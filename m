Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4B15FD595
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 09:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiJMHiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 03:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJMHiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 03:38:18 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745B82BB02
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 00:38:17 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r17so2047698eja.7
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 00:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nDB4j48Rkk69fhXG+QbKEwrLRuGO0ekWeIE+8o1PgGc=;
        b=cRyIr0mnJMo2TKRlGhwNT2YQVK7FyALlnjgQY9BEz+Nr85ISiQ/+kyIdSQ6QVHIGUg
         T5EwiG1deIug3elpFg0rKFDw7nrz2qwmNZXmJC8HQXycWtwehINKo61wyId9pTTvNkpc
         t6vr0FPnTphMBwHkV4+/e0afrxFS/uIr637uyPFNytptG6AMdEIaqs4cgg/8M7ODEUSp
         oI1VEvrOTRYLp0+GiaDxv9HH6OVFLM66at4KhL0sUCYVvpQbfynyUXjLT1iEzQQ6S5/4
         n8sCGJ+behD3KvtH0pk+ldBxf4dfxNsbjEUhgsb7yIT2AOI4B2up3LEM/gw/MWpA70v9
         wA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nDB4j48Rkk69fhXG+QbKEwrLRuGO0ekWeIE+8o1PgGc=;
        b=ICET7Omw3aZosJEGG8km4LAic01WFm7C9fzi7pe0cAo+JqmMTaHpw2e61wkRYzJFGP
         kqtTM3WQmB3E5ga4gZLzHHA3BuCBOHg8JWocNKyNLk/IU6acadpvhY35VafuwJUTYXSB
         wVeabS7EGd/24DQge9TVLcpGPlTW4aXHU8/tPP2HoI/4fAkhafE6G784mjiDnR6nYNho
         f0aQSQVZHCRnT+WQ922E29apT5+MgORKOALyjF6P7HHddHV4No3gTCVzf4ri6nGf8xcb
         97NLe12TSpKZa9TO1tIArh2HFhYm3Tz0dE0pUs2mjK3YxMIwlsWS1ixOIdH3Ne6CO/rw
         /1KA==
X-Gm-Message-State: ACrzQf3KK/bzgBz6r0KnbgCVI3Fl4Q01QQZnEMVKBZVBTiXBKEOLyUge
        JcoAq0lqkf+U1Fjj9pdiSXA=
X-Google-Smtp-Source: AMsMyM4Jx0YIMz2ChdXSEkTUrxcMrhpbyb4m17Z1QfPlcRF2+oujqSdpfvMJONGAS4vdApsm+bj8YA==
X-Received: by 2002:a17:906:2bc7:b0:72f:dc70:a3c6 with SMTP id n7-20020a1709062bc700b0072fdc70a3c6mr25591166ejg.645.1665646695871;
        Thu, 13 Oct 2022 00:38:15 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id s26-20020a056402165a00b00456d40f6b73sm12734252edx.87.2022.10.13.00.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 00:38:15 -0700 (PDT)
Date:   Thu, 13 Oct 2022 10:38:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
Message-ID: <20221013073812.mvbs6wo64b4yr5cc@skbuf>
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de>
 <CAA93jw5J5XzhKb_L0C5uw1e3yz_4ithUnWO6nAmeeAEn7jyYiQ@mail.gmail.com>
 <1a1214b6-fc29-1e11-ec21-682684188513@tarent.de>
 <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
 <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de>
 <8051fcd-4b5-7b32-887e-7df7a779be1b@tarent.de>
 <3660fc5b-5cb3-61ee-a10c-0f541282eba4@gmail.com>
 <c18b3a75-95cc-a35c-7a2c-fb4ec0b18b84@tarent.de>
 <Y0c0Yw1FjmR0m+Cs@lunn.ch>
 <93ce7034-a26f-b68d-f27f-ef90b6b01bf8@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93ce7034-a26f-b68d-f27f-ef90b6b01bf8@tarent.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 11:56:11PM +0200, Thorsten Glaser wrote:
> The thing I did first was to add ASSERT_RTNL(); directly before the
> rtnl_* call, just like it was in the other place. That, of course,
> crashed immediately. Now *this* could be done systematically.
> 
> In OpenBSD, things like that are often hidden behind #if DIAGNOSTIC
> which is a global option, disabled in “prod” or space-constrained
> (installer) kernels but enabled for the “generic” one for wide testing.
> Something to think about?
> 
> I’m sure there’s lots of things like flow analysis around in the
> Linux world, however that wouldn’t help out-of-tree code being
> developed, whereas extra checks like that would. Just some thoughts,
> as said earlier this is basically¹ my start in Linux kernel dev.

Not trying to defend the Qdisc framework which has poor to non-existing
documentation, but with some minimal level of experience you'd kind of
expect that a function named rtnl_kfree_skbs() expects a calling context
where the rtnl_mutex is held. It is even more clear that this is the
case when you notice that in its implementation, there is a single
defer_kfree_skb_list global to the kernel, which is processed in
__rtnl_unlock().

I think as a takeaway from your debugging journey, you can add an
ASSERT_RTNL() to rtnl_kfree_skbs() and add a comment documenting the
function. You can use the commit message of 1b5c5493e3e6 ("net_sched:
add the ability to defer skb freeing") as inspiration for the function
description.
