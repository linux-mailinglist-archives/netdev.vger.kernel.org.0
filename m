Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD61493BE7
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237644AbiASOZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbiASOZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:25:36 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E10FC061574;
        Wed, 19 Jan 2022 06:25:36 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id o12so9960817lfu.12;
        Wed, 19 Jan 2022 06:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bDLBp02jeXk2Kbm1icyCtGEPU2BJF/wbtFBRUuToY6c=;
        b=OZDPmDyHKoazYm/WmmtX/T2OAceyVmvcO7d4wf41meruGWJV5sdApEAPh8kdVeuIw4
         Oz3xBH1+RgtcTiouKCakWfEw1J57aPAAWlkjJ2VeP6kSBzByxEuCXnALkCgTGbcDWBml
         WcElCZO+HexYIvbbyJYltFEiwDoaPXMbVRANVuCR3uT1QgfpjDa0lrnrhOPI/sx6gn6/
         /MWEt/9MC/0YqDO2fn3+u6tHOG1chNvJsaXZIhkYyzCsccs6w3j93ws74b73OmEifDU2
         ZH1b2236DPokUMxyUm5w3hsCs+b5bok9k4A5RWbZw1bp5mC4aX+UlQfJtloAhZUtrXCg
         Nclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bDLBp02jeXk2Kbm1icyCtGEPU2BJF/wbtFBRUuToY6c=;
        b=BA+71gtkspEf1I5unUuvS6CEMCnbOtmD0krhD1cemhJ/o5xskYcrGAw4PkFsM8nW/G
         UeScOAhrattuInY28ZlGMRahyCmPKTffN87w+cMVI17nfc7H7/amoichDaklj3w+RkRC
         JjqLtRbSu0/oxM+mBn4Pi8g9+oc8QD8ZJg8Rlifo6iy67pdPQD33ZqBcGrcZecrIT2Fh
         MqDmyaAQKDybmvPOIPjt8tP3gPgv5/xJb3mGVOmY1AwvikvuAysbW9iGcs/LtLBhgx/t
         apBbbKc4aQMmK2XWacjwtyC4shn6rL61a9olrswOOUe+lCXxi6dMDTLCuMMxgkB4TaI5
         6llg==
X-Gm-Message-State: AOAM533mRLqfPHoufYryjA+F6rDxIXXZMwUfOpm2o2gTibtvQF94ghSR
        MWRGByXCsZZzrcou2mLHl3u+TDLOick=
X-Google-Smtp-Source: ABdhPJwhg/02sy+FSDpuGEhZThpslrqLvI3lbHlzTAco2V4/+u5CywUEhSPu73AOY2STvE529H1c/A==
X-Received: by 2002:a19:600f:: with SMTP id u15mr26216930lfb.633.1642602334616;
        Wed, 19 Jan 2022 06:25:34 -0800 (PST)
Received: from scuderia-pc.olvs.miee.ru (broadband-5-228-176-108.ip.moscow.rt.ru. [5.228.176.108])
        by smtp.gmail.com with ESMTPSA id p22sm1177663lji.21.2022.01.19.06.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 06:25:34 -0800 (PST)
From:   Alexey Smirnov <s.alexey@gmail.com>
To:     ardb@kernel.org
Cc:     arnd@arndb.de, davem@davemloft.net, grygorii.strashko@ti.com,
        ilias.apalodimas@linaro.org, kuba@kernel.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: cpsw: avoid alignment faults by taking NET_IP_ALIGN into account
Date:   Wed, 19 Jan 2022 17:25:32 +0300
Message-Id: <20220119142532.115092-1-s.alexey@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118102204.1258645-1-ardb@kernel.org>
References: <20220118102204.1258645-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doesn't CPSW_HEADROOM already include NET_IP_ALIGN and has actually more strict
alignment (by sizeof(long)) than CPSW_HEADROOM_NA?
