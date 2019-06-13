Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBA943DF8
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389430AbfFMPqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:46:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43840 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731786AbfFMJkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 05:40:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so10626844pgv.10;
        Thu, 13 Jun 2019 02:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S785yMePDE021tloy76IdFNKeU0Irn+hedVlKYK5ipY=;
        b=TlShaR6epnwL9p3CfCwrB2g6iuxpQoNMpwhNhC3CLXs3o/HZOl58AoynO+xl+dhNVB
         XoNuku3lQPC8g82X2kn8pKX0ecCsvxuo8JrSkHXCCDG16KJjhK1ioaQ0778T1z3dW87T
         SjdOhV6PzC1NwCYDiWnF+BVkO/wvjhWt5dUnOm2W6uUtJIf/5//koj4eHJEYKaeqHVaB
         Buku0/USyDgFp2sWu/qm8/94GNzTFCWWG3aAOH+rDJ2VqtuUNM9nm68aHJP8uvKT9awd
         /i5cSaSgnJ3A4U1kLOsGaAVpkFUD+fe9sqYenPIp5wpxLrwrNKIWLLALGcQ3BwyTrWBM
         fHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S785yMePDE021tloy76IdFNKeU0Irn+hedVlKYK5ipY=;
        b=Y6UkC7GqkYyU4GOqTN2eDDh4XgJF8/GR8IbJzGOd0zJGS5gyrjNwCqr2zbtmA9d2pR
         6zt2OspPNIUZ6ORWYyhzDVemInB1qZt9PWwYJzmbYzl1JW0m24Hto8QFYJRllGH4tYEH
         fqm6Q4rZOTCr60QgU9wfWfiwTAddUAetpPTvg3J6O3fD4yN3QRblfDXWzQMuDRL6VIu9
         sRG1bSP+AnHp1gHp4j1cSCgBs+u3ikrG1pWA2I29OhmW1++Xe8gU0XEExJknGMcRQT5L
         ZCYKS5CT/Wq5H1q4aUJ1DisX9F1DVBip/CPDIXFkiQoZfxvhz5fgipP65uMB9Dartufb
         9qzA==
X-Gm-Message-State: APjAAAUbqUHQDdiRNKswQPrZx4FNmQff+PJSCf3GoKEySRpQBcc5Z1hn
        0blrYr0+Skdgha4RMloR7Bc=
X-Google-Smtp-Source: APXvYqxBO4VpcMKL6uWlpGsa+GzR1EPPEvrVE3sbX1Y8jJSJ+Rdn+SnIhOakvtu6HF8uE4vOgLZWrQ==
X-Received: by 2002:a17:90a:372a:: with SMTP id u39mr4402627pjb.2.1560418830360;
        Thu, 13 Jun 2019 02:40:30 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id y1sm2501015pfe.19.2019.06.13.02.40.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 02:40:29 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v3 bpf-next 0/2] veth: Bulk XDP_TX
Date:   Thu, 13 Jun 2019 18:39:57 +0900
Message-Id: <20190613093959.2796-1-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces bulk XDP_TX in veth.
Improves XDP_TX performance by approximately 9%. The detailed
explanation and performance numbers are shown in patch 2.

v2:
- Use stack for bulk queue instead of a global variable.

v3:
- Add act field to xdp_bulk_tx tracepoint to be in line with other XDP
  tracepoints.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Toshiaki Makita (2):
  xdp: Add tracepoint for bulk XDP_TX
  veth: Support bulk XDP_TX

 drivers/net/veth.c         | 60 ++++++++++++++++++++++++++++++++++++----------
 include/trace/events/xdp.h | 29 ++++++++++++++++++++++
 kernel/bpf/core.c          |  1 +
 3 files changed, 78 insertions(+), 12 deletions(-)

-- 
1.8.3.1

