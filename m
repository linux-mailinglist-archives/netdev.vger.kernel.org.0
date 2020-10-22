Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0595C2956A1
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 05:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443220AbgJVDNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 23:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442068AbgJVDNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 23:13:11 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30884C0613CE;
        Wed, 21 Oct 2020 20:13:11 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id k21so255819wmi.1;
        Wed, 21 Oct 2020 20:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RPuifGNGlhjVfszqKMOn5Y70zir8Fda3sApRhgcK6+Q=;
        b=aSTwHLEY7nFTj7UAOZerhSz/J2mUFJ14Nbahqk4pXY2hDc7mrZ9LjzeaU200od3sSW
         EFmZY+tz5VkbfHqn9o/QChW7LJ+4S0IjsI5wEd8rcRSyGMdVmsUBV5repgTuPKXdx9Xw
         9ceno6rmkHg98ysf7rYevtOXb1bY8CKXwe4lSKVI4hqu2FRSFoPXJMuBGN7tRv9Ld1KJ
         pFd7uNKFStH3ZZQfn4y2PmBW/H4M10tYuWAcj8SMq0zRs7nI23sGSI2OK2W6AQ3L1BqJ
         yHB3u4OLe6JgCMxpf+yf2Vd43v9ddGWAKNrQs3xEIptfzmLradxZA9r562rRJberpN0j
         pOgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RPuifGNGlhjVfszqKMOn5Y70zir8Fda3sApRhgcK6+Q=;
        b=lE7D/0/RK9K2s/zKNHuO1C838dQsjPiDVpmv/RP/+/rF2BD7muSjjleLqOUhN0IkLF
         NJvVUVKvZ3x43XMkemhFs9MiboCBkVhd78ouNCCReduQyWscKWLzsb+6koUxolr0C1ds
         hxNVRteWXqlr0cxKxO5R3En+Wp6OdGc+b2/L2FMJEFS1v51MPGU2hCwJCCdsmC8dqAUj
         NNk5p2hPTf0uItbuj1+22XndDL8PV2OvqO/hPOiXtIOD1AXjrDV2zBcXLDtnhA90yV8F
         44FKUznN6wc8u8qJm1jD1HYNRdbJaPoFUhvb+sc05F55g7Kzm49a8rO+f4XkDTxS/idB
         Oyig==
X-Gm-Message-State: AOAM533q1yNJ8ZF9HGbQZVUfXw+J/1YfS0Gy87R/p8UOTSoTVMPBfAl0
        ej653+Ao/Z7EEGfOzDzMuJRML6ekhfKocwDTqwo=
X-Google-Smtp-Source: ABdhPJwWsgx/DUHbCS7KE/aIhJ67wk2PwIXEpFxpQX1FfYa39D49TgF89m+1oz2HouJpaYLgF69N8pJUeKaPGvazuTc=
X-Received: by 2002:a1c:4683:: with SMTP id t125mr431708wma.110.1603336389731;
 Wed, 21 Oct 2020 20:13:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1603110316.git.lucien.xin@gmail.com> <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain> <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
 <20201020211108.GF11030@localhost.localdomain> <3BC2D946-9EA7-4847-9C6E-B3C9DA6A6618@fh-muenster.de>
 <20201020212338.GG11030@localhost.localdomain> <CADvbK_csZzHwQ04rMnCDw6=4meY-rrH--19VWm8ROafYSQWWeQ@mail.gmail.com>
 <5EE3969E-CE57-4D9E-99E9-9A9D39C60425@fh-muenster.de>
In-Reply-To: <5EE3969E-CE57-4D9E-99E9-9A9D39C60425@fh-muenster.de>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 22 Oct 2020 11:12:57 +0800
Message-ID: <CADvbK_cZua_+2e=u--cV4jH5tR=24DvcEtwcHfAp1kyq9sYofA@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
To:     Michael Tuexen <tuexen@fh-muenster.de>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 5:13 PM Michael Tuexen <tuexen@fh-muenster.de> wrote:
>
> > On 21. Oct 2020, at 06:16, Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Wed, Oct 21, 2020 at 5:23 AM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> >>
> >> On Tue, Oct 20, 2020 at 11:15:26PM +0200, Michael Tuexen wrote:
> >>>> On 20. Oct 2020, at 23:11, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> >>>>
> >>>> On Tue, Oct 20, 2020 at 05:12:06PM +0800, Xin Long wrote:
> >>>>> On Tue, Oct 20, 2020 at 6:15 AM Marcelo Ricardo Leitner
> >>>>> <marcelo.leitner@gmail.com> wrote:
> >>>>>>
> >>>>>> On Mon, Oct 19, 2020 at 08:25:33PM +0800, Xin Long wrote:
> >>>>>>> --- a/Documentation/networking/ip-sysctl.rst
> >>>>>>> +++ b/Documentation/networking/ip-sysctl.rst
> >>>>>>> @@ -2640,6 +2640,12 @@ addr_scope_policy - INTEGER
> >>>>>>>
> >>>>>>>     Default: 1
> >>>>>>>
> >>>>>>> +udp_port - INTEGER
> >>>>>>
> >>>>>> Need to be more verbose here, and also mention the RFC.
> >>>>>>
> >>>>>>> +     The listening port for the local UDP tunneling sock.
> >>>>>>       , shared by all applications in the same net namespace.
> >>>>>>> +     UDP encapsulation will be disabled when it's set to 0.
> >>>>>>
> >>>>>>       "Note, however, that setting just this is not enough to actually
> >>>>>>       use it. ..."
> >>>>> When it's a client, yes,  but when it's a server, the encap_port can
> >>>>> be got from the incoming packet.
> >>>>>
> >>>>>>
> >>>>>>> +
> >>>>>>> +     Default: 9899
> >>>>>>> +
> >>>>>>> encap_port - INTEGER
> >>>>>>>     The default remote UDP encapsalution port.
> >>>>>>>     When UDP tunneling is enabled, this global value is used to set
> >>>>>>
> >>>>>> When is it enabled, which conditions are needed? Maybe it can be
> >>>>>> explained only in the one above.
> >>>>> Thanks!
> >>>>> pls check if this one will be better:
> >>>>
> >>>> It is. Verbose enough now, thx.
> >>>> (one other comment below)
> >>>>
> >>>>>
> >>>>> udp_port - INTEGER
> >>>>>
> >>>>> The listening port for the local UDP tunneling sock.
> >>>>>
> >>>>> This UDP sock is used for processing the incoming UDP-encapsulated
> >>>>> SCTP packets (from RFC6951), and shared by all applications in the
> >>>>> same net namespace. This UDP sock will be closed when the value is
> >>>>> set to 0.
> >>>>>
> >>>>> The value will also be used to set the src port of the UDP header
> >>>>> for the outgoing UDP-encapsulated SCTP packets. For the dest port,
> >>>>> please refer to 'encap_port' below.
> >>>>>
> >>>>> Default: 9899
> >>>>
> >>>> I'm now wondering if this is the right default. I mean, it is the
> >>>> standard port for it, yes, but at the same time, it means loading SCTP
> >>>> module will steal/use that UDP port on all net namespaces and can lead
> >>>> to conflicts with other apps. A more conservative approach here is to
> >>>> document the standard port, but set the default to 0 and require the
> >>>> user to set it in if it is expected to be used.
> >>>>
> >>>> Did FreeBSD enable it by default too?
> >>> No. The default is 0, which means that the encapsulation is turned off.
> >>> Setting this sysctl variable to a non-zero value enables the UDP tunneling
> >>> with the given port.
> >>
> >> Thanks Michael.
> >> Xin, then we should change this default value (and update the
> >> documentation above accordingly, to still have the standard port #
> >> readily available in there).
> > OK, I misunderstood the RFC.
> Does that RFC mandate that the feature is on by default? Can you point me to
> that text?
Not really.

I was thinking that by leaving it to 9899 by default users don't need to
know the port when want to use it, and yet I didn't want to add another
sysctl member. :D

>
> Best regards
> Michael
> >
> > I will remove the call to sctp_udp_sock_start/stop() from
> > sctp_ctrlsock_init/exit(), and set the udp_port as 0 by default.
> >
> > Thanks.
>
