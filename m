Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B864E852D
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbiC0C4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbiC0Czy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:55:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4091EC42;
        Sat, 26 Mar 2022 19:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2F260ED0;
        Sun, 27 Mar 2022 02:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB8AC340E8;
        Sun, 27 Mar 2022 02:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349652;
        bh=yMz1qRo2c8PMxZJ4OYHCmlv1drANw/ow3ic99thb9dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzFb5gCzaPf2X9xmDoxTkM8rUf3TM8YxnRZDRQb8PgkHCIeeM/wvqU8b5AiVdRfH2
         aApWSZ+hF8DP2E4F0Qv+fgN2Gnb2KSZFp1jLkzvU4vMJ4OHlfZG4W6PKD4LddnbOVK
         rGNoM+JuBpn5f9u6Q/6sRoipPwltMcoxtD8VkfR4JFqp5IinpC4iqq/jfrpv0eETJ6
         IQg/zNADnjz+CbFwYbH6Ofnl0WGkM+kBQyZ2hze5ayEGELeAKLFQ9hoycbyUNXinHS
         rrDwsoCLke1JyEdRy+9xXdQbmiZ9d0ViT7LveGy0k8GwW4KmMz75sTaKPUdNwBjMC7
         JcDYY2NucVnHA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 09/13] docs: netdev: make the testing requirement more stringent
Date:   Sat, 26 Mar 2022 19:53:56 -0700
Message-Id: <20220327025400.2481365-10-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220327025400.2481365-1-kuba@kernel.org>
References: <20220327025400.2481365-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 85a0af5dca65..26110201f301 100644
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

