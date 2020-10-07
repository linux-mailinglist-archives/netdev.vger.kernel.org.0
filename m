Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E998D285640
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 03:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgJGBYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 21:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgJGBYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 21:24:40 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C1DC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 18:24:40 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t18so776813ilo.12
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 18:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E1dFloofMfn7FRqxtkiLA1WJPnSQWg17TfBVKxTqQ7Q=;
        b=azl677csei2OlMaql1YvG4XfQSR77N2iyicOQalBnojFLrVKmTRhhFCbf+O+etiUwI
         /XIECxhTtX69YfFZnWRi+HxfXitdEWlPCSJKZJpn3tClG1IYCyzKIp7jQBaOygkI9OEn
         ouzdB/60zjS56FyQoebrSP8qqoYNBLj+eR4I+/0mbQMOoejp+KLOu2hwRuXhk9m5+Wn7
         iOVDkddYSmKbgvnwL9HAP3/d2bpmV9DhMT7E5PMB5aZZSk1x7uwazUBkFLfa4WVtR0gI
         7bwjQN+KIKul09VTV0UcPpFjFFzF8AtSvj/mTIes+RGqRjMglmU+cTbVxLK/4Y2xlZ2j
         UkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E1dFloofMfn7FRqxtkiLA1WJPnSQWg17TfBVKxTqQ7Q=;
        b=g18JrpOpJFm+y9XwwZzYmaZriwX2FmmLy1R22PERld+Q+3nvNmBXLYZhBdOgTl6zWw
         G+xxFFj8bkwGAChmR1UNbveZzsGgM7YxtoK92l1wZnE47yOI5rH8VEGtxHU0eL1AWZTr
         EDtQtozFf3+JCv0Ac82xN/W8FClkKo+xr54F17HzNiAAl6CWSteqHErkAfPoHzUXm02G
         7EOumFg7MQNHhO3/SJyS/XdnLrXdIOAG0UjlnFbya8AiPCBYZBYOx8WRviEA+XZAOnaP
         MnFCx4exQT1rq8PBKR8oDbemgcuxdXsVBx7hRu8T0AbKR+qN1Mr3lm8R2uiUDH/WJtnm
         +KFA==
X-Gm-Message-State: AOAM533Ln0pE7TqOuWrJbN6yxEOmgVB01amTkCbLJ7kTyd/BfUx76hNb
        RHcGXw0lJofZ8SRItBL/U8Eh+Qu4bQPLZi49oZraWw==
X-Google-Smtp-Source: ABdhPJzrDkLjNAhcNX1cvoHWN/nDJNz6SaUIp6T0XSS/DNMJuK3r9FApm2wNN58dxCkbu7ILNjZLWzpJhvNEBDm5QNw=
X-Received: by 2002:a92:9408:: with SMTP id c8mr726209ili.61.1602033879796;
 Tue, 06 Oct 2020 18:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <160200013701.719143.12665708317930272219.stgit@firesoul>
 <160200018165.719143.3249298786187115149.stgit@firesoul> <20201006183302.337a9502@carbon>
 <20201006181858.6003de94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006181858.6003de94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 6 Oct 2020 18:24:28 -0700
Message-ID: <CANP3RGe3S4eF=xVkQ22o=sxtW991jmNfq-bVtbKQQaszsLNZSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V1 3/6] bpf: add BPF-helper for reading MTU from
 net_device via ifindex
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 6:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 6 Oct 2020 18:33:02 +0200 Jesper Dangaard Brouer wrote:
> > > +static const struct bpf_func_proto bpf_xdp_mtu_lookup_proto = {
> > > +   .func           = bpf_xdp_mtu_lookup,
> > > +   .gpl_only       = true,
> > > +   .ret_type       = RET_INTEGER,
> > > +   .arg1_type      = ARG_PTR_TO_CTX,
> > > +   .arg2_type      = ARG_ANYTHING,
> > > +   .arg3_type      = ARG_ANYTHING,
> > > +};
> > > +
> > > +
>
> FWIW
>
> CHECK: Please don't use multiple blank lines
> #112: FILE: net/core/filter.c:5566:

FYI: It would be nice to have a similar function to return a device's
L2 header size (ie. 14 for ethernet) and/or hwtype.

Also, should this be restricted to gpl only?

[I'm not actually sure, I'm actually fed up with non-gpl code atm, and
wouldn't be against all bpf code needing to be gpl'ed...]
