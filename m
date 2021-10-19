Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78C3432E56
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 08:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbhJSGgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 02:36:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbhJSGgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 02:36:11 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J6MtVR001554;
        Tue, 19 Oct 2021 02:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CvIWIWZegw5geXGYTY/N3EkVK5pJ1TTtd9V7IPsX/VU=;
 b=ozKL91ufBGwUOOy7EGQpD92GvCGBnYdTa5YY9NsHwsMwyvEf5E/5jheq2bJlQx65HVQE
 tUYlBgPatELJEsQtdrdNV0wA5/h/OOIt8vm3Je4UicA91xjfXt3GgZU+u4qZGWOyGFf3
 aPwQehV98rwk2GXSLZ2TfzX8U7NExDJ0bWd6U3X2/wrmns8mhgTschvY6hr6+tmqxgxK
 IjhZ4gnkOOHZZpOr6ISSrX9HbChu+UE9WUnetDuN1YJBsifSeIMXA+KqRlQ0pAy335Xd
 wiK0Rf4G5OH3/1BLBwGgRgonFNz2Vz/rTNzo4at4ddDnlJnli2D9CL3Kl0Z0gyZMN2fN QA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsnhhkev3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 02:33:55 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19J6DPba015996;
        Tue, 19 Oct 2021 06:33:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9bxgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 06:33:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19J6XofS56492444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 06:33:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C000F11C04A;
        Tue, 19 Oct 2021 06:33:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CF5511C058;
        Tue, 19 Oct 2021 06:33:50 +0000 (GMT)
Received: from [9.171.65.69] (unknown [9.171.65.69])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 06:33:50 +0000 (GMT)
Message-ID: <ceb1a1ce-b4a4-7908-7d18-832cca1bfbe2@linux.ibm.com>
Date:   Tue, 19 Oct 2021 08:33:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH][linux-next] net/smc: prevent NULL dereference in
 smc_find_rdma_v2_device_serv()
Content-Language: en-US
To:     Tim Gardner <tim.gardner@canonical.com>, linux-s390@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211018183128.17743-1-tim.gardner@canonical.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211018183128.17743-1-tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QGXdzv8rsRR0Q2JVRw8d6oCKuWvBrNo0
X-Proofpoint-ORIG-GUID: QGXdzv8rsRR0Q2JVRw8d6oCKuWvBrNo0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_07,2021-10-18_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 clxscore=1011 adultscore=0 mlxscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190038
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/10/2021 20:31, Tim Gardner wrote:
> Coverity complains of a possible NULL dereference in smc_find_rdma_v2_device_serv().
> 
> 1782        smc_v2_ext = smc_get_clc_v2_ext(pclc);
> CID 121151 (#1 of 1): Dereference null return value (NULL_RETURNS)
> 5. dereference: Dereferencing a pointer that might be NULL smc_v2_ext when calling smc_clc_match_eid. [show details]
> 1783        if (!smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext, NULL, NULL))
> 1784                goto not_found;
> 
> Fix this by checking for NULL.

Hmm that's a fundamental question for me: do we want to make the code checkers happy?
While I understand that those warnings give an uneasy feeling I am not sure
if the code should have additional (unneeded) checks only to avoid them.

In this case all NULL checks are initially done in smc_listen_v2_check(), 
afterwards no more NULL checks are needed. When we would like to add them
then a lot more checks are needed, e.g. 3 times in smc_find_ism_v2_device_serv()
(not sure why coverity does not complain about them, too).

Thoughts?
