Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137D5696D67
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbjBNSxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbjBNSxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:53:06 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B1A29E31;
        Tue, 14 Feb 2023 10:53:03 -0800 (PST)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31E7iTKL015754;
        Tue, 14 Feb 2023 18:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=U3syg7haXYmZC0gFSKxR5D4kG4hxMwo5K00/a2RSWtE=;
 b=Izk6QLpiZ9dr0Foaahq4S5JfEs9cTeRtjuncMddjWtP5HK5EnZ1nR3kNE8FLkEpDOYNa
 FcX+hfQDtWl3u6nQPMB+y0KErFkfGcztwUaP5XMoesB1SrjezHH8seqRpuYPIeivVpo3
 PxJmd+7VV6eGCv1gsfEBzxQyuhZ6Pi4DzuqtLP17LeO823HoHrNF7J3XDmcZNypWtrK9
 TCKiVw9qdsm82Q2VPNeBZRz3befyq5uk9q4VAENYvDrOJvZ4oj3GrkW+ry8Np1IOELj7
 9axEUN7GT6Pxkv9SdDu5fr73dUQ52DO1hgPpH5myYuZTRiLziCEPQtOKLHn+/GtEPXWG lA== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nr6619pf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Feb 2023 18:52:44 +0000
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 31EIqi8M017864
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Feb 2023 18:52:44 GMT
Received: from [10.134.67.48] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 10:52:43 -0800
Message-ID: <bdda82f7-933d-443b-614a-6befad2899b5@quicinc.com>
Date:   Tue, 14 Feb 2023 10:52:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
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
Content-Language: en-US
From:   Elliot Berman <quic_eberman@quicinc.com>
In-Reply-To: <20230214172325.lplxgbprhj3bzvr3@ripper>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 83ESq1VK2Hge4g6kN6ODPmnd5mncqH5W
X-Proofpoint-GUID: 83ESq1VK2Hge4g6kN6ODPmnd5mncqH5W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_13,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302140163
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/2023 9:23 AM, Bjorn Andersson wrote:
> On Tue, Feb 14, 2023 at 09:58:44AM +0100, Greg Kroah-Hartman wrote:
>> On Mon, Feb 13, 2023 at 01:44:17PM -0800, Bjorn Andersson wrote:
>>> On Mon, Feb 13, 2023 at 10:18:29AM -0800, Elliot Berman wrote:
>>>> The maximum VMID for assign_mem is 63. Use a u64 to represent this
>>>> bitmap instead of architecture-dependent "unsigned int" which varies in
>>>> size on 32-bit and 64-bit platforms.
>>>>
>>>> Acked-by: Kalle Valo <kvalo@kernel.org> (ath10k)
>>>> Tested-by: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
>>>> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
>>>
>>> Reviewed-by: Bjorn Andersson <andersson@kernel.org>
>>>
>>> @Greg, would you mind taking this through your tree for v6.3, you
>>> already have a related change in fastrpc.c in your tree...
>>
>> I tried, but it doesn't apply to my char-misc tree at all:
>>
>> checking file drivers/firmware/qcom_scm.c
>> Hunk #1 succeeded at 898 (offset -7 lines).
>> Hunk #2 succeeded at 915 (offset -7 lines).
>> Hunk #3 succeeded at 930 (offset -7 lines).
>> checking file drivers/misc/fastrpc.c
>> checking file drivers/net/wireless/ath/ath10k/qmi.c
>> checking file drivers/remoteproc/qcom_q6v5_mss.c
>> Hunk #1 succeeded at 227 (offset -8 lines).
>> Hunk #2 succeeded at 404 (offset -10 lines).
>> Hunk #3 succeeded at 939 with fuzz 1 (offset -28 lines).
>> checking file drivers/remoteproc/qcom_q6v5_pas.c
>> Hunk #1 FAILED at 94.
>> 1 out of 1 hunk FAILED
>> checking file drivers/soc/qcom/rmtfs_mem.c
>> Hunk #1 succeeded at 30 (offset -1 lines).
>> can't find file to patch at input line 167
>> Perhaps you used the wrong -p or --strip option?
>> The text leading up to this was:
>> --------------------------
>> |diff --git a/include/linux/firmware/qcom/qcom_scm.h
>> b/include/linux/firmware/qcom/qcom_scm.h
>> |index 1e449a5d7f5c..250ea4efb7cb 100644
>> |--- a/include/linux/firmware/qcom/qcom_scm.h
>> |+++ b/include/linux/firmware/qcom/qcom_scm.h
>> --------------------------
>>
>> What tree is this patch made against?
>>
> 
> Sorry about that, I missed the previous changes in qcom_q6v5_pas in the
> remoteproc tree. Elliot said he based it on linux-next, so I expect that
> it will merge fine on top of -rc1, once that arrives.
> 

Yes, this patch applies on next-20230213. I guess there are enough 
changes were coming from QCOM side (via Bjorn's qcom tree) as well as 
the fastrpc change (via Greg's char-misc tree).

Let me know if I should do anything once -rc1 arrives. Happy to post 
version on the -rc1 if it helps.

Thanks,
Elliot

> Regards,
> Bjorn
