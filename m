Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C518D1DBE3D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgETTp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:45:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37278 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETTp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:45:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KJRr4m063954;
        Wed, 20 May 2020 19:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=uK5Lcdw4NGbEJFHC3Vv/WDvbuBjG0vtZ2idMT/tLedo=;
 b=fWRZRQBt2ZL6U+Dc1kee8uHj0a7B/lWVBTlYYS/wW47o9hDTAAiBW53+vF6djqgz/DdZ
 BedVe0daUpOj6iedd5CANaiTGY1x3Ha3eu03e6FGWscz4BbG5xdZRM4mJ781VDYowXI/
 GNPROm6sp7JxMXGciSVDGUvFgR9zUI6j25L+AtBcg/PtCM6NDvjz/KgSov+lkrJ4hOjD
 Y4WLWflBe9fl73Be5p5zPBgoYh7WCUlgKS3/gEk+ipy8Rv4cb3O2X469A5S2qkv5RO1L
 ITnU09AkdwlPcQHzMx6S0MRUuFdo76jC7QAwc6rcE4f5I3oFNZf9UBTPc6Tu5Z4zcC6g ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31284m52ra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 19:45:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KJSeAC099029;
        Wed, 20 May 2020 19:43:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 313gj43u34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 19:43:44 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04KJev92134964;
        Wed, 20 May 2020 19:43:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 313gj43u13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 19:43:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KJhftj025589;
        Wed, 20 May 2020 19:43:42 GMT
Received: from [10.74.108.67] (/10.74.108.67)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 12:43:41 -0700
Subject: Re: [PATCH] rds: fix crash in rds_info_getsockopt()
To:     John Hubbard <jhubbard@nvidia.com>,
        syzbot+118ac0af4ac7f785a45b@syzkaller.appspotmail.com
Cc:     akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, syzkaller-bugs@googlegroups.com
References: <00000000000000d71e05a6185662@google.com>
 <20200520194147.127137-1-jhubbard@nvidia.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <d848c10e-1d04-3669-0d0f-5b53505686b1@oracle.com>
Date:   Wed, 20 May 2020 12:43:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200520194147.127137-1-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/20 12:41 PM, John Hubbard wrote:
> The conversion to pin_user_pages() had a bug: it overlooked
> the case of allocation of pages failing. Fix that by restoring
> an equivalent check.
> 
> Reported-by: syzbot+118ac0af4ac7f785a45b@syzkaller.appspotmail.com
> Fixes: dbfe7d74376e ("rds: convert get_user_pages() --> pin_user_pages()")
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: rds-devel@oss.oracle.com
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
Thanks John !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
