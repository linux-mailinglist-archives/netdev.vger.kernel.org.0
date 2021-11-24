Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A31F45C31D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 14:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352321AbhKXNfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 08:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351820AbhKXNdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 08:33:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E663D61B42;
        Wed, 24 Nov 2021 12:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758434;
        bh=4FWpbJjc67hKE2N6NsHxiJw01NesjLwtiUBhXamYQdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCKokSdzhG7imCrNdMlN5m7J4dTQoinFnqh4Lqfmci/KWcBXoIIsbfbOd07Cg6Hqh
         g3PRaxhhG+Cpq4pGvDIeKpvV6vCVUkXclwF78mGDfqwgFh5hPEVxI79q++RJ92JeC/
         ci1GLYP099+VOGou02hHCf05TkNHrbxu/qd5USWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/154] perf tests: Remove bash construct from record+zstd_comp_decomp.sh
Date:   Wed, 24 Nov 2021 12:57:43 +0100
Message-Id: <20211124115704.482090973@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James Clark <james.clark@arm.com>

[ Upstream commit a9cdc1c5e3700a5200e5ca1f90b6958b6483845b ]

Commit 463538a383a2 ("perf tests: Fix test 68 zstd compression for
s390") inadvertently removed the -g flag from all platforms rather than
just s390, because the [[ ]] construct fails in sh. Changing to single
brackets restores testing of call graphs and removes the following error
from the output:

  $ ./perf test -v 85
  85: Zstd perf.data compression/decompression                        :
  --- start ---
  test child forked, pid 50643
  Collecting compressed record file:
  ./tests/shell/record+zstd_comp_decomp.sh: 15: [[: not found

Fixes: 463538a383a2 ("perf tests: Fix test 68 zstd compression for s390")
Signed-off-by: James Clark <james.clark@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/20211028134828.65774-3-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/record+zstd_comp_decomp.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/record+zstd_comp_decomp.sh b/tools/perf/tests/shell/record+zstd_comp_decomp.sh
index 045723b3d9928..c62af807198de 100755
--- a/tools/perf/tests/shell/record+zstd_comp_decomp.sh
+++ b/tools/perf/tests/shell/record+zstd_comp_decomp.sh
@@ -12,7 +12,7 @@ skip_if_no_z_record() {
 
 collect_z_record() {
 	echo "Collecting compressed record file:"
-	[[ "$(uname -m)" != s390x ]] && gflag='-g'
+	[ "$(uname -m)" != s390x ] && gflag='-g'
 	$perf_tool record -o $trace_file $gflag -z -F 5000 -- \
 		dd count=500 if=/dev/urandom of=/dev/null
 }
-- 
2.33.0



