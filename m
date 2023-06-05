Return-Path: <netdev+bounces-8121-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6BD722CF0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FFC5280E22
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D033B9468;
	Mon,  5 Jun 2023 16:50:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27D26FC3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:50:08 +0000 (UTC)
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF9310D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:50:01 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 586BB6C1EA5
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:50:00 +0000 (UTC)
Received: from pdx1-sub0-mail-a246.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id E4E696C1EFA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:49:59 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1685983799; a=rsa-sha256;
	cv=none;
	b=xqWer2mtuSNAOYeRhqbnbHXheOSBNCysUHSCbFW1glE69khwsScZ/QMCB2RmJEISB5VD0c
	absjbl/MV871W27WQ+MEQaU8jzxySIyFV14MYByBcNbMi7waOSkUZKRORaImbq/qlTzOQo
	RJ4Ijhr4gUcEvMnPoAqxi/mc4R6B6q5A+g0Z88DR7+2+m/uJM4iOhmItgygHYh6cv44IcV
	1LXUl2MsQyG7epmwQuoGIymFC0iED0/9Qjz+50lLfASYjOEEl/VMbthGMYRYpgMLcnkPzY
	kqW72nH2qPf216IQ99RZd+06iRGXlls9n8WWv7GqnKi5fs+mvyitBOpBKCoa6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1685983799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 dkim-signature; bh=bA9dwwrLWaPkBczdJGZf0n7gtEXmPiDCbFmELkXgQMQ=;
	b=yESzd6E7asq8w/7CKbH4q7Hv4HH/zgQB/5QnBLiWek0cHU54dSP71CZ9spoqG2sd+tHG7A
	u/2Sv468Dh1VdU611BpHpfp/DPnGkNQ7WEWCrd3DUWibqG9XZmxUyJ6NHe+d4hUhm02CCu
	lPDLh4EzKAyvk9xLD9zvu5TbjPK6vENFkWFe+BUbuibIlsE690So1IDDx9dpOS3EtBqYID
	TiE90Ya2OGL8PiUbfqfHSx2y5LPLd5tWkpI9xzUYVvGHmyIfdcHFalSOuNNsn+Z89/tPT6
	Au71avCLuUVmlglgnv4PDZByfnWvynRwqVtXgGXfSrofd+1hAJGYmg4z+uPvYw==
ARC-Authentication-Results: i=1;
	rspamd-56648fb6f9-kkvtb;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Industry-Attack: 150eeaac4690006c_1685983800172_86195380
X-MC-Loop-Signature: 1685983800172:4043999244
X-MC-Ingress-Time: 1685983800172
Received: from pdx1-sub0-mail-a246.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.127.59.37 (trex/6.8.1);
	Mon, 05 Jun 2023 16:50:00 +0000
Received: from kmjvbox (c-73-93-64-36.hsd1.ca.comcast.net [73.93.64.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a246.dreamhost.com (Postfix) with ESMTPSA id 4QZfjL4fPtz11s
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1685983798;
	bh=bA9dwwrLWaPkBczdJGZf0n7gtEXmPiDCbFmELkXgQMQ=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=GRh1O24h56VOD69FVspvvFrfKJDz125mN0N07VKMg7XGYe/cfg041XaIe60pBCdUq
	 6Y4me79JxShLfWOPtV+UvBSMGH62zQS/kzw0ic+Ir5FQPqiuVOuqoC5/h8szQysweq
	 rOun9wLRRodw/T2HjeAgqIk0/lRTPf56fQF0UA80=
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0044
	by kmjvbox (DragonFly Mail Agent v0.12);
	Mon, 05 Jun 2023 09:49:55 -0700
Date: Mon, 5 Jun 2023 09:49:55 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: bpf@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, llvm@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH bpf] bpf: search_bpf_extables should search subprogram
 extables
Message-ID: <20230605164955.GA1977@templeofstupid.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

JIT'd bpf programs that have subprograms can have a postive value for
num_extentries but a NULL value for extable.  This is problematic if one of
these bpf programs encounters a fault during its execution.  The fault
handlers correctly identify that the faulting IP belongs to a bpf program.
However, performing a search_extable call on a NULL extable leads to a
second fault.

Fix up by refusing to search a NULL extable, and by checking the
subprograms' extables if the umbrella program has subprograms configured.

Once I realized what was going on, I was able to use the following bpf
program to get an oops from this failure:

   #include "vmlinux.h"
   #include <bpf/bpf_helpers.h>
   #include <bpf/bpf_tracing.h>
   
   char LICENSE[] SEC("license") = "Dual BSD/GPL";
   
   #define PATH_MAX 4096
   
   struct callback_ctx {
           u8 match;
   };
   
   struct filter_value {
           char prefix[PATH_MAX];
   };
   struct {
           __uint(type, BPF_MAP_TYPE_ARRAY);
           __uint(max_entries, 256);
           __type(key, int);
           __type(value, struct filter_value);
   } test_filter SEC(".maps");
   
   static __u64 test_filter_cb(struct bpf_map *map, __u32 *key,
                               struct filter_value *val,
                               struct callback_ctx *data)
   {
       return 1;
   }
   
   SEC("fentry/__sys_bind")
   int BPF_PROG(__sys_bind, int fd, struct sockaddr *umyaddr, int addrlen)
   {
     pid_t pid;
   
     struct callback_ctx cx = { .match = 0 };
     pid = bpf_get_current_pid_tgid() >> 32;
     bpf_for_each_map_elem(&test_filter, test_filter_cb, &cx, 0);
     bpf_printk("fentry: pid = %d, family = %llx\n", pid, umyaddr->sa_family);
     return 0;
   }

And then the following code to actually trigger a failure:

  #include <stdio.h>
  #include <stdlib.h>
  #include <unistd.h>
  #include <sys/socket.h>
  #include <netinet/in.h>
  #include <netinet/ip.h>
  
  int
  main(int argc, char *argv[])
  {
    int sfd, rc;
    struct sockaddr *sockptr = (struct sockaddr *)0x900000000000;
  
    sfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sfd < 0) {
      perror("socket");
      exit(EXIT_FAILURE);
    }
  
    while (1) {
      rc = bind(sfd, (struct sockaddr *) sockptr, sizeof(struct sockaddr_in));
      if (rc < 0) {
        perror("bind");
        sleep(5);
      } else {
        break;
      }
    }
  
    return 0;
  }

I was able to validate that this problem does not occur when subprograms
are not in use, or when the direct pointer accesses are replaced with
bpf_probe_read calls.  I further validated that this did not break the
extable handling in existing bpf programs.  The same program caused no
failures when subprograms were removed, but the exception was still
injected.

Cc: stable@vger.kernel.org
Fixes: 1c2a088a6626 ("bpf: x64: add JIT support for multi-function programs")
Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 kernel/bpf/core.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7421487422d4..0e12238e4340 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -736,15 +736,33 @@ const struct exception_table_entry *search_bpf_extables(unsigned long addr)
 {
 	const struct exception_table_entry *e = NULL;
 	struct bpf_prog *prog;
+	struct bpf_prog_aux *aux;
+	int i;
 
 	rcu_read_lock();
 	prog = bpf_prog_ksym_find(addr);
 	if (!prog)
 		goto out;
-	if (!prog->aux->num_exentries)
+	aux = prog->aux;
+	if (!aux->num_exentries)
 		goto out;
 
-	e = search_extable(prog->aux->extable, prog->aux->num_exentries, addr);
+	/* prog->aux->extable can be NULL if subprograms are in use. In that
+	 * case, check each sub-function's aux->extables to see if it has a
+	 * matching entry.
+	 */
+	if (aux->extable != NULL) {
+		e = search_extable(prog->aux->extable,
+		    prog->aux->num_exentries, addr);
+	} else {
+		for (i = 0; (i < aux->func_cnt) && (e == NULL); i++) {
+			if (!aux->func[i]->aux->num_exentries ||
+			    aux->func[i]->aux->extable == NULL)
+				continue;
+			e = search_extable(aux->func[i]->aux->extable,
+			    aux->func[i]->aux->num_exentries, addr);
+		}
+	}
 out:
 	rcu_read_unlock();
 	return e;
-- 
2.25.1


