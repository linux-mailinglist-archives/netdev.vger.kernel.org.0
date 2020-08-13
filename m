Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BCE243B8D
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 16:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHMO30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 10:29:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51147 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726106AbgHMO3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 10:29:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597328964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DtGeLvx1wLTBoO7zj2vWPZCvAg2PY5suAIRCYsTk2d0=;
        b=iRDhvSQuZX8Qe439HmHxhC3x2wC7/aFCSAbum83hfpapOfO7o+cUnywRPWOoS8/85QCCMZ
        cyXQm+G7RHSJ+/bYd/CyD/ZX8AlPhDoZXySHixF5S1x5U3v0r2NDK7y3YTdvBKTT9m6nUe
        5k8MlI1RhpA/Vv8eKq9/1lSlR/yAmCo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-b7P0CHMuM_e21iEwrERREg-1; Thu, 13 Aug 2020 10:29:22 -0400
X-MC-Unique: b7P0CHMuM_e21iEwrERREg-1
Received: by mail-wm1-f70.google.com with SMTP id s4so2040969wmh.1
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 07:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DtGeLvx1wLTBoO7zj2vWPZCvAg2PY5suAIRCYsTk2d0=;
        b=bYOJpitHl8amheOrtxl/yetxTKDsrtwigPOATH+dAscjvKFNVFV5uEKBTv+QqPTKYY
         vzRIwAtBoe1W4FtFPVZTzRk5lwnnskpen8Dm32e1he4pguXwxYjbtSU/hOe7io+1mVBP
         I3y97mB1SGliQhlizXFcD/ZaEveeP94ycIQuVD3eiPMmJPnK8Ndy9rSxE1LiT+obTkzA
         lh7var7GDNIMVd5QHG7jhHcTMc/Bo/LfxmV0OrRev00a82r/EqC6alcTLMyHz9HbdTE4
         sXpgbh+2pkVVArC3MBQIq7otyTEONFXRf3EcKxQkCDc35TUMWcEmvglDZ18VfpJaaUWc
         WBVg==
X-Gm-Message-State: AOAM5300RPdBruvr/RCLl8+mmq4pMROZgrJuHVnMH0IyYPY2meE4oUvM
        +n6Jk1Yh58PyXOCOOEqPjL20kyxiOdaq6RpXNPYXs3wDqF+Occt+kxNNkvxaQq142qTS6h+LFh2
        62HqyrVvCiV4FF80L
X-Received: by 2002:a1c:a1c7:: with SMTP id k190mr4438278wme.1.1597328961230;
        Thu, 13 Aug 2020 07:29:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8+M1jAPj+ZJqG/iK2mV6QXZ1RVt0oQY1ErDa8VCJ4x0jUp2RJYJLbFnS1QJBPue9oi3VZCA==
X-Received: by 2002:a1c:a1c7:: with SMTP id k190mr4438262wme.1.1597328961025;
        Thu, 13 Aug 2020 07:29:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r22sm9828936wmh.45.2020.08.13.07.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 07:29:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E2F71180493; Thu, 13 Aug 2020 16:29:18 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf] libbpf: Prevent overriding errno when logging errors
Date:   Thu, 13 Aug 2020 16:29:05 +0200
Message-Id: <20200813142905.160381-1-toke@redhat.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turns out there were a few more instances where libbpf didn't save the
errno before writing an error message, causing errno to be overridden by
the printf() return and the error disappearing if logging is enabled.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0a06124f7999..fd256440e233 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3478,10 +3478,11 @@ bpf_object__probe_global_data(struct bpf_object *obj)
 
 	map = bpf_create_map_xattr(&map_attr);
 	if (map < 0) {
-		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+		ret = -errno;
+		cp = libbpf_strerror_r(-ret, errmsg, sizeof(errmsg));
 		pr_warn("Error in %s():%s(%d). Couldn't create simple array map.\n",
-			__func__, cp, errno);
-		return -errno;
+			__func__, cp, -ret);
+		return ret;
 	}
 
 	insns[0].imm = map;
@@ -6012,9 +6013,10 @@ int bpf_program__pin_instance(struct bpf_program *prog, const char *path,
 	}
 
 	if (bpf_obj_pin(prog->instances.fds[instance], path)) {
-		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
+		err = -errno;
+		cp = libbpf_strerror_r(-err, errmsg, sizeof(errmsg));
 		pr_warn("failed to pin program: %s\n", cp);
-		return -errno;
+		return err;
 	}
 	pr_debug("pinned program '%s'\n", path);
 
-- 
2.28.0

