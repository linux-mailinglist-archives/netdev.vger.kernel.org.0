Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77162E51E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 21:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfE2TNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 15:13:12 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:41953 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfE2TNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 15:13:11 -0400
Received: by mail-wr1-f46.google.com with SMTP id c2so2529434wrm.8
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 12:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=rxV+NICysnWvVQQ+EnUl2poL6/PgJzJsXCTfYXa1Bv0=;
        b=bipXf81ydSNb9GQfTgoZkm/DvGsM8Uug9PfOkHSMaZuNLKBP23BJBmU04yqvm0mzj4
         aF3wfnfaSVqOPG30d4l1mEX860jIp5cbQCHRyiKvoQLqfsAOV0F1wKWe7t2KFLHSZNXv
         PqfFqTitVZXXmWxZPFH7naCg9JK0mIM0KcnjDv+GkKrAQMvzkiahqq0kNPHDrZZSA1wf
         CUALJyQuLJQrhJcVFkYY3OuluuHUUxoxQm1pucUuFJB02QR7FvoIRq77QhGk48UNkp2I
         UahdLztzhOcDp4ck6rU0IWbm1gMjX+0K92bJwHJhWZFxXUeOP5Fmp8MNSzgsKUC3TyC6
         PWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=rxV+NICysnWvVQQ+EnUl2poL6/PgJzJsXCTfYXa1Bv0=;
        b=ZdCfbxT4OLaeQxAJaPDddZuGmXCMeqT9a2hFQS/GNu3lQ7dAga2ivRZX0itDIMO1ud
         pBpmpYxtuPYxwKPOdYHdk4hMuN2SKO2AHrVCGsvtXGfMECR7q/QrUVgXbaVtHsT1qdCE
         DXFIqhF7NDBjO0TlEll8YHMHrp4xjwcH/mPaC07rAEfUxij7BEmrJBfFizCvjxqyfdFj
         6eJMgv2drVdZv2JnSnPhR2hUPrmH83tTpL7RfeiZu7N6i4kFtgtURJVJe3glpPUun4It
         UlP6UFO3Af3lLdx9blCAynYVoPg+VX8A5m/FzZFHalfCMXGPU3jfa2h2uxWw2iKUUTCe
         8N2Q==
X-Gm-Message-State: APjAAAXreZrl3eHX7JbOV/FPsz1WgRGa2kcM8i6v8VGlzJczsepipdI9
        nwNr7Xo0Xs/DXPaba3vgX91BDT1N
X-Google-Smtp-Source: APXvYqy1yLT7VzTj/lfUcGcqWFMoRnGhE1+5cMqfsmABeXUX8MwmAlwr2zBQjD12O0xYgwjDS6Jleg==
X-Received: by 2002:adf:e301:: with SMTP id b1mr20297099wrj.304.1559157190033;
        Wed, 29 May 2019 12:13:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:c13b:48f0:87ee:c916? (p200300EA8BF3BD00C13B48F087EEC916.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:c13b:48f0:87ee:c916])
        by smtp.googlemail.com with ESMTPSA id a124sm399810wmh.3.2019.05.29.12.13.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 12:13:09 -0700 (PDT)
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] r8169: decouple firmware handling code from
 actual driver code
Message-ID: <57c46ad0-f086-7321-aeca-8744a607b622@gmail.com>
Date:   Wed, 29 May 2019 21:13:05 +0200
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

These two patches are a step towards eventually factoring out firmware
handling code to a separate source file.

Heiner Kallweit (2):
  r8169: improve rtl_fw_format_ok
  r8169: decouple rtl_phy_write_fw from actual driver code

 drivers/net/ethernet/realtek/r8169.c | 71 +++++++++++++++-------------
 1 file changed, 37 insertions(+), 34 deletions(-)

-- 
2.21.0

