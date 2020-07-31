Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE55B2343D7
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732508AbgGaKAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:00:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732292AbgGaKAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 06:00:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06V9qw7Y015363;
        Fri, 31 Jul 2020 09:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=S9ve+QX3l80OyB6k9hGZRrisazhkSN61TPadeW92FAU=;
 b=SEgYugyqhNyevsmB58/8dBw3UeEQKZZn4RGLKsfjMQGdB5w7poSmCCujgRo6lvNyP9J2
 N6BlFv+evhhJgcXclTknHVtdHLqu2VEzhibj9GRqcDmfmSWUU5JeXzJPjdvFhxsIdS6x
 yZafV/ElbdjOysvaMjddzIPbyQy0GMoe5f/bK4NU7pR16NFjs1rwbVCfbis9hw7X8DxM
 wUO1jUuRdpbAEygEA3aHk/8hJbl0gXbPOHvR9RcyJqWGscZW7v2M48lyVejaheVou/Qc
 2ZjlWBT4ZeCxpFJkDwOp9keWcdG7bQg6HQt0Ol0SuLZZ1nsF+0pY7zx0wV/+3hu0k1s/ WQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32hu1jr9sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jul 2020 09:59:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06V9wiXB043580;
        Fri, 31 Jul 2020 09:59:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 32mf706216-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jul 2020 09:59:58 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06V9xvtd046242;
        Fri, 31 Jul 2020 09:59:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32mf70620b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 09:59:57 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06V9xsLW005845;
        Fri, 31 Jul 2020 09:59:55 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 31 Jul 2020 02:59:54 -0700
Date:   Fri, 31 Jul 2020 12:59:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200731095943.GI5493@kadam>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731045301.GI75549@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007310073
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 07:53:01AM +0300, Leon Romanovsky wrote:
> On Thu, Jul 30, 2020 at 03:20:26PM -0400, Peilin Ye wrote:
> > rds_notify_queue_get() is potentially copying uninitialized kernel stack
> > memory to userspace since the compiler may leave a 4-byte hole at the end
> > of `cmsg`.
> >
> > In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`, which
> > unfortunately does not always initialize that 4-byte hole. Fix it by using
> > memset() instead.
> 
> Of course, this is the difference between "{ 0 }" and "{}" initializations.
> 

No, there is no difference.  Even struct assignments like:

	foo = *bar;

can leave struct holes uninitialized.  Depending on the compiler the
assignment can be implemented as a memset() or as a series of struct
member assignments.

regards,
dan carpenter

