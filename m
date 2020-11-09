Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D16B2AC3E8
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgKISfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:35:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59168 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbgKISfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 13:35:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9INh9N041829;
        Mon, 9 Nov 2020 18:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hz0dp+MWnnB/crTto5dkGMHc/HGLug5zH9g1TIHexg0=;
 b=GrZUlFvX3CEmrj3GTUJ4zjo5NplgObEPTpKs+pcIJWgGAdB6eMEexEfMPWHeTOoEOT6I
 oGgF57+WFxHYewJPHkGmPkQB5FABB0H3ugCMMXd1+CC2jGvXDVwf0mjHPWMGayfHhNM0
 6t0z+3dOIpWv9XymOoH9SSWAg194Wr2DF/3PVOPbhS2B4Xloj72/mTvZ2N6r/yye+jtI
 cECiboQoiybzln3LRO4KH8jFaUX2B0EBKgTOcJ/K7nxD6apj6Yc5/r5bR/Vb9BZWoBP3
 CDvmxiL2aCAoXhrB49ps+MFp430Gn2pAZD9wh0QJ31CmuHa+uSQaKDiP36Epr9xUe/Gk tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhkqhnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:34:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IQ5NE019010;
        Mon, 9 Nov 2020 18:34:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34p5gvmrbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:34:29 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A9IYRGA029581;
        Mon, 9 Nov 2020 18:34:27 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:34:27 -0800
Date:   Mon, 9 Nov 2020 21:34:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net 1/2] mptcp: fix static checker warnings in
 mptcp_pm_add_timer
Message-ID: <20201109183419.GQ18329@kadam>
References: <cover.1604930005.git.geliangtang@gmail.com>
 <ccf004469e02fb5bd7ec822414b9a98b0015f4a3.1604930005.git.geliangtang@gmail.com>
 <009ea5da-8a44-3ea2-1b9f-a658a09f3396@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009ea5da-8a44-3ea2-1b9f-a658a09f3396@tessares.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 05:28:54PM +0100, Matthieu Baerts wrote:
> Hi Geliang, Dan,
> 
> On 09/11/2020 14:59, Geliang Tang wrote:
> > Fix the following Smatch complaint:
> 
> Thanks for the report and the patch!
> 
> >       net/mptcp/pm_netlink.c:213 mptcp_pm_add_timer()
> >       warn: variable dereferenced before check 'msk' (see line 208)
> > 
> >   net/mptcp/pm_netlink.c
> >      207          struct mptcp_sock *msk = entry->sock;
> >      208          struct sock *sk = (struct sock *)msk;
> >      209          struct net *net = sock_net(sk);
> >                                             ^^
> >   "msk" dereferenced here.
> > 
> >      210
> >      211          pr_debug("msk=%p", msk);
> >      212
> >      213          if (!msk)
> >                      ^^^^
> >   Too late.
> > 
> >      214                  return;
> >      215
> > 
> > Fixes: 93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> > Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> A small detail (I think): the Signed-off-by of the sender (Geliang) should
> be the last one in the list if I am not mistaken.
> But I guess this is not blocking.

Generally, I like them to be in chronological order.  For other tags like
here it doesn't matter, but for signed-off-bys they only make sense in
chronological order.

regards,
dan carpenter

