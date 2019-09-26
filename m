Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85502BF3EE
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfIZNS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:18:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51854 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfIZNS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 09:18:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QDE9HW020149;
        Thu, 26 Sep 2019 13:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5JHjfX/ClfVQeV1xv35C0i2HfLD5Mcn+A2KlqPYkbdM=;
 b=ZH365Uagnno+L42TFiGn0s/sd3cK/xTPKhSiVbsvtSxo2J7Z0IGYOpakHb/xhVSnCo7G
 Wv+qBnhwM/Zm/gFdS3YXnewtvF/P5tC7C6+n4Tk9kyNK07OGTrRlnIP4sMJYJcB1BV8t
 rELpqGpPoed5NGqAQf2TK9XqnwsT2RU/8Bv0ChMH++rg+FNjOxttQjxM1+5iY6KNOaam
 XVMcn0lYWmuhA8AVqChFZLuA1L5+ANlHBLQCi/PlMpduhZ85t3sAUaRyvzwQ3ujgYIun
 j+T9lTE6yA9OIDLs92vBcxpzEW/tcJvD3AHGMi3OMk9SXY8mN8Mpr4j7eKewufpWrtQN CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v5b9u3q7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 13:18:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QDIOlO134358;
        Thu, 26 Sep 2019 13:18:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v8rvt7a4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 13:18:34 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8QDIKdF032457;
        Thu, 26 Sep 2019 13:18:21 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 06:18:20 -0700
Date:   Thu, 26 Sep 2019 16:18:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Alvaro G. M" <alvaro.gamez@hazent.com>
Cc:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net] net: axienet: fix a signedness bug in probe
Message-ID: <20190926131811.GG29696@kadam>
References: <20190925105911.GI3264@mwanda>
 <20190925110542.GA21923@salem.gmr.ssr.upm.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925110542.GA21923@salem.gmr.ssr.upm.es>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260125
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 01:05:43PM +0200, Alvaro G. M wrote:
> Hi, Dan
> 
> On Wed, Sep 25, 2019 at 01:59:11PM +0300, Dan Carpenter wrote:
> > The "lp->phy_mode" is an enum but in this context GCC treats it as an
> > unsigned int so the error handling is never triggered.
> > 
> >  		lp->phy_mode = of_get_phy_mode(pdev->dev.of_node);
> > -		if (lp->phy_mode < 0) {
> > +		if ((int)lp->phy_mode < 0) {
> 
> This (almost) exact code appears in a lot of different drivers too,
> so maybe it'd be nice to review them all and apply the same cast if needed?
> 

This is a new warning in Smatch.  I did send patches for the whole
kernel.  We won't get these bugs in the future because people run Smatch
on the kernel and will find the bugs.  All the bugs were from 2017 or
later which suggests that someone cleared these out two years ago but
soon the 0-day bot will warn about issues so they will get fixed
quicker.

I'm sort of out of it today...

The get_phy_mode() function seem like they lend themselves to creating
these bugs.  The ->phy_mode variables tend to be declared in the driver
so it would require quite a few patches to make them all int and I'm not
sure that's more beautiful.  Andrew Lunn's idea to update the API would
probably be a good idea.

I'm going back to bed for now and I'll think about this some more.

regards,
dan carpenter
