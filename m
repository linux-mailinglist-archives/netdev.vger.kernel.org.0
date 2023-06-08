Return-Path: <netdev+bounces-9204-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37EF2727F09
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:42:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B1432816F1
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9B911196;
	Thu,  8 Jun 2023 11:42:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62EF63CF;
	Thu,  8 Jun 2023 11:42:10 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA63A1FF5;
	Thu,  8 Jun 2023 04:42:01 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30e5b017176so348848f8f.1;
        Thu, 08 Jun 2023 04:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686224520; x=1688816520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HKO4XV+hpTrRt0GM3KS4NAMo/ycXBKZUbmq0E+OLn3Y=;
        b=Z5tO79ASIgPnOSjT/ZvwDMxyebdf7fPOF9Nwh1X8r+lPFUSdXnSKsR0rmQccHJ9E0R
         wTCmCEfJRmUTfGNMaWD0DCPYnzUW8qogyb551QYC3tYyUHVp5nKj4mrw07aIXMm/Deta
         roOY7cg04YRPjq7HjBlIpJp5qe7OdYsRinf7/J/Nxrd4rfQaLX6h6Lgg3hKhlUh/Ll+1
         jvJJazEamodc2TjIRxaoOjPGKOiqROGdpxFulIpklT4Lk+aguc615vyXc5xhnkvyrBqh
         Lis5AXCJK+vuJxrvGQReMj3nhg4nalyJY4fITN1rhNrzm8NGByzsKJY3RBXbivXJ5yy/
         hmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686224520; x=1688816520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HKO4XV+hpTrRt0GM3KS4NAMo/ycXBKZUbmq0E+OLn3Y=;
        b=humnOHbADrGETAejAaY1XJWesKwUFwxUb6pjzRP7nIc5OMHQ2YjhHlMUxmX3oa/0C8
         b+7/dTEdCqtoILpFHJOYtEITEaOvG1E7ZwK8WwBr/TZSi7kfE2S9BUuuK7aF7alMsmcd
         DJNd4EPMMUdf2lF0bI0yU5lxBpNyM20rlIk3ckiWsjMfYTJn+3s1zzRcQmIBlaNy3H50
         C2CNhDfkgAKZ4JiJ1LL3aQPRZISJSEOXcFoZHDx0Q/tfZu+5YMpQcu8VB0+ySWfyMCX8
         AkGgViD6pKjaNu+XezEmsZkx0GaOoud79tL7jWPhPxVs8G6hQtxEMX0u4MErmaHS3rVr
         soRw==
X-Gm-Message-State: AC+VfDwXBfBO669BqvTht2x35R0jB/cgJp4fsKGkokPzC7cAV93nw86s
	AUSuO7WK9PdOrN/QEEEZmyU=
X-Google-Smtp-Source: ACHHUZ7zVTZ82qBxoo9qz8MrK6a/R0YVUM4En6oX0l+TAxuve+NiDMf7Ln9MyUP1m04nGMbwX+fS8g==
X-Received: by 2002:a5d:464e:0:b0:306:37bf:ca5a with SMTP id j14-20020a5d464e000000b0030637bfca5amr6295141wrs.47.1686224520077;
        Thu, 08 Jun 2023 04:42:00 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id s2-20020adfecc2000000b0030aed4223e0sm1326158wro.105.2023.06.08.04.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 04:41:59 -0700 (PDT)
From: Gilad Sever <gilad9366@gmail.com>
To: dsahern@kernel.org,
	martin.lau@linux.dev,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	ast@kernel.org,
	andrii@kernel.org,
	song@kernel.org,
	yhs@fb.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	mykolal@fb.com,
	shuah@kernel.org,
	hawk@kernel.org,
	joe@wand.net.nz
Cc: eyal.birger@gmail.com,
	shmulik.ladkani@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Gilad Sever <gilad9366@gmail.com>
Subject: [PATCH bpf,v5 0/4] Socket lookup BPF API from tc/xdp ingress does not respect VRF bindings.
Date: Thu,  8 Jun 2023 14:41:51 +0300
Message-Id: <20230608114155.39367-1-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When calling socket lookup from L2 (tc, xdp), VRF boundaries aren't
respected. This patchset fixes this by regarding the incoming device's
VRF attachment when performing the socket lookups from tc/xdp.

The first two patches are coding changes which factor out the tc helper's
logic which was shared with cg/sk_skb (which operate correctly).

This refactoring is needed in order to avoid affecting the cgroup/sk_skb
flows as there does not seem to be a strict criteria for discerning which
flow the helper is called from based on the net device or packet
information.

The third patch contains the actual bugfix.

The fourth patch adds bpf tests for these lookup functions.
---
v5: Use reverse xmas tree indentation

v4: - Move dev_sdif() to include/linux/netdevice.h as suggested by Stanislav Fomichev
    - Remove SYS and SYS_NOFAIL duplicate definitions

v3: - Rename bpf_l2_sdif() to dev_sdif() as suggested by Stanislav Fomichev
    - Added xdp tests as suggested by Daniel Borkmann
    - Use start_server() to avoid duplicate code as suggested by Stanislav Fomichev

v2: Fixed uninitialized var in test patch (4).

Gilad Sever (4):
  bpf: factor out socket lookup functions for the TC hookpoint.
  bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC
    hookpoint
  bpf: fix bpf socket lookup from tc/xdp to respect socket VRF bindings
  selftests/bpf: Add vrf_socket_lookup tests

 include/linux/netdevice.h                     |   9 +
 net/core/filter.c                             | 123 +++++--
 .../bpf/prog_tests/vrf_socket_lookup.c        | 312 ++++++++++++++++++
 .../selftests/bpf/progs/vrf_socket_lookup.c   |  88 +++++
 4 files changed, 511 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/vrf_socket_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/vrf_socket_lookup.c

-- 
2.34.1


