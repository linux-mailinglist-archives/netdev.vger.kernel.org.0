Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28EC3E4F99
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhHIW6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbhHIW6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 18:58:19 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298BBC0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 15:57:58 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u3so31851060ejz.1
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 15:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=UAhYmXYIV9bdXw0DpDGg+bSDDtFfEP0Yfk64QR9eHo4=;
        b=Mc+VEw06bNdtVF4C3Lw8OfmNjv2TCD2dXtyh8t/fvoS0WWKuaI0JbVGXSbGriimX5L
         +tYJbrWuEXyvUi6eQ4Nu1bQxOFQPeHdwjSouE1GBcTw1VjtGbbkNo7Rad+cEC7NTlhBA
         kA58ze0vDAzqzfZjOHJ2uYprwVu0uxna/35smlAqdHjuNeQzBIVpw8tHeydnPtL4XyNe
         0iMSmPWl58JtOftjTgFgehfn++rZJpIyBYpvkGYHzdGGNx2qxlur4UcvANIANWnEbdz5
         C7ynJaJxz6+rudgF1sx+v3NqaqgUh0BLE4Gpv7Z7U3RXJZRu8tdo6r7JCYZLb72sExsY
         vr2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=UAhYmXYIV9bdXw0DpDGg+bSDDtFfEP0Yfk64QR9eHo4=;
        b=A9xa5B6PTZfXOAkOACi6nEudYW5d8XdCoDCgqAwPpGXfiI2h+RNzjttteYGOPBBDaS
         d9Yn/qaeuCr2X6xhNesj9ooHTCtq7h+KXlb3sjfAaaNoCDXyAageUF5/B0jTlx61ocmR
         WmVa1S95gu4KZzfGUpTHGZq6ztNOHokr39GBS1ae3DsE52BU1M+8SCiWXYUOdO65Iozo
         Bjkifgs8t2YgPl8yLbgy7GjNezEx6sUavuys1BNV70PZcTOPaveZIzlSJ6o7enS81gUI
         YzLAIu+CPQ7YkfFS+t/GnFD53wzd+B6FWBDUb+viiA6izncJF/jEeUvP5Q9d1imB6BPy
         dDsw==
X-Gm-Message-State: AOAM532qA7lSC784L0ldYnbV7pbrpmNwynXJS83lAgEx2j0EYyX9Atwg
        XMgty4vJVQdo1k8vhm68rYOrHMj4AfAvFQ==
X-Google-Smtp-Source: ABdhPJyFQRQCv4Qf1buj90l5EYF96qXefz7CFyeWFNIajRWwapZcYNctHOFg+tjViQdIgjHNcI+OsQ==
X-Received: by 2002:a17:907:970f:: with SMTP id jg15mr25204534ejc.175.1628549876047;
        Mon, 09 Aug 2021 15:57:56 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id i6sm6268335ejd.57.2021.08.09.15.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 15:57:55 -0700 (PDT)
Date:   Tue, 10 Aug 2021 00:57:54 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/7] ksz8795 VLAN fixes
Message-ID: <20210809225753.GA17207@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes a number of bugs in the ksz8795 driver that affect
VLAN filtering, tag insertion, and tag removal.

I've tested these on the KSZ8795CLXD evaluation board, and checked the
register usage against the datasheets for the other supported chips.

Ben.

Ben Hutchings (7):
  net: dsa: microchip: Fix ksz_read64()
  net: dsa: microchip: ksz8795: Fix PVID tag insertion
  net: dsa: microchip: ksz8795: Reject unsupported VLAN configuration
  net: dsa: microchip: ksz8795: Fix VLAN untagged flag change on
    deletion
  net: dsa: microchip: ksz8795: Use software untagging on CPU port
  net: dsa: microchip: ksz8795: Fix VLAN filtering
  net: dsa: microchip: ksz8795: Don't use phy_port_cnt in VLAN table
    lookup

 drivers/net/dsa/microchip/ksz8795.c     | 82 ++++++++++++++++++++-----
 drivers/net/dsa/microchip/ksz8795_reg.h |  4 ++
 drivers/net/dsa/microchip/ksz_common.h  |  9 +--
 3 files changed, 74 insertions(+), 21 deletions(-)

-- 
2.20.1
