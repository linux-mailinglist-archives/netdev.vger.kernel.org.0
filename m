Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070E54DAD27
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 10:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354813AbiCPJEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 05:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354799AbiCPJEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 05:04:23 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F25737AA6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:03:08 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id bu29so2707612lfb.0
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=6/ER/sO+t5OaggfresC0Wax9ePqmeP3gWFIFu+iOnHw=;
        b=InAfNgIT37hzRbKi7cPdZX+rBhA/Uxq/U6rVfGVfrnRFY93zat6be7xsUvdNB5Ipko
         nXaC8NJH2vrlj7gGia+66ctk7l9yZ5tcT38x6F8XuLQsWmNeLnxU52Wi/wjNg08Ef5+U
         u+Me1XXlNPnAvjzqaSKlh8ickryDgm160kH6n3Q0Nat1j0Zf0bvjHYse7ZIxhr/gD36Q
         UTcP6Y0nbRkwbY6ZxWVfWYE0v7052ZImPv/Q4/YzRHi3SGwji5TVwQwoIQqX4UapRSY5
         7qEmYk+1RYpAOFS4b5al/JaJjVW8jSPPEqcnVE4ljCmfimongzZOtTQr+nikjzwhybb6
         Pfjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=6/ER/sO+t5OaggfresC0Wax9ePqmeP3gWFIFu+iOnHw=;
        b=7+8Ir7F0jipw3i4yVVkoElRieAh4bgS/61Eoz4+PBCM6g/uVKj0t7pnX68jFKaaMdn
         e0doDymM3d3Gqa98YaLVr9NXSHWSglpUGHslu1eXAzR2dlMtbZTJ26YfmZ6diDJFS1Uc
         g0TdFtUU5DhY6vMqJHDBxY3l3xL853lpyrN1LAEl0QtZmRTuZj8HrwodwAn0ajWjNv9G
         wPjQw0RNnRwwzQcSrwfKFL1iygniGwVakQkJgZ9bPA913bjB/XsZBJrtTEhwI0zhDbaO
         0peRt1OTn5mK9NmaBbcXQbtyLDLRkI0cWLvFvDI3KAg3Xjhym6pXwWOaSiohd2+Kno71
         E+Tw==
X-Gm-Message-State: AOAM533D61v5Kd+sHkb0I6QOrxWE0ielzonzYV5V9lYrDZR0cJUHHNqg
        s013JMDTz2eHAWUAUrY0Rp9+Ww8BOqcJ/g==
X-Google-Smtp-Source: ABdhPJzhwUEb2Cz2KwqiNl/5sc11xyRGSrmUbbTzzbY0JfvpzpqYOsFrTx9/OVlor43tiuZE1ZEVcA==
X-Received: by 2002:a05:6512:2209:b0:448:afa2:2fe8 with SMTP id h9-20020a056512220900b00448afa22fe8mr3369376lfu.428.1647421385753;
        Wed, 16 Mar 2022 02:03:05 -0700 (PDT)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id j17-20020a2e8511000000b00247ee6592cesm124111lji.104.2022.03.16.02.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 02:03:05 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next 0/2] bridge: support for per-port mcast_router options
Date:   Wed, 16 Mar 2022 10:02:55 +0100
Message-Id: <20220316090257.3531111-1-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Hi,

this patch set adds per bridge port mcast_router option.  I.e., the
ability to control how IGMP/MLD snooping learns of external routers
where both known and unknown multicast should be flooded.  Similar
functionality per-port and per-vlan setting already exist.

Best regards
 /Joachim

Joachim Wiberg (2):
  bridge: support for controlling mcast_router per port
  man: bridge: document per-port mcast_router settings

 bridge/link.c     | 15 +++++++++++++++
 man/man8/bridge.8 | 15 +++++++++++++++
 2 files changed, 30 insertions(+)

-- 
2.25.1
