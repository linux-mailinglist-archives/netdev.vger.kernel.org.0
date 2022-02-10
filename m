Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6194B136B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244767AbiBJQss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:48:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiBJQsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:48:47 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F247A189;
        Thu, 10 Feb 2022 08:48:46 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id r64-20020a17090a43c600b001b8854e682eso6179903pjg.0;
        Thu, 10 Feb 2022 08:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aqQlw5J1PJbV80o+XQLfHKm2M9x6OQ12KF2pGPWeqWc=;
        b=KbdpH+hRiXwL3t+NP3b7Z+bfjLG5pkQSlxDoEJ4ZQVxOt673194ucjCkGOg5anSOOz
         LNBTXvQW9azZxmQ4OwmFhofqZcmkqvowDf+/2TXVX72gj4LFE1V7dePcI3SSw+UPe6U7
         8Uc6tPTIRLVCgz6o+SCr+Ra0xI3SJ8FZxWwQKhOU3szq0NM+TZPPPobh7N/BdsqiAKwG
         3yUwic3+2c/FxFetWYmKPZXLLwkIdGKIk1N2jVujEFqikOh1VgKSr0UBjvf7Cxxe4jjv
         Dlbl2tLevKFk+oVPnbiQ9DmkhrI2wfbPcReVIE7UBX2Cd8B8MQz8kz/rrYxHciBPHj4z
         /tvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aqQlw5J1PJbV80o+XQLfHKm2M9x6OQ12KF2pGPWeqWc=;
        b=VMt8RRzza+FZ/Q72oFFIOMPP1UPxaE6cjAoI+wYNrUmDVd0Ze4Hhq8SGpHZqS+1sss
         w/yJDXDNst6XP7aCpX/zzc75Ne2KhWlBE/h/dPkEFARUquWTdD0V05YV8/BGFZUmFDYX
         HVSwhCoVOs/VVJIjZKx3sHj/v9CgEVu1i7CfYvld27yKPt3Mo528f2oB/ZkuCmvFUSOH
         WbiwMk/KLoaVR/YIEZ550NYbV1GcAixAFUuyupDEYOaaZ7EQ1FppctPhlJa4ySMcHS0p
         jCwl9/2r8YULrJsmPof8sRDylRkGOPkmdV95jLtH+a9o6CFsmKaI9Hh4qgeklxJ3tYpJ
         d75w==
X-Gm-Message-State: AOAM532ZWkhT7DKmqS37T/9DDWIiATO6PLrm6ll1ygEHtd7vbztcIf7k
        MEXazzVF0qnccGDc/UnbM6I=
X-Google-Smtp-Source: ABdhPJx3T94btrdaKA0aIxiIdC3wg24SQyyLM1KoLZA/PFuUM/LZLCJleUSTZ2mNdhBHZJNvHz3cpw==
X-Received: by 2002:a17:90b:4d11:: with SMTP id mw17mr3715979pjb.9.1644511726359;
        Thu, 10 Feb 2022 08:48:46 -0800 (PST)
Received: from localhost ([2405:201:2003:b021:6001:8ce1:3e29:705e])
        by smtp.gmail.com with ESMTPSA id x126sm10291208pfb.117.2022.02.10.08.48.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:48:45 -0800 (PST)
Date:   Thu, 10 Feb 2022 22:18:39 +0530
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
Message-ID: <20220210164839.GA3679@localhost>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <Yf6QbbqaxZhZPUdC@lunn.ch>
 <20220206171234.GA5778@localhost>
 <YgANBQjsrmK+T/N+@lunn.ch>
 <20220207174948.GA5183@localhost>
 <YgHQ7Kf+2c9knxk3@lunn.ch>
 <20220208155752.GB3003@localhost>
 <YgLAux87L1zYmp7k@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgLAux87L1zYmp7k@lunn.ch>
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

On Tue, Feb 08, 2022 at 08:12:59PM +0100, Andrew Lunn wrote:
> On Tue, Feb 08, 2022 at 09:27:52PM +0530, Raag Jadav wrote:
> > On Tue, Feb 08, 2022 at 03:09:48AM +0100, Andrew Lunn wrote:
> > > > MAC implementation[1] in a lot of NXP SoCs comes with in-band aneg enabled
> > > > by default, and it does expect Clause 37 auto-negotiation to complete
> > > > between MAC and PHY before the actual data transfer happens.
> > > > 
> > > > [1] https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/t-series/3241/1/AN3869(1).pdf
> > > > 
> > > > I faced such issue while integrating VSC85xx PHY
> > > > with one of the recent NXP SoC having similar MAC implementation.
> > > > Not sure if this is a problem on MAC side or PHY side,
> > > > But having Clause 37 support should help in most cases I believe.
> > > 
> > > So please use this information in the commit message.
> > > 
> > > The only danger with this change is, is the PHY O.K with auto-neg
> > > turned on, with a MAC which does not actually perform auto-neg? It
> > > could be we have boards which work now because PHY autoneg is turned
> > > off.
> > > 
> > 
> > Introducing an optional device tree property could be of any help?
> 
> Or find out what this PHY does when the host is not performing auto
> neg. Does the datasheet say anything about that?
> 

Not sure if such behaviour is explicitly mentioned in the datasheet.
Maybe someone from Microchip can shed some light on this.

Cheers,
Raag

>      Andrew
