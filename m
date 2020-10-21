Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1665929526D
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504400AbgJUSuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:50:08 -0400
Received: from smtp.uniroma2.it ([160.80.6.22]:47171 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394632AbgJUSuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 14:50:07 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2020 14:50:06 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 09LIga9f005673
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Oct 2020 20:42:37 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [RFC,net-next, 0/4] seg6: add support for SRv6 End.DT4 behavior
Date:   Wed, 21 Oct 2020 20:41:12 +0200
Message-Id: <20201021184116.2722-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for the SRv6 End.DT4 behavior.

The SRv6 End.DT4 is used to implement multi-tenant IPv4 L3VPN. It decapsulates
the received packets and performs IPv4 routing lookup in the routing table of
the tenant. The SRv6 End.DT4 Linux implementation leverages a VRF device. SRv6
End.DT4 is defined in the SRv6 Network Programming [1].

- Patch 1/4 is needed to solve a pre-existing issue with tunneled packets
  when a sniffer is attached;

- Patch 2/4 introduces two callbacks used for customizing the
  creation/destruction of a SRv6 behavior;

- Patch 3/4 is the core patch that adds support for the SRv6 End.DT4 behavior;

- Patch 4/4 adds the selftest for SRv6 End.DT4.

I would like to thank David Ahern for his support during the development of
this patch set.

Comments, suggestions and improvements are very welcome!

Thanks,
Andrea Mayer

[1] https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming

Andrea Mayer (4):
  vrf: push mac header for tunneled packets when sniffer is attached
  seg6: add callbacks for customizing the creation/destruction of a
    behavior
  seg6: add support for the SRv6 End.DT4 behavior
  add selftest for the SRv6 End.DT4 behavior

 drivers/net/vrf.c                             |  78 ++-
 net/ipv6/seg6_local.c                         | 261 ++++++++++
 .../selftests/net/srv6_end_dt4_l3vpn_test.sh  | 490 ++++++++++++++++++
 3 files changed, 823 insertions(+), 6 deletions(-)
 create mode 100755 tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh

-- 
2.20.1

