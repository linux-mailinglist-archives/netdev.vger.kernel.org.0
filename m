Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88DE655F98
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 04:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiLZDqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 22:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiLZDqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 22:46:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE72BE2E
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 19:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672026307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v6UhDCmakXh8a6UllVBzSFIWUqyi4qvcOl3b6DYLJeI=;
        b=Z8Pr5Tb7WLh2NPJawmnlL5Km19NyMsjld94FyhchlADnIRcXhBj7j5eRHnXFgGSp87e2dw
        AVH9ulmR7TKGFwhFornLHlJ74opRhf54W1AvBERuTcUkFChvImFpdU3qzP8hERzldfkbfa
        Buggskgx54npw8VS/PgNHozkJ9/XnMo=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-542-lcNGW5Y4PB-ZjfOZX_MRGA-1; Sun, 25 Dec 2022 22:45:05 -0500
X-MC-Unique: lcNGW5Y4PB-ZjfOZX_MRGA-1
Received: by mail-ot1-f71.google.com with SMTP id cg13-20020a056830630d00b00670556db34fso5780049otb.3
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 19:45:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v6UhDCmakXh8a6UllVBzSFIWUqyi4qvcOl3b6DYLJeI=;
        b=H+s24mk9KFi5MeFh/SRqGli/C1d4wO4MSHHr306GMGpK8i5PSoIJj78nyBT5gGUC+k
         DPxwksHarWBx6VL1lxjZ3KYsEG1uVqa1vXSot6oEQEXnFnkcHPJCAE8OqFJ6eSw+u4ZM
         /FRpAU7HHNrVk/7d2b+6drzpbLkhjP25QAlyabZUq8Q9Gp3Y5d0L6pwsfgLHcpNHFdGC
         kIZftrOB4dgB7hONHSsRzMOP/doRRPm6g/XJvFfHSmlEA5KYtSA8LdtebpEoC76M6mon
         FUwavkN/+ayw/4Vp72K6Ic/LK2slyZLnZ1DO8fZ6nexnNQJHxX7aT0U8k1grYGYuXYKW
         UthA==
X-Gm-Message-State: AFqh2kpxkMN24DNFP47RRn2Qh02uXvdws4HVzq6oklMCE2auMoAEy5rm
        457D03d9vWR8M6c/6tScu6RsbigdRhNXEZoqfyZzRB6k9VPsuO8e494w6BIoCwukEiWHTZXzI1t
        FNcR6wCs07idoWzMs50U3rOumLcHq9f5h
X-Received: by 2002:a9d:7843:0:b0:678:1eb4:3406 with SMTP id c3-20020a9d7843000000b006781eb43406mr1074883otm.237.1672026304511;
        Sun, 25 Dec 2022 19:45:04 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuuFZprgssl3UYeZRNHdhEmv9X+l3MPWp5HXJ8UsDPnAmMUZUZsmZJzzO7LV6M+colYpmnRAcxyg0NMseykUt0=
X-Received: by 2002:a9d:7843:0:b0:678:1eb4:3406 with SMTP id
 c3-20020a9d7843000000b006781eb43406mr1074880otm.237.1672026304284; Sun, 25
 Dec 2022 19:45:04 -0800 (PST)
MIME-Version: 1.0
References: <20221222060427.21626-1-jasowang@redhat.com> <20221222060427.21626-5-jasowang@redhat.com>
 <CAJaqyWetutMj=GrR+ieS265_aRr7OhoP+7O5rWgPnP+ZAyxbPg@mail.gmail.com>
 <CACGkMEvs6QenyQNR0GyJ81PgT-w2fy7Rag-JkJ7xNGdNZLGSfQ@mail.gmail.com> <CAJaqyWfJriGB1aLJ8BWZnnZ+fYrpwpkwxSAmKhzmYE72VWBvEA@mail.gmail.com>
In-Reply-To: <CAJaqyWfJriGB1aLJ8BWZnnZ+fYrpwpkwxSAmKhzmYE72VWBvEA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 26 Dec 2022 11:44:53 +0800
Message-ID: <CACGkMEuZqe8=hmn+SWFb6DZ+8BgTJ5xiaXTMTnz_4Cc0b1E0pg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        alvaro.karsz@solid-run.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 4:05 PM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Fri, Dec 23, 2022 at 4:04 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Thu, Dec 22, 2022 at 5:19 PM Eugenio Perez Martin
> > <eperezma@redhat.com> wrote:
> > >
> > > On Thu, Dec 22, 2022 at 7:05 AM Jason Wang <jasowang@redhat.com> wrote:
> > > >
> > > > We used to busy waiting on the cvq command this tends to be
> > > > problematic since:
> > > >
> > > > 1) CPU could wait for ever on a buggy/malicous device
> > > > 2) There's no wait to terminate the process that triggers the cvq
> > > >    command
> > > >
> > > > So this patch switch to use sleep with a timeout (1s) instead of busy
> > > > polling for the cvq command forever. This gives the scheduler a breath
> > > > and can let the process can respond to a signal.
> > > >
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 15 ++++++++-------
> > > >  1 file changed, 8 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 8225496ccb1e..69173049371f 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -405,6 +405,7 @@ static void disable_rx_mode_work(struct virtnet_info *vi)
> > > >         vi->rx_mode_work_enabled = false;
> > > >         spin_unlock_bh(&vi->rx_mode_lock);
> > > >
> > > > +       virtqueue_wake_up(vi->cvq);
> > > >         flush_work(&vi->rx_mode_work);
> > > >  }
> > > >
> > > > @@ -1497,6 +1498,11 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
> > > >         return !oom;
> > > >  }
> > > >
> > > > +static void virtnet_cvq_done(struct virtqueue *cvq)
> > > > +{
> > > > +       virtqueue_wake_up(cvq);
> > > > +}
> > > > +
> > > >  static void skb_recv_done(struct virtqueue *rvq)
> > > >  {
> > > >         struct virtnet_info *vi = rvq->vdev->priv;
> > > > @@ -2024,12 +2030,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
> > > >         if (unlikely(!virtqueue_kick(vi->cvq)))
> > > >                 return vi->ctrl->status == VIRTIO_NET_OK;
> > > >
> > > > -       /* Spin for a response, the kick causes an ioport write, trapping
> > > > -        * into the hypervisor, so the request should be handled immediately.
> > > > -        */
> > > > -       while (!virtqueue_get_buf(vi->cvq, &tmp) &&
> > > > -              !virtqueue_is_broken(vi->cvq))
> > > > -               cpu_relax();
> > > > +       virtqueue_wait_for_used(vi->cvq, &tmp);
> > > >
> > > >         return vi->ctrl->status == VIRTIO_NET_OK;
> > > >  }
> > > > @@ -3524,7 +3525,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > > >
> > > >         /* Parameters for control virtqueue, if any */
> > > >         if (vi->has_cvq) {
> > > > -               callbacks[total_vqs - 1] = NULL;
> > > > +               callbacks[total_vqs - 1] = virtnet_cvq_done;
> > >
> > > If we're using CVQ callback, what is the actual use of the timeout?
> >
> > Because we can't sleep forever since locks could be held like RTNL_LOCK.
> >
>
> Right, rtnl_lock kind of invalidates it for a general case.
>
> But do all of the commands need to take rtnl_lock? For example I see
> how we could remove it from ctrl_announce,

I think not, it's intended to serialize all cvq commands.

> so lack of ack may not be
> fatal for it.

Then there could be more than one cvq commands sent to the device, the
busy poll logic may not work.

And it's a hint that the device malfunctioned which is something that
the driver should be aware of.

Thanks

> Assuming a buggy device, we can take some cvq commands
> out of this fatal situation.
>
> This series already improves the current situation and my suggestion
> (if it's worth it) can be applied on top of it, so it is not a blocker
> at all.
>
> > >
> > > I'd say there is no right choice neither in the right timeout value
> > > nor in the action to take.
> >
> > In the next version, I tend to put BAD_RING() to prevent future requests.
> >
> > > Why not simply trigger the cmd and do all
> > > the changes at command return?
> >
> > I don't get this, sorry.
> >
>
> It's actually expanding the first point so you already answered it :).
>
> Thanks!
>
> > >
> > > I suspect the reason is that it complicates the code. For example,
> > > having the possibility of many in flight commands, races between their
> > > completion, etc.
> >
> > Actually the cvq command was serialized through RTNL_LOCK, so we don't
> > need to worry about this.
> >
> > In the next version I can add ASSERT_RTNL().
> >
> > Thanks
> >
> > > The virtio standard does not even cover unordered
> > > used commands if I'm not wrong.
> > >
> > > Is there any other fundamental reason?
> > >
> > > Thanks!
> > >
> > > >                 names[total_vqs - 1] = "control";
> > > >         }
> > > >
> > > > --
> > > > 2.25.1
> > > >
> > >
> >
>

