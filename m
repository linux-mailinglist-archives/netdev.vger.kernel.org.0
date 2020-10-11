Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC41E28A9B0
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgJKTfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgJKTfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:35:10 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F389C0613CE;
        Sun, 11 Oct 2020 12:35:10 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id md26so20278965ejb.10;
        Sun, 11 Oct 2020 12:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=K8aM+wsuH+b5e/V3iFm/UCWXbcrACCoUfMzBFSDIIjs=;
        b=OGKP0cnrBvlbfHqjtgQ++A7bU89/HXGWVwoiLiIwjNoiSWZn7j8YDzKW+WyqhBCQAy
         59ENx6/8OuM1/S9qpbMITd2j1UORS7BdCvX1OtGEE0ZcVyhyvXLJ2mu/OE/oxSrYraP6
         p9KXtbnTRgxqFqRZILQr+TsSa2DiLph2aaBfa7XO1vPzme1evZh9JwhMvyepRPbmIoCS
         xtDQ90Mu1Hbx/oieGYQT1OMM1D8D9lOfAHIVhNc6cABc4PGjM6LP5qKlIcYeMJureXus
         Jv8zEGwRQNqNVjDuqiuDsMjLZOyfuhm5VP4SIGfrkGtOaqNwZ/EK2WBscLO42wbjSSup
         acjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=K8aM+wsuH+b5e/V3iFm/UCWXbcrACCoUfMzBFSDIIjs=;
        b=DOcul6iPs4yJqR7d91y2KmvQ2EJAtcIfSv6/WEVr+h1Wk5udyZSBc7ulPoV0TWtu4s
         aTBtu6fQVLWWvi4RtP4R3mIl5Vcww8o7AligM8hFAiD9pF/ydO4PAgY7va4jEN97BkLq
         qRA704jG2ZPgGfXk6u9Gr3u/QhD/wWA+mrArFXUdeJfLLaDld1lQcq5+3Ecvh5VAUay/
         Ssvw0VE4uwTzDYImKzuv5Aq77J07nCQMpTq7apuv7cCS3Hab1JH5RlJQZfh5y8fPsjsl
         aNu5Kju2OTMdu/jD2/ncyFYEMrC3+gJH1YhQA9Kbxzogu4RTkq5UCJpeVAXTmCDkyO2Y
         5Y4Q==
X-Gm-Message-State: AOAM533ecW3XvaXSFVZOJboVodEvKfqzDc1zgIBT2yRM/HEIlP/+xlHl
        bby9PgQg2Zg7hWKzV1978ME=
X-Google-Smtp-Source: ABdhPJzVlyVjU16DJNx2PSPP4M89OX3yHiUWJFeQbTo2OLpXzAvIWhOQ3EiLBn5Q+FtKAFhT6sPXdg==
X-Received: by 2002:a17:906:1a0b:: with SMTP id i11mr24887327ejf.472.1602444908702;
        Sun, 11 Oct 2020 12:35:08 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id w13sm2595839ede.89.2020.10.11.12.35.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 12:35:08 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 00/12] net: add and use function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Message-ID: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
Date:   Sun, 11 Oct 2020 21:34:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In several places the same code is used to populate rtnl_link_stats64
fields with data from pcpu_sw_netstats. Therefore factor out this code
to a new function dev_fetch_sw_netstats().

Heiner Kallweit (12):
  net: core: add function dev_fetch_sw_netstats for fetching
    pcpu_sw_netstats
  IB/hfi1: use new function dev_fetch_sw_netstats
  net: macsec: use new function dev_fetch_sw_netstats
  net: usb: qmi_wwan: use new function dev_fetch_sw_netstats
  net: usbnet: use new function dev_fetch_sw_netstats
  qtnfmac: use new function dev_fetch_sw_netstats
  net: bridge: use new function dev_fetch_sw_netstats
  net: dsa: use new function dev_fetch_sw_netstats
  iptunnel: use new function dev_fetch_sw_netstats
  mac80211: use new function dev_fetch_sw_netstats
  net: openvswitch: use new function dev_fetch_sw_netstats
  xfrm: use new function dev_fetch_sw_netstats

 drivers/infiniband/hw/hfi1/ipoib_main.c       | 34 +-----------------
 drivers/net/macsec.c                          | 25 +------------
 drivers/net/usb/qmi_wwan.c                    | 24 +------------
 drivers/net/usb/usbnet.c                      | 24 +------------
 drivers/net/wireless/quantenna/qtnfmac/core.c | 27 +-------------
 include/linux/netdevice.h                     |  2 ++
 net/bridge/br_device.c                        | 21 +----------
 net/core/dev.c                                | 36 +++++++++++++++++++
 net/dsa/slave.c                               | 21 +----------
 net/ipv4/ip_tunnel_core.c                     | 23 +-----------
 net/mac80211/iface.c                          | 23 +-----------
 net/openvswitch/vport-internal_dev.c          | 20 +----------
 net/xfrm/xfrm_interface.c                     | 22 +-----------
 13 files changed, 49 insertions(+), 253 deletions(-)

-- 
2.28.0

