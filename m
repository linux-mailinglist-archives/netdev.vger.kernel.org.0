Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BEE60F022
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 08:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiJ0G3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 02:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiJ0G3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 02:29:03 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3C4160EC4
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 23:29:01 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id c3-20020a1c3503000000b003bd21e3dd7aso3374285wma.1
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 23:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UAU5yyUB4mbIzxXvKnUzDnBw+wtC3frKRq03Vtd4mjk=;
        b=Z8cD2SRF8NdlhNsfIxe6nUjGhLrhsYf9WGWW9PsMmE8uc5DkWHR3lahx6cWyvRhXLl
         z2FU0Tt3vTBYv/wlVDrsPcpDVDC9+T0MsPMrNmXEd20DF0cRbLZV8Ca5iUfyJsDdgi1i
         1PEVzA6JI02LirahtzQ+QQrzXDhhLIx9A7bNdjH7xJ6W3EAjseypMIPMfQSuB2e4QRum
         jh1rgsKl+qH21mjo+tjgSHIIXTVTuzd+PBgVMnqrPXvJXtlI1YebvZj8UR/KuLbxVDig
         TY+vfFCIOcLtlmd5m+z2tiQrG8FVipheuP/8ygVtua9cZq/Hh7wSB99OgoMcXLyuoMu9
         shEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UAU5yyUB4mbIzxXvKnUzDnBw+wtC3frKRq03Vtd4mjk=;
        b=WKtbo285WRHQ4y6mSPW1+isM7Q883GSj8v0zOs/fCM/DClC2+nsF9RN6tgKj5GhTFp
         +MeSFNSYWH/QjwueM7TMWPCTaWvh7Y7S6yvxO9NQsd5RHWpVwFjsYJiB+TJ6/rqRqrES
         RvJr5DhLbE1C7Wn5PL/TRkgMn87G/mV5r+ZiuqJZ6tDVzccWEdErcxYVxY89yZoBza2A
         fWVJ4RuRDdpaJIzuClaVmfT5CCQe33ayrwgSNNB3eREtJyc1/RYU2zeAlGAXpBZY/RXD
         RQqWUM+PE89zloggezl3LrVPW4Efey6tzeBXDTyXpbeIcxd8dTZVlRlKftUGu0T2OQn3
         0nCA==
X-Gm-Message-State: ACrzQf2u59yLsMO6K6To+hyebYg/NoOJjtfrEnUbbpnJoYMufrsW2unw
        yrJ9T4iWe/gB1fMKbeqNlCPmJKsxLXElNFs4mry6ug==
X-Google-Smtp-Source: AMsMyM7sIvc3ouhHdP/BMmcus+/e+M3eEwv1Rcsd+WkQCyB+TVAsfjUMV/cU6GqcBhhsX8RK4kMXEQmzTgV4Vy2BT70=
X-Received: by 2002:a1c:ac81:0:b0:3c6:e566:cc21 with SMTP id
 v123-20020a1cac81000000b003c6e566cc21mr4771527wme.0.1666852139803; Wed, 26
 Oct 2022 23:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221026020200.29222-1-zhaoping.shu@mediatek.com>
 <CAMZdPi-bAw293XWBQL0wZS-nO_COD=ZOBduBVicof87HyEmS3w@mail.gmail.com> <7e8434e1fc683de62400dd93ea7a248e28e1efaa.camel@mediatek.com>
In-Reply-To: <7e8434e1fc683de62400dd93ea7a248e28e1efaa.camel@mediatek.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 27 Oct 2022 08:28:23 +0200
Message-ID: <CAMZdPi-8dRVioPUWcOABZsT53mQrji1sDjMWnLQzdXKhBd4-rA@mail.gmail.com>
Subject: Re: [PATCH net v1] net: wwan: iosm: fix memory leak in ipc_wwan_dellink
To:     "zhaoping.shu" <zhaoping.shu@mediatek.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, srv_heupstream@mediatek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        haijun.liu@mediatek.com, xiayu.zhang@mediatek.com,
        lambert.wang@mediatek.com, "hw . he" <hw.he@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 at 04:08, zhaoping.shu <zhaoping.shu@mediatek.com> wrote:
>
> Hi Loic,
>
> On Wed, 2022-10-26 at 09:50 +0200, Loic Poulain wrote:
> > Hi Zhaoping,
> >
> > On Wed, 26 Oct 2022 at 04:02, zhaoping.shu <zhaoping.shu@mediatek.com
> > > wrote:
> > >
> > > From: hw.he <hw.he@mediatek.com>
> > >
> > > IOSM driver registers network device without setting the
> > > needs_free_netdev flag, and does NOT call free_netdev() when
> > > unregisters network device, which causes a memory leak.
> > >
> > > This patch sets needs_free_netdev to true when registers
> > > network device, which makes netdev subsystem call free_netdev()
> > > automatically after unregister_netdevice().
> > >
> > > Signed-off-by: hw.he <hw.he@mediatek.com>
> > > Signed-off-by: zhaoping.shu <zhaoping.shu@mediatek.com>
> >
> > Could you please add a corresponding 'fixes' tag.
> This issue was introduced in the first commit of this driver:
> Fixes: 2a54f2c77934 ("net: iosm: net driver")

Ok, fine, then simply send a V2 with that tag.
You can append mine as well:

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>


>
> >
> > > ---
> > >  drivers/net/wwan/iosm/iosm_ipc_wwan.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> > > b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> > > index 2f1f8b5d5b59..0108d8d01ff2 100644
> > > --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> > > +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> > > @@ -168,6 +168,7 @@ static void ipc_wwan_setup(struct net_device
> > > *iosm_dev)
> > >         iosm_dev->max_mtu = ETH_MAX_MTU;
> > >
> > >         iosm_dev->flags = IFF_POINTOPOINT | IFF_NOARP;
> > > +       iosm_dev->needs_free_netdev = true;
> >
> > Look like we have the same problem in mhi_wwan_mbim driver, would you
> > be able to submit a change for it as well?
> We will submit another patch to fix it, since this patch is dedicated
> for iosm.
