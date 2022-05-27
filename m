Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADE0535D3C
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350169AbiE0JNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350268AbiE0JNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:13:11 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F382A5E16D;
        Fri, 27 May 2022 02:13:09 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j25so5055810wrb.6;
        Fri, 27 May 2022 02:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=RetBFMCG9lpCLQ9GX70HNv/afENGPmJuOklOwoJiSPQ=;
        b=ZQzyFVLp2dzDfjoAsp+7ZPY0X7JBg5tzdnvBkc7uQnGV83c10Sr1XPTlos1jrEsUT1
         C3OazIfS1PM+ifZ4BvTZHzp6L80SBBywV4vDDNzIE+6bcVIKccnpdiLbS0RfO41NiAhT
         m3i95T6UBdPqQOmakprbQwctYjhsBtCw8f88ecv53H9W/LKylsWYPG5Y9wPm1TGVA0Nj
         aXGZONEFX7snSTyARs8L3uT4z23vge+hYk6gfdLfa5fRI7ysCXcprdoQFfhVAW+bou33
         6bgZ9JOLjHUNM/ikf7kRfrfvLiaeKQcJW/4VxHAmraVEjdcqex0Mm1AXAjQaoC7qhlGY
         KtwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=RetBFMCG9lpCLQ9GX70HNv/afENGPmJuOklOwoJiSPQ=;
        b=MZolrHWbgxwQWhyTPCnBlaW6H+zz506kuZWu+CmWWHkairALTdBr3BDxQGz9o0PMQ1
         lUgl4xLaZbb1vBikVGei1qhS+JcKueFBp6sOtOtfOBlY6ayYbuVQpVFekk4X/sITQ+qs
         VcF1ZTJzfncz7dZaMyz7W/xxZ8n8Sd6BM/SVAYMSkSXE58rbbXYQNguxBBPeTgvf5/Aa
         Y5LddAB6AXGJ3yFkk0fud/CQ6nYnGzFbNxRpGnOTb/fcej/RiuclcInJu1suzmpWWWJ0
         2pJGKxCntHaca5t7+UXdMI4sV6Id9HtBs5/CRlr8ixVx2pUvwYiwoGi8qjO2EMsZgZnX
         d4/A==
X-Gm-Message-State: AOAM533PQjSYv2d9fnDfQZOIkmyjJ5dxTBwI6fNbGLEGNIupveZXxwcA
        1s1J1G8YLWSEIvKg4+1e2/k+f8zNpW4=
X-Google-Smtp-Source: ABdhPJwtWKYLZA55ZTOzSRd4thmuCkh/99+ZZ5lCisRvMKaSENv9Y2FPT/alaE3MhJ+wR45C+2Pxkw==
X-Received: by 2002:a5d:64e4:0:b0:20f:eb22:1af1 with SMTP id g4-20020a5d64e4000000b0020feb221af1mr16226781wri.437.1653642788602;
        Fri, 27 May 2022 02:13:08 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id 8-20020a1c0208000000b003942a244ed1sm1615289wmc.22.2022.05.27.02.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 02:13:08 -0700 (PDT)
Date:   Fri, 27 May 2022 10:13:06 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: mainline build failure due to c1918196427b ("iwlwifi: pcie: simplify
 MSI-X cause mapping")
Message-ID: <YpCWIlVFd7JDPfT+@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

The latest mainline kernel branch fails to build for mips allmodconfig
with the error:

drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1093: error: "CAUSE" redefined [-Werror]
 1093 | #define CAUSE(reg, mask)                                                \
      | 
In file included from ./arch/mips/include/asm/ptrace.h:19,
                 from ./include/linux/sched/signal.h:14,
                 from ./include/linux/rcuwait.h:6,
                 from ./include/linux/percpu-rwsem.h:7,
                 from ./include/linux/fs.h:33,
                 from ./arch/mips/include/asm/elf.h:12,
                 from ./include/linux/elf.h:6,
                 from ./include/linux/module.h:19,
                 from ./include/linux/device/driver.h:21,
                 from ./include/linux/device.h:32,
                 from ./include/linux/pci.h:37,
                 from drivers/net/wireless/intel/iwlwifi/pcie/trans.c:7:
./arch/mips/include/uapi/asm/ptrace.h:18: note: this is the location of the previous definition
   18 | #define CAUSE           65

git bisect pointed to c1918196427b ("iwlwifi: pcie: simplify MSI-X cause mapping")

And, reverting it on top of mainline branch has fixed the build failure.

--
Regards
Sudip
