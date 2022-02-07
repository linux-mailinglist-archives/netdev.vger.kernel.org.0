Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A874AB989
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 12:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350767AbiBGLGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 06:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352922AbiBGK47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:56:59 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E9FC043181
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 02:56:58 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso14109008wmj.2
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 02:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=references:user-agent:from:to:subject:date:in-reply-to:message-id
         :mime-version;
        bh=gCbLAdNfo6DzwKZZhiI2gvYSp0E58X2J6K8BZ7WMiCw=;
        b=HdVq6PkDWV64cO4Meh1wk8wgo8CdzN+zPTFC2pB2FI0bwgSi81Z/HYG5aXK5pBx5W9
         CmRKZIAdtvIRSGLTDlE7WkPAMx3+g4v7iK/1sAjHYfFRJIQxN++xO0oQC3iVySbmeEr2
         liwS39gPsfsrucyJX8zQIoivl9PssDAZCHqaTY/Q4YEotG+CRwK7yiaR7SA6dxoLkTLT
         XN4QMOE6TX7YM/Kbh9Mi64oJnP8lOtqYENqGa81nj35oCQXlA63fr2aOZkdR8SPGvjWe
         /QH8n567hcYJd3qk1Xz01BRQxfBCrVSfmkDJxRGb0BFFuatHy6dfNxj6/KD2RZaZSB2P
         1GTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:subject:date
         :in-reply-to:message-id:mime-version;
        bh=gCbLAdNfo6DzwKZZhiI2gvYSp0E58X2J6K8BZ7WMiCw=;
        b=6LjnRL3i1x6ZItpJxJv56fkcj4LURucdk2oLTZcF3m44U4fEN0vXkuA6qbwZgAy7t/
         gELXKg/NDj3qBqh0+wkGeR+LC7Wm8HE4Xf4hZOZEAbFxqruz1ARHtDASyJ21TLIUtxbJ
         uG6NXq4bUqlekCncO1WqiJyrCY6wqhOA0mm4ndDcuh626ivRrkSagiXCvBApoaimyKze
         HT/XAP5lc+oSX0cXVHhx6BfvbfVrA8TpjBA1rAWa6x7gOlqEhXs/0IQkEkMHoQK9Nplb
         WhNu5IBNei1SjmIREVE3Zk2YrXVa5tR2232yUFr2zw3B+w7LnlG3m7UU5lP0NDlNGsxN
         ih6w==
X-Gm-Message-State: AOAM53202HvjHUnqo6OuejtCakMaSwvh1sn6n+xDCMuZRF4CJ1m7REJB
        uoxXfHb6OM5DcXw9a/w2WoEIs40q4sOEuA==
X-Google-Smtp-Source: ABdhPJya4Y4U2ZAbUsCovhbUSLiaQE9fPad2ZHKayIa+Ateyevndqek8qHHFBktc7reIkkgLh7oW+A==
X-Received: by 2002:a7b:cbd7:: with SMTP id n23mr284984wmi.76.1644231416515;
        Mon, 07 Feb 2022 02:56:56 -0800 (PST)
Received: from localhost (82-65-169-74.subs.proxad.net. [82.65.169.74])
        by smtp.gmail.com with ESMTPSA id u14sm11073998wmq.41.2022.02.07.02.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 02:56:56 -0800 (PST)
References: <CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Erico Nunes <nunes.erico@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: Re: net: stmmac: dwmac-meson8b: interface sometimes does not come
 up at boot
Date:   Mon, 07 Feb 2022 11:41:36 +0100
In-reply-to: <CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com>
Message-ID: <1jczjzt05k.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 02 Feb 2022 at 21:18, Erico Nunes <nunes.erico@gmail.com> wrote:

> Hello,
>
> I've been tracking down an issue with network interfaces from
> meson8b-dwmac sometimes not coming up properly at boot.
> The target systems are AML-S805X-CC boards (Amlogic S805X SoC), I have
> a group of them as part of a CI test farm that uses nfsroot.
>
> After hopefully ruling out potential platform/firmware and network
> issues I managed to bisect this commit in the kernel to make a big
> difference:
>
>   46f69ded988d2311e3be2e4c3898fc0edd7e6c5a net: stmmac: Use resolved
> link config in mac_link_up()
>
> With a kernel before that commit, I am able to submit hundreds of test
> jobs and the boards always start the network interface properly.
>
> After that commit, around 30% of the jobs start hitting this:
>
>   [    2.178078] meson8b-dwmac c9410000.ethernet eth0: PHY
> [0.e40908ff:08] driver [Meson GXL Internal PHY] (irq=48)
>   [    2.183505] meson8b-dwmac c9410000.ethernet eth0: Register
> MEM_TYPE_PAGE_POOL RxQ-0
>   [    2.200784] meson8b-dwmac c9410000.ethernet eth0: No Safety
> Features support found
>   [    2.202713] meson8b-dwmac c9410000.ethernet eth0: PTP not supported by HW
>   [    2.209825] meson8b-dwmac c9410000.ethernet eth0: configuring for
> phy/rmii link mode
>   [    3.762108] meson8b-dwmac c9410000.ethernet eth0: Link is Up -
> 100Mbps/Full - flow control off
>   [    3.783162] Sending DHCP requests ...... timed out!
>   [   93.680402] meson8b-dwmac c9410000.ethernet eth0: Link is Down
>   [   93.685712] IP-Config: Retrying forever (NFS root)...
>   [   93.756540] meson8b-dwmac c9410000.ethernet eth0: PHY
> [0.e40908ff:08] driver [Meson GXL Internal PHY] (irq=48)
>   [   93.763266] meson8b-dwmac c9410000.ethernet eth0: Register
> MEM_TYPE_PAGE_POOL RxQ-0
>   [   93.779340] meson8b-dwmac c9410000.ethernet eth0: No Safety
> Features support found
>   [   93.781336] meson8b-dwmac c9410000.ethernet eth0: PTP not supported by HW
>   [   93.788088] meson8b-dwmac c9410000.ethernet eth0: configuring for
> phy/rmii link mode
>   [   93.807459] random: fast init done
>   [   95.353076] meson8b-dwmac c9410000.ethernet eth0: Link is Up -
> 100Mbps/Full - flow control off
>
> This still happens with a kernel from master, currently 5.17-rc2 (less
> frequently but still often hit by CI test jobs).
> The jobs still usually get to work after restarting the interface a
> couple of times, but sometimes it takes 3-4 attempts.
>
> Here is one example and full dmesg:
> https://gitlab.freedesktop.org/enunes/mesa/-/jobs/16452399/raw
>
> Note that DHCP does not seem to be an issue here, besides the fact
> that the problem only happens since the mentioned commit under the
> same setup, I did try to set up the boards to use a static ip but then
> the interfaces just don't communicate at all from boot.
>
> For test purposes I attempted to revert
> 46f69ded988d2311e3be2e4c3898fc0edd7e6c5a on top of master but that
> does not apply trivially anymore, and by trying to revert it manually
> I haven't been able to get a working interface.
>
> Any advice on how to further debug or fix this?

Hi Erico,

Thanks a lot for digging into this topic.
I'm seeing exactly the same behavior on the g12 based khadas-vim3:

* Boot stalled waiting for DHCP - with an NFS based filesystem
* Every minute, the network driver gets a reset and try again

Sometimes it works on the first attempt, sometimes it takes up to 5
attempts. Eventually, it reaches the prompt which might be why it went
unnoticed so far.

I think that NFS just makes the problem easier to see.
On devices with an eMMC based filesystem, I noticed that, sometimes, I
had unplug/plug the ethernet cable to make it go.

So far, the problem is reported on all the Amlogic SoC generation we
support. I think a way forward is to ask the the other users of
stmmac whether they have this problem or not - adding Allwinner and
Rockchip ML.

Since the commit you have identified is in the generic part of the
stmmac code, Maybe Jose can help us understand what is going on.

>
> Thanks
>
> Erico

