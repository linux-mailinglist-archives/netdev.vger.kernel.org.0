Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3EF233910
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbgG3TaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:30:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53710 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730497AbgG3TaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:30:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UJR3XR008264;
        Thu, 30 Jul 2020 19:30:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MYB52dScwZ/YBoMJOfRh65nbt7ONDs6/VLbB0Qsq0fc=;
 b=XLRFex85LtNCdTDAA7zB9spn+lHdz8yywS6/YV+AjFb+6CrgVPg02x0RTerQJrzla9lS
 YSXIlriNxsjKlhe7G0qtfRHMpDROWqBnI3Z/wk3r6RBWlq06lFB3LuB0/Jk19gOXTOhO
 AwMi+mshxlbtbJjDtSasSEDGGVseGyInn7v2M2HnegKS9hk1IBUX9uOpUxCFDu8RARe6
 IeyAcq1c4WV6LXPhmjg1pTMiJn2JFAdv73pY1CnrRolipzJv8wNWZJfAPlSY6oGV4xZc
 87aJxUk3H0eIN77JwJustCdPW1YHRdW4dH/F/LuFuKjvJ21C+92oV56WUejcvD+vuQLt Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32hu1jnkuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 19:30:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UJSgGP119594;
        Thu, 30 Jul 2020 19:30:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 32hu5xbn6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 19:30:03 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06UJSh0p119640;
        Thu, 30 Jul 2020 19:30:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32hu5xbmyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 19:30:03 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06UJU19s023130;
        Thu, 30 Jul 2020 19:30:01 GMT
Received: from dhcp-10-159-232-234.vpn.oracle.com (/10.159.232.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jul 2020 12:30:01 -0700
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
From:   "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <2b21c0e4-2783-74f6-313b-9f6cb17c545a@oracle.com>
Date:   Thu, 30 Jul 2020 12:29:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200730192026.110246-1-yepeilin.cs@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/20 12:20 PM, Peilin Ye wrote:
> rds_notify_queue_get() is potentially copying uninitialized kernel stack
> memory to userspace since the compiler may leave a 4-byte hole at the end
> of `cmsg`.
> 
> In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`, which
> unfortunately does not always initialize that 4-byte hole. Fix it by using
> memset() instead.
> 
> Cc: stable@vger.kernel.org
> Fixes: f037590fff30 ("rds: fix a leak of kernel memory")
> Fixes: bdbe6fbc6a2f ("RDS: recv.c")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
> Note: the "real" copy_to_user() happens in put_cmsg(), where
> `cmlen - sizeof(*cm)` equals to `sizeof(cmsg)`.
> 
> Reference: https://lwn.net/Articles/417989/
> 
> $ pahole -C "rds_rdma_notify" net/rds/recv.o
> struct rds_rdma_notify {
> 	__u64                      user_token;           /*     0     8 */
> 	__s32                      status;               /*     8     4 */
> 
> 	/* size: 16, cachelines: 1, members: 2 */
> 	/* padding: 4 */
> 	/* last cacheline: 16 bytes */
> };
> 
>   net/rds/recv.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
Looks good.
FWIW,
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
