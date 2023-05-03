Return-Path: <netdev+bounces-68-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F17176F5032
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 514FC1C20A2E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 06:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6CDA3D;
	Wed,  3 May 2023 06:32:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31FFA2A
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 06:32:58 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E43A3AB2;
	Tue,  2 May 2023 23:32:54 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Wed,  3 May 2023 08:32:47 +0200
Message-Id: <20230503063250.13700-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

The following patchset contains Netfilter fixes for net:

1) Hit ENOENT when trying to update an unexisting base chain.

2) Fix libmnl pkg-config usage in selftests, from Jeremy Sowden.

3) KASAN reports use-after-free when deleting a set element for an
   anonymous set that was already removed in the same transaction,
   reported by P. Sondej and P. Krysiuk.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit c6d96df9fa2c1d19525239d4262889cce594ce6c:

  net: ethernet: mtk_eth_soc: drop generic vlan rx offload, only use DSA untagging (2023-05-02 20:19:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-05-03

for you to fetch changes up to c1592a89942e9678f7d9c8030efa777c0d57edab:

  netfilter: nf_tables: deactivate anonymous set from preparation phase (2023-05-03 08:24:32 +0200)

----------------------------------------------------------------
netfilter pull request 23-05-03

----------------------------------------------------------------
Jeremy Sowden (1):
      selftests: netfilter: fix libmnl pkg-config usage

Pablo Neira Ayuso (2):
      netfilter: nf_tables: hit ENOENT on unexisting chain/flowtable update with missing attributes
      netfilter: nf_tables: deactivate anonymous set from preparation phase

 include/net/netfilter/nf_tables.h          |  1 +
 net/netfilter/nf_tables_api.c              | 41 +++++++++++++++++++++---------
 net/netfilter/nft_dynset.c                 |  2 +-
 net/netfilter/nft_lookup.c                 |  2 +-
 net/netfilter/nft_objref.c                 |  2 +-
 tools/testing/selftests/netfilter/Makefile |  7 +++--
 6 files changed, 38 insertions(+), 17 deletions(-)

