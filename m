Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEA529D81B
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387601AbgJ1W3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387559AbgJ1W3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:29:18 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F092BC0613CF;
        Wed, 28 Oct 2020 15:29:17 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id j5so332339plk.7;
        Wed, 28 Oct 2020 15:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/grDH67JVTJbzB78YH3seFryBGYNizraZozn/nf+6Us=;
        b=rKawpu8XUrDQGUOwLJZyJ5NAVvk2yWXTuptvHGZ1kWdMopnYTMWgBbyitdooqfTmhb
         D21SRKedVxi6nU6ixe/md3R+qomdSR3u1LHGkV8o580v4HWjqBWBEwBjmnD5sHeFRQSP
         AD1Q4U5UMnri4qQnv0uKMxHvSVoD6Y+hgnq11llL8K/vE7zycjMmoOs4XmIP79SZ3Yzv
         8VQMOrCPdppJvZfbExomhHtT5QMp4x6qWqXy4rbd80XgjFgP1hqw9SPDh8jzSToTwGCV
         SMWX5Ff4HGZ5yjL+Lk/BRZgmKEgSbWRyPwo9C12Y+2e62+bHU1Kdc4pFnKCtr2tNXSNW
         1zrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/grDH67JVTJbzB78YH3seFryBGYNizraZozn/nf+6Us=;
        b=E1vNqn7iM4TUMrKHoJEJOKKeqyo6aHtbgsfCRmYxrVLyiAE/HXA3e1XnDR/gOyVge8
         C9s3Hrk4cgwKzPYr00eA9WWjGLGoPsld19U3CBUryZZMdo1d1MZ5+j+kiEgqSidwTiW4
         Br8FheWNUbZZTXszdaGF/zAHyLPx7ExlFNs4azVct0+Y6uVV2kAg/qFSPoltO+uqSYGw
         enMer9euPSbefgqt3+vDo8xrBHg9PvNeTvmxEEjQf8xq3RHEq1RqvG/uRt990GvF8733
         u1y8cXfGOIELpO+dStIZsypynqOSsCkNnrsE9RxowuhWKtK5SMPDqjlONr1h+m5fYZmu
         PdRw==
X-Gm-Message-State: AOAM532Sclx4kItJ38kmTy3a+Hh8g1gHCix07E/dI1msmBAdCvw1tsHu
        HnwK7y6XvOXN9DkiOYaCg8qkOrNDmxg=
X-Google-Smtp-Source: ABdhPJw5vqLI9XR8SEbflqMdSbBgr9A/rOdtv4W3XNIbsJgbESyXNC/P3istRFJfHaRfTk4CfUK5Pg==
X-Received: by 2002:a17:902:c395:b029:d3:f156:ef0c with SMTP id g21-20020a170902c395b02900d3f156ef0cmr7700983plg.55.1603891167354;
        Wed, 28 Oct 2020 06:19:27 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6d80:dec8:7340:3009])
        by smtp.gmail.com with ESMTPSA id r8sm7058032pgn.30.2020.10.28.06.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:19:26 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v2 0/4] net: hdlc_fr: Add support for any Ethertype
Date:   Wed, 28 Oct 2020 06:18:03 -0700
Message-Id: <20201028131807.3371-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this series is the last patch. The previous 3 patches
are just code clean-ups so that the last patch will not make the code too
messy. The patches must be applied in sequence.

The receiving code of this driver doesn't support arbitrary Ethertype
values. It only recognizes a few known Ethertypes when receiving and drops
skbs with other Ethertypes.

However, the standard document RFC 2427 allows Frame Relay to support any
Ethertype values. This series adds support for this.

Change from v1:
Small fix to the commit message of the second patch

Xie He (4):
  net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
  net: hdlc_fr: Change the use of "dev" in fr_rx to make the code
    cleaner
  net: hdlc_fr: Improve the initial check when we receive an skb
  net: hdlc_fr: Add support for any Ethertype

 drivers/net/wan/hdlc_fr.c | 119 +++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 46 deletions(-)

-- 
2.25.1

