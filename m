Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F133558B3B
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiFWWbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiFWWbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FE34133B;
        Thu, 23 Jun 2022 15:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 726E261EFE;
        Thu, 23 Jun 2022 22:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8C7C341C0;
        Thu, 23 Jun 2022 22:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656023500;
        bh=JOr4XB5AjQsPL/m0VXzjQnysrgirQotZ5IrmNpmL/CI=;
        h=From:To:Cc:Subject:Date:From;
        b=SyxQjSbcmpvHyzO+Qf7Av3hgXARona9YUuA8gkKjUjoTXqHQeWCSLLn7bpppX4qWk
         vTi4Py859pnIZajqzoutiREgtn5nLJx2KUoueifzREJO64dSAi1SM3oG3Y2GR3dKwl
         QGemYCCgCvUa+EvS81oW6/azKOudbInBYznsPi6o7sJN30DBF6Q4z+epqePrY/c5dM
         yD+xsdDRIT9tW0rdpKk3LXsNHsizvrqzqPGey0wwQU/y9w8cdu5soQPbSieEq+DbAy
         Pr6PkU5bLnAnfdfMih1oUaYuF5GOx3W5U7vNJwp56YVGVzEpV4Int7IWS2aws4r1qe
         /ECVEaSoBb6QA==
From:   "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf] fprobe, samples: Add module parameter descriptions
Date:   Fri, 24 Jun 2022 07:31:35 +0900
Message-Id: <165602349520.56016.1314423560740428008.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Add module parameter descriptions for the fprobe_example module.

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 samples/fprobe/fprobe_example.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/samples/fprobe/fprobe_example.c b/samples/fprobe/fprobe_example.c
index 01ee6c8c8382..18b1e5c4b431 100644
--- a/samples/fprobe/fprobe_example.c
+++ b/samples/fprobe/fprobe_example.c
@@ -25,12 +25,19 @@ static unsigned long nhit;
 
 static char symbol[MAX_SYMBOL_LEN] = "kernel_clone";
 module_param_string(symbol, symbol, sizeof(symbol), 0644);
+MODULE_PARM_DESC(symbol, "Probed symbol(s), given by comma separated symbols or a wildcard pattern.");
+
 static char nosymbol[MAX_SYMBOL_LEN] = "";
 module_param_string(nosymbol, nosymbol, sizeof(nosymbol), 0644);
+MODULE_PARM_DESC(nosymbol, "Not-probed symbols, given by a wildcard pattern.");
+
 static bool stackdump = true;
 module_param(stackdump, bool, 0644);
+MODULE_PARM_DESC(stackdump, "Enable stackdump.");
+
 static bool use_trace = false;
 module_param(use_trace, bool, 0644);
+MODULE_PARM_DESC(use_trace, "Use trace_printk instead of printk. This is only for debugging.");
 
 static void show_backtrace(void)
 {

