Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0534C270E9
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfEVUlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:41:03 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:59452 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729528AbfEVUlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:41:02 -0400
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MKarq4016997;
        Wed, 22 May 2019 21:40:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=FmHMVBT0zKoYMfsU5AfjlU72gf0eepn7ZbKOb+8WUwY=;
 b=grNoqAijnwY3rgnVIWXyXx07KOgayr0lLPchM9bqlB2rQV/ZOwK0siRtVXMNgwdHT2T2
 kSEl355vxT8HNpE2tp2fVIuSvz9Rdp/lgG6Ir9te+OWy0DZeNB3zVMkw5ialVbD/6IRL
 EHAeAI4qsVWVp7fkup3vlCduzvJy/fXg7KiGgZvcJOQbklZsY1DS1vl3nU7spG2JY0KJ
 lumagt86sUnLFQXwO/F5GxevZIRFZv6rExM/VJD4EaTWYqBwQE17LVQBKPLYe88QR3zM
 LgLd4KEI+mmo/tIis3c/wA8WBK+uIA8KGCGefFjS9BTY0jUTb+LKIZ5udYK945HEkyCX SQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2sn8r5170v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 21:40:57 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4MKX5o4011403;
        Wed, 22 May 2019 16:40:56 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2sjdcvsjuf-1;
        Wed, 22 May 2019 16:40:55 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id EE8161FC6C;
        Wed, 22 May 2019 20:40:25 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     ycheng@google.com, ilubashe@akamai.com, netdev@vger.kernel.org
Subject: [PATCH net-next 0/6] add TFO backup key
Date:   Wed, 22 May 2019 16:39:32 -0400
Message-Id: <cover.1558557001.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220144
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

Christoph Paasch (1):
  tcp: introduce __tcp_fastopen_cookie_gen_cipher()

Jason Baron (5):
  tcp: add backup TFO key infrastructure
  tcp: add support to TCP_FASTOPEN_KEY for optional backup key
  tcp: add support for optional TFO backup key to /proc/sys/net/ipv4/tcp_fastopen_key
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
 tools/testing/selftests/net/Makefile               |   3 +-
 .../selftests/net/tcp_fastopen_backup_key.c        | 336 +++++++++++++++++++++
 .../selftests/net/tcp_fastopen_backup_key.sh       |  55 ++++
 11 files changed, 694 insertions(+), 119 deletions(-)
 create mode 100644 tools/testing/selftests/net/tcp_fastopen_backup_key.c
 create mode 100644 tools/testing/selftests/net/tcp_fastopen_backup_key.sh

-- 
2.7.4

