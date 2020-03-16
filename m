Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0281874BC
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732652AbgCPVb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:31:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35224 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732567AbgCPVb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:31:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so2504512wru.2
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 14:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=SgETd90ZKtQ7RU5hKVpzvpDEdZg67onYcApmCJzP1J4=;
        b=DPb+JdLOiBJ8jqDzeh5/PAV5LozTbUfVfTQl3Aql6u5g93WyJP+bY3AwjAyPNgupCr
         /RYQy6jvD+ezpSt2tYFFFQTxHAGhnlCOCU4PjDyflLtGG7znGo1/PF1fAiUk4cmSgo3T
         G8LNP8yrc4SdsXEUBhHtR/Czea0sm51UJTbAysOQqedDvaYQ+3fDgfhJqhbB68KyXI1p
         5q+reXo7L1wkvAqrUh71PTkFObkdzu6I3Kpy5Qtmb0HUbHiiOdcao6OGb6rB7hrPAtxX
         EOQNRLyULfnhh1Rc3lm8F8A8OPEJq9KLxk9yxHxsI0wPUpNofk8vzFPTa3fAgh0AyV85
         1pMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=SgETd90ZKtQ7RU5hKVpzvpDEdZg67onYcApmCJzP1J4=;
        b=W1a4WcG/N2tMitP/V8JR/8NAPq8HOWLKr+FLI7X9DHjpzjKNZhPPGeeziMUuPJlHp8
         HtuTzHGRxCq0EDU64RCIAt5NLeUu6jQKdAegloWz79pMXAswV/7erZFyd/OjtERQwd8F
         sRg3NDMrProLn0H+5KFjIjdNOAKkZtBlja0x1+29gMQsHTfaKaALg4SKnohp9AwC2au/
         U+G9Crp3ZIgnDWHpinlhHBsxXYsn8zXuAGVQYtVu3q1+iO7EpQ1tO4qE50XSgt+lCam1
         xe8gvtI/soXscjIFrDluCV6RAUcGffptDtpb45E2OoDoxDaYoGMdQQ4aTd9uNgSUCimI
         81jA==
X-Gm-Message-State: ANhLgQ3bR9EVy0E41AnXpHU3nk0It19+yYGTrWUdRpiJvMAtEk4mj3/h
        9YYCf+doy4ugYXtfUq6KrYjshrzB
X-Google-Smtp-Source: ADFU+vvoly4V66Z9JOfz7dOkpeKHvsJK+Ghaq8suEZm5W0fC48WziQpSueNGu9cqQpmkFe9YN2RcMA==
X-Received: by 2002:a5d:5512:: with SMTP id b18mr1345298wrv.215.1584394314978;
        Mon, 16 Mar 2020 14:31:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:1dfa:b5c5:6377:a256? (p200300EA8F2960001DFAB5C56377A256.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1dfa:b5c5:6377:a256])
        by smtp.googlemail.com with ESMTPSA id s1sm1551070wrp.41.2020.03.16.14.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 14:31:54 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: improve phy_driver callback
 handle_interrupt
Message-ID: <49afbad9-317a-3eff-3692-441fae3c4f49@gmail.com>
Date:   Mon, 16 Mar 2020 22:31:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

did_interrupt() clears the interrupt, therefore handle_interrupt() can
not check which event triggered the interrupt. To overcome this
constraint and allow more flexibility for customer interrupt handlers,
let's decouple handle_interrupt() from parts of the phylib interrupt
handling. Custom interrupt handlers now have to implement the
did_interrupt() functionality in handle_interrupt() if needed.

Fortunately we have just one custom interrupt handler so far (in the
mscc PHY driver), convert it to the changed API and make use of the
benefits.

Heiner Kallweit (2):
  net: phy: improve phy_driver callback handle_interrupt
  net: phy: mscc: consider interrupt source in interrupt handler

 drivers/net/phy/mscc/mscc_main.c | 18 ++++++++++++++----
 drivers/net/phy/phy.c            | 26 ++++++++++++--------------
 include/linux/phy.h              |  3 ++-
 3 files changed, 28 insertions(+), 19 deletions(-)

-- 
2.25.1

