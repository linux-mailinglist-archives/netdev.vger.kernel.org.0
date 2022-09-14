Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F515B8636
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiINKWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiINKWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:22:40 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3AD7A52B;
        Wed, 14 Sep 2022 03:22:39 -0700 (PDT)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28E9SuJw008032;
        Wed, 14 Sep 2022 10:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=eEkLslpr+tNgGZKF+emI7z6RQzFcHb8DKHBoODfssng=;
 b=DPbru+WzqsAQrA3Zt8Z1XhX+nT2lFWfDBWGPQsp9zZx9ZfwcEGKzFdj5HmIN7X5KWGlC
 /eyF6J51bwzlxpTRSzBb5+BEE1m0pbzaLJlw85772vMhwGNKyGFWNI1lHpAtu2WgrZS9
 VnLPk7Wt3q1FD07Z6G61TloY7HlVonLj4vgd5rmoLHouGdpsaoC0Yb9hjWDG3wNEi68a
 gvDvJ5r3yULL/eK6kYdhqSfaG8V6LCF/mCN6TES6AfuNJbB1ybKjBZ51+V6uuFrqqEhD
 8Eba3+gK1kk+cjg78OiouFQJIYQ3/zor4Qnjw5KgaLxbJNoH7CKprxarPq9wsqnynsXx ZQ== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjy0c9ut7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 10:22:22 +0000
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28EAJMaC008864;
        Wed, 14 Sep 2022 10:22:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 3jh45kn765-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 10:22:21 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28EAJigW009529;
        Wed, 14 Sep 2022 10:22:21 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 28EAMK1V012539
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 10:22:20 +0000
Received: from [10.79.43.230] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 03:22:15 -0700
Subject: Re: [PATCH 1/4] net: ipa: Make QMI message rules const
To:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Mathieu Poirier" <mathieu.poirier@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "Konrad Dybcio" <konrad.dybcio@somainline.org>
CC:     <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
References: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
 <20220912232526.27427-2-quic_jjohnson@quicinc.com>
From:   Sibi Sankar <quic_sibis@quicinc.com>
Message-ID: <4fe0283d-d2f4-a593-0748-a180e3589832@quicinc.com>
Date:   Wed, 14 Sep 2022 15:52:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220912232526.27427-2-quic_jjohnson@quicinc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: WhKfS7_gS2wQmYILn1N4lixApnkS-2dD
X-Proofpoint-GUID: WhKfS7_gS2wQmYILn1N4lixApnkS-2dD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_03,2022-09-14_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209140050
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/22 4:55 AM, Jeff Johnson wrote:
> Commit ff6d365898d ("soc: qcom: qmi: use const for struct
> qmi_elem_info") allows QMI message encoding/decoding rules to be
> const, so do that for IPA.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>

Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>

> ---
>   drivers/net/ipa/ipa_qmi_msg.c | 20 ++++++++++----------
>   drivers/net/ipa/ipa_qmi_msg.h | 20 ++++++++++----------
>   2 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
> index 6838e8065072..c5a5dac284a9 100644
> --- a/drivers/net/ipa/ipa_qmi_msg.c
> +++ b/drivers/net/ipa/ipa_qmi_msg.c
> @@ -9,7 +9,7 @@
>   #include "ipa_qmi_msg.h"
>   
>   /* QMI message structure definition for struct ipa_indication_register_req */
> -struct qmi_elem_info ipa_indication_register_req_ei[] = {
> +const struct qmi_elem_info ipa_indication_register_req_ei[] = {
>   	{
>   		.data_type	= QMI_OPT_FLAG,
>   		.elem_len	= 1,
> @@ -116,7 +116,7 @@ struct qmi_elem_info ipa_indication_register_req_ei[] = {
>   };
>   
>   /* QMI message structure definition for struct ipa_indication_register_rsp */
> -struct qmi_elem_info ipa_indication_register_rsp_ei[] = {
> +const struct qmi_elem_info ipa_indication_register_rsp_ei[] = {
>   	{
>   		.data_type	= QMI_STRUCT,
>   		.elem_len	= 1,
> @@ -134,7 +134,7 @@ struct qmi_elem_info ipa_indication_register_rsp_ei[] = {
>   };
>   
>   /* QMI message structure definition for struct ipa_driver_init_complete_req */
> -struct qmi_elem_info ipa_driver_init_complete_req_ei[] = {
> +const struct qmi_elem_info ipa_driver_init_complete_req_ei[] = {
>   	{
>   		.data_type	= QMI_UNSIGNED_1_BYTE,
>   		.elem_len	= 1,
> @@ -151,7 +151,7 @@ struct qmi_elem_info ipa_driver_init_complete_req_ei[] = {
>   };
>   
>   /* QMI message structure definition for struct ipa_driver_init_complete_rsp */
> -struct qmi_elem_info ipa_driver_init_complete_rsp_ei[] = {
> +const struct qmi_elem_info ipa_driver_init_complete_rsp_ei[] = {
>   	{
>   		.data_type	= QMI_STRUCT,
>   		.elem_len	= 1,
> @@ -169,7 +169,7 @@ struct qmi_elem_info ipa_driver_init_complete_rsp_ei[] = {
>   };
>   
>   /* QMI message structure definition for struct ipa_init_complete_ind */
> -struct qmi_elem_info ipa_init_complete_ind_ei[] = {
> +const struct qmi_elem_info ipa_init_complete_ind_ei[] = {
>   	{
>   		.data_type	= QMI_STRUCT,
>   		.elem_len	= 1,
> @@ -187,7 +187,7 @@ struct qmi_elem_info ipa_init_complete_ind_ei[] = {
>   };
>   
>   /* QMI message structure definition for struct ipa_mem_bounds */
> -struct qmi_elem_info ipa_mem_bounds_ei[] = {
> +const struct qmi_elem_info ipa_mem_bounds_ei[] = {
>   	{
>   		.data_type	= QMI_UNSIGNED_4_BYTE,
>   		.elem_len	= 1,
> @@ -208,7 +208,7 @@ struct qmi_elem_info ipa_mem_bounds_ei[] = {
>   };
>   
>   /* QMI message structure definition for struct ipa_mem_array */
> -struct qmi_elem_info ipa_mem_array_ei[] = {
> +const struct qmi_elem_info ipa_mem_array_ei[] = {
>   	{
>   		.data_type	= QMI_UNSIGNED_4_BYTE,
>   		.elem_len	= 1,
> @@ -229,7 +229,7 @@ struct qmi_elem_info ipa_mem_array_ei[] = {
>   };
>   
>   /* QMI message structure definition for struct ipa_mem_range */
> -struct qmi_elem_info ipa_mem_range_ei[] = {
> +const struct qmi_elem_info ipa_mem_range_ei[] = {
>   	{
>   		.data_type	= QMI_UNSIGNED_4_BYTE,
>   		.elem_len	= 1,
> @@ -250,7 +250,7 @@ struct qmi_elem_info ipa_mem_range_ei[] = {
>   };
>   
>   /* QMI message structure definition for struct ipa_init_modem_driver_req */
> -struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
> +const struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
>   	{
>   		.data_type	= QMI_OPT_FLAG,
>   		.elem_len	= 1,
> @@ -645,7 +645,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
>   };
>   
>   /* QMI message structure definition for struct ipa_init_modem_driver_rsp */
> -struct qmi_elem_info ipa_init_modem_driver_rsp_ei[] = {
> +const struct qmi_elem_info ipa_init_modem_driver_rsp_ei[] = {
>   	{
>   		.data_type	= QMI_STRUCT,
>   		.elem_len	= 1,
> diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
> index 495e85abe50b..8dfac59ea0ed 100644
> --- a/drivers/net/ipa/ipa_qmi_msg.h
> +++ b/drivers/net/ipa/ipa_qmi_msg.h
> @@ -242,15 +242,15 @@ struct ipa_init_modem_driver_rsp {
>   };
>   
>   /* Message structure definitions defined in "ipa_qmi_msg.c" */
> -extern struct qmi_elem_info ipa_indication_register_req_ei[];
> -extern struct qmi_elem_info ipa_indication_register_rsp_ei[];
> -extern struct qmi_elem_info ipa_driver_init_complete_req_ei[];
> -extern struct qmi_elem_info ipa_driver_init_complete_rsp_ei[];
> -extern struct qmi_elem_info ipa_init_complete_ind_ei[];
> -extern struct qmi_elem_info ipa_mem_bounds_ei[];
> -extern struct qmi_elem_info ipa_mem_array_ei[];
> -extern struct qmi_elem_info ipa_mem_range_ei[];
> -extern struct qmi_elem_info ipa_init_modem_driver_req_ei[];
> -extern struct qmi_elem_info ipa_init_modem_driver_rsp_ei[];
> +extern const struct qmi_elem_info ipa_indication_register_req_ei[];
> +extern const struct qmi_elem_info ipa_indication_register_rsp_ei[];
> +extern const struct qmi_elem_info ipa_driver_init_complete_req_ei[];
> +extern const struct qmi_elem_info ipa_driver_init_complete_rsp_ei[];
> +extern const struct qmi_elem_info ipa_init_complete_ind_ei[];
> +extern const struct qmi_elem_info ipa_mem_bounds_ei[];
> +extern const struct qmi_elem_info ipa_mem_array_ei[];
> +extern const struct qmi_elem_info ipa_mem_range_ei[];
> +extern const struct qmi_elem_info ipa_init_modem_driver_req_ei[];
> +extern const struct qmi_elem_info ipa_init_modem_driver_rsp_ei[];
>   
>   #endif /* !_IPA_QMI_MSG_H_ */
> 
