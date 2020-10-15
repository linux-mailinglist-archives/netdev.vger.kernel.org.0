Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598A128FB92
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 01:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbgJOXQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 19:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732872AbgJOXQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 19:16:34 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F124C061755;
        Thu, 15 Oct 2020 16:16:34 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602803789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjUedKRxgvfYMPV7hCjkN8m3z31Iq7E51pJ7H44Pj0s=;
        b=jvaMb2FWyysyAuM4zwgrUWmKAVzz7LFxYs7aZtkIAlQQCQGaTQS0PCSrnzcO0oq1dWIMre
        mUv+XOu6496lnJNyndNSQ0StMFzIZmP8taw7FDSVTVGS6RMY6zZ84Oy1uA8s8hQu4eTOw1
        knbdQh843QNYc6VhlKmrnA01OPH4Qnv3iAY68r9xXihpj+q8yp5UMqSXLQjTk3EY192fFT
        NiKpiAgSMJCCd63F4TwN0YwU6/pnju8BTO4Ub1BLZ7IQPMt79HZetzjLCOFfjgivcZP9FA
        QLrUBCsgTkuG3R+c/eJrIGPZp6tkJDoQipMoKsQV9tTC26eDpZ2WPNWpYCU60g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602803789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjUedKRxgvfYMPV7hCjkN8m3z31Iq7E51pJ7H44Pj0s=;
        b=CBacvdxbYq+BPIvqZQNSV/dhhCJfkiEGVIkiHUx6YaniVlCBoHE53RNIpexQpmnYWZS7eQ
        zUjRm7JEMQaPEiDg==
To:     "Meisinger\, Andreas" <andreas.meisinger@siemens.com>,
        "vinicius.gomes\@intel.com" <vinicius.gomes@intel.com>,
        "Geva\, Erez" <erez.geva.ext@siemens.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "jiri\@resnulli.us" <jiri@resnulli.us>,
        "avagin\@gmail.com" <avagin@gmail.com>,
        "0x7f454c46\@gmail.com" <0x7f454c46@gmail.com>,
        "ebiederm\@xmission.com" <ebiederm@xmission.com>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "john.stultz\@linaro.org" <john.stultz@linaro.org>,
        "mkubecek\@suse.cz" <mkubecek@suse.cz>,
        "oleg\@redhat.com" <oleg@redhat.com>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "richardcochran\@gmail.com" <richardcochran@gmail.com>,
        "sboyd\@kernel.org" <sboyd@kernel.org>,
        "vdronov\@redhat.com" <vdronov@redhat.com>,
        "bigeasy\@linutronix.de" <bigeasy@linutronix.de>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "edumazet\@google.com" <edumazet@google.com>
Cc:     "jesus.sanchez-palencia\@intel.com" 
        <jesus.sanchez-palencia@intel.com>,
        "vedang.patel\@intel.com" <vedang.patel@intel.com>,
        "Sudler\, Simon" <simon.sudler@siemens.com>,
        "Bucher\, Andreas" <andreas.bucher@siemens.com>,
        "henning.schild\@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka\@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler\, Andreas" <andreas.zirkler@siemens.com>,
        "Sakic\, Ermin" <ermin.sakic@siemens.com>,
        "anninh.nguyen\@siemens.com" <anninh.nguyen@siemens.com>,
        "Saenger\, Michael" <michael.saenger@siemens.com>,
        "Maehringer\, Bernd" <bernd.maehringer@siemens.com>,
        "gisela.greinert\@siemens.com" <gisela.greinert@siemens.com>,
        "Geva\, Erez" <erez.geva.ext@siemens.com>,
        "ErezGeva2\@gmail.com" <ErezGeva2@gmail.com>,
        "guenter.steindl\@siemens.com" <guenter.steindl@siemens.com>
Subject: Re: [PATCH 0/7] TC-ETF support PTP clocks series
In-Reply-To: <AM0PR10MB3073F9694ECAD4F612A86FA7FA050@AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM>
References: <AM0PR10MB3073F9694ECAD4F612A86FA7FA050@AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM>
Date:   Fri, 16 Oct 2020 01:16:28 +0200
Message-ID: <87ft6fulkj.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andreas,

On Wed, Oct 14 2020 at 09:12, Andreas Meisinger wrote:
> Sorry about the wrong format/style of my last mail, hope I did get it
> right this time.

No problem. Yes this looks better. The only thing which could be
improved is that your mail client fails to add

 In-Reply-To: <messageid>
 References: <msgid1> <msgid2> ...

headers and instead has the MS lookout specific

Thread-Topic: [PATCH 0/7] TC-ETF support PTP clocks series
Thread-Index: AdaiB8a+x+RhfhtwSZ+NKfvRdyiJkw=3D=3D

headers. If you look at the lore archive you see the effect:

  https://lore.kernel.org/r/AM0PR10MB3073F9694ECAD4F612A86FA7FA050@AM0PR10M=
B3073.EURPRD10.PROD.OUTLOOK.COM

and that happens to all mail clients which use threading based on the
standard headers. There is config knob in lookout to enable them.

> Let me first point at an important thing because we did have
> discussions here about it too. As of the manpages Linux CLOCK_TAI
> seems to be defined as an nonsettable clock which does have the same
> behaviour as of international atomic time TAI. Yet if it's nonsettable
> it can't be linked or synchronized to the value of International
> Atomic Time?
>
> On the other hand there seems to be code in place to change the
> CLOCK_TAI offset thus making it basically sort of "setable"?

It obviously needs to be modifiable in some way, otherwise
synchronization to a master clock via PTP would not work at all.

But it cannot be set in the way of settimeofday()/clock_settime() like
CLOCK_REALTIME.

>> The user space daemon which does the correlation between these PTP
>> domains and TAI is required in any case, so the magic clock
>> TAI_PRIVATE is not having any advantage.

> I think a userspace daemon handling the translation information
> between different clocks would be fine. I think it's not really that
> relevant who exactly does apply the translation. Kernel level might be
> a little bit more precise but I guess it'd depend on other factors
> too.

Not really. The kernel still provides the timestamp pairs/triplets in the
best way the underlying hardware provides it. Some hardware can even
provide hardware assistet pairs of ART and PTP clock.

> Yet all translation based approaches have in common, setting a clock,
> renders translations done in past invalid. It would be required to fix
> old translated values along with setting the clock. I assume we
> couldn't distinguish between "translated" values and genuine values
> after translation, so fixing them might not be possible at all.

CLOCK_TAI is not really set after the initial sychronization. It's
frequency corrected without causing jumps. PTP daemon uses a PLL based
algorithm for that.

Of course this adjustment has side effects for translation.

> In our usecase we do have a clock for network operation which can't be
> set. We can guarantee this because we are able to define the network
> not being operational when the defined time is not available =F0=9F=98=89.
> Having this defined the remaining option would be the target clock to
> be set. As of your suggestion that would be CLOCK_TAI. So at this
> point "setable" or "nonsettable" would become important. Here
> "setable" would introduce a dependency between the clocks. Being
> independent from clocks outside of our control was exactly the reason
> to introduce the separate network clock. To me this means if CLOCK_TAI
> could be changed by anything it couldn't be the base clock for our
> usecase if it can't it might be a solution.

It's under your control as system designer how you operate CLOCK_TAI.

If you use the PTP daemon then it will sync CLOCK_TAI to the PTP clock
of your choice. If you don't have PTP at all then you can use NTP to
sync to a time server, which is less accurate. You can use PPS or just
use nothing.

The kernel does not care which non-standard base time or frequency you
chose.

Applications which communicate over network might care if the other side
uses a differnet time universe. Log files which start at 1971 might be
interesting to analyse against the log file of your other system which
starts in 2020.

>> Depending on the frequency drift between CLOCK_TAI and clock PTP/$N
>> the timer expiry might be slightly inaccurate, but surely not more
>> inaccurate than if that conversion is done purely in user space.
>>
>> The self rearming posix timers would work too, but the self rearming
>> is based on CLOCK_TAI, so rounding errors and drift would be
>> accumulative. So I'd rather stay away from them.
>
> As of the time ranges typically used in tsn networks the drift error
> for single shot timers most likely isn't a big deal. But as you
> suggest I'd stay away from long running timers as well rearming ones
> too, I guess they'd be mostly unusable.

Depends. It's a matter of hardware properties, system requirements,
application/system designers decisions. So what you consider unusable
for your system might be perfectly fine for others.

If we add support for this type of correlation then of course these
things need to be documented.

> Right now there's only one timestamp in CLOCK_TAI format which is used
> by ETF as well as by network card thus causing trouble if time is not
> same there.
>
> If we'd add an (optional) second timestamp to SKB which would have to
> be set to network card time we could avoid the conversion error. As we
> do know which network card will be used for sending the SKB we
> wouldn't need a clock identifier for the second timestamp.  For
> situations where the application is not aware of the network cards
> timespace it wouldn't provide the second timestamp. In these
> situations it'd behave identical to your suggestion. Here the
> CLOCK_TAI timestamp would be translated to network card time based on
> the information of the userspace daemon.

That would work as long as the target PTP clock is correlated because
the TAI timestamp is still required to make all of this work.

There are probably quite some dragons lurking left and right if we go
there, but it looks like a possible option.

Thanks,

        tglx


