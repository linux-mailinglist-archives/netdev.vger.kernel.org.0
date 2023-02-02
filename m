Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB97F6884BA
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjBBQol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 11:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjBBQok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:44:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5925CD26
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675356235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vLGgg4w5fjKTg3ZGMKi4b1YcgIW3xdSURLS2xtogCsU=;
        b=fRyMoD2q1Mop6NPALY9c2uKe5Rhk/1GfTW0af3vqH2DlIl99n5v0AwTtVD2M79Ya0xd6Xl
        xgkhTWTIeKcc82IivBmts1cIQKk137fAZZ3NcviiG6423HQ9jtsuJdPQnGmY1AxuoRaQqG
        b+Ltqdxv2kk8qgwWooAtyVirlRRQ7ac=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-402-NDG3uN0aMp-W2AWfsnSDuw-1; Thu, 02 Feb 2023 11:43:54 -0500
X-MC-Unique: NDG3uN0aMp-W2AWfsnSDuw-1
Received: by mail-qv1-f69.google.com with SMTP id n13-20020a056214008d00b0053a62a11f9fso1234940qvr.2
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 08:43:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLGgg4w5fjKTg3ZGMKi4b1YcgIW3xdSURLS2xtogCsU=;
        b=sbIHQ3Dxd+oVqqMtbc6+8N8wHPHfPT9hybZ8Ib1Lo2FJGEKwFhS5OBENO+VVQqIazp
         MINMQP32yMnNESX3gfIpvwiv8gqiMqcGTRjphZkMson0rJ8SjQ5hrGKdQeGDs/pzOkvq
         Ss1rL+cT+KEZgsBrS88kzCOVwYhlI1C0gFTG8t2DULvO7ZOiOYEqfyNs7+tuu88cn/Wy
         ij/qCgnQc6e8P49Ni3etd6gCRr+0+zivBjmNAVjS/wnB1kxB4QeNcQwuMuD6DDG0bCJr
         ZyiMsyLGAZtJllwWVPEprVJTIBpwYn3drspL+eas8vnysThr9fG7GTQXrjnyYoG3PKIt
         v9Eg==
X-Gm-Message-State: AO0yUKWlb42eIrU6xxkgdn/BxRvdfKcHDWmSq5bGq/Caqmbo3LfqnRR6
        oZgoB3htvN1CK0oLYpgGMzgT2XmLRjZt7jtR2lZ730sG0pWgL3E+W9ZBpvJItRLHnLSZhmWjC+5
        oRyn4Kag1vlp6zCOx
X-Received: by 2002:ac8:574f:0:b0:3b9:bd28:bb6c with SMTP id 15-20020ac8574f000000b003b9bd28bb6cmr9268595qtx.36.1675356233801;
        Thu, 02 Feb 2023 08:43:53 -0800 (PST)
X-Google-Smtp-Source: AK7set8npLnF2ztXqc6em28U8S/uZmIS8F+UsdTRM7+mksTrm4l1Z502h1Y4uJTTQH/IgeXd93Stng==
X-Received: by 2002:ac8:574f:0:b0:3b9:bd28:bb6c with SMTP id 15-20020ac8574f000000b003b9bd28bb6cmr9268562qtx.36.1675356233479;
        Thu, 02 Feb 2023 08:43:53 -0800 (PST)
Received: from debian (2a01cb058918ce0063dc0e119f3f7ce5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:63dc:e11:9f3f:7ce5])
        by smtp.gmail.com with ESMTPSA id n20-20020ac81e14000000b003b9a4a497a1sm6114637qtl.86.2023.02.02.08.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 08:43:53 -0800 (PST)
Date:   Thu, 2 Feb 2023 17:43:49 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     jchapman@katalix.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] l2tp: Avoid possible recursive deadlock in
 l2tp_tunnel_register()
Message-ID: <Y9voRRiiWK/V7WQD@debian>
References: <20230130154438.1373750-1-syoshida@redhat.com>
 <Y9f4eAhcJXhh0+c2@debian>
 <Y9qItT82LcJdJVlF@kernel-devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9qItT82LcJdJVlF@kernel-devel>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 12:43:49AM +0900, Shigeru Yoshida wrote:
> Hi Guillaume,
> 
> On Mon, Jan 30, 2023 at 06:03:52PM +0100, Guillaume Nault wrote:
> > On Tue, Jan 31, 2023 at 12:44:38AM +0900, Shigeru Yoshida wrote:
> > > This patch fixes the issue by returning error when a pppol2tp socket
> > > itself is passed.
> > 
> > Fixes: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
> > 
> > > Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> > > ---
> > >  net/l2tp/l2tp_ppp.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
> > > index db2e584c625e..88d1a339500b 100644
> > > --- a/net/l2tp/l2tp_ppp.c
> > > +++ b/net/l2tp/l2tp_ppp.c
> > > @@ -702,11 +702,14 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
> > >  			struct l2tp_tunnel_cfg tcfg = {
> > >  				.encap = L2TP_ENCAPTYPE_UDP,
> > >  			};
> > > +			int dummy = 0;
> > 
> > There's no need to initialise dummy here. This is just confusing.
> > We could even do without any extra variable and reuse error in
> > sockfd_lookup().
> > 
> > >  			/* Prevent l2tp_tunnel_register() from trying to set up
> > > -			 * a kernel socket.
> > > +			 * a kernel socket.  Also, prevent l2tp_tunnel_register()
> > > +			 * from trying to use pppol2tp socket itself.
> > >  			 */
> > > -			if (info.fd < 0) {
> > > +			if (info.fd < 0 ||
> > > +			    sock == sockfd_lookup(info.fd, &dummy)) {
> > >  				error = -EBADF;
> > >  				goto end;
> > >  			}
> > 
> > That should work, but the real problem is calling l2tp_tunnel_register()
> > under lock_sock(). We should instead get/create the tunnel before
> > locking the pppol2tp socket.
> 
> Thank you so much for your comment, and sorry for the late response.
> 
> Do you mean we can call l2tp_tunnel_register() without pppol2tp socket
> lock?

Yes. At this point, we're creating a new tunnel which is independant
from the pppol2tp socket.

> I've read the source code of pppol2tp_connect(), but I'm not
> sure why pppol2tp socket is locked at the beginning of this function.
> If we can call l2tp_tunnel_register() without pppol2tp socket lock, I
> think we can move lock_sock() after l2tp_tunnel_register().

Here are a few more details to be sure we're on the same page.

Locking the pppol2tp socket remains necessary since we access and
modify some of its protected attributes. But we can fetch or create
the tunnel before working on the socket. For this, the only information
we need to get from the socket is its netns. And calling sock_net(sk)
without holding the socket lock is fine because user space sockets
can't have their netns modified after initialisation.

So the code for retrieving or creating the tunnel can be moved before
the lock_sock(sk) call in pppol2tp_register(). Just make sure to adjust
the error path accordingly. Also, a helper function might help to make
the code more readable.

> Thanks,
> Shigeru
> 
> > 
> 

