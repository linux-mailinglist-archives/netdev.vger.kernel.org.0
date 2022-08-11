Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FE959088D
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 00:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiHKWFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 18:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236488AbiHKWFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 18:05:50 -0400
X-Greylist: delayed 607 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 Aug 2022 15:05:49 PDT
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7036B1EEDF;
        Thu, 11 Aug 2022 15:05:49 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id BFB892B05D1B;
        Thu, 11 Aug 2022 17:55:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 11 Aug 2022 17:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1660254940; x=1660262140; bh=ZgAnECcKiNINQ/nMekoYRrtEA
        FO/LNkk2RLbQLXX3Oc=; b=vIS86Kh2zXrtYCvVOYCzWsRKom8XuVEa6HpXfxCra
        EIctIqfcntjf8OVXYRma1/nuFkyBfXewbOo1jb1iSFJgi8594bKSqe9Q9hCQ3i87
        0aASAw1PBw3nhZm6tJ2L9ktWvqAPmywm4Jh1BxR8tkNoHRjCTn8jNT+Uq9scl1Qs
        uG1sHoeBCz/ZyMI1jqiuEHUvzdaIms194LGwvTtcG+2xzLjQ/k3uzI3Y7bnt2+Yc
        oDs5svJYGA059hsCN31fI83KYApBBOWUIh85/vsQ1M6VAhQERTH1jJq4OCSTJjDd
        XVb2a38JdhsPW1kRekHmb/AVgZ4Sr/7RIHakJp5Nj+xZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1660254940; x=1660262140; bh=ZgAnECcKiNINQ/nMekoYRrtEAFO/LNkk2RL
        bQLXX3Oc=; b=ASUoPEXG3PHwYvWY3SPVwQ1CDMrHQ9S6NdthZQlptZrRfxUyPkm
        92Rxw0hoUr8iRn9VRo9DgXcYDb7FgAmT6aeVKfAM/5bFFXOIc1m/WjWloMAhjcEE
        DkrelS1no3NoV1gQ4WSAVlpsMKsa/j+5zbpdjuHtGL+dOME+oKvo1ll6UFMZkgdt
        cbCr7u6w3q34os3ix8cVsPrKOiBL+4T24Q5NvdxHH4tzy33kstxUgb+ihhMxMc4i
        XS6QA+lsAt7xkBDtjmQxWVO+1URgSpBzjcB9fx/wSa7IjdiegrUU1mXkJpq/RgLK
        fn8w3BGK47Dc9Ambigh68Uozi28mNVMdb3w==
X-ME-Sender: <xms:23r1YubqbHJ3u0qSoa4DJXrUQfZqWDFSq-wcjxKWZWCD1yEGjtEKZg>
    <xme:23r1YhbEaNt4rqDvZQvph7P3MuS0WWF8rhpSFDyXpSjqpaD1vkRYKMLfKcHF3bwT_
    3AGoCqxGgZEYRlKcA>
X-ME-Received: <xmr:23r1Yo-Zb1ulSDneO6iolcO3ljq6WFv8xOMzlO_w0AprgE_RUb-hvw-S3QMe7ModH-PvHOuUAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeghedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfeehmdenogevohgrshhtrg
    hlqdfhgeduvddqtddvucdludehtddmnecujfgurhephffvvefufffkofgggfestdekredt
    redttdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqe
    enucggtffrrghtthgvrhhnpeetueektdeuhfefvefggfevgeffgfekfefhkeekteffheev
    tddvhedukeehffeltdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdr
    giihii
X-ME-Proxy: <xmx:23r1YgpIMgm9fSTff6UETf1xQBxZW_7i5zefq8K0v1euPdO-ESvdsA>
    <xmx:23r1YppsnWjtVI3hs1EEsfvJWk2NAB7K1H_Ojki1vG5JgeoR8YUIOQ>
    <xmx:23r1YuQ1eCWumr42QYffI2-ddQqlnh4IolG1rQfGt5eVF8vh6cacgg>
    <xmx:3Hr1Yk1_8Tt381-AngQtpf7HiVpvoiSgVDPJA9JQuCE3ESDSpWkktg_eHkQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Aug 2022 17:55:38 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 0/3] Add more bpf_*_ct_lookup() selftests
Date:   Thu, 11 Aug 2022 15:55:24 -0600
Message-Id: <cover.1660254747.git.dxu@dxuuu.xyz>
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

This patchset adds more bpf_*_ct_lookup() selftests. The goal is to test
interaction with netfilter subsystem as well as reading from `struct
nf_conn`. The first is important when migrating legacy systems towards
bpf. The latter is important in general to take full advantage of
connection tracking.

I'll follow this patchset up with support for writing to `struct nf_conn`.

Past discussion:
- v3: https://lore.kernel.org/bpf/cover.1660173222.git.dxu@dxuuu.xyz/
- v2: https://lore.kernel.org/bpf/cover.1660062725.git.dxu@dxuuu.xyz/
- v1: https://lore.kernel.org/bpf/cover.1659209738.git.dxu@dxuuu.xyz/

Changes since v3:
- Remove deprecated CHECK_FAIL() usage
- cc netfilter folks

Changes since v2:
- Add bpf-ci kconfig changes

Changes since v1:
- Reword commit message / cover letter to not mention connmark writing

Daniel Xu (3):
  selftests/bpf: Add existing connection bpf_*_ct_lookup() test
  selftests/bpf: Add connmark read test
  selftests/bpf: Update CI kconfig

 tools/testing/selftests/bpf/config            |  2 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c | 60 +++++++++++++++++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 21 +++++++
 3 files changed, 83 insertions(+)

-- 
2.37.1

