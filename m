Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BA54C219C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 03:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiBXCLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 21:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiBXCLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 21:11:55 -0500
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD843D69;
        Wed, 23 Feb 2022 18:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645668685; x=1677204685;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fZyhYuwnNQimtogeAc+YQ3EaiDLzHnTREqeogFQmmrI=;
  b=bERLsWhCZLj/ZLIGwVBNzuQsFDcycH1TMRsmkG6htHImLbF/IUH+GUzR
   /aNUy0oHYJ0FTrxjXFDaoP4Rj6hSdyIqeT19Uf4pBBEW/9M6A/4BGyF+q
   LADjbXLMFuQ7RQUq+kUvdpukOR6/4Z7uVO9TOtbzk5EEOFhNRQrNggkq+
   E=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 23 Feb 2022 16:49:10 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 16:49:09 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 23 Feb 2022 16:49:09 -0800
Received: from [10.48.243.226] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Wed, 23 Feb
 2022 16:49:08 -0800
Message-ID: <3abb0846-a26f-3d76-8936-cd23cf4387f1@quicinc.com>
Date:   Wed, 23 Feb 2022 16:49:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 3/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_channel_list_reply
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>
References: <cover.1645583264.git.gustavoars@kernel.org>
 <30306253b1b5e6b8f5c0faba97e935eda4638020.1645583264.git.gustavoars@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <30306253b1b5e6b8f5c0faba97e935eda4638020.1645583264.git.gustavoars@kernel.org>
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
> wmi_channel_list_reply.
> 
> It's also worth noting that due to the flexible array transformation,
> the size of struct wmi_channel_list_reply changed, see below.
> 
> Before flex-array transformation:
> 
> struct wmi_channel_list_reply {
> 	u8                         reserved;             /*     0     1 */
> 	u8                         num_ch;               /*     1     1 */
> 	__le16                     ch_list[1];           /*     2     2 */
> 
> 	/* size: 4, cachelines: 1, members: 3 */
> 	/* last cacheline: 4 bytes */
> };
> 
> After flex-array transformation:
> 
> struct wmi_channel_list_reply {
> 	u8                         reserved;             /*     0     1 */
> 	u8                         num_ch;               /*     1     1 */
> 	__le16                     ch_list[];            /*     2     0 */
> 
> 	/* size: 2, cachelines: 1, members: 3 */
> 	/* last cacheline: 2 bytes */
> };
> 
> So, the following change preserves the logic that if _len_ is at least
> 4 bytes in size, this is the existence of at least one channel in
> ch_list[] is being considered, then the execution jumps to call
> ath6kl_wakeup_event(wmi->parent_dev);, otherwise _len_ is 2 bytes or
> less and the code returns -EINVAL:
> 
> 	-       if (len < sizeof(struct wmi_channel_list_reply))
> 	+       if (len <= sizeof(struct wmi_channel_list_reply))
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
> 	-       if (len < sizeof(struct wmi_channel_list_reply))
> 	+       if (len <= sizeof(struct wmi_channel_list_reply))

My opinion is this can remain unchanged since being unchanged would 
correctly handle a channel list with no channels whereas the original 
code required that at least one channel be present.

The test is really there just to make sure the entirety of the "fixed" 
portion of the message is present.

Ultimately it doesn't matter since no actual processing of the channel 
list takes place.

If actual processing took place, then it would make sense to have an 
additional test to verify the len is large enough to handle num_ch entries.


> 
> Thanks
> 
>   drivers/net/wireless/ath/ath6kl/wmi.c | 2 +-
>   drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index bdfc057c5a82..049d75f31f3c 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -1240,7 +1240,7 @@ static int ath6kl_wmi_ratemask_reply_rx(struct wmi *wmi, u8 *datap, int len)
>   
>   static int ath6kl_wmi_ch_list_reply_rx(struct wmi *wmi, u8 *datap, int len)
>   {
> -	if (len < sizeof(struct wmi_channel_list_reply))
> +	if (len <= sizeof(struct wmi_channel_list_reply))
>   		return -EINVAL;
>   
>   	ath6kl_wakeup_event(wmi->parent_dev);
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
> index 9e168752bec2..432e4f428a4a 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.h
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.h
> @@ -1373,7 +1373,7 @@ struct wmi_channel_list_reply {
>   	u8 num_ch;
>   
>   	/* channel in Mhz */
> -	__le16 ch_list[1];
> +	__le16 ch_list[];
>   } __packed;
>   
>   /* List of Events (target to host) */

whether or not you modify the length check consider this:
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
