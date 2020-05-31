Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D951E976E
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgEaMIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgEaMIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 08:08:00 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2396DC061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:07:59 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id k11so6530745ejr.9
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=phEvEYNdksjv+GIWpIOE09HshmlyCeEPRoGC5EIVIjE=;
        b=m2zleDi3rYtD1hosTAYW9S95R2tJtlMBJzJy1rIucPITIaxgZ4clS6OTknO+sCtbLl
         YB91kh2leHrr9PSkT8ygR82gRtjexIRm+z8/V2iRI04O1hz5TKxd5AmehBHPfz/Sx9Hd
         VXWPb11hLgE0mxxTvD2C9zF8EBtaQ6vu5Yv0CYuVaXGK0OLfhONK1CnBU3/gWkH1yFlx
         4vTV3YlEJpWWfrRbVaMjQshkgq9AdsjRjtGL76LDGLfEibFsUB9c2fjTFcpCSq8t3c2Y
         XcPSbjvsEtJBIMu7RTIkG9n/JF0KIrw24A/HQ8SZyLHp+OrSJPPEt2J81y24pLAPOxyc
         qvew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=phEvEYNdksjv+GIWpIOE09HshmlyCeEPRoGC5EIVIjE=;
        b=lrBsWdgCcQStTLtbhZgcullOLRSkrbHCBp8tRGvAs+CLXpT6+WheEXY0FQF8sn+Vk+
         FEwq6uxwuAX+LMF/T2iDmIt8SnjYDTUivhgRhjnGf1NJvYn0hfL2nuWsNEbOAqNy8mHA
         ZhR0XPsZHbcoJdtOy0F3osRgiH5RHqUmSr6YrsbT/lJ9c540MG/nBeYa/lvM1aMxjTIx
         16TMNCcWvc7xn+emwDP7TSasrHKE3LV5cLc4feXN2AHm/l2XgBwO8plwASUb25PVjjM7
         Xft9tAZgT3uVxnrmNnM/PCHzsnuMWiEFbtPEdgSjXaHpw2rOrpkbC+s8kVutlkywp+bi
         eTaw==
X-Gm-Message-State: AOAM531ZBkxQ4d9JHjDswHrk3QMLv9TryuN6VGrGVgO7yesGid4dnbdZ
        oOmgvklew170eKDqLanaaKh2Q1W0
X-Google-Smtp-Source: ABdhPJzo92SkXvODiqh8yNR2lhYTMKQu0f3lQE7fuk2tJVQc8K0Y4EEUARVq4Q6U3YsTHnUjfeMmDw==
X-Received: by 2002:a17:906:470c:: with SMTP id y12mr15499449ejq.336.1590926877631;
        Sun, 31 May 2020 05:07:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:a5a8:2d13:1520:7eae? (p200300ea8f235700a5a82d1315207eae.dip0.t-ipconnect.de. [2003:ea:8f23:5700:a5a8:2d13:1520:7eae])
        by smtp.googlemail.com with ESMTPSA id j16sm9055851edp.35.2020.05.31.05.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2020 05:07:57 -0700 (PDT)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: netif_device_present() and Runtime PM / PCI D3
Message-ID: <d7e70ee5-1c7b-c604-61ca-dff1f2995d0b@gmail.com>
Date:   Sun, 31 May 2020 14:07:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just wonder about the semantics of netif_device_present().
If a device is in PCI D3 (e.g. being runtime-suspended), then it's
not accessible. So is it present or not?
The description of the function just mentions the obvious case that
the device has been removed from the system.

Related is the following regarding ethtool:
dev_ethtool() returns an error if device isn't marked as present.
If device is runtime-suspended and in PCI D3, then the driver
may still be able to provide quite some (cached) info about the
device. Same applies for settings: Even if device is sleeping,
the driver may store new settings and apply them once the device
is awake again.
