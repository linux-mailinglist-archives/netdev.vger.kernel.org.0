Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540C933E1A7
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCPWsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhCPWsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 18:48:23 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A57CC06174A;
        Tue, 16 Mar 2021 15:48:23 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id n12-20020a4ad12c0000b02901b63e7bc1b4so95471oor.5;
        Tue, 16 Mar 2021 15:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4VNJlBIK/l0B0rflIt/JsjIA9MOMykQTfYi1HuYhLA8=;
        b=iG2YDGRfB597kTnHnMbN29C4gT2F1h8RoDzubDX4dxcznvffc0kH7DrG+OkjJpyhmD
         2m8xvE12peVACEyM0hVuKTjjEmCfhjiCweBcUQ8N8+buGLTfVIK/+4itRKGbDqo7kHtQ
         s75ZtVBZ2FHJ22J0Tx3xXqWMYx0O/ySNyF4NpiXzkJwdByaZZK2PEg27XZW9lnFRuQDj
         U65Y2NAnfte9BS+BE1lWEHml9bU0VdfoMy61/7VjloJc05bKVO6CKwaz2KQsc+Be8LOs
         VI/d7z536vyp7pzQCxQVI+GCJLMVKVkXdYyI0qtzFFHtmTsRWD7oIrVVU/afTJ3UxpH1
         W4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4VNJlBIK/l0B0rflIt/JsjIA9MOMykQTfYi1HuYhLA8=;
        b=jLvbU8lkfsv21/6tKuXZP0rEjrFpWZqNvMJ1iTonzfoQZb+qtcoTjV94idx4nXmh5c
         UCpd18dJ2GaJwdQ4oZOqcTERwjIMWZTSNzeDYdTTyQKiTlWgFxQSfYwziTt+yXq1woED
         yYkC1DiCdMSfJhInxGL6oq95haBoZjk+WpmU3LfB/Vg/NMHJu2njGo5Roqq3cdrsy4ji
         4avcy3or0VmtZDRAsMZgjCPTHiKBZD8ihC3167Ue8elMC+7UZxoehjAaAiQ1csf4ODY1
         /Iml9VEcaNir4kHn0TY1yXJzI4v3WLYlAHQKMr1oHGlFzhlaFPrfhImnLZ8bGtGLG7B3
         FR3g==
X-Gm-Message-State: AOAM533d61mGPi5f4xbf+4XGyHNhsC2UM9+SDDYZyX4+EM6MZ1591naN
        NjAeTrJC4s+HXYS3JSHh//g=
X-Google-Smtp-Source: ABdhPJw2GgDs72UdZk6pZKiwD6jh6dvmDWOtt/Haf/45deMiok54N12Z+QXLpDUeaGrMp1Fwt/LwBw==
X-Received: by 2002:a4a:be86:: with SMTP id o6mr845981oop.70.1615934902474;
        Tue, 16 Mar 2021 15:48:22 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v9sm7969756oon.11.2021.03.16.15.48.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Mar 2021 15:48:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Mar 2021 15:48:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, andy.shevchenko@gmail.com, davem@davemloft.net,
        axboe@kernel.dk, viro@zeniv.linux.org.uk,
        herbert@gondor.apana.org.au, dong.menglong@zte.com.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
Message-ID: <20210316224820.GA225411@roeck-us.net>
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310015135.293794-1-dong.menglong@zte.com.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Mar 09, 2021 at 05:51:35PM -0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> The bit mask for MSG_* seems a little confused here. Replace it
> with BIT() to make it clear to understand.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

I must admit that I am a bit puzzled, but with this patch in the tree
(in next-20210316) several of my qemu network interface tests fail
to get an IP address. So far I have only seen this with mips64
tests, but that may be because I only started running those tests
on various architectures.

The tests do nothing special: With CONFIG_IP_PNP_DHCP=n, run udhcpc
in qemu to get an IP address. With this patch in place, udhcpc fails.
With this patch reverted, udhcpc gets the IP address as expected.
The error reported by udhcpc is:

udhcpc: sending discover
udhcpc: read error: Invalid argument, reopening socket

Reverting this patch fixes the problem.

Guenter

---
bisect log:

# bad: [0f4b0bb396f6f424a7b074d00cb71f5966edcb8a] Add linux-next specific files for 20210316
# good: [1e28eed17697bcf343c6743f0028cc3b5dd88bf0] Linux 5.12-rc3
git bisect start 'HEAD' 'v5.12-rc3'
# bad: [edd84c42baeffe66740143a04f24588fded94241] Merge remote-tracking branch 'drm-misc/for-linux-next'
git bisect bad edd84c42baeffe66740143a04f24588fded94241
# good: [a76f62d56da82bee1a4c35dd6375a8fdd57eca4e] Merge remote-tracking branch 'cel/for-next'
git bisect good a76f62d56da82bee1a4c35dd6375a8fdd57eca4e
# good: [e2924c67bae0cc15ca64dbe1ed791c96eed6d149] Merge remote-tracking branch 'rdma/for-next'
git bisect good e2924c67bae0cc15ca64dbe1ed791c96eed6d149
# bad: [a8f9952d218d816ff1a13c9385edd821a8da527d] selftests: fib_nexthops: List each test case in a different line
git bisect bad a8f9952d218d816ff1a13c9385edd821a8da527d
# bad: [4734a750f4674631ab9896189810b57700597aa7] mlxsw: Adjust some MFDE fields shift and size to fw implementation
git bisect bad 4734a750f4674631ab9896189810b57700597aa7
# good: [32e76b187a90de5809d68c2ef3e3964176dacaf0] bpf: Document BPF_PROG_ATTACH syscall command
git bisect good 32e76b187a90de5809d68c2ef3e3964176dacaf0
# good: [ee75aef23afe6e88497151c127c13ed69f41aaa2] bpf, xdp: Restructure redirect actions
git bisect good ee75aef23afe6e88497151c127c13ed69f41aaa2
# bad: [90d181ca488f466904ea59dd5c836f766b69c71b] net: rose: Fix fall-through warnings for Clang
git bisect bad 90d181ca488f466904ea59dd5c836f766b69c71b
# bad: [537a0c5c4218329990dc8973068f3bfe5c882623] net: fddi: skfp: smt: Replace one-element array with flexible-array member
git bisect bad 537a0c5c4218329990dc8973068f3bfe5c882623
# bad: [97c2c69e1926260c78c7f1c0b2c987934f1dc7a1] virtio-net: support XDP when not more queues
git bisect bad 97c2c69e1926260c78c7f1c0b2c987934f1dc7a1
# good: [c1acda9807e2bbe1d2026b44f37d959d6d8266c8] Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
git bisect good c1acda9807e2bbe1d2026b44f37d959d6d8266c8
# bad: [0bb3262c0248d44aea3be31076f44beb82a7b120] net: socket: use BIT() for MSG_*
git bisect bad 0bb3262c0248d44aea3be31076f44beb82a7b120
# first bad commit: [0bb3262c0248d44aea3be31076f44beb82a7b120] net: socket: use BIT() for MSG_*
