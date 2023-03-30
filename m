Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763686D002B
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjC3Jui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjC3JuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:50:05 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C29A900B;
        Thu, 30 Mar 2023 02:48:52 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32U8mL0p027535;
        Thu, 30 Mar 2023 09:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=rZWpKp/vv95yuclKAqIflGpTAfp/OBY4tgNZ/deX2f4=;
 b=MSCt6wxo7z6ZUcHWsxMRdnV/PKPjF1ifEebA+dtgOU0nWdJ506Rl5UIxev3PB8QES5uZ
 l4nN+fc89QG+UQuGlM9Bz6LawvAxLi2GeeUHix5rup0w8YBIDlrzHPjixCuFhMx7CUx+
 CHbwIay7ifkvKuYvmVpkOwiyEesGaj9F2yQ0VB9W8NcentfBDgbGZF4HHp+YvN52sbal
 9+XwegX2rs+keKCMW3tnK2obMf9RMpBGLrAHDqgok1J2KGXwzEdbm7reaN5y5c8lBeCh
 v9t3fKW/AuHJSpDcUmWs3UibrLNN1yPZ6ESSwh/zfHCY9yEnCMYzzTvlLvO5m4oVeqPJ 3w== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pn1a9s5n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 09:48:14 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32U9mDSY019930
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 09:48:13 GMT
Received: from [10.201.3.182] (10.80.80.8) by nalasex01c.na.qualcomm.com
 (10.47.97.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Thu, 30 Mar
 2023 02:48:10 -0700
Message-ID: <0821c0e1-43ff-56b6-7141-28b0292dd0bd@quicinc.com>
Date:   Thu, 30 Mar 2023 15:18:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] net: qrtr: Do not do DEL_SERVER broadcast after
 DEL_CLIENT
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
CC:     <mani@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1680095250-21032-1-git-send-email-quic_srichara@quicinc.com>
 <20230330062445.GB9876@thinkpad>
From:   Sricharan Ramabadhran <quic_srichara@quicinc.com>
In-Reply-To: <20230330062445.GB9876@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: cj5HmLKAConyamjoXhvmZVLnN9abirxQ
X-Proofpoint-GUID: cj5HmLKAConyamjoXhvmZVLnN9abirxQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_04,2023-03-30_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 mlxlogscore=637 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300078
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/30/2023 11:54 AM, Manivannan Sadhasivam wrote:
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
> Can you share the qrtr trace when this happens to help me understand the flow?

    Flow is like this.

     IPQ                                   SDX
     ---                           	  ----
                                 	 qrtr_release
                                          qrtr_port_remove
                                 	 qrtr_send_del_client
                                        		|
                                     		|
                                     		|
                                     		|
    RX CTRL: cmd:0x6 addr[0x2:0x40d4]<-----------|
     (qrtr_send_client broadcasts it to          |
      the remote,                      		|
      IPQ cleans up the port)                    |
                                          	|
	                              ctrl_cmd_del_client
        		                        (send_del_client
	               	                 also forwards the
	                       	         DEL_CLIENT to
         	                       	 internal ns.c.
	                                 Which then again
         	                         sends DEL_server
                 	                 to same port to
                         	         remote)
                                 	       |
                                                |
    RX CTRL: cmd:0x5 SVC[0x1389:0x1]            |
      addr[0x2:0x40d4] <-------------------- ---|
      (IPQ on receiving the DEL_SERVER on
       same port throws the message
       "failed while handling packet from 2:-2")


  Regards,
    Sricharan
