Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C6B571900
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiGLLwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiGLLvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:51:44 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E193EB31F0;
        Tue, 12 Jul 2022 04:51:41 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VJ87Zun_1657626697;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VJ87Zun_1657626697)
          by smtp.aliyun-inc.com;
          Tue, 12 Jul 2022 19:51:38 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net/smc: Extend SMC-R link group netlink attribute
Date:   Tue, 12 Jul 2022 19:51:30 +0800
Message-Id: <1657626690-60367-7-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1657626690-60367-1-git-send-email-guwen@linux.alibaba.com>
References: <1657626690-60367-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend SMC-R link group netlink attribute SMC_GEN_LGR_SMCR.
Introduce SMC_NLA_LGR_R_BUF_TYPE to show the buffer type of
SMC-R link group.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 include/uapi/linux/smc.h | 1 +
 net/smc/smc_core.c       | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 693f549..bb4dacc 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -124,6 +124,7 @@ enum {
 	SMC_NLA_LGR_R_V2,		/* nest */
 	SMC_NLA_LGR_R_NET_COOKIE,	/* u64 */
 	SMC_NLA_LGR_R_PAD,		/* flag */
+	SMC_NLA_LGR_R_BUF_TYPE,		/* u8 */
 	__SMC_NLA_LGR_R_MAX,
 	SMC_NLA_LGR_R_MAX = __SMC_NLA_LGR_R_MAX - 1
 };
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 9056ae8..f6ff42d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -347,6 +347,8 @@ static int smc_nl_fill_lgr(struct smc_link_group *lgr,
 		goto errattr;
 	if (nla_put_u8(skb, SMC_NLA_LGR_R_TYPE, lgr->type))
 		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_R_BUF_TYPE, lgr->buf_type))
+		goto errattr;
 	if (nla_put_u8(skb, SMC_NLA_LGR_R_VLAN_ID, lgr->vlan_id))
 		goto errattr;
 	if (nla_put_u64_64bit(skb, SMC_NLA_LGR_R_NET_COOKIE,
-- 
1.8.3.1

