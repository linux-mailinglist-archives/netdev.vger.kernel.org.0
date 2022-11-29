Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F023863BD2A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiK2Jn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiK2Jnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:43:55 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0CB1B7BF;
        Tue, 29 Nov 2022 01:43:54 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id y16so1379994wrm.2;
        Tue, 29 Nov 2022 01:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jeqcoxm8Nqrt6iXsC20iMe7fG7ZxHmkQeMwVwCCMT84=;
        b=GWW7tHdJvDC5InTvP1c5sP0a8wc8Way1HZPpGUGBCpWugXfUB2GIiU8Ulwn0OMpkNt
         XGsllGvOyjsDEOMlsUVogaXndIDfIvTn8F0AZulXhPLi3zPhgh2ZwtCdIYAnXDKU+rOB
         xUxoNXh1FPYdXE6iFRCVGrF228fnJ4drFmI0WsNyRo9OCIrhjgBgSqsyjSFL939at0If
         W4VUZZWT3WuWWQWKdC9BKzhMnDrfSdEO/5NA1Svn/QAual9023jdQpNX7KmYKzTFz68k
         /uH2MVR8+CfQrkVB3vhZIGWIOeJGq4x8WtzVlsRNMUZGscbY4ptm2qyFq+ZSeHHqVu0Z
         fbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jeqcoxm8Nqrt6iXsC20iMe7fG7ZxHmkQeMwVwCCMT84=;
        b=4SaA63auDv1H1cGO4N4ySsMAt0BmM/pRtF1SdnI/thyOGiUAnjwhLLJ0ontbovZwiU
         NMj9BuAtt5zKBZpfA5Cgyr0neRE0HdANKbtdwsx+V3vRrmPdrDxbGhdNIwuVCvubR7a+
         JB4odSS3XaFP5ot+ecXakKc1UNfZKkKNkVKqWYhxtQGaCdkDCY93FxdRKTeFFGsqml6q
         OrwiLMv9H6JV8FF3FTSrHdMxX57azqwTU4D+ufF/nT+VRMlJgPr7Xs4ZhqpxI6qwoAir
         38DxjSLwj0BpA4++XkkjhrXT0nY2/8dD6LtFiUkUW7LMfzGeLO+Be/5fosdj6alVFf87
         e7nw==
X-Gm-Message-State: ANoB5plHs9h6syBv/hBnxo2B3Pii88m8BJ9YiaIj4PHe13qbbFsZ0OQZ
        GjUOss0hma7mYc56bHRr/fb+IqyYwMy0sg==
X-Google-Smtp-Source: AA0mqf7rByhOtrn/GWz8pQ9uGBwVAoOecGpgcUjL5Re7DNs0UezI0GfXpbeuQaEoWHClzXkdXA25dA==
X-Received: by 2002:a5d:684f:0:b0:242:7a2:a014 with SMTP id o15-20020a5d684f000000b0024207a2a014mr11817514wrw.228.1669715032904;
        Tue, 29 Nov 2022 01:43:52 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c2-20020a05600c0a4200b003cfd4cf0761sm1484062wmq.1.2022.11.29.01.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 01:43:52 -0800 (PST)
Date:   Tue, 29 Nov 2022 12:43:47 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
Cc:     Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: microchip: sparx5: Fix error handling in
 vcap_show_admin()
Message-ID: <Y4XUUx9kzurBN+BV@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If vcap_dup_rule() fails that leads to an error pointer dereference
side the call to vcap_free_rule().  Also it only returns an error if the
very last call to vcap_read_rule() fails and it returns success for
other errors.

I've changed it to just stop printing after the first error and return
an error code.

Fixes: 3a7921560d2f ("net: microchip: sparx5: Add VCAP rule debugFS support for the VCAP API")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 .../ethernet/microchip/vcap/vcap_api_debugfs.c    | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index d9c7ca988b76..14fcb3d4ee85 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -639,17 +639,24 @@ static int vcap_show_admin(struct vcap_control *vctrl,
 	mutex_lock(&admin->lock);
 	list_for_each_entry(elem, &admin->rules, list) {
 		ri = vcap_dup_rule(elem);
-		if (IS_ERR(ri))
-			goto free_rule;
+		if (IS_ERR(ri)) {
+			ret = PTR_ERR(ri);
+			goto err_unlock;
+		}
 		/* Read data from VCAP */
 		ret = vcap_read_rule(ri);
 		if (ret)
-			goto free_rule;
+			goto err_free_rule;
 		out->prf(out->dst, "\n");
 		vcap_show_admin_rule(vctrl, admin, out, ri);
-free_rule:
 		vcap_free_rule((struct vcap_rule *)ri);
 	}
+	mutex_unlock(&admin->lock);
+	return 0;
+
+err_free_rule:
+	vcap_free_rule((struct vcap_rule *)ri);
+err_unlock:
 	mutex_unlock(&admin->lock);
 	return ret;
 }
-- 
2.35.1

