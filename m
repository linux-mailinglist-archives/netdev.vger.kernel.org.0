Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348BF2930C8
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgJSVth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:49:37 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34672 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729436AbgJSVth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 17:49:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JLmpdF142816;
        Mon, 19 Oct 2020 21:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=lEQcBtvpcSltUtV8NmOf13rDzwSuBl2unCZJLIVntIg=;
 b=xfxRtzxfTUz+LrApXWmG/zsMn+hzCEWCWbHiVRYjXFhBzkz+a8iFdbAaNOuOrVkWHBnQ
 PJDCTQpLpDZCtguoct2OGsyZzK9g1nJWU5v8MVkV00N+wy+NneNGT899WM6ALa1tEgqS
 ogw3C/qFbkqFfaloF7ruuhZ4m96EXabeHVE48lQB5UFjABs6YEZ43LZcTnNEQy2PlTkU
 DRFZwgCSkJ2wEmyG21z3gwpqSHf1d3EJPZ1xo+1dwV6et9zoOoYfTTJnNHVNWE7OUOAe
 kNz/MKd185i75rHMzFALgD2kbdxfAhGCWPLIhnx69tkvjAXIihTZjhdr65w24XTPGJaM QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 347p4ar22h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 21:49:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JLnZkj021516;
        Mon, 19 Oct 2020 21:49:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 348agwn4xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 21:49:35 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09JLnTH8007288;
        Mon, 19 Oct 2020 21:49:29 GMT
Received: from mbpatil.us.oracle.com (/10.211.44.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 14:49:28 -0700
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rama.nichanamatlu@oracle.com, manjunath.b.patil@oracle.com
Subject: [PATCH 0/2] rds: MR(Memory Region) related patches 
Date:   Mon, 19 Oct 2020 14:48:06 -0700
Message-Id: <1603144088-8769-1-git-send-email-manjunath.b.patil@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=1 bulkscore=0 mlxlogscore=868
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=901 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset intends to add functionality to track MR usages by RDS
applications.

Manjunath Patil (2):
  rds: track memory region (MR) usage in kernel
  rds: add functionality to print MR related information

 include/uapi/linux/rds.h | 13 ++++++++++++-
 net/rds/af_rds.c         | 42 ++++++++++++++++++++++++++++++++++++++++
 net/rds/ib.c             |  1 +
 net/rds/rdma.c           | 29 ++++++++++++++++++++-------
 net/rds/rds.h            | 10 +++++++++-
 5 files changed, 86 insertions(+), 9 deletions(-)

-- 
2.27.0.112.g101b320

