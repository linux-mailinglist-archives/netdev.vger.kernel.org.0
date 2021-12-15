Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C61147651A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 23:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhLOWBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 17:01:07 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:39444 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhLOWBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 17:01:06 -0500
Received: by mail-ot1-f42.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso26596080ots.6;
        Wed, 15 Dec 2021 14:01:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=c6UAbQUHh0bkbgJxZcIXfdq0YkmNnPRTN+bKL3wTqVE=;
        b=pgPppMykiCGkK2zynL6wlOIwGIpqIBQFOvY4+SdDnJzMu0wfWmLLeJEJV/iew/oj8c
         I1SMjIP43DrM3aLfHr1Ns2rRK9p0KSqrm4j6mwKknVE0stGXxnVUiYv10zvcOxlpcn30
         F7kpEoEp2ZpcdwoIicgJB4N+IYsENUnfSr6H8bJb1Gs8VpdQJsuPD4oU+TRsOBA6ZTLi
         FPp/4jzs3eKXBXtH3on5P2IPX268kAQSvdIeqV1zUMyKQ9yAzNICeZ/FUCJIiVJEqQTq
         Iku/Ge2ZRQ16poJ6N9oevHGHSy/uXRViFyZdIMwtG4k1oj3pkoZKMg79oU5rwGRZN0IQ
         klgA==
X-Gm-Message-State: AOAM530aOp13ya6wnMcH+zwx1XdhGPdRKRLAnro1QV+iuvGgS+/QN/K5
        E6Ig7OnFnsfH1TSRq0v/TA==
X-Google-Smtp-Source: ABdhPJzi1VlR+ywnlwkQqkC5KG28HperBuxf4J3TLrSNqTTA96sfQi7zRIPPudAX/GBAnpVnIBNS/Q==
X-Received: by 2002:a05:6830:2082:: with SMTP id y2mr10338584otq.15.1639605665874;
        Wed, 15 Dec 2021 14:01:05 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id x13sm673179oof.19.2021.12.15.14.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:01:05 -0800 (PST)
Received: (nullmailer pid 1916578 invoked by uid 1000);
        Wed, 15 Dec 2021 22:01:04 -0000
Date:   Wed, 15 Dec 2021 16:01:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree 2/2] dt-bindings: phy: Add
 `tx-amplitude-microvolt` property binding
Message-ID: <YbploCb6sJRN+HJH@robh.at.kernel.org>
References: <20211214233432.22580-1-kabel@kernel.org>
 <20211214233432.22580-3-kabel@kernel.org>
 <YbnJhI2Z3lwC3vF9@lunn.ch>
 <20211215182222.620606a0@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211215182222.620606a0@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 06:22:22PM +0100, Marek Behún wrote:
> On Wed, 15 Dec 2021 11:55:00 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Wed, Dec 15, 2021 at 12:34:32AM +0100, Marek Behún wrote:
> > > Common PHYs often have the possibility to specify peak-to-peak voltage
> > > on the differential pair - the default voltage sometimes needs to be
> > > changed for a particular board.  
> > 
> > Hi Marek
> > 
> > Common PHYs are not the only user of this. Ethernet PHYs can also use
> > it, as well as SERDESes embedded within Ethernet switches.
> > 
> > That is why i suggested these properties go into something like
> > serdes.yaml. That can then be included into Common PHY, Ethernet PHYs,
> > switch drivers etc.
> > 
> > Please could you make such a split?
> > 
> >        Andrew
> 
> Hi Andrew,
> 
> and where (into which directory) should this serdes.yaml file go?
> 
> My idea was to put the properties into common PHY and then refer to
> them from other places, so for example this would be put into ethernet
> PHY binding:
> 
>   serdes-tx-amplitude-microvolt:

Why do you need a different name here? 

>     $ref: '/schemas/phy/phy.yaml#/properties/tx-amplitude-microvolt'

This is a pattern I try to avoid generally. Put what's common in 1 
schema file and then reference all of it from the top level.

Rob
