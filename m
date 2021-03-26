Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C62234A5D9
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhCZKvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:51:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53277 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230022AbhCZKux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:50:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4A91B5C070A
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:50:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 26 Mar 2021 06:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=a8KqjxTrvysHAqftoheby3QlpL
        QG9qIqt6QzMUYXEtU=; b=zCAKeG/pTR/GAuXB8PJz8qKDtFSnekK7ubu2mkYmNP
        HSKPj14wvHszZqPPb2OFaGu93D3/mQO/pg+1+aYhj9ufekDUQ+IQltkcoVMR4xf8
        fCkKWuYhZu0+R510clD3zwZ82nV9onUu8dBFFRLhjrdDHvmh9U48KU9Rv7vA1QtH
        Hd3+sOxEoL6tf+TpY0F7KcDoLO//ZLnOY+xGa/jFq/p1yaIV7HU1QtbJwqPu7iGr
        pjKV6OvEzyXBgz4JFv32CuaX+OLdiSJX76iOTaEEludMKmqhgNpeHp1l711ZHfqo
        ORDFeWOS80T8VObny8JhOWwblKVeKIuCkjcATP8jyrOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=a8Kqjx
        TrvysHAqftoheby3QlpLQG9qIqt6QzMUYXEtU=; b=Uz6iVBsKq64Zo3AHa8ipCc
        FhlxqF9IcsYi/jGBlXZupQRHOnpgzuHdDXIL1vxxt77w2uw1tBZysPj28Yetprz0
        uxl92YM4R8wb5jIvv22GAVSNWjFXvK8/Vt3EQr3/mMZx778Td9hJSFI3jdfqJ87x
        wIt3WXz5AygNoNPmAGhbp5UvsrDxRW6w/Ny03Goq6465RooUoLiBYP2vjkM+yiH2
        z2r52mv8Kt+D9T3y6IdMgB+NPV1ET9FCk8coe5BXOqpz1dBpq9ktC/dvzTrDPXnn
        TgXmjT5GZGRH+73FHDa8Dj6F/R7Ahe9fwhkUDIqpJZdK11UqcQFmY0RgLAG6V/BQ
        ==
X-ME-Sender: <xms:jbxdYMwzTu8LmU4if6YJEQL22udmErK31EC8ak34NSP1w6QG_O8tRA>
    <xme:jbxdYARy2xaeexPoW8XsjPfB15WWKMvbCIm9YTgCrQUhc_BCQhdvCpatC2-eF8uhN
    9gO3U7izEsfV0kZwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvffftggfggfgsehtjeertd
    dtreejnecuhfhrohhmpeevhhhrihhsthhophhhvghrucfvrghlsghothcuoegthhhrihhs
    sehtrghlsghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepieeitdevveegje
    euveeflefhhfeffeeijeffffeiteeifffhveeigeeghfevffdunecukfhppeejvddrleeh
    rddvgeefrdduheeinecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilh
    hfrhhomheptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:jbxdYOV7727LdlP-v1KB-NssyGmjU4WQAxC82L0PM_Wl_5y5iMwc0Q>
    <xmx:jbxdYKjqRnerDFOoJFjSXY_s25ii5hGm_52dDAlC6mEj6wn85CkhBw>
    <xmx:jbxdYOCdKL9iquJNDzOiLVh0vhk7CGEzaE7O9X_wc3C_cmVJOAiewg>
    <xmx:jbxdYBPMDCgVY0OjAPg5_w7VVksq3H1OBc5toDQEb-oBlfYsxz-zHQ>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D408240068
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:50:53 -0400 (EDT)
Message-ID: <7e6ec700d812d9d3a8d2ec6a621118dad2f8e9dd.camel@talbothome.com>
Subject: [PATCH 4/9] Fix issue if there is an empty string in encoded text
From:   Christopher Talbot <chris@talbothome.com>
To:     netdev@vger.kernel.org
Date:   Fri, 26 Mar 2021 06:50:52 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
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
 
+       if(l == 0) {
+               DBG("Length is 0! Returning empty string");
+               dec_text = g_strdup("");
+               *out = dec_text;
+               return TRUE;
+       }
+
        switch (wsp_header_iter_get_val_type(iter)) {
        case WSP_VALUE_TYPE_TEXT:
                /* Text-string */
-- 
2.30.0

