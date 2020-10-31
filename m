Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202A82A1221
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgJaAtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJaAtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:49:24 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AC6C0613D5;
        Fri, 30 Oct 2020 17:49:24 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t6so3792967plq.11;
        Fri, 30 Oct 2020 17:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8friKqLeurKp8Qqgfoy3djOL/bPCrMJ3ZwWvjKE6BDg=;
        b=YLCUHd/1BgHbf+elXoAw+z8rArE5XARcatBMCPpGYMUispipMw3tTp/1H8lcHLyKZI
         nlrLh8VrnxSa+21M+Cd/IhbA3Vise3i3bCjaNuuEQnHHdJ+CB0SgX/ai3ah8MPWj4baF
         Zhl11qZQ1Y8F55Na+pMDeddizok7hC4jakM1yFV4ROs6mGvkVYHYcJZfFPvWUwDJhv3F
         dFKub2CGenFeFaViNpAy+CEOXQ+JaWVt3TVqYt9Ypjg1gWybltK6jHAaKDEbRulnvtAh
         UHrqDVG9TNHrvIzB8qbPYxzskDxNkwNEreKjZLyY3llzusHsTHGPm7+nVBDd6gibl0CK
         9SJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8friKqLeurKp8Qqgfoy3djOL/bPCrMJ3ZwWvjKE6BDg=;
        b=LPSexcuQRQpB45RIz3W75gw1xwRW8ZZ6Xkuk43qKJEX234T8duKRw37hA/vZ3+l1wC
         dwEZEWJQohrIQcufMgVgpYN/NoJp++nQBogGeLKj0dxePwjutDdkhbYVlKris3qb0CSW
         w0AEO1xOMlAmnpDBgaXtCXD2DQNOdkMk967iJ84M06PHTQgCKAVTG7fFXTwP01Y4g/F8
         FOycmRtetWg8KCHa88owvMA1gnjqUNqfg0W6ubFZxrpTKSCcZ+d5MPDBAjWvA4HfkB4g
         dV295prZUunFoTP8JPev7tpgJgtF/5uF3+hQoopYeRELiOY0OdmzJ7dQErgZRuKffP3H
         i51w==
X-Gm-Message-State: AOAM530lruEdalHp41RpTIRC7ouRLzY/8BHpiUPc98r4P9Wdf6AKp2WO
        /pw9Lo39sghiTs5C4QRzSLI=
X-Google-Smtp-Source: ABdhPJzI1oAJcuyoZOHpW1Bsr5LP/l94iHYKlt7uWdjqX9P4a0aeLKkAH5iraXDPc8bbGFqTTcDpfA==
X-Received: by 2002:a17:90a:4bcf:: with SMTP id u15mr5550560pjl.142.1604105363717;
        Fri, 30 Oct 2020 17:49:23 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:48fd:1408:262f:a64b])
        by smtp.gmail.com with ESMTPSA id w10sm4466634pjy.57.2020.10.30.17.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:49:23 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v6 0/5] net: hdlc_fr: Improve fr_rx and add support for any Ethertype
Date:   Fri, 30 Oct 2020 17:49:13 -0700
Message-Id: <20201031004918.463475-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this series is the last patch. The previous 4 patches
are just code clean-ups so that the last patch will not make the code too
messy. The patches must be applied in sequence.

The receiving code of this driver doesn't support arbitrary Ethertype
values. It only recognizes a few known Ethertypes when receiving and drops
skbs with other Ethertypes.

However, the standard document RFC 2427 allows Frame Relay to support any
Ethertype values. This series adds support for this.

Change from v5:
Small fix to the commit messages.

Change from v4:
Drop the change related to stats.rx_dropped from the 1st patch.
Switch the 3rd and 4th patch.
Improve the commit message of the 4th patch by stating why only a 2-byte
address field is accepted.

Change from v3:
Split the last patch into 2 patches.
Improve the commit message of the 1st patch to explicitly state that the
stats.rx_dropped count is also increased after "goto rx_error".

Change from v2:
Small fix to the commit messages.

Change from v1:
Small fix to the commit messages.

Xie He (5):
  net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
  net: hdlc_fr: Change the use of "dev" in fr_rx to make the code
    cleaner
  net: hdlc_fr: Do skb_reset_mac_header for skbs received on normal PVC
    devices
  net: hdlc_fr: Improve the initial checks when we receive an skb
  net: hdlc_fr: Add support for any Ethertype

 drivers/net/wan/hdlc_fr.c | 118 +++++++++++++++++++++++---------------
 1 file changed, 72 insertions(+), 46 deletions(-)

-- 
2.27.0

