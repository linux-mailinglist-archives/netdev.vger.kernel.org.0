Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A29C5BE88B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiITOTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiITOSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:18:33 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADB062AAC;
        Tue, 20 Sep 2022 07:15:51 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 42A725C00EA;
        Tue, 20 Sep 2022 10:15:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 20 Sep 2022 10:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1663683349; x=1663769749; bh=mXWCZRKD8ECA8BgjnvzAToJOu
        nSXcjLQ95mV6RkkIEk=; b=iDubo4syi26G9dCWPmR3k8jhC6zViz2ktC2Ub3Egm
        8pnJNCoVGA6IifM0iMcJOtNEdxUsGe0YcXsAuVSWAAs/qeh2WPotaa/hN/NXNT7+
        fvu/fiVuq2TOMBbwPO30qr/2WBOlhNo3i6OxIO/xUESPUymkmyfYTasqExchNr3q
        utAu+7FooUbWbj+xRYoDEhkxr8TxezS9h2++v46HEQ2dFDdvxEdQIBcfIQp1FsPL
        T5sbjnvtKK9kPRq9i/HVOlGgOpLNsZ9SF59D6CWSyQpuILlM3T/xJF+8FklPtbRT
        9hr1KUGeiesMhAvs/6SPGk0iLeXPqJILYbwqRKzZRS2Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1663683349; x=1663769749; bh=mXWCZRKD8ECA8BgjnvzAToJOunSXcjLQ95m
        V6RkkIEk=; b=hc93u75EWlZ8e3cLV6+AHRPSTkymmRz5xzEPxjU1Ukdt1vQK+zF
        JY1N0sGvrDHlSVuS0F+iagxoLBSunm2A/raZ+GkT35W4yH/iVBHetIqlHzUi25Yx
        5JU6iIbPj6LFcgKUzZNlbWdJ82UWgI6DplkzsIO/JUpabdVoiYnLSFC3Ynv0nlPa
        DeCeGEphnRvD3P5+FeZUkR4ccfuabBNMfHKyRFTm2u+dtZmdiGxpdTdmA6lhbDkQ
        sJz5ssQ1J47EBP/CQiRXN4S+jOmyHv2A0R1aGb2FniowQcXy7o7O6uPPdcnb13I2
        WrAyvkgMHIkZGNoE62K5gaNr/mDOLMHlh7g==
X-ME-Sender: <xms:FMspY63-etQAaZNkuvzm_9ToxqFiA5yOsqt24Mxs9vdIiPkHQHuDQg>
    <xme:FMspY9H5nw5M9iyaeQvlHj3kujQyx_PPB6oa-JbjY8aXScpMHUOswKxnoJvSnyjJu
    kM3VBAWoPM445vk6A>
X-ME-Received: <xmr:FMspYy58m3aTUHzhSCys2zCDZaFJmNp5oJVLl5E6oUz1ce7LJIzams6bUsO5iPXsEMaSp5w50yuHVdzS5CbgzSk7TiVcprIXwM0d93o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvledgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfeehmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougig
    uhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepteeukedtuefhfeevgffgve
    egfffgkeefhfekkeetffehvedtvdehudekheffledtnecuffhomhgrihhnpehkvghrnhgv
    lhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:FMspY72fENX-BEOcuYZqKkV6UUuwpkPRf5OB4itSwIojgcpqdNXKMA>
    <xmx:FMspY9GVFwyDpLD1gL6gZwi0psoEZE7i9Cerr_15-sjTGLhP1KqRaA>
    <xmx:FMspY08sNzLamKiBLnxhsl3kHKIQj0A2053xAHoOR6W8_dKOR16svw>
    <xmx:FcspY8_wvCAtK0kNuvgws_yBTfVEml5xmD2HYkLf9Qq9eVw-LDe8-w>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Sep 2022 10:15:47 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, martin.lau@linux.dev
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 0/3] bpf: Small nf_conn cleanups
Date:   Tue, 20 Sep 2022 08:15:21 -0600
Message-Id: <cover.1663683114.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset cleans up a few small things:

* Delete unused stub
* Rename variable to be more descriptive
* Fix some `extern` declaration warnings

Past discussion:
- v2: https://lore.kernel.org/bpf/cover.1663616584.git.dxu@dxuuu.xyz/

Changes since v2:
- Remove unused #include's
- Move #include <linux/filter.h> to .c

Daniel Xu (3):
  bpf: Remove unused btf_struct_access stub
  bpf: Rename nfct_bsa to nfct_btf_struct_access
  bpf: Move nf_conn extern declarations to filter.h

 include/linux/filter.h                   |  6 ++++++
 include/net/netfilter/nf_conntrack_bpf.h | 18 ------------------
 net/core/filter.c                        | 18 +++++++++---------
 net/netfilter/nf_conntrack_bpf.c         |  5 +++--
 4 files changed, 18 insertions(+), 29 deletions(-)

-- 
2.37.1

