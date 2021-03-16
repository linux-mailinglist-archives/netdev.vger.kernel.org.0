Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700C233DC52
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbhCPSOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239903AbhCPSNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:13:25 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB54CC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:13:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id bf3so22651565edb.6
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 11:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LFfq0jIxvvTczaJIVUd5rU6kQnhHlHtaOe9J6Hapl4o=;
        b=1XOiACGDxIM+TB34mPsol8NYvrzfvP3JXCXvBKW8Gctz8MGBYGwZy1kBIjULsZICXF
         7PZbnWWEN+m6ATkTXGVgs/mgV7+0SZof5/96MMDpHIIJepmnjKYG/pdjR88ZVTyK3hk9
         FntGGntD2XvRsAsimzCSO/1IdDV3fbQ6sTr6CFaALU/P5jJ1fCksKdjXiGF3zQaJ9oq+
         A6C7uFkIbKvQpnr2MocZ8yKLlWCyUViFt4PB361K1kfnxi8AtY23Tq1L3Oh8IpgyxTIw
         IFmnTaydQicNy58+PX9jXTpAJ7lpkuvyM4pfmJShNkxpA0gGSgawLULuzk5FeSS0ctxw
         9y5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LFfq0jIxvvTczaJIVUd5rU6kQnhHlHtaOe9J6Hapl4o=;
        b=J+txvyNA3Po/PsWzy23N0K2MzTHn2gZwPpianJbjSeFqHXLCycaVVkIk8ON7vSJO7V
         tizlI7mtZyHcc+EhewcMHY56//jvQgc/fx/RPIYmUExvMssUhyqD5H0meBS4JAVogqyG
         ng8UOhKcDKLbmTbUaRwV3TWd7ZdIsD/jJhIz/98LMIKOQ0Q7b/XCxN2bEcPlzKRRPFUK
         T5Ux49j/XswnASCbQCNQGa16sPbAlddq2Cr8HH6sS/J2diPAifRqYyx4yk/RWVXZQH+h
         JpwpiSBme6V4VvjNMFnbDn0QXrAFGY3Dl4anf+okterbkHDG86uEbZbZ0t8Alo82DQEm
         BVNA==
X-Gm-Message-State: AOAM532qCICSPOsQ9i9zMBfODXtAFuTe5r4wbQ/ZF8eKUWcqEZMnlHK8
        6f4XA0n9QlS0Vqv2dGLowUlkLw==
X-Google-Smtp-Source: ABdhPJwQjaCP+1FV6bMruF+ENyUQ2hRi10crfQ8XhPHZ1Et4sO/yASzlqxXgOCVzAeaP6rPLS41egA==
X-Received: by 2002:aa7:d7da:: with SMTP id e26mr38057781eds.269.1615918402618;
        Tue, 16 Mar 2021 11:13:22 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id e26sm11537778edj.29.2021.03.16.11.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 11:13:22 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 0/3] Fixes for nfp pre_tunnel code
Date:   Tue, 16 Mar 2021 19:13:07 +0100
Message-Id: <20210316181310.12199-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Louis Peens says:

The following set of patches fixes up a few bugs in the pre_tun
decap code paths which has been hiding for a while.

Louis Peens (3):
  nfp: flower: fix unsupported pre_tunnel flows
  nfp: flower: add ipv6 bit to pre_tunnel control message
  nfp: flower: fix pre_tun mask id allocation

 .../ethernet/netronome/nfp/flower/metadata.c  | 24 +++++++++++++------
 .../ethernet/netronome/nfp/flower/offload.c   | 18 ++++++++++++++
 .../netronome/nfp/flower/tunnel_conf.c        | 15 ++++++++++--
 3 files changed, 48 insertions(+), 9 deletions(-)

-- 
2.20.1

