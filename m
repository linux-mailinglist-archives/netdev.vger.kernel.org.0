Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC6F35AE16
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhDJOUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:20:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36835 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234519AbhDJOUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:20:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 920935C0189;
        Sat, 10 Apr 2021 10:20:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:20:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        CJqY00XdomyeCtNxnwgXbX8urx12xkl4eFktcz1wACs=; b=5/5bMGIYrF9cQF6Q
        0HPum+ZPHc10yL0rBP5tJdxXUd4e63Ea/MjF56UPQu3r6oKr+FFq+HV0oERPSAgH
        NrYXyt7F7j9BL2jsPTXuATR6dt0SKc52TIITEWqPx51pKgQn1X5cxC5B/iIsUEEl
        e8++x68LyQBfGmCrJ719weRtB8rEefM5Mb8iEoox7p1Llr5FpSqGa1knErSUUtP/
        Qbrsvb8z1GqRuYpiU6rwsvCkCWrOxFJvb60zjz1giUd98fU+mM8DSMpZ1IwiUlax
        Dd93hznqGq0/wNtVg+6lF7ynrgJgdUg4PnQ2skTs66J+FdYuySqAFHAU/GZ6mjFc
        xQrNsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=CJqY00XdomyeCtNxnwgXbX8urx12xkl4eFktcz1wA
        Cs=; b=XQ7ekfLdCxn0ZnirbFP03fYsTFtzmDFhITBPA8xTtElDH7EyKjmtztFzK
        rHK7Gd1fy5+F9AiuLqwXscSk95F0f533rFW0JHVYtBcGvaKVIkkh541BbgcIV9vy
        pRdo0UY3shw5F3HA0Qm3hGQOyCXxYDBKTTe5rOtOwXMkjle8AF2GnD1xZxfqdsoO
        QDv5AIK32Q8BprkcXovRwm7PVaYu1YXRiNIMFDYxF0y7Cw/ctAJcTQnKQZTsTGKF
        8N8LGNqM9s/K0KOr0eDrE+fnJhDCF8LcAuWIW2sEkP0GlZrtQVBHj77cUn1garc9
        y1TX9DbzsAsQjNadpQcpR44id5GbA==
X-ME-Sender: <xms:I7RxYIhfdA4RjCStuA12GNjqaTXN9-1iSZtnOpKIvtni_wN8oGg2KA>
    <xme:I7RxYBD5tv5r2qNhnen0Xgbo-cEvCmO335PgU_XAhm2iz5E_8ItkxvHzvkqlNuT9g
    fRxOQZ4LwH4V7dlMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvfffjghftggfggfgsehtje
    ertddtreejnecuhfhrohhmpeevhhhrihhsucfvrghlsghothcuoegthhhrihhssehtrghl
    sghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepgefhtdfhgfeklefgueevte
    dtfeejjefhvdetheevudfgkeeghefhleelvdeuieegnecukfhppeejvddrleehrddvgeef
    rdduheeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:I7RxYAHEzEm-ScgxezrPx3K7Tk7EvUXEJAQDPE8sEHBzq1u4ggZ_dQ>
    <xmx:I7RxYJTGFzj7V71wo4yYClqoUEEZM2--9hJ-k47MscICL_aZnzxw5A>
    <xmx:I7RxYFxJPOPHj0q0xMk5psuCb-J7_PdwQLLfLOl6L_1r8Kch2yoPgg>
    <xmx:JLRxYGqQIbq0T5OBvkMDfuszYu9OQqnYWg5Q1Vy5SHKXNUmNMX44Rw>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id B92171080057;
        Sat, 10 Apr 2021 10:20:19 -0400 (EDT)
Message-ID: <df512b811ee2df6b8f55dd2a9fb0178e6e5c490f.camel@talbothome.com>
Subject: [PATCH 2/9] Ensure Compatibility with Telus Canada
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm
Date:   Sat, 10 Apr 2021 10:20:19 -0400
In-Reply-To: <b23ba0656ea0d58fdbd8c83072e017f63629f934.camel@talbothome.com>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
         <b23ba0656ea0d58fdbd8c83072e017f63629f934.camel@talbothome.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Telus Canada makes mmsd decode a header that is not in the standard.
This patch allows this header to be decoded and allows for MMS support
in Telus Canada.
---
 src/mmsutil.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/src/mmsutil.c b/src/mmsutil.c
index 5fcf358..9430bf1 100644
--- a/src/mmsutil.c
+++ b/src/mmsutil.c
@@ -732,10 +732,9 @@ static header_handler handler_for_type(enum
mms_header header)
 		return extract_text;
 	case MMS_HEADER_INVALID:
 	case __MMS_HEADER_MAX:
+	default:
 		return NULL;
 	}
-
-	return NULL;
 }
 
 struct header_handler_entry {
@@ -781,8 +780,17 @@ static gboolean mms_parse_headers(struct
wsp_header_iter *iter,
 
 		handler = handler_for_type(h);
 		if (handler == NULL) {
-			DBG("no handler for type %u", h);
-			return FALSE;
+			if(h == MMS_HEADER_INVALID) {
+				DBG("no handler for type %u", h);
+				return FALSE;
+			} else if (h == __MMS_HEADER_MAX) {
+				DBG("no handler for type %u", h);
+				return FALSE;
+			} else {
+				/*  Telus has strange headers, so this
handles it */
+				DBG("type isn't a part of the
standard? Skipping %u", h);
+				continue;
+			}
 		}
 
 		DBG("saw header of type %u", h);
-- 
2.30.2

