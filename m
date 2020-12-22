Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8913F2E0DCE
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 18:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgLVRWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 12:22:42 -0500
Received: from smtp7.emailarray.com ([65.39.216.66]:58280 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgLVRWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 12:22:42 -0500
Received: (qmail 4439 invoked by uid 89); 22 Dec 2020 17:22:01 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 22 Dec 2020 17:22:01 -0000
Date:   Tue, 22 Dec 2020 09:21:58 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH 01/12 v2 RFC] net: group skb_shinfo zerocopy related bits
 together.
Message-ID: <20201222172158.4b266ljlwtsyrvcj@bsd-mbp.dhcp.thefacebook.com>
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-2-jonathan.lemon@gmail.com>
 <CAF=yD-+i9o0_+2emOVkBw2JS5JyD+17zw-tJFdHiRyfHOz5LPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-+i9o0_+2emOVkBw2JS5JyD+17zw-tJFdHiRyfHOz5LPQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 09:43:15AM -0500, Willem de Bruijn wrote:
> On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > From: Jonathan Lemon <bsd@fb.com>
> >
> > In preparation for expanded zerocopy (TX and RX), move
> > the ZC related bits out of tx_flags into their own flag
> > word.
> >
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> I think it's better to expand tx_flags to a u16 and add the two new
> flags that you need.

Okay, but in that case, tx_flags is now wrong, since some of these flags
will also be checked on the rx path.


> That allows the additional 7 bits to be used for arbitrary flags, not
> stranding 8 bits exactly only for zerocopy features.
> 
> Moving around a few u8's in the same cacheline won't be a problem.

How about rearranging them to form 16 bits, and just calling it 'flags'?

 
> I also prefer not to rename flags that some of us are familiar with,
> if it's not needed.

Ack.
--
Jonathan
