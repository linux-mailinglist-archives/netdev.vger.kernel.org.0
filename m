Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9044A105218
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 13:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfKUMKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 07:10:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfKUMKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 07:10:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALC91JV013371;
        Thu, 21 Nov 2019 12:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Dq2dMuOCLQfRiUH1NYttnwcL5/6LTvSWv74kK3octXc=;
 b=IQ4v7puYKBsqJf7LIh7pGx2BQCJtML1CYnkjnmUFHpDVuxslvk7uZcZC4RygdqRqAPVB
 QJfB+ZRJe5qjGoKFJyySfdM68kKszk0q7Oe3b34iP4scY+QxypbF9B3lSInrF4ZT5w+B
 s9q7hxIVNqcI4XmxEPntgd38OPJDn7T8wwkis0rBPltN8Ypac3YzmPLeyqTHnOXNlMf1
 KP2mF62PjYGlo0SSt8LRuv3UQm40cw6QHxBthKHq7H+kh1q5HPYVsF1EptgXp1FrVmKu
 lbdd0qZn8GgihIjSgcyQYaK5ycZ4DaIeV1uMTkReQHF6sKbHCSCkF9F/iy1vI6K2seMZ SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wa9rqunpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 12:09:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALC8wCC040000;
        Thu, 21 Nov 2019 12:09:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wdfrsanm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 12:09:06 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xALC7x6X026371;
        Thu, 21 Nov 2019 12:07:59 GMT
Received: from kadam (/41.210.154.230)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 04:07:57 -0800
Date:   Thu, 21 Nov 2019 15:07:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Joe Perches <joe@perches.com>,
        zhanglin <zhang.lin16@zte.com.cn>, davem@davemloft.net,
        cocci <cocci@systeme.lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        jakub.kicinski@netronome.com, ast@kernel.org,
        jiang.xuexin@zte.com.cn, f.fainelli@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        lirongqing@baidu.com, maxime.chevallier@bootlin.com,
        vivien.didelot@gmail.com, wang.yi59@zte.com.cn, hawk@kernel.org,
        arnd@arndb.de, jiri@mellanox.com, xue.zhihong@zte.com.cn,
        natechancellor@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linyunsheng@huawei.com,
        pablo@netfilter.org, bpf@vger.kernel.org
Subject: Re: [Cocci] [PATCH] net: Zeroing the structure ethtool_wolinfo in
 ethtool_get_wol()
Message-ID: <20191121120733.GF5604@kadam>
References: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
 <c790578751dd69fb1080b355f5847c9ea5fb0e15.camel@perches.com>
 <bc150c6a-6d3e-ff01-e40e-840e8a385bda@metux.net>
 <20191121111917.GE29650@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121111917.GE29650@unicorn.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 12:19:17PM +0100, Michal Kubecek wrote:
> On Thu, Nov 21, 2019 at 11:23:34AM +0100, Enrico Weigelt, metux IT consult wrote:
> > On 26.10.19 21:40, Joe Perches wrote:
> > > On Sat, 2019-10-26 at 15:54 +0800, zhanglin wrote:
> > >> memset() the structure ethtool_wolinfo that has padded bytes
> > >> but the padded bytes have not been zeroed out.
> > > []
> > >> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> > > []
> > >> @@ -1471,11 +1471,13 @@ static int ethtool_reset(struct net_device *dev, char __user *useraddr)
> > >>  
> > >>  static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
> > >>  {
> > >> -	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
> > >> +	struct ethtool_wolinfo wol;
> > >>  
> > >>  	if (!dev->ethtool_ops->get_wol)
> > >>  		return -EOPNOTSUPP;
> > >>  
> > >> +	memset(&wol, 0, sizeof(struct ethtool_wolinfo));
> > >> +	wol.cmd = ETHTOOL_GWOL;
> > >>  	dev->ethtool_ops->get_wol(dev, &wol);
> > >>  
> > >>  	if (copy_to_user(useraddr, &wol, sizeof(wol)))
> > > 
> > > It seems likely there are more of these.
> > > 
> > > Is there any way for coccinelle to find them?
> > 
> > Just curios: is static struct initialization (on stack) something that
> > should be avoided ? I've been under the impression that static
> > initialization allows thinner code and gives the compiler better chance
> > for optimizations.
> 
> Not in general. The (potential) problem here is that the structure has
> padding and it is as a whole (i.e. including the padding) copied to
> userspace. While I'm not aware of a compiler that wouldn't actually
> initialize the whole data block including the padding in this case, the
> C standard provides no guarantee about that so that to be sure we cannot
> leak leftover kernel data to userspace, we need to explicitly initialize
> the whole block.

GCC will not always initialize the struct holes.  This patch fixes a
real bug that GCC on my system (v7.4)

regards,
dan carpenter

