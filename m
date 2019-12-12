Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6811A11CBD9
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 12:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfLLLHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 06:07:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34214 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728613AbfLLLHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 06:07:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCAwwB0056725;
        Thu, 12 Dec 2019 11:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=YRk6g7FxBAzSfJq2rxanLkGSDrmUILvwq1H4o0Nf8a0=;
 b=bLPkQT4mKEuc+Fxi6AsqdsjDk7SkewoV2cW2scJzIgOoM6V1VVjV6yYT2VGz/llEMpli
 9+AOLjuW/a+GW5xS4GUHGkgVqHujAQ2xuJ+LgZTcWmeJOyHE0/dMHrqPMlK08daP53NR
 ynuC13Tt3ntLOtezqcZZ5jksE/F66YAABFmXqgqr24/U/zmvZLGGoibPU/EpERAXKk8o
 f/eFw0+as9S6ouBrMbN/WJFuBzv/mkC5SxaZy3OiYbwJ8Mlq9qVF39i6/1czkx2D/pEw
 AmlXnm4spgO+P5xr+5MkpYJyhb38NfJhB2T+SXm4/xy3uvb3lq6QWDHRnH0gO7J84HGp nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wr41qjaqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 11:07:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCB7MRO095116;
        Thu, 12 Dec 2019 11:07:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wu3k15fa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 11:07:40 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBCB7cZZ011111;
        Thu, 12 Dec 2019 11:07:39 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 03:07:38 -0800
Date:   Thu, 12 Dec 2019 14:07:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
        linux-kernel@vger.kernel.org, Manish Chopra <manishc@marvell.com>
Subject: Re: [PATCH v2 20/23] staging: qlge: Fix CHECK: usleep_range is
 preferred over udelay
Message-ID: <20191212110729.GD2070@kadam>
References: <cover.1576086080.git.schaferjscott@gmail.com>
 <a3f14b13d76102cd4e536152e09517a69ddbe9f9.1576086080.git.schaferjscott@gmail.com>
 <337af773-a1da-0c04-6180-aa3597372522@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <337af773-a1da-0c04-6180-aa3597372522@cogentembedded.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120082
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 01:45:57PM +0300, Sergei Shtylyov wrote:
> Hello!
> 
> On 11.12.2019 21:12, Scott Schafer wrote:
> 
> > chage udelay() to usleep_range()
> 
>    Change?
> 
> > Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
> > ---
> >   drivers/staging/qlge/qlge_main.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> > index e18aa335c899..9427386e4a1e 100644
> > --- a/drivers/staging/qlge/qlge_main.c
> > +++ b/drivers/staging/qlge/qlge_main.c
> > @@ -147,7 +147,7 @@ int ql_sem_spinlock(struct ql_adapter *qdev, u32 sem_mask)
> >   	do {
> >   		if (!ql_sem_trylock(qdev, sem_mask))
> >   			return 0;
> > -		udelay(100);
> > +		usleep_range(100, 200);
> 
>    I hope you're not in atomic context...

I have an unpublished Smatch check which says that we aren't in atomic
context, but still this has spin_lock() in the name so you're right, it
shouldn't sleep.

regards,
dan carpenter

