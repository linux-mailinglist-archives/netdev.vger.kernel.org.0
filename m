Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BAE5139FE
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350121AbiD1Qlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350108AbiD1Qly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:41:54 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19586AFB11
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:38:39 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x17so9601656lfa.10
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cYERQvoVyttYHR74fN2RQHSA1X/Z0zaYMsIwS0bi7gU=;
        b=Z2PEwnhQSZKxCN8Yx3JvfTQjNd6WvXJFRReExUl3jKb/4BpidnWyfBfXkiM3OA8uNs
         JdMbF52mgFuZ1jYLJ7jXLwpPLPpimJC+tLBUR9PXCjT3QEIdz5RKQ42Icb0qwWgr3+ez
         5iKigTkzR9e8lQG3Vs8DhEe2ZH0V7M1a9kXxihTajdyj2Ieuu/e1+6q3SJcjRmMt3TSq
         pgShzGcSpIoxd2WTVWEavMgczyDGbNQzpstFSxR5FUPO/vZPd/9pXi2AlNu0ZSSnKv3I
         kGbTHWbgG6cio1SWobmdO9hCAX32sXH8qnJXXYWRvis7uyoJnNecrIuwh94SxPHc8fP8
         nlsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cYERQvoVyttYHR74fN2RQHSA1X/Z0zaYMsIwS0bi7gU=;
        b=cl7Z6trzI+Yevr0op+pHR95+JLzgLwy0dWyhqNRKSPtMWIVhjOutxVHt5s5hLeKsBv
         cD0hNvc8PfuTrWeLzt6CyshZHijSeXh8rTyBdMXNGvRto1eecKCSgOv7HOWlAlpxPuHO
         mNFcSix543CaIYzdrrVyxubyOU7xR8QFY/FMCOByNo1YAvxBGOXNfqimtv34I2KXxHXi
         P3r/tEuASTq00NSlkV13iADmGvIsbsZxxAopSMJ6Z90EfnEI1TZP2V7MDh9mW/nLDOju
         pbkP4hdo0SotnOf4777LAQNdLf0JeQALyRwFAtV4KWlfntM7IfIlUvTU6Tq5Bq6GzgSl
         tz2g==
X-Gm-Message-State: AOAM532BfWR2knT23el2h7XlGmF7nrfcPtSb1gJQIq3cSDtnFNfpWm12
        N98YG904XmCBDiqEQ9IuC9pnDJTqXvYrvHoEB4/UaQ==
X-Google-Smtp-Source: ABdhPJzJaesftKuGZACqd62CymchGb8wJU++CKbqANpFBgo4Jj2f5+vNLThx9l3y766H1+maniEX84xoaBk5AE9j9iI=
X-Received: by 2002:a05:6512:321c:b0:46b:b7fd:1eca with SMTP id
 d28-20020a056512321c00b0046bb7fd1ecamr11555094lfe.481.1651163916571; Thu, 28
 Apr 2022 09:38:36 -0700 (PDT)
MIME-Version: 1.0
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com> <87levpzcds.fsf@tarshish>
In-Reply-To: <87levpzcds.fsf@tarshish>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 28 Apr 2022 18:38:26 +0200
Message-ID: <CAPv3WKc1eM4gyD_VG2M+ozzvLYrDAXiKGvK6Ej_ykRVf-Zf9Mw@mail.gmail.com>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baruch,

czw., 28 kwi 2022 o 13:16 Baruch Siach <baruch@tkos.co.il> napisa=C5=82(a):
>
> Hi Marcin,
>
> On Thu, Apr 28 2022, Marcin Wojtas wrote:
> > =C5=9Br., 27 kwi 2022 o 17:05 Baruch Siach <baruch@tkos.co.il> napisa=
=C5=82(a):
> >>
> >> From: Baruch Siach <baruch.siach@siklu.com>
> >>
> >> Without this delay PHY mode switch from XLG to SGMII fails in a weird
> >> way. Rx side works. However, Tx appears to work as far as the MAC is
> >> concerned, but packets don't show up on the wire.
> >>
> >> Tested with Marvell 10G 88X3310 PHY.
> >>
> >> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> >> ---
> >>
> >> Not sure this is the right fix. Let me know if you have any better
> >> suggestion for me to test.
> >>
> >> The same issue and fix reproduce with both v5.18-rc4 and v5.10.110.
> >> ---
> >>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers=
/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >>n index 1a835b48791b..8823efe396b1 100644
> >> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> >> @@ -6432,6 +6432,8 @@ static int mvpp2_mac_prepare(struct phylink_conf=
ig *config, unsigned int mode,
> >>                 }
> >>         }
> >>
> >> +       mdelay(10);
> >> +
> >>         return 0;
> >>  }
> >
> > Thank you for the patch and debug effort, however at first glance it
> > seems that adding delay may be a work-around and cover an actual root
> > cause (maybe Russell will have more input here).
>
> That's my suspicion as well.
>
> > Can you share exact reproduction steps?
>
> I think I covered all relevant details. Is there anything you find
> missing?
>
> The hardware setup is very similar to the Macchiatobin Doubleshot. I can
> try to reproduce on that platform next week if it helps.
>
> The PHY MAC type (MV_V2_33X0_PORT_CTRL_MACTYPE_MASK) is set to
> MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER.
>
> I can add that DT phy-mode is set to "10gbase-kr" (equivalent to
> "10gbase-r" in this case). The port cp0_eth0 is connected to a 1G
> Ethernet switch. Kernel messages indicate that on interface up the MAC
> is first configured to XLG (10G), but after Ethernet (wire)
> auto-negotiation that MAC switches to SGMII. If I set DT phy-mode to
> "sgmii" the issue does not show. Same if I make a down/up cycle of the
> interface.
>
> Thanks for your review.
>

I booted MacchiatoBin doubleshot with DT (phy-mode set to "10gbase-r")
without your patch and the 3310 PHY is connected to 1G e1000 card.
After `ifconfig eth0 up` it properly drops to SGMII without any issue
in my setup:

# ifconfig eth0 up
[   62.006580] mvpp2 f2000000.ethernet eth0: PHY
[f212a600.mdio-mii:00] driver [mv88x3310] (irq=3DPOLL)
[   62.016777] mvpp2 f2000000.ethernet eth0: configuring for phy/sgmii link=
 mode
# [   66.110289] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full
- flow control rx/tx
[   66.118270] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
# ifconfig eth0 192.168.1.1
# ping 192.168.1.2
PING 192.168.1.2 (192.168.1.2): 56 data bytes
64 bytes from 192.168.1.2: seq=3D0 ttl=3D64 time=3D0.511 ms
64 bytes from 192.168.1.2: seq=3D1 ttl=3D64 time=3D0.212 ms

Are you aware of the firmware version of the 3310 PHY in your setup?
In my case it's:
mv88x3310 f212a600.mdio-mii:00: Firmware version 0.3.3.0

Best regards,
Marcin
