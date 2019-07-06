Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C81A60F85
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 10:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfGFIr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 04:47:26 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45251 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfGFIrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 04:47:22 -0400
Received: by mail-ed1-f65.google.com with SMTP id e2so3077156edi.12
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 01:47:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=SzMIkZULOUXyWz0bs3UvGouAnnYDVNmXPoS+1dNAR9g=;
        b=MV4lViY87Aw7phjXd987F9yDrj/Y+6GYkrbzj2uuasX1wmlpFjFIeSchdoYNXgLfjn
         3yzvHOjays70TezTpxTX+7HQw7GLGRn0rlGZcjssUiBKrQruH2I+CWISfxs72KeTdJ+t
         REtNeGYv2mzaBgjKYOF4Nrt/XjaIZmG/4jEUXiPGa/etLTNkjD2YN0dHSkCIxQn+/Tvp
         /hjI3UmAWmT4cI/m/IGXXr23EAf/IfY5QeL/4hGNtQhNngSRiruHorwiXbNzzj6oMZIf
         mCJqDrLbYJS3HEIWtlWZoSnI62wEc0SiyviV2L/nKvGYG4zd2rZTFZKsclaktqioGwCj
         6Paw==
X-Gm-Message-State: APjAAAUaJp0ZXjp3HiFjJsFeSRAMi8KDjW6UnF5Cr1ftzLcJ1LAd5h9K
        G4MP4B/O2mJx2K1TaSol7vK0sg==
X-Google-Smtp-Source: APXvYqy4XI1kitq2HjIyzJsAm+BvbunxeCfXDfLtwaxSTZRQk1uNGFjqjZnE6Da9YeXKmRvZJIPVpw==
X-Received: by 2002:aa7:c2c8:: with SMTP id m8mr8876674edp.63.1562402840975;
        Sat, 06 Jul 2019 01:47:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id t13sm3399037edd.13.2019.07.06.01.47.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 01:47:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2D905181CE9; Sat,  6 Jul 2019 10:47:16 +0200 (CEST)
Subject: [PATCH bpf-next v2 6/6] tools: Add definitions for devmap_hash map
 type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sat, 06 Jul 2019 10:47:16 +0200
Message-ID: <156240283611.10171.18010849007723279211.stgit@alrua-x1>
In-Reply-To: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds a selftest, syncs the tools/ uapi header and adds the
devmap_hash name to bpftool for the new devmap_hash map type.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/bpftool/map.c                 |    1 +
 tools/include/uapi/linux/bpf.h          |    1 +
 tools/testing/selftests/bpf/test_maps.c |   16 ++++++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 5da5a7311f13..c345f819b840 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -37,6 +37,7 @@ const char * const map_type_name[] = {
 	[BPF_MAP_TYPE_ARRAY_OF_MAPS]		= "array_of_maps",
 	[BPF_MAP_TYPE_HASH_OF_MAPS]		= "hash_of_maps",
 	[BPF_MAP_TYPE_DEVMAP]			= "devmap",
+	[BPF_MAP_TYPE_DEVMAP_HASH]		= "devmap_hash",
 	[BPF_MAP_TYPE_SOCKMAP]			= "sockmap",
 	[BPF_MAP_TYPE_CPUMAP]			= "cpumap",
 	[BPF_MAP_TYPE_XSKMAP]			= "xskmap",
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index cecf42c871d4..8afaa0a19c67 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -134,6 +134,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_QUEUE,
 	BPF_MAP_TYPE_STACK,
 	BPF_MAP_TYPE_SK_STORAGE,
+	BPF_MAP_TYPE_DEVMAP_HASH,
 };
 
 /* Note that tracing related programs such as
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index a3fbc571280a..086319caf2d9 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -508,6 +508,21 @@ static void test_devmap(unsigned int task, void *data)
 	close(fd);
 }
 
+static void test_devmap_hash(unsigned int task, void *data)
+{
+	int fd;
+	__u32 key, value;
+
+	fd = bpf_create_map(BPF_MAP_TYPE_DEVMAP_HASH, sizeof(key), sizeof(value),
+			    2, 0);
+	if (fd < 0) {
+		printf("Failed to create devmap_hash '%s'!\n", strerror(errno));
+		exit(1);
+	}
+
+	close(fd);
+}
+
 static void test_queuemap(unsigned int task, void *data)
 {
 	const int MAP_SIZE = 32;
@@ -1675,6 +1690,7 @@ static void run_all_tests(void)
 	test_arraymap_percpu_many_keys();
 
 	test_devmap(0, NULL);
+	test_devmap_hash(0, NULL);
 	test_sockmap(0, NULL);
 
 	test_map_large();

