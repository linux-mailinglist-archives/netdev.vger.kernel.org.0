Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54954AC724
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353406AbiBGRSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344486AbiBGRDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:03:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6A4C0401D1;
        Mon,  7 Feb 2022 09:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644253414; x=1675789414;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pnrO5Plp1Sug3zd8Uyldl5o/laIPwZ454MnCGdKK9C0=;
  b=Lzht4rsrtFtugZC0Rf6Y0V6BQNgoKmAy/sjDoaDBmGhl1QJpDgwlSg1j
   ZRRZWM8gKs5WrXOsmG2US4irzvb3ibcq43/8LonY7iYUWp64iDbV63DKm
   dYzGrFHje+psAR/OXvuFqlxUyRx24UhkEqywfJjh8Tj7d2QV+/ai3kNTJ
   pQglyAWiAO7nxH2+LGejKtK1N4GJ0TnWxehy/rgA3zWHZP6cFIFtHqioe
   AwCLjK4x7vQR4wICn8N+d742R0VO2k2E5q1bEehPrNfXnOFt8Ymb3UIF5
   IrqcQoK59NLsbE9olp2p3MxPsAyhe4mPP9UE3EhUTK/HVYryBgeG6h6BQ
   Q==;
IronPort-SDR: ASOr3RrNRwTdUZYa3WxbUDfOgmuEVvbq9pKxD/chgXWMRHhWjHN2vEpYsADK29+Ufzo10XspCs
 VbZQg3ez+ZqhJyCsvrGMoLvHLvOEozZPHCY0JaRPZXck9sIKGhM5FZJ4aCiOSUjGToQuDOQrNP
 rtD9YbKZy1ohwJFr31lge+ulzLIueK5TvC4/0TRB9DV4Oav8w1MQTtQGfIgkGSwvvTcfPRteIk
 HCDgH1TPdP+UGoWJ5f41lOOvn0lfglmuXEX60++rSFobwRetk0qgf6inDVSdoboJ5YAcwJ2h4g
 H2hoPW/fG4rFPYMU7ljdQbB3
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="152733239"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2022 10:03:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Feb 2022 10:03:32 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Feb 2022 10:03:26 -0700
Message-ID: <49878826c61a9fe556869710fecee615cf2a0c21.camel@microchip.com>
Subject: Re: [PATCH v7 net-next 07/10] net: dsa: microchip: add support for
 ethtool port counters
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Mon, 7 Feb 2022 22:33:25 +0530
In-Reply-To: <20220204192721.21835705@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
         <20220204174500.72814-8-prasanna.vengateshan@microchip.com>
         <20220204192721.21835705@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-02-04 at 19:27 -0800, Jakub Kicinski wrote:
> > +     for (i = 0; i < dev->mib_cnt; i++) {
> > +             memcpy(buf + i * ETH_GSTRING_LEN, lan937x_mib_names[i].string,
> > +                    ETH_GSTRING_LEN);
> > +     }
> 
> parenthesis unnecessary around single expression
> 
> Also check out ethtool_sprintf(), although not strictly necessary since
> you're not formatting
Sure, thanks for the feedback.

Prasanna V


