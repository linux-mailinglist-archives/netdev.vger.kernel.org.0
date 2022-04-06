Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A4A4F6C47
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiDFVN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236310AbiDFVM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:12:57 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467121B74DE;
        Wed,  6 Apr 2022 12:57:40 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso6839242pju.1;
        Wed, 06 Apr 2022 12:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=amIBwcurHA/IB31GoJLXw8YYalrzwFRfV1FNlUywLyA=;
        b=A+ldMtGikFUMW0nfl3NicAkA+QcLIcD6thv6uQRWu1NvLRvDOyYy/MnIwZcXVMnB8p
         C2LhM2tIO+fszp8CazwogGob1ozqXTHi8KIXanT+geTGOszYYANyDkd7CuE/yonCcr8p
         g7i6PRU9gkXq0co1KKsLD5O49a2LIFMkcZK18Bil/dK9eAqClfXLDGxWAQCSiO2w6Ap4
         p8qGNv2l5XMslaEKT2A/ooY8wMxHUPtTs7S4cmuca6PrtZR2fSE46QyLwxQWDa3iZQ4M
         1YNAzXEzRa45tMb0Krqeyqua8aJhzOtToGv60dZWl+XXfOUlAFaqJb6lmlEXtqHOfheL
         0SlA==
X-Gm-Message-State: AOAM533DoOkv/GWi2g6AZlcrLl6j9nETuSPknzFzNuh3Oy9GIq/FGqhI
        uMTkKCTZdouWi4vNolk0Vhw=
X-Google-Smtp-Source: ABdhPJzPYf5xMo/3tiolm5zS6xnm4HQHpdPD7nFtjZCYwwxKplAg725myh8iIllXTcpGGAj31TN69Q==
X-Received: by 2002:a17:903:40c1:b0:156:f1cc:7d72 with SMTP id t1-20020a17090340c100b00156f1cc7d72mr3074987pld.70.1649275056484;
        Wed, 06 Apr 2022 12:57:36 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id m18-20020a056a00081200b004faeae3a291sm20294259pfk.26.2022.04.06.12.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 12:57:35 -0700 (PDT)
Message-ID: <ca06d463-cf68-4b6f-8432-a86e34398bf0@acm.org>
Date:   Wed, 6 Apr 2022 12:57:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] RDMA: Split kernel-only global device caps from uverbs
 device caps
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Ariel Elior <aelior@marvell.com>,
        Anna Schumaker <anna@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        target-devel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
References: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/22 12:27, Jason Gunthorpe wrote:
> +enum ib_kernel_cap_flags {
> +	/*
> +	 * This device supports a per-device lkey or stag that can be
> +	 * used without performing a memory registration for the local
> +	 * memory.  Note that ULPs should never check this flag, but
> +	 * instead of use the local_dma_lkey flag in the ib_pd structure,
> +	 * which will always contain a usable lkey.
> +	 */
> +	IBK_LOCAL_DMA_LKEY = 1 << 0,
> +	/* IB_QP_CREATE_INTEGRITY_EN is supported to implement T10-PI */
> +	IBK_INTEGRITY_HANDOVER = 1 << 1,
> +	/* IB_ACCESS_ON_DEMAND is supported during reg_user_mr() */
> +	IBK_ON_DEMAND_PAGING = 1 << 2,
> +	/* IB_MR_TYPE_SG_GAPS is supported */
> +	IBK_SG_GAPS_REG = 1 << 3,
> +	/* Driver supports RDMA_NLDEV_CMD_DELLINK */
> +	IBK_ALLOW_USER_UNREG = 1 << 4,
> +
> +	/* ipoib will use IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK */
> +	IBK_BLOCK_MULTICAST_LOOPBACK = 1 << 5,
> +	/* iopib will use IB_QP_CREATE_IPOIB_UD_LSO for its QPs */
> +	IBK_UD_TSO = 1 << 6,
> +	/* iopib will use the device ops:
> +	 *   get_vf_config
> +	 *   get_vf_guid
> +	 *   get_vf_stats
> +	 *   set_vf_guid
> +	 *   set_vf_link_state
> +	 */
> +	IBK_VIRTUAL_FUNCTION = 1 << 7,
> +	/* ipoib will use IB_QP_CREATE_NETDEV_USE for its QPs */
> +	IBK_RDMA_NETDEV_OPA = 1 << 8,
> +};

Has it been considered to use the kernel-doc syntax? This means moving 
all comments above "enum ib_kernel_cap_flags {".

Thanks,

Bart.
