Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A353433EA
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCURtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCURtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:49:17 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B71C061574;
        Sun, 21 Mar 2021 10:49:16 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id hq27so17592262ejc.9;
        Sun, 21 Mar 2021 10:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cxmDAU8x+OReK7ClYXrwHtsmLJe/FvUE1XWeig1gzaE=;
        b=oJ6WyQtQYig5mMMjx97J7Zvx+sc1Dsfbd5+jafPgbY6OwD5RfkLUR8HHzimB5p757x
         KmYjmZ/27Dc231sCBHaanfJuha8naSrzSNIKV4uC6ImjAlU7ig3WVQ7UWq7yohhM0Khr
         gvyLkgr2SP9ERtklgAvu1KLkweOFVaiyJXslhPWACCR+L6TWMn20BHF3ogu5aaGVAWCl
         mabcTLvvH02b+OT+mTTfP3rWnDijDaFt/HDq8D3omKy/g9JolIm7LM5SD5phQ5Uj4sLh
         FAGY+9OPIMFD86Cfj0+a18Dw8u8P7oLz6yS5oFhTBFEZvYWmvV5amqKUKkh1Wx2fp97P
         NVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cxmDAU8x+OReK7ClYXrwHtsmLJe/FvUE1XWeig1gzaE=;
        b=U7D++iLX4K/NJFFYdGeljwbQn3JhZtKMoWZmHDWp2GSldhfXpjV1ZV+1Yzo5/6ZI0x
         Kay/pvJgUg7Xfiao0is45u43cfcJYs0CEKtpASONDxkiucv6XGl3AYwGFgPN99yUqUVE
         d+R9VJRmZ9nKtKDdQ9AsdEKQ7pPI3x13Zew6IbSBkZAELnUuMI8t5PzbfeScu+gnIthN
         fvJCKctnUmQBW0tUDz4QCQVi7+5yjp2mlQsXGkMRqd77PU+aMMbgYKZpxRiIdMvi01T/
         RsH6G8EWazeSZLwW5ePRMv19QyrWUDgsm8E1qHIem6QWiK+jXkT0X5O1QsaA/kGHnort
         DJXw==
X-Gm-Message-State: AOAM533ECrU74SrzCld8M+QDJQkODeiAywRFtx5tZcuPsSbj3jYuKpqO
        32UbDZgqWlIw7mFYE9lMv1o=
X-Google-Smtp-Source: ABdhPJxH3NEoJ5lFQxI+MDsEUqlm1U95CAxvQuZNdMTSaBWTnvNc8nvoDPuqHNUdbc9v2cNgV0lNLA==
X-Received: by 2002:a17:906:3b84:: with SMTP id u4mr15448640ejf.431.1616348955563;
        Sun, 21 Mar 2021 10:49:15 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id i1sm4567698ejh.94.2021.03.21.10.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 10:49:15 -0700 (PDT)
Date:   Sun, 21 Mar 2021 19:49:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: enetc: fix bitfields, we are clearing wrong bits
Message-ID: <20210321174914.q7qanecg5s6dvoz6@skbuf>
References: <20210321162500.GA26497@amd>
 <20210321174419.jiwfu2nsfyhlhllc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210321174419.jiwfu2nsfyhlhllc@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 07:44:19PM +0200, Vladimir Oltean wrote:
> On Sun, Mar 21, 2021 at 05:25:00PM +0100, Pavel Machek wrote:
> > Bitfield manipulation in enetc_mac_config() looks wrong. Fix
> > it. Untested.
> > 
> > Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> > 
> > diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> > index 224fc37a6757..b85079493933 100644
> > --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> > +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> > @@ -505,7 +505,7 @@ static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
> >  	if (phy_interface_mode_is_rgmii(phy_mode)) {
> >  		val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
> >  		val &= ~ENETC_PM0_IFM_EN_AUTO;
> > -		val &= ENETC_PM0_IFM_IFMODE_MASK;
> > +		val &= ~ENETC_PM0_IFM_IFMODE_MASK;
> >  		val |= ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
> >  		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
> >  	}
> > 
> > -- 
> > DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> > HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> 
> Fixes: c76a97218dcb ("net: enetc: force the RGMII speed and duplex instead of operating in inband mode")
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Note that for normal operation, the bug was inconsequential, due to the
> fact that we write the IF_MODE register in two stages, first in
> .phylink_mac_config (which incorrectly cleared out a bunch of stuff),
> then we update the speed and duplex to the correct values in
> .phylink_mac_link_up. Maybe loopback mode was broken.
> 
> Thanks!

I forgot to mention, target tree should be "net" and patch should be
queued up for stable.
