Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939031FC8DA
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 10:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgFQIfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 04:35:41 -0400
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:38612 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbgFQIfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 04:35:41 -0400
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: KfZvMvC1oYnZ7gi+KDWOviH4clxbHShSY7Yli+xfkrqN6LkJMaGowI1WLqHxqcACgMUrxfkUAD
 Ay5pg5WGOeqKL0CCypgK4qhxMgOHjyTIf64e1aNhYRAm71VGxZrK78hisJYBoO7fnRxdMgfY7b
 vDubhXWnqwLSYTQ7ryxlfakGFVKT1POd8dRmcMBv35hFYrPvNJEhPlc4qaSrLIUxHxgq6p86dI
 Fvz6UQo69l4R4knwvEj6X3MlFh19OkyWqWkPIwHX3MDCwr+2pRlebLitMY4MMI8I/Szkk6yaRS
 9UE=
X-SBRS: 2.7
X-MesageID: 20261029
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.73,522,1583211600"; 
   d="scan'208";a="20261029"
Date:   Wed, 17 Jun 2020 10:35:28 +0200
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Anchal Agarwal <anchalag@amazon.com>
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
Subject: Re: [PATCH 06/12] xen-blkfront: add callbacks for PM suspend and
 hibernation]
Message-ID: <20200617083528.GW735@Air-de-Roger>
References: <7FD7505E-79AA-43F6-8D5F-7A2567F333AB@amazon.com>
 <20200604070548.GH1195@Air-de-Roger>
 <20200616214925.GA21684@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200616214925.GA21684@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 09:49:25PM +0000, Anchal Agarwal wrote:
> On Thu, Jun 04, 2020 at 09:05:48AM +0200, Roger Pau Monné wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > On Wed, Jun 03, 2020 at 11:33:52PM +0000, Agarwal, Anchal wrote:
> > >  CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > >     > +             xenbus_dev_error(dev, err, "Freezing timed out;"
> > >     > +                              "the device may become inconsistent state");
> > >
> > >     Leaving the device in this state is quite bad, as it's in a closed
> > >     state and with the queues frozen. You should make an attempt to
> > >     restore things to a working state.
> > >
> > > You mean if backend closed after timeout? Is there a way to know that? I understand it's not good to
> > > leave it in this state however, I am still trying to find if there is a good way to know if backend is still connected after timeout.
> > > Hence the message " the device may become inconsistent state".  I didn't see a timeout not even once on my end so that's why
> > > I may be looking for an alternate perspective here. may be need to thaw everything back intentionally is one thing I could think of.
> > 
> > You can manually force this state, and then check that it will behave
> > correctly. I would expect that on a failure to disconnect from the
> > backend you should switch the frontend to the 'Init' state in order to
> > try to reconnect to the backend when possible.
> > 
> From what I understand forcing manually is, failing the freeze without
> disconnect and try to revive the connection by unfreezing the
> queues->reconnecting to backend [which never got diconnected]. May be even
> tearing down things manually because I am not sure what state will frontend
> see if backend fails to to disconnect at any point in time. I assumed connected.
> Then again if its "CONNECTED" I may not need to tear down everything and start
> from Initialising state because that may not work.
> 
> So I am not so sure about backend's state so much, lets say if  xen_blkif_disconnect fail,
> I don't see it getting handled in the backend then what will be backend's state?
> Will it still switch xenbus state to 'Closed'? If not what will frontend see, 
> if it tries to read backend's state through xenbus_read_driver_state ?
> 
> So the flow be like:
> Front end marks XenbusStateClosing
> Backend marks its state as XenbusStateClosing
>     Frontend marks XenbusStateClosed
>     Backend disconnects calls xen_blkif_disconnect
>        Backend fails to disconnect, the above function returns EBUSY
>        What will be state of backend here?

Backend should stay in state 'Closing' then, until it can finish
tearing down.

>        Frontend did not tear down the rings if backend does not switches the
>        state to 'Closed' in case of failure.
> 
> If backend stays in CONNECTED state, then even if we mark it Initialised in frontend, backend

Backend will stay in state 'Closing' I think.

> won't be calling connect(). {From reading code in frontend_changed}
> IMU, Initialising will fail since backend dev->state != XenbusStateClosed plus
> we did not tear down anything so calling talk_to_blkback may not be needed
> 
> Does that sound correct?

I think switching to the initial state in order to try to attempt a
reconnection would be our best bet here.

Thanks, Roger.
