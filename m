Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3436B1C8A33
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 14:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgEGMOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 08:14:19 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58204 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgEGMOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 08:14:19 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 047CEFbJ108738;
        Thu, 7 May 2020 07:14:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588853655;
        bh=QlxtLs1bYV4C6jrPTOhXGflRMXFMssbJhOKrVMLzTN0=;
        h=Subject:From:To:References:Date:In-Reply-To;
        b=Ie60NRuJqjwdkAvw7IinN8tbXCo7CFNz/K3MIBDpQIXfBurz3ESY73yfX90/TJ5MD
         aLALtdy+m6o8Z7S63jWpjMia9b8l2otNHqxnBUwp7EK8opNixMmzbwuTRBbWhisVXL
         yvQ2N8s5E816yZ9sQiFc42y74NLh+hbPXBSD4qno=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 047CEFIa109561;
        Thu, 7 May 2020 07:14:15 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 7 May
 2020 07:14:15 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 7 May 2020 07:14:15 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 047CEFgQ105716;
        Thu, 7 May 2020 07:14:15 -0500
Subject: Re: [net PATCH v2] net: hsr: fix incorrect type usage for protocol
 variable
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200506213107.28291-1-m-karicheri2@ti.com>
Message-ID: <76101ccc-0a9d-dad9-1d34-f3d204a1dbe5@ti.com>
Date:   Thu, 7 May 2020 08:14:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506213107.28291-1-m-karicheri2@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 5/6/20 5:31 PM, Murali Karicheri wrote:
> Fix following sparse checker warning:-
> 
> net/hsr/hsr_slave.c:38:18: warning: incorrect type in assignment (different base types)
> net/hsr/hsr_slave.c:38:18:    expected unsigned short [unsigned] [usertype] protocol
> net/hsr/hsr_slave.c:38:18:    got restricted __be16 [usertype] h_proto
> net/hsr/hsr_slave.c:39:25: warning: restricted __be16 degrades to integer
> net/hsr/hsr_slave.c:39:57: warning: restricted __be16 degrades to integer
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>   v2 : Added Acked-by from Vinicius Costa Gomes
>   net/hsr/hsr_slave.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
> index f4b9f7a3ce51..25b6ffba26cd 100644
> --- a/net/hsr/hsr_slave.c
> +++ b/net/hsr/hsr_slave.c
> @@ -18,7 +18,7 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
>   {
>   	struct sk_buff *skb = *pskb;
>   	struct hsr_port *port;
> -	u16 protocol;
> +	__be16 protocol;
>   
>   	if (!skb_mac_header_was_set(skb)) {
>   		WARN_ONCE(1, "%s: skb invalid", __func__);
> 
I saw that you have applied the initial patch to net-next. Please ignore 
this.

-- 
Murali Karicheri
Texas Instruments
