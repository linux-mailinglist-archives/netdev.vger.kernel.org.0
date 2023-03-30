Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B186D0F20
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjC3ToQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjC3ToP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:44:15 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1C9EFB2;
        Thu, 30 Mar 2023 12:44:14 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UCRDk6012211;
        Thu, 30 Mar 2023 19:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=cqQmgaIu3tZ+F9OvZEHmpqKHsX7ixNOJ/m95ok1vMM8=;
 b=Up+PS7Uiny/Em6fX83QTfkoXSUJa1dAAhEEXlNRZXb0d1hMpSxU01jJDNExGvbhjdM0f
 iJB2XkZR3AuhokGk6YTwb4fXCpZTGXkmelN19od4ygoMWMMyIOZ/wBuIZ+x62YvZnMZ6
 FmV8fGiKKfeVsInT4PF2mULZil37wOQqsr5gPjlJAOmr6D0JK6zDFPH8sgzEhvMg5jHW
 5Wan8Ysiyb0SNUPmw25twfbbrQIs9RjOe6RsvgHckB6yMgfbLyVxi9Gd+/wLv+pUlPtm
 H1cZRPbCsPO13reIo3t6CCEKqEnWWf3xFlbTMieZ6RIJ4r2X8w+841jteRuhJCD6hIO/ ow== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pn1a9tnve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 19:44:06 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32UJhqvq013247
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 19:43:52 GMT
Received: from [10.216.46.49] (10.80.80.8) by nalasex01c.na.qualcomm.com
 (10.47.97.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Thu, 30 Mar
 2023 12:43:49 -0700
Message-ID: <fe19a934-979f-6925-fefe-a650570e68b3@quicinc.com>
Date:   Fri, 31 Mar 2023 01:13:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] net: qrtr: Do not do DEL_SERVER broadcast after
 DEL_CLIENT
Content-Language: en-US
To:     Manivannan Sadhasivam <mani@kernel.org>
CC:     <manivannan.sadhasivam@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1680095250-21032-1-git-send-email-quic_srichara@quicinc.com>
 <20230330112716.GA84386@thinkpad>
From:   Sricharan Ramabadhran <quic_srichara@quicinc.com>
In-Reply-To: <20230330112716.GA84386@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: cDdKCeOiOxm3LWQuSMCAiGnggPnIImfX
X-Proofpoint-GUID: cDdKCeOiOxm3LWQuSMCAiGnggPnIImfX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_12,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300155
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/30/2023 6:09 PM, Manivannan Sadhasivam wrote:
> On Wed, Mar 29, 2023 at 06:37:30PM +0530, Sricharan R wrote:
>> When the qrtr socket is released, qrtr_port_remove gets called, which
>> broadcasts a DEL_CLIENT. After this DEL_SERVER is also additionally
>> broadcasted, which becomes NOP, but triggers the below error msg.
>>
>> "failed while handling packet from 2:-2", since remote node already
>> acted upon on receiving the DEL_CLIENT, once again when it receives
>> the DEL_SERVER, it returns -ENOENT.
>>
>> Fixing it by not sending a 'DEL_SERVER' to remote when a 'DEL_CLIENT'
>> was sent for that port.
>>
> 
> How about:
> 
> "On the remote side, when QRTR socket is removed, af_qrtr will call
> qrtr_port_remove() which broadcasts the DEL_CLIENT packet to all neighbours
> including local NS. NS upon receiving the DEL_CLIENT packet, will remove
> the lookups associated with the node:port and broadcasts the DEL_SERVER
> packet.
> 
> But on the host side, due to the arrival of the DEL_CLIENT packet, the NS
> would've already deleted the server belonging to that port. So when the
> remote's NS again broadcasts the DEL_SERVER for that port, it throws below
> error message on the host:
> 
> "failed while handling packet from 2:-2"
> 
> So fix this error by not broadcasting the DEL_SERVER packet when the
> DEL_CLIENT packet gets processed."
> 

   Sure, sounds good. Will change this up and send V2.

>> Signed-off-by: Ram Kumar D <quic_ramd@quicinc.com>
>> Signed-off-by: Sricharan R <quic_srichara@quicinc.com>
>> ---
>> Note: Functionally tested on 5.4 kernel and compile tested on 6.3 TOT
>>

  <...>

>>   
>> -	/* Remove the server belonging to this port */
>> +	/* Remove the server belonging to this port
>> +	 * Given that DEL_CLIENT is already broadcasted
>> +	 * by port_remove, no need to send DEL_SERVER for
>> +	 * the same port to remote
>> +	 */
> 
> 	/*
>   	 * Remove the server belonging to this port but don't broadcast
> 	 * DEL_SERVER. Neighbours would've already removed the server belonging
> 	 * to this port due to the DEL_CLIENT broadcast from qrtr_port_remove().
> 	 */

    Sure, would reword it like above in V2. Thanks.

Regards,
  Sricharan
