Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012951F1A19
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 15:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgFHNbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 09:31:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33872 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729626AbgFHNbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 09:31:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058DMlaq117919;
        Mon, 8 Jun 2020 13:31:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=WApRWoMVwB7b4JqgMLtVk9V8sp+TjxqHynjtFi+O36c=;
 b=0WSKx4oD0khsSOKkIqj3RidE8CJi0nqzN7ex7hdd1HZi3Plg6cYaSuXA0JNpYiyS1Ny8
 WNXg9uVrluCmyEs8ch58pTHfPddIl6Qn0LpS442+dk4vMyNZ637qX4IpHiICbfLsWmVY
 laYHH3T5SaKT4nlhQZWFMnXva92ww2ZfpD8htcamU0WyDL8G1UEsiujy6lXZDYMqvjbe
 7I2OmvhqiZDA6GBxe+CJZl5FwTXxtep/Hzh/fz/VPz57NvECBKnN27uibcL9+M2ZY+73
 dLjojpHUOWLI6ZhyYgH/Mcy6ATv24+cl13RQLB88IbY6waY1stNlmO//SoQJ0ZCEOLGF FA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31g33kxw4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 13:31:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058DNmEZ108462;
        Mon, 8 Jun 2020 13:31:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31gmqm7qjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 13:31:20 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 058DVJIc017866;
        Mon, 8 Jun 2020 13:31:19 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 06:31:15 -0700
Date:   Mon, 8 Jun 2020 16:31:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: E-Switch, Fix some error pointer dereferences
Message-ID: <20200608133109.GQ22511@kadam>
References: <20200603175436.GD18931@mwanda>
 <20200604103255.GA8834@unreal>
 <20200605105203.GK22511@kadam>
 <20200607062555.GC164174@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607062555.GC164174@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=921 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=949
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 07, 2020 at 09:25:55AM +0300, Leon Romanovsky wrote:
> On Fri, Jun 05, 2020 at 01:52:03PM +0300, Dan Carpenter wrote:
> > On Thu, Jun 04, 2020 at 01:32:55PM +0300, Leon Romanovsky wrote:
> > > + netdev
> > >
> >
> > This is sort of useless.  What's netdev going to do with a patch they
> > can't apply?  I assumed that mellanox was going to take this through
> > their tree...
> 
> Right, but it will be picked by Saeed who will send it to netdev later
> as PR. CCing netdev saves extra review at that stage.

Okay.  I will try to remember this in the future.  I'll try put
[PATCH mlx5-next] in the subject even when it applies to the net tree.

regards,
dan carpenter

