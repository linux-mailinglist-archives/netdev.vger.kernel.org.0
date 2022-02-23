Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8554C06CB
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiBWBTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiBWBTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:19:30 -0500
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69393DA51;
        Tue, 22 Feb 2022 17:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645579143; x=1677115143;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0kQShUgmQFv+XGVCWzx4wwZ+zYeAVyIwJJcXpq3EHQg=;
  b=KljmWFdy/dKTxxnX8qntn6p2XAhi/AC07InYbS36U6Jls68e43BLScJa
   QbEdG9uF0qtXzy7L/p5NZY0JinqRR6G8wlJWxR7gQ/4W/2Y/FOwYcAmOM
   ybba+sp862WS9Tf+xELXOwbn4DpO/WfgPJVTr1N4B+C8IqhVeitTg7MY3
   A=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 22 Feb 2022 17:19:03 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 17:19:02 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 22 Feb 2022 17:19:02 -0800
Received: from [10.48.243.226] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Tue, 22 Feb
 2022 17:19:01 -0800
Message-ID: <31aa626d-3d39-ca5f-c91d-47aa5bf7715b@quicinc.com>
Date:   Tue, 22 Feb 2022 17:19:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] ath9k: make array voice_priority static const
Content-Language: en-US
To:     Colin Ian King <colin.i.king@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220222121749.87513-1-colin.i.king@gmail.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220222121749.87513-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/2022 4:17 AM, Colin Ian King wrote:
> Don't populate the read-only array voice_priority on the stack but
> instead make it static const. Also makes the object code a little
> smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   drivers/net/wireless/ath/ath9k/mci.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
> index 39d46c203f6b..5e0ae7e6412f 100644
> --- a/drivers/net/wireless/ath/ath9k/mci.c
> +++ b/drivers/net/wireless/ath/ath9k/mci.c
> @@ -43,7 +43,7 @@ static bool ath_mci_add_profile(struct ath_common *common,
>   				struct ath_mci_profile_info *info)
>   {
>   	struct ath_mci_profile_info *entry;
> -	u8 voice_priority[] = { 110, 110, 110, 112, 110, 110, 114, 116, 118 };
> +	static const u8 voice_priority[] = { 110, 110, 110, 112, 110, 110, 114, 116, 118 };
>   
>   	if ((mci->num_sco == ATH_MCI_MAX_SCO_PROFILE) &&
>   	    (info->type == MCI_GPM_COEX_PROFILE_VOICE))

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>

An additional cleanup that could be performed in that function:

		if (info->voice_type < sizeof(voice_priority))

replace sizeof() with ARRAY_SIZE() so that it works correctly if the 
base type is ever changed from u8
