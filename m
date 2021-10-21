Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE96D43606F
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 13:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhJULny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 07:43:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229765AbhJULnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 07:43:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634816497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L2e4spOXfMpskoS1N0H4A7qUNY78c1wAiks2CIeTGAQ=;
        b=WGLVZtEmqK1zsETvOMLTClkuxoNouCGM+YRWgeTy5ZQpliHjgrekQ2REpUrX6zG/OZqlj4
        L9i8aWoPM61VLtZz+71d8zPsc3guA+BW//vqQo7xAF+duVDlnN8FvwhYLqeIy9KxbC6LHm
        UGDHsApasSI2RneNY6cMUDqqC2i0xEg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-u48ZTiUMOCGuP4K5gzwbVA-1; Thu, 21 Oct 2021 07:41:34 -0400
X-MC-Unique: u48ZTiUMOCGuP4K5gzwbVA-1
Received: by mail-ed1-f69.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso23937911edj.20
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 04:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L2e4spOXfMpskoS1N0H4A7qUNY78c1wAiks2CIeTGAQ=;
        b=BR16CXkgBin2tMpYYF0QudAW96FVXNDvsxLCBqq9nWqIN4n8obAVaLG6bsMEaHO3rU
         sUAkfXVZsy1/g5mjTO3sm1vFuhGwmTREtasAI8KM6GdiDIlRsQpN4RM+dHm5Q/NgZb3P
         QjykL6T6sGAvw5njIgVG0Dekqtpf7Jtw+QprQ/IIdFscrBfG41Bd2uQq1bO2qL2iAw8u
         1Mq3WV40RYmB3ffxWvpgIiyMyQuzNugF+r3rNAPeBOct3REPxmdW2XKcDtlPrHuz5WHy
         P6ta03w9CNd1ubEdHU3236+CeE5p0BeXzNjdnRTsl8MAxXBJ4u5IrNpZWFyN2Y8IgbLJ
         b9CA==
X-Gm-Message-State: AOAM531cPwCyOb7XxxUx+aaNdlDb3dKy9f0wa6r2QAG++wJ1W7wUHY+x
        pESSm8kiJvAaw2cazImVkWOc+0h6fkvRe2qWHtMYuKQZZ6V5HiLD2ATxozy7VmaoovcIjnuM4a5
        VXHB8JUkHWJz+xZYO
X-Received: by 2002:a05:6402:2553:: with SMTP id l19mr6934936edb.321.1634816493335;
        Thu, 21 Oct 2021 04:41:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0/PpaJBgA3ZF+GNCyLqQ+YOun7Y/ZtdJIj1MoEWgtX6K0YICG+8Suaaa0E9xfjgwyIjkUAg==
X-Received: by 2002:a05:6402:2553:: with SMTP id l19mr6934908edb.321.1634816493207;
        Thu, 21 Oct 2021 04:41:33 -0700 (PDT)
Received: from krava.cust.in.nbox.cz ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id y6sm2459996ejf.58.2021.10.21.04.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 04:41:32 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 0/3] selftests/bpf: Fixes for perf_buffer test
Date:   Thu, 21 Oct 2021 13:41:29 +0200
Message-Id: <20211021114132.8196-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
sending fixes for perf_buffer test on systems
with offline cpus.

v2:
  - resend due to delivery issues, no changes

thanks,
jirka


---
Jiri Olsa (3):
      selftests/bpf: Fix perf_buffer test on system with offline cpus
      selftests/bpf: Fix possible/online index mismatch in perf_buffer test
      selftests/bpf: Use nanosleep tracepoint in perf buffer test

 tools/testing/selftests/bpf/prog_tests/perf_buffer.c | 17 +++++++++--------
 tools/testing/selftests/bpf/progs/test_perf_buffer.c |  2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

