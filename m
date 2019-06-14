Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9BF45451
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfFNFxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:53:23 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:37727 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfFNFxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:53:23 -0400
Received: by mail-wm1-f49.google.com with SMTP id 22so968383wmg.2
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 22:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xtaA+6ZRw93lc+V/Swmy3Sx4sWVbDJkdAN29Jjw6ksI=;
        b=nrCDW/mOmM6rO7ISJijxspq0TqXK907cil2I5VE+bzqNSzc0RfE6E5Hp7mXkHhMgVR
         p0Vpx7i9snh8fHgn1xQJiT1Y/yYDaJJgU7bAggufhApIB7JOXCHWojF4bzhrsr5O9vnl
         sWj3/j4x2KIIswa7mgrP1+et3/nDngfD4SjPs10eKSkoFW00TCRj/ZpE3mbJQpCXxOXC
         S1+v7yP2W838okjQqLkjta0X1JsOd1QxNW/KWZfviZeSqmihs4F0jejjueiW24B1+7I4
         OGiOmRDcJeQ9ooughszCD+/ahyXUY6vXDf+NCf28LdgKP3+zB2gzJDofyGZcL1inEn83
         N8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xtaA+6ZRw93lc+V/Swmy3Sx4sWVbDJkdAN29Jjw6ksI=;
        b=k66qicW59mA7/KRn/q5yG3p0/hlZam76EQRiUamq9Harj4QgFBPhA/V8gFA4e2KvR2
         bfzSPwBiGwL6tzHJSqpffn5+eTvYtsZbhFKR7iibNIluEPrdAD+j4Vzv/lDkOG2XUawt
         UpKoX0jzQMzfOeLxA6olLTLI7bzdJFC/mHBpOF2XvgmM90MighCTdgrXavi27EGWQ7Qq
         QCw/irDv2Oa+W1aNmyVtT7l3T+t9HfgVcE1p/QAHPA6ldTtWMapZxRgCOUZ9bqPqYJV5
         uPcp67/YohMrcp8hhdncyG/TGrElIsrAaVXzn3h6NBmYSj5V8996x+M4OqwyAGH8mESC
         k0UA==
X-Gm-Message-State: APjAAAUqLU5/wpt/MbRF2rZv/9RmUkPb9QqaZvEoTisso3sJB6ccbzRr
        mVg3TqlgZTfBM4tijEnHa9eMgjPr
X-Google-Smtp-Source: APXvYqzi4IhNXCuQroZJIXIA3dja1Gp+ve7pGWoS28Api0rh+Z2FkJ8Uwqt9L2i1iqwkfLgBhL5vsA==
X-Received: by 2002:a1c:6641:: with SMTP id a62mr954700wmc.175.1560491600740;
        Thu, 13 Jun 2019 22:53:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:9178:4599:8cd6:9f81? (p200300EA8BF3BD00917845998CD69F81.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:9178:4599:8cd6:9f81])
        by smtp.googlemail.com with ESMTPSA id s8sm3245177wra.55.2019.06.13.22.53.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 22:53:20 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] r8169: add and use helper rtl_is_8168evl_up
Message-ID: <0c355e89-8e6b-7ea9-4971-21980f9e64da@gmail.com>
Date:   Fri, 14 Jun 2019 07:51:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few registers have been added or changed its purpose with version
RTL8168e-vl, so create a helper for identifying chip versions from
RTL8168e-vl.

Heiner Kallweit (2):
  r8169: add helper rtl_is_8168evl_up
  r8169: use helper rtl_is_8168evl_up for setting register
    MaxTxPacketSize

 drivers/net/ethernet/realtek/r8169_main.c | 53 +++++++----------------
 1 file changed, 16 insertions(+), 37 deletions(-)

-- 
2.22.0

