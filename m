Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B68633E271
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhCPXzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhCPXyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 19:54:50 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59620C06174A;
        Tue, 16 Mar 2021 16:54:50 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id t23-20020a0568301e37b02901b65ab30024so146325otr.4;
        Tue, 16 Mar 2021 16:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cetp4E84Jn2JBGw6pg9+/mZwA46pxyy3Q78ITWNFMFw=;
        b=QzvfgoNxgjNFa51rF5li6QYAIMhyzZ2lNKrWXMivQSXjsu7IpiEwThvyDGcyNJvJpz
         jeTo/Ohe+rG0UQpM55TFH6P6m4oko7lRYPJ6pZm/EoNf7NvQfboX26IYAMW+apTKwiIT
         zk4iX5GXR6aeULYQ+lCCS1Fd2JrIxHGKorT2K8pHQ5ISAkexEpJvZb9F3cImp3tzrfqU
         zhO6vjqn80Cnq0bTUSjd9EiIsWcFlew77YuvkHJ1QF20mQFIBrZ/B/Z1+n2PoAUcWf/j
         zWdwtVbmqzPFb6zxmwe7+rQGo2H2rf4sZ0WJmaeKpJ8GEJNpgtE6L89H5HMnM+GOsaWy
         M7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Cetp4E84Jn2JBGw6pg9+/mZwA46pxyy3Q78ITWNFMFw=;
        b=BG47rmXz81pAq71CQdIuLLIWesS4y4+fjK0VQldveT4tMBshqQNpi+GyK5L2AR2igz
         eqx6Gh0mwvavDmjqQWVFwJzJ/1cO6N3m3qsPON/UltRSiK9TH8JuXbg3d/Dv+s8B8551
         Elca6FmF726sFi3TcHnCVfbopVzeKbVZevt7JZTeA4Zzm1McgBFliETHQzvd+kyU7hud
         dkq253s8WiRawA1DL4uTwHf+IcYYTBuV+68Ku/8i+waTHNtIkli4qgJGbWBL5C3ad3od
         A2yuAU14bjGKRQKJgDWP7p14ehGr67rY2QbFD7EvCmvTGpRXaOHSBeEnufUq0PmNZoVl
         utBA==
X-Gm-Message-State: AOAM530HkwvYEm+yKqXk+SqcI5uz1G5wvB6QqqqVPiFtklPwfoiQX1et
        /NXQRNgtczZwx+UxCcw2UTO93fOdvgg=
X-Google-Smtp-Source: ABdhPJwJk97jvdYOqoEcXSv0sYMtD5yt+buwSl/bxqx6CXTKJ75XjsU7qy1NqRES8wEfeea2/Aln0w==
X-Received: by 2002:a9d:20c3:: with SMTP id x61mr1016640ota.311.1615938888723;
        Tue, 16 Mar 2021 16:54:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t19sm8371923otm.40.2021.03.16.16.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 16:54:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "dong.menglong@zte.com.cn" <dong.menglong@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
 <20210316224820.GA225411@roeck-us.net>
 <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <3e744033-d73b-8bec-5117-4b85fa127351@roeck-us.net>
Date:   Tue, 16 Mar 2021 16:54:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/21 4:02 PM, Andy Shevchenko wrote:
> 
> 
> On Wednesday, March 17, 2021, Guenter Roeck <linux@roeck-us.net <mailto:linux@roeck-us.net>> wrote:
> 
>     Hi,
> 
>     On Tue, Mar 09, 2021 at 05:51:35PM -0800, menglong8.dong@gmail.com <mailto:menglong8.dong@gmail.com> wrote:
>     > From: Menglong Dong <dong.menglong@zte.com.cn <mailto:dong.menglong@zte.com.cn>>
>     >
>     > The bit mask for MSG_* seems a little confused here. Replace it
>     > with BIT() to make it clear to understand.
>     >
>     > Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn <mailto:dong.menglong@zte.com.cn>>
> 
>     I must admit that I am a bit puzzled,
> 
> 
> I have checked the values and don’t see a problem. So, the only difference is the type int vs. unsigned long. I think this simply reveals an issue somewhere in the code.
>  

I am currently trying to "bisect" the individual bits. We'll see if I can find
the culprit(s).

Guenter

> 
> 
>      but with this patch in the tree
>     (in next-20210316) several of my qemu network interface tests fail
>     to get an IP address. So far I have only seen this with mips64
>     tests, but that may be because I only started running those tests
>     on various architectures.
> 
>     The tests do nothing special: With CONFIG_IP_PNP_DHCP=n, run udhcpc
>     in qemu to get an IP address. With this patch in place, udhcpc fails.
>     With this patch reverted, udhcpc gets the IP address as expected.
>     The error reported by udhcpc is:
> 
>     udhcpc: sending discover
>     udhcpc: read error: Invalid argument, reopening socket
> 
>     Reverting this patch fixes the problem.
> 
>     Guenter
> 
>     ---
>     bisect log:
> 
>     # bad: [0f4b0bb396f6f424a7b074d00cb71f5966edcb8a] Add linux-next specific files for 20210316
>     # good: [1e28eed17697bcf343c6743f0028cc3b5dd88bf0] Linux 5.12-rc3
>     git bisect start 'HEAD' 'v5.12-rc3'
>     # bad: [edd84c42baeffe66740143a04f24588fded94241] Merge remote-tracking branch 'drm-misc/for-linux-next'
>     git bisect bad edd84c42baeffe66740143a04f24588fded94241
>     # good: [a76f62d56da82bee1a4c35dd6375a8fdd57eca4e] Merge remote-tracking branch 'cel/for-next'
>     git bisect good a76f62d56da82bee1a4c35dd6375a8fdd57eca4e
>     # good: [e2924c67bae0cc15ca64dbe1ed791c96eed6d149] Merge remote-tracking branch 'rdma/for-next'
>     git bisect good e2924c67bae0cc15ca64dbe1ed791c96eed6d149
>     # bad: [a8f9952d218d816ff1a13c9385edd821a8da527d] selftests: fib_nexthops: List each test case in a different line
>     git bisect bad a8f9952d218d816ff1a13c9385edd821a8da527d
>     # bad: [4734a750f4674631ab9896189810b57700597aa7] mlxsw: Adjust some MFDE fields shift and size to fw implementation
>     git bisect bad 4734a750f4674631ab9896189810b57700597aa7
>     # good: [32e76b187a90de5809d68c2ef3e3964176dacaf0] bpf: Document BPF_PROG_ATTACH syscall command
>     git bisect good 32e76b187a90de5809d68c2ef3e3964176dacaf0
>     # good: [ee75aef23afe6e88497151c127c13ed69f41aaa2] bpf, xdp: Restructure redirect actions
>     git bisect good ee75aef23afe6e88497151c127c13ed69f41aaa2
>     # bad: [90d181ca488f466904ea59dd5c836f766b69c71b] net: rose: Fix fall-through warnings for Clang
>     git bisect bad 90d181ca488f466904ea59dd5c836f766b69c71b
>     # bad: [537a0c5c4218329990dc8973068f3bfe5c882623] net: fddi: skfp: smt: Replace one-element array with flexible-array member
>     git bisect bad 537a0c5c4218329990dc8973068f3bfe5c882623
>     # bad: [97c2c69e1926260c78c7f1c0b2c987934f1dc7a1] virtio-net: support XDP when not more queues
>     git bisect bad 97c2c69e1926260c78c7f1c0b2c987934f1dc7a1
>     # good: [c1acda9807e2bbe1d2026b44f37d959d6d8266c8] Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next <http://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next>
>     git bisect good c1acda9807e2bbe1d2026b44f37d959d6d8266c8
>     # bad: [0bb3262c0248d44aea3be31076f44beb82a7b120] net: socket: use BIT() for MSG_*
>     git bisect bad 0bb3262c0248d44aea3be31076f44beb82a7b120
>     # first bad commit: [0bb3262c0248d44aea3be31076f44beb82a7b120] net: socket: use BIT() for MSG_*
> 
> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 
> 

