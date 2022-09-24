Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893AE5E8728
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiIXBzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiIXBzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:55:05 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9759E146633;
        Fri, 23 Sep 2022 18:54:01 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id mi14so1020580qvb.12;
        Fri, 23 Sep 2022 18:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Nte7p+jnLyhkSvGVt/N5dUvnml7WCMzO6Xtu7Rr0z68=;
        b=KPrT3VeZVs4usk0B+/Ed1ZSzBe93N+XZaNfdL41TvLKa9Q2oFNfPB79yrIxBFkcQks
         Wxa/8pVayj+tgP/pwxSSNBysdrs19uYNRlwVkff3YiMVv3NdfgkUuaUKR6Wp2a7YqyXf
         zF7NyR9C7uMb42nJCcNW3BxtrG/HebhxqkB91bIHPlV8V/wthEfqvUVBrsXYZarKzt5B
         FwrASmtcJOotX+rOeM9FEgPuBK0a7kao+T7Ae2s0TinAppb1grrrGUM0pz1TELpBZnvE
         wASAP1MapudTpyd3PsZZERrrIfZ7GV5nxPTdvhnHXuQwLcZ+DjfoLF0Qz2j4OPg4qBBA
         vkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Nte7p+jnLyhkSvGVt/N5dUvnml7WCMzO6Xtu7Rr0z68=;
        b=4FSI5JzNEf+WGY1D8qfAu7Kn9x+J8FaoZh0b/UqjeOmd0cz0L4/9+m5aHbzX0L/sDd
         7FN9TQILMUye2yBYOuilIyVOik1QeuVPS9CM3KPDnOuWgOKn4biZtshByvARYe6E6OlP
         MYk+rTo6x2wPbtonKEFPyBp01TxuHjGUNP0dKuuSmsRjtF09tLnmvIC0ecLXetFNeVQG
         TnbXrtxBkid7rttCffmYiS/kkZTykmiPDTszz86R9ZsMJ6O+U5BwulOzQ/FOfnynuVZw
         XYKruVjNltQbwd2LySGClK+QgRs3+aq2sFMef9tIWoDixSiI9duXOG/OcYMJbir1fkb7
         XG9Q==
X-Gm-Message-State: ACrzQf2EYw4aXjuCN1CngmVxJcns3lhcwqImZ+QhcvWimkSn7AmcVfAK
        rnqXvm3h3HFWghr76dUy1FM=
X-Google-Smtp-Source: AMsMyM5lwDv2RVyoB9OOg3yvdYPKo12pYK4CJOJ7lq2QPZ/AMtntKppUorx/ZW6ZUiIIFtUlxMUL/g==
X-Received: by 2002:a05:6214:f26:b0:4ac:7bf9:21d4 with SMTP id iw6-20020a0562140f2600b004ac7bf921d4mr9539214qvb.98.1663984440218;
        Fri, 23 Sep 2022 18:54:00 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id h6-20020a05620a400600b006b9ab3364ffsm7223719qko.11.2022.09.23.18.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:59 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 13/13] sunhme: Add myself as a maintainer
Date:   Fri, 23 Sep 2022 21:53:39 -0400
Message-Id: <20220924015339.1816744-14-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220924015339.1816744-1-seanga2@gmail.com>
References: <20220924015339.1816744-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have the hardware so at the very least I can test things.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v1)

 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 74036b51911d..381e1457f601 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19491,6 +19491,11 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/dlink/sundance.c
 
+SUN HAPPY MEAL ETHERNET DRIVER
+M:	Sean Anderson <seanga2@gmail.com>
+S:	Maintained
+F:	drivers/net/ethernet/sun/sunhme.*
+
 SUNPLUS ETHERNET DRIVER
 M:	Wells Lu <wellslutw@gmail.com>
 L:	netdev@vger.kernel.org
-- 
2.37.1

