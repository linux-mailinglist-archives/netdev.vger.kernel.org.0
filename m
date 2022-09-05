Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49745AD391
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbiIENOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbiIENOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:14:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF7D13D58;
        Mon,  5 Sep 2022 06:14:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C92ACB8116E;
        Mon,  5 Sep 2022 13:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA799C433D7;
        Mon,  5 Sep 2022 13:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662383677;
        bh=UHjKuCr5hgzP3mK38/S3kML2gmharluTdaSLmnTB7oU=;
        h=From:To:Cc:Subject:Date:From;
        b=O0MseNX536r1XuNa5oiiGpOv9gTu4TFbN586lwfTWinxgmLEQcdhrVjBnWSbfz5wX
         aj4zYZdHIupKql5AoBg3FnnP1tKSE9bcqD5YpBjoxNro92E+XvTqNnSCCIfLiK/dvD
         YR/RnfEIIYCfRQX3xx8wbNJUPZ9UUyuESWCHvvaROHhLaAX11J9AipDfRdEZM4aSeB
         rzxNwjhMO5zdbH6s3Gr1uxEBAHCPDgWYZ6u0Hkxx+OVut+4XDLCxMi1PTktEFfXRxa
         +0aIBKDMdjlw6bYdGsBqlu9g0E/Cw8Fh6ENnAFxCTxQBrDAjQ9FM/op0p/uG13oRIK
         Oh9eX4OPrpkig==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v2 bpf-next 0/4] Introduce bpf_ct_set_nat_info kfunc helper
Date:   Mon,  5 Sep 2022 15:14:01 +0200
Message-Id: <cover.1662383493.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
destination nat addresses/ports in a new allocated ct entry not inserted
in the connection tracking table yet.
Introduce support for per-parameter trusted args.

Changes since v1:
- enable CONFIG_NF_NAT in tools/testing/selftests/bpf/config

Kumar Kartikeya Dwivedi (2):
  bpf: Add support for per-parameter trusted args
  selftests/bpf: Extend KF_TRUSTED_ARGS test for __ref annotation

Lorenzo Bianconi (2):
  net: netfilter: add bpf_ct_set_nat_info kfunc helper
  selftests/bpf: add tests for bpf_ct_set_nat_info kfunc

 Documentation/bpf/kfuncs.rst                  | 18 +++++++
 kernel/bpf/btf.c                              | 39 ++++++++++-----
 net/bpf/test_run.c                            |  9 +++-
 net/netfilter/nf_conntrack_bpf.c              | 49 ++++++++++++++++++-
 tools/testing/selftests/bpf/config            |  1 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 +
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 +++++++++-
 tools/testing/selftests/bpf/verifier/calls.c  | 38 +++++++++++---
 8 files changed, 157 insertions(+), 25 deletions(-)

-- 
2.37.3

