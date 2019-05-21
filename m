Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DC92591F
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfEUUk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:40:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44220 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbfEUUk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:40:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKdCjs007756;
        Tue, 21 May 2019 20:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=5I9CKb5Hl96KPJjCWN8+MeUPzJsUMvUtl48sSHTlfMk=;
 b=caRY3AXwi9gnuNMuEYsTt974sgzl/Q4g7k4cnb4RoRCRbLOrFN4QCoBzWnjH1LQaWMs4
 d4bExD8tUSTJx/ZWxqbf8qrC4yYt9SWF7HagGZ/5oA4hTjhNtz4Mi9ba63xgztVMn9o/
 EMyCV4mvktp6Gv4LAfzXlCyP6by879aeSnCa9POEdPtc2OSc77kC2H5E2klSCnvcaQKB
 B2PA9dbNq1LQ2f15rOnXUTXWIBXND/H04UlzPVl0AQQSLpWTU5lMTtSWQXuQXrKmpcWl
 BUxz0SJKTj/xDjEBSWy7uJvBulYvQ4LX2vOpb1uD4GX/RX+CbsHFxnaDHF1w79rdgsWI Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sjapqfvuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:39:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKdevM067582;
        Tue, 21 May 2019 20:39:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2sks1jnp9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 May 2019 20:39:41 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4LKdesO067590;
        Tue, 21 May 2019 20:39:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2sks1jnp91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:39:40 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4LKddbl023199;
        Tue, 21 May 2019 20:39:39 GMT
Message-Id: <201905212039.x4LKddbl023199@aserv0121.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Tue, 21 May 2019 20:39:38 +0000
MIME-Version: 1.0
Date:   Tue, 21 May 2019 20:39:38 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 03/11] bpf: export proto for bpf_perf_event_output helper
In-Reply-To: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_perf_event_output helper is used by various tracer BPF program
types, but it was not visible outside of bpf_trace.c.  In order to make
it available to tracer BPF program types that are implemented elsewhere,
a function is added similar to bpf_get_trace_printk_proto() to query the
prototype (bpf_get_perf_event_output_proto()).

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Nick Alcock <nick.alcock@oracle.com>
---
 include/linux/bpf.h      | 1 +
 kernel/trace/bpf_trace.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7a40a3cd7ff2..e4bcb79656c4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -479,6 +479,7 @@ bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *f
 int bpf_prog_calc_tag(struct bpf_prog *fp);
 
 const struct bpf_func_proto *bpf_get_trace_printk_proto(void);
+const struct bpf_func_proto *bpf_get_perf_event_output_proto(void);
 
 typedef unsigned long (*bpf_ctx_copy_t)(void *dst, const void *src,
 					unsigned long off, unsigned long len);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b496ffdf5f36..3d812238bc40 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -473,6 +473,12 @@ static const struct bpf_func_proto bpf_perf_event_output_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+const struct bpf_func_proto *bpf_get_perf_event_output_proto(void)
+{
+	return &bpf_perf_event_output_proto;
+}
+
+
 static DEFINE_PER_CPU(struct pt_regs, bpf_pt_regs);
 static DEFINE_PER_CPU(struct perf_sample_data, bpf_misc_sd);
 
-- 
2.20.1

