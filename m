Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38688472204
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 08:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhLMH7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 02:59:22 -0500
Received: from out162-62-57-137.mail.qq.com ([162.62.57.137]:56209 "EHLO
        out162-62-57-137.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229728AbhLMH7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 02:59:21 -0500
X-Greylist: delayed 25267 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2021 02:59:19 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1639382357;
        bh=hZhmtF9KS7UscRW9F6LM5Awl0828NXiTWNMt+b+wQDQ=;
        h=From:To:Cc:Subject:Date;
        b=TUiweKALXsLE8x4WxBUN/hUQsRx0DOPKrc3Hw3qv3FSU8Kbbtbl/uq3JfauoNZlM5
         iyRXn7a22/FH1pkaHnRFy/adKimfCgMSNfwb1WSsIjCUMY4AIUNRCO1CosYorQXnau
         D29/9cwDtev6laCCbNa1360xa/5e9YmrVCl+dGHY=
Received: from localhost.localdomain ([218.197.153.188])
        by newxmesmtplogicsvrszc9.qq.com (NewEsmtp) with SMTP
        id ECE938A4; Mon, 13 Dec 2021 15:59:14 +0800
X-QQ-mid: xmsmtpt1639382354tev1jruem
Message-ID: <tencent_B595FC0780AC301FE5EE719C50FC8553280A@qq.com>
X-QQ-XMAILINFO: MAMW4dxoxFytibx0XFNH1TQTAxCMbttEUazcBw73t1yGH1ebeugJMlPzP8O0DP
         XCfRa7KZk1dq7DZwUdDwrM74mdmhWXOmXD5DUKqdrljyjCNpDMfxgWmEWOLgE5FYdFNpbdR2Q08Z
         mjCj/yRomvTCcjiaQCdIb1SyzdiWfzogrGCIR/eCrWLCGgFIgv8qUdWulxtiMbYqick0KlP1VH1a
         GdEmZg8gTfaaY/tl0mmjW7DL0yg1O/6L/d06vJJzf8Kr6TDqUL9H7yHVflAXBkK6+Rc2uKD2S1W5
         ipIn4z/Nu0nYNU8DZyR36yjSWjjsiBB+y0/X3c2jWaMUBKjnd3zF0C5NYWcrcnPhfYOcmrQWQ53c
         GPXqr0lTVaVWTWMPw/6yOMnbflbaFywo6QmuLIJm5yyvxlBF6XZtv9u3LznPc7Czgk8MDvJ6Gt2M
         XrqqF4E+Fjj0OAoy8Swp/IWkkdZQCmutVrW7quqUnMEmUyMEwxaONqMsmbC48/Y+FUVlpzkPwxaK
         2HYNCIKFDMPD2EiYCrxFz1bWvKDo0RV9T6z9wr/d03LIlz4mTXu7yJiLT9ty9gO345GpVqLO6EZd
         wdFoplbaGnmoVhl4WAqucqg+MRJnVoaXBVQ9jacJeN6CChjQoFbaePQjGPBaguiR42lvNldZG0KS
         dn47ZMPmiEHh/IVeWjTPPLURCEpun5GfH6ZO0kz5F0v1/dqwXkZPzACiQr/nb3E+dlzdYzUCdrs1
         llRCMGQtpqFGvW1Hxt5djAisHnpPK7+riP6pmlZXxConD2/9EbcFG/csme8GF9qu8F8dT7SR58QG
         5X6RIfALmL44wcaSDpEBhJEDnDw8xVZVM/Xz/+1Su++FEY8QczzYmco5oJW85SROIlW4S9txLmV1
         0Xidu7sf3p+VuBCdyJaK96y+svrXBPwQAKjfwdJvraDZEjWBNbO8t9J2xRb0O/RdmMZC3h/rwR
From:   Xiaoke Wang <xkernel.wang@foxmail.com>
To:     rostedt@goodmis.org, mingo@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>
Subject: Re: [PATCH] tracing: check the return value of kstrdup()
Date:   Mon, 13 Dec 2021 15:59:04 +0800
X-OQ-MSGID: <20211213075904.4325-1-xkernel.wang@foxmail.com>
X-Mailer: git-send-email 2.33.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note: Compare with the last email, this one is using my full name.
And I am sorry that yesterday I did not notice the bugs in trace_boot.c had been
already patched.
kstrdup() returns NULL when some internal memory errors happen, it is
better to check the return value of it.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
---
 kernel/trace/trace_uprobe.c | 5 +++++
 1 files changed, 5 insertions(+)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 225ce56..173ff0f 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1618,6 +1618,11 @@ create_local_trace_uprobe(char *name, unsigned long offs,
 	tu->path = path;
 	tu->ref_ctr_offset = ref_ctr_offset;
 	tu->filename = kstrdup(name, GFP_KERNEL);
+	if (!tu->filename) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
 	init_trace_event_call(tu);
 
 	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
-- 
