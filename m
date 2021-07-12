Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA263C62CC
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 20:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhGLSoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 14:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236017AbhGLSoE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 14:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DE80611CB;
        Mon, 12 Jul 2021 18:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626115275;
        bh=e//PfPkISlb21wssK1bjd4TW7DNOcSX1l1Av6v2WG+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c1xjBxYT38Be4lYoF3QXwQnD+SMr+rg6afZfryQrS0hBPVS/DklJVY08nPAVRJ8/9
         d0fyv4iiytXvr2OzTbXDakQNEZtiD4jpyfiStQJwaTUL8Rt/Uh8eAxdOVtuOQDjhoj
         ZFbay6aZ0rZDk419K82DI0RWixnK/F+WqeX0hyK0CJcFlPpUikxi/QBHBo42Yr1By4
         +gQGMU3eLY7lTx3ZUQki+Nwvf0mzPH+hTSLcWtA0YWX/QpSfhoeZqmKjWlHxP+Ef20
         TFVGSjyHwFuTLcUvEjEBx1YaSMkKjs3qxbDUqfo1JOCsbkW/OlclqgagbAUr2oZ7P/
         khBDK7uXuA0Gg==
Date:   Mon, 12 Jul 2021 11:41:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <alexandru.tachici@analog.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>
Subject: Re: [PATCH v2 4/7] net: phy: adin1100: Add ethtool get_stats
 support
Message-ID: <20210712114114.35d7771b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210712130631.38153-5-alexandru.tachici@analog.com>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
        <20210712130631.38153-5-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Jul 2021 16:06:28 +0300 alexandru.tachici@analog.com wrote:
> +static const struct adin_hw_stat adin_hw_stats[] = {
> +	{ "total_frames_error_count",		0x8008 },
> +	{ "total_frames_count",			0x8009, 0x800A }, /* hi, lo */
> +	{ "length_error_frames_count",		0x800B },
> +	{ "alignment_error_frames_count",	0x800C },
> +	{ "symbol_error_count",			0x800D },
> +	{ "oversized_frames_count",		0x800E },
> +	{ "undersized_frames_count",		0x800F },
> +	{ "odd_nibble_frames_count",		0x8010 },
> +	{ "odd_preamble_packet_count",		0x8011 },
> +	{ "false_carrier_events_count",		0x8013 },
> +};

Since this phy seems to implement a lot MAC stats would it make sense
to plumb thru the new ethtool API for PHYs (ethtool_eth_mac_stats etc.)
rather than let the same string proliferation problem spring up in
another section of the code?
