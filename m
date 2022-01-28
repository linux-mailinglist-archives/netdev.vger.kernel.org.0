Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59F249F33B
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346267AbiA1GFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiA1GFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:05:36 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF77CC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:05:35 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id b17-20020a9d4791000000b005a17fc2dfc1so4824599otf.1
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e56RDjDwEIz9kl/3dZK15SC+je5dkcQRvCLS1KxVBls=;
        b=NRcL6eN5UCCE0b/eg9/mHfTa+wdompitMW1FKwpWZAruCUn9KErNkR7sTIA/bbTXWj
         cNX67AZmJAb35KeBs86qw5rtdrznuQdYYYS7P6pNnV6fl9bEW3M+3psTn+z2qhdtHngQ
         bDX0+1iW6DL9XZt4m7IFkwyHoLSoHiuL4hDB3q7B7QSG6A/2Y8/fIlbngdb1/Q0Imf/l
         G2cRitcbViY4hIKBR7BK2V3YocYAsk8XZsQ2s4t8pJGxNT+Pnt9wk+wNdVMeWYAPx7YS
         4b0qUZhe8Gsy6Ad4ei9QT90kioJT41Yswl09f6cMZopGPJjo0Hw8NfVyFwvQib3wotwb
         XaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e56RDjDwEIz9kl/3dZK15SC+je5dkcQRvCLS1KxVBls=;
        b=cxWEq+o4MlJDBc7ASxXsLhsnqxkWQH/0jIAm9c0isMaNUda02OHbrTm8lPyKzc1/pw
         deI0i+iq6xRhHRMCMZ7TJsP1Y8iIS85Wjqlwffnjpy6e4f4pOmK/fn+f5svvz+pQ1Ru3
         dMD0HqOxW/AAJr563yPuPXGBcgNa57T3Aoy13yM33+O2iSH96/uhkagdx87YaOyqeqT9
         ACHvsnJG2xz7nqSIAXY1kNehkbw8qvN1+1OTJPjkzeW0IVFXzYvIaRZ2GGejfj48ak67
         ycatI20FHS4UQBuz2g0EWxFycrNQi2pAo4FdZBYX3qqXSLTRmO6cOMPc7JjGLEgyH+JD
         cm8Q==
X-Gm-Message-State: AOAM530woVDs717IAOdYw+4Tzgrro81fyeK2p/Bi42rNZfQAjTPho1bv
        K9jb0TLzh2Qn/98oDwR1L2VY3BNh/lfb5A==
X-Google-Smtp-Source: ABdhPJxXVOAU7njLZ4oaqTYA5pc9yhVMw6HfUiG7aCtVX/HYeuo5wHJSHAbJht4sMR7+7M12Ljt2ig==
X-Received: by 2002:a05:6830:b88:: with SMTP id a8mr550934otv.196.1643349934794;
        Thu, 27 Jan 2022 22:05:34 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:05:33 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next v6 00/13] net: dsa: realtek: MDIO interface and RTL8367S,RTL8367RB-VB 
Date:   Fri, 28 Jan 2022 03:04:56 -0300
Message-Id: <20220128060509.13800-1-luizluca@gmail.com>
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

v5) sent again v4 branch. Sorry

v4-v6)
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


