Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36F535AE3E
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbhDJOZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:25:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50995 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234849AbhDJOX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:23:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EBE345C00F9;
        Sat, 10 Apr 2021 10:23:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        lb3u5Lv1LdA/SIutJO+VdzIOW4VJ848VilRXmjjIhew=; b=mNxq4A70xBeoaI96
        e3Xgs3wEyQC+6dEwNHC5B5RPyYQj6dig7s0FLqXo1VOX32hUq7XpVwDnONJN6+g5
        ISbGsPz9jXiUiE2b2nMC4sC10sRu4MjSm6qGz1jrRKvH9X7tnm4JCxHVFyfWT0S2
        I05i19P8l7IAcgfhRmXq9SqhspGoEAtQ2C9TyiMB9bPdSlKH2x1R2d9qkQdsk2JY
        6/c93Ekg0hePkBMuZw6uSY8G0YFmKE7QQfJ1RDyz/lMZ4QElJBzbmw0k70Q5uuTi
        AFQTZ1gSDDrj5Zu7BTNXRvm6qe+uVpuQLIKToS41BrXvvYj1TO+qoSibCyB+0aB8
        LX1sIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=lb3u5Lv1LdA/SIutJO+VdzIOW4VJ848VilRXmjjIh
        ew=; b=N6esOIZzP8qZbsD5J+50og0Lzf/x697Layio6/mFh/ziGIPSSoEgIb4oE
        HzyPodxgkB/I/jMhfzi85sAN46rFp75DiiBbZ1ytm7RDkO5qzcRvXHcKfSG6dTnn
        ZNLLkTq7U0g9HQDPYm3BjmCFzVp82QoSU46NTqtXt+/APQYBSeL/Mk4SPVSPTkPF
        FV3oPRWesQvZW2C9DpdWiR9lPI8tK1yDXKy5IM1W8+NDvZ5DgWpCDuC5ZQWGI02K
        z/de2gZ7NqYj8Dgi6YGPIp9r6pL9JXFWBzEJBFlziiTWS5BzKtDNImB/avq7s83Y
        ZYvgiUEndoY0F9t7roEZHN/xTWI3g==
X-ME-Sender: <xms:0LRxYJzS3KV2U1I2C66MjxGHdrd0m6FoUmvV-9WFMoxb5_4MSWSTvQ>
    <xme:0LRxYJTwA7zS2qwKrHUGBDULY4aHShfWWG6NgzUcY0XhTsdZa8WfLLWHfSeQ6WAIy
    sRSx4GZToP4iunzQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvfffjghftggfggfgsehtje
    ertddtreejnecuhfhrohhmpeevhhhrihhsucfvrghlsghothcuoegthhhrihhssehtrghl
    sghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepgefhtdfhgfeklefgueevte
    dtfeejjefhvdetheevudfgkeeghefhleelvdeuieegnecukfhppeejvddrleehrddvgeef
    rdduheeinecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomh
    eptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:0LRxYDW_oq8K0FrwjkcVlo2lFjo_9QBMHoHY2474lEDQzA3k7GpvCQ>
    <xmx:0LRxYLhz1H8eluoegxZZXlyOfmzYP9uoyLEe_TXV2mGVZRIJe1UQsg>
    <xmx:0LRxYLBZUMe8r1eljzgSkSICbVPyWR4zytupL5msX7DwZoK8VduZ5A>
    <xmx:0LRxYA4-MYtQfziYr166rJtE7vdCFJBISk7an-HIzw9ypW74FBP0eQ>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9017C240054;
        Sat, 10 Apr 2021 10:23:12 -0400 (EDT)
Message-ID: <9f9d0f40db75ff82a306af14e7879e567dce9821.camel@talbothome.com>
Subject: [PATCH 7/9] Fix Draft and Sent Bugs
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm
Date:   Sat, 10 Apr 2021 10:23:12 -0400
In-Reply-To: <85928d2def5893cd90f823b563369e313e993084.camel@talbothome.com>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
         <b23ba0656ea0d58fdbd8c83072e017f63629f934.camel@talbothome.com>
         <df512b811ee2df6b8f55dd2a9fb0178e6e5c490f.camel@talbothome.com>
         <178dd29027e6abb4a205e25c02f06769848cbb76.camel@talbothome.com>
         <eee886683aa0cbf57ec3f0c8637ba02bc01600d6.camel@talbothome.com>
         <9c67f5690bd4d5625b799f40e68fa54373617341.camel@talbothome.com>
         <85928d2def5893cd90f823b563369e313e993084.camel@talbothome.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a few bugs:
- Makes sure "sent" has an accurate time
- Allows "Draft" to Go to "Sent" on the dbus
- Allows the time to be preserved if mmsd is closed and opened
---
 src/mmsutil.h |  2 ++
 src/service.c | 60 +++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/src/mmsutil.h b/src/mmsutil.h
index 00ecc39..ec139f1 100644
--- a/src/mmsutil.h
+++ b/src/mmsutil.h
@@ -120,12 +120,14 @@ struct mms_retrieve_conf {
 	char *priority;
 	char *msgid;
 	time_t date;
+ 	char *datestamp;
 };
 
 struct mms_send_req {
 	enum mms_message_status status;
 	char *to;
 	time_t date;
+ 	char *datestamp;
 	char *content_type;
 	gboolean dr;
 };
diff --git a/src/service.c b/src/service.c
index dede36d..b0c2428 100644
--- a/src/service.c
+++ b/src/service.c
@@ -18,6 +18,7 @@
  *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-
1301  USA
  *
  */
+#define _XOPEN_SOURCE 700
 
 #ifdef HAVE_CONFIG_H
 #include <config.h>
@@ -35,6 +36,8 @@
 #include <glib.h>
 #include <glib/gstdio.h>
 #include <gdbus.h>
+#include <time.h>
+#include <stdio.h>
 
 #include <gweb/gweb.h>
 
@@ -129,6 +132,11 @@ static DBusConnection *connection;
 
 static guint32 transaction_id_start = 0;
 
+
+static const char *time_to_str(const time_t *t);
+void debug_print(const char* s, void* data);
+
+
 static void mms_load_settings(struct mms_service *service)
 {
 	GError *error;
@@ -220,6 +228,7 @@ static void emit_msg_status_changed(const char
*path, const char *new_status)
 
 	signal = dbus_message_new_signal(path, MMS_MESSAGE_INTERFACE,
							"PropertyChanged");
+							
 	if (signal == NULL)
 		return;
 
@@ -269,6 +278,7 @@ static DBusMessage *msg_mark_read(DBusConnection
*conn,
 	g_free(state);
 
 	g_key_file_set_boolean(meta, "info", "read", TRUE);
+	mms->rc.status = MMS_MESSAGE_STATUS_READ;
 
 	mms_store_meta_close(service->identity, mms->uuid, meta,
TRUE);
 
@@ -722,6 +732,7 @@ static gboolean result_request_send_conf(struct
mms_request *request)
 
 	g_key_file_set_string(meta, "info", "state", "sent");
 	g_key_file_set_string(meta, "info", "id", msg->sc.msgid);
+	request->msg->sr.status = MMS_MESSAGE_STATUS_SENT;
 
 	mms_message_free(msg);
 
@@ -1047,6 +1058,7 @@ static DBusMessage *send_message(DBusConnection
*conn,
 	struct mms_service *service = data;
 	struct mms_request *request;
 	GKeyFile *meta;
+	const char *datestr;
 
 	msg = g_new0(struct mms_message, 1);
 	if (msg == NULL)
@@ -1059,7 +1071,13 @@ static DBusMessage *send_message(DBusConnection
*conn,
 
 	msg->sr.dr = service->use_delivery_reports;
 
-	if (send_message_get_args(dbus_msg, msg) == FALSE) {
+	time(&msg->sr.date);
+
+	datestr = time_to_str(&msg->sr.date);
+
+	msg->sr.datestamp = g_strdup(datestr);
+
+	if (send_message_get_args(dbus_msg, msg, service) == FALSE) {
 		mms_debug("Invalid arguments");
 
 		release_attachement_data(msg->attachments);
@@ -1099,6 +1117,7 @@ static DBusMessage *send_message(DBusConnection
*conn,
 	if (meta == NULL)
 		goto release_request;
 
+	g_key_file_set_string(meta, "info", "date",  msg-
>sr.datestamp);
 	g_key_file_set_string(meta, "info", "state", "draft");
 
 	if (service->use_delivery_reports) {
@@ -1339,10 +1358,12 @@ static gboolean load_message_from_store(const
char *service_id,
 	char *state = NULL;
 	gboolean read_status;
 	char *data_path = NULL;
+	char *datestr = NULL;
 	gboolean success = FALSE;
 	gboolean tainted = FALSE;
 	void *pdu;
 	size_t len;
+	struct tm tm;
 
 	meta = mms_store_meta_open(service_id, uuid);
 	if (meta == NULL)
@@ -1354,6 +1375,13 @@ static gboolean load_message_from_store(const
char *service_id,
 
 	read_status = g_key_file_get_boolean(meta, "info", "read",
NULL);
 
+	datestr = g_key_file_get_string(meta, "info", "date", NULL);
+	if (datestr != NULL) {
+		strptime(datestr, "%Y-%m-%dT%H:%M:%S%z", &tm);
+	} else {
+		mms_error("src/service.c:load_message_from_store()
There is no date stamp!");
+	}
+    
 	data_path = mms_store_get_path(service_id, uuid);
 	if (data_path == NULL)
 		goto out;
@@ -1372,25 +1400,28 @@ static gboolean load_message_from_store(const
char *service_id,
 
 	msg->uuid = g_strdup(uuid);
 
-	if (strcmp(state, "received") == 0
-			&& msg->type ==
MMS_MESSAGE_TYPE_RETRIEVE_CONF) {
+	if (strcmp(state, "received") == 0 && msg->type ==
MMS_MESSAGE_TYPE_RETRIEVE_CONF) {
+        msg->rc.datestamp = g_strdup(datestr);
+        msg->rc.date = mktime(&tm);
 		if (read_status == TRUE)
 			msg->rc.status = MMS_MESSAGE_STATUS_READ;
 		else
 			msg->rc.status = MMS_MESSAGE_STATUS_RECEIVED;
-	} else if (strcmp(state, "downloaded") == 0
-			&& msg->type ==
MMS_MESSAGE_TYPE_RETRIEVE_CONF) {
+	} else if (strcmp(state, "downloaded") == 0 && msg->type ==
MMS_MESSAGE_TYPE_RETRIEVE_CONF) {
 		msg->rc.status = MMS_MESSAGE_STATUS_DOWNLOADED;
 		if (msg->transaction_id == NULL)
 			msg->transaction_id = "";
-	} else if (strcmp(state, "sent") == 0
-			&& msg->type == MMS_MESSAGE_TYPE_SEND_REQ)
+	} else if (strcmp(state, "sent") == 0 && msg->type ==
MMS_MESSAGE_TYPE_SEND_REQ) {
+        msg->sr.datestamp = g_strdup(datestr);
+        msg->sr.date = mktime(&tm);
 		msg->sr.status = MMS_MESSAGE_STATUS_SENT;
-	else if (strcmp(state, "draft") == 0
-			&& msg->type == MMS_MESSAGE_TYPE_SEND_REQ)
+    }
+	else if (strcmp(state, "draft") == 0 && msg->type ==
MMS_MESSAGE_TYPE_SEND_REQ) {
+        msg->sr.datestamp = g_strdup(datestr);
+        msg->sr.date = mktime(&tm);
 		msg->sr.status = MMS_MESSAGE_STATUS_DRAFT;
-	else if (msg->type != MMS_MESSAGE_TYPE_NOTIFICATION_IND &&
-			msg->type != MMS_MESSAGE_TYPE_DELIVERY_IND)
+    }
+	else if (msg->type != MMS_MESSAGE_TYPE_NOTIFICATION_IND &&
msg->type != MMS_MESSAGE_TYPE_DELIVERY_IND)
 		goto out;
 
 	success = TRUE;
@@ -1879,14 +1910,13 @@ static void
append_rc_msg_properties(DBusMessageIter *dict,
 static void append_sr_msg_properties(DBusMessageIter *dict,
 					struct mms_message *msg)
 {
-	const char *date = time_to_str(&msg->rc.date);
 	const char *status = mms_message_status_get_string(msg-
>sr.status);
 
 	mms_dbus_dict_append_basic(dict, "Status",
 					DBUS_TYPE_STRING, &status);
 
 	mms_dbus_dict_append_basic(dict, "Date",
-					DBUS_TYPE_STRING,  &date);
+					DBUS_TYPE_STRING,  &msg-
>sr.datestamp);
 
 	if (msg->sr.to != NULL)
 		append_msg_recipients(dict, msg);
@@ -2120,6 +2150,9 @@ static gboolean result_request_notify_resp(struct
mms_request *request)
 	if (meta == NULL)
 		return FALSE;
 
+    const char *datestr = time_to_str(&msg->rc.date);
+    msg->rc.datestamp = g_strdup(datestr);
+    g_key_file_set_string(meta, "info", "date",  msg->rc.datestamp);
 	g_key_file_set_string(meta, "info", "state", "received");
 
 	mms_store_meta_close(request->service->identity,
@@ -2536,7 +2569,6 @@ void mms_service_bearer_notify(struct mms_service
*service, mms_bool_t active,
 	if (active == FALSE)
 		goto interface_down;
 
-
 	DBG("interface %s proxy %s", interface, proxy);
 
 	if (service->web != NULL) {
-- 
2.30.2

