Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22A55763F6
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 16:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiGOO7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 10:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbiGOO7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 10:59:44 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EB47AC34
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 07:59:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id a5so7055818wrx.12
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 07:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=cOihMWKU0vFBMKp2Zuzahpyk4sVfE0QMx1czqbn+Lm0=;
        b=WIbLcNULV9JZqvtCDgnaFqyjIvpIo68iMh2MqQmGgOKC1njEgFpwYDEwXdnPSQcbUb
         py75+6sBq+SltENbFC241l39IowiTPiXjKREEqAdcmDXnuDmLE5jjT92+TBkYI2/nNj6
         XfNZtYYhwEMOdUwTLzUCY5w5tRk5jBZ3loDYgMN9WScdr+8Yb2w6OFoJCwbAPy+beGYn
         Vtwn3PK+pjKecvIpgUXZDPVLRyjnHqFC/0w2wjfswx5T+hH4Gr4mZsu3HYByA21qH/O4
         PhY5kR7v175KAMBT5axJ9OQUXqUCf4XlPHihkiBz8BXI0qOvxPOStAAGtMwuAyiDP7n7
         yNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=cOihMWKU0vFBMKp2Zuzahpyk4sVfE0QMx1czqbn+Lm0=;
        b=Id/+BVURz1X91C+PZbtY9MG+RDClwNXXjGw/kxK9YOptn9qCQghc/80AFUQ3GKcpxO
         9Yu3I6J+Xn6iqFAFPWM+ud2rOvlnQrBtRRIL3d3F48xy/WmcIoBQkB/Jj3RbZ0Q29xzk
         +nB5K0Sivfc1tqfok25H+dpgU61neKFKUK/n0MkN13F76zYMgp2Y4z9SeGY0M40lnteb
         Vsktcn69gPA1Tvo/6KLT+sggmwIUwSE/Xrx3rfIDRpIfLkq1j5DVVPD1/bf74HZCz1uD
         DYNRjcxnsDIYPoHXHs2c9oN/xssRvxpWuPGt1vyFt6kOsaNURcgus0sksM4tCKCnHWJa
         tiFg==
X-Gm-Message-State: AJIora+z6cp86xXLlXl8Ltpt2f1GWWiDJa74Cm+9mgA8yCtMW20tJGMk
        HWoK4VCDJtplDWyOsBm14UwS
X-Google-Smtp-Source: AGRyM1sCNUdZ7FXjuvrfImE/SFvPOU5o5fTSq0gsCNhw0YRQAauVxP4npX1yHL1s/uCxiEUj6hEKHw==
X-Received: by 2002:adf:e38c:0:b0:21d:6df5:f7da with SMTP id e12-20020adfe38c000000b0021d6df5f7damr12602156wrm.265.1657897181808;
        Fri, 15 Jul 2022 07:59:41 -0700 (PDT)
Received: from Mem (2a01cb088160fc0095dc955fbebd15a0.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:95dc:955f:bebd:15a0])
        by smtp.gmail.com with ESMTPSA id m9-20020adfe949000000b0021d4694fcaesm3947762wrn.107.2022.07.15.07.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 07:59:41 -0700 (PDT)
Date:   Fri, 15 Jul 2022 16:59:39 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH bpf 0/5] bpf: Allow any source IP in bpf_skb_set_tunnel_key
Message-ID: <cover.1657895526.git.paul@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
added support for getting and setting the outer source IP of encapsulated
packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
allows BPF programs to set any IP address as the source, including for
example the IP address of a container running on the same host.

In that last case, however, the encapsulated packets are dropped when
looking up the route because the source IP address isn't assigned to any
interface on the host. To avoid this, we need to set the
FLOWI_FLAG_ANYSRC flag.

Paul Chaignon (5):
  ip_tunnels: Add new flow flags field to ip_tunnel_key
  vxlan: Use ip_tunnel_key flow flags in route lookups
  geneve: Use ip_tunnel_key flow flags in route lookups
  bpf: Set flow flag to allow any source IP in bpf_tunnel_key
  selftests/bpf: Don't assign outer source IP to host

 drivers/net/geneve.c                           |  2 ++
 drivers/net/vxlan/vxlan_core.c                 | 18 ++++++++++++------
 include/net/ip_tunnels.h                       |  1 +
 net/core/filter.c                              |  1 +
 .../selftests/bpf/prog_tests/test_tunnel.c     |  1 -
 5 files changed, 16 insertions(+), 7 deletions(-)

-- 
2.25.1

