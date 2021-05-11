Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D986937A673
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhEKMVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:21:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34934 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231429AbhEKMVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nYiN4ObFpoOGO3znd/xq12Uh2Pvor93u/J+O6JGegJU=; b=q+i1b4YntA7o596ER5FSfmWSlZ
        gM1rFD8lBgf9AASJ3eJ1V2imEF7sxmDFbJ5GEe30FgXox1W4MllCLR22Z6WcTRT503aPF+QBXXhsS
        ccKm/YIQBrnDj3CPoOtpPcHeHpUbolyb4VDlO8lqdhTUENf9wfN05KYIzpmbgsdHA+6Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRN9-003jZu-87; Tue, 11 May 2021 14:20:23 +0200
Date:   Tue, 11 May 2021 14:20:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] forcedeth: Delete a redundant condition branch
Message-ID: <YJp2hwGLeYcOt+gu@lunn.ch>
References: <20210510135656.3960-1-thunder.leizhen@huawei.com>
 <YJmQufHgq6WlRz4Q@lunn.ch>
 <20f15fbc-347f-b76d-24f4-da08f76fd603@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20f15fbc-347f-b76d-24f4-da08f76fd603@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If it must exist, it should be in the form of comments. Otherwise, the
> intuition is that there was a mistake in writing this code.

I agree that it could look like there is an error in the code. But
that is where the bot stops and the human takes over. When you read
the code, and understand what it does, you can see there is no
error. You should also look at the history. This is old code, if it
was broken, it would of been fixed by now, since the hulk bot has been
around for quiet a while.

For me, the optimization argument is not correct. We have a lot of
code, in macros for example, where we assume the compiler will
optimize it. Think about all the

if (IS_ENABLED(CONFIG_FOO))
	{}

code. The code you are suggesting to change is also on the very slow
path. We want to optimize it for human understandability, not code
generation. It is much more important humans understand it, than the
few microsecods it takes the compiler to optimize it.

    Andrew
