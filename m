Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A7963B92B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 05:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiK2El4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 23:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbiK2Elt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 23:41:49 -0500
X-Greylist: delayed 373 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Nov 2022 20:41:48 PST
Received: from pv50p00im-zteg10011501.me.com (pv50p00im-zteg10011501.me.com [17.58.6.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2B232BBE
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 20:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1669696535;
        bh=gqMG1+v4/My2KUXkGkqNVJ/uFJ0mxXw/w4pdKkF5idQ=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=AGL7RMNR+K4S6h4eHYj5m0WHMR5igxt7ZDGSdhNCOOKMyDK7TqHYe/Hz9m3SJ6XfV
         wk+2gCzytBPmsJPfG7ujGYdezsLayiwFzYIlZ7O5cdFSeC3n5ezcBiN9qdlVO5iYh2
         xpjVHuIQDAe0FqRdOPUmiPnLMYNbLPhS1iKwN5GG39o/DJifB59aZSHw4Tm6FMfn/H
         g7fGKZR0ArhrCHxXggpK8pbZbQPr3vz+lPAhWWJkf/T6fTOhxF2ererJKRmCm7tOpg
         s6dKzvxia15jczGE259VJlBqcrSfs+rNqdlZ96eq9lsbu26LqcEQm5O+h5buMf6K7H
         gHYVvaW0nb17Q==
Received: from vanilla.lan (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-zteg10011501.me.com (Postfix) with ESMTPSA id 1A03E2E0A11;
        Tue, 29 Nov 2022 04:35:31 +0000 (UTC)
From:   JunASAKA <JunASAKA@zzy040330.moe>
To:     Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        JunASAKA <JunASAKA@zzy040330.moe>
Subject: [PATCH] drivers: rewrite and remove a superfluous parameter.
Date:   Tue, 29 Nov 2022 12:34:42 +0800
Message-Id: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: O2CodvTiGlUoqhNMPHn2VKKzHfLnRfAk
X-Proofpoint-GUID: O2CodvTiGlUoqhNMPHn2VKKzHfLnRfAk
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.883,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F08:2022-06-21=5F01,2022-06-21=5F08,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=602
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 clxscore=1030
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2211290029
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed there is a superfluous "*hdr" parameter in rtl8xxxu module
when I am trying to fix some bugs for the rtl8192eu wifi dongle. This
parameter can be removed and then gained from the skb object to make the
function more beautiful.

Signed-off-by: JunASAKA <JunASAKA@zzy040330.moe>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index ac641a56efb0..4c3d97e8e51f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4767,9 +4767,10 @@ static u32 rtl8xxxu_80211_to_rtl_queue(u32 queue)
 	return rtlqueue;
 }
 
-static u32 rtl8xxxu_queue_select(struct ieee80211_hdr *hdr, struct sk_buff *skb)
+static u32 rtl8xxxu_queue_select(struct sk_buff *skb)
 {
 	u32 queue;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	if (ieee80211_is_mgmt(hdr->frame_control))
 		queue = TXDESC_QUEUE_MGNT;
@@ -5118,7 +5119,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	if (control && control->sta)
 		sta = control->sta;
 
-	queue = rtl8xxxu_queue_select(hdr, skb);
+	queue = rtl8xxxu_queue_select(skb);
 
 	tx_desc = skb_push(skb, tx_desc_size);
 
-- 
2.38.1

