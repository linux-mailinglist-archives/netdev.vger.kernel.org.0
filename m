Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBA998A10
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbfHVDyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:54:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbfHVDyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:54:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 89ED61522471F;
        Wed, 21 Aug 2019 20:54:54 -0700 (PDT)
Date:   Wed, 21 Aug 2019 20:54:54 -0700 (PDT)
Message-Id: <20190821.205454.2103510420957943248.davem@davemloft.net>
To:     paul@paul-moore.com
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHC9VhRLexftb5mK8_izVQkv9w46m=aPukws2d2m+yrMvHUF_g@mail.gmail.com>
References: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
        <20190821.155013.1723892743521935274.davem@davemloft.net>
        <CAHC9VhRLexftb5mK8_izVQkv9w46m=aPukws2d2m+yrMvHUF_g@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 20:54:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>
Date: Wed, 21 Aug 2019 23:27:03 -0400

> On Wed, Aug 21, 2019 at 6:50 PM David Miller <davem@davemloft.net> wrote:
>> From: Paul Moore <paul@paul-moore.com>
>> Date: Wed, 21 Aug 2019 18:00:09 -0400
>>
>> > I was just made aware of the skb extension work, and it looks very
>> > appealing from a LSM perspective.  As some of you probably remember,
>> > we (the LSM folks) have wanted a proper security blob in the skb for
>> > quite some time, but netdev has been resistant to this idea thus far.
>> >
>> > If I were to propose a patchset to add a SKB_EXT_SECURITY skb
>> > extension (a single extension ID to be shared among the different
>> > LSMs), would that be something that netdev would consider merging, or
>> > is there still a philosophical objection to things like this?
>>
>> Unlike it's main intended user (MPTCP), it sounds like LSM's would use
>> this in a way such that it would be enabled on most systems all the
>> time.
>>
>> That really defeats the whole purpose of making it dynamic. :-/
> 
> I would be okay with only adding a skb extension when we needed it,
> which I'm currently thinking would only be when we had labeled
> networking actually configured at runtime and not just built into the
> kernel.  In SELinux we do something similar today when it comes to our
> per-packet access controls; if labeled networking is not configured we
> bail out of the LSM hooks early to improve performance (we would just
> be comparing unlabeled_t to unlabeled_t anyway).  I think the other
> LSMs would be okay with this usage as well.
> 
> While a number of distros due enable some form of LSM and the labeled
> networking bits at build time, vary few (if any?) provide a default
> configuration so I would expect no additional overhead in the common
> case.
> 
> Would that be acceptable?

I honestly don't know, I kinda feared that once the SKB extension went in
people would start dumping things there and that's exactly what's happening.
I just so happened to be reviewing:

	https://patchwork.ozlabs.org/patch/1150091/

while you were writing this email.

It's rediculous, the vultures are out.
