Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860C62EA7C8
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbhAEJlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbhAEJlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:41:11 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDCDC061574;
        Tue,  5 Jan 2021 01:40:30 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ga15so8268456ejb.4;
        Tue, 05 Jan 2021 01:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=7JpfgvEf5Dv3hNrt+948clbIZ+Oxxj5OAi+iacxd46I=;
        b=F5BNa7wPD+WAkUgPQ8GPBm+v8CNXST1S8WDbl+7abPKUDu1TEyE14kYCrqCDaIHwAR
         L97vYSj6jZ/MUI/lZNyRmoEktlpCmwOlGxFe4fsN4y6rrunqVfDDxpca2RA7Avoq5ooa
         j1rSTu19y4kcieJNFB07zAHaGMkFaITraLBzK4ixQEoPDnNM2h/1ElPbGFsRAvmH5qoT
         W8UqfoUHHdPZM6z8z7XCE+5iDuoCtwyIK/iX5lHQ5MZMIPcCA0I8sxks011M3smpIHSv
         XHL1BxUnQaM+KWnvOgciZHqoUu9+I534ag6vfe9vn6a7yyhzdFVVBL0ZjyyzXJhQkqZT
         k2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=7JpfgvEf5Dv3hNrt+948clbIZ+Oxxj5OAi+iacxd46I=;
        b=Jucqk8M0PcL1/fVo0RDqf/Xh1jM3sXUszB7UIUHHIoEC0J2QdTPQO+XsIbL3eDF2gS
         L8cYwNMLMU4SF3fujaKW+XSFrkevA4nG74zNtuooteKM0m3J349l0doNcnG6nxgY/BVR
         CXyiphDZl585R/qYhgjbROCm/E5JpXPfjiCSXqnzTssF2SPJfP6WLLv3l7b6/gSDMW5y
         1RMprnxpYn4vx2HusweOEBxVTrS2DWF9hSw21ItcG/bJ5WT/6oDDiSSS8iRZZPzjktJ/
         p4De8VTeAkJUeSWDkeFm/1TvqeCxjdu/KD2ckSntp0C6iSXk/wbUK9/EHVaiLQjWoIpc
         P/Dg==
X-Gm-Message-State: AOAM531P8Uv7XVeOAPRpDss1cXZ0A6+l6Of1YZZ19NLZFL96Ag/sd5Uz
        XgYoypv1SxMxSI2RHLsi9EYnh/DgPbI=
X-Google-Smtp-Source: ABdhPJzwjFwZ3FNbcLiYV2rf1ENgTEumATCWtzmL/Jp4/zr4BlbeUHFvSg5W0QGCmcAz979GWhwMKQ==
X-Received: by 2002:a17:906:a29a:: with SMTP id i26mr69055933ejz.45.1609839629342;
        Tue, 05 Jan 2021 01:40:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5ee:6bfd:b6c9:8fa1? (p200300ea8f06550005ee6bfdb6c98fa1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5ee:6bfd:b6c9:8fa1])
        by smtp.googlemail.com with ESMTPSA id x16sm24389880ejb.38.2021.01.05.01.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 01:40:28 -0800 (PST)
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/3] PCI: Disable parity checking if broken_parity is set
Message-ID: <a6f09e1b-4076-59d1-a4e3-05c5955bfff2@gmail.com>
Date:   Tue, 5 Jan 2021 10:40:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we know that a device has broken parity checking, then disable it.
This avoids quirks like in r8169 where on the first parity error
interrupt parity checking will be disabled if broken_parity_status
is set. Make pci_quirk_broken_parity() public so that it can be used
by platform code, e.g. for Thecus N2100.

Heiner Kallweit (3):
  PCI: Disable parity checking if broken_parity_status is set
  ARM: iop32x: improve N2100 PCI broken parity quirk
  r8169: simplify broken parity handling now that PCI core takes care

 arch/arm/mach-iop32x/n2100.c              |  8 +++-----
 drivers/net/ethernet/realtek/r8169_main.c | 14 --------------
 drivers/pci/quirks.c                      | 17 +++++++++++------
 include/linux/pci.h                       |  2 ++
 4 files changed, 16 insertions(+), 25 deletions(-)

-- 
2.30.0

