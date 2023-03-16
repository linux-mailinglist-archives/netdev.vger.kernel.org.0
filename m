Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F3A6BCEDC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 13:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCPMB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 08:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCPMB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 08:01:56 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D5DC2DBA
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:01:54 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id f1so998137qvx.13
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678968113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zGSYxFpfPqliNEIzuhLxL5wVz3x0a0qjbmPNzIUYOIQ=;
        b=WM/D2v9fjsYERF8WAwYwFQENruXpako7FpQ0E0a7juFuoimxNRbHYUQIA3DM/NyXpI
         LrIw08SzgwF5XQSDURlDl/HT7oLcqhJ9bTxIKITYsrljE8aTpYB1JXwMzvRuYdPau0/d
         oC/xjwasq1F3BQEh6Q4rrwiv9+hch8vDYOs5PgM92vur4TQrQopJHGpZ27GLaYcMS9ub
         kp9B0XWEKqjTPgxTGg7cOsbrWhGIRMfQ10hWufuNdGq+lcHzOIP9ToqQg/h9XtwSjWK4
         QLwYpP8aHI/fEUjyNod3tnxqQhSranOXOiJnbYwZhcI0HBQ02Whcpa7YHsxa3yilUJ6J
         7xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678968113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGSYxFpfPqliNEIzuhLxL5wVz3x0a0qjbmPNzIUYOIQ=;
        b=5hLKJST+qW67UtbDcam8yeS5axrzgT23L+/9xG68XiF2jzuKwhpctZV+5+dAr6gVvn
         BXoF63hn1FEHSBEwmdE0D651d02AzVSw3OM/oxF/Mc6vJzDsJQGOTKZjDtItrcLCqmsE
         aZrQdfzwNTC3Mok+p2ZhD1Az/oFFHYh2q8awDEA9lkxt1a03tMb1+EZCeSPDKBMm/Scj
         Dakpby5nuiGjhpbCSUByQ6mbp/u2geKwcanaQNMmognb9ydcmYt+9KYFG2RhoVDv5pEV
         F7nrZQ+fKj06s47h9O+2KRADw82qIcKoWmW5qMIf4+NVPx792AZy30gINqaRj4dVWlv1
         C6hw==
X-Gm-Message-State: AO0yUKXGXAa86tjAJPuGns87qAyE+mxkz1Yo1EBIFrbtAa7mypci2Tz4
        VvqBCEHdHiUKAQG1duQDDaBHfF5uXeqmIg==
X-Google-Smtp-Source: AK7set/yPNOaHcuLu7pynkExNpfJpWTHoxAT54qqIYKYsCIg+sgLEGhIC7gflZ4tJLVDww+KhIpMVg==
X-Received: by 2002:a05:6214:1c87:b0:537:7d76:ea7c with SMTP id ib7-20020a0562141c8700b005377d76ea7cmr30203928qvb.25.1678968112902;
        Thu, 16 Mar 2023 05:01:52 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:dc26:c93f:e030:938d])
        by smtp.gmail.com with ESMTPSA id g14-20020a05620a218e00b007457bc9a047sm5643743qka.50.2023.03.16.05.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 05:01:52 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1 0/2] ynl: add support for user headers and struct attrs
Date:   Thu, 16 Mar 2023 12:01:40 +0000
Message-Id: <20230316120142.94268-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for user headers and struct attrs to YNL.

Patch 1 adds the capabilities to YNL.
Patch 2 adds partial openvswitch specs that demonstrate the new features.

Donald Hunter (2):
  tools: ynl: add user-header and struct attr support
  netlink: specs: add partial specification for openvswitch

 Documentation/netlink/genetlink-legacy.yaml   |  10 +-
 Documentation/netlink/specs/ovs_datapath.yaml | 154 ++++++++++++++++++
 Documentation/netlink/specs/ovs_vport.yaml    | 141 ++++++++++++++++
 tools/net/ynl/lib/ynl.py                      |  58 ++++++-
 4 files changed, 355 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/netlink/specs/ovs_datapath.yaml
 create mode 100644 Documentation/netlink/specs/ovs_vport.yaml

-- 
2.39.0

