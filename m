Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9876C623213
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiKISJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiKISJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:09:19 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3393E22BE7
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:09:18 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id u24so28262489edd.13
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 10:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=go/qFrlfKxYDOzPYzeTA8A83ngXuKYoA+aPGsw5k65Q=;
        b=GPNoj6vglHqBfQ8dyclvRgqIe95JEljGXKjkxuBLLcyfpSjdCsIVsPAaqOXkLIxfu6
         FjuUlNdM3GefXJ4lqlk+nWqSFIn2tI+sHblqMllWBp8C3uz+b/gGsRFciWUmXvhgS0Ex
         BCXuUSpbxMRlMywwjsZ6moIGcZiizUHURmyBqKb3zwtnHchLVWACFvd5kHVrOiX8vUlx
         eAc5Q6xO55oHB+GDX71F3GbpLydmcrSyWf2WwOAS09oj12nAkYyYv67yclH4EnQSY25N
         NBbvFgBA1CQ/Yk1PCojUqNgAN49L15SvV0tDujy+u70yD197yZQB1gttobSGfeoXjGCR
         UJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=go/qFrlfKxYDOzPYzeTA8A83ngXuKYoA+aPGsw5k65Q=;
        b=l28h89olZjOY5qRwMSHuzUX3UqfI0Z5ab72S6qDHxINFGz8WeeZleONEnTJ5RzDd8+
         zivltsBuWqrkUzBtokXcQFkU1V9yDTNQtqc8xayHJb47jlyS+qKPtR00KmN9kLEdlMQD
         RNYrjsCG+58iZ7uGL/iUdj7eaJG+MGZFjg+8ArDHCRQu5DAb5Rs0GTCM5Ux8XEw9sIJo
         3QdAVIuEIe/TrHaVOcVqRC0QX3G4PK6vnw0mhyd0SmRL1+605xaKdfuZthW0LiKED+EX
         tKJiG/Ki45Aym72QXTDzH7J1pgsiPZ9rFqRXDf+Vwn62qN0trRqrxINmQFZoJ7XEuSHG
         A5lg==
X-Gm-Message-State: ACrzQf0i8Iizxa07XQydBFCIN3MbmVBXYumEton8E7zQ1j9XBYJx3gsL
        q3ahZ1Ddtq0egHFkNUwQcSo=
X-Google-Smtp-Source: AMsMyM6lOadEOaIW8XLmFjuS2VwH55c7WvbUmJUn6eEMUlfx1aJCymJfXPKpbCRyJOyOUg7ZOhfgBA==
X-Received: by 2002:aa7:de0a:0:b0:462:d2a0:93a with SMTP id h10-20020aa7de0a000000b00462d2a0093amr58659273edv.275.1668017356508;
        Wed, 09 Nov 2022 10:09:16 -0800 (PST)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id rh16-20020a17090720f000b0077016f4c6d4sm6116311ejb.55.2022.11.09.10.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 10:09:15 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next 0/3] add tx packets aggregation to ethtool and rmnet
Date:   Wed,  9 Nov 2022 19:02:46 +0100
Message-Id: <20221109180249.4721-1-dnlplm@gmail.com>
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

Thanks,
Daniele

Daniele Palmas (3):
  ethtool: add tx aggregation parameters
  net: qualcomm: rmnet: add tx packets aggregation
  net: qualcomm: rmnet: add ethtool support for configuring tx
    aggregation

 Documentation/networking/ethtool-netlink.rst  |   6 +
 .../ethernet/qualcomm/rmnet/rmnet_config.c    |   5 +
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |  19 ++
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  25 ++-
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |   7 +
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 196 ++++++++++++++++++
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  44 ++++
 include/linux/ethtool.h                       |  12 +-
 include/uapi/linux/ethtool_netlink.h          |   3 +
 include/uapi/linux/if_link.h                  |   1 +
 net/ethtool/coalesce.c                        |  22 +-
 11 files changed, 335 insertions(+), 5 deletions(-)

-- 
2.37.1

