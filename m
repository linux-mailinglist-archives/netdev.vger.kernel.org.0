Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C0327C135
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgI2JbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgI2JbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:31:07 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C2BC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 02:31:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g4so4565495wrs.5
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 02:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=20Opd1KbzfKVWbWB380MJLXU/LCIpN0t6D10z4zpmZQ=;
        b=HBkYIFLPztSezAegjoJa7iMD9U2nkk04r7vRSAk8kgQchwzCGVULYayP4W1NRnYEEc
         e7kIPUc50JrKrTNr9fVGYSWZpoXpaTEf+dcMXiYm3ZcMBiBdlmWFxq9qVezGNvTzVe0V
         1bQ3KHHT6rWvgClmFFv5i9pwuSP6gFBjjmhXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=20Opd1KbzfKVWbWB380MJLXU/LCIpN0t6D10z4zpmZQ=;
        b=c+QDeSLhtjRKTNm6JrmxYsC2YfLxplaxlD015fAjDGItraY38lsrllezcc8JMFDa4f
         9YTjlBQvDFf5zsYvUVlkO35w416Z88LUiv14BMm88pMGkwXz9LhVH3Q5KwTtmV4LeQTe
         jOcQXiQy6N0wG/6ufXAHdvj8VIPnkfaDZ6itU1cNLCotj8hXUBdApz+nwRkEf/Ftwh6R
         kLcqxaMhSSP+w4LiCXCpBvIKsmErSCbl5YPosVQ4vcKRJNwcFHCTaau2/I2TozeKVo4x
         b91q4b7dN661TA9yQ0nlbwWNdjTCTdzjT9WpEEZzd+dD0SnEWla9fMD8qqEgXkT9KyfU
         P/cw==
X-Gm-Message-State: AOAM530Gagf/9X16DAnemdho8Dcs0X0MuPiK6BY8shXD3IEbNtJQ/gFR
        CXKmTXAeC236KG1ir3JO7LRUZHJy4imX0w==
X-Google-Smtp-Source: ABdhPJy6LeWn0GIvYRj+CvOBY6F5jYDGyylJ5di7VMpxdpfAqQg4f/hqfEe/iKlMRH/F8P77Gy9brQ==
X-Received: by 2002:a5d:470f:: with SMTP id y15mr3143091wrq.420.1601371865690;
        Tue, 29 Sep 2020 02:31:05 -0700 (PDT)
Received: from antares.lan (1.f.1.6.a.e.6.5.a.0.3.2.4.7.4.0.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:474:230a:56ea:61f1])
        by smtp.gmail.com with ESMTPSA id i16sm5246798wrq.73.2020.09.29.02.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 02:31:04 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     kafai@fb.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 0/4] [PATCH bpf-next v2 0/4] Sockmap copying
Date:   Tue, 29 Sep 2020 10:30:35 +0100
Message-Id: <20200929093039.73872-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v3:
- Initialize duration to 0 in selftests (Martin)

Changes in v2:
- Check sk_fullsock in map_update_elem (Martin)

Enable calling map_update_elem on sockmaps from bpf_iter context. This
in turn allows us to copy a sockmap by iterating its elements.

The change itself is tiny, all thanks to the ground work from Martin,
whose series [1] this patch is based on. I updated the tests to do some
copying, and also included two cleanups.

1: https://lore.kernel.org/bpf/20200925000337.3853598-1-kafai@fb.com/

Lorenz Bauer (4):
  bpf: sockmap: enable map_update_elem from bpf_iter
  selftests: bpf: Add helper to compare socket cookies
  selftests: bpf: remove shared header from sockmap iter test
  selftest: bpf: Test copying a sockmap and sockhash

 kernel/bpf/verifier.c                         |   2 +-
 net/core/sock_map.c                           |   3 +
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 100 +++++++++++-------
 .../selftests/bpf/progs/bpf_iter_sockmap.c    |  32 ++++--
 .../selftests/bpf/progs/bpf_iter_sockmap.h    |   3 -
 5 files changed, 90 insertions(+), 50 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_sockmap.h

-- 
2.25.1

