Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672D96E979C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjDTOvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbjDTOvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:51:07 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9568B527A;
        Thu, 20 Apr 2023 07:50:56 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o29-20020a05600c511d00b003f1739de43cso1256197wms.4;
        Thu, 20 Apr 2023 07:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682002255; x=1684594255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=12IToH1z540Y8x94r2QXP2yZFItKLN+0PG21x7lnd0U=;
        b=CqHR2atveEswCD0xdfjrV9j3/qoHqm8X3DG9S3B7wM7RBjpl0gQUCLY3Nh/i1zgern
         S06QFq9VtgIYl1UmPrrE54UuZV8yP90ADVVBEuYFk2zxfmEdLqSmLrhZv5Er2pNPuUTL
         CcSD63yRtmfUgKOLrhGr8D9I7rFKzBbuNxM8RnwxgNgkCSTaVXZIegZ/OGSanhZwrRfd
         jBRIG7/0Vp28TeIdxmdUY4WU3xYuRktQsxr98A0F6HP7cuqCwsN+2yITa+0njnC9zxp9
         4qo1ja/GrZZadSzpOF9xTo1a4OUrUU8J9ofp6ltVXap5rX0Bni0WHMR8S1m8XupRfsAO
         19YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682002255; x=1684594255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=12IToH1z540Y8x94r2QXP2yZFItKLN+0PG21x7lnd0U=;
        b=T1NRc7PJoTd4Jrb07T8Fil4FC5E7pKIeZmIrguE0C7uS1N+tbmp705VXpU4Ipco3CC
         tCWTPOXdg8K8eZKDj+OUUbZvtW+6+iM56zl0vbN++IfDloUq0LhVhG+JBRtaLCcdqCGb
         dnIO4j6aCGbaHj3RRIItBtBK82NiqlFm0gy/Mksq+HFnoa1f4/CoYSU6mNyuYE/LwFQT
         Tv6EsqT8NxYJj8+nzDfiUAwoVlLRQH1RCT0ME45ymb8p0ESGe+cv6so+2YcgatG7ZE6g
         qjFJP8lqK0JeSY9FIQf5LmpD1Sz17KgGEulFdS4VzMgN5UtzNhHHL6ykMHukAN8x0iPU
         zmtQ==
X-Gm-Message-State: AAQBX9eILwxOBTZd9ZyBh+mLaAgR+fZSgDo0KiUckdvhJB08zwWehxuz
        0GTEMCJcs7zUo/RoXxqcYYyhKvYNUmBE4w==
X-Google-Smtp-Source: AKy350YpSRptGaVYVNbLf0nOt6wQG0r1cM+ntP1YuTVMW8CwYHbYLywmIhP0OkmjsP1ji8sU2vCxxg==
X-Received: by 2002:a05:600c:2106:b0:3f0:7e56:82a4 with SMTP id u6-20020a05600c210600b003f07e5682a4mr1542283wml.18.1682002254937;
        Thu, 20 Apr 2023 07:50:54 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id n20-20020a7bc5d4000000b003f17b96793dsm5534619wmk.37.2023.04.20.07.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 07:50:54 -0700 (PDT)
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
Subject: [PATCH bpf,v2 0/4] Socket lookup BPF API from tc/xdp ingress does not respect VRF bindings.
Date:   Thu, 20 Apr 2023 17:50:37 +0300
Message-Id: <20230420145041.508434-1-gilad9366@gmail.com>
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
---
v2: Fixed uninitialized var in test patch (4).

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

