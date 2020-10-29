Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B8029F335
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgJ2R3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgJ2R3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:29:33 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25952C0613D5
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:28:59 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v5so598553wmh.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=PnA8jzIEuTFtJjEgsmvrwqFY+148FJUCFXRwrCY31bo=;
        b=T0cz/8+JmyyU+vLplok/3CPhgebaCNDl1H+XPiJMS2qFcmnVEmaHj8OzufaAUuqGYn
         G0qtFS/97CUBYFHXVNHDEXP13BqOwG+ji5q0pk3KAuRb03OwlXRvo8PdM0JorJ/NzwqG
         Cjk7RzEdtfCBWNqV4eiTfww0QMVgV4l1I8Hmhtzjfmm4P7xqKu1qcbLi5rigjY2EnECh
         prlJqI1LwvZcKfEF4Gnwwzy/j62KbL6ZKaQTCC2pJ48gt++Kms96i/sSDhGMDsrvFeSe
         a6984oPZWJlhFRpAo3pvxbjaZrLLPcn8OdvXI3/+RBeALwIw8okRWjMjqbIoFmI+sugc
         D/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=PnA8jzIEuTFtJjEgsmvrwqFY+148FJUCFXRwrCY31bo=;
        b=iwbur+3CcipcI9OeXo7vG4dCQXevKVdRboPmflsD2zCyM9sugDmh1pVBuVd+Mmpf0T
         JQ/Zs/DPW+ltUXR59ZXoZlbNIsnvFiLwjZqQteABqa0cxlMcD2PU1afd6baCUCTqUtQn
         HU6LtTaFwxWwoI6M7Rk3+kWZdmisoJe+kvqoCSHSkw+E4xsd39DhrQiUCvngRbtA3rYg
         MtAvehDYsrwLPQ3JQZaHLKq729TTaZxcKOl5p7s6FnsdRlBmeBtoDmsW2pmVj26oCkzz
         DGBWuDf7P5MYGN85m1tJZ2f6cME30OTujZO5J/xwmMO4aGMgzW/gA4cHzp+/WLw6vcfo
         RWwQ==
X-Gm-Message-State: AOAM531tZaXwfmDXogcaTE44CTPqhm9MisNldar0MSnnwHSsqZq5codu
        KwtYVTWWnrrBwiSgNjzh09Gf3PjLwvM=
X-Google-Smtp-Source: ABdhPJytx/seY1VgwuF8BkpAvsarGJiiYDBA4be0z1zdxOQWHnMkc7EOLT2SaLd+21enYqz79a5nyg==
X-Received: by 2002:a7b:c157:: with SMTP id z23mr980545wmi.70.1603992537680;
        Thu, 29 Oct 2020 10:28:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:a990:f24b:87e1:a560? (p200300ea8f232800a990f24b87e1a560.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a990:f24b:87e1:a560])
        by smtp.googlemail.com with ESMTPSA id z76sm856239wmc.10.2020.10.29.10.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 10:28:57 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] net: add functionality to net core byte/packet
 counters and use it in r8169
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <1fdb8ecd-be0a-755d-1d92-c62ed8399e77@gmail.com>
Date:   Thu, 29 Oct 2020 18:28:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds missing functionality to the net core handling of
byte/packet counters and statistics. The extensions are then used
to remove private rx/tx byte/packet counters in r8169 driver.

Heiner Kallweit (4):
  net: core: add dev_sw_netstats_tx_add
  net: core: add devm_netdev_alloc_pcpu_stats
  r8169: use struct pcpu_sw_netstats for rx/tx packet/byte counters
  r8169: remove no longer needed private rx/tx packet/byte counters

 drivers/net/ethernet/realtek/r8169_main.c | 45 ++++-------------------
 include/linux/netdevice.h                 | 26 +++++++++++++
 2 files changed, 34 insertions(+), 37 deletions(-)

-- 
2.29.1

