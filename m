Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DECE78160B
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 11:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfHEJ5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 05:57:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35735 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbfHEJ5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 05:57:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so83760603wrm.2
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 02:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BWoMC/gG3WA9hZdmhlG34TCNLOez/oXxZk5JKz6gCMs=;
        b=y/IWPPHnnKDLS8XpYCZcOYD+mM+7WvW45nLDKmmPh1g+WfMVmlwnFtO8goTMz4BYTt
         4cwUwGbEd0xuEuwvZYPRBUGRWJ9yC2O5jrzJsJWf1l39AMlT+G89pm8PlVup2q0mJsm9
         XWfPJhRNVGF76Y+ijnkJZpZW5+7EN4DQOIaSk70ToUDwLmHc1lOOi8Fhp7b6ktcu0H1N
         1pjpRf8CNxzJht0pX5ItVioepIoHAfDWCI4OAlc8Ly1QkY7gmtD+Vr8DafxB5eF7uvFk
         YYz8bbgdNcIEUDURoXNTxXpNmhXQq3KQ+56eyHjnC9jHxm75SX2X971h86HLrXgXBA3a
         B/nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BWoMC/gG3WA9hZdmhlG34TCNLOez/oXxZk5JKz6gCMs=;
        b=OIcgKVgTtE6jeGKARphvApQGKQGkveP9jmnnrERGDbzY5GWqAB3Z1C0b+uLfHyztyC
         u1hZuFVLwpxnO6Kf5Qwh5xl0zIWzda30V7M2iR19dJn6B3SPwRg9qkuU/iIrKtJwuPAm
         XMYcqE8SUIw7W7Moc6slHNpQLf19wmmkFNnV6G300gGp5SkZBqdU1QzlzCCigZ6umiWJ
         0EfiYbzFiYoUPhgd4srCPxgqhe1F8gbhSdcemg38gPl/3qFd2awmOHhLVBArOPUMpSg2
         +s87H5HPl8YaznSRPZdHKrrYzsxZ2ckArDs5Be9b/9V0QJetM6NfdoaZQZ5GiLYnMBv7
         parg==
X-Gm-Message-State: APjAAAWmFb7jt/ZrlfEWFb2Ld3BryTLhZzKdGmM9WzkQORQA6FDskxXZ
        75UrIzYFVRFiB/v5Ex1KPEZ19sK+
X-Google-Smtp-Source: APXvYqzZy3LNpI8qSSRw+tAa0GOHEH8N4POO6fR9652hhF+bdGUINFvxbZhwTUbkmO+gBvKDop0KrQ==
X-Received: by 2002:a05:6000:112:: with SMTP id o18mr83219301wrx.153.1564999019563;
        Mon, 05 Aug 2019 02:56:59 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c65sm85761512wma.44.2019.08.05.02.56.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 02:56:59 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, slyfox@gentoo.org,
        ayal@mellanox.com, mlxsw@mellanox.com
Subject: [patch iproute2] devlink: finish queue.h to list.h transition
Date:   Mon,  5 Aug 2019 11:56:56 +0200
Message-Id: <20190805095658.19841-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Loose the "q" from the names and name the structure fields in the same
way rest of the code does. Also, fix list_add arg order which leads
to segfault.

Fixes: 33267017faf1 ("iproute2: devlink: port from sys/queue.h to list.h")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0ea401ae432a..91c85dc1de73 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -5978,35 +5978,36 @@ static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
 	return MNL_CB_OK;
 }
 
-struct nest_qentry {
+struct nest_entry {
 	int attr_type;
-	struct list_head nest_entries;
+	struct list_head list;
 };
 
 struct fmsg_cb_data {
 	struct dl *dl;
 	uint8_t value_type;
-	struct list_head qhead;
+	struct list_head entry_list;
 };
 
 static int cmd_fmsg_nest_queue(struct fmsg_cb_data *fmsg_data,
 			       uint8_t *attr_value, bool insert)
 {
-	struct nest_qentry *entry = NULL;
+	struct nest_entry *entry;
 
 	if (insert) {
-		entry = malloc(sizeof(struct nest_qentry));
+		entry = malloc(sizeof(struct nest_entry));
 		if (!entry)
 			return -ENOMEM;
 
 		entry->attr_type = *attr_value;
-		list_add(&fmsg_data->qhead, &entry->nest_entries);
+		list_add(&entry->list, &fmsg_data->entry_list);
 	} else {
-		if (list_empty(&fmsg_data->qhead))
+		if (list_empty(&fmsg_data->entry_list))
 			return MNL_CB_ERROR;
-		entry = list_first_entry(&fmsg_data->qhead, struct nest_qentry, nest_entries);
+		entry = list_first_entry(&fmsg_data->entry_list,
+					 struct nest_entry, list);
 		*attr_value = entry->attr_type;
-		list_del(&entry->nest_entries);
+		list_del(&entry->list);
 		free(entry);
 	}
 	return MNL_CB_OK;
@@ -6115,7 +6116,7 @@ static int cmd_health_object_common(struct dl *dl, uint8_t cmd, uint16_t flags)
 		return err;
 
 	data.dl = dl;
-	INIT_LIST_HEAD(&data.qhead);
+	INIT_LIST_HEAD(&data.entry_list);
 	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_fmsg_object_cb, &data);
 	return err;
 }
-- 
2.21.0

