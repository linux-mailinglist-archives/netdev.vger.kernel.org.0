Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98FB35436C
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 17:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbhDEP12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 11:27:28 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:52087 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhDEP10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 11:27:26 -0400
Received: by mail-pj1-f49.google.com with SMTP id s21so6260363pjq.1;
        Mon, 05 Apr 2021 08:27:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s6/xO6zDlOcf9rGpsVwdjh2veGTAn/Y535MvhVK0maI=;
        b=h9EtD5dygBgSwlVuY9Jq6t+X2QFeSKBAkLNb8O5qKyvy3AGmgN7kScbfC7a9jLtSQi
         Z1sS31l/OWdoApZgs07IyDTIt4Vt9unJzh2oUmBlZ1dcZbglfJyRHc343UVzS0J/gB69
         Eia2NxXoItDcvXbhXr5JyUWefkOUynENpPCvCqLT9uJG+gOFHktluYVVAQujWgyZ1CXH
         opKRO9ZSgM82jTPeMpxBKC0oaMvZJI5J2mbEq8lDlJOJniapJWlAacenFoG7FVAhIWso
         riUNBcde/x8w0fA7n4Oc8Niicf6zMOAoLtUKfLTObExCAUybVvDZH1RCzngmYP1J1Z/E
         BRNQ==
X-Gm-Message-State: AOAM53271sAdFQyyNyFbp7r9nebheGfwuj34uN9tQFpPpqb7rY50RQiR
        Js8Q6+WcdfOTSJSj21l2Ok0=
X-Google-Smtp-Source: ABdhPJxlWm0Lzuy1NvlR6D9W30X3v6KfefWidA41cG0vntzFiFzAU4ozy7Gn2cAEzl4sPpga7IG/QA==
X-Received: by 2002:a17:90b:33d0:: with SMTP id lk16mr14383989pjb.115.1617636440145;
        Mon, 05 Apr 2021 08:27:20 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:20c0:5960:9793:8deb? ([2601:647:4000:d7:20c0:5960:9793:8deb])
        by smtp.gmail.com with ESMTPSA id p11sm16137366pjo.48.2021.04.05.08.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 08:27:19 -0700 (PDT)
Subject: Re: [PATCH rdma-next 01/10] RDMA: Add access flags to ib_alloc_mr()
 and ib_mr_pool_init()
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405052404.213889-2-leon@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c21edd64-396c-4c7c-86f8-79045321a528@acm.org>
Date:   Mon, 5 Apr 2021 08:27:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210405052404.213889-2-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/21 10:23 PM, Leon Romanovsky wrote:
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index bed4cfe50554..59138174affa 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -2444,10 +2444,10 @@ struct ib_device_ops {
>  				       struct ib_udata *udata);
>  	int (*dereg_mr)(struct ib_mr *mr, struct ib_udata *udata);
>  	struct ib_mr *(*alloc_mr)(struct ib_pd *pd, enum ib_mr_type mr_type,
> -				  u32 max_num_sg);
> +				  u32 max_num_sg, u32 access);
>  	struct ib_mr *(*alloc_mr_integrity)(struct ib_pd *pd,
>  					    u32 max_num_data_sg,
> -					    u32 max_num_meta_sg);
> +					    u32 max_num_meta_sg, u32 access);
>  	int (*advise_mr)(struct ib_pd *pd,
>  			 enum ib_uverbs_advise_mr_advice advice, u32 flags,
>  			 struct ib_sge *sg_list, u32 num_sge,
> @@ -4142,11 +4142,10 @@ static inline int ib_dereg_mr(struct ib_mr *mr)
>  }
>  
>  struct ib_mr *ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
> -			  u32 max_num_sg);
> +			  u32 max_num_sg, u32 access);
>  
> -struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
> -				    u32 max_num_data_sg,
> -				    u32 max_num_meta_sg);
> +struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd, u32 max_num_data_sg,
> +				    u32 max_num_meta_sg, u32 access);
>  
>  /**
>   * ib_update_fast_reg_key - updates the key portion of the fast_reg MR
> diff --git a/include/rdma/mr_pool.h b/include/rdma/mr_pool.h
> index e77123bcb43b..2a0ee791037d 100644
> --- a/include/rdma/mr_pool.h
> +++ b/include/rdma/mr_pool.h
> @@ -11,7 +11,8 @@ struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct list_head *list);
>  void ib_mr_pool_put(struct ib_qp *qp, struct list_head *list, struct ib_mr *mr);
>  
>  int ib_mr_pool_init(struct ib_qp *qp, struct list_head *list, int nr,
> -		enum ib_mr_type type, u32 max_num_sg, u32 max_num_meta_sg);
> +		    enum ib_mr_type type, u32 max_num_sg, u32 max_num_meta_sg,
> +		    u32 access);
>  void ib_mr_pool_destroy(struct ib_qp *qp, struct list_head *list);
>  
>  #endif /* _RDMA_MR_POOL_H */

Does the new 'access' argument only control whether or not PCIe relaxed
ordering is enabled? It seems wrong to me to make enabling of PCIe
relaxed ordering configurable. I think this mechanism should be enabled
unconditionally if the HCA supports it.

Thanks,

Bart.
