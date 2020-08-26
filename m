Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29D0252B05
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 12:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgHZKB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 06:01:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgHZKBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 06:01:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07Q9rmML110211;
        Wed, 26 Aug 2020 09:58:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=99lx5iUfIkT1H9yGqvvBxJOhPDkHKQlkIHLEmQ8PDXw=;
 b=pHUo6T87aN4HkyoolW4yELYhdaG6ZvSavIkxfBgUOj0Org1O9z1r+ZQOuET12WJ7H5Pc
 xnVCQfyl6qFGmQNX19oW+/bFETNvgM6pF7csHfuvBHB3cwqfsUd0O1/rGIc/5OQTnnFB
 MEojeNBzUtEmGEuqP0gM6P7/G+Nn01P+JHgzxPDBnzH/evLKYOeuFaI9EUmCauKOO4Dv
 zZppw57NrWnHoxtj9wH99M6dzm4GlspA3OSB7TYDhwfTGMPmrp1Qrwutr2AFfwHTZX4W
 mmUMO7IJxJ3uJAsWGpM1c6assMY729yLXVkHlFuUfSzlq1xzAsoVwPIWis3T8JNJMC4u Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 333dbryf24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 09:58:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07Q9odrR139540;
        Wed, 26 Aug 2020 09:56:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 333rtywr8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 09:56:05 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07Q9tlAJ026067;
        Wed, 26 Aug 2020 09:55:47 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 02:55:46 -0700
Date:   Wed, 26 Aug 2020 12:55:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Allen Pais <allen.cryptic@gmail.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-atm-general@lists.sourceforge.net, manohar.vanga@gmail.com,
        airlied@linux.ie, linux-hyperv@vger.kernel.org,
        dri-devel@lists.freedesktop.org, sre@kernel.org,
        anton.ivanov@cambridgegreys.com, devel@driverdev.osuosl.org,
        linux-s390@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        maximlevitsky@gmail.com, richard@nod.at, deller@gmx.de,
        jassisinghbrar@gmail.com, linux-spi@vger.kernel.org,
        3chas3@gmail.com, intel-gfx@lists.freedesktop.org,
        Jakub Kicinski <kuba@kernel.org>, mporter@kernel.crashing.org,
        jdike@addtoit.com, Kees Cook <keescook@chromium.org>,
        oakad@yahoo.com, s.hauer@pengutronix.de,
        linux-input@vger.kernel.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, broonie@kernel.org,
        openipmi-developer@lists.sourceforge.net, mitch@sfgoth.com,
        linux-arm-kernel@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        martyn@welchs.me.uk, dmitry.torokhov@gmail.com,
        linux-mmc@vger.kernel.org, Allen <allen.lkml@gmail.com>,
        linux-kernel@vger.kernel.org, alex.bou9@gmail.com,
        stefanr@s5r6.in-berlin.de, Daniel Vetter <daniel@ffwll.ch>,
        linux-ntb@googlegroups.com,
        Romain Perier <romain.perier@gmail.com>, shawnguo@kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] block: convert tasklets to use new tasklet_setup() API
Message-ID: <20200826095528.GX1793@kadam>
References: <202008171228.29E6B3BB@keescook>
 <161b75f1-4e88-dcdf-42e8-b22504d7525c@kernel.dk>
 <202008171246.80287CDCA@keescook>
 <df645c06-c30b-eafa-4d23-826b84f2ff48@kernel.dk>
 <1597780833.3978.3.camel@HansenPartnership.com>
 <f3312928-430c-25f3-7112-76f2754df080@kernel.dk>
 <1597849185.3875.7.camel@HansenPartnership.com>
 <CAOMdWSJRR0BhjJK1FxD7UKxNd5sk4ycmEX6TYtJjRNR6UFAj6Q@mail.gmail.com>
 <1597873172.4030.2.camel@HansenPartnership.com>
 <CAEogwTCH8qqjAnSpT0GDn+NuAps8dNbfcPVQ9h8kfOWNbzrD0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEogwTCH8qqjAnSpT0GDn+NuAps8dNbfcPVQ9h8kfOWNbzrD0w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9724 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9724 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 07:21:35AM +0530, Allen Pais wrote:
> On Thu, Aug 20, 2020 at 3:09 AM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > On Wed, 2020-08-19 at 21:54 +0530, Allen wrote:
> > > > [...]
> > > > > > Since both threads seem to have petered out, let me suggest in
> > > > > > kernel.h:
> > > > > >
> > > > > > #define cast_out(ptr, container, member) \
> > > > > >     container_of(ptr, typeof(*container), member)
> > > > > >
> > > > > > It does what you want, the argument order is the same as
> > > > > > container_of with the only difference being you name the
> > > > > > containing structure instead of having to specify its type.
> > > > >
> > > > > Not to incessantly bike shed on the naming, but I don't like
> > > > > cast_out, it's not very descriptive. And it has connotations of
> > > > > getting rid of something, which isn't really true.
> > > >
> > > > Um, I thought it was exactly descriptive: you're casting to the
> > > > outer container.  I thought about following the C++ dynamic casting
> > > > style, so out_cast(), but that seemed a bit pejorative.  What about
> > > > outer_cast()?
> > > >
> > > > > FWIW, I like the from_ part of the original naming, as it has
> > > > > some clues as to what is being done here. Why not just
> > > > > from_container()? That should immediately tell people what it
> > > > > does without having to look up the implementation, even before
> > > > > this becomes a part of the accepted coding norm.
> > > >
> > > > I'm not opposed to container_from() but it seems a little less
> > > > descriptive than outer_cast() but I don't really care.  I always
> > > > have to look up container_of() when I'm using it so this would just
> > > > be another macro of that type ...
> > > >
> > >
> > >  So far we have a few which have been suggested as replacement
> > > for from_tasklet()
> > >
> > > - out_cast() or outer_cast()
> > > - from_member().
> > > - container_from() or from_container()
> > >
> > > from_container() sounds fine, would trimming it a bit work? like
> > > from_cont().
> >
> > I'm fine with container_from().  It's the same form as container_of()
> > and I think we need urgent agreement to not stall everything else so
> > the most innocuous name is likely to get the widest acceptance.
> 
> Kees,
> 
>   Will you be  sending the newly proposed API to Linus? I have V2
> which uses container_from()
> ready to be sent out.

I liked that James swapped the first two arguments so that it matches
container_of().  Plus it's nice that when you have:

	struct whatever *foo = container_from(ptr, foo, member);

Then it means that "ptr == &foo->member".

regards,
dan carpenter

