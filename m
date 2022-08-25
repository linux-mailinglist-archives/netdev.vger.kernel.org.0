Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAD85A1D56
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243526AbiHYXpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244131AbiHYXpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:45:35 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578F0BCC1A;
        Thu, 25 Aug 2022 16:45:32 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x93so57196ede.6;
        Thu, 25 Aug 2022 16:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=0iK/pr4xLo47HopX4u5r1hckwLvpwxEltSBciwBAkLw=;
        b=F40/IIhXL+okTAOvuMUTbRHs1eRxX4jt1qHNsfhzL/qyEdMeNr6n+MwIh4ud5gzQOx
         ebIq6oVnsWYA+vFz5MBM230qyweOAw/JK2iPqBy5uS2k+EVsRtCAdPkD6IDaV98+l/3b
         HOjkQyUmzPsYh8D5Z6niQuMNmvz0hlSGg5JBG+pFkhFSaRk1kCO6uttZWhStt5VAKCgL
         CVCND+VQJSt+ih9iXWQR5h94gJS4AGkD2N0Tct07n7ux8D043IjWj4PFSIg4F0J6c3Xk
         HGVi0A6U7EXE4PgaogBrGUS0tHkuiNgoLnb1pQS5IONWP9AW234mo6miR9O3wXzNDG91
         3yTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0iK/pr4xLo47HopX4u5r1hckwLvpwxEltSBciwBAkLw=;
        b=KAjXBuA2dLbOztb6YglSQqG9yxkbXJUS0kXx2LiadqX2OvGFCQuxHG1AvQLDu8bSfu
         MOIDbE3Ii8LvDpscDWofftNTd2bjFTmlXdpUFRIHxP21E349zhgDBUefreCvUzzUwgBr
         puef1/3Tp23gVw0DPi6ADqOEhzQLUm/lHwEeTTBZT4k9hOECUcC2lcgebwwoTGD7eskr
         4EaKMjCbwf/TZlLUX+jiqD4lWMv0wYgUexuyMynGmebdTxQVwjhNkj0HVO/SWeSjuTSE
         e6X91We30bIgZVfG06yECU8GlpMvf0MLY5alivMplzl/MAkYM0YPzXvvCfaGBtAPYkQK
         HBFg==
X-Gm-Message-State: ACgBeo1T0Xn0RDZNgS73pplXHSkQRg/rhWK3FGVEsLUGz7MY3CSOwLk0
        p2A4oK8FI8KGJnYbzGDgSQM=
X-Google-Smtp-Source: AA6agR6uBX8x4bxD0y+4dlwc6pOEoMy9eIA5OmWNt07mWOfaHlCuXhEXd1OGurb5rZ3u7SmCNzcEOQ==
X-Received: by 2002:a05:6402:5106:b0:440:3693:e67b with SMTP id m6-20020a056402510600b004403693e67bmr5030743edd.226.1661471129803;
        Thu, 25 Aug 2022 16:45:29 -0700 (PDT)
Received: from skbuf ([188.27.185.241])
        by smtp.gmail.com with ESMTPSA id b23-20020a17090630d700b007317f017e64sm205036ejb.134.2022.08.25.16.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 16:45:29 -0700 (PDT)
Date:   Fri, 26 Aug 2022 02:45:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] net: phy: Add 1000BASE-KX interface mode
Message-ID: <20220825234526.f6pjq56sab4pm6u4@skbuf>
References: <20220725153730.2604096-3-sean.anderson@seco.com>
 <20220818165303.zzp57kd7wfjyytza@skbuf>
 <8a7ee3c9-3bf9-cfd1-67ab-bb11c1a0c82a@seco.com>
 <35779736-8787-f4cb-4160-4ff35946666d@seco.com>
 <20220818171255.ntfdxasulitkzinx@skbuf>
 <cfe3d910-adee-a3bf-96e2-ce1c10109e58@seco.com>
 <20220818195151.3aeaib54xjdhk3ch@skbuf>
 <b858932a-3e34-7365-f64b-63decfe83b41@seco.com>
 <68b28596-cd16-2485-87df-b659060b0b0b@seco.com>
 <68b28596-cd16-2485-87df-b659060b0b0b@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b28596-cd16-2485-87df-b659060b0b0b@seco.com>
 <68b28596-cd16-2485-87df-b659060b0b0b@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 06:50:23PM -0400, Sean Anderson wrote:
> > The problem is that our current model looks something like
> > 
> > 1. MAC <--               A              --> phy (ethernet) --> B <-- far end
> > 2. MAC <-> "PCS" <-> phy (serdes) --> C <-- phy (ethernet) --> B <-- far end
> > 3.                                --> C <-- transciever    --> B <-- far end
> > 4.                                -->           D                <-- far end
> > 
> > Where 1 is the traditional MAC+phy architecture, 2 is a MAC connected to
> > a phy over a serial link, 3 is a MAC connected to an optical
> > transcievber, and 4 is a backplane connection. A is the phy interface
> > mode, and B is the ethtool link mode. C is also the "phy interface
> > mode", except that sometimes it is highly-dependent on the link mode
> > (e.g. 1000BASE-X) and sometimes it is not (SGMII). The problem is case
> > 4. Here, there isn't really a phy interface mode; just a link mode.
> >
> > Consider the serdes driver. It has to know how to configure itself.
> > Sometimes this will be the phy mode (cases 2 and 3), and sometimes it
> > will be the link mode (case 4). In particular, for a link mode like
> > 1000BASE-SX, it should be configured for 1000BASE-X. But for
> > 1000BASE-KX, it has to be configured for 1000BASE-KX. I suppose the
> > right thing to do here is rework the phy subsystem to use link modes and
> > not phy modes for phy_mode_ext, since it seems like there is a
> > 1000BASE-X link mode. But what should be passed to mac_prepare and
> > mac_select_pcs?
> > 
> > As another example, consider the AQR113C. It supports the following
> > (abbreviated) interfaces on the MAC side:
> > 
> > - 10GBASE-KR
> > - 1000BASE-KX
> > - 10GBASE-R
> > - 1000BASE-X
> > - USXGMII
> > - SGMII
> > 
> > This example of what phy-mode = "1000base-kx" would imply. I would
> > expect that selecting -KX over -X would change the electrical settings
> > to comply with clause 70 (instead of the SFP spec).
> 
> Do you have any comments on the above?

What comments do you expect? My message was just don't get sidetracked
by trying to tackle problems you don't need to solve, thinking they're
just there, along the way.

"The problem" of wanting to describe an electrical using phy-mode was
discussed before, with debatable degrees of success and the following
synopsis:

| phy_interface_t describes the protocol *only*, it doesn't describe
| the electrical characteristics of the interface.  So, if we exclude
| the electrical characteristics of SFI, we're back to 10GBASE-R,
| 10GBASE-W, 10GFC or 10GBASE-R with FEC.  That's what phy_interface_t
| is, not SFI.
|
| So, I propose that we add 10GBASE-R to the list and *not* SFI.

https://lore.kernel.org/netdev/20191223105719.GM25745@shell.armlinux.org.uk/

I don't have access to 802.3 right now to double check, but I think this
is a similar case here - between 1000Base-SX and 1000Base-KX, only the
PMA/PMD is different, otherwise they are still both 1000Base-X in terms
of protocol/coding.

As for the second "example". I had opened my copy of the AQR113C manual
and IIRC it listed 10GBASE-KR in the system interfaces, but I don't
recall seeing 1000Base-KX. And even for 10GBASE-KR, there weren't a lot
of details, like what is configurable about it, is there C73 available etc.
Not extremely clear what that is about, tbh. Something that has
10GBase-KR on system side and 10GBase-T on media side sounds like a
media converter to me. Not sure how we model those in phylib (I think
the answer is we don't).
