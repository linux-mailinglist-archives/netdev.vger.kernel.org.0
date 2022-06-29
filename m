Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DABE560350
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiF2Okc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiF2Ok3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:40:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A35D369D5
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 07:40:28 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so8879906wmp.3
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 07:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7sHHxKHhOuhUyVaz8t460JVijEfqsyoKS0CwKfvkjl0=;
        b=37CZzmTGcjONXqQok14iIci1Rip+reC5wHZU4UckTWREDGronrmcvPxmmrLr2XWpNs
         D7kPaYLTi/9yi3aj4fniDLY8PAioQ8Tkv3C5dZ+1oM5B95wvT3sssAoSO18re+z6BMG2
         1tezSa6Biln2pBTzLqBw+T0jI0vcEnM0JqNyhyftgSi5+7e4RRmFSOczRnxWzuqNtekN
         3JUojIpQqDaPfZuu7/FPjelrgXIdSWlDjXDTirojz/B4aiUWIYJ4VbbIiy93su5uKCKw
         8DFNKrEFwEC0ZVkngdtbMy1QfEzoBo9aK/pD4QuiS4h3rSm0OTDB61TANz3ucVOAa8kE
         ioMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7sHHxKHhOuhUyVaz8t460JVijEfqsyoKS0CwKfvkjl0=;
        b=0uVB9xx19p4Dmy1vV8oz+uHzEfqsQCQmMPBEjG2Yot+w9Eb8l0VK4P82Hg4RY6kTTe
         yRI0/Nt6XSAdJpwjLv7yyL6jlFVWdQqDCs8H/vPbDECqK4qWcmSQi0rUCgx+hGhsVhkc
         HtCaM1AsIaXBeZduvwDJJp+ej2LycKZtrHrkBDE85aPnBrtAPHMmkYoJHqRyKimkqAdi
         jILHoxeXWkxfou1QQNJxdIb36PWnkbS3LEuJsGiKqZOS8kVB7uhoJN84zqZSFHO8El0z
         vfCgxgqEihtGOy30+BsRUE+g31wOC/On4c15IOmyklaMNm95PHrRVFjhpSGnMMMgNTh3
         rIlg==
X-Gm-Message-State: AJIora/bijw8ZVaRBUOidzfYkf3yr88hNL9GqkO9uzcTY7J2FYQO0JdO
        Jf8b7oi4qQVBpyrmrl3iutyv3Q==
X-Google-Smtp-Source: AGRyM1uBLhlRs4wgFTa2XaFyiRD7YOYHRISXfILlVMEsEpMBSIbvifvBMe2Ql/Lt8aIdoYveHYtA1g==
X-Received: by 2002:a05:600c:4fc8:b0:3a0:3ae8:449 with SMTP id o8-20020a05600c4fc800b003a03ae80449mr4070405wmq.26.1656513626958;
        Wed, 29 Jun 2022 07:40:26 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id h13-20020adff4cd000000b002103aebe8absm16770518wrp.93.2022.06.29.07.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 07:40:26 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 0/2] bpftool: Add command to list BPF types, helpers
Date:   Wed, 29 Jun 2022 15:40:17 +0100
Message-Id: <20220629144019.75181-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

