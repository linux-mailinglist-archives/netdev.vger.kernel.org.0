Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974666E9463
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjDTMcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjDTMck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:32:40 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893537A80;
        Thu, 20 Apr 2023 05:32:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2fe3fb8e25fso359651f8f.0;
        Thu, 20 Apr 2023 05:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681993936; x=1684585936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kLLXiVx5ZXlRbmgfFrjTg14WDa0lYtFvhw7NAI2mimo=;
        b=N5XToj2hnv44N3U9CSsIIV7oCSE2c85rC2hUBDjRCThisqIoRHOb5eIa0n4PLSVJUH
         H+2XaiUCQX+M0VabhKvfZkdEWrOlkKImOF4NPYpuYstsZhc86lnnUANENB8Zo/JgWS9+
         Pzzu80xXoyxuJroSSVZOg7q8NfVr/sx9IkeLllnqPFx73lo+6yQcKC33pmMKFFvEUIrF
         JFoZZ1sH8weh7thDyLGSzFu8rKpkL3U45FClwUmC6aP3G35t79SThH5CP4z2fSDgk7No
         TcGvQ/03+2iNRDd3Fnvn49aVexqvSH+kfv6CQHTolZHLpXScizWvkC+ASs7kaVcgCXut
         0Dqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681993936; x=1684585936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kLLXiVx5ZXlRbmgfFrjTg14WDa0lYtFvhw7NAI2mimo=;
        b=dMqThB+cWY9d3DwHuQWT15u2haBvDNFVyqupyCj4sL2Y6xIw9a886pRVg9DZ2fALKJ
         rdIccUpz1F9L9uhmnxOTxzCTPjCA8WR413oUvbzCna5hwr9lGvT/jwDyjE9qIkJFOnuN
         ZuDeEe/Lhp0qDI8YvtG9jCJ/ho8hz9AYx1/zWJjkybRZQhw8+BU3eEBdWVuJXE9p1WSg
         zv0IvBdjly7REO3G7uPBop+gVwViBL2ljhBMnBKxjI8IAjmaGiztiRWWYs/Tfdqvw4om
         MIbCSiA3tLnTTyTHVn7OyJ2ci1Yot3rtKjG61I/lcYO9BB6D1ZsHz0te16IYz69L+Xjt
         8qfA==
X-Gm-Message-State: AAQBX9eiBIhqcD32MvpXMf1Wl2gxFsai1hEQ9N4dAMZ1NTGrfu5X3BF/
        /jSVltUp/GOstSVEN0D6i04=
X-Google-Smtp-Source: AKy350Z0hfkprBBmYBXXeQ4v20OBXLfn2U2EbRwzpbYC2Dz8QJKSiR2XMWenJ26PmHdB4ByVhKlICA==
X-Received: by 2002:a5d:4611:0:b0:2f6:987f:a0f5 with SMTP id t17-20020a5d4611000000b002f6987fa0f5mr1351297wrq.5.1681993935723;
        Thu, 20 Apr 2023 05:32:15 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id z16-20020a5d4410000000b002f79ea6746asm1835081wrq.94.2023.04.20.05.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 05:32:15 -0700 (PDT)
From:   Gilad Sever <gilad9366@gmail.com>
To:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz
Cc:     eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Gilad Sever <gilad9366@gmail.com>
Subject: [PATCH bpf 0/4] Socket lookup BPF API from tc/xdp ingress does not respect VRF bindings.
Date:   Thu, 20 Apr 2023 15:31:51 +0300
Message-Id: <20230420123155.497634-1-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling socket lookup from L2 (tc, xdp), VRF boundaries aren't
respected. This patchset fixes this by regarding the incoming device's
VRF attachment when performing the socket lookups from tc/xdp.

The first two patches are coding changes which facilitate this fix by
factoring out the tc helper's logic which was shared with cg/sk_skb
(which operate correctly).

The third patch contains the actual bugfix.

The fourth patch adds bpf tests for these lookup functions.

Gilad Sever (4):
  bpf: factor out socket lookup functions for the TC hookpoint.
  bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC
    hookpoint
  bpf: fix bpf socket lookup from tc/xdp to respect socket VRF bindings
  selftests/bpf: Add tc_socket_lookup tests

 net/core/filter.c                             | 132 +++++--
 .../bpf/prog_tests/tc_socket_lookup.c         | 341 ++++++++++++++++++
 .../selftests/bpf/progs/tc_socket_lookup.c    |  73 ++++
 3 files changed, 525 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/tc_socket_lookup.c

-- 
2.34.1

