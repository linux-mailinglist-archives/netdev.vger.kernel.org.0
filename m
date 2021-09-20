Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190DA41169D
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240035AbhITORR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237353AbhITORL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:11 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC15C061760;
        Mon, 20 Sep 2021 07:15:44 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j14so4035805plx.4;
        Mon, 20 Sep 2021 07:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yU4+xx6iAwgsGxgz5Ht4AFD9WjITvbQsNdCqZ6ULtK4=;
        b=mBiyEuqmZ1PuLj+ohMREoKbQOdJNazYDg+Wwlus/vZKwldJEY1WOtlKOjTweVhb/sN
         dnd8ZHc0AiQ/E4PUa5a/2mTpHI/5a4pnzBTQ83hm8f8YMo3mhIcwNR5nAh5JXNWhB+6o
         uYmwYgy9jR5r9lW7q5/VVi7kiUIBLF+C+lwm2BjI1VgkgrDeiUlWenufy/EzatAqWsnl
         7hzDVicHNnhLjaWSuGrgwReJDMAIMDb/sQQl5gN52PBWhFSj41bONpuE9QtOyKjyZsKQ
         Cgg/k/2qvG55UT7SLQQMiJz2+rIfcX8qdRar0SnthlrNBih1LARrIrqpKOpZWef2HAcj
         aJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yU4+xx6iAwgsGxgz5Ht4AFD9WjITvbQsNdCqZ6ULtK4=;
        b=GWoFJ4WKtDCHG+uj0j2u/HUXhfYkN5DbxmSOQK3up9IkTtKs9DDGjzmLdavCBK81ji
         VtoEvcOn+8yZx3SW9Nx2zkqMCpWVn6elSzU+NXHQZ3uaay1B81TQ1mNINIPsEwt+TpBS
         Tk6FrGxxEwZpgao0c8RwniPpavrseN6F83cnYISlVmYNh6cy8kPGhuhVlWYUQymFywZf
         bybRUmjhtxbyDFbG3L8uN68d+VSoafA+Ni0BeK140JBNRlRfVQmW+ObXa3ev0ZNjKvyF
         Nm3fB3lfiF2f50v7/HEBfCw+69jduNcYHABEM0j26awf6dhZKZx/WLaRgiTRg/hRtB+G
         FsCA==
X-Gm-Message-State: AOAM531lxyNOglWVk89EKl5TGCCf7AjVPr5xpTJyvj5COqLgkVl9yPda
        kTWvWlEkGsGrlSu2kfMHX6WvaW3TrgoDuQ==
X-Google-Smtp-Source: ABdhPJy9JsUM1dybe+LpVnHynrp2ADztC/kCv3XoON7avqS3AZCCjSztYSdvdFvE9NQfzMR2e1nraA==
X-Received: by 2002:a17:902:9a06:b0:13c:86d8:ce0b with SMTP id v6-20020a1709029a0600b0013c86d8ce0bmr22942577plp.51.1632147344268;
        Mon, 20 Sep 2021 07:15:44 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id i7sm2648407pgd.54.2021.09.20.07.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:15:43 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 04/11] tools: Allow specifying base BTF file in resolve_btfids
Date:   Mon, 20 Sep 2021 19:45:19 +0530
Message-Id: <20210920141526.3940002-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
References: <20210920141526.3940002-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2098; h=from:subject; bh=kZhRM1Uo6vUje4gN/WsUjSsDNLJ5u0WuItuVyu5D9Zk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaEDhwehFEbRic2pkL2wCQ10r1eCg0KKIKoWVSG lKYtwOmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWhAAKCRBM4MiGSL8RyrcoD/ sEGqCUVCMkiIBpO2zDXStqilTry+NxWaawcwZ1ciAsYkq2RIUrCvWiQsSb8vXJ/8UPpzwmXNGIyqO4 XB5eTDWWlXOJBFwhQ0HS4StdJoFdKPMjUAOG2ALYgvTl+LE3VEBVTcyj2CGPFDZGiaul+KnxC6GZr2 EdbqiDV13ew+yDpb+zs+klVcn3Z3dq48VqyDTvsvbQfIZLWMzNOh2CmpbiH/fXaSgM7tfD1Fnq8fbw yFhTc3f6xUW5BW0wPggQmOQbW9KfAb0rcpqWx+sP0XKJANyVJOc/ImzAx82iUIptIxHhEiQxhE6n1U aCnNtJ2Ul8PYaqSSC+enIYEDbFpjurJS4rEHnalndEWAf4xclUKRUCoxt/kXp3NVQOiV3B3KlMYg0t DhOx2/+WSgMY4b91LBF2y2PEw1I2NnJRwDT4nZBT2cksx6byFlMh0CbkSRPwlOZOSO/kpDVaZQjFsv iP28qWHn/x2AEAKawp8DB/1rNmisC2AU3tF5hLYy6WjipnMtJ84YcATcw7V6oLRscwtJKIueFy1K3m pOtlFmC7vWaKTBLsxPIQSBx88LMO97ZWIYllDjvBCDeCtGwt0IYHKnyUVfis7BghCn24mb7obXDkPf 5QDEgW6Ib1FaXDYCpDRu4fxsDS1Gp7Gq/DCUI8qvV5XJxVTFTpkdM2Tk9UjQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commits allows specifying the base BTF for resolving btf id
lists/sets during link time in the resolve_btfids tool. The base BTF is
set to NULL if no path is passed. This allows resolving BTF ids for
module kernel objects.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/bpf/resolve_btfids/main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index de6365b53c9c..206e1120082f 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -89,6 +89,7 @@ struct btf_id {
 struct object {
 	const char *path;
 	const char *btf;
+	const char *base_btf_path;
 
 	struct {
 		int		 fd;
@@ -477,16 +478,27 @@ static int symbols_resolve(struct object *obj)
 	int nr_structs  = obj->nr_structs;
 	int nr_unions   = obj->nr_unions;
 	int nr_funcs    = obj->nr_funcs;
+	struct btf *base_btf = NULL;
 	int err, type_id;
 	struct btf *btf;
 	__u32 nr_types;
 
-	btf = btf__parse(obj->btf ?: obj->path, NULL);
+	if (obj->base_btf_path) {
+		base_btf = btf__parse(obj->base_btf_path, NULL);
+		err = libbpf_get_error(base_btf);
+		if (err) {
+			pr_err("FAILED: load base BTF from %s: %s\n",
+			       obj->base_btf_path, strerror(-err));
+			return -1;
+		}
+	}
+
+	btf = btf__parse_split(obj->btf ?: obj->path, base_btf);
 	err = libbpf_get_error(btf);
 	if (err) {
 		pr_err("FAILED: load BTF from %s: %s\n",
 			obj->btf ?: obj->path, strerror(-err));
-		return -1;
+		goto out;
 	}
 
 	err = -1;
@@ -545,6 +557,7 @@ static int symbols_resolve(struct object *obj)
 
 	err = 0;
 out:
+	btf__free(base_btf);
 	btf__free(btf);
 	return err;
 }
@@ -697,6 +710,8 @@ int main(int argc, const char **argv)
 			   "BTF data"),
 		OPT_BOOLEAN(0, "no-fail", &no_fail,
 			   "do not fail if " BTF_IDS_SECTION " section is not found"),
+		OPT_STRING('s', "base-btf", &obj.base_btf_path, "file",
+			   "path of file providing base BTF data"),
 		OPT_END()
 	};
 	int err = -1;
-- 
2.33.0

