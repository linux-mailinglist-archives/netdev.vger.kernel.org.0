Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0708B57020F
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 14:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiGKMaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 08:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiGKMau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 08:30:50 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35AD4E606
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 05:30:46 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w12so5295068edd.13
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 05:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dinsH8nHmPQWYTrCJzENUxcxxna7aK91AI5aOp85vpU=;
        b=ZZIAPv5RFeBCz9t2F7BEVlo9BkdIK0n0zy2AuB6Tlo1bYfSE1reFdGQZ+WfyNc3PHX
         SYx5kQA7raM7YwqTMo6Epc/joM7/9Ho2XX9WaUHzr0NiALqPsPjKMeQP84DUZQk0tGYq
         nNtYqiELHdJBOO2MeQRNQxLY1Npgk/kvG2O0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dinsH8nHmPQWYTrCJzENUxcxxna7aK91AI5aOp85vpU=;
        b=5AhASwPydG6bsez+3UknwAjAwck7Xl3rwqJaysQ81CqDoEEgYZh8IIklrrhVtRhhAE
         XYY+Cp2rtZJYN7uut2tEf63zrPduonELdsXedJ4srQysQ5vyuzm+pDqlqyk4iLGnlL9v
         elEgFldJ7uz9n4OEuN8WUdRm8rIUDkLNepFuvAuXJOmL9+4cglY+Hz6b3uJ++wmYvej/
         3Phx1YSDcCCvU50TyscQ5BVUeTzAInf8NdSfEMTTNFWDLTJkH94HPch9IxF92+nDkBb0
         8yHVSu2/aefvkcDXT2QrWwPu1WvdH3LkSRmCSPwyOFcyDtJjTboTDc11EJqsgq9AVq97
         yxLA==
X-Gm-Message-State: AJIora8QpoXgtl/8zObOcQocVkutAINalAIITJk9vRq3XwjNGArWsmJG
        B6/ctp/5iJtWiwW2DcYEX0QnXA==
X-Google-Smtp-Source: AGRyM1tTEgBNgz9f8tfSSoW95yEmuofIldNpEiDEKPcaXPL6BBFJPbk/MXZsdlSD7LsDcAe2MIw+Sg==
X-Received: by 2002:a50:fb81:0:b0:43a:7975:c721 with SMTP id e1-20020a50fb81000000b0043a7975c721mr24785059edq.381.1657542645520;
        Mon, 11 Jul 2022 05:30:45 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090604c100b0072b16a57cdcsm738785eja.118.2022.07.11.05.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 05:30:44 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        van Spriel <arend@broadcom.com>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 0/2] wifi: brcmfmac: add DT property for trivial ccode mapping
Date:   Mon, 11 Jul 2022 14:30:02 +0200
Message-Id: <20220711123005.3055300-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Previous commits introduced a fallback mechanism for translating the
in-kernel ISO3166 country code to the in-firmware country code +
revision pair. The mechanism is dependent on the common chip core ID and
enabled only for a few specific chipsets.

But the in-firmware country code/revision is actually a function of the CLM
blob, not the chip core. Indeed, while it was reported that the fallback
mechanism causes regressions on a board with a chip identified by the
driver as BCM4359, we too have such a board with a BCM4359-identified
chip, and in our case we really do want to use this fallback mechanism.
Put another way, our CLM blob is using ISO3166 country codes, and the
revision is always 0.

Since this is evidently a property of the firmware, it would be nice to
be able to specify this in the device tree, since the driver has no
general mechanism for finding out based on the hardware type alone. This
series adds such a property: brcm,ccode-map-trivial.


Alvin Šipraga (2):
  dt-bindings: bcm4329-fmac: add optional brcm,ccode-map-trivial
  wifi: brcmfmac: support brcm,ccode-map-trivial DT property

 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml       | 10 ++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    |  3 +++
 .../net/wireless/broadcom/brcm80211/brcmfmac/common.h  |  2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c  |  6 ++++++
 4 files changed, 21 insertions(+)

-- 
2.37.0

