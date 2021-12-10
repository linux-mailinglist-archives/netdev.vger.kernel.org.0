Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DD746FD5F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239047AbhLJJKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbhLJJKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:10:00 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C0AC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:06:25 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id 30so15548642uag.13
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9tGFC4LzWqCgm0WZvcBZCqbYx5+hs05WaoMGVHtCwSQ=;
        b=dzpOCEItnevmnc8O0NJ2fSw3n6TQ92XxO7pp66r2wpqtT5lx1yKL302TGJBZ+fRHur
         wrIK+V1zGgd2tRlm6qJgkI4PG417GtmPOwMQYTBT4kxCpHfZtsmIZkund8StmOt6DbLw
         gkl0/0hO55nO4rj6kPf/26O5z/2FSwjBNz47wBZ+79mv8fJ9lTNFFMQd9ZUKxB0MbvY8
         1dz5TJo0RllEyA0kSN82ISIyHcOnjYgfsDxTaeVdGSDAuPDD88B+tg8p4wnAXytE6bkX
         Dl2YXCnWW0EwEJExzaZIIZ5FOngJEg32AH2WWgogRr0Jk2NXNNu77PAOSNOfU3oHEGhE
         JPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9tGFC4LzWqCgm0WZvcBZCqbYx5+hs05WaoMGVHtCwSQ=;
        b=iDcv4Qa302VRKqcX/5oqu+JrMcTMWkJ9eZRL5u5+1Zzg/v9H7YxI76AgK0mXKAJSAA
         NivPyw016NwTjYHrPLWFSAkr/Za15+45wseU3yiNJtas5tJdX7Jni6cuIfQKtf1j8fd2
         s8k3vCrGPQV3yHfmn3FAdYN8NS4yCrAJuAFqtMrbEFE6UoNWrnBORisLpe5R3V/3nbT4
         fwZq0TB4NAPOShKaIM1rOuOKTL9t9wlgjCy1MV91vWxlX8+YOEGo/fmx4vOPtkZPVrxZ
         bLQ+1IPkLkUNEWQ0l7ehsKoHWq/77hqBIP1mVGxO6npSN5AE8cyZF5iH+pv0TZ7yeg+L
         WydA==
X-Gm-Message-State: AOAM532jjQfNxKMHXKxBdyG1SzRE/YeTx0TjFb53G9U4XaHKqIJTFvaO
        viaqw6M9vM1QD6rDQZbTJrgDDVDEzgTI9DhqEws=
X-Google-Smtp-Source: ABdhPJwrzX4R908X787m5pCkNfhqt1pa0auQvUb6jSQ5RECJlas/hTNiNuMIw0lJZP+KkheO/qddaS1r4cuYm+MR/EA=
X-Received: by 2002:a05:6102:38ce:: with SMTP id k14mr14134171vst.70.1639127185051;
 Fri, 10 Dec 2021 01:06:25 -0800 (PST)
MIME-Version: 1.0
References: <CALW65jbKsDGTXghqQFQe2CxYbWPakkaeFrr+3vAA4gAPjeeL2w@mail.gmail.com>
In-Reply-To: <CALW65jbKsDGTXghqQFQe2CxYbWPakkaeFrr+3vAA4gAPjeeL2w@mail.gmail.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Fri, 10 Dec 2021 10:06:14 +0100
Message-ID: <CAMhs-H9ve2VtLm8x__DEb0_CpoYsqix1HwLDcZ8_ZeEK9vdfQg@mail.gmail.com>
Subject: Re: MT7621 ethernet does not get probed on net-next branch after 5.15 merge
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qingfang,

On Fri, Oct 15, 2021 at 4:23 PM DENG Qingfang <dqfext@gmail.com> wrote:
>
> Hi,
>
> After the merge of 5.15.y into net-next, MT7621 ethernet
> (mtk_eth_soc.c) does not get probed at all.
>
> Kernel log before 5.15 merge:
> ...
> libphy: Fixed MDIO Bus: probed
> libphy: mdio: probed
> mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
> mtk_soc_eth 1e100000.ethernet eth0: mediatek frame engine at 0xbe100000, irq 20
> mt7621-pci 1e140000.pcie: host bridge /pcie@1e140000 ranges:
> ...
>
> Kernel log after 5.15 merge:
> ...
> libphy: Fixed MDIO Bus: probed
> mt7621-pci 1e140000.pcie: host bridge /pcie@1e140000 ranges:
> ...
>
>
> I tried adding debug prints into the .mtk_probe function, but it did
> not execute.
> There are no dts changes for MT7621 between 5.14 and 5.15, so I
> believe it should be something else.
>
> Any ideas?

I had time to create a new image for my gnubee board using kernel 5.15
and this problem does not exist on my side. Since no more mails have
come for a while I guess this was a problem from your configuration,
but just in case I preferred to answer to let you know. I am currently
using v5.15.7 from linux-stable with some other patches that will be
for 5.16. Just in case, you can check the kernel tree [0] I am
currently using.

Best regards,
     Sergio Paracuellos

[0]: https://github.com/paraka/linux/tree/gbpc1-5.15
