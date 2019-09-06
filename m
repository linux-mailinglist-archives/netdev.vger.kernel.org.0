Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB903ABA52
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394047AbfIFOJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:09:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730909AbfIFOJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 10:09:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86E8RBS009220;
        Fri, 6 Sep 2019 14:08:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9IqTqd9WWe4EMEVRfD9iiDMP5W+mzRr0rbM19ouvz7E=;
 b=ky3KgQoIHi+0y5SmSaheovaRBxBdhXKRyLNIkECjU3A0q8Gd7bi5aPMsDpl4f9kpwip5
 qlUk+Uqd3Suv82vY/QvD1mSHRIzVwrfg2rBHkXh7W+iEGxtlqw5I97PX3P+mwVWlZMxK
 Nsz9pEwvh87aYqmetRDLKz/RxZ4krlY6YTiatule9IhZUaP/NDhdm+5EbLDewa3cPVdJ
 RuIhj51Ik6Bclt3sdLo6Bbr45Kk0aiNoPPLR9jVt/Kvk/rd8JqPlJVqy/HYTY2bDJNu4
 0mdJKe3F9EVrqpPmbuiLPhuEG6TDRRREOiAENzrfd/Bb7kzSP3LLZK1H9ddiPzFZwV+f Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uurqk038x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 14:08:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86E3wBd185766;
        Fri, 6 Sep 2019 14:08:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uud7pjd94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 14:08:47 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x86E8jJZ009758;
        Fri, 6 Sep 2019 14:08:45 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 07:08:44 -0700
Date:   Fri, 6 Sep 2019 17:08:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Dan Elkouby <streetwalkermc@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: hidp: Fix error checks in
 hidp_get/set_raw_report
Message-ID: <20190906140744.GC14147@kadam>
References: <20190906094158.8854-1-streetwalkermc@gmail.com>
 <440C3662-1870-44D8-B4E3-C290CE154F1E@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <440C3662-1870-44D8-B4E3-C290CE154F1E@holtmann.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 03:56:29PM +0200, Marcel Holtmann wrote:
> Hi Dan,
> 
> > Commit 48d9cc9d85dd ("Bluetooth: hidp: Let hidp_send_message return
> > number of queued bytes") changed hidp_send_message to return non-zero
> > values on success, which some other bits did not expect. This caused
> > spurious errors to be propagated through the stack, breaking some (all?)
> > drivers, such as hid-sony for the Dualshock 4 in Bluetooth mode.
> > 
> > Signed-off-by: Dan Elkouby <streetwalkermc@gmail.com>
> > ---
> > net/bluetooth/hidp/core.c | 4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> patch has been applied to bluetooth-next tree.
> 

The v2 added an additional fix and used the Fixes tag.  Could you apply
that instead?

regards,
dan carpenter

