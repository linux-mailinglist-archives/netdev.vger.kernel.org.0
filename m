Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA92FDE1B
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 13:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfKOMmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 07:42:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36084 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727272AbfKOMmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 07:42:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573821774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VKSgyufm9lCSTbG6iAHD70fQpWTZJML7/dJPhf6V5lk=;
        b=K6hiAh+vHui8SvInBZoT5VK5urNhg6K3VJqmk5XH4U9Zl1/ALGlDVTIFOuTFyp+3EsF5q5
        W5G4C/RNv78PsDD3YBMgcRI1+S+r12n2nt94PWDtholjQi4zkLesIykgyK3OMA1l0Ie1xH
        SPwE4LDtcs5YAfe+nnNn1OjpgKv9H6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-vYiBxy1BNMmK6MDubHF4dg-1; Fri, 15 Nov 2019 07:42:53 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9D2E1802CE3;
        Fri, 15 Nov 2019 12:42:51 +0000 (UTC)
Received: from griffin.upir.cz (unknown [10.40.206.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E860E5C548;
        Fri, 15 Nov 2019 12:42:50 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf] selftests: bpf: xdping is not meant to be run standalone
Date:   Fri, 15 Nov 2019 13:42:32 +0100
Message-Id: <4365c81198f62521344c2215909634407184387e.1573821726.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: vYiBxy1BNMmK6MDubHF4dg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The actual test to run is test_xdping.sh, which is already in TEST_PROGS.
The xdping program alone is not runnable with 'make run_tests', it
immediatelly fails due to missing arguments.

Move xdping to TEST_GEN_PROGS_EXTENDED in order to be built but not run.

Fixes: cd5385029f1d ("selftests/bpf: measure RTT from xdp using xdping")
Cc: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 tools/testing/selftests/bpf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests=
/bpf/Makefile
index 6889c19a628c..99193a241bc7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -29,7 +29,7 @@ TEST_GEN_PROGS =3D test_verifier test_tag test_maps test_=
lru_map test_lpm_map test
 =09test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 =09test_cgroup_storage test_select_reuseport test_section_names \
 =09test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashm=
ap \
-=09test_btf_dump test_cgroup_attach xdping
+=09test_btf_dump test_cgroup_attach
=20
 BPF_OBJ_FILES =3D $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES =3D $(BPF_OBJ_FILES)
@@ -82,7 +82,7 @@ TEST_PROGS_EXTENDED :=3D with_addr.sh \
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED =3D test_libbpf_open test_sock_addr test_skb_cgrou=
p_id_user \
 =09flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
-=09test_lirc_mode2_user
+=09test_lirc_mode2_user xdping
=20
 include ../lib.mk
=20
--=20
2.18.1

