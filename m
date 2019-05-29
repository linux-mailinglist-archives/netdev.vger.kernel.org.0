Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C873B2E253
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfE2QfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:35:14 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:55626 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbfE2QfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:35:13 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4TGW2Ik023137;
        Wed, 29 May 2019 17:35:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=7n599icGFggz65auh1hR5qcFWccIP5bcaXRJgSFTfdc=;
 b=bXt6zPyIg34K+6sZ7A4Fvi6JWQwkPFeQB8Suvua4XPwNROGb+OmpGNcyw14sNTqGioQd
 RsplrRrJCLt16E7/K6392JZZHmcuyJDTHinNE1ffmjTEoPowfu5uP437eXeQkMvIDhAm
 mniFDR549ImWkO3GEZP20XHiIuqji2v9gj2Ex2TLI/RVgn6m8WSUIwsloTxh3idV7pvz
 FWT/WetuNUb3CABcCJiaRCPU8fUHVwqu1dqJECqp8edWoXJtp2j30sD6rK5U62kJ4/iz
 4IIqC/3GXSQxz2JZ1FoVd9Rva8R+wD8QDqZ0Tlw4ioxYQSAxJt36Kwx2eF1N2VEH82cG 0w== 
Received: from prod-mail-ppoint3 (prod-mail-ppoint3.akamai.com [96.6.114.86] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2ss4sh4txs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 May 2019 17:35:07 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4TGW0N6028643;
        Wed, 29 May 2019 12:35:06 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint3.akamai.com with ESMTP id 2sq11ys515-1;
        Wed, 29 May 2019 12:35:06 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id EEE741FC6B;
        Wed, 29 May 2019 16:35:05 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com, ycheng@google.com
Cc:     cpaasch@apple.com, ilubashe@akamai.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/6] add TFO backup key
Date:   Wed, 29 May 2019 12:33:55 -0400
Message-Id: <cover.1559146812.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290108
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Christoph, Igor, and I have worked on an API that facilitates TFO key 
rotation. This is a follow up to the series that Christoph previously
posted, with an API that meets both of our use-cases. Here's a
link to the previous work:
https://patchwork.ozlabs.org/cover/1013753/

Thanks,

-Jason

Changes in v2:
  -spelling fixes in ip-sysctl.txt (Jeremy Sowden)
  -re-base to latest net-next

Christoph Paasch (1):
  tcp: introduce __tcp_fastopen_cookie_gen_cipher()

Jason Baron (5):
  tcp: add backup TFO key infrastructure
  tcp: add support to TCP_FASTOPEN_KEY for optional backup key
  tcp: add support for optional TFO backup key to
    net.ipv4.tcp_fastopen_key
  Documentation: ip-sysctl.txt: Document tcp_fastopen_key
  selftests/net: add TFO key rotation selftest

 Documentation/networking/ip-sysctl.txt             |  20 ++
 include/net/tcp.h                                  |  41 ++-
 include/uapi/linux/snmp.h                          |   1 +
 net/ipv4/proc.c                                    |   1 +
 net/ipv4/sysctl_net_ipv4.c                         |  93 ++++--
 net/ipv4/tcp.c                                     |  29 +-
 net/ipv4/tcp_fastopen.c                            | 233 +++++++++-----
 tools/testing/selftests/net/.gitignore             |   1 +
 tools/testing/selftests/net/Makefile               |   2 +
 .../selftests/net/tcp_fastopen_backup_key.c        | 336 +++++++++++++++++++++
 .../selftests/net/tcp_fastopen_backup_key.sh       |  55 ++++
 11 files changed, 694 insertions(+), 118 deletions(-)
 create mode 100644 tools/testing/selftests/net/tcp_fastopen_backup_key.c
 create mode 100755 tools/testing/selftests/net/tcp_fastopen_backup_key.sh

-- 
2.7.4

