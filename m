Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826892A129
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404446AbfEXW1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43524 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404396AbfEXW13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:27:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id l17so2982050wrm.10
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CMIkQOSkmcVf3vLVosaE6Q/2oGq+edbegUwjxTcb43k=;
        b=FKNUJioGObBUV6R6dGVFBAXl0oy3JsZgoFa8YLicqbvtTcW982xN5TB7TtVu9Cw/2j
         FaIixBPyhOdhB1UDKgy7FNZU4jSphV89At6uDe8hf1UtetJ1SIZuNCFvOvQ64wG7e4Er
         qoPkD+35HYT8fOT/p5Gw2FSpPfL1O2i8oeTbzr4rk6A/rOCIEPg8HN0fDmbQlrutIv0x
         NjgEVCPcej3R83uuLr/6GBJ8vjOBadbebGBCdapP1MyD1+tXBbltZQLH/CG83vw/Zlzx
         sF1AwftuBJVp6dYBxcmZm+ZvGMvMwKuUsmzdh2iCpRcWoE7lqQvC38C9Eu2b/32ohv4G
         Ievg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CMIkQOSkmcVf3vLVosaE6Q/2oGq+edbegUwjxTcb43k=;
        b=gYW9/YQcplbS1jUZWwsIUR7NF9gTajpjMUi31ZALNSYtb9532RSppy+L0/UlQ1r7XF
         CceG2alLjV2O+RV0xas+c4+AJXE+eqe5Top6qoFGoZ68MqLObIeoc/sOfMZMLSvY5UT8
         hagujqQUhL6O2SzubOk2+FObhB7ZouoXSqAOKKyBQf5PDsAE6URqyM38Bo86vf2QRkvJ
         ECAoCWmUe1qqcJx10P0r+v8becQ0PyscVIWJvC516R7quH+GjpTSkl7l1qN/UY5Hqhd8
         CH2ahrEVrAjAMnFg68mh+WV+JwoEvTXaz2rkdeWK3vkSAC0XxfBWwvziuWwy272iCpp8
         xQWA==
X-Gm-Message-State: APjAAAWSONJQ/CumuX6aB0jL5WiMkCBS4vxDkyPc29SUgyDnH7CfbNx+
        eBE4mOX/t4bXKqO68GoZV0lxSA==
X-Google-Smtp-Source: APXvYqy6iOlEZ9XDZ/O0gmstdad3lPs7tIcvVGo/uk6bZpuAD5aGU/U1vwErjWyDewauNvnrZe5XCw==
X-Received: by 2002:a5d:504f:: with SMTP id h15mr5307710wrt.208.1558736848443;
        Fri, 24 May 2019 15:27:28 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y10sm7194961wmg.8.2019.05.24.15.27.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 15:27:27 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v9 bpf-next 06/17] tools: bpf: sync uapi header bpf.h
Date:   Fri, 24 May 2019 23:25:17 +0100
Message-Id: <1558736728-7229-7-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync new bpf prog load flag "BPF_F_TEST_RND_HI32" to tools/.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 tools/include/uapi/linux/bpf.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 68d4470..7c6aef2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -260,6 +260,24 @@ enum bpf_attach_type {
  */
 #define BPF_F_ANY_ALIGNMENT	(1U << 1)
 
+/* BPF_F_TEST_RND_HI32 is used in BPF_PROG_LOAD command for testing purpose.
+ * Verifier does sub-register def/use analysis and identifies instructions whose
+ * def only matters for low 32-bit, high 32-bit is never referenced later
+ * through implicit zero extension. Therefore verifier notifies JIT back-ends
+ * that it is safe to ignore clearing high 32-bit for these instructions. This
+ * saves some back-ends a lot of code-gen. However such optimization is not
+ * necessary on some arches, for example x86_64, arm64 etc, whose JIT back-ends
+ * hence hasn't used verifier's analysis result. But, we really want to have a
+ * way to be able to verify the correctness of the described optimization on
+ * x86_64 on which testsuites are frequently exercised.
+ *
+ * So, this flag is introduced. Once it is set, verifier will randomize high
+ * 32-bit for those instructions who has been identified as safe to ignore them.
+ * Then, if verifier is not doing correct analysis, such randomization will
+ * regress tests to expose bugs.
+ */
+#define BPF_F_TEST_RND_HI32	(1U << 2)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
  *
-- 
2.7.4

