Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672428D249
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 13:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfHNLhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 07:37:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42821 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfHNLhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 07:37:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id b16so14062070wrq.9
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 04:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=/uOcvbr7W4BNDBGFlgBNRAJtBhauxb70EOTJlpIIqeE=;
        b=QS0JYrM3xQOutEPfWggnrSenr4NaWZWTqkVUIiWZKpN78CrOk5p0ItUNOHCRWRvV6I
         7buGT47NH/m/sKjwDP3ZQKp8LmZABIhXviJYS7Hiu9ucPHDCZ4agb1RSNKsZi3319qI5
         nQlj+7lOqNK4jlnFrPTI7hzVUCVLkSTMXWqN3z+HKc9pbHY66zcUb3ga4wr7r80NDekD
         IkQ3lTqDs7dKvn2O7y5euotBndmI5QxIKWUvvvEaxSV/casesqtOovRHHFKZoyBDJ4on
         bJlEvQfLVjKMvcwo88wMUY7ARzCh/N3YfFT4nHQHQudgVpdYXNLgx2ZSIWnd56pV7ZnW
         9QNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/uOcvbr7W4BNDBGFlgBNRAJtBhauxb70EOTJlpIIqeE=;
        b=m1yYuII5a9m242Ks9hak6Vqn4Nr9rBCxeZSxRbfLFyliiikC80Z4MR7SF1YpJekY8X
         4zI8+KYQTW8eCrUgOxYF7zejDa5w6PXQ4KQ91hSlsdFnAquIBv5682nhXaZonTqoc1fz
         CO5wbts+VMxHs7ZDcc+HMyBAaEtUp6ZX9NShPMLHWFvcZYVxZgrOHwSf1GlKPmOrm4nh
         dJJfxKqnekvmXiV9Af2OUhZG/M58TsBrkv2Tcq7nH7zzeEDyvh0GVIJA95AS77CWN7R6
         21/mm38ABB/h9ZEVyb7DptDWr4RsFUV7giCxECU1+F+L91iVEMkXrJOZ3EKgDJQJ5Bgx
         VhNQ==
X-Gm-Message-State: APjAAAUTapbCCLHDPurA5XCa4JbolJ73hvwirYdH95EJcqHmolZIyYux
        NyL4VtYQzJij9jmdfETbfoVywg==
X-Google-Smtp-Source: APXvYqyidnt83gOV6RcxGFWLvn0wQsELUCIsNuikJCcFKQnTqf/8GxOfC8N+yqtos/rpuD8YLcFYPw==
X-Received: by 2002:adf:ed8d:: with SMTP id c13mr5290790wro.106.1565782659448;
        Wed, 14 Aug 2019 04:37:39 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id 2sm17902687wrg.83.2019.08.14.04.37.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 04:37:37 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next] tools: bpftool: compile with $(EXTRA_WARNINGS)
Date:   Wed, 14 Aug 2019 12:37:24 +0100
Message-Id: <20190814113724.20884-1-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compile bpftool with $(EXTRA_WARNINGS), as defined in
scripts/Makefile.include, and fix the new warnings produced.

Simply leave -Wswitch-enum out of the warning list, as we have several
switch-case structures where it is not desirable to process all values
of an enum.

Remove -Wshadow from the warnings we manually add to CFLAGS, as it is
handled in $(EXTRA_WARNINGS).

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/Makefile | 3 ++-
 tools/bpf/bpftool/cgroup.c | 2 +-
 tools/bpf/bpftool/perf.c   | 4 ++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 4c9d1ffc3fc7..f284c207765a 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -37,7 +37,8 @@ prefix ?= /usr/local
 bash_compdir ?= /usr/share/bash-completion/completions
 
 CFLAGS += -O2
-CFLAGS += -W -Wall -Wextra -Wno-unused-parameter -Wshadow -Wno-missing-field-initializers
+CFLAGS += -W -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers
+CFLAGS += $(filter-out -Wswitch-enum,$(EXTRA_WARNINGS))
 CFLAGS += -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ \
 	-I$(srctree)/kernel/bpf/ \
 	-I$(srctree)/tools/include \
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 44352b5aca85..1ef45e55039e 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -120,8 +120,8 @@ static int count_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type)
 static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 				   int level)
 {
+	const char *attach_flags_str;
 	__u32 prog_ids[1024] = {0};
-	char *attach_flags_str;
 	__u32 prog_cnt, iter;
 	__u32 attach_flags;
 	char buf[32];
diff --git a/tools/bpf/bpftool/perf.c b/tools/bpf/bpftool/perf.c
index f2a545e667c4..b2046f33e23f 100644
--- a/tools/bpf/bpftool/perf.c
+++ b/tools/bpf/bpftool/perf.c
@@ -104,6 +104,8 @@ static void print_perf_json(int pid, int fd, __u32 prog_id, __u32 fd_type,
 		jsonw_string_field(json_wtr, "filename", buf);
 		jsonw_lluint_field(json_wtr, "offset", probe_offset);
 		break;
+	default:
+		break;
 	}
 	jsonw_end_object(json_wtr);
 }
@@ -140,6 +142,8 @@ static void print_perf_plain(int pid, int fd, __u32 prog_id, __u32 fd_type,
 		printf("uretprobe  filename %s  offset %llu\n", buf,
 		       probe_offset);
 		break;
+	default:
+		break;
 	}
 }
 
-- 
2.17.1

