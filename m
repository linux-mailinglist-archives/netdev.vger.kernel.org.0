Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E27D2F1EB5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390699AbhAKTLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:11:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387783AbhAKTLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 14:11:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65E1522AED;
        Mon, 11 Jan 2021 19:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610392232;
        bh=UHHxfrHWzfueplXxevdOeF1oVMkFG+ZlbpjRhO/ulPY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lvc37j+Ml0dvjwNywO5/jlU169QBD5fD0jZ/Aa1Y4n8AtNI/anytOP+aXRrq+jPC5
         RrhTvPABmLDMO5mwFhP1GE8BTtKZ93RmGkWhYP5N6iji3K0kOHsb94PwdmZ5CbT1YE
         bua3DiFw0S9ZngFdIyx+qKvBcLPh0DWf5YZqwTlwmfuOeukneBRRCuQPUuD4ljlWPo
         laS+F55cC4DEL3ZPRFE0EMoF+YaLUikgv7+YTFu9RGazLuGBnqs/zdsRHn/qw6ZOap
         s29kNSUJuxUtNsERsIruWfJUNZfblbjRurmyLnycrcZ5/96AX+ia56ICzTgfPwNKAz
         LnwPiymHMCwVA==
Date:   Mon, 11 Jan 2021 11:10:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 02/10] net: mscc: ocelot: add ops for
 decoding watermark threshold and occupancy
Message-ID: <20210111111031.136b7522@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111165321.p5v5y4btwohl4hc6@skbuf>
References: <20210108175950.484854-1-olteanv@gmail.com>
        <20210108175950.484854-3-olteanv@gmail.com>
        <20210109172046.635e4456@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210111165321.p5v5y4btwohl4hc6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 18:53:21 +0200 Vladimir Oltean wrote:
> On Sat, Jan 09, 2021 at 05:20:46PM -0800, Jakub Kicinski wrote:
> > On Fri,  8 Jan 2021 19:59:42 +0200 Vladimir Oltean wrote:  
> > > +	*inuse = (val & GENMASK(23, 12)) >> 12;  
> > 
> > FWIW FIELD_GET()  
> 
> Do you mind if I don't use it? I don't feel that:
> 	*inuse = FIELD_GET(GENMASK(23, 12), val);
> looks any better.

Not at all, your call.
