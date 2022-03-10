Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFCF4D47CA
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 14:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242136AbiCJNNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 08:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242074AbiCJNNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 08:13:12 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E26314CD83
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:12:10 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id f38so10795443ybi.3
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=viAYQWfLt8jwZlTYc2jBnWPUdfvsV3AuBv3mwnsHANc=;
        b=rOg7CmPnbKgdQtl8rsvfvtCzZIc3kZDG1B7x3HvHfLX+o/rk7nHHf3NQMez7ZtAVRv
         W+cp8fURE1R70uFNRlYkNI2z7+IP84mjonGW31B7Y/LxIEwXgwzdwQXRvpeoCQSObpzv
         x25xUZSpCHnUtZOZr43ZQnpugaLaYLiLNIOIVf/aWgloMTfjD8xB5777s1fRODnDhlIo
         G3WA14B25YlBSrEQ2SjdscFQEwLKFFQS2VvRrbLLgTjh+mjuwo+YcCnKvmkOwpLikDZj
         iillSXkJScsl8SkEVSN/ZgYXD20pApfmy0SnAXtLT0DY7ka6EW/kpgadJhv7Cw6jaB0N
         9+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=viAYQWfLt8jwZlTYc2jBnWPUdfvsV3AuBv3mwnsHANc=;
        b=J1Fx7qN93JMs++JgIzXG/5gDr8s1zguBljWA4aTl0gYvusvwTOOvJNnFd3QWlzPVSw
         eoGDBwqFUPQklfyoHmzypBtytjjtX+3815Xxo18yriT/PKud2tk9q7kIEEcGWz0/bBRA
         d4HKbr6tAyT4JjmlLjLxFsr4fVPVi1+gKaDetVSa95gaHg4Au6SLeyllueXFuzMr9HNy
         d0DSJ5iNUbT2heakHGsZHtQat0SIa+F7wVDU0XN18RrZJb/2wbBV0ASXXokovFPpvHoE
         m7ycJ1wOPNpkwTq1/GVlurWEQvuYc3fkC+kGZzOOvSrYYTh6G8cRjY1i4wG44h7dGEg2
         T4ag==
X-Gm-Message-State: AOAM530NopzqSVwOLDhP5Uck8VKu2IMOqIWrEKMrYu/4MX1FDVE0bSWB
        aLZYRxvGoBhxY4S8MzHnk+GqlzxhQTNEJcuLSnGiKA==
X-Google-Smtp-Source: ABdhPJzLTSZqQ0N6Dik+Ofetn+Lan6es0hiT0HdX5o9gIuwuEt+HBhUI3tnnkFx4aOXExiO1NLOtmhI1fbhXdEazMp4=
X-Received: by 2002:a25:3a41:0:b0:628:86a2:dbc with SMTP id
 h62-20020a253a41000000b0062886a20dbcmr3593888yba.633.1646917929039; Thu, 10
 Mar 2022 05:12:09 -0800 (PST)
MIME-Version: 1.0
References: <20220310125425.4193879-1-jiyong@google.com> <20220310125425.4193879-2-jiyong@google.com>
 <20220310075933-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220310075933-mutt-send-email-mst@kernel.org>
From:   Jiyong Park <jiyong@google.com>
Date:   Thu, 10 Mar 2022 22:11:32 +0900
Message-ID: <CALeUXe4V=6WhavV5d0XN_EjtZ9=0_5rD9ZfvQ77M1W4HpYh_2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] vsock: each transport cycles only on its own sockets
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     sgarzare@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

Thanks for looking into this.

Would you mind if I ask what you mean by incomplete? Is it because non-updated
modules will still have the issue? Please elaborate.


On Thu, Mar 10, 2022 at 10:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Mar 10, 2022 at 09:54:24PM +0900, Jiyong Park wrote:
> > When iterating over sockets using vsock_for_each_connected_socket, make
> > sure that a transport filters out sockets that don't belong to the
> > transport.
> >
> > There actually was an issue caused by this; in a nested VM
> > configuration, destroying the nested VM (which often involves the
> > closing of /dev/vhost-vsock if there was h2g connections to the nested
> > VM) kills not only the h2g connections, but also all existing g2h
> > connections to the (outmost) host which are totally unrelated.
> >
> > Tested: Executed the following steps on Cuttlefish (Android running on a
> > VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
> > connection inside the VM, (2) open and then close /dev/vhost-vsock by
> > `exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
> > session is not reset.
> >
> > [1] https://android.googlesource.com/device/google/cuttlefish/
> >
> > Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> > Signed-off-by: Jiyong Park <jiyong@google.com>
> > ---
> >  drivers/vhost/vsock.c            | 4 ++++
> >  net/vmw_vsock/virtio_transport.c | 7 +++++++
> >  net/vmw_vsock/vmci_transport.c   | 5 +++++
> >  3 files changed, 16 insertions(+)
> >
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index 37f0b4274113..853ddac00d5b 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -722,6 +722,10 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
> >        * executing.
> >        */
> >
> > +     /* Only handle our own sockets */
> > +     if (vsk->transport != &vhost_transport.transport)
> > +             return;
> > +
> >       /* If the peer is still valid, no need to reset connection */
> >       if (vhost_vsock_get(vsk->remote_addr.svm_cid))
> >               return;
>
>
> We know this is incomplete though. So I think it's the wrong thing to do
> when you backport, too. If all you worry about is breaking a binary
> module interface, how about simply exporting a new function when you
> backport. Thus you will have downstream both:
>
> void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
>
> void vsock_for_each_connected_socket_new(struct vsock_transport *transport,
>                                     void (*fn)(struct sock *sk));
>
>
> and then upstream we can squash these two patches.
>
> Hmm?
>
>
> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > index fb3302fff627..61b24eb31d4b 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -24,6 +24,7 @@
> >  static struct workqueue_struct *virtio_vsock_workqueue;
> >  static struct virtio_vsock __rcu *the_virtio_vsock;
> >  static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
> > +static struct virtio_transport virtio_transport; /* forward declaration */
> >
> >  struct virtio_vsock {
> >       struct virtio_device *vdev;
> > @@ -357,11 +358,17 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
> >
> >  static void virtio_vsock_reset_sock(struct sock *sk)
> >  {
> > +     struct vsock_sock *vsk = vsock_sk(sk);
> > +
> >       /* vmci_transport.c doesn't take sk_lock here either.  At least we're
> >        * under vsock_table_lock so the sock cannot disappear while we're
> >        * executing.
> >        */
> >
> > +     /* Only handle our own sockets */
> > +     if (vsk->transport != &virtio_transport.transport)
> > +             return;
> > +
> >       sk->sk_state = TCP_CLOSE;
> >       sk->sk_err = ECONNRESET;
> >       sk_error_report(sk);
> > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > index 7aef34e32bdf..cd2f01513fae 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
> > @@ -803,6 +803,11 @@ static void vmci_transport_handle_detach(struct sock *sk)
> >       struct vsock_sock *vsk;
> >
> >       vsk = vsock_sk(sk);
> > +
> > +     /* Only handle our own sockets */
> > +     if (vsk->transport != &vmci_transport)
> > +             return;
> > +
> >       if (!vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)) {
> >               sock_set_flag(sk, SOCK_DONE);
> >
> > --
> > 2.35.1.723.g4982287a31-goog
>
