Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2549E6AA0DA
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 22:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbjCCVJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 16:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjCCVJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 16:09:38 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685996150D;
        Fri,  3 Mar 2023 13:09:35 -0800 (PST)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 323Hw71Q027393;
        Fri, 3 Mar 2023 21:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : from : subject : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=0GV0GIblVbFArHNpmZ1Srz0Rk2Sez5YtbO96Shw/C94=;
 b=K3GuB/c67HB+9X5scaPeKggDaitwzAl87gNnC3C2vueKKu5ykHfKheQhr1xKU/22aTAG
 2+qjLzzrcdUMfHDrMM8J2lxHIyVHw3312cEHlYqeO4nzKWp0jVnGkb3wsqgDTsz83U2S
 nuBYJpzVB0bP0JlKacrywW+IItuotYBNMh/5qrIlH2w3bzY3RVFj2YEo71ZnLw2D5cs0
 kiHUZjliGhYkEWITN3YHvZZeHW/E9PUMeEH2Yv/bx3TZjK2WeuMe2bZZma6hvZxrc/Ta
 tyt1/AmHVAK43H2/wqZIiWRyYD0i8xWBH4KecTVsak0SRfxB0QClW+YoH0gbO2hx0Rh5 zQ== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3p3dpxj579-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 21:09:11 +0000
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 323L9ALS015416
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 3 Mar 2023 21:09:10 GMT
Received: from [10.110.20.90] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 3 Mar 2023
 13:09:09 -0800
Message-ID: <2ae96b75-82f1-165a-e56d-7446c90bb7af@quicinc.com>
Date:   Fri, 3 Mar 2023 13:09:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From:   Elliot Berman <quic_eberman@quicinc.com>
Subject: Re: [PATCH] firmware: qcom_scm: Use fixed width src vm bitmap
To:     Bjorn Andersson <andersson@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        "Gokul krishna Krishnakumar" <quic_gokukris@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-remoteproc@vger.kernel.org>
References: <20230213181832.3489174-1-quic_eberman@quicinc.com>
 <20230213214417.mtcpeultvynyls6s@ripper> <Y+tNRPf0PGdShf5l@kroah.com>
 <20230214172325.lplxgbprhj3bzvr3@ripper>
 <bdda82f7-933d-443b-614a-6befad2899b5@quicinc.com>
Content-Language: en-US
In-Reply-To: <bdda82f7-933d-443b-614a-6befad2899b5@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: fFgsdjU-gZTIeIOv6LUxDDseAdoa3PuQ
X-Proofpoint-GUID: fFgsdjU-gZTIeIOv6LUxDDseAdoa3PuQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_05,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 clxscore=1011 priorityscore=1501 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303030177
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/2023 10:52 AM, Elliot Berman wrote:
> 
> 
> On 2/14/2023 9:23 AM, Bjorn Andersson wrote:
>> On Tue, Feb 14, 2023 at 09:58:44AM +0100, Greg Kroah-Hartman wrote:
>>> On Mon, Feb 13, 2023 at 01:44:17PM -0800, Bjorn Andersson wrote:
>>>> On Mon, Feb 13, 2023 at 10:18:29AM -0800, Elliot Berman wrote:
>>>>> The maximum VMID for assign_mem is 63. Use a u64 to represent this
>>>>> bitmap instead of architecture-dependent "unsigned int" which 
>>>>> varies in
>>>>> size on 32-bit and 64-bit platforms.
>>>>>
>>>>> Acked-by: Kalle Valo <kvalo@kernel.org> (ath10k)
>>>>> Tested-by: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
>>>>> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
>>>>
>>>> Reviewed-by: Bjorn Andersson <andersson@kernel.org>
>>>>
>>>> @Greg, would you mind taking this through your tree for v6.3, you
>>>> already have a related change in fastrpc.c in your tree...
>>>
>>> I tried, but it doesn't apply to my char-misc tree at all:
>>>
>>> checking file drivers/firmware/qcom_scm.c
>>> Hunk #1 succeeded at 898 (offset -7 lines).
>>> Hunk #2 succeeded at 915 (offset -7 lines).
>>> Hunk #3 succeeded at 930 (offset -7 lines).
>>> checking file drivers/misc/fastrpc.c
>>> checking file drivers/net/wireless/ath/ath10k/qmi.c
>>> checking file drivers/remoteproc/qcom_q6v5_mss.c
>>> Hunk #1 succeeded at 227 (offset -8 lines).
>>> Hunk #2 succeeded at 404 (offset -10 lines).
>>> Hunk #3 succeeded at 939 with fuzz 1 (offset -28 lines).
>>> checking file drivers/remoteproc/qcom_q6v5_pas.c
>>> Hunk #1 FAILED at 94.
>>> 1 out of 1 hunk FAILED
>>> checking file drivers/soc/qcom/rmtfs_mem.c
>>> Hunk #1 succeeded at 30 (offset -1 lines).
>>> can't find file to patch at input line 167
>>> Perhaps you used the wrong -p or --strip option?
>>> The text leading up to this was:
>>> --------------------------
>>> |diff --git a/include/linux/firmware/qcom/qcom_scm.h
>>> b/include/linux/firmware/qcom/qcom_scm.h
>>> |index 1e449a5d7f5c..250ea4efb7cb 100644
>>> |--- a/include/linux/firmware/qcom/qcom_scm.h
>>> |+++ b/include/linux/firmware/qcom/qcom_scm.h
>>> --------------------------
>>>
>>> What tree is this patch made against?
>>>
>>
>> Sorry about that, I missed the previous changes in qcom_q6v5_pas in the
>> remoteproc tree. Elliot said he based it on linux-next, so I expect that
>> it will merge fine on top of -rc1, once that arrives.
>>
> 
> Yes, this patch applies on next-20230213. I guess there are enough 
> changes were coming from QCOM side (via Bjorn's qcom tree) as well as 
> the fastrpc change (via Greg's char-misc tree).
> 
> Let me know if I should do anything once -rc1 arrives. Happy to post 
> version on the -rc1 if it helps.
> 

The patch now applies on tip of Linus's tree and on char-misc.
