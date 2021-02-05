Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E959231144E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhBEWDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhBEO5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:57:55 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D56C0617A7;
        Fri,  5 Feb 2021 08:26:50 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id w4so6483225wmi.4;
        Fri, 05 Feb 2021 08:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=qkOMo2ll21Kj5Gw0zJCnssUfVA2sNkOv80MBYCGIhRA=;
        b=GT3AhtO2+ycO8mxCe30V8GmkrI3L+0F/KIN6Ax0Eagi4Gz127rYwKdDDjpWgR08X9J
         OorDdRoK0j2R3xAaHYzgkVbd9pad8BYOlWnWxiAXpZ3mdm8S9O0YJKLENZRJoVPQj6KW
         n8IFVXOjx3xnyRw0Fnb3y6mQn/4mlXp+5olDkRQG7x3XVwJ1k/8KxlPinpLCPWVPMpwJ
         HKjy2KGng9Apmh81L3FsMGMvvWOFWoH1hMLZcksUZJoRboUb6Iq43XGl1tbkEAScg41n
         CoIaNNk28NN2lKV14VZrNasJ3aIW9NzVZhmpYzw4Y3YdrXxfHsgtvFb9IsfWPCtoGAu0
         Qyzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=qkOMo2ll21Kj5Gw0zJCnssUfVA2sNkOv80MBYCGIhRA=;
        b=I1HhU5lk8felwrvFuqfltFa2sF3j0RU20P1Xelex35fK/zEpDO1e4M6heOLfXnwtC2
         ehWbTToT+KJanpTWgqjisHglOkwjV48BgFJAhubOxB/OX1BqC0PUZ8jvO3xHjulaeGYJ
         rO2nSlEEygk7/5ZR0SjSaGcNeUJzfLfYnqZA7UVIkyqNrM5B6H6l8VyfB9/GjmkND4yy
         qtJi+lp9851CdsK5b8F85hWktDGyQWWjoGrZ44i9xL9r/d+bfGSaKoSNAifPBG5Kk4Vf
         2FelC1P6Y2uyVWxe5tP67lefX1i9HpWUiFU1u9gxX0NeT8ZZgOx6zpVQw4rc9N2gTWYo
         k0gg==
X-Gm-Message-State: AOAM533S/kMhqpys/RTzF17/gX60FSCkzXEQjC78Z3jM0/SrqIIQZ+Jq
        eZU0I85BypM8+ebNd6q5poUC2ts5Okigyw==
X-Google-Smtp-Source: ABdhPJwDegFue9QaFRgWm8J+tlU4FED2PpI55GA1+0qctSg7nTtNfSi6UikoGp/H2j4RVqBOb7R24A==
X-Received: by 2002:a1c:e104:: with SMTP id y4mr3638295wmg.89.1612535090456;
        Fri, 05 Feb 2021 06:24:50 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:9118:8653:7e7:879e? (p200300ea8f1fad009118865307e7879e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:9118:8653:7e7:879e])
        by smtp.googlemail.com with ESMTPSA id h207sm9536401wme.18.2021.02.05.06.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 06:24:49 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next v2 0/3] cxgb4: improve PCI VPD handling
Message-ID: <8edfa4ae-1e78-249d-14fb-0e44a2c51864@gmail.com>
Date:   Fri, 5 Feb 2021 15:24:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Working on PCI VPD core code I came across the Chelsio drivers.
Let's improve the way how cxgb4 handles PCI VPD.

One major goal is to eventually remove pci_set_vpd_size(),
cxgb4 is the only user. The amount of data exposed via the VPD
interface is fixed, therefore I see no benefit in providing
an interface for manipulating the VPD size.

This series touches only device-specific quirks in the core code,
therefore I think it should go via the netdev tree.

v2:
- remove patch 1 from the series

Heiner Kallweit (3):
  cxgb4: remove unused vpd_cap_addr
  PCI/VPD: Change Chelsio T4 quirk to provide access to full virtual
    address space
  cxgb4: remove changing VPD len

 .../net/ethernet/chelsio/cxgb4/cudbg_entity.h |  1 -
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 21 ++++---------------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  1 -
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 --
 drivers/pci/vpd.c                             |  7 +++----
 5 files changed, 7 insertions(+), 25 deletions(-)

-- 
2.30.0

