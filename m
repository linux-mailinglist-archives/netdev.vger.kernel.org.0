Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32EE22A397
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 11:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfEYJDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 05:03:04 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37326 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfEYJDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 05:03:04 -0400
Received: by mail-pl1-f196.google.com with SMTP id p15so5116587pll.4;
        Sat, 25 May 2019 02:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=kl+IMHLNpv3fsUuyOVQXvcaV+YnnSK1PnzziatRKSdU=;
        b=qzjThKc0msG/VNYue5lUg77weVA4wGXe2bh1oYAYamfsvjo5GpMpv93rBeFNrG5Fs/
         +gJQ4ki6p3oPEkV1eUCmfkxrgYFaWHUHGokZet3Afn+wNxlEDPaU6DCU/HAkZLLtlSn2
         SPXtegQSasgBgOuxgwUxdnyKdEG+UNB2jwl63Nj5Za9IYS1KyO0tAYSKe890D9RWsChp
         Loohhc8tYEpU0fGkdwvyTeDKzDOFkN2BoZwSn14p3mv4OPOdVJHFj+LdvYXN8cC+1gZO
         5Ia0Q6BcSdUSdtageD+8sfmy13YvUzCJpmhJP85YgpAeTht3zk3jHD/LzTjozsO3/XgF
         SGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=kl+IMHLNpv3fsUuyOVQXvcaV+YnnSK1PnzziatRKSdU=;
        b=Xf5r5S6JS7a2nZcXh4OTzXM7BoVVSfsk27/cviIUOiSF7xk33s0dcuR72tfW9KxIoR
         fYo9aJdFUmj8KzLf/B5EAbo0zZEhisBX/30DSeb2gvjkY+Va4CkRSZXvNLBa+TqDUO5y
         3XNIg+D3TejlnDTg06nXjs+R9Tt6QZrNCQM0QKc4z3haNHZpd1b2Q8ly63QwLpmTfcTM
         9+tULMyhq0Uw6exrqJQRDudE5vVkP6+2bsg8pdRR717ILxiYbq+D5Qkj2W4pr2gOVIJn
         fpqHXYh2sllGomydNpTp96j4+5AQZHFTB2ZGYQX7Vlq8DRRyc0va2UJUe3YRECsU5Gau
         19hQ==
X-Gm-Message-State: APjAAAUIAVI2lE/HSFPFf0zX5sP89RZwejfKR4Yr+2SPGzwx78IF90o+
        /60zq3C81o8u1BqD2gl43wk=
X-Google-Smtp-Source: APXvYqzYd/tKRFn7gIydvK7cJxKcMezbXxvGCtMKs9BRgyRt5msCyQuVptkMzaN/moG89XmdxGsGOA==
X-Received: by 2002:a17:902:a70f:: with SMTP id w15mr42169460plq.222.1558774983695;
        Sat, 25 May 2019 02:03:03 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.92.73])
        by smtp.gmail.com with ESMTPSA id 140sm9869603pfw.123.2019.05.25.02.02.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 02:03:03 -0700 (PDT)
Date:   Sat, 25 May 2019 14:32:57 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org
Subject: [PATCH] libbpf: fix warning PTR_ERR_OR_ZERO can be used
Message-ID: <20190525090257.GA12104@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix below warning reported by coccicheck

/tools/lib/bpf/libbpf.c:3461:1-3: WARNING: PTR_ERR_OR_ZERO can be used

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 tools/lib/bpf/libbpf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 197b574..33c25b6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3458,9 +3458,7 @@ bpf_object__find_map_by_offset(struct bpf_object *obj, size_t offset)
 
 long libbpf_get_error(const void *ptr)
 {
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
-	return 0;
+	return PTR_ERR_OR_ZERO(ptr);
 }
 
 int bpf_prog_load(const char *file, enum bpf_prog_type type,
-- 
2.7.4

