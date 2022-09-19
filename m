Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E2F5BD54C
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 21:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiISToy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 15:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiISTox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 15:44:53 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2298F59B;
        Mon, 19 Sep 2022 12:44:51 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id D89645C045B;
        Mon, 19 Sep 2022 15:44:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 19 Sep 2022 15:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1663616690; x=1663703090; bh=bM8Zv6hDKlzVWonZNm31Q3HGM
        Y4j+0tQ5jhkGQLKvN4=; b=Ypl1eQ7zC7pAdxthoD4SmQJhLAff8mrlhtjheqk5s
        2RpRopEZINHVvvp74JTxDhqXtS/jrrWtaDIf0Fm+P+LDP3niRbV6eaevOcvxhPXI
        vuapgYto0AB0D77J0hV2c+hEJyy4eE1ldD166K3EqEAVL91c9lHePlRamlHkTyd/
        qvvXJD9cggQ4w6xz83I1rGTiyG9EU8/KcFC6lZainuALBxokUONsK22RywQJ5iyx
        hbtdX1P44FEjaPrgLzDP5jH8gs014wBqHDeptCcj2qc5/D66ROt1vc2/8nWaIiYW
        yars2vfZNSCbz1Zt+840cReFq4Ixx/MEkLitYOPUsC7qA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1663616690; x=1663703090; bh=bM8Zv6hDKlzVWonZNm31Q3HGMY4j+0tQ5jh
        kGQLKvN4=; b=o/pEr9PSoAI3zuSwTIk5AGfi3UDJVmOlIfxTBse9QmtgP6z1NCx
        dQILFN4UHWzsnuAirWFPb3oqsdZ9QjnUp4GYf16OLoXHP/GApzTWtRZLFf02RJam
        RHztbuUuzbJhH4ngyfY9YCTToArrdOgl396ZDVx3JUNXahD90jRQffQr+hv8/h4h
        SHMER67OeMmwghtmJsIjbAb9U95355dLl3TBB+BHUJSgwdgZL7aqD/is4DRTsbmM
        0VfzbQLkWopudSk25EbFbSAJtqOWIi9peBZ8GweGOrkmPkK4XOzXnFc78RSYjC3N
        PkrVWx6liLFarmhzUlTgpVKMITHlNGYCYFA==
X-ME-Sender: <xms:ssYoY9PhwNpv26htwiPN5bI9LTxKkyJOaERPkNzGqJoKvdHoUzcQ9g>
    <xme:ssYoY__Ufd9JEo0Ain67Ht5ZIZ0oj9tMrl7FKm-sWqKm9I1JbsOE4BwqfITfxjOnJ
    9rQtegUJjHxDa4wnQ>
X-ME-Received: <xmr:ssYoY8QiZaqNAyI5YLmG3Vmbi2uF4HOiS9WY855kYVlZYMhKVxsm81RrTtm9K9QGmLT0EaJdAHiI7mS_mv0ge2YBjW1v_NSAowrMj_s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedgudegfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcuoegu
    gihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpedvgefgtefgleehhfeufe
    ekuddvgfeuvdfhgeeljeduudfffffgteeuudeiieekjeenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:ssYoY5tR37McFCjHOGv6xYxgLLYhbRgdij9yL2X3N-B5q7m6edzdeA>
    <xmx:ssYoY1fFjhp_NUMo0iav5w3fvZVQxFw1vI9Ouw6eV6DONG3hC1Ss7Q>
    <xmx:ssYoY13MMHN1hbqYqMk8Zp4b5YqrzA7TGxpvuV3K1dqo11tFRmh5Jg>
    <xmx:ssYoY12wtllVljZx7MLBzEv4Dm1HaSK7EjZ6ecSO0TXura2rfTPNag>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 15:44:49 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, martin.lau@linux.dev
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 0/3] bpf: Small nf_conn cleanups
Date:   Mon, 19 Sep 2022 13:44:34 -0600
Message-Id: <cover.1663616584.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_PDS_OTHER_BAD_TLD autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset cleans up a few small things:

* Delete unused stub
* Rename variable to be more descriptive
* Fix some `extern` declaration warnings

Daniel Xu (3):
  bpf: Remove unused btf_struct_access stub
  bpf: Rename nfct_bsa to nfct_btf_struct_access
  bpf: Move nf_conn extern declarations to filter.h

 include/linux/filter.h                   |  6 ++++++
 include/net/netfilter/nf_conntrack_bpf.h | 17 +----------------
 net/core/filter.c                        | 18 +++++++++---------
 net/netfilter/nf_conntrack_bpf.c         |  4 ++--
 4 files changed, 18 insertions(+), 27 deletions(-)

-- 
2.37.1

