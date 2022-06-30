Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DEB560DF5
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 02:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbiF3AYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 20:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiF3AYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 20:24:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0B02A27E;
        Wed, 29 Jun 2022 17:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23ABFB827BB;
        Thu, 30 Jun 2022 00:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1FBC34114;
        Thu, 30 Jun 2022 00:24:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RN1R7tzA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656548671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yhJeMlaJxX3LrfVXt5LEZDg6XeT5mqblmQOfOgg/+S0=;
        b=RN1R7tzA9LJmRLipddoaZl+SAjVveNjXi3uMxifQkM4+JW04JiAXddKuYswIKWd7I6YfzN
        bWiaN2IgFsUdz6qU9iV9W9jimu8OpM6ldOuliM8ZrOJ34+n0u8U/3IstNXi725jdktXGqq
        ojC33c7dUhSRMDZ4U1akIsKmYNrXwtw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f14ed555 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 30 Jun 2022 00:24:30 +0000 (UTC)
Date:   Thu, 30 Jun 2022 02:24:26 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     John Stultz <jstultz@google.com>
Cc:     Kalesh Singh <kaleshsingh@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, rcu <rcu@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, sultan@kerneltoast.com,
        android-kernel-team <android-kernel-team@google.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <YrztOqBBll66C2/n@zx2c4.com>
References: <20220629161527.GA24978@lst.de>
 <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <YryNQvWGVwCjJYmB@zx2c4.com>
 <Yryic4YG9X2/DJiX@google.com>
 <Yry6XvOGge2xKx/n@zx2c4.com>
 <CAC_TJve_Jk0+XD7VeSJVvJq4D9ZofnH69B4QZv2LPT4X3KNfeg@mail.gmail.com>
 <YrzaCRl9rwy9DgOC@zx2c4.com>
 <CANDhNCpRzzULaGmEGCbbJgVinA0pJJB-gOP9AY0Hy488n9ZStA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANDhNCpRzzULaGmEGCbbJgVinA0pJJB-gOP9AY0Hy488n9ZStA@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On Wed, Jun 29, 2022 at 04:52:05PM -0700, John Stultz wrote:
> Jason: Thanks for raising this issue and sharing this patch to avoid
> breakage! I really appreciate it.
> 
> My only concern with this change introducting a userspace knob set at
> runtime, vs a (hopefully more specific than _ANDROID) kernel config is

I'd also be okay with a compile-time knob. The details make no
difference to me, so long as there's just *something* there.

> that it's not exactly clear what the flag really means (which is the
> same issue CONFIG_ANDROID has). And more problematic, with this it
> would be an ABI.
> 
> So for this we probably need to have a very clear description of what
> userland is telling the kernel. Because I'm sure userlands behavior
> will drift and shift and we'll end up litigating what kind of behavior
> is really userspace_autosleeping vs userspace_sortof_autosleeping. :)

I guess what I have in mind is the answer to these being "yes":
- "Is it very common to be asleep for only 2 seconds before being woken?"
- "Is it very common to be awake for only 2 seconds before sleeping?"

I think it'd be easiest to have a knob somewhere (compiletime,
runtime, wherever) that describes a device that exhibits those
properties. Then wireguard and other things will make a decision on how
to handle the crypto during relevant events.

> Alternatively, maybe we should switch it to describe what behavior
> change we are wanting the kernel take (instead of it hinting to the
> kernel what to expect from userland's behavior)? That way it might be
> more specific.

As a general rule, I don't expose knobs like that in wireguard /itself/,
but wireguard has no problem with adapting to whatever machine properties
it finds itself on. And besides, this *is* a very definite device
property, something really particular and peculiar about the machine
the kernel is running on. It's a concrete thing that the kernel should
know about. So let's go with your "very clear description idea", above,
instead.

So taken together, I guess there are two approaches to this:

1) Introduce a simple CONFIG_PM_CONTINUOUS_AUTOSLEEPING Kconfig thing
   with lots of discouraging help text.

2) Go with the /sys/power tunable and bikeshed the naming of that a bit
   to get it to something that reflects this better, and document it as
   being undesirable except for Android phones.

It seems like in both cases, the key will be getting the naming right.

Jason
