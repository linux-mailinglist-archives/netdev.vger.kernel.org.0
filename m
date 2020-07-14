Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C0021FD0E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgGNTPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgGNTPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 15:15:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4167620656;
        Tue, 14 Jul 2020 19:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594754130;
        bh=wASoBqCsf39wwEeN0q6SNf1opLJ9yKxe9XYGPgy99VA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z9dOfZIeBE7fSPh02eDrRDACKdJ3GfPB4EcRRMK8CCxDnTgNrDuKdxKjIGH7kzENk
         +C26y7hG8VUgmJonAVUxBTjzmBq4nRstcdemxRVFBquUeZdpQ5gkLksblNZ40PQ1t/
         YjCBObwu3TtR6vh8Nn46Da2uYXn41FpGzbzUIzrQ=
Date:   Tue, 14 Jul 2020 12:15:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        thomas.lendacky@amd.com, aelior@marvell.com, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com
Subject: Re: [PATCH net-next v2 11/12] qede: convert to new udp_tunnel_nic
 infra
Message-ID: <20200714121527.3dc55a35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200714182908.690108-12-kuba@kernel.org>
References: <20200714182908.690108-1-kuba@kernel.org>
        <20200714182908.690108-12-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 11:29:07 -0700 Jakub Kicinski wrote:
> +const struct udp_tunnel_nic_info qede_udp_tunnels_both = {

self-nak, this needs a static

Gotta make my own infra work for local patches :S

> +	.sync_table	= qede_udp_tunnel_sync,
> +	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP,
> +	.tables		= {
> +		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
> +		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_GENEVE, },
> +	},
> +}, qede_udp_tunnels_vxlan = {
> +	.sync_table	= qede_udp_tunnel_sync,
> +	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP,
> +	.tables		= {
> +		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_VXLAN,  },
> +	},
> +}, qede_udp_tunnels_geneve = {
> +	.sync_table	= qede_udp_tunnel_sync,
> +	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP,
> +	.tables		= {
> +		{ .n_entries = 1, .tunnel_types = UDP_TUNNEL_TYPE_GENEVE, },
> +	},
> +};
