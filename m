Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFFF16B894
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgBYEqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:46:06 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37053 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgBYEqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 23:46:05 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so6515638pfn.4;
        Mon, 24 Feb 2020 20:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HCVc3i9d3S/qcUpJff2WYyjdf86w+Z7qr4+taVELhb4=;
        b=qAVJSW7RAgfZGvfyiSBLu1F1qhdFjXkE8xJTqEzZt333W/krXdLyn22u+T0pK14CBt
         aBZwBMlZZBDSsKqU8sfQTNqHwU/J2KB+zXcPLyOp+Tg5LSI7GQC/Gq5iKqr0MJGz06iy
         hJcst9b0VQfcTfuhaDoqhOcvBzNH9dP1GRm7E5ZWYIOq0zm/TxWFjUq+sxpl9eVHNVWM
         2i5VQoRP7UvNJSdRcfhJDc1eb1viFAEVEdsDwB78i1/ZEjWNgFgVIbdqUVXi0PakA53+
         M2I4MGnfiNDtJQ0FLheBMEHQn+Ftce1iUI5+AnNsryGNIbRMbZunNw2sO1z0Qvsu2bYB
         rXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HCVc3i9d3S/qcUpJff2WYyjdf86w+Z7qr4+taVELhb4=;
        b=ExKXYRYaVIR/nOaBP2hQnZOd60z5okf8MF8ygMG4FXFolA9Kzq55aTeZF36VeoJuAR
         30xmNS53PMwaL5zLxWOvA39EeFe6uBzghEjako4VEgni0BhIi8aN9r/JLnnINNcQCXug
         srJX7b+qAvjpOBLVb+GDJXgMnAp/jS+2yzY2/5wUqQrxnUkfqTrEq44SSFqpfpv3Ellm
         OYksCHld5CzVLWONdT0M9glSahcnXFrzlenoMu+Z+zMhp7DeC78ZCVg33/+epCsBSA9G
         bDjUhiKPmEglr5CcgXkS5IccmT0DWKQIQY3QKR9rkYzyQNY/qUD24DjVc47ntBUyrCtO
         j3Lg==
X-Gm-Message-State: APjAAAUeVTSHYZgTpQoFaPy+SM7JpKWW7Hr95ic3oaIEtoasD3l2KsRN
        2BGxYRTBTJ0a7pxvYHdhEUF5Ed39/rA=
X-Google-Smtp-Source: APXvYqzdgAVkcj6/SSD9kRG26CjGcEzoUEqF0Wk87X4XzI/A8SPlR7fHGP5atRyB0AiGBGapxO3e3A==
X-Received: by 2002:a62:1456:: with SMTP id 83mr55965186pfu.186.1582605963455;
        Mon, 24 Feb 2020 20:46:03 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id l13sm1170879pjq.23.2020.02.24.20.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 20:46:03 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Song Liu <song@kernel.org>,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH v4 bpf-next 0/3] bpf: Add get_netns_id helper for sock_ops
Date:   Tue, 25 Feb 2020 04:45:35 +0000
Message-Id: <20200225044538.61889-1-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
References: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently 5-tuple(sip+dip+sport+dport+proto) can't identify a
uniq connection because there may be multi net namespace.
For example, there may be a chance that netns a and netns b all
listen on 127.0.0.1:8080 and the client with same port 40782
connect to them. Without netns number, sock ops program
can't distinguish them.
Using bpf_get_netns_id helpers to get current connection
netns number to distinguish connections.

Changes in v4:
- rename get_netns_id_sock_ops to get_getns_id
- rebase from bpf-next

Changes in v3:
- rename sock_ops_get_netns to get_netns_id

Changes in v2:
- Return u64 instead of u32 for sock_ops_get_netns
- Fix build bug when CONFIG_NET_NS not set
- Add selftest for sock_ops_get_netns

Lingpeng Chen (3):
  bpf: Add get_netns_id helper function for sock_ops
  bpf: Sync uapi bpf.h to tools/
  selftests/bpf: add selftest for get_netns_id helper

 include/uapi/linux/bpf.h                      |  9 +++-
 net/core/filter.c                             | 20 ++++++++
 tools/include/uapi/linux/bpf.h                |  9 +++-
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 11 +++++
 .../testing/selftests/bpf/test_tcpbpf_user.c  | 46 ++++++++++++++++++-
 5 files changed, 92 insertions(+), 3 deletions(-)


base-commit e0360423d020
("selftests/bpf: Run SYN cookies with reuseport BPF test only for TCP")
-- 
2.20.1

