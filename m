Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88229617659
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiKCFxO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Nov 2022 01:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKCFxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:53:12 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038AB167C3
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:53:11 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVsK8009856
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 22:53:11 -0700
Received: from maileast.thefacebook.com ([163.114.130.8])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkvcwdu45-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:53:11 -0700
Received: from twshared17038.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:53:08 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id AE4F32102ECBA; Wed,  2 Nov 2022 22:53:05 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 00/10] veristat: replay, filtering, sorting
Date:   Wed, 2 Nov 2022 22:52:54 -0700
Message-ID: <20221103055304.2904589-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: xJtCL9NNHLjl7VAst5uFu15m_SGcafMz
X-Proofpoint-ORIG-GUID: xJtCL9NNHLjl7VAst5uFu15m_SGcafMz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds a bunch of new featurs and improvements that were sorely
missing during recent active use of veristat to develop BPF verifier precision
changes. Individual patches provide justification, explanation and often
examples showing how new capabilities can be used.

Andrii Nakryiko (10):
  selftests/bpf: add veristat replay mode
  selftests/bpf: shorten "Total insns/states" column names in veristat
  selftests/bpf: consolidate and improve file/prog filtering in veristat
  selftests/bpf: ensure we always have non-ambiguous sorting in veristat
  selftests/bpf: allow to define asc/desc ordering for sort specs in
    veristat
  selftests/bpf: support simple filtering of stats in veristat
  selftests/bpf: make veristat emit all stats in CSV mode by default
  selftests/bpf: handle missing records in comparison mode better in
    veristat
  selftests/bpf: support stats ordering in comparison mode in veristat
  selftests/bpf: support stat filtering in comparison mode in veristat

 tools/testing/selftests/bpf/veristat.c | 887 ++++++++++++++++++++-----
 1 file changed, 727 insertions(+), 160 deletions(-)

-- 
2.30.2

