Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355F23DCC1A
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 16:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhHAObp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 10:31:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55996 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231791AbhHAObn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Aug 2021 10:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=eTgx0KE33KIk1fuzL+/3WuloQZ2Q4QKhpop+vJYtbTw=; b=GG
        NkfJYBfs7e2xCeZ+/F1LNEgHCosMiaj+D5CN3jppOqnqAulOvSov42Vs28M+jvv7ODzm8XO4BYDRk
        +Qpo/M7EN1oP96x7Kan/VqbgqSgiEcDeuRB31bE6JsKUR/Ubb+INnMpVbewXHdkardYf3DdRJ4QnT
        6Uoqd6Lsw0TayoE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mACV3-00Fitf-WF; Sun, 01 Aug 2021 16:31:34 +0200
Date:   Sun, 1 Aug 2021 16:31:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to find out name or id of newly created interface
Message-ID: <YQawRZL6aeBkuDSZ@lunn.ch>
References: <20210731203054.72mw3rbgcjuqbf4j@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210731203054.72mw3rbgcjuqbf4j@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 10:30:54PM +0200, Pali Rohár wrote:
> Hello!
> 
> Via rtnetlink API (RTM_NEWLINK/NLM_F_CREATE) it is possible to create a
> new network interface without specifying neither interface name nor id.
> This will let kernel to choose some interface name which does not
> conflicts with any already existing network interface. So seems like
> ideal way if I do not care about interface names. But at some stage it
> is needed to "configure" interface and for this action it is required to
> know interface id or name (as some ioctls use interface name instead of
> id).

Hi Pali

Looking at __rtnl_newlink() it looks like you can specify the
dev->ifindex when you request the create. So you can leave the kernel
to pick the name, but pick the if_index from user space.

   Andrew
