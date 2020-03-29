Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7FE196DA4
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 15:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgC2NXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 09:23:24 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:31664 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728114AbgC2NXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 09:23:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585488202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2s2BdnMCPGd1g5Zqt0G0Bsb/G6cmPG9iPfUVgjjDP5I=;
        b=iDMSzMuBkHYsg8FdUe5dCPQGBGU/z/VFNvtjj8/yqaqjvwdm2Y9j2beNjh+Z+b5PvJ5k1V
        4LWkmYZU8f0+WbFmNS1huoeDeCbF0Ut/VwtBxCRaJrmHVntzuK2DBzQGV8M3m5y1rfZY3l
        YXWeNglGzE/Xuebkuy3ekPFOG6TmEDc=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18--kozBBVUP8uA1kPPAAHUew-1; Sun, 29 Mar 2020 09:23:18 -0400
X-MC-Unique: -kozBBVUP8uA1kPPAAHUew-1
Received: by mail-lj1-f197.google.com with SMTP id t12so2204196lji.14
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 06:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2s2BdnMCPGd1g5Zqt0G0Bsb/G6cmPG9iPfUVgjjDP5I=;
        b=olsT+YrC2Vg5ir76G7JF+BDS1N+NK+C0Y4H/RSJk/V6X2d5irK1SBBbLICg9btvM3Y
         g4vMOzxpdJ4nTddFXX1ROQp30urRfu/yYgoesUVszDJxyihlGy+vCgGHbRTOobiIFnc5
         AbrdvcW+s7zzN3ckQJ3RqUXElPOZAxKJ+HrOaftHUNvNR8YwqaKO3/2dWvZPc6fyYXAh
         cyrA5bVPrkELrCWayb5Dn2Z0O1S78mkaNgMIBuW5DLvjmISWC5yRXDIvNr8Iarxm7gCF
         ViqAmW+cmCUGpwlL5oUFLJysYGQ6kIs1JwQMtMGaeJkkzHmwkMnfV7c+YDlBSUjZ1Olh
         ZFsQ==
X-Gm-Message-State: AGi0PuZRBBlROHWCaC0KHuvU7ijgbIgZOAauf7mm4Wggmtu6zdshwAoA
        06Eb+dz1iGxkCpJu2E4P1jYWwsqs194GqN+WdzsoA93Cw46Z6eykFxpOy20mGAM1NL/0RoCSWWD
        wFYpckltSqJit7JMq
X-Received: by 2002:a2e:3a01:: with SMTP id h1mr4602901lja.161.1585488197278;
        Sun, 29 Mar 2020 06:23:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypJnAFmndO5nwxNXiRkPpOK0TLlxetboyE0xtvhjvUUI3lHhKU0hHnrqVjWfxXDOOIDZXOC9tw==
X-Received: by 2002:a2e:3a01:: with SMTP id h1mr4602881lja.161.1585488196682;
        Sun, 29 Mar 2020 06:23:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y124sm6187788lff.48.2020.03.29.06.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 06:23:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D131F18158B; Sun, 29 Mar 2020 15:23:14 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH v4 1/2] libbpf: Add setter for initial value for internal maps
Date:   Sun, 29 Mar 2020 15:22:52 +0200
Message-Id: <20200329132253.232541-1-toke@redhat.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200328182834.196578-1-toke@redhat.com>
References: <20200328182834.196578-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For internal maps (most notably the maps backing global variables), libbpf
uses an internal mmaped area to store the data after opening the object.
This data is subsequently copied into the kernel map when the object is
loaded.

This adds a function to set a new value for that data, which can be used to
before it is loaded into the kernel. This is especially relevant for RODATA
maps, since those are frozen on load.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v4:
  - Make void pointer const, check if map was loaded
  - Reject set if map was already loaded
  - Split test into its own file
v3:
  - Add a setter for the initial value instead of a getter for the pointer to it
  - Add selftest
v2:
  - Add per-map getter for data area instead of a global rodata getter for bpf_obj

 tools/lib/bpf/libbpf.c   | 11 +++++++++++
 tools/lib/bpf/libbpf.h   |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 14 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 62903302935e..7deab98720ee 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6758,6 +6758,17 @@ void *bpf_map__priv(const struct bpf_map *map)
 	return map ? map->priv : ERR_PTR(-EINVAL);
 }
 
+int bpf_map__set_initial_value(struct bpf_map *map,
+			       const void *data, size_t size)
+{
+	if (!map->mmaped || map->libbpf_type == LIBBPF_MAP_KCONFIG ||
+	    size != map->def.value_size || map->fd >= 0)
+		return -EINVAL;
+
+	memcpy(map->mmaped, data, size);
+	return 0;
+}
+
 bool bpf_map__is_offload_neutral(const struct bpf_map *map)
 {
 	return map->def.type == BPF_MAP_TYPE_PERF_EVENT_ARRAY;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index bf7a35a9556d..958ae71c116e 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -407,6 +407,8 @@ typedef void (*bpf_map_clear_priv_t)(struct bpf_map *, void *);
 LIBBPF_API int bpf_map__set_priv(struct bpf_map *map, void *priv,
 				 bpf_map_clear_priv_t clear_priv);
 LIBBPF_API void *bpf_map__priv(const struct bpf_map *map);
+LIBBPF_API int bpf_map__set_initial_value(struct bpf_map *map,
+					  const void *data, size_t size);
 LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
 LIBBPF_API int bpf_map__resize(struct bpf_map *map, __u32 max_entries);
 LIBBPF_API bool bpf_map__is_offload_neutral(const struct bpf_map *map);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index dcc87db3ca8a..159826b36b38 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -243,6 +243,7 @@ LIBBPF_0.0.8 {
 		bpf_link__pin;
 		bpf_link__pin_path;
 		bpf_link__unpin;
+		bpf_map__set_initial_value;
 		bpf_program__set_attach_target;
 		bpf_set_link_xdp_fd_opts;
 } LIBBPF_0.0.7;
-- 
2.26.0

