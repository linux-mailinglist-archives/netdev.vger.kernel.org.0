Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3F3E5DB1
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 16:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfJZO0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 10:26:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfJZO0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 10:26:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9QEORdr139601;
        Sat, 26 Oct 2019 14:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=g0EobvnuNtLD/kX6AGj4Z/TZ+7lRKu7nyaQLzoUBx5I=;
 b=BQlez8emRUWSibANBLQXkIRr+NQC5XfbrmMQf4rd3PBr0hHWd0cGYQ5Wgo22VVDH7WU5
 XYbo1LqrNUAUOfEH47zkqnmQ+Uu1v0YVOFHDxbP60xx7cqB7AJ8zHwhS+JqY3F0nzfyl
 T+hvFL1INqhN7UhL3/3sxumzqVCRiXlcrmiyy99fIVDluB7v5CHxVJVWSciqMd2w9IXG
 nCLUdGe1JXuPGTY1Qn7d54PYUmhjOMnTjo+jVr0QcAbCc3jKrR3f03bKQBe/EJh16g6B
 lQSLWGq5dzu0sntRKT8NdU23ACvKJxeuaR1eZHeGndyqXA43S70v51R9SU3CQzBeHPoy Fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vve3ptf4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Oct 2019 14:25:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9QEO9rj011950;
        Sat, 26 Oct 2019 14:25:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vvb8wkseq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Oct 2019 14:25:27 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9QEPCHp031477;
        Sat, 26 Oct 2019 14:25:12 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 26 Oct 2019 07:25:12 -0700
Date:   Sat, 26 Oct 2019 17:24:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     zhanglin <zhang.lin16@zte.com.cn>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, mkubecek@suse.cz, jiri@mellanox.com,
        pablo@netfilter.org, f.fainelli@gmail.com,
        maxime.chevallier@bootlin.com, lirongqing@baidu.com,
        vivien.didelot@gmail.com, linyunsheng@huawei.com,
        natechancellor@gmail.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        jiang.xuexin@zte.com.cn
Subject: Re: [PATCH] net: Zeroing the structure ethtool_wolinfo in
 ethtool_get_wol()
Message-ID: <20191026142458.GJ23523@kadam>
References: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9422 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910260146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9422 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910260146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 26, 2019 at 03:54:16PM +0800, zhanglin wrote:
> memset() the structure ethtool_wolinfo that has padded bytes
> but the padded bytes have not been zeroed out.
> 
> Signed-off-by: zhanglin <zhang.lin16@zte.com.cn>
> ---
>  net/core/ethtool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index aeabc48..563a845 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -1471,11 +1471,13 @@ static int ethtool_reset(struct net_device *dev, char __user *useraddr)
>  
>  static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
>  {
> -	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
> +	struct ethtool_wolinfo wol;
>  

How did you detect that they weren't initialized?  Is this a KASAN
thing?

Most of the time GCC will zero out the padding bytes when you have an
initializer like this, but sometimes it just makes the intialization a
series of assignments which leaves the holes uninitialized.  I wish I
knew the rules so that I could check for it in Smatch.  Or even better,
I wish that there were an option to always zero the holes in this
situation...

regards,
dan carpenter

