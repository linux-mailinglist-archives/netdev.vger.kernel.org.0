Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CB2330004
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 11:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhCGKHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 05:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbhCGKHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 05:07:21 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDFAC06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 02:07:21 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id p7so2484463eju.6
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 02:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NKk33qQkc8DpMviJzc+qDqffpGYfOAMC3NSZvpNhdhk=;
        b=NRM4bkInM/SxIJpP9houYF+TXfHhw7B12G50Ek21Pe9+9zi/T2jVQQv5Z1CzT7mgdU
         yhx7w4UjpMm92fKbkrZynAcJg3OMaDphdRjum2JN+DerGSQPb2oRMMDVuo5U9bP6cZcK
         wr3X4S2ZunXdmtcgUqDzOWneiyAinfcnp3IPrXv4L8Fp9wgQwvGoq790cw/yJk54d4C8
         Ue8b29/JcJY1Mau5Z7RTq+wmaRMf5th4vOSpcxJPT9Or0i5b2800WZcUviklyfvx6Pou
         RUKMYnHNgjq3vyAOjVdX/XOS6juzjdn6T0qXnBvIJZz/TX/OEq21qK631kp1gazgFj+a
         8tZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NKk33qQkc8DpMviJzc+qDqffpGYfOAMC3NSZvpNhdhk=;
        b=BIdvnv+dQAjN/Rx3X/QsrfxjcLEuqE7iOqA5IdBk1dneCoboLI8PILZT0XzR5G42C7
         sbxxbenel6/zmWAeJp2EfAQM9dMaCHN+kQGuiAsuwtPv6i/G77pAkRN2r5KoVjPQDZg8
         /NmPrYb2YwiDsobWnhs27kMvQd8d6IvTqXOwQ33/Wrxeubzto3W6UXQhC2yFkMGrhTGl
         DK/3KDWaxGHnjaR2jZahw756xnwGB8x6a6dWsnGt3xIZ0yA+MfXNqJXJkcLMreZMUVmB
         8YZwxshrHx8IVT9Wv3MddbRdpAfaEVK4hPeId1h0w4cNkom+LPcmkTdEIEFb4A0u76l5
         1zEA==
X-Gm-Message-State: AOAM5338k7qFvOMm6VenJR2uEnxUi5TJu4RYEsxz6Y7+Vk5kliS01uW+
        WAlrlkBbiF10XfmcIVOvxf0=
X-Google-Smtp-Source: ABdhPJzmdd6dJsbQAYmpZt16pBF1oaeIW8KXaCVHcn/jgnGmNtZPBvOY3xW/XLpjBRwSWJNew1dpIw==
X-Received: by 2002:a17:906:ef2:: with SMTP id x18mr6325383eji.323.1615111639933;
        Sun, 07 Mar 2021 02:07:19 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id x4sm4878842edd.58.2021.03.07.02.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 02:07:19 -0800 (PST)
Date:   Sun, 7 Mar 2021 12:07:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: Always react to global bridge
 attribute changes
Message-ID: <20210307100718.w7tyyyneyobtomfg@skbuf>
References: <20210306002455.1582593-1-tobias@waldekranz.com>
 <20210306002455.1582593-3-tobias@waldekranz.com>
 <20210306140033.axpbtqamaruzzzew@skbuf>
 <20210306140440.3uwmyji4smxdpgpm@skbuf>
 <87czwcqh96.fsf@waldekranz.com>
 <20210307005826.mj6jqyov4kzhqsti@skbuf>
 <877dmjqokp.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dmjqokp.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 10:51:18AM +0100, Tobias Waldekranz wrote:
> On Sun, Mar 07, 2021 at 02:58, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Sat, Mar 06, 2021 at 07:17:09PM +0100, Tobias Waldekranz wrote:
> >> On Sat, Mar 06, 2021 at 16:04, Vladimir Oltean <olteanv@gmail.com> wrote:
> >> > On Sat, Mar 06, 2021 at 04:00:33PM +0200, Vladimir Oltean wrote:
> >> >> Hi Tobias,
> >> >>
> >> >> On Sat, Mar 06, 2021 at 01:24:55AM +0100, Tobias Waldekranz wrote:
> >> >> > This is the second attempt to provide a fix for the issue described in
> >> >> > 99b8202b179f, which was reverted in the previous commit.
> >> >> >
> >> >> > When a change is made to some global bridge attribute, such as VLAN
> >> >> > filtering, accept events where orig_dev is the bridge master netdev.
> >> >> >
> >> >> > Separate the validation of orig_dev based on whether the attribute in
> >> >> > question is global or per-port.
> >> >> >
> >> >> > Fixes: 5696c8aedfcc ("net: dsa: Don't offload port attributes on standalone ports")
> >> >> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> >> > ---
> >> >>
> >> >> What do you think about this alternative?
> >> >
> >> > Ah, wait, this won't work when offloading objects/attributes on a LAG.
> >> > Let me actually test your patch.
> >>
> >> Right. But you made me realize that my v1 is also flawed, because it
> >> does not guard against trying to apply attributes to non-offloaded
> >> ports. ...the original issue :facepalm:
> >>
> >> I have a version ready which reuses the exact predicate that you
> >> previously added to dsa_port_offloads_netdev:
> >>
> >> -               if (netif_is_bridge_master(attr->orig_dev))
> >> +               if (dp->bridge_dev == attr->orig_dev)
> >>
> >> Do you think anything else needs to be changed, or should I send that as
> >> v2?
> >
> > Sorry, I just get a blank stare when I look at that blob of code you've
> > added at the beginning of dsa_slave_port_attr_set, it might as well be
> > correct but I'm not smart enough to process it and say "yes it is".
> >
> > What do you think about this one? At least for me it's easier to
> > understand what's going on, and would leave a lot more room for further
> > fixups if needed.
>
> I like the approach of having to explicitly state the supported orig_dev
> per attribute or object. I think we should go with your fix.

Ok, I'm sending it as-is. Thanks again!
