Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC15D986A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfJPRZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:25:59 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36289 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfJPRZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:25:38 -0400
Received: by mail-io1-f67.google.com with SMTP id b136so54812014iof.3
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 10:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=dXgxUS40mRQzkfwkmWDJ9VvItmm2CjNhFGKui6wbZwc=;
        b=yR/9OFAjzSEVyD9iD6xejU+OodS52E8bKjMXFEzqsepNu0B4YuCg0USbKXUQxlkgP8
         9Xv0Q/kWfetZAgM7L/nUnTiNTI+Y7U/Kjfx38cvOhcQ/ALIGcr9PAP29f2/JFAmcwM/n
         g2Y/YjgaRvASXrVpa7MPJj0TXw3vtiCzMJdeDTXS+r61uFLTqiQ4zgVJ/F6UPJC314Vp
         6j0jNAjZuVGRk+M7v3RgwIItdh4/KtlydvTbIx495DsQCxYB3CqKeAH8qzJD1Gf5Tlrq
         WRK2MBGxbRptw46TZn61TfK4GxHdeQjb0pdFZHOYRKatUUxTOH3pLmTFlqoz1GEAiHMK
         5ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=dXgxUS40mRQzkfwkmWDJ9VvItmm2CjNhFGKui6wbZwc=;
        b=f0wkMMFz0wusWrrbRFp8eTDIgfDseiZQIKtbZucbToTKBLuYwZhf9RY0xamtF93xZK
         8Lp4XMtO35axeJPNPftwwPuUiW07EPqQ445i0wUtEN3/yfSe6qgkeZU0H0p3+2bKRve6
         9WnnUsbIwadCGQRyd/9zHrCBzdVNtFbs8yiQ+ZL0KCxrKambrqE0JUtfRC7rgBepFjjG
         keyP3KQVtBxxxZeNhTq4l5IjYZJLSid3GLlcq1uGvSaKnEybdwQpWcmFwimmHLcbqxeU
         IQm1LRYt4bCAlxlNWEOmb7pROW3sk5Wk207nHKlq6TXsbgt0YtypUN/PT3lawerMprA9
         E6tQ==
X-Gm-Message-State: APjAAAWSAS4dAm0b+iw4UO7xnMQ2nArsY11nJkZsWi9H3MkTM9uM23Xz
        tlrd2yQ1QgDRjNkVSolTE2hrZYnuKKY=
X-Google-Smtp-Source: APXvYqwtu2p6xdepTEYR/yLJYi8oc817I9ZxAW5E49BJsKqeONk+kP7CWET3zhMqaM0FrGHVSQD3og==
X-Received: by 2002:a63:4e58:: with SMTP id o24mr6993330pgl.72.1571246301048;
        Wed, 16 Oct 2019 10:18:21 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id f62sm29175811pfg.74.2019.10.16.10.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 10:18:20 -0700 (PDT)
Date:   Wed, 16 Oct 2019 10:18:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: [PATCH net-next 11/12] net: hns3: do not allocate linear data
 for fraglist skb
Message-ID: <20191016101817.725b6d28@cakuba.netronome.com>
In-Reply-To: <1571210231-29154-12-git-send-email-tanhuazhong@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
        <1571210231-29154-12-git-send-email-tanhuazhong@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 15:17:10 +0800, Huazhong Tan wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> 
> Currently, napi_alloc_skb() is used to allocate skb for fraglist
> when the head skb is not enough to hold the remaining data, and
> the remaining data is added to the frags part of the fraglist skb,
> leaving the linear part unused.
> 
> So this patch passes length of 0 to allocate fraglist skb with
> zero size of linear data.
> 
> Fixes: 81ae0e0491f3 ("net: hns3: Add skb chain when num of RX buf exceeds MAX_SKB_FRAGS")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Is this really a fix? I just wastes memory, right?

> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index 6172eb2..14111af 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -2866,8 +2866,7 @@ static int hns3_add_frag(struct hns3_enet_ring *ring, struct hns3_desc *desc,
>  			return -ENXIO;
>  
>  		if (unlikely(ring->frag_num >= MAX_SKB_FRAGS)) {
> -			new_skb = napi_alloc_skb(&ring->tqp_vector->napi,
> -						 HNS3_RX_HEAD_SIZE);
> +			new_skb = napi_alloc_skb(&ring->tqp_vector->napi, 0);
>  			if (unlikely(!new_skb)) {
>  				hns3_rl_err(ring_to_netdev(ring),
>  					    "alloc rx fraglist skb fail\n");

