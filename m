Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0191EF5C7
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 12:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgFEKwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 06:52:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52440 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgFEKwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 06:52:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055AqDkr143594;
        Fri, 5 Jun 2020 10:52:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TcLjO/5VIHquUf07QKX+TVc1IEAD3WCGP7IiHK1yH78=;
 b=kz4BzrY0xfgyLif/aSfMHiXxWbUBS0FlAYlPIhVDblQHAxV4HycDK0tRPIDAiNgkVpNK
 SHxcjwhPpdaIoqbqoUxHD+ocqOAgAKxDWaCMgIkeeAPl+d+McnHICGLzaav2oICe6YZj
 sEReDcSwjVLWTMDjXtv3G5dZTgJzmPhfH7UtKZhuciLxihnrewdy5TO3YwM4IXwOwYfm
 2iRrJKztkmt0MeBEAejqJpQMtbnOxiPaukl5KF1iqapkg/TFpaUF5YCR5HiRPU5qFlK4
 lPz6Tut0pv6KFUneAtaqCb48g0AwiQTKIQHZmdBIWgz6WvfSpARCD8+Zp+XGCKiUG1Pi tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31f924296p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 10:52:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055Am7Qq105927;
        Fri, 5 Jun 2020 10:52:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31f9274y4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 10:52:12 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 055AqB14024050;
        Fri, 5 Jun 2020 10:52:11 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 03:52:10 -0700
Date:   Fri, 5 Jun 2020 13:52:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: E-Switch, Fix some error pointer dereferences
Message-ID: <20200605105203.GK22511@kadam>
References: <20200603175436.GD18931@mwanda>
 <20200604103255.GA8834@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604103255.GA8834@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=969 bulkscore=0
 suspectscore=0 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 bulkscore=0
 lowpriorityscore=0 cotscore=-2147483648 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 01:32:55PM +0300, Leon Romanovsky wrote:
> + netdev
> 

This is sort of useless.  What's netdev going to do with a patch they
can't apply?  I assumed that mellanox was going to take this through
their tree...

Should I resend the other mlx5 patch as well?

regards,
dan carpenter

