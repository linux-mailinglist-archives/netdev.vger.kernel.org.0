Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEEA225B62
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 11:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgGTJXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 05:23:35 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:36468 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbgGTJXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 05:23:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595237015; x=1626773015;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=+7yAVZl6mHmUHzH/+LVL6YAFykoxwPD4jg9C2cO3LOg=;
  b=Gck+mCm9qzRnNinmRnf/iKM96JnoffpbBhBSNgKYX6nxJU04JNI2CEhT
   0TzJMLniH+8c3NRAq1oTb0yVReHQo5/jojJadHb6KfMAH9w970P1JYNm4
   qyFzWbm6Ja2VTOqb52J6RE5Ak88nc8N86L+Cs4X8N08CLv8hX/tgVFFwI
   4=;
IronPort-SDR: C8cd0F9M+jjP4jsjmMLL96Y3EX8+slPuwv4bDevIK7M6h+ACb+rK0U7pTSR7KPZ6ZH4KOOylOT
 kxavO417bAmw==
X-IronPort-AV: E=Sophos;i="5.75,374,1589241600"; 
   d="scan'208";a="59807333"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 20 Jul 2020 09:23:33 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id C72D2A28E3;
        Mon, 20 Jul 2020 09:23:31 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 20 Jul 2020 09:23:31 +0000
Received: from ua97a68a4e7db56.ant.amazon.com.amazon.com (10.43.161.146) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 20 Jul 2020 09:23:25 +0000
References: <20200720075614.35676-1-wanghai38@huawei.com>
User-agent: mu4e 1.4.10; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Wang Hai <wanghai38@huawei.com>
CC:     <joe@perches.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <zorik@amazon.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sameehj@amazon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3] net: ena: Fix using plain integer as NULL pointer in ena_init_napi_in_range
In-Reply-To: <20200720075614.35676-1-wanghai38@huawei.com>
Date:   Mon, 20 Jul 2020 12:23:20 +0300
Message-ID: <pj41zlimeibkvr.fsf@ua97a68a4e7db56.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.146]
X-ClientProxiedBy: EX13D20UWC001.ant.amazon.com (10.43.162.244) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Wang Hai <wanghai38@huawei.com> writes:

> Fix sparse build warning:
>
> drivers/net/ethernet/amazon/ena/ena_netdev.c:2193:34: warning:
>  Using plain integer as NULL pointer
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> Suggested-by: Joe Perches <joe@perches.com>
> Acked-by: Shay Agroskin <shayagr@amazon.com>
> ---
> v1->v2:
>  Improve code readability based on Joe Perches's suggestion 
> v2->v3:
>  Simplify code based on Joe Perches's suggestion
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 91be3ffa1c5c..3eb63b12dd68 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -2190,14 +2190,13 @@ static void ena_del_napi_in_range(struct 
> ena_adapter *adapter,
>  static void ena_init_napi_in_range(struct ena_adapter *adapter,
>  				   int first_index, int count)
>  {
> -	struct ena_napi *napi = {0};
>  	int i;
>  
>  	for (i = first_index; i < first_index + count; i++) {
> -		napi = &adapter->ena_napi[i];
> +		struct ena_napi *napi = &adapter->ena_napi[i];
>  
>  		netif_napi_add(adapter->netdev,
> -			       &adapter->ena_napi[i].napi,
> +			       &napi->napi,
>  			       ENA_IS_XDP_INDEX(adapter, i) ? 
>  ena_xdp_io_poll : ena_io_poll,
>  			       ENA_NAPI_BUDGET);

Acked-by: Shay Agroskin <shayagr@amazon.com>

Thanks a lot for your work
