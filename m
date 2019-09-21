Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C985DB9BE4
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 03:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404897AbfIUBt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 21:49:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38871 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730652AbfIUBt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 21:49:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id u186so9258879qkc.5
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 18:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FeqXKSmrKgPryn0IKpLutsFyfvdRW6HQixGEpZvfgYU=;
        b=ivuU0aupOrzdi7aeGFvRG+9Q3gOwo6HMwbTO14y4SlF1WyIBCE+57GfqAHOw+lUQNQ
         jEMvvu+KrSwrWkJ5+eZ/9PYnzCjdBjHiy8uTCBKoeCDnMhNwF6dZpNgXBY5r7T4owBbM
         EA0K8+wMK4rHF1/vxDvcQDsSwmZBHP1nuikZUcVTg3/Q3rsfpShMNT1x9JOrJeFtz5Kk
         +Qy7UVrTd3xw0loXH5qn8im1RW1PS8pR3pwMkb8I7C7OXNrTba5jbEQSVRuDV2vzdB3K
         5Q64RQUiX0CKWeZCuc56VQRMD0L0bohoDOJR1xt5QwYSG1SxIatvOnoNAVu/9snFMqX1
         P+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FeqXKSmrKgPryn0IKpLutsFyfvdRW6HQixGEpZvfgYU=;
        b=E5up/7M+t8coY1fMVcnTUiNeDlhQFOTXFR3iEopmLPyr51wUB6cPPCLwi7PYERLOlI
         k8CPxjUp1S2fgUNZmUfyBho5BXd4CUgx/VwvZhgxM+vYoWgOaLo7kuzAYaJrTcTFHu4O
         KnCUnYFtLGVvDLZOLVcRbhwEDjw5UvOvcLeVp4BPtpSVQKv5vEm8WFNHJN2J9m4kn8ix
         RjWnbMMgGmhjafJIs1AwTd9mZ0pWBdT6gMf8HSYGx6WB3pI70Yn2aOga//yMhG7KmRPn
         ZFQNCAqN1VIevkv1c2vbwgt9iFsWfvKAxt4nMGEv7iBujTAGsBarGbaZS/zPQA/H5j8S
         LzvA==
X-Gm-Message-State: APjAAAXXcYbbiE8xBSR6zy2p38dtCsw3nyzwQFvWTrJ09sdgF5lVF39H
        YZroDHAE8X2odlgbUQ6K4DhGvQ==
X-Google-Smtp-Source: APXvYqy3TI36UEKri6vTjhOUCqw4ubZxj6nMjgp2ss02bQkJ8QlGCRYx405pw6P7fPjs52t18v2LGg==
X-Received: by 2002:a05:620a:13c5:: with SMTP id g5mr7077761qkl.475.1569030598344;
        Fri, 20 Sep 2019 18:49:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 200sm1764206qkf.65.2019.09.20.18.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 18:49:57 -0700 (PDT)
Date:   Fri, 20 Sep 2019 18:49:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: release skb on failure
Message-ID: <20190920184642.3c36d26b@cakuba.netronome.com>
In-Reply-To: <20190918044521.14953-1-navid.emamdoost@gmail.com>
References: <20190918044521.14953-1-navid.emamdoost@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Sep 2019 23:45:21 -0500, Navid Emamdoost wrote:
> In ql_run_loopback_test, ql_lb_send does not release skb when fails. So
> it must be released before returning.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c | 4 +++-

Thanks for the patch, this driver has been moved, please see

commit 955315b0dc8c8641311430f40fbe53990ba40e33
Author: Benjamin Poirier <bpoirier@suse.com>
Date:   Tue Jul 23 15:14:13 2019 +0900

    qlge: Move drivers/net/ethernet/qlogic/qlge/ to
    drivers/staging/qlge/ 
    The hardware has been declared EOL by the vendor more than 5 years
    ago. What's more relevant to the Linux kernel is that the quality
    of this driver is not on par with many other mainline drivers.
    
    Cc: Manish Chopra <manishc@marvell.com>
    Message-id: <20190617074858.32467-1-bpoirier@suse.com>
    Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Could you rebase, and send the new version to GregKH as he is the
stable maintainer?

>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c b/drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c
> index a6886cc5654c..d539b71b2a5c 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c
> @@ -544,8 +544,10 @@ static int ql_run_loopback_test(struct ql_adapter *qdev)
>  		skb_put(skb, size);
>  		ql_create_lb_frame(skb, size);
>  		rc = ql_lb_send(skb, qdev->ndev);
> -		if (rc != NETDEV_TX_OK)
> +		if (rc != NETDEV_TX_OK) {
> +			dev_kfree_skb_any(skb);
>  			return -EPIPE;
> +		}
>  		atomic_inc(&qdev->lb_count);
>  	}
>  	/* Give queue time to settle before testing results. */

