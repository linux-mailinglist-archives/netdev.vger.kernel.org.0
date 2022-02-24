Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4550A4C219E
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 03:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiBXCL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 21:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiBXCLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 21:11:55 -0500
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8ADB4D;
        Wed, 23 Feb 2022 18:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645668686; x=1677204686;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x6brwM7ZtEJWe3+MXlu4EJraFcB8hQIqzGr5Jpw6Omo=;
  b=B4xNYAOjZ6b8KkZ6OOj3s3d20VTLnCtTuNXow3pCwGhK9B2Vm0/9benJ
   GolozGIn0BG3+YYXmnP/NGWu7OqK++77iXZOoaXxSzRsR3Rq7AGn/0Ryu
   /XhEvkFgjGxuAvPO0rO3M0NuEarEhBSshF2w58O8qMu6hk0c7d9e8cWFP
   g=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 23 Feb 2022 16:53:47 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 16:53:47 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 23 Feb 2022 16:53:46 -0800
Received: from [10.48.243.226] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Wed, 23 Feb
 2022 16:53:45 -0800
Message-ID: <03cee2a7-1455-b788-e1f0-5fb48db3478c@quicinc.com>
Date:   Wed, 23 Feb 2022 16:53:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 5/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_disconnect_event
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>
References: <cover.1645583264.git.gustavoars@kernel.org>
 <4a42b591109202589cb1cf87df13daef02eb75f9.1645583264.git.gustavoars@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <4a42b591109202589cb1cf87df13daef02eb75f9.1645583264.git.gustavoars@kernel.org>
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

On 2/22/2022 6:39 PM, Gustavo A. R. Silva wrote:
> Replace one-element array with flexible-array member in struct
> wmi_disconnect_event.
> 
> It's also worth noting that due to the flexible array transformation,
> the size of struct wmi_disconnect_event changed (now the size is 1 byte
> smaller), and in order to preserve the logic of before the transformation,
> the following change is needed:
> 
>          -       if (len < sizeof(struct wmi_disconnect_event))
>          +       if (len <= sizeof(struct wmi_disconnect_event))
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
>          -       if (len < sizeof(struct wmi_disconnect_event))
>          +       if (len <= sizeof(struct wmi_disconnect_event))
> 
> Thanks
> 
>   drivers/net/wireless/ath/ath6kl/wmi.c | 2 +-
>   drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index ccdccead688e..645fb6cae3be 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -1023,7 +1023,7 @@ static int ath6kl_wmi_disconnect_event_rx(struct wmi *wmi, u8 *datap, int len,
>   	struct wmi_disconnect_event *ev;
>   	wmi->traffic_class = 100;
>   
> -	if (len < sizeof(struct wmi_disconnect_event))
> +	if (len <= sizeof(struct wmi_disconnect_event))

this is another case where I believe the original code should remain 
since that is checking that the "fixed" portion is present.

and here again what is missing in the original code is logic to verify 
that the provide len is large enough to handle the advertised assoc_resp_len

>   		return -EINVAL;
>   
>   	ev = (struct wmi_disconnect_event *) datap;
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
> index 6b064e669d87..6a7fc07cd9aa 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.h
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.h
> @@ -1596,7 +1596,7 @@ struct wmi_disconnect_event {
>   	u8 disconn_reason;
>   
>   	u8 assoc_resp_len;
> -	u8 assoc_info[1];
> +	u8 assoc_info[];
>   } __packed;
>   
>   /*

