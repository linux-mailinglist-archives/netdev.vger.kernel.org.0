Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8585519423
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243327AbiEDBxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343551AbiEDBwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:52:34 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D415F443EF
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:48:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso19031pjj.2
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xT+5hQcq61BvthAgaoVmL+Iixyk9Kz6M9vS9nNgwYZE=;
        b=foxymm92zvgmK0ETJD/OF52F7nwlYYgJQ8oVdho7r9BzWtgtuSGYfDYK5MhNshEOoZ
         2wn0h0u9CPuexCbq87DKe80piTtxK5R6ZpJwSBGXRNF7rOHEPYzOtCIu9lKjSdiUbhe+
         r2DkWtw3UKhrg5w4I5ukgiJdOnG5MzFcAx9yc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xT+5hQcq61BvthAgaoVmL+Iixyk9Kz6M9vS9nNgwYZE=;
        b=TFmj8Ipb+7neR53w+hHxBNUoTdSMPhw/RQVUTi1JZ342V6A6mqmmJVPmUuQsKP30nm
         UzqtPbx/JoB2UTTdmFLB2FUX6zBdPbGOftqZfgw/KIOFmnJ4s/P/DhzxXi7mLLRuwSjF
         f7mijJu9a/tRD7rdZ1GJl1WBrIAuSrJ44pkftk43ehnHM9N/RXAV5b5AKQoFX8R107YG
         66eLubo0YTd/QLHpTsvAdI9cKB/JQ/LGonFiGg06COQ334LW+iQTlZWarIU3YkTEX2Hv
         tl8G9ScjNOI7sdUgy16gIg18/JYkRCP5cfSc2e9uH3ofyVTIE+O/yu0p//MoN3CYXvms
         gCmw==
X-Gm-Message-State: AOAM530u0B4d33vUfb8Zscev+B0WXSTCHDjZRUu4h9+Gtl77ubKlz/YS
        7py+Za+V6s9ZOg9ZxOeq3cJ2eQ==
X-Google-Smtp-Source: ABdhPJycw4EcllNGdcYu/hsnVxTNLEqPs1svu/l7N5hfPruKY3mWUaTfGlJqogJnY0zHUzGi9AG+AQ==
X-Received: by 2002:a17:90b:4d8f:b0:1db:d41d:9336 with SMTP id oj15-20020a17090b4d8f00b001dbd41d9336mr7719381pjb.29.1651628859970;
        Tue, 03 May 2022 18:47:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s11-20020a170902b18b00b0015e8d4eb258sm7004776plr.162.2022.05.03.18.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:39 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
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
        David Howells <dhowells@redhat.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>,
        Keith Packard <keithp@keithp.com>, keyrings@vger.kernel.org,
        kunit-dev@googlegroups.com,
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
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        llvm@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
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
Subject: [PATCH 08/32] iwlwifi: mvm: Use mem_to_flex_dup() with struct ieee80211_key_conf
Date:   Tue,  3 May 2022 18:44:17 -0700
Message-Id: <20220504014440.3697851-9-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2437; h=from:subject; bh=kqrSs6qCwh+Lec2OX97eOmuBYGTxbYZO/oveyYvsSyU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqCYob8Le101GWyzNPT8SUQLcWbnMdLaBLnNMKi PFuQ5FWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHaggAKCRCJcvTf3G3AJrrrD/ 41pLe3vLmy1DT131k402AnWkbvKKTeLHCfdZOZOBG/caJXqmnpOxwil6RAxg5u6hN5hKr+gqoQg3jM PjxMAKOnj4UigmA4/hMbFkpe2UAFQce0nHR1yDX9KirGdKMvnAq1KmeZTOvAK12ubsFuw1otFOoOY9 il9bAkoOcb67DGRv3WnjeBeJAIZesPeob+hkdIGXBLwjDM9HsKNWnS0CO4faN9H2UB5yHtan5AE3fY ejNDT+faux7HktJ5LMXGuFK8hNTMT6DzsBUJMh/VqnJUQfz4J8NZnt1C2fhjm2UKTMJJXaSL2VTIls +E869VhJZmwXhnjNOoXxgs2ypZPdZn7bJMJt9MVXQCWOJ/r5Z4HL//NjQwlMsxa5eN/OtY6fhuJmQa Kt081e3mYWawz+yHoGLyrxfgEVcaxPetNNZbtFWAguSAm+2kDAVJoYtbd1P/PeFNxjV9iclz5KMbsR vfwg2FoAJ4/UE7uv/e9hwMg874lDgZBVxecyw2BfPg0CFqa9KiQ4QmpYRs8HaRBhJQv/jDtfxWqnVh RhanF8E/YIf8Mwjneo+/nQykVNYJP+mnin2t2PXGGQTtyZfdgc4mogRxpnvnUcDOoGAndvfOm8tHL7 lnC6lEffqiIvIoLzddv1Yrb2IU0R/a/tFtHusn7zJ+WlS695vP3r1pDWMDUg==
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

Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 ++------
 include/net/mac80211.h                       | 4 ++--
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 406f0a50a5bf..23cade528dcf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -4108,7 +4108,7 @@ int iwl_mvm_add_pasn_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	int ret;
 	u16 queue;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct ieee80211_key_conf *keyconf;
+	struct ieee80211_key_conf *keyconf = NULL;
 
 	ret = iwl_mvm_allocate_int_sta(mvm, sta, 0,
 				       NL80211_IFTYPE_UNSPECIFIED,
@@ -4122,15 +4122,11 @@ int iwl_mvm_add_pasn_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		goto out;
 
-	keyconf = kzalloc(sizeof(*keyconf) + key_len, GFP_KERNEL);
-	if (!keyconf) {
+	if (mem_to_flex_dup(&keyconf, key, key_len, GFP_KERNEL)) {
 		ret = -ENOBUFS;
 		goto out;
 	}
-
 	keyconf->cipher = cipher;
-	memcpy(keyconf->key, key, key_len);
-	keyconf->keylen = key_len;
 
 	ret = iwl_mvm_send_sta_key(mvm, sta->sta_id, keyconf, false,
 				   0, NULL, 0, 0, true);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 75880fc70700..4abe52963a96 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1890,8 +1890,8 @@ struct ieee80211_key_conf {
 	u8 hw_key_idx;
 	s8 keyidx;
 	u16 flags;
-	u8 keylen;
-	u8 key[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(u8, keylen);
+	DECLARE_FLEX_ARRAY_ELEMENTS(u8, key);
 };
 
 #define IEEE80211_MAX_PN_LEN	16
-- 
2.32.0

