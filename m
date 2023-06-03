Return-Path: <netdev+bounces-7635-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2A3720E38
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37794281A1B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FAFEA937;
	Sat,  3 Jun 2023 06:59:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A988834
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AD9C433EF;
	Sat,  3 Jun 2023 06:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685775541;
	bh=IAGJxJ3JlAB/u0zA2ngAhx3AwvNiI19/nJzIKrbxIwU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JkAQLqD73oxh6KmB2BycBMWXatq8QfSoGA+xO6kS9quNZlFnkVAOTJf9cbEDla5K4
	 c4DExDqam/dmkEipKm3LiZjFv4Y3YV/dx6Ps2fz5D7ecFIEq88Amk+i/sViPsJOXeN
	 qdCyVnnDrjqUbhsZzyxDZWQ+yPeL6/9DkYTHhfqxPVIoCKYDdqQOQ1pxfW1Xp4UwdT
	 Rk5jKYZPqmpyGUKLnliW9dRdpKUKpYVC4AGj2XjFgwls00FdFNAeixy3ZCfwVqxfEp
	 k65VH0q2KQxCZXpdo4CpAUaXENMxXmRoUgxf21f3PS8toenNBUSIbKxc4dfPC3XE5P
	 0wiqX+mSjJ/Og==
Date: Fri, 2 Jun 2023 23:58:59 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 bcm-kernel-feedback-list@broadcom.com, florian.fainelli@broadcom.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 opendmb@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, richardcochran@gmail.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v6 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <20230602235859.79042ff0@kernel.org>
In-Reply-To: <1685657551-38291-4-git-send-email-justin.chen@broadcom.com>
References: <1685657551-38291-1-git-send-email-justin.chen@broadcom.com>
	<1685657551-38291-4-git-send-email-justin.chen@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Jun 2023 15:12:28 -0700 Justin Chen wrote:
> +	/* general stats */
> +	STAT_NETDEV(rx_packets),
> +	STAT_NETDEV(tx_packets),
> +	STAT_NETDEV(rx_bytes),
> +	STAT_NETDEV(tx_bytes),
> +	STAT_NETDEV(rx_errors),
> +	STAT_NETDEV(tx_errors),
> +	STAT_NETDEV(rx_dropped),
> +	STAT_NETDEV(tx_dropped),
> +	STAT_NETDEV(multicast),

please don't report standard interface stats in ethtool -S

> +	/* UniMAC RSV counters */
> +	STAT_BCMASP_MIB_RX("rx_64_octets", mib.rx.pkt_cnt.cnt_64),
> +	STAT_BCMASP_MIB_RX("rx_65_127_oct", mib.rx.pkt_cnt.cnt_127),
> +	STAT_BCMASP_MIB_RX("rx_128_255_oct", mib.rx.pkt_cnt.cnt_255),
> +	STAT_BCMASP_MIB_RX("rx_256_511_oct", mib.rx.pkt_cnt.cnt_511),
> +	STAT_BCMASP_MIB_RX("rx_512_1023_oct", mib.rx.pkt_cnt.cnt_1023),
> +	STAT_BCMASP_MIB_RX("rx_1024_1518_oct", mib.rx.pkt_cnt.cnt_1518),
> +	STAT_BCMASP_MIB_RX("rx_vlan_1519_1522_oct", mib.rx.pkt_cnt.cnt_mgv),
> +	STAT_BCMASP_MIB_RX("rx_1522_2047_oct", mib.rx.pkt_cnt.cnt_2047),
> +	STAT_BCMASP_MIB_RX("rx_2048_4095_oct", mib.rx.pkt_cnt.cnt_4095),
> +	STAT_BCMASP_MIB_RX("rx_4096_9216_oct", mib.rx.pkt_cnt.cnt_9216),

these should also be removed, and you should implement @get_rmon_stats.

> +	STAT_BCMASP_MIB_RX("rx_pkts", mib.rx.pkt),
> +	STAT_BCMASP_MIB_RX("rx_bytes", mib.rx.bytes),
> +	STAT_BCMASP_MIB_RX("rx_multicast", mib.rx.mca),
> +	STAT_BCMASP_MIB_RX("rx_broadcast", mib.rx.bca),
> +	STAT_BCMASP_MIB_RX("rx_fcs", mib.rx.fcs),

there's a FCS error statistic in the standard stats, no need to
duplicate

> +	STAT_BCMASP_MIB_RX("rx_control", mib.rx.cf),
> +	STAT_BCMASP_MIB_RX("rx_pause", mib.rx.pf),

@get_pause_stats

> +	STAT_BCMASP_MIB_RX("rx_unknown", mib.rx.uo),
> +	STAT_BCMASP_MIB_RX("rx_align", mib.rx.aln),
> +	STAT_BCMASP_MIB_RX("rx_outrange", mib.rx.flr),
> +	STAT_BCMASP_MIB_RX("rx_code", mib.rx.cde),
> +	STAT_BCMASP_MIB_RX("rx_carrier", mib.rx.fcr),
> +	STAT_BCMASP_MIB_RX("rx_oversize", mib.rx.ovr),
> +	STAT_BCMASP_MIB_RX("rx_jabber", mib.rx.jbr),

these look like candidates from standard stats, too.
Please read thru:

https://docs.kernel.org/next/networking/statistics.html

> +	STAT_BCMASP_MIB_RX("rx_mtu_err", mib.rx.mtue),
> +	STAT_BCMASP_MIB_RX("rx_good_pkts", mib.rx.pok),
> +	STAT_BCMASP_MIB_RX("rx_unicast", mib.rx.uc),
> +	STAT_BCMASP_MIB_RX("rx_ppp", mib.rx.ppp),
> +	STAT_BCMASP_MIB_RX("rx_crc", mib.rx.rcrc),

hm, what's the difference between rx_crc and rx_fcs ?

