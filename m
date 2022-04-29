Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C89514E74
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377994AbiD2O6G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Apr 2022 10:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377984AbiD2O6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:58:05 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8222CBE9C1
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 07:54:45 -0700 (PDT)
Received: from mail-yw1-f178.google.com ([209.85.128.178]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MQuPJ-1nXROm3FoN-00O0gu for <netdev@vger.kernel.org>; Fri, 29 Apr 2022
 16:49:39 +0200
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2f863469afbso63684327b3.0
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 07:49:39 -0700 (PDT)
X-Gm-Message-State: AOAM530DHK7AkLbjbLb1v3BNu5e/k4JC8GjkcXR0jwJ8sP/cYJYJypPw
        hW/XON4nIt2DK9kouVGbGZyMTEdGXcXUIEC5XVY=
X-Google-Smtp-Source: ABdhPJxgBxvE+oN60txD8ANadm+s/87Z28p7WWITHbxMwRgweXeBvfDMsRdHAhLEogMrfIuWNRUzkbwKnsSoR24LqRs=
X-Received: by 2002:a0d:d804:0:b0:2f4:e47d:1c2c with SMTP id
 a4-20020a0dd804000000b002f4e47d1c2cmr37961295ywe.320.1651243778408; Fri, 29
 Apr 2022 07:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com> <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
In-Reply-To: <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 29 Apr 2022 16:49:22 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
Message-ID: <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
Subject: Re: Optimizing kernel compilation / alignments for network performance
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:MZW/Fox5wJoE/+FtF724xGO6UdtdFDf7rzszb/C9wCUDTu/VwwC
 QwdiQdgAHAMKF6wTY3xlKyuo+I07B9r9BqOVMLqaSg9U/thu1796HP80e5wJYXWxKWNBH0e
 JpeXWxmj7eOdiu5IanEpq5viHBSQplE4ywMRmq2uWqgqaVpc+ijlc6LH6PRi9nV2czPigJ7
 ZCkPwW+vg37utb3r10mqg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:VKLrKaiJyzw=:fEm4Gi1yuoBdGd4KjB5c4r
 jvLQK4vteVLBkuVICI9X+l3za13JwDgeG5bxi142aJHyx9jVCjZS2B+sxcPQTjHjRKwClpr0r
 rd6ouS3RD1Q3tPLPMftuKJ4ui3zXjAQbsXbJaQUb2GjPAaju0vYOx+djQmmRNG8R1qepe179u
 n4YXYWxRauoVv3mtu//qDPKA4PfY8jwswVkp0Lg2hpUXX3HegrHZJ6Yg/j7cCHMzeG/6fww9i
 qg5I1q7Xbteb23IIIDXT3wjzdTYMK5xBIUBhDeCiijH+TebcukSiLa7jyVoi8VKrHIgUJu3mH
 1zzzRFMZvH2T2IcYM4xM6ud+XxcErrHsLmDiL1oqAM0D0NmQs2WeCGmzywL3Y196ICeHQyy4b
 CC/7IIiZdDOmV+lp6qEAoJidAQVOzMRpuJt9k9oJI4vxrD2rqxHnmkpi6xK51zNR9Ey70b6Vp
 Wk+OMCD83mekzO5ECt+cLl0cSy3mdQGuIwcAuLB3CoJy2b43fdJEV+oclFLVSa5JCoMp9CHoE
 HOY4xVlz11HsfRlgu+v+z884Z1qd3/YGMa5pkSUYLNIS/84tjC3oXbimJdTJIwQccIjUf2B+4
 1QbPF7SYIEI9DS/IUzl5Icrr/9JA0vojSajHyYb2SRnG2ykAlGezYtur099VPEJ5vKt35ZLd5
 ucx9RGgQo7yLFp9FDTRb6a69Z3q51GSmLkcC53M7QZHCrsYKcoaTLhS/4mHvSweAgwts=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 7:31 PM Rafał Miłecki <zajec5@gmail.com> wrote:
> On 27.04.2022 14:56, Alexander Lobakin wrote:

> Thank you Alexander, this appears to be helpful! I decided to ignore
> CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B for now and just adjust CFLAGS
> manually.
>
>
> 1. Without ce5013ff3bec and with -falign-functions=32
> 387 Mb/s
>
> 2. Without ce5013ff3bec and with -falign-functions=64
> 377 Mb/s
>
> 3. With ce5013ff3bec and with -falign-functions=32
> 384 Mb/s
>
> 4. With ce5013ff3bec and with -falign-functions=64
> 377 Mb/s
>
>
> So it seems that:
> 1. -falign-functions=32 = pretty stable high speed
> 2. -falign-functions=64 = very stable slightly lower speed
>
>
> I'm going to perform tests on more commits but if it stays so reliable
> as above that will be a huge success for me.

Note that the problem may not just be the alignment of a particular
function, but also how different function map into your cache.
The Cortex-A9 has a 4-way set-associative L1 cache of 16KB, 32KB or
64KB, with a line size of 32 bytes. If you are unlucky and you get
five different functions that are frequently called and are a multiple
functions are exactly the wrong spacing that they need more than
four ways, calling them in sequence would always evict the other
ones. The same could of course happen if the problem is the D-cache
or the L2.

Can you try to get a profile using 'perf record' to see where most
time is spent, in both the slowest and the fastest versions?
If the instruction cache is the issue, you should see how the hottest
addresses line up.

        Arnd
