Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64814861CB
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiAFJEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiAFJEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 04:04:11 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FFAC061245;
        Thu,  6 Jan 2022 01:04:11 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c2so2009019pfc.1;
        Thu, 06 Jan 2022 01:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xSSoYa3Oh5uJWtwI1Z8ymCv2YQrKvjhDxgIsNPINZuE=;
        b=oO7ezoyhjSV72us8z/bLxc1YLcDYAIyMpQqn6lC4mSQkqfJFDDFg7SopCSCWAHcW0z
         m9DS0HZ38CsiHLP5vXaZrBpCpdTdU3l1qYkJFIxXHIMDAA453jB3HL3brHJGHdJ+suiT
         Wv+uOQC9oBIclXDSXiDAOvAMQAPKSlOYyTRrHofEXkoqTT63EPRinBnY6NPLNYDWhTau
         DQiA0vepc214e1BnzbfNPdeTTfhLvWsd9mxv/8smhX+Zl3axUFlMr47p3TR1UH+rfBIL
         fkOC9HdcxoxaAixj8TSIe/OCYxg9sZ2RyDbYdBzwMNJ0c1XdPBJuUM8ZZcZ5b3Fnnof9
         iitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xSSoYa3Oh5uJWtwI1Z8ymCv2YQrKvjhDxgIsNPINZuE=;
        b=BmTEqXE5mkTAoJPq6c4VP3LT8hUweM+03wzA9hbovbp8kx5KtWTdBbGSrhHUyZ+wav
         05/5+260K2Sh813Mq2BdG8tmenPt5CkFQtsB7+n4WgeQk9lxreN9DDVLh1YQF1pe2zl1
         4VD4566QmDIydNXszpYLSCR1ahPZFVYzcxwnpBOZ/cjJmbvZ3ppOFihmCV+OBxmKvIH2
         i2a/458G7Zep23aSpDu3Ghehu22NhmUfNolVYIQFy6UEjA/qmBKn3fltZzILucvwMz2U
         wpj4pXKmJ28xRC0+2EoJJybuqD7/w0cM335+1yhNKnbyP33jWUsmYiY/lQDiCRSCXoGs
         WAbg==
X-Gm-Message-State: AOAM532u8y+6TZ6dawmJ6ffLgipD+0nozGQKYRBuzFQcIsa58e1b3vVX
        moH45dMXOnfXbqnk3cCsovZPmqnd7LQ=
X-Google-Smtp-Source: ABdhPJyP2x8XCIgRK0rHBg0d8z1S+0k0lUMQfGBmrTLq3LZnKv8ER61R9/iHsXj6WOO3sKqoJsU5FA==
X-Received: by 2002:a63:381d:: with SMTP id f29mr52599558pga.162.1641459850913;
        Thu, 06 Jan 2022 01:04:10 -0800 (PST)
Received: from localhost ([103.4.221.252])
        by smtp.gmail.com with ESMTPSA id j1sm1759183pfc.49.2022.01.06.01.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 01:04:10 -0800 (PST)
Date:   Thu, 6 Jan 2022 14:34:00 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v6 11/11] selftests/bpf: Add test for race in
 btf_try_get_module
Message-ID: <20220106090400.6p34bempgv2wzocj@apollo.legion>
References: <20220102162115.1506833-1-memxor@gmail.com>
 <20220102162115.1506833-12-memxor@gmail.com>
 <20220105062033.lufu57xhpyou3sie@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105062033.lufu57xhpyou3sie@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:50:33AM IST, Alexei Starovoitov wrote:
> On Sun, Jan 02, 2022 at 09:51:15PM +0530, Kumar Kartikeya Dwivedi wrote:
> > This adds a complete test case to ensure we never take references to
> > modules not in MODULE_STATE_LIVE, which can lead to UAF, and it also
> > ensures we never access btf->kfunc_set_tab in an inconsistent state.
> >
> > The test uses userfaultfd to artifically widen the race.
>
> Fancy!
> Does it have to use a different module?
> Can it be part of bpf_testmod somehow?

I was thinking of doing it with bpf_testmod, but then I realised it would be a
problem with parallel mode of test_progs, where another selftest in parallel may
rely on bpf_testmod (which this test would unload, load and make it fault, and
then fail the load before restoring it by loading again), so I went with
bpf_testmod.

Maybe we can hardcode a list of tests to be executed serially in --workers=n > 1
mode? All serial tests are then executed in the beginning (or end), and then it
starts invoking others in parallel as usual.

--
Kartikeya
