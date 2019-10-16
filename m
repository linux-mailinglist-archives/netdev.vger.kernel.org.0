Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23AD8D8EE4
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392589AbfJPLFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:05:11 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:48172 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfJPLFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 07:05:11 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKh6l-0004pY-QH; Wed, 16 Oct 2019 12:04:47 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iKh6l-0006Pw-EC; Wed, 16 Oct 2019 12:04:47 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: bpf: add static in net/core/filter.c
Date:   Wed, 16 Oct 2019 12:04:46 +0100
Message-Id: <20191016110446.24622-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a number of structs in net/core/filter.c
that are not exported or declared outside of the
file. Fix the following warnings by making these
all static:

net/core/filter.c:8465:31: warning: symbol 'sk_filter_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8472:27: warning: symbol 'sk_filter_prog_ops' was not declared. Should it be static?
net/core/filter.c:8476:31: warning: symbol 'tc_cls_act_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8484:27: warning: symbol 'tc_cls_act_prog_ops' was not declared. Should it be static?
net/core/filter.c:8488:31: warning: symbol 'xdp_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8495:27: warning: symbol 'xdp_prog_ops' was not declared. Should it be static?
net/core/filter.c:8499:31: warning: symbol 'cg_skb_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8505:27: warning: symbol 'cg_skb_prog_ops' was not declared. Should it be static?
net/core/filter.c:8509:31: warning: symbol 'lwt_in_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8515:27: warning: symbol 'lwt_in_prog_ops' was not declared. Should it be static?
net/core/filter.c:8519:31: warning: symbol 'lwt_out_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8525:27: warning: symbol 'lwt_out_prog_ops' was not declared. Should it be static?
net/core/filter.c:8529:31: warning: symbol 'lwt_xmit_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8536:27: warning: symbol 'lwt_xmit_prog_ops' was not declared. Should it be static?
net/core/filter.c:8540:31: warning: symbol 'lwt_seg6local_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8546:27: warning: symbol 'lwt_seg6local_prog_ops' was not declared. Should it be static?
net/core/filter.c:8550:31: warning: symbol 'cg_sock_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8556:27: warning: symbol 'cg_sock_prog_ops' was not declared. Should it be static?
net/core/filter.c:8559:31: warning: symbol 'cg_sock_addr_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8565:27: warning: symbol 'cg_sock_addr_prog_ops' was not declared. Should it be static?
net/core/filter.c:8568:31: warning: symbol 'sock_ops_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8574:27: warning: symbol 'sock_ops_prog_ops' was not declared. Should it be static?
net/core/filter.c:8577:31: warning: symbol 'sk_skb_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8584:27: warning: symbol 'sk_skb_prog_ops' was not declared. Should it be static?
net/core/filter.c:8587:31: warning: symbol 'sk_msg_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8594:27: warning: symbol 'sk_msg_prog_ops' was not declared. Should it be static?
net/core/filter.c:8597:31: warning: symbol 'flow_dissector_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8603:27: warning: symbol 'flow_dissector_prog_ops' was not declared. Should it be static?
net/core/filter.c:8929:31: warning: symbol 'sk_reuseport_verifier_ops' was not declared. Should it be static?
net/core/filter.c:8935:27: warning: symbol 'sk_reuseport_prog_ops' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 net/core/filter.c | 60 +++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ed6563622ce3..f7338fee41f8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8462,18 +8462,18 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
-const struct bpf_verifier_ops sk_filter_verifier_ops = {
+static const struct bpf_verifier_ops sk_filter_verifier_ops = {
 	.get_func_proto		= sk_filter_func_proto,
 	.is_valid_access	= sk_filter_is_valid_access,
 	.convert_ctx_access	= bpf_convert_ctx_access,
 	.gen_ld_abs		= bpf_gen_ld_abs,
 };
 
-const struct bpf_prog_ops sk_filter_prog_ops = {
+static const struct bpf_prog_ops sk_filter_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
-const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
+static const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.get_func_proto		= tc_cls_act_func_proto,
 	.is_valid_access	= tc_cls_act_is_valid_access,
 	.convert_ctx_access	= tc_cls_act_convert_ctx_access,
@@ -8481,126 +8481,126 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.gen_ld_abs		= bpf_gen_ld_abs,
 };
 
-const struct bpf_prog_ops tc_cls_act_prog_ops = {
+static const struct bpf_prog_ops tc_cls_act_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
-const struct bpf_verifier_ops xdp_verifier_ops = {
+static const struct bpf_verifier_ops xdp_verifier_ops = {
 	.get_func_proto		= xdp_func_proto,
 	.is_valid_access	= xdp_is_valid_access,
 	.convert_ctx_access	= xdp_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
 };
 
-const struct bpf_prog_ops xdp_prog_ops = {
+static const struct bpf_prog_ops xdp_prog_ops = {
 	.test_run		= bpf_prog_test_run_xdp,
 };
 
-const struct bpf_verifier_ops cg_skb_verifier_ops = {
+static const struct bpf_verifier_ops cg_skb_verifier_ops = {
 	.get_func_proto		= cg_skb_func_proto,
 	.is_valid_access	= cg_skb_is_valid_access,
 	.convert_ctx_access	= bpf_convert_ctx_access,
 };
 
-const struct bpf_prog_ops cg_skb_prog_ops = {
+static const struct bpf_prog_ops cg_skb_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
-const struct bpf_verifier_ops lwt_in_verifier_ops = {
+static const struct bpf_verifier_ops lwt_in_verifier_ops = {
 	.get_func_proto		= lwt_in_func_proto,
 	.is_valid_access	= lwt_is_valid_access,
 	.convert_ctx_access	= bpf_convert_ctx_access,
 };
 
-const struct bpf_prog_ops lwt_in_prog_ops = {
+static const struct bpf_prog_ops lwt_in_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
-const struct bpf_verifier_ops lwt_out_verifier_ops = {
+static const struct bpf_verifier_ops lwt_out_verifier_ops = {
 	.get_func_proto		= lwt_out_func_proto,
 	.is_valid_access	= lwt_is_valid_access,
 	.convert_ctx_access	= bpf_convert_ctx_access,
 };
 
-const struct bpf_prog_ops lwt_out_prog_ops = {
+static const struct bpf_prog_ops lwt_out_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
-const struct bpf_verifier_ops lwt_xmit_verifier_ops = {
+static const struct bpf_verifier_ops lwt_xmit_verifier_ops = {
 	.get_func_proto		= lwt_xmit_func_proto,
 	.is_valid_access	= lwt_is_valid_access,
 	.convert_ctx_access	= bpf_convert_ctx_access,
 	.gen_prologue		= tc_cls_act_prologue,
 };
 
-const struct bpf_prog_ops lwt_xmit_prog_ops = {
+static const struct bpf_prog_ops lwt_xmit_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
-const struct bpf_verifier_ops lwt_seg6local_verifier_ops = {
+static const struct bpf_verifier_ops lwt_seg6local_verifier_ops = {
 	.get_func_proto		= lwt_seg6local_func_proto,
 	.is_valid_access	= lwt_is_valid_access,
 	.convert_ctx_access	= bpf_convert_ctx_access,
 };
 
-const struct bpf_prog_ops lwt_seg6local_prog_ops = {
+static const struct bpf_prog_ops lwt_seg6local_prog_ops = {
 	.test_run		= bpf_prog_test_run_skb,
 };
 
-const struct bpf_verifier_ops cg_sock_verifier_ops = {
+static const struct bpf_verifier_ops cg_sock_verifier_ops = {
 	.get_func_proto		= sock_filter_func_proto,
 	.is_valid_access	= sock_filter_is_valid_access,
 	.convert_ctx_access	= bpf_sock_convert_ctx_access,
 };
 
-const struct bpf_prog_ops cg_sock_prog_ops = {
+static const struct bpf_prog_ops cg_sock_prog_ops = {
 };
 
-const struct bpf_verifier_ops cg_sock_addr_verifier_ops = {
+static const struct bpf_verifier_ops cg_sock_addr_verifier_ops = {
 	.get_func_proto		= sock_addr_func_proto,
 	.is_valid_access	= sock_addr_is_valid_access,
 	.convert_ctx_access	= sock_addr_convert_ctx_access,
 };
 
-const struct bpf_prog_ops cg_sock_addr_prog_ops = {
+static const struct bpf_prog_ops cg_sock_addr_prog_ops = {
 };
 
-const struct bpf_verifier_ops sock_ops_verifier_ops = {
+static const struct bpf_verifier_ops sock_ops_verifier_ops = {
 	.get_func_proto		= sock_ops_func_proto,
 	.is_valid_access	= sock_ops_is_valid_access,
 	.convert_ctx_access	= sock_ops_convert_ctx_access,
 };
 
-const struct bpf_prog_ops sock_ops_prog_ops = {
+static const struct bpf_prog_ops sock_ops_prog_ops = {
 };
 
-const struct bpf_verifier_ops sk_skb_verifier_ops = {
+static const struct bpf_verifier_ops sk_skb_verifier_ops = {
 	.get_func_proto		= sk_skb_func_proto,
 	.is_valid_access	= sk_skb_is_valid_access,
 	.convert_ctx_access	= sk_skb_convert_ctx_access,
 	.gen_prologue		= sk_skb_prologue,
 };
 
-const struct bpf_prog_ops sk_skb_prog_ops = {
+static const struct bpf_prog_ops sk_skb_prog_ops = {
 };
 
-const struct bpf_verifier_ops sk_msg_verifier_ops = {
+static const struct bpf_verifier_ops sk_msg_verifier_ops = {
 	.get_func_proto		= sk_msg_func_proto,
 	.is_valid_access	= sk_msg_is_valid_access,
 	.convert_ctx_access	= sk_msg_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
 };
 
-const struct bpf_prog_ops sk_msg_prog_ops = {
+static const struct bpf_prog_ops sk_msg_prog_ops = {
 };
 
-const struct bpf_verifier_ops flow_dissector_verifier_ops = {
+static const struct bpf_verifier_ops flow_dissector_verifier_ops = {
 	.get_func_proto		= flow_dissector_func_proto,
 	.is_valid_access	= flow_dissector_is_valid_access,
 	.convert_ctx_access	= flow_dissector_convert_ctx_access,
 };
 
-const struct bpf_prog_ops flow_dissector_prog_ops = {
+static const struct bpf_prog_ops flow_dissector_prog_ops = {
 	.test_run		= bpf_prog_test_run_flow_dissector,
 };
 
@@ -8926,12 +8926,12 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
-const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
+static const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 	.get_func_proto		= sk_reuseport_func_proto,
 	.is_valid_access	= sk_reuseport_is_valid_access,
 	.convert_ctx_access	= sk_reuseport_convert_ctx_access,
 };
 
-const struct bpf_prog_ops sk_reuseport_prog_ops = {
+static const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
 #endif /* CONFIG_INET */
-- 
2.23.0

