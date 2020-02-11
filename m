Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D2E1598B7
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbgBKSeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 13:34:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30175 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730445AbgBKSeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 13:34:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581446050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P7ySnESgFtRjAvtxkdGs4ebd9m2H/cHLSYVYmV9SARA=;
        b=OZT+Vv2JOTcC287DVO9OLoFCH7Dw+BlKu8YyBZvd1tyJ8JPIZLRJEJ1/Mw0xpVJhKFY89M
        NI/f7TweF/j9QMG5QiY0Rey/ivk7+WFW91Kmv09V//UxQshCblAYXmjoBSAsEXyCaf6hF1
        3CDwevHYAi3T1tauqzzbYV0pv+fQBHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-iUFnfjV0O-KGoQHpRWVkdw-1; Tue, 11 Feb 2020 13:34:06 -0500
X-MC-Unique: iUFnfjV0O-KGoQHpRWVkdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2C81A0CCA;
        Tue, 11 Feb 2020 18:34:04 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A669F1000325;
        Tue, 11 Feb 2020 18:34:03 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Amir Vadai <amir@vadai.me>, Yotam Gigi <yotamg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/2] net/sched: flower: add missing validation of TCA_FLOWER_FLAGS
Date:   Tue, 11 Feb 2020 19:33:40 +0100
Message-Id: <6f39f0296c4cd7b339764c863cde8fdf04b83ec6.1581444848.git.dcaratti@redhat.com>
In-Reply-To: <cover.1581444848.git.dcaratti@redhat.com>
References: <cover.1581444848.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unlike other classifiers that can be offloaded (i.e. users can set flags
like 'skip_hw' and 'skip_sw'), 'cls_flower' doesn't validate the size of
netlink attribute 'TCA_FLOWER_FLAGS' provided by user: add a proper entry
to fl_policy.

Fixes: 5b33f48842fa ("net/flower: Introduce hardware offload support")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/cls_flower.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f9c0d1e8d380..7e54d2ab5254 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -691,6 +691,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_M=
AX + 1] =3D {
 					    .len =3D 128 / BITS_PER_BYTE },
 	[TCA_FLOWER_KEY_CT_LABELS_MASK]	=3D { .type =3D NLA_BINARY,
 					    .len =3D 128 / BITS_PER_BYTE },
+	[TCA_FLOWER_FLAGS]		=3D { .type =3D NLA_U32 },
 };
=20
 static const struct nla_policy
--=20
2.24.1

