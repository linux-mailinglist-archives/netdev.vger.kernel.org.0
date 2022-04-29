Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA8C51435A
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 09:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355157AbiD2Hm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 03:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238511AbiD2Hm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 03:42:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D06A5EBB;
        Fri, 29 Apr 2022 00:39:38 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23T56YtP014049;
        Fri, 29 Apr 2022 07:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CuFcLG9fyyl5I4le9BXuxPJQS9NreBnbA9rA4Dc7Ceg=;
 b=arMwhMXZUYcxUjyCNksFsuu+yha2o15kmiq2zmoMaS7MipQvw4GmnRvZZi+I+Ow9YfaX
 bOcl+xcj6138HybCG26N2qfH6QATBqLQ7M+zOhqYiPR8m6vudrjfMoG1/0TVKBuwNIIX
 dABExnaX44i8kIDz887iZ2SOxEeODUev2+cF1QNwtFBU3TeStaXO+BTBT+lQ6LlQEsQa
 lHhbHzFr5bpHqcBMHB3vT4W/eC5l1KFTvsDO1qX0AEu6s4YKEqWuI6UGbFoKt2DSdm5/
 4dCZih0CtZtS0bQ9iiqt15zIVkCLedwIqFtPNs2ozRvzi3i3+NSEV9Cvdh9UznSQt7Fh zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fque158sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 07:39:33 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23T7AEgZ031633;
        Fri, 29 Apr 2022 07:39:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fque158ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 07:39:33 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23T7asPi005657;
        Fri, 29 Apr 2022 07:39:31 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3fm9390p40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 07:39:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23T7dSmO46924102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 07:39:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09AF742041;
        Fri, 29 Apr 2022 07:39:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E4C74203F;
        Fri, 29 Apr 2022 07:39:27 +0000 (GMT)
Received: from [9.145.66.15] (unknown [9.145.66.15])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 07:39:27 +0000 (GMT)
Message-ID: <f42b3b84-8cee-fcd9-e6cf-7a55d956b4d8@linux.ibm.com>
Date:   Fri, 29 Apr 2022 09:39:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v2 15/15] qeth: remove a copy of the
 NAPI_POLL_WEIGHT define
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org, wenjia@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org
References: <20220428212323.104417-1-kuba@kernel.org>
 <20220428212323.104417-16-kuba@kernel.org>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220428212323.104417-16-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N4GcZCAYWDYoua3WzzoNsctDHaGFoQ5r
X-Proofpoint-GUID: SR1oKQww8aoDj-nziLgrZD9R2mYf0yK7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_05,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxlogscore=784 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204290042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.04.22 23:23, Jakub Kicinski wrote:
> Defining local versions of NAPI_POLL_WEIGHT with the same
> values in the drivers just makes refactoring harder.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>
Acked-by: Alexandra Winter <wintera@linux.ibm.com>
