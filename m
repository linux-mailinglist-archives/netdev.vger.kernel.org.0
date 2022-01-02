Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A51C482BF0
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiABQV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbiABQVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:21:25 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9685C061784;
        Sun,  2 Jan 2022 08:21:24 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso35520581pjc.4;
        Sun, 02 Jan 2022 08:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xP2GpYAOF9CdXJVl41Jy6MeeNxSHGMb2EJl82bCdhLk=;
        b=Wlk++8ftjsRmLKHAa41wuxPaq10rKMqxE+2fItkr+0jT/qTSpkUXyVvv6q3jiPE6Zy
         2P5tYaWQpc4PQHTCN7UW0VTHK7oEt/7n7jHdPdxCuE+fzNdMYrU7ycOCFBif/YfmgwJ1
         y2yugPPoBRaGy0XS/TMpTUeVcKi73rFB1IV7DfwuOXlSg3wzSw5pILPHomNyFdwbiA2p
         ntPQO5m9fJpkyt5JG8HAtXFfqKnqd8zCTw9kHU+dNohvbknKoB46g5wM8febApjO+u3/
         qmiRBbAvatpEJy7sOV6bKBe0u/rN+6mo7et4ffDc59Qa+JD36T/b0cpDk1/1Xgxn8MIe
         xl+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xP2GpYAOF9CdXJVl41Jy6MeeNxSHGMb2EJl82bCdhLk=;
        b=Nr6ZX+TEyJJY+fhZ96PXTIZZs0cGZH9gmNYm8WncADrPiFVcIa5F3HIKOmkrJ0qP5q
         9WNc475v5AoxpmnbKJfBCUvUZPLU+4zlbcHG3xjKYL1U/iCmfP75ixMcHoNiiRei79OC
         peoJnf4SUyiPD10nv//Vde0OsKfjvxmasDW9dZ5fVCNnQaUwI27EeP1xtfP9kM7T2Yj7
         yUePEMXakvEagmdyNW1U6BcJeV2wcJlQDcv6g/fl2Sd4zBKbM1qi2oshJHWadS9TRTfm
         V3pZyssiDa3LrigbiDbXHyQsg5WYMcBCrtv5m3F2wm9v12oHwwQjn9VAzTt3baeFknyN
         6JWg==
X-Gm-Message-State: AOAM531I7hWf7UCNTnoDhhztDPueTbhE+UGK9QKTiLieGoP6arAZfesr
        ek2yNukM6fn/J0RDN+7JbSpg3G1230A=
X-Google-Smtp-Source: ABdhPJyEkb+suVbVlXRrZ6njtDDzu/GJYCtOgBUGykNJLO1TdU/BQFJvgZKTtv1mZ2SrCfFgNp5yVw==
X-Received: by 2002:a17:903:234b:b0:149:b5dd:364b with SMTP id c11-20020a170903234b00b00149b5dd364bmr6228507plh.158.1641140484266;
        Sun, 02 Jan 2022 08:21:24 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id j4sm4265640pfa.149.2022.01.02.08.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 08:21:24 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v6 02/11] bpf: Fix UAF due to race between btf_try_get_module and load_module
Date:   Sun,  2 Jan 2022 21:51:06 +0530
Message-Id: <20220102162115.1506833-3-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220102162115.1506833-1-memxor@gmail.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3836; h=from:subject; bh=tGeHQtMmskBa59XJI3pK1YkA7rxvArC5aJ7MibngMZk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh0dCJZT33jHMhrkn5pRDFjtbrIo0gvSTikQ84veCT RwqCvd+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYdHQiQAKCRBM4MiGSL8RyiwVD/ 4hcKPz8ly/Sw8332MaOUAQ5pHhZ2Uyo+Q6iVU+oPqPRW3eg76JeZFJ9PMLvMs6jjeHl8Y3/9u3JqkU ia8Pbx9sHIib8E9Bt1QaNtL2CqZbMl5USKR+yTLOubqRPpEftPpUPxTbh5qrFevEIs66khvk4N2+sf vKlOrMmhiocHCY7YEqcO6Frygub6ELZeJNkg4InMPRUw2bH2fdkSP3jLfoAC99o4L19PZEUq/2vMaW SNER9GevUBVwir6qDtFkwRhJSA8PMSg54Trz7ZPkMNhBK5wUBs4rvOwa4NGXsrilz7GtE3Zg18aevA aTwI4dnyG+AMzeQ4vUQr9hBucsa6Pxp3f9+eKYl9vNft6n6k6i/cksA+LpHunGAcVB/HZmjPC55wxL xtygg67GqwTaGuWYdXa3fUqJ2kATOXcGDtx9GX8T7INYgK6l4zaZJhW8PAlutr+SE2JJKqOX3aA6vU eJcIusHHjt7LWjeMTG5tnYO1AKjniSOtGRNRBIaWW6NTSdv4qqP5Dro5NCHf6DwtkmjipZxTYCe4pP XpVcQpKMsIruLTYmGgmJJsAg7SAUyg4TNUIp8W7ua2ul3IOyyJioYjzxCZp8KbzTkHavFhqZE6dyH1 sNsAT6qW11X6c8PRSJILyN5IFQRd6ceuNCxwpu4Mphh3VelDMX6X/DjOLd1Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While working on code to populate kfunc BTF ID sets for module BTF from
its initcall, I noticed that by the time the initcall is invoked, the
module BTF can already be seen by userspace (and the BPF verifier). The
existing btf_try_get_module calls try_module_get which only fails if
mod->state == MODULE_STATE_GOING, i.e. it can increment module reference
when module initcall is happening in parallel.

Currently, BTF parsing happens from MODULE_STATE_COMING notifier
callback. At this point, the module initcalls have not been invoked.
The notifier callback parses and prepares the module BTF, allocates an
ID, which publishes it to userspace, and then adds it to the btf_modules
list allowing the kernel to invoke btf_try_get_module for the BTF.

However, at this point, the module has not been fully initialized (i.e.
its initcalls have not finished). The code in module.c can still fail
and free the module, without caring for other users. However, nothing
stops btf_try_get_module from succeeding between the state transition
from MODULE_STATE_COMING to MODULE_STATE_LIVE.

This leads to a use-after-free issue when BPF program loads
successfully in the state transition, load_module's do_init_module call
fails and frees the module, and BPF program fd on close calls module_put
for the freed module. Future patch has test case to verify we don't
regress in this area in future.

There are multiple points after prepare_coming_module (in load_module)
where failure can occur and module loading can return error. We
illustrate and test for the race using the last point where it can
practically occur (in module __init function).

An illustration of the race:

CPU 0                           CPU 1
			  load_module
			    notifier_call(MODULE_STATE_COMING)
			      btf_parse_module
			      btf_alloc_id	// Published to userspace
			      list_add(&btf_mod->list, btf_modules)
			    mod->init(...)
...				^
bpf_check		        |
check_pseudo_btf_id             |
  btf_try_get_module            |
    returns true                |  ...
...                             |  module __init in progress
return prog_fd                  |  ...
...                             V
			    if (ret < 0)
			      free_module(mod)
			    ...
close(prog_fd)
 ...
 bpf_prog_free_deferred
  module_put(used_btf.mod) // UAF

A later selftest patch adds crafts the race condition artifically to
verify it has been fixed, and verifier fails to load program.

Lastly, a couple of comments:

 1. Even if this race didn't exist, it seems more appropriate to only
    access resources (ksyms and kfuncs) of a fully formed module which
    has been initialized completely.

 2. This patch was born out of need for synchronization against module
    initcall for the next patch, so it is needed for correctness even
    without the aforementioned race condition. The BTF resources
    initialized by module initcall are set up once and then only looked
    up, so just waiting until the initcall has finished ensures correct
    behavior.

Fixes: 541c3bad8dc5 ("bpf: Support BPF ksym variables in kernel modules")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/btf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 33bb8ae4a804..b5b423de53ab 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6338,7 +6338,10 @@ struct module *btf_try_get_module(const struct btf *btf)
 		if (btf_mod->btf != btf)
 			continue;
 
-		if (try_module_get(btf_mod->module))
+		/* We must only consider module whose __init routine has
+		 * finished, hence use try_module_get_live.
+		 */
+		if (try_module_get_live(btf_mod->module))
 			res = btf_mod->module;
 
 		break;
-- 
2.34.1

