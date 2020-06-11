Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F6C1F6AE4
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 17:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgFKPWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 11:22:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35018 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbgFKPWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 11:22:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05BFGwIx189025;
        Thu, 11 Jun 2020 15:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=F+errMLdvgi4MHt8jCQq09ZX5AvpbDZ+cZ9ta5vO2pQ=;
 b=qQeRu8d9AseQvkn6mmiWlD6UFRviqGajGZpCB4mNg4zU8Yg0+3HgGizUcCZRBNQD4DS8
 p8w8LmzJdXtq6u9UUWQQYHcXXXLHhk8hqI9y6gLjjt8hqxWlT0eGEYhx71kgkHGu6wII
 bzUaU3VJ/Zh88Dkzg0+Nn5YMEyucRur96i524mcIawwORJ176PEbMaSMhH8MT+UtASSt
 WX6ptbjkL6WVwZeKOa4VK/oUtoUJepBkRu7UI7wTNDdi8K0ggQHHm4KlzwwrpnIczYGU
 9GBJOstKJZoXKJGRhdwAANFY7GseOg93bG+y9h6L28r1oXrVE0GU07nBVApJRaQcR5Cj 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31g3sn8cv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 11 Jun 2020 15:22:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05BFIXc3033187;
        Thu, 11 Jun 2020 15:22:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31gmwvhfn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jun 2020 15:22:14 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05BFMDHj017504;
        Thu, 11 Jun 2020 15:22:13 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jun 2020 08:22:13 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id EBBF46A0100; Thu, 11 Jun 2020 11:22:57 -0400 (EDT)
Date:   Thu, 11 Jun 2020 11:22:57 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, eperezma@redhat.com
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
Message-ID: <20200611152257.GA1798@char.us.oracle.com>
References: <20200611113404.17810-1-mst@redhat.com>
 <20200611113404.17810-3-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611113404.17810-3-mst@redhat.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9649 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=944 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006110121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9649 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=995 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006110121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 07:34:19AM -0400, Michael S. Tsirkin wrote:
> As testing shows no performance change, switch to that now.

What kind of testing? 100GiB? Low latency?

