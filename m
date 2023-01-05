Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0E265F30C
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbjAERnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbjAERnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:43:47 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7593DBD0;
        Thu,  5 Jan 2023 09:43:46 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id u28so48965617edd.10;
        Thu, 05 Jan 2023 09:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mc995RQU5XcVA3doI/OYoladX0qBn8UtEeewhcjwF34=;
        b=BhREoBZ1b6ppPpjxkXwzDaeJK9Iom+vVDVR77VSEet7vQ8flZBR0/S4xAq2JexcreY
         eNuhC3y/IgtM7FEw2ildDeuSwsltSOaDnZbCD1c8uMlb0jz5tVkjSsGroOmxY0S8KuUw
         uqjnpSCUvmeA6gb5nNwEbE21/l5AGowd9FGBKUNyzcIIeyBGst/oplbZDyG30DkJpBp/
         IWwL/PUhTkGPppPZhBZzYxo+RLKHyeSNckMCTiEJEPBrwnGcX9m4tLhSAyTOr0jLTEvk
         vCgHeNrMeic6au8VuBKMcBq/c5e69Rorxx46fBNj0gUgKTRer4QPS9Ii3fbE5A2vwte4
         4pSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mc995RQU5XcVA3doI/OYoladX0qBn8UtEeewhcjwF34=;
        b=y8+SeaIPlc6VFTKM+lARGYmAIXy12iDXZkurv+MyA0cwxboejk0tIyn8n/102jSXNq
         mt1uFsdjTDCJfnTHigiiM3ZLounq0yjRWHG6nKUaYsOjyJYdltEtXL/lKZUvTH3QnOO2
         15G+YdoUDzJFfiMShGyAD5AfxRxzhSHiVPkcWThQ2Lx3CVcjqNZmWLV520jGTW/7LrlJ
         WAew9ydyW7RDYnktdsTLOWQo1T4sLGTIanaLqtd6y/yZxHUcsBrOpPH1Ew4RB9PD63gI
         OtYeD6Yljk+5hgnDSpq3QqsVHJ1+yxXifeaAdyXRaPevg0Enh0Rcjh2IGzjYewfWVcLG
         y6jw==
X-Gm-Message-State: AFqh2kqdGjZ3FkGMD0+R2yI31neoU3ADB4uKRsRMs4LPh71HN9ZnyrTJ
        eQPC1vOjLxlCOOsYkg96tkY=
X-Google-Smtp-Source: AMrXdXv+5cK8BNgrptRcJ95PrbdA/CwlWZJli9CYIhw65uTWfZG/FKbj71UxraHme/ipAtoI00yj7A==
X-Received: by 2002:aa7:cf94:0:b0:45c:834b:eb59 with SMTP id z20-20020aa7cf94000000b0045c834beb59mr55828713edx.36.1672940625319;
        Thu, 05 Jan 2023 09:43:45 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id m2-20020aa7d342000000b00488117821ffsm10379593edr.31.2023.01.05.09.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 09:43:45 -0800 (PST)
Date:   Thu, 5 Jan 2023 19:43:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <20230105174342.jldjjisgzs6dmcpd@skbuf>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <Y7bhctPZoyNnw1ay@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7bhctPZoyNnw1ay@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 02:40:50PM +0000, Russell King (Oracle) wrote:
> > If the PHY firmware uses a combination like this: 10GBASE-R/XFI for
> > media speeds of 10G, 5G, 2.5G (rate adapted), and SGMII for 1G, 100M
> > and 10M, a call to your implementation of
> > aqr107_get_rate_matching(PHY_INTERFACE_MODE_10GBASER) would return
> > RATE_MATCH_NONE, right? So only ETHTOOL_LINK_MODE_10000baseT_Full_BIT
> > would be advertised on the media side?
> 
> No, beause of the special condition in phylink that if it's a clause 45
> PHY and we use something like 10GBASE-R, we don't limit to just 10G
> speed, but try all interface modes - on the assumption that the PHY
> will switch its host interface.
> 
> RATE_MATCH_NONE doesn't state anything about whether the PHY operates
> in a single interface mode or not - with 10G PHYs (and thus clause 45
> PHYs) it seems very common from current observations for
> implementations to do this kind of host-interface switching.

So you mention commits
7642cc28fd37 ("net: phylink: fix PHY validation with rate adaption") and
df3f57ac9605 ("net: phylink: extend clause 45 PHY validation workaround").

IIUC, these allow the advertised capabilities to be more than 10G (based
on supported_interfaces), on the premise that it's possible for the PHY
to switch SERDES protocol to achieve lower speeds.

This does partly correct the last part of my question, but I believe
that the essence of it still remains. We won't make use of PAUSE rate
adaptation to support the speeds which aren't directly covered by the
supported_interfaces. Aren't we interpreting the PHY provisioning somewhat
too conservatively in this case, or do you believe that this is just an
academic concern?
