Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68A76914D3
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 00:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBIXoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 18:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjBIXod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 18:44:33 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A927DAC
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 15:44:27 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id g8so4072042qtq.13
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 15:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nN+gG5ZnfVuSY+BYYUgD5dyJF0WYGguJ4bcRYhMdw/s=;
        b=k+optFJ/9jE626UG0eFeWrSzHm2wdXSIdTtO/iQIKVyjpKGNnSLShg0FNqZuyAnBH5
         dZBdYFoQzfD/qeD5uxlKnrkEAqFTpOOmW1rgRyWlI3WcCxSlgF38TLHx6DCUeUJD5CWs
         3NybWFxm9wJfoLiqEmi2NLUnoPIrkUI07O1sYKtxcOFc4QgY+ofNaVoTrVwhzrYIiBAH
         bShv83v9lm0QEHkQRJ2BZJyVeWDUmAl8YaU9SKRoIDIB5ff8Y8tc2t+0YOMABqJ2E36G
         Xgluu4zS2v8LW4evSI/i7HthrFHOlDhYB4icH21ntwzH9He8eir+eX3UHCo51iJ+tpSN
         QbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nN+gG5ZnfVuSY+BYYUgD5dyJF0WYGguJ4bcRYhMdw/s=;
        b=n4Y4PriV6bQPHHjAOOSBTDYtWzgN69doDEeD8rTxNsHJlYXTipXtQ35EqoRKIcr8Ly
         ikWKRxDuw5wvIxwBnyPCtqqanWzOlGnD73g2lWclFRKqPOhG559/55sQtEJF95ieilIf
         gFUqmuGQPp6vItADUGnKVdTweuLnY0xXqcDBAYA3dZjkKKOevhX6hMy+vNRfIgBis0nB
         o3cypunoNOTD+tyVd6yyhiLsO93SncKSGcTtEmYhsG0zxpJKHE4YnT+vnKdqPcdHBLrf
         lg5su6qmKP2n4gtsuWQlZ2nuaFqaUN6CFkZFlPkhn3OtXqN/bJV37njNOJgTF93AC46C
         gBxA==
X-Gm-Message-State: AO0yUKUMjABNDztCxy+oO3UFO8wtKtEhxGkH3B1ZYoMBKEto+T79pNhm
        yONpF3a1jJf/OyXOgf9xB99z+aEqphs=
X-Google-Smtp-Source: AK7set99VUqMQ5cQXKfYOvwLFFt0dT5uB4vTbYlQhpqWfA4zIm0f1zw2+BMKQvjqUXAs6AIDWSGiow==
X-Received: by 2002:a05:622a:452:b0:3b8:3629:7cb7 with SMTP id o18-20020a05622a045200b003b836297cb7mr23222009qtx.64.1675986266670;
        Thu, 09 Feb 2023 15:44:26 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id y19-20020a05622a121300b003bb822b0f35sm2197808qtx.71.2023.02.09.15.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 15:44:26 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 1/2] iplink: fix the gso and gro max_size names in documentation
Date:   Thu,  9 Feb 2023 18:44:23 -0500
Message-Id: <727af35c9bf20f4bf1b363daaf6aecea321eb28f.1675985919.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1675985919.git.lucien.xin@gmail.com>
References: <cover.1675985919.git.lucien.xin@gmail.com>
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

The option names for "ip link set" should be gso/gro_max_*
instead of max_gso/gro_*. So fix them in documentation.

Fixes: e4ba36f75201 ("iplink: add ip-link documentation")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 man/man8/ip-link.8.in | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index ac33b438..eeddf493 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -88,11 +88,11 @@ ip-link \- network device configuration
 .RB "[ " txqueuelen
 .IR PACKETS " ]"
 .br
-.RB "[ " max_gso_size
+.RB "[ " gso_max_size
 .IR BYTES " ]"
-.RB "[ " max_gso_segs
+.RB "[ " gso_max_segs
 .IR SEGMENTS " ]"
-.RB "[ " max_gro_size
+.RB "[ " gro_max_size
 .IR BYTES " ]"
 .br
 .RB "[ " name
-- 
2.31.1

