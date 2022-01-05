Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BDC484CC2
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiAEDPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiAEDPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:15:41 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959FEC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 19:15:41 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id p12so12160897qvj.6
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 19:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jA7RqPfrfFk70WdkcYCoiesx2P7kCHKW6HifwOFPGLo=;
        b=d7UDB+4b5epaaM89S9MXJH+R5jzz+OfuQsormcHTTEEpj4N1xlXnh/GiXlLw9rvpa6
         JK2frWEKjvR5ONw5eQdB6slW3RESu1bhs8dYRxW27zvTVv7gP/LCHTRIyv05dOBv+DYs
         eYxPk7rsQTAXxSds7zbmpE0/tQmAiIMeahyenPlmEN/uDMKrcPl6+pEOyfgdlg/Iu282
         SDV/Da9F0hiX5DlSgLD5q2SlYH/mUhpsi2l0djN1KkWaMfacZ9DqoUjuKl7nI9y+DQRy
         Ni2vfQJJzueF4QohmuzR+zRKv1xJHaltf/ax+AGMD3NfxaKt+nnbxe72ug2hmHVgmngz
         1Y9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jA7RqPfrfFk70WdkcYCoiesx2P7kCHKW6HifwOFPGLo=;
        b=Kq+Gk3FgJxuGSMipM6uhHiL82s8qp2x6UMMUduYGV7ySO19ymUW0Pqz8qWocCTSbIR
         1clAaUlnKwtApULvDbgSME5LwAw5xdLLaMyZIPyvF4jhOr8Xko7KC/3tlCyapkEaHy6D
         30xFc9Cdg6tAG71R6PXyQsPZ07GfZg752YkON6GUYDpUrHoNwnlzf/45vfAr2SaWUHBm
         7M8JDJGKHZI4CIhlXuBe8MdLe32Bh6ztaD5EMMX6dAKHu7B5LzfPtnWw556P9pvfJDLL
         DiOWiq0OsAQn3N8CL1zntdttxkyfoDAAOJPd2GokgOii9GvQqaYfPvTPam0rBC+/wwj7
         vcMQ==
X-Gm-Message-State: AOAM531le5RIeGEIZ2CwnjTgw3NtjztF7KYhU7LHqtSgiZ8Zw6TfpMge
        DANLfrChmnZ5geTK+hVnMEc7p6IO77s3cwpe
X-Google-Smtp-Source: ABdhPJys3N4NcGHV5U+UbM+iw+AACdFhe/87E54qBnJ9ITsaQE1byHf6lvo2mVaYP851Au+7shHPEQ==
X-Received: by 2002:a05:6214:29cb:: with SMTP id gh11mr35151615qvb.34.1641352540490;
        Tue, 04 Jan 2022 19:15:40 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t11sm32607629qkp.56.2022.01.04.19.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:15:39 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de
Subject: [PATCH net-next v4 00/11] net: dsa: realtek: MDIO interface and RTL8367S
Date:   Wed,  5 Jan 2022 00:15:04 -0300
Message-Id: <20220105031515.29276-1-luizluca@gmail.com>
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

v3-v4)
* fix cover message numbering 0/13 -> 0/11
* use static for realtek_mdio_read_reg
  - Reported-by: kernel test robot <lkp@intel.com>
* use dsa_switch_for_each_cpu_port
* mention realtek_smi_{variant,ops} to realtek_{variant,ops}
  in commit message


