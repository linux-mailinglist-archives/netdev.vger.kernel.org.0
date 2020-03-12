Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E7C183896
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgCLS0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:26:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41944 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgCLS0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:26:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id s14so8782823wrt.8
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0+2JNX2PMgxL+ZJjbpbgEiZboTmHGFEEqRtv5RnrKFQ=;
        b=U9BZtr5POstMx41yri864snud2+aOVK/kwpeJM2hj8WQe8EW7yvj+gl5A355PwyKC0
         RDw6GIuFuxY50wQ8BeoDf/fMJRuudsbnjXKNDEoATh40fit+ja5kWOJ6txzaHLjG7PPx
         qssTxqJRtapmEICbqBaOGCcq7Bra1dVjp9Pl9kShBHXUFtaWa2ybc9jerfMYi9kaCkHf
         mNXbIl0mAtK3V7/7xRniqrVK4HOWn937I5VbYhXVaPVQOltQsKb8JJMx8TX/ef+OhyKA
         5UsWnOJe85z15l3O0ezTfkDuKrDHoiAor5KHF9JvHToudUgcqFn+1+p9W7EXe7JdfwQj
         VvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0+2JNX2PMgxL+ZJjbpbgEiZboTmHGFEEqRtv5RnrKFQ=;
        b=rub6Lx7zozOXu2zxO/N0G48YUHL9D+j2t26UYiCkKuaHbYPZdKlLO/pE0gCe/HtHqh
         Kr+UvlfGm5MMWB+wls1kojcVt0ndpx5uUbIoXyConygfETYs4SMl5pvuXWgxeEfkgD1d
         ecbS1qwy9s1FM1mvxbor2Q+oom27+ttV64e4Qc5TQpem8LbW6h/J1c5xe4OIADyNWXOg
         EemDQdebXCOrVpfipwhrH6wT6W6QX+uqRp0p8jcUZzMk+ehgdeH4xv4yUx12dxgDVj2T
         rmJlDN1dk79SgoYW33cDaOs03hDV1ESAVzcLHQSslavw9JNUL21vIjgwA68fL2it8J3u
         7rjQ==
X-Gm-Message-State: ANhLgQ10jKKn2j25ZOZXRlsHfsxC45SeF2E+PPcPADMKovxFfVcqi0bK
        7LVfm8/F0o1KDI+tU6ELwPdHNg==
X-Google-Smtp-Source: ADFU+vs7ip4XWHMcAzBmnbyORO4L6XndADmhbyl79Eid1tgkiXb9h4FssA+GefCpMJ5SgRCO8zB4Pw==
X-Received: by 2002:adf:f505:: with SMTP id q5mr12145705wro.348.1584037563875;
        Thu, 12 Mar 2020 11:26:03 -0700 (PDT)
Received: from localhost.localdomain ([194.35.118.177])
        by smtp.gmail.com with ESMTPSA id r9sm6379134wma.47.2020.03.12.11.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 11:26:02 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/2] tools: bpftool: fix object pinning and bash
Date:   Thu, 12 Mar 2020 18:25:53 +0000
Message-Id: <20200312182555.945-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch of this series improves user experience by allowing to pass
all kinds of handles for programs and maps (id, tag, name, pinned path)
instead of simply ids when pinning them with "bpftool (prog|map) pin".

The second patch improves or fix bash completion, including for object
pinning.

Quentin Monnet (2):
  tools: bpftool: allow all prog/map handles for pinning objects
  tools: bpftool: fix minor bash completion mistakes

 tools/bpf/bpftool/bash-completion/bpftool | 29 ++++++++++++-----
 tools/bpf/bpftool/common.c                | 39 +++--------------------
 tools/bpf/bpftool/main.h                  |  2 +-
 tools/bpf/bpftool/map.c                   |  2 +-
 tools/bpf/bpftool/prog.c                  |  2 +-
 5 files changed, 29 insertions(+), 45 deletions(-)

-- 
2.20.1

