Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3144663D602
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbiK3MxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiK3MxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:53:11 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971F32ED5C
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:53:10 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b8so23868854edf.11
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6XbSROP1lYrjFN74NlXRjjxl8/VmnLZU99D0zjkwtOQ=;
        b=FqImKnxq6t0YmwiN8kvn10gwtxX/Wf6cP6RQobJPWl1puL8iPzOwSdSJWV06EQDgTU
         67gwmWTKJKVcsezCB+S1Z/IpTDnV/h/tP9agB9K0N2X+GVJjmPBsYQjJ+2xeqO35jIIs
         sarKx71utgeSVPDKTSOBWjV2nnEH7whLe4mT5b1ePss3+DxjCOQ+tti98XFD08UcyA6p
         V1PZXaVbIe36NdbzCZQVFnzwo8hNOsJvdUv1RID8hjgGaLG9MD2MEWrNO36J0nGkWOxr
         6yNOQTWRqEu2vdTe/ol2OfnV7wawz3iy2W/XC7iUSjOamJHDx4sgIhfZIfc6m4S5Osus
         0I8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6XbSROP1lYrjFN74NlXRjjxl8/VmnLZU99D0zjkwtOQ=;
        b=KS4vJQJNiIryMrwkuEreuMl1MQ9ebthI9WBAmB4LzvA8FlvgoLofDHagB0LHaP7qHJ
         dN8SxStY5SEdhCgCu2PWwvIgBwQyEWJGbfSBeXKYdjXbUKk+Wy+XmkZqlfRsv1BkTXXo
         5AHuMBpDnZ56HUaVsQdAs+9rRC8ie9AbT7uA2u/ZjclVP03+NldFVMrofEK/jy/LQFgc
         lESmKXYy539rgNjUPFMz1hJws+rgYzcjwdWnbJbvXa7GnUpbLBKIh7GXyIa04RJ+2mUt
         hwuvnq21xgcNgstZwXMuM2jcV2M6OLXvs/0sKMNlPRqOvRYAJZ+NBRXM7IKXvkjvzXDm
         DYrw==
X-Gm-Message-State: ANoB5plKXnr+OzXQZGhikybpazWQl7nzJodAjydPzYewaBYkllJOVKXf
        quctQa0ajKLZI+s1t+FN9Gc=
X-Google-Smtp-Source: AA0mqf44YXT7PJKgMOOzbTCzBPemFjUOJIc55zCsReyvz+zheLlVMItmRKnrr43yqHs1m759/FsvWQ==
X-Received: by 2002:a05:6402:916:b0:46a:c2d:127f with SMTP id g22-20020a056402091600b0046a0c2d127fmr35238534edz.220.1669812788820;
        Wed, 30 Nov 2022 04:53:08 -0800 (PST)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id v1-20020a1709063bc100b007ad84cf1346sm608426ejf.110.2022.11.30.04.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 04:53:08 -0800 (PST)
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
        netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v2 0/3] add tx packets aggregation to ethtool and rmnet
Date:   Wed, 30 Nov 2022 13:46:13 +0100
Message-Id: <20221130124616.1500643-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

