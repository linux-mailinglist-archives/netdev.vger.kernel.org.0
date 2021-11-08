Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE15C449CDA
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 21:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbhKHUFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbhKHUFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 15:05:51 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF646C061570;
        Mon,  8 Nov 2021 12:03:06 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j21so67052957edt.11;
        Mon, 08 Nov 2021 12:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gfAW25npFijObZczyeTtXuHr+HMG0py6gXu8Oe8aGbQ=;
        b=MASgWmxyfQR+VXm4faiVUYw7Hpp0SWGGzIwBC95c+422xytVdOdFS4qVwxvbnLBAHa
         reNEg1Rgm+iM5o6Z8+kRP26cmqQhXGFEjKCyYekOyilXjMjiwSnJzPcZmtlj+SdW9JT/
         TQTq4U65ObeWa7oGz944LwYscLqFZNDGh18t/u0ExDA5He+AzU82ZR/qE/n2xd40Uem2
         ZoAgTm7mhFDv1goDyvW54xkyJhQArcxD5u6zEYTfCe1U/WBvNXqvBCzBEqEEoDot6pdl
         Cr5P2dm3QCRMCK+E95nLcmSFOXJFnRZwqLSP5EnmBnX91wJygyOmzTNvaag8z3RVLxJL
         ea7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gfAW25npFijObZczyeTtXuHr+HMG0py6gXu8Oe8aGbQ=;
        b=Sr2KSq6K03RHQrMwQslM1GMGpUojan1woWXTTaQniyAlCMHoByAGOPRqJA22kBYSj7
         fXvh9iHFBgbWliV8u0ZrpCg3jqKHXUe0AnKnp+2MxmrLTmBY9TJWmm6G8GPH4Z+DyKtB
         4S+e0UQHzg1Axw3gUIgTAntK+h5A7nUVHOJ9cHdtpyUM1xHNa61od6MnoAawqCatNaD0
         PTNfWxvb4M2Dt8oEyRuugjPmAposxv4YvQmYIezyZ0vkG7qxCIzedQf4IWZb880ag93r
         eLx0Ent61iae2Gob3bdPQz9ZusrYOgtwqpbsIYc0Wt9D18HbN/WHpgj04ogMhm7zMSmP
         4C6w==
X-Gm-Message-State: AOAM533eOAiMNt3c+/B+tLwi7pWN2JOKiTaYbe+5feUOGt6PWdtoT5jc
        laSIiG6HNRLVhAjZvQ61Vhc=
X-Google-Smtp-Source: ABdhPJyr1gNI0uda0yXjXSsbfW3BBMV5yo4ctyCCmHiurclZHgyu/ngNGTcq+0SXtFGufhVLaqGAZA==
X-Received: by 2002:a05:6402:28e:: with SMTP id l14mr2298832edv.162.1636401785325;
        Mon, 08 Nov 2021 12:03:05 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id v6sm8243762edy.83.2021.11.08.12.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 12:03:04 -0800 (PST)
Date:   Mon, 8 Nov 2021 22:03:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <20211108200302.dusowlxfsb3e2sy3@skbuf>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
 <YYkuZwQi66slgfTZ@lunn.ch>
 <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
 <20211108171312.0318b960@thinkpad>
 <YYliclrZuxG/laIh@lunn.ch>
 <20211108185637.21b63d40@thinkpad>
 <YYmAQDIBGxPXCNff@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYmAQDIBGxPXCNff@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 08:53:36PM +0100, Andrew Lunn wrote:
> > I guess I will have to work on this again ASAP or we will end up with
> > solution that I don't like.
> > 
> > Nonetheless, what is your opinion about offloading netdev trigger vs
> > introducing another trigger?
> 
> It is a solution that fits the general pattern, do it in software, and
> offload it if possible.
> 
> However, i'm not sure the software solution actually works very well.
> At least for switches. The two DSA drivers which implement
> get_stats64() simply copy the cached statistics. The XRS700X updates
> its cached values every 3000ms. The ar9331 is the same. Those are the
> only two switch drivers which implement get_stats64 and none implement
> get_stats. There was also was an issue that get_stats64() cannot
> perform blocking calls. I don't remember if that was fixed, but if
> not, get_stats64() is going to be pretty useless on switches.

No it wasn't, I lost the interest.
I feel pretty uneasy hooking up .ndo_get_stats64() to my switches, and
basically opening the flood gates for random processes and kernel
threads to send SPI transactions back and forth like it's nothing.
Latency for programs like ptp4l and phc2sys is actually more important.

> 
> We also need to handle drivers which don't actually implement
> dev_get_stats(). That probably means only supporting offloads, all
> modes which cannot be offloaded need to be rejected. This is pretty
> much the same case of software control of the LEDs is not possible.
> Unfortunately, dev_get_stats() does not return -EOPNOTSUPP, you need
> to look at dev->netdev_ops->ndo_get_stats64 and
> dev->netdev_ops->ndo_get_stats.
> 
> Are you working on Marvell switches? Have you implemented
> get_stats64() for mv88e6xxx? How often do you poll the hardware for
> the stats?
> 
> Given this, i think we need to bias the API so that it very likely
> ends up offloading, if offloading is available.
> 
>      Andrew
> 

We could use some of the newer stats APIs exposed by Jakub if
.ndo_get_stats64 is not implemented, like ethtool_ops->get_eth_mac_stats.
Although.. see above.
