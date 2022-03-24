Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDCD4E6486
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346111AbiCXN6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350692AbiCXN6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:58:38 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C580ABF79
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:57:06 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t13so2662842pgn.8
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wn1jTjVPAF4WJ0iAxAHVjzl8mp8Sci1Yq6/1VczWQXg=;
        b=UlHh0p/KqyAfHs9rFeQZUwOKk+w+J20my3kHJEwYqL7RfwVXSwenEdG56/DWZY2BJ6
         IMEYZf1RRi62aG5J1CvSjRlFayjaererrUlGEy3zVZocjcrjyAt45D0LuOLdgv2Er1IE
         1Zu9T2d0m86O0aqXymkIs8h583SmtQlXEMk/CEhBogsNfcnuJX/4iETMtHl4Dhs1Prab
         ayzAN7inv/ZW/99ZgkN58dyibyX2+ASiAtCiDGM2765TWX7NwjPWvPC7DhCmEaXsUwUC
         PYgKW1lxqif527KNF5CTUc1k7+pDpWU4JXzXyf9rgrqS7wacGxjkC3d+thJUR55l9adq
         NEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wn1jTjVPAF4WJ0iAxAHVjzl8mp8Sci1Yq6/1VczWQXg=;
        b=zuZ/H9tLcmFxCqTJlDKcGkwENKgrzgkbLcF/hwsWtDAfcYOdavHIDSB+igOgfH2f2v
         B88f1wVH+c728JG36jE1vCyGTfFDFsREX4/Q3kgpEnJEQJvnpxsAZtrm4khN6YKrLVub
         DOb99fXCXkKzbViTmrWw1dmRgOtDSxd0iqhi/70b9/EVHyR/SsgjDrw7C8WwAKtudByl
         1HkXgi3CZ6OfDsf8JWW/mtnXvSz54J+4VLiT+CAz/hKATX2s8Oxm2IxmhMgGZUSQi+oQ
         HaMs4A9Tkhn5mhTbLFZekSr9mr4qi4vQcvqaV+3sK5B10HdPc3CEDbRTsZ9HXx/y39N9
         iKfw==
X-Gm-Message-State: AOAM531p/TwITQaGpPJIZ2q2nrdED8HQTOErWR37AIm+CyARoPFOFXBA
        dsHBP91AAwKnC/5WFYAnyDQddAbP8LizFw==
X-Google-Smtp-Source: ABdhPJz5Tx1x4EYLsqT5F9ZZ3w2ZuAAiUpI/cxpJJJ5yTf5dnxPCS7SSPOb7vblnn9KuA8eEjpCBBA==
X-Received: by 2002:a05:6a00:810:b0:4fa:e869:f4b5 with SMTP id m16-20020a056a00081000b004fae869f4b5mr4684916pfk.54.1648130225651;
        Thu, 24 Mar 2022 06:57:05 -0700 (PDT)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090a2a0900b001c6e540fb6asm3282991pjd.13.2022.03.24.06.57.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Mar 2022 06:57:04 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [net v6 0/2] fix bpf_redirect to ifb netdev
Date:   Thu, 24 Mar 2022 21:56:51 +0800
Message-Id: <20220324135653.2189-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
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

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patchset try to fix bpf_redirect to ifb netdev.

Tonghao Zhang (2):
  net: core: set skb useful vars in __bpf_tx_skb
  selftests: bpf: add bpf_redirect to ifb

 net/core/filter.c                             |  8 +++
 tools/testing/selftests/bpf/Makefile          |  1 +
 .../bpf/progs/test_bpf_redirect_ifb.c         | 13 ++++
 .../selftests/bpf/test_bpf_redirect_ifb.sh    | 64 +++++++++++++++++++
 4 files changed, 86 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_redirect_ifb.c
 create mode 100755 tools/testing/selftests/bpf/test_bpf_redirect_ifb.sh

-- 
v6:
* remove 2/3 from v5 https://patchwork.kernel.org/project/netdevbpf/list/?series=592355&archive=both&state=*
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
--
2.27.0

