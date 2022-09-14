Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802265B8655
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiINK0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiINK0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:26:38 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779BE6AA22;
        Wed, 14 Sep 2022 03:26:34 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28E9mte0007852;
        Wed, 14 Sep 2022 10:26:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=YEISDO6tRN2BKZmf1zGjPFjG8txfCf6PeSIqZVu3kcM=;
 b=TL5yKDVh/yaeYS9WmvGBBuEyLl7zxW1h1w2itMnTjp2MMbbmyNtNDRpAOQT4fD6oUGrX
 QusZ9K7oSTLIhWKOGalS9GhZUnznWfW2ue695Jfatf4geR8N5ykLIPgzh/fsu3BqFgwU
 c4NTv5FiyFG0YpITSt6y9dPdAqPktgjGJaDIgzDzvXCdgFzi5kvzzxprZSW9iysxAHwF
 ycxg2o+DVxOMNu2oK2n3wVmCZwBYDpD/D+CMVv3uAAlT1VMUF0ezrXdpjmNDd9udhU/Y
 sh6TK6FnTZv+CXS5MMmnRvduwKigOCGxXDvxNAqT9xR5wWmNWTyIq7bO7ZSRh1XGlSYD Dg== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjxys27r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 10:26:23 +0000
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28EAQLXV008247;
        Wed, 14 Sep 2022 10:26:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 3jh430w719-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 10:26:21 +0000
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28EAQLQD008237;
        Wed, 14 Sep 2022 10:26:21 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 28EAQLa0008236
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 10:26:21 +0000
Received: from [10.79.43.230] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 03:26:17 -0700
Subject: Re: [PATCH 3/4] slimbus: qcom-ngd-ctrl: Make QMI message rules const
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
From:   Sibi Sankar <quic_sibis@quicinc.com>
Message-ID: <7237445c-98fa-ef2b-8cdb-75656a724422@quicinc.com>
Date:   Wed, 14 Sep 2022 15:56:14 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220912232526.27427-4-quic_jjohnson@quicinc.com>
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
X-Proofpoint-ORIG-GUID: iaPqmHGDL_hzox27I1LdgUEUrqf183jx
X-Proofpoint-GUID: iaPqmHGDL_hzox27I1LdgUEUrqf183jx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_03,2022-09-14_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
> const, so do that for qcom-ngd-ctrl.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>

Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>

> ---
>   drivers/slimbus/qcom-ngd-ctrl.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
> index 0aa8408464ad..931ab6317467 100644
> --- a/drivers/slimbus/qcom-ngd-ctrl.c
> +++ b/drivers/slimbus/qcom-ngd-ctrl.c
> @@ -220,7 +220,7 @@ struct slimbus_power_resp_msg_v01 {
>   	struct qmi_response_type_v01 resp;
>   };
>   
> -static struct qmi_elem_info slimbus_select_inst_req_msg_v01_ei[] = {
> +static const struct qmi_elem_info slimbus_select_inst_req_msg_v01_ei[] = {
>   	{
>   		.data_type  = QMI_UNSIGNED_4_BYTE,
>   		.elem_len   = 1,
> @@ -262,7 +262,7 @@ static struct qmi_elem_info slimbus_select_inst_req_msg_v01_ei[] = {
>   	},
>   };
>   
> -static struct qmi_elem_info slimbus_select_inst_resp_msg_v01_ei[] = {
> +static const struct qmi_elem_info slimbus_select_inst_resp_msg_v01_ei[] = {
>   	{
>   		.data_type  = QMI_STRUCT,
>   		.elem_len   = 1,
> @@ -284,7 +284,7 @@ static struct qmi_elem_info slimbus_select_inst_resp_msg_v01_ei[] = {
>   	},
>   };
>   
> -static struct qmi_elem_info slimbus_power_req_msg_v01_ei[] = {
> +static const struct qmi_elem_info slimbus_power_req_msg_v01_ei[] = {
>   	{
>   		.data_type  = QMI_UNSIGNED_4_BYTE,
>   		.elem_len   = 1,
> @@ -324,7 +324,7 @@ static struct qmi_elem_info slimbus_power_req_msg_v01_ei[] = {
>   	},
>   };
>   
> -static struct qmi_elem_info slimbus_power_resp_msg_v01_ei[] = {
> +static const struct qmi_elem_info slimbus_power_resp_msg_v01_ei[] = {
>   	{
>   		.data_type  = QMI_STRUCT,
>   		.elem_len   = 1,
> 
