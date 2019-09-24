Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C736BC4B6
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504159AbfIXJV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:21:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50618 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395143AbfIXJV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 05:21:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O99SnS035989;
        Tue, 24 Sep 2019 09:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=nW1mVSUlRlC6Xi8gsIAQF8wGl9EcYhp7h0NTVYykaII=;
 b=RAOr5c46/XkgY1Gb6+Z0hGEZ7Qdn9/ORJv1Iu0Kp1LAB6sWW/11d8mBCnGPfFy8D7dBv
 7kHUTFLN4l56fnFXp6pHEPiWS3xyCAS3m2kj+8YG2w08BFPOb4L7WFxXqz9T6in6KXCA
 15vSU6H3w+3IuqU5HkVqFyIY6erdjRL7KH8Gu5G1xmi3CwoAM8SpsHC7IeTDQ4KkMyDB
 6TL3rvrK5bAtN9jszFbiRTZgOCP1wmk7QHzoOUKL95OheH/KZ8thFDvS8gIoOYiGNXGE
 oseEwdn6H1AoLK1CP7IiRnofzbuFOXaL7DcF5Jbw9ZYLDOYgYxCbfZFs8EkE5YCC9xIB EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgqvrar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 09:21:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O98rmr088004;
        Tue, 24 Sep 2019 09:21:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v6yvr9u85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 09:21:11 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8O9L8Ul024258;
        Tue, 24 Sep 2019 09:21:09 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Sep 2019 02:21:08 -0700
Date:   Tue, 24 Sep 2019 12:21:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Eli Cohen <eli@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
Message-ID: <20190924091823.GM20699@kadam>
References: <20190415094610.GO6095@kadam>
 <VI1PR0501MB22713CCB1141529CCB6934B1D12B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190416082112.GA27670@kadam>
 <AM4PR0501MB22609E4C9D126A096DD7F614D1240@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190420095102.GA14798@kadam>
 <VI1PR0501MB22713B232B3CF42B849F959BD1220@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190423154943.GC14820@kadam>
 <AM4PR0501MB2260ADC1DA37E87D01979969D1230@AM4PR0501MB2260.eurprd05.prod.outlook.com>
 <20190424140820.GB14798@kadam>
 <AM4PR0501MB2260DF0BBBC528A147F07E0DD13D0@AM4PR0501MB2260.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM4PR0501MB2260DF0BBBC528A147F07E0DD13D0@AM4PR0501MB2260.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240093
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 25, 2019 at 06:15:13AM +0000, Parav Pandit wrote:
> 
> 
> > -----Original Message-----
> > From: Dan Carpenter <dan.carpenter@oracle.com>
> > Sent: Wednesday, April 24, 2019 9:08 AM
> > To: Parav Pandit <parav@mellanox.com>; netdev@vger.kernel.org
> > Cc: Leon Romanovsky <leon@kernel.org>; Eli Cohen <eli@mellanox.com>;
> > Doug Ledford <dledford@redhat.com>; Jason Gunthorpe <jgg@ziepe.ca>;
> > linux-rdma@vger.kernel.org; kernel-janitors@vger.kernel.org
> > Subject: Re: [PATCH] IB/mlx5: add checking for "vf" from do_setvfinfo()
> > 
> > I think I'm just going to ask netdev for an opinion on this.  It could be that
> > we're just reading the code wrong...
> > 
> > I'm getting a lot of Smatch warning about buffer underflows.  The problem is
> > that Smatch marks everything from nla_data() as unknown and untrusted
> > user data.  In do_setvfinfo() we get the "->vf" values from nla_data().  It
> > starts as u32, but all the function pointers in net_device_ops use it as a
> > signed integer.  Most of the functions return -EINVAL if "vf" is negative but
> > there are at least 48 which potentially use negative values as an offset into
> > an array.
> > 
> > To me making "vf" a u32 throughout seems like a good idea but it's an
> > extensive patch and I'm not really able to test it at all.
> 
> I will be try to get you patch early next week for core and in mlx5,
> tested on mlx5 VFs, that possibly you can carry forward?

Whatever happened with this?

regards,
dan carpenter
