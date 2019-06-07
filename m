Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E57AD38F0B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbfFGPaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:30:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53232 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfFGPaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 11:30:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57FIvwc065415;
        Fri, 7 Jun 2019 15:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=HgNb4Eaeuh7hnkrkenJhDs2+BF4CbcxcUHAitZN3w/I=;
 b=2aE2myt9lxKrtAWQGQsrJSdJRybCJGmGQQpC3R6uE7I8ZZum7De8N6VtaySosY1snnA/
 MBxV5e47d9h2bFAjtpafF8+7qYvaXr4KnlOFWSzSiPAyU687shnKjlO9OBGT1SqpCk6G
 AwarIQ9FfMhQt605ozjEKcN5OiVoNZZStNjOtjruknuaNywDk0QzLtFNuu4A+5fXFVd0
 l/DqrAe23r19ERMdSh3oQ2EINncL9/3zYWmTk8Me7i6K9h8FhPTuhhSz7CZbk5ARr1VV
 k78TUgPIE70HeUuXiYk1skuy1gVxetMnhbc01jDTB/7tP6Cm4mp0DyBE26dAnJ/gWLsq 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2sugstxxup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 15:30:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57FT8rU180546;
        Fri, 7 Jun 2019 15:29:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2swngn4uf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 15:29:59 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x57FTwUe005099;
        Fri, 7 Jun 2019 15:29:58 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 08:29:57 -0700
Date:   Fri, 7 Jun 2019 18:29:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next] nexthop: off by one in nexthop_mpath_select()
Message-ID: <20190607152951.GR31203@kadam>
References: <20190607135636.GB16718@mwanda>
 <0e02a744-f28e-e206-032b-a0ffac9f7311@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e02a744-f28e-e206-032b-a0ffac9f7311@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=750
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=800 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 08:54:33AM -0600, David Ahern wrote:
> On 6/7/19 7:56 AM, Dan Carpenter wrote:
> > The nhg->nh_entries[] array is allocated in nexthop_grp_alloc() and it
> > has nhg->num_nh elements so this check should be >= instead of >.
> > 
> > Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")
> 
> Wrong fixes. The helper was added by 430a049190de so it should be
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> 

Sorry, my eyes must have gone squiffy.  I don't even know how I got that
wrong.  Let me resend.

regards,
dan carpenter

