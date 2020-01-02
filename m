Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9962712EB75
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 22:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgABVln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 16:41:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44770 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgABVln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 16:41:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7A921568B3D5;
        Thu,  2 Jan 2020 13:41:42 -0800 (PST)
Date:   Thu, 02 Jan 2020 13:41:38 -0800 (PST)
Message-Id: <20200102.134138.1618913847173804689.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577400698-4836-1-git-send-email-tom@herbertland.com>
References: <1577400698-4836-1-git-send-email-tom@herbertland.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 13:41:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Thu, 26 Dec 2019 14:51:29 -0800

> The fundamental rationale here is to make various TLVs, in particular
> Hop-by-Hop and Destination options, usable, robust, scalable, and
> extensible to support emerging functionality.

So, patch #1 is fine and it seems to structure the code to more easily
enable support for:

https://tools.ietf.org/html/draft-ietf-6man-icmp-limits-07

(I'll note in passing how frustrating it is that, based upon your
handling of things in that past, I know that I have to go out and
explicitly look for draft RFCs containing your name in order to figure
out what your overall long term agenda actually is.  You should be
stating these kinds of things in your commit messages)

But as for the rest of the patch series, what are these "emerging
functionalities" you are talking about?

I've heard some noises about people wanting to do some kind of "kerberos
for packets".  Or even just plain putting app + user ID information into
options.

Is that where this is going?  I have no idea, because you won't say.

And honestly, this stuff sounds so easy to misuse by governments and
other entities.  It could also be used to allow ISPs to limit users
in very undesirable and unfair ways.   And honestly, surveilance and
limiting are the most likely uses for such a facility.  I can't see
it legitimately being promoted as a "security" feature, really.

I think the whole TX socket option can wait.

And because of that the whole consolidation and cleanup of the option
handling code is untenable, because without a use case all it does is
make -stable backports insanely painful.
