Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC08D300066
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbhAVK07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbhAVJsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:48:13 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E16C061352
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:51 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id 6so4449616wri.3
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDwtoHHHtoIGbBAO22mGCE+oSYcsmSPxTKMYD4nngnY=;
        b=J/x6WWXcqvtz8WLCLCZQEj/iKTwAt4cUdLInjxOviaVCtpTdlF7wBnr9M8w0uSXD/0
         sueDyE+PLsN8ANYMdyzCd0uC+2HSWpGxfgTWEC9I46uycwxygrmf6wQSmkAcpQ7yx9nG
         4pj6TepwVFtu5flE3pkPfaahNEAt0yv3oz4Lz9pGCrBUdPzClF1A7xIbqA+R4ZgSGP3F
         CLI3yjKRPlEBqwdIC97jVjIrwvZnMQQ3gNuHHCXaYe+RTUm9jJYJOX+zpIgheUOzIRXa
         3UlDyBAR6qTrIXzy8uORz9g6sqloOjzi1DJyjBpTGJvjNTCK3I79vD3Iq+P+UOHMtktj
         23wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDwtoHHHtoIGbBAO22mGCE+oSYcsmSPxTKMYD4nngnY=;
        b=EpvLpR7kv0XjVPPZWDlboZe0pAe274vsAcB4MN+O0BjP4pP850vxSB9/bM0U1u9bhr
         Bf7KsESrJ19CuXyf+amJmvDtmLK0QJLHE9YqEySrrcsNdisFskRkH1Sg0UF5q5PyxmHz
         IEm5uCmlbbBw17f7ApsB5+zpYGVIjpdyOSUgwEfIr37Yij6jZh5pj2dsyljM0ezJAS9w
         DiazuKTJUTLO1mH3YWEhZ3gI55hGGz0n5z0L5gHulVjfckIFlFr6bdDvpwzdzh2RujWH
         J3TJq5xT1SGs06ch3GuoSXQZ7U6u4dSLSLfAqwQP0hcstYm3weEEPs9j5pYZtPwoltQV
         e7Ow==
X-Gm-Message-State: AOAM532ZTV+nR+2i25taZNL7o7yY/xy9T4WcScAtuAXp8Vdg78puJzIR
        euPUFjrw+B/ERu5u6pqW3MX4UukWmjZy0LoBb4A=
X-Google-Smtp-Source: ABdhPJzcmaEVKPoaFktJkA3WliOMAxiOJF9YCBfkqxyJqeIxfYPN2M1BsR8J+wKdVHoz2JO4kaIVTA==
X-Received: by 2002:adf:d085:: with SMTP id y5mr3691056wrh.41.1611308809909;
        Fri, 22 Jan 2021 01:46:49 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id m82sm11158364wmf.29.2021.01.22.01.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:46:49 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch net-next RFCv2 00/10] introduce line card support for modular switch
Date:   Fri, 22 Jan 2021 10:46:38 +0100
Message-Id: <20210122094648.1631078-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

This patchset introduces support for modular switch systems.
NVIDIA Mellanox SN4800 is an example of such. It contains 8 slots
to accomodate line cards - basically replaceable PHY modules.
Available line cards include:
16X 100GbE (QSFP28)
8X 200GbE (QSFP56)
4X 400GbE (QSFP-DD)

Similar to split cabels, it is essencial for the correctness of
configuration and funcionality to treat the line card entities
in the same way, no matter the line card is inserted or not.
Meaning, the netdevice of a line card port cannot just disappear
when line card is removed. Also, system admin needs to be able
to apply configuration on netdevices belonging to line card port
even before the linecard gets inserted. The nature of a line card
is not "a pluggable device", but "a pluggable PHY module". 

To resolve this, a concept of "provisioning" is introduced.
The user may "provision" certain slot with a line card type.
Driver then creates all instances (devlink ports, netdevices, etc)
related to this line card type. The carrier of netdevices stays down.
Once the line card is inserted and activated, the carrier of the
related netdevices goes up.

Once user does not want to use the line card related instances
anymore, he can "unprovision" the slot. Driver then removes the
instances.

Patches 1-5 are extending devlink driver API and UAPI in order to
register, show, dump, provision and activate the line card.
Patches 6-9 are implementing the introduced API in netdevsim

Example:

# Create a new netdevsim device, with no ports and 2 line cards:
$ echo "10 0 2" >/sys/bus/netdevsim/new_device
$ devlink port # No ports are listed
$ devlink lc
netdevsim/netdevsim10:
  lc 0 state unprovisioned
    supported_types:
       card1port card2ports card4ports
  lc 1 state unprovisioned
    supported_types:
       card1port card2ports card4ports

# Note that driver advertizes supported line card types. In case of
# netdevsim, these are 3.

$ devlink lc set netdevsim/netdevsim10 lc 0 type card4ports
$ devlink lc
netdevsim/netdevsim10:
  lc 0 state provisioned type card4ports
    supported_types:
       card1port card2ports card4ports
  lc 1 state unprovisioned
    supported_types:
       card1port card2ports card4ports
$ devlink port
netdevsim/netdevsim10/1000: type eth netdev eni10nl0p1 flavour physical lc 0 port 1 splittable false
netdevsim/netdevsim10/1001: type eth netdev eni10nl0p2 flavour physical lc 0 port 2 splittable false
netdevsim/netdevsim10/1002: type eth netdev eni10nl0p3 flavour physical lc 0 port 3 splittable false
netdevsim/netdevsim10/1003: type eth netdev eni10nl0p4 flavour physical lc 0 port 4 splittable false
#                                                 ^^                    ^^^^
#                                     netdev name adjusted          index of a line card this port belongs to

$ ip link set eni10nl0p1 up
$ ip link show eni10nl0p1
165: eni10nl0p1: <NO-CARRIER,BROADCAST,NOARP,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff

# Now insert the line card using debugfs. That emulates plug-in even
# on real hardware:
$ echo "card4ports"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/inserted_type
$ ip link show eni10nl0p1
165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
# The carrier is UP now.

Jiri Pirko (10):
  devlink: add support to create line card and expose to user
  devlink: implement line card provisioning
  devlink: implement line card active state
  devlink: append split port number to the port name
  devlink: add port to line card relationship set
  netdevsim: introduce line card support
  netdevsim: allow port objects to be linked with line cards
  netdevsim: create devlink line card object and implement provisioning
  netdevsim: implement line card activation
  selftests: add netdevsim devlink lc test

 drivers/net/netdevsim/bus.c                   |  21 +-
 drivers/net/netdevsim/dev.c                   | 425 +++++++++++++++-
 drivers/net/netdevsim/netdev.c                |   2 +
 drivers/net/netdevsim/netdevsim.h             |  26 +
 include/net/devlink.h                         |  44 ++
 include/uapi/linux/devlink.h                  |  23 +
 net/core/devlink.c                            | 463 +++++++++++++++++-
 .../drivers/net/netdevsim/devlink.sh          |  62 ++-
 8 files changed, 1040 insertions(+), 26 deletions(-)

-- 
2.26.2

