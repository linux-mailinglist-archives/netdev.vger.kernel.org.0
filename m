Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12EB59C630
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbiHVS0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiHVS0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:26:09 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A64481D0;
        Mon, 22 Aug 2022 11:26:07 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 08E3A2B0694C;
        Mon, 22 Aug 2022 14:26:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 22 Aug 2022 14:26:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1661192765; x=1661199965; bh=vfJv+oLtoyrLAFr9WpKYFQGVR
        rJVovoWBCn/PTIos2k=; b=u0IAtOtM0kiq4G99BdozDiXx7azA98UNb9aO5isVV
        1OaVdbQAcqHDZRsGYeXDKsxiF8z/B+wGuRCWnw9T7qApS9RmxINkXx6/5eTHF8N1
        5qcXL0BD0LHfATtNkN5WEBy1LcpGllR53DgzalPFTGLyGd43NP9a0ae08oEY6JWS
        Mzn2kmxuStZzEKrMsS8mVMniZg4MX3tZqp7/OBrv1XLGWO+s3nPi+uDr1amHeVpk
        G8HKC6m0K4HsqVFPci50Z12O5+VGVKnifIXPDqaZneFQi84eYtcgMHppGzqEufAP
        5F24q8CpRPWnbPT8qxveXIBo6TMnn0w1133BkPqA50Paw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1661192765; x=1661199965; bh=vfJv+oLtoyrLAFr9WpKYFQGVRrJVovoWBCn
        /PTIos2k=; b=bONUmxzMikQmLB+iJrpQTjsreENshBuVEBIS7lQsKE93OFKJ+n9
        suARhHjp4kN27hjk46cE7COFshCqwYODJ7e7K/bnbNqSGZRVgoWJt5Colq0lYcPe
        W6b42aCwEDMwlkZL4Ddp6LsbPnwOeP71HX254vt696fM8NuWBzwKAFbS18B3H/cd
        h/w+/faf8FxxuYtcFFIH0TegSRW/w/gihd8Q0Pa3+pIEuBBuyq2JfGRqxUriV8er
        s4ydbF/qR8rDMnC6/pjplywN/EtnYCQziVW2zAj8az5E3zYaYfm6nmOzLJY8Q/mW
        NgwdSe0mb/2lAVc9Eo3lAutpuPb6WyD8iPw==
X-ME-Sender: <xms:PMoDY2Zd3Ms3yta0HSwC7ME1iSaR42OC4VJeup5onuHhvE2VhOcqZg>
    <xme:PMoDY5aEu57ay0VOnGP0kkLOZA9gyF6tv1cAkCRj8WHMCX5BHNpY06SiMN_TeVRp5
    AJczE-8PUOmL23DuQ>
X-ME-Received: <xmr:PMoDYw-QnlSTWRnpqkn3DAVLPK7qzDRbhIcjEklrgw6GpfL5_Udi2ydGE9aopOEjYHngNBMp-JUagP6hLLvz-dLyddhvVpyftrB3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeijedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnegovehorghsth
    grlhdqhfeguddvqddtvdculdduhedtmdenucfjughrpefhvfevufffkffoggfgsedtkeer
    tdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougiguhesugiguhhuuhdrgiihii
    eqnecuggftrfgrthhtvghrnhepteeukedtuefhfeevgffgveegfffgkeefhfekkeetffeh
    vedtvdehudekheffledtnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhu
    rdighiii
X-ME-Proxy: <xmx:PMoDY4o8qJEfJLsP6XvUgFZKh7vre0oc39Wws0Ky2gIcA4IKSWsYwg>
    <xmx:PMoDYxqHgeIuTNfJp6tF0et22XUl75t04RIPTWtbFNcMcfynVWi5FQ>
    <xmx:PMoDY2R-ZmlZ7KFPB6sDSleZKLh_hiskUuDzV6-xZK6RwRzzUbUqBg>
    <xmx:PcoDYyTy6JPTmziG9JKhBIobO5aZ0J71Uc3f-te2Ike2X4V8BJeBdqyDqlY>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Aug 2022 14:26:04 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 0/5] Support direct writes to nf_conn:mark
Date:   Mon, 22 Aug 2022 12:25:50 -0600
Message-Id: <cover.1661192455.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support direct writes to nf_conn:mark from TC and XDP prog types. This
is useful when applications want to store per-connection metadata. This
is also particularly useful for applications that run both bpf and
iptables/nftables because the latter can trivially access this metadata.

One example use case would be if a bpf prog is responsible for advanced
packet classification and iptables/nftables is later used for routing
due to pre-existing/legacy code.

Past discussion:
- v3: https://lore.kernel.org/bpf/cover.1660951028.git.dxu@dxuuu.xyz/
- v2: https://lore.kernel.org/bpf/CAP01T74Sgn354dXGiFWFryu4vg+o8b9s9La1d9zEbC4LGvH4qg@mail.gmail.com/T/
- v1: https://lore.kernel.org/bpf/cover.1660592020.git.dxu@dxuuu.xyz/

Changes since v3:
- Use a mutex to protect module load/unload critical section

Changes since v2:
- Remove use of NOT_INIT for btf_struct_access write path
- Disallow nf_conn writing when nf_conntrack module not loaded
- Support writing to nf_conn___init:mark

Changes since v1:
- Add unimplemented stub for when !CONFIG_BPF_SYSCALL

Daniel Xu (5):
  bpf: Remove duplicate PTR_TO_BTF_ID RO check
  bpf: Add stub for btf_struct_access()
  bpf: Use 0 instead of NOT_INIT for btf_struct_access() writes
  bpf: Add support for writing to nf_conn:mark
  selftests/bpf: Add tests for writing to nf_conn:mark

 include/linux/bpf.h                           |  9 ++
 include/net/netfilter/nf_conntrack_bpf.h      | 22 +++++
 kernel/bpf/verifier.c                         |  3 -
 net/core/filter.c                             | 34 +++++++
 net/ipv4/bpf_tcp_ca.c                         |  2 +-
 net/netfilter/nf_conntrack_bpf.c              | 91 ++++++++++++++++++-
 net/netfilter/nf_conntrack_core.c             |  1 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 +
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  9 +-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    | 14 +++
 10 files changed, 180 insertions(+), 7 deletions(-)

-- 
2.37.1

