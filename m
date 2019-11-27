Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD2B10C03C
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 23:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfK0Wdh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Nov 2019 17:33:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37162 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfK0Wdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 17:33:37 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 796A414AC47C1;
        Wed, 27 Nov 2019 14:33:36 -0800 (PST)
Date:   Wed, 27 Nov 2019 14:33:33 -0800 (PST)
Message-Id: <20191127.143333.1387731429786481895.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org, subashab@codeaurora.org,
        edumazet@google.com, linux-sctp@vger.kernel.org
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
        <20191127131407.GA377783@localhost.localdomain>
        <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Nov 2019 14:33:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Wed, 27 Nov 2019 12:50:39 -0800

> On Wed, Nov 27, 2019 at 5:14 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
>>
>> On Tue, Nov 26, 2019 at 04:13:13PM -0800, Maciej ¯enczykowski wrote:
>> > From: Maciej ¯enczykowski <maze@google.com>
>> >
>> > and associated inet_is_local_unbindable_port() helper function:
>> > use it to make explicitly binding to an unbindable port return
>> > -EPERM 'Operation not permitted'.
>> >
>> > Autobind doesn't honour this new sysctl since:
>> >   (a) you can simply set both if that's the behaviour you desire
>> >   (b) there could be a use for preventing explicit while allowing auto
>> >   (c) it's faster in the relatively critical path of doing port selection
>> >       during connect() to only check one bitmap instead of both
>> ...
>> > If we *know* that certain ports are simply unusable, then it's better
>> > nothing even gets the opportunity to try to use them.  This way we at
>> > least get a quick failure, instead of some sort of timeout (or possibly
>> > even corruption of the data stream of the non-kernel based use case).
>>
>> This is doable with SELinux today, no?
> 
> Perhaps, but SELinux isn't used by many distros, including the servers
> where I have nics that steal some ports.  It's also much much
> more difficult, requiring a policy, compilers, etc... and it gets even
> more complex if you need to dynamically modify the set of ports,
> which requires extra tools and runtime permissions.

I can see both sides of this argument, but anyways this is a new features and
thus net-next material.  It's nice to keep this discussion going, of course,
but if this trends in the positive you still need to resubmit this when
net-next opens back up.

Thanks.
