Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AFC488CCE
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 23:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbiAIWK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 17:10:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57032 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbiAIWK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 17:10:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7209F60EA8;
        Sun,  9 Jan 2022 22:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2CEC36AE3;
        Sun,  9 Jan 2022 22:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641766225;
        bh=IBra92ffqfZ+rHSrbea8fGiXiOScBbW8B0xwzylN6EQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WTLTKAN77RUy/pF4Y28Lkdsh9l7UhbM3pS+ddIi+Hyr1oMfmr0+XeNKa+0ZiXL5ir
         E1eKZFmu13+aOzDpwQHCMqCV+ypgO1BNjf7lXdXnxe44uEUDwDaNMP0kmcdNWOpikB
         pNh7OQ0PKm0OEZv3vSSh2UXY+wM0H+HmLql1W0006JmKLOq2QJBuHxdWKlYtj7I8Sm
         mQsHF1dIhsDuUdHRv7OzitQXSqZFvwJJQLKHIsti5g0cln6n5TAlnxnSjsLMjcQg5T
         LkeGiuxElEXS8XYQjTtFd5HFMRtlhwuyxHo1nQqnT82Usy3N9sGxL6FlP8VXZpap0l
         IrWjwuRJU4GPA==
Date:   Sun, 9 Jan 2022 14:10:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     "An, Tedd" <tedd.an@intel.com>, David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth 2022-01-07
Message-ID: <20220109141024.719698d2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CABBYNZJEZFwoQyAhXwpQsRB4c4jks4Yg9Sw9XLwPL7Pk3j_iMA@mail.gmail.com>
References: <20220107210942.3750887-1-luiz.dentz@gmail.com>
        <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CABBYNZJEZFwoQyAhXwpQsRB4c4jks4Yg9Sw9XLwPL7Pk3j_iMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 23:50:40 -0800 Luiz Augusto von Dentz wrote:
> > FWIW to see the new warnings check out net-next, do a allmodconfig build
> > with W=1 C=1, pull in your code, reset back to net-next (this will
> > "touch" all the files that need rebuilding), do a single threaded build
> > and save (2>file) the warnings, pull in your code, do another build  
> > (2>file2), diff the warnings from the build of just net-next and after  
> > pull.  
> 
> Hmm, we might as well do that in our CI then, but isn't that gonna
> cause all sorts of warnings in different subsystem/drivers to appear?
> I get that the diff should come clean if we do this 2 stage builds
> like you suggested but I'm not sure that is the best approach for CI,
> what do you think @An, Tedd? I'd guess we could keep our minimal
> config to keep building times in check but add a 2 stage build per
> patch so we can detect if they produce new warnings.

FWIW if you use patchwork you can try to massage our scripts to do the
building: https://github.com/kuba-moo/nipa That said our setup is far
from perfect as well.
