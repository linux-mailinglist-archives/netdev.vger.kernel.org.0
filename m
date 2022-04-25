Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCC650D76B
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240549AbiDYDRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbiDYDRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:17:22 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955275158E;
        Sun, 24 Apr 2022 20:14:20 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i62so120585pgd.6;
        Sun, 24 Apr 2022 20:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ISQrcSjnxBvSrG6lu02vspGdUWKWWM3Zb596oaYBot4=;
        b=I/pjKBjt08A8TmbT862cHoga5neTfWNsFcFjfFBel7jBMx3IaZMFbl/agRHw0eTefb
         C0SuioIO42NiAjhWappX8KG0T+TqKWEqoyg8g80Vy58pUC8v9ayQqNPtPpGdgUdOQ8v1
         9T8UUl7mvj8b5Sy3tE6+7T9YhqN0MLrPNGdzrnLStG7gcRJavNxK3GsqL3R9PE5dQuot
         7uPGQR6oo34gbTA5h9f90FKo4Lob1IywbJ6Tl4Kn16tv5iixmaWc4ay2SU49Mxw+mHj+
         abEZcrA4awdDRz+/m6OrG7vxsN05RaIi87ESO1FYwbucyOds/G5HBpUrVu83F7/G4DIZ
         s5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ISQrcSjnxBvSrG6lu02vspGdUWKWWM3Zb596oaYBot4=;
        b=698khvroCOSjYNl5go+iFyDNNNc7CLSpCsunblpr4ysNMtMncm0PDIswtQHhity/vJ
         4dJmqQQSmFe94twJmyKkrlWydQiJqsJ1IgiQBfG2qAzDM0Z5RRxFlb1nUsHNjMvG3OIV
         tdOeBuOHTyu07YVBeJNGJ5dT0invx2lO/dnmfnMbdo6n6JQ7lyiNT1szKjNWhDpdfHIt
         IZH6mnWwR7RfCT6TMKV/wc9a58+ipJGvSpHzCAEjlNX+2boagIAuAXCvSLcKKy+tZbnG
         T8K8XxtYlNuVYd63vymdnKcaTq0r0P4VTKzyWBAyXOfQmGjVZXv5n3LPogs73ZZcUmxl
         ZaJA==
X-Gm-Message-State: AOAM533S1bFs5/uHwLm2nAfdFvFxOjU2qEEXKGBPdH2/OFqca1vPtqmj
        zX8wSdZqUUFYlxaSD8VPcBg=
X-Google-Smtp-Source: ABdhPJwD6D4D1+4gmyKbVvsKQnu5cQQ7kXFTN5Y8i+xfBA+5seHDS+mojT+PnKzTvs4rIMgwlrwvRQ==
X-Received: by 2002:a65:4947:0:b0:3a4:dd71:be90 with SMTP id q7-20020a654947000000b003a4dd71be90mr13180673pgs.449.1650856460001;
        Sun, 24 Apr 2022 20:14:20 -0700 (PDT)
Received: from ethan-Latitude-7280.localdomain (125-228-239-174.hinet-ip.hinet.net. [125.228.239.174])
        by smtp.googlemail.com with ESMTPSA id y12-20020a17090a784c00b001c6bdafc995sm9229024pjl.3.2022.04.24.20.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 20:14:19 -0700 (PDT)
From:   Ethan Yang <ipis.yang@gmail.com>
X-Google-Original-From: Ethan Yang <etyang@sierrawireless.com>
To:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gchiang@sierrawireless.com, Ethan Yang <etyang@sierrawireless.com>
Subject: [PATCH] add support for Sierra Wireless EM7590 0xc081 composition.
Date:   Mon, 25 Apr 2022 11:14:11 +0800
Message-Id: <20220425031411.4030-1-etyang@sierrawireless.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support for Sierra Wireless EM7590 0xc081 composition.

Signed-off-by: Ethan Yang <etyang@sierrawireless.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 3353e761016d..fa220a13edb6 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1351,6 +1351,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1199, 0x907b, 8)},	/* Sierra Wireless EM74xx */
 	{QMI_QUIRK_SET_DTR(0x1199, 0x907b, 10)},/* Sierra Wireless EM74xx */
 	{QMI_QUIRK_SET_DTR(0x1199, 0x9091, 8)},	/* Sierra Wireless EM7565 */
+	{QMI_QUIRK_SET_DTR(0x1199, 0xc081, 8)},	/* Sierra Wireless EM7590 */
 	{QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},	/* Telekom Speedstick LTE II (Alcatel One Touch L100V LTE) */
 	{QMI_FIXED_INTF(0x1bbb, 0x0203, 2)},	/* Alcatel L800MA */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
-- 
2.17.1

