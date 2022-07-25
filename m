Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0575800BD
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235532AbiGYObQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbiGYObO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:31:14 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF756584
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:31:11 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v13so8457792wru.12
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=SZEdKt3NPH9qVcYSfhPFXnFmaQRMdCaZikV9avg1yi0=;
        b=t4pUXQKxvv8PcOIu7CyQckFVJpxcGcEAiGGw/qdtQp6uBiE5Ebj8l0IVuodTkoNbdv
         t796lVFBHvD6Bo0jt3KpkiE4/tMfzD6kJYAnPpSxX74DrDbl7UctNhLFnB62L+Wqwxkr
         DbmRADXPd+iw7tPiHv8SJ9oik4uUtT9uzbfywlorjNn+a/nPvpkucZAyen1qdkSE2Epk
         41F2l0BZQCv9TH1NF7eOiD/+WUMUD2XsU1ktPCXgFT6HyGgyeoUtzqBvocE6mqtveWZg
         N1nv1lnre53hq9h/ARC//VgS/LMRfaPxVTFytyHOdctToDY4ACow0jxX2/fKJeBXPPwI
         KEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=SZEdKt3NPH9qVcYSfhPFXnFmaQRMdCaZikV9avg1yi0=;
        b=IyHylRffZk0Pk5zaPqUTeB7ftXRF1r/vts9txBfi2lddGyIrWcyMlSjiK3KBwiDkVU
         oPrtFKovm/wq9AEJVKW3I3gUYm808pt+ZVVuEDLzFan/CEA/oMZHunYa9YBwC7pSVNfD
         Z+m3apb5OugC6mXsbqsMZlmtImgKvKqi3llKFwwee5OO9sdI3wTYmxQmxGuq/uwB0N8z
         PynfbNZnaT/bz1kjd5sG3JjEYmJCCIAu5Lz+tfg5zSiCekfRUrIpGY4e6667wxNzHOhw
         YxwCRp9Bg9yzfaT2zxjsoKlM4WDHlvWiyLsbtdUv5tHOIoT2HngcMbQvGH5WyClpKaqS
         +rKg==
X-Gm-Message-State: AJIora/rikSdKwxgJfSgMz4wTAbkN92Hz631ZNVXxzio0vaJfR/fclje
        dBhtn0tTuh+sMV3GOXOSSk4N0PG4ZCQO0RQ=
X-Google-Smtp-Source: AGRyM1tpPv6YnuXAkVsy6GXpaTyBFZoFtb4i/hhr6ApqgqnCEamHq8kadea+LusdLhkAxvcSAHDANg==
X-Received: by 2002:a05:6000:1f0c:b0:21e:8979:1f20 with SMTP id bv12-20020a0560001f0c00b0021e89791f20mr3457759wrb.714.1658759470075;
        Mon, 25 Jul 2022 07:31:10 -0700 (PDT)
Received: from Mem (pop.92-184-116-22.mobile.abo.orange.fr. [92.184.116.22])
        by smtp.gmail.com with ESMTPSA id m39-20020a05600c3b2700b003a2e1883a27sm22975495wms.18.2022.07.25.07.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:31:09 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:31:07 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v3 0/5] bpf: Allow any source IP in
 bpf_skb_set_tunnel_key
Message-ID: <cover.1658759380.git.paul@isovalent.com>
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

Changes in v3:
  - Rebased on top of bpf-next.
  - Reworked the last patch, for the selftests. Several changes were
    required to the existing vxlan_tunnel test to be able to test the
    change in the bpf_skb_set_tunnel_key helper.
  - Apart from the rebase, only the last selftests patch changed, so
    I kept the Reviewed-by and Acked-by tags on other patches.
Changes in v2:
  - Removed changes to IPv6 code paths as they are unnecessary.

Paul Chaignon (5):
  ip_tunnels: Add new flow flags field to ip_tunnel_key
  vxlan: Use ip_tunnel_key flow flags in route lookups
  geneve: Use ip_tunnel_key flow flags in route lookups
  bpf: Set flow flag to allow any source IP in bpf_tunnel_key
  selftests/bpf: Don't assign outer source IP to host

 drivers/net/geneve.c                          |  1 +
 drivers/net/vxlan/vxlan_core.c                | 11 ++-
 include/net/ip_tunnels.h                      |  1 +
 net/core/filter.c                             |  1 +
 .../selftests/bpf/prog_tests/test_tunnel.c    | 17 +++-
 .../selftests/bpf/progs/test_tunnel_kern.c    | 80 ++++++++++++++++---
 6 files changed, 96 insertions(+), 15 deletions(-)

-- 
2.25.1

