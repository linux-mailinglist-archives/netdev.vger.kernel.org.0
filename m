Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A42E2EF1B2
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 12:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbhAHL4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 06:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHL4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 06:56:22 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E66BC0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 03:55:42 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k10so7588733wmi.3
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 03:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=7EWxshdvzngKbBX5brO0Znd8cRcJoh0Yy5cTscWLjIA=;
        b=O1Pv3s6nhLDOrSIQXH3wawNaVKPb5m+zOGiK5N6nFGqhoYQqr3VIKuKEFugSi7HY/5
         P1qlOno/M1vgRr+BxOc18B5omSHTfDibQveZP3EUtx9l4d3W8AcVGVFnAKPY0w4emmN6
         Du+3xQHNmAlsv+nUSxzGtLr7DmpYVMxM6s788mMbEPEahVcEQ4o7RcLE3JF0LngwX+IX
         LKyC9VunV09ovw7xmjADXU+p2IxtAdxcgE0r0EwUIUNLQPrCjEmFCjA16MexI3AnfeXn
         /Y/tgJZNeNjc1bUHfGUdkegpqADvxIDYLlUw4famQekf8Tb5OUyFvnj0z9VOG+UG9VR8
         cQMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=7EWxshdvzngKbBX5brO0Znd8cRcJoh0Yy5cTscWLjIA=;
        b=X+jVJPPB9AHY5wf1g7m0b7eLBZZL5Ouv7Ziys5jCGdcw4g74IM4JqfLv0B3onpjD66
         xk+JDPrHxn1J/6zSeHgRB+IMhSHbM3K2/4Y2mkLHQTcOZtJ/frhhwMQfM3UrrpwfQv3Q
         lDy/ycqzKRdhp6T+bOtkKAvN7VL9qP90hclDJDI9pou4DIS+5tNg/XqjBE4R5KhSh+a9
         vO/EdEiKRwsXO/BhVUk6U5xUlNLXsiVFfGdRpDhCN131SZyXms8y2d2fJqs+76s6/D6j
         zmORnaaKLABO6wfzD6uc/GDVIgXrkOv+8BDakr4h2IHKlrZMjTP0izxLgJVtHSbSXzZJ
         II8w==
X-Gm-Message-State: AOAM530QLAFWZILefyGsxgfIwgZ1sWL+C3mCM53NAxQY23HnW8MRODSh
        emPQPELbyh9gOuR5x7GzwpeTsQ5cb+0=
X-Google-Smtp-Source: ABdhPJyj/OXn5OcKJNEr457AQqnXK5N4v6Cxf4V+YAjRYjpy6HKIlkWB3hBT3pbrklto9vlmbiGelg==
X-Received: by 2002:a1c:4483:: with SMTP id r125mr2662787wma.80.1610106939281;
        Fri, 08 Jan 2021 03:55:39 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4? (p200300ea8f0655006dbbaa764e1a5cc4.dip0.t-ipconnect.de. [2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4])
        by smtp.googlemail.com with ESMTPSA id m8sm12531570wmc.27.2021.01.08.03.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 03:55:38 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next v2 0/3] r8169: small improvements
Message-ID: <938caef4-8a0b-bbbd-66aa-76f758ff877a@gmail.com>
Date:   Fri, 8 Jan 2021 12:55:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes a number of smaller improvements.

v2:
- return on WARN in patch 1

Heiner Kallweit (3):
  r8169: replace BUG_ON with WARN in _rtl_eri_write
  r8169: improve rtl_ocp_reg_failure
  r8169: don't wakeup-enable device on shutdown if WOL is disabled

 drivers/net/ethernet/realtek/r8169_main.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

-- 
2.30.0

