Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E44C6D84A2
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387897AbfJPAEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:04:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34306 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfJPAEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:04:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id j11so25852158wrp.1
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 17:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=u2sFG6u6ohRXSnAkcKzjorORqSIj1roXYbU4NUeLUDY=;
        b=wR0pnrLNBkakwMEcsKcwFQRYhBsg2MrkwrvJxsRG9KTF9uXyMr9c8Nvxr9TItOuO9v
         63MWawNGqDzPPA8a3eVRIfZfjba5wKiDNpUVC2XAzOgKil6jdxVS/O8X6FWLgiDWWnn4
         rZEEjN/5zCPzP5uUiD38ZzEO9wKBYqgFW5DjiWXdS8dFpRS/GHIC0GUoEB5t4SFFea93
         88Nv6590DdI2tLCpsh4W1OvssKlbwbsQ48bjxdD89F8xZeE3ROAkNHnXttONK9T6zlWb
         ubxF/YFlr6uA6Rr1gAKSG79UGIlfMYTV62pTkjHU2y7knoeTCz21muWJSaijvZcDZs+v
         PY1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=u2sFG6u6ohRXSnAkcKzjorORqSIj1roXYbU4NUeLUDY=;
        b=C2fmLBoS4QGGzI8Yy5hto024tq4iwP4iplgTXBIIHj7mgTeWZj7VSqCbm5lU0T0dY/
         iFu4UazfHEc4DDmllGHjDh+L6zQNeKLXShNXOycKSB9/UB0y9wplfJYYe5SGk19mNwst
         ZkyssWeI0ZXwQTzwfMFYHPRH3kj4u/b9DE3KI5C2FzSy9HLbIyOI07KmHT3aiQGbsVuW
         cWJ0r0Y6BASev9zBoD8+mUS9rQq1tPQm/Lo2ZWLid/krlyYsWbjljtLge+26galbIUEB
         K/djxWboHWC20BpTj/xcLLuXdDYgwYEpA7sg8w6k7K9oFEnU7C3OD9eu/tD3yIHrP++O
         34oA==
X-Gm-Message-State: APjAAAVQlsUvNXb++jc2PJXJMeLReAOpB0UaEPKxSfghmc7108UWtYYq
        Y/sbOQPXf3gZWH+JFo5tZAfetA==
X-Google-Smtp-Source: APXvYqxk0Dr1nRrypaAExNMGKBtlKtuwGSf3iTZtJWHSV+nK/DbSD9IkAZfKxBQtbbWvNA5V5vghbA==
X-Received: by 2002:adf:e40c:: with SMTP id g12mr52838wrm.216.1571184242601;
        Tue, 15 Oct 2019 17:04:02 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 63sm34968818wri.25.2019.10.15.17.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 17:04:02 -0700 (PDT)
Date:   Tue, 15 Oct 2019 17:03:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 7/8] net: mvneta: make tx buffer array
 agnostic
Message-ID: <20191015170353.1f4fbbbb@cakuba.netronome.com>
In-Reply-To: <d233782c20a6d64f39c9d28fd321fc07fcc8b65e.1571049326.git.lorenzo@kernel.org>
References: <cover.1571049326.git.lorenzo@kernel.org>
        <d233782c20a6d64f39c9d28fd321fc07fcc8b65e.1571049326.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Oct 2019 12:49:54 +0200, Lorenzo Bianconi wrote:
> Allow tx buffer array to contain both skb and xdp buffers in order to
> enable xdp frame recycling adding XDP_TX verdict support
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 66 +++++++++++++++++----------
>  1 file changed, 43 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index a79d81c9be7a..477ae6592fa3 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -561,6 +561,20 @@ struct mvneta_rx_desc {
>  };
>  #endif
>  
> +enum mvneta_tx_buf_type {
> +	MVNETA_TYPE_SKB,
> +	MVNETA_TYPE_XDP_TX,
> +	MVNETA_TYPE_XDP_NDO,
> +};
> +
> +struct mvneta_tx_buf {
> +	enum mvneta_tx_buf_type type;

I'd be tempted to try to encode type on the low bits of the pointer,
otherwise you're increasing the cache pressure here. I'm not 100% sure
it's worth the hassle, perhaps could be a future optimization.

> +	union {
> +		struct xdp_frame *xdpf;
> +		struct sk_buff *skb;
> +	};
> +};

