Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B584F46CD73
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbhLHGLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhLHGLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:11:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916D1C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 22:08:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B225ECE1FD8
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827FBC00446;
        Wed,  8 Dec 2021 06:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638943695;
        bh=d3LlXX8NJyrxsgEpXv9SgC+XdfIj1Fuq7zmTjUDWtBA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gtZxhHEdSSAOaIsE0KdAsfTubiS9obqJcnsNPQGpVXD8nz9MPGDAZVec+k/Q0d/qm
         VJrV4LWmFpeaKJzJnizwOh1kjJmvkEIHji149SHGh5Y19SzOS971/TE95FXz3I14Po
         0ruO5vfe5lVk7/1IURpffJGB++cf1GLiCfZO9lG757nSlsuRT9NQaAkFC1hkYGHHtB
         ZarDOd+lOALWO7BBTYwEhrqfd+TKbf4Bmbi+mSnpIsy+8tv9TofNKvyAh61M/+VopC
         eEpGo/VWLIJznkrXrgki2KYXCCxMorAQndqNdP6BVKmsbREVIYH/GOb1CFIpmZuiR4
         bSeIYR89n1BiQ==
Date:   Tue, 7 Dec 2021 22:08:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAGS_UNSTABLE_PHC
Message-ID: <20211207220814.0ca3403f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208044224.1950323-2-liuhangbin@gmail.com>
References: <20211208044224.1950323-1-liuhangbin@gmail.com>
        <20211208044224.1950323-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Dec 2021 12:42:23 +0800 Hangbin Liu wrote:
> -	/* Reserved for future extensions */
> -	if (config->flags)
> -		return -EINVAL;

Should we do something like:

	if (config->flags & ~PHC_DRIVER_IGNORED_FLAGS)
		return -EINVAL;

Or whatnot? We still want the drivers to reject bits other than the new
flag.
