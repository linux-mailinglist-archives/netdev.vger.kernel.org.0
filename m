Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A2421D2A0
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 11:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgGMJNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 05:13:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54872 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgGMJNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 05:13:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06D96nCd150599;
        Mon, 13 Jul 2020 09:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XLvfUS4mbnV209WiCLIZkkPnGW6xeTZVH1WmfCUolWs=;
 b=tzeG5ve5TmruXBYeD9fe3P4ay+Nf1tkBPArT6w+89JT5hNRXDqSZU91+g15xPWrtafNt
 ZLTYImWy1OkIQ7w8fG/d39KP2quYoCC2Yvd1D/U+L+p9jYE2rPBwC9g7pa2ki+6mlrBP
 sQLkCQuENMsJAe01428Hub7ho75G6GAHVicrhf+BvvO+Ie4ELwQccA4lT2DsO8XSnmz2
 gHNLgk0ksBwmu1ock23DP+QK3Iz3biOfIj56Jdmk49tcghTpeh9sTKkYgMorkr8Hy7MZ
 kFzTm6Yw2oiHwD7nauThznUSN4yjcgzy/scVg/eBdjKC15rpAUJKzkmJvvVY+ZP030mj Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32762n5svv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 09:13:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06D98X5X145817;
        Mon, 13 Jul 2020 09:13:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 327qbv8vbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 09:13:40 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06D9DcU1002442;
        Mon, 13 Jul 2020 09:13:38 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 02:13:37 -0700
Date:   Mon, 13 Jul 2020 12:13:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] qrtr: Fix ZERO_SIZE_PTR deref
 in qrtr_tun_write_iter()
Message-ID: <20200713091329.GP2571@kadam>
References: <20200712210300.200399-1-yepeilin.cs@gmail.com>
 <20200712213631.GA809@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200712213631.GA809@sol.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130071
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 12, 2020 at 02:36:31PM -0700, Eric Biggers wrote:
> On Sun, Jul 12, 2020 at 05:03:00PM -0400, Peilin Ye wrote:
> > qrtr_tun_write_iter() is dereferencing `ZERO_SIZE_PTR`s when `from->count`
> > equals to zero. Fix it by rejecting zero-length kzalloc() requests.
> > 
> > This patch fixes the following syzbot bug:
> > 
> >     https://syzkaller.appspot.com/bug?id=f56bbe6668873ee245986bbd23312b895fa5a50a
> > 
> > Reported-by: syzbot+03e343dbccf82a5242a2@syzkaller.appspotmail.com
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > ---
> >  net/qrtr/tun.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
> > index 15ce9b642b25..5465e94ba8e5 100644
> > --- a/net/qrtr/tun.c
> > +++ b/net/qrtr/tun.c
> > @@ -80,6 +80,9 @@ static ssize_t qrtr_tun_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >  	ssize_t ret;
> >  	void *kbuf;
> >  
> > +	if (!len)
> > +		return -EINVAL;
> > +
> >  	kbuf = kzalloc(len, GFP_KERNEL);
> >  	if (!kbuf)
> >  		return -ENOMEM;
> 
> Wasn't this already fixed by:
> 
>     commit 8ff41cc21714704ef0158a546c3c4d07fae2c952
>     Author: Dan Carpenter <dan.carpenter@oracle.com>
>     Date:   Tue Jun 30 14:46:15 2020 +0300
> 
>         net: qrtr: Fix an out of bounds read qrtr_endpoint_post()


Yep.  If you're using kmalloc() you can allocate a zero byte buffer but
you just can't access the array.  for (i = 0; i < 0; i++) works.

It's interesting because at the time, I wrote the patch I thought "len"
probably couldn't be zero but I just checked it for completeness and
readability.

regards,
dan carpenter
