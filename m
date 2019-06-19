Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66EA4BE3A
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfFSQa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:30:59 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.109]:18784 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725899AbfFSQa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 12:30:59 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id D7D3831E4B
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 11:07:10 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id dd78hzaAkdnCedd78haXSw; Wed, 19 Jun 2019 11:07:10 -0500
X-Authority-Reason: nr=8
Received: from cablelink-187-160-61-213.pcs.intercable.net ([187.160.61.213]:45847 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hdd77-003AwA-QE; Wed, 19 Jun 2019 11:07:09 -0500
Date:   Wed, 19 Jun 2019 11:07:08 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH][bpf-next] bpf: verifier: add a break statement in switch
Message-ID: <20190619160708.GA30356@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.160.61.213
X-Source-L: No
X-Exim-ID: 1hdd77-003AwA-QE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: cablelink-187-160-61-213.pcs.intercable.net (embeddedor) [187.160.61.213]:45847
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 19
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Notice that in this case, it's much clearer to explicitly add a break
rather than letting the code to fall through. It also avoid potential
future fall-through warnings[1].

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

[1] https://lore.kernel.org/patchwork/patch/1087056/

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 709ce4cef8ba..0b38cc917d21 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6066,6 +6066,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 			range = tnum_range(0, 3);
 			enforce_attach_type_range = tnum_range(2, 3);
 		}
+		break;
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 	case BPF_PROG_TYPE_SOCK_OPS:
-- 
2.21.0

