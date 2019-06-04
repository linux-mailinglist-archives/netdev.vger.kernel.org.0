Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D2133E88
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFDFpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:45:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33530 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfFDFpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:45:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so1936568wru.0
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 22:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YYHYafmvXP1IkMMGWkqo0e0ZfKMryy8IFFLWyebYOik=;
        b=BOHSjJ8JYtgg6GR0LIJCnXqYCEVYJr/gSRafbu7Nq5osiIpuiu6mb3/35HJc2XIt96
         JUy0aEQn1iSIWU2jpe1Yfr3+2fjFNrimabYdtJhZzDkXIQ+2fTyZHR/qyPmbIhR66Xbp
         NtiN5uxICY7EZulN1APARZ9RZM/yiOiVt4mH5j4KmXWMJx9/k9LYcRCiFmtyreBBu/3d
         JMSsWIwqDHxaGHsRLvPhT37jPXTmighDUkPdAd1dDyPTICwK6sKmu8Wb50S8OLaMISFx
         PeIfIRStqtewKIVFz4FuKkxGMCoP3TkpaxytecBt9qNyCfFmp6sJqC+vbmfAiJVViznm
         lNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YYHYafmvXP1IkMMGWkqo0e0ZfKMryy8IFFLWyebYOik=;
        b=IghYsTO0YkZIG2YM9zbrMIkMBEYq0BfAXkqhCb7DBt6+yJN/lZs6MbcjFc85w3tOz0
         dSx0Kzqngrd13wdVoOhHyikedCtn57mYrXR6+tu7+HN1tME5hH0vHwXIo6BTIKZiSp2Y
         AMThlhyWRG/a5kxohT59rGjIefZ5yPJ7xhS9XkVp9bKd/lzqW6s++z8m2Su2khM0mGsp
         +wmyWCH0rH3WwWSSL/jaHFAkajzzT1rLvsHQ7SRaLIXh0647PejdQridCTP9bPZVEXai
         ckRmA+uCXw0XHpLiZEIgEJ8Q0L+HTfxsROL/9N5kMCsR/9zFKLLAgSH3kbqUHjWrE5s0
         mB2g==
X-Gm-Message-State: APjAAAVNUc7iJWshRrPrlszdUhe92JalDa2fAfFZSO14aFFxByFBCc69
        RjAJUH7GNC1dwv06BeK+aivWLXlX
X-Google-Smtp-Source: APXvYqxbyzeAwnmRu4cl6f6xPX3yFqU+T+rf606KyZjSu6XUmoKA6HrKU+Kj1cgr2caxPcg3HOJ9eg==
X-Received: by 2002:adf:8b83:: with SMTP id o3mr17865694wra.278.1559627099801;
        Mon, 03 Jun 2019 22:44:59 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:15c:4632:d703:a1f7? (p200300EA8BF3BD00015C4632D703A1F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:15c:4632:d703:a1f7])
        by smtp.googlemail.com with ESMTPSA id 88sm19987231wrl.68.2019.06.03.22.44.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 22:44:59 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] r8169: factor out firmware handling
Message-ID: <3e2e0491-8b0f-17e1-b163-e47fcb931eb5@gmail.com>
Date:   Tue, 4 Jun 2019 07:44:53 +0200
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

Let's factor out firmware handling into a separate source code file.
This simplifies reading the code and makes clearer what the interface
between driver and firmware handling is.

Heiner Kallweit (2):
  r8169: rename r8169.c to r8169_main.c
  r8169: factor out firmware handling

 drivers/net/ethernet/realtek/Makefile         |   1 +
 drivers/net/ethernet/realtek/r8169_firmware.c | 231 +++++++++++++++++
 drivers/net/ethernet/realtek/r8169_firmware.h |  39 +++
 .../realtek/{r8169.c => r8169_main.c}         | 243 +-----------------
 4 files changed, 274 insertions(+), 240 deletions(-)
 create mode 100644 drivers/net/ethernet/realtek/r8169_firmware.c
 create mode 100644 drivers/net/ethernet/realtek/r8169_firmware.h
 rename drivers/net/ethernet/realtek/{r8169.c => r8169_main.c} (97%)

-- 
2.21.0

