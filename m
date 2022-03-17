Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EF44DCE02
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237652AbiCQSxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237651AbiCQSxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:53:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B647221BBA
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:51:57 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id rm8-20020a17090b3ec800b001c55791fdb1so6299025pjb.1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vw3XaM6v46z2MuOTuiLDtIikE5mFUpXQTggdnZPb20Q=;
        b=YNQzE2c4U8b/woj51/ICQ9KfXeN9biR00rtSvs3CeHEc5pKderDQ+lRx0Pc4Se4eDG
         MdjX1//yOBAcpbxT94It7UqzBzhtdndBEZgvISaNEyw9iG83yAlLsuMJpWjh9ZIGm/ef
         CX5do56FUQ7IEDTgEUxBzfZpjMXbWfJKlzuNcD27yRmMdX9iE7m1OFlKyC7b8cGWb6tF
         ENwQ1kHdJyUTwjFXpQzJt5KM/MBHKbjjXVlh7Neopn2YpSGU+1zqyBmhnZeKFwwdzL6B
         dbRSftw+MU//29I2CZWQdUiZpuuql6sVSA/pGsUpnRyaIJnFBoSGfQOotN7gJo19/xuv
         Rkcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vw3XaM6v46z2MuOTuiLDtIikE5mFUpXQTggdnZPb20Q=;
        b=Ck4gUpJIC/w5oyhEGqFIr/VzdYONnCPDoNiZL1YnzD0H0BLk3LvBAR3d5bvLCOB4Ki
         LeIVbn2MiYiVJe3wWqDR+iaAPy5uAFS6TeeDl/PSzzIzcQXJAGnftRUxJOvkiwRzc83b
         kS343zq8tv1OijjyVf/J6Y+2RFHZ97EQY4yS2jQWyOmi7TtNGftF+qhszTfiRBhtnRLI
         jxShLoFhYQd2OqVBG74UfljXhAQLsFLmnkBKHKNKbRht3HvGIAjngmOY0G2RtrI7r2dP
         1CNisjXhr5Rk01ydQX/8L0PuziN4SF2FiO96kqPScxtVZy5SSDBlr8sDRjJvLesoEH/U
         ePfA==
X-Gm-Message-State: AOAM531Xdl6uFYvx3aNYwfzqCvln2/w5G4/lOh0NGfAu4VstZd/KMnyT
        AZNkyE9wSQTF2QeNB6CwqXURU5mdmhQq0dTpvnp4
X-Google-Smtp-Source: ABdhPJwqBUNPutkqf0ZNA9iXOQ6U8fxduS3yLPrsiTJ0HTunQXu2ts8GnvQ/f5rybTBoEVsneLLdoiD3ctaUsdhl4S4=
X-Received: by 2002:a17:902:ec89:b0:153:f480:5089 with SMTP id
 x9-20020a170902ec8900b00153f4805089mr3655434plg.166.1647543116685; Thu, 17
 Mar 2022 11:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220316213109.2352015-1-morbo@google.com> <AM9PR04MB8397B7734E38A4E60C6965DB96129@AM9PR04MB8397.eurprd04.prod.outlook.com>
In-Reply-To: <AM9PR04MB8397B7734E38A4E60C6965DB96129@AM9PR04MB8397.eurprd04.prod.outlook.com>
From:   Bill Wendling <morbo@google.com>
Date:   Thu, 17 Mar 2022 11:51:45 -0700
Message-ID: <CAGG=3QXGZKy2HCs=khGbmWC5MWs47S654p1b7SCD+sRqMv2DPQ@mail.gmail.com>
Subject: Re: [PATCH] enetc: use correct format characters
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 10:37 AM Claudiu Manoil <claudiu.manoil@nxp.com> wrote:
>
> > -----Original Message-----
> > From: Bill Wendling <morbo@google.com>
> > Sent: Wednesday, March 16, 2022 11:31 PM
> [...]
> > Subject: [PATCH] enetc: use correct format characters
> >
> > When compiling with -Wformat, clang emits the following warning:
> >
> > drivers/net/ethernet/freescale/enetc/enetc_mdio.c:151:22: warning:
> > format specifies type 'unsigned char' but the argument has type 'int'
> > [-Wformat]
> >                         phy_id, dev_addr, regnum);
> >                                           ^~~~~~
> > ./include/linux/dev_printk.h:163:47: note: expanded from macro 'dev_dbg'
> >                 dev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__); \
> >                                                     ~~~     ^~~~~~~~~~~
> > ./include/linux/dev_printk.h:129:34: note: expanded from macro
> > 'dev_printk'
> >                 _dev_printk(level, dev, fmt, ##__VA_ARGS__);            \
> >                                         ~~~    ^~~~~~~~~~~
> >
> > The types of these arguments are unconditionally defined, so this patch
> > updates the format character to the correct ones for ints and unsigned ints.
> >
> > Link: ClangBuiltLinux/linux#378
> > Signed-off-by: Bill Wendling <morbo@google.com>
>
> Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> Fixes: ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")
>
Thanks Claudiu.

Could you change the Link about to this one? It's a valid URL.

Link: https://github.com/ClangBuiltLinux/linux/issues/378

> Can be also net-next material. It's up to you. Thx.
