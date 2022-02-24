Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6454C2137
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 02:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiBXBm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 20:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiBXBmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 20:42:25 -0500
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EFF36165;
        Wed, 23 Feb 2022 17:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645666916; x=1677202916;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Kt6QjyLYTRwOzZP9VnYhf/8ijLxJLwLct45EpDi/FbI=;
  b=e44unWK+leFg2HKumixyVSRMsUotVMEW9UpzLnpFdW4Lan0wofscLHN8
   +VThvWwhRaSj5bYN6C1r+1GpH6kN9k7JypVgqo2wacra/iP0yPMlZuCDJ
   L73ODYqSXtJuCSf7n4u9/vzNCA3EOkAbEcaiOskloA5WB2wmaxYA7vyJQ
   I=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 23 Feb 2022 17:01:49 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 17:01:49 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 23 Feb 2022 17:01:49 -0800
Received: from [10.48.243.226] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Wed, 23 Feb
 2022 17:01:48 -0800
Message-ID: <3f408c80-cabf-5ba2-2014-2eb0550b73f9@quicinc.com>
Date:   Wed, 23 Feb 2022 17:01:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 6/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_aplist_event
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>
References: <cover.1645583264.git.gustavoars@kernel.org>
 <c2116e10dd61869e17fa40a96f1e07a415820575.1645583264.git.gustavoars@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <c2116e10dd61869e17fa40a96f1e07a415820575.1645583264.git.gustavoars@kernel.org>
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
> wmi_aplist_event.
> 
> It's also worth noting that due to the flexible array transformation,
> the size of struct wmi_aplist_event changed (now the size is 8-byte
> smaller), and in order to preserve the logic of before the transformation,
> the following change is needed:
> 
>          -       if (len < sizeof(struct wmi_aplist_event))
>          +       if (len <= sizeof(struct wmi_aplist_event))
> 
> sizeof(struct wmi_aplist_event) before the flex-array transformation:
> 
> struct wmi_aplist_event {
> 	u8                         ap_list_ver;          /*     0     1 */
> 	u8                         num_ap;               /*     1     1 */
> 	union wmi_ap_info          ap_list[1];           /*     2     8 */
> 
> 	/* size: 10, cachelines: 1, members: 3 */
> 	/* last cacheline: 10 bytes */
> };
> 
> sizeof(struct wmi_aplist_event) after the flex-array transformation:
> 
> struct wmi_aplist_event {
> 	u8                         ap_list_ver;          /*     0     1 */
> 	u8                         num_ap;               /*     1     1 */
> 	union wmi_ap_info          ap_list[];            /*     2     0 */
> 
> 	/* size: 2, cachelines: 1, members: 3 */
> 	/* last cacheline: 2 bytes */
> };
> 
> Also, make use of the struct_size() helper and remove unneeded variable
> ap_info_entry_size.
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
>          -       if (len < sizeof(struct wmi_aplist_event))
>          +       if (len <= sizeof(struct wmi_aplist_event))
> 
> Thanks
> 
>   drivers/net/wireless/ath/ath6kl/wmi.c | 7 ++-----
>   drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
>   2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index 645fb6cae3be..484d37e66ce6 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -1750,23 +1750,20 @@ static int ath6kl_wmi_snr_threshold_event_rx(struct wmi *wmi, u8 *datap,
>   
>   static int ath6kl_wmi_aplist_event_rx(struct wmi *wmi, u8 *datap, int len)
>   {
> -	u16 ap_info_entry_size;
>   	struct wmi_aplist_event *ev = (struct wmi_aplist_event *) datap;
>   	struct wmi_ap_info_v1 *ap_info_v1;
>   	u8 index;
>   
> -	if (len < sizeof(struct wmi_aplist_event) ||
> +	if (len <= sizeof(struct wmi_aplist_event) ||

again IMO the original code is preferred since then we can handle a 
0-length list

>   	    ev->ap_list_ver != APLIST_VER1)
>   		return -EINVAL;
>   
> -	ap_info_entry_size = sizeof(struct wmi_ap_info_v1);
>   	ap_info_v1 = (struct wmi_ap_info_v1 *) ev->ap_list;
>   
>   	ath6kl_dbg(ATH6KL_DBG_WMI,
>   		   "number of APs in aplist event: %d\n", ev->num_ap);
>   
> -	if (len < (int) (sizeof(struct wmi_aplist_event) +
> -			 (ev->num_ap - 1) * ap_info_entry_size))
> +	if (len < struct_size(ev, ap_list, ev->num_ap))

and unlike the prior patches in this set, at least the original code 
here had logic to validate len against the metadata that describes the 
number of entries in the list. so this change is good, and also supports 
a 0-length list

>   		return -EINVAL;
>   
>   	/* AP list version 1 contents */
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
> index 6a7fc07cd9aa..a9732660192a 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.h
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.h
> @@ -1957,7 +1957,7 @@ union wmi_ap_info {
>   struct wmi_aplist_event {
>   	u8 ap_list_ver;
>   	u8 num_ap;
> -	union wmi_ap_info ap_list[1];
> +	union wmi_ap_info ap_list[];
>   } __packed;
>   
>   /* Developer Commands */

whether or not you modify the length check consider this:
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
