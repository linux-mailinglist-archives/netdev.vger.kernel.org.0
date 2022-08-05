Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4840258AB5F
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 15:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiHENL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 09:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiHENLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 09:11:25 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D8D1260B;
        Fri,  5 Aug 2022 06:11:23 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id v128so2388967vsb.10;
        Fri, 05 Aug 2022 06:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=ym3pLpfuDkXTM3Cj60rcGQ6rpNB+5lNblhfX7X7z2TA=;
        b=kA8tkzwom8u9pwSJUsSg4poYv8Bvp31lLUJ6V+KIBGOglmyJkk4U7j3MMLl8nO51+c
         gqbCfp2DC9DwtolVKi2gI3gzAP8lH4WX/X7GLmPJskeF1fSZidwcMQ0F6hpYpiKz9xfq
         7oe8E/iZjEkSnEXnneSoH/mWAy4UGf+YVIt9A0wQyDxj5SNPTq1TkiMYwvrP8l1DGJTH
         AqZj8BqYR5i9TaoMYJTSLMYjFqnjaagRgJkqBQQWQy+C/sytwAQcCL1M26rMpq5PSaPr
         ZFXnhy5GzmMQCOQMIwLD6tFriNVRLbgPnobtxgfcCS2YQqg1XiqBid2qnc0tyJaVujDZ
         rQxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=ym3pLpfuDkXTM3Cj60rcGQ6rpNB+5lNblhfX7X7z2TA=;
        b=kRgOS5GmyiSQxzjDTwwDQeaAlyPbAWaOfZr7odU6YpNPaAzVcdS4coompW1eJhaSsd
         j7aJ136Xgx/QYwZlGkAh1SLoiVi81P0SSiNuo9cx0LdGFn36J2NbAlht8iwOg+G1e1BC
         IKRpWZmpAWUZfvEuE7RIbjviHyro0LOf9gEW+C94RV3f0x+FkMD6mlxYdZZWO9kaJuOA
         vnMTurTdUI2TsWmP9PE+pazTxOq3JFoGvdjMl3PvsYkFUMWGcR8njU1UHr5J2hiZ+6yZ
         D6vE4tAD8EPBfN4bQIb0a+Y5gtmV0ZNv+6TM2z1o1AWpWZ+3kIEF2IoYS5LgLUg36fKJ
         TBjg==
X-Gm-Message-State: ACgBeo3jzBrzzqudFnEKunrFXE4sDzihXg8H2CYcHvLMt54oR+Hh52mq
        HfiHIWrceQH+JVtBU9T8qPw=
X-Google-Smtp-Source: AA6agR4hwpM09pR8Y7WY/tr3CH6acIASkZKpxUN9MjbDKsFyRcJP8g/ZILE1meWQ9k8/2/HAPdUrqw==
X-Received: by 2002:a67:f595:0:b0:388:9591:abd4 with SMTP id i21-20020a67f595000000b003889591abd4mr375198vso.42.1659705082601;
        Fri, 05 Aug 2022 06:11:22 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:8fe6:28d:a348:5d75:1a38? ([2804:14c:71:8fe6:28d:a348:5d75:1a38])
        by smtp.gmail.com with ESMTPSA id 186-20020a1f17c3000000b003748499ee4esm3132501vkx.44.2022.08.05.06.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 06:11:21 -0700 (PDT)
Message-ID: <3da70b16068fdda4607b364cc8fb5c70579f778b.camel@gmail.com>
Subject: [revert PATCH net stable-tree] net: usb: ax88179_178a needs
 FLAG_SEND_ZLP
From:   Jose Alonso <joalonsof@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>
Date:   Fri, 05 Aug 2022 10:11:18 -0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please revert the commits.

The usage of FLAG_SEND_ZLP cause problems with other firmware/hardware
versions that have no issues.

The patch needs reworking because using FLAG_SEND_ZLP in this context is no=
t safe.

See:
https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@L=
inuxdev4-laptop/#118378

reported by:
Ronald Wahl <ronald.wahl@raritan.com>
https://bugzilla.kernel.org/show_bug.cgi?id=3D216327
https://bugs.archlinux.org/task/75491

Signed-off-by: Jose Alonso <joalonsof@gmail.com>

--

net: usb: ax88179_178a needs FLAG_SEND_ZLP
commit 36a15e1cb134c0395261ba1940762703f778438c

stable tree:
v4.9.x
commit 1b1cf809a7e606230ac7015bf90259ac74c414f3
v4.14.x
commit 631b2b75867cb67a9e8dfa865f5b4e2037b6dd8b
v4.19.x
commit c46cc6297180a889449ebf1724ff2fa231532b89
v5.4.x
commit f88d8c18822963d75a2b85d0ea6bb5d791dd95bf
v5.10.x
commit f7c1fc0dec97b882c105a0887bef585471cf1262
v5.15.x
commit b34229f4b212367196d787170b02be6f31802622
v5.18.x
commit f8bfce2177cdd64357dd57b8f43154f236d25f51

