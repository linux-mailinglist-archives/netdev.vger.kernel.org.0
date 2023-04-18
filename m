Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D0E6E5D12
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjDRJLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 05:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjDRJLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 05:11:51 -0400
Received: from sonata.ens-lyon.org (sonata.ens-lyon.org [140.77.166.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF6B10E0;
        Tue, 18 Apr 2023 02:11:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by sonata.ens-lyon.org (Postfix) with ESMTP id 175AE20180;
        Tue, 18 Apr 2023 11:11:49 +0200 (CEST)
Received: from sonata.ens-lyon.org ([127.0.0.1])
        by localhost (sonata.ens-lyon.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bKQ3-A0V8pgX; Tue, 18 Apr 2023 11:11:48 +0200 (CEST)
Received: from begin.home (apoitiers-658-1-118-253.w92-162.abo.wanadoo.fr [92.162.65.253])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by sonata.ens-lyon.org (Postfix) with ESMTPSA id B380620177;
        Tue, 18 Apr 2023 11:11:48 +0200 (CEST)
Received: from samy by begin.home with local (Exim 4.96)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1pohNM-00BMWM-0m;
        Tue, 18 Apr 2023 11:11:48 +0200
Date:   Tue, 18 Apr 2023 11:11:48 +0200
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPPoL2TP: Add more code snippets
Message-ID: <20230418091148.hh3b52zceacduex6@begin>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Guillaume Nault <gnault@redhat.com>,
        James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230416220704.xqk4q6uwjbujnqpv@begin>
 <ZD5V+z+cBaXvPbQa@debian>
 <20230418085323.h6xij7w6d2o4kxxi@begin>
 <ZD5dqwPblo4FOex1@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD5dqwPblo4FOex1@debian>
Organization: I am not organized
User-Agent: NeoMutt/20170609 (1.8.3)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume Nault, le mar. 18 avril 2023 11:06:51 +0200, a ecrit:
> On Tue, Apr 18, 2023 at 10:53:23AM +0200, Samuel Thibault wrote:
> > Guillaume Nault, le mar. 18 avril 2023 10:34:03 +0200, a ecrit:
> > > On Mon, Apr 17, 2023 at 12:07:04AM +0200, Samuel Thibault wrote:
> > > >          sax.sa_family = AF_PPPOX;
> > > >          sax.sa_protocol = PX_PROTO_OL2TP;
> > > >          sax.pppol2tp.fd = tunnel_fd;
> > > > @@ -406,12 +407,64 @@ Sample userspace code:
> > > >          /* session_fd is the fd of the session's PPPoL2TP socket.
> > > >           * tunnel_fd is the fd of the tunnel UDP / L2TPIP socket.
> > > >           */
> > > > -        fd = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
> > > > -        if (fd < 0 ) {
> > > > +        ret = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
> > > > +        if (ret < 0 ) {
> > > 
> > > Now you also need to close session_fd.
> > 
> > ? No, we need it for PPPIOCGCHAN, and also PPPIOCGL2TPSTATS.
> 
> connect() failed. You can't do anything with this socket.

Ah, you were talking about the failure case, ok.

> > > > +The ppp<ifunit> interface can then be configured as usual with SIOCSIFMTU,
> > > > +SIOCSIFADDR, SIOCSIFDSTADDR, SIOCSIFNETMASK, and activated by setting IFF_UP
> > > > +with SIOCSIFFLAGS
> > > > +
> > > > +  - Tunnel switching is supported by bridging channels::
> > > 
> > > This is a PPP feature not an L2TP one.
> > > 
> > > PPPIOCBRIDGECHAN's description
> > > belongs to Documentation/networking/ppp_generic.rst, where it's already
> > > documented.
> > 
> > Yes but that's hard to find out when you're looking from the L2TP end.
> 
> That's why I proposed linking to ppp_generic.rst.

Yes, but it's still not obvious to L2TP people that it's a ppp channel
that you have to bridge. Really, having that 20-line snippet available
would have saved me some head-scratching time.

Samuel
