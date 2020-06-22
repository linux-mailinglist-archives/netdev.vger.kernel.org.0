Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE7A20410D
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 22:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgFVUHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 16:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728539AbgFVUHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 16:07:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C017C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 13:07:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2319B1295D5F8;
        Mon, 22 Jun 2020 13:07:38 -0700 (PDT)
Date:   Mon, 22 Jun 2020 13:07:37 -0700 (PDT)
Message-Id: <20200622.130737.763192936886895186.davem@davemloft.net>
To:     colton.w.lewis@protonmail.com
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] net: phylink: correct trivial kernel-doc
 inconsistencies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3315816.iIbC2pHGDl@laptop.coltonlewis.name>
References: <20200621154248.GB338481@lunn.ch>
        <20200621155345.GV1551@shell.armlinux.org.uk>
        <3315816.iIbC2pHGDl@laptop.coltonlewis.name>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 13:07:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colton Lewis <colton.w.lewis@protonmail.com>
Date: Sun, 21 Jun 2020 23:02:30 +0000

> On Sunday, June 21, 2020 10:53:45 AM CDT Russell King - ARM Linux admin wrote:
>> > ---
>> >   */
>> >  struct phylink_config {
>> >  	struct device *dev;
>> > @@ -331,7 +333,7 @@ void pcs_get_state(struct phylink_config *config,
>> >   *
>> >   * For most 10GBASE-R, there is no advertisement.
>> >   */
>> > -int (*pcs_config)(struct phylink_config *config, unsigned int mode,
>> > +int *pcs_config(struct phylink_config *config, unsigned int mode,
>> >  		  phy_interface_t interface, const unsigned long *advertising);
>> 
>> *Definitely* a NAK on this and two changes below.  You're changing the
>> function signature to be incorrect.  If the documentation can't parse
>> a legitimate C function pointer declaration and allow it to be
>> documented, then that's a problem with the documentation's parsing of
>> C code, rather than a problem with the C code itself.
> 
> I realize this changes the signature, but this declaration is not compiled. It is under an #if 0 with a comment stating it exists for kernel-doc purposes only. The *real* function pointer declaration exists in struct phylink_pcs_ops.
> 
> Given the declaration is there exclusively for documentation, it makes sense to change it so the documentation system can parse it.

I agree with Russell, if the C code can't be accurately represented you
make things worse for people trying to actually _use_ the documentation.

Can't you escape the parenthesis or something like that?

If you can't make it look accurate, leave it alone.
