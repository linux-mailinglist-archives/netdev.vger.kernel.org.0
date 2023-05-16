Return-Path: <netdev+bounces-2851-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0C87044A7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 904EB1C20B27
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 05:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F9D1C77F;
	Tue, 16 May 2023 05:24:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4231B91D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 05:24:12 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474E635BB
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 22:24:11 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 0C6B4206ED;
	Tue, 16 May 2023 07:24:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6OU5YI6H-0BI; Tue, 16 May 2023 07:24:09 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 069C5201D3;
	Tue, 16 May 2023 07:24:09 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 01FE980004A;
	Tue, 16 May 2023 07:24:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 07:24:08 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 16 May
 2023 07:24:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id B1E083181D1E; Tue, 16 May 2023 07:24:07 +0200 (CEST)
From: Steffen Klassert <steffen.klassert@secunet.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Steffen Klassert
	<steffen.klassert@secunet.com>, <netdev@vger.kernel.org>
Subject: [PATCH 0/7] pull request (net): ipsec 2023-05-16
Date: Tue, 16 May 2023 07:23:58 +0200
Message-ID: <20230516052405.2677554-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

1) Don't check the policy default if we have an allow
   policy. Fix from Sabrina Dubroca.

2) Fix netdevice refount usage on offload.
   From Leon Romanovsky.

3) Use netdev_put instead of dev_puti to correctly release
   the netdev on failure in xfrm_dev_policy_add.
   From Leon Romanovsky.

4) Revert "Fix XFRM-I support for nested ESP tunnels"
   This broke Netfilter policy matching.
   From Martin Willi.

5) Reject optional tunnel/BEET mode templates in outbound policies
   on netlink and pfkey sockets. From Tobias Brunner.

6) Check if_id in inbound policy/secpath match to make
   it symetric to the outbound codepath.
   From Benedict Wong.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 24e3fce00c0b557491ff596c0682a29dee6fe848:

  net: stmmac: Add queue reset into stmmac_xdp_open() function (2023-04-05 19:02:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git tags/ipsec-2023-05-16

for you to fetch changes up to 8680407b6f8f5fba59e8f1d63c869abc280f04df:

  xfrm: Check if_id in inbound policy/secpath match (2023-05-10 07:56:05 +0200)

----------------------------------------------------------------
ipsec-2023-05-16

----------------------------------------------------------------
Benedict Wong (1):
      xfrm: Check if_id in inbound policy/secpath match

Leon Romanovsky (2):
      xfrm: release all offloaded policy memory
      xfrm: Fix leak of dev tracker

Martin Willi (1):
      Revert "Fix XFRM-I support for nested ESP tunnels"

Sabrina Dubroca (1):
      xfrm: don't check the default policy if the policy allows the packet

Tobias Brunner (2):
      xfrm: Reject optional tunnel/BEET mode templates in outbound policies
      af_key: Reject optional tunnel/BEET mode templates in outbound policies

 net/key/af_key.c               | 12 ++++++----
 net/xfrm/xfrm_device.c         |  2 +-
 net/xfrm/xfrm_interface_core.c | 54 ++++--------------------------------------
 net/xfrm/xfrm_policy.c         | 20 +++++-----------
 net/xfrm/xfrm_user.c           | 15 ++++++++----
 5 files changed, 29 insertions(+), 74 deletions(-)

