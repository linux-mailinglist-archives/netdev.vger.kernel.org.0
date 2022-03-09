Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6314D26BF
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiCIBru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiCIBrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:47:49 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A260847AD1;
        Tue,  8 Mar 2022 17:46:51 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id a5so963833pfv.2;
        Tue, 08 Mar 2022 17:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B8bBqTwia7wBMwz5hHXZHCzqohNsptzJRrrGwkJNRS8=;
        b=nwj7tvDCQhT1tTSZYmeFh97v6ljyhYUeGt5xJaI5O+5JHeo06oneSZyrrLp9BGAYNI
         pMlEUKTuDpYeL6nlBXoq5WGC1p86052RqBGBeaop9vmCRbk8j+OE7kmswBlOQcWUZYqC
         ozkE/n0IsZrz/0oiZ1k+8RlL1lvSozFFqulT9DKNgIa3kEZU610qd8SVTBLtq01v3rmq
         Ces/SsF7xuWX4HjoBhGvS8jbozk85pviU83o6Yw1emBgHCO6Kw0O3HDB//5i7xHSKBRF
         vUQzWla11q3n6eixTOIm4NrDY5rPuED+sdh3H9ZqRREY9VP0fdsNZEEJtJH3avwR9DQA
         XYeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B8bBqTwia7wBMwz5hHXZHCzqohNsptzJRrrGwkJNRS8=;
        b=v0DdGmYv5HUPYgrQ987JVZi1+VnecA/G3OPbP8+uP9WcXUqv4e+a/cF+NaLNg7FoXu
         HgkAlND6stJBLAM0fJ31vPpU0mV3A74G39Zu/Pzt9mM7tS/RD+EoMjgy3BYPta9KSmVy
         OBH9nFNeFWPrU77mhop8SbvPgbnvfiWM1jwaHaQU6i2aM1Ir/ZlrZs9d/rzsiAzrxxsC
         uNqkNuDD7llikinHJ+97sf/hcel0zK5wra+m/WS2v604aMWej+cDSCKeK0FUBQV/CilI
         OQAzkT30M0jzu8BJbEB7btyLbccoxK1P4re03C3+0Yz0C6ZfaIn2W73F5ccgp8XsdqCs
         mffw==
X-Gm-Message-State: AOAM533SasUcdPKCjpC1idsAGoxqEi0E9ylJ46lj10meD4XRj6hpIuxS
        FrChO2X6eftg9M2RyqnKQl+//7PABbk=
X-Google-Smtp-Source: ABdhPJzjVo7e2qrmUbNkeL2htyp8gE3ptwnN+rocneGeMxNszSiqfQmZvPVecIgxWwjPCwx68Brb+g==
X-Received: by 2002:a63:2bc1:0:b0:35e:c54b:3be0 with SMTP id r184-20020a632bc1000000b0035ec54b3be0mr16632074pgr.105.1646790411123;
        Tue, 08 Mar 2022 17:46:51 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o185-20020a6341c2000000b0036fb987b25fsm358271pga.38.2022.03.08.17.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 17:46:50 -0800 (PST)
Date:   Tue, 8 Mar 2022 17:46:47 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Divya.Koppera@microchip.com, netdev@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220309014647.GB24366@hoboy.vegasvil.org>
References: <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YifoltDp4/Fs+9op@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 12:36:54AM +0100, Andrew Lunn wrote:

> I'm assuming the ptp protocol does not try to measure the cable delay,
> since if it did, there would be no need to know the RJ45-PHY delay, it
> would be part of that.

The PTP does indeed measure the cable delay.  With a well tuned
system, you can tell the copper cable length directly from the
measured delay.

The problem with uncorrected PHY time stamps is that they affect the
boundary point between the node and the network.  A static error there
will create a path asymmetry that can neither be measured nor
corrected by the PTP, and a variable error degrades the time signal.


Thanks,
Richard
