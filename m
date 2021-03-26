Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B1B34A5DD
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCZKw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:52:26 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56547 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230192AbhCZKwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:52:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5BA825C0DA9
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:52:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 26 Mar 2021 06:52:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=CfK7y4/+k3ZNbNL/1R2+rWG26q
        vEUFxYYPBfkfs/JWI=; b=OmbR4ZfPhGzlKlnEQBWRObnI7Uq9sDSQOWVRBVUKDJ
        rqwfabEUQAaYc/WrDSQ+X9nIDu3wFMdpFc+CXdDMgE8AX5urRfd43b6Z/666jIc5
        x3ZsjcTPglkeofL2+1pqcJv33Q9Vo0koV52zlFU7GPdvvTI4jPyhORlbcU7BTG4j
        qbbM3fV2Iu3Ef1gO26Lri/XEBWeOjMQPmkP3Rwls4laCVs2s6+h7DrGZi1Q0dHt8
        9AltSKjeQWTIQ+zdic5NJHDRLek48CwAMKomdENZK93AT3/ID4Sl5RI7orLI5eRK
        YrwUjCQ1HCPpR67PUyhFSN+fWlc51OiNlsOboyDu6MCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CfK7y4
        /+k3ZNbNL/1R2+rWG26qvEUFxYYPBfkfs/JWI=; b=MLNxH4ilkmCWqIuN3i/nhC
        whRY70xqyJUISFGnqz1wiX6A38Tsq3OG23ISs294bbbbhFclrL/UtxtVutBDHK/d
        POb1IoENFW2gelfgrzKOaFqoTTD+BqlKYIqPHF9fe4e5Y1Q5sWMrLw9MUZvEGbnG
        C0IcPd4evLTP+qzGlEjT39f9PvjbB4mKuXOv13mt8W916vYDkuu/yqCQOt32z/gv
        mILvVp+gNTvgZl0QAfcd85J7cuOtY1BHDVlPgXp8xJ+hVpqthnkhBwfB5SHeHb3X
        3JEtFh31spQ9V0VvA1llfNXX18LHeEEkQ8ApfeZrdKkxf2ckBVwW7ab4LFhxxSHA
        ==
X-ME-Sender: <xms:3bxdYOg_KErXIlsNjr9DBPzeQnv-wHqUolmqAvShxXhL0FVbIe52zA>
    <xme:3bxdYPDBYx4_yplE41UJcF_8bY2fDId5XpJFyvmTeisRXbZmOqmWlHDRDfIqnnFRw
    eIfnHiwZG6C3KbuCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehvddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvffftggfggfgsehtjeertd
    dtreejnecuhfhrohhmpeevhhhrihhsthhophhhvghrucfvrghlsghothcuoegthhhrihhs
    sehtrghlsghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepieeitdevveegje
    euveeflefhhfeffeeijeffffeiteeifffhveeigeeghfevffdunecukfhppeejvddrleeh
    rddvgeefrdduheeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomheptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:3bxdYGGLV3GezMQRADVhKuozGyMMp0QrJJubXb9FgK_DQxOT2OoajA>
    <xmx:3bxdYHTqzsk2dk0yO3Zr8Ktukn28cSKPxpFWb_Tkj7N3JcD9I0CEOQ>
    <xmx:3bxdYLzP8cotwQDtqye__t_14BVfcv57zwZ0ykZs3hB50kLuyN26jQ>
    <xmx:3bxdYK-_uW8hHjk51wPSCRRIWXi--a9meEmxLtzw6T5ldAclwkm4Bg>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0AF2224005C
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:52:13 -0400 (EDT)
Message-ID: <f38551343dfa3ec0b5e854b37f8e1f5aa3371daf.camel@talbothome.com>
Subject: [PATCH 7/9] Fix Draft and Sent Bugs
From:   Christopher Talbot <chris@talbothome.com>
To:     netdev@vger.kernel.org
Date:   Fri, 26 Mar 2021 06:52:12 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes some bugs related to sending MMSes:
- Makes sure "sent" has an accurate time
- Allows "Draft" to Go to "Sent" on the dbus
- Allows the time to be preserved if mmsd is closed and opened in sent
and recieved messages
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
+       char *datestamp;
 };
 
 struct mms_send_req {
        enum mms_message_status status;
        char *to;
        time_t date;
+       char *datestamp;
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
                                                        "PropertyChange
d");
+                                                       
        if (signal == NULL)
                return;
 
@@ -269,6 +278,7 @@ static DBusMessage *msg_mark_read(DBusConnection
*conn,
        g_free(state);
 
        g_key_file_set_boolean(meta, "info", "read", TRUE);
+       mms->rc.status = MMS_MESSAGE_STATUS_READ;
 
        mms_store_meta_close(service->identity, mms->uuid, meta, TRUE);
 
@@ -722,6 +732,7 @@ static gboolean result_request_send_conf(struct
mms_request *request)
 
        g_key_file_set_string(meta, "info", "state", "sent");
        g_key_file_set_string(meta, "info", "id", msg->sc.msgid);
+       request->msg->sr.status = MMS_MESSAGE_STATUS_SENT;
 
        mms_message_free(msg);
 
@@ -1047,6 +1058,7 @@ static DBusMessage *send_message(DBusConnection
*conn,
        struct mms_service *service = data;
        struct mms_request *request;
        GKeyFile *meta;
+       const char *datestr;
 
        msg = g_new0(struct mms_message, 1);
        if (msg == NULL)
@@ -1059,7 +1071,13 @@ static DBusMessage *send_message(DBusConnection
*conn,
 
        msg->sr.dr = service->use_delivery_reports;
 
-       if (send_message_get_args(dbus_msg, msg) == FALSE) {
+       time(&msg->sr.date);
+
+       datestr = time_to_str(&msg->sr.date);
+
+       msg->sr.datestamp = g_strdup(datestr);
+
+       if (send_message_get_args(dbus_msg, msg, service) == FALSE) {
                mms_debug("Invalid arguments");
 
                release_attachement_data(msg->attachments);
@@ -1099,6 +1117,7 @@ static DBusMessage *send_message(DBusConnection
*conn,
        if (meta == NULL)
                goto release_request;
 
+       g_key_file_set_string(meta, "info", "date",  msg-
>sr.datestamp);
        g_key_file_set_string(meta, "info", "state", "draft");
 
        if (service->use_delivery_reports) {
@@ -1339,10 +1358,12 @@ static gboolean load_message_from_store(const
char *service_id,
        char *state = NULL;
        gboolean read_status;
        char *data_path = NULL;
+       char *datestr = NULL;
        gboolean success = FALSE;
        gboolean tainted = FALSE;
        void *pdu;
        size_t len;
+       struct tm tm;
 
        meta = mms_store_meta_open(service_id, uuid);
        if (meta == NULL)
@@ -1354,6 +1375,13 @@ static gboolean load_message_from_store(const
char *service_id,
 
        read_status = g_key_file_get_boolean(meta, "info", "read",
NULL);
 
+       datestr = g_key_file_get_string(meta, "info", "date", NULL);
+       if (datestr != NULL) {
+               strptime(datestr, "%Y-%m-%dT%H:%M:%S%z", &tm);
+       } else {
+               mms_error("src/service.c:load_message_from_store()
There is no date stamp!");
+       }
+    
        data_path = mms_store_get_path(service_id, uuid);
        if (data_path == NULL)
                goto out;
@@ -1372,25 +1400,28 @@ static gboolean load_message_from_store(const
char *service_id,
 
        msg->uuid = g_strdup(uuid);
 
-       if (strcmp(state, "received") == 0
-                       && msg->type == MMS_MESSAGE_TYPE_RETRIEVE_CONF)
{
+       if (strcmp(state, "received") == 0 && msg->type ==
MMS_MESSAGE_TYPE_RETRIEVE_CONF) {
+        msg->rc.datestamp = g_strdup(datestr);
+        msg->rc.date = mktime(&tm);
                if (read_status == TRUE)
                        msg->rc.status = MMS_MESSAGE_STATUS_READ;
                else
                        msg->rc.status = MMS_MESSAGE_STATUS_RECEIVED;
-       } else if (strcmp(state, "downloaded") == 0
-                       && msg->type == MMS_MESSAGE_TYPE_RETRIEVE_CONF)
{
+       } else if (strcmp(state, "downloaded") == 0 && msg->type ==
MMS_MESSAGE_TYPE_RETRIEVE_CONF) {
                msg->rc.status = MMS_MESSAGE_STATUS_DOWNLOADED;
                if (msg->transaction_id == NULL)
                        msg->transaction_id = "";
-       } else if (strcmp(state, "sent") == 0
-                       && msg->type == MMS_MESSAGE_TYPE_SEND_REQ)
+       } else if (strcmp(state, "sent") == 0 && msg->type ==
MMS_MESSAGE_TYPE_SEND_REQ) {
+        msg->sr.datestamp = g_strdup(datestr);
+        msg->sr.date = mktime(&tm);
                msg->sr.status = MMS_MESSAGE_STATUS_SENT;
-       else if (strcmp(state, "draft") == 0
-                       && msg->type == MMS_MESSAGE_TYPE_SEND_REQ)
+    }
+       else if (strcmp(state, "draft") == 0 && msg->type ==
MMS_MESSAGE_TYPE_SEND_REQ) {
+        msg->sr.datestamp = g_strdup(datestr);
+        msg->sr.date = mktime(&tm);
                msg->sr.status = MMS_MESSAGE_STATUS_DRAFT;
-       else if (msg->type != MMS_MESSAGE_TYPE_NOTIFICATION_IND &&
-                       msg->type != MMS_MESSAGE_TYPE_DELIVERY_IND)
+    }
+       else if (msg->type != MMS_MESSAGE_TYPE_NOTIFICATION_IND && msg-
>type != MMS_MESSAGE_TYPE_DELIVERY_IND)
                goto out;
 
        success = TRUE;
@@ -1879,14 +1910,13 @@ static void
append_rc_msg_properties(DBusMessageIter *dict,
 static void append_sr_msg_properties(DBusMessageIter *dict,
                                        struct mms_message *msg)
 {
-       const char *date = time_to_str(&msg->rc.date);
        const char *status = mms_message_status_get_string(msg-
>sr.status);
 
        mms_dbus_dict_append_basic(dict, "Status",
                                        DBUS_TYPE_STRING, &status);
 
        mms_dbus_dict_append_basic(dict, "Date",
-                                       DBUS_TYPE_STRING,  &date);
+                                       DBUS_TYPE_STRING,  &msg-
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
2.30.0

