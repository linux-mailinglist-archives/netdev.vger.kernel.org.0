Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3334D581C85
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 01:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240026AbiGZXoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 19:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239920AbiGZXoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 19:44:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97DF22511;
        Tue, 26 Jul 2022 16:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FBF4B81F0C;
        Tue, 26 Jul 2022 23:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFC2C433D7;
        Tue, 26 Jul 2022 23:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658879043;
        bh=FoyrG1ZSgKJnTOrE1VYOwsrWEx1RrK04H5tFHcdUZVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnw7D0K/2S3xHB8E1XlQo3MsWKrlc/yb5JfpC2qYfn3tIfZLCcDpy8jnyi2XqkdFx
         oPH/26ZSHQsdMjH0WPzWVAwtzVHg5nvJlLAV2b9RWzLA9hlugZr3eEBOaqQJbLyv92
         cHFU0zDCJToId772FpQJW+tZ6BiJRC8zCkJYdojPAkhSQNEgKFJMhHACmcVOX1mbYZ
         0J6kWmZbx7t+OTHQZk5drOvbg+5pYxIyxk9g8FYPr4TPjc5fJXZcxc6DRXUoMiMcfo
         0NtkuBYoNcMTU+v2M2wf84pQM9rzVOXUc48tecqeKZ7ejvCck0c/f8UQnQscDPUSAb
         xEmsALrM7JIQw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id A02575C0369; Tue, 26 Jul 2022 16:44:02 -0700 (PDT)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, kernel-team@fb.com,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH v2 bpf 2/2] bpf: Update bpf_design_QA.rst to clarify that attaching to functions is not ABI
Date:   Tue, 26 Jul 2022 16:44:01 -0700
Message-Id: <20220726234401.3425557-2-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20220726234401.3425557-1-paulmck@kernel.org>
References: <20220722212346.GD2860372@paulmck-ThinkPad-P17-Gen-1>
 <20220726234401.3425557-1-paulmck@kernel.org>
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
attach a BPF program to an arbitrary function in the kernel does not
make that function become part of the Linux kernel's ABI.

[ paulmck: Apply Daniel Borkmann feedback. ]

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 Documentation/bpf/bpf_design_QA.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index 2ed9128cfbec8..a06ae8a828e3d 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -279,3 +279,15 @@ cc (congestion-control) implementations.  If any of these kernel
 functions has changed, both the in-tree and out-of-tree kernel tcp cc
 implementations have to be changed.  The same goes for the bpf
 programs and they have to be adjusted accordingly.
+
+Q: Attaching to arbitrary kernel functions is an ABI?
+-----------------------------------------------------
+Q: BPF programs can be attached to many kernel functions.  Do these
+kernel functions become part of the ABI?
+
+A: NO.
+
+The kernel function prototypes will change, and BPF programs attaching to
+them will need to change.  The BPF compile-once-run-everywhere (CO-RE)
+should be used in order to make it easier to adapt your BPF programs to
+different versions of the kernel.
-- 
2.31.1.189.g2e36527f23

