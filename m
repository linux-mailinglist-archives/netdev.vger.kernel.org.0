Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848D815AF2C
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgBLRzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:55:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbgBLRzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 12:55:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01CHhWLh190088;
        Wed, 12 Feb 2020 17:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Y+1Njwk15wXKV3Mssus0sPgtfffmph3i+pYY6U43ZAs=;
 b=Pg1+RZ7QzoBMtC4+0gvZ+2TM/uNiNTSbr4agsKdrxwmWsszElNa3xwONwu1E386Z5ALi
 WR99QVhSq9H0MHOj2io3WWG3Ih4SpxQtau01QFypH9T8wMuTIwfOlsebfZnSnlsQrBZn
 DRSMJiwLAqyIrdMnTHXJK3ABzVVdV2fbo63ZU9Qnob2jAU2h2L0CVzpY1bcFDgwx9WlI
 p3Z433JEkjKui0syY2aRR0LZbSmTsnFGWeus2Ezy1J28UoOyxmo3iOq8WAJsntXhhRgp
 wBmMhBtz6/6IJfPFyOT6KlFnXJ8gtyO2Pv3nvJ1CY4COeoMjqHIIqh/m6cLeSuBvleEZ aQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y2p3sme6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Feb 2020 17:55:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01CHfcOZ093948;
        Wed, 12 Feb 2020 17:55:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2y4k7x3xw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Feb 2020 17:55:04 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01CHt4Kw045592;
        Wed, 12 Feb 2020 17:55:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2y4k7x3xvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Feb 2020 17:55:04 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01CHt4EK028539;
        Wed, 12 Feb 2020 17:55:04 GMT
Received: from [10.209.227.41] (/10.209.227.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 09:55:03 -0800
Subject: Re: [PATCH 1/1] net/rds: Track user mapped pages through special API
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <20200212030355.1600749-1-jhubbard@nvidia.com>
 <20200212030355.1600749-2-jhubbard@nvidia.com>
 <c0d8d04e-08d1-60ff-ea4c-e6c71f3e118a@oracle.com>
 <20200212175159.GD679970@unreal>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <b0e45342-4415-67e4-8c5b-37a6fc8d310e@oracle.com>
Date:   Wed, 12 Feb 2020 09:55:02 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200212175159.GD679970@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002120131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/20 9:51 AM, Leon Romanovsky wrote:
> On Wed, Feb 12, 2020 at 09:31:51AM -0800, santosh.shilimkar@oracle.com wrote:
>> On 2/11/20 7:03 PM, John Hubbard wrote:
>>> From: Leon Romanovsky <leonro@mellanox.com>
>>>
>>> Convert net/rds to use the newly introduces pin_user_pages() API,
>>> which properly sets FOLL_PIN. Setting FOLL_PIN is now required for
>>> code that requires tracking of pinned pages.
>>>
>>> Note that this effectively changes the code's behavior: it now
>>> ultimately calls set_page_dirty_lock(), instead of set_page_dirty().
>>> This is probably more accurate.
>>>
>>> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
>>> dealing with a file backed page where we have reference on the inode it
>>> hangs off." [1]
>>>
>>> [1] https://urldefense.com/v3/__https://lore.kernel.org/r/20190723153640.GB720@lst.de__;!!GqivPVa7Brio!OJHuecs9Iup5ig3kQBi_423uMMuskWhBQAdOICrY3UQ_ZfEaxt9ySY7E8y32Q7pk5tByyA$
>>>
>>> Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>> Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>>> ---
>> Change looks fine to me. Just on safer side, we will try
>> to test this change with regression suite to make sure it
>> works as expected.
> 
> Thanks Santosh,
> I wrote this patch before John's series was merged into the tree,
> but back then, Hans tested it and it worked, hope that it still works. :)
> 
I see. Wasn't aware of it. In that case, its should be fine.

Regards,
Santosh
