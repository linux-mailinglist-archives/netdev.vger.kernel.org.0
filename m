Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9F1156EE7
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 06:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgBJFov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 00:44:51 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34530 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgBJFov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 00:44:51 -0500
Received: by mail-pj1-f66.google.com with SMTP id f2so2606744pjq.1;
        Sun, 09 Feb 2020 21:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=labp035rli0OVm73UTGjoZ6dXuDB1qKbYO5tg3KOfN0=;
        b=TU/wBb4XkZKeMhj1Q+CUixOVtoA1mf2W79DLnHBSGHDQaiDpoJohR2vtxYOA6WJnbb
         7v9oBakXRcPcHlm0Hl9kuLsuJ1DmcMr1Xl8v0ULDK0kTxz66QREC1oWkVQyf77tB9R5U
         449zXzCvTiuQHlM+xZY6VVH+Tp+TaG+gSWxv/Kv9LD/sPdiK474wkNE47xrJI+2qi1MJ
         F36m2Pu/Agn7g8AuPLSkBmsEUaO2JA6nC6lPQHFL9JsU02TXSd+sC7niv6ZPLfKI9NyD
         Svstm2AseGXwd5ThutJYBHUAMcTJ6aJeHEwgphgvHFmrY4cL+XQIe9+suYjQBTW+yf/P
         vKtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=labp035rli0OVm73UTGjoZ6dXuDB1qKbYO5tg3KOfN0=;
        b=H+YjCz3Umc3OBnf1KE9bLQE5YIpMaAdTJFUUpOysk1RJ0gkfn5gyxq6WranWob15Ce
         cPn17XRI778ZyLP1VHsYA8uRcphJgBI+ByNGNC8PsIBUDMuYH6HXnOSEAkjUAJxZen4P
         vLjSTnpQ3WWfpUBydSd+6F29J8S2n6y8QTmHQhqBA8g9xJHTwodsorOCdndgdE+jGDNI
         3JAQUq6QmBOqPz7Ynrko9hjGPf9lRFG12By6Sqauv/MoYdO59/ue6s9/6Ys/iPpMv3eV
         /FcY45fCc8AHoxZQ6VKHb90xQVOzCIbvfPHN/poG+MvuMmlflD0Rw/udK/fliqeMj68y
         r+Cg==
X-Gm-Message-State: APjAAAV7g64gnuN4NKqzBfGC6gSzd/kJrvZMcIvouO6ke0amI7/M6lu/
        TqZfufO4UGICZOSKWdek17I=
X-Google-Smtp-Source: APXvYqyz94mEMAGD9HZUu8ZQWtYKzgXd7PpEsARBppsi4WOvkCAbMogepgU8/i5/+jWLBF+D5hc7Yw==
X-Received: by 2002:a17:90a:9f83:: with SMTP id o3mr18752096pjp.95.1581313490372;
        Sun, 09 Feb 2020 21:44:50 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y190sm10861171pfb.82.2020.02.09.21.44.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Feb 2020 21:44:49 -0800 (PST)
Subject: [PATCH] bpf: selftests build error in sockmap_basic.c
From:   John Fastabend <john.fastabend@gmail.com>
To:     alexei.starovoitov@gmail.com, jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net
Date:   Sun, 09 Feb 2020 21:44:37 -0800
Message-ID: <158131347731.21414.12120493483848386652.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following build error. We could push a tcp.h header into one of the
include paths, but I think its easy enough to simply pull in the three
defines we need here. If we end up using more of tcp.h at some point
we can pull it in later.

/home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c: In function ‘connected_socket_v4’:
/home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:20:11: error: ‘TCP_REPAIR_ON’ undeclared (first use in this function)
  repair = TCP_REPAIR_ON;
           ^
/home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:20:11: note: each undeclared identifier is reported only once for each function it appears in
/home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:29:11: error: ‘TCP_REPAIR_OFF_NO_WP’ undeclared (first use in this function)
  repair = TCP_REPAIR_OFF_NO_WP;

Then with fix,

$ ./test_progs -n 44
#44/1 sockmap create_update_free:OK
#44/2 sockhash create_update_free:OK
#44 sockmap_basic:OK

Fixes: 5d3919a953c3c ("selftests/bpf: Test freeing sockmap/sockhash with a socket in it")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c       |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 07f5b46..aa43e0b 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -3,6 +3,11 @@
 
 #include "test_progs.h"
 
+#define TCP_REPAIR		19	/* TCP sock is under repair right now */
+
+#define TCP_REPAIR_ON		1
+#define TCP_REPAIR_OFF_NO_WP	-1	/* Turn off without window probes */
+
 static int connected_socket_v4(void)
 {
 	struct sockaddr_in addr = {

