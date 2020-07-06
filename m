Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093F42158B6
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 15:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgGFNmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 09:42:11 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47740 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729158AbgGFNmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 09:42:10 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 13701B9CE76425DA7FFA;
        Mon,  6 Jul 2020 21:42:09 +0800 (CST)
Received: from kernelci-master.huawei.com (10.175.101.6) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 6 Jul 2020 21:41:57 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: [PATCH -next] perf/core: Make some symbols static
Date:   Mon, 6 Jul 2020 21:52:08 +0800
Message-ID: <20200706135208.80692-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sparse report build warning as follows:

kernel/events/core.c:6493:6: warning: symbol
 'perf_pmu_snapshot_aux' was not declared. Should it be static?
kernel/events/core.c:10545:1: warning: symbol
 'dev_attr_nr_addr_filters' was not declared. Should it be static?
 
'perf_pmu_snapshot_aux' and 'dev_attr_nr_addr_filters' are not used
outside of this file, so mark them static.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 kernel/events/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1449553a8d44..9465f30ad981 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6490,10 +6490,10 @@ static unsigned long perf_prepare_sample_aux(struct perf_event *event,
 	return data->aux_size;
 }
 
-long perf_pmu_snapshot_aux(struct perf_buffer *rb,
-			   struct perf_event *event,
-			   struct perf_output_handle *handle,
-			   unsigned long size)
+static long perf_pmu_snapshot_aux(struct perf_buffer *rb,
+				  struct perf_event *event,
+				  struct perf_output_handle *handle,
+				  unsigned long size)
 {
 	unsigned long flags;
 	long ret;
@@ -10542,7 +10542,7 @@ static ssize_t nr_addr_filters_show(struct device *dev,
 
 	return snprintf(page, PAGE_SIZE - 1, "%d\n", pmu->nr_addr_filters);
 }
-DEVICE_ATTR_RO(nr_addr_filters);
+static DEVICE_ATTR_RO(nr_addr_filters);
 
 static struct idr pmu_idr;
 

