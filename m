Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6473DDAC9
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbhHBOVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:21:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57354 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235571AbhHBOVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4qIOHS8eFAH0iaUUz0QVNzsJO9b3q6SnKsk8d8XgdyA=; b=5UTHLExSQte7RGSE0ejymRIz3W
        HaU1WpCl7D9VncXelbUXNpiG0o8G3lbgcc2hX7NX+1BlyFoL5dnil4LqjtKVog14hNTE9HIW5wYgw
        TMSiR4Mof3HKr4dIvN7w8vQ/aXQB/h2aPYsvS0Sj5FyPlJH+U7e/KV2wRe/UvQ5Lhoqk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAYoT-00FprS-Fh; Mon, 02 Aug 2021 16:21:05 +0200
Date:   Mon, 2 Aug 2021 16:21:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to find out name or id of newly created interface
Message-ID: <YQf/UVmFEF2ihyKY@lunn.ch>
References: <20210731203054.72mw3rbgcjuqbf4j@pali>
 <YQawRZL6aeBkuDSZ@lunn.ch>
 <20210801143840.j6bfvt3zsfb2x7q5@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210801143840.j6bfvt3zsfb2x7q5@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hello! This has additional issue that I have to choose some free ifindex
> number and it introduce another race condition that other userspace
> process may choose same ifindex number. So create request in this case
> fails if other userspace process is faster... So it has same race
> condition as specifying interface name.

O.K. if you don't want to deal with retries, you are going to have to
modify the return value. The nice thing is, its netlink. So you can
add additional attributes, and not break backwards compatibility. User
space should ignore all attributes it does not expect.

But i suspect the architecture of the code is not going to make it
easy.

	Andrew
