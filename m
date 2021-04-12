Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B01635B97D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 06:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhDLEZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 00:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhDLEZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 00:25:42 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9A0C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 21:25:24 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id o17so3635516qkl.13
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 21:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yhzm6p+bjR9fRq+1LQF6CgbIE6TbP47J9WNxvruU9cU=;
        b=aTJoTwUD1bV0n5/0BoAtYe65cjbqNz1ofsrHE1xcZG6SsD6LUqldDc3XkG5EQBOYwD
         ZyR+Xxq2CW8xpbI+AmySOmV86/AsO0DCsbbFUOx7/dKYR+03ic3T4rDBDK9yyYnKSf/n
         KvGvCrW0D/WkrDk+wWmgoj/rtzKfFDRQTOTMjtrihKsyeKRjMr9y5ZUAJzOXR3CyegMS
         ngLQWnbHY+mhtT4epeqn+27EJcvaNpXY6M16aMcIWNVfQU81mmt6ntL0sKL3dl9u8xYH
         HudaaFPjwojAKABCaYjw6xUJ4e0ZXhfNADtV1PzBs4GRRadkWiGxjohOYssrS8pDdYYI
         X7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yhzm6p+bjR9fRq+1LQF6CgbIE6TbP47J9WNxvruU9cU=;
        b=tkIaHPiG5rijnEhiWDk5jKj1xE3dhCOccR3QWOmcnuBjtVQK5yuVKW2YspKbePInOK
         o91cr3Uu+QjepYsKXSy8NgLlZDb52kJduS77pGf0MrC/QvcEuw5W5mYMOGKuBZSaqyh9
         c3R/jM7XPxsv2Dig35By2OwK7gfAFRX6O+XzvdjD6DfWxvoWyF0pY99o0vtbFV44Fr/2
         Emv8BC8QqzekuTKyB1zohx1t1sd1PaC+G9bAyQ/3dSFc8L2SFa09u23ukZg2pEfV2VXe
         x93k/KidOVl+gHkfBZZodr1dVsTkM7fDvjo2Y17xk/YUmfkZF/W0HX3ohnB/4NQqDCP4
         GMXg==
X-Gm-Message-State: AOAM531f26gbT6aCAeyWDy9rzMQMOaqzPcxVyWeNmBdbvssq3ydalhZb
        FSStm0phk8Xz2n9CoUFuoRbRiNtW+4D4FA==
X-Google-Smtp-Source: ABdhPJxxGx/NXBAuJgaWRdZ+IammQE+rCP6YtcQnJ/zTL4bovEeYAycCigegqp0T4oAzUtUrRJWWLA==
X-Received: by 2002:ae9:f719:: with SMTP id s25mr25509198qkg.42.1618201523658;
        Sun, 11 Apr 2021 21:25:23 -0700 (PDT)
Received: from jrr-vaio.onthefive.com (2603-6010-7221-eda3-0000-0000-0000-1d7d.res6.spectrum.com. [2603:6010:7221:eda3::1d7d])
        by smtp.gmail.com with ESMTPSA id a187sm7090996qkd.69.2021.04.11.21.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 21:25:23 -0700 (PDT)
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
X-Google-Original-From: Jonathon Reinhart <Jonathon.Reinhart@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jonathon Reinhart <Jonathon.Reinhart@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 0/2] Ensuring net sysctl isolation
Date:   Mon, 12 Apr 2021 00:24:51 -0400
Message-Id: <20210412042453.32168-1-Jonathon.Reinhart@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is the result of an audit of /proc/sys/net to prove that
it is safe to be mouted read-write in a container when a net namespace
is in use. See [1].

The first commit adds code to detect sysctls which are not netns-safe,
and can "leak" changes to other net namespaces.

My manual audit found, and the above feature confirmed, that there are
two nf_conntrack sysctls which are in fact not netns-safe.

I considered sending the latter to netfilter-devel, but I think it's
better to have both together on net-next: Adding only the former causes
undesirable warnings in the kernel log.

[1]: https://github.com/opencontainers/runc/issues/2826

Jonathon Reinhart (2):
  net: Ensure net namespace isolation of sysctls
  netfilter: conntrack: Make global sysctls readonly in non-init netns

 net/netfilter/nf_conntrack_standalone.c | 10 ++----
 net/sysctl_net.c                        | 48 +++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 8 deletions(-)

-- 
2.20.1

