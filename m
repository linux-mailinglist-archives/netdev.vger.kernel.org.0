Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5152D35C603
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240318AbhDLMQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 08:16:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237283AbhDLMQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 08:16:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVvTx-00GGCA-21; Mon, 12 Apr 2021 14:15:57 +0200
Date:   Mon, 12 Apr 2021 14:15:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        liuwe@microsoft.com, netdev@vger.kernel.org, leon@kernel.org,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YHQ5/fJyvkTHzBqA@lunn.ch>
References: <20210412023455.45594-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412023455.45594-1-decui@microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline bool is_gdma_msg(const void *req)
> +{
> +	struct gdma_req_hdr *hdr = (struct gdma_req_hdr *)req;
> +
> +	if (hdr->req.hdr_type == GDMA_STANDARD_HEADER_TYPE &&
> +	    hdr->resp.hdr_type == GDMA_STANDARD_HEADER_TYPE &&
> +	    hdr->req.msg_size >= sizeof(struct gdma_req_hdr) &&
> +	    hdr->resp.msg_size >= sizeof(struct gdma_resp_hdr) &&
> +	    hdr->req.msg_type != 0 && hdr->resp.msg_type != 0)
> +		return true;
> +
> +	return false;
> +}
> +
> +static inline bool is_gdma_msg_len(const u32 req_len, const u32 resp_len,
> +				   const void *req)
> +{
> +	struct gdma_req_hdr *hdr = (struct gdma_req_hdr *)req;
> +
> +	if (req_len >= sizeof(struct gdma_req_hdr) &&
> +	    resp_len >= sizeof(struct gdma_resp_hdr) &&
> +	    req_len >= hdr->req.msg_size && resp_len >= hdr->resp.msg_size &&
> +	    is_gdma_msg(req)) {
> +		return true;
> +	}
> +
> +	return false;
> +}

You missed adding the mana_ prefix here. There might be others.

> +#define CQE_POLLING_BUFFER 512
> +struct ana_eq {
> +	struct gdma_queue *eq;
> +	struct gdma_comp cqe_poll[CQE_POLLING_BUFFER];
> +};

> +static int ana_poll(struct napi_struct *napi, int budget)
> +{

You also have a few cases of ana_, not mana_. There might be others.

    Andrew
