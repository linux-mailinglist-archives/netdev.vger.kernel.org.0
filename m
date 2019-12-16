Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B961203DF
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 12:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfLPL1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 06:27:36 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40431 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbfLPL1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 06:27:36 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so6269358wmi.5;
        Mon, 16 Dec 2019 03:27:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ryVCsc54wbLULwv2yhD2TV0CloGuzqu6YbJ+JZg2+Bw=;
        b=B2wZKrqI53sfMzTn1xB9u+IAC8aAlprP6lKyoRjOFv+mAgWyzRZKUPdkllZEgZ+/W8
         DeMsCEl/DMhiZSPkcv1VniypQlOM9UmrDyedZqf89IgUuW2hPQHGAlyOGxMlbvYlrji4
         XXvKSSjJP7Ki8gOjCFpsJIilunbNGJ7docT2BrLClswLH/iSXu50XpBLxmBU9tEYhdca
         lp5M+q8iSvgo+TMjAwY826pkQhTBoLXXvdfH3jXLG6xIscRX90HVzvGVCGrpkpoEAE5U
         sNcIBDaWY/sXqexrw8PjlnSUCqysQ6CUfC1WWERdw5ZlmsYjkFZtzH2Ykuwp+zR1auUH
         MYvg==
X-Gm-Message-State: APjAAAX3GUeIydIzceIaETTjj4pl3zu7ShKIqin5zXTtG7KQhCVujwP+
        QrxclS4MioGEVz4FJn8F/Lp0rG5R40v0eQ==
X-Google-Smtp-Source: APXvYqz1BLiG5nMqNCmn72jiVmsafaibGobD6Zl88Jm7HLwR9e20MoalCryrVovJTR9RG8IWR3qSjg==
X-Received: by 2002:a05:600c:48a:: with SMTP id d10mr13816032wme.87.1576495654385;
        Mon, 16 Dec 2019 03:27:34 -0800 (PST)
Received: from Omicron ([217.76.31.1])
        by smtp.gmail.com with ESMTPSA id c17sm20883601wrr.87.2019.12.16.03.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 03:27:33 -0800 (PST)
Date:   Mon, 16 Dec 2019 12:27:33 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     bpf@vger.kernel.org
Cc:     paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next] bpftool: Fix compilation warning on shadowed
 variable
Message-ID: <20191216112733.GA28366@Omicron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ident variable has already been declared at the top of the function
and doesn't need to be re-declared.

Fixes: 985ead416df39 ("bpftool: Add skeleton codegen command")
Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
---
 tools/bpf/bpftool/gen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index a07c80429c7a..f70088b4c19b 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -388,7 +388,7 @@ static int do_skeleton(int argc, char **argv)
 		);
 		i = 0;
 		bpf_object__for_each_map(map, obj) {
-			const char *ident = get_map_ident(map);
+			ident = get_map_ident(map);
 
 			if (!ident)
 				continue;
-- 
2.24.0

