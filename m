Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031294AB0DE
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 18:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343918AbiBFRMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 12:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiBFRMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 12:12:43 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3CCC06173B;
        Sun,  6 Feb 2022 09:12:41 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso4140938pjt.4;
        Sun, 06 Feb 2022 09:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=MrarPuJrKTyhOUq+rI1FUAiZg79JNxsp4npqGqfl6cs=;
        b=DdMayqDm5XSil1zTmkUcSaO9tsDlRrcWYLqm3H0HDZDPjGaAyOgFGD9wIKNDOe8iU0
         kI4eABQT6kg+n+gx3RHjAkSXy8/NVt/PwKPGfPkxMXwFmXXU+MV7t+E6sfLY6McqTyDw
         Y0yj6Ud/RgVVkMCYSz6bBVBLJFFD9sxRggw/tx73A0elpBS/cCRY7UYKyAg9Tl82Y+VW
         dNZUZGc5sQpZK3tKiSOs1fmMGIv6tnZR2VmLOD+Ame5uf0DkpF5Wpt8k/Y18cR7ImzS/
         HASRXCTJZOmING9TDlsu+f/f6ajPvAYC/7y3jsIxfVTMcJOWc839d4aQrfuE4hnc6ZRn
         K8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=MrarPuJrKTyhOUq+rI1FUAiZg79JNxsp4npqGqfl6cs=;
        b=OeMgxpC0DLdGr1maXmtu2XPEWXKcj9RaozUlqz8gjzUggEh7wQ2Dqow8EtyaMbgiWY
         swRP6EcCDEZuGLxPfa/QgRToyHdhZirKwsJMhPk/b8H9D5MrJwO/fKhZsRKhjbhpsYJM
         XgAEbwmelvL4z3tCCbBZ3JtR6RKiOvZNSuEMZox0VnwEOAgwcviS0yVTWLfPPMYbnzLg
         sGAOngqT5iC5Lk+2SF9mgsiojcG9qC60khIBWqG+1NDbgLRlcVCQf93abhShDaUYD3kE
         MMbDG7wS6PgCxdaea/BFV/TqetvbvKUTRRyR5NRjQypyFbmqqTim/w+zpe3V29dZwLJS
         N6Mg==
X-Gm-Message-State: AOAM531q25wA2BSmFqfFGv8edrdFDxjtAWIFsP8jV7/bFUf0gGyXxclW
        qC0B+bzuTq2pG5Q6aV41T4WPa/GSBj0SrNQs
X-Google-Smtp-Source: ABdhPJyy6ZEBRMuYPMl1/IK1gNi5MaBoezrlnYNfmYFc8Hg2GVl8C2SDl3TlMamlgC2ihIueZP6WWQ==
X-Received: by 2002:a17:902:dac7:: with SMTP id q7mr12739431plx.125.1644167561361;
        Sun, 06 Feb 2022 09:12:41 -0800 (PST)
Received: from localhost ([2405:201:2003:b021:6001:8ce1:3e29:705e])
        by smtp.gmail.com with ESMTPSA id om8sm19873537pjb.51.2022.02.06.09.12.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Feb 2022 09:12:40 -0800 (PST)
Date:   Sun, 6 Feb 2022 22:42:34 +0530
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
Message-ID: <20220206171234.GA5778@localhost>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <Yf6QbbqaxZhZPUdC@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yf6QbbqaxZhZPUdC@lunn.ch>
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

On Sat, Feb 05, 2022 at 03:57:49PM +0100, Andrew Lunn wrote:
> On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> > Enable MAC SerDes autonegotiation to distinguish between
> > 1000BASE-X, SGMII and QSGMII MAC.
> 
> How does autoneg help you here? It just tells you about duplex, pause
> etc. It does not indicate 1000BaseX, SGMII etc. The PHY should be
> using whatever mode it was passed in phydev->interface, which the MAC
> sets when it calls the connection function. If the PHY dynamically
> changes its host side mode as a result of what that line side is
> doing, it should also change phydev->interface. However, as far as i
> can see, the mscc does not do this.
>

Once the PHY auto-negotiates parameters such as speed and duplex mode
with its link partner over the copper link as per IEEE 802.3 Clause 27,
the link partner’s capabilities are then transferred by PHY to MAC
over 1000BASE-X or SGMII link using the auto-negotiation functionality
defined in IEEE 802.3z Clause 37.

So any dynamic change in link partner’s capabilities over the copper link
can break MAC to PHY communication if MAC SerDes autonegotiation is disabled
even on active MAC interface link.

Is this understanding correct?

> So i don't understand this commit message.
> 

Will send out a v2 with updated commit message on confirmation.

Cheers,
Raag
 
>    Andrew
