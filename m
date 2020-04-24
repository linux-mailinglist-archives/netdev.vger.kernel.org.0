Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441411B7E65
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 20:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgDXS4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 14:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727033AbgDXS4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 14:56:05 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B06C09B048
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 11:56:05 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u127so12135300wmg.1
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 11:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZwcPKnb5cZ7VoIyj6nK3gkxMikTmBHrFG55t3Mv9UCg=;
        b=c35SoLrq7rs1ZEEBb+3C2NhgTyW7AtBP0qrt/QOvKQIWhvbhfS9j9493wOcWXkZ5XG
         1nodOtITd6jPRwq5tNeWfdd+w/zL8wwPQ6QdxkYQegFG+JspmvORqzwZEbsz3Vv3hmHy
         7C/UrOX7GFXCAYW7cLVlpx+9sQE+WvrjvU3I4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZwcPKnb5cZ7VoIyj6nK3gkxMikTmBHrFG55t3Mv9UCg=;
        b=BOO3vbOLLOLqE5MFUYk2NBYGns/Qvj/W+OZ03X7e/A4RMxyaFam0HZJXpCzakmVhnd
         XJVKrcbLlZSsuGdxHQ1uI63F6JudftvrQQfsy4kuviTvoqcNQC7yxejzcloLaG8pA80A
         0Uk86dycb4ckmlbYZlG1L+vx+fLNZBSDh5o28io+FTAD830Ea3uO0Mf8JzWvXTmK0U5r
         bb9JY0jbVdlepb5cUFvybS/4zff94wPe9zhqQSJJSiCKlFN0VDp2Pbko/gsUmfJ38y+a
         EtOUHx5qO7g7CfKhKatjUCz9939mNanojfN4CxPuwyYrGH5mdvWGPmt4IG1ZRFGejSLI
         Fjlw==
X-Gm-Message-State: AGi0PubiKPzg9iBAuzZlmzIrgy4XbdW1t4pAScfFc1Vo3M3nguzDZmbE
        z/rcVTpLlHOu6gxTkj3aipl+Uw==
X-Google-Smtp-Source: APiQypLnj6/3x5hACLSblJPJSEZ7foGXLvucMXCs24gNeadD4IBCITpw/IEu9UQ6wVZXm2IvmJQOdw==
X-Received: by 2002:a05:600c:4102:: with SMTP id j2mr12341821wmi.159.1587754564116;
        Fri, 24 Apr 2020 11:56:04 -0700 (PDT)
Received: from antares.lan (111.253.187.81.in-addr.arpa. [81.187.253.111])
        by smtp.gmail.com with ESMTPSA id r17sm9263875wrn.43.2020.04.24.11.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 11:56:02 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     theojulienne@github.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 0/1] Open source our TC classifier
Date:   Fri, 24 Apr 2020 19:55:54 +0100
Message-Id: <20200424185556.7358-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've been developing an in-house L4 load balancer based on XDP
and TC for a while. Following Alexei's call for more up-to-date examples of
production BPF in the kernel tree [1], Cloudflare is making this available
under dual GPL-2.0 or BSD 3-clause terms.

The code requires at least v5.3 to function correctly.

1: https://lore.kernel.org/bpf/20200326210719.den5isqxntnoqhmv@ast-mbp/

Lorenz Bauer (1):
  selftests/bpf: add cls_redirect classifier

 .../selftests/bpf/prog_tests/cls_redirect.c   |  456 +++++++
 .../selftests/bpf/progs/test_cls_redirect.c   | 1058 +++++++++++++++++
 .../selftests/bpf/progs/test_cls_redirect.h   |   54 +
 tools/testing/selftests/bpf/test_progs.h      |    7 +
 4 files changed, 1575 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cls_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect.h

-- 
2.20.1

