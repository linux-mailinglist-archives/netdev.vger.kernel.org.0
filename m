Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B419E2F03F6
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 22:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbhAIV7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 16:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbhAIV7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 16:59:54 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964F6C061786
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 13:59:14 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 190so10601787wmz.0
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 13:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=GWoOeiJ4fexwN2D7mkvruM0f2nzxY7y+FqV+JIzzYik=;
        b=eLChKcbS1DIPT0rCe6gext/mQRGmSFug/pWCcc4weHOxD5t+yfw7fy4cXzs68LjO4x
         C+B9bMz18R+D1iOVErdB9P7HveP6nPrZSgBo23WN3mTZfAkkbnj+9ZzVhAlS6t5rvraT
         zC1dc0Gefk+J8Xium9hoOtn26IZzGdXDbOtM3ypyk6ZlEqnd1wR6a7lNWW2YwYyZ0fYp
         spPRA1WvrUgCVRmsSV2Ti198+yBM5KBWv9mVHzG8MxUHSSI09j/h7cjw7YhiGO9z1nzz
         q+F/tY7EvclLIel/sFOSKVaDObJu2RctKsvZPNi+VD5ghAtxluNKr1caTy1FcoOGWjN4
         DsEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=GWoOeiJ4fexwN2D7mkvruM0f2nzxY7y+FqV+JIzzYik=;
        b=s13cmO53AKHWLHYP9m6mlAKfyIc+4xKQG6MrqX9XoukUL1x7wukRU63uuW66Wo6ugB
         TTbu5oC5B8r4Xu9IMQ8E0+TFrSQE3e51qxKmjIeYakoypKBhc282Mp3T0f+xUV7hPfTG
         oVi6UgEame4ql+ZQ/ViE6ZJAbICyZj2KVvBDcjazLKywLdtFxiKaAj245+XWVkDO3yyJ
         wAsHH1lU/YzebB8zfAwPnzJMGT7m3ZcnZZ0T9CzGflAInTnrp0F/wkGWgXNF1BulS2rb
         Pi8kUhyhJDM8WDaJmzSZ3LtLUJTUHQY73oSFpZZT4Xcw9t1l0umi15chF6azvDX+b5xo
         6Sqw==
X-Gm-Message-State: AOAM531dSOKNkJM1Vw13xcvVsovkAC53fxvifzX82LTMY/IW6qcKidNN
        Lb7gF3M1lvfeR9qR3m98SJ8MYyipOHc=
X-Google-Smtp-Source: ABdhPJw1o5ciDhn37hXgPh06SKAcZYKvPkz2oqFKGHku6waUonhn3WvK28RaxS5t0uU+jZnkLE3cxw==
X-Received: by 2002:a1c:4156:: with SMTP id o83mr8528611wma.178.1610229553004;
        Sat, 09 Jan 2021 13:59:13 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:a584:5efe:3c65:46c1? (p200300ea8f065500a5845efe3c6546c1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:a584:5efe:3c65:46c1])
        by smtp.googlemail.com with ESMTPSA id r15sm18612878wrq.1.2021.01.09.13.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 13:59:12 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] r8169: improve jumbo configuration
Message-ID: <1dd337a0-ff5a-3fa0-91f5-45e86c0fce58@gmail.com>
Date:   Sat, 9 Jan 2021 22:59:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small improvements to jumbo configuration.

Heiner Kallweit (2):
  r8169: align RTL8168e jumbo pcie read request size with vendor driver
  r8169: tweak max read request size for newer chips also in jumbo mtu
    mode

 drivers/net/ethernet/realtek/r8169_main.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

-- 
2.30.0

