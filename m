Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03355E413
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfD2N6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:58:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58232 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727710AbfD2N6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 09:58:08 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7CD20C9C64512253D5B8;
        Mon, 29 Apr 2019 21:58:03 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Mon, 29 Apr 2019 21:57:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        <alexander@wetzel-home.de>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] mac80211: remove set but not used variable 'old'
Date:   Mon, 29 Apr 2019 14:07:54 +0000
Message-ID: <20190429140754.76537-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

net/mac80211/key.c: In function 'ieee80211_set_tx_key':
net/mac80211/key.c:271:24: warning:
 variable 'old' set but not used [-Wunused-but-set-variable]

It is not used since introduction in
commit 96fc6efb9ad9 ("mac80211: IEEE 802.11 Extended Key ID support")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/mac80211/key.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 20bf9db7a388..89f09a09efdb 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -268,11 +268,9 @@ int ieee80211_set_tx_key(struct ieee80211_key *key)
 {
 	struct sta_info *sta = key->sta;
 	struct ieee80211_local *local = key->local;
-	struct ieee80211_key *old;
 
 	assert_key_lock(local);
 
-	old = key_mtx_dereference(local, sta->ptk[sta->ptk_idx]);
 	sta->ptk_idx = key->conf.keyidx;
 	ieee80211_check_fast_xmit(sta);



