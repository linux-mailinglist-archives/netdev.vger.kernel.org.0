Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37681BBB02
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 12:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgD1KRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 06:17:45 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:27017 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbgD1KRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 06:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588069063; x=1619605063;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=wxE1pArbBRl3l1RDLsV1GX67Nv4XKbB6AEf7eL5UUvw=;
  b=vecClBYM5LJp97Nt6QTCzNn2UfwgN2oTaKdtWD2dHfFeYo7ackhjIhAE
   D36mifSNqTInk0cbuR4RJiMpdnCDAUYiTMcy+V/ZWmt2Pwo9WVWJTduQo
   7eJAa7yONQrV6FcaE6o2Li0u/5u/QSvE3+NIvSolRLCM5XPFfk70KsfQ4
   8=;
IronPort-SDR: VIqmipF/xkb9oihStHSuDyGuqkTl9kueeZG9RjZK5NwvPKO+bF/cfhLh3RfzFkgUPOoFo3AtHJ
 Mi4uGPLtuQPg==
X-IronPort-AV: E=Sophos;i="5.73,327,1583193600"; 
   d="scan'208";a="41337237"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 28 Apr 2020 10:17:40 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 42EFB240C4A;
        Tue, 28 Apr 2020 10:17:35 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 10:17:35 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.162.38) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 10:17:27 +0000
Subject: Re: [PATCH V6 mlx5-next 10/16] RDMA: Group create AH arguments in
 struct
To:     Maor Gottlieb <maorg@mellanox.com>
CC:     <davem@davemloft.net>, <jgg@mellanox.com>, <dledford@redhat.com>,
        <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <kuba@kernel.org>, <jiri@mellanox.com>, <dsahern@kernel.org>,
        <leonro@mellanox.com>, <saeedm@mellanox.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alexr@mellanox.com>
References: <20200426071717.17088-1-maorg@mellanox.com>
 <20200426071717.17088-11-maorg@mellanox.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <5c306a86-3579-fc96-2214-5ac6a73f7ccb@amazon.com>
Date:   Tue, 28 Apr 2020 13:17:22 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200426071717.17088-11-maorg@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D12UWA004.ant.amazon.com (10.43.160.168) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2020 10:17, Maor Gottlieb wrote:
> Following patch adds additional argument to the create AH function,
> so it make sense to group ah_attr and flags arguments in struct.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>

RDMA driver maintainers should probably be CC'd.

> diff --git a/drivers/infiniband/hw/efa/efa.h b/drivers/infiniband/hw/efa/efa.h
> index aa7396a1588a..45d519edb4c3 100644
> --- a/drivers/infiniband/hw/efa/efa.h
> +++ b/drivers/infiniband/hw/efa/efa.h
> @@ -153,8 +153,7 @@ int efa_mmap(struct ib_ucontext *ibucontext,
>  	     struct vm_area_struct *vma);
>  void efa_mmap_free(struct rdma_user_mmap_entry *rdma_entry);
>  int efa_create_ah(struct ib_ah *ibah,
> -		  struct rdma_ah_attr *ah_attr,
> -		  u32 flags,
> +		  struct rdma_ah_init_attr *init_attr,
>  		  struct ib_udata *udata);
>  void efa_destroy_ah(struct ib_ah *ibah, u32 flags);
>  int efa_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
> diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
> index 5c57098a4aee..454b01b21e6a 100644
> --- a/drivers/infiniband/hw/efa/efa_verbs.c
> +++ b/drivers/infiniband/hw/efa/efa_verbs.c
> @@ -1639,10 +1639,10 @@ static int efa_ah_destroy(struct efa_dev *dev, struct efa_ah *ah)
>  }
>  
>  int efa_create_ah(struct ib_ah *ibah,
> -		  struct rdma_ah_attr *ah_attr,
> -		  u32 flags,
> +		  struct rdma_ah_init_attr *init_attr,
>  		  struct ib_udata *udata)
>  {
> +	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>  	struct efa_dev *dev = to_edev(ibah->device);
>  	struct efa_com_create_ah_params params = {};
>  	struct efa_ibv_create_ah_resp resp = {};
> @@ -1650,7 +1650,7 @@ int efa_create_ah(struct ib_ah *ibah,
>  	struct efa_ah *ah = to_eah(ibah);
>  	int err;
>  
> -	if (!(flags & RDMA_CREATE_AH_SLEEPABLE)) {
> +	if (!(init_attr->flags & RDMA_CREATE_AH_SLEEPABLE)) {
>  		ibdev_dbg(&dev->ibdev,
>  			  "Create address handle is not supported in atomic context\n");
>  		err = -EOPNOTSUPP;

EFA part looks good,
Acked-by: Gal Pressman <galpress@amazon.com>
