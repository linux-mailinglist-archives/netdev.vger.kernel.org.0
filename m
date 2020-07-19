Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2FB225133
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 12:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgGSKIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 06:08:51 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:29496 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgGSKIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 06:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595153331; x=1626689331;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=tcP9glb7MJA5U6uyVkklf1D75ytsFZVBdTt6Qe1lvKE=;
  b=lNZoRneEuJo02HbofjzWY/wH5sOD6mIP1VMa18yQOx+IuUul2eP5kvWS
   JROHwtJChKFAna+PXmYz5nlbPxEwIih2neWkyIL9C3/7yo7VwJDEyQZAx
   k1pZFE/dTOV0FeZbECxqNj/Tgp5W9Es8SN4F0MsrtmKpTHBzauPrDYjX0
   A=;
IronPort-SDR: mxDPYRSMy0Bv+96wI9jQ0Mk/1Am/p18JLTb7eSw7YlP9rqLE6x9XVCRlamriV4bx/p2FXW9AUu
 YAbIW/dhfxOg==
X-IronPort-AV: E=Sophos;i="5.75,370,1589241600"; 
   d="scan'208";a="42583767"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 Jul 2020 10:08:50 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 5C023A33A1;
        Sun, 19 Jul 2020 10:08:48 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 19 Jul 2020 10:08:47 +0000
Received: from ua97a68a4e7db56.ant.amazon.com.amazon.com (10.43.161.146) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 19 Jul 2020 10:08:41 +0000
References: <20200718115633.37464-1-wanghai38@huawei.com> <3093bc36c2ad86170e2e90a3451e5962d0815122.camel@perches.com>
User-agent: mu4e 1.4.10; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Joe Perches <joe@perches.com>
CC:     Wang Hai <wanghai38@huawei.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <zorik@amazon.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sameehj@amazon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] net: ena: use NULL instead of zero
In-Reply-To: <3093bc36c2ad86170e2e90a3451e5962d0815122.camel@perches.com>
Date:   Sun, 19 Jul 2020 13:08:35 +0300
Message-ID: <pj41zlsgdn4y1o.fsf@ua97a68a4e7db56.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.146]
X-ClientProxiedBy: EX13D46UWB002.ant.amazon.com (10.43.161.70) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Joe Perches <joe@perches.com> writes:

> On Sat, 2020-07-18 at 19:56 +0800, Wang Hai wrote:
>> Fix sparse build warning:
>> 
>> drivers/net/ethernet/amazon/ena/ena_netdev.c:2193:34: warning:
>>  Using plain integer as NULL pointer
>
> Better to remove the initialization altogether and
> move the declaration into the loop.
>
>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
>> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> []
>> @@ -2190,7 +2190,7 @@ static void ena_del_napi_in_range(struct 
>> ena_adapter *adapter,
>>  static void ena_init_napi_in_range(struct ena_adapter 
>>  *adapter,
>>  				   int first_index, int count)
>>  {
>> -	struct ena_napi *napi = {0};
>> +	struct ena_napi *napi = NULL;
>>  	int i;
>>  
>>  	for (i = first_index; i < first_index + count; i++) {
>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 91be3ffa1c5c..470d8f38b824 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -2190,11 +2190,10 @@ static void ena_del_napi_in_range(struct 
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
>  			       &adapter->ena_napi[i].napi,

We prefer the second variant as it improves code readability imo.
Thank you both for the time you invested in it (:

Acked-by: Shay Agroskin <shayagr@amazon.com>

