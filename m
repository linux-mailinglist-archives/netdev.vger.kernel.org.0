Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9CA563B0E
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiGAUWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiGAUWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:22:41 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CB84D174;
        Fri,  1 Jul 2022 13:22:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id BDCD936D;
        Fri,  1 Jul 2022 20:22:38 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net BDCD936D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1656706959; bh=dxet9HAczfcZ9vu/1oL1hu5S6lHOaJx1MYQzpzQnE3w=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=c/wZEaG8r9bEzMb/9Yed5GTIwTIqapPop1mA95KPr3rBUovZudh3MzbBq4CCf2w+N
         O5wA2ppfkxYCkT2qYzn/jocPg/WF6Un9rseV62tBWBuL8our/CBG1rvsHTx82AKtaK
         PadBeZObcRmaPrgOdyJXbkz9sR08gVwxb40AApbU05jfYCYZdziljL8MbgOsH9rdWj
         h8Z5rZuitWMoBgGDvgE+XvHLus3OHETunxvmSJA+s7qxDSlCCuQ0kQcBBdP75BPdWR
         ZYJRDJhoHU1mFDZqSclmpR1UPyNV2ue6xVZftBJdFvgLnyFLshgAKX8+i1NVJWFlCj
         /8mq64R3WoXEQ==
From:   Jonathan Corbet <corbet@lwn.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        John Stultz <jstultz@google.com>
Cc:     Kalesh Singh <kaleshsingh@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?utf-8?B?SGrDuG5u?= =?utf-8?B?ZXbDpWc=?= 
        <arve@android.com>, Todd Kjos <tkjos@android.com>,
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
In-Reply-To: <YrztOqBBll66C2/n@zx2c4.com>
References: <20220629161527.GA24978@lst.de> <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de> <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <YryNQvWGVwCjJYmB@zx2c4.com> <Yryic4YG9X2/DJiX@google.com>
 <Yry6XvOGge2xKx/n@zx2c4.com>
 <CAC_TJve_Jk0+XD7VeSJVvJq4D9ZofnH69B4QZv2LPT4X3KNfeg@mail.gmail.com>
 <YrzaCRl9rwy9DgOC@zx2c4.com>
 <CANDhNCpRzzULaGmEGCbbJgVinA0pJJB-gOP9AY0Hy488n9ZStA@mail.gmail.com>
 <YrztOqBBll66C2/n@zx2c4.com>
Date:   Fri, 01 Jul 2022 14:22:38 -0600
Message-ID: <87a69slh0x.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> I guess what I have in mind is the answer to these being "yes":
> - "Is it very common to be asleep for only 2 seconds before being woken?"
> - "Is it very common to be awake for only 2 seconds before sleeping?"
>
> I think it'd be easiest to have a knob somewhere (compiletime,
> runtime, wherever) that describes a device that exhibits those
> properties. Then wireguard and other things will make a decision on how
> to handle the crypto during relevant events.

So please forgive the noise from the peanut gallery, but I do find
myself wondering...do you really need a knob for this?  The kernel
itself can observe how often (and for how long) the system is suspended,
and might well be able to do the right thing without explicit input from
user space.  If it works it would eliminate a potential configuration
problem and also perhaps respond correctly to changing workloads.

For example, rather than testing a knob, avoid resetting keys on resume
if the suspend time is less than (say) 30s?

Educate me on what I'm missing here, please :)

Thanks,

jon
