Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A446E4C7A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjDQPLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbjDQPL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:11:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBA57ED8;
        Mon, 17 Apr 2023 08:11:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37958621FB;
        Mon, 17 Apr 2023 15:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2375C433EF;
        Mon, 17 Apr 2023 15:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681744279;
        bh=P/QoeHAKZ55pby10GX/9bO6MW7hatN7F+qitfvgXnRE=;
        h=From:Subject:Date:To:Cc:From;
        b=FJPp7X4zdL6Va3+6pJ4YZPL7NSqwB631FyG24irKLeOIieUVWibRtdAGxhf4A+pF0
         IRTNFSXMp0qeEroftwH601Z7yOYJoqIutvYYZNi+Ou1wEEC+pQwC9jBGDj6r3meO1x
         JfqudXjZtQ5DKLmTnu6reDsGf2w3H1YpRniLFV6b+GE3kJzoNos1qbABVISUFYskNy
         XZTuysiPKUV5GfBC0Z448JmJe5xswnctbPLFenRMxJeGTgqvq74uO2gWEo+JHEOIA8
         ulq9i1clgvzfl+FEUfEPxP5AlO4F8Wo3NHWimpP+hBz30YZHz2LeBK4wf1d+But4UA
         gLhQzFWnHFUSA==
From:   Simon Horman <horms@kernel.org>
Subject: [PATCH nf-next v3 0/4] ipvs: Cleanups for v6.4
Date:   Mon, 17 Apr 2023 17:10:44 +0200
Message-Id: <20230409-ipvs-cleanup-v3-0-5149ea34b0b9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHRhPWQC/32Nyw6CMBREf4V0bU25oIAr/8O46OMCjc2FtNBgC
 P9u052JcTkzOXN2FtBbDOxW7MxjtMFOlEJ1KpgeJQ3IrUmZgYBK1KLjdo6Ba4eS1pkr3ckLSGg
 quLKEKBmQKy9Jjwmi1blUzh57u2XHg1HPCbeFPdMw2rBM/p3dsczzb00sueBdq42GGnpU4v5CT
 +jOkx/yU4R/NCQaRK1N2RjZiPaLPo7jAywovkcFAQAA
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Julian,

this series aims to clean up IPVS in several ways without
implementing any functional changes, aside from removing
some debugging output.

Patch 1/4: Update width of source for ip_vs_sync_conn_options
           The operation is safe, use an annotation to describe it properly.

Patch 2/4: Consistently use array_size() in ip_vs_conn_init()
           It seems better to use helpers consistently.

Patch 3/4: Remove {Enter,Leave}Function
           These seem to be well past their use-by date.

Patch 4/4: Correct spelling in comments
	   I can't spell. But codespell helps me these days.

All changes: compile tested only!

---
Changes in v3:
- Patch 2/4: Correct division by 1024.
             It was applied to the wrong variable in v2.
- Add Horatiu's Reviewed-by tag.

Changes in v2:
- Patch 1/4: Correct spelling of 'conn' in subject.
- Patch 2/4: Restore division by 1024. It was lost on v1.

---
Simon Horman (4):
      ipvs: Update width of source for ip_vs_sync_conn_options
      ipvs: Consistently use array_size() in ip_vs_conn_init()
      ipvs: Remove {Enter,Leave}Function
      ipvs: Correct spelling in comments

 include/net/ip_vs.h             | 32 +++++----------------
 net/netfilter/ipvs/ip_vs_conn.c | 12 ++++----
 net/netfilter/ipvs/ip_vs_core.c |  8 ------
 net/netfilter/ipvs/ip_vs_ctl.c  | 26 +----------------
 net/netfilter/ipvs/ip_vs_sync.c |  7 +----
 net/netfilter/ipvs/ip_vs_xmit.c | 62 ++++++-----------------------------------
 6 files changed, 23 insertions(+), 124 deletions(-)

base-commit: 99676a5766412f3936c55b9d18565d248e5463ee

