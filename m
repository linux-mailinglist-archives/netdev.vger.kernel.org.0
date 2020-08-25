Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46BA25142C
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 10:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgHYI0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:26:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59030 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbgHYI0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 04:26:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07P8Nj5N094460;
        Tue, 25 Aug 2020 08:26:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PjJiapN6S66feKThBGgHeW3S/yTm+iArd2Yb3om4uTQ=;
 b=IWhxqaKEgAMvOc0eRh9Me6+srFa6pgVwAQBs+5tTjzsbBR1vUPFiNpwV9jyMBi7bG8j8
 Zi21mO8dnlXJXE8nWVW5GuPXKv801vByqFbVmyXi35epO2ycmxtP5AbRYLS9IPNxwlHj
 D7WRNPH/f1Cm1hSHQfichHYDN88oFyl6I5t3MrF1hcnJEOnVYtU2u0uoVj+40TWEbJK8
 6DEd9WQunod9uIU9jF/mU9/DXPHRdWZCyGvuGwFBW+ob1WtsCzEoeRC6SP1575H9FfOo
 ilPvR+Ie9Fw7l1rQ8aaDo+K9Z03TVv8WFyH+1StjR8OsFunQOoPchiQh5uhzzajEQoan qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 333dbrs038-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 08:26:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07P8KBIs022599;
        Tue, 25 Aug 2020 08:24:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 333ru6xhrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 08:24:45 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07P8Ohnj026831;
        Tue, 25 Aug 2020 08:24:44 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Aug 2020 01:24:43 -0700
Date:   Tue, 25 Aug 2020 11:24:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net: read dev->needs_free_netdev before potentially
 freeing dev
Message-ID: <20200825082437.GQ5493@kadam>
References: <20200824141519.GA223008@mwanda>
 <20200824200650.21982-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824200650.21982-1-Jason@zx2c4.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=2 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250064
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 10:06:50PM +0200, Jason A. Donenfeld wrote:
> If dev->needs_free_netdev is true, it means that netdev_run_todo should
> call free_netdev(dev) after it calls dev->priv_destructor. If
> dev->needs_free_netdev is false, then it means that either
> dev->priv_destructor is taking care of calling free_netdev(dev), or
> something else, elsewhere, is doing that. In this case, branching on
> "if (dev->needs_free_netdev)" after calling dev->priv_destructor is a
> potential UaF. This patch fixes the issue by reading
> dev->needs_free_netdev before calling dev->priv_destructor.
> 

No, I misread the code.  Sorry.  This patch is not required.  We can
use "dev" up to the end of the function where we do:

		/* Free network device */
		kobject_put(&dev->dev.kobj);

That's where the final reference is released.

regards,
dan carpenter

