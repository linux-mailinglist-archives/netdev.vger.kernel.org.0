Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29555458A7B
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 09:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbhKVI0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 03:26:21 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:55002 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238579AbhKVI0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 03:26:20 -0500
Received: from rico.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 7A5D220164;
        Mon, 22 Nov 2021 16:23:11 +0800 (AWST)
Message-ID: <9652c9dd6b6238922f45ee71cf341cac88449b98.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next] mctp: Add MCTP-over-serial transport binding
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>
Date:   Mon, 22 Nov 2021 16:23:10 +0800
In-Reply-To: <YZtHOfdn4HQdF3LD@kroah.com>
References: <20211122042817.2988517-1-jk@codeconstruct.com.au>
         <YZs1p+lkKO+194zN@kroah.com>
         <123a5491b8485f42c9279d397cdeb6358c610f6c.camel@codeconstruct.com.au>
         <YZtHOfdn4HQdF3LD@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

> ida_destroy() will not be a no-op if you have allocated some things
> in the past.  It should always be called when your module is removed.
> 
> Or at least that is how it used to be, if this has changed in the
> past year, then I am mistaken here.

I was going by this bit of the comment on ida_destroy:

   * Calling this function frees all IDs and releases all resources used
   * by an IDA.  When this call returns, the IDA is empty and can be reused
   * or freed.  If the IDA is already empty, there is no need to call this
   * function.

[From a documentation improvement in 50d97d50715]

Looking at ida_destroy, it's iterating the xarray and freeing all !value
entries. ida_free will free a (allocated) value entry once all bits are
clear, so the comment looks correct to me - there's nothing left to free
if the ida is empty.

However, I'm definitely no ida/idr/xarray expert! Happy to be corrected
here - and I'll send a patch to clarify that comment too, if so.

Cheers,


Jeremy

