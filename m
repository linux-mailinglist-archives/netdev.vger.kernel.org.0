Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2621568AD6B
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 00:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjBDXa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 18:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBDXa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 18:30:27 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990D7C148;
        Sat,  4 Feb 2023 15:30:26 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id lu11so24891023ejb.3;
        Sat, 04 Feb 2023 15:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=48zrL7dDekd40DOwd/bnDnGHKiZSAz1cWiLL1H5HRVk=;
        b=Toim7KqVELHZdsy6UfwGn1snV4wW+zIFBpdU1NpsrUYcRQ5YfI7pOodl2fCPrlhJr8
         H2jwij7U03WnAPaeXhS7sahjW1TGz/9QjRFqxgt4XhKkh44SIOCzGCrloIH40ka/VF7S
         rhar49JPz26lEtSnFEIMHccOYbdr31CnSrX65zkOeg/wjACZa+lgSg9UzmdQwbtcyxje
         cXxBOjz/nP6Jsd9b0J+TpqDWohky5HlN3WMC6q03dJWzmBF3K4ZvzMvHv34NM9v3BJdw
         CsYDnBvLHxKDNlQEvLlfe4Z4RAvvoh1GOtpsRT9ZZLKzmK6RPv/fLbZguJu1n26oj1uJ
         wVEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=48zrL7dDekd40DOwd/bnDnGHKiZSAz1cWiLL1H5HRVk=;
        b=akmwQgvarMd8Rw5TGouJRgHcnri1C42DbEyWkXgX4wOmgtDwTzjbVIZZ5oqShtyW2J
         uTDxtM4p2DZ5asIEmxU7C5jLaSZt0dcrNfflPpMk5r0TPpQR1yPPYUleiL6SyVg6FRBx
         z+ZO4QPJN+SwymzIZPj5RhGEEwykTe6VF3NOI3IS/R1M72+jsoDh/Jp1lUqOLci7+Zt0
         WKAaEdLWbv01lJ6bpl8HAFEYK0HTkSVo6aTTlido3Gm4idSa8pZkoJelwOgvwmf2UyO2
         0UQzj+MlVnbC07UbBPFiYILpeWi/Msy51T/RQwUuz+sLavZB6Cjgg7g8Lmsa3Y72KB4I
         T1oQ==
X-Gm-Message-State: AO0yUKWc6WiqqLX1nV9L0lxAxZxO5t6stJWMUMo6ktUYT8hqvgc5iQDe
        XTQeimuAvy/Ip/BuhS8PJxEYzXVETUQ=
X-Google-Smtp-Source: AK7set8TPW9qzjxVs8EfQtcw+B2AqS66LrxaaAxIrqe7rGr0/fqwTbrfZOwPLLHyFeimrVxjmz3IYw==
X-Received: by 2002:a17:906:cc8f:b0:889:d998:1576 with SMTP id oq15-20020a170906cc8f00b00889d9981576mr14880064ejb.66.1675553424888;
        Sat, 04 Feb 2023 15:30:24 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7777-cc00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7777:cc00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id v5-20020a1709061dc500b0084d4e9a13cbsm3386658ejh.221.2023.02.04.15.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 15:30:24 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 0/4] rtw88: four small code-cleanups and refactorings
Date:   Sun,  5 Feb 2023 00:29:57 +0100
Message-Id: <20230204233001.1511643-1-martin.blumenstingl@googlemail.com>
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

Hello,

this series consists of four small patches which clean up and refactor
existing code in preparation for SDIO support. Functionality is
supposed to stay the same with these changes.

The goal of the first two patches is to make it easier to understand
the allowed values in the queue by using enum rtw_tx_queue_type instead
of u8.

The third patch in this series moves the rtw_tx_queue_type code out of
pci.c so it can be re-used by SDIO (and also USB) HCIs.

The last patch is another small cleanup to improve readability of the
code by using (already existing) macros instead of magic BIT(n).


Changes since v1 at [0]:
- add "wifi" to the subject of all patches
- add Ping-Ke's Acked-by to patches 2 and 4 (thank you!)
- add const keyword in patch 1
- add array bounds checking in patch 3
- remove references to another series from the cover letter as it's
  not needed as a precondition / dependency anymore


[0] https://lore.kernel.org/netdev/20220114234825.110502-1-martin.blumenstingl@googlemail.com/


Martin Blumenstingl (4):
  wifi: rtw88: pci: Use enum type for rtw_hw_queue_mapping() and
    ac_to_hwq
  wifi: rtw88: pci: Change queue datatype to enum rtw_tx_queue_type
  wifi: rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
  wifi: rtw88: mac: Use existing macros in rtw_pwr_seq_parser()

 drivers/net/wireless/realtek/rtw88/mac.c |  4 +-
 drivers/net/wireless/realtek/rtw88/pci.c | 50 ++++++------------------
 drivers/net/wireless/realtek/rtw88/tx.c  | 41 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/tx.h  |  3 ++
 4 files changed, 57 insertions(+), 41 deletions(-)

-- 
2.39.1

