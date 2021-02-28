Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84703272E1
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhB1PT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:19:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230212AbhB1PTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:19:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614525506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oBgnfLo+d/dBvpawLqs1HKruHJv8Tx0bnqG3j9bT2vE=;
        b=E8GByHAJiXjA2I5N9RJ6iKw5vq/+e1Xl2QLwtjE8qzXyYHuVLaFxVvSjmXa2Rnajbo4YPa
        mNBJmvAejW/ncabuVvJ9ckci6XFmgdmU+K5zzNDCEcjsD8XFVul9yA2QEqU4WW5vQzIcOE
        Km6VLr5D7OeRauXpn80L8Zgm8o73FTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-IUULfvWeOu67abUDtmYARA-1; Sun, 28 Feb 2021 10:18:23 -0500
X-MC-Unique: IUULfvWeOu67abUDtmYARA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C719E1936B61;
        Sun, 28 Feb 2021 15:18:22 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-112-225.rdu2.redhat.com [10.10.112.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 628AB5C1D5;
        Sun, 28 Feb 2021 15:18:21 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wpan 01/17] net: ieee802154: make shift exponent unsigned
Date:   Sun, 28 Feb 2021 10:18:01 -0500
Message-Id: <20210228151817.95700-2-aahringo@redhat.com>
In-Reply-To: <20210228151817.95700-1-aahringo@redhat.com>
References: <20210228151817.95700-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the iftype type variable to unsigned that it can
never be reach a negative value.

Reported-by: syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/ieee802154/nl802154.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index e9e4652cd592..3ee09f6d13b7 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -898,8 +898,8 @@ static int nl802154_get_interface(struct sk_buff *skb, struct genl_info *info)
 static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg802154_registered_device *rdev = info->user_ptr[0];
-	enum nl802154_iftype type = NL802154_IFTYPE_UNSPEC;
 	__le64 extended_addr = cpu_to_le64(0x0000000000000000ULL);
+	u32 type = NL802154_IFTYPE_UNSPEC;
 
 	/* TODO avoid failing a new interface
 	 * creation due to pending removal?
-- 
2.26.2

