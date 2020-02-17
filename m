Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94728161CD7
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 22:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgBQVjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 16:39:37 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35710 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbgBQVjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 16:39:37 -0500
Received: by mail-wr1-f67.google.com with SMTP id w12so21494408wrt.2;
        Mon, 17 Feb 2020 13:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pQK+JSaj4X1ouX/nv3XugRaRb5vhJaYjMLbHKqXiJLs=;
        b=tRxbEzBjpxae4/jPkX1ksr+AcCQ64ru3BPDzjqwTU82KNKYS4zCXaPWBV+ZO5ottcE
         SWRr3JAXQpC0gyS+wvRGCiIV4U7PA5WMbz2ZSGOVn7SsIblDcq7V3IvlODWdUH8p0ZeP
         sCvsYdTwQE2yPqtNrPz6d1lxZtBN6p6isE2YiGyv2JTZHAKg31zP2fe1rcF1Al3uFeA6
         uiKo+SF5Lcs5EuO1azjUgTpoU2DReG7SX6W8+ujPHNv7MEWktBJFkZQKhjLy9uu1OizE
         Jh0qS3HZKJGRz9Hc84QtlrjF3T0y9mRnpe/R7e9MGNwBJa9fWcRifsPM/jzkNm8IjdmP
         LUxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pQK+JSaj4X1ouX/nv3XugRaRb5vhJaYjMLbHKqXiJLs=;
        b=EuXsJmXSuow80EnJPHYONBimakZupXfMjrmjETsHnKuMNye063HQNRX6b5wtxxlXXa
         s5QIdUgOLCCkaRL55yqsrJyvET+MAIWC1Hilzin1hwYmx38dynfg+E0AbotrQIsdH5Bu
         usPi4gshVIMGdOvsWdH5DYrVzuQihcpTu4U/f2oZ+gABwRr0cDvaQMUvi5cFMipYZGK5
         AJ10owrzCHeUJCwRV01hE1ec+sWgLhD80NUAz9aWbflW5XPeS6JdJ98e1xO9h+Ue6Bf5
         EfeOnli7lXTL/2XiECxdZemwEQhUd8hfxR5EM3uBnVvQpiZrUE6mQInRuzz9sYSQ4Jzc
         f8pQ==
X-Gm-Message-State: APjAAAUpBXFde1CcJPLsdrBV6lqv0wiB1JNElg7XIY3RkiXnuPeLQZ+7
        2dlvCN1UMxeGLJC5as1Az0GLvai9Wk0=
X-Google-Smtp-Source: APXvYqxtgfXlPYMtn3A/6f+SlQuvmEQ1uS0kThsmRCNvSY3l7Z1IWf9fXRqMYdc2QonmDvWxMh0+og==
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr24421643wrt.241.1581975575195;
        Mon, 17 Feb 2020 13:39:35 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:41c6:31a6:d880:888? (p200300EA8F29600041C631A6D8800888.dip0.t-ipconnect.de. [2003:ea:8f29:6000:41c6:31a6:d880:888])
        by smtp.googlemail.com with ESMTPSA id t13sm2892378wrw.19.2020.02.17.13.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 13:39:34 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] net: core: add helper tcp_v6_gso_csum_prep
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Timur Tabi <timur@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, linux-hyperv@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Message-ID: <76cd6cfc-f4f3-ece7-203a-0266b7f02a12@gmail.com>
Date:   Mon, 17 Feb 2020 22:39:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several network drivers for chips that support TSO6 share the same code
for preparing the TCP header. A difference is that some reset the
payload_len whilst others don't do this. Let's factor out this common
code to a new helper.

Heiner Kallweit (3):
  net: core: add helper tcp_v6_gso_csum_prep
  r8169: use new helper tcp_v6_gso_csum_prep
  net: use new helper tcp_v6_gso_csum_prep

 drivers/net/ethernet/atheros/alx/main.c       |  5 +---
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  6 ++---
 drivers/net/ethernet/brocade/bna/bnad.c       |  7 +----
 drivers/net/ethernet/cisco/enic/enic_main.c   |  3 +--
 drivers/net/ethernet/intel/e1000/e1000_main.c |  6 +----
 drivers/net/ethernet/intel/e1000e/netdev.c    |  5 +---
 drivers/net/ethernet/jme.c                    |  7 +----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  5 +---
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |  7 ++---
 drivers/net/ethernet/realtek/r8169_main.c     | 26 ++-----------------
 drivers/net/ethernet/socionext/netsec.c       |  6 +----
 drivers/net/hyperv/netvsc_drv.c               |  5 +---
 drivers/net/usb/r8152.c                       | 26 ++-----------------
 drivers/net/vmxnet3/vmxnet3_drv.c             |  5 +---
 include/net/ip6_checksum.h                    | 12 +++++++++
 15 files changed, 30 insertions(+), 101 deletions(-)

-- 
2.25.0

