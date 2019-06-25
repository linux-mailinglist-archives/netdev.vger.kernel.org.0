Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E06558C2
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfFYU1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:27:07 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45527 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727699AbfFYU1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:27:06 -0400
Received: by mail-lf1-f68.google.com with SMTP id u10so13557495lfm.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=0YDqvR98EjwNxyu4huLL3dsPvsKLYn4gdNkZG2oBOJs=;
        b=ogc+rYMA9sdqu9wSpp67RZ+Lj/mZ8Za7GmnoAmifPddTMTPznHlqTWRXxOSIh2hrbf
         rgHK9WvEXU4z1dSYPcm9UVJ7/GCISvrI1yYKNdeJF5LC6UkAwwCTve6aKweG6zD6g6ab
         75bC/zD8yeBlSOGg0GFPTx1lyvDcfhMkwsaCMkvpfgJMLv/p4JnSElcxyzR5NH5Dfrvq
         WzdTDN89NzXPDXz0CLIQHD0dkAEgaum1ymPsXFsH98xGEcdzZJr41VYDRgig6ZOMYyb/
         c3DLt28dh3CpqwUsPcJVVsGBIP87UA8vhN5TtjoScLG+XIIQN8aLoTMCxXD3nR9vBG8w
         Uicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0YDqvR98EjwNxyu4huLL3dsPvsKLYn4gdNkZG2oBOJs=;
        b=Ycf1olcRueBlNgeN8DDQCZpPkH/pEYBS9RP6pKVgwqW6gUK+udz1jir2eH/JBSfdnn
         oHag5T9mAs3GvCLCpDcaJS+CKxN0jKRJcTzLszltskI5A50f7tQJdMQKMCo1u8XozrJz
         nua/LFzydMcE/qAiWdgX3rJyd9twup8kiHDvo+JpjLyYqD88YVyZ5Q++qmTUl28hnhK4
         OhtRvcHKa/ul90qxLakmSQ80V8W2PWf0xuFG0iAnA3bcPHhjiXn0Rma+WNrw0UuLAb+J
         mryGXyfOJVC4RbsxBdZXpRBd8jT8psDm6rGYZSJBEFFKu9bF6JvtgsmIUIQFq5ETV3gt
         nsJg==
X-Gm-Message-State: APjAAAU4kIqRzsi9aDix6TI1sDDvCw/V4zljiw6B7rl1agrd8ZvGJw3E
        A/zHH7FlBkO1PVj2k9KZ2S5D0w==
X-Google-Smtp-Source: APXvYqzcMVnRXL4XO+yihowQtHyEaB/cdp9lUKVcAvdS1owjAyn8/YfQPThVzOdDdvjE3MgEOOP03w==
X-Received: by 2002:ac2:5337:: with SMTP id f23mr383567lfh.15.1561494424398;
        Tue, 25 Jun 2019 13:27:04 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id y10sm2070362lfb.28.2019.06.25.13.27.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 13:27:03 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next] libbpf: fix max() type mismatch for 32bit
Date:   Tue, 25 Jun 2019 23:27:00 +0300
Message-Id: <20190625202700.28030-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It fixes build error for 32bit caused by type mismatch
size_t/unsigned long.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 68f45a96769f..5186b7710430 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -778,7 +778,7 @@ static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
 	if (obj->nr_maps < obj->maps_cap)
 		return &obj->maps[obj->nr_maps++];
 
-	new_cap = max(4ul, obj->maps_cap * 3 / 2);
+	new_cap = max((size_t)4, obj->maps_cap * 3 / 2);
 	new_maps = realloc(obj->maps, new_cap * sizeof(*obj->maps));
 	if (!new_maps) {
 		pr_warning("alloc maps for object failed\n");
-- 
2.17.1

