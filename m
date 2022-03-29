Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9674A4EA6FB
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiC2FKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiC2FKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2594765CE;
        Mon, 28 Mar 2022 22:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDED9B816AD;
        Tue, 29 Mar 2022 05:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E08C34112;
        Tue, 29 Mar 2022 05:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530529;
        bh=y7z/qEHrOST+r4n/NHkYGhJVqbjFJwbZE+oL7GnF4Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqRtsUdJRBE4R/a+xJtrTh5NJfyc7OWG7x7FsIJv6imxHo9LpO6Kkkx3C7qFNzBPp
         As++5mcuLRah+rujqncgnukRogCI31w4wKqanWHxn6ualPafBEgn7XGu7fGlrp6UEO
         J9AvRLKPJsjIGOVGnz0NhVgM8JB9CcrJhhfnb1ZBtAQA/OCdaU1YWKi5mr46AKho2M
         iRug9t4Re1mk19bvWnBJR46cs5zWeNiLDSbG3Pd633u1OkaEsJwaMBlwHfaGi3nezV
         T7DILvrkpVhxCNP6F9InnNeLvAI28Wu0Q7quCQs55fHYLoFPlGIGjGd611aSy48zMZ
         CCdZcF2FVSqiA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 10/14] docs: netdev: make the testing requirement more stringent
Date:   Mon, 28 Mar 2022 22:08:26 -0700
Message-Id: <20220329050830.2755213-11-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329050830.2755213-1-kuba@kernel.org>
References: <20220329050830.2755213-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These days we often ask for selftests so let's update our
testing requirements.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index f8b89dc81cab..1388f78cfbc5 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -196,11 +196,15 @@ as possible alternative mechanisms.
 
 What level of testing is expected before I submit my change?
 ------------------------------------------------------------
-If your changes are against ``net-next``, the expectation is that you
-have tested by layering your changes on top of ``net-next``.  Ideally
-you will have done run-time testing specific to your change, but at a
-minimum, your changes should survive an ``allyesconfig`` and an
-``allmodconfig`` build without new warnings or failures.
+At the very minimum your changes must survive an ``allyesconfig`` and an
+``allmodconfig`` build with ``W=1`` set without new warnings or failures.
+
+Ideally you will have done run-time testing specific to your change,
+and the patch series contains a set of kernel selftest for
+``tools/testing/selftests/net`` or using the KUnit framework.
+
+You are expected to test your changes on top of the relevant networking
+tree (``net`` or ``net-next``) and not e.g. a stable tree or ``linux-next``.
 
 How do I post corresponding changes to user space components?
 -------------------------------------------------------------
-- 
2.34.1

