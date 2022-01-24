Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CEC49872C
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244441AbiAXRq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:46:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49206 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241189AbiAXRq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:46:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4863B811A5;
        Mon, 24 Jan 2022 17:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFA7C340E5;
        Mon, 24 Jan 2022 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643046385;
        bh=GiTNno6qWptbhmpqlvMLwvdzOouARoHcSXnF4o9E6ds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h5vAdzpgvvIfXC5hbZGfL5/tsy62LqIjDGcv+DiwLCIHprNE3la30cfDJFtwFJLug
         hefcvW7Q4KVfyc4a8bsU+lXEmdlfZ+J7g4imHRDlOtzIPRXsriZCwT4ZHu0gAQFPzc
         Cv1ashJxZUFsscxQP8KknjRSiAUbHYJ1Byjc4nMNjx/Js0ADjEP5AEGAV5y/uMaOjo
         1+WnE7fx+wJCOJ1bO8LRihvADmWZo4xf/Tli6DHENmlvfp+WcRTDAs7nbVFlQUYtmj
         U6rVMQk9DI0UbEOTeQvhkwmWmf5RM+fT101wE1VQ4loyMGjrGN9HzYG3YeUS5zRu/O
         qy6UUD3hOVA0w==
Date:   Mon, 24 Jan 2022 09:46:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Jeffrey Ji <jeffreyjilinux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH net-next] net-core: add InMacErrors counter
Message-ID: <20220124094623.7ca137e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CANn89iKGOw3LZ_2agxewuNLMLRX7TSnGYnf0T6NwC+1s4OB2bg@mail.gmail.com>
References: <20220122000301.1872828-1-jeffreyji@google.com>
        <20220121194057.17079951@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAMzD94QW5uK2wAZfYWu5J=2HqCcLrT=y7u6+0PgJvHBb0YTz_Q@mail.gmail.com>
        <20220124092924.0eb17027@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CANn89iKGOw3LZ_2agxewuNLMLRX7TSnGYnf0T6NwC+1s4OB2bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 09:39:22 -0800 Eric Dumazet wrote:
> On Mon, Jan 24, 2022 at 9:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > That much it's understood, but it's a trade off. This drop point
> > existed for 20 years, why do we need to consume extra memory now?  
> 
> Being able to tell after the facts, that such a drop reason had
> occured can help investigations.
> 
> nstat -a | grep InMac
> 
> Jeffrey, what about _also_ adding the kfree_skb_reason(), since this
> seems to also help ?

Yes, and please add a proper justification to the commit message, 
with real life examples of cases where this drop point has proven
to be the culprit. Right now the commit message says gives the example
of trafgen :(

