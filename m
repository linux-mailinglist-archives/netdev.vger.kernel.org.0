Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182B337BDC6
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 15:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhELNOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 09:14:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55902 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231516AbhELNOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 09:14:17 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14CDCkoN020974;
        Wed, 12 May 2021 13:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QRs5gdlYriFU1v1EfQ+7iR08huQidQJKaI0/QDa1fOw=;
 b=yIxXWRH14O29PT8kolnkt2yqtI0NDL5OiiveV45Fo27TGbw5iCNlMkDVVLbkq7F2TQL0
 8yAZkG/fH3Ypp+SOBad1YpbLKyvDpPZw4hl9ucjjn5vx7MBSQWLMF7IyrdZd0hwd4iRx
 2JPjtqqQWKAWAX3NCrhggcAn4/yvlBlvkk/rlvyaCgNPBLbyJsRqDedh1ZhhVukWIvGk
 MLj8Q/HJZLdrDnP2XKu++Yku9kLvxC0nT1Ghu2EKqa/eWdvEcf3NKUORZ+nyV54ZL9vw
 Dl6spRJ20AkbGUQhW2GQtWcqoCD41mjGonhzuta95d2QGypckv8p77Qcny3KkPQ15z0Q dw== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38ex140sjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 13:12:46 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14CDCjXX031433;
        Wed, 12 May 2021 13:12:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38djfbjx0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 13:12:45 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14CDBNgx015043;
        Wed, 12 May 2021 13:12:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 38djfbjwxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 13:12:44 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14CDCfWR026621;
        Wed, 12 May 2021 13:12:41 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 May 2021 06:12:40 -0700
Date:   Wed, 12 May 2021 16:12:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Denis Joseph Barrow <D.Barow@option.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: hso: check for allocation failure in
 hso_create_bulk_serial_device()
Message-ID: <20210512131232.GX1955@kadam>
References: <YJupQPb+Y4vw3rDk@mwanda>
 <YJurlxqQ9L+zzIAS@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJurlxqQ9L+zzIAS@hovoldconsulting.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: vQDJBerTT7xwK3dR9YNacmK_j22vue2w
X-Proofpoint-ORIG-GUID: vQDJBerTT7xwK3dR9YNacmK_j22vue2w
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 12:19:03PM +0200, Johan Hovold wrote:
> On Wed, May 12, 2021 at 01:09:04PM +0300, Dan Carpenter wrote:
> > Add a couple checks for if these allocations fail.
> > 
> > Fixes: 542f54823614 ("tty: Modem functions for the HSO driver")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/net/usb/hso.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> > index 3ef4b2841402..3b2a868d7a72 100644
> > --- a/drivers/net/usb/hso.c
> > +++ b/drivers/net/usb/hso.c
> > @@ -2618,9 +2618,13 @@ static struct hso_device *hso_create_bulk_serial_device(
> >  		num_urbs = 2;
> >  		serial->tiocmget = kzalloc(sizeof(struct hso_tiocmget),
> >  					   GFP_KERNEL);
> > +		if (!serial->tiocmget)
> > +			goto exit;
> 
> Nice catch; the next assignment would go boom if this ever failed.
> 
> This appears to have been introduced by 
> 
> 	af0de1303c4e ("usb: hso: obey DMA rules in tiocmget")
> 
> >  		serial->tiocmget->serial_state_notification
> >  			= kzalloc(sizeof(struct hso_serial_state_notification),
> >  					   GFP_KERNEL);
> > +		if (!serial->tiocmget->serial_state_notification)
> > +			goto exit;
> >  		/* it isn't going to break our heart if serial->tiocmget
> >  		 *  allocation fails don't bother checking this.
> >  		 */
> 
> You should remove this comment and drop the conditional on the following
> line as well now, though.

Ah, good catch.  I'll resend. Thanks!

regards,
dan carpenter

