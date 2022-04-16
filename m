Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9633F5033D2
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiDPFdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 01:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiDPFdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 01:33:03 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7E7107AA4;
        Fri, 15 Apr 2022 22:30:33 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso13191003pjb.5;
        Fri, 15 Apr 2022 22:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NUaxTDZsFJXw5nzozVASQ9js3ycJGMRPKyw3ts2KsXY=;
        b=UDZwm3/JQkQelDS9GBKQ59ASjZ/Hp4j5PlD3xcSe6EwE9pZy6a+2enR49rlxGO+ynB
         oNT9kZnq+cGPXtk3hUyZ8zd6nDx1QRm0Zng5w7cevHgnbMHam+nCGsBa+xgAxV6CP82o
         Ir1bBoCD8RhMdJ8S0mI/YAmJXHmFSyPPLdPkBuOPBpxUpxWxnwbEof+Bhe/mk0HdF4Cq
         4lgYNWKi448gbxf5YI+AnZ3kWeK2CSpH4NBNuwmhUauRLdEUNs0QONq4vf//XKW6JEff
         iUeFk6xmxMkd/J+N3DNeeKGtYh/ADiC92hazFV3HnQ02dy38Ezhl9VtFlJmMqLIUc2cc
         O6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NUaxTDZsFJXw5nzozVASQ9js3ycJGMRPKyw3ts2KsXY=;
        b=Hb4M+Z9E/PVBqIe/fXJEj5imyyxbEr0BCkHtIQYgbn0EwmFltjcNsZMmOFX78Svrn9
         FH7MBQxyHViqMn0UoWT9OGZCE9iC7kmai5hHefZe6kKFTcJU12TRyGTlZHSrUDf/rN5r
         H3PGUrY+0f/sMDED/FAl66PtCfdQHVLYGsyJwAwAx9N1J9v+uGB/ScnguGptV/AHJdtj
         t91WkMHElyuJsj0zdJtSpkExBNripq8gvK53wVIq76iZtGuA4eacOh4z0RbbWQUin7tK
         KaFiG1btfhgZauh7tn+RH3ALxP32ZR2f815Z1OTfzq93N4dDqXwPDZh5R2evijB15xVF
         1R2g==
X-Gm-Message-State: AOAM531XdgpxLEtCnikKB2TP2cs/8RYaLBcukBZpt/0OIBPalO1EzIPE
        EnPCGTctKQo1wUxlNitkC770+e36uatK71+Qo44=
X-Google-Smtp-Source: ABdhPJyx+hG0Ul4FVSldb0MgZOwGWOgLY5CfBWj6so/jzG6ERile0oM7UvyA9yRFD1oCbqHARqxrOyKxI8fqB30fnwY=
X-Received: by 2002:a17:90a:8595:b0:1bf:4592:a819 with SMTP id
 m21-20020a17090a859500b001bf4592a819mr2334242pjn.183.1650087032428; Fri, 15
 Apr 2022 22:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220411230305.28951-1-luizluca@gmail.com> <20220413200841.4nmnv2qgapqhfnx3@skbuf>
 <Ylc3ca1k1IZUhFxZ@lunn.ch> <20220413205350.3jhtm7u6cusc7kh3@skbuf>
 <Ylc5RhzehbIuLswA@lunn.ch> <20220413210026.pe4jpq7jjefcuypo@skbuf>
 <CAJq09z7h_M9u=7jC3i3xEXCt+8wjkV9PfD4iVdje_jZ=9NZNKA@mail.gmail.com>
 <20220414125849.hinuxwesqrwumpd2@skbuf> <CAJq09z6XTz7Xb0VBFdFVELb26LztFng7hULe6tSDX7KCQjzUmg@mail.gmail.com>
 <20220415102229.zaoqqjxcs27ofdy3@skbuf>
In-Reply-To: <20220415102229.zaoqqjxcs27ofdy3@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 16 Apr 2022 02:30:21 -0300
Message-ID: <CAJq09z7TeJQxEqKWjcCmvTgkkpua5Qkoro16ssU=29+ph1O0Ag@mail.gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with checksum offload
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Should we put this patch on hold waiting for the code refactor or we
> > merge it as is (as it tells no lies about current code).
>
> It looks like the patch was marked as "changes requested", my side
> comments other than the Reviewed-by tag were probably misinterpreted:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220411230305.28951-1-luizluca@gmail.com/
>
> So please repost.

Done as v3 (unchanged except for you review tag). Thanks!
