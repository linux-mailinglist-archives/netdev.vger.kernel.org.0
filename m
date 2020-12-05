Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD672CFFD9
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgLEX7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgLEX7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 18:59:06 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051A3C0613D1
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 15:58:20 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id t4so8958938wrr.12
        for <netdev@vger.kernel.org>; Sat, 05 Dec 2020 15:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=Hg9A5yWhuSijN8I3Wf2ZFp54kMtCfs6q1jmN7tL2RM8=;
        b=HwiBuXK/e04xpJ4cCIRUWaP9BKz4pfnVtfa4+SKkTw4dg5rYEE42A74wKvC5ypH4iZ
         L9dzxcfsYxv9y4wuFOARxzxf6NXzYeu4HnXjDtx7fH/eRS/8Gn+kSKNlkgh6Kz6XVXRZ
         efL1M1j0lv7zUgZ0DDkjH2u/6BfPB4KzJHtPQ4/wo76+iOWOxwqbRyXJUq8/isFMV5lO
         1PnCIx2HNtTaVZ1GnnQlaPM/MCCFYFggbe6+C7b5omW22nezpWZsIA/iBILYD2aP1fNl
         qZ17JCdGJ4txJDFseV+FpRJWao9LpxfMdI3zEWj4B/6rZ2+O+QqTCtBiY9C/vCIzFIYc
         bzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=Hg9A5yWhuSijN8I3Wf2ZFp54kMtCfs6q1jmN7tL2RM8=;
        b=hOQL23V2/5X+Q7BdL/1O5C5nHF93wea+s0hocSkinnrgwV114PBRUAndaHh8AOOCr0
         abpFZKlmr7GE3e4ue5mMX5mBH/s9R89BxF8k2zR9q43QH3mZRVne9PgmXf42QCQlegv1
         4f1Q8um4kMi4lpWzfB7iCOUuu8JMnq6BB7a4mDGVkw4pnPlXn21ekdSHOOjrIW9wf12t
         +HHnaErC5/08tFuSriQx8aVUnMfkak/sX7UcrtPA6gZDGuXqJFS1ikwclTRyZ8s2ZMbj
         pYtWvo2xhXI1jK0cqMhgXACyasUg3Wpl6PTCxtHuZSTEMyvIpqxUAoWnpmoOUS1f/DqJ
         GtEA==
X-Gm-Message-State: AOAM531t6uKxjS8EYApigUq0a/zU6G4RLE3xtufTtfZYLrI4SQ/4U6GW
        Ws9eoPuK4UxUo8Gh0Nf7fxVXhu4KsyM=
X-Google-Smtp-Source: ABdhPJz/rD+LhksXHrETnEqJqxG/zKJGQ2JLMdUruj0wn90n2jiSNxQ9LkTP+qPNF/avkwv32etQnA==
X-Received: by 2002:adf:ee12:: with SMTP id y18mr12045603wrn.231.1607212697836;
        Sat, 05 Dec 2020 15:58:17 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2e:e00:6845:f25a:bfd1:6598? (p200300ea8f2e0e006845f25abfd16598.dip0.t-ipconnect.de. [2003:ea:8f2e:e00:6845:f25a:bfd1:6598])
        by smtp.googlemail.com with ESMTPSA id x17sm2223034wro.40.2020.12.05.15.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 15:58:17 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] r8169: improve rtl_rx and NUM_RX_DESC handling
Message-ID: <bf2db26b-5188-7311-a89a-32fafcd653ac@gmail.com>
Date:   Sun, 6 Dec 2020 00:58:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves rtl_rx() and the handling of NUM_RX_DESC.

Heiner Kallweit (2):
  r8169: improve rtl_rx
  r8169: make NUM_RX_DESC a signed int

 drivers/net/ethernet/realtek/r8169_main.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

-- 
2.29.2

