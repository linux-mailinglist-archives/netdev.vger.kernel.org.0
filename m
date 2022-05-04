Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23312519514
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbiEDCCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343761AbiEDCB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:01:56 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A159144A0A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:57:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h12so157500plf.12
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=01xJZEdKekiitPaj8shKdCy94myHgVaNNGs/evnqdOM=;
        b=SvMNDAvPtTxF809bZoNNzl6o2LENxUqxJ8mipssp3LG3CBJ8QbgPBB5oXpfBBM0oF0
         mrxvm9m9xVoCbf+yK4esflyfRaDRIsoJWH6TXY5t/ov9rXMP+/iMpbnHqj0C62OZCoN6
         UGJtRe8MarqA1Hj1HXhO/p0X4vXAnV3Tj8zaI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=01xJZEdKekiitPaj8shKdCy94myHgVaNNGs/evnqdOM=;
        b=6OvareD8aa+XhvfgE3XGdbD0nTpJcgO3FRsNfFRn5dcc1tQut4MbvCrv0FtKHOV8g+
         Ka+R5ws6MvNrRRbTk5CAju6AQF1wU10Bm99X0U9v4NQE9gJPrpIbSEd0WDryHQB13La0
         c3mPw7WX3a0aQx9RAq6aQaBcJ/XS165vvBvkk5/zo5IePWrmv6+EMPBLIlt05ygTVWSD
         RQGQ4pDsKQvafwoASAWmbdApOKF5hlmfWJqdCdZDm4MqZRO3X3Jh7cppB+/O4w5TGrUt
         oVqC1vI1JhV0ET37OKZ77r1XiOzMOfvEgu6f2SarW7WkrfCyJ5MK984n/t4UlYZY8nQL
         hX7Q==
X-Gm-Message-State: AOAM533kxuXZtqFI2PQwBZ4l9TknezKfhkAEgJE2RfMm0/91XoZJ7Pi6
        O22Pu5CPXEdj0+KQN80tp267rQ==
X-Google-Smtp-Source: ABdhPJzqn2WxKVt7rWNzi+965SEqw7JTWEb+lKAff5WyHkMUjA5nI6RYV6fsBZImK2fATViZPprHkA==
X-Received: by 2002:a17:902:748b:b0:15c:3d1b:8a4d with SMTP id h11-20020a170902748b00b0015c3d1b8a4dmr19589131pll.85.1651629464893;
        Tue, 03 May 2022 18:57:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e7-20020a62ee07000000b0050dc7628187sm7109908pfi.97.2022.05.03.18.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:57:44 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Gow <davidgow@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        Keith Packard <keithp@keithp.com>, kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        llvm@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 27/32] KEYS: Use mem_to_flex_dup() with struct user_key_payload
Date:   Tue,  3 May 2022 18:44:36 -0700
Message-Id: <20220504014440.3697851-28-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2171; h=from:subject; bh=+EMqJweUKHRI+p140UR53z0ouyFfaCeLO7XO6/7BouU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqGhXIUX0opXFG+79dwIKeyeoTVzZjDz3s4gqRG WcoAdoCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHahgAKCRCJcvTf3G3AJpigD/ 9+hUDrqvhbexCJ+LI5xyfbONc0He6AfGv1OpoTuMyM/EDr+8Hlw69lTHvEd33pGAWnTcfLgvPFr5do SNqT7Ky9GohochNniXjI7VRAtZrFkRiG4130PztKwnvQ1ESHLdO+N8oQLoe0xNaVekFqVoLBQkU9ev NHp8YraJs7P1h9w8Pzngx6LtwE4pUvGsFmXmsBhmx5Uk1uiQ2UWzwtYPWYzdgEo1mTJ+BX1FT2/meR Eat9ZR2zS06PJ4uns7jc0qp4FerfBCuZHWMHvuzUrZLKj8YxmjyZPUn166vO9ypE2CX9eBtY3kFi3n EmX0Ryqm38lbokKGz+VyWMmMBepuljd3Kfm8eTAac9jztiqctLEmKqxMqXkQxGfDluj5udRd3fZOOR lag1NSmzJGGy19dHbynOZKZH+nGjFmGobp3C/7rBrswBDkGAbM9kHRt0+D9nPRbomIChQdinr+YNdi taMC+Zbtg73jiBg4SNGk9uXdxHdHcrvUozaxfZNwaBq19qR/CzNl695UzIFzTsoHUgCgp8UNwQOrIX 147/aQi6XAgsy4OrML7xnIyf5cn/Lol5s3J5+7HAqw9FmH4FhWg/atdWEZT71eREnRWKn+j7VQWUSS sH4Cq8R0Hlz39XjL9tHdhH6lg4wbDgAXnwYK6YZ7bEVdBr2fYMufUIc2hMWw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the work to perform bounds checking on all memcpy() uses,
replace the open-coded a deserialization of bytes out of memory into a
trailing flexible array by using a flex_array.h helper to perform the
allocation, bounds checking, and copying.

Cc: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: keyrings@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/keys/user-type.h     | 4 ++--
 security/keys/user_defined.c | 7 ++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/keys/user-type.h b/include/keys/user-type.h
index 386c31432789..4e67ff902a32 100644
--- a/include/keys/user-type.h
+++ b/include/keys/user-type.h
@@ -26,8 +26,8 @@
  */
 struct user_key_payload {
 	struct rcu_head	rcu;		/* RCU destructor */
-	unsigned short	datalen;	/* length of this data */
-	char		data[] __aligned(__alignof__(u64)); /* actual data */
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(unsigned short, datalen);
+	DECLARE_FLEX_ARRAY_ELEMENTS(char, data) __aligned(__alignof__(u64));
 };
 
 extern struct key_type key_type_user;
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 749e2a4dcb13..2fb84894cdaa 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -58,21 +58,18 @@ EXPORT_SYMBOL_GPL(key_type_logon);
  */
 int user_preparse(struct key_preparsed_payload *prep)
 {
-	struct user_key_payload *upayload;
+	struct user_key_payload *upayload = NULL;
 	size_t datalen = prep->datalen;
 
 	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		return -EINVAL;
 
-	upayload = kmalloc(sizeof(*upayload) + datalen, GFP_KERNEL);
-	if (!upayload)
+	if (mem_to_flex_dup(&upayload, prep->data, datalen, GFP_KERNEL))
 		return -ENOMEM;
 
 	/* attach the data */
 	prep->quotalen = datalen;
 	prep->payload.data[0] = upayload;
-	upayload->datalen = datalen;
-	memcpy(upayload->data, prep->data, datalen);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(user_preparse);
-- 
2.32.0

