Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1087B6D005B
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjC3J6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjC3J6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:58:23 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0A4AB;
        Thu, 30 Mar 2023 02:58:22 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32U8wVkn031996;
        Thu, 30 Mar 2023 09:58:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=+5MOdgd+F9DOFkIAvbc9XGeePiUbARDP9UnLP6YhKxo=;
 b=dLFkDMHdHk9lCu8W//3UHsxeazPTdmqBxNuSV01GXgjSJMCe4RRrDMfWSBlyjQ/AEQPO
 yn34ZcMdOIoBgefYyH1MfAHNz0dXchrMLLdbTmEExqdDp79YOGthfWLmjwxHYfezEoz6
 q15ccFVa2ao813qw7NyBWTzzBGxlwZ1b3W32yha8HK1YnGL0qODteDCz5NI0QXrgXwt7
 CpjYfKEWxiC8LSvXmmN0BMHr0eWd4selofp6eLienXy0DudIK+BjJeBQ9GDh/MVLufiH
 lqhhjHfIq51alR2TZbiBeEJ2b1w2tZ4Kx09dcyPlP9wkTmPq1hw1aqg08zug5BMjBxu+ Xw== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pn7by846f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 09:58:16 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32U9wF1w001527
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 09:58:15 GMT
Received: from [10.201.3.182] (10.80.80.8) by nalasex01c.na.qualcomm.com
 (10.47.97.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Thu, 30 Mar
 2023 02:58:11 -0700
Message-ID: <7da90524-37b3-0168-6326-a0a46b287736@quicinc.com>
Date:   Thu, 30 Mar 2023 15:28:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] net: qrtr: Do not do DEL_SERVER broadcast after
 DEL_CLIENT
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <mani@kernel.org>, <manivannan.sadhasivam@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1680095250-21032-1-git-send-email-quic_srichara@quicinc.com>
 <20230329213216.7b0447e9@kernel.org>
From:   Sricharan Ramabadhran <quic_srichara@quicinc.com>
In-Reply-To: <20230329213216.7b0447e9@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: ZS0G6pDsMpXHsRe609Ow0IiOUpDmzetz
X-Proofpoint-GUID: ZS0G6pDsMpXHsRe609Ow0IiOUpDmzetz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_04,2023-03-30_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 adultscore=0 mlxlogscore=998 malwarescore=0 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300080
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/30/2023 10:02 AM, Jakub Kicinski wrote:
> On Wed, 29 Mar 2023 18:37:30 +0530 Sricharan R wrote:
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
> 
> You use the word "fix" so please add a Fixes tag.
> 

  ok

>> Signed-off-by: Ram Kumar D <quic_ramd@quicinc.com>
>> Signed-off-by: Sricharan R <quic_srichara@quicinc.com>
> 
> Spell out full names, please.

  ok

Regards,
  Sricharan
