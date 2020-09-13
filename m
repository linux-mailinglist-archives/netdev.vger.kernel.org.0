Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BFB268091
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 19:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgIMR0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 13:26:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgIMR0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 13:26:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08DHOwpg021278;
        Sun, 13 Sep 2020 17:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nyBwxCnbYyUWOK+NiyWEbUqCiK98qGPkeLZjwlqCjKw=;
 b=ZR5aPxz9gSva9xylW6NOtGWoC1ZFSHh+ZcI/7QD2EhfR2/fz1r6q6DgSMmlx1VFCtjh0
 c03slDfplrdVWH40rpvHRmf4hqr6smhR5EkrWxypcvmmx1gLB1MkHXT/S8qaFU0OPg74
 HPD3Uty0sckSmjuqlgWXNIQgCc5u1eM3tE97f5ZdRSJb3FV7Pyq0bvumbC+SpL6J034Q
 MaAgmskllCrJFVcwFIIytl/7w1dwUzPOwfz3qSGNgHjk22BzhIX5LCZmKnez17An0oOx
 KHBz13eC6eGb/hK/BfEHoZ0bREzLVEFpa4jYEy2j5emUlnj2Jrnfq+/ZF6Bi0Nnqa49f 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33gp9ku6q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Sep 2020 17:25:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08DHPJHh104805;
        Sun, 13 Sep 2020 17:25:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h87xvpq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Sep 2020 17:25:32 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08DHPTvi030996;
        Sun, 13 Sep 2020 17:25:30 GMT
Received: from [10.74.86.192] (/10.74.86.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 13 Sep 2020 17:25:29 +0000
Subject: Re: [PATCH v3 04/11] x86/xen: add system core suspend and resume
 callbacks
To:     Anchal Agarwal <anchalag@amazon.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        jgross@suse.com, linux-pm@vger.kernel.org, linux-mm@kvack.org,
        kamatam@amazon.com, sstabellini@kernel.org, konrad.wilk@oracle.com,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        xen-devel@lists.xenproject.org, vkuznets@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw@amazon.co.uk, benh@kernel.crashing.org
References: <cover.1598042152.git.anchalag@amazon.com>
 <6b86a4bf71ee3e3e9b0bb00f594a4edc85da19a9.1598042152.git.anchalag@amazon.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <286ac56d-7fd2-66d5-bfcb-6a329afca3d6@oracle.com>
Date:   Sun, 13 Sep 2020 13:25:23 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <6b86a4bf71ee3e3e9b0bb00f594a4edc85da19a9.1598042152.git.anchalag@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9743 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9743 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009130158
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/21/20 6:27 PM, Anchal Agarwal wrote:
> From: Munehisa Kamata <kamatam@amazon.com>
>
> Add Xen PVHVM specific system core callbacks for PM
> hibernation support. The callbacks suspend and resume
> Xen primitives like shared_info, pvclock and grant table.
> These syscore_ops are specifically for domU hibernation.
> xen_suspend() calls syscore_suspend() during Xen suspend
> operation however, during xen suspend lock_system_sleep()
> lock is taken and thus system cannot trigger hibernation.
> These system core callbacks will be called only from the
> hibernation context.


Well, they can be called from Xen suspend too, which is why you have the
checks in the beginning.


-boris



