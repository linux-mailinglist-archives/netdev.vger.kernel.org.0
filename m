Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F06758800D
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiHBQOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237698AbiHBQOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:14:25 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2175A54AD2
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 09:12:13 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31cdce3ed04so122418737b3.13
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 09:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jUv4DHIW/jf9S8WLW0PtEsjOkKBjlj0vSuriaB+Qt8E=;
        b=hM+Y0P/b1I1LdGmErr2y+Pi82Lk6RWNHLQyjLYuQWRue2rjjvVuIYhBbnUjvMQulhG
         aQtvHB6uHfIobK93i0FmJI8mpx7/MxrFYIdIbUvHr/pOvNUIzGZfqtA9eZmHvPrJ+lw8
         sWXW+KQ6/4oPPWtJw2Nw6Q+QygmSGCg+1FAREphdmPPvbY6t2C//R1aUMo1tfdto3j8W
         eWSVQtZJr5uhI6GufTWlbC01S3C6QmvhtgxoHsZy/QJJUqlQt1sdRRqz8a2y3mcei563
         WSJmqXpYWFf2IbEVjOeKYGj3ulDLq7j9cEx9sJ3WmD8mDZafbXFR5Wkl+rmpCHySy/FX
         hb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jUv4DHIW/jf9S8WLW0PtEsjOkKBjlj0vSuriaB+Qt8E=;
        b=HWUPqQRGK5ernqUiyu+agbud+b32Q5I7opeynZlFe0p1TO7R5PTzQSZcKu7/Gcfv+k
         CtAI2frIoPksugYT+j7UQhDRD1SqFyrCAorirRaiRGYrWVcmrMZ4SgO/KP/zd7bhydVn
         hzU8yWRbWbtp+0zUQ2s+LTcNMbq8Go1NZ8UlLPuw6FLOCE9NRQUySfTftud2iO3X2W63
         eQ5ITrlacy43tpZQSKeToblG+4pUzsRG5QrfuZvxxLWzC2rNe76CjVYdzKo7c0jftg5w
         IkCF6k+c5tc8YuW8yFzWqWDbIU4ZAVJzMfO9F3yuVQ23Lwayc9tYZVKzobHypBbE4WDr
         5Aww==
X-Gm-Message-State: ACgBeo1U7E1oV2qFQCW4mBtfPMosu6TGnQ9eP9QC0F/snqMOIoG/gUQN
        51VVEa9Aw3Me5y/jnJsIIJHhXuMcFf+zXVoXNTA=
X-Google-Smtp-Source: AA6agR60KPhLaUDDpE75SmK32fLcyUdmmWauNKhKvmIUnp3GPJYseoEjLta6QhF5LXEWhDck591iA/+DgKy5DObhXTE=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:1:6143:4baa:89b9])
 (user=ndesaulniers job=sendgmr) by 2002:a5b:3ca:0:b0:676:e468:2879 with SMTP
 id t10-20020a5b03ca000000b00676e4682879mr11554363ybp.239.1659456731748; Tue,
 02 Aug 2022 09:12:11 -0700 (PDT)
Date:   Tue,  2 Aug 2022 09:12:03 -0700
Message-Id: <20220802161203.622293-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Developer-Key: i=ndesaulniers@google.com; a=ed25519; pk=lvO/pmg+aaCb6dPhyGC1GyOCvPueDrrc8Zeso5CaGKE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1659456689; l=3416;
 i=ndesaulniers@google.com; s=20211004; h=from:subject; bh=oyWYempWhhw0KWZY55bZsDNwZFMaSWFofRJis1N1L/M=;
 b=42HGiJT3UIZyJGqLJXCvnn6Urd53yKrlQYq3xpzUzMPprOAanxKmz6+K6VfxxIR5QM3d1FzY4BGY
 m9/lY7ckDkA7WV9dzrS3p23C+Hs1HUrk4KbyKhniYaf3eg8PZ5nJ
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH] net: seg6: initialize induction variable to first valid array index
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following warnings observed when building
CONFIG_IPV6_SEG6_LWTUNNEL=y with clang:

  net/ipv6/seg6_local.o: warning: objtool: seg6_local_fill_encap() falls
  through to next function seg6_local_get_encap_size()
  net/ipv6/seg6_local.o: warning: objtool: seg6_local_cmp_encap() falls
  through to next function input_action_end()

LLVM can fully unroll loops in seg6_local_get_encap_size() and
seg6_local_cmp_encap(). One issue in those loops is that the induction
variable is initialized to 0. The loop iterates over members of
seg6_action_params, a global array of struct seg6_action_param calling
their put() function pointer members.  seg6_action_param uses an array
initializer to initialize SEG6_LOCAL_SRH and later elements, which is
the third enumeration of an anonymous union.

The guard `if (attrs & SEG6_F_ATTR(i))` may prevent this from being
called at runtime, but it would still be UB for
`seg6_action_params[0]->put` to be called; the unrolled loop will make
the initial iterations unreachable, which LLVM will later rotate to
fallthrough to the next function.

Make this more obvious that this cannot happen to the compiler by
initializing the loop induction variable to the minimum valid index that
seg6_action_params is initialized to.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 net/ipv6/seg6_local.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 2cd4a8d3b30a..b7de5e46fdd8 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1614,7 +1614,7 @@ static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
 	 * callback. If the callback is not available, then we skip to the next
 	 * attribute; otherwise, we call the destroy() callback.
 	 */
-	for (i = 0; i < max_parsed; ++i) {
+	for (i = SEG6_LOCAL_SRH; i < max_parsed; ++i) {
 		if (!(parsed_attrs & SEG6_F_ATTR(i)))
 			continue;
 
@@ -1643,7 +1643,7 @@ static int parse_nla_optional_attrs(struct nlattr **attrs,
 	struct seg6_action_param *param;
 	int err, i;
 
-	for (i = 0; i < SEG6_LOCAL_MAX + 1; ++i) {
+	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; ++i) {
 		if (!(desc->optattrs & SEG6_F_ATTR(i)) || !attrs[i])
 			continue;
 
@@ -1742,7 +1742,7 @@ static int parse_nla_action(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 	}
 
 	/* parse the required attributes */
-	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
+	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; i++) {
 		if (desc->attrs & SEG6_F_ATTR(i)) {
 			if (!attrs[i])
 				return -EINVAL;
@@ -1847,7 +1847,7 @@ static int seg6_local_fill_encap(struct sk_buff *skb,
 
 	attrs = slwt->desc->attrs | slwt->parsed_optattrs;
 
-	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
+	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; i++) {
 		if (attrs & SEG6_F_ATTR(i)) {
 			param = &seg6_action_params[i];
 			err = param->put(skb, slwt);
@@ -1927,7 +1927,7 @@ static int seg6_local_cmp_encap(struct lwtunnel_state *a,
 	if (attrs_a != attrs_b)
 		return 1;
 
-	for (i = 0; i < SEG6_LOCAL_MAX + 1; i++) {
+	for (i = SEG6_LOCAL_SRH; i < SEG6_LOCAL_MAX + 1; i++) {
 		if (attrs_a & SEG6_F_ATTR(i)) {
 			param = &seg6_action_params[i];
 			if (param->cmp(slwt_a, slwt_b))
-- 
2.37.1.455.g008518b4e5-goog

