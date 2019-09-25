Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED0CBDF3B
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 15:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406790AbfIYNo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 09:44:57 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57998 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406646AbfIYNo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 09:44:57 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: aratiu)
        with ESMTPSA id 34818280400
From:   Adrian Ratiu <adrian.ratiu@collabora.com>
To:     brcm80211-dev-list.pdl@broadcom.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martyn Welch <martyn.welch@collabora.com>
Subject: [PATCH 1/2] brcmfmac: don't WARN when there are no requests
Date:   Wed, 25 Sep 2019 16:44:57 +0300
Message-Id: <20190925134458.1413790-1-adrian.ratiu@collabora.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When n_reqs == 0 there is nothing to do so it doesn't make sense to
search for requests and issue a warning because none is found.

Signed-off-by: Martyn Welch <martyn.welch@collabora.com>
Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index 14e530601ef3..fabfbb0b40b0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -57,6 +57,10 @@ static int brcmf_pno_remove_request(struct brcmf_pno_info *pi, u64 reqid)
 
 	mutex_lock(&pi->req_lock);
 
+	/* Nothing to do if we have no requests */
+	if (pi->n_reqs == 0)
+		goto done;
+
 	/* find request */
 	for (i = 0; i < pi->n_reqs; i++) {
 		if (pi->reqs[i]->reqid == reqid)
-- 
2.23.0

