Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC0E564261
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbiGBTKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGBTKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:10:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EFD1E00A;
        Sat,  2 Jul 2022 12:10:33 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Sat,  2 Jul 2022 21:10:26 +0200
Message-Id: <20220702191029.238563-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Insufficient validation of element datatype and length in
   nft_setelem_parse_data(). At least commit 7d7402642eaf updates
   maximum element data area up to 64 bytes when only 16 bytes
   where supported at the time. Support for larger element size
   came later in fdb9c405e35b though. Picking this older commit
   as Fixes: tag to be safe than sorry.

2) Memleak in pipapo destroy path, reproducible when transaction
   in aborted. This is already triggering in the existing netfilter
   test infrastructure since more recent new tests are covering this
   path.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit f8ebb3ac881b17712e1d5967c97ab1806b16d3d6:

  net: usb: ax88179_178a: Fix packet receiving (2022-06-30 10:41:57 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 9827a0e6e23bf43003cd3d5b7fb11baf59a35e1e:

  netfilter: nft_set_pipapo: release elements in clone from abort path (2022-07-02 21:04:19 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nf_tables: stricter validation of element data
      netfilter: nft_set_pipapo: release elements in clone from abort path

 net/netfilter/nf_tables_api.c  |  9 +++++++-
 net/netfilter/nft_set_pipapo.c | 48 +++++++++++++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 16 deletions(-)
