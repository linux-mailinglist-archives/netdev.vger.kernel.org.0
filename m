Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB82E58812E
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 19:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiHBRjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 13:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiHBRjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 13:39:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36474B0D8;
        Tue,  2 Aug 2022 10:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ED02B81FE4;
        Tue,  2 Aug 2022 17:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D039C433C1;
        Tue,  2 Aug 2022 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659461955;
        bh=MuBLArNMizvUksBhjYtQXr2Fl8QtF7ViTn25ne4X8Jk=;
        h=From:To:Cc:Subject:Date:From;
        b=Owrpy1b6JGbxAj+OZKkLPxy84SMEQ1r8CFVtqfWGqJIHRI8+hUaYD2kSOFnJJ3xNf
         T10k4SF4f3znZHwaWVNdYX9ireXQREz2j4fwh2HXa19OlQJXzjXQg2mG1OU3g647zC
         jzlhR6iUy/M6xcx1tA+EpYVyfYQqAVs8A0AI85MvXrRA+ogYcJbubMsaBCBXybKPOU
         2iQ9CRiH5q64t1R3b4TMM3E+viFyp3iTs3GnjQ2F/Lc14GHScqIxnuFF60DrA49S0u
         ZlQlbCR/xHkWMsQzKXCjJt/YyhFTFP/s8mz35Q7B7Lzf5iQTH8pvTQMadpcyQz5i4O
         0x8YV4/Dc0z3g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id B6AF55C0830; Tue,  2 Aug 2022 10:39:14 -0700 (PDT)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, kernel-team@fb.com,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v3 bpf 3/3] bpf: Update bpf_design_QA.rst to clarify that BTF_ID does not ABIify a function
Date:   Tue,  2 Aug 2022 10:39:13 -0700
Message-Id: <20220802173913.4170192-3-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
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

This patch updates bpf_design_QA.rst to clarify that mentioning a function
to the BTF_ID macro does not make that function become part of the Linux
kernel's ABI.

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 Documentation/bpf/bpf_design_QA.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index a06ae8a828e3d..a210b8a4df005 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -291,3 +291,10 @@ The kernel function prototypes will change, and BPF programs attaching to
 them will need to change.  The BPF compile-once-run-everywhere (CO-RE)
 should be used in order to make it easier to adapt your BPF programs to
 different versions of the kernel.
+
+Q: Marking a function with BTF_ID makes that function an ABI?
+-------------------------------------------------------------
+A: NO.
+
+The BTF_ID macro does not cause a function to become part of the ABI
+any more than does the EXPORT_SYMBOL_GPL macro.
-- 
2.31.1.189.g2e36527f23

