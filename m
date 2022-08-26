Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1085A2B88
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbiHZPpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiHZPph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:45:37 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5863ED53
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:45:35 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z25so2510181lfr.2
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lessconfused.com; s=lessconfused;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=/iw18RzoUQLkecnuSCWCtSAHlAnE4tLc3GasgZ3eUE0=;
        b=L2QxI7y6/YAlVT7cbZzbVXUqCmPpE19/qP2JgpgvcKWJM7RI6fv0+slvVT/knkqwMv
         HoXde8pO8YkYqT5tbOj8JncS2eb6Iois0Glr7ZdIk6qQ7daO6jebEccuqPlAan99cP8M
         4tvS6z7A7lylPso+V6Oh95GlvJkJWnXvu+hR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/iw18RzoUQLkecnuSCWCtSAHlAnE4tLc3GasgZ3eUE0=;
        b=HCiSo6JoQIpWWyrPf5inGS0WXdFLLvQ+yJWuDyHOdfrmb4xXvBls+PKeGMjTcn87h1
         QhSAFbVRFgVGmbY0r7ETNT6Ea2ozHYZxLfZws2Xz7akmBdbu1TUsdv9elpH6e1bBqR2G
         iTCIlPK9SoXUE5zhmIC7jbgyffu2+Uc7jsNyRXDNK6tqlwMy7R5MNsLKWMe4WflsPPji
         OwQTeh7CEAZFN1GDcuz6UwBwIwQx6HXz8woiWpp6bfRjzqXLHUkqeQRdQ8R8zMLV/UBF
         HKWXMvUgPrAkwRRZBR3dCDuz2KIyzpAp+5cYUSd/7UiWKpM9R6SS+xU8B/oWGsrkDg3Z
         yTJA==
X-Gm-Message-State: ACgBeo1dcZ1GULFJ5SPru+J7fDbQHi9jRaUNFd5FruUtofL27QnstVOw
        UuAPipAxevV7yl1PJZ5oUr01rOX8leWxpvCU2rFieA==
X-Google-Smtp-Source: AA6agR7SKgTSgCxgZUTZ/8IvSD0dm7XWjdL3fxsToFr10oQAW3WhQLLbGV+/wAZJIsz3GbVjLwoHPLxFwtjTXH5ZiX4=
X-Received: by 2002:a05:6512:3406:b0:492:edf2:daf2 with SMTP id
 i6-20020a056512340600b00492edf2daf2mr2757702lfr.32.1661528733497; Fri, 26 Aug
 2022 08:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220707101423.90106-1-jbrunet@baylibre.com> <00f1e968-c140-29b9-dc82-a6f831171d6f@gmail.com>
In-Reply-To: <00f1e968-c140-29b9-dc82-a6f831171d6f@gmail.com>
From:   Da Xue <da@lessconfused.com>
Date:   Fri, 26 Aug 2022 11:45:21 -0400
Message-ID: <CACdvmAiyFQTUgEzkva9j8xYJYYBRXg_sfB562f3F515AHmkUoA@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] net: stmmac: do not poke MAC_CTRL_REG twice on
 link up
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Erico Nunes <nunes.erico@gmail.com>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Vyacheslav <adeep@lexina.in>, Qi Duan <qi.duan@amlogic.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

I have been running with the patch reverted for about two weeks now
without issue but I have a modified u-boot with ethernet bringup
disabled.

If u-boot brings up ethernet, all of the GXL boards with more than 1GB
memory experience various bugs. I had to bring the PHY initialization
patch into Linux proper:
https://github.com/libre-computer-project/libretech-linux/commit/1a4004c11877d4239b57b182da1ce69a81c0150c

Hope this helps someone.

Best,

Da

On Fri, Aug 26, 2022 at 5:51 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 07.07.2022 12:14, Jerome Brunet wrote:
> > For some reason, poking MAC_CTRL_REG a second time, even with the same
> > value, causes problem on a dwmac 3.70a.
> >
> > This problem happens on all the Amlogic SoCs, on link up, when the RMII
> > 10/100 internal interface is used. The problem does not happen on boards
> > using the external RGMII 10/100/1000 interface. Initially we suspected the
> > PHY to be the problem but after a lot of testing, the problem seems to be
> > coming from the MAC controller.
> >
> >> meson8b-dwmac c9410000.ethernet: IRQ eth_wake_irq not found
> >> meson8b-dwmac c9410000.ethernet: IRQ eth_lpi not found
> >> meson8b-dwmac c9410000.ethernet: PTP uses main clock
> >> meson8b-dwmac c9410000.ethernet: User ID: 0x11, Synopsys ID: 0x37
> >> meson8b-dwmac c9410000.ethernet:     DWMAC1000
> >> meson8b-dwmac c9410000.ethernet: DMA HW capability register supported
> >> meson8b-dwmac c9410000.ethernet: RX Checksum Offload Engine supported
> >> meson8b-dwmac c9410000.ethernet: COE Type 2
> >> meson8b-dwmac c9410000.ethernet: TX Checksum insertion supported
> >> meson8b-dwmac c9410000.ethernet: Wake-Up On Lan supported
> >> meson8b-dwmac c9410000.ethernet: Normal descriptors
> >> meson8b-dwmac c9410000.ethernet: Ring mode enabled
> >> meson8b-dwmac c9410000.ethernet: Enable RX Mitigation via HW Watchdog Timer
> >
> > The problem is not systematic. Its occurence is very random from 1/50 to
> > 1/2. It is fairly easy to detect by setting the kernel to boot over NFS and
> > possibly setting it to reboot automatically when reaching the prompt.
> >
> > When problem happens, the link is reported up by the PHY but no packet are
> > actually going out. DHCP requests eventually times out and the kernel reset
> > the interface. It may take several attempts but it will eventually work.
> >
> >> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> >> Sending DHCP requests ...... timed out!
> >> meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
> >> IP-Config: Retrying forever (NFS root)...
> >> meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.1:08] driver [Meson G12A Internal PHY] (irq=POLL)
> >> meson8b-dwmac ff3f0000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
> >> meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
> >> meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
> >> meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rmii link mode
> >> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> >> Sending DHCP requests ...... timed out!
> >> meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
> >> IP-Config: Retrying forever (NFS root)...
> >> [...] 5 retries ...
> >> IP-Config: Retrying forever (NFS root)...
> >> meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.1:08] driver [Meson G12A Internal PHY] (irq=POLL)
> >> meson8b-dwmac ff3f0000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
> >> meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
> >> meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
> >> meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rmii link mode
> >> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> >> Sending DHCP requests ., OK
> >> IP-Config: Got DHCP answer from 10.1.1.1, my address is 10.1.3.229
> >
> > Of course the same problem happens when not using NFS and it fairly
> > difficult for IoT products to detect this situation and recover.
> >
> > The call to stmmac_mac_set() should be no-op in our case, the bits it sets
> > have already been set by an earlier call to stmmac_mac_set(). However
> > removing this call solves the problem. We have no idea why or what is the
> > actual problem.
> >
> > Even weirder, keeping the call to stmmac_mac_set() but inserting a
> > udelay(1) between writel() and stmmac_mac_set() solves the problem too.
> >
> > Suggested-by: Qi Duan <qi.duan@amlogic.com>
> > Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> > ---
> >
> >  Hi,
> >
> >  There is no intention to get this patch merged as it is.
> >  It is sent with the hope to get a better understanding of the issue
> >  and more testing.
> >
> >  The discussion on this issue initially started on this thread
> >  https://lore.kernel.org/all/CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com/
> >
> >  The patches previously proposed in this thread have not solved the
> >  problem.
> >
> >  The line removed in this patch should be a no-op when it comes to the
> >  value of MAC_CTRL_REG. So the change should make not a difference but
> >  it does. Testing result have been very good so far so there must be an
> >  unexpected consequence on the HW. I hope that someone with more
> >  knowledge on this controller will be able to shine some light on this.
> >
> >  Cheers
> >  Jerome
> >
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index d1a7cf4567bc..3dca3cc61f39 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -1072,7 +1072,6 @@ static void stmmac_mac_link_up(struct phylink_config *config,
> >
> >       writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
> >
> > -     stmmac_mac_set(priv, priv->ioaddr, true);
> >       if (phy && priv->dma_cap.eee) {
> >               priv->eee_active = phy_init_eee(phy, 1) >= 0;
> >               priv->eee_enabled = stmmac_eee_init(priv);
>
> Now that we have a3a57bf07de2 ("net: stmmac: work around sporadic tx issue on link-up")
> in linux-next and scheduled for stable:
>
> Jerome, can you confirm that after this commit the following is no longer needed?
> 2c87c6f9fbdd ("net: phy: meson-gxl: improve link-up behavior")
>
> Then I'd revert it, referencing the successor workaround / fix in stmmac.
