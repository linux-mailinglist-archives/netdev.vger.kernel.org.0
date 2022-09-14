Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699CD5B8617
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiINKTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiINKTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:19:07 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB89786DE;
        Wed, 14 Sep 2022 03:19:06 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28EAEmUd001145;
        Wed, 14 Sep 2022 10:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=TauJo4S33vubiSKMJ8vkdsBpJE36madk8or1JdPhPtE=;
 b=owEMl6AOMvp0gM+XCVPA+DAuIvwts+9qcvs5p0+ATTATOxq5gsI042eFqY3LtH6lW817
 pazqUs6PZly1aKhS4XTQj4/EABeCeCyOVKdSWEjDXgPazjGeEg4yj56VdilzP5ljGKdE
 ThPo8/22y9trmcxzqg9tGSqoKXG5pnFV8zKgPD30+NLaYTedY+PvDwTZGWfG2DZXD7xT
 zIDZnjpNumcuFIDG8S7r1EHd8ypefjrlt5B5cW1bgu+yeZqjX7pQd8ZLuxY8pDp9mxxA
 4kVSo6jOk2c9mcBvUUIAPSmx9RRr25DzMe1mFj4idKfc78UTMEwagkaBpGGb1HpJSMNw aw== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjxyva6be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 10:18:52 +0000
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28EAIp5D031835;
        Wed, 14 Sep 2022 10:18:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 3jjqbt4rfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 10:18:51 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28EAIpIO031830;
        Wed, 14 Sep 2022 10:18:51 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 28EAIooi031829
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 10:18:50 +0000
Received: from [10.79.43.230] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 03:18:46 -0700
Subject: Re: [PATCH 4/4] soc: qcom: pdr: Make QMI message rules const
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
 <20220912232526.27427-3-quic_jjohnson@quicinc.com>
 <20220912232526.27427-4-quic_jjohnson@quicinc.com>
 <20220912232526.27427-5-quic_jjohnson@quicinc.com>
From:   Sibi Sankar <quic_sibis@quicinc.com>
Message-ID: <f8f43b22-bb13-71ff-15fc-a323d0b56ead@quicinc.com>
Date:   Wed, 14 Sep 2022 15:48:43 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220912232526.27427-5-quic_jjohnson@quicinc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: bMVDI2dAzz-eh0sNk3DHpUhUOHYrziiX
X-Proofpoint-ORIG-GUID: bMVDI2dAzz-eh0sNk3DHpUhUOHYrziiX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_03,2022-09-14_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 priorityscore=1501 clxscore=1011 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
> const, so do that for QCOM PDR.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>

Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>

> ---
>   drivers/soc/qcom/pdr_internal.h | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/soc/qcom/pdr_internal.h b/drivers/soc/qcom/pdr_internal.h
> index a30422214943..03c282b7f17e 100644
> --- a/drivers/soc/qcom/pdr_internal.h
> +++ b/drivers/soc/qcom/pdr_internal.h
> @@ -28,7 +28,7 @@ struct servreg_location_entry {
>   	u32 instance;
>   };
>   
> -static struct qmi_elem_info servreg_location_entry_ei[] = {
> +static const struct qmi_elem_info servreg_location_entry_ei[] = {
>   	{
>   		.data_type      = QMI_STRING,
>   		.elem_len       = SERVREG_NAME_LENGTH + 1,
> @@ -74,7 +74,7 @@ struct servreg_get_domain_list_req {
>   	u32 domain_offset;
>   };
>   
> -static struct qmi_elem_info servreg_get_domain_list_req_ei[] = {
> +static const struct qmi_elem_info servreg_get_domain_list_req_ei[] = {
>   	{
>   		.data_type      = QMI_STRING,
>   		.elem_len       = SERVREG_NAME_LENGTH + 1,
> @@ -116,7 +116,7 @@ struct servreg_get_domain_list_resp {
>   	struct servreg_location_entry domain_list[SERVREG_DOMAIN_LIST_LENGTH];
>   };
>   
> -static struct qmi_elem_info servreg_get_domain_list_resp_ei[] = {
> +static const struct qmi_elem_info servreg_get_domain_list_resp_ei[] = {
>   	{
>   		.data_type      = QMI_STRUCT,
>   		.elem_len       = 1,
> @@ -199,7 +199,7 @@ struct servreg_register_listener_req {
>   	char service_path[SERVREG_NAME_LENGTH + 1];
>   };
>   
> -static struct qmi_elem_info servreg_register_listener_req_ei[] = {
> +static const struct qmi_elem_info servreg_register_listener_req_ei[] = {
>   	{
>   		.data_type      = QMI_UNSIGNED_1_BYTE,
>   		.elem_len       = 1,
> @@ -227,7 +227,7 @@ struct servreg_register_listener_resp {
>   	enum servreg_service_state curr_state;
>   };
>   
> -static struct qmi_elem_info servreg_register_listener_resp_ei[] = {
> +static const struct qmi_elem_info servreg_register_listener_resp_ei[] = {
>   	{
>   		.data_type      = QMI_STRUCT,
>   		.elem_len       = 1,
> @@ -263,7 +263,7 @@ struct servreg_restart_pd_req {
>   	char service_path[SERVREG_NAME_LENGTH + 1];
>   };
>   
> -static struct qmi_elem_info servreg_restart_pd_req_ei[] = {
> +static const struct qmi_elem_info servreg_restart_pd_req_ei[] = {
>   	{
>   		.data_type      = QMI_STRING,
>   		.elem_len       = SERVREG_NAME_LENGTH + 1,
> @@ -280,7 +280,7 @@ struct servreg_restart_pd_resp {
>   	struct qmi_response_type_v01 resp;
>   };
>   
> -static struct qmi_elem_info servreg_restart_pd_resp_ei[] = {
> +static const struct qmi_elem_info servreg_restart_pd_resp_ei[] = {
>   	{
>   		.data_type      = QMI_STRUCT,
>   		.elem_len       = 1,
> @@ -300,7 +300,7 @@ struct servreg_state_updated_ind {
>   	u16 transaction_id;
>   };
>   
> -static struct qmi_elem_info servreg_state_updated_ind_ei[] = {
> +static const struct qmi_elem_info servreg_state_updated_ind_ei[] = {
>   	{
>   		.data_type      = QMI_SIGNED_4_BYTE_ENUM,
>   		.elem_len       = 1,
> @@ -336,7 +336,7 @@ struct servreg_set_ack_req {
>   	u16 transaction_id;
>   };
>   
> -static struct qmi_elem_info servreg_set_ack_req_ei[] = {
> +static const struct qmi_elem_info servreg_set_ack_req_ei[] = {
>   	{
>   		.data_type      = QMI_STRING,
>   		.elem_len       = SERVREG_NAME_LENGTH + 1,
> @@ -362,7 +362,7 @@ struct servreg_set_ack_resp {
>   	struct qmi_response_type_v01 resp;
>   };
>   
> -static struct qmi_elem_info servreg_set_ack_resp_ei[] = {
> +static const struct qmi_elem_info servreg_set_ack_resp_ei[] = {
>   	{
>   		.data_type      = QMI_STRUCT,
>   		.elem_len       = 1,
> 
