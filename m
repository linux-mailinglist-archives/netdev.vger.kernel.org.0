Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F71968E46B
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 00:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBGXaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 18:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBGXaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 18:30:11 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1119822A22;
        Tue,  7 Feb 2023 15:30:07 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317ND6n8014197;
        Tue, 7 Feb 2023 23:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7iQpkqbTs7RU0852al0yH5gnszO5M0V2QRE43sqvS9M=;
 b=GjRBKThyLhMjKqPGM56j0wPIhZa1n2L+x6w6YqVVgtOT3+H8YZS/nhLhNkE4hmRenTe7
 4yIJSblBuuDppy+JhlUXSZwbRA9wCRzmDs4tS9QylnSw7HC6ZW9Nlmk8sEKjIdlJ5akh
 prrbINUXGLqvYut+dWYsMOUQ8pzqpMa48d9kmk0c1VGqW2sSfpk+9SelMakS6GFh26UC
 xmY/k2jo+iRS6l/1B9wNDRqSznRAWB55LtxoDtOFNc3/or70ApX70gkJYxtjl3piqpho
 2nUdhHRJlRco70vY3A5L2723SHeiDZTE6GpkIKwOyOTWqz2OpdMnjmLoiYtvyeQR01vn 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nm04dgafs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 23:30:01 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 317NSFRW003978;
        Tue, 7 Feb 2023 23:30:01 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nm04dgafc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 23:30:01 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 317NFBq4001991;
        Tue, 7 Feb 2023 23:30:00 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([9.208.129.120])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3nhf07ewr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 23:30:00 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 317NTw9N8192536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Feb 2023 23:29:58 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7228258043;
        Tue,  7 Feb 2023 23:29:58 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2332658055;
        Tue,  7 Feb 2023 23:29:57 +0000 (GMT)
Received: from [9.211.153.50] (unknown [9.211.153.50])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Feb 2023 23:29:56 +0000 (GMT)
Message-ID: <fe0d2dae-1a3e-e32f-e8b3-285a33d29422@linux.ibm.com>
Date:   Wed, 8 Feb 2023 00:29:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next 0/2] Deliver confirm/delete rkey message in parallel
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1675755374-107598-1-git-send-email-alibuda@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1675755374-107598-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AQO2V47LNTOC0pUM6Cl2JxcEGCnKlcMM
X-Proofpoint-GUID: 5i4PQeFT34O400XfabBWAOk-_tT4aIrH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_13,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070198
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.02.23 08:36, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> According to the SMC protocol specification, we know that all flows except
> confirm_rkey adn delete_rkey are exclusive, confirm/delete rkey flows
> can run concurrently (local and remote).
> 
> However, although the protocol allows, all flows are actually mutually
> exclusive in implementation, deus to we are waiting for LLC message
> in serial.
> 
> On the one hand, this implementation does not conform to the protocol
> specification, on the other hand, this implementation aggravates the
> time for establishing or destroying a SMC-R connection, connection
> have to be queued in smc_llc_wait.
> 
> This patch will improve the performance of the short link scenario
> by about 5%. In fact, we all know that the performance bottleneck
> of the short link scenario is not here.
> 
> This patch try use rtokens or rkey to correlate a confirm/delete
> rkey message with its response.
> 
> This patch contains two parts.
> 
> At first, we have added the process
> of asynchronously waiting for the response of confirm/delete rkey
> messages, using rtokens or rkey to be correlate with.
> 
> And then, we try to send confirm/delete rkey message in parallel,
> allowing parallel execution of start (remote) or initialization (local)
> SMC_LLC_FLOW_RKEY flows.
> 
> D. Wythe (2):
>    net/smc: allow confirm/delete rkey response deliver multiplex
>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
> 
>   net/smc/smc_core.h |   1 +
>   net/smc/smc_llc.c  | 263 +++++++++++++++++++++++++++++++++++++++++------------
>   net/smc/smc_llc.h  |   6 ++
>   net/smc/smc_wr.c   |  10 --
>   net/smc/smc_wr.h   |  10 ++
>   5 files changed, 220 insertions(+), 70 deletions(-)
> 

As we already discussed, on this changes we need to test them carefully 
so that we have to be sure that the communicating with z/OS should not 
be broken. We'll let you know as soon as the testing is finished.
