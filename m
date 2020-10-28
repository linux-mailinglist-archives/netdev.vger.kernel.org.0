Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFD229DCDE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733153AbgJ1WXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732546AbgJ1WVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:21:46 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE19BC0613D1;
        Wed, 28 Oct 2020 15:21:45 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z5so1238135iob.1;
        Wed, 28 Oct 2020 15:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J+loTL3cY0GJn8NZE0IhsWKxIonlZ23vOcImcA9hMOk=;
        b=MBjkO85JwDunuHwbEZKEWNU4jXCcQzSSnl3RfL/WyZNjGrLwaWq8u2+j6ZiJsQVe3/
         B71MwVUBzvTT7/gTYYqrFSzkKQwPQKAURQEoIA2FvcwZg75lo6svGKDpdCgeLi5B60oh
         83RifJsegGYsA9O0HGBz9E2ZAwyAJxC7WvodGvU8xUeUhdk6n5sy1Y3iinKhSkAKNlOF
         osPBgImyulyyrgPtkNiKrOkiJcuG6fXJM540HPBQckYlIltmyFs+ecGDpb8IPSxFN3RN
         61Huo1CX1o9qDIwq0zjk6L/bGKu3XGDBG0/mHk8rIZKBBt7cAvhLRi3rlUCUpF6C/XFD
         ZwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J+loTL3cY0GJn8NZE0IhsWKxIonlZ23vOcImcA9hMOk=;
        b=cY3RQbvQ08kOAtWCWBzO5iYJ9zFGmD+oZGSoEF8/FLj8aMlF54w8zZmoRVDFLBAP3x
         bH3OTCxzNeHLTvcR4KO03ELXD23fE0v+sKhW0bwkkf413fIJxW371wijwApVa+JFei5C
         gY+v9qfxhEx08LkpqwHbDH0y10WXobcGEOu4tx1QsOkeOPMFPOGZj7CTTEcoPTlgQBUT
         4IuNMM4A6w1jht6n++vqCSJSyqcdRKHREfvht3IQqi0GiYX/ulCeQpKOx24GkGBXMTyX
         KZFixstyadd3a2CSHlGksmcl1cQ/cXKO/99BinwQc54FYGXmjpLq7gwHEL1QQpWGkEL5
         7jKw==
X-Gm-Message-State: AOAM532W3LT9BBe4Jckmn5u3jrH5CexqzKx5YTXlLOWfdLIPVvRB0swv
        bJfizXkQMPCkg5hSotXzy+GwkY2lFqI=
X-Google-Smtp-Source: ABdhPJxd1F0n/yjJ8dvuEV6RK72m6oIIRxEetEFqADQgw+aAUC3EcUrC1tUdnHG54xVOup4xhzzNQQ==
X-Received: by 2002:a65:478d:: with SMTP id e13mr1916673pgs.358.1603882659563;
        Wed, 28 Oct 2020 03:57:39 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:a46c:8b86:395a:7a3d])
        by smtp.gmail.com with ESMTPSA id 65sm557863pge.37.2020.10.28.03.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 03:57:38 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next 0/4] net: hdlc_fr: Add support for any Ethertype
Date:   Wed, 28 Oct 2020 03:57:01 -0700
Message-Id: <20201028105705.460551-1-xie.he.0141@gmail.com>
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

Xie He (4):
  net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
  net: hdlc_fr: Change the use of "dev" in fr_fx to make the code
    cleaner
  net: hdlc_fr: Improve the initial check when we receive an skb
  net: hdlc_fr: Add support for any Ethertype

 drivers/net/wan/hdlc_fr.c | 119 +++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 46 deletions(-)

-- 
2.25.1

