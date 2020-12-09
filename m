Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EBA2D40F3
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgLILWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:22:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729130AbgLILUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:20:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607512723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xSOTlsGZZ/ADfKcdaJ8Ay5xDLSKq4CczFccCePJHcIk=;
        b=IT7tOjNU/v/A2MwUc+8BWQBfrwgDfAHQrhYC1xLjhp46/eIDZwiyfTixumlD7ymS/9u2Mi
        0JfrZpfIs1tsFNwGn/QfEK7QM2B0e4X+i0dJe5IKmrOjIxU3WhvpL6ihLtylMTsFBJPPvO
        fE/y52MCUp+NlvBQ3/cKrbGFLhFiomw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-BKdZmGRnNliJHQPX288lfQ-1; Wed, 09 Dec 2020 06:18:41 -0500
X-MC-Unique: BKdZmGRnNliJHQPX288lfQ-1
Received: by mail-wr1-f71.google.com with SMTP id b5so539608wrp.3
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 03:18:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=xSOTlsGZZ/ADfKcdaJ8Ay5xDLSKq4CczFccCePJHcIk=;
        b=uVPGP2kBpY12GVTxy+cNzqaJbON6ZForDnCv+bOeQFdamo9AUVftm3oDRX9S7OQaQQ
         61Ycxy2Nw3GmnygcA9fbym0FrPA3sZIT568eofTHGS82Irtaj+GQ2bPqSmXPxdA+FTr8
         CJMene9Fxzx+3xG/qH+fQjDZhxA3ytNS2ukbj7fuRkYrxZLrrJDtApfUdsRi7pdMQYGd
         FNcb4Wv2cGzc7VpnaVENdBSHBHmB6tD2GbO7Nb7EMNl9mUEsoBUFhb9Onh5LxmWTjj30
         f5mP64Tpb0QI2Or8cjT3lmgHsqIqWbjGeDx+0l3j0A/EK330l7Ng+osUp0nqb2mdaV90
         BMMQ==
X-Gm-Message-State: AOAM530d2591VZ1TJssGarhfimf2z2EJkDcziLsrGSNm+AQdNbQyiSmF
        zscljoV58CHrjDM/XkvOm8LXM6uMikqv0srhmdNheQgjK14+HKT70gMI72rWcFU454DM3IYo+l3
        ivH93Wh9nDEkqPZNl
X-Received: by 2002:a5d:4209:: with SMTP id n9mr2104997wrq.128.1607512720465;
        Wed, 09 Dec 2020 03:18:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzm5RxsK1e736lOeUy/K4LoocHFwg4m6StAtUALim1kfo/PoU+Wv+tRPAcTaMmDK/AR8J9m6Q==
X-Received: by 2002:a5d:4209:: with SMTP id n9mr2104984wrq.128.1607512720296;
        Wed, 09 Dec 2020 03:18:40 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m81sm2860764wmf.29.2020.12.09.03.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 03:18:39 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1576A180003; Wed,  9 Dec 2020 12:18:38 +0100 (CET)
Subject: [PATCH bpf v3 0/7] selftests/bpf: Restore test_offload.py to working
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
Date:   Wed, 09 Dec 2020 12:18:38 +0100
Message-ID: <160751271801.104774.5575431902172553440.stgit@toke.dk>
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

v3:
- Add Fixes: tags

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


 drivers/net/netdevsim/bpf.c                 | 12 ++++-
 drivers/net/netdevsim/netdevsim.h           |  1 +
 tools/testing/selftests/bpf/test_offload.py | 53 +++++++++++----------
 3 files changed, 40 insertions(+), 26 deletions(-)

