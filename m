Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C62D6D19E8
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjCaIcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjCaIcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:32:19 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1359138;
        Fri, 31 Mar 2023 01:32:18 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V729cS021646;
        Fri, 31 Mar 2023 08:32:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=r4iJnzwIAsULH4Il/U+tC47GyZ2GCICQr95aHXk6hNQ=;
 b=g37Gc494Abw1RTFb9iT83ecz//jEA9ZKOtAWfA8jz6XngcM+yYNlfucksHv1mFHZptik
 cucSAofbUSa8i+0gcvhiGRxptrOCr7PT2yH5nIAfShPqhdxsbRxjf53H09hqZPy6bFCp
 we0k6KiQblQKwfJpeyYRbRw1cVMHrkd0KMO6zcWdjJEpgymycXocGqBVx3T3j5kgTW7C
 7BSINegj73WVFNES24nYpn7jY/Jaro2j0V+qaAF8JuF3n5MgQPEklZ4k/nM5ipF1FluI
 Xx5ZdY2ZZLo/m5OOaXVaOdHcqHq4ruCWLHm18EM3bkahJfngSXhnabgfxHch1b9OwieF oA== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pn7byba35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 08:32:11 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32V8WBxH012002
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 08:32:11 GMT
Received: from [10.216.13.246] (10.80.80.8) by nalasex01c.na.qualcomm.com
 (10.47.97.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Fri, 31 Mar
 2023 01:32:07 -0700
Message-ID: <4792f5c8-2902-2e46-b663-22cffe450556@quicinc.com>
Date:   Fri, 31 Mar 2023 14:02:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH V2] net: qrtr: Do not do DEL_SERVER broadcast after
 DEL_CLIENT
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
CC:     <mani@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1680248937-16617-1-git-send-email-quic_srichara@quicinc.com>
 <20230331080216.GA6352@thinkpad>
From:   Sricharan Ramabadhran <quic_srichara@quicinc.com>
In-Reply-To: <20230331080216.GA6352@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: yWUOuhIlPHa6RaHAPobr63OwjC3k6wvQ
X-Proofpoint-GUID: yWUOuhIlPHa6RaHAPobr63OwjC3k6wvQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_04,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 adultscore=0 mlxlogscore=255 malwarescore=0 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310070
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<..>

>>   
>> -static int server_del(struct qrtr_node *node, unsigned int port)
>> +static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
>>   {
>>   	struct qrtr_lookup *lookup;
>>   	struct qrtr_server *srv;
>> @@ -287,7 +287,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
>>   	radix_tree_delete(&node->servers, port);
>>   
>>   	/* Broadcast the removal of local servers */
>> -	if (srv->node == qrtr_ns.local_node)
>> +	if (srv->node == qrtr_ns.local_node && bcast)
>>   		service_announce_del(&qrtr_ns.bcast_sq, srv);
>>   
>>   	/* Announce the service's disappearance to observers */
>> @@ -373,7 +373,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
>>   		}
>>   		slot = radix_tree_iter_resume(slot, &iter);
>>   		rcu_read_unlock();
>> -		server_del(node, srv->port);
>> +		server_del(node, srv->port, true);
>>   		rcu_read_lock();
>>   	}
>>   	rcu_read_unlock();
>> @@ -459,10 +459,13 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
>>   		kfree(lookup);
>>   	}
>>   
>> -	/* Remove the server belonging to this port */
>> +	/* Remove the server belonging to this port but don't broadcast
> 
> This is still not as per the multi line comment style perferred in kernel.
> Please read: https://www.kernel.org/doc/html/latest/process/coding-style.html#commenting
> 

  Ho, i had it like first style and checkpatch cribbed. Then changed it
  as per the second style for net/ format. You mean we should stick to
  1 st style ?

Regards,
  Sricharan
