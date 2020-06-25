Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FB720A516
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 20:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405208AbgFYSh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 14:37:29 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:16778 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgFYSh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 14:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593110246; x=1624646246;
  h=date:from:to:cc:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to:subject;
  bh=qlB2s4Wgnet0CN8ARSsKtfvhK92eox5FVS24rLtb+rU=;
  b=mv8WKD75KZXT2Wv6dMBRRMLqOZY6gIdejE/1xsodfAjR7J66l6IisIGZ
   M9QYvjnLzLOi6uEWdopkyWVItVKiWoy0j1jYI85aaoreErVowFwB85Fzj
   eE5LD6IuLHA02E6zjN3VH8OwvZGwGzESY5WChBz0KbuznJsA3d/xnoOQN
   o=;
IronPort-SDR: SCR/aF+rX11ye4y2opWfGY1ClwptB+a+zTCNmAF+d6fCjJf+qsOh77GBJkosreSA4gZmk3KUZB
 UVvuNlnLGzMQ==
X-IronPort-AV: E=Sophos;i="5.75,280,1589241600"; 
   d="scan'208";a="39889028"
Subject: Re: [PATCH 06/12] xen-blkfront: add callbacks for PM suspend and hibernation]
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 25 Jun 2020 18:37:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id E128AA275E;
        Thu, 25 Jun 2020 18:37:16 +0000 (UTC)
Received: from EX13D05UWB001.ant.amazon.com (10.43.161.181) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 18:36:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D05UWB001.ant.amazon.com (10.43.161.181) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 18:36:59 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 25 Jun 2020 18:36:59 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 66FC940359; Thu, 25 Jun 2020 18:36:59 +0000 (UTC)
Date:   Thu, 25 Jun 2020 18:36:59 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Message-ID: <20200625183659.GA26586@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <7FD7505E-79AA-43F6-8D5F-7A2567F333AB@amazon.com>
 <20200604070548.GH1195@Air-de-Roger>
 <20200616214925.GA21684@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200617083528.GW735@Air-de-Roger>
 <20200619234312.GA24846@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200622083846.GF735@Air-de-Roger>
 <20200623004314.GA28586@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200623081903.GP735@Air-de-Roger>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200623081903.GP735@Air-de-Roger>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 10:19:03AM +0200, Roger Pau Monné wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On Tue, Jun 23, 2020 at 12:43:14AM +0000, Anchal Agarwal wrote:
> > On Mon, Jun 22, 2020 at 10:38:46AM +0200, Roger Pau Monné wrote:
> > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > >
> > >
> > >
> > > On Fri, Jun 19, 2020 at 11:43:12PM +0000, Anchal Agarwal wrote:
> > > > On Wed, Jun 17, 2020 at 10:35:28AM +0200, Roger Pau Monné wrote:
> > > > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > > >
> > > > >
> > > > >
> > > > > On Tue, Jun 16, 2020 at 09:49:25PM +0000, Anchal Agarwal wrote:
> > > > > > On Thu, Jun 04, 2020 at 09:05:48AM +0200, Roger Pau Monné wrote:
> > > > > > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > > > > > On Wed, Jun 03, 2020 at 11:33:52PM +0000, Agarwal, Anchal wrote:
> > > > > > > >  CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > > > > > >     > +             xenbus_dev_error(dev, err, "Freezing timed out;"
> > > > > > > >     > +                              "the device may become inconsistent state");
> > > > > > > >
> > > > > > > >     Leaving the device in this state is quite bad, as it's in a closed
> > > > > > > >     state and with the queues frozen. You should make an attempt to
> > > > > > > >     restore things to a working state.
> > > > > > > >
> > > > > > > > You mean if backend closed after timeout? Is there a way to know that? I understand it's not good to
> > > > > > > > leave it in this state however, I am still trying to find if there is a good way to know if backend is still connected after timeout.
> > > > > > > > Hence the message " the device may become inconsistent state".  I didn't see a timeout not even once on my end so that's why
> > > > > > > > I may be looking for an alternate perspective here. may be need to thaw everything back intentionally is one thing I could think of.
> > > > > > >
> > > > > > > You can manually force this state, and then check that it will behave
> > > > > > > correctly. I would expect that on a failure to disconnect from the
> > > > > > > backend you should switch the frontend to the 'Init' state in order to
> > > > > > > try to reconnect to the backend when possible.
> > > > > > >
> > > > > > From what I understand forcing manually is, failing the freeze without
> > > > > > disconnect and try to revive the connection by unfreezing the
> > > > > > queues->reconnecting to backend [which never got diconnected]. May be even
> > > > > > tearing down things manually because I am not sure what state will frontend
> > > > > > see if backend fails to to disconnect at any point in time. I assumed connected.
> > > > > > Then again if its "CONNECTED" I may not need to tear down everything and start
> > > > > > from Initialising state because that may not work.
> > > > > >
> > > > > > So I am not so sure about backend's state so much, lets say if  xen_blkif_disconnect fail,
> > > > > > I don't see it getting handled in the backend then what will be backend's state?
> > > > > > Will it still switch xenbus state to 'Closed'? If not what will frontend see,
> > > > > > if it tries to read backend's state through xenbus_read_driver_state ?
> > > > > >
> > > > > > So the flow be like:
> > > > > > Front end marks XenbusStateClosing
> > > > > > Backend marks its state as XenbusStateClosing
> > > > > >     Frontend marks XenbusStateClosed
> > > > > >     Backend disconnects calls xen_blkif_disconnect
> > > > > >        Backend fails to disconnect, the above function returns EBUSY
> > > > > >        What will be state of backend here?
> > > > >
> > > > > Backend should stay in state 'Closing' then, until it can finish
> > > > > tearing down.
> > > > >
> > > > It disconnects the ring after switching to connected state too.
> > > > > >        Frontend did not tear down the rings if backend does not switches the
> > > > > >        state to 'Closed' in case of failure.
> > > > > >
> > > > > > If backend stays in CONNECTED state, then even if we mark it Initialised in frontend, backend
> > > > >
> > > > > Backend will stay in state 'Closing' I think.
> > > > >
> > > > > > won't be calling connect(). {From reading code in frontend_changed}
> > > > > > IMU, Initialising will fail since backend dev->state != XenbusStateClosed plus
> > > > > > we did not tear down anything so calling talk_to_blkback may not be needed
> > > > > >
> > > > > > Does that sound correct?
> > > > >
> > > > > I think switching to the initial state in order to try to attempt a
> > > > > reconnection would be our best bet here.
> > > > >
> > > > It does not seems to work correctly, I get hung tasks all over and all the
> > > > requests to filesystem gets stuck. Backend does shows the state as connected
> > > > after xenbus_dev_suspend fails but I think there may be something missing.
> > > > I don't seem to get IO interrupts thereafter i.e hitting the function blkif_interrupts.
> > > > I think just marking it initialised may not be the only thing.
> > > > Here is a short description of what I am trying to do:
> > > > So, on timeout:
> > > >     Switch XenBusState to "Initialized"
> > > >     unquiesce/unfreeze the queues and return
> > > >     mark info->connected = BLKIF_STATE_CONNECTED
> > >
> > > If xenbus state is Initialized isn't it wrong to set info->connected
> > > == CONNECTED?
> > >
> > Yes, you are right earlier I was marking it explicitly but that was not right,
> > the connect path for blkfront will do that.
> > > You should tear down all the internal state (like a proper close)?
> > >
> > Isn't that similar to disconnecting in the first place that failed during
> > freeze? Do you mean re-try to close but this time re-connect after close
> > basically do everything you would at "restore"?
> 
> Last time I checked blkfront supported reconnections (ie: disconnect
> from a backend and connect again). I was assuming we could apply the
> same here on timeout, and just follow the same path where the frontend
> waits indefinitely for the backend to close and then attempts to
> reconnect.
> 
> > Also, I experimented with that and it works intermittently. I want to take a
> > step back on this issue and ask few questions here:
> > 1. Is fixing this recovery a blocker for me sending in a V2 version?
> 
> At the end of day it's your feature. I would certainly prefer for it
> to work as good as possible, this being a recovery in case of failure
> just make sure it does something sane (ie: crash/close the frontend)
> and add a TODO note.
> 
> > 2. In our 2-3 years of supporting this feature at large scale we haven't seen this issue
> > where backend fails to disconnect. What we are trying to do here is create a
> > hypothetical situation where we leave backend in Closing state and try and see how it
> > recovers. The reason why I think it "may not" occur and the timeout of 5HZ is
> > sufficient is because we haven't come across even a single use-case where it
> > caused hibernation to fail.
> > The reason why I think "it may" occur is if we are running a really memory
> > intensive workload and ring is busy and is unable to complete all the requests
> > in the given timeout. This is very unlikely though.
> 
> As said above I would generally prefer for code to handle possible
> failures the best way, and hence I think here it would be nice to
> fallback to the normal disconnect path and just wait for the backend
> to close.
>
Do you mind throwing some light in here, what that path may be, if its
straight forward to fix I would like to debug it a bit more. May be I am
missing some of the context here.

I was of the view we may just want to mark frontend closed which should do 
the job of freeing resources and then following the same flow as
blkfront_restore. That does not seems to work correctly 100% of the time.

> You likely have this very well tuned to your own environment and
> workloads, since this will now be upstream others might have more
> contended systems where it could start to fail.
> 
I agree, however, this is also from the testing I did with 100 of runs 
outside of EC2 running few tests of my own. 
> > 3) Also, I do not think this may be straight forward to fix and expect
> > hibernation to work flawlessly in subsequent invocations. I am open to
> > all suggestions.
> 
> Right, adding a TODO would seem appropriate then.
>
Just to double check, I will send in a V2 with this marked as TO-DO?
> Roger.

Thanks,
Anchal
