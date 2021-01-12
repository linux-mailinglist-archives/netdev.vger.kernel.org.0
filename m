Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3552F3D6C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406937AbhALVin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437162AbhALVbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:31:32 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172ECC061786
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:30:52 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id w1so19775ejf.11
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PJd0ALgVMcSWNszhOrAdVjODXiGkl3GLwoN6F+nTFS0=;
        b=h181h1pgrfaX5SQu48R8Sa4JEwUHapAmjpqm80xhrdBVegAT9U6o8tRnP/1AlYEfv+
         0DUPu8z2Aq4nvDnyIdPd3RdxQlLivYEHzK1rPWqhMK7+NjFX5UcmeyNiEjsRk3axmd0Y
         8w0vmvgoz4WqFvh3qnn6HQq6hbCpvKI8Eglt9ZYqrX5m6Wnc10y7AivUtiKxS7rYenYL
         JD/l2LZBbyf5o4reCUSAUoJzMIVPU1xNowCsVYwGLiKycMxiXt8xxkKSgau2/ypBuZnS
         IRv/+AFkG75XfDicl2jqLli0MAIlkGmGUR2hnqHorvpCpRudWYvqLheikjvtKzxULLPA
         cMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PJd0ALgVMcSWNszhOrAdVjODXiGkl3GLwoN6F+nTFS0=;
        b=lJ7PZLadTcJXMf0lP/wg6YEXhn8qNt1m5Os1aGn0qXXxOe8hSCprseihSSrL9RWAlf
         Ybst2RDC6xP3JTRQKb5tnSgrWIV+ds6c8EHxW9xn1X41JLRmE6Vtj/db5zZxQjJ6TCLo
         gDyGOdcCFomnrkT4lFdEe+9GRy/EmpQRtRAFzbgRf43j4yu/nXMJZJdrlPy+t7Zll3Ga
         GibYGot9ib9jaFTREAxgHj+KoXc0nRGaNN4wceuKEIRCAJvKWktmlSZRa99TH+PAPXE3
         SXFrm1SU89ueHMHzmVrEkPiBvehELBvjlONwjMxOY4czKS3PZT7lw1aI4vgAUJSP1wgU
         kgaw==
X-Gm-Message-State: AOAM531Nv81ac6GgO9mD+5yn7AIoyNCPLMlIXsmIaqd1gE0IjcMnLmX1
        9+8Zn26G1SQdkfv6/LCr3qM=
X-Google-Smtp-Source: ABdhPJzEuKVUGrhIGDFeC9yT1CXlfFyJN1pxpzSHOP3iYd6bFZuD2uSZ3FcrhKMxK9bmQmilfX9MHw==
X-Received: by 2002:a17:906:941a:: with SMTP id q26mr573462ejx.266.1610487050797;
        Tue, 12 Jan 2021 13:30:50 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id ak17sm1699104ejc.103.2021.01.12.13.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 13:30:50 -0800 (PST)
Date:   Tue, 12 Jan 2021 23:30:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v15 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112213048.grqrqx4imgbypmdh@skbuf>
References: <20210112195405.12890-1-kabel@kernel.org>
 <20210112195405.12890-6-kabel@kernel.org>
 <20210112203808.4mkryi3tcut7mvz7@skbuf>
 <20210112221632.611c8a7e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210112221632.611c8a7e@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 10:16:32PM +0100, Marek Behún wrote:
> On Tue, 12 Jan 2021 22:38:08 +0200
> Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > > +		phylink_set(mask, 10000baseT_Full);
> > > +		phylink_set(mask, 10000baseCR_Full);
> > > +		phylink_set(mask, 10000baseSR_Full);
> > > +		phylink_set(mask, 10000baseLR_Full);
> > > +		phylink_set(mask, 10000baseLRM_Full);
> > > +		phylink_set(mask, 10000baseER_Full);
> > 
> > Why did you remove 1000baseKR_Full from here?
> 
> I am confused now. Should 1000baseKR_Full be here? 10g-kr is 10g-r with
> clause 73 autonegotiation, so they are not compatible, or are they?

ETHTOOL_LINK_MODE_10000baseKR_Full_BIT and most of everything else from
enum ethtool_link_mode_bit_indices are network-side media interfaces
(aka between the PHY and the link partner).

Whereas PHY_INTERFACE_MODE_10GKR and most of everything else from
phy_interface_t is a system-side media independent interface (aka
between the MAC and the PHY).

What the 6393X does not support is PHY_INTERFACE_MODE_10GKR, and my
feedback from your previous series did not ask you to remove
1000baseKR_Full from phylink_validate. There's nothing that would
prevent somebody from attaching a PHY with a different (and compatible)
system-side SERDES protocol, and 10GBase-KR on the media side.

What Russell said is that he's seriously thinking about reworking the
phylink_validate API so that the MAC driver would not need to sign off
on things it does not care about (such as what media-side interface will
the PHY use, of which there is an ever increasing plethora). But at the
moment, the API is what it is, and you should put as many media-side
link modes as possible, at the given speed and duplex that the MAC
supports.

_I_ am confused. What did you say you were happy to help with?
