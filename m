Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483761AF1AA
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 17:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgDRPbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 11:31:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43046 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgDRPby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 11:31:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03IFSJ3b001645;
        Sat, 18 Apr 2020 15:31:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=8a+w9NGOzcwt8ZrjgWjkYPrl011hqP6PUDX4gumC2hE=;
 b=PsrDyBywc3kDlbGFShCPvH+jr1UdLgrRPClwqNA4VsGrj/zhKvETVImyP+RO1W/gvdig
 HSo26ThJAuNAA04y5o1RmN4N9f0GCVsQt+V8ytTws1Zzau3v1UhKfKbZNwiKzEVnaMXP
 2wkA2a66FoqVhhFNsW+2T4OcFtjMoNEZqnpjPbrsrs6DrM57E1TBjAIuoiSGL4wtroj8
 cd1OWgFMA3aZ3xBqhO0qqLOGChq5XzHYdrGHCRzr/FYXuNDaEYK3gUplVpP+zYG//oi7
 By7hPrXwIw9DP2He6CZWHqgC1IPrqB0WRzTNZqP4fdkXhNkq9qhiwUP0vTVJMBGVhY+s lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30ft6ms90u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Apr 2020 15:31:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03IFSFjV075944;
        Sat, 18 Apr 2020 15:31:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 30fvfce7fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 18 Apr 2020 15:31:17 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03IFVHFh081015;
        Sat, 18 Apr 2020 15:31:17 GMT
Received: from control-surface.uk.oracle.com (dhcp-10-175-171-153.vpn.oracle.com [10.175.171.153])
        by aserp3020.oracle.com with ESMTP id 30fvfce7e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 18 Apr 2020 15:31:17 +0000
Received: from control-surface.uk.oracle.com (localhost [127.0.0.1])
        by control-surface.uk.oracle.com (8.15.2/8.15.2) with ESMTPS id 03IFVE0Y019967
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sat, 18 Apr 2020 16:31:14 +0100
Received: (from jch@localhost)
        by control-surface.uk.oracle.com (8.15.2/8.15.2/Submit) id 03IFVCJF019966;
        Sat, 18 Apr 2020 16:31:12 +0100
X-Authentication-Warning: control-surface.uk.oracle.com: jch set sender to john.haxby@oracle.com using -f
From:   John Haxby <john.haxby@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     John Haxby <john.haxby@oracle.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ipv6: fix restrict IPV6_ADDRFORM operation
Date:   Sat, 18 Apr 2020 16:30:48 +0100
Message-Id: <cover.1587221721.git.john.haxby@oracle.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9595 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 mlxlogscore=846 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004180130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation") added a
check to ensure that sk->sk_prot is the default pointer for a TCP IPv6
socket, an issue found by syzbot.

The earlier code simply had

    if (sk->sk_protocol != IPPROTO_TCP)
       break;

and the new code degenerated to

    if (sk->sk_protocol == IPPROTO_TCP)
       break;

the very opposite of what was intended.  The following patch
rearranges the checks so that the original sk->sk_prot == &tcpv6_prot
is just one of the series of checks made before moving the socket.

jch

John Haxby (1):
  ipv6: fix restrict IPV6_ADDRFORM operation

 net/ipv6/ipv6_sockglue.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

-- 
2.25.3

