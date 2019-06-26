Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2A356778
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfFZLVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:21:13 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:42930 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfFZLVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 07:21:13 -0400
Received: by mail-wr1-f51.google.com with SMTP id x17so2266848wrl.9
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 04:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1gg4VMZTAr4VV2hAuc3LXRvTeD4Jg5fNDTH+1pwJPTg=;
        b=ezlRIobg2RuqKpKkd08dq2rS0FR6N0NOkpaJnOk4fdzu9flXxFtmbckeClhf+Yi+CA
         U835/w4SFyTrNT3VqJhOpMRP8Xw6LAqYLD6r29vaPU4PPAFz7M+B/67E6EmqfwIKcUm+
         oiRqDLsu8X2VoXLoRtXwbP6gsfKsCsQiDB8IPgUBKPCsha+xdK7HkvZZ2eiT9tgNG4qy
         tZjFAOoDpHpvGO3a/4Lni1MFQSuaH2HKhyAlEGnD9S60GCNuK+6N3aQVA7m6/x0mqETD
         51c+8pMMj6hFX8BEjHQZzODk+N32aUCzxYJG595wtt3osKBI4J+sWakYaEH0W/1X1yJI
         J1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1gg4VMZTAr4VV2hAuc3LXRvTeD4Jg5fNDTH+1pwJPTg=;
        b=Kcc2DkW+MEguwtNsPRl7m2Gkjy2J/XRTdVTGxEDjpTuRditL5P7PZ3fZCkhUMyjjhM
         3bgHPasu7HQeQysimCEwu2hbpoZzYqwJ2e6rgoT4LZqSyEaNdj/3FtreIdfQ/gN6gL3q
         9LfUJc5TzdjjDuCeiTazzW/Zoh28akzXcuXZAJ6F6eoimTIkNUqd9/HqKIV5d/Oe0aF9
         kPZSiAPAkofdjnk5j4tFgPjUUvg/NyKG8J86A+mvlvQ74YtjEYCTniYK9ljlsLP0+AKT
         vK3E+HR9xAFHTc8JQGhR3cAoOjtsvOb+/yr/d1EAfJvb0q26iae63QAn+LebhhyKFaPZ
         tBAg==
X-Gm-Message-State: APjAAAV/auS0dWAS4t100inPi3HuPauYI2Pi1MYpltbsFifG7WLn9fzO
        7Iie2CNqf3dIy1f3ibVCZac=
X-Google-Smtp-Source: APXvYqz39P2013+Yumry/WCEBfCKVjUCxZ2KUbH0niamW2dCnZESJjSlEY+VNE8AFVq/Er+S45NmRQ==
X-Received: by 2002:adf:deca:: with SMTP id i10mr3267727wrn.313.1561548070878;
        Wed, 26 Jun 2019 04:21:10 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id h14sm6233701wro.30.2019.06.26.04.21.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 04:21:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     rmk+kernel@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/3] Better PHYLINK compliance for SJA1105 DSA
Date:   Wed, 26 Jun 2019 14:20:11 +0300
Message-Id: <20190626112014.7625-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After discussing with Russell King, it appears this driver is making a
few confusions and not performing some checks for consistent operation.

Vladimir Oltean (3):
  net: dsa: sja1105: Don't check state->link in phylink_mac_config
  net: dsa: sja1105: Check for PHY mode mismatches with what PHYLINK
    reports
  net: dsa: sja1105: Mark in-band AN modes not supported for PHYLINK

 drivers/net/dsa/sja1105/sja1105_main.c | 59 +++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 2 deletions(-)

-- 
2.17.1

