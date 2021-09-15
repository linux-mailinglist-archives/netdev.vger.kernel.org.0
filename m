Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A5040BF30
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhIOFLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhIOFL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 01:11:28 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12591C0613C1;
        Tue, 14 Sep 2021 22:10:10 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so4057779pjr.1;
        Tue, 14 Sep 2021 22:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=unBtJ4BgEaQ1q3x2SN/FO8ndnAfXWb2rghCo8mQpwXY=;
        b=D6P6oDA86AfKIfKnehKa+l5GHGTK6+EDuk0ntifX18se3+S0iBsrCvk0ZH2CmZcFC2
         UA/kSanaiPgw1PG9TSKaMiBrdEbDn6BqrA3VHJRdg65INrASSPE89guCGDJVuEhwBIOX
         nRrwhFyRHrIDakiTcsbjdSFmHeZKarsBmP1FofWlBDgKgugIrYBmGrC5PIgBdnZeTiay
         +5EGCe8hhQBrNt6JuYuODCHSYvkhh+0Pf8AYTR3cHZjXWQ+kaXE+vwK5zdhy8lQpFrih
         OzltjJxKwlo2QB8CwoKIg5DE5LKHuV7CQbTKQnlMkpWJrXlPFEEuwEU/h9fJwTSQFHXM
         gvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=unBtJ4BgEaQ1q3x2SN/FO8ndnAfXWb2rghCo8mQpwXY=;
        b=wqXTkg0MkG8/EXqwTlMdNxiH3qc27zvgv1HubLsLj8cYy9aDAXsshgbFC+SJQwbEh1
         q1MVa7BwIVhmHvbEw1eQyvTtbY0yN51lsP/pEqgpKbXXtVqWArPMELPuzu0Vi6lbBAEd
         34eDuHCG3qusp/gYclx761TRiPgUKgn2I56N3qtkWM2ehmS0mA25XCjTTgjef+aQKdzu
         AzZaaf1K2W3lJsBscumYPlsD3PJDnqM3x0/oqa/pXuVj9bI0ivJQWbunoSIF/iRZ6OPo
         T0DHCX5B7OwVFkJKEpkEYu14Owk4WNDTSkg+EcsLb2WljpIXsH+188ULlvFyFaEKFy1r
         2B4w==
X-Gm-Message-State: AOAM533mwAhv9Cm6tOFw9dIHSQzwHyCdgPVkLBclgFmEooSi0o4TiNF/
        1wU6ZB1+K5E0sMx1GSUlvPmnb71LNXGJkw==
X-Google-Smtp-Source: ABdhPJwsSwzOPidEO306IfobM6wvCAiBPGySaLKkPpjKlXuptz73EgZWBVDgHyczJI7shGLTleg3gg==
X-Received: by 2002:a17:90a:de16:: with SMTP id m22mr6382525pjv.54.1631682609454;
        Tue, 14 Sep 2021 22:10:09 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id m10sm2333891pjs.21.2021.09.14.22.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:10:09 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 07/10] libbpf: Support kernel module function calls
Date:   Wed, 15 Sep 2021 10:39:40 +0530
Message-Id: <20210915050943.679062-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915050943.679062-1-memxor@gmail.com>
References: <20210915050943.679062-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4871; h=from:subject; bh=1xbQtnet8ONbSdxejO5SOUckglIx2nhjKxRa61HQUGg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQX4c2Y0kuFgftjf+pdnO7/VUz/pKeQlitvNrGk+d 8NpVdoKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUF+HAAKCRBM4MiGSL8RyjD5EA CUQ/KD+pRbfgnc5hqIp562Rk07O3uyGI8RvH5fy8pA4B65k6O3YCVWuhmh5REQ7f+HVLYt+uIC0Xgg UAGpUST1GJUpxC//uNKaz/w6VJuQOtimge/EhWriaITb6S7yVfFs7EFouQ9ZuGzF/sX+RXo++IJ3Ew caWHD6vahNguziY3HHyc6478QInDyWt2cjurPz05sf7jSjp8Ar4dObIDS36bG/d2I2W3/F5pWZ/j5n QmL3yjmMwydQkNj7aKjeoqElTKW409C5y+X5mh+oKnN49uYYRadFoxsnHqs8LYpAE/dNxiONb+NGc1 dMqyEPGPSSG6qJ7yh8hm9DWNKGltBZkxga82/4sRaDyXCpKMvms7UyjeghVOhzeuRziTOXx0L+yEiR K4bWnseLMeiTod8dsiCJPStwZvWVC6sQDgpLOownXBYgWPg2u+8Tcl1KG9POdzMKiL+hLQ4Wj1Xx2y h3Qr0qYN7Jdge+1flOYwnb7K42AZ6/aesbPGD7GSSp6f9iGaZND1kZNwGqF4IKodX+CzWfV226jj35 ne8W3mJCt7hnSjZgV5ND6DOLcxm/oo60x3b7RY2iizaZV3+ouIfgKPTKcdqHlsxYYxLDNhIvNkwq6Y eavHVDtFdfC0s15xXDeASKl8I21Yn1NRo/ujNjV3auUn08i6N4wY7BGpcJ2A==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds libbpf support for kernel module function call support.
The fd_array parameter is used during BPF program load is used to pass
module BTFs referenced by the program. insn->off is set to index into
this array + 1, because insn->off as 0 is reserved for btf_vmlinux. The
kernel subtracts 1 from insn->off when indexing into env->fd_array.

We try to use existing insn->off for a module, since the kernel limits
the maximum distinct module BTFs for kfuncs to 256, and also because
index must never exceed the maximum allowed value that can fit in
insn->off (INT16_MAX). In the future, if kernel interprets signed offset
as unsigned for kfunc calls, this limit can be increased to UINT16_MAX.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf.c             |  1 +
 tools/lib/bpf/libbpf.c          | 56 +++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf_internal.h |  1 +
 3 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 2401fad090c5..7d1741ceaa32 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -264,6 +264,7 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 	attr.line_info_rec_size = load_attr->line_info_rec_size;
 	attr.line_info_cnt = load_attr->line_info_cnt;
 	attr.line_info = ptr_to_u64(load_attr->line_info);
+	attr.fd_array = ptr_to_u64(load_attr->fd_array);
 
 	if (load_attr->name)
 		memcpy(attr.prog_name, load_attr->name,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 62a43c408d73..accf2586fa76 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -420,6 +420,12 @@ struct extern_desc {
 
 			/* local btf_id of the ksym extern's type. */
 			__u32 type_id;
+			/* offset to be patched in for insn->off,
+			 * this is 0 for btf_vmlinux, and index + 1
+			 * for module BTF, where index is BTF index in
+			 * obj->fd_array
+			 */
+			__s16 offset;
 		} ksym;
 	};
 };
@@ -516,6 +522,10 @@ struct bpf_object {
 	void *priv;
 	bpf_object_clear_priv_t clear_priv;
 
+	int *fd_array;
+	size_t fd_cap_cnt;
+	int nr_fds;
+
 	char path[];
 };
 #define obj_elf_valid(o)	((o)->efile.elf)
@@ -5357,6 +5367,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
 			insn[0].imm = ext->ksym.kernel_btf_id;
+			insn[0].off = ext->ksym.offset;
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6151,6 +6162,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	}
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
+	load_attr.fd_array = prog->obj->fd_array;
 
 	if (prog->obj->gen_loader) {
 		bpf_gen__prog_load(prog->obj->gen_loader, &load_attr,
@@ -6760,9 +6772,44 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 	}
 
 	if (kern_btf != obj->btf_vmlinux) {
-		pr_warn("extern (func ksym) '%s': function in kernel module is not supported\n",
-			ext->name);
-		return -ENOTSUP;
+		int index = -1;
+
+		if (!obj->fd_array) {
+			obj->fd_array = calloc(8, sizeof(*obj->fd_array));
+			if (!obj->fd_array)
+				return -ENOMEM;
+			obj->fd_cap_cnt = 8;
+		}
+
+		for (int i = 0; i < obj->nr_fds; i++) {
+			if (obj->fd_array[i] == kern_btf_fd) {
+				index = i;
+				break;
+			}
+		}
+
+		if (index == -1) {
+			if (obj->nr_fds == obj->fd_cap_cnt) {
+				ret = libbpf_ensure_mem((void **)&obj->fd_array,
+							&obj->fd_cap_cnt, sizeof(int),
+							obj->fd_cap_cnt + 1);
+				if (ret)
+					return ret;
+			}
+
+			index = obj->nr_fds;
+			obj->fd_array[obj->nr_fds++] = kern_btf_fd;
+		}
+
+		if (index >= INT16_MAX) {
+			/* insn->off is s16 */
+			pr_warn("extern (func ksym) '%s': module btf fd index too big\n",
+				ext->name);
+			return -E2BIG;
+		}
+		ext->ksym.offset = index + 1;
+	} else {
+		ext->ksym.offset = 0;
 	}
 
 	kern_func = btf__type_by_id(kern_btf, kfunc_id);
@@ -6938,6 +6985,9 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 			err = bpf_gen__finish(obj->gen_loader);
 	}
 
+	/* clean up fd_array */
+	zfree(&obj->fd_array);
+
 	/* clean up module BTFs */
 	for (i = 0; i < obj->btf_module_cnt; i++) {
 		close(obj->btf_modules[i].fd);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index ceb0c98979bc..44b8f381b035 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -291,6 +291,7 @@ struct bpf_prog_load_params {
 	__u32 log_level;
 	char *log_buf;
 	size_t log_buf_sz;
+	int *fd_array;
 };
 
 int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
-- 
2.33.0

