Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DC364FD49
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 01:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiLRAnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 19:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLRAnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 19:43:14 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74509BC99;
        Sat, 17 Dec 2022 16:43:13 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id n4so5821800plp.1;
        Sat, 17 Dec 2022 16:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e2c8ZL/8/h1Gdu4/0xKpRnjB2QYVOuqhbuJPyLPQI/Y=;
        b=TCTkFdIGC5brUhfozD1SJQhdJu0UuD0T/DRL2jqnkaLQ20XHRadU19oz8nmwD/UUSt
         plVkHmA9o2kRstAMV6aiq66VlNoPQJ8oNA+UwrNFTU82M/Ay3SXkKAXjmeSPjcNA9OUp
         EcB76+ugoPTZZWRCl0bbrXFpq1eywPVDHGrXFvICKrjN0YybtbtgM+NwC8aetA6h/pPb
         SzimkXUKkco/G4cXBVv8JQzY2rRdr4DnGOi77KrH9exFuipp/rxjf0zmtLRAbcEoYW4X
         Yu4oCTsGqTxCZhMQg2OJ1pLX/3wKflCVdt9VSQ+4MXqbcNPCzoj48O3UrWl+iYhj3DFu
         9YDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e2c8ZL/8/h1Gdu4/0xKpRnjB2QYVOuqhbuJPyLPQI/Y=;
        b=ScRr36diGmIJCqe7UV89X/oxL9iimGLUHMPFJYxjt7MN2axOrRemRS0AvzzOSKBPMR
         bOGk0hZV2VEs1xt+9b/fi4LM/gH5oQHVe3AJunLWqYPXZYlJliS8VZEAXvW26+bo19E3
         m7dWA0oWMM+cSaWjbA0tSaVOC3ehtlOFHU/Q6Dg4B3A3NhneTxYsIT4z0CANVFB4UfXu
         qff4vvaWW20+blY4YwxBp+6Qs+vijT+s+j61/gkPG2aB3RROkpuwdHoq4bn3O0fOEdVF
         FvQJ9dS2oGzTgWJqmmobdRH+TCcukYzF7w4W/aRT/t2p+UWD/nRAIDrJgidFzSmchrSR
         KPog==
X-Gm-Message-State: ANoB5pl7Qw5rXg5YqIzQ07Iq6d82XPRX08JH+lOGsoR0vYIy5rn2Noh7
        LL9TlIdun+Vp5h3EmppVCGGWysCq/wru
X-Google-Smtp-Source: AA0mqf6kFhcAUjvJfYKVsmHmG2NnbE5uQSiXjpQ26jjS9p3YSWZZE1hksdSJUizzeZbR9Ih4L7q6hw==
X-Received: by 2002:a17:903:251:b0:189:7891:574d with SMTP id j17-20020a170903025100b001897891574dmr43532883plh.47.1671324192929;
        Sat, 17 Dec 2022 16:43:12 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id k10-20020a63ff0a000000b0047048c201e3sm3639458pgi.33.2022.12.17.16.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 16:43:12 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v3 0/3] samples/bpf: fix LLVM compilation warning with samples
Date:   Sun, 18 Dec 2022 09:43:04 +0900
Message-Id: <20221218004307.4872-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, compiling samples/bpf with LLVM emits several warning. They
are only small details, but they do not appear when compiled with GCC.
Detailed compilation command and warning logs can be found from bpf CI.

Daniel T. Lee (3):
  samples/bpf: remove unused function with test_lru_dist
  samples/bpf: replace meaningless counter with tracex4
  samples/bpf: fix uninitialized warning with
    test_current_task_under_cgroup

 samples/bpf/test_current_task_under_cgroup_user.c | 6 ++++--
 samples/bpf/test_lru_dist.c                       | 5 -----
 samples/bpf/tracex4_user.c                        | 4 ++--
 3 files changed, 6 insertions(+), 9 deletions(-)

---
Changes in V2:
- Change the cover letter subject
Changes in V3:
- Fix style problem with the patch

-- 
2.34.1

