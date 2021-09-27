Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A993F419647
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhI0O1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234706AbhI0O1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 10:27:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 131B7610A2;
        Mon, 27 Sep 2021 14:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632752766;
        bh=4zbOOUtxrR7msPE48PHiPXzfw63aLKDTKDuaRxP+2oU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vPBYw+GuINRrTLt22ZYAHpxTNP7FA5ARycV+ZzEa1EP79kpg4cVjoLL4/NWUrshlY
         WCY3yM2nDl3S1C9vJQpCPjL6K0PKA2VXzi37K16/AY+dHfSw7cucSNOdlgZEGaXoOU
         nsNZUkCy/YEoPFmxrh+pnKx+drfGMUsMDcRZAI5ra+XjtTgq9tpyM10KzNectkVOxh
         y0kgceeLGunHKdpPnrBLbMSLolqb8UW+3X+RjIAZkygtPkCuyCblfkefuphc5oC8LO
         Vcgb98S/l4zlPO+m3zLGxN60RI4ThYWK0XhiAZN/g/JapI61O7wctspgbgg8Znsbun
         AnHWoIq+o7HZA==
Date:   Mon, 27 Sep 2021 07:26:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] nfc: avoid potential race condition
Message-ID: <20210927072605.45291daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <81b648d2-0e20-e5ac-e2ff-a1b8b8ea83a8@canonical.com>
References: <20210923065051.GA25122@kili>
        <3760c70c-299c-89bf-5a4a-22e8d564ef92@canonical.com>
        <20210923122220.GB2083@kadam>
        <47358bea-e761-b823-dfbd-cd8e0a2a69a6@canonical.com>
        <20210924131441.6598ba3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <81b648d2-0e20-e5ac-e2ff-a1b8b8ea83a8@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Sep 2021 09:44:08 +0200 Krzysztof Kozlowski wrote:
> On 24/09/2021 22:14, Jakub Kicinski wrote:
> > On Fri, 24 Sep 2021 10:21:33 +0200 Krzysztof Kozlowski wrote:  
> >> Indeed. The code looks reasonable, though, so even if race is not really
> >> reproducible:
> >>
> >> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>  
> > 
> > Would you mind making a call if this is net (which will mean stable) or
> > net-next material (without the Fixes tags) and reposting? Thanks! :)  
> 
> Hi Jakub,
> 
> Material is net-next. However I don't understand why it should be
> without "Fixes" in such case?
> 
> The material going to current release (RC, so I understood: net), should
> fix only issues introduced in current merge window. Linus made it clear
> several times.

Oh, really? I've never heard about this rule, would you be able to dig
up references?

This strikes me as odd, most fixes we merge are for previous releases.
In fact when I write -rc pull requests to Linus I break them down by
current release vs previous - and he never complained.

> The issue here was introduced long time ago, not in current merge
> window, however it is still an issue to fix. It's still a bug which
> should have a commit with "Fixes" for all the stable tress and
> downstream distros relying on stable kernels. Also for some statistics
> on LWN.

Stable will not pull the commit from net-next, tho. Stable is more
restrictive than rc (or at least so I think) so "we want it in stable,
please merge it to net-next" does not compute with the preconceptions 
I have.
