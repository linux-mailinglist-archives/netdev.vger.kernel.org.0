Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA0B8C395
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfHMVYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:24:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55367 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfHMVYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:24:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id f72so2773057wmf.5
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 14:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1F7ug8rNeIYNF01+G3VWQEppnABm23QBFnnzwmZJ21U=;
        b=Ew1RIWMfKbtQpidh7Jpd2Pl5p0BLWhFsId3y/72DuuQ3QN6sJt0Qm1LAOozpX+4LHd
         iEDM1vIPzs9tiWfifrD0Ibda0C1xBYi6k7EJXhh7VB1m3ZpbFhcc3kLlCSr/Qj+Cbxzz
         y/CMmMzH3UxBKRtBCS+aPMfnIYhZ8koZkZUPlOBtYuNqX+x84sFb9Jb1J8neRQPc/33j
         7s5mEH/vbBD+AUs7Jo3gJBQ1vjiBPoYc6YOV5/dnf+hZPZtmpzPY4zTxWlg3XB4BLT/6
         3kxBoghYVR2eLTFzxCZH/Ynd3i+loJ1ux23J3g0nIEZ6AUAuuYRNcPE9DDLkVZ98kAV8
         icjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1F7ug8rNeIYNF01+G3VWQEppnABm23QBFnnzwmZJ21U=;
        b=CXFDYSuppS7xe0elphK7qIHyG+yioxxTptQXNM45EC6U8p4gENP3baaWBlXtGN5y3q
         y57zQaO4HJlXz0jLxOw5Ibigyh6HMRc9lf82bubC3O9coI9IwQsOweuJCKnBCmH8ecOQ
         gW78NV6RXQxJRiz6l1/2bCjeB5jDPwT623LyZO17baC1EXa9HM6p8YMGBHvyjEjo2bve
         R9dYZnZsRA0ReceWg6ukmNsaQRn4r6RUprwUTL8yo3J5UorU3qQDDHYySSwr2a4ppijJ
         3kpaI8B4KYWTs4ysoNVIhe5XojS16Cg4IGkjC0b5chE/c034ku7ljuDWi8lzxBfljZaP
         wOAA==
X-Gm-Message-State: APjAAAUO1vfqdALGH98D0D1Cm5y7oyNYxjlxBqEZIFUG8ahzobQW8tOY
        yCMfTD0qp4LWrOb7HZZzJHTRe/Up
X-Google-Smtp-Source: APXvYqzHuR9oU+DuXvuyej1B0fmuAfy5YcsC0j+lVBBnO2afzhxGaYvfV+ILAo5bG0c2NTo70qbyaQ==
X-Received: by 2002:a7b:cf09:: with SMTP id l9mr4821531wmg.20.1565731446873;
        Tue, 13 Aug 2019 14:24:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a? (p200300EA8F2F3200E1E264B7EE242D4A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a])
        by smtp.googlemail.com with ESMTPSA id m6sm18614422wrq.95.2019.08.13.14.24.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 14:24:06 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marek Behun <marek.behun@nic.cz>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH RFC 0/4] net: phy: improve fixed_phy / swphy handling
Message-ID: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
Date:   Tue, 13 Aug 2019 23:23:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on discussion [0] I prepared a patch set for improving few
aspects of swphy and fixed_phy handling. So far it's compile-tested
only. I'd appreciate testing on different devices.

[0] https://marc.info/?t=156553610700001&r=1&w=2

Heiner Kallweit (4):
  net: phy: swphy: emulate register MII_ESTATUS
  net: phy: allow to bind genphy driver at probe time
  net: phy: swphy: bind swphy to genphy driver at probe time
  net: phy: fixed_phy: let genphy driver set supported and advertised
    modes

 drivers/net/phy/fixed_phy.c  | 23 -----------------------
 drivers/net/phy/phy_device.c |  3 +--
 drivers/net/phy/swphy.c      | 11 ++++++++++-
 include/linux/phy.h          |  4 ++++
 4 files changed, 15 insertions(+), 26 deletions(-)

-- 
2.22.0

