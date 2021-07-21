Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874AB3D1979
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhGUVRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 17:17:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229916AbhGUVRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 17:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626904694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Siz/P5D/M03bAys99ZaIKAlUV73f5y7wfF/yizEdY04=;
        b=UCBaOOXR7K3P9tqA24seebQDA7NIuvSMMYKe6O/rKnP6PrnOpbHGBlRthvuSuXkoWRXYtW
        ow9tppzZAMsPJDjCKVhWUMO8sugk/WRWJ1oKUlHJLvBdTCgPBJLpd2dhH1N082WJxo0V/H
        6Wn+8n32PgC2lz997EqRBcL8iIW65tQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-TKm0O9YbMySNKVD-4eSmrw-1; Wed, 21 Jul 2021 17:58:12 -0400
X-MC-Unique: TKm0O9YbMySNKVD-4eSmrw-1
Received: by mail-ed1-f72.google.com with SMTP id z13-20020a05640235cdb02903aa750a46efso1734381edc.8
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 14:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Siz/P5D/M03bAys99ZaIKAlUV73f5y7wfF/yizEdY04=;
        b=g1dLQO51RlCmRsFww2k7gIupEPaH0WtJsG6tENP45e2UbLTawEy/pLU1kcwWP2LWqC
         HhSEJWE66rUmwVk4rQDfkr0FX+mtwuD8SPIl9W3IJzYh7s0eDj+oIt3zRDAqCG4/dKKN
         3ygjqFV9qIIMtHm1Cj+mghRBMq075OQI+vZb3HksH2tHJIGVdo9DSW1E9B4xbEvto54+
         mUF0lxsHORHdwmc92CJJdMWpZe54ntusM/bdsOZNxb6htzW9jaGE1DkepDlivkTxEIGB
         gEzNCXBfCJe6mMH9aJ4AJ+4MiMi7zspkFOZH1A6XDx7JGM6nqaq75NeeTFONkv18NhkV
         m5FQ==
X-Gm-Message-State: AOAM531N05Z6O92vghN99eYrg00dpYpBqwCU0z/79shNWOVAUCsWVzeh
        uf6UwyWkzJ0hhGDOuB+ELAG7r52nvk2KoFNsZlSzwcsISQ3poSymrEIgeSTNMxmgFlW/94cBFa/
        I08Jdg9uva2J+dxv9
X-Received: by 2002:a05:6402:1396:: with SMTP id b22mr24377548edv.380.1626904691574;
        Wed, 21 Jul 2021 14:58:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzITIPYeAo63PJ0MDgStSYALzx9ZaL9PNYQW33NTSP+hHHmPMbJx43mSxQAcRshbyH8THRzfA==
X-Received: by 2002:a05:6402:1396:: with SMTP id b22mr24377531edv.380.1626904691430;
        Wed, 21 Jul 2021 14:58:11 -0700 (PDT)
Received: from krava.cust.in.nbox.cz ([83.240.60.59])
        by smtp.gmail.com with ESMTPSA id kb12sm8763228ejc.35.2021.07.21.14.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:58:11 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 0/3] libbpf: Export bpf_program__attach_kprobe_opts function
Date:   Wed, 21 Jul 2021 23:58:07 +0200
Message-Id: <20210721215810.889975-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
making bpf_program__attach_kprobe_opts function exported,
and other fixes suggested by Andrii in recent review [1][2].

thanks,
jirka


[1] https://lore.kernel.org/bpf/CAEf4BzYELMgTv_RhW7qWNgOYc_mCyh8-VX0FUYabi_TU3OiGKw@mail.gmail.com/
[2] https://lore.kernel.org/bpf/CAEf4Bzbk-nyenpc86jtEShset_ZSkapvpy3fG2gYKZEOY7uAQg@mail.gmail.com/

---
Jiri Olsa (3):
      libbpf: Fix func leak in attach_kprobe
      libbpf: Allow decimal offset for kprobes
      libbpf: Export bpf_program__attach_kprobe_opts function

 tools/lib/bpf/libbpf.c                                    | 34 +++++++++++++++++++---------------
 tools/lib/bpf/libbpf.h                                    | 14 ++++++++++++++
 tools/lib/bpf/libbpf.map                                  |  1 +
 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c |  2 ++
 tools/testing/selftests/bpf/progs/get_func_ip_test.c      | 11 +++++++++++
 5 files changed, 47 insertions(+), 15 deletions(-)

