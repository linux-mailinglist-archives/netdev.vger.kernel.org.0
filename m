Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEA749F10E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345420AbiA1Cgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345337AbiA1Cgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:36:50 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225E1C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:36:50 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id b186so3542886oif.1
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M8qNs7GpQzHfBZAU6o1idv4dd/5iCkDbh2+HDTKKKgM=;
        b=dc6RjvcUPGt+eIYYlaqAtHU36xpQt+8+13gR74saDA5gw2prRaw61+lrCy9HDaiBfI
         aqYPaK4uOJU/bTma4sNNDEgrnFACEWjJRT5XyAZ4N5tJUMPwM7fsEbAh8QXPOfZqlRZ0
         qcuOfCaCLyR6DZ2wfRs2JoPAGREvDpDwVxCdanhdom5b8RpxqTWWhuOcHtLqXjullvOo
         7OWGPxiGJmO4IQeXCBAeqQN0nbKXf8+Kg2Awus8NJ1oHJBIW7F4EQ5BvLEsG664fLvZK
         0BBxXBO28uLD40RAkSUyUK09HgHLmQy48WRXINQUAEuMbKlfZAHeKpxl3X+FjmHumu8m
         74lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M8qNs7GpQzHfBZAU6o1idv4dd/5iCkDbh2+HDTKKKgM=;
        b=QtsF2KoM8VBrVDf405fNgRfQdhiU2UqJVclfPtZCG9623Pt+S5vW7NxYwgvuXTGkJc
         i+fcnKvcIDy47kCM7CZIkXm5DR0emq9SOhUUSvfMugMT5TGp82zX5+5uLguMIL6HFhWz
         L1/NI1rbkFUcwtUrMSZftUedqStccbHMKyV7OC3AhkA2HedkCcukxncIswAzM3LI8irp
         GkBTmrsNz7aGKmtfNWivi8ph9Yeqkv8OECrrLQ88ajiwit1HHMFb6uBOwW3xkkimIk6z
         D1dSAwwb+eSvO7m+Cv+fqcH06/jgfO2GdZUIW3DCPX2kehO9ajyO7N6J6u8acIjFjGzi
         Cbkw==
X-Gm-Message-State: AOAM532INioaxOVv++v0TKMDg0KWdCEamcXqbcnNKp8Rx8wBr2Qs+Qp7
        pzzXEc0iKK6PoHQhdQh0LBR6SanLkUbGMw==
X-Google-Smtp-Source: ABdhPJwfJdFN2JmouKTcoB1h/GTTKGgMc/VeIk1aYgzqKClFP1dlPwbX8SobLqTvLVLfXaV2ncoLcQ==
X-Received: by 2002:a05:6808:1704:: with SMTP id bc4mr4041721oib.186.1643337409135;
        Thu, 27 Jan 2022 18:36:49 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id p82sm2586920oib.25.2022.01.27.18.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:36:48 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de
Subject: [PATCH net-next v5 00/11] net: dsa: realtek: MDIO interface and RTL8367S,RTL8367RB-VB
Date:   Thu, 27 Jan 2022 23:36:00 -0300
Message-Id: <20220128023611.2424-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
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

The rtl8365mb might now handle multiple CPU ports and extint ports not
used as CPU ports. RTL8367S has an SGMII external interface, but my test
device (TP-Link Archer C5v4) uses only the second RGMII interface. We
need a test device with more external ports to test these features.
The driver still cannot handle SGMII ports.

RTL8367RB-VB support was added using information from Frank Wunderlich
<frank-w@public-files.de> but I didn't test it myself.

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

v4-v5)
- added support for RTL8367RB-VB
- cleanup mdio_{read,write}, removing misterious START_OP, checking and
  returning errors
- renamed priv->phy_id to priv->mdio_addr
- duplicated priv->ds_ops into ds_ops_{smi,mdio}. ds_ops_smi must not
  set
  phy_read or else both dsa and this driver might free slave_mii.
Dropped
  401fd75c92f37
- Map port to extint using code instead of device-tree property. Added
  comment 
  about port number, port description and external interfaces. Dropped
  'realtek,ext-int' device-tree property
- Redacted the non-cpu ext port commit message, not highlighting the
  possibility of using multiple CPU ports as it was just a byproduct.
- In a possible case of multiple cpu ports, use the first one as the
  trap port.
  Dropped 'realtek,trap-port' device-tree property
- Some formatting fixes
- BUG: rtl8365mb_phy_mode_supported was still checking for a cpu port
  and not
  an external interface
- BUG: fix trapdoor masking for port>7. Got a compiler error with a
  bigger
  constant value
- WARN: completed kdoc for rtl8366rb_drop_untagged()
- WARN: removed marks from incomplete kdoc


