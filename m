Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FF0538DF2
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 11:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245121AbiEaJo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 05:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiEaJoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 05:44:25 -0400
Received: from sym2.noone.org (sym.noone.org [178.63.92.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAF693463
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:44:24 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4LC6n33MkCzvjhV; Tue, 31 May 2022 11:44:23 +0200 (CEST)
Date:   Tue, 31 May 2022 11:44:23 +0200
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] socket: Use __u8 instead of u8 in uapi socket.h
Message-ID: <20220531094423.eylqehirkrxgqxbz@distanz.ch>
References: <20220525085126.29977-1-tklauser@distanz.ch>
 <20220530081450.16591-1-tklauser@distanz.ch>
 <2d48c65078ff424398588237e5fe1279@AcuMS.aculab.com>
 <7e77647a5c3c538ae6beb668083e1b6090dccb62.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e77647a5c3c538ae6beb668083e1b6090dccb62.camel@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-31 at 11:24:46 +0200, Paolo Abeni <pabeni@redhat.com> wrote:
> On Mon, 2022-05-30 at 08:20 +0000, David Laight wrote:
> > From: Tobias Klauser
> > > Sent: 30 May 2022 09:15
> > > 
> > > Use the uapi variant of the u8 type.
> > > 
> > > Fixes: 26859240e4ee ("txhash: Add socket option to control TX hash rethink behavior")
> > > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> > > ---
> > > v2: add missing <linux/types.h> include as reported by kernel test robot
> > > 
> > >  include/uapi/linux/socket.h | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
> > > index 51d6bb2f6765..62a32040ad4f 100644
> > > --- a/include/uapi/linux/socket.h
> > > +++ b/include/uapi/linux/socket.h
> > > @@ -2,6 +2,8 @@
> > >  #ifndef _UAPI_LINUX_SOCKET_H
> > >  #define _UAPI_LINUX_SOCKET_H
> > > 
> > > +#include <linux/types.h>
> > > +
> > >  /*
> > >   * Desired design of maximum size and alignment (see RFC2553)
> > >   */
> > > @@ -31,7 +33,7 @@ struct __kernel_sockaddr_storage {
> > > 
> > >  #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
> > > 
> > > -#define SOCK_TXREHASH_DEFAULT	((u8)-1)
> > > +#define SOCK_TXREHASH_DEFAULT	((__u8)-1)
> > 
> > I can't help feeling that 255u (or 0xffu) would be a better
> > way to describe that value.
> 
> Even plain '255' would do. Additionally, any of the above will avoid
> the additional header dependency.

Thanks, I've sent v3 changing it to plain '255'.
