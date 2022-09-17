Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E165BB6A6
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 08:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiIQGbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 02:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIQGbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 02:31:06 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 518FD4A117;
        Fri, 16 Sep 2022 23:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Lgdgq
        /H/nA5I76joSevima0XH/B50fVoyAmtV+SUmos=; b=FgI44wACuIF23ZEdhRjuu
        TSNhgHbTPeyVCN9Aj0deZgfG6huDrXm4oeQuPx08tmZhywKLUzaK2F5DnR858P0t
        BcdXDst+4AelDhibTdAUM18kvYEFcQqr0N7q6Zq50W7YJN9QTSWfLi/1P63p9zrf
        U8kYYkT3mDhmNb305JgOZY=
Received: from DESKTOP-CE2KKHI.localdomain (unknown [124.160.210.227])
        by smtp4 (Coremail) with SMTP id HNxpCgDHeN+KaSVjeUn+dg--.624S2;
        Sat, 17 Sep 2022 14:30:35 +0800 (CST)
From:   williamsukatube@163.com
To:     dsahern@kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     William Dean <williamsukatube@163.com>
Subject: [PATCH -next] nexthop: simplify code in nh_valid_get_bucket_req
Date:   Sat, 17 Sep 2022 14:30:31 +0800
Message-Id: <20220917063031.2172-1-williamsukatube@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgDHeN+KaSVjeUn+dg--.624S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFWkWw1UKrWUtr45uFykXwb_yoW3Arg_Gr
        n7XrZrXrsFqFyfCw4UCF45Aa4xKr4ruFWrua92qa97Ja47AFsY9w4kGF98CrZ7WrWkGry7
        WF1fKrWjyF9rZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_8nY3UUUUU==
X-Originating-IP: [124.160.210.227]
X-CM-SenderInfo: xzlozx5dpv3yxdwxuvi6rwjhhfrp/xtbBiAt-g1aECq0k2gAAs0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Dean <williamsukatube@163.com>

It could directly return 'nh_valid_get_bucket_req_res_bucket' to simplify code.

Signed-off-by: William Dean <williamsukatube@163.com>
---
 net/ipv4/nexthop.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 853a75a8fbaf..1556961cf153 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -3489,12 +3489,8 @@ static int nh_valid_get_bucket_req(const struct nlmsghdr *nlh,
 		return -EINVAL;
 	}

-	err = nh_valid_get_bucket_req_res_bucket(tb[NHA_RES_BUCKET],
+	return nh_valid_get_bucket_req_res_bucket(tb[NHA_RES_BUCKET],
 						 bucket_index, extack);
-	if (err)
-		return err;
-
-	return 0;
 }

 /* rtnl */
--
2.25.1

