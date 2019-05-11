Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881591A9C4
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 01:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfEKXRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 19:17:12 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:37025 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfEKXRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 19:17:12 -0400
Received: by mail-qt1-f182.google.com with SMTP id o7so10835815qtp.4
        for <netdev@vger.kernel.org>; Sat, 11 May 2019 16:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vCXdwp9yh3By/kCj/5erJ6oXJXVyhgvtgkRt+CmPDAs=;
        b=Dn0Nu3VqM4Y3kLuDh67i6FpWOrBtzVcmQulPRB7RBTFACdMUVQgj8E/rJpIhv/B9Gh
         KUPWcgvxganghv+TzqGlMBc3TSoK39SPrm8rXrf1nA9yBJZlPlWMeGGvcDdCJpp1xDMy
         8hBE3gD0XtjuzK0UVpOnLJFCI0HRScoDBTrNeeUP0BLblzZj38nKAkp590ZfJJmF81/e
         Ti61JTqCrZMuTu4pwvBVkeXv+XJ96jLcEXhvXxmMEq80QsNqvxY1ZI/ix58i1XH+YdJ/
         Y19srbW/y2eaBj+E4F/UeYvkFiD6fw3KzxJX/rNP8xeCM6EqUoLGs7U3MUbN24ge9NDb
         XoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vCXdwp9yh3By/kCj/5erJ6oXJXVyhgvtgkRt+CmPDAs=;
        b=WoDGNonu7Q0UlnMjhndqB4kPrBOHBnhEZh0+XGfipNVjcvkWyZI78TCxQ/wBefyXnQ
         OrEQ4OoNhtSyDMNZeMplXI9+ZsgqrXd01GGwArdMbPRqfnbzA/fHbNSNFzJ76JtjRl6j
         l4v3Y6pKX1mtEVBQocGI6CfMtqma7qomRGj1R5V3x06l6y6m/QP4sWDeUy9APx70q0ME
         lLPT+itw55ApdnUUWT4toucT+m+FX99LrQyIX5E6mONlHdyHIE8TWEMqO+6r2aoAvrr8
         TAtnPZrk7Ul7iVjrp1DMFELvoS4p9vOnnFXbA3r0AecekceT9FWEmCzb87FLC7gFD2eM
         SCPA==
X-Gm-Message-State: APjAAAUHTblzCivB+ATWCdehXSrSQCfM+Qq0uxPRUS33gnQGNO5AqI6Y
        3u3oWwGiPZFP/eWKnFyARp0=
X-Google-Smtp-Source: APXvYqxQe4Et4h1sohcpGFr47FYqd1E9ODeE7aIPOPWK5YBECGzk0Cla9q6zDtfJrN+n15g7mxPYMA==
X-Received: by 2002:ac8:641:: with SMTP id e1mr16602358qth.76.1557616630479;
        Sat, 11 May 2019 16:17:10 -0700 (PDT)
Received: from ?IPv6:2601:153:900:ebb:b5f3:c6ee:317b:8b7e? ([2601:153:900:ebb:b5f3:c6ee:317b:8b7e])
        by smtp.gmail.com with ESMTPSA id e3sm5861782qkn.93.2019.05.11.16.17.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 16:17:09 -0700 (PDT)
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev@vger.kernel.org,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
From:   Peter Geis <pgwipeout@gmail.com>
Subject: [Regression] "net: phy: realtek: Add rtl8211e rx/tx delays config"
 breaks rk3328-roc-cc networking
Message-ID: <066a0d38-2c64-7a1e-d176-04341f0cb6d7@gmail.com>
Date:   Sat, 11 May 2019 19:17:08 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Evening,

Commit f81dadbcf7fd067baf184b63c179fc392bdb226e "net: phy: realtek: Add 
rtl8211e rx/tx delays config" breaks networking completely on the 
rk3328-roc-cc.
Reverting the offending commit solves the problem.

The following error occurs:

[   49.442425] Unable to handle kernel execution of user memory at 
virtual address 0000000000000000
[   49.443237] Mem abort info:
[   49.443512]   ESR = 0x86000005
[   49.443798]   Exception class = IABT (current EL), IL = 32 bits
[   49.444331]   SET = 0, FnV = 0
[   49.444613]   EA = 0, S1PTW = 0
[   49.444914] user pgtable: 64k pages, 48-bit VAs, pgdp = 000000008f8d6f90
[   49.445516] [0000000000000000] pgd=0000000000000000, pud=0000000000000000
[   49.446136] Internal error: Oops: 86000005 [#1] PREEMPT SMP
[   49.446641] Modules linked in: snd_soc_hdmi_codec dw_hdmi_i2s_audio 
aes_ce_blk crypto_simd aes_ce_cipher crct10dif_ce ghash_ce aes_arm64 
sha2_ce rockchipdrm sha256_arm64 sha1_ce dw_hdmi lima drm_kms_helper 
gpu_sched pwm_fan snd_soc_simple_card snd_soc_simple_card_utils drm 
snd_soc_rockchip_i2s drm_panel_orientation_quirks snd_soc_rockchip_pcm 
squashfs sch_fq_codel ip_tables x_tables ipv6 crc_ccitt btrfs xor 
xor_neon zstd_compress raid6_pq libcrc32c zstd_decompress rtc_rk808 realtek
[   49.450477] Process NetworkManager (pid: 1814, stack limit = 
0x00000000cc8e3ffb)
[   49.451150] CPU: 2 PID: 1814 Comm: NetworkManager Not tainted 
5.1.0-next-20190510test-00009-g3ed182aaa670 #51
[   49.452036] Hardware name: Firefly roc-rk3328-cc (DT)
[   49.452496] pstate: 80400005 (Nzcv daif +PAN -UAO)
[   49.452938] pc : 0x0
[   49.453158] lr : phy_select_page+0x34/0x78
[   49.453532] sp : ffff0000139cf130
[   49.453841] x29: ffff0000139cf130 x28: ffff80000c9908c0
[   49.454326] x27: ffff800000ba1e10 x26: ffff0000139cf9a0
[   49.454806] x25: ffff80000034a000 x24: 0000000000000000
[   49.455285] x23: 0000000000000000 x22: 0000000000000008
[   49.455762] x21: 0000000000000007 x20: ffff800000344800
[   49.456245] x19: ffff800000344800 x18: 0000000000000030
[   49.456726] x17: 0000000000000000 x16: 0000000000000000
[   49.457207] x15: ffffffffffffffff x14: ffff000010f03688
[   49.457688] x13: 000000cce415c000 x12: 0000000000000001
[   49.458167] x11: 0000000000000000 x10: 00000000000004e5
[   49.458647] x9 : 000000000b94d076 x8 : 00000000000000cc
[   49.459130] x7 : 0000000000ddfd31 x6 : ffff8000feabcf70
[   49.459610] x5 : ffff8000007e9f00 x4 : ffff000010a1cbd8
[   49.460090] x3 : ffff80000034a070 x2 : ffff8000007e9f00
[   49.460569] x1 : 0000000000000000 x0 : ffff800000344800
[   49.461050] Call trace:
[   49.461287]  0x0
[   49.461468]  rtl8211e_config_init+0x40/0xa0 [realtek]
[   49.461927]  phy_init_hw+0x54/0x70
[   49.462243]  phy_attach_direct+0xd4/0x250
[   49.462612]  phy_connect_direct+0x20/0x70
[   49.462978]  phy_connect+0x54/0xa0
[   49.463295]  stmmac_init_phy+0x17c/0x200
[   49.463655]  stmmac_open+0x124/0xac0
[   49.463983]  __dev_open+0xd8/0x158
[   49.464299]  __dev_change_flags+0x164/0x1c8
[   49.464680]  dev_change_flags+0x20/0x60
[   49.465047]  do_setlink+0x288/0xba8
[   49.465366]  __rtnl_newlink+0x5cc/0x6e8
[   49.465720]  rtnl_newlink+0x48/0x70
[   49.466038]  rtnetlink_rcv_msg+0x120/0x368
[   49.466426]  netlink_rcv_skb+0x58/0x118
[   49.466784]  rtnetlink_rcv+0x14/0x20
[   49.467115]  netlink_unicast+0x180/0x1f8
[   49.467479]  netlink_sendmsg+0x190/0x330
[   49.467878]  sock_sendmsg+0x3c/0x58
[   49.468199]  ___sys_sendmsg+0x268/0x2a0
[   49.468554]  __sys_sendmsg+0x68/0xb8
[   49.468884]  __arm64_sys_sendmsg+0x20/0x28
[   49.469266]  el0_svc_common.constprop.0+0x7c/0xe8
[   49.469705]  el0_svc_handler+0x28/0x78
[   49.470052]  el0_svc+0x8/0xc
[   49.470334] Code: bad PC value
[   49.470619] ---[ end trace f330c41329b3e289 ]---
