Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF712CED84
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgLDLxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:53:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbgLDLxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 06:53:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607082726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S28IWYpmMbvljShisgwF1Sds0GijR5zbQJ0B1oiVu4I=;
        b=AOH1ik1QFQphqfMc6ia2lKapqQYT/U64er3z+pnTYf2cq2bWSzfLY3Q+X5JMDLfxrOsTPJ
        n4fz9EWd0T/Iyf6xgnvI4iV5kv48bhyvM71TrPVl8KN5VUX+S/khwF1E/89tAh4/1gVdqD
        H2BRZlQZrCdOC3/rF7vlhOPVtSfbiOI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-7EA_iF2mOgq7AGba0W9O8Q-1; Fri, 04 Dec 2020 06:52:04 -0500
X-MC-Unique: 7EA_iF2mOgq7AGba0W9O8Q-1
Received: by mail-ej1-f72.google.com with SMTP id f2so1969501ejx.22
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 03:52:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=S28IWYpmMbvljShisgwF1Sds0GijR5zbQJ0B1oiVu4I=;
        b=mCfbQ7yvMqRA1SBaUKagO2b7heUAf5C9AZTGQpz10aAGgHfS3v2Unsfxe5+Jv8oW2v
         37uN7yEcWKW6pnjy2qCj9T4Gkwg0TmKALBtmuXyVGPWScIzjve/YDjC7h+ye4OAMwO3o
         2iZipJI2VY0rj5IIyNon189eVtn6J3iIwgo5dSHmZ2mIWyxGxQm/HMKheS+Xu3yNzJmk
         AHuNYhKupKTvevMD6v+4DV/t1K3C8VhCBOWb4ZX6L16wDvcWAbdSy8UQJJv5wSzSGjT7
         7gHVZ/HXuadCxLLC3QQNoxR8CVDhZ2RHfXDBaYO4dGcRmyqCj7hnieizCOsmGi/aiVu3
         /Q8Q==
X-Gm-Message-State: AOAM533X9zDOREhHKy8436bRlVSa4whADQMVkBd9F+HK3wVvgNL1OjUF
        KBthz7e1vzgnJecByL9eMIXRVL6uyjxQqPNb+4icZFxOfaLoqm4F6F1WVZQn0M6v5FO3c4Fopc5
        YrWGMWUSxvIrJ0xJg
X-Received: by 2002:aa7:db01:: with SMTP id t1mr7136310eds.185.1607082723561;
        Fri, 04 Dec 2020 03:52:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydWNhM9OGBmoWFurBAWqUsCG+7QPy6zB87nj6ko9cEAEqVbwTS+2jTkztJCQPYTHSUbN60pw==
X-Received: by 2002:aa7:db01:: with SMTP id t1mr7136286eds.185.1607082723326;
        Fri, 04 Dec 2020 03:52:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q24sm3299903edw.66.2020.12.04.03.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 03:52:02 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 42343182EEA; Fri,  4 Dec 2020 12:52:02 +0100 (CET)
Subject: [PATCH bpf v2 0/7] selftests/bpf: Restore test_offload.py to working
 order
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 04 Dec 2020 12:52:02 +0100
Message-ID: <160708272217.192754.14019805999368221369.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series restores the test_offload.py selftest to working order. It seems a
number of subtle behavioural changes have crept into various subsystems which
broke test_offload.py in a number of ways. Most of these are fairly benign
changes where small adjustments to the test script seems to be the best fix, but
one is an actual kernel bug that I've observed in the wild caused by a bad
interaction between xdp_attachment_flags_ok() and the rework of XDP program
handling in the core netdev code.

Patch 1 fixes the bug by removing xdp_attachment_flags_ok(), and the reminder of
the patches are adjustments to test_offload.py, including a new feature for
netdevsim to force a BPF verification fail. Please see the individual patches
for details.

Changelog:

v2:
- Replace xdp_attachment_flags_ok() with a check in dev_xdp_attach()
- Better packing of struct nsim_dev

---

Toke Høiland-Jørgensen (7):
      xdp: remove the xdp_attachment_flags_ok() callback
      selftests/bpf/test_offload.py: Remove check for program load flags match
      netdevsim: Add debugfs toggle to reject BPF programs in verifier
      selftests/bpf/test_offload.py: only check verifier log on verification fails
      selftests/bpf/test_offload.py: fix expected case of extack messages
      selftests/bpf/test_offload.py: reset ethtool features after failed setting
      selftests/bpf/test_offload.py: filter bpftool internal map when counting maps


 .../ethernet/netronome/nfp/nfp_net_common.c   |  6 ---
 drivers/net/ethernet/ti/cpsw_priv.c           |  3 --
 drivers/net/netdevsim/bpf.c                   | 15 ++++--
 drivers/net/netdevsim/netdevsim.h             |  1 +
 include/net/xdp.h                             |  2 -
 net/core/dev.c                                | 22 +++++++-
 net/core/xdp.c                                | 12 -----
 tools/testing/selftests/bpf/test_offload.py   | 53 ++++++++++---------
 8 files changed, 60 insertions(+), 54 deletions(-)

