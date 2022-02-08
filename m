Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9304ADDAA
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357527AbiBHPxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbiBHPxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:53:14 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B337C061576;
        Tue,  8 Feb 2022 07:53:13 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id x3so14175733pll.3;
        Tue, 08 Feb 2022 07:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=gAm+PLZtrqdu/2KKj3BZozQaVMMACzxvjpkrHL/obM4=;
        b=aV/EE1edQCucPEr+plYfTdxaMVX8QN1x4M6sMVj9wVDOxMMG+25UrgT8O96rKHY80V
         KBwM8FJcupa7PIPHI0rXalxH1N6c1tXZ2Vd26NRBL3UwSSKBaL8OkLisb1sTnoh0Zhw7
         qPOuUGusze8e6ezam8tunqmF5M2RO+K084dzHN2iJlPlCim04ptuRsL+nSJiZhq95Hzn
         Vu2qD8CxGOp8VB1vuNdcMvZSkxKBKhhshz7MDCNKiirIp1+dJv2tUSTYk1KQNEeyKLCO
         LKeR4zhbVfCs70dJkup1PcdC+4vKseKVk0eFTPeuOEAkLttLeTvfHAU2Vnx3qZZVbuSQ
         MzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=gAm+PLZtrqdu/2KKj3BZozQaVMMACzxvjpkrHL/obM4=;
        b=pgpTs1MwsnzhgGJ1xEVasS+gNE5wV0FrVSj3d/p0wU3Qwaix2PRGPdqL5kLesRyF2S
         kWPG+S1mZjcZmvLTvDekW/9jA2r4P43rSOA1tVHqZyKi4tW9EDL3CdmK1QoQ3lxH+iOh
         le9kTAZFAPM6L0NPgHk9R5J5x6EQyIpbjVeEylA08F0jU3DxfmCER4dMaq0IozVjXS9d
         71c7yoTkno76HPWjg8YwmIbTeJjQiTkDfgQh3MZAwlVxXxLETfA1pBS8HTFEixlrnCiM
         ZYQUrsER/tGpOILyCoA9GpICSnDANw2RFbQOjeq+u+8ZNrJdKfr1uA2uIzPuSR0Lhxab
         aDmQ==
X-Gm-Message-State: AOAM531G0mD6VWn1n54byP2m+QCqehIFqr3Mrr0jTjypjkxp/zzMbz+h
        8WZKszpckL0PL8N/9zitZ9g=
X-Google-Smtp-Source: ABdhPJybJREJFmQkPKtB0rsnZk0tzZgG7w0ZBF+GSQrj0s3mvdMvi7ThmDAG3834IOzuqFRMQOvYLg==
X-Received: by 2002:a17:903:2286:: with SMTP id b6mr5280223plh.94.1644335593021;
        Tue, 08 Feb 2022 07:53:13 -0800 (PST)
Received: from localhost ([2405:201:2003:b021:6001:8ce1:3e29:705e])
        by smtp.gmail.com with ESMTPSA id o21sm17116826pfu.100.2022.02.08.07.53.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Feb 2022 07:53:12 -0800 (PST)
Date:   Tue, 8 Feb 2022 21:23:06 +0530
From:   Raag Jadav <raagjadav@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <20220208155306.GA3003@localhost>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <Yf6QbbqaxZhZPUdC@lunn.ch>
 <20220206171234.GA5778@localhost>
 <YgANBQjsrmK+T/N+@lunn.ch>
 <20220207174948.GA5183@localhost>
 <YgI7qcO1qjicYqUm@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YgI7qcO1qjicYqUm@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 09:45:13AM +0000, Russell King (Oracle) wrote:
> On Mon, Feb 07, 2022 at 11:19:48PM +0530, Raag Jadav wrote:
> > On Sun, Feb 06, 2022 at 07:01:41PM +0100, Andrew Lunn wrote:
> > > On Sun, Feb 06, 2022 at 10:42:34PM +0530, Raag Jadav wrote:
> > > > On Sat, Feb 05, 2022 at 03:57:49PM +0100, Andrew Lunn wrote:
> > > > > On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> > > > > > Enable MAC SerDes autonegotiation to distinguish between
> > > > > > 1000BASE-X, SGMII and QSGMII MAC.
> > > > > 
> > > > > How does autoneg help you here? It just tells you about duplex, pause
> > > > > etc. It does not indicate 1000BaseX, SGMII etc. The PHY should be
> > > > > using whatever mode it was passed in phydev->interface, which the MAC
> > > > > sets when it calls the connection function. If the PHY dynamically
> > > > > changes its host side mode as a result of what that line side is
> > > > > doing, it should also change phydev->interface. However, as far as i
> > > > > can see, the mscc does not do this.
> > > > >
> > > > 
> > > > Once the PHY auto-negotiates parameters such as speed and duplex mode
> > > > with its link partner over the copper link as per IEEE 802.3 Clause 27,
> > > > the link partner’s capabilities are then transferred by PHY to MAC
> > > > over 1000BASE-X or SGMII link using the auto-negotiation functionality
> > > > defined in IEEE 802.3z Clause 37.
> > > 
> > > None of this allows you to distinguish between 1000BASE-X, SGMII and
> > > QSGMII, which is what the commit message says.
> > > 
> > 
> > I agree, the current commit message is misleading.
> > 
> > > It does allow you to get duplex, pause, and maybe speed via in band
> > > signalling. But you should also be getting the same information out of
> > > band, via the phylib callback.
> > > 
> > > There are some MACs which don't seem to work correctly without the in
> > > band signalling, so maybe that is your problem? Please could you give
> > > more background about your problem, what MAC and PHY combination are
> > > you using, what problem you are seeing, etc.
> > > 
> > 
> > MAC implementation[1] in a lot of NXP SoCs comes with in-band aneg enabled
> > by default, and it does expect Clause 37 auto-negotiation to complete
> > between MAC and PHY before the actual data transfer happens.
> > 
> > [1] https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/t-series/3241/1/AN3869(1).pdf
> > 
> > I faced such issue while integrating VSC85xx PHY
> > with one of the recent NXP SoC having similar MAC implementation.
> > Not sure if this is a problem on MAC side or PHY side,
> > But having Clause 37 support should help in most cases I believe.
> 
> Clause 37 is 1000BASE-X negotiation, which is different from SGMII - a
> point which is even made in your PDF above in section 1.1.
> 
> You will need both ends to be operating in SGMII mode for 10M and 100M
> to work. If one end is in 1000BASE-X mdoe and the other is in SGMII,
> it can appear to work, but it won't be working correctly.
> 
> Please get the terminology correct here when talking about SGMII or
> 1000BASE-X.
> 

Thank you for the clarification.
Really appreciate it.

Cheers,
Raag

> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
