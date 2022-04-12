Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0698E4FDF0E
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349109AbiDLMFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351756AbiDLMCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:43 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121C27CDD3;
        Tue, 12 Apr 2022 03:59:07 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id t11so9565082eju.13;
        Tue, 12 Apr 2022 03:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JrLemglUST4WORuuuukktAwV8TRd9yLyGflAl3xl1zc=;
        b=hsZJe29AqSg2O6WCZssdZkgs16ExQWUSSztvz7QZHXLQ1p8siy7CRb5NrHAnlQudSa
         MURp6EYnydmxOdzQ6sbb3XAHJX3SNQIfjcYKViYfDQ5QmxtefPJCKOTmiJts2fT+9j6Q
         Jy4srpYIm8L0XCW8Ky3AUuwglPJakfuSzkTYglJ4B/7A+OaAqBzmwLpZGrdMV78l0VX2
         yVG1uorw6FhE7xCMWszUOvSNn1avDwvFzpf1tPRgDLiF6ImwoVsaA82AcAzK11kLOUYi
         YAbYHfjp71mHXPzf29KRkPg1SHsJpZdQ94+Ekx7UMlzyouyB+WsObi805hv82S0KMAWp
         avDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JrLemglUST4WORuuuukktAwV8TRd9yLyGflAl3xl1zc=;
        b=5983VccSAUP6TPoMSfqevEyBdL1UBUfJuM3tj8CKZEXR4Y/r/fzy+C1k2gZJx8Kyb+
         MIDK+leIsj80BnmJFrF86EpKXapPGG5gExp1kE4LdCxSvG8YoC/mruvb+u7S9b+Wtdnp
         UJpEo2MjWrWA5NQNfDgrc8Guq70cn9gxMyjUOh8uAsmvJ/uD7kiTDhAuG7mdmn67nguS
         hZd6xuF7eCshgc8pfNhLnkhdMqpsGETuC5DW8oZET4hN1us494cOgqECfUhjAZyqz3rC
         Kiz1wSY23CacAZtLKZ7nJS0eX1AifMgNcF7bvTEYyK1SkuawkHCPCTTnA9f7spqpWSVl
         /cXg==
X-Gm-Message-State: AOAM532s0B+eKFj+xT2OBUG/3Rg7rCbI7eLsymT2/9hIPjP4sSqONZpW
        QS1a1io98ZP1Lmd1Jz+zERk=
X-Google-Smtp-Source: ABdhPJwc3b3Ll5+hkkpicYGoscoXx6T0nFGeyGRf8n6yjTeqLLhFcUZswCTy4e/3O+CL8gdNSejuOA==
X-Received: by 2002:a17:906:c14c:b0:6e8:6526:7647 with SMTP id dp12-20020a170906c14c00b006e865267647mr13282520ejc.257.1649761146033;
        Tue, 12 Apr 2022 03:59:06 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:59:05 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v2 11/18] qed: Remove usage of list iterator variable after the loop
Date:   Tue, 12 Apr 2022 12:58:23 +0200
Message-Id: <20220412105830.3495846-12-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412105830.3495846-1-jakobkoschel@gmail.com>
References: <20220412105830.3495846-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

Since "found" and "p_ent" need to be equal, "found" should be used
consistently to limit the scope of "p_ent" to the list traversal in
the future.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_spq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_spq.c b/drivers/net/ethernet/qlogic/qed/qed_spq.c
index d01b9245f811..cbaa2abed660 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_spq.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_spq.c
@@ -934,10 +934,10 @@ int qed_spq_completion(struct qed_hwfn *p_hwfn,
 		       u8 fw_return_code,
 		       union event_ring_data *p_data)
 {
+	struct qed_spq_entry	*found = NULL;
 	struct qed_spq		*p_spq;
-	struct qed_spq_entry	*p_ent = NULL;
+	struct qed_spq_entry	*p_ent;
 	struct qed_spq_entry	*tmp;
-	struct qed_spq_entry	*found = NULL;
 
 	if (!p_hwfn)
 		return -EINVAL;
@@ -980,7 +980,7 @@ int qed_spq_completion(struct qed_hwfn *p_hwfn,
 	DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
 		   "Complete EQE [echo %04x]: func %p cookie %p)\n",
 		   le16_to_cpu(echo),
-		   p_ent->comp_cb.function, p_ent->comp_cb.cookie);
+		   found->comp_cb.function, found->comp_cb.cookie);
 	if (found->comp_cb.function)
 		found->comp_cb.function(p_hwfn, found->comp_cb.cookie, p_data,
 					fw_return_code);
-- 
2.25.1

