Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F32479994
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhLRIO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbhLRIO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:14:57 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA39CC061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:14:56 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id 193so4503145qkh.10
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+lWS4eDkS6D1ZTPBeDbltZDNnUJw6QNu1olBKvyNh1Y=;
        b=g6fSd4dJN4TW93MyvxQu4b6U5F8zPu/ijBtl0ZeXh4/RQTqDdYjnksg9II1T8cas3O
         Etyv0FTnSHM5w9YvmtiAcscq+KqGEu9virz9gsL8v1JMuH40N0nFSfASztTyqFER45g7
         yi+ynoOwjcmcJIu1kGV/ujMFwyTsbrXnPVIYy9HsXmv7nnY6+V8c5Eda0TrNu4ktX3E0
         +Vcsw7T4FFhE+e+7VschpOmASeXNSyuNkDh3IlBArOAD2UxFqji05KsbSt6JDEtQXUxB
         Lyc2OD6jWbugmO/TerB/FbWyu7MVXB3WSj93sYbCaidjaObsQifA11KhXWpikyxU0e/p
         do5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+lWS4eDkS6D1ZTPBeDbltZDNnUJw6QNu1olBKvyNh1Y=;
        b=kHrWh3Ux6aYDKKGS2FoCQ3jatVJveAlikIY/FtTp9fpvSPfd0xB12nnqNkQIjPy/RB
         1AmBN97l0mHZ9jMSrVAFqa1Zhsq2HTE6vPDTBQ3i8+CoHBR3rjBXDaIpuU9f1DJJnZFf
         Jpj+UAoCAYwXOeqf/2Pc5u/wiZV6aFvZUvOAKe/3EqBKJT+deFLPR3P8z7wY9HMBW48W
         aSlisz0Z2bsr3NfoIMzenLR/sI04BycIDDu7xUZKu6s5RmspoyZaW0atWp3M1xoEup+a
         pzQcXXbJ1Dx46wCsjDyi7Vg3morEJsst2DvaYWJiG5RrcSypYSMfpNpJgBYcH9eYRsvA
         2XGQ==
X-Gm-Message-State: AOAM53231F8dHraagXMe7IlHO39ULvxF95ZzFgSITG2gi67Ro35urWOR
        t7EwR4XiiNe8u1l1+OWQRG+gnlbjCII11Q==
X-Google-Smtp-Source: ABdhPJzNUfw2ZrDUUu8s3sLh26Ir/xSQxZt+0swRIBbHduej5D2PAWbltnsza3nGDINMEenlnNxDWw==
X-Received: by 2002:a05:620a:4251:: with SMTP id w17mr4048119qko.284.1639815295799;
        Sat, 18 Dec 2021 00:14:55 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id f11sm6423357qko.84.2021.12.18.00.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 00:14:55 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: net: dsa: realtek: MDIO interface and RTL8367S
Date:   Sat, 18 Dec 2021 05:14:12 -0300
Message-Id: <20211218081425.18722-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series refactors the current Realtek DSA driver to support MDIO
connected switchesand RTL8367S. RTL8367S is a 5+2 10/100/1000M Ethernet
switch, with one of those 2 external ports supporting SGMII/High-SGMII.

The old realtek-smi driver was linking subdrivers into a single
realtek-smi.ko After this series, each subdriver will be an independent
module required by either realtek-smi (platform driver) or the new
realtek-mdio (mdio driver). Both interface drivers (SMI or MDIO) are
independent, and they might even work side-by-side, although it will be
difficult to find such device. The subdriver can be individually
selected but only at buildtime, saving some storage space for custom
embedded systems.

Existing realtek-smi devices continue to work untouched during the
tests. The realtek-smi was moved into a realtek subdirectory, but it
normally does not break things.

I couldn't identify a fixed relation between port numbers (0..9) and
external interfaces (0..2), and I'm not sure if it is fixed for each
chip version or a device configuration. Until there is more info about
it, there is a new port property "realtek,ext-int" that can inform the
external interface.

The rtl8365mb still can only use those external interface ports as a
single CPU port. Eventually, a different device could use one of those
ports as a downlink to a second switch or as a second CPU port. RTL8367S
has an SGMII external interface, but my test device (TP-Link Archer
C5v4) uses only the second RGMII interface. We need a test device with
more external ports in use before implementing those features.

The rtl8366rb subdriver was not tested with this patch series, but it
was only slightly touched. It would be nice to test it, especially in an
MDIO-connected switch.

Best,

Luiz


