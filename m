Return-Path: <netdev+bounces-9504-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 593187297B8
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13AC12818C1
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77FF10958;
	Fri,  9 Jun 2023 11:04:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB12715486
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:04:53 +0000 (UTC)
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06B9210E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 04:04:50 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-30ad99fa586so1578353f8f.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 04:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686308689; x=1688900689;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hXj1WwjbvB9/pMgnlgZ+4nn9ohz+hnVKVJRXwh0hBUI=;
        b=RPTqyNKRXVwFr2f498zOolCmS/QaBuMCBH2XsgfgSo9Ec2d51VIgjo3ANXJgxMwpdy
         Tadmr/fFjfY88AUjE5l4BNyB9Xe2TrKJCurkEVvshdhe0p0UsbVjjjVpRc+X9ZnaHyPz
         EUc0uhqzAm3fnLZnt3VyYvQ3vQoBYuTLMaOC+jf5otjZ9a+/eI1ViZBOxwVEFLc1FneB
         /3WHyiqm6hU08L2TNYiX2OwZsKr/PenI5uboqCTjak90Fr7ZR11XkXacbsTgDJ+6c8rl
         5kN+LnvROdePOiYCzH0sqMgEyFP9JIzSnzx0I20oDeO5VZX2n5duKfN5I0cRiM0nfH5L
         NlTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686308689; x=1688900689;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hXj1WwjbvB9/pMgnlgZ+4nn9ohz+hnVKVJRXwh0hBUI=;
        b=S4pkcDAmaOLNEoVIazoDmDd1Why+TbcQ1kARnjCXRi3W5lUc7/3Yaspm3nWLVPHBjy
         AkH7AcmF72CE+ihrf4GYJYmFHtBpTs28D7ctJlG7D6cgSvaENhn0WUMbQBQxOJiTcWJl
         lyuF6yN9mD3qDHXb6hq4qLkCd8Hffu9rAiCT4SR1jU4cdmp1WLaeZ6YtF2AfydkA5Rob
         7/OJrDD+Kk52mueuaspQTETLbiTGfGfQTWv1cb3diibn0YTLcC1+4nLZcQKtW/aGLycW
         vtWXnCSClkjmmGZywpsVJWPaipmkDa1h/inRRxK2Qya7RkK/MHKu/gDA3oDgCrYPZszb
         f08Q==
X-Gm-Message-State: AC+VfDzlU5tLD7Hxi9m0+vA/ZHP/1tfEI6ugJ9y3ul3AEQ0ggwBHFjR5
	y0l4PtVYDvF2VmFw+5BLLLykbw==
X-Google-Smtp-Source: ACHHUZ62BlqjebHJfa/aFzpvqpty56hZMNVb2Jao/A4jGFspbi9nX77fCrW3yRU6jOw7a4mSysm05w==
X-Received: by 2002:a5d:67c9:0:b0:30a:d747:b357 with SMTP id n9-20020a5d67c9000000b0030ad747b357mr720722wrw.56.1686308689368;
        Fri, 09 Jun 2023 04:04:49 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id bl18-20020adfe252000000b0030adc30e9f1sm4147402wrb.68.2023.06.09.04.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 04:04:48 -0700 (PDT)
Date: Fri, 9 Jun 2023 14:04:43 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2 net] sctp: handle invalid error codes without calling
 BUG()
Message-ID: <4629fee1-4c9f-4930-a210-beb7921fa5b3@moroto.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The sctp_sf_eat_auth() function is supposed to return enum sctp_disposition
values but if the call to sctp_ulpevent_make_authkey() fails, it returns
-ENOMEM.

This results in calling BUG() inside the sctp_side_effects() function.
Calling BUG() is an over reaction and not helpful.  Call WARN_ON_ONCE()
instead.

This code predates git.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
This is just from reviewing the code and not tested.

To be honest, the WARN_ON_ONCE() stack trace is not very helpful either
because it wouldn't include sctp_sf_eat_auth().  It's the best I can
think of though.

 net/sctp/sm_sideeffect.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 7fbeb99d8d32..8c88045f26c6 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1250,7 +1250,10 @@ static int sctp_side_effects(enum sctp_event_type event_type,
 	default:
 		pr_err("impossible disposition %d in state %d, event_type %d, event_id %d\n",
 		       status, state, event_type, subtype.chunk);
-		BUG();
+		error = status;
+		if (error >= 0)
+			error = -EINVAL;
+		WARN_ON_ONCE(1);
 		break;
 	}
 
-- 
2.39.2


