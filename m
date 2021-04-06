Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409C23553BC
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344008AbhDFMXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:23:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34464 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343978AbhDFMWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:04 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1058963E3C;
        Tue,  6 Apr 2021 14:21:34 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 17/28] netfilter: nftables: remove documentation on static functions
Date:   Tue,  6 Apr 2021 14:21:22 +0200
Message-Id: <20210406122133.1644-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 4f16d25c68ec ("netfilter: nftables: add nft_parse_register_load()
and use it") and 345023b0db31 ("netfilter: nftables: add
nft_parse_register_store() and use it"), the following functions are not
exported symbols anymore:

- nft_parse_register()
- nft_validate_register_load()
- nft_validate_register_store()

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index edb51c9ebab0..a24de59e6c69 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8615,15 +8615,6 @@ int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest)
 }
 EXPORT_SYMBOL_GPL(nft_parse_u32_check);
 
-/**
- *	nft_parse_register - parse a register value from a netlink attribute
- *
- *	@attr: netlink attribute
- *
- *	Parse and translate a register value from a netlink attribute.
- *	Registers used to be 128 bit wide, these register numbers will be
- *	mapped to the corresponding 32 bit register numbers.
- */
 static unsigned int nft_parse_register(const struct nlattr *attr)
 {
 	unsigned int reg;
@@ -8659,15 +8650,6 @@ int nft_dump_register(struct sk_buff *skb, unsigned int attr, unsigned int reg)
 }
 EXPORT_SYMBOL_GPL(nft_dump_register);
 
-/**
- *	nft_validate_register_load - validate a load from a register
- *
- *	@reg: the register number
- *	@len: the length of the data
- *
- * 	Validate that the input register is one of the general purpose
- * 	registers and that the length of the load is within the bounds.
- */
 static int nft_validate_register_load(enum nft_registers reg, unsigned int len)
 {
 	if (reg < NFT_REG_1 * NFT_REG_SIZE / NFT_REG32_SIZE)
@@ -8695,20 +8677,6 @@ int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len)
 }
 EXPORT_SYMBOL_GPL(nft_parse_register_load);
 
-/**
- *	nft_validate_register_store - validate an expressions' register store
- *
- *	@ctx: context of the expression performing the load
- * 	@reg: the destination register number
- * 	@data: the data to load
- * 	@type: the data type
- * 	@len: the length of the data
- *
- * 	Validate that a data load uses the appropriate data type for
- * 	the destination register and the length is within the bounds.
- * 	A value of NULL for the data means that its runtime gathered
- * 	data.
- */
 static int nft_validate_register_store(const struct nft_ctx *ctx,
 				       enum nft_registers reg,
 				       const struct nft_data *data,
-- 
2.30.2

