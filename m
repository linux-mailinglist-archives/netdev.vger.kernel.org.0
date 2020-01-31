Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2944A14E985
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 09:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgAaIZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 03:25:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbgAaIZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 03:25:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V8NIiR125627;
        Fri, 31 Jan 2020 08:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9HJDg4ebV+36JCqgzBLlPd7SgnrdxJDhGJ/uJ+JFH5w=;
 b=g4IJM3qs4GwjlL9VCYQgNkQp2YhlDOd+SEZceV9za8UGvo9EhsNs5FvkHCaCFT+gea+l
 WA82aQYc5m5DZk/p7J9LBevmYm6HI+mF0sW4WMlnYCk7um1wisMTJpAPmlCNXi5Ve3F4
 EH3V3yG6Po9VVIyLg0NRjN+1Ih8zYFhD7EGqXlszWrLf3saKZ9cFpeMDHqn6OFoGWaaU
 2ma2AvsVhNaQJCS1FK5UGjZFzzCrjPH65HGS3pml7oucbHx+9YVVdhxr1gREHrHKo/Co
 lPDLF+YvKZdL+64fX9RNt9+dNhWbU9lqVjJEAalWqnEQL6p/oVcMwxw9P+wqxh8pnabm aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xrearrppq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 08:25:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V8NFU0123097;
        Fri, 31 Jan 2020 08:25:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xva6q2yh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 08:25:24 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00V8PLea003983;
        Fri, 31 Jan 2020 08:25:21 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 31 Jan 2020 00:25:20 -0800
Date:   Fri, 31 Jan 2020 11:24:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ajay Gupta <ajayg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] device property: change device_get_phy_mode() to
 prevent signedess bugs
Message-ID: <20200131082451.GD11068@kadam>
References: <20200131045953.wbj66jkvijnmf5s2@kili.mountain>
 <CAHp75Vc7eudHy=05nHKB2==QJM1f23E1jZw=7yFKHA1nq0qBqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vc7eudHy=05nHKB2==QJM1f23E1jZw=7yFKHA1nq0qBqA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001310074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001310074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 10:15:14AM +0200, Andy Shevchenko wrote:
> On Fri, Jan 31, 2020 at 7:03 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > The device_get_phy_mode() was returning negative error codes on
> > failure and positive phy_interface_t values on success.  The problem is
> > that the phy_interface_t type is an enum which GCC treats as unsigned.
> > This lead to recurring signedness bugs where we check "if (phy_mode < 0)"
> > and "phy_mode" is unsigned.
> >
> > In the commit 0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve
> > int/unit warnings") we updated of_get_phy_mode() take a pointer to
> > phy_mode and only return zero on success and negatives on failure.  This
> > patch does the same thing for device_get_phy_mode().  Plus it's just
> > nice for the API to be the same in both places.
> 
> 
> > +       err = device_get_phy_mode(dev, &config->phy_interface);
> 
> > +       if (err)
> > +               config->phy_interface = PHY_INTERFACE_MODE_NA;
> 
> Do you need these? It seems the default settings when error appears.
> 

We don't need it, but I thought it made things more readable.

regards,
dan carpenter

