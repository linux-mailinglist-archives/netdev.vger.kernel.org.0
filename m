Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E6261A658
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 01:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKEAR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 20:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKEAR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 20:17:27 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76D222BF6;
        Fri,  4 Nov 2022 17:17:25 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667607443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H5uIl72QdPBXVe8yuF7QEshKt+zvtto6PscaB3KBuJ0=;
        b=josogeB8Wx43dge4QprDSrNq2Qr0h5Cmv8a7hLLpBJ99FW1mdek/d/NeEbT4nGttaKNj6l
        ykhtWmeVxF64or/s+tGwoqpJEXpwtHlYZ+ARyq5ZYIiyA0XECY3boXDQgphWTwBPVTXLjU
        fDG9RxtyhMK+Wvgc8jYdREna5nQHTqA=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 0/3] bpf: Add hwtstamp field for the sockops prog
Date:   Fri,  4 Nov 2022 17:17:10 -0700
Message-Id: <20221105001713.1347122-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The bpf-tc prog has already been able to access the
skb_hwtstamps(skb)->hwtstamp.  This set extends the same hwtstamp
access to the sockops prog.

Martin KaFai Lau (3):
  bpf: Add hwtstamp field for the sockops prog
  selftests/bpf: Fix incorrect ASSERT in the tcp_hdr_options test
  selftests/bpf: Test skops->skb_hwtstamp

 include/uapi/linux/bpf.h                      |  1 +
 net/core/filter.c                             | 39 +++++++++++++++----
 tools/include/uapi/linux/bpf.h                |  1 +
 .../bpf/prog_tests/tcp_hdr_options.c          |  6 ++-
 .../bpf/progs/test_misc_tcp_hdr_options.c     |  4 ++
 5 files changed, 41 insertions(+), 10 deletions(-)

-- 
2.30.2

