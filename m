Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264CE144B07
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 06:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgAVFMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 00:12:17 -0500
Received: from nwk-aaemail-lapp03.apple.com ([17.151.62.68]:52074 "EHLO
        nwk-aaemail-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgAVFMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 00:12:17 -0500
Received: from pps.filterd (nwk-aaemail-lapp03.apple.com [127.0.0.1])
        by nwk-aaemail-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0pxYO007363;
        Tue, 21 Jan 2020 16:56:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : mime-version :
 content-transfer-encoding; s=20180706;
 bh=Tj/Xh1ADokd8zXWuY0DZ17kaAHioi2FXe2cxOqYwu5k=;
 b=IJ9bCdFUG5fjtisjcMso36QYYKud5flTvHIGtcHEk/2XEMR3ToNksfeJqLpXA+6qFddW
 0GzXPPc2kY95q1QnqBca7h8VB/SEtDy5GNcMKEEiE8YqLABMnCYVMno+RdWL0E1vMZ93
 q8JCYk/ySZpQgth2sLSzjSnQ5DNNWHsv82QaO0yAV66FODE/5hFdULWRoSxyGoKn7F2w
 9oAxFaUC6ljJPk5nzX9odk4QIu/cpJXNOgZG+qytHdBeLK8PdldUhYsT1Af08F9V02Jq
 QdFzAN4wscKSEWK78XsB2rRQKpHzGuAjXmi9Hs///CYdOqodZgqeC+z2E0dGejYrr0kB Ew== 
Received: from ma1-mtap-s02.corp.apple.com (ma1-mtap-s02.corp.apple.com [17.40.76.6])
        by nwk-aaemail-lapp03.apple.com with ESMTP id 2xmk4p1659-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:56:46 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s02.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H0014CHALF030@ma1-mtap-s02.corp.apple.com>; Tue,
 21 Jan 2020 16:56:46 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00F00F5G4K00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:56:45 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: a90a569dc4155a44ea31a13ea0a8e519
X-Va-R-CD: 13c89f449697cb842941f5e30f66b620
X-Va-CD: 0
X-Va-ID: 9581b6bc-d855-4e1a-a28e-99762a3ac834
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: a90a569dc4155a44ea31a13ea0a8e519
X-V-R-CD: 13c89f449697cb842941f5e30f66b620
X-V-CD: 0
X-V-ID: 1f63ec3c-a4c1-430a-8388-f160ac83eccb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H00DNAHAIDC30@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:56:42 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org
Subject: [PATCH net-next v3 00/19] Multipath TCP part 2: Single subflow &
 RFC8684 support
Date:   Tue, 21 Jan 2020 16:56:14 -0800
Message-id: <20200122005633.21229-1-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2 -> v3: Added RFC8684-style handshake (see below fore more details) and some minor fixes
v1 -> v2: Rebased on latest "Multipath TCP: Prerequisites" v3 series

This set adds MPTCP connection establishment, writing & reading MPTCP
options on data packets, a sysctl to allow MPTCP per-namespace, and self
tests. This is sufficient to establish and maintain a connection with a
MPTCP peer, but will not yet allow or initiate establishment of
additional MPTCP subflows.

We also add the necessary code for the RFC8684-style handshake.
RFC8684 obsoletes the experimental RFC6824 and makes MPTCP move-on to
version 1.

Originally our plan was to submit single-subflow and RFC8684 support in
two patchsets, but to simplify the merging-process and ensure that a coherent
MPTCP-version lands in Linux we decided to merge the two sets into a single
one.

The MPTCP patchset exclusively supports RFC 8684. Although all MPTCP
deployments are currently based on RFC 6824, future deployments will be
migrating to MPTCP version 1. 3GPP's 5G standardization also solely supports
RFC 8684. In addition, we believe that this initial submission of MPTCP will be
cleaner by solely supporting RFC 8684. If later on support for the old
MPTCP-version is required it can always be added in the future.

The major difference between RFC 8684 and RFC 6824 is that it has a better
support for servers using TCP SYN-cookies by reliably retransmitting the
MP_CAPABLE option.

Before ending this cover letter with some refs, it is worth mentioning
that we promise David Miller that merging this series will be rewarded by
Twitter dopamine hits :-D

Clone/fetch:
https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-v3-part2)

Browse:
https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-v3-part2

Thank you for your review. You can find us at mptcp@lists.01.org and
https://is.gd/mptcp_upstream


Christoph Paasch (2):
  mptcp: parse and emit MP_CAPABLE option according to v1 spec
  mptcp: process MP_CAPABLE data option

Florian Westphal (2):
  mptcp: add subflow write space signalling and mptcp_poll
  mptcp: add basic kselftest for mptcp

Mat Martineau (3):
  mptcp: Add MPTCP socket stubs
  mptcp: Write MPTCP DSS headers to outgoing data packets
  mptcp: Implement MPTCP receive path

Matthieu Baerts (1):
  mptcp: new sysctl to control the activation per NS

Paolo Abeni (4):
  mptcp: recvmsg() can drain data from multiple subflows
  mptcp: allow collapsing consecutive sendpages on the same substream
  mptcp: move from sha1 (v0) to sha256 (v1)
  mptcp: cope with later TCP fallback

Peter Krystad (7):
  mptcp: Handle MPTCP TCP options
  mptcp: Associate MPTCP context with TCP socket
  mptcp: Handle MP_CAPABLE options for outgoing connections
  mptcp: Create SUBFLOW socket for incoming connections
  mptcp: Add key generation and token tree
  mptcp: Add shutdown() socket operation
  mptcp: Add setsockopt()/getsockopt() socket operations

 MAINTAINERS                                   |    2 +
 include/linux/tcp.h                           |   35 +
 include/net/mptcp.h                           |  105 +-
 net/Kconfig                                   |    1 +
 net/Makefile                                  |    1 +
 net/ipv4/tcp.c                                |    2 +
 net/ipv4/tcp_input.c                          |   19 +-
 net/ipv4/tcp_output.c                         |   57 +
 net/ipv6/tcp_ipv6.c                           |   13 +
 net/mptcp/Kconfig                             |   26 +
 net/mptcp/Makefile                            |    4 +
 net/mptcp/crypto.c                            |  152 ++
 net/mptcp/ctrl.c                              |  130 ++
 net/mptcp/options.c                           |  586 ++++++++
 net/mptcp/protocol.c                          | 1244 +++++++++++++++++
 net/mptcp/protocol.h                          |  240 ++++
 net/mptcp/subflow.c                           |  860 ++++++++++++
 net/mptcp/token.c                             |  195 +++
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/net/mptcp/.gitignore  |    2 +
 tools/testing/selftests/net/mptcp/Makefile    |   13 +
 tools/testing/selftests/net/mptcp/config      |    4 +
 .../selftests/net/mptcp/mptcp_connect.c       |  832 +++++++++++
 .../selftests/net/mptcp/mptcp_connect.sh      |  595 ++++++++
 tools/testing/selftests/net/mptcp/settings    |    1 +
 25 files changed, 5118 insertions(+), 2 deletions(-)
 create mode 100644 net/mptcp/Kconfig
 create mode 100644 net/mptcp/Makefile
 create mode 100644 net/mptcp/crypto.c
 create mode 100644 net/mptcp/ctrl.c
 create mode 100644 net/mptcp/options.c
 create mode 100644 net/mptcp/protocol.c
 create mode 100644 net/mptcp/protocol.h
 create mode 100644 net/mptcp/subflow.c
 create mode 100644 net/mptcp/token.c
 create mode 100644 tools/testing/selftests/net/mptcp/.gitignore
 create mode 100644 tools/testing/selftests/net/mptcp/Makefile
 create mode 100644 tools/testing/selftests/net/mptcp/config
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_connect.c
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect.sh
 create mode 100644 tools/testing/selftests/net/mptcp/settings

-- 
2.23.0

