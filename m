Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A750B1E13EA
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgEYSPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:15:20 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41114 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbgEYSPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:15:19 -0400
Received: by mail-qk1-f195.google.com with SMTP id n11so12692760qkn.8
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 11:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eKX0+uPoGaQwvkR7iF4FDx2mROTsEwClo5tOoflVnLM=;
        b=h813B2eCq22ZfiFh40v7iFpHf8quNJEXWIkDwgxcT5F7Z3eNtzgbKdpxGrzRl7o/dz
         g3SqkZMmfMgttjGPlESxbUGnkMoPgLhGabKlquoeluusqSVCC2ZYzTqP6riEUnx2TjkJ
         9KPFimmp8o9qttba2YFNqGb8SXS6e4DuR9R3IcxlEl6GBEelWG8jyxgNfPbl0GnzJRxd
         r5V3F6uGAbkhSR66+T2W+yTWEnjYbck1V8vWNxamVe9ItLoGnrzf9KxP10+G/eZTy7vX
         Ow6mKgrhbsd7d021bPl61YejCBzj47YBdYgGmBSBNtSJDvy133Pbs2mdOiKzfswmd4FU
         3KCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eKX0+uPoGaQwvkR7iF4FDx2mROTsEwClo5tOoflVnLM=;
        b=Vmp5jt5fjYVqdYwE9br2CkR6/ATU10jHLeK2jetI+I9v6WRt1+1aw3K4bw/p53igCd
         PJiGAtBgYUoGxxQv+rKBCHtvfUZiq7dZSCKm6QZTp3sZBBAvfYzlHvV9cNEHWNMkKWM4
         xVnAEfPL60Q8Tx9wIm9SH7t1eQomo6FW+h7clA5w29EwVKVTaeKFXZOynmRvQq19Ay/F
         3HZUKTT7dXbQxtrYPIUtMMiQ0DdJWKtwKpSHaU+wuzpcF6FXq+ib7GnT3cOWFR0hAOeS
         CFr05Esy0o1vDUf6YXBTThsCnjILVhi06vEL7MSvUwwN2BNquzzF1HFIKp6cEC+OVFBA
         3bgA==
X-Gm-Message-State: AOAM530EkPO2Z8epRLwxw6v0HYIVd1DFQDUQVRCe9bFXJAiZwEu+qOfb
        mcomcJBKFYeDIwp88GU7D8bDFA==
X-Google-Smtp-Source: ABdhPJwLyD55r8bw1XTSt/MRjSo+WXge4biwlAYf0ydhc+lJWNdthkd53udQb5oArh0e9K5LrYdqew==
X-Received: by 2002:a37:e101:: with SMTP id c1mr13747043qkm.433.1590430458530;
        Mon, 25 May 2020 11:14:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id x2sm10541822qke.42.2020.05.25.11.14.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2020 11:14:17 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jdHc9-00078A-Hn; Mon, 25 May 2020 15:14:17 -0300
Date:   Mon, 25 May 2020 15:14:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        target-devel@vger.kernel.org
Subject: Re: [PATCH rdma-next v2 7/7] RDMA/cma: Provide ECE reject reason
Message-ID: <20200525181417.GC24366@ziepe.ca>
References: <20200413141538.935574-1-leon@kernel.org>
 <20200413141538.935574-8-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413141538.935574-8-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 05:15:38PM +0300, Leon Romanovsky wrote:
> @@ -4223,7 +4223,7 @@ int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event)
>  EXPORT_SYMBOL(rdma_notify);
>  
>  int rdma_reject(struct rdma_cm_id *id, const void *private_data,
> -		u8 private_data_len)
> +		u8 private_data_len, enum rdma_ucm_reject_reason reason)
>  {
>  	struct rdma_id_private *id_priv;
>  	int ret;
> @@ -4237,10 +4237,12 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
>  			ret = cma_send_sidr_rep(id_priv, IB_SIDR_REJECT, 0,
>  						private_data, private_data_len);
>  		} else {
> +			enum ib_cm_rej_reason r =
> +				(reason) ?: IB_CM_REJ_CONSUMER_DEFINED;
> +
>  			trace_cm_send_rej(id_priv);
> -			ret = ib_send_cm_rej(id_priv->cm_id.ib,
> -					     IB_CM_REJ_CONSUMER_DEFINED, NULL,
> -					     0, private_data, private_data_len);
> +			ret = ib_send_cm_rej(id_priv->cm_id.ib, r, NULL, 0,
> +					     private_data, private_data_len);
>  		}
>  	} else if (rdma_cap_iw_cm(id->device, id->port_num)) {
>  		ret = iw_cm_reject(id_priv->cm_id.iw,
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index d41598954cc4..99482dc5934b 100644
> +++ b/drivers/infiniband/core/ucma.c
> @@ -1178,12 +1178,17 @@ static ssize_t ucma_reject(struct ucma_file *file, const char __user *inbuf,
>  	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
>  		return -EFAULT;
>  
> +	if (cmd.reason &&
> +	    cmd.reason != RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED)
> +		return -EINVAL;

It would be clearer to set cmd.reason to IB_CM_REJ_CONSUMER_DEFINED at
this point.. 

if (!cmd.reason)
   cmd.reason = IB_CM_REJ_CONSUMER_DEFINED

if (cmd.reason != IB_CM_REJ_CONSUMER_DEFINED && cmd.reason !=
    RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED)
   return -EINVAL

Esaier to follow and no reason userspace shouldn't be able to
explicitly specifiy the reason's that it is allowed to use.


> index 8d961d8b7cdb..f8781b132f62 100644
> +++ b/include/rdma/rdma_cm.h
> @@ -324,11 +324,12 @@ int __rdma_accept_ece(struct rdma_cm_id *id, struct rdma_conn_param *conn_param,
>   */
>  int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event);
>  
> +
>  /**

Extra hunk?

>   * rdma_reject - Called to reject a connection request or response.
>   */
>  int rdma_reject(struct rdma_cm_id *id, const void *private_data,
> -		u8 private_data_len);
> +		u8 private_data_len, enum rdma_ucm_reject_reason reason);
>  
>  /**
>   * rdma_disconnect - This function disconnects the associated QP and
> diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
> index c4ca1412bcf9..e545f2de1e13 100644
> +++ b/include/uapi/rdma/rdma_user_cm.h
> @@ -78,6 +78,10 @@ enum rdma_ucm_port_space {
>  	RDMA_PS_UDP   = 0x0111,
>  };
>  
> +enum rdma_ucm_reject_reason {
> +	RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED = 35
> +};

not sure we need ABI defines for IBTA constants?

Jason
