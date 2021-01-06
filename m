Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1252EBCA5
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbhAFKpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbhAFKpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:45:43 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25C5C06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 02:45:02 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k10so2053913wmi.3
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 02:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=CFa9IIBCcCV1TWWcbkI0g56e3WbaZgQhuUzvzGj/9ds=;
        b=SFg10qa75Lsox/usexee8Y29+MICLSOmspXLYMNmmh6yI4+fcHmvOBu/enRaFGtzYm
         BgZc/Vz3saPdK8eCi+Y43EcTCOs1FRr1hqLY8wPKPfs3YSwHh7KGXK5wSEDcGnDtx7eH
         J+NFzj/1YC/sVSkaM0vPLGe/JoTlRqH/NOPNwFk4u/SsKJG8xhBJyBHyFR2FsdKGwToa
         HeZ3e40jiqvPVNrNCoeyyTFbOiBw5JPmVYWbfQpRQuTZ9h4DXUYQ1yFrUUa7dQNP4XRu
         anWyN8Gvl1mVbpGyU1hCcWY3sUaE50FtNSDEF/yxPR/mfalTAfIJZl90tOCqC6zf7u7X
         GRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=CFa9IIBCcCV1TWWcbkI0g56e3WbaZgQhuUzvzGj/9ds=;
        b=MDYRh6XfLRjSkg1n/+5Sx63aivoh2BUYUpFoERGvStd75zUY2kOuPdgZ0vV4fnUaOP
         4xrZ39dcdVcUqwbdwaOSr1YHSkIHsJeu3UHcdbLNkrERi7WDAL4ki1hAdwY5+ZroE1hx
         RsB9XCmMorzO4xEd17PoU3YHx0P8DjcK3uIZj4pNUP7OSQupvs24e7qI4nHBt5JBfovZ
         +Hx17YqcRuwUIXlzxTQPuNBCGK6oj3pHuA0V2PlsqW/ubrEND5kbTgcCFdwNDrHf59mP
         v66XIgqtz14IWaOGN1wg0Ju1+34u1F/eDcYfjWJ2gT2/21lOS43edilpDlWqwnaF75i2
         UoPQ==
X-Gm-Message-State: AOAM533UOk6rZvzgkN+E5CKCUd8SnwD/ryx5Xm5sYUH7t/7Y4Sfi0D+A
        mcl3/gTfUuhUV4Fx/WPCX3Eou7hVX6s=
X-Google-Smtp-Source: ABdhPJw2aaUdQURvnZ35oIjZsFfaUmKnAMAGtorRIiUHVSEbEgzhum2+UeLY+PQqCHWBewjGq2E8Qg==
X-Received: by 2002:a1c:790f:: with SMTP id l15mr3151169wme.188.1609929901189;
        Wed, 06 Jan 2021 02:45:01 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id j10sm2700563wmj.7.2021.01.06.02.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 02:45:00 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] r8169: improve RTL8168g PHY suspend quirk
Message-ID: <9303c2cf-c521-beea-c09f-63b5dfa91b9c@gmail.com>
Date:   Wed, 6 Jan 2021 11:44:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Realtek the ERI register 0x1a8 quirk is needed to work
around a hw issue with the PHY on RTL8168g. The register needs to be
changed before powering down the PHY. Currently we don't meet this
requirement, however I'm not aware of any problems caused by this.
Therefore I see the change as an improvement.

The PHY driver has no means to access the chip ERI registers,
therefore we have to intercept MDIO writes to the BMCR register.
If the BMCR_PDOWN bit is going to be set, then let's apply the
quirk before actually powering down the PHY.

Heiner Kallweit (2):
  r8169: move ERI access functions to avoid forward declaration
  r8169: improve RTL8168g PHY suspend quirk

 drivers/net/ethernet/realtek/r8169_main.c | 180 +++++++++++-----------
 1 file changed, 90 insertions(+), 90 deletions(-)

-- 
2.30.0

