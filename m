Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E097614285
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKABB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKABBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:01:55 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0973E15FC0
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:01:54 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so17450195pjc.3
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YpQKJf0nCYhED+OJ4NgA+kcEUlPiaiAkjycoHn2haSw=;
        b=jyV40niyXaznH+xF2lsPZ3/7o3Z1xZe++umhAGYRU59whff/rMEr6MXl7gIwvw/Qhi
         J1gQmTIrdbe3IhUaociyBychF1i0NBZ+4lH5C/z//wTR8qVUzJA7R9gDxGGXjm6R7WEf
         KNh8SHeoC23dTTWCozLT3rwvUi1GuLvKpQwnmLDxkttdw1Xk4Tthk/umAjZGys/e7HlP
         d7SPemLpPc75vE/WHKwkSEVzmVTOntGuyrB2aQVZPn7N2K5h9qMA7hXB58ToVSLbg7o0
         4bcoPi7ikgXHV5U2lAmnQ3PzFIPiiBHSv0+qcsnH3cABoBtnRcOqi+2Xzm5lgVdoORmr
         CJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YpQKJf0nCYhED+OJ4NgA+kcEUlPiaiAkjycoHn2haSw=;
        b=pveYvDlRVCYB9Q4asDWQK0B9hn8yIZcwLR6zdwgbg6Kl/xQegQ1/RgrgMg3c2IbJfi
         ugqurWaN5KMNybBSE/dSqAEheH0uPlP7dnbCSdX0OsQ7L67uHSXpxpNjI4C0Cf/bikyc
         hgZ/rOFkPkORWQYrTvqGPyhAPkG/pGIKofyn/XmW2FLf3DmV0KeSldgw7x3+Nk9pCqN1
         7zVvyMfHwvHyMRnNPBfxkI/WZtZ937Ddw68e/uzLIGkFwyDsTvj8DrwSK62BmhtFvsW6
         BwrLCB4fAiwpeuTePakGvHkASTQAQdoWBxym0WRnUmJOqHoywXdQMyelo6pn9Zy0BoJ0
         Q9Sw==
X-Gm-Message-State: ACrzQf0eMglPDiEtV9J+TvKCjH0eVhyBa+m9GPl6pByVohGwvpIR7peq
        IGMMYCQk2bV7sjAHUZcMSOcKRg==
X-Google-Smtp-Source: AMsMyM40mGDjn/AE/VqMdr2FOW+ALCggd/wxgijHCfk9xkJ6ZuPgfLd2RVFKNgmsHS9AoMAJsO5AIw==
X-Received: by 2002:a17:90b:30c1:b0:213:a155:949c with SMTP id hi1-20020a17090b30c100b00213a155949cmr17879204pjb.76.1667264513481;
        Mon, 31 Oct 2022 18:01:53 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id a16-20020aa794b0000000b005627d995a36sm5221920pfl.44.2022.10.31.18.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 18:01:52 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v2 net-next 0/3] net: axienet: Use a DT property to configure frequency of the MDIO bus
Date:   Tue,  1 Nov 2022 09:01:44 +0800
Message-Id: <20221101010146.900008-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some FPGA platforms have to set frequency of the MDIO bus lower than 2.5
MHz. Thus, we use a DT property, which is "clock-frequency", to work
with it at boot time. The default 2.5 MHz would be set if the property
is not pressent. Also, factor out mdio enable/disable functions due to
the api change since 253761a0e61b7.

Changelog:
--- v2 ---
1. Use clock-frequency, as defined in mdio.yaml, to configure MDIO
   clock.
2. Only print out frequency if it is set to a non-standard value.
3. Reduce the scope of axienet_mdio_enable and remove
   axienet_mdio_disable because no one really uses it anymore.

Andy Chiu (2):
  net: axienet: Unexport mdio functions
  net: axienet: set mdio clock according to bus-frequency
  dt-bindings: describe the support of "clock-frequency" in mdio

 .../bindings/net/xilinx_axienet.txt           |  2 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  2 -
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 58 +++++++++++--------
 3 files changed, 35 insertions(+), 27 deletions(-)

-- 
2.36.0

