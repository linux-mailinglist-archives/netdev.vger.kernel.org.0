Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB32730E0E
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfEaMZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:25:06 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41490 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfEaMZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 08:25:05 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4VCIk32008456
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 12:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=tHa0eODiR6s3LRReKTl9qasdtQnNZgp6o910SqPuky4=;
 b=ocAz3LybUfSXiOJ7NM8HZtb92cGc5h0IbAefE63VRMxaEBjPQUxQCSDWtRFbc7NZAaVY
 e8WRh/g9vRejQAlvTotLJGYoc2VqkUUHPy6dhj4Lm0qFt69ydvT+xKz7/BACmHQw7sq7
 sVpG/Gmn1dK+t7IQAFs44+rp5AWdvKwdrsZPBY2llPMbhyCp7ujkoXKrAJIrJZHeRav5
 ZUILnx6oEt/xW+G3xzZ6cZtjjHRy5CtBhLqOh+7EHCFEu5NZ99sAHzjeeTGbczQ4U/w8
 4zxy2Qcnoa9fuWDR1VCcA5YPQvHenraifCwfTamCIJife7vPO00gCQu1iz8b8wjGkmqG vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2spu7dx530-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 12:25:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4VCO1F8144767
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 12:25:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2su3y489yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 12:25:02 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4VCP1tv002827
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 12:25:01 GMT
Received: from dhcp-10-175-206-186.vpn.oracle.com (/10.175.206.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 31 May 2019 05:25:01 -0700
Date:   Fri, 31 May 2019 13:24:54 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-206-186.vpn.oracle.com
To:     netdev@vger.kernel.org
Subject: support for popping multiple MPLS labels with iproute2?
Message-ID: <alpine.LRH.2.20.1905311313080.9247@dhcp-10-175-206-186.vpn.oracle.com>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9273 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=976
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905310079
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9273 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905310079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was wondering if there is a way to pop multiple MPLS labels at
once for local delivery using iproute2?

Adding multiple labels for encapsulation is supported via
label1/label2/... syntax, but I can't find a way to do the same
for popping multiple labels for local delivery.

For example if I run

# ip route add 192.168.1.0/24 encap mpls 100/200 via inet 192.168.1.101 \
   dev mytun mtu 1450

...I'm looking for the equivalent command to pop both labels on the
target system for local delivery; something like

# ip -f mpls route add 100/200 dev lo

...but that gets rejected as only a single label is expected.

Thanks!

Alan
