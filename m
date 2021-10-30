Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EC64409AB
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhJ3Osq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhJ3Osp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:48:45 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC4EC061570;
        Sat, 30 Oct 2021 07:46:15 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t21so8751854plr.6;
        Sat, 30 Oct 2021 07:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9klrgRgQzMH/Mh4zVMtr35Xc00VoRE93eTNM0xjODpw=;
        b=dx94PDN0En/WKw4gy/MygfuVPiulcuQMskZ4V9ufQKRwiUVFcWaF9zA8/F13zs7PHE
         lBvg2AmdXHKbJRaRcjska6N+Pio1z2YtEmxgMpXub4Rl+8RMhn2nsFfyXPjf1E4ZeYI7
         SrEBOnMpX5Ib3FT8WCb4UgDSqu7uWrfpvTNJJMpCBHMngTHdLNi/1phHGR/6/l7QCJTb
         t4uO1/XrkLwEUFcb//SGXKkvU7hHWiPv3x1Ck49twmM9Oaox8UIc5f7v4kcxNj5P9KT5
         ivR85gy9OTvsL5+J3qxjHAxg4s6SxaCi2VBBirvXDtqaiUhZVKjXpLRwU3EzWDMwcSPk
         2x5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9klrgRgQzMH/Mh4zVMtr35Xc00VoRE93eTNM0xjODpw=;
        b=JdqUDQg8A4rUhemosY7GlCG4nvSosfbaxX01Dvx45JFQ9Umbv8MkF+4F7oQ4qyJNN1
         nPRIWtFPFP29qWbe6aS0BKrek+2/9lqi75iJP6EOhvRv3ZScP4yV9rqJ0PMfi6buniTq
         njeozb4V0l3yz+Bw85A8zjrBlvMu+CLb8f/mySC9JJC6ujyX5KpG/3regGGNT2Acskad
         lg8SPZHD0zaYESbboL7X90wpZpdEf70gYmK88I8pHMLNzk/qcn9XP+Q/BV7NG+JWWdEi
         ob3oQ7VAzLh346wRZv3EttAO/eFW/+RUzx6xetx8fN48xfA09Kc1M5SVmFChHXhg5HiN
         2hRw==
X-Gm-Message-State: AOAM533yz8iPSVNgeoqthLh/2QIwk4NXj47/bZrp8AbnqGnsRt0duk55
        rHgGDkrGwqw2v1wUVscPpKTBMDbySGg1MQ==
X-Google-Smtp-Source: ABdhPJzB4oJDKRQZHCweZ+EtXKDONHoMFMnqD3Vj3D1Hb86aJfeCasy/sKQIoG//onTK1ZMGXJek3w==
X-Received: by 2002:a17:90a:5b0c:: with SMTP id o12mr26582711pji.11.1635605174681;
        Sat, 30 Oct 2021 07:46:14 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id nu3sm14039525pjb.25.2021.10.30.07.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 07:46:14 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH RFC bpf-next v1 1/6] bpf: Refactor bpf_check_mod_kfunc_call
Date:   Sat, 30 Oct 2021 20:16:04 +0530
Message-Id: <20211030144609.263572-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211030144609.263572-1-memxor@gmail.com>
References: <20211030144609.263572-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2122; h=from:subject; bh=hX+4it6R/f22Ld0QIZom7cug/b0ypZdRUOXGLjEiAe0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhfVoRNY2/zVNTTOkEZEoRxMmc2LuLeZBQ/iMAcEhy 3YLlki2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYX1aEQAKCRBM4MiGSL8RyubyD/ 9BtmSQypU9loSuKD7MDBo+iyvRmKC9tDcFrbgDRERYb2FK6LS84uZl6l4B6JGBSZ9YGb0pkkXq7L1Q N3h53sKFDwFFMN/CgcdGsyt0VIZDmn8Wj3MiWdf8uO+b1sFR+iZW2s4PhP89KWeYIBZM36X79omGj+ CW9hwvgNyOLWsMS0OkrHKsRvVh+AUAJBG3Px26/JvpRgYLtEcFuy+8vJI2lsppbqUs+4btQ/NkwNqV P1IH4NWyjNSvNrKyZqUtmuxzgTa+8Md966+6MPU6pqaTJcSojXKAJAEg4tKNaLDa3fEzdEdNLKm5NO HEaBjJybohthEJs+PggRSWg8eExOp/lh2A0qcEABGCpS5hqPphVaJ/XFafxDrWYv4eWKzJoqEyqkKx KWMe+SXGbSiBFm5zOogBrqMaBHWqPLL47mhEllhuOvndE77tFF1N+Aobu2ptiJ9IaRARXCr9b8bang M1JhnI5YRtuWtiQgHyc0yHhvAugCf9IoF95NjcoIA0Kw8bNJUrfv5Cc02LoeXlg57MPjcCq0W5T2RQ +BFwL6B8J6mifXlav9UOwQU3J5fpaHn38UsxStA8liUmlCRS9WrHVntHXCY/ecBVGqY9lCBvJh2TrK HffTg5plczNxurbpfT1fsei4z6nNXkn/CeJ0Bcub2CpASphmNn/bEUEkfbzg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Future commits adding more callbacks will implement the same pattern of
matching module owner of kfunc_btf_id_set, and then operating on data in
the struct.

Since all call sites in the verifier hold a reference to struct module
parameter 'owner', it is safe to release the mutex lock and still
reference the struct pointer. This can be consolidated in a common
helper given the reference is always held for owner module parameter.

Since removal from the list is dependent on module reference dropping to
zero, it is safe to assume it is registered as long the caller holds a
reference.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/btf.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index dbc3ad07e21b..be1082270455 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6371,22 +6371,35 @@ void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 }
 EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
 
-bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
-			      struct module *owner)
+/* Caller must hold reference to module 'owner' */
+struct kfunc_btf_id_set *__get_kfunc_btf_id_set(struct kfunc_btf_id_list *klist,
+						struct module *owner)
 {
-	struct kfunc_btf_id_set *s;
+	struct kfunc_btf_id_set *s, *ret = NULL;
 
 	if (!owner)
-		return false;
+		return NULL;
 	mutex_lock(&klist->mutex);
 	list_for_each_entry(s, &klist->list, list) {
-		if (s->owner == owner && btf_id_set_contains(s->set, kfunc_id)) {
-			mutex_unlock(&klist->mutex);
-			return true;
+		if (s->owner == owner) {
+			ret = s;
+			break;
 		}
 	}
 	mutex_unlock(&klist->mutex);
-	return false;
+	return ret;
+}
+
+bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	struct kfunc_btf_id_set *s;
+	bool ret = false;
+
+	s = __get_kfunc_btf_id_set(klist, owner);
+	if (s)
+		ret = btf_id_set_contains(s->set, kfunc_id);
+	return ret;
 }
 
 #endif
-- 
2.33.1

