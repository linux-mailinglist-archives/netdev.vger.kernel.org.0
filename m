Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0914E86F1
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 10:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiC0IcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 04:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiC0Ib6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 04:31:58 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72362337;
        Sun, 27 Mar 2022 01:30:20 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id o13so9892200pgc.12;
        Sun, 27 Mar 2022 01:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CcQC5mza5HmAPvm8+7iXtd7sMyq+njfhZSyBbkzIFG8=;
        b=Bf8KxCQSudLHj2QsQlt7813ft5274mDIOp8ndciYSXCOmXRw2oZtosCQ/gW6h4STtd
         IsTsv9D3uGfroPDAId6et70IyvUloCCUeLeYh/D3yoAQk+8qjz5kWHlaqDhq5c8fkF3Z
         RgDOgNpmN60HhXxHRzTJOl863jv+i+ac42nS9q5lvrQAbBB7nP/hVQNfpgaRZoLQe7eX
         IX45SmtoXGa2EepS0wdZZRi1gc6l42lkdCGRUPZAz5xCywsMwRWKswY+xNr2TzQc/Xir
         ZdWqznawwUjSZVhI5vtMRJJ+Vs3pzGZZLMePbbFAKehChnJG3mK8TAJKkGLEq8pl8Zf4
         R4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CcQC5mza5HmAPvm8+7iXtd7sMyq+njfhZSyBbkzIFG8=;
        b=Fn82Qu/w98rcqaNHjCrd7sDrwaSC3ryZhK+VuD5iyzFTkIfeqUPmQImSRLIl6KhuCF
         /ADkAiox5/+so77my4fTLYANctU8J6X4rWcpWbCYHLLGZduq+1Dk0hIj+Cb7bJqSRkTa
         IsK6exAvyvjICs/Ar1M47eOmjZ3ZQYtd8E5eviIXGfACgoGpoXzBNJ1ePnZLLS8dWAkw
         l7UZ4Zi8ggH9j3O8a3YDdHrg6v8V5mY1/t4b1E0dxL9uoOAFhbPA9kZRnFy+qn+DxSex
         R8cP2gfokZF7wqfWa+BOHmZPgRImkYvLi12FCDYnLRmOADhAkWqKZkUi3Q3B1YT8T0lF
         x3HQ==
X-Gm-Message-State: AOAM530YlD5tCK3Szikv3mHaCfoBNouP2CAHyGO5uofP1kv3zMtyHTid
        TosD52w268SvqVYuZ5PiCU0=
X-Google-Smtp-Source: ABdhPJxetl+47M9eJes1Ne4PzwcZTzahLw24KWbM9gKe5L3DRKWGA6TAhf6sF98jDfNRs2dLMZyRog==
X-Received: by 2002:a63:1620:0:b0:375:948e:65bf with SMTP id w32-20020a631620000000b00375948e65bfmr6137145pgl.49.1648369819773;
        Sun, 27 Mar 2022 01:30:19 -0700 (PDT)
Received: from localhost ([2405:201:2003:b021:6001:8ce1:3e29:705e])
        by smtp.gmail.com with ESMTPSA id h8-20020a056a001a4800b004fb2cf4a22dsm4210570pfv.25.2022.03.27.01.30.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Mar 2022 01:30:18 -0700 (PDT)
Date:   Sun, 27 Mar 2022 14:00:12 +0530
From:   Raag Jadav <raagjadav@gmail.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <20220327083012.GA3254@localhost>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <YhdimdT1qLdGqPAW@shell.armlinux.org.uk>
 <20220226072327.GA6830@localhost>
 <846b6171-2acd-1e03-8cd8-827bf5437636@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <846b6171-2acd-1e03-8cd8-827bf5437636@ti.com>
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

On Thu, Mar 24, 2022 at 03:36:02PM +0530, Siddharth Vadapalli wrote:
> Hi Raag,
> 
> On 26/02/22 12:53, Raag Jadav wrote:
> > On Thu, Feb 24, 2022 at 10:48:57AM +0000, Russell King (Oracle) wrote:
> >> Sorry for the late comment on this patch.
> >>
> >> On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> >>> +static int vsc85xx_config_inband_aneg(struct phy_device *phydev, bool enabled)
> >>> +{
> >>> +	int rc;
> >>> +	u16 reg_val = 0;
> >>> +
> >>> +	if (enabled)
> >>> +		reg_val = MSCC_PHY_SERDES_ANEG;
> >>> +
> >>> +	mutex_lock(&phydev->lock);
> >>> +
> >>> +	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
> >>> +			      MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
> >>> +			      reg_val);
> >>> +
> >>> +	mutex_unlock(&phydev->lock);
> >>
> >> What is the reason for the locking here?
> >>
> >> phy_modify_paged() itself is safe due to the MDIO bus lock, so you
> >> shouldn't need locking around it.
> >>
> > 
> > True.
> > 
> > My initial thought was to have serialized access at PHY level,
> > as we have multiple ports to work with.
> > But I guess MDIO bus lock could do the job as well.
> > 
> > Will fix it in v2 if required.
> 
> Could you please let me know if you plan to post the v2 patch?
> 
> The autonegotiation feature is also required for VSC8514, and has to be invoked
> in vsc8514_config_init(). Let me know if you need my help for this.
> 

Maybe this is what you're looking for.
https://www.spinics.net/lists/netdev/msg768517.html

Cheers,
Raag

> Regards,
> Siddharth
