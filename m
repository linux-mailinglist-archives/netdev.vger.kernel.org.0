Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8F0500860
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 10:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239134AbiDNIb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 04:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238634AbiDNIb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 04:31:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27419B863;
        Thu, 14 Apr 2022 01:29:33 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23E7FWn7015091;
        Thu, 14 Apr 2022 08:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=w6LG2k4ti6YV7S9h7NTtZdo/5OqXBbE7WUofQP2sUjQ=;
 b=PDNPTej/fiv0dCpibnpXHfWDXL3bUJSOmpLG8HSiylIcvgjOAB06SfqaQgy9VEgi9g+e
 bb2Xn4uMExRzmqvOvu51DBUmNJZ0GYWiV32Xfl0VpjM2NVyElji86MIeWwNoOExkZYyv
 vkZgBQjmB+xfQKBY4fBAve+R9J+IUTlDUy9cTV1H1mUgywUCBSEeAejrSPr4cY5JMYSu
 xzPUzehB4m0LbTzkh452jft+elHk8zHx/Vk2YoghtPJljYQ+QZPZ1VPjTHsGxRqtDoYC
 ZPX/FQwSTzs+GWh9lZMN95eDfmyIEmbnYcKwVqHHJ3NMkZ3D7qe7NWhgAitle37s1fON Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fef2mh8bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:29:22 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23E8J0YJ010436;
        Thu, 14 Apr 2022 08:29:22 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fef2mh8b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:29:22 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23E8Rwjp006604;
        Thu, 14 Apr 2022 08:29:20 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3fb1s8pg81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:29:20 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23E8GivW49021386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 08:16:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 197BB42042;
        Thu, 14 Apr 2022 08:29:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAC6542047;
        Thu, 14 Apr 2022 08:29:17 +0000 (GMT)
Received: from [9.171.63.52] (unknown [9.171.63.52])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 08:29:17 +0000 (GMT)
Message-ID: <aee77dea-7161-e988-27f8-bbf6c28d048a@linux.ibm.com>
Date:   Thu, 14 Apr 2022 10:29:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net] net/smc: Fix sock leak when release after
 smc_shutdown()
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220414075102.84366-1-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220414075102.84366-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CnKmzBZN9TVi2TxabweZgPMTjdbNDB3j
X-Proofpoint-GUID: eO6JUPubVmmQ_gyhmKHSAfUjIfgQEtUi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 clxscore=1015 suspectscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140040
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2022 09:51, Tony Lu wrote:
> Since commit e5d5aadcf3cd ("net/smc: fix sk_refcnt underflow on linkdown
> and fallback"), for a fallback connection, __smc_release() does not call
> sock_put() if its state is already SMC_CLOSED.
> 
> When calling smc_shutdown() after falling back, its state is set to
> SMC_CLOSED but does not call sock_put(), so this patch calls it.
> 
> Reported-and-tested-by: syzbot+6e29a053eb165bd50de5@syzkaller.appspotmail.com
> Fixes: e5d5aadcf3cd ("net/smc: fix sk_refcnt underflow on linkdown and fallback")
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---

Thank you.

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
