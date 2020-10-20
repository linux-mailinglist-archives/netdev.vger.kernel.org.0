Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8954294461
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409754AbgJTVLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgJTVLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 17:11:14 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD05C0613CE;
        Tue, 20 Oct 2020 14:11:12 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id bl9so1684132qvb.10;
        Tue, 20 Oct 2020 14:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ecIivpc/1HsN13YzeA7fwLIPqYvZiXYhNL2Lt9A0dWw=;
        b=uSOYa0MOTaoJ19s0MnDjoHCH+YLMMdITNpuBPXdSWZhDPwyXCWwcPePsyheTTiFaVN
         PPkyeevH7LYWNh0P6JEt3V7Uv2y/P/WlWZsWsW82Y9RrwpSo6EnT3izcHKOs1DGGz4QQ
         DSfvRHoaDw+J7PW2iE5Ht2ITcNenWu2zrwjFq5nIYG8upsQBVAwzyRUSSJc8yH4Uc0qB
         Zkj49+hYI5WoTFSTKyB7ux9Nhz0f0MfAflzZL7briH76MtJ5+1cEylOVDAYAPeCjAn/f
         ZNNY//vSHMfFyrY9C8c9Q0YuklR9EgjrjhWCQAhXjiOKWN/NKDMMbnCZlcUCJi0wI70A
         SkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ecIivpc/1HsN13YzeA7fwLIPqYvZiXYhNL2Lt9A0dWw=;
        b=fxsj3k6kvmR5ltWB50Mc/5pLssIeG3YKAaDYAHPHF/Bu4QxTa448TJQktMyBFdrv88
         nTQJTW/MPN5czw/4r+7gfz8LC3zsqB03ID+/MvHX+Rg1tFzs+Qoma0nQaO1ol6YBfHz8
         Jrrbd5mNzr3yEYwiJ0orX7t5PwQKHGWo/jS1P7WDgrh5jnHozLAsm1JJuLJ8nCn6QNZ2
         IkwOWp9Zsh9TjmZbYS1MQ1hb8FsaG0HvmlG4i1yMBbwHrcCGKvTK7jQaxJ7xogurj/Hv
         I1Loy6DME6weIiOEVYjqTShkUHMZP4QTY3PsRuHbCnkLQ+x+di/MiWlfBc4y8cGLWOlG
         IAtg==
X-Gm-Message-State: AOAM5330fBKRn+6fCj5WRp2+ULty33hafL6ewZ2JVPPr/WlkaAlUEOY1
        6Fxya/wBdFfK9txrkMX2gS0=
X-Google-Smtp-Source: ABdhPJyfsFH5kFEFInCEUMn4/F1aXcn2lzkusPQn6hTW7FLA4gJW9a8tFtFe8eGpDF49HwVHqZ2E7g==
X-Received: by 2002:a0c:b385:: with SMTP id t5mr5409153qve.39.1603228271787;
        Tue, 20 Oct 2020 14:11:11 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:21ac:5145:f91d:ccdb:98a2])
        by smtp.gmail.com with ESMTPSA id k64sm39049qkc.97.2020.10.20.14.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 14:11:10 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4EF0BC1632; Tue, 20 Oct 2020 18:11:08 -0300 (-03)
Date:   Tue, 20 Oct 2020 18:11:08 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Message-ID: <20201020211108.GF11030@localhost.localdomain>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain>
 <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 05:12:06PM +0800, Xin Long wrote:
> On Tue, Oct 20, 2020 at 6:15 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Mon, Oct 19, 2020 at 08:25:33PM +0800, Xin Long wrote:
> > > --- a/Documentation/networking/ip-sysctl.rst
> > > +++ b/Documentation/networking/ip-sysctl.rst
> > > @@ -2640,6 +2640,12 @@ addr_scope_policy - INTEGER
> > >
> > >       Default: 1
> > >
> > > +udp_port - INTEGER
> >
> > Need to be more verbose here, and also mention the RFC.
> >
> > > +     The listening port for the local UDP tunneling sock.
> >         , shared by all applications in the same net namespace.
> > > +     UDP encapsulation will be disabled when it's set to 0.
> >
> >         "Note, however, that setting just this is not enough to actually
> >         use it. ..."
> When it's a client, yes,  but when it's a server, the encap_port can
> be got from the incoming packet.
> 
> >
> > > +
> > > +     Default: 9899
> > > +
> > >  encap_port - INTEGER
> > >       The default remote UDP encapsalution port.
> > >       When UDP tunneling is enabled, this global value is used to set
> >
> > When is it enabled, which conditions are needed? Maybe it can be
> > explained only in the one above.
> Thanks!
> pls check if this one will be better:

It is. Verbose enough now, thx.
(one other comment below)

> 
> udp_port - INTEGER
> 
> The listening port for the local UDP tunneling sock.
> 
> This UDP sock is used for processing the incoming UDP-encapsulated
> SCTP packets (from RFC6951), and shared by all applications in the
> same net namespace. This UDP sock will be closed when the value is
> set to 0.
> 
> The value will also be used to set the src port of the UDP header
> for the outgoing UDP-encapsulated SCTP packets. For the dest port,
> please refer to 'encap_port' below.
> 
> Default: 9899

I'm now wondering if this is the right default. I mean, it is the
standard port for it, yes, but at the same time, it means loading SCTP
module will steal/use that UDP port on all net namespaces and can lead
to conflicts with other apps. A more conservative approach here is to
document the standard port, but set the default to 0 and require the
user to set it in if it is expected to be used.

Did FreeBSD enable it by default too?
