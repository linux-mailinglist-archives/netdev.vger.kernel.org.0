Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF0D33903
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfFCTWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:22:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43659 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCTWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:22:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id r18so4293574wrm.10
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 12:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pCadAAGe96Q6lbm6CtUFHmcyUPDNvmCtd0zZ/A8OwdY=;
        b=SPvVXYuwEFk5Soi5yu1Rv/RMPwtUye9LJvZaXDWPTICKRGsiK2i7GeUM2gGTLU9MFk
         9zvEF/6ZBwIppu9zjwOQZJ++p9wlWNzdDll2RUGqR8LZYzSZ00NCjKOKKZ8wlFeOf98p
         PiYhNLIkJwXzwchvX/rR0qBIAgKjlDsQPTZzfhXrSN/RtudMk+Dq8e7/TUL+eYvYl2oF
         xnV1ddVinWRaaUr1sa2Z37Xq9RnKJTcFQo/HfQPGGNed4YOenMOxyMOFjOeqVZIs0u2c
         Db5vPLJ4JWtt29Aa1mORXf07ssbqIU05N/GY3yRLzzpHWdP2rDk3CZ4D39aoOGOhKbxu
         KqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pCadAAGe96Q6lbm6CtUFHmcyUPDNvmCtd0zZ/A8OwdY=;
        b=ldL2wfzQxRDoOsmbeXe2xddlHS5/ZtFadkEvlGQyak6NLeMZ1+XEEJ5SM+gn8dsB+J
         8ARU3ptsp5tebp0V0j9nEgnzt600qPL8a4JI12YQdFVzv3D2TwxSiNcEnjbjc/mjsTjj
         6MaaTCFr8aaoWrt0AWDcYRw2GVLUG2JdbgZ8QRrT2luJgX1Fo4i8QL8WNjwfOvIW8/Vl
         SwAkLDqV+HeLtyafkjhN0h/JrthDkZE+k4VbKNZ7Z90Rji19wrnG0YmnDVcA+pRoMd7A
         B2H6lvbKjJvk7FlvEgu5pI6ZcpkI/a/ouyP6jZErTaaayKbZw0XeCp0y0oansMacFDtu
         NKTg==
X-Gm-Message-State: APjAAAUxBGKjeB/YAf6b1iRy6HTfN7Ez51ApOwxh/7X/LAhibrizy3sY
        PaBYkmCKTFb3CszT6v7XXvh4kB5f
X-Google-Smtp-Source: APXvYqwxLXVh6ZfgWfMZHo7O5ZFXpO1a2WGL+1t7LaOHRi6lIXiwa2wX1/Osk5nYOiYYP+wn8aOHAQ==
X-Received: by 2002:adf:eb91:: with SMTP id t17mr17743566wrn.203.1559589772582;
        Mon, 03 Jun 2019 12:22:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:2453:b919:ed8b:94f6? (p200300EA8BF3BD002453B919ED8B94F6.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:2453:b919:ed8b:94f6])
        by smtp.googlemail.com with ESMTPSA id y133sm12790492wmg.5.2019.06.03.12.22.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 12:22:51 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] r8169: make firmware handling code ready to be
 factored out
Message-ID: <7c425378-dadb-399e-0a51-f226039e441f@gmail.com>
Date:   Mon, 3 Jun 2019 21:22:46 +0200
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

This series contains the final steps to make firmware handling code
ready to be factored out into a separate source code file.

Heiner Kallweit (4):
  r8169: add enum rtl_fw_opcode
  r8169: simplify rtl_fw_write_firmware
  r8169: make rtl_fw_format_ok and rtl_fw_data_ok more independent
  r8169: add rtl_fw_request_firmware and rtl_fw_release_firmware

 drivers/net/ethernet/realtek/r8169.c | 165 ++++++++++++---------------
 1 file changed, 73 insertions(+), 92 deletions(-)

-- 
2.21.0

