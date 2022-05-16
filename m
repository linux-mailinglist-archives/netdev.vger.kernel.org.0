Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182F4528B6D
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344040AbiEPQ66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344061AbiEPQ6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:58:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744A1198;
        Mon, 16 May 2022 09:58:31 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GGIWij007719;
        Mon, 16 May 2022 16:58:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aVzUp1Bdiwo6CVinfyFYrysYi3uvBEDaynhoTyH4Rjs=;
 b=Uzjvg0bNRguteZvUKLcK03PE3wwOlvWy2V4CSCi5Aajd+hwzIUWOggszRcFRnqetuH5Q
 zAUvmEjbyOzzcGMQInqBMqX4YmAMbwiGCbcf1ENFV/m6Ja2JTbb+/Rf58mNYUlBSMr0S
 XQqw/yv7s4akqZEEviG/szyt6Qwx4lkZtu/bRVnISR7Jr5b9tPpNQOpjLFP0AEcovaWQ
 ef8DPY7wG7Z4QWpGUe3685cPoLFmjR9jjBDIaEGWpICWAT+G4GESkZDG9m6QFv/8mKoC
 e0nWjL0HMoh7s76MNFpqUIggtN1VejfHUp/FMLcL9V8B8v8Gw6Vv5KjDZ2WmOYfkPfSL /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3t11gnn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:58:26 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GGSPWY010605;
        Mon, 16 May 2022 16:58:26 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3t11gnm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:58:25 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GGruFW029831;
        Mon, 16 May 2022 16:58:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428tcf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:58:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GGvo6N28574030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 16:57:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2637111C05B;
        Mon, 16 May 2022 16:58:21 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F81011C04C;
        Mon, 16 May 2022 16:58:20 +0000 (GMT)
Received: from [9.171.85.194] (unknown [9.171.85.194])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 16:58:20 +0000 (GMT)
Message-ID: <63039789-839c-865e-27b3-1f843c87de9b@linux.ibm.com>
Date:   Mon, 16 May 2022 18:58:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v3 0/2] net/smc: send and write inline
 optimization for smc
Content-Language: en-US
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, leon@kernel.org, tonylu@linux.alibaba.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220516055137.51873-1-guangguan.wang@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220516055137.51873-1-guangguan.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9q07apO6WGDWethuOTZKU76-3kK4fbuc
X-Proofpoint-GUID: 6DlRkI7CZBAkWIxZa-wLpYcoVFrHp4SB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160092
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/05/2022 07:51, Guangguan Wang wrote:
> Send cdc msgs and write data inline if qp has sufficent inline
> space, helps latency reducing. 
> 
> In my test environment, which are 2 VMs running on the same
> physical host and whose NICs(ConnectX-4Lx) are working on
> SR-IOV mode, qperf shows 0.4us-1.3us improvement in latency.
> 
> Test command:
> server: smc_run taskset -c 1 qperf
> client: smc_run taskset -c 1 qperf <server ip> -oo \
> 		msg_size:1:2K:*2 -t 30 -vu tcp_lat
> 
> The results shown below:
> msgsize     before       after
> 1B          11.9 us      10.6 us (-1.3 us)
> 2B          11.7 us      10.7 us (-1.0 us)
> 4B          11.7 us      10.7 us (-1.0 us)
> 8B          11.6 us      10.6 us (-1.0 us)
> 16B         11.7 us      10.7 us (-1.0 us)
> 32B         11.7 us      10.6 us (-1.1 us)
> 64B         11.7 us      11.2 us (-0.5 us)
> 128B        11.6 us      11.2 us (-0.4 us)
> 256B        11.8 us      11.2 us (-0.6 us)
> 512B        11.8 us      11.3 us (-0.5 us)
> 1KB         11.9 us      11.5 us (-0.4 us)
> 2KB         12.1 us      11.5 us (-0.6 us)
> 
> Guangguan Wang (2):
>   net/smc: send cdc msg inline if qp has sufficient inline space
>   net/smc: rdma write inline if qp has sufficient inline space
> 
>  net/smc/smc_ib.c |  1 +
>  net/smc/smc_tx.c | 17 ++++++++++++-----
>  net/smc/smc_wr.c |  5 ++++-
>  3 files changed, 17 insertions(+), 6 deletions(-)
> 

I like that change, thank you!

For the series:

Acked-by: Karsten Graul <kgraul@linux.ibm.com>

