Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03484E8CA2
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 05:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbiC1DgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 23:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiC1DgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 23:36:15 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE78DFA2;
        Sun, 27 Mar 2022 20:34:25 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p17so13688428plo.9;
        Sun, 27 Mar 2022 20:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hzdL/UK29xtukZI/LeM5DstxPMM7F/hHvlJmMxZK1mM=;
        b=ql7meP7VuYduIL6sh1lSlx2TdePnmgT5DavpRfFzCqn19bEiPlF3vwe5AnuWYU5waO
         GbKj6Oihp+gvQxmDR12nowBN/j2LD9y/78k3LxMGpezMPWwBMbEgXSJWOWpd1F2iQEPE
         w2bzho8VPNaNf34kunXv9U9xo2Ls56N15JinfQo7v9HcYfsaBJVZVERqFcFP0F4RYaDI
         xIPogoU1LkPy7Y0FYjGBYZ0BXVvaa5Wof9Ls6DlzHO2Q4m3m9e6k5TVLKQBoU/wldpP0
         yfgobV7xlelEreGA8lfiPPAac4V4X69Jvm7aR5r2k00L1fdU0uipOciQR/TtwWFHP7ZX
         4R6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hzdL/UK29xtukZI/LeM5DstxPMM7F/hHvlJmMxZK1mM=;
        b=2Xj9lPaejEZw5QnbQ8oiAPFdwz/SFqe1J0V1uk7Al4Wn7P9d9SBDYHqoaiWGuDh/JH
         vMnRpykKbpihDxemJ6yUvdQt6Ll1uO5gWf3pkqKZAeWprUgGZZZsPO5KD66DWPhy4MVQ
         RZHBhslQr9wH9vceasgouYwJR2K+NLjqNYXaqpWXS38gA16RbKYslgr5yIXxIHGQtms6
         E4hs9nBXVVRX+/aa1dWlyFnoHpmSC8lcpwlTpzJYNY0YpAXH+EnnslFVqqoPzp5WAI8D
         oyfioi1H57qDAzEwavNVflb57qEM1v9WBSQV4DsI3bzVpF1TLrbCH+QIteuXwQWnX+Pf
         IzPQ==
X-Gm-Message-State: AOAM5309QsbZrZYNhItyvjItejDYVcZHa9NOyTvVJLNeu8hklJlRJDTP
        /mvHo3wfQZ8C+14/I5XM3jVd/IvDwtpILw==
X-Google-Smtp-Source: ABdhPJzIBhLHNSmZ62ldIsf9MUhOkr/H41b1vwREXenOonIrLoyF29QPxwdeaZiAxJejg97MlYsIwQ==
X-Received: by 2002:a17:902:b902:b0:154:bb05:ddb9 with SMTP id bf2-20020a170902b90200b00154bb05ddb9mr24728470plb.14.1648438464785;
        Sun, 27 Mar 2022 20:34:24 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id om16-20020a17090b3a9000b001c7bc91a89bsm11944172pjb.52.2022.03.27.20.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 20:34:23 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     f.fainelli@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        olteanv@gmail.com, pabeni@redhat.com, stable@vger.kernel.org,
        vivien.didelot@gmail.com, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator
Date:   Mon, 28 Mar 2022 11:34:15 +0800
Message-Id: <20220328033415.22742-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <0dd59973-a4da-51db-5234-d4cc48ec13ee@gmail.com>
References: <0dd59973-a4da-51db-5234-d4cc48ec13ee@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Mar 2022 19:51:39 -0700, Florian Fainelli wrote:
> If you could please resubmit with the subject being:
> 
> net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator
> 
> and add Vladimir's and my tag below:
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> That would be great! Thanks

I have resubmited as your suggestion, please check it, thank you.

--
Xiaomeng Tong
