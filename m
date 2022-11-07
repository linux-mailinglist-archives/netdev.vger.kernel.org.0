Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFBB61F73D
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 16:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiKGPKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 10:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiKGPKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 10:10:45 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E321DDF3;
        Mon,  7 Nov 2022 07:10:44 -0800 (PST)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A7CsHxa031939;
        Mon, 7 Nov 2022 15:10:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=97DbRwlEk3E6duDpQtGKjxqvG1D5WOcOP9p0tcjFgXE=;
 b=Lc3yKjHnk+IV2o0LBlfgxbG8KG48i23CqyNy7JCuKeD0VM6nnFtY+aqpZj7sEzh71ef1
 TlCUK1Bow4DXQ8GEa3c3iV3kt3Ti6dURmm1NwX7kCCxBpywzBTsfRfBKJxXpxzLiS6ut
 2kWeXFZO2fn31qlyec1rB1/BpmE7RbYikhLnOIUNhz2MYG6djd3eKndrv5N5VscglIlu
 WscGewWLQXqhUHGT70UW/OPc1CpuDUMIS6fQYspI5DPgcwyeq0Xpksk8dclEQ6VfY/iZ
 fiA0r97RrbrBogI14shN46CE4UUGBNKGdVI7PgBZnM/FSyFAlkUp2ZHnpdpYiuNW+Zdv PQ== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kpx6nrvxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 15:10:01 +0000
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7FA1Ak003502;
        Mon, 7 Nov 2022 15:10:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 3kngwkqfyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 15:10:01 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7FA0lF003480;
        Mon, 7 Nov 2022 15:10:00 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 2A7FA03l003473
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 15:10:00 +0000
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 7 Nov 2022
 07:09:59 -0800
Message-ID: <9d61676a-888a-b172-141d-62257e2e9e84@quicinc.com>
Date:   Mon, 7 Nov 2022 08:09:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 2/2] wifi: ath11k: use unique QRTR instance ID
Content-Language: en-US
To:     Robert Marko <robimarko@gmail.com>, <mani@kernel.org>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <elder@linaro.org>,
        <hemantk@codeaurora.org>, <quic_qianyu@quicinc.com>,
        <bbhatt@codeaurora.org>, <mhi@lists.linux.dev>,
        <linux-arm-msm@vger.kernel.org>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ansuelsmth@gmail.com>
References: <20221105194943.826847-1-robimarko@gmail.com>
 <20221105194943.826847-2-robimarko@gmail.com>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <20221105194943.826847-2-robimarko@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: knkLWmPQr3B5uSc_8E1wZY65TFXQrRd_
X-Proofpoint-ORIG-GUID: knkLWmPQr3B5uSc_8E1wZY65TFXQrRd_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070122
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/2022 1:49 PM, Robert Marko wrote:
> Currently, trying to use AHB + PCI/MHI cards or multiple PCI/MHI cards
> will cause a clash in the QRTR instance node ID and prevent the driver
> from talking via QMI to the card and thus initializing it with:
> [    9.836329] ath11k c000000.wifi: host capability request failed: 1 90
> [    9.842047] ath11k c000000.wifi: failed to send qmi host cap: -22
> 
> So, in order to allow for this combination of cards, especially AHB + PCI
> cards like IPQ8074 + QCN9074 (Used by me and tested on) set the desired
> QRTR instance ID offset by calculating a unique one based on PCI domain
> and bus ID-s and writing it to bits 7-0 of BHI_ERRDBG2 MHI register by
> using the SBL state callback that is added as part of the series.
> We also have to make sure that new QRTR offset is added on top of the
> default QRTR instance ID-s that are currently used in the driver.
> 
> This finally allows using AHB + PCI or multiple PCI cards on the same
> system.
> 
> Before:
> root@OpenWrt:/# qrtr-lookup
>    Service Version Instance Node  Port
>       1054       1        0    7     1 <unknown>
>         69       1        2    7     3 ATH10k WLAN firmware service
> 
> After:
> root@OpenWrt:/# qrtr-lookup
>    Service Version Instance Node  Port
>       1054       1        0    7     1 <unknown>
>         69       1        2    7     3 ATH10k WLAN firmware service
>         15       1        0    8     1 Test service
>         69       1        8    8     2 ATH10k WLAN firmware service
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Robert Marko <robimarko@gmail.com>
> ---
>   drivers/net/wireless/ath/ath11k/mhi.c | 47 ++++++++++++++++++---------
>   drivers/net/wireless/ath/ath11k/mhi.h |  3 ++
>   drivers/net/wireless/ath/ath11k/pci.c |  5 ++-
>   3 files changed, 38 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
> index 86995e8dc913..23e85ea902f5 100644
> --- a/drivers/net/wireless/ath/ath11k/mhi.c
> +++ b/drivers/net/wireless/ath/ath11k/mhi.c
> @@ -294,6 +294,32 @@ static void ath11k_mhi_op_runtime_put(struct mhi_controller *mhi_cntrl)
>   {
>   }
>   
> +static int ath11k_mhi_op_read_reg(struct mhi_controller *mhi_cntrl,
> +				  void __iomem *addr,
> +				  u32 *out)
> +{
> +	*out = readl(addr);
> +
> +	return 0;
> +}
> +
> +static void ath11k_mhi_op_write_reg(struct mhi_controller *mhi_cntrl,
> +				    void __iomem *addr,
> +				    u32 val)
> +{
> +	writel(val, addr);
> +}
> +
> +static void ath11k_mhi_qrtr_instance_set(struct mhi_controller *mhi_cntrl)
> +{
> +	struct ath11k_base *ab = dev_get_drvdata(mhi_cntrl->cntrl_dev);
> +
> +	ath11k_mhi_op_write_reg(mhi_cntrl,
> +				mhi_cntrl->bhi + BHI_ERRDBG2,
> +				FIELD_PREP(QRTR_INSTANCE_MASK,
> +				ab->qmi.service_ins_id - ab->hw_params.qmi_service_ins_id));
> +}

What kind of synchronization is there for this?

Does SBL spin until this is set?

What would prevent SBL from booting, sending the notification to the 
host, and then quickly entering runtime mode before the host had a 
chance to get here?


> +
>   static char *ath11k_mhi_op_callback_to_str(enum mhi_callback reason)
>   {
>   	switch (reason) {
> @@ -315,6 +341,8 @@ static char *ath11k_mhi_op_callback_to_str(enum mhi_callback reason)
>   		return "MHI_CB_FATAL_ERROR";
>   	case MHI_CB_BW_REQ:
>   		return "MHI_CB_BW_REQ";
> +	case MHI_CB_EE_SBL_MODE:
> +		return "MHI_CB_EE_SBL_MODE";
>   	default:
>   		return "UNKNOWN";
>   	}
> @@ -336,27 +364,14 @@ static void ath11k_mhi_op_status_cb(struct mhi_controller *mhi_cntrl,
>   		if (!(test_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags)))
>   			queue_work(ab->workqueue_aux, &ab->reset_work);
>   		break;
> +	case MHI_CB_EE_SBL_MODE:
> +		ath11k_mhi_qrtr_instance_set(mhi_cntrl);
> +		break;
>   	default:
>   		break;
>   	}
>   }
>   
> -static int ath11k_mhi_op_read_reg(struct mhi_controller *mhi_cntrl,
> -				  void __iomem *addr,
> -				  u32 *out)
> -{
> -	*out = readl(addr);
> -
> -	return 0;
> -}
> -
> -static void ath11k_mhi_op_write_reg(struct mhi_controller *mhi_cntrl,
> -				    void __iomem *addr,
> -				    u32 val)
> -{
> -	writel(val, addr);
> -}
> -
>   static int ath11k_mhi_read_addr_from_dt(struct mhi_controller *mhi_ctrl)
>   {
>   	struct device_node *np;
> diff --git a/drivers/net/wireless/ath/ath11k/mhi.h b/drivers/net/wireless/ath/ath11k/mhi.h
> index 8d9f852da695..0db308bc3047 100644
> --- a/drivers/net/wireless/ath/ath11k/mhi.h
> +++ b/drivers/net/wireless/ath/ath11k/mhi.h
> @@ -16,6 +16,9 @@
>   #define MHICTRL					0x38
>   #define MHICTRL_RESET_MASK			0x2
>   
> +#define BHI_ERRDBG2				0x38
> +#define QRTR_INSTANCE_MASK			GENMASK(7, 0)
> +
>   int ath11k_mhi_start(struct ath11k_pci *ar_pci);
>   void ath11k_mhi_stop(struct ath11k_pci *ar_pci);
>   int ath11k_mhi_register(struct ath11k_pci *ar_pci);
> diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
> index 99cf3357c66e..cd26c1567415 100644
> --- a/drivers/net/wireless/ath/ath11k/pci.c
> +++ b/drivers/net/wireless/ath/ath11k/pci.c
> @@ -370,13 +370,16 @@ static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
>   static void ath11k_pci_init_qmi_ce_config(struct ath11k_base *ab)
>   {
>   	struct ath11k_qmi_ce_cfg *cfg = &ab->qmi.ce_cfg;
> +	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
> +	struct pci_bus *bus = ab_pci->pdev->bus;
>   
>   	cfg->tgt_ce = ab->hw_params.target_ce_config;
>   	cfg->tgt_ce_len = ab->hw_params.target_ce_count;
>   
>   	cfg->svc_to_ce_map = ab->hw_params.svc_to_ce_map;
>   	cfg->svc_to_ce_map_len = ab->hw_params.svc_to_ce_map_len;
> -	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id;
> +	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id +
> +	(((pci_domain_nr(bus) & 0xF) << 4) | (bus->number & 0xF));
>   
>   	ath11k_ce_get_shadow_config(ab, &cfg->shadow_reg_v2,
>   				    &cfg->shadow_reg_v2_len);

