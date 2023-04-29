Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D045E6F2706
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 00:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjD2Wkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 18:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjD2Wkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 18:40:52 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6607E57
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 15:40:51 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 6a1803df08f44-5ef6135d2a8so6340496d6.3
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 15:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682808049; x=1685400049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=diDxLhsgU6EFglhybp+rqfDFsscOUs4tz2zLzJ9SxXo=;
        b=Lnjdk5Mn1ZhPcO0wA2/FFmT8YJQEnPD8eEO8OOUaxv0qScxDLOZBL3s2D5kkHioj9q
         /DsbVXcZlZbt2C81CxPyDVfeqBBmHGhYNUioLOm7VRSPmXyJ0ekVWLxKmfn5IgIgVbSY
         X+wtsZuBq9MekJ1mV07MZdI5dxESDJrIGFQtktTCAiP/G7PVqingppA1jLtQexnjO8au
         aEEqSbV9dX9CZa2/ZBs4Im1R+PosLoZBTi2PbiOKoMRGGzSvCamKw9saBqV7zvVasfaB
         SvlfvCmIrrwLpUkZNE1+hC6QQn6+RcEy4IRQov8Rt3PvVL9SyvluSFK3PQcKTzvJA9xl
         Nktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682808049; x=1685400049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=diDxLhsgU6EFglhybp+rqfDFsscOUs4tz2zLzJ9SxXo=;
        b=VfRClrOgfCia0ArLjgA33tVz3021erzxi8pq1EJ7MRTQBSmSG8lro89pDxcIKcLwYL
         ZpXBwDZ3kQ5BVEam2j6bwkgM0a5XJR2VJIUxRl+B6GXUpqAGaJOXoAwlOuH+5E8xzFPZ
         Pps/Ip8/XR7nFM2ipRJYEiYvyHMIsi3/mg7y/uwjYLcN9C8jSTxWiBokfrMiR6EXiSsf
         Ln4AGLyN4pJwgabvazgOoUOA1FznedII8p09AHFAJHhcUYMCkoZRT6s5cb2AmyR3n6za
         Hcfv/BK2E35Xmv6ZiCPthyo1BpELrj/BD4NnJWoVnNw97I3cLMEEgOmGf/DDfl3wUUsl
         5oXQ==
X-Gm-Message-State: AC+VfDwMgsRkXn2UDydu9hJZBmygnpLqy3O2xeagUu6+HeM3Es7VNLri
        CYWcetqdbjLa3j9tQplS4c+vnBwBvHNWxw==
X-Google-Smtp-Source: ACHHUZ7HMExoo7A+NkHyx1xtP6vJ0x2rKCMmv7XOOmZLImcBHV8prEEpiAFcIGseAsxc5v1NIYUSiw==
X-Received: by 2002:a05:6214:2247:b0:5ea:d52:7042 with SMTP id c7-20020a056214224700b005ea0d527042mr19591713qvc.31.1682808049169;
        Sat, 29 Apr 2023 15:40:49 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p12-20020a0ce18c000000b00606322241b4sm6595741qvl.27.2023.04.29.15.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 15:40:48 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>
Subject: [PATCH net 0/2] tipc: fix the mtu update in link mtu negotiation
Date:   Sat, 29 Apr 2023 18:40:45 -0400
Message-Id: <cover.1682807958.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
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

This patchset fixes a crash caused by a too small MTU carried in the
activate msg. Note that as such malicious packet does not exist in
the normal env, and the fix won't break any application.

The 1st patch introduces a function to calculate the minimum MTU for
the bearer, and the 2nd patch fixes the crash with this function.

Xin Long (2):
  tipc: add tipc_bearer_min_mtu to calculate min mtu
  tipc: do not update mtu if msg_max is too small

 net/tipc/bearer.c    | 13 +++++++++++++
 net/tipc/bearer.h    |  3 +++
 net/tipc/link.c      |  7 ++++---
 net/tipc/udp_media.c |  5 +++--
 4 files changed, 23 insertions(+), 5 deletions(-)

-- 
2.39.1

