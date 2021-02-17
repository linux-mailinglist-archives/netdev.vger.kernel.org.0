Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7266831DB7F
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 15:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhBQOaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 09:30:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbhBQOaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 09:30:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HEOuHW123468;
        Wed, 17 Feb 2021 14:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VvKlgYlVOYtS4OI7T3yN1e+q9Tl67gJogc0P5PctqGc=;
 b=O9FsFRC3ZoeNiAc8cHxWwkrtxtzmtRM0Y7hTFqYnlnA5/SgPEpBQsBYTGK5mqEzAv/1Y
 0VRN2lA/46FfNThnJkh7x9AN8zpH47ecKyy+mFj9VUqHuUx5+/J2m5xVS0f+XOMVptxi
 chfsirJ1ODH9Cxl22bZ0AbVeDekocRpNMwcWQJ9ZUH319ZzooVQcCgYxQpDfYAnje6j4
 GxEJSUQooSnHGcJ8c6dFTnVfXPwrXpyhrrIkHuBxjgqHoTrxBA2VAW9tdqbPEeNLFe9I
 rBlmuatUVNZWdUVR5AYPScbTnHHornHwNXfyOkgbLsvX1Bz33oO3QN/jpQ6ImKPvh8Ek ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36p66r2jjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:29:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HEQ5Jc172023;
        Wed, 17 Feb 2021 14:28:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 36prpy6uwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:28:58 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 11HESp0I018684;
        Wed, 17 Feb 2021 14:28:51 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Feb 2021 06:28:50 -0800
Date:   Wed, 17 Feb 2021 17:28:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: icplus: Call phy_restore_page() when
 phy_select_page() fails
Message-ID: <20210217142838.GM2222@kadam>
References: <YCy1F5xKFJAaLBFw@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCy1F5xKFJAaLBFw@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 09:17:59AM +0300, Dan Carpenter wrote:
> Smatch warns that there is a locking issue in this function:
> 
> drivers/net/phy/icplus.c:273 ip101a_g_config_intr_pin()
> warn: inconsistent returns '&phydev->mdio.bus->mdio_lock'.
>   Locked on  : 242
>   Unlocked on: 273
> 
> It turns out that the comments in phy_select_page() say we have to call
> phy_restore_page() even if the call to phy_select_page() fails.
> 
> Fixes: f9bc51e6cce2 ("net: phy: icplus: fix paged register access")

Don't apply this patch.  I have created a new Smatch warning for the
phy_select_page() behavior and it catches a couple similar bugs in the
same file.  I will send a v2 that fixes those as well.

regards,
dan carpenter

