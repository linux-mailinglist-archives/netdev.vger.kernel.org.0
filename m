Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BDD17F735
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 13:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCJMPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 08:15:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24111 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726224AbgCJMPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 08:15:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583842535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CzUhhSMzByN/8VQWNZIF3TTLGgveIGd68acA4mU6ntY=;
        b=NAoIqTFPzmqfc1jkeQVml0VKzwmlwzKyVJQUChtFgq8nD2Oa+WLvUd5oOEIVBiEgTNdw0l
        sB0WiebWaWX2ccyeqw5ehwIh8RVEFUe8PQlVrTohCogZuhutGSBXoEcRDqwip95qVuBysj
        qh5qDFOuQlbqzakRt/v3DzyydYjkPbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-KB7FzRqdMFC5O7k_ZoYi2w-1; Tue, 10 Mar 2020 08:15:32 -0400
X-MC-Unique: KB7FzRqdMFC5O7k_ZoYi2w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B585F108BD0E;
        Tue, 10 Mar 2020 12:15:30 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.36.118.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 434025C28D;
        Tue, 10 Mar 2020 12:15:28 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] nexthop: fix error reporting in filter dump
Date:   Tue, 10 Mar 2020 13:15:17 +0100
Message-Id: <07545342394d8a8477f81ecbc1909079bfeeb78e.1583842365.git.aclaudi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nh_dump_filter is missing a return value check in two cases.
Fix this simply adding an assignment to the proper variable.

Fixes: 63df8e8543b03 ("Add support for nexthop objects")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ipnexthop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 9f860c8cea251..99f89630ed189 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -59,13 +59,13 @@ static int nh_dump_filter(struct nlmsghdr *nlh, int r=
eqlen)
 	}
=20
 	if (filter.groups) {
-		addattr_l(nlh, reqlen, NHA_GROUPS, NULL, 0);
+		err =3D addattr_l(nlh, reqlen, NHA_GROUPS, NULL, 0);
 		if (err)
 			return err;
 	}
=20
 	if (filter.master) {
-		addattr32(nlh, reqlen, NHA_MASTER, filter.master);
+		err =3D addattr32(nlh, reqlen, NHA_MASTER, filter.master);
 		if (err)
 			return err;
 	}
--=20
2.24.1

