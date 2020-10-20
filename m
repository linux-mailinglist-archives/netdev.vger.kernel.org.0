Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04DA2937B4
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 11:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391025AbgJTJMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 05:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390974AbgJTJMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 05:12:19 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB1EC061755;
        Tue, 20 Oct 2020 02:12:19 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id n15so1206843wrq.2;
        Tue, 20 Oct 2020 02:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=92SLYfdJI297isdHxutj998j2GxP03O4p2KdaKj+HWM=;
        b=gnlyuInUfaQEbtzn6BFjlC4qzQX4a3qkIab7r+J2Qn/e07w/3jHIgpLTbQTOykmzOJ
         ueBsXeNlVYa+fjKyz2ovILJ/3Z5ZhLLNSywubWU2vvywwPXMEWkJnvLZxRKlEEwipyJp
         mxJiEcaOre+TZZLryPTNRCtS2FzM7Fave/J0k08+MR4D33AZvsPrFZ1PeHKK6/I+YzvH
         3CQb5BKF/bMqbGXJE4MUdqHLaHLgZP5rDDJ1Qy6ULw6TauhBYvM38MDClJp8pTV+2/J5
         3dW2bJaSm/3mWubiz4sLM4o8+dNnVQGgXTxa5KGmtjdsYdcT49frwwR7jzdp8omeGgDx
         VtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=92SLYfdJI297isdHxutj998j2GxP03O4p2KdaKj+HWM=;
        b=RimhKdYK/Hxyh/nArHTzw6Sj/mb50GfH1JLDMaVptFdSADjrgFSyeBrR0KC27sFnS7
         SZmwiNSBEV2MqxdmZR/9weeFimAXp0eGBGWXngZhxjH3L0NcrWv9gZL0phWxA8fIaSv/
         159JiQzGLZz9z80R2aJwEWRit6vOisTEQsGXAops7ghZ+7EzTX108nyTT2LkyDoM7yfP
         /IT/PiKhnwhFUcFTWwu0gsS1G0P12NW4aHwYIkWFyH2V7+Mvdbi4fZpFjmYbpi+4rlv6
         qXZNlFYndaExjHdkLuHyXvwB8VzZla12pbDyNEj9386Mn8oxmiASZX8HSYuip5E6VGIU
         xbsg==
X-Gm-Message-State: AOAM531tCC2drOkzzj/QgJKYwML9Kdf5knodKCQGzPx0iOIODuKwUBgl
        xlKo2zroOP/oG//qqpl47w2O7pdSjjB6fK45/10PC+VpkCA=
X-Google-Smtp-Source: ABdhPJxyEVYgVwYwghGgNXg65Uu8Y+703SeqBprdWXx5g433etT4RmmhlCjLgOdn1/TULoLP9sY6oX+HaxiaEJIEy1c=
X-Received: by 2002:a5d:5748:: with SMTP id q8mr2296520wrw.299.1603185137830;
 Tue, 20 Oct 2020 02:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1603110316.git.lucien.xin@gmail.com> <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
 <20201019221545.GD11030@localhost.localdomain>
In-Reply-To: <20201019221545.GD11030@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 20 Oct 2020 17:12:06 +0800
Message-ID: <CADvbK_ezWXMxpKkt3kxbXhcgu73PTJ1zpChb_sCgDu38xcROtA@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 6:15 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Oct 19, 2020 at 08:25:33PM +0800, Xin Long wrote:
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -2640,6 +2640,12 @@ addr_scope_policy - INTEGER
> >
> >       Default: 1
> >
> > +udp_port - INTEGER
>
> Need to be more verbose here, and also mention the RFC.
>
> > +     The listening port for the local UDP tunneling sock.
>         , shared by all applications in the same net namespace.
> > +     UDP encapsulation will be disabled when it's set to 0.
>
>         "Note, however, that setting just this is not enough to actually
>         use it. ..."
When it's a client, yes,  but when it's a server, the encap_port can
be got from the incoming packet.

>
> > +
> > +     Default: 9899
> > +
> >  encap_port - INTEGER
> >       The default remote UDP encapsalution port.
> >       When UDP tunneling is enabled, this global value is used to set
>
> When is it enabled, which conditions are needed? Maybe it can be
> explained only in the one above.
Thanks!
pls check if this one will be better:

udp_port - INTEGER

The listening port for the local UDP tunneling sock.

This UDP sock is used for processing the incoming UDP-encapsulated
SCTP packets (from RFC6951), and shared by all applications in the
same net namespace. This UDP sock will be closed when the value is
set to 0.

The value will also be used to set the src port of the UDP header
for the outgoing UDP-encapsulated SCTP packets. For the dest port,
please refer to 'encap_port' below.

Default: 9899

encap_port - INTEGER

The default remote UDP encapsulation port.

This value is used to set the dest port of the UDP header for the
outgoing UDP-encapsulated SCTP packets by default. Users can also
change the value for each sock/asoc/transport by using setsockopt.
For further information, please refer to RFC6951.

Note that when connecting to a remote server, the client should set
this to the port that the UDP tunneling sock on the peer server is
listening to and the local UDP tunneling sock on the client also
must be started. On the server, it would get the encap_port from
the incoming packet's source port.

Default: 0
