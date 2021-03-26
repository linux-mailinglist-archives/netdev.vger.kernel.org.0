Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F3F34A5DB
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhCZKvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:51:55 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57331 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhCZKv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:51:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 8376A5C0A31
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:51:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 26 Mar 2021 06:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=mfLM54NkRzGihGMt1RtjFf1msn
        m+AjpFdY2ii5u1oQ4=; b=IBh8P9l1vEWPrFve79xNQI0K5wSnjGQO/10qRJdf9O
        objichibOJi6pqHlstsqE2SJEDAWN0U+1A09pXhwpfuJZcjkXlOsG9h4a7QMvJvv
        u3J9fZZiTondDjKL7nH7zyul7ZB4mMM4CrQFNKP3b7trvYzt+ppJ83t6E2O777YP
        BxyOrIIAHNKYhFtms7TBCntReoICnPXtfIiJdefjQjI4L2wS8jZZ5W06MXLh6WHy
        bIlwwOm4tWSMnaJMT/XJLNGyc7M1i/gLvaX5kFGMa7XxyoHxBHDFIqaSyTh5FAEZ
        sVUvjbiV/PsLr8BLx+szjPBj+x6qC80oLCyZrzOy7FDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mfLM54
        NkRzGihGMt1RtjFf1msnm+AjpFdY2ii5u1oQ4=; b=fFBLViJOiFnhepKCWA7Nd7
        F8GUlCIm4GQDIRri1J6sMmMybbrs84WVr/+S1qb7xLuVwrzayxMWCuD0EM3zt9Q7
        161O7lYxobxXZ/s0ZTf57nX1uP1r4WWki+AejysoPj9R+Zf5ZGyFkFQB7cgn9qvy
        77qIiWZFBxHkjPP+eGBWcKcQWqg8htaz0A7dRY6PEFKVCHdvxCtukffH5K9B9NvV
        4gB3iaiO3q6LvdRZlzXbivDPx7//iuF7KU95BqzrgiV/cUm9oGQuPDqK64Tjv1xn
        wnTKCnfbjV0MXj9IFuKszpko96rKC9mNH3aFm8oD8DDKj0RSAmYj9zdVieuKhqdQ
        ==
X-ME-Sender: <xms:rbxdYGgVYUG9ffnxsDlQTJDuZdO4-GaJ44gadBS4k31J9TPhh6l_3Q>
    <xme:rbxdYG8O52PT1Kyl5Kc0ZfE0dtkpIT4ZbQqIBzjKP0w37tZfOg8f5-SWoMusKLlhb
    haV07JKIjtkn5X_-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehvddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvffftggfggfgsehtjeertd
    dtreejnecuhfhrohhmpeevhhhrihhsthhophhhvghrucfvrghlsghothcuoegthhhrihhs
    sehtrghlsghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepieeitdevveegje
    euveeflefhhfeffeeijeffffeiteeifffhveeigeeghfevffdunecukfhppeejvddrleeh
    rddvgeefrdduheeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomheptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:rbxdYK_U0VHvVmDJkxmP48l58ObsyNefAc5ldJkLE0XAFha4Lf0Hbg>
    <xmx:rbxdYHC1a_Al94zFY-HV2b7FCAzafqt661vrnXsogVVV-WpK1P0wfQ>
    <xmx:rbxdYCzqHZW8aZW3ct4UgAJDH2D0BPg9yqLORR96yarWhZbnrRg2pg>
    <xmx:rbxdYGlRublZCbR6Vt9trc8aDeo7KmgakyMbpHoGjgFO018Dmy5gnA>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46D6E24005B
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:51:25 -0400 (EDT)
Message-ID: <152c1a9de39bf054725522dcf762097091e5a8a4.camel@talbothome.com>
Subject: [PATCH 5/9] Allow for a user configurable maximum attachment size
From:   Christopher Talbot <chris@talbothome.com>
To:     netdev@vger.kernel.org
Date:   Fri, 26 Mar 2021 06:51:24 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Android and iOS enforce a maximum attachment size for MMS messages.
This patch enforces a maximum attachment size for MMS messages and
makes it user configurable.

The default maximum size is based off of Android, which has a maximum
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
+       int max_attach_total_size;
 };
 
 enum mms_request_type {
@@ -146,7 +148,22 @@ static void mms_load_settings(struct mms_service
*service)
                g_key_file_set_boolean(service->settings,
SETTINGS_GROUP,
                                                "UseDeliveryReports",
                                                service-
>use_delivery_reports);
+               error = NULL;
        }
+
+       service->max_attach_total_size =
+               g_key_file_get_integer(service->settings,
SETTINGS_GROUP,
+                                               "TotalMaxAttachmentSize
", &error);
+
+       if (error) {
+               g_error_free(error);
+               service->max_attach_total_size =
DEFAULT_MAX_ATTACHMENT_TOTAL_SIZE;
+               g_key_file_set_integer(service->settings,
SETTINGS_GROUP,
+                                               "TotalMaxAttachmentSize
",
+                                               service-
>max_attach_total_size);
+       }
+       mms_debug("Maximum Attachment Total Size (in bytes): %d",
service->max_attach_total_size);
+
 }
 
 static void mms_request_destroy(struct mms_request *request)
@@ -414,10 +431,11 @@ static gboolean
send_message_get_recipients(DBusMessageIter *top_iter,
 }
 
 static gboolean send_message_get_attachments(DBusMessageIter
*top_iter,
-                                               struct mms_message
*msg)
+                                               struct mms_message
*msg, struct mms_service *service)
 {
        DBusMessageIter attachments;
        unsigned int attach_num = 0;
+       int attach_total_size = 0;
 
        dbus_message_iter_recurse(top_iter, &attachments);
 
@@ -430,8 +448,10 @@ static gboolean
send_message_get_attachments(DBusMessageIter *top_iter,
                struct mms_attachment *attach;
                void *ptr;
 
-               if (++attach_num > MAX_ATTACHMENTS_NUMBER)
+               if (++attach_num > MAX_ATTACHMENTS_NUMBER) {
+                       mms_error("Error: Too many attachments!");
                        return FALSE;
+               }
 
                dbus_message_iter_recurse(&attachments, &entry);
 
@@ -466,6 +486,16 @@ static gboolean
send_message_get_attachments(DBusMessageIter *top_iter,
                        return FALSE;
                }
 
+               attach_total_size = attach_total_size + attach->length;
+
+               mms_debug("Total attachment size: %d",
attach_total_size);
+               mms_debug("Maximum Attachment Total Size (in bytes):
%d", service->max_attach_total_size);
+
+               if (attach_total_size > service-
>max_attach_total_size) 
{
+                       mms_error("Error: Total Attachment size too
large!");
+                       return FALSE;
+               }
+
                attach->data = ptr;
 
                attach->content_id = g_strdup(id);
@@ -490,7 +520,7 @@ static gboolean
send_message_get_attachments(DBusMessageIter *top_iter,
 }
 
 static gboolean send_message_get_args(DBusMessage *dbus_msg,
-                                               struct mms_message
*msg)
+                                               struct mms_message
*msg, struct mms_service *service)
 {
        DBusMessageIter top_iter;
        const char *smil;
@@ -536,7 +566,7 @@ static gboolean send_message_get_args(DBusMessage
*dbus_msg,
        if (dbus_message_iter_get_arg_type(&top_iter) !=
DBUS_TYPE_ARRAY)
                return FALSE;
 
-       return send_message_get_attachments(&top_iter, msg);
+       return send_message_get_attachments(&top_iter, msg, service);
 }
 
 static struct mms_request *create_request(enum mms_request_type type,
-- 
2.30.0

