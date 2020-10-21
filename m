Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871B629472D
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411909AbgJUERP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406955AbgJUERP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 00:17:15 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C98AC0613CE;
        Tue, 20 Oct 2020 21:17:15 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b8so1336870wrn.0;
        Tue, 20 Oct 2020 21:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mtCWTzThbSGsPnLQ2dhcZTUW9wJC0LLgAyW+oajv6I0=;
        b=jhQ5JymE3kbh64yTNo+18tKxgHWk8wCEeCdACK0FgQzC2MCZvDEpq1wjHhxfvpkdw4
         Y5up1dS/fmOUPBoIYCcZjc3zuzmQXk0idi1tNzMLuu133Wd/u3tSNLL5jg2trOJDdpZr
         yxRBXRm8bNHYKHYkRV//PQOoBkNX7EAkY3WmcG/cO6DwPo80zzW+YAe+WlQJEZCePGN+
         3L5tuJUgCFUa0c/RddXps6z4Ja02rtmIxs67PIojtUWgYhdXcf0FSKc5yYmoHdHcaFgX
         8MssalrLWgsP7+EuS3G4uwhG2qPsnYXewrZAkH7ncYpO6KsXKNmPCc9qrGmcE0lLjVsc
         fVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtCWTzThbSGsPnLQ2dhcZTUW9wJC0LLgAyW+oajv6I0=;
        b=a1ivyebbkBXUCBlJo1knhO6vEbAgrRq97vIElnzMGELS1tHzGG0HZwNsogUthq18nS
         UeixUgiWtl88zL4mSsvBO1xOiMjA/+8CtI3YC2thVLRrGOnEJuAGDhPNKTe5Cmh70VdF
         vhYpk4eTtoTTMQx10mJeBYv4A95wxDnOxqASqhJ2g1qaJSnOc+O/SwTnrspAmF7ZHkAI
         Ll5Mv5Cw/bP6StZ9QJW3zKL2EsSMjXDsNVyG7ulqfa+r2jsur5crcx7PQo4ZWe+T9Cp7
         e8Pq9LVkXPM/1TWlv3e3UU91lps5ppGzHS+MaUiEoNvrIdwVP1U/CrkEZLbTTdmWyJrF
         dHEQ==
X-Gm-Message-State: AOAM533Y9AJ3i+Z5qWLDdtOgQFJKLPvlRr4zv3w1JqJmSGBq3WmnC6j4
        29vmr9Y4PTb/hjl3p+vW25ZTmU2XWOxH1C9HfxQ=
X-Google-Smtp-Source: ABdhPJyi42ELNus1lAQH7wBqU6iEgKGrfj89cdeufFJ2aWDWh7xpRxIqM05RnCYJkbZ2V8FtPPqg7GgWTvqkY7ZIYNo=
X-Received: by 2002:a1c:4683:: with SMTP id t125mr1326869wma.110.1603253828608;
 Tue, 20 Oct 2020 21:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1603110316.git.lucien.xin@gmail.com> <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain> <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
 <20201020211108.GF11030@localhost.localdomain> <3BC2D946-9EA7-4847-9C6E-B3C9DA6A6618@fh-muenster.de>
 <20201020212338.GG11030@localhost.localdomain>
In-Reply-To: <20201020212338.GG11030@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 21 Oct 2020 12:16:53 +0800
Message-ID: <CADvbK_csZzHwQ04rMnCDw6=4meY-rrH--19VWm8ROafYSQWWeQ@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Michael Tuexen <tuexen@fh-muenster.de>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 5:23 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Oct 20, 2020 at 11:15:26PM +0200, Michael Tuexen wrote:
> > > On 20. Oct 2020, at 23:11, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Tue, Oct 20, 2020 at 05:12:06PM +0800, Xin Long wrote:
> > >> On Tue, Oct 20, 2020 at 6:15 AM Marcelo Ricardo Leitner
> > >> <marcelo.leitner@gmail.com> wrote:
> > >>>
> > >>> On Mon, Oct 19, 2020 at 08:25:33PM +0800, Xin Long wrote:
> > >>>> --- a/Documentation/networking/ip-sysctl.rst
> > >>>> +++ b/Documentation/networking/ip-sysctl.rst
> > >>>> @@ -2640,6 +2640,12 @@ addr_scope_policy - INTEGER
> > >>>>
> > >>>>      Default: 1
> > >>>>
> > >>>> +udp_port - INTEGER
> > >>>
> > >>> Need to be more verbose here, and also mention the RFC.
> > >>>
> > >>>> +     The listening port for the local UDP tunneling sock.
> > >>>        , shared by all applications in the same net namespace.
> > >>>> +     UDP encapsulation will be disabled when it's set to 0.
> > >>>
> > >>>        "Note, however, that setting just this is not enough to actually
> > >>>        use it. ..."
> > >> When it's a client, yes,  but when it's a server, the encap_port can
> > >> be got from the incoming packet.
> > >>
> > >>>
> > >>>> +
> > >>>> +     Default: 9899
> > >>>> +
> > >>>> encap_port - INTEGER
> > >>>>      The default remote UDP encapsalution port.
> > >>>>      When UDP tunneling is enabled, this global value is used to set
> > >>>
> > >>> When is it enabled, which conditions are needed? Maybe it can be
> > >>> explained only in the one above.
> > >> Thanks!
> > >> pls check if this one will be better:
> > >
> > > It is. Verbose enough now, thx.
> > > (one other comment below)
> > >
> > >>
> > >> udp_port - INTEGER
> > >>
> > >> The listening port for the local UDP tunneling sock.
> > >>
> > >> This UDP sock is used for processing the incoming UDP-encapsulated
> > >> SCTP packets (from RFC6951), and shared by all applications in the
> > >> same net namespace. This UDP sock will be closed when the value is
> > >> set to 0.
> > >>
> > >> The value will also be used to set the src port of the UDP header
> > >> for the outgoing UDP-encapsulated SCTP packets. For the dest port,
> > >> please refer to 'encap_port' below.
> > >>
> > >> Default: 9899
> > >
> > > I'm now wondering if this is the right default. I mean, it is the
> > > standard port for it, yes, but at the same time, it means loading SCTP
> > > module will steal/use that UDP port on all net namespaces and can lead
> > > to conflicts with other apps. A more conservative approach here is to
> > > document the standard port, but set the default to 0 and require the
> > > user to set it in if it is expected to be used.
> > >
> > > Did FreeBSD enable it by default too?
> > No. The default is 0, which means that the encapsulation is turned off.
> > Setting this sysctl variable to a non-zero value enables the UDP tunneling
> > with the given port.
>
> Thanks Michael.
> Xin, then we should change this default value (and update the
> documentation above accordingly, to still have the standard port #
> readily available in there).
OK, I misunderstood the RFC.

I will remove the call to sctp_udp_sock_start/stop() from
sctp_ctrlsock_init/exit(), and set the udp_port as 0 by default.

Thanks.
