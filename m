Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3455964FDE7
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 07:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiLRGPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 01:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiLRGPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 01:15:00 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC77BF71;
        Sat, 17 Dec 2022 22:14:58 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so10010086pjr.3;
        Sat, 17 Dec 2022 22:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WvUPvEz+hwLeXYOnxx9RLLvhM9HA9H7x8sj2QfEA/CU=;
        b=ZAPQ1oYxez8wothcZ4zH2H8G9q5MwmTiYr6xquJU8r21S5g5zCIKj5dBIRexUfWjPF
         cbaW1vf09S0zLj+D7MJKdPouYMGJedpVYS5YDd6Mmg4+HtTigM1xnQGdiGq/YNUiXbKk
         sjB8kAzLpcsTW9II3RDaGi4UoGrnQ3ZAWjlPUiDOQ/uyZO9MpINmPBvAgZ3PFVlPLtnS
         PL+wUG4yht1zANg4N1GDJNwE28xr6FCNOVbExKG2IavLcr3SXDByUskUE4EYDel/2V8M
         T6Ndy5TWSF8C58ECRcCBGdL0t/4ICC5ZQPshn1LSyd17T0tcXFG0LfTf1jBj4l6DctDc
         sSHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WvUPvEz+hwLeXYOnxx9RLLvhM9HA9H7x8sj2QfEA/CU=;
        b=tB/choqkDDagq+ig19q69DRorS+ksZGpqgp12O4PWzGuLYUcgVvDHS7I1RVG4bdxtj
         SwVymnTRuKaUtWSVgigzpyMj6z2CXef6JcFfGAyT8cWo1vcZWvT/U7SKVo8n9JxOQGcr
         8RTiRi7qWOPGT0W0h9zU6cDNL93v+lk1eZPeF4CPXhPh1att1t0bTjAqanfyddDjf8RC
         Tq1ZrwGOGkeBXYHWmLPvDRzoqMICUuXpY9Ad6im1GnEXILgup7wzIlyH0emcMmLFIj3G
         rd7vmNBs8jOXACZVd3d3UbDuZSvk4X7xs4dMiha8fcUqro3yoRsAjHYyNr/ByLx2g2g4
         soxw==
X-Gm-Message-State: ANoB5pn7uwa9/gcBf+WEt6KLc4Fuc8rRy1HmQcFf3b8mURnTVyfgXY/J
        eaV3kMi7lz0N3nWAvSpYeA==
X-Google-Smtp-Source: AA0mqf5IPHPInjUtNdx919G9phmoMMYrTVmB1j0tKH/JCc92w9QfOKPbyhL59UH7y4dGiomRzBg88w==
X-Received: by 2002:a17:90b:300b:b0:21a:a0e:4a8b with SMTP id hg11-20020a17090b300b00b0021a0a0e4a8bmr38592149pjb.2.1671344097709;
        Sat, 17 Dec 2022 22:14:57 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id r21-20020a17090b051500b00219eefe47c7sm3721836pjz.47.2022.12.17.22.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 22:14:57 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v4 0/3] samples/bpf: fix LLVM compilation warning
Date:   Sun, 18 Dec 2022 15:14:50 +0900
Message-Id: <20221218061453.6287-1-danieltimlee@gmail.com>
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
Changes in V4:
- Change the cover letter subject

-- 
2.34.1

