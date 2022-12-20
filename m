Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5434E652040
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiLTMPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiLTMO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 07:14:59 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4CF186D0;
        Tue, 20 Dec 2022 04:14:58 -0800 (PST)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKABAMI032452;
        Tue, 20 Dec 2022 12:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=wLqDcO+Wsi26P0nos/+8/kSQfghM5ThFrgbZ4/Pqpn8=;
 b=jVXUPoovH6l3UXbdHTkvrxkegxnp9pGaYIGsoK8PPCPQqIyEgHztqL+dn0fLRDj1dAQu
 iVegfwcwYkmvD2UQPSwNMS2B2SShNkEtJx7yCngp7RifeS5cWlhdQCF+FkduNx3GfLkx
 gz4XDNWR8wDM8u/0Fq/+H6MIhFWPntWkzgJRWDCfUxgl+8uhFbY/ouyXdLn+1Jz90cKP
 Mr/XgXuSbtZ7Ut9LuS3NsGwdI2Rq1YHTM1W8dYwJFjjG/oAPY1HJIQ6OeHTtJWBe4uqT
 i4s9LMEvJ88oz6PZNOcWWFWHpQMr8MBRmiKlq8nPGGz+YqX2vRiYydjb/+PzzdshSYQZ hQ== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mk39t96pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 12:14:40 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2BKCEdqR003361
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 12:14:39 GMT
Received: from [10.216.28.180] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 20 Dec
 2022 04:14:35 -0800
Message-ID: <56d4941a-ad35-37ca-48ca-5f1bf7a86d25@quicinc.com>
Date:   Tue, 20 Dec 2022 17:44:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] ath10k: snoc: enable threaded napi on WCN3990
Content-Language: en-US
To:     Abhishek Kumar <kuabhs@chromium.org>, <kvalo@kernel.org>
CC:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221220075215.1.Ic12e347e0d61a618124b742614e82bbd5d770173@changeid>
From:   Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
In-Reply-To: <20221220075215.1.Ic12e347e0d61a618124b742614e82bbd5d770173@changeid>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: y7oCJvTmlbthnqGTIZ5zOR0qIdiaHjqF
X-Proofpoint-GUID: y7oCJvTmlbthnqGTIZ5zOR0qIdiaHjqF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_05,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200101
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/2022 1:25 PM, Abhishek Kumar wrote:
> NAPI poll can be done in threaded context along with soft irq
> context. Threaded context can be scheduled efficiently, thus
> creating less of bottleneck during Rx processing. This patch is
> to enable threaded NAPI on ath10k driver.
> 
> Based on testing, it was observed that on WCN3990, the CPU0 reaches
> 100% utilization when napi runs in softirq context. At the same
> time the other CPUs are at low consumption percentage. This
> does not allow device to reach its maximum throughput potential.
> After enabling threaded napi, CPU load is balanced across all CPUs
> and following improvments were observed:
> - UDP_RX increase by ~22-25%
> - TCP_RX increase by ~15%
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
> 
>   drivers/net/wireless/ath/ath10k/core.c | 16 ++++++++++++++++
>   drivers/net/wireless/ath/ath10k/hw.h   |  2 ++
>   drivers/net/wireless/ath/ath10k/snoc.c |  3 +++
>   3 files changed, 21 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 5eb131ab916fd..ee4b6ba508c81 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -100,6 +100,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA988X_HW_2_0_VERSION,
> @@ -140,6 +141,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA9887_HW_1_0_VERSION,
> @@ -181,6 +183,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA6174_HW_3_2_VERSION,
> @@ -217,6 +220,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA6174_HW_2_1_VERSION,
> @@ -257,6 +261,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA6174_HW_2_1_VERSION,
> @@ -297,6 +302,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA6174_HW_3_0_VERSION,
> @@ -337,6 +343,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA6174_HW_3_2_VERSION,
> @@ -381,6 +388,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA99X0_HW_2_0_DEV_VERSION,
> @@ -427,6 +435,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA9984_HW_1_0_DEV_VERSION,
> @@ -480,6 +489,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA9888_HW_2_0_DEV_VERSION,
> @@ -530,6 +540,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA9377_HW_1_0_DEV_VERSION,
> @@ -570,6 +581,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA9377_HW_1_1_DEV_VERSION,
> @@ -612,6 +624,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA9377_HW_1_1_DEV_VERSION,
> @@ -645,6 +658,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = QCA4019_HW_1_0_DEV_VERSION,
> @@ -692,6 +706,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = false,
>   		.use_fw_tx_credits = true,
>   		.delay_unmap_buffer = false,
> +		.enable_threaded_napi = false,
>   	},
>   	{
>   		.id = WCN3990_HW_1_0_DEV_VERSION,
> @@ -725,6 +740,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>   		.hw_restart_disconnect = true,
>   		.use_fw_tx_credits = false,
>   		.delay_unmap_buffer = true,
> +		.enable_threaded_napi = true,
>   	},
>   };
>   
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index 9643031a4427a..adf3076b96503 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -639,6 +639,8 @@ struct ath10k_hw_params {
>   	bool use_fw_tx_credits;
>   
>   	bool delay_unmap_buffer;
> +
> +	bool enable_threaded_napi;
>   };
>   
>   struct htt_resp;
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index cfcb759a87dea..b94150fb6ef06 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -927,6 +927,9 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
>   
>   	bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
>   
> +	if (ar->hw_params.enable_threaded_napi)
> +		dev_set_threaded(&ar->napi_dev, true);
> +

Since this is done in the API specific to WCN3990, we do not need 
hw_param for this.

Thanks,
Manikanta
