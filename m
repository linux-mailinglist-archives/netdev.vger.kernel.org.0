Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8BC59F2E6
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 07:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbiHXFCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 01:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiHXFCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 01:02:22 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F354505E
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 22:02:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E456920538;
        Wed, 24 Aug 2022 07:02:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8b8gfDlD4VMc; Wed, 24 Aug 2022 07:02:17 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 008C020519;
        Wed, 24 Aug 2022 07:02:17 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id E26E180004A;
        Wed, 24 Aug 2022 07:02:16 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 24 Aug 2022 07:02:16 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 24 Aug
 2022 07:02:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id BB0CA3182A09; Wed, 24 Aug 2022 07:02:15 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/6] pull request (net): ipsec 2022-08-24
Date:   Wed, 24 Aug 2022 07:02:07 +0200
Message-ID: <20220824050213.3643599-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix a refcount leak in __xfrm_policy_check.
   From Xin Xiong.

2) Revert "xfrm: update SA curlft.use_time". This
   violates RFC 2367. From Antony Antony.

3) Fix a comment on XFRMA_LASTUSED.
   From Antony Antony.

4) x->lastused is not cloned in xfrm_do_migrate.
   Fix from Antony Antony.

5) Serialize the calls to xfrm_probe_algs.
   From Herbert Xu.

6) Fix a null pointer dereference of dst->dev on a metadata
   dst in xfrm_lookup_with_ifid. From Nikolay Aleksandrov.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 9b134b1694ec8926926ba6b7b80884ea829245a0:

  bridge: Do not send empty IFLA_AF_SPEC attribute (2022-07-26 15:35:53 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 17ecd4a4db4783392edd4944f5e8268205083f70:

  xfrm: policy: fix metadata dst->dev xmit null pointer dereference (2022-08-17 11:06:37 +0200)

----------------------------------------------------------------
Antony Antony (3):
      Revert "xfrm: update SA curlft.use_time"
      xfrm: fix XFRMA_LASTUSED comment
      xfrm: clone missing x->lastused in xfrm_do_migrate

Herbert Xu (1):
      af_key: Do not call xfrm_probe_algs in parallel

Nikolay Aleksandrov (1):
      xfrm: policy: fix metadata dst->dev xmit null pointer dereference

Xin Xiong (1):
      xfrm: fix refcount leak in __xfrm_policy_check()

 include/uapi/linux/xfrm.h | 2 +-
 net/key/af_key.c          | 3 +++
 net/xfrm/xfrm_input.c     | 1 -
 net/xfrm/xfrm_output.c    | 1 -
 net/xfrm/xfrm_policy.c    | 3 ++-
 net/xfrm/xfrm_state.c     | 1 +
 6 files changed, 7 insertions(+), 4 deletions(-)
