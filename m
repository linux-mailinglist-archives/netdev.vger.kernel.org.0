Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7818451649
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346515AbhKOVSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243275AbhKOU4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:56:44 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999FFC04319B
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:50:22 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d24so33247139wra.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 12:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=JTAIUv3sbdsberOA06QnS5pTCX3jWpXQ8c5R3a9lk08=;
        b=GkOoSVS8lnqUDbJ6pvDlUtMrxoaGlZm4IdG+DU9GCKWgdScrWQ+7yUKp08ibRld1tU
         ZPE5B/JrVjYGwUip6iu9fxS0DK1oG0WwO3sql3tBHG8vgrMPxm4f40xCVUpTcaRd6PGF
         BESzZPcminBxcHxXo1XzdjdzYQV4LmePmAiBhqDYclW6qIwcNZavC1CI6jT4+xSi4Bmx
         wNba+j29tXd1ZsZw0CKsT4+ETACmRcLl+61WKi7HqgWZzBsqa4jTGj00eWOD/K3Umffo
         QDvEtDRHTGGbiX4PYgtPzicedXdwb5LX8M88gzNLhORlczP21672ldlX/1cEocZnXvVf
         qRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=JTAIUv3sbdsberOA06QnS5pTCX3jWpXQ8c5R3a9lk08=;
        b=L9vtDiMlThVbJCuvn+Y+CN9aHioY09VkqpuTmBvE/yfes8VcNtQzwREtPotJZcMFAx
         jM0TExgE2ODSgMnPHb2xROQyyD8TWZ/aWIzKlzgm5D4i0zaRzzmwckPYClQ14RuynywF
         65NG6pxEQC9l1uZw2RtmiOcYXXYyzF9TEuU5JirI64gMXtvAg4Z57lUtHSV4KUFTZy9b
         Wf8HZyUTv/Ribe5WYwmbmjzxPjoijCHfMzfKIFQORMRlwbr2JXVoHtmOZ03WoOY0PPdx
         AocF6qbXm6rNirNYroc5DJtVaXzXkVIFPJXOs8qrIm0fg7LdBBpup3fkkc3c5NoZXOKH
         GbQQ==
X-Gm-Message-State: AOAM530lAHeB5Ukm/RyvaYg3nqB57Rn30vFxIniv+pf+EcVq2v6SEg29
        n80Dj/nQexrvoBFVSX5rC2EvvEDuyNE=
X-Google-Smtp-Source: ABdhPJz2djy/89/HUxGm+Yn4G6NlYdYtH7owrLAQQOuKYffB3d6vYToLWXcBPiOpwMUDc8623PJQxg==
X-Received: by 2002:a5d:6151:: with SMTP id y17mr2456193wrt.275.1637009421289;
        Mon, 15 Nov 2021 12:50:21 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:a554:6e71:73b4:f32d? (p200300ea8f1a0f00a5546e7173b4f32d.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:a554:6e71:73b4:f32d])
        by smtp.googlemail.com with ESMTPSA id z6sm15763883wrm.93.2021.11.15.12.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 12:50:20 -0800 (PST)
Message-ID: <7708d13a-4a2b-090d-fadf-ecdd0fff5d2e@gmail.com>
Date:   Mon, 15 Nov 2021 21:50:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next 0/3] r8169: disable detection of further chip
 versions that didn't make it to the mass market
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no sign of life from further chip versions. Seems they didn't
make it to the mass market. Let's disable detection and if nobody
complains remove support a few kernel versions later.

Heiner Kallweit (3):
  r8169: disable detection of chip versions 49 and 50
  r8169: disable detection of chip version 45
  r8169: disable detection of chip version 41

 drivers/net/ethernet/realtek/r8169_main.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

-- 
2.33.1

