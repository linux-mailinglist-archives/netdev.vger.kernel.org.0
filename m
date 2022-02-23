Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9AF4C113A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239843AbiBWL0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239840AbiBWL0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:26:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C8959024D
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645615585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Haw7XCJunvY/DjkGYU10zm/TPnhQIIAXDUz4hP9McDQ=;
        b=S7y+lRvpZeEiZxrKRjyk4EXWt9EnD/i/GpUJBuuKnPiHOfW/TLaFqQykPNCiQ0U65FnzmN
        mhq3lQbjdvMDHnyh9T4u8gZUBA2QMx8YAWrlcKvZgTcOaQUZqSEYntpEOTvlEjHBByJJgw
        mO3SNFcyjK33I9Ddkul9MI+feXfNUQY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-ms836GTiP-O3Q5V8BAaz6g-1; Wed, 23 Feb 2022 06:26:22 -0500
X-MC-Unique: ms836GTiP-O3Q5V8BAaz6g-1
Received: by mail-wm1-f69.google.com with SMTP id v125-20020a1cac83000000b0037e3d70e7e1so987975wme.1
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:26:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Haw7XCJunvY/DjkGYU10zm/TPnhQIIAXDUz4hP9McDQ=;
        b=SEGvs04ZgADvis0C2mnEwjG8vXwkEOnI51E37MuqsSa/5qU+N9Fe207Ekz2+yuvzzD
         hD5wU2dA7hn9Ut0uHKcBQCx7NP+MncNoELBSp9VocCi/ampz7ohcQVU1pqB9zEH1VOyq
         0RId1hXApt0R/qJxyA8oDXvHwIaWvCWvme7QOmn4wp3sU7jcaNx5tRwA+GzqGfAcEmzi
         F7kzAyfT0sHie/LFrnIOSVbWl0LedTTOr9+oUfs9XXXM1fJ7we9fD7po1rs+M4vOLurR
         IcYsOpVsanYAWS/Jjlu3CAtPVn03+C8Iu/WCpAAmyCCpSt5WCZ1SXu2YyudBOrnsaJcH
         fiIA==
X-Gm-Message-State: AOAM530C1Tkp7F/4g7dk6rGGCthm2y5JkPqvzJ6lXk/P6yYq7T55amNb
        HccMZVSRX3NWYLLmJ6d8cJM2rLKsSTyfcJPWxvC6l95jTZqbSIEMgsmhjiwdr84epcjeYEKVq0S
        prP1d21uiIXqpdSAS
X-Received: by 2002:adf:e2cf:0:b0:1ed:a702:5ef4 with SMTP id d15-20020adfe2cf000000b001eda7025ef4mr2247205wrj.487.1645615581412;
        Wed, 23 Feb 2022 03:26:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykSRUu2MIXs7qWqdvPoNdIH8fNfCQn7v7rt5GYse64UKs0Uo+59+0XKkms3GN06X84NEVg5Q==
X-Received: by 2002:adf:e2cf:0:b0:1ed:a702:5ef4 with SMTP id d15-20020adfe2cf000000b001eda7025ef4mr2247190wrj.487.1645615581185;
        Wed, 23 Feb 2022 03:26:21 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id f63sm3976646wma.17.2022.02.23.03.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 03:26:20 -0800 (PST)
Date:   Wed, 23 Feb 2022 12:26:18 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: vlan: allow vlan device MTU change follow real
 device from smaller to bigger
Message-ID: <20220223112618.GA19531@debian.home>
References: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
 <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
 <YhQ1KrtpEr3TgCwA@gondor.apana.org.au>
 <8248d662-8ea5-7937-6e34-5f1f8e19190f@huawei.com>
 <CANn89iLf2ira4XponYV91cbvcdK76ekU7fDW93fmuJ3iytFHcw@mail.gmail.com>
 <20220222103733.GA3203@debian.home>
 <20220222152815.1056ca24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222152815.1056ca24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 03:28:15PM -0800, Jakub Kicinski wrote:
> On Tue, 22 Feb 2022 11:37:33 +0100 Guillaume Nault wrote:
> > What about an explicit option:
> > 
> >   ip link add link eth1 dev eth1.100 type vlan id 100 follow-parent-mtu
> > 
> > 
> > Or for something more future proof, an option that can accept several
> > policies:
> > 
> >   mtu-update <reduce-only,follow,...>
> > 
> >       reduce-only (default):
> >         update vlan's MTU only if the new MTU is smaller than the
> >         current one (current behaviour).
> > 
> >       follow:
> >         always follow the MTU of the parent device.
> > 
> > Then if anyone wants more complex policies:
> > 
> >       follow-if-not-modified:
> >         follow the MTU of the parent device as long as the VLAN's MTU
> >         was not manually changed. Otherwise only adjust the VLAN's MTU
> >         when the parent's one is set to a smaller value.
> > 
> >       follow-if-not-modified-but-not-quite:
> >         like follow-if-not-modified but revert back to the VLAN's
> >         last manually modified MTU, if any, whenever possible (that is,
> >         when the parent device's MTU is set back to a higher value).
> >         That probably requires the possibility to dump the last
> >         modified MTU, so the administrator can anticipate the
> >         consequences of modifying the parent device.
> > 
> >      yet-another-policy (because people have a lot of imagination):
> >        for example, keep the MTU 4 bytes lower than the parent device,
> >        to account for VLAN overhead.
> > 
> > Of course feel free to suggest better names and policies :).
> > 
> > This way, we can keep the current behaviour and avoid unexpected
> > heuristics that are difficult to explain (and even more difficult for
> > network admins to figure out on their own).
> 
> My $0.02 would be that if we want to make changes that require new uAPI
> we should do it across uppers.

Do you mean something like:

  ip link set dev eth0 vlan-mtu-policy <policy-name>

that'd affect all existing (and future) vlans of eth0?

Then I think that for non-ethernet devices, we should reject this
option and skip it when dumping config. But yes, that's another
possibility.

I personnaly don't really mind, as long as we keep a clear behaviour.

What I'd really like to avoid is something like:
  - By default it behaves this way.
  - If you modified the MTU it behaves in another way
  - But if you modified the MTU but later restored the
    original MTU, then you're back to the default behaviour
    (or not?), unless the MTU of the upper device was also
    changed meanwhile, in which case ... to be continued ...
  - BTW, you might not be able to tell how the VLAN's MTU is going to
    behave by simply looking at its configuration, because that also
    depends on past configurations.
  - Well, and if your kernel is older than xxx, then you always get the
    default behaviour.
  - ... and we might modify the heuristics again in the future to
    accomodate with situations or use cases we failed to consider.

