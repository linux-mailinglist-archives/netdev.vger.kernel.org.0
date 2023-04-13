Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16DD6E00CE
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDLV3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjDLV3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:29:17 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5917A85;
        Wed, 12 Apr 2023 14:29:15 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id e3so4616585ljn.1;
        Wed, 12 Apr 2023 14:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681334954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eGq7QJNXqtJ7PzPn0R1ELOZRM5o1H528/AgWUxvVM7c=;
        b=qfZbZ0xDU4nCd1UZh6R+cquHg7T+Vyauj2Hd++h1yUOBLNsno6oJllhocRbsccAVGc
         5Tp5MEZhqiX6Anf63RoGpS+LBZYqHp93jewInhPcTD/dFwYlv7tLIVWqNP85TChsuxZp
         o76XK6qXpF24eq6F/UjfjrBpL1EhukgXwNt3Y8XuUeUA34tUdPsPbrq/O2BvcF2EXnBr
         FIkxqcLRotXo90V1e3q4A3zkf+lJFrQUgIm+uSGcMkztuwlO8GeNwURh0djEPRlDy0aJ
         7cm92srK8ZTROyUEbxde9jg+zldaI63j5Vu+laWkegIBxnccwJdyr5Wd5BPWM6Ey5xkd
         y8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681334954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eGq7QJNXqtJ7PzPn0R1ELOZRM5o1H528/AgWUxvVM7c=;
        b=D2vWd6J6nogwzkFhmRePxcXcfgK7XPxsDY6ry9zYIBzpEkvd3ZJcsIqTX+/UsohWbZ
         rXyAYPzHcP1W2rnJDiG85zFWEcWZze62Cv8ZJTYH6mmvW6rJoDGiMYYam7Au7yJX4Lsi
         0VgZwKSBTBAoLWRotjqW8dXH5Y/XkV4DOl9IvoxQ06aqLF0fFOTvQXsweM7WS+NqPwVQ
         dY+/f/P6oVZZFcp6+ye5h4yRKwLEmmJh5LgtBOjmxocMhm5umXghsJBzPAnigdO5atkx
         3n5YcjE5fQ0IR0NOR+Sj/U3qUa/UJJm+TSUd74V0fKYuqKRxVKjnRdkNEH3ML+PSIkKn
         X0HA==
X-Gm-Message-State: AAQBX9fCBJOAMSL/Qg6NXX2qAjVxcxX7PW9pA1GstuoFrQ13dL0YMbij
        w5yzBMut2MwQO43fuzURNJs=
X-Google-Smtp-Source: AKy350YDwqFFbA4dSl4h4Vrp5SMQGSWtO4Ii0QmlZqbsHrppQmNmaTQxJj50JSw6/cKMU0mcQj1+og==
X-Received: by 2002:a2e:8656:0:b0:2a7:7162:ae14 with SMTP id i22-20020a2e8656000000b002a77162ae14mr1167668ljj.21.1681334954057;
        Wed, 12 Apr 2023 14:29:14 -0700 (PDT)
Received: from localhost.localdomain (93-80-67-75.broadband.corbina.ru. [93.80.67.75])
        by smtp.googlemail.com with ESMTPSA id p14-20020a2e804e000000b002a7758b13c9sm1882481ljg.52.2023.04.12.14.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:29:13 -0700 (PDT)
From:   Ivan Mikhaylov <fr0st61te@gmail.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivan Mikhaylov <fr0st61te@gmail.com>
Subject: [PATCH 0/4] Refactoring for GMA command
Date:   Thu, 13 Apr 2023 00:29:01 +0000
Message-Id: <20230413002905.5513-1-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make one GMA function for all manufacturers, change ndo_set_mac_address
to dev_set_mac_address for notifiying net layer about MAC change which
ndo_set_mac_address doesn't do. 

Add mac-address-increment option for possibility to control MAC address
assignment on BMC via GMA command. 

Ivan Mikhaylov (4):
  net/ncsi: make one oem_gma function for all mfr id
  net/ncsi: change from ndo_set_mac_address to dev_set_mac_address
  net/ftgmac100: add mac-address-increment option for GMA command from
    NC-SI
  net/ncsi: add shift MAC address property

 .../devicetree/bindings/net/ftgmac100.txt     |   4 +
 net/ncsi/ncsi-rsp.c                           | 108 ++++++------------
 2 files changed, 41 insertions(+), 71 deletions(-)

-- 
2.40.0

