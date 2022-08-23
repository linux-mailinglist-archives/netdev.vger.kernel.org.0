Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB9E59EC82
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiHWTgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiHWTga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:36:30 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6088B6E2EB
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 11:33:13 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u15so20472865ejt.6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 11:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=0bdho+csc6Tuo1C87iW8skDABmualo/hUQ+MFTjRvaU=;
        b=o2WhlcHO7H64Ch/xAmYv0RZkNJrpphjO5ju7OUs1Qm5mzudYwGluFckGoorputig83
         TkSPFbD574FcK/+ZO4uunxvrmCtNmXTBjsi+62iM9xmyNqeTN1VdrVkMXD6boNWGC4er
         W/yIwPGbr7M6c1UidrkcOldTXJYpBNMPVD6M27PaKJTdJE3N5jTe78S0wlWmZT+0T4xR
         BnwqSn1WNqTSmO+3yjwEI83ZEk2TR9ssouRwbzJEf1cRvBmVtaAMsDciJbm5eZ/mgx3n
         /b0as3q8B8ORYZcmCjxADcxfuFe+XCDXNZ9lnoSQgulzctZzWTPiYgHKnKkRT60YKY8H
         GHeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=0bdho+csc6Tuo1C87iW8skDABmualo/hUQ+MFTjRvaU=;
        b=hRaSIXQgxx9jLpwfW6XEB2FpCiZPlflno7JSKHYBHnAb+xIjdacNYm0BZvHOd7kM4O
         q4h7++HOUe4ck6myQENQfnTqI2rM3lGQGSe9omBH2cXIB4xawePt4YktfM/iAER2DONS
         ihh/fOaoWUhQ0aPlN0FlXjA2Dv3ckXfjZvuZTW9Lk+Rw3In3/AK1bo2or6Bn2t37+Gsg
         iZDdvHfTGx3mHwgQirWoE2dvnC+YVNZHnamnRpVovWaxdajSvXPv2NjTtZ63L9WdC0Z7
         RCh0mfCLOAVkgKfmFGk+oVt+HBx/3jvDdB2arfPIogFum0a+V2f/uARuqzg3wnrUpaxJ
         R+pA==
X-Gm-Message-State: ACgBeo0IOeIEKewlHhQ6sqAmNJnSJJlaOdh7DFMSp/XfqqLkWsYFCyzg
        ZA6bYMAF/cb7+JHXt7pSkuM=
X-Google-Smtp-Source: AA6agR7ylzaVr3K2nfrupyBQnTPRM6jHrU2dxhtOe4YdvxZTKTSakh/wGfKkZfE904Uo2+BSINB6qw==
X-Received: by 2002:a17:907:9484:b0:738:6f9f:6032 with SMTP id dm4-20020a170907948400b007386f9f6032mr574776ejc.602.1661279592092;
        Tue, 23 Aug 2022 11:33:12 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7758:1500:8528:d099:20f2:8fd6? (dynamic-2a01-0c22-7758-1500-8528-d099-20f2-8fd6.c22.pool.telefonica.de. [2a01:c22:7758:1500:8528:d099:20f2:8fd6])
        by smtp.googlemail.com with ESMTPSA id c5-20020a056402120500b00445e037345csm1812387edw.14.2022.08.23.11.33.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 11:33:11 -0700 (PDT)
Message-ID: <3bff9a7a-2353-3b37-3b6e-ebcae00f7816@gmail.com>
Date:   Tue, 23 Aug 2022 20:33:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next v3 0/5] r8169: remove support for few unused chip
 versions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a number of chip versions that apparently never made it to the
mass market. Detection of these chip versions has been disabled for
few kernel versions now and nobody complained. Therefore remove
support for these chip versions.

Heiner Kallweit (5):
  r8169: remove support for chip version 41
  r8169: remove support for chip versions 45 and 47
  r8169: remove support for chip version 49
  r8169: remove support for chip version 50
  r8169: remove support for chip version 60

v2:
- fix a typo in patch 3
v3:
- rebase patch 4

 drivers/net/ethernet/realtek/r8169.h          |  12 +-
 drivers/net/ethernet/realtek/r8169_main.c     | 124 ++---------------
 .../net/ethernet/realtek/r8169_phy_config.c   | 130 ------------------
 3 files changed, 18 insertions(+), 248 deletions(-)

-- 
2.37.2

