Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF6B3E91E3
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 14:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhHKMtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 08:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhHKMtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 08:49:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C58976056C;
        Wed, 11 Aug 2021 12:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628686159;
        bh=uVK2r72Kdo771r0eBjABRDmj6TjTuVDRF7ffm6kFzkw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y+w3d+FndGpxn3c0N0AgGHVo4U4EspeAH9f8jFW2EHsOLOu15zaLUh+jvY4gZ9wJA
         jiOVDbjH8dLklPkkFM0jGOLuRgHasdjzXCJOpBLKH2eYia29Ut3itBqksJYFvjAyz+
         2jpMWKW4duIQD18KUL64dkgmjb+U5E2bu6uytjJulBCM4fVOp+t8iQXKSXNolgaTvV
         WlJCXwlTAyzjysxfcl12f66sjYF4QvuS/2tZ2v8POHqIHJbm2yDXczlmFr8Un2Jn3j
         NWThV09P060VUNkTF9119P88siLHm58TFqSoQDa9F39TfMFBEKaBzhRJ0bxWwMN9Mo
         1srC7s53Xmewg==
Date:   Wed, 11 Aug 2021 05:49:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        leon@kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] bonding: combine netlink and console
 error messages
Message-ID: <20210811054917.722bd988@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d5e1aada694465fd62f57695e264259815e60746.camel@perches.com>
References: <cover.1628650079.git.jtoppins@redhat.com>
        <e6b78ce8f5904a5411a809cf4205d745f8af98cb.1628650079.git.jtoppins@redhat.com>
        <d5e1aada694465fd62f57695e264259815e60746.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 20:27:01 -0700 Joe Perches wrote:
> > +#define BOND_NL_ERR(bond_dev, extack, errmsg) do {		\
> > +	if (extack)						\
> > +		NL_SET_ERR_MSG(extack, errmsg);			\
> > +	else							\
> > +		netdev_err(bond_dev, "Error: %s\n", errmsg);	\
> > +} while (0)
> > +
> > +#define SLAVE_NL_ERR(bond_dev, slave_dev, extack, errmsg) do {		\
> > +	if (extack)							\
> > +		NL_SET_ERR_MSG(extack, errmsg);				\
> > +	else								\
> > +		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
> > +} while (0)  
> 
> Ideally both of these would be static functions and not macros.

That may break our ability for NL_SET_ERR_MSG to place strings 
back in a static buffer, no?
