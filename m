Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A082A5CCE
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 03:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgKDCqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 21:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729745AbgKDCqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 21:46:03 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B27C061A4D;
        Tue,  3 Nov 2020 18:46:03 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c20so16066633pfr.8;
        Tue, 03 Nov 2020 18:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fCseORm8piqN3TMrPGDC4s2T4rVlCep+V6+qtT2saPM=;
        b=okOE8tPl2W8NhDkWXv6XYf4211bs9BMQXnFafVYSEzZkRto5/aVggY51p6c4ihOkun
         m+zmQlZJ5ocqEaFBW9o1vF8voQg1WEnSCnUTCdjroMzIkqkfAmHEdz7Up2HCXtmZ7cqb
         zaiC99o1pyJIPwdMYc9TUBTgxLLDsp5/kXS18fH20YjY6EbVhuMS7IkfvwG08iAfdWWf
         Nc2ZE4niJlb0+5tWAbLGwnOaN3H64u4A1A1VoONwmZwUe9UvIhwKqeQS8fi9UBKuP7wY
         jCOVbVO2JdAVKOrPRj0NEEknM7vMYBxeXOvYkaF7oQicUAGaqMEiU8HqZsRAVxD36vYO
         Ldeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fCseORm8piqN3TMrPGDC4s2T4rVlCep+V6+qtT2saPM=;
        b=gu0SKt+WHut7BkMfcotHdmAX22oqi4/q4h4LHVIjGtiSVRB5JSxpDYoOv/oKSE+VWK
         lAxuIWcJbLJ4nhUTdHYViyyUdazQLq/wqH6w4L2JEuVCyOIaaEnr4NscqSrjmtQMEAkC
         h8rlPENQ4qU0dMEaj8CNlDCBqw5J2WHWRqfP6iCw7Eqnl55nBc0EUDg1LfGcRM5hKnxO
         Knz2U+5gJorjT20RLHdCdB6/4QMDuRjV85jInZnh6klUTin+J74gK+6lWyTSJN/jHglX
         dksBwv/5+6ZfzholjF0sVWn7fDXAuqmWUU8J0hXEKP21rVIQHTf4f8QOjXmOcNnxMo4I
         snNA==
X-Gm-Message-State: AOAM531MsEblwHhxcHvumlfZZgDEdfWENfOvDfoCTOMQ7BLTJykwjlN/
        ZoXdLCxAXJ25TYK2yjHRGiw=
X-Google-Smtp-Source: ABdhPJzXBlQCM8qE6ISwW2vbHqtMBbzvjqs1MeWPJCA5EmEiRZ5XYMpIgHo7SuSzHf4cA2F060yaqw==
X-Received: by 2002:a17:90b:1413:: with SMTP id jo19mr2175280pjb.221.1604457963334;
        Tue, 03 Nov 2020 18:46:03 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4055])
        by smtp.gmail.com with ESMTPSA id 136sm473827pfb.152.2020.11.03.18.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 18:46:02 -0800 (PST)
Date:   Tue, 3 Nov 2020 18:45:59 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201104024559.gxullc7e6boaupuk@ast-mbp.dhcp.thefacebook.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <ce441cb4-0e36-eae6-ca19-efebb6fb55f1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce441cb4-0e36-eae6-ca19-efebb6fb55f1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 06:40:44PM -0700, David Ahern wrote:
> On 11/3/20 3:55 PM, Alexei Starovoitov wrote:
> > The bpf support in "tc" command instead of being obviously old and obsolete
> > will be sort-of working with unpredictable delay between released kernel
> > and released iproute2 version. The iproute2 release that suppose to match kernel
> > release will be meaningless.
> 
> iproute2, like all userspace commands, is written to an API and for well
> written APIs the commands should be backward and forward compatible
> across kernel versions. Kernel upgrades do not force an update of the
> entire ecosystem. New userspace on old kernels should again just work.
> New functionality in the new userpsace will not, but detection of that
> is a different problem and relies on kernel APIs doing proper data
> validation.

commands ?!
libbpf is not a library that translates user input into kernel syscalls.
It's not libmnl that is a wrapper for netlink.
It's not libelf either.
libbpf probes kernel features and does different things depending on what it found.
libbpf is the only library I know that is backward and forward compatible.
All other libraries are backwards compatible only.
iproute2 itself is backward compatible only as well.
New devlink feature in iproute2 won't do anything on the kernel that doesn't
have the support.
libbpf, on the other side, has to work on older kernels. New libbpf features
have to gradually degrade when possible.
The users can upgrade and downgrade libbpf version at any time.
They can upgrade and downgrade kernel while keeping libbpf version the same.
The users can upgrade llvm as well and libbpf has to expect unexpected
and deal with all combinations.

> 
> > More so, the upgrade of shared libbpf.so can make older iproute2/tc to do 
> > something new and unpredictable.
> 
> How so? If libbpf is written against kernel APIs and properly versioned,
> it should just work. A new version of libbpf changes the .so version, so
> old commands will not load it.

Please point out where do you see this happening in the patch set.
See tools/lib/bpf/README.rst to understand the versioning.
