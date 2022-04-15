Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26F2503154
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346305AbiDOXFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiDOXF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:05:29 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A02167D3B;
        Fri, 15 Apr 2022 16:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1650063780; x=1681599780;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SXwXBdQqg3w0Na7l4QbphKGJc3ZMWJFk1TEWGHJVyNM=;
  b=IRieHLE8uz5anchfW4gaXjIx87uxIGJy3MOhaaBPIZWmUDdIwFUYe6oI
   WYbz/9xS3blV0v6LV85CRSB8EAbSJyIG9Q8+N7ovjIQqX9sksUnXrBGCD
   lV3eGWgjCo/v4wPaDPNb5K/4ecLbrUeX26oFQzHCqzoZZBGEkdh0NNqCC
   s=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 15 Apr 2022 16:02:59 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 16:02:59 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 15 Apr 2022 16:02:59 -0700
Received: from [10.110.103.65] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 15 Apr
 2022 16:02:58 -0700
Message-ID: <ca2944bd-e80e-e0ff-0804-c8439f54b28a@quicinc.com>
Date:   Fri, 15 Apr 2022 16:02:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2] ath11k: simplify if-if to if-else
Content-Language: en-US
To:     Yihao Han <hanyihao@vivo.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <kernel@vivo.com>
References: <20220415125853.86418-1-hanyihao@vivo.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220415125853.86418-1-hanyihao@vivo.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/2022 5:58 AM, Yihao Han wrote:
> Replace `if (!ab->is_reset)` with `else` for simplification
> according to the kernel coding style:
> 
> "Do not unnecessarily use braces where a single statement will do."
> 
> ...
> 
> "This does not apply if only one branch of a conditional statement is
> a single statement; in the latter case use braces in both branches"
> 
> Please refer to:
> https://www.kernel.org/doc/html/v5.17-rc8/process/coding-style.html

why are you referring to braces when your patch has nothing to do with 
braces?

changing if (foo) X;if (!foo) Y; to if (foo) X else Y; is not a design 
pattern referenced in the coding style

> 
> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---
> v2:edit commit message
> ---
>   drivers/net/wireless/ath/ath11k/core.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
> index cbac1919867f..80009482165a 100644
> --- a/drivers/net/wireless/ath/ath11k/core.c
> +++ b/drivers/net/wireless/ath/ath11k/core.c
> @@ -1532,8 +1532,7 @@ static void ath11k_core_restart(struct work_struct *work)
>   
>   	if (ab->is_reset)
>   		complete_all(&ab->reconfigure_complete);
> -
> -	if (!ab->is_reset)
> +	else
>   		ath11k_core_post_reconfigure_recovery(ab);
>   }
>   

