Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79B2654B87
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 04:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiLWDFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 22:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiLWDFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 22:05:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DC828760
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 19:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671764655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nk22SddT8s32uuy10mS2yxkS5L294EJjQs4S55LMRvI=;
        b=jOzkJ8OBP/qocbT3jM9tshFBciUGgpH+ok+MFZC2/FWZWc6SM/VY/A1VMdddFsB8M/Z8P1
        OfE/hioxcqCz2CzPo4D2dPCDvdLRVVsJyt6HdE/PH0ywE1DTZbNf2Sr6oLXV11f7eJ3ZPr
        c5bBgoVGK/vH5oCHut5/kNPDt/D4tyY=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-tRkFtOu3NhO_6AhVBDutQA-1; Thu, 22 Dec 2022 22:04:11 -0500
X-MC-Unique: tRkFtOu3NhO_6AhVBDutQA-1
Received: by mail-ot1-f71.google.com with SMTP id cg13-20020a056830630d00b00670556db34fso1944398otb.3
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 19:04:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nk22SddT8s32uuy10mS2yxkS5L294EJjQs4S55LMRvI=;
        b=pbEA12BtboPTbakcizyma17lnmSsKX3K93pL4b0SskZgKjgoeIZWJDt5aQ+np7DZ3/
         wBWtL2dH7HiWHScINYjUX7ymMrP7gptoAEub59yiefBSl3x947WYlqtzpmXSCRKAC7DE
         ZN0NDozoHzWYLLawbTHxhxtsfX0GCI5vrWslSFrnw6RYAW6pqx5RuHwScBKHg85Cp+vn
         rAUZrFFy1tYQbOhCG8FhwJGTDpA6NG3oK8uFqW/uSw8ZS/yBLjqbnMTbYO1Ax2cAzusi
         Qn2NZfh53diPEo3hDen9Xj1a4rCcy7XTy2hxOOEFeo86SlyoX68w3qCZDy2f8Z+kJXRC
         hW+w==
X-Gm-Message-State: AFqh2krBUbHjXrDHESkHMEfXwaV93EwffusfEtFCL3Jjh86vAiM6cGSH
        MkLVw0aD5gaAqIVh/dIBNILGwHVvBet39Ff3bDm43ptRZw6Q8DhRWEpz/QawgLDOxUCFmeD1cMp
        PEXH01htr01OcCxS1fhWLw6Xc3muI+Hwy
X-Received: by 2002:a54:4e89:0:b0:35c:303d:fe37 with SMTP id c9-20020a544e89000000b0035c303dfe37mr218400oiy.35.1671764650578;
        Thu, 22 Dec 2022 19:04:10 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsbL3LlKBLthwI89NipAwg3/BzVWpLTk8GXoTYMUIMS3DQO3dU//K5z2UA8qfcPRw+PutWyU9/4ADoDgk3Mic0=
X-Received: by 2002:a54:4e89:0:b0:35c:303d:fe37 with SMTP id
 c9-20020a544e89000000b0035c303dfe37mr218393oiy.35.1671764650344; Thu, 22 Dec
 2022 19:04:10 -0800 (PST)
MIME-Version: 1.0
References: <20221222060427.21626-1-jasowang@redhat.com> <20221222060427.21626-5-jasowang@redhat.com>
 <CAJaqyWetutMj=GrR+ieS265_aRr7OhoP+7O5rWgPnP+ZAyxbPg@mail.gmail.com>
In-Reply-To: <CAJaqyWetutMj=GrR+ieS265_aRr7OhoP+7O5rWgPnP+ZAyxbPg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 23 Dec 2022 11:03:59 +0800
Message-ID: <CACGkMEvs6QenyQNR0GyJ81PgT-w2fy7Rag-JkJ7xNGdNZLGSfQ@mail.gmail.com>
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

On Thu, Dec 22, 2022 at 5:19 PM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Thu, Dec 22, 2022 at 7:05 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > We used to busy waiting on the cvq command this tends to be
> > problematic since:
> >
> > 1) CPU could wait for ever on a buggy/malicous device
> > 2) There's no wait to terminate the process that triggers the cvq
> >    command
> >
> > So this patch switch to use sleep with a timeout (1s) instead of busy
> > polling for the cvq command forever. This gives the scheduler a breath
> > and can let the process can respond to a signal.
> >
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 8225496ccb1e..69173049371f 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -405,6 +405,7 @@ static void disable_rx_mode_work(struct virtnet_info *vi)
> >         vi->rx_mode_work_enabled = false;
> >         spin_unlock_bh(&vi->rx_mode_lock);
> >
> > +       virtqueue_wake_up(vi->cvq);
> >         flush_work(&vi->rx_mode_work);
> >  }
> >
> > @@ -1497,6 +1498,11 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
> >         return !oom;
> >  }
> >
> > +static void virtnet_cvq_done(struct virtqueue *cvq)
> > +{
> > +       virtqueue_wake_up(cvq);
> > +}
> > +
> >  static void skb_recv_done(struct virtqueue *rvq)
> >  {
> >         struct virtnet_info *vi = rvq->vdev->priv;
> > @@ -2024,12 +2030,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
> >         if (unlikely(!virtqueue_kick(vi->cvq)))
> >                 return vi->ctrl->status == VIRTIO_NET_OK;
> >
> > -       /* Spin for a response, the kick causes an ioport write, trapping
> > -        * into the hypervisor, so the request should be handled immediately.
> > -        */
> > -       while (!virtqueue_get_buf(vi->cvq, &tmp) &&
> > -              !virtqueue_is_broken(vi->cvq))
> > -               cpu_relax();
> > +       virtqueue_wait_for_used(vi->cvq, &tmp);
> >
> >         return vi->ctrl->status == VIRTIO_NET_OK;
> >  }
> > @@ -3524,7 +3525,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> >
> >         /* Parameters for control virtqueue, if any */
> >         if (vi->has_cvq) {
> > -               callbacks[total_vqs - 1] = NULL;
> > +               callbacks[total_vqs - 1] = virtnet_cvq_done;
>
> If we're using CVQ callback, what is the actual use of the timeout?

Because we can't sleep forever since locks could be held like RTNL_LOCK.

>
> I'd say there is no right choice neither in the right timeout value
> nor in the action to take.

In the next version, I tend to put BAD_RING() to prevent future requests.

> Why not simply trigger the cmd and do all
> the changes at command return?

I don't get this, sorry.

>
> I suspect the reason is that it complicates the code. For example,
> having the possibility of many in flight commands, races between their
> completion, etc.

Actually the cvq command was serialized through RTNL_LOCK, so we don't
need to worry about this.

In the next version I can add ASSERT_RTNL().

Thanks

> The virtio standard does not even cover unordered
> used commands if I'm not wrong.
>
> Is there any other fundamental reason?
>
> Thanks!
>
> >                 names[total_vqs - 1] = "control";
> >         }
> >
> > --
> > 2.25.1
> >
>

