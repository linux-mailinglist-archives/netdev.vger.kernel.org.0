Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54A14FBE33
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346852AbiDKOEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346861AbiDKOES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:04:18 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5954332045;
        Mon, 11 Apr 2022 07:02:04 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id s18so8629535ejr.0;
        Mon, 11 Apr 2022 07:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ltzNq+8+sL93drV3kp6Vbdv371fmcOWq8QHYVYbzYY=;
        b=Rjg6jRXoiWAjWyrTf4H1Dm65aQd4qrbKKS77HmACr81qVoUBvYArBeSrVne4VH7Jtq
         bKO4AJdqM4yFJaaih2b0oGseGU5RGDuF6X+XCQnRti4ZN3cgAVDmA2SSBoGNZTH667H2
         NxRJpZIOPwUi6gcGsm7DVwYYlnorr3rG+zXjyPbSvOPbJYbLFS2kkkT6F/mNNa9xpF6c
         jNWkFyja3d1C2960uz6qQOClwsGotKat/MKXCBlRXAIADHq1YPqHKWQbsjOKzxMudCLh
         A3YJh0iSwKlfLPJ5Uzxjo+zG7gBDTDQYDuAaWGQbLcCGtoycXcrDGrH5TZ04gzBdspGu
         zBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ltzNq+8+sL93drV3kp6Vbdv371fmcOWq8QHYVYbzYY=;
        b=edgy6mrGqsZTzNUhv1588pmrQm5FrFdDbYu+Bvt5+irNtJ+gyOGQA1AuTVGebfKZZh
         wRx9Xx81gA3t5HALNbZF4Fzl3XGVzKR5sQZixraa8tciAAY2lINqD/UymJeJfXezcRbR
         rsI7piW4tPa/bNLHtEtuxiZS3mgW8XHHGBsFMzVUwXZRnb62szZsqWz1zEdlZASqu9/D
         c+XTjabDpp8LTxL61NJrhsrNEOWZTHxcEryCVb+fabjjJYBAzivEsmh+BW95dZyjMRwT
         lV1Yvc9GnAmofy30fG7/0GU4Jxjws10vGfl5zDM0vaNPoWSK0K0sGhPmqA/+82T/VYrs
         hzoQ==
X-Gm-Message-State: AOAM532B+tICEubFZSZxeA4oqaUiCB4xOVM3Dt3iSanTX3CN1nKPanga
        /qAqXdrq4DelpUhgGdhu91Q=
X-Google-Smtp-Source: ABdhPJwL97gq4P9B6hLA4eRtL4rnB7f/JEYAzDS+uv9gjZ08vzJOXtwCq605jvFRDQxdmVj+6nS/sw==
X-Received: by 2002:a17:907:a425:b0:6e8:74de:7823 with SMTP id sg37-20020a170907a42500b006e874de7823mr8718070ejc.635.1649685722795;
        Mon, 11 Apr 2022 07:02:02 -0700 (PDT)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id p24-20020a1709061b5800b006e88dfea127sm1604332ejg.3.2022.04.11.07.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 07:02:02 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net 1/1] net: usb: qmi_wwan: add Telit 0x1057 composition
Date:   Mon, 11 Apr 2022 15:59:43 +0200
Message-Id: <20220411135943.4067264-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the following Telit FN980 composition:

0x1057: tty, adb, rmnet, tty, tty, tty, tty, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
Hello Bjørn and all,

following the output of usb-devices:

T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=01 Dev#=  3 Spd=5000 MxCh= 0
D:  Ver= 3.20 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=1bc7 ProdID=1057 Rev=04.14
S:  Manufacturer=Telit Wireless Solutions
S:  Product=FN980m
S:  SerialNumber=3cbb984c
C:  #Ifs= 8 Cfg#= 1 Atr=80 MxPwr=896mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
I:  If#=0x1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x6 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x7 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option

Thanks,
Daniele
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 3353e761016d..60f1cae8aa5e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1358,6 +1358,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1057, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
-- 
2.32.0

