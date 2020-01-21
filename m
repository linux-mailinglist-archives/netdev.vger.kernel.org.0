Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D42714424A
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAUQht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:37:49 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:32196 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbgAUQhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:37:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579624668; x=1611160668;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=uowtzUhtMD1h/eN4qCScAmdgoWppOUy0RKbXeqhGk4M=;
  b=NaggMuibbzV41XQ1A8Ynnti4L61OPC81Y50WW79iH0i3c3Q+DvVande3
   kwY43cF6YnO8G6QWsWCCvVpIEVynP9uhCCu2L3C+Jd1OsD7U8ttBQ+fjx
   +Q/WAqQwAAr7F9WBq8ZBYK6igJWm9INFxWFnzq6kz6szEY6tK/oPGEfUh
   E=;
IronPort-SDR: exfgzQegItGclssMh1nvFrjMg4tR15SJxEBNt/lv9j9rmmhz9fRH0F85PlvROU7AUa7Fu5+u/q
 C0WhYhPTa+Zg==
X-IronPort-AV: E=Sophos;i="5.70,346,1574121600"; 
   d="scan'208";a="12608833"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Jan 2020 16:37:47 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 1E63DA28BB;
        Tue, 21 Jan 2020 16:37:44 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 21 Jan 2020 16:37:43 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.162.95) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 Jan 2020 16:37:38 +0000
Subject: Re: [PATCH rdma-next 07/10] RDMA/efa: Allow passing of optional
 access flags for MR registration
To:     Yishai Hadas <yishaih@mellanox.com>
CC:     <linux-rdma@vger.kernel.org>, <jgg@mellanox.com>,
        <dledford@redhat.com>, <saeedm@mellanox.com>, <maorg@mellanox.com>,
        <michaelgur@mellanox.com>, <netdev@vger.kernel.org>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
 <1578506740-22188-8-git-send-email-yishaih@mellanox.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <6df1dbee-f35e-a5ad-019b-1bf572608974@amazon.com>
Date:   Tue, 21 Jan 2020 18:37:34 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1578506740-22188-8-git-send-email-yishaih@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.95]
X-ClientProxiedBy: EX13D12UWA003.ant.amazon.com (10.43.160.50) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/01/2020 20:05, Yishai Hadas wrote:
> From: Michael Guralnik <michaelgur@mellanox.com>
> 
> As part of adding a range of optional access flags that drivers need to
> be able to accept, mask this range inside efa driver.
> This will prevent the driver from failing when an access flag from
> that range is passed.
> 
> Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> ---
>  drivers/infiniband/hw/efa/efa_verbs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
> index 50c2257..b6b936c 100644
> --- a/drivers/infiniband/hw/efa/efa_verbs.c
> +++ b/drivers/infiniband/hw/efa/efa_verbs.c
> @@ -1370,6 +1370,7 @@ struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start, u64 length,
>  		IB_ACCESS_LOCAL_WRITE |
>  		(is_rdma_read_cap(dev) ? IB_ACCESS_REMOTE_READ : 0);
>  
> +	access_flags &= ~IB_UVERBS_ACCESS_OPTIONAL_RANGE;

Hi Yishai,
access_flags should be masked with IB_ACCESS_OPTIONAL instead of
IB_UVERBS_ACCESS_OPTIONAL_RANGE.

Also, could you please make sure to CC me to future EFA patches?
