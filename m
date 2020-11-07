Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E902E2AA653
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 16:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgKGPdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 10:33:44 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:51959 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgKGPdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 10:33:16 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0A7FW8qb010493
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 7 Nov 2020 16:32:09 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next,v2,0/5] seg6: add support for SRv6 End.DT4 behavior
Date:   Sat,  7 Nov 2020 16:31:34 +0100
Message-Id: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset provides support for the SRv6 End.DT4 behavior.

The SRv6 End.DT4 is used to implement multi-tenant IPv4 L3 VPN. It
decapsulates the received packets and performs IPv4 routing lookup in the
routing table of the tenant. The SRv6 End.DT4 Linux implementation
leverages a VRF device. The SRv6 End.DT4 is defined in the SRv6 Network
Programming [1].

- Patch 1/5 is needed to solve a pre-existing issue with tunneled packets
  when a sniffer is attached;

- Patch 2/5 improves the management of the seg6local attributes used by the
  SRv6 behaviors;

- Patch 3/5 introduces two callbacks used for customizing the
  creation/destruction of a SRv6 behavior;

- Patch 4/5 is the core patch that adds support for the SRv6 End.DT4
  behavior;

- Patch 5/5 adds the selftest for SRv6 End.DT4 behavior.

I would like to thank David Ahern for his support during the development of
this patch set.

Comments, suggestions and improvements are very welcome!

Thanks,
Andrea Mayer

v2
 no changes made: resubmitted after false build report.

v1
 improve comments;

 add new patch 2/5 titled: seg6: improve management of behavior attributes

 seg6: add support for the SRv6 End.DT4 behavior
  - remove the inline keyword in the definition of fib6_config_get_net().

 selftests: add selftest for the SRv6 End.DT4 behavior
  - add check for the vrf sysctl

[1] https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming

Andrea Mayer (5):
  vrf: add mac header for tunneled packets when sniffer is attached
  seg6: improve management of behavior attributes
  seg6: add callbacks for customizing the creation/destruction of a
    behavior
  seg6: add support for the SRv6 End.DT4 behavior
  selftests: add selftest for the SRv6 End.DT4 behavior

 drivers/net/vrf.c                             |  78 ++-
 net/ipv6/seg6_local.c                         | 370 ++++++++++++-
 .../selftests/net/srv6_end_dt4_l3vpn_test.sh  | 494 ++++++++++++++++++
 3 files changed, 927 insertions(+), 15 deletions(-)
 create mode 100755 tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh

-- 
2.20.1

