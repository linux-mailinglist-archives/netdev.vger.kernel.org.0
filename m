Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE01737AEDC
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 20:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhEKS4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 14:56:25 -0400
Received: from mout.gmx.net ([212.227.15.18]:53027 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231329AbhEKS4Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 14:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1620759241;
        bh=WENqI3vsyBY6Che+sULK//xoiDEcerYKhusYaYmV+Jo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Wm7uyMFH3ntYOc7siUqnRWJyQKqP/L/GemZ32U41cZtFpWvRPGw8LRUeA5Wc8VxGv
         3lshu0OpGSbCZPFkc/z39jHh6HxlNPAyP64coKYwkRUqUwObUdhdz4GzqgVuo7XDYn
         Wq/zbHxl2T5QmIu9gnRtj6TSO4gUOC64b9OA36ps=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.149.187] ([217.61.149.187]) by web-mail.gmx.net
 (3c-app-gmx-bs62.server.lan [172.19.170.146]) (via HTTP); Tue, 11 May 2021
 20:54:01 +0200
MIME-Version: 1.0
Message-ID: <trinity-da507ec7-f0ec-4d64-b7fe-1c9d13dbead8-1620759241263@3c-app-gmx-bs62>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        peterz@infradead.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Peter Enderborg <peter.enderborg@sony.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Vitor Massaru Iha <vitor@massaru.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Di Zhu <zhudi21@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upsream@mediatek.com,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Aw: [PATCH][v2] rtnetlink: add rtnl_lock debug log
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 11 May 2021 20:54:01 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210508085738.6296-1-rocco.yue@mediatek.com>
References: <20210508085738.6296-1-rocco.yue@mediatek.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:vPtDeKS2EkjkBFhCI0MTeN8+oyPoFuj1CethO+QBiXE32fotLiQj3aR78hUsvSvNgQveJ
 5Vk3+k2e4Uy1jjeU113UmzFfxe+2rx6KN6XBpfqCkB2aytuVjsjTTNga6VErcNnELg1CQ2tSCdxH
 KGima4m2jsQu8qxpK4/EClBBlbyipfhQlCqZqJZ1wiC4nsYcoR2rZ+Y3X4csKHww9z/Q7kG7msZl
 T3OO17Vc+cXzSxBTGrm5dXMILZmPRsj0mJqFWC7z7z5sxY/vnfv7M/HLGOMmHmCGX8BIeSS07Khc
 kk=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1dioUG1R8SQ=:hob++s0902VF7y5u+td1EZ
 sw+23yXRodDzF2z2T9xOFfVMS99mkk5kUjw2ux8ozYAMOs35z8M39epNx9J9VbRKRIaPSP9vE
 odEAjxv3m3HwWC4kCwBcweqwGrGMhevXTKfYJeZrORadT8yGabxSWTM8j39w44vc2UwEkukyo
 H96t6aPJsl4kOfyq1PoEIxCvcGZTjSNCWzg1dj9MJNP78FeKEoWsGRDDhd4KwTWpaCsrVSwhJ
 T45wYSxgtSphuJBiTny7xFz58TAVkVcyBb4ZPUuliO2Q0Hpg4UvS0b6XNWN6mDlru/DLH0oQ9
 nJgYOdNPc9Xl3bid/u8tmw191g2TASRi/iCiH78pnSu122f2/hpH4Ner3NVE7szdKNSNlnUAJ
 tBqMWemXG/dJ/Zsrg79lE1DWpmsUIuVnAyqtFZBBC0yIq7AxFL5m16U0eOt8PDJ1UsB1q03mA
 +VFI1Y4zUPixCP36Y34vWP05m3m7cmuXpbgn2bh4vOdO/4xoY2zljqRQg1+d24vUYO0tHll4c
 inj4eEY/7E593OGi1YF4Wf7cZnhahAwixwIeBmvVOSHYOxfHhTuGlzwxvdPop34zOQVlgBnA9
 2QW/ulESpmSg7iWOh36butorJGlClRm5XJjFEV7lufqTVugy4dcwjiKDQfVjufsb0Xj2XAON+
 K7XRKw0c1JzvvVwkVnHlHQLzWoAuc+leU341ft5AP5WxSqfpUUl9Lm1chzvxRLNnetxCZSiV2
 atf9H7D7tKjZ6JI8A0rXoN82Go9vyMk3Cv0v+re3DZLE/GgkGi20226pN5vErMKK2qBjWTwzL
 50PtqGKn12cVKtHlXt2X3mnUh2/FoYcdxDEbH0ZENbKng+A4Vjvy1ziAyBPrEmZVESV68p4L7
 BTPds5r/9pUmA3Lkbkv8lX3Zk/ViQ6+d7DuVRHwibja2JdicGhxrf8YiJLrrTOM0Nz11lvDk8
 sJqwim7iQ0w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Samstag, 08. Mai 2021 um 10:57 Uhr
> Von: "Rocco Yue" <rocco.yue@mediatek.com>
> Betreff: [PATCH][v2] rtnetlink: add rtnl_lock debug log

> <6>[   40.191481][    C6] rtnetlink: -- rtnl_print_btrace start --
> <6>[   40.191494][    C6] rtnetlink: RfxSender_4[2206][R] hold rtnl_lock
> more than 2 sec, start time: 38181400013
it would be good to have same time-format (seconds.nanosec)

> <6>[   42.181879][ T2206] rtnetlink: rtnl_lock is held by [2206] from
> [38181400013] to [42181875177]
same as above

> +static void rtnl_relase_btrace(void)
should this be release_btrace?

regards Frank
