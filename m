Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD351554D1
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 10:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgBGJgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 04:36:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40402 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgBGJgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 04:36:10 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D006E15A17A01;
        Fri,  7 Feb 2020 01:36:08 -0800 (PST)
Date:   Fri, 07 Feb 2020 10:36:05 +0100 (CET)
Message-Id: <20200207.103605.2059545131045029032.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, maximmi@mellanox.com
Subject: Re: [PATCH net] ipv6/addrconf: fix potential NULL deref in
 inet6_set_link_af()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANn89iLb-OcdVCV+qNH7BEUjw3KtEPhhOM_XUyyJaWbhA5=dQw@mail.gmail.com>
References: <20200206.141300.1752448469848126511.davem@davemloft.net>
        <CANn89iLR8jR4L3ANiSBxuLoLFuUA5+SbJ06L3cW5-99i9=_yZQ@mail.gmail.com>
        <CANn89iLb-OcdVCV+qNH7BEUjw3KtEPhhOM_XUyyJaWbhA5=dQw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 01:36:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 6 Feb 2020 18:50:40 -0800

> If I understood the repro well enough, it seems it sets the device MTU
> to 1023, thus IPV6 is automatically disabled. (as mtu < 1280)

Now I understand.

Can you add some text about this to the commit message?  Just saying
that if the request also lowers the mtu below the ipv6 min mtu then we
will see the NULL idev.

Thanks.
