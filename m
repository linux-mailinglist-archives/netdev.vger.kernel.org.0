Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A66B2B5AEE
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgKQI05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgKQI04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 03:26:56 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AEEC0613CF;
        Tue, 17 Nov 2020 00:26:55 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id w4so15634379pgg.13;
        Tue, 17 Nov 2020 00:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lWxaqBdhoJLWHCbKsjLTbdE3l/2x2uYyyZVuBw0tu10=;
        b=APkdHfk/ecF1LsBLszpAlRHHUwF7IvXnqcnbxW7hhhJ8MKPNjYd61AHClU+GAS9Qt4
         R9hODm2CQko74tD9/grElbeGbTMah1o+R59Qs+iATBj77obw3bLj3/ob91je2Z43dVAk
         RIwTgxt8VleMTe1AOusML/W2EbHSFdrV5OU3XTiwk/S7WiwiTo/+XOq0zTgBzqJ/A7P0
         P8m/DFXGmsex+YBDdjhBAnpV+9b88KMpqpFCgQQr6/U2tAHPIpSKsJG51YQfgioItgP/
         j3H74wtl4arDpK+MSakCpCbGRSGNHd31fnKy1LGcZ5+KMPsZfklQFgEYpjFEmm7m8mXJ
         ikTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lWxaqBdhoJLWHCbKsjLTbdE3l/2x2uYyyZVuBw0tu10=;
        b=LR0Md8ve23lTccz8aFEd+qM8yMJe6+VlLBfObipLhp5dqXKT28Du5Iu/9lxMb4b9ej
         okkMsADTiZGgdUHQK6snKOuW+lEzypNgbgDuWlmhA3+kIqrtj2178K8mFYl8nFqbeMvb
         Za+0TigESt0StbxtdbFvada+uuhJFOrtVu4bfvxToKZGmGS9+HjhftpayolBqX2kDBU7
         H2YKlCGUbiaYVvoS0SACeairKw5ov1j25v73dgmwq146mvKUcPBEhDmH6aqf4bHCEpan
         RGohzdvtSsOzkZPW4NpdWrg6/3zXfdvzR0NCb0SwZ9ZXn/z1K3eYE5TA3jli99T/rHAz
         JQTw==
X-Gm-Message-State: AOAM533RirrPHov645J+g/C0CPVvMVBtlQ6CJx3QvfTZnuWyzBEAN4rt
        9qGO1l/qILOL3aYzAMc9MAU=
X-Google-Smtp-Source: ABdhPJw/20J9aJnynQ18oyYmbo4w4o3XFMN3krvy2E2soJiudn0nqgqvnqu0j1/LsbLxThkGz/UZ/A==
X-Received: by 2002:a63:4c24:: with SMTP id z36mr2569977pga.432.1605601614730;
        Tue, 17 Nov 2020 00:26:54 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id c12sm2251671pjs.8.2020.11.17.00.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 00:26:53 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        xi.wang@gmail.com, luke.r.nels@gmail.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next 0/3] RISC-V selftest/bpf fixes
Date:   Tue, 17 Nov 2020 09:26:35 +0100
Message-Id: <20201117082638.43675-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contain some fixes for selftests/bpf when building/running
on a RISC-V host. Details can be found in each individual commit.


Cheers,
Björn

Björn Töpel (3):
  selftests/bpf: Fix broken riscv build
  selftests/bpf: Avoid running unprivileged tests with alignment
    requirements
  selftests/bpf: Mark tests that require unaligned memory access

 tools/testing/selftests/bpf/Makefile          |  3 +-
 tools/testing/selftests/bpf/test_verifier.c   | 12 +++--
 .../selftests/bpf/verifier/ctx_sk_lookup.c    |  7 +++
 .../bpf/verifier/direct_value_access.c        |  3 ++
 .../testing/selftests/bpf/verifier/map_ptr.c  |  1 +
 .../selftests/bpf/verifier/raw_tp_writable.c  |  1 +
 .../selftests/bpf/verifier/ref_tracking.c     |  4 ++
 .../testing/selftests/bpf/verifier/regalloc.c |  8 ++++
 .../selftests/bpf/verifier/wide_access.c      | 46 +++++++++++--------
 9 files changed, 63 insertions(+), 22 deletions(-)

-- 
2.27.0

