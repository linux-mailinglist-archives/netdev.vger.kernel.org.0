Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD9142E613
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 03:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhJOBVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 21:21:12 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:38930 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbhJOBU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 21:20:59 -0400
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id BADF720181;
        Fri, 15 Oct 2021 09:18:45 +0800 (AWST)
Message-ID: <df5c3b8c0d0e8e2c97d4ab009c2f8faf1569c958.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v4 04/15] mctp: Add sockaddr_mctp to uapi
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-m68k@lists.linux-m68k.org
Date:   Fri, 15 Oct 2021 09:18:45 +0800
In-Reply-To: <20211014183456.GA8474@asgard.redhat.com>
References: <20210729022053.134453-1-jk@codeconstruct.com.au>
         <20210729022053.134453-5-jk@codeconstruct.com.au>
         <20211014183456.GA8474@asgard.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eugene,

Thanks for taking a look at these!

> > +typedef __u8                   mctp_eid_t;
> > +
> > +struct mctp_addr {
> > +       mctp_eid_t              s_addr;
> > +};
> > +
> >  struct sockaddr_mctp {
> > +       unsigned short int      smctp_family;
> 
> This gap makes the size of struct sockaddr_mctp 2 bytes less at least
> on m68k, are you fine with that?

Yep, that's OK from the protocol implementation side; this layout better
matches the "hierarchy" of the MCTP addressing. If we go for optimal
packing, the order of the members makes somewhat less sense. We could
add padding members, but I'm not sure that's worth it...

I noticed a few other protocol implementations doing similar things, so
assume it isn't an issue - it's all arch-specific ABI anyway, right?

> > +       int                     smctp_network;
> > +       struct mctp_addr        smctp_addr;
> > +       __u8                    smctp_type;
> > +       __u8                    smctp_tag;
> >  };

Cheers,


Jeremy


