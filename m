Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC0A23A3AF
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHCL53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:57:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:41854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgHCL5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 07:57:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 200BFAC5E
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:57:37 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C879B60754; Mon,  3 Aug 2020 13:57:21 +0200 (CEST)
Message-Id: <f3a978f879a758c08049552e1d3a770e47f8dc6d.1596451857.git.mkubecek@suse.cz>
In-Reply-To: <cover.1596451857.git.mkubecek@suse.cz>
References: <cover.1596451857.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 6/7] netlink: mark unused parameters of parser
 callbacks
To:     netdev@vger.kernel.org
Date:   Mon,  3 Aug 2020 13:57:21 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some calbacks used with nl_parser() do not use all parameters passed to
them. Mark unused parameters explicitly to get rid of compiler warnings.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/parser.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/netlink/parser.c b/netlink/parser.c
index f152a8268f0b..395bd5743af9 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -155,8 +155,9 @@ static int lookup_u8(const char *arg, uint8_t *result,
 /* Parser handler for a flag. Expects a name (with no additional argument),
  * generates NLA_FLAG or sets a bool (if the name was present).
  */
-int nl_parse_flag(struct nl_context *nlctx, uint16_t type, const void *data,
-		  struct nl_msg_buff *msgbuff, void *dest)
+int nl_parse_flag(struct nl_context *nlctx __maybe_unused, uint16_t type,
+		  const void *data __maybe_unused, struct nl_msg_buff *msgbuff,
+		  void *dest)
 {
 	if (dest)
 		*(bool *)dest = true;
@@ -166,7 +167,8 @@ int nl_parse_flag(struct nl_context *nlctx, uint16_t type, const void *data,
 /* Parser handler for null terminated string. Expects a string argument,
  * generates NLA_NUL_STRING or fills const char *
  */
-int nl_parse_string(struct nl_context *nlctx, uint16_t type, const void *data,
+int nl_parse_string(struct nl_context *nlctx, uint16_t type,
+		    const void *data __maybe_unused,
 		    struct nl_msg_buff *msgbuff, void *dest)
 {
 	const char *arg = *nlctx->argp;
@@ -183,8 +185,8 @@ int nl_parse_string(struct nl_context *nlctx, uint16_t type, const void *data,
  * (may use 0x prefix), generates NLA_U32 or fills an uint32_t.
  */
 int nl_parse_direct_u32(struct nl_context *nlctx, uint16_t type,
-			const void *data, struct nl_msg_buff *msgbuff,
-			void *dest)
+			const void *data __maybe_unused,
+			struct nl_msg_buff *msgbuff, void *dest)
 {
 	const char *arg = *nlctx->argp;
 	uint32_t val;
@@ -207,8 +209,8 @@ int nl_parse_direct_u32(struct nl_context *nlctx, uint16_t type,
  * (may use 0x prefix), generates NLA_U32 or fills an uint32_t.
  */
 int nl_parse_direct_u8(struct nl_context *nlctx, uint16_t type,
-		       const void *data, struct nl_msg_buff *msgbuff,
-		       void *dest)
+		       const void *data __maybe_unused,
+		       struct nl_msg_buff *msgbuff, void *dest)
 {
 	const char *arg = *nlctx->argp;
 	uint8_t val;
@@ -231,8 +233,8 @@ int nl_parse_direct_u8(struct nl_context *nlctx, uint16_t type,
  * NLA_U32 or fills an uint32_t.
  */
 int nl_parse_direct_m2cm(struct nl_context *nlctx, uint16_t type,
-			 const void *data, struct nl_msg_buff *msgbuff,
-			 void *dest)
+			 const void *data __maybe_unused,
+			 struct nl_msg_buff *msgbuff, void *dest)
 {
 	const char *arg = *nlctx->argp;
 	float meters;
@@ -256,7 +258,8 @@ int nl_parse_direct_m2cm(struct nl_context *nlctx, uint16_t type,
 /* Parser handler for (tri-state) bool. Expects "name on|off", generates
  * NLA_U8 which is 1 for "on" and 0 for "off".
  */
-int nl_parse_u8bool(struct nl_context *nlctx, uint16_t type, const void *data,
+int nl_parse_u8bool(struct nl_context *nlctx, uint16_t type,
+		    const void *data __maybe_unused,
 		    struct nl_msg_buff *msgbuff, void *dest)
 {
 	const char *arg = *nlctx->argp;
@@ -463,8 +466,9 @@ err:
  * error_parser_params (error message, return value and number of extra
  * arguments to skip).
  */
-int nl_parse_error(struct nl_context *nlctx, uint16_t type, const void *data,
-		   struct nl_msg_buff *msgbuff, void *dest)
+int nl_parse_error(struct nl_context *nlctx, uint16_t type __maybe_unused,
+		   const void *data, struct nl_msg_buff *msgbuff __maybe_unused,
+		   void *dest __maybe_unused)
 {
 	const struct error_parser_data *parser_data = data;
 	unsigned int skip = parser_data->extra_args;
-- 
2.28.0

