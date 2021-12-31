Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC0F4821F4
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 05:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242675AbhLaEeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 23:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhLaEeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 23:34:22 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4797DC061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:22 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id q14so23408405qtx.10
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AB5G5Elopurk4tcVRqqaWXViPjDjetGDOais0caWaWs=;
        b=D/FnXROtqGQ2iYubW3TkMzQV24MoUCcQfUxrAcdlMQRi/y6IbWLZUsQ0t+TOfKXIXQ
         vX8edPTBqT/+vhkdfhT2IjrNR8MzaI9DEGRvv8cMbjdX9/Qpz5BfqTic8vJ5bE2mEQX2
         aScP37iFstGIF15vsCs765ovriyq4P9HJ1vdWiN80d6FgDfdkfqagT/rPlmp9pj+Kyi+
         sEsBItYZKM+ZN/qDD0pQS/aLiFm98NLqQJJiQw54szU/kSzwlmGw4rr6pzS7Q5iDZEbn
         2fpbWxVTtQ7zykgDjSccl9exCWjiVW7Bz1JuIu50df4lyL8JnahKswY0dLkj6Ib3Ri1i
         rVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AB5G5Elopurk4tcVRqqaWXViPjDjetGDOais0caWaWs=;
        b=UhAN8ZPrmQzgw8GxDM4OUysIcMI8umza8RRkco97GpB7EI8JsGUlq82OEBNX0JgOMq
         8dHxiopHAQs4NeDCYMoFjh9ZH8aPSMQdQxMrdXjsa9QfOD0gOSCSxnM7dgwN0W5CNVg9
         EFSu5JhDpah8gLMm0tInNTdSdl0yPYNPJaAqXz9OSKRL7rbc3e8HSB3dNSFN3jcJa/oY
         5RZMJgvf5Oe5ic+xFonLavkosmepW4JxuCndMOUYj1mWKRV3CG7KEWz9HB0ZnHeAqmMw
         aY+6Y3I57+2hUPo2aiXsgJbeQ7G9ph6EVUG/olnTcaquwyw+fdc/NH7VudLSTXhMFlNJ
         fLQg==
X-Gm-Message-State: AOAM5324BdAtXVU1Cy/FURY2ZamMsw+JpHZhpseumjVJdwtvcbqhXQIz
        DKH2Im9DPQmVyQ0zcej3WYfx7j+atNRX11Sc
X-Google-Smtp-Source: ABdhPJxc/Oqh2kofmWJM4TYLIeWvtX0Od6dxMKlH8zP7+JgzxBsQn7w42kfhM+c3yKAKnO2ZtpMIiA==
X-Received: by 2002:a05:622a:411:: with SMTP id n17mr29153054qtx.439.1640925260381;
        Thu, 30 Dec 2021 20:34:20 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id i5sm8020030qti.27.2021.12.30.20.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 20:34:19 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de
Subject: [PATCH net-next 00/13 v3] net: dsa: realtek: MDIO interface and RTL8367S
Date:   Fri, 31 Dec 2021 01:32:55 -0300
Message-Id: <20211231043306.12322-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

The rtl8365mb might now handle multiple CPU ports and extint ports not
used as CPU ports. RTL8367S has an SGMII external interface, but my test
device (TP-Link Archer C5v4) uses only the second RGMII interface. We
need a test device with more external ports to test these features.
The driver still cannot handle SGMII ports.

The rtl8365mb was tested with a MDIO-connected RTL8367S (TP-Link Acher
C5v4) and a SMI-connected RTL8365MB-VC switch (Asus RT-AC88U)

The rtl8366rb subdriver was not tested with this patch series, but it
was only slightly touched. It would be nice to test it, especially in an
MDIO-connected switch.

Best,

Luiz

Changelog:

v1-v2)
- formatting fixes
- dropped the rtl8365mb->rtl8367c rename
- other suggestions
	
v2-v3)
* realtek-mdio.c:
  - cleanup realtek-mdio.c (BUG_ON, comments and includes)   
  - check devm_regmap_init return code
  - removed realtek,rtl8366s string from realtek-mdio
* realtek-smi.c:
  - removed void* type cast
* rtl8365mb.c:
  - using macros to identify EXT interfaces
  - rename some extra extport->extint cases
  - allow extint as non cpu (not tested)
  - allow multple cpu ports (not tested)
  - dropped cpu info from struct rtl8365mb
* dropped dt-bindings changes (dealing outside this series)
* formatting issues fixed


