Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596A42A1932
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgJaSLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbgJaSLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:11:01 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154D8C0617A6;
        Sat, 31 Oct 2020 11:11:01 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r186so7573524pgr.0;
        Sat, 31 Oct 2020 11:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5X9I0loIyOutdXyW3xhnANGyP+mCEbMgTnS/40+361g=;
        b=jIwusoNoLBFzHDGDEdzj03z5daic6DSkotqRrCTTrFM09DQVdsHAoKncenhEs4NB7o
         Q0ELojiS5dHA281OmvDvQw7XPZgqT04njXCusrz5s9SZSmAbgGxwgAYtNkbyLKuucFg0
         G45Gu1kCBZW97DvLOOufzSp6f0IqJ/21DHbapGiaFiN70jUWPlbja5kqpbMtFA4dl4jr
         HdKGpgRSe6AGMfNwqL4l7rnij6GU9/yIfMRo5IIH+Sux+K36nPJ3lXp4cJ5XAIQVk/Xr
         JHI/8pfcAg8QjruLWxO26lXcCNjUO614WHs7MFh+D7sLumsD7L1na8Gb+tUQV0RQ1BqI
         AcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5X9I0loIyOutdXyW3xhnANGyP+mCEbMgTnS/40+361g=;
        b=qK56rLkkVykQyjUHjXpJTZN8N1tK87JqO+93G9VbGzgfCgNQD9JqcRErcYq9HZBUNt
         oe/xyRmTfqOBupYAKUrbq5jnQIl/gJ+JKjyUJuvlgBZYl6Pd5/d+AoO0C1gNTziuTdJo
         PKadDa2rXrj3QzdiP1MsL814tHLkqj2e+9gboIla94R1zbjALFO7lm1vgoELSQSjD19R
         SXbwz9drXfogTIJ/y9FiFApelSQZ2bnT+0f+tbkZaSzCdWZWUIBeMqXy5zTy+4k4GC2j
         9mQlyJqH2hMnxUgtpdml+reULY8bsxuIuU2yvqWgDEo/jFCnu/ysKbzW1giitHvwU5wg
         /+Bw==
X-Gm-Message-State: AOAM532dkrH1VtujMSWY89QNujKO/qcC9U9mlVlUdOdbpePIeh3ygkqr
        MaasXL5lwwoNrbeMhB8JiwY=
X-Google-Smtp-Source: ABdhPJxABc7SJKTCG9I+uiJJRoSFKkecKeA0IzhMxR0ZfjiIzY0P9mGdWlkBOwbC/Zzlva7arb2d3g==
X-Received: by 2002:a62:e914:0:b029:174:77ea:4881 with SMTP id j20-20020a62e9140000b029017477ea4881mr9768482pfh.69.1604167860665;
        Sat, 31 Oct 2020 11:11:00 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:32f8:16e7:6105:7fb5])
        by smtp.gmail.com with ESMTPSA id n6sm6967137pjj.34.2020.10.31.11.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:11:00 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v7 0/5] net: hdlc_fr: Improve fr_rx and add support for any Ethertype
Date:   Sat, 31 Oct 2020 11:10:38 -0700
Message-Id: <20201031181043.805329-1-xie.he.0141@gmail.com>
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

Change from v6:
Remove the explanation about why only a 2-byte address field is accepted
because I think it is inadequate and unnecessary.

Change from v5:
Small fix to the commit messages.

Change from v4:
Drop the change related to the stats.rx_dropped count.
Improve the commit message by stating why only a 2-byte address field
is accepted.

Change from v3:
Split the last patch into 2 patches.
Improve the commit message about the stats.rx_dropped count.

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

