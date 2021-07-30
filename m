Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA4A3DBD6D
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 18:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhG3Q7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 12:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229761AbhG3Q7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 12:59:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BCC760F26;
        Fri, 30 Jul 2021 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627664377;
        bh=cOLEvzJm4g+6qRVVkQkfRg19xYWm3jDS20NZilYCN3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f8xKZAt5FZbNa1tPxRVNm9kPXYbjN9hfiPZu3jPWtQPtVrzo+SbMNh7wzH1s0jrc8
         tUU8oA2iZOsuMGGKdpFbwWTTe3v10n7sxtNEsLjn67CmN9Ox2VEd82JuCv8QC2G9el
         oCvxEKQ66Ah/PvRWL13jD54y4/2KfoAnIHFfkYNFNc9lLd8Toyo6efN6hHZu0a3Dhe
         nQpAb988Ji6g17V8kVojAE4i/l5PgS7Zv/EOqELT71wZqt8eBVIHzM8pQ9hhEuVfLl
         K0dUQtBjnliuSR0pRICpnImjvGHR9YMQODS6+Wv+K2F5/dbKIHRoTeG05Sy2biaD3A
         M65NKao8oUzCg==
Date:   Fri, 30 Jul 2021 09:59:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steve Bennett <steveb@workware.net.au>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: Fix detection of ksz87xx switch
Message-ID: <20210730095936.1420b930@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210730105120.93743-1-steveb@workware.net.au>
References: <20210730105120.93743-1-steveb@workware.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please extend the CC list to the maintainers, and people who
worked on this driver in the past, especially Marek.

On Fri, 30 Jul 2021 20:51:20 +1000 Steve Bennett wrote:
> The previous logic was wrong such that the ksz87xx
> switch was not identified correctly.

Any more details of what is happening? Which extact device do you see
this problem on?

I presume ksz87xx devices used to work and gotten broken - would you
mind clarifying and adding a Fixes tag to help backporting to the
correct stable branches?

> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 4d53886f7d51..a4acec02c8cb 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -401,11 +401,11 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
>  }
>  
>  static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
> -					    const u32 ksz_phy_id)
> +					    const u32 ksz_8051)

bool and use true/false in the callers?

