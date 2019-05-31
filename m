Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B96831433
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfEaRw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:52:28 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40254 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfEaRw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:52:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so2228614wre.7
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=KXHbDO12CadT71KsfZFNQZ2BewlWPkRg8wh/8Fbu5gU=;
        b=hzQBLLT7XDkNuyKjqJXw5ah550J1Qu0jip2ikgTqhVgUANsHsN4+ZDq3V4H3M+I3VF
         VN8W1ktjZz004iGObKYCrxBVy5O6p0EFPtfHb0ZrgZhqN2FUFNvyCDlQpDNcEFLntJLq
         i/uJfCcA1/8t+A2LzEi5jXOY5wUD1qfAl75N1A4Tm1cZCRuVa7o3Scz88SlmI8KaM62P
         dEAsNYpglN7Ay08kYiwRVi0at/7UHyf+L8jRWSB33h+UKNOzEwzTGa+n6tfQA9M7lgoj
         DmwtKmOZgRSFpaPdrdDxio8kVTfWOGfO++/VEI5dlcuEHh6eYmbcHR6udFhlRkT/K6re
         j9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=KXHbDO12CadT71KsfZFNQZ2BewlWPkRg8wh/8Fbu5gU=;
        b=ljEG68IuECLxrcrSZZjdE63BuRWtSp+Wxp4Sg0bKWG9V9bVqu3USEepLkuJ8YpGSsD
         YI+LbG6Nl318gMt5Bx8BqmA0wEWC8bO+3c/bsHzJtfKWCdRbstsRmVJBW29Gvs4ZCsG8
         Z21uFdMWJi+1fkj0uNNuof03Bx5KqB2pO0VZ2bIbiv+xtp0k833vUEA5Bcc629b3kIEY
         pBPRZRymZHRpI+x6Lwbj+AKWHavZgpPdXRJ2i1BIAMdfT8vmSuAHEfTaETP4mqiPXNCZ
         sVDv7KTr6sCyWUybjAbj99Fc5zhO7pPGzuGCUFk+n4TOUIq2fQTWtFdDI+eAOkz6Tg7B
         VH2w==
X-Gm-Message-State: APjAAAVqTf7v14jlt3g6s6D297k7LfGXv+Fd4fPEUkMIipbJVVcFzHo/
        kSSzbe8LDPXdZXK4mIrNbiAmz3Vu
X-Google-Smtp-Source: APXvYqyUMcuF87RlZGoqrAz1jiSy+4qea1Touo3+0CpAmYLoEc/DWI89CAFMCU9xR2SdkLx1PSt7ag==
X-Received: by 2002:a5d:6849:: with SMTP id o9mr7478381wrw.196.1559325146700;
        Fri, 31 May 2019 10:52:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce? (p200300EA8BF3BD0020267A0B4D8DD1CE.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2026:7a0b:4d8d:d1ce])
        by smtp.googlemail.com with ESMTPSA id k125sm14363621wmb.34.2019.05.31.10.52.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 10:52:26 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] r8169: replace several function pointers with
 direct calls
Message-ID: <1e17bf2f-93a9-03ff-7101-7f680665f4a7@gmail.com>
Date:   Fri, 31 May 2019 19:52:24 +0200
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

This series removes most function pointers from struct rtl8169_private
and uses direct calls instead. This simplifies the code and avoids
the penalty of indirect calls in times of retpoline.

Heiner Kallweit (3):
  r8169: remove struct mdio_ops
  r8169: remove struct jumbo_ops
  r8169: avoid tso csum function indirection

 drivers/net/ethernet/realtek/r8169.c | 201 +++++++++++----------------
 1 file changed, 83 insertions(+), 118 deletions(-)

-- 
2.21.0

