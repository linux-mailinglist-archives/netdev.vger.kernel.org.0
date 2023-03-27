Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CDD6C9DFF
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbjC0Ihg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjC0IhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:37:09 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217349EFE;
        Mon, 27 Mar 2023 01:31:54 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r29so7742550wra.13;
        Mon, 27 Mar 2023 01:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679905911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HjNj28/Jhl8ERT2Gnc3byTIO3nUY9uGnzk3NiQJVKjI=;
        b=JdkO1R4MTFSIMrDa56x/MU24Z68WDwhUPUdjH4CPAcEhzhEyfz3htowkfCOWMcsz1N
         VRgfPekM0R6dUffH8iMhSfHv8358NG09aC9LMAfZsU17tLK9nNEgfSt91NMV0INgo3uD
         3nIZModLFVQXyp3SPuzAJ3M2GKhC2cxr/DhwbSyOyJtA6jpYHNe3WTrss9Xo+T4JKzG7
         RX46RIhHYJAVAqKqZYy0qW0jSew1OxWYs6Stetz8pXMyDgBgZT7j/Z1xDVvfQ7c8VdKj
         SoAEumYx6cLNwWTL0GHGkoT2Hj4uCF16Es3+FICOdjpKwAHmKgto5Hj7XAMKoVHi6ONA
         yXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679905911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HjNj28/Jhl8ERT2Gnc3byTIO3nUY9uGnzk3NiQJVKjI=;
        b=GjlDB98sL488pBB23gAkchDzhxBQT/V2u0rMgYEl/oR6/xjBzHTDrbvn2TE9KV8O0e
         nJcS1GXqHT++GzTmBSn4xqv4qE7OwP2SWw6Q5XZJmc7TMZPGjAA9NvPdw489wdhlGIRo
         zKpDkB7aex2YyLdOjvCwzM0fFGYqjTJqORRSaIAkUBzlYkyagMPZKSmY6iHHTb1oXjre
         NKFHlDwFV+AdtRWZSLgF42MbMHN4Fs4vUdgR5Gzh7C4inxWEaUhwh57yJPx5rQ1YsNin
         HPj1+iI43yVSowpfLfvpkCn0nqBC5EfAmvYkS9WP0wcPwYCJ685s3Zv22K9JpR63vTuS
         mTWg==
X-Gm-Message-State: AAQBX9eYY7JF3ee/PeCGIHjYL+YWTPiWpjbCbPl8Zjlz7LOPwB5SDOj8
        TCh01KCuCP++ZbmuSEW6zxxidUO4SZlJ5g==
X-Google-Smtp-Source: AKy350ZjJQa9J6vaKWYLO2Hbe8n54pRri4fDbfsglS2P7q7tUlItjIQS+9ejW7SaahqLxYSE9UVxiw==
X-Received: by 2002:adf:f544:0:b0:2cf:f2f9:5aab with SMTP id j4-20020adff544000000b002cff2f95aabmr9169193wrp.20.1679905911332;
        Mon, 27 Mar 2023 01:31:51 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm24353249wrw.99.2023.03.27.01.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:31:50 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v5 0/7] ynl: add support for user headers and struct attrs
Date:   Mon, 27 Mar 2023 09:31:31 +0100
Message-Id: <20230327083138.96044-1-donald.hunter@gmail.com>
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

v4 - v5: all requested by Jakub Kicinski
 - Describe C struct packing sematics in docs
 - Rework struct example
 - Change sub-type doc to use text from Jakub
 - Add struct_name and sub_type as fields of class SpecAttr
 - Fix typos and wrap at 80 chars
 - Clean up signature formatting in python code

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

 Documentation/netlink/genetlink-legacy.yaml   |  16 ++
 Documentation/netlink/specs/ovs_datapath.yaml | 153 ++++++++++++++++++
 Documentation/netlink/specs/ovs_vport.yaml    | 139 ++++++++++++++++
 .../netlink/genetlink-legacy.rst              |  88 +++++++++-
 Documentation/userspace-api/netlink/specs.rst |  10 ++
 tools/net/ynl/lib/nlspec.py                   |  73 +++++++--
 tools/net/ynl/lib/ynl.py                      |  55 ++++++-
 7 files changed, 516 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/netlink/specs/ovs_datapath.yaml
 create mode 100644 Documentation/netlink/specs/ovs_vport.yaml

-- 
2.39.0

