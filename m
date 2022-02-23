Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE144C165E
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbiBWPSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241459AbiBWPSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:18:08 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE62A344D4
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 07:17:40 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id s1so1611386plg.12
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 07:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FU9/IvCmjYnHYqrzJTmk+Vx5+9qmrRgnFwotNQzbX4k=;
        b=2CCI/5pLpIu6L72TWxqSuj9zBOB2EWevZZIgPq1BxYyAavuNOHlZfCBsmFhCPj+mmD
         uENTl/DFokE0ImFbCc+hiZm2m8uTEYE9INgDP8CDcUPyseE+n9PeZBbGPsOH0C2PYW0c
         RGVx/vcbFW48Yop+L5RfzrvN0ARuvz7p/sL4ampiTvYfuLEWF2RvKrJe6ghmgFhda2ab
         osn8h0mWe0hQKtig9tUYShO43DpE5lmHM8eQSUrRnSCuQu5Uq5NXNSPdVzud4OefYr2r
         T7Yt24QNxwB3sNygJtdFTvNeBbQX96EfZqOtOfiy4HzvXiMCsaBlx60/x7wzi8wtLMza
         j9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FU9/IvCmjYnHYqrzJTmk+Vx5+9qmrRgnFwotNQzbX4k=;
        b=Qy1Xbs41/c5ZInIcHfRiGdzNTD+lzbAzvbLAlnih4bRhu+ig/N6fB7f1WjOQ2/yG+K
         huccsMCMu4fj+a4lmkYbyxxQYVJze5KsZgb/vz7+RtZJXMwtt+FfL3YLs07Gby3VbHDJ
         DTaaiVtnnkUi5gXoIc04gDKZtdnZS2XADXdK4esWa+8LoDJZKXxIrn6LfQnOXhscjDso
         6oED9JbI+rmzsOO60LRj3DD9p+Dhx+7W5mlN6yJAQ7Bqw+xe+jbczAXwqfu6HAWQVLQp
         ZS0eI/LV1KgPeE3AURMNhrhQ3La03btZwWy9GmQe5kslCAYcBaQtsjBKatKqd2buj/Ta
         3b0g==
X-Gm-Message-State: AOAM533y7Uorbzqpsa+v4+4Cde5mfSgYHAEPzq9nwMSVSvT90JLvy/Ou
        u+znFGlEHEhvSo6vapN+YOgdng==
X-Google-Smtp-Source: ABdhPJwN7M8YSHG4iF7b++t0/quAJ9PE73LLYCfZKEx6kSciDW9MpiOz69mCVKRkyTF+HUkKivUD3A==
X-Received: by 2002:a17:902:ec88:b0:14f:de5b:2fbe with SMTP id x8-20020a170902ec8800b0014fde5b2fbemr198232plg.123.1645629460230;
        Wed, 23 Feb 2022 07:17:40 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u6sm12183964pfk.203.2022.02.23.07.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 07:17:39 -0800 (PST)
Date:   Wed, 23 Feb 2022 07:17:36 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: vlan: allow vlan device MTU change follow real
 device from smaller to bigger
Message-ID: <20220223071736.1cb2cf3e@hermes.local>
In-Reply-To: <20220223112618.GA19531@debian.home>
References: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
        <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
        <YhQ1KrtpEr3TgCwA@gondor.apana.org.au>
        <8248d662-8ea5-7937-6e34-5f1f8e19190f@huawei.com>
        <CANn89iLf2ira4XponYV91cbvcdK76ekU7fDW93fmuJ3iytFHcw@mail.gmail.com>
        <20220222103733.GA3203@debian.home>
        <20220222152815.1056ca24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220223112618.GA19531@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 12:26:18 +0100
Guillaume Nault <gnault@redhat.com> wrote:

> On Tue, Feb 22, 2022 at 03:28:15PM -0800, Jakub Kicinski wrote:
> > On Tue, 22 Feb 2022 11:37:33 +0100 Guillaume Nault wrote:  
> > > What about an explicit option:
> > > 
> > >   ip link add link eth1 dev eth1.100 type vlan id 100 follow-parent-mtu
> > > 
> > > 
> > > Or for something more future proof, an option that can accept several
> > > policies:
> > > 
> > >   mtu-update <reduce-only,follow,...>
> > > 
> > >       reduce-only (default):
> > >         update vlan's MTU only if the new MTU is smaller than the
> > >         current one (current behaviour).
> > > 
> > >       follow:
> > >         always follow the MTU of the parent device.
> > > 
> > > Then if anyone wants more complex policies:
> > > 
> > >       follow-if-not-modified:
> > >         follow the MTU of the parent device as long as the VLAN's MTU
> > >         was not manually changed. Otherwise only adjust the VLAN's MTU
> > >         when the parent's one is set to a smaller value.
> > > 
> > >       follow-if-not-modified-but-not-quite:
> > >         like follow-if-not-modified but revert back to the VLAN's
> > >         last manually modified MTU, if any, whenever possible (that is,
> > >         when the parent device's MTU is set back to a higher value).
> > >         That probably requires the possibility to dump the last
> > >         modified MTU, so the administrator can anticipate the
> > >         consequences of modifying the parent device.
> > > 
> > >      yet-another-policy (because people have a lot of imagination):
> > >        for example, keep the MTU 4 bytes lower than the parent device,
> > >        to account for VLAN overhead.
> > > 
> > > Of course feel free to suggest better names and policies :).
> > > 
> > > This way, we can keep the current behaviour and avoid unexpected
> > > heuristics that are difficult to explain (and even more difficult for
> > > network admins to figure out on their own).  
> > 
> > My $0.02 would be that if we want to make changes that require new uAPI
> > we should do it across uppers.  
> 
> Do you mean something like:
> 
>   ip link set dev eth0 vlan-mtu-policy <policy-name>
> 
> that'd affect all existing (and future) vlans of eth0?
> 
> Then I think that for non-ethernet devices, we should reject this
> option and skip it when dumping config. But yes, that's another
> possibility.
> 
> I personnaly don't really mind, as long as we keep a clear behaviour.
> 
> What I'd really like to avoid is something like:
>   - By default it behaves this way.
>   - If you modified the MTU it behaves in another way
>   - But if you modified the MTU but later restored the
>     original MTU, then you're back to the default behaviour
>     (or not?), unless the MTU of the upper device was also
>     changed meanwhile, in which case ... to be continued ...
>   - BTW, you might not be able to tell how the VLAN's MTU is going to
>     behave by simply looking at its configuration, because that also
>     depends on past configurations.
>   - Well, and if your kernel is older than xxx, then you always get the
>     default behaviour.
>   - ... and we might modify the heuristics again in the future to
>     accomodate with situations or use cases we failed to consider.
> 

In general these kind of policy choices are done via sysctl knobs.
They aren't done at netlink/ip link level.

