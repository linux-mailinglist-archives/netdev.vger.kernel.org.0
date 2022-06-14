Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036C354B153
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbiFNMhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354764AbiFNMfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:35:46 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC1A4A91D
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:29 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gl15so16888439ejb.4
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Qv6cvpA9bsDZxIZ5eK8fhQFlWOcpUZOpnGZHRUzsZY=;
        b=J8ShOuX0d4YyiFoMiKs7Z01E4uTdi+9Y21rNS6qM9rvtPH6lXKA58/g3F7wPoKeScV
         klqaEgWuVG9b1LUmd6sgQClrL+g7Ul/BTIpogukKiL8SXZCLzMgE62ji547bendTI8f5
         WahS3N/epKJLR1kn9S9gfTsy+AJIsSc9sr5dwbT0trFqyfy8G3l6xW+DT/IMEokusEdG
         nJSKi13xaQqOVcgytJXxYMc4L6HxvYW9F+e4iGF2H6rlIhjeqzuj2am+jgw50I7YN5yl
         WvxSUaVLWN6s9n5ffnnuv35PEnonNcMSAxJ7A35Izrx6NI2dqDSNjlYPPlzfrHtuoQsY
         nIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Qv6cvpA9bsDZxIZ5eK8fhQFlWOcpUZOpnGZHRUzsZY=;
        b=hIhzwUUra5P6FdIKPnaKe8AjI6CuP9bH6BK/ZC/GBc9Ngbw2Cey/zPoYf8ZZhew/8c
         y3/+6Z4InyMJDqUT+VYdlA4He9Hz3GfrIlvp90DBMTsKP6N0hH06Q/J1hm8H6cajvghC
         kviGDQUE4+LoKftXuxN70K0iIFtpb464fXXkHAEFBGD6cKVmJFFo0eUVfKt2WGdz4HRu
         ZY/L7hLvVVFqKhsAadTvGlJ7EoQdFOrjZojJGjqPKOwCHwoc6KviI5IOzK8HE/GPMmwI
         QSGAt4f0sOyYywf3e0LVMUO+guOhRPLs801w11JsrfIxAetFFCc/bAvSsj8OFFLhvCJR
         t2pw==
X-Gm-Message-State: AJIora/UlWsxExs87JLcjkoAwr+63jrQ9e1unL3W4d674WHjmA68ixwU
        P+/Vhhjuo2sof6owiAFYVbRcUBVB/E+jIcAKf3Y=
X-Google-Smtp-Source: ABdhPJwe9lynRhzdqSJ4TlvMvfCw5w1F+ILNn7ZuXuuXTc5q5s4M6209SX4/TmidFzW+YAOizOpm4Q==
X-Received: by 2002:a17:907:6ea4:b0:711:d106:b93a with SMTP id sh36-20020a1709076ea400b00711d106b93amr4206226ejc.189.1655210008211;
        Tue, 14 Jun 2022 05:33:28 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id lu33-20020a170906fae100b007041e969a8asm4998137ejb.97.2022.06.14.05.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:27 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 00/11] mlxsw: Implement dev info and dev flash for line cards
Date:   Tue, 14 Jun 2022 14:33:15 +0200
Message-Id: <20220614123326.69745-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

This patchset implements two features:
1) "devlink dev info" is exposed for line card (patches 3-8)
2) "devlink dev flash" is implemented for line card gearbox
   flashing (patch 9)

For every line card, "a nested" auxiliary device is created which
allows to bind the features mentioned above (patch 2).

The relationship between line card and its auxiliary dev devlink
is carried over extra line card netlink attribute (patches 1 and 3).

Examples:

$ devlink lc show pci/0000:01:00.0 lc 1
pci/0000:01:00.0:
  lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
    supported_types:
       16x100G

$ devlink dev show auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0

$ devlink dev info auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0:
  versions:
      fixed:
        hw.revision 0
        fw.psid MT_0000000749
      running:
        ini.version 4
        fw 19.2010.1312

$ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2

Jiri Pirko (11):
  devlink: introduce nested devlink entity for line card
  mlxsw: core_linecards: Introduce per line card auxiliary device
  mlxsw: core_linecard_dev: Set nested devlink relationship for a line
    card
  mlxsw: core_linecards: Expose HW revision and INI version
  mlxsw: reg: Extend MDDQ by device_info
  mlxsw: core_linecards: Probe provisioned line cards for devices and
    expose FW version
  mlxsw: reg: Add Management DownStream Device Tunneling Register
  mlxsw: core_linecards: Expose device PSID over device info
  mlxsw: core_linecards: Implement line card device flashing
  selftests: mlxsw: Check line card info on provisioned line card
  selftests: mlxsw: Check line card info on activated line card

 Documentation/networking/devlink/mlxsw.rst    |  24 ++
 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  44 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  35 ++
 .../mellanox/mlxsw/core_linecard_dev.c        | 180 ++++++++
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 403 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 173 +++++++-
 include/net/devlink.h                         |   2 +
 include/uapi/linux/devlink.h                  |   2 +
 net/core/devlink.c                            |  42 ++
 .../drivers/net/mlxsw/devlink_linecard.sh     |  54 +++
 12 files changed, 948 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c

-- 
2.35.3

