Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FCF2A1200
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgJaAil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgJaAik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:38:40 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92541C0613D5;
        Fri, 30 Oct 2020 17:38:40 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a200so6692833pfa.10;
        Fri, 30 Oct 2020 17:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LH/FE3+msefZQLxAesyIHB0BqDv0Bl4jy7aavvgkNQg=;
        b=mkQLXeNJkZd5lOyGdfhpzu0NZ3BBGnPVUJ+pzgvxJpSQL7hb5NZGevyeTbwT+Kn6ZL
         HW+r1PApPehnQ4d+Pz52I4WhOx+tI5xNSZ1XcQki7IYGSXBoqaNx8bkh/sFDQ3qIeIlc
         EvnPxCGZkjjyNa75fhypApmZJPi1dNib35v0bVbwvXOjWL2ZCmYt4pL83wTpLaeBPQHA
         Ks7Sc1EXQJoe9n3OKzQdZRQQXNXusGkpl4ObStNlIs7rjIhDL46vnxX29pljFJpQUVFf
         myCVTl2avT2vLE/x2aqFgIQkIN+hTtrA3sorqS2Xak0IzC32Bsw9idtNQW5EErY0Nmdi
         2TjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LH/FE3+msefZQLxAesyIHB0BqDv0Bl4jy7aavvgkNQg=;
        b=akfpcXgfjQwjk+iomW6q90PyJpjXhKPpHCrTU/c+te3YKO3R3+qepLxFyQA5+YXtQ3
         SzKsuLW7dul1IDQtXskBlM95axFxGi+glogreDcx6PhL+dfxnpmB++ZupV4PZkFgv975
         itZZ3aYy7GNY1KlORF3lfLP1T+ryMOoOeu3p3ZMEye2CB5GJLHvxAaeXMJZtVQg5MeEn
         KLA3pbdl2QVOLQBSoHYtX9HhZCUIQec+xgArJhwdgrO87qUEhrOkL942Av6JKM+xdBtV
         2z8XObhtuxDTBpFTzxjj2WcYtj/rw1d2JnaR7T0/W2o9EgGx1ugWi47VXSTe/gh/eDDg
         fpYw==
X-Gm-Message-State: AOAM531IT3J4lcos9l4brzUF15UYmllmhDZOLOPudw1mJEfSggHgoMbm
        Pzt4Tl6yJmEhAx0mbUfRx9qfKqkF8eg=
X-Google-Smtp-Source: ABdhPJyJ9R7rr4EEDntRhy9LYv5JodVGCZWCy1X3ePnkrHOfDacXQNtIlZxA0xPoL+9jLnvF6OgjgQ==
X-Received: by 2002:a63:cb08:: with SMTP id p8mr4353470pgg.76.1604104720205;
        Fri, 30 Oct 2020 17:38:40 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:48fd:1408:262f:a64b])
        by smtp.gmail.com with ESMTPSA id ch21sm4596888pjb.24.2020.10.30.17.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:38:39 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v5 0/5] net: hdlc_fr: Improve fr_rx and add support for any Ethertype
Date:   Fri, 30 Oct 2020 17:37:26 -0700
Message-Id: <20201031003731.461437-1-xie.he.0141@gmail.com>
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

