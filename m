Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28151CB448
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 18:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgEHQCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 12:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgEHQCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 12:02:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35D3620725;
        Fri,  8 May 2020 16:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588953721;
        bh=nGc+SLJxpXjap5msmJmrGbQ4enOvgC5oOrcNf+H+qw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OKyAPh2sT+mAa691UfV0EN32C1WrLZFmlr/klni0D/8/ugY513c0hbj8PI4HSYiEH
         PmOyVmptSWIDUr+Hs/NHzZg4A2TcPKlbtcRJ6A8Zgd5uJM3iK6hnVCYC8NTJwUXWFK
         83vWa2jCzOCfEOX4sa4YY7rtUKeer/muWhau4Gl0=
Date:   Fri, 8 May 2020 09:01:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net-next v3 24/33] ixgbevf: add XDP frame size to VF
 driver
Message-ID: <20200508090159.4f5cd868@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <158893624794.2321140.18426998968815095643.stgit@firesoul>
References: <158893607924.2321140.16117992313983615627.stgit@firesoul>
        <158893624794.2321140.18426998968815095643.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 08 May 2020 13:10:48 +0200 Jesper Dangaard Brouer wrote:
> +static unsigned int ixgbevf_rx_frame_truesize(struct ixgbevf_ring *rx_ring,
> +					      unsigned int size)
> +{
> +	unsigned int truesize;
> +
> +#if (PAGE_SIZE < 8192)
> +	truesize = ixgbevf_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
> +#else
> +	truesize = ring_uses_build_skb(rx_ring) ?
> +		SKB_DATA_ALIGN(IXGBEVF_SKB_PAD + size) +
> +		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
> +		SKB_DATA_ALIGN(size);
> +#endif
> +       return truesize;
> +}

WARNING: please, no spaces at the start of a line
#43: FILE: drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:1111:
+       return truesize;$
