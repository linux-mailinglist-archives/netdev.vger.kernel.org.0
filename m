Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4650055CFA
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 02:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFZAi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 20:38:57 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:49045 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfFZAi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 20:38:57 -0400
Received: by mail-pg1-f201.google.com with SMTP id z10so417160pgf.15
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 17:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cALMpl1zhJhWyFsIJDuEGXPsZBtZwwHf9RNESh/DFIw=;
        b=q6HF3nqqskhjv+PSJGKOWHW3tR81pXc8EAsARsWrFtWfpmOTBajscuH3kgWx7gTq88
         UscPLsQhLExTfPPb8s8o9eux2AyHu5J31jpIYk81/O8PBTuJbE1/CuA1Quq37WkVBNVL
         Mu+rAsKAh64Fh4K1xmweEiFKJ7qkiDN4VPhJR9ERhv1h0yhwy38SHbCIQbowZ76CEnyI
         Y1+OIb7ZLCdVNWy50zvvroF+R+QJQszp9jsRnW6Nsr+meEuzcJaH9FMiZj0I6pZKbwtI
         4+1gekk3WxjZGND8TJx+/OMxg0HCBgreCjddGO+lzbO+NQRXoimoOWfXso0vFX4cUlnM
         wzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cALMpl1zhJhWyFsIJDuEGXPsZBtZwwHf9RNESh/DFIw=;
        b=ZJXh1nZVG/xSLS9RoLxSVhzkGDlM+q4Xpz0wioigY73i8BR45L+PG3t9cHqCt5Hhbz
         /DWBdGdSPPkf2GTjje02lewGObjeyG5olalt/p2nD7J7fZYwUsE4I97vfpq66vdLdzIk
         7Veabecf67Oo9UZ/tLWJSgmgnUM2tpB/ioJpbzP51pd5f4V4SBfgRXIvnUf/m8g0cBsr
         U1JQUzYH1FdSGPnayYyvFy6DW8UUFFk6n9t6LqIp5+hPGRtyW570IJWqfyuWcW65hHDO
         eNQAUnVau6xFNOVP7lmoiNFKoSZEGLz62xVO3c48rodnJqu4RmToMdsqzzRxMXsvSuTD
         Wcaw==
X-Gm-Message-State: APjAAAVwKCyOMLM2TneLOxgBWeuXFTSbPhg3t5z4OV7SNH/Ov9fpwWrU
        QD5Gfr2qXlx3u/qwodrtdOzLN3RsudB4LxE9
X-Google-Smtp-Source: APXvYqzsBFKGyDA2PqihhPpY6qxeUko0GVwQrfcpv5JxGJZAQguRpfdHPmcPJcuQET+xrL6DT6lvDvFz9BDkRC7U
X-Received: by 2002:a65:6102:: with SMTP id z2mr40322232pgu.194.1561509536303;
 Tue, 25 Jun 2019 17:38:56 -0700 (PDT)
Date:   Tue, 25 Jun 2019 17:38:50 -0700
Message-Id: <20190626003852.163986-1-allanzhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v6 0/2] bpf: Allow bpf_skb_event_output for more prog types
From:   allanzhang <allanzhang@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Software event output is only enabled by a few prog types right now (TC,
LWT out, XDP, sockops). Many other skb based prog types need
bpf_skb_event_output to produce software event.

More prog types are enabled to access bpf_skb_event_output in this
patch.

v2 changes:
Reformating log message.

v3 changes:
Reformating log message.

v4 changes:
Reformating log message.

v5 changes:
Fix typos, reformat comments in event_output.c, move revision history to
cover letter.

v6 changes:
fix Signed-off-by, fix fixup map creation.

allanzhang (2):
  bpf: Allow bpf_skb_event_output for a few prog types
  bpf: Add selftests for bpf_perf_event_output

 net/core/filter.c                             |  6 ++
 tools/testing/selftests/bpf/test_verifier.c   | 12 ++-
 .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
 3 files changed, 111 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c

-- 
2.22.0.410.gd8fdbe21b5-goog

