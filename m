Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB1077261
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfGZTrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:47:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36082 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbfGZTrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:47:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so44473327wme.1
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9uMJXnFWfjBhvPSvY9fzTfD6jfxTl1hZlPomSYIlBEk=;
        b=N8lkjMuP1swIlOXHsuY9fgBe8SMAZNID71JDg9NHLayXVWuwaevfr5l9EXf0OPnxk5
         sXXaYZDBB/g80isCdhzYDqt5aK+Fkks0rFq5KgsyhVhlP+3umS6RdeS6LNuL2LlZG7wd
         4efKvmmUvynwaIxEj5KHx8yGjrxEdBUMWjnRVb9FeEv1ugtOxvlsp2OwXZ/e5mWed43e
         TPElVOA8UBM/5ZWwyVj+TpMSb5XE8Y6OXmEqd0A2e0NTb4PHvGWTw6x2FDGMUE6OngPR
         u6OqZZHPeBNCGmX1DPS2ycBUZtcwa53wO8vYxrhopNnEdRznNRahl1KYk8dUvGIubotl
         QrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9uMJXnFWfjBhvPSvY9fzTfD6jfxTl1hZlPomSYIlBEk=;
        b=X+C/iyH1PHGpa/IC2fMctpENZ20GnRpXwu0W6ACwf+FqNy9b7LM2H0bCCdWuIPmdOT
         OLEm7k+sP9mQ2sUW0ikfI+kZQ2+2tDM6MRcEfq5Dc47FN8kT8kByn53R1KiqcU42H57y
         p8MIO/DCWHOaqyQRadiXj9WmK23hNxeAvE2n8zIiaX2M8ARgzDLFJ+UwVYDtMlcK48eg
         MO8BE2pMmlSY6qf9aGgJEP7qkIML5Q6zmyEg+t1tM+xqiKc3XPTWZXW4d0FDisbM8zzN
         GrdoVoEF8ZfWNIFvuqERInNoK8DfyXonIJVVoOmXMZf1gUrkYN74Y45HWGx8ZfBvp5hd
         G4OQ==
X-Gm-Message-State: APjAAAXoZ/yZNtkcmGIwbKFYG+1oQfrksmMF3e+scMxj9QAX3+xg02a8
        N58z7dTp7Nt/BlcXPofqFZx01Kug
X-Google-Smtp-Source: APXvYqyPje8/zPdKLnblCMOzz9zkWKYOZNpRYneDHI9cE2NMKUZdoUITpj7XLaogGfRTYpi22TfuNA==
X-Received: by 2002:a1c:630a:: with SMTP id x10mr91047910wmb.113.1564170457256;
        Fri, 26 Jul 2019 12:47:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:55f1:e404:698f:358? (p200300EA8F43420055F1E404698F0358.dip0.t-ipconnect.de. [2003:ea:8f43:4200:55f1:e404:698f:358])
        by smtp.googlemail.com with ESMTPSA id n12sm57473059wmc.24.2019.07.26.12.47.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 12:47:36 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] r8169: improve HW csum and TSO handling
Message-ID: <d347af97-0b46-6c71-37ef-46ce2b46f4df@gmail.com>
Date:   Fri, 26 Jul 2019 21:47:30 +0200
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

This series:
- delegates more tasks from the driver to the core
- enables HW csum and TSO per default
- copies quirks for buggy chip versions from vendor driver

Heiner Kallweit (4):
  r8169: set GSO size and segment limits
  r8169: implement callback ndo_features_check
  r8169: remove r8169_csum_workaround
  r8169: enable HW csum and TSO

 drivers/net/ethernet/realtek/r8169_main.c | 128 +++++++++++-----------
 1 file changed, 61 insertions(+), 67 deletions(-)

-- 
2.22.0

