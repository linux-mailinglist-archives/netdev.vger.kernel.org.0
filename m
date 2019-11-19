Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107C5103058
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKSXj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:39:57 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35899 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfKSXj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:39:57 -0500
Received: by mail-lj1-f193.google.com with SMTP id k15so25349794lja.3
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 15:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/LdIVr6ra3bRQ43A7v1+Qjf/FERkqn/ICf+KG5+y8H4=;
        b=1u1od0HL3ClKpZIZcHZ7QhDHP+rVfM1aWmY4mQ8xA0nZ4CFxNPH+8EhicNs9Q0FdHb
         By4uHTABE3UNltrG2oI71PHH4L2/qybiNDh1mkuZyXKajuIlnzvbpCAGyohXRCO/f2Sd
         bOrAL+8vHCpxSEdL2V2xYGg6AF9wKvK+RtPAm/hkVEFb/j59ss8HZnbxgH3iNBRdZN8D
         D6I+KskGcbn7/Jy//brTHTgzxY4bJKRYBiwOzweq/bPuz1OXVdn4OxJkXKxYsJX1h7aR
         QtJhGiwqiLvhw4AIev87g31LjiXt+qpMOiiZV1ZNWiBCtTgC1QE9ZqLOAIIH6nW75wwl
         L0MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/LdIVr6ra3bRQ43A7v1+Qjf/FERkqn/ICf+KG5+y8H4=;
        b=eQeTZaWavHf4ecp5/w2xcOQTsyM7KKI+26T8tXToXhrCZE5fmJ6dy0gNk3AMyi/N4Y
         VbzRpxVEfmnn2IATc+1rOhq2ywVkyC8nfXKSqFD2GodcJmUw3++7BEaTJMFn5nAKOV//
         baz3Wtr2DhYrdqCSHm/CNkVwIaDNS9TZlpH1i4DVUKJ7UL/U4GYxQ44AJotysNh2zsjZ
         4bxOT7Z/yTheQd/uKz9nyecEiGpYTohvpj5GCDALQcx+io/lLwrXUHCMDy6zz6W/BxVV
         08dVRtTK9qtVdljPfKak4+POZn74HeaSUdtO7RDTD1WC5IgasFkXj3oLkmbvIiy46Ak0
         Lm1w==
X-Gm-Message-State: APjAAAVmnsspDCKfKFRyyshzzEWXEF7p2rxr61wiCFSZOeBfmu3jOMN1
        3rq/SQt4xQ7jLcNW7dRwFCpq7Q==
X-Google-Smtp-Source: APXvYqxEDbPn5VgA0bCKIJKrbbL2AzlQkUYvBtNKskxkY6ZBytpcx30a3AzLRfyzy/Ra8S5b674Sgw==
X-Received: by 2002:a2e:4703:: with SMTP id u3mr83376lja.126.1574206794369;
        Tue, 19 Nov 2019 15:39:54 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y18sm10931041lja.12.2019.11.19.15.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 15:39:54 -0800 (PST)
Date:   Tue, 19 Nov 2019 15:39:37 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: Re: [PATCH V2 net-next v2 1/3] net: ena: implement XDP drop support
Message-ID: <20191119153937.484b7059@cakuba.netronome.com>
In-Reply-To: <20191119133419.9734-2-sameehj@amazon.com>
References: <20191119133419.9734-1-sameehj@amazon.com>
        <20191119133419.9734-2-sameehj@amazon.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 15:34:17 +0200, sameehj@amazon.com wrote:
> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This commit implements the basic functionality of drop/pass logic in the
> ena driver.
> 
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 148 +++++++++++++++++--
>  drivers/net/ethernet/amazon/ena/ena_netdev.h |  30 ++++
>  2 files changed, 168 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index d46a91200..35f766d9c 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -35,8 +35,8 @@
>  #ifdef CONFIG_RFS_ACCEL
>  #include <linux/cpu_rmap.h>
>  #endif /* CONFIG_RFS_ACCEL */
> +#include <linux/bpf_trace.h>
>  #include <linux/ethtool.h>
> -#include <linux/if_vlan.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/numa.h>
> @@ -123,6 +123,80 @@ static int ena_change_mtu(struct net_device *dev, int new_mtu)
>  	return ret;
>  }
>  
> +static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
> +{
> +	struct bpf_prog *xdp_prog;
> +	u32 verdict = XDP_PASS;
> +
> +	rcu_read_lock();
> +	xdp_prog = READ_ONCE(rx_ring->xdp_bpf_prog);
> +
> +	if (!xdp_prog)
> +		goto out;
> +
> +	verdict = bpf_prog_run_xdp(xdp_prog, xdp);
> +
> +	if (unlikely(verdict == XDP_ABORTED))
> +		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
> +	else if (unlikely(verdict >= XDP_TX))
> +		bpf_warn_invalid_xdp_action(verdict);
> +out:
> +	rcu_read_unlock();
> +	return verdict;
> +}
> +
> +static int ena_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf)
> +{
> +	struct ena_adapter *adapter = netdev_priv(netdev);
> +	struct bpf_prog *prog = bpf->prog;
> +	struct bpf_prog *old_bpf_prog;
> +	int i, prev_mtu;
> +
> +	if (ena_xdp_allowed(adapter)) {
> +		old_bpf_prog = xchg(&adapter->xdp_bpf_prog, prog);
> +
> +		for (i = 0; i < adapter->num_io_queues; i++)
> +			xchg(&adapter->rx_ring[i].xdp_bpf_prog, prog);
> +
> +		if (old_bpf_prog)
> +			bpf_prog_put(old_bpf_prog);
> +
> +		prev_mtu = netdev->max_mtu;
> +		netdev->max_mtu = prog ? ENA_XDP_MAX_MTU : adapter->max_mtu;
> +		netif_info(adapter, drv, adapter->netdev, "xdp program set, changging the max_mtu from %d to %d",
> +			   prev_mtu, netdev->max_mtu);
> +
> +	} else {
> +		netif_err(adapter, drv, adapter->netdev, "Failed to set xdp program, the current MTU (%d) is larger than the maximum allowed MTU (%lu) while xdp is on",
> +			  netdev->mtu, ENA_XDP_MAX_MTU);
> +		NL_SET_ERR_MSG_MOD(bpf->extack, "Failed to set xdp program, the current MTU is larger than the maximum allowed MTU. Check the dmesg for more info");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/* This is the main xdp callback, it's used by the kernel to set/unset the xdp
> + * program as well as to query the current xdp program id.
> + */
> +static int ena_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
> +{
> +	struct ena_adapter *adapter = netdev_priv(netdev);
> +
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		return ena_xdp_set(netdev, bpf);
> +	case XDP_QUERY_PROG:
> +		bpf->prog_id = adapter->xdp_bpf_prog ?
> +			adapter->xdp_bpf_prog->aux->id : 0;
> +		break;
> +	default:
> +		NL_SET_ERR_MSG_MOD(bpf->extack, "Unsupported XDP command");

Please remove this and silently ignore unsupported commands.

> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  static int ena_init_rx_cpu_rmap(struct ena_adapter *adapter)
>  {
>  #ifdef CONFIG_RFS_ACCEL
> @@ -417,6 +491,9 @@ static void ena_free_rx_resources(struct ena_adapter *adapter,
>  
>  	vfree(rx_ring->free_ids);
>  	rx_ring->free_ids = NULL;
> +
> +	xdp_rxq_info_unreg_mem_model(&rx_ring->xdp_rxq);
> +	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
>  }
>  
>  /* ena_setup_all_rx_resources - allocate I/O Rx queues resources for all queues
> @@ -1037,6 +1114,23 @@ static void ena_set_rx_hash(struct ena_ring *rx_ring,
>  	}
>  }
>  
> +int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
> +{
> +	struct ena_rx_buffer *rx_info =
> +		&rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];

empty line between variables and code.

Also what's the point of the inline init of this variable if you have
to break it over mutliple lines anyway?

> +	xdp->data = page_address(rx_info->page) +
> +		rx_info->page_offset;

How much space does this guarantee? From a quick grep looks like
page_offset is always 0? We'd like to have 256 bytes of space for the
frame to grow for XDP. I see you subtract XDP_PACKET_HEADROOM from the
MTU but I don't see it used otherwise..

> +	xdp->data_meta = xdp->data;
> +	xdp->data_hard_start = page_address(rx_info->page);
> +	xdp->data_end = xdp->data + rx_ring->ena_bufs[0].len;
> +	/* If for some reason we received a bigger packet than
> +	 * we expect, then we simply drop it
> +	 */
> +	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
> +		return XDP_DROP;
> +	else
> +		return ena_xdp_execute(rx_ring, xdp);
> +}
>  /* ena_clean_rx_irq - Cleanup RX irq
>   * @rx_ring: RX ring to clean
>   * @napi: napi handler
