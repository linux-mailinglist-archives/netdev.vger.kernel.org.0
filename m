Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CFB5319E0
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiEWU1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiEWU0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:26:54 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD57B4161C;
        Mon, 23 May 2022 13:26:53 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id v14so13433668qtc.3;
        Mon, 23 May 2022 13:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=TneNowabt0wjfzcxvQYZmn9RWQW8O4p43QsS4BuL4Dc=;
        b=e1TDt/NRrfz4ypJXJ1NfIg0Ve5DTTcDwjCMlowV3pyQ0izpa5NAHmyd7TsQlZ+GHJs
         zdvFIsIY3zGT7Brd2Ua+3ox7t8IWK0JFr8HcUVZRfJ8SWFO9W57lwA3RuuF1zUYGxxeZ
         rRUjs3WiD5g9vQc8R+V/vDtmzlLSDY4sraJEioNKgOL0UQPtJaCYH7lFxWoMcrvfDeVo
         Cr/wdW3EymvdF3L23Fg8uT0+/8TRXzwW3U41Xru4ygGOWs6QfzSwnJA0RlvPSRX1xx6a
         /fssiRVo1N2uFsBDOR3WrYSFAC9nXgseXfKe03Gi7ckpMoAc1bvn3x/KiAnc5ifgZDtD
         ewKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=TneNowabt0wjfzcxvQYZmn9RWQW8O4p43QsS4BuL4Dc=;
        b=yICmhUtSL1xkukmTotgfb3ttECrbLYDtOhJolaL1TAcuYvmH/weKBcZquJsrqEDFag
         9NK9Yz05+j8cY6RprCDcyKFzi+xQxewmk1heitYs8hEXK+OoQQLjtL51O5Eu03ik1wpt
         S5fr6W7KE/hWTBaAzJAtDRHVKCnGp1zIzKV+gFIlU9wwif3/4Eenmy6QhBQ+2t1XBcc8
         YqjvIDhZWC5JAvBVQJ0GLhO7suaRFzqGQkGTTmOhvE9xS51aGAzBPg1juwVffn7pEBIn
         Plx9mh48mkOudMkN0bDIktf3owWNqpSekmYEc8cfge5C4SznEfZKQKORMYc9PAu34fqo
         kiOg==
X-Gm-Message-State: AOAM533Vfm89dEtZscZNZffkSAh21GTuwyExTy3j1iv1bwTQ0h48moEq
        KsEKUhzLqOI882q2ZGXjjE5Hq7O4kb9r3Q==
X-Google-Smtp-Source: ABdhPJx+GTqxMCPSbvVea/sP0y3LdvjzYe3CmSBpp3szH5MjEEVnyVxGQftCkBeg+wfP//3sAGjtOw==
X-Received: by 2002:ac8:5892:0:b0:2f9:1720:9e43 with SMTP id t18-20020ac85892000000b002f917209e43mr14664867qta.627.1653337612864;
        Mon, 23 May 2022 13:26:52 -0700 (PDT)
Received: from jup ([2607:fea8:e2e4:d600::6ece])
        by smtp.gmail.com with ESMTPSA id x11-20020a05620a0ecb00b006a33c895d25sm4865604qkm.21.2022.05.23.13.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 13:26:52 -0700 (PDT)
Date:   Mon, 23 May 2022 16:26:49 -0400
From:   Michael Mullin <masmullin@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpftool: mmaped fields missing map structure in generated
 skeletons
Message-ID: <20220523202649.6iiz4h2wf5ryx3w2@jup>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating a skeleton which has an mmaped map field, bpftool's
output is missing the map structure.  This causes a compile break when
the generated skeleton is compiled as the field belongs to the internal
struct maps, not directly to the obj.

Signed-off-by: Michael Mullin <masmullin@gmail.com>
---
 tools/bpf/bpftool/gen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index f158dc1c2149..b49293795ba0 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -853,7 +853,7 @@ codegen_maps_skeleton(struct bpf_object *obj, size_t map_cnt, bool mmaped)
 			i, bpf_map__name(map), i, ident);
 		/* memory-mapped internal maps */
 		if (mmaped && is_internal_mmapable_map(map, ident, sizeof(ident))) {
-			printf("\ts->maps[%zu].mmaped = (void **)&obj->%s;\n",
+			printf("\ts->maps[%zu].mmaped = (void **)&obj->maps.%s;\n",
 				i, ident);
 		}
 		i++;
-- 
2.36.1

