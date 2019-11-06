Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69C2F1896
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfKFO0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:26:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfKFO0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:26:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6EOR07171013;
        Wed, 6 Nov 2019 14:25:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=7Ndo0FoaiRNkVm4ytOUV1hWgxQHQQZogflwm7+Jib/w=;
 b=JuA+gca34A4p27QBUtog8bGD/V0gw0mmipCfLsucGGaCymrz2StHWblo5eBZkCwtQihi
 x4lznHQBZrsHb2WKpYlSWGZA2uj69TlLMpopYenq71Obmslf8ODEG7G5+kRHBPH/9lzd
 pzRYcS6Vl5FZJ30TvYVdu5mF59oec0BVUJYAI2WwtDgTA3IKGhpl6QIR6temZxkdJhvE
 N0V+S2hKIOFSGOJPlWX6mpqwaxzuFpQu1Um+DHLW9tV+IHCWX33cLfs3RbZzD4TA1hLK
 331YQk/ONYRIuGh8kH5Cw/t7nAg5dR7/PVes9eQvyHcGOacgc+rLV1RAsMhhtI1v/BJ2 cA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w12ereh0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 14:25:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6ENQGF009280;
        Wed, 6 Nov 2019 14:25:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w3xc2psuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 14:25:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA6EPpwW028944;
        Wed, 6 Nov 2019 14:25:51 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 06:25:51 -0800
Date:   Wed, 6 Nov 2019 17:25:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vincent Cheng <vincent.cheng.xh@renesas.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH -next] ptp: Fix missing unlock on error in idtcm_probe()
Message-ID: <20191106142542.GK10409@kadam>
References: <20191106115308.112645-1-weiyongjun1@huawei.com>
 <20191106140228.GA28081@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106140228.GA28081@renesas.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The prefix should probably be "ptp: ptp_clockmatrix: Fix missing ..." or
something.  This is a problem when we don't set a prefix when the driver
is first merged and then the first person to send a fix has to guess
what the maintainers are going to want to use.

The only other patch to this driver is commit 3a6ba7dc7799 ("ptp: Add a
ptp clock driver for IDT ClockMatrix.") so it's impossible to know.

regards,
dan carpenter

