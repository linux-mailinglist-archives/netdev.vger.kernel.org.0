Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E82319817
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBLBo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBLBoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 20:44:54 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E21BC061756
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 17:44:14 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id v5so10937337lft.13
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 17:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Klai6ijiXMah8c4iiQZHxcS1VG4bowOMH7Gp0E8ik8=;
        b=kRmF6dU+1uEN05IVZ4HPJGHmcvnd+Pl1TeatcZzGYWMf0x4JPqUqLDN9ywVpJCtW0E
         6CzjaWcPWZru6I6T+JHaFlFGABChCGPX2XCb5fxfHoAI10s7Ns8ZeLOszS6/iYCCgHCz
         S9L/2c6Qtr1/LY5rrgWhS8OKojvKLmVMCWWQbz/d0sCJ+DFhN+kwIBILoW3bSaGbHLnN
         heBqwZ9HiR+uJG1aKVLhWxbqdzG7MSkEonPH4n7U/xDhxeiN/edJxdyz9L5qMMRIuWOw
         SaiQF3gFtjykPxzIuT+GzX0euv76k4cwajtNij5X1xruVgVbC1e0BB9594IlNhdE28G2
         bXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Klai6ijiXMah8c4iiQZHxcS1VG4bowOMH7Gp0E8ik8=;
        b=Nuy6DiQrpEWtj9I9uOlAurIXfj46Nf0OlIdmObmue+WtHBUYEl3J63oDDTQ5J5ur+8
         jeW89rw/L7tUoMwBj2tLItmlsujfwLOYXH8HYcDtfdOnqM74pNacxGrdxIiTdidM/CmO
         pY28I3F8jKEhzF4Dxj+yJwaKTS7zlKkneiDFoEUcqaH7G32FYDnrbGwMngNHOYli8C19
         UE8lFEMdjztkuc0bN7qwZdjQX8/JceM2MDL/KJ8xMtewNRWohTbMnQDrRkmFtrKfFh+O
         BgBS/+AlRAMUuY0v8zAxaTMKU2WkEwxbVdvKg1pZrIgo+YAHSHFgkuQLlVTT+xzvYGjL
         x3bQ==
X-Gm-Message-State: AOAM5336xVJWmAvpfS3PAGDReskf8xOoI+OVcvQ/gCal3MUSrhu2V34L
        OY4R9UiEhyZWN1gRte1a4a1USscst8AbNQYadDU=
X-Google-Smtp-Source: ABdhPJz7auQ8Qd1W571v7dzv2ApGMyLmGVLSRLOLICV6as23BmoyGt/RK/et9xdl1/hHe5Lgu+V/USeQA0hA2cjBJbg=
X-Received: by 2002:a19:6d07:: with SMTP id i7mr403339lfc.75.1613094252578;
 Thu, 11 Feb 2021 17:44:12 -0800 (PST)
MIME-Version: 1.0
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
 <56e72b72-685f-925d-db2d-d245c1557987@gmail.com> <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
 <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org> <CAEA6p_ArQdNp=hQCjrsnAo-Xy22d44b=2KdLp7zO7E7XDA4Fog@mail.gmail.com>
 <f10c733a-09f8-2c72-c333-41f9d53e1498@gmail.com> <6a314f7da0f41c899926d9e7ba996337@codeaurora.org>
 <839f0ad6-83c1-1df6-c34d-b844c52ba771@gmail.com> <9f25d75823a73c6f0f556f0905f931d1@codeaurora.org>
 <5905440c-163a-d13e-933e-c9273445a6ed@gmail.com> <CAEA6p_CfmJZuYy7msGm0hi813q92hO2daC_zEZhhj0y3FYJ4LA@mail.gmail.com>
 <CAADnVQ+AbH0Xs_fF5mESb2i-TCL0T-inpAX+gtggDbHhA+9djA@mail.gmail.com> <20210211172856.3d913519@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210211172856.3d913519@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 11 Feb 2021 17:44:01 -0800
Message-ID: <CAADnVQL4PSQd79fjkwWnq0C_1rLT3rwUOs4aWK67i9DVHuysWA@mail.gmail.com>
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        stranche@codeaurora.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 5:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Feb 2021 11:21:26 -0800 Alexei Starovoitov wrote:
> > On Tue, Jan 5, 2021 at 11:11 AM Wei Wang <weiwan@google.com> wrote:
> > > On Mon, Jan 4, 2021 at 8:58 PM David Ahern <dsahern@gmail.com> wrote:
> > > > On 1/4/21 8:05 PM, stranche@codeaurora.org wrote:
> > > Ah, I see now. rt6_flush_exceptions is called by fib6_del_route, but
> > > > that won't handle replace.
> > > >
> > > > If you look at fib6_purge_rt it already has a call to remove pcpu
> > > > entries. This call to flush exceptions should go there and the existing
> > > > one in fib6_del_route can be removed.
> > > >
> > > Thanks for catching this!
> > > Agree with this proposed fix.
> >
> > Looks like this fix never landed?
> > Is it still needed or there was an alternative fix merged?
>
> Wasn't it:
>
> d8f5c29653c3 ("net: ipv6: fib: flush exceptions when purging route")
>
> ?

Ahh. Thanks!
