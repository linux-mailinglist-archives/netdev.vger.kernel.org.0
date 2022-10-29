Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B81861213E
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 10:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJ2IEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 04:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJ2IEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 04:04:43 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B827F6313
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 01:04:39 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l14so9297558wrw.2
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 01:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v0oK14yzXxpUjIDymvjkDTwqnjS/MUHB22GrvInuANo=;
        b=ru6HeG+J7Thc6eiamnfTqppsiOqivRby209FapsbhgfmBca0OfQFcg3sXMKFDLvzbu
         yVJtRx7tK3/SpC4RWUOxUgtV07SdWEkVdKeVptUHsNrkNy3exLwBBdl/RGNePzhwZ7kY
         du5jr+BTk3L5s3k4GRWeMqJvb2i5n+BMjbub45xx/QxM2rQyzTbC2frW+/W8e9kRTi5T
         WDtXmNU6VbcJHpr5ykhHsMYEIm8DlOA6S0LodIZ0HTxLZu//FRybZAeioJU8j7VH4zlN
         tygddKK6skZ0eZOy14uBVcNnGU+W6CRsn5O2d4l2yPvGeyEA7AgZXsRCdhmXgYS3g2IJ
         0cAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v0oK14yzXxpUjIDymvjkDTwqnjS/MUHB22GrvInuANo=;
        b=QXPTDDcvmg63CaQxT2Z5sqanoKbBJVrwJDpOlrSmQE7T3bB9BuRl0AUrXHto9y9Awf
         0PVByo8pNbUNjl3ZLWqpNwLWfpa5FFcFZcWFpM265M8hmWSBFMVtrq2QmPG5vb4x3ZVD
         tJRqd3yJ9xtZmwjddSF8eLc+e3LyTHSrh+Br8yZOFxL+S+9tM3BQkIdRi/vMlcBYTfLi
         72vqXjPunCzMQT20ZdkvhQGJY1DLk4cfB4nNk9kuqnGnpgqtsO7x7TH6a0Y6Zwfar8Lv
         KdG/3VoSIniatx7sEZP2diDns0z8VCrhcxE4ZBEiQeiBuHVSGCdxu6+WZOo7mq7VOTSb
         06RQ==
X-Gm-Message-State: ACrzQf1tjn1ebWf0HMjrxAKjkK+FaKBxo+vqQCGvc9mWLk3hWD4eZ688
        SOQovoDLnMoE3wTQ3KbV2+NxOBWkchbH3PEcGQG8DQ==
X-Google-Smtp-Source: AMsMyM4FlYS/rxr40IeUzXIEbctrxffIn33VyHb4/LpIm/M6OxlIZfoHHgvi7171wst2eOVquGFGw1wkD00RxYnDHKs=
X-Received: by 2002:a05:6000:510:b0:235:e5de:8da0 with SMTP id
 a16-20020a056000051000b00235e5de8da0mr1740287wrf.416.1667030678012; Sat, 29
 Oct 2022 01:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221026011540.8499-1-haozhe.chang@mediatek.com>
 <CAMZdPi_XSWeTf-eP+O2ZXGXtn5yviEp=p1Q0rs_fG76UGf2FsQ@mail.gmail.com>
 <82a7acf3176c90d9bea773bb4ea365745c1a1971.camel@mediatek.com>
 <CAMZdPi_tTBgqSGCUaB29ifOUSE5nWa6ooOa=4k8T6pXJDfpO-A@mail.gmail.com> <3abbe6ea016b865b6762708fe8234913884a0ed5.camel@mediatek.com>
In-Reply-To: <3abbe6ea016b865b6762708fe8234913884a0ed5.camel@mediatek.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Sat, 29 Oct 2022 10:04:01 +0200
Message-ID: <CAMZdPi-LCzrzM1eGsA_mKH-GZ1LgYXQqs4k8r=8gQAC3BRUFNg@mail.gmail.com>
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
        <Xiayu.Zhang@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 at 03:19, haozhe chang <haozhe.chang@mediatek.com> wrote:
>
> On Wed, 2022-10-26 at 22:27 +0800, Loic Poulain wrote:
> > On Wed, 26 Oct 2022 at 13:45, haozhe chang <haozhe.chang@mediatek.com
> > > wrote:
> > >
> > > On Wed, 2022-10-26 at 15:28 +0800, Loic Poulain wrote:
> > > > Hi Haozhe,
> > > >
> > > > On Wed, 26 Oct 2022 at 03:16, <haozhe.chang@mediatek.com> wrote:
> > > > >
> > > > > From: haozhe chang <haozhe.chang@mediatek.com>
> > > > >
> > > > > wwan_port_fops_write inputs the SKB parameter to the TX
> > > > > callback of
> > > > > the WWAN device driver. However, the WWAN device (e.g., t7xx)
> > > > > may
> > > > > have an MTU less than the size of SKB, causing the TX buffer to
> > > > > be
> > > > > sliced and copied once more in the WWAN device driver.
> > > >
> > > > The benefit of putting data in an skb is that it is easy to
> > > > manipulate, so not sure why there is an additional copy in the
> > > > first
> > > > place. Isn't possible for the t7xx driver to consume the skb
> > > > progressively (without intermediate copy), according to its own
> > > > MTU
> > > > limitation?
> > > >
> > >
> > > t7xx driver needs to add metadata to the SKB head for each
> > > fragment, so
> > > the driver has to allocate a new buffer to copy data(skb_put_data)
> > > and
> > > insert metadata.
> >
> > Normally, once the first part (chunk) of the skb has been consumed
> > (skb_pull) and written to the device, it will become part of the
> > skb headroom, which can then be used for appending (skb_push) the
> > header (metadata) of the second chunks, and so... right?
> >
> > Just want to avoid a bunch of unnecessary copy/alloc here.
> >
> t7xx DMA can transfer multiple fragments at once, if done as
> recomended, the DMA performance will be inhibited.

OK, so the skb fragmentation is valid in t7xx case, but the way of
doing it is kind of specific to t7xx. Maybe a more acceptable solution
for a generic fragmentation feature would be to keep the extra
fragments part of the 'main' skb, using skb chaining. That would allow
the fragments to stay linked to a specific user transfer. So if
fragmentation is enabled for a given driver, core only fills the
initial skb with MTU size, and appends additional skb as fragments,
you can look at mhi_net_skb_agg() for skb chaining example.

Regards,
Loic
