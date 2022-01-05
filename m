Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8EB4858F5
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243388AbiAETNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:13:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243347AbiAETNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:13:33 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205IYXDQ031251;
        Wed, 5 Jan 2022 19:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jgutIp5KMRR/rHHpwO7EaubrirX/cWCWPlMwmFTaJ18=;
 b=W8wJd3SDoYuMLnQQFFVduHhVzkTmDnOx7WVgOY2N0uIGvDLyt+iTPvRGgrLDKbCy59Wt
 87D82dPdZO9fnFOIICmEeit5ROv4q6LkmUnhex7WHV8h/UFkn+vEulf/qzuKUTr3KzlD
 K7jUgDqazZdrPICDoJ6bH+qtyULlhHGBcaYZCrGc631qpUI0AHxV673Zayfa2dimW8FZ
 Aw4vjO3vPrW+/InfkoAUeXfnaNpbfVxvmWDNLpZdIobyTZJU2vsyctVgW9q+aiQbVH+N
 Wp6FhkBQDLMPN5lAmQ4bioeMN/4hKZANfm3EX8ByUpfESVXRJA51ZgiVkY149XHwxbER lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dcmawwk6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 19:13:28 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 205J2upa012410;
        Wed, 5 Jan 2022 19:13:27 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dcmawwk5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 19:13:27 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 205JA4YP023225;
        Wed, 5 Jan 2022 19:13:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3daek9jt8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Jan 2022 19:13:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 205JDM0443844006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Jan 2022 19:13:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EE90AE051;
        Wed,  5 Jan 2022 19:13:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 927E7AE045;
        Wed,  5 Jan 2022 19:13:21 +0000 (GMT)
Received: from [9.145.89.5] (unknown [9.145.89.5])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Jan 2022 19:13:21 +0000 (GMT)
Message-ID: <d35569df-e0e0-5ea7-9aeb-7ffaeef04b14@linux.ibm.com>
Date:   Wed, 5 Jan 2022 20:13:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     dust.li@linux.alibaba.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
 <20220105085748.GD31579@linux.alibaba.com>
 <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
 <20220105150612.GA75522@e02h04389.eu6sqa>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220105150612.GA75522@e02h04389.eu6sqa>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ht9CE45YnXG5lb09FAey3s1bPxafW6N9
X-Proofpoint-ORIG-GUID: iL_dZu0klVtlWvci52WsqiW8gJGxpyKO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_05,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201050123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2022 16:06, D. Wythe wrote:
> LGTM. Fallback makes the restrictions on SMC dangling
> connections more meaningful to me, compared to dropping them.
> 
> Overall, i see there are two scenario.
> 
> 1. Drop the overflow connections limited by userspace application
> accept.
> 
> 2. Fallback the overflow connections limited by the heavy process of
> current SMC handshake. ( We can also control its behavior through
> sysctl.)
> 

I vote for (2) which makes the behavior from user space applications point of view more like TCP.

One comment to sysctl: our current approach is to add new switches to the existing 
netlink interface which can be used with the smc-tools package (or own implementations of course). 
Is this prereq problematic in your environment? 
We tried to avoid more sysctls and the netlink interface keeps use more flexible.
