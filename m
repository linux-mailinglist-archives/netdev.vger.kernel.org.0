Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18956519459
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343769AbiEDBzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237510AbiEDByM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:54:12 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B484507C
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:48:49 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so22080pjm.1
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QnKXHDo7FoS6A9KJnTSD5KrVSbLLoX11tytSVaJywLg=;
        b=I1CnhqzTuM3VIMYb3RIInFBjlZ/Kx1CC2nOaz3zCzGfRz66UhpKktUjcUf1DB5iFHu
         gfyX0fG10mb1nZrZrHamW6VaM5Mxf2xxMafia1jAkPA8Cn5ohLG+uBumAmwOSdS3hISM
         a4JzdC7Fo3kAKeDLIrkA80T/ZAttaFcZAV7gI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QnKXHDo7FoS6A9KJnTSD5KrVSbLLoX11tytSVaJywLg=;
        b=MQR/xDcOV+3MzMZT+t0WpoCcNUtTdj4Bq+iFyndRxmlE/giIfMmNYCLoLSxzsZM0OF
         ig8Hd8k/f6tNy2plWQHGPvMEYXnbIqbQf0yg/3vS5SjyvE5FAfo3yNtf/cWIljjR/X8J
         6U2HcyGSN7lnvHP5+IYbv31zFnGjC5zbqGtcNdxK4te2dorZS93al7xT7B5TMXxao0My
         RQTjtyrQzhPvpFAfo3PFqkRpUzfTAVt5GWz0KrPUXOTQtnkc56X85wlkGm7UQWhHvqis
         ZAdaiZZdZ//GKMWZuMvnd5wzUna36/cpHe1ZsFXMHcsm3Dj4pjjEUVfYfrEwA3LiIiV8
         NIAg==
X-Gm-Message-State: AOAM5301gVlxCRGEQeyZI3rNP5mUqfB9CJ+dty+6xR9HNWA32mQe77UZ
        64tJPt1MfzcnMqoZGIgLuyDrRA==
X-Google-Smtp-Source: ABdhPJwfTAxyAJFgY1oitylR/Cmm8/uATlVgjIuVTmKRpsuPoxTiwANwfO0lQwCtHkRUnQW8wKiN6Q==
X-Received: by 2002:a17:90b:180d:b0:1dc:6c19:afd3 with SMTP id lw13-20020a17090b180d00b001dc6c19afd3mr7816856pjb.84.1651628867653;
        Tue, 03 May 2022 18:47:47 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x16-20020a1709027c1000b0015e8d4eb294sm6998452pll.222.2022.05.03.18.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:45 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
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
        Gregory Greenman <gregory.greenman@intel.com>,
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
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
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
        linux-arm-msm@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        llvm@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Marc Dionne <marc.dionne@auristor.com>,
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
Subject: [PATCH 23/32] Bluetooth: Use mem_to_flex_dup() with struct hci_op_configure_data_path
Date:   Tue,  3 May 2022 18:44:32 -0700
Message-Id: <20220504014440.3697851-24-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2134; h=from:subject; bh=wkblXI7lu8DePbBEkrWcF6TPvSCY+fsd3+cJcm8lUX8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqFhAG+9XZipSZhJ97uz0MVZAPm9ikLEayXBQca tSbucr2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHahQAKCRCJcvTf3G3AJuQgD/ 0RkSBHvTdsmM6uGZhl5vuzw4/t8A08lVzH+n9delDb7Snc4rClp98T7EnMak/i+Ne5YZV/OBum0+Ri 2Rso0KTZ7bgngl/ZWjToI21GZHTx0BvhmyN92pCyMRw8Q5g2WKeqI0pNWy8pO+tdkj+OZBI+kBTpzB DSCicDcFGgdZrS4ClZfIJ3ul5GuyH628GJbhzyj2IkHnbcVJTgVXEYTZfa9CUXIk5OxX0tgeN5hgKI YhvXiesuoZ4ZeGkGoBZgoWkyhWZg61taY7sMsK18JUdPuD2jO1Ziy7pPKMcmqr1QC1dxYBE2bshZ+7 3zm60sMtOhDVJc9pY0GGXTh83THBv9el1PLd8R1i03dHlFU+DYzQrq0OMEQ82DXkr9t89m7UmRpPNh UlFCgY75idmpPhVdKyd4ETvQlZtXZLEj7o98G9BByjCzXoXREee+09IWrA/DOZh7zHcuLHY4mwot7j j2JWq1nvZO0OVDBDjoUB6FMPShLAPZiPeGYn+67y9JU7lL1VFHN8sVsxBLq08bQ/HI32D+rAgZCCsn fVZ7tajhB6zkfYibttaD+E5RLSV+adLK+eXnFBqoQttbtNsKxuiZQF0dJZusj9dnKk/M5l3Ud90Uiq FXQeX6fOpiALefTfw5/ocOvMAHAP7Hz1WKgKO3NK7KYNbxbmS5+syYfDxdWQ==
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

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/bluetooth/hci.h | 4 ++--
 net/bluetooth/hci_request.c | 9 ++-------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 62a9bb022aed..7b398ef0b46d 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1321,8 +1321,8 @@ struct hci_rp_read_local_oob_ext_data {
 struct hci_op_configure_data_path {
 	__u8	direction;
 	__u8	data_path_id;
-	__u8	vnd_len;
-	__u8	vnd_data[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(__u8, vnd_len);
+	DECLARE_FLEX_ARRAY_ELEMENTS(__u8, vnd_data);
 } __packed;
 
 #define HCI_OP_READ_LOCAL_VERSION	0x1001
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index f4afe482e300..e29be3810b93 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -2435,19 +2435,14 @@ int hci_req_configure_datapath(struct hci_dev *hdev, struct bt_codec *codec)
 	if (err < 0)
 		goto error;
 
-	cmd = kzalloc(sizeof(*cmd) + vnd_len, GFP_KERNEL);
-	if (!cmd) {
-		err = -ENOMEM;
+	err = mem_to_flex_dup(&cmd, vnd_data, vnd_len, GFP_KERNEL);
+	if (err < 0)
 		goto error;
-	}
 
 	err = hdev->get_data_path_id(hdev, &cmd->data_path_id);
 	if (err < 0)
 		goto error;
 
-	cmd->vnd_len = vnd_len;
-	memcpy(cmd->vnd_data, vnd_data, vnd_len);
-
 	cmd->direction = 0x00;
 	hci_req_add(&req, HCI_CONFIGURE_DATA_PATH, sizeof(*cmd) + vnd_len, cmd);
 
-- 
2.32.0

