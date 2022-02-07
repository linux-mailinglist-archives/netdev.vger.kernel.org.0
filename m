Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD624AC7FD
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241398AbiBGRwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358181AbiBGRt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:49:58 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3B8C03FEDF;
        Mon,  7 Feb 2022 09:49:55 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id e28so14265126pfj.5;
        Mon, 07 Feb 2022 09:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=oP4sNWh8iR7KWN0kzeOWR8daIfqvnXiV6Uiu1fQgVnY=;
        b=Uz/gTtwoKHvTP1Dj5BCTpmTjU9hsSTVEMf2aWbTpnoWQ11WMjMAL159OjrPKuB9MbT
         3PFzmq8cWmFajJGy69t11cM8qFGao4QUE9S2Ov00q2NX7KBSl/CrsY2mbqQMNmFS95Fl
         1GekIe0LSI8k+4RQK8XFhcn8RYaYG/Qcr6qqTUqvSEAgXyt9p/BLEQoYGcIzBq/YFjTP
         6A/f/vVthM57ufBNg8Vx8cUQz+pwX/tS3ETrNGdyMzvVU0s817O5vgxQHokNFy08S2cO
         Sut6WCyfcvfdfAvOByDF7sInyU4wJisr2k+h6L1mMV6rEpztFGVeScC/aRZqhHr6seCO
         6P5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=oP4sNWh8iR7KWN0kzeOWR8daIfqvnXiV6Uiu1fQgVnY=;
        b=P0uvTCU17fPdC+GsLoW0Zv8jf9tiGrZva0E2FWIuy+adpV4p3enIfhOa49mPzesYj7
         x9we8NdGYILvgHg5yJhKa/SJNhTXGQRhpuJ2g/Cu0mLsmQlhRW9SMieYUv9zk0F3VWkw
         eJfuQtMFy/yzC3BapZIIgSbZUR+bV9ciH7SCvRLNW79WceACwYqSuQorLpimtaKnXJiy
         AmOLQL2bziurecl6sawhxinTKEsJVlR6uDo2WvOGQAwDYf321kN7F1RcHuBhHoNlmmni
         125e3smJTdtTQ4AHj1Um9SlwD7fBoj/mqTEQE+/18XwEwJbqW0dBFnhM3P78j0vf4l8l
         YirA==
X-Gm-Message-State: AOAM533y4DuYmAaGRnWXq8RapJaPMQzxi3h3aRkf7QL8o/HFMR22r2RC
        zYfl2KoqpI5gXOLRsdUKkAi8Pu2NyCHTMxll
X-Google-Smtp-Source: ABdhPJxcje7J9TJHoslEMy9RgbrnEC80j5+R9Yvm6gQb/WKFjeGgPmnIdPe5EQEYHErrAW3vRpWNdA==
X-Received: by 2002:aa7:94a9:: with SMTP id a9mr510130pfl.78.1644256195115;
        Mon, 07 Feb 2022 09:49:55 -0800 (PST)
Received: from localhost ([2405:201:2003:b021:6001:8ce1:3e29:705e])
        by smtp.gmail.com with ESMTPSA id s19sm12541046pfu.34.2022.02.07.09.49.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Feb 2022 09:49:54 -0800 (PST)
Date:   Mon, 7 Feb 2022 23:19:48 +0530
From:   Raag Jadav <raagjadav@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <20220207174948.GA5183@localhost>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <Yf6QbbqaxZhZPUdC@lunn.ch>
 <20220206171234.GA5778@localhost>
 <YgANBQjsrmK+T/N+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YgANBQjsrmK+T/N+@lunn.ch>
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

On Sun, Feb 06, 2022 at 07:01:41PM +0100, Andrew Lunn wrote:
> On Sun, Feb 06, 2022 at 10:42:34PM +0530, Raag Jadav wrote:
> > On Sat, Feb 05, 2022 at 03:57:49PM +0100, Andrew Lunn wrote:
> > > On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> > > > Enable MAC SerDes autonegotiation to distinguish between
> > > > 1000BASE-X, SGMII and QSGMII MAC.
> > > 
> > > How does autoneg help you here? It just tells you about duplex, pause
> > > etc. It does not indicate 1000BaseX, SGMII etc. The PHY should be
> > > using whatever mode it was passed in phydev->interface, which the MAC
> > > sets when it calls the connection function. If the PHY dynamically
> > > changes its host side mode as a result of what that line side is
> > > doing, it should also change phydev->interface. However, as far as i
> > > can see, the mscc does not do this.
> > >
> > 
> > Once the PHY auto-negotiates parameters such as speed and duplex mode
> > with its link partner over the copper link as per IEEE 802.3 Clause 27,
> > the link partner’s capabilities are then transferred by PHY to MAC
> > over 1000BASE-X or SGMII link using the auto-negotiation functionality
> > defined in IEEE 802.3z Clause 37.
> 
> None of this allows you to distinguish between 1000BASE-X, SGMII and
> QSGMII, which is what the commit message says.
> 

I agree, the current commit message is misleading.

> It does allow you to get duplex, pause, and maybe speed via in band
> signalling. But you should also be getting the same information out of
> band, via the phylib callback.
> 
> There are some MACs which don't seem to work correctly without the in
> band signalling, so maybe that is your problem? Please could you give
> more background about your problem, what MAC and PHY combination are
> you using, what problem you are seeing, etc.
> 

MAC implementation[1] in a lot of NXP SoCs comes with in-band aneg enabled
by default, and it does expect Clause 37 auto-negotiation to complete
between MAC and PHY before the actual data transfer happens.

[1] https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/t-series/3241/1/AN3869(1).pdf

I faced such issue while integrating VSC85xx PHY
with one of the recent NXP SoC having similar MAC implementation.
Not sure if this is a problem on MAC side or PHY side,
But having Clause 37 support should help in most cases I believe.

Cheers,
Raag

>     Andrew
> 
