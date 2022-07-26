Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4A8581C83
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 01:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbiGZXoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 19:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbiGZXoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 19:44:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A159220F4;
        Tue, 26 Jul 2022 16:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4937AB81EF9;
        Tue, 26 Jul 2022 23:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BC6C433C1;
        Tue, 26 Jul 2022 23:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658879043;
        bh=D+x8CqdaXbsmhEFhqyxFXaNoVxZF5fkQARi2WHcJmQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9EsrFidVTHX3mXXL+nFaGsFpVhTLpamPzuJMkHWSGIn6d4e9NCMeLSHk5OfyV03R
         rhI0tGt0ZJ3cE0cfb+QB/1yVzDMZuxuYlShPMbiib03tmAPWNKtbKQ6cjrRMRFN5VK
         WJg/VqCokNMNjw3f+Z1OneBOPSGdIYitKegbrqalA2yObAsU9TX5XefzT/0oRcyGCt
         unnzoAjDhpyHtXrXPmPve6P8Q/RJf+YLx33QboNHKwD0OMRFswn8XnOR8wB+W6oPFo
         tvltXU9e4EeCWjpWstIHcdJJs8ZxuFvlK/Qs/JVWV54mnblCrynjCOixAvsbNfVET2
         RcCbiYJnzxQxA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 9DCED5C02F9; Tue, 26 Jul 2022 16:44:02 -0700 (PDT)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, kernel-team@fb.com,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH v2 bpf 1/2] bpf: Update bpf_design_QA.rst to clarify that kprobes is not ABI
Date:   Tue, 26 Jul 2022 16:44:00 -0700
Message-Id: <20220726234401.3425557-1-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20220722212346.GD2860372@paulmck-ThinkPad-P17-Gen-1>
References: <20220722212346.GD2860372@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updates bpf_design_QA.rst to clarify that the ability to
attach a BPF program to a given point in the kernel code via kprobes
does not make that attachment point be part of the Linux kernel's ABI.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 Documentation/bpf/bpf_design_QA.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index 437de2a7a5de7..2ed9128cfbec8 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -214,6 +214,12 @@ A: NO. Tracepoints are tied to internal implementation details hence they are
 subject to change and can break with newer kernels. BPF programs need to change
 accordingly when this happens.
 
+Q: Are places where kprobes can attach part of the stable ABI?
+--------------------------------------------------------------
+A: NO. The places to which kprobes can attach are internal implementation
+details, which means that they are subject to change and can break with
+newer kernels. BPF programs need to change accordingly when this happens.
+
 Q: How much stack space a BPF program uses?
 -------------------------------------------
 A: Currently all program types are limited to 512 bytes of stack
-- 
2.31.1.189.g2e36527f23

