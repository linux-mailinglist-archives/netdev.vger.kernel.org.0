Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B232BC301
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 02:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgKVBg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 20:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbgKVBgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 20:36:47 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9066EC0613CF;
        Sat, 21 Nov 2020 17:36:45 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 62so10879693pgg.12;
        Sat, 21 Nov 2020 17:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WwAQohGmMP/UiMeBYoppGq4ywWWRc++yLHyyw6pljp0=;
        b=ZSvFuKzJDq20yV9cD8q3f5oL2uT1IoufooJHf4S1BwoXX3+/65ELeVjWDRUC0kT/QQ
         JwlTReGDDFOpxXbEFRhjzABXjQYme8/KQ/JXUiHSMATcUUzhfrbCQ1XQwJqZ3UcHsAnZ
         Ezxfn8vz9fWrSdBWAv75OMy+OEnp/7Ll++a2LrwQKy/Qy4Y8gwJdwqN/IfblXCZpvvbk
         ic5JWNtqxxt1fKMBM4XXxUWsMuNiFrJ8ZK4DfgigdJ2ZzlJ+KH2eRvTVBxfYhYWZF7QV
         Sm6y625IuFVFQKUlNIGST6oQ8AJHLsyhSOqaXxymv97c51c7fLt+BkE4mr58RABP3jfY
         aqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WwAQohGmMP/UiMeBYoppGq4ywWWRc++yLHyyw6pljp0=;
        b=lHyf/XGgYeKByuYzyeZz6WUhjcttOxrD1zKupct3QQ4KHr5YfIjPksD+hsQCiiI54Z
         vPbS1hJO05LarYdP5kUw5exk/+tILqQDZv6fzzXmSZQOCCsJSpZ5IDd06Sge2jCS4QW5
         3RhAvVxl+TPngcuNzVll29kTB1e1ggChUzBRx9Za2VoPLQmrGMdiYgk1NVACul0mQlpz
         hLxOUPP8qutXWbcZbgAnvSgVDgUtK8EzqzsSE1eQDtdQ4aZszS7TSZmzOP4SzpaZrHET
         wPNb2wPTm0SQNEJk4hDMGQ2FSYZDENPmS2wawP8A9nJ+V4Q4mbn1rmf7aCZwkDwiYia0
         0icQ==
X-Gm-Message-State: AOAM532SLnmBMu0bJ9WIJfSZ3/IXcwJJXVFNNktzgASLsCKVzY2DiJpJ
        5M1s15CvOfFgqRpdr/LP38k=
X-Google-Smtp-Source: ABdhPJyQFDu9Fztrd006rONVHW0ogMHQyAiT6BU48QCtukjh9oCOWHo1QiyagZOSIyt1pkLlZLIrZg==
X-Received: by 2002:a62:f20e:0:b029:197:f6d8:8d4d with SMTP id m14-20020a62f20e0000b0290197f6d88d4dmr2294937pfh.58.1606009004985;
        Sat, 21 Nov 2020 17:36:44 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id kb12sm8981106pjb.2.2020.11.21.17.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 17:36:43 -0800 (PST)
Date:   Sat, 21 Nov 2020 17:36:40 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tristram.Ha@microchip.com, ceggers@arri.de, kuba@kernel.org,
        andrew@lunn.ch, robh+dt@kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, kurt.kanzenbach@linutronix.de,
        george.mccollister@gmail.com, marex@denx.de,
        helmut.grohne@intenta.de, pbarker@konsulko.com,
        Codrin.Ciubotariu@microchip.com, Woojung.Huh@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for
 KSZ956x
Message-ID: <20201122013640.GA997@hoboy.vegasvil.org>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118234018.jltisnhjesddt6kf@skbuf>
 <2452899.Bt8PnbAPR0@n95hx1g2>
 <BYAPR11MB35582F880B533EB2EE0CDD1DECE00@BYAPR11MB3558.namprd11.prod.outlook.com>
 <20201121012611.r6h5zpd32pypczg3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121012611.r6h5zpd32pypczg3@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 03:26:11AM +0200, Vladimir Oltean wrote:
> On Thu, Nov 19, 2020 at 06:51:15PM +0000, Tristram.Ha@microchip.com wrote:
> > The receive and transmit latencies are different for different connected speed.  So the
> > driver needs to change them when the link changes.  For that reason the PTP stack
> > should not use its own latency values as generally the application does not care about
> > the linked speed.
> 
> The thing is, ptp4l already has ingressLatency and egressLatency
> settings, and I would not be surprised if those config options would get
> extended to cover values at multiple link speeds.
> 
> In the general case, the ksz9477 MAC could be attached to any external
> PHY, having its own propagation delay characteristics, or any number of
> other things that cause clock domain crossings. I'm not sure how feasible
> it is for the kernel to abstract this away completely, and adjust
> timestamps automatically based on any and all combinations of MAC and
> PHY. Maybe this is just wishful thinking.

The idea that the driver will correctly adjust time stamps according
to link speed sounds nice in theory, but in practice it fails.  There
is a at least one other driver that attempted this, but, surprise,
surprise, the hard coded correction values turned out to be wrong.

I think the best way would be to let user space monitor the link speed
and apply the matching correction value.  That way, we avoid bogus,
hard coded values in kernel space.  (This isn't implemented in
linuxptp, but it certainly could be.)

Thanks,
Richard
