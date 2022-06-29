Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6511560B21
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 22:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiF2Ugo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 16:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiF2Ugn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 16:36:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16D7369FB
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:36:42 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r20so24186026wra.1
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7sHHxKHhOuhUyVaz8t460JVijEfqsyoKS0CwKfvkjl0=;
        b=gM08TqfCcZduwp9y4LH3yewBYj3Do7LdBWSQvfNTDNljYhWPJeoDrtdXs8XBZVYGxJ
         6lMpadcTCe0uul4g5JTv8097uCkPCSUGAX32kujo2drkmDrclX/tJg0l1qbL+7a7co03
         h5mAnIXJ3rN3OxwfmZ3ZUOM8mwy8XcjIfvr6HwKo+pX8Wp4a/CyC70E4AX53nr5o5boH
         mlxZm1/EUrOFkFAYQf/sAYNdBx32ePHIquvuxc7LZ/qkkmn2bWfbN6QvKdnljfiW6jWW
         rn7+l1ELhZJLNZacTko3RA1d+5zRHGrkiNDYo+5lVUbxNH5WSSp6V6BRZJMh4nwZ41P5
         I0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7sHHxKHhOuhUyVaz8t460JVijEfqsyoKS0CwKfvkjl0=;
        b=U7KzFbVO8a5H7h+5LWKusRkb+n4xNYs7kvx9E0pRNi7CM4zTiFb7owdUVDMJgqHDfC
         YDDHJ5L3chgIeN5T+9OvUeuunaiOIYhnYPG9kvIVSZ5oNSZwx8b6Em5aTX4UILZ6g329
         lr/T2675AKfVuDYAAB7/SSwtO53lDrdgF9zeKChM31oqUvDObwu8bHkQEOclG/Kiy4/C
         7oW8L1SJ5lILuE2es6azrYtm9izlT2u6yxUpYKWfVxK3fgvTpRBeVc6udfS53b9Wjzle
         kuVFsnokrDn023BICmUBJ/GtMonBDgBpFN1y2jiT0Z5q77E2JdPb3quDXhPG8FKw3bLO
         6fNQ==
X-Gm-Message-State: AJIora+1jkUwHryXwxu7Msq+Mm+ohR2ueWSiq0fErLODgpbrMV4nCuLC
        Ik/lkDAyUB/N/gBGXwz+4CJsAw==
X-Google-Smtp-Source: AGRyM1tB7nLIHbrprGxp6vk39SrmJ+3tVPG9H7yfbBEm7qpAph9uqy2wypA/UaEzA/w9D8m1teg2QQ==
X-Received: by 2002:a5d:4a09:0:b0:21b:862d:d819 with SMTP id m9-20020a5d4a09000000b0021b862dd819mr4939961wrq.59.1656535001235;
        Wed, 29 Jun 2022 13:36:41 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b003a02b9c47e4sm246986wmq.27.2022.06.29.13.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 13:36:40 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 0/2] bpftool: Add command to list BPF types, helpers
Date:   Wed, 29 Jun 2022 21:36:35 +0100
Message-Id: <20220629203637.138944-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that bpftool relies on libbpf to get a "standard" textual
representation for program, map, link, and attach types, we can make it
list all these types (plus BPF helpers) that it knows from compilation
time.

The first use case for this feature is to help with bash completion. It
also provides a simple way for scripts to iterate over existing BPF types,
using the canonical names known to libbpf.

The first patch adds a new subcommand "bpftool feature list" to do this,
and the second one updates the bash completion to drop the hardcoded lists
of map types or cgroup attach types.

Quentin Monnet (2):
  bpftool: Add feature list (prog/map/link/attach types, helpers)
  bpftool: Use feature list in bash completion

 .../bpftool/Documentation/bpftool-feature.rst | 12 ++++
 tools/bpf/bpftool/bash-completion/bpftool     | 28 ++++------
 tools/bpf/bpftool/feature.c                   | 55 +++++++++++++++++++
 .../selftests/bpf/test_bpftool_synctypes.py   | 20 +------
 4 files changed, 80 insertions(+), 35 deletions(-)

-- 
2.34.1

