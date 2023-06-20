Return-Path: <netdev+bounces-12185-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B16F736963
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6985C1C20B86
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C041BA38;
	Tue, 20 Jun 2023 10:35:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0C3522C
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 10:35:19 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760EC19A
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:35:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 8AE20207CA;
	Tue, 20 Jun 2023 12:35:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id swGrN6FoL4wF; Tue, 20 Jun 2023 12:35:14 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id F39F5200AC;
	Tue, 20 Jun 2023 12:35:13 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id EB87E80004A;
	Tue, 20 Jun 2023 12:35:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 20 Jun 2023 12:35:13 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 20 Jun
 2023 12:35:13 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 50EDE3181712; Tue, 20 Jun 2023 12:35:13 +0200 (CEST)
From: Steffen Klassert <steffen.klassert@secunet.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Steffen Klassert
	<steffen.klassert@secunet.com>, <netdev@vger.kernel.org>
Subject: [PATCH 0/6] pull request (net): ipsec 2023-06-20
Date: Tue, 20 Jun 2023 12:34:24 +0200
Message-ID: <20230620103430.1975055-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

1) Treat already-verified secpath entries as optional
   to fix nested IPsec tunnels with xfrm interfaces.
   Fix from Benedict Wong.

2) Make sure that policies always checked on the input
   path with xfrm interfaces. Fix from Benedict Wong.

3) Add missing calls to delete offloaded policies.
   Fix from Leon Romanovsky.

4) Fix inbound ipv4/udp/esp packets to UDPv6 dualstack
   sockets. We need to make sure to call the handler
   of the correct address family.
   Fix from Maciej Żenczykowski.

5) Use the address faqmily from the xfrm_state selector
   for BEET mode input.
   Fix from Herbert Xu.

6) Linearize the skb after offloading if needed. This
   was forgotten when the ESP software GRO codepath
   was created. Fix from Sebastian Andrzej Siewior.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 67caf26d769e0cb17dba182b0acae015c7aa5881:

  Merge tag 'for-net-2023-05-19' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth (2023-05-19 22:48:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git tags/ipsec-2023-06-20

for you to fetch changes up to f015b900bc3285322029b4a7d132d6aeb0e51857:

  xfrm: Linearize the skb after offloading if needed. (2023-06-16 10:29:50 +0200)

----------------------------------------------------------------
ipsec-2023-06-20

----------------------------------------------------------------
Benedict Wong (2):
      xfrm: Treat already-verified secpath entries as optional
      xfrm: Ensure policies always checked on XFRM-I input path

Herbert Xu (1):
      xfrm: Use xfrm_state selector for BEET input

Leon Romanovsky (1):
      xfrm: add missed call to delete offloaded policies

Maciej Żenczykowski (1):
      xfrm: fix inbound ipv4/udp/esp packets to UDPv6 dualstack sockets

Sebastian Andrzej Siewior (1):
      xfrm: Linearize the skb after offloading if needed.

 include/net/xfrm.h             |  1 +
 net/ipv4/esp4_offload.c        |  3 +++
 net/ipv4/xfrm4_input.c         |  1 +
 net/ipv6/esp6_offload.c        |  3 +++
 net/ipv6/xfrm6_input.c         |  3 +++
 net/xfrm/xfrm_input.c          |  8 +++----
 net/xfrm/xfrm_interface_core.c | 54 ++++++++++++++++++++++++++++++++++++++----
 net/xfrm/xfrm_policy.c         | 14 +++++++++++
 8 files changed, 79 insertions(+), 8 deletions(-)

