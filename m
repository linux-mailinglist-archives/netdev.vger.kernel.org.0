Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14BF4D477B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 13:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242220AbiCJM7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 07:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241982AbiCJM7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 07:59:06 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CD74739A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:58:05 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2dbc48104beso56764287b3.5
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iuwqffCdQd1eESb6fUO0/SnvNhzkvPtu3e/WcycweOo=;
        b=RrY1qstXlqlY+DZc3aARzo1Cj6XCRkbqyccP8Xh1TPs1TMmPR8yxslOCvbrAikPu5M
         BX7I7ZrDD/qOSpLQEygR3lTBKc5zV6EMN7OmFdS7uSLWjNWu60qtL2wMLmrBFr3pfZCP
         WoH6wlTj5yv7H+MP4Tot3zPvuMM7MN5slDex4agIm2rpwuAbeO9ucsbWXpai7eJawwBr
         /4d/WDBlWTdOgwcyFsf7RlOd/b6A+WsTPjgaEj39+WKjTJdJ2TEgEV3iXTOtD9geI+57
         HvizxXo2ozyvQDXNLwi1sy47RLwZmW4V/yeD9oKkVxzA8VKCGDgu1U7QhbwAR5+F40vH
         +9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iuwqffCdQd1eESb6fUO0/SnvNhzkvPtu3e/WcycweOo=;
        b=bual8tRFh55v1aKML3ixsgkxvAXq6uUDNqEV1JbcoPbzCA0w+wj7qBn1LYM58FHEQK
         9iBQzymAZ1PSo+adzEbdPPo4oZx0GlZo1Xm5uYdtjNWgp9cLjAraH7cXtvu69STaTG6S
         uYfQjODvLEU73/tgxScMizOP1lPI7VcRTDhauR8OucBn51AbS8v5nKkDE7FUSxItiia3
         4niltYvKieFR73PCLAvyfakFeWxzqk+okmUZpctvJB1umyJNqmel0QCDvD2z6wgv1Dn5
         RUK6stY2y/io7yct/It4L5LnDaRwqTk/TR0E1hLbyw/yb0rXpkHnfQixis5T2O3UrdNv
         nBNg==
X-Gm-Message-State: AOAM531zYVqVB0nzFA4nfb+D3OgPQtB45d/RP3i6vyhW0RPSV3JN9KnL
        YJ/moVhKb9bqkxD1nSAM1kz/paeR2qasXWgXKnSHUw==
X-Google-Smtp-Source: ABdhPJxdjA8F3tV+OdA1BTaMyn8LeQHiA1/aVgsouoCSeWVb5l3W2tDld95Y2GEsqLsq3I1z3TQHSWAubgJB0bTM7bA=
X-Received: by 2002:a81:fe01:0:b0:2dc:1f0:441e with SMTP id
 j1-20020a81fe01000000b002dc01f0441emr3611482ywn.227.1646917084118; Thu, 10
 Mar 2022 04:58:04 -0800 (PST)
MIME-Version: 1.0
References: <20220310124936.4179591-1-jiyong@google.com> <20220310124936.4179591-2-jiyong@google.com>
 <20220310075217-mutt-send-email-mst@kernel.org> <20220310075421-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220310075421-mutt-send-email-mst@kernel.org>
From:   Jiyong Park <jiyong@google.com>
Date:   Thu, 10 Mar 2022 21:57:28 +0900
Message-ID: <CALeUXe5ZCfJcHPK98xBcd=NHkZGfc_SMjg-unffbvn+yeKf5qw@mail.gmail.com>
Subject: Re: [PATCH 1/2] vsock: each transport cycles only on its own sockets
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My bad. I mistakenly omitted to and cc for the cover letter. Fixed.

On Thu, Mar 10, 2022 at 9:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Mar 10, 2022 at 07:53:25AM -0500, Michael S. Tsirkin wrote:
> > This message had
> > In-Reply-To: <20220310124936.4179591-1-jiyong@google.com>
> > in its header but 20220310124936.4179591-2-jiyong@google.com was
> > not sent to the list.
> > Please don't do that. Instead, please write and send a proper
> > cover letter. Thanks!
> >
>
>
> Also, pls version in subject e.g. PATCH v2, and include
> full changelog in the cover letter. Thanks!
>
> > On Thu, Mar 10, 2022 at 09:49:35PM +0900, Jiyong Park wrote:
> > > When iterating over sockets using vsock_for_each_connected_socket, make
> > > sure that a transport filters out sockets that don't belong to the
> > > transport.
> > >
> > > There actually was an issue caused by this; in a nested VM
> > > configuration, destroying the nested VM (which often involves the
> > > closing of /dev/vhost-vsock if there was h2g connections to the nested
> > > VM) kills not only the h2g connections, but also all existing g2h
> > > connections to the (outmost) host which are totally unrelated.
> > >
> > > Tested: Executed the following steps on Cuttlefish (Android running on a
> > > VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
> > > connection inside the VM, (2) open and then close /dev/vhost-vsock by
> > > `exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
> > > session is not reset.
> > >
> > > [1] https://android.googlesource.com/device/google/cuttlefish/
> > >
> > > Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> > > Signed-off-by: Jiyong Park <jiyong@google.com>
> > > ---
> > >  drivers/vhost/vsock.c            | 4 ++++
> > >  net/vmw_vsock/virtio_transport.c | 7 +++++++
> > >  net/vmw_vsock/vmci_transport.c   | 5 +++++
> > >  3 files changed, 16 insertions(+)
> > >
> > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > index 37f0b4274113..853ddac00d5b 100644
> > > --- a/drivers/vhost/vsock.c
> > > +++ b/drivers/vhost/vsock.c
> > > @@ -722,6 +722,10 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
> > >      * executing.
> > >      */
> > >
> > > +   /* Only handle our own sockets */
> > > +   if (vsk->transport != &vhost_transport.transport)
> > > +           return;
> > > +
> > >     /* If the peer is still valid, no need to reset connection */
> > >     if (vhost_vsock_get(vsk->remote_addr.svm_cid))
> > >             return;
> > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > index fb3302fff627..61b24eb31d4b 100644
> > > --- a/net/vmw_vsock/virtio_transport.c
> > > +++ b/net/vmw_vsock/virtio_transport.c
> > > @@ -24,6 +24,7 @@
> > >  static struct workqueue_struct *virtio_vsock_workqueue;
> > >  static struct virtio_vsock __rcu *the_virtio_vsock;
> > >  static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
> > > +static struct virtio_transport virtio_transport; /* forward declaration */
> > >
> > >  struct virtio_vsock {
> > >     struct virtio_device *vdev;
> > > @@ -357,11 +358,17 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
> > >
> > >  static void virtio_vsock_reset_sock(struct sock *sk)
> > >  {
> > > +   struct vsock_sock *vsk = vsock_sk(sk);
> > > +
> > >     /* vmci_transport.c doesn't take sk_lock here either.  At least we're
> > >      * under vsock_table_lock so the sock cannot disappear while we're
> > >      * executing.
> > >      */
> > >
> > > +   /* Only handle our own sockets */
> > > +   if (vsk->transport != &virtio_transport.transport)
> > > +           return;
> > > +
> > >     sk->sk_state = TCP_CLOSE;
> > >     sk->sk_err = ECONNRESET;
> > >     sk_error_report(sk);
> > > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > > index 7aef34e32bdf..cd2f01513fae 100644
> > > --- a/net/vmw_vsock/vmci_transport.c
> > > +++ b/net/vmw_vsock/vmci_transport.c
> > > @@ -803,6 +803,11 @@ static void vmci_transport_handle_detach(struct sock *sk)
> > >     struct vsock_sock *vsk;
> > >
> > >     vsk = vsock_sk(sk);
> > > +
> > > +   /* Only handle our own sockets */
> > > +   if (vsk->transport != &vmci_transport)
> > > +           return;
> > > +
> > >     if (!vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle)) {
> > >             sock_set_flag(sk, SOCK_DONE);
> > >
> > > --
> > > 2.35.1.723.g4982287a31-goog
>
