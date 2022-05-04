Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B7D51952E
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243458AbiEDCCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343815AbiEDCB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:01:58 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EA94506B
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:57:47 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so25872pjf.3
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rmxrp/UxOFb8piH92Vxf3rNJk8bX2cfzoG0Wa8qHsPs=;
        b=M/yQls1bpyaiOjU76efK5Yp3KeWPaKFU4zmgVp0hnDPVEvcbG0Yr2VZsk9GtUI6EW2
         P3x8PrWJUASQzTlrmV7uEWLEbManT0y+Zg+pt3XuYEBjyOBd/MkDra9+mVvndIuuMdNV
         ADaMqJRFecvzQ2p2BbgcShyTVJWmeZm5rse6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rmxrp/UxOFb8piH92Vxf3rNJk8bX2cfzoG0Wa8qHsPs=;
        b=36XMNY562PZ7jzFU/XY/iF34FKzDDt12ny4Wc2F1x3wzv3dL9q9vJCRMEjNj//JVRl
         bjM0WzwcgG5vdTYniyInY+p36BZTL1ZKiEuKaPZoLs0W4ii/I0Pq0jlnLvMiwN7cVyUZ
         eBy/XpHkmJ5oZnWJq1Vod5zPDBK/STgLjEeIagih9VjB5vztvlZ/L/JLhimKNyb2+TnT
         +g3XsdTLoJMJ0hpmv4WSXKdJl+lS0ei/lfg8+7y4eSksctnWjXDGlwT2S3dxE5Z7u0Fg
         m0dHCkCUjVM5ItbYl1ERGuRA6NvYvTwh9l7Rrgwmock01MAR6sYEbJbhuLLYThl3ZtBR
         rbfA==
X-Gm-Message-State: AOAM531PV51COwe/UJbn1nUP/bdLwFXrtYyiEP7gRBpW83owH/0amPEk
        IHBU/jwGwisA7QtcVro3++ircA==
X-Google-Smtp-Source: ABdhPJw5UH+zE7V//6n7buLSwyzvbe4dXHNIfzHZYUp5Gsqm2kqmkk896GY+p9QRLPq6Ee7dPP32pg==
X-Received: by 2002:a17:902:d1cd:b0:15d:1483:6ed6 with SMTP id g13-20020a170902d1cd00b0015d14836ed6mr20296811plb.58.1651629466374;
        Tue, 03 May 2022 18:57:46 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090311c300b0015e8d4eb2e9sm6671462plh.307.2022.05.03.18.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:57:45 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
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
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
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
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        llvm@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
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
Subject: [PATCH 32/32] esas2r: Use __mem_to_flex() with struct atto_ioctl
Date:   Tue,  3 May 2022 18:44:41 -0700
Message-Id: <20220504014440.3697851-33-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1840; h=from:subject; bh=wclXkCNzL8tWkFiLRsyBirHZGs1pS2ud8xMfF2Bbgys=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqIM8CXiBVoq1vvnq9rbFmtFRUsN4irOoYa4gS1 0IJEQ2KJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHaiAAKCRCJcvTf3G3AJgOdD/ sEBkA9QLnBKc64IqIq4YxEg4VNWAmPZGOznytqC/Owjod/71puJ/xtUz+R2WjO80ATXotNqfvtWe/d 9/yCjwl54Xp//OjYlRlQVLKBx2Q11FBqi4MBsooAiVirzGDDTHxmU1iuq6Wz2ZIdZlghDO60VBIerY f7y/tG7dD7LIfF4hLq69yeIQaG4gx8rz9gY1ntSTDKIZg+3A+cCuG7GHCLE4hzM9XcCNdcjNHkLLzM U6m0NaS7W7NFnR0mxnwloGXZVChfb884A/O/wC2lhgRNoxndIkrhF+x2NIhSvpQQmje9R235snuAfX mTZgHUaiYXSuSt8YrUbWAYgqP95oux1CHcGbFo6OSfvzri3R22Sizw6iJPckU4HcHFbxLD7v2eEMVp 3ECGtyv2+WAG63yJy/2YJm4mTGZKQM9ZC/lL6nR/U6EYIjrevoE7kTnSKMDTU+PS27rxgE+Rh1Hg9K ipwZmZh4bV/Xed50s1aJAocNChxua0lDl5jjP3QaZBpQGTlt8ls0YY8i1DswPFLAiSj88j/CGJOPOK +82q4/Et8Wn6QjhXmaRuef6bFcOHFRRdfpp1PZEOD91CPvnpq0Q9e/WXiAbsnkg/diZHdL5A9LVD0O L6xVqhkIsupraaLBcdxfoyPChtyfc0T1x/f55UeM/J7IkMaJAzAUEKGWn+Gg==
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
allocation, bounds checking, and copying. This requires adding the
flexible array explicitly.

Cc: Bradley Grove <linuxdrivers@attotech.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/esas2r/atioctl.h      |  1 +
 drivers/scsi/esas2r/esas2r_ioctl.c | 11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/esas2r/atioctl.h b/drivers/scsi/esas2r/atioctl.h
index ff2ad9b38575..dd3437412ffc 100644
--- a/drivers/scsi/esas2r/atioctl.h
+++ b/drivers/scsi/esas2r/atioctl.h
@@ -831,6 +831,7 @@ struct __packed atto_hba_trace {
 	u32 total_length;
 	u32 trace_mask;
 	u8 reserved2[48];
+	u8 contents[];
 };
 
 #define ATTO_FUNC_SCSI_PASS_THRU     0x04
diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 08f4e43c7d9e..9310b54b1575 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -947,11 +947,14 @@ static int hba_ioctl_callback(struct esas2r_adapter *a,
 					break;
 				}
 
-				memcpy(trc + 1,
-				       a->fw_coredump_buff + offset,
-				       len);
+				if (__mem_to_flex(hi, data.trace.contents,
+						  data_length,
+						  a->fw_coredump_buff + offset,
+						  len)) {
+					hi->status = ATTO_STS_INV_FUNC;
+					break;
+				}
 
-				hi->data_length = len;
 			} else if (trc->trace_func == ATTO_TRC_TF_RESET) {
 				memset(a->fw_coredump_buff, 0,
 				       ESAS2R_FWCOREDUMP_SZ);
-- 
2.32.0

