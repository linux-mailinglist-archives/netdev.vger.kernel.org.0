Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865826C85B3
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjCXTTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCXTTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:19:16 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECDE30E8;
        Fri, 24 Mar 2023 12:19:14 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 59so2240969qva.11;
        Fri, 24 Mar 2023 12:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679685553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6XtwHNRoh1C9C0xfCvvrQVFXFeZEucO7O/XihUeWbwQ=;
        b=LtLleDLZL7Ws4NHtBTk38BrqWv2x9H/wo44YKOBj2pHuEs5WZsSDMd5V5vbJchvSFX
         Js0MRk2Kuqa1ecRqbWQIeX7v8Gkwo3IQEl1j26xtN1sX9mFWwKhSPT8Mdq4z0GTOR2zS
         2Ys5LNJ0ePiezJ864oumYC0P1KruxtC9f0Fq5jzzOmsivgbyLMTVujds7pVKBfJ2y0JR
         Pj2n32v+nEeeenTEe7LGBzKb7PFqZd+KzEP9nJc4QQkc9zTqH3+xzgHIQZAu5cNmUEdO
         WiR2ZGRb2hTOtCak4jhZpDjBaeFAzyMrgtXxKBoxusc/u0lN59SzPFzW0A6bAtRGzfqX
         moRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679685553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6XtwHNRoh1C9C0xfCvvrQVFXFeZEucO7O/XihUeWbwQ=;
        b=vA9yID7LsMKH/wUTvsVYCYDnuphk1A8Mxm6j7HBo33N1X2z5XTNluNVleAp+NPpO3w
         u2KcIsl5o3VDTxzOGPcMz2YbhiwITFBAAMmN/NmvXf4+xAfK6zDSqG3CZP0iHb1j9cDx
         Qiebd+IriBTkAsJ3itDo+Owya4KjmREzo9XLlVdU5xV+2RWu1HDKDjQi9mOkw7IoROCa
         D68Y7SwvVoyjrXU5b0Z3IAbaJgdnOhHORiZsF1YlbrocgLagZjsvg5EhYHuxevAbJDsE
         2xpBP93avqSTDjcWgwEUQr634WfxGimkNRLhHmO3uhiCBZantr3O3Vip+qTJcHILykRM
         6Y1Q==
X-Gm-Message-State: AAQBX9e3KTv5B0krfkZgPIvqhNgROjVg/wD1kp/4zPHqyDemB8rgFi5I
        WI1dcEKuX5ogxfznYhnSOTbSurCakh9DFQ==
X-Google-Smtp-Source: AKy350ZGazv0VlvRoHFzTqqt+/58ktVcnlNvXANfjzhkXf6M8wwfDO5yMg2PRdhkO4QbFeU0v+K0Sg==
X-Received: by 2002:ad4:5d6f:0:b0:5b5:9c2:8c29 with SMTP id fn15-20020ad45d6f000000b005b509c28c29mr6814524qvb.12.1679685553134;
        Fri, 24 Mar 2023 12:19:13 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id cn5-20020ad44a65000000b005dd8b9345e1sm900141qvb.121.2023.03.24.12.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 12:19:12 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v4 0/7] ynl: add support for user headers and struct attrs
Date:   Fri, 24 Mar 2023 19:18:53 +0000
Message-Id: <20230324191900.21828-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for user headers and struct attrs to YNL. This patchset adds
features to ynl and add a partial spec for openvswitch that demonstrates
use of the features.

Patch 1-4 add features to ynl
Patch 5 adds partial openvswitch specs that demonstrate the new features
Patch 6-7 add documentation for legacy structs and for sub-type

v3 - v4:
 - Rebase to net-next after net-6.3-rc4 merge

v2 - v3: all requested by Jakub Kicinski
 - Drop genlmsg fix that was applied separately
 - Don't mention 'kernel' types, leave it to schema
 - Avoid passing fixed header around in python code
 - Use 'binary' with 'sub-type' for C arrays
 - Use 'binary' with 'struct' for C structs
 - Add docs for structs and sub-type

v1 - v2: all requested by Jakub Kicinski
 - Split ynl changes into separate patches
 - Rename user-header to fixed-header and improve description
 - Move fixed-header to operations section of spec
 - Introduce objects to represent struct config in nlspec
 - Use kebab-case throughout openvswitch specs

Donald Hunter (7):
  tools: ynl: Add struct parsing to nlspec
  tools: ynl: Add C array attribute decoding to ynl
  tools: ynl: Add struct attr decoding to ynl
  tools: ynl: Add fixed-header support to ynl
  netlink: specs: add partial specification for openvswitch
  docs: netlink: document struct support for genetlink-legacy
  docs: netlink: document the sub-type attribute property

 Documentation/netlink/genetlink-legacy.yaml   |  15 ++
 Documentation/netlink/specs/ovs_datapath.yaml | 153 ++++++++++++++++++
 Documentation/netlink/specs/ovs_vport.yaml    | 139 ++++++++++++++++
 .../netlink/genetlink-legacy.rst              |  68 +++++++-
 Documentation/userspace-api/netlink/specs.rst |   9 ++
 tools/net/ynl/lib/nlspec.py                   |  64 +++++++-
 tools/net/ynl/lib/ynl.py                      |  55 ++++++-
 7 files changed, 488 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/netlink/specs/ovs_datapath.yaml
 create mode 100644 Documentation/netlink/specs/ovs_vport.yaml

-- 
2.39.0

