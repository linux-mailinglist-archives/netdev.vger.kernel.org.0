Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1DE352EC5
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 19:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbhDBRyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 13:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbhDBRyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 13:54:51 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93316C061788
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 10:54:49 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id k188so6168935qkb.5
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 10:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=H/QN+XLAOQblK5KA0ufolQMfBhTIuBh3TpbLAoLglYU=;
        b=YVISu5OC169fQpXC59PG7UjpCT2nVConTKQq7BlmNxFw1NwTbpa8+Dx45CDJmkBANz
         Cwyb4qWFklymIw3FoLDpQdNCpfOP8zE7zeZq2BGCpbdBnxnJ4+J1CPiU5FEqoJRnSTDp
         nH++68MoadOxp9NDhN4HJPPtmEAnXJ62EQdEiEhGtH9Z/g538baHVzV1vO6cjBdBA2xS
         drA7pZWdLHSsN3tju9dfz1bOfitw+vdP0HGHg1GFjQt4WYXnAoKnFXVM9KvfW/ilPvwm
         Vx97iVt4M/HUF4Q+b12qjqje+btT0wl+5TxpZoowhk3ttOIjm93yvmgG0soCO7XJ0uAU
         lx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=H/QN+XLAOQblK5KA0ufolQMfBhTIuBh3TpbLAoLglYU=;
        b=QoDu0bo1x3m7g55iUEOkbvUoDiMUa1sGeYbUYe8vMtCH1ots0ihSZmuzf1hSXlrB+L
         u0DOcGUYx5Nk8H9SQSB6u4xY3LqO84vxuciwVn5+x50pMusXqQhGCThVvzB3XVQ+vWZE
         hgTsaJNOmgVQJHwAUBWZDgmRYWdTB/k2aB+n0Fr7CNb7SaEdHmik6QXyxc5ZsNLZkZTR
         tF1bC/3e9nhOZfJnFBDGelrcUZ5IRCqPdra31d6a3Px5LFZZtRko4vSGd2Ut8G3UrZ3w
         Ny4SDzO5tDXuLnXxiko89uYaKQ7NSoaze/+oklnEBVWfLbGi3br2pW5Q0EsNL/WmKjQ3
         JcVg==
X-Gm-Message-State: AOAM531CZo/SBXAglL+WVoQbhVXTPtL22XQHBw5fE0d90cvEyptWHOUp
        I43HZGl75wvfNpIQcs/19Hi8XQVtsqG1
X-Google-Smtp-Source: ABdhPJyFjIXNtYDwMvOnpZyTqKgcA/IlZyKsLZJ5HwyMpDLPFt4CF66H243aUk/39iUBh+PDp8uP57/+F/qW
X-Received: from yudiliu.mtv.corp.google.com ([2620:15c:202:201:a4ba:ce38:21e0:52a5])
 (user=yudiliu job=sendgmr) by 2002:a05:6214:2507:: with SMTP id
 gf7mr13843817qvb.40.1617386088760; Fri, 02 Apr 2021 10:54:48 -0700 (PDT)
Date:   Fri,  2 Apr 2021 10:54:44 -0700
Message-Id: <20210402105437.v1.1.Id5ee0a2edda8f0902498aaeb1b6c78d062579b75@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v1] Bluetooth: Return whether a connection is outbound
From:   Yu Liu <yudiliu@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org
Cc:     Yu Liu <yudiliu@google.com>, Miao-chen Chou <mcchou@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an MGMT_EV_DEVICE_CONNECTED event is reported back to the user
space we will set the flags to tell if the established connection is
outbound or not. This is useful for the user space to log better metrics
and error messages.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Yu Liu <yudiliu@google.com>
---

Changes in v1:
- Initial change

 include/net/bluetooth/mgmt.h | 2 ++
 net/bluetooth/mgmt.c         | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index a7cffb069565..7cc724386b00 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -885,6 +885,8 @@ struct mgmt_ev_new_long_term_key {
 	struct mgmt_ltk_info key;
 } __packed;
 
+#define MGMT_DEV_CONN_INITIATED_CONNECTION 0x08
+
 #define MGMT_EV_DEVICE_CONNECTED	0x000B
 struct mgmt_ev_device_connected {
 	struct mgmt_addr_info addr;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 09e099c419f2..77213e67e8e4 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8774,6 +8774,11 @@ void mgmt_device_connected(struct hci_dev *hdev, struct hci_conn *conn,
 	bacpy(&ev->addr.bdaddr, &conn->dst);
 	ev->addr.type = link_to_bdaddr(conn->type, conn->dst_type);
 
+	if (conn->out)
+		flags |= MGMT_DEV_CONN_INITIATED_CONNECTION;
+	else
+		flags &= ~MGMT_DEV_CONN_INITIATED_CONNECTION;
+
 	ev->flags = __cpu_to_le32(flags);
 
 	/* We must ensure that the EIR Data fields are ordered and
-- 
2.31.0.208.g409f899ff0-goog

