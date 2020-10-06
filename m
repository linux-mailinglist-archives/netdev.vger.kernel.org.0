Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27F0285191
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 20:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgJFS2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 14:28:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52218 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgJFS2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 14:28:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096IOu8Y012997;
        Tue, 6 Oct 2020 18:28:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6+95rsR9Z5CjnDrnTBVtpeRBJgt9yjv4jhnHQhmfouo=;
 b=P7oF4q8zxf2Q23cohhSEQNdGXSDxa1t5zKv/jbcxspBlc7BMHD0TceE38/jHiIn7AqyD
 f6c+0cv5CAKDroQwH4kzpJIA/Yd3BX8hH+2Z11VB0r/Ld2tck78gnLnBXfhFpMv23zlC
 G3bs4B1sogMTojT52qkklmDX0rTYgY/3RyRdbaf57TghEyTV/V+1oc1lvKqOPb17k5TI
 GaLWd6MfF8CWI9kWbl8OA7+zx7qh99ub1lzzC4emxOmz30sYdRn1A/Y88r3gib9Pq5NX
 SFpp1CYrjFIYBnGzmkjWTLzGWUw+ED17nlgHV1oTi4EGAADbYwv9gk7trBVhf3jpA2bj sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxmwmm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 18:28:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096ILMsQ016127;
        Tue, 6 Oct 2020 18:26:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33y2vnd2n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 18:26:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 096IQZ1c003553;
        Tue, 6 Oct 2020 18:26:35 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 11:26:35 -0700
Date:   Tue, 6 Oct 2020 21:26:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Colin King <colin.king@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: phy: dp83869: fix unsigned comparisons
 against less than zero values
Message-ID: <20201006182628.GI4282@kadam>
References: <20201002165422.94328-1-colin.king@canonical.com>
 <1ffbf497-cb07-4302-8a79-236338f00383@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ffbf497-cb07-4302-8a79-236338f00383@ti.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 12:26:49PM -0500, Dan Murphy wrote:
> Colin
> 
> On 10/2/20 11:54 AM, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > Currently the comparisons of u16 integers value and sopass_val with
> > less than zero for error checking is always false because the values
> > are unsigned. Fix this by making these variables int.  This does not
> > affect the shift and mask operations performed on these variables
> > 
> > Addresses-Coverity: ("Unsigned compared against zero")
> > Fixes: 49fc23018ec6 ("net: phy: dp83869: support Wake on LAN")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >   drivers/net/phy/dp83869.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> > index 0aee5f645b71..cf6dec7b7d8e 100644
> > --- a/drivers/net/phy/dp83869.c
> > +++ b/drivers/net/phy/dp83869.c
> > @@ -305,7 +305,7 @@ static int dp83869_set_wol(struct phy_device *phydev,
> >   static void dp83869_get_wol(struct phy_device *phydev,
> >   			    struct ethtool_wolinfo *wol)
> >   {
> > -	u16 value, sopass_val;
> > +	int value, sopass_val;
> >   	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
> >   			WAKE_MAGICSECURE);
> 
> Wonder why this was not reported before as the previous comparison issue
> reported by zero day.

It was reported on Sep 25.  I forward those zero day bot emails.

https://lore.kernel.org/lkml/20200925123858.GX18329@kadam/

regards,
dan carpenter

