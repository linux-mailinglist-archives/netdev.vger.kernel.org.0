Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1F9482044
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242093AbhL3U2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242088AbhL3U2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 15:28:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9D4C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:28:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8851B81D14
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E760C36AE7;
        Thu, 30 Dec 2021 20:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640896087;
        bh=sWiuHsWIwIlwWdFNGpoSb2jIAq3+0wIXrBqV7zWcuYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P3SRb0GM2FPKqZvQL9mTp7s/Zo3TRU0wK6VEWq9SMFFbcEdnDhCcQYvy5YwUSs8Wj
         yaReCC9AGVSp7/8qhE2x7LazyhXEZf1dGA+xWNyR/QJhmuFxg335qaexzPA01mfLnP
         LyfH9RoQq+9DN0rQGZyavwrmuqrBkCMV3DY0la2tdJSjHuGI+6FbY/BhIs6v0i2B0L
         wMPZRwWS4IFQZVkkrph+M/QPzOcq00ONPMipmqQag2s02SFbBLCmM5gtPC/jLMBczq
         qWDrc7xCi8qZNhqLBysvEEYFx+ys9S93KmHO31OORV7jr5pn/RlrKF27sWrmPSdjnq
         sYQMqDOuuJgcA==
Date:   Thu, 30 Dec 2021 12:28:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
Message-ID: <20211230122806.26b30fe8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230163909.160269-5-dmichail@fungible.com>
References: <20211230163909.160269-1-dmichail@fungible.com>
        <20211230163909.160269-5-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Dec 2021 08:39:05 -0800 Dimitris Michailidis wrote:
> +static const char mac_rx_stat_names[][ETH_GSTRING_LEN] = {
> +	"mac_rx_octets_total",
> +	"mac_rx_octets_ok",
> +	"mac_rx_frames_total",
> +	"mac_rx_frames_ok",
> +	"mac_rx_VLAN_frames_ok",
> +	"mac_rx_unicast_frames",
> +	"mac_rx_multicast_frames",
> +	"mac_rx_broadcast_frames",
> +	"mac_rx_frames_64",
> +	"mac_rx_frames_65_127",
> +	"mac_rx_frames_128_255",
> +	"mac_rx_frames_256_511",
> +	"mac_rx_frames_512_1023",
> +	"mac_rx_frames_1024_1518",
> +	"mac_rx_frames_1519_max",
> +	"mac_rx_drop_events",
> +	"mac_rx_errors",
> +	"mac_rx_FCS_errors",
> +	"mac_rx_alignment_errors",
> +	"mac_rx_frame_too_long_errors",
> +	"mac_rx_in_range_length_errors",
> +	"mac_rx_undersize_frames",
> +	"mac_rx_oversize_frames",
> +	"mac_rx_jabbers",
> +	"mac_rx_fragments",
> +	"mac_rx_control_frames",
> +	"mac_rx_pause",

> +	"mac_rx_CBFCPAUSE15",
> +	"mac_fec_correctable_errors",
> +	"mac_fec_uncorrectable_errors",

Please drop all the stats which are reported via the structured API.
It's a new driver, users are better off using the standard API than
grepping for yet another unique, driver-specific string.
