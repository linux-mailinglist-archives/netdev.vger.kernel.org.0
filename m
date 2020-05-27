Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6505C1E500D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbgE0VS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgE0VS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:18:58 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D79CC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:18:58 -0700 (PDT)
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04RKTBBK028325;
        Wed, 27 May 2020 21:30:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=Jp1odPUnHVMIifCJnHgqnNOFnJ9HPnsIKTs8DyuRooQ=;
 b=h0Z06EIyexp2NbRGBc/pEBrQAM0CXYZ0CSO3iSyVbiYajsCccNkeHAr+pz2lMMxHWiH+
 L6PDC1WeeQUXN66Py78s0V6j7oCDffdXP/2BpDMz9ZCSH2jFtSWJg2iUkH2ZLwB9OGb+
 254eQlyd1Iu/6IG1s+QtViGikOTb8Lak0rebfm+Mj0rM4pBBIZUhPjsM/thU5NcEzw67
 5nh2ud2BRk4fhB4Itoj5sqSMveziizoRRJH+zpuD+4krVNphtx+DJvnMK2wjIyPHkgLO
 Tg+noLYFYfOmHtEAstbD8vuW18BqUQ5RcxQ4wzXrLEkCmkafkga3PnmYcrIhH6anS+W3 Xw== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 316ug52h5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 21:30:24 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 04RK2Igm019712;
        Wed, 27 May 2020 16:30:23 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint3.akamai.com with ESMTP id 319uwvha22-1;
        Wed, 27 May 2020 16:30:23 -0400
Received: from bos-lpjec.145bw.corp.akamai.com (bos-lpjec.145bw.corp.akamai.com [172.28.3.71])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id 4FBE86017F;
        Wed, 27 May 2020 20:30:23 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: [net-next 0/2] net: sched: cls-flower: add support for port-based fragment filtering
Date:   Wed, 27 May 2020 16:25:28 -0400
Message-Id: <1590611130-19146-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-27,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=989
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2004280000 definitions=main-2005270153
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-27,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1
 cotscore=-2147483648 mlxscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 mlxlogscore=939 priorityscore=1501 malwarescore=0
 clxscore=1011 bulkscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port based allow rules must currently allow all fragments since the
port number is not included in the 1rst fragment. We want to restrict
allowing all fragments by inclucding the port number in the 1rst
fragments.

For example, we can now allow fragments for only port 80 via:

# tc filter add dev $DEVICE parent ffff: priority 1 protocol ipv4 flower
  ip_proto tcp dst_port 80 action pass
# tc filter add dev $DEVICE parent ffff: priority 2 protocol ipv4 flower
  ip_flags frag/nofirstfrag action pass

The first patch includes ports for 1rst fragments.
The second patch adds test cases, demonstrating the new behavior.

Jason Baron (2):
  net: sched: cls-flower: include ports in 1rst fragment
  selftests: tc_flower: add destination port tests

 net/core/flow_dissector.c                          |  4 +-
 net/sched/cls_flower.c                             |  3 +-
 .../testing/selftests/net/forwarding/tc_flower.sh  | 73 +++++++++++++++++++++-
 3 files changed, 77 insertions(+), 3 deletions(-)

-- 
2.7.4

