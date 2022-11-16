Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E362BADC
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiKPLGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbiKPLFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:05:41 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31062F65F
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:09 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id b9so21327141ljr.5
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lhvq+yPk9YHs3SZzLHCiUbp/k/V3i0C6Yc7lp/O+0Ac=;
        b=ZItvqg3Y5iwl1BlyagnCBcaHRhAiLxB6aBxBOzqhbw/CdQ/zjd0Qnjq5DzH4akmvS1
         WZwo3HmAHe3iS3mrv0pxnM08YbkPyrylqYRitouB+qbhWsUPCDh2/vn0Y8nHKFaiufvP
         awEuXXbBBmserAdvu5eGNM7jCkPYtR0but2bw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lhvq+yPk9YHs3SZzLHCiUbp/k/V3i0C6Yc7lp/O+0Ac=;
        b=5g71xFKcNXkmchrSY2pdLT0JizyUhulBXT6zY1hOvewhz6aZtpGtNM31H5Vaikovwl
         +G5G8IucUvrPT3gGgt3f/Kjvm/m86W5M9BA6R2LboULHWAZ5DkG9LjyB3A4xrnUKMuyY
         3tXgdD5T0zaIAsDyoQSRkZF0pGkm+Y1bU6z34wSujjh1fBozOkJKMA55a4atxs2q2xlJ
         svtIGBl6c6C0da1thXJVJjEeTmMe4rD0uJrMAXDAS0GJKkhd8D59B3MDqBwRf8k+a3tH
         MYIr3lIe72AZ71c3WCf6RL7L1pwDNQVH/Qequ7GFcuNurEy3thalTkE8R4jA65yg7COV
         WuWA==
X-Gm-Message-State: ANoB5pmBclBkPr7IMcWMlyASahECf+Pp5jTM4Xsk7bbpWDFVoMcP7Yql
        LkR95o2oHeCHQhprDCyV4soNdw==
X-Google-Smtp-Source: AA0mqf4MElXivP86yO93rP/JnuKozHXIn9ZmDnr3WX6dKi2BetQpw/815/REBxz5E3enHDBox2Ed4A==
X-Received: by 2002:a2e:7d19:0:b0:277:23f:5f58 with SMTP id y25-20020a2e7d19000000b00277023f5f58mr7074507ljc.303.1668595928292;
        Wed, 16 Nov 2022 02:52:08 -0800 (PST)
Received: from localhost.localdomain ([87.54.42.112])
        by smtp.gmail.com with ESMTPSA id g42-20020a0565123baa00b004b094730074sm2547119lfv.267.2022.11.16.02.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 02:52:07 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v3 0/3] net: dsa: use more appropriate NET_NAME_* constants for user ports
Date:   Wed, 16 Nov 2022 11:52:01 +0100
Message-Id: <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
References: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The intention of commit 685343fc3ba6 ("net: add name_assign_type
netdev attribute") was clearly that drivers be switched over one by
one to select appropriate NET_NAME_* constants instead of
NET_NAME_UNKNOWN. This small series attempts to do that for DSA user
ports.

This is obviously and intentionally user-visible changes, so there's a
small chance that it could lead to a regression. To make it easy to
revert either of the "label in DT" and "fallback to eth%d" changes,
this is done as a refactoring which shouldn't introduce any functional
change (but by itself adds code which looks a little odd, with the two
identical assignments in the two branches), followed by changing the
constant used in each case in two different patches.

Rasmus Villemoes (3):
  net: dsa: refactor name assignment for user ports
  net: dsa: use NET_NAME_PREDICTABLE for user ports with name given in
    DT
  net: dsa: set name_assign_type to NET_NAME_ENUM for enumerated user
    ports

 net/dsa/dsa2.c  |  3 ---
 net/dsa/slave.c | 13 +++++++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

-- 
2.37.2

