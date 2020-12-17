Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AD72DD5B3
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgLQRHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbgLQRHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 12:07:33 -0500
Date:   Thu, 17 Dec 2020 09:06:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608224812;
        bh=JCgs6Gbs/ppNLtmihKsU7u8Ehtj1qIyP3rFDBAXBx54=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=rdWG7XtYC2PM50mhm0SpxcNAJs2LPfnM4y9f5Rt7Yq5RZFZGcwMcxjCAYWAvN0oot
         Hp06QoTV+L/0jeGpUTUuitDcrmLffUiiIjc7MSkBnNmiXZ0Rn27pK/ij/Z8HT91OkV
         0nRxcqgJvDP04e7uW3H7WCmc8SNnP8w3gcyFOa1zySWTzNt7vJ1UB655OVAzofVDup
         ReSnGqq2H/AUIe8pOid3b16CCCnIpQuS9G0EZJzV3Av88hwvgQ5HkppmR75JFyCZ6r
         OnqRmFnfs0l948811405P8A8/0ntJR02zVWE++8sSRkhkPVy+QgdFX1dK7c2uXtIpa
         FhGMl6Pt93ArQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v8 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20201217090651.0912a035@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dleftjv9d07iz2.fsf%l.stelmach@samsung.com>
References: <20201216081300.3477c3fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20201217114714eucas1p1aea2208877de2a39feb692fe795e6d3e@eucas1p1.samsung.com>
        <dleftjv9d07iz2.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 12:46:57 +0100 Lukasz Stelmach wrote:
> > to the correct values so the stack pre-allocates the needed spaces,
> > when it can.  
> 
> Yes, I fonud these. However, I am not sure setting needed_tailroom has
> any effect. In many places where alloc_skb() is called needed_headrom
> and hard_header_len are refered to via the LL_RESERVED_SPACE macro. But
> the macro does not refer to needed_tailroom. Once (f5184d267c1a ("net:
> Allow netdevices to specify needed head/tailroom") there was
> LL_ALLOCATED_SPACE macro, but but it was removed in 56c978f1da1f ("net:
> Remove LL_ALLOCATED_SPACE"). And now only some protocols refer to
> needet_tailroom.

Yeah, tailroom is used a lot less often. Only really crappy HW requires
it.

> BTW. What is hard_header_len for? Is it the length of the link layer
> header? Considering "my" hardware requires some headers with each
> packet, I find hard_headr_len name a bit confusing.

Yup, L2 headers, not hardware. Not sure why "hard" was chosen, that must
have happened way back.
