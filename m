Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C00A6425F2
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiLEJmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiLEJmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:42:43 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8F3F04
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:42:41 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id vv4so26287501ejc.2
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 01:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fAoyMXhV6wPokEokM1Y8kxHp3I5YSAtTY4bF43H15q4=;
        b=KpoCoJrJG3eXhW/8qA7F6QnjLGRuWW6JWsYuXXYkapiPdrrm915n7LCUJhwYQ/ZXiZ
         uvApIzCzu8UV4z29O4pq+0vXkyS5fVU4lXWwIhWmvzUMan6PAIvmI3wPUu6Ta2Jy1Trf
         D7VPcymz+lDe7Y4h5Xqa1eDrN2VNFXOiKyeMsEgqikH2e9xumi/z987hkL+SwFSuYxm+
         0NQyarciKHZWheSEo0CMVMKBKDR+f0tT+Bd4NuKEbvvpIgQ3eGwpSzkxVrPAFeWfgyK6
         6/0mRHM3x7qorSx+koIHVn3vkvTO02GKkwxgb6ymKVQtyiNrNHOhJQYSmoMtCuUBUKef
         /3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fAoyMXhV6wPokEokM1Y8kxHp3I5YSAtTY4bF43H15q4=;
        b=6YM594nKUkJcXbvjzbtNlFvvHS0VrC4CZfhlrFIkrjxx5LRorippa6CzJYdyDXHmb9
         cBruAxLya+9IJgpCg+cxI7tx0n8EH3aXuar9fhfQX6loLP9FPfY+5I27JJmZan7i9ltd
         FYf4A6/a9ef63v6EUHmq7JwYlfJzDXBhRO6x4+aMk3aI2QOjOJI5QG1z3BTN89ProzN7
         eMY2CSbaOmBRrjpHGngm8aMONNgxBHt28hJHjvAPxJ3TG0omD9aL08iFycKyCdsQQZox
         97Ef+8fQSNj2XMTSpvPb03RgmumNcZtuinWHeoZt4nB21d+OiIe//mTuCBILANubRTCF
         kwow==
X-Gm-Message-State: ANoB5pmeYLhw1Vo/otuBnVBWpK5JQ3F3+V83I4OEPMREQnqabnmTgnKA
        53jM8UhrcPe6DD/2PAK9NSY=
X-Google-Smtp-Source: AA0mqf6fy2S3NfqeqNXRqFMJ2GI0drDmJIFQA9TifseJuCjRDViyHlctTna3TSKUKEWwTybDs121Jg==
X-Received: by 2002:a17:907:8c8e:b0:78d:4167:cf08 with SMTP id td14-20020a1709078c8e00b0078d4167cf08mr20926558ejc.337.1670233359905;
        Mon, 05 Dec 2022 01:42:39 -0800 (PST)
Received: from ThinkStation-P340.. (host-217-57-98-66.business.telecomitalia.it. [217.57.98.66])
        by smtp.gmail.com with ESMTPSA id bn18-20020a170906c0d200b0077a1dd3e7b7sm6083866ejb.102.2022.12.05.01.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:42:39 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v3 0/3] add tx packets aggregation to ethtool and rmnet
Date:   Mon,  5 Dec 2022 10:33:56 +0100
Message-Id: <20221205093359.49350-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello maintainers and all,

this patchset implements tx qmap packets aggregation in rmnet and generic
ethtool support for that.

Some low-cat Thread-x based modems are not capable of properly reaching the maximum
allowed throughput both in tx and rx during a bidirectional test if tx packets
aggregation is not enabled.

I verified this problem with rmnet + qmi_wwan by using a MDM9207 Cat. 4 based modem
(50Mbps/150Mbps max throughput). What is actually happening is pictured at
https://drive.google.com/file/d/1gSbozrtd9h0X63i6vdkNpN68d-9sg8f9/view

Testing with iperf TCP, when rx and tx flows are tested singularly there's no issue
in tx and minor issues in rx (not able to reach max throughput). When there are concurrent
tx and rx flows, tx throughput has an huge drop. rx a minor one, but still present.

The same scenario with tx aggregation enabled is pictured at
https://drive.google.com/file/d/1jcVIKNZD7K3lHtwKE5W02mpaloudYYih/view
showing a regular graph.

This issue does not happen with high-cat modems (e.g. SDX20), or at least it
does not happen at the throughputs I'm able to test currently: maybe the same
could happen when moving close to the maximum rates supported by those modems.
Anyway, having the tx aggregation enabled should not hurt.

The first attempt to solve this issue was in qmi_wwan qmap implementation,
see the discussion at https://lore.kernel.org/netdev/20221019132503.6783-1-dnlplm@gmail.com/

However, it turned out that rmnet was a better candidate for the implementation.

Moreover, Greg and Jakub suggested also to use ethtool for the configuration:
not sure if I got their advice right, but this patchset add also generic ethtool
support for tx aggregation.

The patches have been tested mainly against an MDM9207 based modem through USB
and SDX55 through PCI (MHI).

v2 should address the comments highlighted in the review: the implementation is
still in rmnet, due to Subash's request of keeping tx aggregation there.

v3 fixes ethtool-netlink.rst content out of table bounds and a W=1 build warning
for patch 2.

Thanks,
Daniele

Daniele Palmas (3):
  ethtool: add tx aggregation parameters
  net: qualcomm: rmnet: add tx packets aggregation
  net: qualcomm: rmnet: add ethtool support for configuring tx
    aggregation

 Documentation/networking/ethtool-netlink.rst  |  17 ++
 .../ethernet/qualcomm/rmnet/rmnet_config.c    |   5 +
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |  20 ++
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  18 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |   6 +
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 191 ++++++++++++++++++
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  54 ++++-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   1 +
 include/linux/ethtool.h                       |  12 +-
 include/uapi/linux/ethtool_netlink.h          |   3 +
 net/ethtool/coalesce.c                        |  22 +-
 11 files changed, 342 insertions(+), 7 deletions(-)

-- 
2.37.1

