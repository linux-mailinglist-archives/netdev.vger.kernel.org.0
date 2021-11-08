Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7C449CF6
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 21:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbhKHUR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbhKHURz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 15:17:55 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF1DC061570;
        Mon,  8 Nov 2021 12:15:10 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id w1so67810214edd.10;
        Mon, 08 Nov 2021 12:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8hCp0Yi013+SXOBGMII9NEQdigdtayFGncxyaM4jIM4=;
        b=NtcWbaUhYgGdBg6mioYp2iws0YVSiZ6Y3TYYAJ3Afd0WGwjUGunpc4z2AbpViW0e/m
         cpqaQ/DphMPS4kVi1LXPlsWci+m3IUW6bZmxbu2oM+A7I4ugreE1M934XkzpAf6PQSRh
         V5BtBoUjUV3Q+IM+lzLdTMm0EiTOheFz7bXHHsCsGJbULQoNP2AXijl/7zzsLvnmA960
         UmeV2+HKg5BgdlJnOIHpaaGBJ193lFvEEaI2tCaEBcpobPI3pffylk3nxqf0gAjmuMYt
         B+EfayM7X8OFFZTTkCSqFRd3GoStEIaw0//D7rEqPYrjQcT+t5/1xyvajYSqm6RnUBTx
         HHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8hCp0Yi013+SXOBGMII9NEQdigdtayFGncxyaM4jIM4=;
        b=X2k9bdwgKPcx9HgONp3FqIQ4A8Pa0V0abou51KvnXM0b7yvs1PvhXF8IrGsYDdu53o
         rfUeBK9AOOeAxMC+l19nVHPXnaKygYrCivHR7zXlWXT3BF9R/p6PnOhGZ9mJlGaaUYF1
         tv3dHcdzdVRQdrehtkbtUB7j6Ft2FOlC65RoJKH5HLBj2juyb00syTOwWZoXvQTOgkR4
         tywr3cDk8G4dFKag7I+A1N3F3wfGPr3OlWDzReoxyBh6vD2YS954XfrIv1WccZgaEmJN
         xIYuNorUt4Aus1JO1lG+AkY4LS60RhyAUkmiQ0bAg56lC/6N7ShZJ17xlgQrcizliUC5
         AkIQ==
X-Gm-Message-State: AOAM533Oy0T1k1FwmIYH0TNi3YApJQr6Do0CD5uJ8mieHK84e7S1j1/1
        4DP1R96k7SjMxJlIV30XV40=
X-Google-Smtp-Source: ABdhPJwgLh3pp6rjDCkz7vMLuXr340hWSieme+bN4nI8u/VVXEo2IWGVBIJa4dSWAb2wi8Of+XjsBA==
X-Received: by 2002:a17:906:d20c:: with SMTP id w12mr2245175ejz.521.1636402509437;
        Mon, 08 Nov 2021 12:15:09 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id e1sm4818381ejy.82.2021.11.08.12.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 12:15:08 -0800 (PST)
Date:   Mon, 8 Nov 2021 21:15:06 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <YYmFSsQ9Iz7DDXb0@Ansuel-xps.localdomain>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
 <YYkuZwQi66slgfTZ@lunn.ch>
 <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
 <20211108171312.0318b960@thinkpad>
 <YYliclrZuxG/laIh@lunn.ch>
 <20211108185637.21b63d40@thinkpad>
 <YYmAQDIBGxPXCNff@lunn.ch>
 <20211108211110.4ad78e41@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211108211110.4ad78e41@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 09:11:10PM +0100, Marek Behún wrote:
> On Mon, 8 Nov 2021 20:53:36 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > > I guess I will have to work on this again ASAP or we will end up with
> > > solution that I don't like.
> > > 
> > > Nonetheless, what is your opinion about offloading netdev trigger vs
> > > introducing another trigger?  
> > 
> > It is a solution that fits the general pattern, do it in software, and
> > offload it if possible.
> > 
> > However, i'm not sure the software solution actually works very well.
> > At least for switches. The two DSA drivers which implement
> > get_stats64() simply copy the cached statistics. The XRS700X updates
> > its cached values every 3000ms. The ar9331 is the same. Those are the
> > only two switch drivers which implement get_stats64 and none implement
> > get_stats. There was also was an issue that get_stats64() cannot
> > perform blocking calls. I don't remember if that was fixed, but if
> > not, get_stats64() is going to be pretty useless on switches.
> > 
> > We also need to handle drivers which don't actually implement
> > dev_get_stats(). That probably means only supporting offloads, all
> > modes which cannot be offloaded need to be rejected. This is pretty
> > much the same case of software control of the LEDs is not possible.
> > Unfortunately, dev_get_stats() does not return -EOPNOTSUPP, you need
> > to look at dev->netdev_ops->ndo_get_stats64 and
> > dev->netdev_ops->ndo_get_stats.
> > 
> > Are you working on Marvell switches? Have you implemented
> > get_stats64() for mv88e6xxx? How often do you poll the hardware for
> > the stats?
> > 
> > Given this, i think we need to bias the API so that it very likely
> > ends up offloading, if offloading is available.
> 
> I am working with Marvell PHYs and Marvell switches. I am aware of the
> problem that SW netdev does not work for switches because we don't have
> uptodate data.
> 
> It seems to me that yes, if the user wants to blink the LEDs on
> activity on switch port, the netdev trigger should only work in offload
> mode and only on LEDs that are connected to switch pins, unless we
> implement a mechanism to get statistics at lest 10 times a second
> (which could maybe be done on marvell switches by reading the registers
> via ethernet frames instead of MDIO).
> 
> Marvell switches don't seem to support rx only / tx only activity
> blinking, only rx/tx. I think this could be solved by making rx/tx
> sysfs files for netdev trigger behave so that writing to one would also
> write to another.
> 
> But since currently netdev trigger does not work for these switches, I
> think making it so that it works at least to some fashion (in HW
> supported modes) would still be better that current situation.
> 
> I will try to look into this, maybe work together with Ansuel.
> 
> Marek

I'm polishing some api with Andrew comments and will try to extend
netdev trigger while still proposing the additional trigger. Better
discuss in v3.
I think the main target here is first have a good generic solution for
offload and then actually thinking about working on the triggers/offload
part.

-- 
	Ansuel
