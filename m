Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674DE60E34C
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiJZO2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbiJZO20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:28:26 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16C9117007
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:28:25 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w14so2363784wru.8
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dzkXPsbNyijK++Z6iKWWPP6mQotg49V1KU5aB3xkVHc=;
        b=W+65PLxU1lYfZnzJl2r6U9paUYFsOh0xwuInRv8i941JFSGN7ErO2usOmTCI9iVkI0
         z5A5SABgX2dXQlQT6Gp+z9BpdGxlmRAydWebKw8lD0HgKOeAADsr2knN7L9yoVEQQeFd
         8ZiWV/v91yWhkZ6/chLUbGy/RzOY2wJwWTrpOPuOysS53A/SAFyIBFmUBsmcWn5buZCl
         cLNJw/uznrXj2KT+n/Z3cfyrNuavRudIHmzsYGZqh7TLaBYZ6uxe3vEC223OSPKeC8fB
         Yig0Tnd7q/dPqd0MBZkSPEgbpTxpIT2OaREXzDKhOQT7TYczTEkp2Vd+GYMcCsdHVj4H
         esIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dzkXPsbNyijK++Z6iKWWPP6mQotg49V1KU5aB3xkVHc=;
        b=ReBLePpqL7aGOiKbP3fmIYEo+KnPniMyMgrQzqJ27s24LCKf7MW2ToHbWzsavi+yoH
         ZaZspl1+m/qH54EacVAGvl/0PGK0xgjzVJqG5R/g1WOhwtp6HQ6JJceGUFLX7ubo+61v
         f+VSkveaMAGZDxDXyo4VT9itthWl6NjDqfnp82f/Bt/UTdZHBGWmNsXA3SisWio7C5Ar
         YvHYyuQi/2tP9I3j6BvlSuUDg0LcoRo4jnEzK9nN8/l1aAOe9MLviZTYUOYMLuSxNm/9
         VisIQaiOdzw+g8X8VLSA6oX0RFjFVSChFSt+1zyt835EHpTn8TocvjFhiltpMOL2d73n
         ra/A==
X-Gm-Message-State: ACrzQf017PYduhZ8m95SVOHBdUqqKrNU1por4CqOs/B7TGFn1aRFxxwq
        ml6k5HVB4PonjrNjY6H5fI0S8Yq3d51xLz1vy7B7hw==
X-Google-Smtp-Source: AMsMyM4HUMhUHhe41lht+ReZcREK1zehiLyngQ+trdCDDb5bz+JWQgMAV6LKFoWU9BqFeeoF0+B2OWkTYCk98P1JFvg=
X-Received: by 2002:a5d:4a50:0:b0:236:6064:720e with SMTP id
 v16-20020a5d4a50000000b002366064720emr14889182wrs.124.1666794504269; Wed, 26
 Oct 2022 07:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221026011540.8499-1-haozhe.chang@mediatek.com>
 <CAMZdPi_XSWeTf-eP+O2ZXGXtn5yviEp=p1Q0rs_fG76UGf2FsQ@mail.gmail.com> <82a7acf3176c90d9bea773bb4ea365745c1a1971.camel@mediatek.com>
In-Reply-To: <82a7acf3176c90d9bea773bb4ea365745c1a1971.camel@mediatek.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 26 Oct 2022 16:27:47 +0200
Message-ID: <CAMZdPi_tTBgqSGCUaB29ifOUSE5nWa6ooOa=4k8T6pXJDfpO-A@mail.gmail.com>
Subject: Re: [PATCH] wwan: core: Support slicing in port TX flow of WWAN subsystem
To:     haozhe chang <haozhe.chang@mediatek.com>
Cc:     "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        "m.chetan.kumar@linux.intel.com" <m.chetan.kumar@linux.intel.com>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        =?UTF-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>, srv_heupstream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 at 13:45, haozhe chang <haozhe.chang@mediatek.com> wrote:
>
> On Wed, 2022-10-26 at 15:28 +0800, Loic Poulain wrote:
> > Hi Haozhe,
> >
> > On Wed, 26 Oct 2022 at 03:16, <haozhe.chang@mediatek.com> wrote:
> > >
> > > From: haozhe chang <haozhe.chang@mediatek.com>
> > >
> > > wwan_port_fops_write inputs the SKB parameter to the TX callback of
> > > the WWAN device driver. However, the WWAN device (e.g., t7xx) may
> > > have an MTU less than the size of SKB, causing the TX buffer to be
> > > sliced and copied once more in the WWAN device driver.
> >
> > The benefit of putting data in an skb is that it is easy to
> > manipulate, so not sure why there is an additional copy in the first
> > place. Isn't possible for the t7xx driver to consume the skb
> > progressively (without intermediate copy), according to its own MTU
> > limitation?
> >
> t7xx driver needs to add metadata to the SKB head for each fragment, so
> the driver has to allocate a new buffer to copy data(skb_put_data) and
> insert metadata.

Normally, once the first part (chunk) of the skb has been consumed
(skb_pull) and written to the device, it will become part of the
skb headroom, which can then be used for appending (skb_push) the
header (metadata) of the second chunks, and so... right?

Just want to avoid a bunch of unnecessary copy/alloc here.

Regards,
Loic
