Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948D74F69B7
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 21:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiDFTVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 15:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiDFTUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 15:20:18 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8441E21E19;
        Wed,  6 Apr 2022 10:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1649266255; x=1680802255;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=6ntTxqe3cu4c0Uf8vB38QsM5/1MJtQWWwjbiUS6GuQg=;
  b=PstudtNCDLwXDY3HjryTq9kHJsM7BxGyrHCg/hj8zERiXmdQqKcO8E1G
   dgA7hYltlmsbGjR9lBy2z0tNji3BytmSVhy1CEYH7u2Ln7qBr/coxs9M6
   qgtRwWX+7VuPpsPhPOONCALvoGcjNXJhEaCk1RBmap19G49iyMcoD8mQ0
   8=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 06 Apr 2022 10:30:55 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 10:30:51 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 6 Apr 2022 10:30:51 -0700
Received: from [10.110.72.142] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 10:30:48 -0700
Message-ID: <1bd025f0-8805-6ec9-7927-a9a18d0e0431@quicinc.com>
Date:   Wed, 6 Apr 2022 10:30:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] RDMA: Split kernel-only global device caps from uvers
 device caps
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Ariel Elior <aelior@marvell.com>,
        "Anna Schumaker" <anna@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        "Nelson Escobar" <neescoba@cisco.com>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <rds-devel@oss.oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        <samba-technical@lists.samba.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        <target-devel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Zhu Yanjun" <zyjzyj2000@gmail.com>,
        Xiao Yang <yangx.jy@fujitsu.com>
References: <0-v1-47e161ac2db9+80f-kern_caps_jgg@nvidia.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <0-v1-47e161ac2db9+80f-kern_caps_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/2022 9:18 AM, Jason Gunthorpe wrote:
> Split ib_device::device_cap_flags into kernel_cap_flags that holds the
> flags only used by the kernel.
> 
> This cleanly splits out the uverbs flags from the kernel flags to avoid
> confusion in the flags bitmap.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

subject nit: s/uvers/uverbs/ ?
