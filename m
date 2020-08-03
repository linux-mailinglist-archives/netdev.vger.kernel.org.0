Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C053423A1D1
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 11:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHCJgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 05:36:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36112 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgHCJgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 05:36:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0739H7gc054959;
        Mon, 3 Aug 2020 09:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IM7JPKhzENSyYGDL/C7fWaTdj+MTBkjqO/862CoRfz8=;
 b=IdhZIY/VQCGYYE4ZcaOwrsrMvJ26+J6VKhPX2OIwmRbnNwsfcQrAbj5M5SS8Ge82UApy
 bnRo4Qxk5O/vAbO2DEOYpdI6EujgzX9f+zAPVG5EKTXzqaT7VxZOXOgDnLSp0eqtwcYT
 N5xe7zq5KQNYdwXv0D024Zyq/2jDiCP732JoU90stmHNtCP6gIbg6znBT5w54izyJufW
 Q77/QCZdnSwSxo49Uv3kj32dHtEjY/eO8WzGo5QhEmr0/CyYwd5AVzXDOM1AoJSXVOgO
 MGgIykhTYK3BiwFicoWZdS4A6HfVXNTYrFEP45DqkMIEZMR7eDyzXgzHGLxAHO1GzRRF wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32pdnq0rpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Aug 2020 09:36:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0739X3aW020788;
        Mon, 3 Aug 2020 09:34:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 32p5gqgpfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Aug 2020 09:34:29 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0739YSQk023748;
        Mon, 3 Aug 2020 09:34:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32p5gqgpfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Aug 2020 09:34:28 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0739YOdY020620;
        Mon, 3 Aug 2020 09:34:24 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Aug 2020 02:34:23 -0700
Date:   Mon, 3 Aug 2020 12:34:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Leon Romanovsky <leon@kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200803093414.GL5493@kadam>
References: <20200731045301.GI75549@unreal>
 <20200731053306.GA466103@kroah.com>
 <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca>
 <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
 <20200731171924.GA2014207@kroah.com>
 <20200731182712.GI24045@ziepe.ca>
 <20200801080026.GJ5493@kadam>
 <20200801144030.GM24045@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801144030.GM24045@ziepe.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9701 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008030068
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ah, thanks.  We've had a bunch of discussions about these leaks but I
wasn't aware of this.

regards,
dan carpenter

