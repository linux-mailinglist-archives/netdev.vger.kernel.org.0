Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B855A5F00
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiH3JPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiH3JPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:15:14 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40CA5D12C;
        Tue, 30 Aug 2022 02:15:12 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 199so10683437pfz.2;
        Tue, 30 Aug 2022 02:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=1YatiKId/nj4drK3e2iwJNfEimcD7UODu6LflTCrDfg=;
        b=jg5fvjMeAC+3jPEplPKkRHxF3l0F+HtE/sYbQqaGwsosPYAV8azEAQtPUJLDUJXrT4
         JQ1gqXqT0iJUHwV6Fk/fCRttHUmz0p5Hj+Wt3nJYV/Yvy9bb1Nh9U1gcVsLr0SSGG9Si
         PkNOzj9tZuIQ9VZ/c8rnagnB8hFgS5CZR51hZ1MTNDEYzqZ1D43XkMToM8xkCrlbZX+u
         Nu5oW0v0JJPEzemlV8JQQfNu9CehEEW+dseJgvea4sWQQqU0U4h4bW5a/3vUaCwdYufE
         pWipZUP9CWhoEVt4ea4gBVEbU/bmzyxm/c0yJi7U0YihXt4Xgnh7OmodU87bRlZ0KdQP
         APOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=1YatiKId/nj4drK3e2iwJNfEimcD7UODu6LflTCrDfg=;
        b=NNPfS29D9MoPOZbv4RsqQnM5Hn5PJNsQdCfTzEpJI4AErVNNcYYXAWQ6o8oXgKq+Fs
         LL7NEaNibXeuCIeocKQTlXFnd6ZrPw+IBNepdNCYjtn0aI9nJr7syF9R++W+lIJggYOO
         SturP5lGkWyV17NBQ7G27oXJiT+hPkTt2Ft4dHIdRNs9iQ6BryqVW31Q4EHFG2ftYVlT
         RdK6uXUclfCVaIws78XbC+m51T7FyJft6cmm0FMOrz35H/jsoHT6QI8tdVDYCKlOik+c
         yhH3n5EUnhzWY+QCP4odLOUj4KV56LhC6lMFKNVdM9GPFMzj+VyuMoLJr7kOsbd3YTNP
         dB+g==
X-Gm-Message-State: ACgBeo1P4IoaRp4B/vxFwpY2v+PCnF5VgaEyGvvuprQvDJQrp5S9VJ0J
        zZQLr7gtwHjdjTrrKXVeu1KWUKMwUtw=
X-Google-Smtp-Source: AA6agR74JLD8v1fTz0PnqUxhyNWWQkDpSHEQ2ejTQ1m12kEE6QKZP1U9XbMR1WxEJrkd920K+aSqwg==
X-Received: by 2002:a63:2603:0:b0:42c:f0a1:aed7 with SMTP id m3-20020a632603000000b0042cf0a1aed7mr2709935pgm.82.1661850912219;
        Tue, 30 Aug 2022 02:15:12 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902ce0600b0015e8d4eb1dbsm9107543plg.37.2022.08.30.02.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:15:11 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn
Subject: [PATCH v3 0/3] Namespaceify two sysctls related with route
Date:   Tue, 30 Aug 2022 09:14:53 +0000
Message-Id: <20220830091453.286285-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: xu xin <xu.xin16@zte.com.cn>

With the rise of cloud native, more and more container applications are
deployed. The network namespace is one of the foundations of the container.
The sysctls of error_cost and error_burst are important knobs to control
the sending frequency of ICMP_DEST_UNREACH packet for ipv4. When different
containers has requirements on the tuning of error_cost and error_burst,
for host's security, the sysctls should exist per network namespace.

Different netns has different requirements on the setting of error_cost
and error_burst, which are related with limiting the frequency of sending
ICMP_DEST_UNREACH packets. Enable them to be configured per netns.

xu xin (3):
  ipv4: Namespaceify route/error_cost knob
  ipv4: Namespaceify route/error_burst knob
  ipv4: add documentation of two sysctls about icmp

 Documentation/networking/ip-sysctl.rst | 17 ++++++++++++
 include/net/netns/ipv4.h               |  2 ++
 net/ipv4/route.c                       | 36 ++++++++++++++------------
 3 files changed, 39 insertions(+), 16 deletions(-)

-- 
2.25.1

