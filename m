Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8262BFD0E
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 00:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgKVXki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 18:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgKVXkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 18:40:37 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B176C0613CF;
        Sun, 22 Nov 2020 15:40:37 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id t22so3712541ljk.0;
        Sun, 22 Nov 2020 15:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XuAo/UqnPxZVWuecy1IVdiHQIVBnp2zSMQUaeU8pX2o=;
        b=YmrcZ1k98uk1IIlSpfg5SpUjGxrgZ2nE+V3WjuLs04+ki+RwmEMtAkFduvicay9Hyx
         ANAX0xFaa1Vhcp7FOnEYXwu3EjCeY+PuInVD/DsCHECHLAx5jYGdfokAX75t1zjN6m0B
         qZzNczzwzg78nQeQUXlCaaWLJZjdt5i7u69ct03ZWk3AqZFJBIDTQLyoLgctieEonCg1
         Zt0jtFuSAoEvfkcH2ex1SBNiZWILZ132cITJ85WnRbD9N4Hctahs0hig5ecjLsOZXIuA
         sgKUg4ZcL8y2zwdo1f3vlBR/LkcGzkjAMBiPJ+pgsVhieun7uAbe2wr5J+5UUVFX0AIJ
         iyNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XuAo/UqnPxZVWuecy1IVdiHQIVBnp2zSMQUaeU8pX2o=;
        b=QHv5oWb5siUTLa6DPBcPlpdHs0IrNWFry/4Ma6Cuwdkd2s28PKPnyA6hvS8ZSbsmtK
         eu3jp1wzcoFZLTqHtebVoaFRq1FQnp2XHFuLxhgN5nLDEG3yoCeIPb//rJj9oBxzSSf+
         7jxurxMPpbZoQOxl7bp+dYm+GPrLePffxrbXmKRFOgndYsEVPTfv4jXVXebplc99BUUK
         biHdph4E2gsQ5SdPc+DRqD0klu7x8yQC2eM7cAKFkpBckjzftiqroyUFTJKamTXkvQ8V
         a3X6keaN1El7Ir6M1BWbIk9vawb8fbpsuuPFcoF9Q2NIVvLvCfEtY0gqbsfnOCjXBVLT
         5kzQ==
X-Gm-Message-State: AOAM531PQ+2vKAESKCwmiNw+JHPFisrkUiWica2vOQ0AQxVzmLwNqbUj
        LKCsXYcHZ1jUXmTnuzq2hok=
X-Google-Smtp-Source: ABdhPJxaayS5JzC6KSLfoKjEFJbJm6NGMAZYA8JKMkI76lfJnql8tfRvcN4xoUEK27I70FElA7fK3A==
X-Received: by 2002:a2e:3310:: with SMTP id d16mr13004761ljc.103.1606088435928;
        Sun, 22 Nov 2020 15:40:35 -0800 (PST)
Received: from localhost.localdomain (h-158-174-22-6.NA.cust.bahnhof.se. [158.174.22.6])
        by smtp.gmail.com with ESMTPSA id q13sm1178173lfk.147.2020.11.22.15.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 15:40:35 -0800 (PST)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alex Elder <elder@kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH net-next 0/2] net: Constify static qmi structs
Date:   Mon, 23 Nov 2020 00:40:29 +0100
Message-Id: <20201122234031.33432-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constify a couple of static qmi_ops and qmi_msg_handler structs that are
never modified. 

Rikard Falkeborn (2):
  soc: qcom: ipa: Constify static qmi structs
  ath10k: Constify static qmi structs

 drivers/net/ipa/ipa_qmi.c             | 8 ++++----
 drivers/net/wireless/ath/ath10k/qmi.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.29.2

