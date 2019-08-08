Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8FC86A86
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404368AbfHHTXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:23:09 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:40007 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404346AbfHHTXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:23:08 -0400
Received: by mail-yw1-f68.google.com with SMTP id b143so34480258ywb.7
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HzS1vBGocY2QnhrZLuq2+a83vo0BXLeyFuSj8dAvCBQ=;
        b=rmKDow7y70crngwxWeM6fHjYtjdBUfPK08QmndXZf6gpgson1GFCGiSh4XdJzj3fOP
         iMTBuhFjv4DpN2Pz+e+6YAIaXoSC0832DJsSAG8+xZrVA1FV6OnaOo7fxzT9HcEfJ8mo
         GwCR90wVLHcdoUt+5RxeZBzdhb3tfdQbBJDVmH1QQw8l3REgPa8qG3iJ7kJsfmGJmK5V
         OuYWkVOwaq3hMNfSmfYAD3xodUEZOQ+TjxPB76Esll0H1R8CC6R07c9Oempn14oLaO2a
         zUDVtggdJjTyca45krPdn3VHL8XC3VVXNIMaotPmK0M+gOL4bvMJLEoGhxwTO9iTgMWB
         O8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HzS1vBGocY2QnhrZLuq2+a83vo0BXLeyFuSj8dAvCBQ=;
        b=s7K1ivS6eNFBfRhtfyVma8gAUDIMIc3jILel2G5aYrkVHL3XO+QUhStQsDOLOKYUiH
         CDUw9xBYtVyYCwiCTyzxL07HK+9I/0qUDKqKxiwpEAH093CJsoGb+oHcJk84sQgSG3HB
         gG6SRXbMaHZ4DpDp16REFyM+6nH+4VVj3DOpefsJXQnp/1uz4vhLptlKSWCkZxY0Xu6B
         7gIX3cB5SnDTvTQ8fcTgLrPZd/qzk6YEn20znqDRxoiLdPKqkxlllws6/M/WGLfNvF/6
         Mx1x5J3RErhVwFv+qR0vxkXRCE6ATD5H0w04eGIXi/xo7Cq59DGz8CFaMT0DgPihZQUI
         vu5Q==
X-Gm-Message-State: APjAAAVC6TVCSY6kMRTnmLybe+hV/Op3zE30omxAfYVpj6UFS/MJvaqN
        Tpyb5j/nAqlYVVqrsY2BTq1F5w6/tOayAV6RBw==
X-Google-Smtp-Source: APXvYqwZo+EYSfMubf5Xa5LEpXGLunhD1RT7PzPpGOW0bGM+MFk40JQkkPpDLRbbdOyG2Lqrcej9ZFsc9XPvtj6NVsk=
X-Received: by 2002:a81:8747:: with SMTP id x68mr11532678ywf.504.1565292187833;
 Thu, 08 Aug 2019 12:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190807022509.4214-1-danieltimlee@gmail.com> <20190807022509.4214-2-danieltimlee@gmail.com>
 <20190807134208.6601fad2@cakuba.netronome.com> <CAEKGpzj1VKWuWioEmRkNXrgfDdT-KkWZWsrbY+p=yyK8sPctwg@mail.gmail.com>
 <20190808104948.7e72dea0@cakuba.netronome.com>
In-Reply-To: <20190808104948.7e72dea0@cakuba.netronome.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 9 Aug 2019 04:22:56 +0900
Message-ID: <CAEKGpzg-fhWNTyOPyT8ASzzsKBFZiRZkPvV8AjErhSS9bxt23A@mail.gmail.com>
Subject: Re: [v3,1/4] tools: bpftool: add net attach command to attach XDP on interface
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 2:50 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 8 Aug 2019 07:15:22 +0900, Daniel T. Lee wrote:
> > > > +             return -EINVAL;
> > > > +     }
> > > > +
> > > > +     NEXT_ARG();
> > >
> > > nit: the new line should be before NEXT_ARG(), IOV NEXT_ARG() belongs
> > > to the code which consumed the argument
> > >
> >
> > I'm not sure I'm following.
> > Are you saying that, at here the newline shouldn't be necessary?
>
> I mean this is better:
>
>         if (!is_prefix(*argv, "bla-bla"))
>                 return -EINVAL;
>         NEXT_ARG();
>
>         if (!is_prefix(*argv, "bla-bla"))
>                 return -EINVAL;
>         NEXT_ARG();
>
> Than this:
>
>         if (!is_prefix(*argv, "bla-bla"))
>                 return -EINVAL;
>
>         NEXT_ARG();
>         if (!is_prefix(*argv, "bla-bla"))
>                 return -EINVAL;
>
>         NEXT_ARG();
>
> Because the NEXT_ARG() "belongs" to the code that "consumed" the option.
>
> So instead of this:
>
>      attach_type = parse_attach_type(*argv);
>      if (attach_type == max_net_attach_type) {
>              p_err("invalid net attach/detach type");
>              return -EINVAL;
>      }
>
>      NEXT_ARG();
>      progfd = prog_parse_fd(&argc, &argv);
>      if (progfd < 0)
>              return -EINVAL;
>
> This seems more logical to me:
>
>      attach_type = parse_attach_type(*argv);
>      if (attach_type == max_net_attach_type) {
>              p_err("invalid net attach/detach type");
>              return -EINVAL;
>      }
>      NEXT_ARG();
>
>      progfd = prog_parse_fd(&argc, &argv);
>      if (progfd < 0)
>              return -EINVAL;

Oh. I see.
I'll update NEXT_ARG line stick to the code which "consumes" the option.

Thanks for the review! :)
