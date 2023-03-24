Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840DE6C7D4B
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjCXLiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCXLiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:38:22 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622893AB5;
        Fri, 24 Mar 2023 04:38:21 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id i9so1488234wrp.3;
        Fri, 24 Mar 2023 04:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679657899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F2BYJTtH+6qSJde/8HBl8IV/H0stxtKSWTZU8xEf34g=;
        b=jSNi3gluYJ76YRNRcZaXUOOarLImeBLvnFKo7d0INWUaCQjXxP9CA0MkNV9pNvFPKR
         fdilkZBJOYf11Z8JJQsxq3vpO3wu0Nrkq53SQT0VmKhTbeZofmSt2pTwuHOn2E7GUeAt
         /O5f+iNUHcdW00j9WbqQzCgz9HVKlRcDathR3q/4cNW56PaQAUJ29i0yJZv8nlyORTtC
         JCa8zNMWlN1RaW4SYS5F9shdgDBpuWXc2pkX1zZu9gGLlRpucvtvFu8EMcINCdW1gmuc
         vgmpQCo2Wfdgqkxp1FlGFHptqeueS9EN79rkVTqoMSimqyfzJLSpECxGR5yUXqF4k8uE
         YY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679657899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F2BYJTtH+6qSJde/8HBl8IV/H0stxtKSWTZU8xEf34g=;
        b=iG93/hd5pnP8bjKXKJ43QPipAv4Vo+DMh90UupZbnVv35lg24C2CP/wGFnFrGy9brA
         /msevM8qXKmBNTGT6qhlDWS5kFuQUCYA66YxeXd8f4XeIqW12UVp4lC/N3KwreGOCRbK
         qQN7Uz7ujUepVAa0LOT0MtTM9G6C1JZwdVzShHtLjtX5x4rtO5nM+xLFPqsV5VLldj7z
         MCn2tJnXCflRcQ2EHdH32az9VLAGUqti2/QSDlvtuPQoM4PzivkZoLEgUdEpY5a8dBS7
         UuFk0j5yCxxa7rXwi2veDmXxScf9WWnQ/O3T5w+VvE6bKaoWXI1dvM6NX1CvVYcHvLDh
         3WvA==
X-Gm-Message-State: AAQBX9d2ziZRbDStFWpZaebG8jBrsPxaoZCfKjvTdGK+D0MZ0zFiaFht
        C2/DzQliBbjuK3xxOwon7he60JWVP7t/FA==
X-Google-Smtp-Source: AKy350ZOH0YQmXLutMqQ2/N8ziyEsFodw+xl1WR7wVM83mykG/naTnS92fnHSFsO3Fddwe0IoIau6A==
X-Received: by 2002:adf:db07:0:b0:2d1:6b10:f33c with SMTP id s7-20020adfdb07000000b002d16b10f33cmr1966584wri.14.1679657899277;
        Fri, 24 Mar 2023 04:38:19 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:cd72:bbb4:8d1:483a])
        by smtp.gmail.com with ESMTPSA id t6-20020adff606000000b002d828a9f9ddsm10150954wrp.115.2023.03.24.04.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 04:38:18 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v3 0/7] ynl: add support for user headers and struct attrs
Date:   Fri, 24 Mar 2023 11:37:27 +0000
Message-Id: <20230324113734.1473-1-donald.hunter@gmail.com>
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

