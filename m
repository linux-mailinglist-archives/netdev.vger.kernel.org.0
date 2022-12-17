Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C8064FAE3
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 16:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiLQPy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 10:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiLQPyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 10:54:32 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22A38BA83;
        Sat, 17 Dec 2022 07:38:26 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 4so5106689plj.3;
        Sat, 17 Dec 2022 07:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gOTJnG6wc+5tybZazu3AwKG+4eTKFJX9cjLQMl+q8gI=;
        b=kkFWtYe94sfoX6e1pT4cccrGF4IieqbeS68bN48VDqSa54hbqiRILT19iCikK0rDVG
         2FJTsruzGZFA4id/f2+IPey3MtfuUFGMqsS3cAQ8SvlRyYO459liHaw+kVlzDtazJy8q
         m5idgvJCBapznhTc4VlOtluRMODAxhzeMm4ZJi0Kz7EypZ6sCYgm6hyLkx3KAGHSKM9i
         vGl/UNVQ2AvzP4Lupv8qlaeazNk/Z8ESLc4KWDc4TFE/Jtx/yqoTZmwj3PyX4goF/BV5
         TDJtrGEi4C/ESwrcwUcVfs25d1ETFV3y+dOb6/MhOBuR5m2f+FcfF/cs01rsfd4jOR6H
         rvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gOTJnG6wc+5tybZazu3AwKG+4eTKFJX9cjLQMl+q8gI=;
        b=QIn0MFmLNYwr6gp/r8yqHCPsuAyPOuaGF1oR5hl5CDq5q/Vkdc33xD52RsdzlJuDcf
         SjZpPHPECDUJfuiSnJsQRi+ULLiBLQtF1sb2CPiIzRpE0IuZPWsNCtHP7pQ0WGjVloF9
         +5blITrV6K0YpNTvPYBD2QdrnQ48k4IHSFyP0W/O6+KPftAPXNW1srYBhkGbWbxsEaJ8
         XhyjvkZapPx0i5/lhwI2C5T3KChh32gPDLCKfYK58LItdOZD36e0TqK9sNYN+T9xRadk
         OmWCunKJiWZcSt5NcrQQBjdvsbL19gZB5oHj4ay0qq4w8W0RFhKh7hqEPGYdwvAenNaJ
         GHCQ==
X-Gm-Message-State: ANoB5pnqOHS666GeC6qLNSx1ik3+EYblF1ag8TYT79xJ+sUwNFsvaxhg
        eFTAUMDrONHMHfFrLxjnxTLeFQ/nJNpZ
X-Google-Smtp-Source: AA0mqf6Zs0Sn5+9w7PtgU6NiVaae5QBSOmNjvzndRJO9K1GaUJrsMiutWbZK16e2WVhp+WmtrOFo9g==
X-Received: by 2002:a05:6a20:429a:b0:af:89c2:ad01 with SMTP id o26-20020a056a20429a00b000af89c2ad01mr16381006pzj.40.1671291506159;
        Sat, 17 Dec 2022 07:38:26 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id u31-20020a63235f000000b00488b8ad57bfsm732039pgm.54.2022.12.17.07.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 07:38:25 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 0/3] samples/bpf: fix LLVM compilation warning with
Date:   Sun, 18 Dec 2022 00:38:18 +0900
Message-Id: <20221217153821.2285-1-danieltimlee@gmail.com>
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

-- 
2.34.1

