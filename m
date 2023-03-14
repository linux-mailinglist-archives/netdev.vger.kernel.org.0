Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152AD6B9FD4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjCNTfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjCNTfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:35:32 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C631FCC;
        Tue, 14 Mar 2023 12:35:30 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r29so7363397wra.13;
        Tue, 14 Mar 2023 12:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678822529;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zS1flcInkmMramIBRR4TAKEbNSAkwEp9UUvBUe9dmH4=;
        b=ZqVfV6MCJk0DA1uVT2K2wlc9r/keCeXww9Xg1gEv/9GLp6Z+PYWAglfjuDqLzm+37f
         7/f4FykzXifCkM6baIHYbAoNy4GAP8GybDyQNDhueld4bhztRf677U4iSrsCN9gOyHhn
         vYLtTmbLqzP06wfiNdlTLK9X9f0OMsKSFNGQ/0yjDDQ6Ub0OTY9XY99mNsRyiGXh3Zqg
         fZTsx7X45ZO2f2V4DU9H2eB/AWwL5zj+8cIe9T+heC/srRSvCo13lxDZnHFYNwkOMxuc
         HCnAO+JbGDGK0Ae82ygRz9RKpvyFt44sfMENI5TcyYAFxBtPfWLsh16Y5f7GjF6QWb7E
         +n9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678822529;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zS1flcInkmMramIBRR4TAKEbNSAkwEp9UUvBUe9dmH4=;
        b=TwozVYNk53hsAydVqDzY1CL7ECbeXeabtcd51J9OCiSOM5cZUJjwnZW0R8G+AxLV5j
         fiS6v7gG+lRZWwkNqX5j9Cukta7rHEvQ7WWlWzsVMo00+Px5PlCG3vJMzOY84J5CZvnU
         yOhccmypxzOw6kZp4MZXEyNxNPz1ZmgmD97JM/ke7Jr7COSkNyPs06wSkWt6QK/XJyHx
         40Jp/3FuushxPIa0ktvEmINGfWgksJfzLefnnHw8qYFvXn8elLAmhjy+P8SO9KrY8N77
         WYiY7+ad8SNd7RXE02zglaGODt4gcR10CHQTVp8GWa4sjf2YcJUu6QCzyvkfaT/Cj59y
         w4zg==
X-Gm-Message-State: AO0yUKVvAXU5/3ZeXhxN/Pft7gi6+YekktQN+Aj5Kq+A9TPSpgJe18mO
        qmIL2xynOBQNne94/68lDJE=
X-Google-Smtp-Source: AK7set8RYPxrkYx7nyALJIHo7Vz9mp+d3ixpEB1o9lOAdHXeQTqfKv9SCLip263TawEJSTju/gduyg==
X-Received: by 2002:a5d:68d1:0:b0:2ce:a7a7:b8b4 with SMTP id p17-20020a5d68d1000000b002cea7a7b8b4mr150996wrw.35.1678822529261;
        Tue, 14 Mar 2023 12:35:29 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:5862:40de:7045:5e1b? ([2a02:168:6806:0:5862:40de:7045:5e1b])
        by smtp.gmail.com with ESMTPSA id f2-20020a0560001b0200b002c57384dfe0sm2846569wrz.113.2023.03.14.12.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 12:35:29 -0700 (PDT)
Message-ID: <ed91b3db532bfe7131635990acddd82d0a276640.camel@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't dispose of Global2 IRQ
 mappings from mdiobus code
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Date:   Tue, 14 Mar 2023 20:35:28 +0100
In-Reply-To: <20230314182659.63686-2-klaus.kudielka@gmail.com>
References: <20230314182659.63686-1-klaus.kudielka@gmail.com>
         <20230314182659.63686-2-klaus.kudielka@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This should have been [PATCH net-next v3 1/4] in the series
"net: dsa: mv88e6xxx: accelerate C45 scan".

Lore *does* recognize it as part of the series, put patchwork doesn't.
Sorry for the mistake, and please advise if I should resubmit a v4
series.

Klaus
