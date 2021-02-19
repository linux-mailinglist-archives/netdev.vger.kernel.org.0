Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D241B31F7F1
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 12:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhBSLKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 06:10:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhBSLKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 06:10:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JB4Fcs096687;
        Fri, 19 Feb 2021 11:09:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fsG/A7Asde2lfBXDx/6SqDya0xlFJSttv5i9ktaeAiY=;
 b=t1ZRuiTyswZKGgafFLRE1mt5aXVraICnTHP+Oh5uTy9UvbjTkcbDaigtZui3tHQWWkbe
 oXXvuZrjB4L/Z8vl0qShZVu0ACzvy5uGqdp25pIpdN9qGx01xfLrdbvF0p+4WN/6w6LY
 IOc3UY3XTuo+YWuD0g3V01PQk6Iy1nGGO1cbai8dMKlvuwVQUXuTwH82qjqyJ9KeAh6l
 eUm7Cqj3NDkJbr6mXyBdthZmkakMeAu3DTWUFIKjUsz7QbvHoT64mMHWG/h88VCplUSl
 wcqsJW1KAGXiZIcLqsc934vIUUQiIcpE1X/550APaVr7jBYUTlPq2HRB83xXl2YEOE/m 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36p7dns288-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 11:09:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JB6UJ4132066;
        Fri, 19 Feb 2021 11:09:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 36prbs13kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 11:09:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11JB9Pkb012435;
        Fri, 19 Feb 2021 11:09:25 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Feb 2021 11:09:24 +0000
Date:   Fri, 19 Feb 2021 14:09:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: phy: icplus: call phy_restore_page()
 when phy_select_page() fails
Message-ID: <20210219110913.GQ2222@kadam>
References: <YC+OpFGsDPXPnXM5@mwanda>
 <b10a9b2cf171976e710c309fc82a4728@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b10a9b2cf171976e710c309fc82a4728@walle.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190089
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 11:46:23AM +0100, Michael Walle wrote:
> Am 2021-02-19 11:10, schrieb Dan Carpenter:
> > The comments to phy_select_page() say that "phy_restore_page() must
> > always be called after this, irrespective of success or failure of this
> > call."  If we don't call phy_restore_page() then we are still holding
> > the phy_lock_mdio_bus() so it eventually leads to a dead lock.
> > 
> > Fixes: 32ab60e53920 ("net: phy: icplus: add MDI/MDIX support for
> > IP101A/G")
> > Fixes: f9bc51e6cce2 ("net: phy: icplus: fix paged register access")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Reviewed-by: Michael Walle <michael@walle.cc>
> 
> I assume, this has to go through "net" if the merge window is closed, no?

It applies to net-next and not to net.  I expect that all of net-next
will be merged into net soon enough, but as of a couple hours ago it
only applied to net-next.

regards,
dan carpenter

