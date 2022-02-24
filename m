Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E904C210B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 02:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiBXBbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 20:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiBXBbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 20:31:07 -0500
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E838F9FB2;
        Wed, 23 Feb 2022 17:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645666235; x=1677202235;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rRJItIkRVPSRyn6WcQ0w1H/fcH0+5dRK4WI9eRknR58=;
  b=lbIEGCMrHixZv9VYDEGej38vFQyC8yRLZqsYDsKL3R5KlY8qmlgXuScZ
   G/UfvZ3RMrz+UOKBbX45zyb/25J5LO2S5lWI2gBqqyHcb/1MpvmhWFTy4
   RmnzmaDM/vEuFmAWjqDmqqmb46gL4HaGUSQ3pxZp27MKf9ka2BS8vomNH
   c=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 23 Feb 2022 16:50:19 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 16:50:19 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 23 Feb 2022 16:50:19 -0800
Received: from [10.48.243.226] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Wed, 23 Feb
 2022 16:50:18 -0800
Message-ID: <6106494b-a1b3-6b57-8b44-b9528127533b@quicinc.com>
Date:   Wed, 23 Feb 2022 16:50:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 4/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_connect_event
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>
References: <cover.1645583264.git.gustavoars@kernel.org>
 <8a0e347615a3516980fd8b6ad2dc4864a880613b.1645583264.git.gustavoars@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <8a0e347615a3516980fd8b6ad2dc4864a880613b.1645583264.git.gustavoars@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
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

On 2/22/2022 6:38 PM, Gustavo A. R. Silva wrote:
> Replace one-element array with flexible-array member in struct
> wmi_connect_event.
> 
> It's also worth noting that due to the flexible array transformation,
> the size of struct wmi_connect_event changed (now the size is 1 byte
> smaller), and in order to preserve the logic of before the transformation,
> the following change is needed:
> 
> 	-       if (len < sizeof(struct wmi_connect_event))
> 	+       if (len <= sizeof(struct wmi_connect_event))
> 
> This issue was found with the help of Coccinelle and audited and fixed,
> manually.
> 
> Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Hi!
> 
> It'd be great if someone can confirm or comment on the following
> changes described in the changelog text:
> 
>          -       if (len < sizeof(struct wmi_connect_event))
>          +       if (len <= sizeof(struct wmi_connect_event))
> 
> Thanks
> 
>   drivers/net/wireless/ath/ath6kl/wmi.c | 2 +-
>   drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index 049d75f31f3c..ccdccead688e 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -857,7 +857,7 @@ static int ath6kl_wmi_connect_event_rx(struct wmi *wmi, u8 *datap, int len,
>   	struct wmi_connect_event *ev;
>   	u8 *pie, *peie;
>   
> -	if (len < sizeof(struct wmi_connect_event))
> +	if (len <= sizeof(struct wmi_connect_event))

this is another case where IMO the original code can remain since all it 
is really checking is to see if the entire "fixed" portion is present. 
in reality if there was just one byte of assoc_info the response would 
actually be invalid.

what is missing is logic that verifies len is large enough to hold the 
payload that is advertised via the beacon_ie_len, assoc_req_len, & 
assoc_resp_len members. without this even if you change the initial len 
check you can have a condition where len says there is one u8 in 
assoc_info (and pass the initial test) but the other three members 
indicate that much more data is present.

but that is a pre-existing shortcoming that should be handled with a 
separate patch.


>   		return -EINVAL;
>   
>   	ev = (struct wmi_connect_event *) datap;
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
> index 432e4f428a4a..6b064e669d87 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.h
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.h
> @@ -1545,7 +1545,7 @@ struct wmi_connect_event {
>   	u8 beacon_ie_len;
>   	u8 assoc_req_len;
>   	u8 assoc_resp_len;
> -	u8 assoc_info[1];
> +	u8 assoc_info[];
>   } __packed;
>   
>   /* Disconnect Event */

whether or not you modify the length check consider this:
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
