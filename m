Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08559266206
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgIKPWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:22:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55304 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgIKPUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:20:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BFF3Zc061529;
        Fri, 11 Sep 2020 15:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/MeEy7v1R447j4T1klPQoqAF2B+oLO9ldzBbaI8x8Es=;
 b=fjp11hQgk0M2ieGImtTlL3liHO/dyA25V5DntaVVhLX6Ilu+T/TV1XPoOJjeyYixOdXH
 zTu3b7QveAgDRj+O1ApqsEwqbXRl/lzWg7UZjAG6BWw4KrKZiZe0s1mRw0SMpwW/2LfK
 7YUZ5RbrKNusDmRcqbVYffyvdjomq6LGK4rSI1g0g1J8rhlMt28xUhkmSX9FazUWm2G2
 KyuibgxuaFLMs7xnoMXncD3eDGWm9zUul8GDnF48Ys6F2/7Cr3rvA60y7UAHvg4x611m
 A4nS3Z4JPOYu1YNBX3PDlGFv2TnzNlgfcG5BSV+f+eoo0qxkMfUYHDPryr29pkH/p7Bu Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33c2mmesjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 15:19:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BFFHDE118910;
        Fri, 11 Sep 2020 15:19:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmkd8cfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 15:19:31 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08BFJK2q027490;
        Fri, 11 Sep 2020 15:19:20 GMT
Received: from [10.74.86.16] (/10.74.86.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 08:19:20 -0700
Subject: Re: [PATCH v3 00/11] Fix PM hibernation in Xen guests
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
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <03baf888-5c10-429b-3206-b75d4af1e09e@oracle.com>
Date:   Fri, 11 Sep 2020 11:19:13 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <cover.1598042152.git.anchalag@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110125
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/21/20 6:22 PM, Anchal Agarwal wrote:
>
> Known issues:
> 1.KASLR causes intermittent hibernation failures. VM fails to resumes and
> has to be restarted. I will investigate this issue separately and shouldn't
> be a blocker for this patch series.


Is there any change in status for this? This has been noted since January.


-boris


> 2. During hibernation, I observed sometimes that freezing of tasks fails due
> to busy XFS workqueuei[xfs-cil/xfs-sync]. This is also intermittent may be 1
> out of 200 runs and hibernation is aborted in this case. Re-trying hibernation
> may work. Also, this is a known issue with hibernation and some
> filesystems like XFS has been discussed by the community for years with not an
> effectve resolution at this point.
>
