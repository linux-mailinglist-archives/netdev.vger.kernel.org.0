Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AD351A801
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355171AbiEDRHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 13:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355112AbiEDRFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 13:05:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA9D47555;
        Wed,  4 May 2022 09:54:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9412C618A8;
        Wed,  4 May 2022 16:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2686C385A4;
        Wed,  4 May 2022 16:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683258;
        bh=+3exiSTvH1RziwAzmzXEO9NmF8jkw7MocJUim/2IhpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQgFuPvd8NCKZon2sTow+Z/Z8B5a/gEQMQwTrml/nlqgSJr0SsrGZZevAln58Q33u
         sj2PlUq17387Hgbf5wdcVoeI6ilW9SlvaAbWaBgz1HQ4g0sUW2hhtZl03CWh6QaZ8A
         gk6EsclaLwAFF7Fqs1MFW3MtQmB7hB34Z1q1V7/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Timothy Hayes <timothy.hayes@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        bpf@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        John Garry <john.garry@huawei.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, netdev@vger.kernel.org,
        Song Liu <songliubraving@fb.com>,
        Will Deacon <will@kernel.org>, Yonghong Song <yhs@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/177] perf arm-spe: Fix addresses of synthesized SPE events
Date:   Wed,  4 May 2022 18:45:16 +0200
Message-Id: <20220504153104.142014535@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Timothy Hayes <timothy.hayes@arm.com>

[ Upstream commit 4e13f6706d5aee1a6b835a44f6cf4971a921dcb8 ]

This patch corrects a bug whereby synthesized events from SPE
samples are missing virtual addresses.

Fixes: 54f7815efef7fad9 ("perf arm-spe: Fill address info for samples")
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: bpf@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: John Garry <john.garry@huawei.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20220421165205.117662-2-timothy.hayes@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 7054f23150e1..235549bb28b9 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -927,7 +927,8 @@ arm_spe_synth_events(struct arm_spe *spe, struct perf_session *session)
 	attr.type = PERF_TYPE_HARDWARE;
 	attr.sample_type = evsel->core.attr.sample_type & PERF_SAMPLE_MASK;
 	attr.sample_type |= PERF_SAMPLE_IP | PERF_SAMPLE_TID |
-			    PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC;
+			    PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC |
+			    PERF_SAMPLE_ADDR;
 	if (spe->timeless_decoding)
 		attr.sample_type &= ~(u64)PERF_SAMPLE_TIME;
 	else
-- 
2.35.1



