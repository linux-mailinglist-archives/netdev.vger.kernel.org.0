Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8677F92B1
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfKLOdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:33:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57995 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726645AbfKLOdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:33:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573569201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=r+wi19x3rFI2K1WDJL194GaP8lLRT5DWKj7RFRFiiGQ=;
        b=H2Xi0IE11Y3yb0URVVr6FNHu+QMJK1GkalcpELy0DB91eHdPW9qiLxzK4gbwj9CTDKJFlu
        gCFQZsqd8FLyyjqbqHAVq5J4oqIZBptSXAPiyT/e9hRCe/mVt0ZytY1mJcs9fdplSbWnCz
        c4ttrIEg+XYcURe8JsxlVB1OKnwiUSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-vloIDwteNtCh-OjR2xeuig-1; Tue, 12 Nov 2019 09:33:18 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40277108C2AC;
        Tue, 12 Nov 2019 14:33:15 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3910D5DDA8;
        Tue, 12 Nov 2019 14:33:14 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org
Cc:     Ivan Vecera <ivecera@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next] net/sched: actions: remove unused 'order'
Date:   Tue, 12 Nov 2019 15:33:11 +0100
Message-Id: <e50fe84bfbe3c6fa8c424a5a0af9074c2df63826.1573564420.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: vloIDwteNtCh-OjR2xeuig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

after commit 4097e9d250fb ("net: sched: don't use tc_action->order during
action dump"), 'act->order' is initialized but then it's no more read, so
we can just remove this member of struct tc_action.

CC: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/net/act_api.h | 1 -
 net/sched/act_api.c   | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 0495bdc034d2..71347a90a9d1 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -23,7 +23,6 @@ struct tc_action_ops;
 struct tc_action {
 =09const struct tc_action_ops=09*ops;
 =09__u32=09=09=09=09type; /* for backward compat(TCA_OLD_COMPAT) */
-=09__u32=09=09=09=09order;
 =09struct tcf_idrinfo=09=09*idrinfo;
=20
 =09u32=09=09=09=09tcfa_index;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index bda1ba25c59e..7fc1e2c1b656 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1003,7 +1003,6 @@ int tcf_action_init(struct net *net, struct tcf_proto=
 *tp, struct nlattr *nla,
 =09=09=09err =3D PTR_ERR(act);
 =09=09=09goto err;
 =09=09}
-=09=09act->order =3D i;
 =09=09sz +=3D tcf_action_fill_size(act);
 =09=09/* Start from index 0 */
 =09=09actions[i - 1] =3D act;
--=20
2.23.0

