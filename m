Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33553F09D9
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbfKEWvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:51:20 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:33607 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730054AbfKEWvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:51:19 -0500
Received: by mail-pg1-f175.google.com with SMTP id u23so15660637pgo.0;
        Tue, 05 Nov 2019 14:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XI7iPIXUL0EP+TnAnfcZJ0jZc6zRn3ndELVREIV+c0o=;
        b=mM+rfMukIHJEQT4n08knglekwvpevnpXAE9SjGwpsNAeNiUMCI5XxPeu9nbHvlBDBE
         63BwV/A1PbdIk1q8ZSSEGNH/2nDTbq4qHcQT07PJfQ0RwAdNDMOlllyOsMg0XrSqdFBm
         bAqczgDPK4FYw+rETq7eXfZelT7ifVIlifEwPIXyALqcNCnUopAXqfYFjwkh2hSxNhxs
         dzUfutovbI5RmxPh4olNxpuvhWGN+LY4lf0vCCSgEepEItT38W/gbae+qr6lHyUwSoz7
         LwBY6fTQ+Eyz5hvW9LjKRivEagOQDs1aZD8B/ir9RswHY1edeSV27AvalBoKwK893Uxi
         1Rmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XI7iPIXUL0EP+TnAnfcZJ0jZc6zRn3ndELVREIV+c0o=;
        b=fvR7J3ya+P6Fd9LdMo6CnclRlGcuBQyIBXx93WEJfXSBsRtd5bc5I+fmlNcfRaHdpK
         rRUNrubyBa9J9f4vCWjjkynDDk0Z6FZ6Wpg8Yci0M3pluAA5P6TKYyw/zLyoC5tWzbnG
         sD4XX6iQ/IgHbAtiDo3MGu1xehfr4XL4eW5u4MPEL/5CP5mbTFhv7MoDyFDiLZ6z2GT8
         52sjwJD8j6JjAU6uUCP6rOxk3toYn4GU1kFu3xo6V1nEmsL2cE59niy+bdTwwu08aksP
         kRuv/UklDLcYNYPFkCKFKD5TBliAY9d6ZWe4EhfNgrb4dMwlqQ/YJN0OsZEesqU8nZCm
         GCnA==
X-Gm-Message-State: APjAAAWP1Rv/ObxksN4tGo6Db7b8aC682YuTHV9qxneUjDciSkqo83DJ
        tm73luq8eUYKPLW/zzi5BA==
X-Google-Smtp-Source: APXvYqwOTxn+9xDsmTt1zRcKdzsQTvMDC7tZ4Lu07u6z8mVwTbZfd46oNzr/mhbq2HkJw9o7MyZM+Q==
X-Received: by 2002:a17:90a:174a:: with SMTP id 10mr1937250pjm.104.1572994278560;
        Tue, 05 Nov 2019 14:51:18 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id r10sm18292739pgn.68.2019.11.05.14.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 14:51:18 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH,bpf-next 0/2] samples: bpf: update map definition to new syntax BTF-defined map
Date:   Wed,  6 Nov 2019 07:51:09 +0900
Message-Id: <20191105225111.4940-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since, the new syntax of BTF-defined map has been introduced,
the syntax for using maps under samples directory are mixed up.
For example, some are already using the new syntax, and some are using
existing syntax by calling them as 'legacy'.

As stated at commit abd29c931459 ("libbpf: allow specifying map
definitions using BTF"), the BTF-defined map has more compatablility
with extending supported map definition features.

Also, unifying the map definition to BTF-defined map will help reduce
confusion between new syntax and existing syntax.

The commit doesn't replace all of the map to new BTF-defined map,
because some of the samples still use bpf_load instead of libbpf, which
can't properly create BTF-defined map.

This will only updates the samples which uses libbpf API for loading bpf
program. (ex. bpf_prog_load_xattr)

This patchset fixes some of the outdated error message regarded to loading
bpf program (load_bpf_file -> bpf_prog_load_xattr), and updates map
definition to new syntax of BTF-defined map.

Daniel T. Lee (2):
  samples: bpf: update outdated error message
  samples: bpf: update map definition to new syntax BTF-defined map

 samples/bpf/hbm.c                   |   2 +-
 samples/bpf/sockex1_kern.c          |  12 ++--
 samples/bpf/sockex2_kern.c          |  12 ++--
 samples/bpf/xdp1_kern.c             |  12 ++--
 samples/bpf/xdp1_user.c             |   2 +-
 samples/bpf/xdp2_kern.c             |  12 ++--
 samples/bpf/xdp_adjust_tail_kern.c  |  12 ++--
 samples/bpf/xdp_fwd_kern.c          |  13 ++--
 samples/bpf/xdp_redirect_cpu_kern.c | 108 ++++++++++++++--------------
 samples/bpf/xdp_redirect_kern.c     |  24 +++----
 samples/bpf/xdp_redirect_map_kern.c |  24 +++----
 samples/bpf/xdp_router_ipv4_kern.c  |  64 ++++++++---------
 samples/bpf/xdp_rxq_info_kern.c     |  36 +++++-----
 samples/bpf/xdp_rxq_info_user.c     |   6 +-
 samples/bpf/xdp_sample_pkts_user.c  |   2 +-
 samples/bpf/xdp_tx_iptunnel_kern.c  |  26 +++----
 samples/bpf/xdp_tx_iptunnel_user.c  |   2 +-
 17 files changed, 184 insertions(+), 185 deletions(-)

-- 
2.23.0

