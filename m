Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBC823DD62
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbgHFRIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730044AbgHFRGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:06:15 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EB2C00214B
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 08:52:27 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id f18so9994345pgl.1
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 08:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DKaDTZahT68TPrt3y8j8xlCXfU2IoxIayJ09loOj8ZE=;
        b=JhX/CubUYC7aE5m4SNb/d0hwzJDwU2Bbm5eAj2Yyc5a4e+N8KWNhLqWC7VHcPVtjA/
         BDuIqKNdDwQ6tK4UA9tkY3+1yycjawE/a0qINJ872mqNwfgizOcn9j/wuo9lNHEVCYEa
         DcLb49hX1HQQnA4i7Ofv3IwjK5THQAPMnpUSVBC6hBzdsWHkq2VHC4KxoxGBj+bKXSLD
         EsGRZDnp5TrMqf/tGeKbMvq8vtFmjNXmTwsn8WzCsbkGCyKO49uGcuxXhp4lR6XOOreA
         BYOgbj65at0sIRqHUkxUTYZ7AHxsDVtV2Mgl2uud2hT4+MPIynP2K2HlnGh+zE6HBvU3
         6cnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DKaDTZahT68TPrt3y8j8xlCXfU2IoxIayJ09loOj8ZE=;
        b=iXu7PGCB6OlpyJDUQ8uJjus2sG6rlg+zxmDt8LYqsvsYxXg4avL0cctH+QK23fdqdR
         yGOkpTetpxMz7qzqJWgawmBDVBoES/5U1XKm1L0nmN8izoA4sfvrrsD7agzd83XhPLh6
         xZVKMtF/7LJ9rxXV1JpvkgRANlKJYLVoc4U0jMdBDFMs3zNTWpTSoD8AHPJlNZKXBhtu
         gDcOpwKN75PiMoXf7giVR30gwXJDmDtn3aDG+8N6VrdZJ6OzBaY3hAGJh0fj6L1oUd2j
         K1E/imCQec7MjZkWMHkYc/FeP4oXJV0EZF+WRKgOTLdI4yhDGpWBAqsG/T4vtWMTyRJD
         9vKw==
X-Gm-Message-State: AOAM5313uXuCN3AhIsdwoGoW1Jhgq1zHMKpvatWLeXxO1ObQXx1Hy2Pk
        4wuSJam6/dj5mjAbLDZG1BrQUoD+0P3om1GVA6U+tIvasstMd84mVYDYwibsi4vEpm5MdrVkp6/
        nY+9ZB/qwsfV0v4tUXX7JtbznEBLFda3Dyr6x6BwVzqM4K9rVoV4vDw==
X-Google-Smtp-Source: ABdhPJx+QUh0epEg1PjEslt5Re46VsWuyd9HeUPmxJfHw2mw+1qHTKNCTw2mORGskGzXsRnvkmWY1N8=
X-Received: by 2002:a17:90a:9516:: with SMTP id t22mr8184569pjo.134.1596729147206;
 Thu, 06 Aug 2020 08:52:27 -0700 (PDT)
Date:   Thu,  6 Aug 2020 08:52:25 -0700
Message-Id: <20200806155225.637202-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH bpf] bpf: add missing return to resolve_btfids
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

int sets_patch(struct object *obj) doesn't have a 'return 0' at the end.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/resolve_btfids/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 52d883325a23..4d9ecb975862 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -566,6 +566,7 @@ static int sets_patch(struct object *obj)
 
 		next = rb_next(next);
 	}
+	return 0;
 }
 
 static int symbols_patch(struct object *obj)
-- 
2.28.0.236.gb10cc79966-goog

