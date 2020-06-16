Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826B91FC12D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 23:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgFPVt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 17:49:56 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:31941 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgFPVtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 17:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1592344188; x=1623880188;
  h=date:from:to:cc:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to:subject;
  bh=2xZWar77dXkth8tk0V/E/5zPJfDMTckPDO14OJN6cFs=;
  b=S0KWAit/W96xLY6edIEKux3Zl9R0ulYlurEYcb452/iVIrYLPsdgVvUr
   eiIA7JRiRy7K/26SH2lDtEaRDHr8AtS7RkrkG+Wmz3R26zaeF5cq/kLQo
   Ja+nDsTbQg25cN36o2n41AdEhrYSVSz0y6f96V4lPNSp2NMyNYyCmw1hN
   g=;
IronPort-SDR: mrYnVTXGTnnqHewBUIddvzzRXlflYMjMyxE96i0WnUJPOgd3L5PuAQgZhdT+1V4jG9PhbPquY9
 XRYaFMbAvvQw==
X-IronPort-AV: E=Sophos;i="5.73,519,1583193600"; 
   d="scan'208";a="44534346"
Subject: Re: [PATCH 06/12] xen-blkfront: add callbacks for PM suspend and hibernation]
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 16 Jun 2020 21:49:43 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 8C216A07C3;
        Tue, 16 Jun 2020 21:49:41 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 16 Jun 2020 21:49:26 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 16 Jun 2020 21:49:25 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 16 Jun 2020 21:49:25 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 872B240139; Tue, 16 Jun 2020 21:49:25 +0000 (UTC)
Date:   Tue, 16 Jun 2020 21:49:25 +0000
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
Message-ID: <20200616214925.GA21684@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <7FD7505E-79AA-43F6-8D5F-7A2567F333AB@amazon.com>
 <20200604070548.GH1195@Air-de-Roger>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200604070548.GH1195@Air-de-Roger>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 09:05:48AM +0200, Roger Pau Monné wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> Hello,
> 
> On Wed, Jun 03, 2020 at 11:33:52PM +0000, Agarwal, Anchal wrote:
> >  CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >
> >
> >
> >     On Tue, May 19, 2020 at 11:27:50PM +0000, Anchal Agarwal wrote:
> >     > From: Munehisa Kamata <kamatam@amazon.com>
> >     >
> >     > S4 power transition states are much different than xen
> >     > suspend/resume. Former is visible to the guest and frontend drivers should
> >     > be aware of the state transitions and should be able to take appropriate
> >     > actions when needed. In transition to S4 we need to make sure that at least
> >     > all the in-flight blkif requests get completed, since they probably contain
> >     > bits of the guest's memory image and that's not going to get saved any
> >     > other way. Hence, re-issuing of in-flight requests as in case of xen resume
> >     > will not work here. This is in contrast to xen-suspend where we need to
> >     > freeze with as little processing as possible to avoid dirtying RAM late in
> >     > the migration cycle and we know that in-flight data can wait.
> >     >
> >     > Add freeze, thaw and restore callbacks for PM suspend and hibernation
> >     > support. All frontend drivers that needs to use PM_HIBERNATION/PM_SUSPEND
> >     > events, need to implement these xenbus_driver callbacks. The freeze handler
> >     > stops block-layer queue and disconnect the frontend from the backend while
> >     > freeing ring_info and associated resources. Before disconnecting from the
> >     > backend, we need to prevent any new IO from being queued and wait for existing
> >     > IO to complete. Freeze/unfreeze of the queues will guarantee that there are no
> >     > requests in use on the shared ring. However, for sanity we should check
> >     > state of the ring before disconnecting to make sure that there are no
> >     > outstanding requests to be processed on the ring. The restore handler
> >     > re-allocates ring_info, unquiesces and unfreezes the queue and re-connect to
> >     > the backend, so that rest of the kernel can continue to use the block device
> >     > transparently.
> >     >
> >     > Note:For older backends,if a backend doesn't have commit'12ea729645ace'
> >     > xen/blkback: unmap all persistent grants when frontend gets disconnected,
> >     > the frontend may see massive amount of grant table warning when freeing
> >     > resources.
> >     > [   36.852659] deferring g.e. 0xf9 (pfn 0xffffffffffffffff)
> >     > [   36.855089] xen:grant_table: WARNING:e.g. 0x112 still in use!
> >     >
> >     > In this case, persistent grants would need to be disabled.
> >     >
> >     > [Anchal Changelog: Removed timeout/request during blkfront freeze.
> >     > Reworked the whole patch to work with blk-mq and incorporate upstream's
> >     > comments]
> >
> >     Please tag versions using vX and it would be helpful if you could list
> >     the specific changes that you performed between versions. There where
> >     3 RFC versions IIRC, and there's no log of the changes between them.
> >
> > I will elaborate on "upstream's comments" in my changelog in my next round of patches.
> 
> Sorry for being picky, but can you please make sure your email client
> properly quotes previous emails on reply. Note the lack of '>' added
> to the quoted parts of your reply.
That was just my outlook probably. Note taken.
> 
> >     > +                     }
> >     > +
> >     >                       break;
> >     > +             }
> >     > +
> >     > +             /*
> >     > +              * We may somehow receive backend's Closed again while thawing
> >     > +              * or restoring and it causes thawing or restoring to fail.
> >     > +              * Ignore such unexpected state regardless of the backend state.
> >     > +              */
> >     > +             if (info->connected == BLKIF_STATE_FROZEN) {
> >
> >     I think you can join this with the previous dev->state == XenbusStateClosed?
> >
> >     Also, won't the device be in the Closed state already if it's in state
> >     frozen?
> > Yes but I think this mostly due to a hypothetical case if during thawing backend switches to Closed state.
> > I am not entirely sure if that could happen. Could use some expertise here.
> 
> I think the frontend seeing the backend in the closed state during
> restore would be a bug that should prevent the frontend from
> resuming.
> 
> >     > +     /* Kick the backend to disconnect */
> >     > +     xenbus_switch_state(dev, XenbusStateClosing);
> >     > +
> >     > +     /*
> >     > +      * We don't want to move forward before the frontend is diconnected
> >     > +      * from the backend cleanly.
> >     > +      */
> >     > +     timeout = wait_for_completion_timeout(&info->wait_backend_disconnected,
> >     > +                                           timeout);
> >     > +     if (!timeout) {
> >     > +             err = -EBUSY;
> >
> >     Note err is only used here, and I think could just be dropped.
> >
> > This err is what's being returned from the function. Am I missing anything?
> 
> Just 'return -EBUSY;' directly, and remove the top level variable. You
> can also use -EBUSY directly in the xenbus_dev_error call. Anyway, not
> that important.
> 
> >     > +             xenbus_dev_error(dev, err, "Freezing timed out;"
> >     > +                              "the device may become inconsistent state");
> >
> >     Leaving the device in this state is quite bad, as it's in a closed
> >     state and with the queues frozen. You should make an attempt to
> >     restore things to a working state.
> >
> > You mean if backend closed after timeout? Is there a way to know that? I understand it's not good to
> > leave it in this state however, I am still trying to find if there is a good way to know if backend is still connected after timeout.
> > Hence the message " the device may become inconsistent state".  I didn't see a timeout not even once on my end so that's why
> > I may be looking for an alternate perspective here. may be need to thaw everything back intentionally is one thing I could think of.
> 
> You can manually force this state, and then check that it will behave
> correctly. I would expect that on a failure to disconnect from the
> backend you should switch the frontend to the 'Init' state in order to
> try to reconnect to the backend when possible.
> 
From what I understand forcing manually is, failing the freeze without
disconnect and try to revive the connection by unfreezing the
queues->reconnecting to backend [which never got diconnected]. May be even
tearing down things manually because I am not sure what state will frontend
see if backend fails to to disconnect at any point in time. I assumed connected.
Then again if its "CONNECTED" I may not need to tear down everything and start
from Initialising state because that may not work.

So I am not so sure about backend's state so much, lets say if  xen_blkif_disconnect fail,
I don't see it getting handled in the backend then what will be backend's state?
Will it still switch xenbus state to 'Closed'? If not what will frontend see, 
if it tries to read backend's state through xenbus_read_driver_state ?

So the flow be like:
Front end marks XenbusStateClosing
Backend marks its state as XenbusStateClosing
    Frontend marks XenbusStateClosed
    Backend disconnects calls xen_blkif_disconnect
       Backend fails to disconnect, the above function returns EBUSY
       What will be state of backend here? 
       Frontend did not tear down the rings if backend does not switches the
       state to 'Closed' in case of failure.

If backend stays in CONNECTED state, then even if we mark it Initialised in frontend, backend
won't be calling connect(). {From reading code in frontend_changed}
IMU, Initialising will fail since backend dev->state != XenbusStateClosed plus
we did not tear down anything so calling talk_to_blkback may not be needed

Does that sound correct?
> >     > +     }
> >     > +
> >     > +     return err;
> >     > +}
> >     > +
> >     > +static int blkfront_restore(struct xenbus_device *dev)
> >     > +{
> >     > +     struct blkfront_info *info = dev_get_drvdata(&dev->dev);
> >     > +     int err = 0;
> >     > +
> >     > +     err = talk_to_blkback(dev, info);
> >     > +     blk_mq_unquiesce_queue(info->rq);
> >     > +     blk_mq_unfreeze_queue(info->rq);
> >     > +     if (!err)
> >     > +         blk_mq_update_nr_hw_queues(&info->tag_set, info->nr_rings);
> >
> >     Bad indentation. Also shouldn't you first update the queues and then
> >     unfreeze them?
> > Please correct me if I am wrong, blk_mq_update_nr_hw_queues freezes the queue
> > So I don't think the order could be reversed.
> 
> Regardless of what blk_mq_update_nr_hw_queues does, I don't think it's
> correct to unfreeze the queues without having updated them. Also the
> freezing/unfreezing uses a refcount, so I think it's perfectly fine to
> call blk_mq_update_nr_hw_queues first and then unfreeze the queues.
> 
> Also note that talk_to_blkback returning an error should likely
> prevent any unfreezing, as the queues won't be updated to match the
> parameters of the backend.
>
I think you are right here. Will send out fixes in V2
> Thanks, Roger.
> 
Thanks,
Anchal
