Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71B1620334
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 00:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiKGXE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 18:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiKGXE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 18:04:29 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51D42610A;
        Mon,  7 Nov 2022 15:04:27 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667862266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6ongHk3CaEHFctMElImtqANZj+/qM1HHkJKzKytCrAY=;
        b=RsX583WtiyfdU9Nib8qazhWqREmIpe0nmW3hPtaK0xqsPT20viAVU5XlP1JEe96R/iwDNh
        6W26jtdzoXPgSqMPuXlT3IZEbFVCv8e5+hyabMLt7c/CRKXy6lzrHiqBUUC0h5HxZMfzsb
        7Dr/Qn3gsqC23GQA4zEcCNfpCrly7cg=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 bpf-next 0/3] bpf: Add hwtstamp field for the sockops prog
Date:   Mon,  7 Nov 2022 15:04:17 -0800
Message-Id: <20221107230420.4192307-1-martin.lau@linux.dev>
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

v2:
- Fixed the btf_dump selftest which depends on the
  last member of 'struct bpf_sock_ops'.

Martin KaFai Lau (3):
  bpf: Add hwtstamp field for the sockops prog
  selftests/bpf: Fix incorrect ASSERT in the tcp_hdr_options test
  selftests/bpf: Test skops->skb_hwtstamp

 include/uapi/linux/bpf.h                      |  1 +
 net/core/filter.c                             | 39 +++++++++++++++----
 tools/include/uapi/linux/bpf.h                |  1 +
 .../selftests/bpf/prog_tests/btf_dump.c       |  4 +-
 .../bpf/prog_tests/tcp_hdr_options.c          |  6 ++-
 .../bpf/progs/test_misc_tcp_hdr_options.c     |  4 ++
 6 files changed, 43 insertions(+), 12 deletions(-)

-- 
2.30.2

