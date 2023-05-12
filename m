Return-Path: <netdev+bounces-2168-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E092D7009A4
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5BFD281B5F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A651E53C;
	Fri, 12 May 2023 13:58:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1BE12B74
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:58:58 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34114526F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:58:54 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-50bc4b88998so17592330a12.3
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1683899932; x=1686491932;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s/KFs/2B7m9MZiz0WLTsjGkrH/SBAUtK2lt6sIgh0XA=;
        b=j8Qzw0Lowk/cxZNFBonlAujktmiNhfOIJJVOfo680Kzh/5Av8OSb/w7fykhFtPAaT/
         dmtk7+vfzCj6deZEfAtwVWGYBTW2yYJxVxgSXGm0ps69GH93iTzYAjNtu2h3LqW0ULjb
         xs7947lefsb43rbw1Y4vZ/LJ/mzF59vj3Iesg7bs5UWAD2LVZRo7OY1cgpqZALLuiUve
         ZmExppHvF5NaXX5OxXybJxpYHpMEodMGrASNNDS4mX8zPuuxkGSC1BfAYREnuMWg9+Ci
         KUHcXu/yTSMzsA8TT35GrWpi2BL3W3BHIlM20Gly4oHhugLl/s3JpXn3/BJlZxWr4PN2
         HpiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683899932; x=1686491932;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s/KFs/2B7m9MZiz0WLTsjGkrH/SBAUtK2lt6sIgh0XA=;
        b=Fx7Rga+Hl48Q9gF3JygahJRV1aibiBDUJKKmAMHjytA8UB5tk7E6vxydYIFRcAKnaR
         hU+ag9SX+PrJVfts1R6XSf7Dp5abvdL0zMsD4kiu8ndqh4FzoIM2EQKxqnoU2Eelas+S
         ejRcumcqB+oXGbtkZ53v+q4dRywrl6p5Ml9QV3jN2WX8OqRei5AKGmL418MavkykpyXE
         9UEPZJnN1LQaWg33WJMeOkRUCaDBYUbDhlGfluT/bvrZ01DnaL6MMu1q3l3aGJGms/aI
         jlrt+FMuPkHdMSXPm8OLa/1N8eODZluJzAoi9jeRn9Sdo84uepivHSJWTha+ptq9tKPT
         utIQ==
X-Gm-Message-State: AC+VfDxgOEi50r3A2UTTgTE0B2epLDF8AOaw2v5JRJ6dMdv2dQK7mgeu
	Jf2RKt7BJBnlvuYn4QURIT6NPQ==
X-Google-Smtp-Source: ACHHUZ5gu9z6nIoI4TPFD7yn1Mzc9Dza0XUQXZZ4AyQHtno7HmWHZ9MneOnQYiLcjhLeVX+jeH0cfg==
X-Received: by 2002:a17:907:9686:b0:966:65ee:beb7 with SMTP id hd6-20020a170907968600b0096665eebeb7mr18927481ejc.71.1683899932573;
        Fri, 12 May 2023 06:58:52 -0700 (PDT)
Received: from [172.16.240.113] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id mc27-20020a170906eb5b00b00966330021e9sm5399061ejb.47.2023.05.12.06.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 06:58:52 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH v2 0/4] Add WCN3988 Bluetooth support for Fairphone 4
Date: Fri, 12 May 2023 15:58:22 +0200
Message-Id: <20230421-fp4-bluetooth-v2-0-3de840d5483e@fairphone.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAP5FXmQC/3WNQQ6CMBBFr2Jm7ZihJYKuvIdh0dbBToItaYFoC
 He3snf5XvL/WyFzEs5wPayQeJEsMRRQxwM4b8KTUR6FQZHSVKsK+7FGO8w8xTh5tPpsiNvGXlw
 LZWNNZrTJBOfLKszDUOSYuJf3Hrl3hb3kKabP3lyqn/13v1RISLUm1qZhMurWG0mjj4FPLr6g2
 7btC86hTjbDAAAA
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Marcel Holtmann <marcel@holtmann.org>, 
 Johan Hedberg <johan.hedberg@gmail.com>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 netdev@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support in the btqca/hci_qca driver for the WCN3988 and add it to
the sm7225 Fairphone 4 devicetree.

Devicetree patches go via Qualcomm tree, the rest via their respective
trees.

--
Previously with the RFC version I've had problems before with Bluetooth
scanning failing like the following:

  [bluetooth]# scan on
  Failed to start discovery: org.bluez.Error.InProgress

  [  202.371374] Bluetooth: hci0: Opcode 0x200b failed: -16

This appears to only happen with driver built-in (=y) when the supported
local commands list doesn't get updated in the Bluetooth core and
use_ext_scan() returning false. I'll try to submit this separately since
this now works well enough with =m. But in both cases (=y, =m) it's
behaving a bit weirdly before (re-)setting the MAC address with "sudo
btmgmt public-addr fo:oo:ba:ar"

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
Changes in v2:
- Add pinctrl & 'tlmm 64' irq to uart node
- Pick up tags
- Link to v1: https://lore.kernel.org/r/20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com

---
Luca Weiss (4):
      dt-bindings: net: qualcomm: Add WCN3988
      Bluetooth: btqca: Add WCN3988 support
      arm64: dts: qcom: sm6350: add uart1 node
      arm64: dts: qcom: sm7225-fairphone-fp4: Add Bluetooth

 .../bindings/net/bluetooth/qualcomm-bluetooth.yaml |   2 +
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |  63 +++++++++++++
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  | 103 +++++++++++++++++++++
 drivers/bluetooth/btqca.c                          |  13 ++-
 drivers/bluetooth/btqca.h                          |  12 ++-
 drivers/bluetooth/hci_qca.c                        |  12 +++
 6 files changed, 201 insertions(+), 4 deletions(-)
---
base-commit: f2fe50eb7ca6b7bc6c63745f5c26f7c6022fcd4a
change-id: 20230421-fp4-bluetooth-b36a0e87b9c8

Best regards,
-- 
Luca Weiss <luca.weiss@fairphone.com>


