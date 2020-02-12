Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DC015AEC5
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgBLRcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:32:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40724 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgBLRcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 12:32:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01CHVO1d096683;
        Wed, 12 Feb 2020 17:31:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=s65aO/8IZJu4xCgV1gff0ctcMPYShMHG/a2PtOoIauY=;
 b=PtqNSKTuGm2rh0qwec5o0nv6tsIw9GkespctJjWvBi/nKDvfLzF+qIrs8eBWD/C2qqYh
 ZwiHJ3aIg0V4lNasBx5KvTCBRcwfK2R6mNsgLhX3FfCH/tKGH/kBEQbzKZ2ZIwLKW9vH
 vLFYyRREkaH5IQepvY9jutuaM42rC8jFnPw5p5ES+icjnvEQ/mESp6H9W1r3Id1VCyWw
 Cz31rr3n7M3mUAqNw3HJm+5mJTCjzM5f5SY8Ewhyp8lwdyLXBltlD8T/o1TeUjXbT0ny
 9xGLa+FB02g0gdkHqpj3jVKLnUArHKL98g6y07SGRiZmHuakZ1GAOYtp0NymiwLkupuP uA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y2p3smaat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Feb 2020 17:31:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01CHRisZ101603;
        Wed, 12 Feb 2020 17:31:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2y4k7x2r88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Feb 2020 17:31:56 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01CHVuxh154129;
        Wed, 12 Feb 2020 17:31:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2y4k7x2r6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Feb 2020 17:31:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01CHVrj4020985;
        Wed, 12 Feb 2020 17:31:53 GMT
Received: from [10.209.227.41] (/10.209.227.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 09:31:52 -0800
Subject: Re: [PATCH 1/1] net/rds: Track user mapped pages through special API
To:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <20200212030355.1600749-1-jhubbard@nvidia.com>
 <20200212030355.1600749-2-jhubbard@nvidia.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <c0d8d04e-08d1-60ff-ea4c-e6c71f3e118a@oracle.com>
Date:   Wed, 12 Feb 2020 09:31:51 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200212030355.1600749-2-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1011
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002120130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/20 7:03 PM, John Hubbard wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Convert net/rds to use the newly introduces pin_user_pages() API,
> which properly sets FOLL_PIN. Setting FOLL_PIN is now required for
> code that requires tracking of pinned pages.
> 
> Note that this effectively changes the code's behavior: it now
> ultimately calls set_page_dirty_lock(), instead of set_page_dirty().
> This is probably more accurate.
> 
> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
> dealing with a file backed page where we have reference on the inode it
> hangs off." [1]
> 
> [1] https://urldefense.com/v3/__https://lore.kernel.org/r/20190723153640.GB720@lst.de__;!!GqivPVa7Brio!OJHuecs9Iup5ig3kQBi_423uMMuskWhBQAdOICrY3UQ_ZfEaxt9ySY7E8y32Q7pk5tByyA$
> 
> Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
Change looks fine to me. Just on safer side, we will try
to test this change with regression suite to make sure it
works as expected.

For patch itself,

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
