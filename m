Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A281B186E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgDTV22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgDTV21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 17:28:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE902C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:28:26 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so14052970wrx.4
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=y/8qxNS2lE2X/WZKAfpXbqN9FsJsB+BySP2Oyp6oHoE=;
        b=Uab2RZcltfLZBjlbQLx+RZxfywJo42U/H2C5In5WnHg5cGYcVnl+WSqYN3eqZn+OlI
         cMlRMYBYo9Wrjcd+RwQbWrKjdVek4Cbss5vM2cQe/dbLkBWlDTZSCWNh2NzaFxhmp3V7
         xAgkNqBR9GEz4/VmIGBwUW4NS0ATGKwxZB3qLEAlE2ho+JQXj1VUhONcc5Q7FoNANujs
         qBVpAc93JABSpmfm5LdVlgkZL4XhoIP+9l4SUU9gHHH9q2VkYAcgqFAgSCONfRkoGoxa
         pPt7lwGWRyj2JOR05+hU4EnVqT01YaWXasckcWiq1is+XOjS/4Vt/WiR9gEiVB58PRFI
         4ngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=y/8qxNS2lE2X/WZKAfpXbqN9FsJsB+BySP2Oyp6oHoE=;
        b=QQxNmw5iBah7sVTwI/uTwqYZH1rDSaC5ddLHlIjOyB3CTpFcaUVPV6VY7Kmy60SBQY
         vJSgapL/ADm/IyXGIabkM0CJ0b63nbpFcqEzLeI7dFw78a60XXs8zXc1m2RjjRp3A7eW
         vuYdYIsNPU0ci477tHKc9yCHdiaHnbOGUaYU1h/yyPA4uEOll6Nd+anYShibN+dONfKR
         rWXDMAKVgwkXRrbgHeb8eRf5yakHzgfVNqTqJUUDRLCRR1GUR2jExr1zqepLL8ECRJ0I
         Uultu13OnfPCZ+PsY8x3j+DRpNKPuCTRQ5TdNNYnsovsiC7P0wPTQ8oBQpEK8/eUtuIP
         VHmA==
X-Gm-Message-State: AGi0PuaLmWLEiyzw/auKxcBeVOkfoLYMXXtWh2Vdo9ARNwhWMyrjuHFJ
        A6cr0s6JvYG3wugVfFy1ofQXzwWr
X-Google-Smtp-Source: APiQypKVXdw9YDqMw22YT3raTTHb+B590RGJRUs6e4wa+UhDursPyIb7gVnwpiI1UuTXP72/ObbfHA==
X-Received: by 2002:adf:ea48:: with SMTP id j8mr16493233wrn.108.1587418105267;
        Mon, 20 Apr 2020 14:28:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:7101:507:3ef2:1ef1? (p200300EA8F296000710105073EF21EF1.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7101:507:3ef2:1ef1])
        by smtp.googlemail.com with ESMTPSA id n9sm980856wrx.61.2020.04.20.14.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 14:28:24 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] net: phy: add device-managed
 devm_mdiobus_register
Message-ID: <9b83837d-d246-ffb0-0c52-8d4c5064e7e4@gmail.com>
Date:   Mon, 20 Apr 2020 23:28:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there's no special ordering requirement for mdiobus_unregister(),
then driver code can be simplified by using a device-managed version
of mdiobus_register(). Prerequisite is that bus allocation has been
done device-managed too. Else mdiobus_free() may be called whilst
bus is still registered, resulting in a BUG_ON(). Therefore let
devm_mdiobus_register() return -EPERM if bus was allocated
non-managed.

First user of the new functionality is r8169 driver.

Heiner Kallweit (2):
  net: phy: add device-managed devm_mdiobus_register
  r8169: use devm_mdiobus_register

 drivers/net/ethernet/realtek/r8169_main.c | 10 ++--------
 drivers/net/phy/mdio_bus.c                |  8 +++++++-
 include/linux/phy.h                       | 17 +++++++++++++++++
 3 files changed, 26 insertions(+), 9 deletions(-)

-- 
2.26.1

