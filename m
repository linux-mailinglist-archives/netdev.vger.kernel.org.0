Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE74B2548
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349866AbiBKMLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:11:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239498AbiBKMLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:11:55 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F91FE77;
        Fri, 11 Feb 2022 04:11:54 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id u16so10216280pfg.3;
        Fri, 11 Feb 2022 04:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0lNjZ+DwApF0imKf15w8mcxvZtcgQC1cz+0EsKbpnjY=;
        b=EBqlAyRGb0+mQvO2+QiRr1S4ZsXqBXlBGJsqn0hVX/1Xx67vLmqgDEHBeRmHlRCfxJ
         FN/nbDMmjTX8pOLLvjqtC211WK+LRqPNZRBiLMrBFe1WsxTSYhl7SKKsUVOlqsP12osV
         NkbivlUSMUeaoW8sxTIwJaGMH4n4gov8hEO+9tBTESOpWMFot52+30VdDYV8p3P2FgbX
         H4KJ9/yVKGgTieamp+NFl0jpDgFpDWQtZbNzZUy0IVwnh/i5up9mYiUGA4bO5C+qG5n7
         LDE1mKEh0sK9m6r5Bl+D8e1NlY9dr+j4KMZ7VtS7QRxgeQ0ar37+whMVa/hfCuCxW2xg
         xX7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0lNjZ+DwApF0imKf15w8mcxvZtcgQC1cz+0EsKbpnjY=;
        b=rGfVkVLXmdX8vCKRl+pZn/DualMQdksmSK/Qxt92Kr1InYibMOuj2Vw1HS+2sa3lxW
         zRQST4nDspONSeSIj+iPXRlCIQOJxRQBAohO2zXT/vNTkxVARhiW/5Z6+cdrYl+I1pvO
         VdVhqClSUmUFzxt4iZZLGJgJROuxQimcazyfOAb9sAsYJJ1P+0lKa1P70Kcdn47nZ/7b
         edIPzOw8s7Qb2Jq+dsTVWqvtUVuPTjYurbQya492rG9/dewEiDTv0yzEf3BHOS6Abner
         IKz/RFa+Ncf4ovFgbQIJy4O/VRX92o0o/BLveHiGYw2jhkH1o4lnhwjV0633M8XqImIo
         uvoQ==
X-Gm-Message-State: AOAM533XULSvGMrDtZgJjl+Fsdzmi2zUxbZmpOLZMlLcVNIR2jQgjkFC
        k+xOiOdy60ay2bRKByaB8rM=
X-Google-Smtp-Source: ABdhPJw4k4Ho1sGhoGzEsoatlvdHChxKIAQtxkk3etUsws4ARzNnAcCKsiEZCJkMIJ12EsFtrlyPLg==
X-Received: by 2002:a63:5545:: with SMTP id f5mr1066631pgm.157.1644581512886;
        Fri, 11 Feb 2022 04:11:52 -0800 (PST)
Received: from vultr.guest ([149.248.7.47])
        by smtp.gmail.com with ESMTPSA id il18sm5558913pjb.27.2022.02.11.04.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 04:11:52 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 0/4] bpf: Add more information into bpffs
Date:   Fri, 11 Feb 2022 12:11:41 +0000
Message-Id: <20220211121145.35237-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a bpf manager (bpfman) running on the host to maintain the
lifecycle of all the bpf progs and maps on this host.

The purpose of the bpfman includes,
- pin and unpin bpf progs and maps
- attach and detach bpf progs
- update running bpf progs and the related bpf maps
- update some running bpf progs only without updating the related bpf
  maps
- check the possible conflict of bpf progs
- etc

In order to safely do these works, we used many tools to get the
required information, like bpftool and some other customized tools. Some
of these works seem a little heavy. After the preloaded progs.debug and
maps.debug are introduced, we decided to improve these two files to get
the full view of progs and maps that required by bpfman.

This patchset includes below features,
- the pinned file of progs and maps are introduced into these two files
- the relateship of progs and maps is introduced into progs.debug

With these features we may also improve how bpftool get the pinned
file[1] in the next step.

[1]. https://github.com/torvalds/linux/blob/master/tools/bpf/bpftool/prog.c#L648

Yafang Shao (4):
  bpf: Add pin_name into struct bpf_prog_aux
  bpf: Add pin_name into struct bpf_map
  bpf: show pinned file name in {progs, maps}.debug
  bpf: Show the used maps of each prog in progs.debug

 include/linux/bpf.h                           |   3 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/inode.c                            |  29 +-
 kernel/bpf/preload/iterators/iterators.bpf.c  |  33 +-
 kernel/bpf/preload/iterators/iterators.skel.h | 676 +++++++++++++++-----------
 5 files changed, 460 insertions(+), 282 deletions(-)

-- 
1.8.3.1

