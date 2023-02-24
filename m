Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737FA6A1683
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 07:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjBXGN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 01:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBXGN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 01:13:57 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5426A13D45;
        Thu, 23 Feb 2023 22:13:56 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id y19so7023803pgk.5;
        Thu, 23 Feb 2023 22:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u6LaMT+9/o80hxcj+tCYLFx1OmLwo/BfpzxRAXY8SmI=;
        b=Jww0d5IalT+o18Trpl2xOdKqmmNj7NE9uGuAVGP7ir1Tks2jEn8VMwxKuIOSr4sIW7
         2/tY4Qdq/mSSsQr+bCm+zBtcSgI3tnM6e3qAL3r6hT54EM2tyvTqREVTn0YzRXET6xdM
         imL6Qkq9+l4vH2W5vYCJt/NWVN9faibyZE7DrfnaPxBKmVwh8V1j9fN2nNQvYh/RZiI4
         I9M8nV5wIhXfICZ7RZfNjvsy16a72heDsx5HcIA6SLIUsWpXabP3dzm87DTRMs3LORED
         oxAPhzPJwjfvzB4pokXZx4RlwzlnGcyrrXxepgzG5CYi8wtusDbvgNNOrPtGZ2GeG1+g
         qxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u6LaMT+9/o80hxcj+tCYLFx1OmLwo/BfpzxRAXY8SmI=;
        b=GhBU808rgTT3PcFkMzuG8owaPaoGU3LQ9olcSGjCIQDZmLwRCbFQn7A9Hxbyeqgfac
         mE5dk6kSf2VxT/xnqyj3BDePbPg/E3LsTP/3d+47x3k9tmRI+lNDgrU8YWZTfc70+YpZ
         2nC4T74tGXlTbvJz5YflXhkVG4AmG8tSSGOolYOqghG1vALawIP8T7nNrVw7iHVDhz25
         Spg0OZByfFbfJHlCp0ie0Qil/RgGXOiEbjP5lKWBOJC7Bf+gVC95ko4oYR3SmZOQLBW/
         cEgWl8zEyhGbxJEwdQV8D0dIFE7JjNnN6fJkorQKX2cPqBRPqzm1PDfnP8Rbn9brMEFP
         vEJQ==
X-Gm-Message-State: AO0yUKUuFEV6f0CvhHD+RdFZoWHbWIRsiJlpnmR6ZeEROQslIBbrJIhZ
        2VSKRxt3p/c+sGuYk30slkAC2XRnruI=
X-Google-Smtp-Source: AK7set8B9/T7XeuNW3pQ7+SWnihOlyNtvcdFxqAnwnyIylIXs5kLVKs/Xv3XNdn0atna0w99QUBG1w==
X-Received: by 2002:a62:1aca:0:b0:5a8:d407:60f9 with SMTP id a193-20020a621aca000000b005a8d40760f9mr12094268pfa.29.1677219234924;
        Thu, 23 Feb 2023 22:13:54 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e24-20020aa78258000000b005afda149679sm2336071pfn.179.2023.02.23.22.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 22:13:54 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.linux.dev, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 bpf-next 0/2] move SYS() macro to test_progs.h and run mptcp in a dedicated netns
Date:   Fri, 24 Feb 2023 14:13:41 +0800
Message-Id: <20230224061343.506571-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
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

As Martin suggested, let's move the SYS() macro to test_progs.h since
a lot of programs are using it. After that, let's run mptcp in a dedicated
netns to avoid user config influence.

v3: fix fd redirect typo. Move SYS() macro into the test_progs.h
v2: remove unneed close_cgroup_fd goto label.

Hangbin Liu (2):
  selftests/bpf: move SYS() macro into the test_progs.h
  selftests/bpf: run mptcp in a dedicated netns

 .../selftests/bpf/prog_tests/decap_sanity.c   |  16 +--
 .../selftests/bpf/prog_tests/empty_skb.c      |  25 ++---
 .../selftests/bpf/prog_tests/fib_lookup.c     |  28 ++---
 .../testing/selftests/bpf/prog_tests/mptcp.c  |  19 +++-
 .../selftests/bpf/prog_tests/tc_redirect.c    | 100 ++++++++----------
 .../selftests/bpf/prog_tests/test_tunnel.c    |  71 +++++--------
 .../selftests/bpf/prog_tests/xdp_bonding.c    |  40 +++----
 .../bpf/prog_tests/xdp_do_redirect.c          |  30 ++----
 .../selftests/bpf/prog_tests/xdp_metadata.c   |  23 ++--
 .../selftests/bpf/prog_tests/xdp_synproxy.c   |  41 ++++---
 .../selftests/bpf/prog_tests/xfrm_info.c      |  67 +++++-------
 tools/testing/selftests/bpf/test_progs.h      |  15 +++
 12 files changed, 210 insertions(+), 265 deletions(-)

-- 
2.38.1

