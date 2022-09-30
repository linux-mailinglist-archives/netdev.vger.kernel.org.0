Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D755F10BB
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiI3RYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiI3RYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:24:07 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2A32AE3C;
        Fri, 30 Sep 2022 10:24:04 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id f26so3060271qto.11;
        Fri, 30 Sep 2022 10:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=tE59qToYVinzGTqz22DUmxpAgL/06GWstgS9SE0Qocg=;
        b=O+uRyQ3MPxEGgdrDgVLrKPgXjFR0d7j/Ix4VBXtzqot04sorbD0pe2ZweSbHt3ftkY
         kYigouUXtL/YwocoyWd5MPYtDGxxX4N64pe2BY9SNgUE08qpCyblh5POmFAo1Uk7A8rq
         1+VYBzJ0NgHGi0IgcOlHAiKOZKbUkC1Q/5vjYT+/ChihVNlVeQRsX80MSz1BG62r9/sF
         UByYuiQUIj7qb+YMIbh43LTt+AsYCQTqrU9JKBGt+I9XFPxAvyy3vwnr2sMPt8fQG2iZ
         HA/8CtWCrEI9eBrrLnDqeCNvNEhqldcH6hE1J4xOnN5v3btQNgshZZdnvr6wHG71DCEq
         LEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tE59qToYVinzGTqz22DUmxpAgL/06GWstgS9SE0Qocg=;
        b=qEiXuN0Zaid1UH8+YwKg2moM7xm6G9bpP8O7olshh11qE1T9C3uczZ2pIdynHOks67
         D6L/RfJYNj5H/6SSHKp8XfkSkCWdpOxZp34ZMp60KAx4zw/gFOG9zq5Zy5u3MsTJOwMr
         d+E7AFukpZ7iEQdl8LgFkEK930db9GLCZmj0jNFaboMjvBWIHa3GLnwcytuW+x1pbypr
         1uwUJ1/wXG2ODZsj2Fugp6uX0G7krs+7jsVoz7xCzsMDTR1ERZgO3LUP9vkQDnm6Pv61
         JRLJcIpv91keJooBu2bPQJ9YmDZZPQK+LIBJYikl4j2a4dqGVEVUAlwz+8XpM/XSKwGe
         yXYQ==
X-Gm-Message-State: ACrzQf170KzuWqshfvFPnw9vGNWV02BH/nUwpPyrYV0oy0xJdSxyy71m
        ZET6VS/w1FkdAWiiQGrnXgFXdViiey75jTLX8q0=
X-Google-Smtp-Source: AMsMyM71hTtzH3SgxPRan52bunxLguAaeFevyUenOQSKmpIQyhlcW2JovrB6IZlHQI5qM0qKp6Foo0I2Y0qlKlJzGBM=
X-Received: by 2002:ac8:5995:0:b0:35c:e39a:176b with SMTP id
 e21-20020ac85995000000b0035ce39a176bmr7752465qte.567.1664558643584; Fri, 30
 Sep 2022 10:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220930040310.2221344-1-zyytlz.wz@163.com> <20220930084847.2d0b4f4a@kernel.org>
In-Reply-To: <20220930084847.2d0b4f4a@kernel.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Sat, 1 Oct 2022 01:23:52 +0800
Message-ID: <CAJedcCx5F1tFV0h75kQyQ+Gce-ZC4WagycCSbrjMtsYNM85bZg@mail.gmail.com>
Subject: Re: [PATCH] eth: sp7021: fix use after free bug in spl2sw_nvmem_get_mac_address
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, netdev@vger.kernel.org,
        wellslutw@gmail.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, alex000young@gmail.com,
        security@kernel.org, edumazet@google.com, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is there reporter and author the same person with different email
> addresses or two people?
>

Hi Jakub,
Yes, its the same person from different email count.

Regards,
Zheng Wang
