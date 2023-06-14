Return-Path: <netdev+bounces-10558-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D359272F0D3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 02:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21BC62812A5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 00:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BA3182;
	Wed, 14 Jun 2023 00:12:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280D8160
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 00:12:53 +0000 (UTC)
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FBA10EC;
	Tue, 13 Jun 2023 17:12:50 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-3408334f13bso3357965ab.3;
        Tue, 13 Jun 2023 17:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686701570; x=1689293570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fH6FmxGt/Oa/LI1in+ZqKzhAOMdBsI3JiFQigCkDIqc=;
        b=pYt2RDhwc1sIPeNdgwx+UjMvY5EHQ25+1nToJd1CC7SPfwXpYYeDp7rXg6Qpu5ZqG4
         x1VA9PKkrTPoobu997BcRhjMOBdrXNMzJgca8ddmkVD5Y9H0ZDfoAkPkibPK1PhRCXCs
         ZgjYPKMWVlZgfucyDBSJUkCB13636HGvCMOK1mTSx0AvP4FBZlyIsJTmBCerfVgbmjEf
         RsvbdmNrMPuO75dzAnEC4TuYCo/9rzLWc3IfQrs97y7QhREzNfrEHpa+yGlGC3hHgjh5
         MNtGnuTU/Kt7wh5C/A5uOXWEUr8+A0AUWrGszSehAiyn4v5dJoVEB6/itmey48XFGx/1
         KxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686701570; x=1689293570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fH6FmxGt/Oa/LI1in+ZqKzhAOMdBsI3JiFQigCkDIqc=;
        b=RI1XqNA5F3YQpy7jBVfM2HQktmJAYSAf+2GfEOCK66HyzMvRL8YdidvuOwswp2UhMY
         HFNYrIBaeO7cTVWZ1knO87nQTf+Mb44vHoOjDu/XYA19fW1Je2s32/fDIwcBw2t6BVv8
         oMb4y8t6aL0MIv9Fcmp3EvbnFkrbN6gACr6c7E68ZO/mO2sCiib8+OLRC4fTGAgFHQYZ
         XutxOG5apOmSJoAPMH5ljIH6MX1uJFnVG/jEU6uj9P+gbjW6hFAd+Q8+Aegjr8enjznc
         Jn/tGaqQysgcOqZwlXhZHOIZeLgD4DxVOOdore9vDgRZN1HO80D4/NwZtd9ZrGZ2jw5b
         NzLw==
X-Gm-Message-State: AC+VfDxkro6ljxnBIlGoLXoZ7KKCR7qyJHVzsM9rUnu7QHWrpHvu4aTh
	rFCWQfMwvyGaX7zlh2BCMxk=
X-Google-Smtp-Source: ACHHUZ7sy2N8NvzKYSG+QFV1WfIDNfXpxQy1JxKKM+nnIWZkV1mmK/3kZmx5oP6YJJh9DhyzOuU9yQ==
X-Received: by 2002:a92:d450:0:b0:33e:6378:d917 with SMTP id r16-20020a92d450000000b0033e6378d917mr10816259ilm.9.1686701569555;
        Tue, 13 Jun 2023 17:12:49 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (54.70.188.35.bc.googleusercontent.com. [35.188.70.54])
        by smtp.gmail.com with ESMTPSA id p10-20020a92c10a000000b0033b27117120sm4090039ile.13.2023.06.13.17.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 17:12:48 -0700 (PDT)
From: Azeem Shaikh <azeemshaikh38@gmail.com>
To: Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Kees Cook <keescook@chromium.org>
Cc: linux-hardening@vger.kernel.org,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	Neil Brown <neilb@suse.de>,
	Olga Kornievskaia <kolga@netapp.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH v2] SUNRPC: Remove strlcpy
Date: Wed, 14 Jun 2023 00:12:46 +0000
Message-ID: <20230614001246.538643-1-azeemshaikh38@gmail.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with sysfs_emit().

Direct replacement is safe here since the getter in kernel_params_ops
handles -errno return [3].

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89
[3] https://elixir.bootlin.com/linux/v6.4-rc6/source/include/linux/moduleparam.h#L52

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
---
 net/sunrpc/svc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index e6d4cec61e47..77326f163801 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -109,13 +109,13 @@ param_get_pool_mode(char *buf, const struct kernel_param *kp)
 	switch (*ip)
 	{
 	case SVC_POOL_AUTO:
-		return strlcpy(buf, "auto\n", 20);
+		return sysfs_emit(buf, "auto\n");
 	case SVC_POOL_GLOBAL:
-		return strlcpy(buf, "global\n", 20);
+		return sysfs_emit(buf, "global\n");
 	case SVC_POOL_PERCPU:
-		return strlcpy(buf, "percpu\n", 20);
+		return sysfs_emit(buf, "percpu\n");
 	case SVC_POOL_PERNODE:
-		return strlcpy(buf, "pernode\n", 20);
+		return sysfs_emit(buf, "pernode\n");
 	default:
 		return sprintf(buf, "%d\n", *ip);
 	}
-- 
2.41.0.162.gfafddb0af9-goog



