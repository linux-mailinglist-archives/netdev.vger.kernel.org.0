Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F138E46E3B3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhLIIJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:09:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhLIIJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:09:17 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B97wHRw017171;
        Thu, 9 Dec 2021 08:05:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aem6cxPuggi+bEcKCDWY67UuJqxHPpCkyuvaVcktjuY=;
 b=eLpbqbOAsYmfzik8E6A3VkXsfr0T4jWMOWgEafDrkk/z/Ka+HZ2EwTHHtdPZKjoNK0/i
 XZXvN6vECydDlPA/T23mCijx9SNdyL4/4RYexYAdH4b8ExD+Hz/tyski1+wD2yV1OjSX
 bZD08nKga5usK8AFXFj4t9OnVDsN8SpHG7noY03XNX3v2GXqc0SNyT4vq5246drD8w8B
 JnWgPfcNQj2RKFuBpoKxcet2IoUpGfs0lBFJ/2gvTBZkMQcils5Wg4TZkaXXs8XDTpm5
 BERACozs2nxzR9dh65zbv4qwUPn050nDuo+UWbIeOjNDYBSgI3oBbilShIcR6r6ZaJDX 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cudvng57s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 08:05:41 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B981Nhj028775;
        Thu, 9 Dec 2021 08:05:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cudvng56w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 08:05:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B97w4qx017173;
        Thu, 9 Dec 2021 08:05:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3cqyyaehnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 08:05:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B97vpBL28377388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 07:57:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4411C42049;
        Thu,  9 Dec 2021 08:05:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFD3242047;
        Thu,  9 Dec 2021 08:05:35 +0000 (GMT)
Received: from [9.145.54.108] (unknown [9.145.54.108])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 08:05:35 +0000 (GMT)
Message-ID: <4dc02778-0098-0201-e124-d75691de7b8e@linux.ibm.com>
Date:   Thu, 9 Dec 2021 09:05:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next 10/13] net/smc: add net device tracker to struct
 smc_pnetentry
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
 <20211207013039.1868645-11-eric.dumazet@gmail.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211207013039.1868645-11-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y6AIrqNNH9cwHfv75pBjiB0vgeU2cd3q
X-Proofpoint-ORIG-GUID: pQCraAoMfrWeeIozVYTyHN4kOuyjNCXt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090043
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2021 02:30, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/smc/smc_pnet.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
