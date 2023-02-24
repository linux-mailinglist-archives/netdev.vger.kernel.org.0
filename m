Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0806A2151
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBXSTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjBXSTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:19:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C9215CA9;
        Fri, 24 Feb 2023 10:19:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDBE7B81CDB;
        Fri, 24 Feb 2023 18:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB154C433EF;
        Fri, 24 Feb 2023 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677262744;
        bh=0IIw9DZAnEN+iECLwksXxerTHqhiQ9T5jJaQpxy1MiQ=;
        h=From:Date:Subject:To:Cc:From;
        b=S4HDlrS/2uOJcO/d4I3dHjnLvErl5orZpYAVy8Lt3pde75WGo3NIZCWpxITaYh6nA
         nfYhvBotSkuw0sVphH/mbHsyD/jjZaG3seE397kxBtL5JK8WpIgabej7FoJakTwAeF
         YBwjVpYu3Adt/AEklQoAY05KZ5RIUXAWTi8XVh9Ab3s5J2tcwzay7klKqFxuJhY+ey
         mlq4bhlZgcwvMMAbmYlTwvyfF9Yq+TRdpOSaMqsfm+XJy8YZTtlwu0liw/xq3johiK
         1uIpl7oA5wck6PoK1UeWAGD9Vy+P4SsnlS9/bd7tvLgCi2FMWwS7zcDRGWJClfjC5j
         69xgtax7NvW0A==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Fri, 24 Feb 2023 11:18:49 -0700
Subject: [PATCH net] net/sched: cls_api: Move call to
 tcf_exts_miss_cookie_base_destroy()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-cls_api-wunused-function-v1-1-12c77986dc2d@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIj/+GMC/x2N0QrCMAxFf2Xk2UBXBzJ/RUSyNnUBjaNpVRj7d
 zsfD5dz7grGWdjg3K2Q+S0mL23QHzoIM+mdUWJj8M4fnfcDhofdaBH8VK3GEVPVUJqE/YloHFL
 kNDpo+kTGOGXSMO+BJ1nhvA9L5iTf/+cFlAtct+0HGi5yGogAAAA=
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     paulb@nvidia.com, simon.horman@corigine.com,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1939; i=nathan@kernel.org;
 h=from:subject:message-id; bh=0IIw9DZAnEN+iECLwksXxerTHqhiQ9T5jJaQpxy1MiQ=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDMk//k+vOZYUqnF2lf7ElbnOgevVugoZFJn0QurPWi+bN
 flflaZpRykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIvFUMv9ke5LhvX+XwVyuM
 O3Mzg+vEeGv21Cc3G+s/L3Eucb58YCUjw+Kmr/+kXk1pbfrp+bf9YI/PzTtHDnaum5haeX57bEF
 dDSsA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_NET_CLS_ACT is disabled:

  ../net/sched/cls_api.c:141:13: warning: 'tcf_exts_miss_cookie_base_destroy' defined but not used [-Wunused-function]
    141 | static void tcf_exts_miss_cookie_base_destroy(struct tcf_exts *exts)
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Due to the way the code is structured, it is possible for a definition
of tcf_exts_miss_cookie_base_destroy() to be present without actually
being used. Its single callsite is in an '#ifdef CONFIG_NET_CLS_ACT'
block but a definition will always be present in the file. The version
of tcf_exts_miss_cookie_base_destroy() that actually does something
depends on CONFIG_NET_TC_SKB_EXT, so the stub function is used in both
CONFIG_NET_CLS_ACT=n and CONFIG_NET_CLS_ACT=y + CONFIG_NET_TC_SKB_EXT=n
configurations.

Move the call to tcf_exts_miss_cookie_base_destroy() in
tcf_exts_destroy() out of the '#ifdef CONFIG_NET_CLS_ACT', so that it
always appears used to the compiler, while not changing any behavior
with any of the various configuration combinations.

Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 3569e2c3660c..2a6b6be0811b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3241,9 +3241,9 @@ EXPORT_SYMBOL(tcf_exts_init_ex);
 
 void tcf_exts_destroy(struct tcf_exts *exts)
 {
-#ifdef CONFIG_NET_CLS_ACT
 	tcf_exts_miss_cookie_base_destroy(exts);
 
+#ifdef CONFIG_NET_CLS_ACT
 	if (exts->actions) {
 		tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
 		kfree(exts->actions);

---
base-commit: ac3ad19584b26fae9ac86e4faebe790becc74491
change-id: 20230224-cls_api-wunused-function-17aa94fdef90

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

