Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420D43CCFCF
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbhGSIUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:20:42 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:41701 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235473AbhGSIUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:20:41 -0400
Received: by mail-wm1-f44.google.com with SMTP id p15-20020a05600c358fb0290245467f26a4so1760058wmq.0
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 02:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gicoTuhx62Lz0IXi9HyKg/EPZjby5OAg9N4Cc+WYi3s=;
        b=UeIE377QK2WGUeE/NyuK7L1kbnQYpERmhrdXLxMaiJl4nTX/JzP4PiWtiw4aw0pntU
         33aLmGIBDoAeyMlQzLIRi7MMyGRHr9sxmEXc/cp3+Xg75zsrv02bEXt0O/V82MZISBQy
         n5j+qMd/honSQ2CDlFw6cOOazEKcl3jlf5wxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gicoTuhx62Lz0IXi9HyKg/EPZjby5OAg9N4Cc+WYi3s=;
        b=BC0noOxi0Ma5cYWZFinQagMSXS9P+/Y1wT5Dsu9P3Pb6BMt7ibcCoz3q9aHv72TxWd
         iqFcid2fW9hGPrh7FmDRm1XrL93hlgLKk0GviyqVJu8GIQb9Nuf13M+p4xOpG0VyILH0
         Dg3vBtbizb75v6MV8NuaQrFm0ZCp2Um5ipg+2S3IbxsV9pJJlM3YKVImTOeZowgnUyd+
         8ltkVVy5XzYVpwzU1WU3AqS1rC1MFeglUlNf8VcG7UKupxPH5qXHSnO2IEKM1kwXZYMo
         Hu+U+62GW42xvgv3vV55kYtq1C56eeYUAZlQFj6u2o3Lk6SVCHpIXn/NHzO2gL+ad+wA
         58mw==
X-Gm-Message-State: AOAM531XfMk1XzIvHwgrVT3qdVRRaC79DrN/A/ca/Ew3KFilgL1pUTR/
        hhcEbIUJyKlLw7Hj2zvy8yihvJTnJ11VTA==
X-Google-Smtp-Source: ABdhPJx00yXKDB0CcKZ1Zx5X9m0kVYKDhWQ2GUaHqEN1fHPkW3nFFGSN6N53fqYurbSRHBVD7FQkig==
X-Received: by 2002:a7b:c208:: with SMTP id x8mr31330824wmi.187.1626684712228;
        Mon, 19 Jul 2021 01:51:52 -0700 (PDT)
Received: from antares.. (8.5.4.3.6.6.4.c.b.0.4.b.8.b.e.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4eb8:b40b:c466:3458])
        by smtp.gmail.com with ESMTPSA id 12sm20079763wme.28.2021.07.19.01.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 01:51:51 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf v2 0/1] bpf: fix OOB read when printing XDP link fdinfo
Date:   Mon, 19 Jul 2021 09:51:33 +0100
Message-Id: <20210719085134.43325-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

See the first patch message for details. Same fix as before, except that the
macro invocation is guarded by CONFIG_NET now.

Lorenz Bauer (1):
  bpf: fix OOB read when printing XDP link fdinfo

 include/linux/bpf_types.h | 1 +
 1 file changed, 1 insertion(+)

-- 
2.30.2

