Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01F357E63B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiGVSHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiGVSG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:06:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D78E2982B;
        Fri, 22 Jul 2022 11:06:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF7CBB829E2;
        Fri, 22 Jul 2022 18:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B09EC341CA;
        Fri, 22 Jul 2022 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658513215;
        bh=D+x8CqdaXbsmhEFhqyxFXaNoVxZF5fkQARi2WHcJmQM=;
        h=From:To:Cc:Subject:Date:From;
        b=qxkLir6QXtovlD9rGM/Sbc7EKi7H4BQJ8jNGmEgyj+mZlbchofbdJOGnw1RXlnJm4
         b6MwdZ2W6j71rOee5xBVVwOndXAEmZGIdiVHf8BcWtUWp1Cc2wiiaq+TkMsZvavEa/
         Lmhq0cLzHQYMDNTomIPLXCaKwT4doRfi8WvmweSmmcR65mpXf6q6HrM0fhmodYmv9m
         Rhe0ELuAyixioyL7bj8cjow1GYEGQ/YglcJysgyqWG90fyQx37qX8uRqpi7yTukwCD
         VkpILytuUn8d/VnyWMHk2u9vgpfyfOZIK3+7+ibmwZcDo/8txLcSvd4qs7lZQ1ydqC
         4BeLjT1pw8fFA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 34F1D5C0602; Fri, 22 Jul 2022 11:06:55 -0700 (PDT)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, kernel-team@fb.com,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH bpf 1/2] bpf: Update bpf_design_QA.rst to clarify that kprobes is not ABI
Date:   Fri, 22 Jul 2022 11:06:40 -0700
Message-Id: <20220722180641.2902585-1-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

