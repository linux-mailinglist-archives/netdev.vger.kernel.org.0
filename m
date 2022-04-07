Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9894B4F86A9
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346642AbiDGR4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiDGR4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:56:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A79AC6EEB
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 10:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649354054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CK9Z5mVDe4mgBGspYQzzn8gJDiHvz3qCsQ86FE3l+us=;
        b=WRXydbvXYfYpSEMZIYZNKUVjEfx//g2Sv5ZmeMayiluOaiTSHJYVzxCuqrCpmwtpr0So16
        Ey84+AzbccnLk5ftCHqoWqKelPdbXz3i8Gitdwcq9paSS+5G1yIW8FR6i4K8mVPj95b4Ph
        q5LreLl5+XgRFWdDWu1Xn2OUSRmn3wE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-BHlNPSMIOI2FwNq7CDl6ug-1; Thu, 07 Apr 2022 13:54:13 -0400
X-MC-Unique: BHlNPSMIOI2FwNq7CDl6ug-1
Received: by mail-pj1-f72.google.com with SMTP id mm2-20020a17090b358200b001bf529127dfso3927410pjb.6
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 10:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CK9Z5mVDe4mgBGspYQzzn8gJDiHvz3qCsQ86FE3l+us=;
        b=sdmOyNoklVmDVwKTsOrnTEgY/Th+9gzCQNABqt8WGKMtipV1olDT3LFPOaLm57KTE+
         1OlPMQ07cW5OAHet77sFsXUkfQP6GVWFHvY5M156HZ+iDWTMT0NppXye5nnI25y2BIHe
         qGnbnu3+UKJgaRj93XDjfhPKJflxZ0056qBb6kb8u75WgIKhK7PC9yyCGTrP0h2/cnwG
         p0QKy/8bW2OuO6TyEA/wJWTD87ekwRTlJ2fPQRbrfrpOd8xxl6pCUrVey2ndRJKC4dhu
         cmubcjt4Dps+YP67FFWJpuvJhSNiekbXnkV+rKwHtpp4e26uVfr07bmLyFld88fkesk7
         BCWg==
X-Gm-Message-State: AOAM532RyWX+3URzU9aY0tjU08bRRbmYsMASMhtr7+WYcQuFOrMrn2zQ
        0E5/5zpoOSC5NNgJfhJ6Iq7hxmr6UOCBb8Zvc94CLQ0+tVLTgEUzWDPs9aAbv+Ghv4OXCeaEq+s
        vKX2R0o1pLYlfCKtG
X-Received: by 2002:a65:6b92:0:b0:39c:c97b:1b57 with SMTP id d18-20020a656b92000000b0039cc97b1b57mr3129943pgw.517.1649354052364;
        Thu, 07 Apr 2022 10:54:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxY+f9QwoacEBY4kuGoqYuYwACBfLXX9MLBnkeSnGdArm5ggb+OlgU6GsrW0+ANYwvG2th5MA==
X-Received: by 2002:a65:6b92:0:b0:39c:c97b:1b57 with SMTP id d18-20020a656b92000000b0039cc97b1b57mr3129928pgw.517.1649354051960;
        Thu, 07 Apr 2022 10:54:11 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm23439873pfl.15.2022.04.07.10.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:54:11 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] rtw89: ser: add a break statement
Date:   Thu,  7 Apr 2022 13:53:49 -0400
Message-Id: <20220407175349.3053362-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The clang build fails with
ser.c:397:2: error: unannotated fall-through
  between switch labels [-Werror,-Wimplicit-fallthrough]
        default:
        ^
The case above the default does not have a break.
So add one.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/realtek/rtw89/ser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index 25d1df10f226..5aebd6839d29 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -394,6 +394,7 @@ static void ser_idle_st_hdl(struct rtw89_ser *ser, u8 evt)
 		break;
 	case SER_EV_STATE_OUT:
 		rtw89_hci_recovery_start(rtwdev);
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

