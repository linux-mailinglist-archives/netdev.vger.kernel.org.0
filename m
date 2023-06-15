Return-Path: <netdev+bounces-11154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5185731C5D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:23:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E68741C20EBB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F9C15AE3;
	Thu, 15 Jun 2023 15:22:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA28C20F5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 15:22:58 +0000 (UTC)
X-Greylist: delayed 98194 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Jun 2023 08:22:56 PDT
Received: from zg8tmtyylji0my4xnjqunzqa.icoremail.net (zg8tmtyylji0my4xnjqunzqa.icoremail.net [162.243.164.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E5FE2121
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:22:56 -0700 (PDT)
Received: from localhost.localdomain (unknown [125.119.255.155])
	by mail-app4 (Coremail) with SMTP id cS_KCgD3_AnCLItkTPWABg--.33463S4;
	Thu, 15 Jun 2023 23:22:42 +0800 (CST)
From: Lin Ma <linma@zju.edu.cn>
To: jk@codeconstruct.com.au,
	matt@codeconstruct.com.au,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org
Cc: Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v1] net: mctp: remove redundant RTN_UNICAST check
Date: Thu, 15 Jun 2023 23:22:40 +0800
Message-Id: <20230615152240.1749428-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:cS_KCgD3_AnCLItkTPWABg--.33463S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtr17Jw4ftFyDAF4ruw4rXwb_yoWDWwc_Xr
	WDXry5G390ga48X397CayS9348Ww48Zw1kGFyFkFyDCw15Ww1rZrs7GrWrGr1xurWI9as0
	vFykZF90yF18CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb2AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_XrWl
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
	4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
	6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JU3Ma8UUUUU=
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Current mctp_newroute() contains two exactly same check against
rtm->rtm_type

static int mctp_newroute(...)
{
...
    if (rtm->rtm_type != RTN_UNICAST) { // (1)
        NL_SET_ERR_MSG(extack, "rtm_type must be RTN_UNICAST");
        return -EINVAL;
    }
...
    if (rtm->rtm_type != RTN_UNICAST) // (2)
        return -EINVAL;
...
}

This commits removes the (2) check as it is redundant.

Fixes: 83f0a0b7285b ("mctp: Specify route types, require rtm_type in RTM_*ROUTE messages")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/mctp/route.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index f51a05ec7162..ab62fe447038 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1249,9 +1249,6 @@ static int mctp_newroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 			mtu = nla_get_u32(tbx[RTAX_MTU]);
 	}
 
-	if (rtm->rtm_type != RTN_UNICAST)
-		return -EINVAL;
-
 	rc = mctp_route_add(mdev, daddr_start, rtm->rtm_dst_len, mtu,
 			    rtm->rtm_type);
 	return rc;
-- 
2.17.1


