Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DF31B9431
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 23:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgDZVfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 17:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726184AbgDZVfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 17:35:18 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD31C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 14:35:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k13so18266916wrw.7
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 14:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=QGv1apCndiTMoNbG8w5nmITeWRnpIjAvUUxwCyRXOCU=;
        b=n261jv6vp093qMVWa7nof5nkU6vCYX06I+caRos0l2pbabByAfA/7E1ynvLYR851H+
         n2HFJ8UsdG26a3qTLPzFwVP44KuL5G7iIGL2qSmy/v4N7zEW0L9g3mtp7Q+9LfTuCOqO
         KmAbtJhokgjOw6SIVzzAkkuDwQIfYvNJUG2Jll+E3Kp8umMdm+yfIhsNmCvoe+/g11+6
         bfjnan72F5G/b3p3fQeuV8HuzfHgrVkBDx2pyE5Qz5pdY5wHSUnH4jkqj9tOhlLjqfgY
         3wZDlIjovtHRzes1tDY09E7/snrsMm1+PcVGvpIfYIxqnTcAMb9DQi6eXw7H9IkwFhPN
         5d7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=QGv1apCndiTMoNbG8w5nmITeWRnpIjAvUUxwCyRXOCU=;
        b=CGIMLXJ995mTRFnJXU+yQ0sEDD56XOIiI/uU5AOffRwi4vhSrnH/bETv1bgZNQTFwl
         uMycY+jEi+bkCmdea4KPkHAM2+C+wc8WwVbIiDuCGF6WxHRWcLaw/jGBi2f0u8EHmeEW
         j+9fPRwLPqay9Je5Zxpq+58S+Vn2oPYLsAp2aZmMm+8svAYNvyiVKzyaLyf7T6cQv1k0
         OAmFdXPrPRQcWyAXq10ikwBodq0bqxn4bc/m9RAHI6NjdOQRlzY3aGd/ROfX3HfAjTWj
         es3CRB9PNH7dxDLZw7kl/d8JDp7BtauVQn0KnOIAm4BI4+L8hyGrCqlhrL85jOUVGxzS
         dcIQ==
X-Gm-Message-State: AGi0PuYPqM96zDypgza7w6JfzIMx3aEsB6WEcB+Qri5se8K746Yt5j7x
        HhMwmM3egiRTXHdyMbyCbLTFf8KE
X-Google-Smtp-Source: APiQypI6GeS2XRqMgSkfHcl8sAwDd6IgxsFjAayDy2/fyPNXQF09Ca+9zKI16n+U8icd4ZAmZ6i2rg==
X-Received: by 2002:adf:b1c9:: with SMTP id r9mr25691326wra.271.1587936915397;
        Sun, 26 Apr 2020 14:35:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d1d0:8c1c:405c:5986? (p200300EA8F296000D1D08C1C405C5986.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d1d0:8c1c:405c:5986])
        by smtp.googlemail.com with ESMTPSA id m8sm19629989wrx.54.2020.04.26.14.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 14:35:14 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] r8169: improve chip config handling
Message-ID: <e076bba2-e4dc-f8ce-d119-5b6735017727@gmail.com>
Date:   Sun, 26 Apr 2020 23:35:08 +0200
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

Series includes two improvements for chip configuration handling.

Heiner Kallweit (2):
  r8169: improve handling CPCMD_MASK
  r8169: improve configuring RxConfig register

 drivers/net/ethernet/realtek/r8169_main.c | 41 ++++++++++++-----------
 1 file changed, 21 insertions(+), 20 deletions(-)

-- 
2.26.2

