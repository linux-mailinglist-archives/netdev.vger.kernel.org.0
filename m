Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4B35B7A80
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiIMTFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiIMTFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:05:02 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC653BD;
        Tue, 13 Sep 2022 12:05:01 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28DIGnwJ021401;
        Tue, 13 Sep 2022 19:04:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=IpC2wUwUWey40UM6owh3a0MmnVlbpzDaWHe2xX0ctPE=;
 b=QOLInBaD1/SL3UUKhcGi5q7MOrbtlT65hvq6l5qcbWwE/o0+EIyY7qLK5ZRP/nNGNleI
 4cwdWN0q2RsMnaYaMidOZJfEooHOYwOHzGzfP6WSjNOxms4UhipLn2DeEh3/6YhwGC0s
 HkenHkCPck2EixO7HFdN0MYDth43VEeyEXxFRdfbI3oEy0skqYrixKi2zLdtN/E0MQx+
 P7MR786vw5CHExmv780/U+pnY2GWqvwkQJLP2+m09W2M/K1ox86sOUJKg86c61tIIfti
 uLdX9iYZtyofgv1AM1yDXeY2dY6gVwg0+4Vxr8J0XyE6IKWFk0brzXDNFLe0ETdqup1T DA== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjy0e039c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 19:04:46 +0000
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28DIpRsd013211;
        Tue, 13 Sep 2022 18:51:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 3jj1ubxku9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 18:51:27 +0000
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28DIlOsp009542;
        Tue, 13 Sep 2022 18:51:27 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 28DIpR9P013203
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Sep 2022 18:51:27 +0000
Received: from [10.110.52.115] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 13 Sep
 2022 11:51:25 -0700
Message-ID: <5b0543dc-4db8-aa33-d469-0e185c82b221@quicinc.com>
Date:   Tue, 13 Sep 2022 11:51:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 0/4] Make QMI message rules const
Content-Language: en-US
To:     Alex Elder <elder@ieee.org>, Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
CC:     <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
References: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
 <f2fa19a1-4854-b270-0776-38993dece03f@ieee.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <f2fa19a1-4854-b270-0776-38993dece03f@ieee.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Pub-RnSfiPRai4Z1mkmYQFf4Rdu-yslM
X-Proofpoint-GUID: Pub-RnSfiPRai4Z1mkmYQFf4Rdu-yslM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_09,2022-09-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=888
 suspectscore=0 malwarescore=0 phishscore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209130087
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/13/2022 6:58 AM, Alex Elder wrote:
> On 9/12/22 6:25 PM, Jeff Johnson wrote:
>> Change ff6d365898d ("soc: qcom: qmi: use const for struct
>> qmi_elem_info") allows QMI message encoding/decoding rules to be
>> const. So now update the definitions in the various client to take
>> advantage of this. Patches for ath10k and ath11k were perviously sent
>> separately.
> 
> I have had this on my "to-do list" for ages.
> The commit you mention updates the code to be
> explicit about not modifying this data, which
> is great.
> 
> I scanned over the changes, and I assume that
> all you did was make every object having the
> qmi_elem_info structure type be defined as
> constant.
> 
> Why aren't you changing the "ei_array" field in
> the qmi_elem_info structure to be const?  Or the
> "ei" field of the qmi_msg_handler structure?  And
> the qmi_response_type_v01_ei array (and so on)?
> 
> I like what you're doing, but can you comment
> on what your plans are beyond this series?
> Do you intend to make the rest of these fields
> const?

Hi Alex,
My primary focus is the ath* wireless drivers, and my primary goal was 
to make the tables there const. So this series, along with the two 
out-of-series patches for ath10k and ath11k complete that scope of work.

The lack of the other changes to the QMI data structures is simply due 
to me not looking in depth at the QMI code beyond the registration 
interface.

I'll be happy to revisit this as a separate cleanup.

/jeff

