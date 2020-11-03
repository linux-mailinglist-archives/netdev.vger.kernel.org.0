Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF942A5A5A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbgKCWz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729078AbgKCWz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:55:59 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006A7C0613D1;
        Tue,  3 Nov 2020 14:55:58 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 13so15638084pfy.4;
        Tue, 03 Nov 2020 14:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y9rC6CEfjXUJcDEVAQhothgdJOVJi8hJqCH+5bsgPRw=;
        b=AJMV1wRc1HYlzxcS1TwbAy1floVfKkjV19NaJpPgn0NnRlarLq30PirhQreB26tUns
         IZokwT8vHV92wTZbw1oW0lc68tLzSrz6hY1CmRaD+QeLDRNX9BhnfpPwbxjNhPsbBS9A
         OPmfQ9dl1FNe5LVo/xXqQQuMOReC0h9c0RzuPfSawBKa1fri4mZjlPWqPgM8Kwg/bJ0U
         Z4m3febUHBLaKMgI8B/GPxEhjzwOHb7SWo6sw/GFi+20/k42TpNG5Ly8lR1fCKn6kSc3
         SNeWHz6v7XjTHXF2ozbeiu24iza5GeMKRAOMjQM3BD0q+KmyBMnfVJjq6QuTTyUDm6DX
         0LVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y9rC6CEfjXUJcDEVAQhothgdJOVJi8hJqCH+5bsgPRw=;
        b=QGJ5P/9wBFTpqxbExMqUTtqsWHWCNVCjKMWfQqcgpK1aqiqXP5kc2bo/C2RksZstji
         V9NDtBTKoJnbBebkFvyCOwKinf9RTJIdCBjhcX9VEKMidTnGa9/7SQSPUugcJ/pHqmzv
         mVha72UX3rn00tXySfBV53XefhOVSki3Pu9UU76J+LaahJMjW7GdIkMirhNIUmBja7gS
         BgnSgfccbj6ujFW8P/t5GrGNpUs8WUkMEQ8bhIGx07dA0P6GEHcup1sbqaOtsy60M6SN
         rec5yC/NIoelZxzOCW/V3dOtn+5KHCQRPw9OF3YdSdGzpKUlywEtcyt3MOAbVivvLR4a
         aXqg==
X-Gm-Message-State: AOAM532rpolGPlxWd/mRAl+QOYOR0bGxDCz8wf5rM6cy8kMMZQDKPfGD
        Fi0SeUuLTnaYJw9NnQUCixw=
X-Google-Smtp-Source: ABdhPJz7uT/tDSxLDYzNQd/1ObDCzWHxki/itiK3jD2YN34gVKavsMGrPzkuZUEpon7LUBP7P05CIA==
X-Received: by 2002:a63:ab07:: with SMTP id p7mr18791206pgf.326.1604444158346;
        Tue, 03 Nov 2020 14:55:58 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4055])
        by smtp.gmail.com with ESMTPSA id 63sm161820pfv.25.2020.11.03.14.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 14:55:57 -0800 (PST)
Date:   Tue, 3 Nov 2020 14:55:54 -0800
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
Message-ID: <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 03:32:55PM -0700, David Ahern wrote:
> On 11/3/20 10:47 AM, Alexei Starovoitov wrote:
> > since David is deaf to technical arguments,
> It is not that I am "deaf to technical arguments"; you do not like my
> response.
> 
> The scope of bpf in iproute2 is tiny - a few tc modules (and VRF but it
> does not need libbpf) which is a small subset of the functionality and
> commands within the package.

When Hangbin sent this patch set I got excited that finally tc command
will start working with the latest bpf elf files.
Currently "tc" supports 4 year old files which caused plenty of pain to bpf users.
I got excited, but now I've realized that this patch set will make it worse.
The bpf support in "tc" command instead of being obviously old and obsolete
will be sort-of working with unpredictable delay between released kernel
and released iproute2 version. The iproute2 release that suppose to match kernel
release will be meaningless.
More so, the upgrade of shared libbpf.so can make older iproute2/tc to do 
something new and unpredictable.
The user experience will be awful. Not only the users won't know
what to expect out of 'tc' command they won't have a way to debug it.
All of it because iproute2 build will take system libbpf and link it
as shared library by default.
So I think iproute2 must not use libbpf. If I could remove bpf support
from iproute2 I would do so as well.
The current state of iproute2 is hurting bpf ecosystem and proposed
libbpf+iproute2 integration will make it worse.
