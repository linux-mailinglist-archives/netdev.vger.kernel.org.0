Return-Path: <netdev+bounces-10274-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 124DB72D67C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 02:41:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11B761C20B0C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 00:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5F27E0;
	Tue, 13 Jun 2023 00:41:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C211C196
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:41:02 +0000 (UTC)
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194C818C;
	Mon, 12 Jun 2023 17:41:01 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-777b0cae9ecso313503839f.2;
        Mon, 12 Jun 2023 17:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686616860; x=1689208860;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2bxtso/h5hHMDA1OhTIwAdiVlb8X0frXvIU/x+6pApk=;
        b=J+yegLGQKyAIRViaiGY3XRX5DQMztkZdRhKVfuXd8sNk++I6tfM74xuZjf8cvuJc/f
         nA34+i+rxorP9WtjTAfkJh0/tgKxJ9Zg5IIwbT6zZSlgMpUmreOJVTZ0u+X+5qSnN6XK
         CNnPmEKtp22jsNOME8sbZQVm6N/Ajv7/Pq46xX4l+TwyNMdKAR1qbCiI+mxxx4OqNBVg
         TjDMcKXdMWhYZyPcfPeXRQGzH5KmP2bXpdn9TcB6ZmGOC+cWsmNYf44QMAqJDXeKwbLh
         GMvaYdZrmaH0l6rxqfY/JffS5VhymUjk7SzGX2nqSM1EUtx0qFbhhohymUBFGcCPF0Uu
         +iwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686616860; x=1689208860;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2bxtso/h5hHMDA1OhTIwAdiVlb8X0frXvIU/x+6pApk=;
        b=MEGwynq0EapjINOjwIt58dJ5QDE8+kvChg1RPgDkRR/FFb+bjjzNyGQBDm3ZC7OVTF
         +oLCXp+1KJ2tA6NU9sDnWyjxAf+wURLjOloVBYHdSKNtHkWR59zvdFw9SxQBNtX3G/Y1
         LynAitO2wFOk1YofvAT+yOC12aIIIotoCVrT5Pi74Vl4wKLTjGtP3a11HKCLD2HVuwL4
         iIxqzWN5ZdxD2MRfvMVeCDKwz2ZYIhs+pF1F/P5vrmKEZmLfvtsqnKGjWMRa96jjLO9M
         gZwnDytc/12+jSs8UAk+Ucg7hkAzl4vO35EWmZpHEOggaDhYw6KCNHO566V7aKURiQrc
         r2Sg==
X-Gm-Message-State: AC+VfDxyTv0oNs2Ycq64PQMoIn/a4PJPJb5XZMEyj/B7URDUczNJ0US2
	9orNRBera1Vciz1y7046tLW/xVTuXgxWXXRC
X-Google-Smtp-Source: ACHHUZ4sJ9cNsW+X5gxKQUccWr3cOT8YCi8nQlEpEY2cteV+dfHrNgR3cl0sDXTQyZ7sFrHfBAGvMQ==
X-Received: by 2002:a6b:e312:0:b0:774:9b75:b463 with SMTP id u18-20020a6be312000000b007749b75b463mr11558815ioc.7.1686616860370;
        Mon, 12 Jun 2023 17:41:00 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (54.70.188.35.bc.googleusercontent.com. [35.188.70.54])
        by smtp.gmail.com with ESMTPSA id k19-20020a02a713000000b0041ab38c1a4esm3119181jam.60.2023.06.12.17.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 17:40:59 -0700 (PDT)
From: Azeem Shaikh <azeemshaikh38@gmail.com>
To: Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
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
Subject: [PATCH] SUNRPC: Replace strlcpy with strscpy
Date: Tue, 13 Jun 2023 00:40:54 +0000
Message-ID: <20230613004054.3539554-1-azeemshaikh38@gmail.com>
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
strlcpy() here with strscpy().

Direct replacement is safe here since the getter in kernel_params_ops
handles -errorno return [3].

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89
[3] https://elixir.bootlin.com/linux/v6.4-rc6/source/include/linux/moduleparam.h#L52

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
---
 net/sunrpc/svc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index e6d4cec61e47..e5f379c4fdb3 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -109,13 +109,13 @@ param_get_pool_mode(char *buf, const struct kernel_param *kp)
 	switch (*ip)
 	{
 	case SVC_POOL_AUTO:
-		return strlcpy(buf, "auto\n", 20);
+		return strscpy(buf, "auto\n", 20);
 	case SVC_POOL_GLOBAL:
-		return strlcpy(buf, "global\n", 20);
+		return strscpy(buf, "global\n", 20);
 	case SVC_POOL_PERCPU:
-		return strlcpy(buf, "percpu\n", 20);
+		return strscpy(buf, "percpu\n", 20);
 	case SVC_POOL_PERNODE:
-		return strlcpy(buf, "pernode\n", 20);
+		return strscpy(buf, "pernode\n", 20);
 	default:
 		return sprintf(buf, "%d\n", *ip);
 	}
-- 
2.41.0.162.gfafddb0af9-goog



