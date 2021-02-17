Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B8731E153
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhBQV0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:26:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43880 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbhBQVZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 16:25:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HLJlxc081165;
        Wed, 17 Feb 2021 21:24:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EZvpqrgXMjOzeNOEAbxOepiyXAtwIv/GxcPbcJ8w6vs=;
 b=zkU2212nsTh3bJTN2JlWV9MQsKsFnbygaC6ldFctQ/ViCdR2sFQXryHCQY2hQIre8hwS
 dTfZzxZ+OVw0/+4FHpCAlVyuMYXEPqJhjd7Y+LJjmN25TgdaEwT8Wm7Uk3GLO6JkvG7M
 Pn7/qZbqMEmOTN09m4pb5GQWqg/eplHSUHeeO3HKG62CfpcabD4rDeyGqfdQEhtR5bdv
 BjmqX6ANWmZauqjZXMFpQJtkMT38p3MhLuHFUoeuIT03Jffd2C7QK8U/PJgJSoorPSxG
 UQGz9cF/mMFLaZz4WzkqrUBYOcQ5kX2UydpiRT38iuhQMWdDj4pDJ7XnDbFiMeqd1/l2 pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9abcrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 21:24:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HLK7Lq144903;
        Wed, 17 Feb 2021 21:24:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 36prpyn562-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 21:24:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11HLONQg020565;
        Wed, 17 Feb 2021 21:24:24 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Feb 2021 21:24:23 +0000
Date:   Thu, 18 Feb 2021 00:24:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: icplus: Call phy_restore_page() when
 phy_select_page() fails
Message-ID: <20210217212411.GC2087@kadam>
References: <YCy1F5xKFJAaLBFw@mwanda>
 <20210217142838.GM2222@kadam>
 <20210217150621.GG1463@shell.armlinux.org.uk>
 <20210217153357.GE1477@shell.armlinux.org.uk>
 <YC1NKO2HznLC887f@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YC1NKO2HznLC887f@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170160
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170160
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 06:06:48PM +0100, Andrew Lunn wrote:
> > I'm wondering whether we need to add __acquires() and __releases()
> > annotations to some of these functions so that sparse can catch
> > these cases. Thoughts?
> 
> Hi Russell
> 
> The more tools we have for catching locking problems the better.
> Jakubs patchwork bot should then catch them when a patch is submitted,
> if the developer did not run sparse themselves.

Here is how I wrote the check for Smatch.  The code in the kernel looks
like:

	oldpage = phy_select_page(phydev, 0x0007);

	...

	phy_restore_page(phydev, oldpage, 0);

So what I said is that if phy_select_page() returns an error code then
set "phydev" to &selected state.  Then if we call phy_restore_page()
set it to &undefined.  When we hit a return, check if we have any
"phydev" variables can possibly be in &selected state and print a
warning.

The code is below.

regards,
dan carpenter

#include "smatch.h"
#include "smatch_slist.h"

static int my_id;

STATE(selected);

static sval_t err_min = { .type = &int_ctype, .value = -4095 };
static sval_t err_max = { .type = &int_ctype, .value = -1 };

static void match_phy_select_page(struct expression *expr, const char *name, struct symbol *sym, void *data)
{
	set_state(my_id, name, sym, &selected);
}

static void match_phy_restore_page(struct expression *expr, const char *name, struct symbol *sym, void *data)
{
	set_state(my_id, name, sym, &undefined);
}

static void match_return(struct expression *expr)
{
	struct sm_state *sm;

	FOR_EACH_MY_SM(my_id, __get_cur_stree(), sm) {
		if (slist_has_state(sm->possible, &selected)) {
			sm_warning("phy_select_page() requires restore on error");
			return;
		}
	} END_FOR_EACH_SM(sm);
}

void check_phy_select_page_fail(int id)
{
	if (option_project != PROJ_KERNEL)
		return;

	my_id = id;

	return_implies_param_key("phy_select_page", err_min, err_max,
				 &match_phy_select_page, 0, "$", NULL);
	add_function_param_key_hook("phy_restore_page", &match_phy_restore_page,
				    0, "$", NULL);
	add_hook(&match_return, RETURN_HOOK);
}
