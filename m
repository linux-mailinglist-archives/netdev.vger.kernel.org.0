Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061EC1D5A58
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgEOTtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726204AbgEOTtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 15:49:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9894C05BD09
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 12:49:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z7so3405614ybn.21
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 12:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0lx4/muAj6zHL5hlNrQDx8C/+BhbmUkBZUFKAjLFg14=;
        b=aeu6q1m7nVHL3PgmuMxmXvACbigIfstLfKme6Y8xFp+EQV0WxXxrEXWpu2YB1cKvEg
         7G0gJVWh7sgGEJH0VGAZRjn17cDmDBwEUjoLW/FlO3Qm362+n9w1Zkgbg1N/sQvgGqFQ
         3FTPYPvZTH0d4fkvAtfcDDu9KcNBAxOWnB6U4CzVN66NVcMKy4lWWiw2UPJJJRBLx4rL
         4OiHiVC+h4MRCY4MdzLjcG0bVbvccKoWAQagm8kzGTKJmO9ShwrAquxQHrj0F9u+8B6r
         enBu8nBouFvRjR3USPbQa3pOyS1q36mIQoIVn37UHxB+S4UXUuxKMoE+sPBoqXMRsqf9
         9CQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0lx4/muAj6zHL5hlNrQDx8C/+BhbmUkBZUFKAjLFg14=;
        b=MrwHdBzqQaPq2grp3Qa0QmcWV92cRjiafKlWTSXntEzdPzTlkxYf+OIg0ntPnXJfWy
         LgnubXbMvOUGttgVsEaNkxBtSZmT9Q3pO2HDuVzPi/Bgq9N0FTIL0h0+SsJId3cl2ALK
         C12P+JhfOyaPkbAqi1/2JW70anw/diBMu3+QqgkM7DgDRVM4p9GK4eGwzirliyv8C7gI
         O3/H30y0YAoaECL4utKtQ596iooNJ4gfJ8yOH2YsGjnAqHm6m3Mr374er92BmW6m8BNS
         t+6xLOj+XsJB/caETHVPFm2wObMPwPpuHBJKyJjTwEUet/y7tGh/nAa41RX1fHQjm+2P
         GrmQ==
X-Gm-Message-State: AOAM5328IAwSEx3drAccY+dQTGwCUzPm05/t5yC+yYQspZqzvE3bJaSz
        b+521Fiqy7knON+5zBPPzpZx3AFtK8lx5YeLvoU/wU1luhVD/QFZwgRYrsVfy+8AQTQLSduhIN6
        /xHvF/Lv2IyWJaa3mkqxL4uqIZVhLOBuOninv+D23gkRregjT5Pxa8Q==
X-Google-Smtp-Source: ABdhPJw9asfw462ApaggfcGn4vZ/mEZjRo7LyirHwmtnRYAHg6ZQGiHUtpOjU2BZjn9W7NvMXlghgZ8=
X-Received: by 2002:a25:bc8d:: with SMTP id e13mr8575945ybk.67.1589572145960;
 Fri, 15 May 2020 12:49:05 -0700 (PDT)
Date:   Fri, 15 May 2020 12:49:03 -0700
Message-Id: <20200515194904.229296-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH bpf-next 1/2] selftests/bpf: fix test_align
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always
call update_reg_bounds()") changed the way verifier logs some of its state,
adjust the test_align accordingly. Where possible, I tried to
not copy-paste the entire log line and resorted to dropping
the last closing brace instead.

Fixes: 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_align.c | 41 ++++++++++++------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 0262f7b374f9..c9c9bdce9d6d 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -359,15 +359,15 @@ static struct bpf_align_test tests[] = {
 			 * is still (4n), fixed offset is not changed.
 			 * Also, we create a new reg->id.
 			 */
-			{29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc))"},
+			{29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (18)
 			 * which is 20.  Then the variable offset is (4n), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc))"},
-			{33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc))"},
+			{33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
+			{33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
 		},
 	},
 	{
@@ -410,15 +410,15 @@ static struct bpf_align_test tests[] = {
 			/* Adding 14 makes R6 be (4n+2) */
 			{9, "R6_w=inv(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
 			/* Packet pointer has (4n+2) offset */
-			{11, "R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
-			{13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
+			{11, "R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
+			{13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
 			 * which is 2.  Then the variable offset is (4n+2), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{15, "R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
+			{15, "R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
 			/* Newly read value in R6 was shifted left by 2, so has
 			 * known alignment of 4.
 			 */
@@ -426,15 +426,15 @@ static struct bpf_align_test tests[] = {
 			/* Added (4n) to packet pointer's (4n+2) var_off, giving
 			 * another (4n+2).
 			 */
-			{19, "R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
-			{21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
+			{19, "R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
+			{21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
 			 * which is 2.  Then the variable offset is (4n+2), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{23, "R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
+			{23, "R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
 		},
 	},
 	{
@@ -469,16 +469,16 @@ static struct bpf_align_test tests[] = {
 		.matches = {
 			{4, "R5_w=pkt_end(id=0,off=0,imm=0)"},
 			/* (ptr - ptr) << 2 == unknown, (4n) */
-			{6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))"},
+			{6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc)"},
 			/* (4n) + 14 == (4n+2).  We blow our bounds, because
 			 * the add could overflow.
 			 */
-			{7, "R5_w=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
+			{7, "R5_w=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>=0 */
-			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 			/* packet pointer + nonnegative (4n+2) */
-			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
-			{13, "R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{13, "R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
 			 * We checked the bounds, but it might have been able
 			 * to overflow if the packet pointer started in the
@@ -486,7 +486,7 @@ static struct bpf_align_test tests[] = {
 			 * So we did not get a 'range' on R6, and the access
 			 * attempt will fail.
 			 */
-			{15, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{15, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 		}
 	},
 	{
@@ -528,7 +528,7 @@ static struct bpf_align_test tests[] = {
 			/* New unknown value in R7 is (4n) */
 			{11, "R7_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			/* Subtracting it from R6 blows our unsigned bounds */
-			{12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,var_off=(0x2; 0xfffffffffffffffc))"},
+			{12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>= 0 */
 			{14, "R6=inv(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
 			/* At the time the word size load is performed from R5,
@@ -537,7 +537,8 @@ static struct bpf_align_test tests[] = {
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
+			{20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc)"},
+
 		},
 	},
 	{
@@ -579,18 +580,18 @@ static struct bpf_align_test tests[] = {
 			/* Adding 14 makes R6 be (4n+2) */
 			{11, "R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c))"},
 			/* Subtracting from packet pointer overflows ubounds */
-			{13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c))"},
+			{13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c)"},
 			/* New unknown value in R7 is (4n), >= 76 */
 			{15, "R7_w=inv(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc))"},
 			/* Adding it to packet pointer gives nice bounds again */
-			{16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
+			{16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
 			 * which is 2.  Then the variable offset is (4n+2), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
+			{20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
 		},
 	},
 };
-- 
2.26.2.761.g0e0b3e54be-goog

