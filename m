Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923FC2EA564
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 07:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbhAEGW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 01:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbhAEGW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 01:22:57 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C73C061574
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 22:22:17 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id n10so20618398pgl.10
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 22:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q6EzBo32QB9tKiHgZ2I3OZJNAx7CcQrFXfF1AeQ6b1Y=;
        b=qyxmsh1sHTEKh4J2JlD3yY3Ly9xPb6ATNFesIX39woX+Jv4Clmy/He4Ba4niPusDlm
         eZr9W+SgU66CGjgrCDjop7d15VPlbZJm29LEqOhA1DO4xGnuV35omByUgnHRPyNqWHTn
         7XlagLfadd584/gYGHFnCyaKXUoTde7MdL8DpthxZebuded3S3Ai6rJUsDTMC02wmjSd
         zO8IUJVhZVkd77RjVuVRZTWgKGr0ORoCzgH8f0a/kznHRZpxt4FOhLJb/uXDGcjheiKI
         VLTc8cArY3yndgbh517tc7eOfCoJMNBogLCoySVjf/uC/tqqIyXYh/qL9VwWf8hix1/R
         4dWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q6EzBo32QB9tKiHgZ2I3OZJNAx7CcQrFXfF1AeQ6b1Y=;
        b=fG493cjyC5yKXNdNIXStzgXoyTMj3SA46PZxaSAN0WS0v+6hn3j4Kr+T9R7rgKI4vC
         6v8gDJLS+se/KPeTmuZRTZR0Ogo1nMnCaekj7kd5NTJsHyB3YT+8tiWBM+SzYM2jWoRB
         0JQY3EieX0gBW86znoOSUAu+b9QV+iUwqpxiCh9BcMCg5VH94mhRsYBmZpw0VTv+EJb3
         5FDhOWezgwtHA5FPpjfZGj0Dqmfd6qDcZiwd7m6SAmvs1dH1Ywhf0LyPc3a7yBkGD81C
         VS71XyClnEwslItPnZkGMOdounArbQIPpvZEplC+3ZSxcVIe4/x3gbdIDBDjVcj99SdA
         ugqQ==
X-Gm-Message-State: AOAM5326pV5oZPNf40h1j6t7YS6hkgX/9EEPX6rFWBLSngyPyLCWsLYg
        QGwGHVm0eIOr/4p0fiJ/PvRyNqnV2fFJZnyjhrQ=
X-Google-Smtp-Source: ABdhPJw/EJsfTKOQJI/HihyVQyqe9V2Md+BwMue+/rjmmLYnHuzaQm4jJhV6HLc970dVA4AH5MRQjk459JznkrpJ9pI=
X-Received: by 2002:a63:1707:: with SMTP id x7mr41171696pgl.266.1609827736591;
 Mon, 04 Jan 2021 22:22:16 -0800 (PST)
MIME-Version: 1.0
References: <20201231034417.1570553-1-kuba@kernel.org> <CAM_iQpW1ZMyb33j4uLNMXXW+vQSS6FB1-BhxSQ7ZShi9dT2ZoQ@mail.gmail.com>
 <20210104094936.79247c33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210104094936.79247c33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 4 Jan 2021 22:22:05 -0800
Message-ID: <CAM_iQpUTZ9ZOAgfWjBP83Q9J3UFpVKbueboAs7uQFFuieyDfug@mail.gmail.com>
Subject: Re: [PATCH net] net: bareudp: add missing error handling for bareudp_link_config()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        martin.varghese@nokia.com, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 4, 2021 at 9:49 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 2 Jan 2021 15:49:54 -0800 Cong Wang wrote:
> > On Wed, Dec 30, 2020 at 7:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > @@ -661,9 +662,14 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
> > >
> > >         err = bareudp_link_config(dev, tb);
> > >         if (err)
> > > -               return err;
> > > +               goto err_unconfig;
> > >
> > >         return 0;
> > > +
> > > +err_unconfig:
> >
> > I think we can save this goto.
>
> I personally prefer more idiomatic code flow to saving a single LoC.
>
> > > +       list_del(&bareudp->next);
> > > +       unregister_netdevice(dev);
> >
> > Which is bareudp_dellink(dev, NULL). ;)
>
> I know, but calling full dellink when only parts of newlink fails felt
> weird. And it's not lower LoC, unless called with NULL as second arg,
> which again could be surprising to a person changing dellink.

I think calling a function with "bareudp_" prefix is more readable
than interpreting list_del()+unregister_netdevice(). I mean

if (bareudp_*())
  goto err;
...
err:
bareudp_*();

this looks cleaner, right?

Thanks.
