Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4B3494C75
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiATLDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:03:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230207AbiATLDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:03:40 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20K9QigS016149;
        Thu, 20 Jan 2022 11:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8so99dsxSS6KYmeK8IX0mENGoLMZ/qTO+b8ToLB57ac=;
 b=baH15jafuSpJndWkzndIZAXrNr46vbp6XK4eATaWvYgo4+jpLDNmqeeFQAZkwlaW7ChT
 jy7/NOtyqbO9EHmzt3cyADZU5xkKiuspzMly3N0cKgs5F42klae3P7F3z0/QFvX4OrJp
 R5IAGAjRFmp4rGokNwoVJH3lGWKmC6yN7xd21S/lgNS8YySmwCu5hqX+u5k00HC3s2aD
 pV+5dgPBRpaJ6qsDP+dw/6MhmmUOrIkJmAcP3C3W45uwv9HGDfctnIF7MtbnWX+iEYy2
 rAU3OT1kd1T12GwdOUoDEpdC0QPTzok5u9aDAIeTRyf7iNioP3kTn78Psj1BIIIwY5bT gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq543stf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 11:03:37 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20KAGYO9002742;
        Thu, 20 Jan 2022 11:03:37 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq543stea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 11:03:37 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20KAw2Ep031887;
        Thu, 20 Jan 2022 11:03:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3dknw9p9c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 11:03:34 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20KAsB9833817062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 10:54:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 384C752078;
        Thu, 20 Jan 2022 11:03:32 +0000 (GMT)
Received: from [9.145.155.19] (unknown [9.145.155.19])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DAB7252069;
        Thu, 20 Jan 2022 11:03:31 +0000 (GMT)
Message-ID: <20da5fa9-6158-d04c-6f44-29e550ed97d0@linux.ibm.com>
Date:   Thu, 20 Jan 2022 12:03:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Content-Language: en-US
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3-ia-8Pfmu4-75XzdY1Yw2VT2620v7KB
X-Proofpoint-ORIG-GUID: QboW9hjUWhruWmlE3v4j2N3EJWQuH07Z
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_03,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 clxscore=1011 phishscore=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2022 07:51, Guangguan Wang wrote:
> This implement rq flow control in smc-r link layer. QPs
> communicating without rq flow control, in the previous
> version, may result in RNR (reveive not ready) error, which
> means when sq sends a message to the remote qp, but the
> remote qp's rq has no valid rq entities to receive the message.
> In RNR condition, the rdma transport layer may retransmit
> the messages again and again until the rq has any entities,
> which may lower the performance, especially in heavy traffic.
> Using credits to do rq flow control can avoid the occurrence
> of RNR.
> 
> Test environment:
> - CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4.
> - redis benchmark 6.2.3 and redis server 6.2.3.
> - redis server: redis-server --save "" --appendonly no
>   --protected-mode no --io-threads 7 --io-threads-do-reads yes
> - redis client: redis-benchmark -h 192.168.26.36 -q -t set,get
>   -P 1 --threads 7 -n 2000000 -c 200 -d 10
> 
>  Before:
>  SET: 205229.23 requests per second, p50=0.799 msec
>  GET: 212278.16 requests per second, p50=0.751 msec
> 
>  After:
>  SET: 623674.69 requests per second, p50=0.303 msec
>  GET: 688326.00 requests per second, p50=0.271 msec
> 
> The test of redis-benchmark shows that more than 3X rps
> improvement after the implementation of rq flow control.
> 
> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> ---

I really appreciate your effort to improve the performance and solve existing bottle necks,
but please keep in mind that the SMC module implements the IBM SMC protocol that is
described here: https://www.ibm.com/support/pages/node/6326337
(you can find these links in the source code, too).

Your patch makes changes that are not described in this design paper and may lead to
future incompatibilities with other platforms that support the IBM SMC protocol.

For example:
- you start using one of the reserved bytes in struct smc_cdc_msg
- you define a new smc_llc message type 0x0A
- you change the maximum number of connections per link group from 255 to 32

We need to start a discussion about your (good!) ideas with the owners of the protocol.
