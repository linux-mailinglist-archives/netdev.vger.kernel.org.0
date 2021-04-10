Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B801E35AE3B
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhDJOYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:24:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38389 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235100AbhDJOWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:22:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C28065C0131;
        Sat, 10 Apr 2021 10:22:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:22:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        VRjHKu+UQYboUnRFo4s7gUFIw24Z8qP6oOX5Tq/emog=; b=FiQelbNAmNAZ8j9W
        MGQwbIMI5/lzvnL5USdReeVGctJ6nqYlkp82tuu8deBjvda5AOfGcpeugx7ZC11Q
        65glFAyFj/j5YyMXsqhDQCwagWXxROWpVcpNo3Iz3pT4DFkKdto6HeGnEHuAw/KD
        m6bwXlr6OX4PFTIkicB5hX/qiwqo5DlWi4VmZylegqr9snV8Z3/SbKsn8Wt+ELmg
        YU9vAL0EkOAMPQaBPd4KHSxIZrGfUELrLQ08PrhaIvB8t4BqgtW/nTy3Vfafqwis
        xbLBwLW3RK93UfdqEZFiyDFVuLvyoq4trvnwNXiDYBaCBAB/5R4uu+tHkerDwhBj
        kXkJHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=VRjHKu+UQYboUnRFo4s7gUFIw24Z8qP6oOX5Tq/em
        og=; b=fDBgbLfoZRaphMst1hCBTYfUFgdwvwDhdyJ9NA6XE78oe0ndchAisum9p
        clSobhjXGAkEm6T2PfdVq+WB6FUjpcudBePj0esuuj1bxugqlsZLRSoR/Uk4U/km
        QjYsyExPaaj5DHC1Dp3RMZC3lOCmYwkTo/c3LBShknsKyY0t3Xu5oYFK4/+hnO3y
        N47Ra9X2AIxjEq3OZSGsnOT0ypf0c7C3WkT6xZJOxM5NUPOume4DWVQOlSYubsmA
        k0T6R71zDNaAsQrar1yC3D/1z9KhoTXO5rVDxhWbw/Of7o1HTpz8yJlqFPV9OnYM
        DiqD9INKvNnmEn2wvQKvSWoB1emWQ==
X-ME-Sender: <xms:jbRxYNrJKNVG8NKyyNjU3q5PzxmtGE5chnpYDvY_jp6J6av2TNhC7w>
    <xme:jbRxYPrppdBsST_g4eZyaKodiDxEyexr_eaaTYL0p2573TAWk3S5bUd3bMl6eSxgW
    l3xpq0IzdJlrP7EBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvfffjghftggfggfgsehtje
    ertddtreejnecuhfhrohhmpeevhhhrihhsucfvrghlsghothcuoegthhhrihhssehtrghl
    sghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepgefhtdfhgfeklefgueevte
    dtfeejjefhvdetheevudfgkeeghefhleelvdeuieegnecukfhppeejvddrleehrddvgeef
    rdduheeinecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomh
    eptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:jbRxYKOTs1yV7OqWSDIDT5RCzd1eTiY4COsa-jNpl2txZMeeGZjeQg>
    <xmx:jbRxYI66QYgKftG6asOWbUuTV9DLRM_CJIUb_qkCYLzGmHLfvzh6gg>
    <xmx:jbRxYM7Gw2w4pb_46eCsYznv1Hlt27Gg7g5YlU23ZfouzyyXPMG2SQ>
    <xmx:jbRxYKRJNKer6ThFV5A_fry_xD9Zm6DMMlZzPFGIBkYWT0fgQVHloQ>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7AAEA24005B;
        Sat, 10 Apr 2021 10:22:05 -0400 (EDT)
Message-ID: <9c67f5690bd4d5625b799f40e68fa54373617341.camel@talbothome.com>
Subject: [PATCH 5/9] Allow for a user configurable maximum attachment size
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm
Date:   Sat, 10 Apr 2021 10:22:05 -0400
In-Reply-To: <eee886683aa0cbf57ec3f0c8637ba02bc01600d6.camel@talbothome.com>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
         <b23ba0656ea0d58fdbd8c83072e017f63629f934.camel@talbothome.com>
         <df512b811ee2df6b8f55dd2a9fb0178e6e5c490f.camel@talbothome.com>
         <178dd29027e6abb4a205e25c02f06769848cbb76.camel@talbothome.com>
         <eee886683aa0cbf57ec3f0c8637ba02bc01600d6.camel@talbothome.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Android and iOS enforce a maximum attachment size for MMS messages.
This patch enforces a maximum attachment size for MMS messages and
makes it user configurable.

The Default maximum size is based off of Android, which has a maximum
MMS size of 1.1 Megabytes
---
 src/service.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/src/service.c b/src/service.c
index a3b90c5..dede36d 100644
--- a/src/service.c
+++ b/src/service.c
@@ -56,6 +56,7 @@
 
 #define MAX_ATTACHMENTS_NUMBER 25
 #define MAX_ATTEMPTS 3
+#define DEFAULT_MAX_ATTACHMENT_TOTAL_SIZE 1100000
 
 #define SETTINGS_STORE "mms"
 #define SETTINGS_GROUP "Settings"
@@ -100,6 +101,7 @@ struct mms_service {
 	GHashTable *messages;
 	GKeyFile *settings;
 	gboolean use_delivery_reports;
+	int max_attach_total_size;
 };
 
 enum mms_request_type {
@@ -146,7 +148,22 @@ static void mms_load_settings(struct mms_service
*service)
 		g_key_file_set_boolean(service->settings,
SETTINGS_GROUP,
 						"UseDeliveryReports",
 						service-
>use_delivery_reports);
+		error = NULL;
 	}
+
+	service->max_attach_total_size =
+		g_key_file_get_integer(service->settings,
SETTINGS_GROUP,
+						"TotalMaxAttachmentSiz
e", &error);
+
+	if (error) {
+		g_error_free(error);
+		service->max_attach_total_size =
DEFAULT_MAX_ATTACHMENT_TOTAL_SIZE;
+		g_key_file_set_integer(service->settings,
SETTINGS_GROUP,
+						"TotalMaxAttachmentSiz
e",
+						service-
>max_attach_total_size);
+	}
+	mms_debug("Maximum Attachment Total Size (in bytes): %d",
service->max_attach_total_size);
+
 }
 
 static void mms_request_destroy(struct mms_request *request)
@@ -414,10 +431,11 @@ static gboolean
send_message_get_recipients(DBusMessageIter *top_iter,
 }
 
 static gboolean send_message_get_attachments(DBusMessageIter
*top_iter,
-						struct mms_message
*msg)
+						struct mms_message
*msg, struct mms_service *service)
 {
 	DBusMessageIter attachments;
 	unsigned int attach_num = 0;
+	int attach_total_size = 0;
 
 	dbus_message_iter_recurse(top_iter, &attachments);
 
@@ -430,8 +448,10 @@ static gboolean
send_message_get_attachments(DBusMessageIter *top_iter,
 		struct mms_attachment *attach;
 		void *ptr;
 
-		if (++attach_num > MAX_ATTACHMENTS_NUMBER)
+		if (++attach_num > MAX_ATTACHMENTS_NUMBER) {
+			mms_error("Error: Too many attachments!");
 			return FALSE;
+		}
 
 		dbus_message_iter_recurse(&attachments, &entry);
 
@@ -466,6 +486,16 @@ static gboolean
send_message_get_attachments(DBusMessageIter *top_iter,
 			return FALSE;
 		}
 
+		attach_total_size = attach_total_size + attach-
>length;
+
+		mms_debug("Total attachment size: %d",
attach_total_size);
+		mms_debug("Maximum Attachment Total Size (in bytes):
%d", service->max_attach_total_size);
+
+		if (attach_total_size > service-
>max_attach_total_size) {
+			mms_error("Error: Total Attachment size too
large!");
+			return FALSE;
+		}
+
 		attach->data = ptr;
 
 		attach->content_id = g_strdup(id);
@@ -490,7 +520,7 @@ static gboolean
send_message_get_attachments(DBusMessageIter *top_iter,
 }
 
 static gboolean send_message_get_args(DBusMessage *dbus_msg,
-						struct mms_message
*msg)
+						struct mms_message
*msg, struct mms_service *service)
 {
 	DBusMessageIter top_iter;
 	const char *smil;
@@ -536,7 +566,7 @@ static gboolean send_message_get_args(DBusMessage
*dbus_msg,
 	if (dbus_message_iter_get_arg_type(&top_iter) !=
DBUS_TYPE_ARRAY)
 		return FALSE;
 
-	return send_message_get_attachments(&top_iter, msg);
+	return send_message_get_attachments(&top_iter, msg, service);
 }
 
 static struct mms_request *create_request(enum mms_request_type type,
-- 
2.30.2


