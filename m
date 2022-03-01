Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FF04C8BA2
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiCAMb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiCAMb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:31:57 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C50857154
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 04:31:17 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id o6so21662852ljp.3
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 04:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AbGDvCEdi9EHLSnmyMSrzSB68KTWFrajsRKOJhc+Ih8=;
        b=XlpI+0OYsksK3UXmVsGdJ/ER2x8kRi7xQu1bbzlgFcV50tfJz0dg6Yc8DaUFm6mBFR
         QJCcMjs1iLq/e6TZx5nKsbnu2jVIq/1iPeGrz0yCzuNwWB7A9XsbOmEi8gxMijbrngu8
         T+iIDBjtlIflCtmvl4gvKmyze5VePF330M3K+KJ9bFnvifunC4Z0BA/o0U+rzkzlCTu7
         q/rjqbHW3tkfNVkY27uiQ/I8do1LBnVMtQZHQNdMMKBGxKzmEBw7CgznP0zJMDrOQV5w
         sLLgBkEDcXHXtyLsQykg0k/AJEQotXx5TvZD3TYTdEvWBiMeGldLIpPa4EDW6xfOUhCG
         0qhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AbGDvCEdi9EHLSnmyMSrzSB68KTWFrajsRKOJhc+Ih8=;
        b=tNyY2ezQ/m8ZIcp8/CTROiScfKh03UMRJi9aeUXRI+Ci0zT/5sa5f7T6dc7P7zMv4b
         93A2vsYBfDnHDFfMWYb/1UKbRpnE7dfjbRU+Vwa6p7LaDpe2OauT26C5ogxXc68A96Cs
         XxkECTvfo65dzDZ5sWrx6B7Kqkd/umvRnpk7oT9JnLZxZGeVyIDRLOKEhw/rQxGOXZxw
         nlo/KkELG4hbWNsy/F9DAe0QLow2XYaYeATQhfCRAnYNlFuXD4dQfviB/gtHt9eLRi2k
         2onFN+BQP4Y8rVCKPETbPyaF17fyWCPjHHJlMHXy/dJ1c6jdFIFRWiipQtlFxgZwr3m+
         IQ8w==
X-Gm-Message-State: AOAM531yDlDbmQnHfFqIivnjArgAhFm/1ZE3ZubmQozNbf5KSBMOr4M9
        KvhczgIE517Kz+RM0RKktQGun7VrZrf9xN/tHe4=
X-Google-Smtp-Source: ABdhPJw0WJyAR/jBBuKab1aODUGVCQ48Zr5ydEfC4K9YqqOIFgKJDS7nBG5opO6+QAM4JPJ6Rhvckw==
X-Received: by 2002:a2e:908f:0:b0:246:4cf7:69c9 with SMTP id l15-20020a2e908f000000b002464cf769c9mr18132668ljg.149.1646137875049;
        Tue, 01 Mar 2022 04:31:15 -0800 (PST)
Received: from wse-c0089.westermo.com (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id i8-20020a0565123e0800b0044312b4112dsm1470459lfv.52.2022.03.01.04.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 04:31:14 -0800 (PST)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
X-Google-Original-From: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net-next 0/3] bridge: dsa: switchdev: mv88e6xxx: Implement local_receive bridge flag
Date:   Tue,  1 Mar 2022 13:31:01 +0100
Message-Id: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

This series implements a new bridge flag 'local_receive' and HW
offloading for Marvell mv88e6xxx.

When using a non-VLAN filtering bridge we want to be able to limit
traffic to the CPU port to lessen the CPU load. This is specially
important when we have disabled learning on user ports.

A sample configuration could be something like this:

       br0
      /   \
   swp0   swp1

ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp0 type bridge_slave learning off
ip link set swp1 type bridge_slave learning off
ip link set swp0 up
ip link set swp1 up
ip link set br0 type bridge local_receive 0
ip link set br0 up

The first part of the series implements the flag for the SW bridge
and the second part the DSA infrastructure. The last part implements
offloading of this flag to HW for mv88e6xxx, which uses the
port vlan table to restrict the ingress from user ports
to the CPU port when this flag is cleared.

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>

Regards,
Mattias Forsblad (3):
  net: bridge: Implement bridge flag local_receive
  dsa: Handle the local_receive flag in the DSA layer.
  mv88e6xxx: Offload the local_receive flag

 drivers/net/dsa/mv88e6xxx/chip.c | 45 ++++++++++++++++++++++++++++++--
 include/linux/if_bridge.h        |  6 +++++
 include/net/dsa.h                |  6 +++++
 include/net/switchdev.h          |  2 ++
 include/uapi/linux/if_bridge.h   |  1 +
 include/uapi/linux/if_link.h     |  1 +
 net/bridge/br.c                  | 18 +++++++++++++
 net/bridge/br_device.c           |  1 +
 net/bridge/br_input.c            |  3 +++
 net/bridge/br_ioctl.c            |  1 +
 net/bridge/br_netlink.c          | 14 +++++++++-
 net/bridge/br_private.h          |  2 ++
 net/bridge/br_sysfs_br.c         | 23 ++++++++++++++++
 net/bridge/br_vlan.c             |  8 ++++++
 net/dsa/dsa_priv.h               |  1 +
 net/dsa/slave.c                  | 16 ++++++++++++
 16 files changed, 145 insertions(+), 3 deletions(-)

-- 
2.25.1

