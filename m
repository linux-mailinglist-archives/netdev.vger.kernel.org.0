Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFFA35AE2F
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbhDJOWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:22:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38067 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235002AbhDJOVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:21:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9633C5C0100;
        Sat, 10 Apr 2021 10:21:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        FUHslzvYmgsm4DwiiLlVZrO3anc/yGH5DAFpQv0uEQM=; b=EPbK56Sid9IwxkR2
        /3IIzvmZdFfDAr7e6OIkOGnJ7H0nqx1cMnzoTrOmj0mB624PL9nUpgxlNvUXX+Fx
        rQyk8J6bjO/GFAeBoVsH8YZn/OCmhcHgSfRBwF2mV+zaG1zTrbN46qJ3NlEKhTGX
        o2BOocerMEQSltkd3iO2C3vmMEF9gnbJOATFtNFy8tjOxmDS132fw/LDnYSI2ohg
        6Ok3xC4laZqWDKdeZYdkEOyFniXb4JC8p85jQG/UeJjxdl5CyKW1v6DEOuEJQLuX
        WvfAE3feSu6p3KLeK1otFN5xrgZgZgWHwVNFYtt6q68f9hfjhxrCjSBnHXCFLHzq
        pWdZfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=FUHslzvYmgsm4DwiiLlVZrO3anc/yGH5DAFpQv0uE
        QM=; b=RmeLDrhYYDgawyl60d+zaeZAvgCs5zyXKeAzHEm4vjcUgt3+yon2kCrHA
        zlwTud+yd6qzU02cWZ0oL2SAxTi5ZKJMFHp+tX3uiBVMvUvfoaHYuda3Xi5wlapG
        BSPxpYuoK6Ftnavj8PBZL6EgjsXptL5GtiHu+ZvOB25vBwpJ+ie7jVP5OSOwPt+4
        +jlrQT8Uj4S8o7njgNgGo8qAAHYB0igmbU6W2TxfP4kQRzGtBKZkuaJlpSfBzMk9
        MLRZK3645KxyKwz2H99uH/SLjl2uIuExeXjHFHTWaJxN+Sm18NtbyRS5g2BohP9c
        Y03/DEuk+E/QpuRF100H6Qwyw33/w==
X-ME-Sender: <xms:YbRxYAhe9sdfF5fk8i40rMso3nkNdrTn6cmA8R6iIM-K5SFgHqdNPA>
    <xme:YbRxYJBVt2P3HR-KL-h-1L4GigYAcMHFOiV6Fx8OBTN7RL76_Qp9HhzjC7KMIHCg0
    NBz_9HwRqnYJlc1oA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvfffjghftggfggfgsehtje
    ertddtreejnecuhfhrohhmpeevhhhrihhsucfvrghlsghothcuoegthhhrihhssehtrghl
    sghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepgefhtdfhgfeklefgueevte
    dtfeejjefhvdetheevudfgkeeghefhleelvdeuieegnecukfhppeejvddrleehrddvgeef
    rdduheeinecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomh
    eptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:YbRxYIEmD-QNtpEupivEJVgZisy6yAyTBVeHMLzsFCf5v_lJAV3j3g>
    <xmx:YbRxYBS32liumLWGDJ_u8FkL7p2whb0n_bAGdEMYqeSLwXDQgymwDA>
    <xmx:YbRxYNyvT7DewMUQnZBaRmO5rNuHBJNxNhFpGcmRQHj-9X7OabNeeA>
    <xmx:YbRxYOoQIklqvIxj_Szyn7t-mUvpRCF_TD7frjTtNa5WkHdTF98WlA>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53F081080063;
        Sat, 10 Apr 2021 10:21:21 -0400 (EDT)
Message-ID: <eee886683aa0cbf57ec3f0c8637ba02bc01600d6.camel@talbothome.com>
Subject: [PATCH 4/9] Fix issue if there is an empty string in encoded text
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm
Date:   Sat, 10 Apr 2021 10:21:21 -0400
In-Reply-To: <178dd29027e6abb4a205e25c02f06769848cbb76.camel@talbothome.com>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
         <b23ba0656ea0d58fdbd8c83072e017f63629f934.camel@talbothome.com>
         <df512b811ee2df6b8f55dd2a9fb0178e6e5c490f.camel@talbothome.com>
         <178dd29027e6abb4a205e25c02f06769848cbb76.camel@talbothome.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A swedish carrier sends an empty string in the subject line. This
patch allows mmsd to handle it
---
 src/mmsutil.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/mmsutil.c b/src/mmsutil.c
index 9430bf1..615198f 100644
--- a/src/mmsutil.c
+++ b/src/mmsutil.c
@@ -297,6 +297,13 @@ static gboolean extract_encoded_text(struct
wsp_header_iter *iter, void *user)
 	p = wsp_header_iter_get_val(iter);
 	l = wsp_header_iter_get_val_len(iter);
 
+	if(l == 0) {
+		DBG("Length is 0! Returning empty string");
+		dec_text = g_strdup("");
+		*out = dec_text;
+		return TRUE;
+	}
+
 	switch (wsp_header_iter_get_val_type(iter)) {
 	case WSP_VALUE_TYPE_TEXT:
 		/* Text-string */
-- 
2.30.2

