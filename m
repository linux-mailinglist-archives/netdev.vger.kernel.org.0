Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40123B81C9
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhF3MOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:14:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234413AbhF3MOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:14:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625055137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IgkWdNwml5AbnxYQNYHxxHeoFVm9yVfptJ5ZSxaAHBs=;
        b=DIJcSOACTWF8+Xb6Edp+PkdP9H5Tau3rHbUnKUmuh+EeDsIqKpveIHTUc+VKC02K4EQRyM
        NRVKdQfUkxVdf041FkClqJg3jzt+egrmgP/19SJhFt08TZC6ffJsYX0Y3IxUtmfENa2RL3
        x7IuFBmKuQSJtJV7fNSIrLj4VIpLjso=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-O8uec7c3M3-lNS9bD4nhvw-1; Wed, 30 Jun 2021 08:12:14 -0400
X-MC-Unique: O8uec7c3M3-lNS9bD4nhvw-1
Received: by mail-ed1-f72.google.com with SMTP id ee28-20020a056402291cb0290394a9a0bfaeso1040720edb.6
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IgkWdNwml5AbnxYQNYHxxHeoFVm9yVfptJ5ZSxaAHBs=;
        b=ZnUwQjDaOmyiBucmWZkN9lPsgVnn7k6Gf4Dn7GODW4h7+zeNTa4qeCkwR6lJdTFoi3
         oG+sUxYOWCSrlDlUd74U9BuPpGM4T7rIstBqdF2cdtewP6ubRau+7ApU1Ek51Hc3xTwt
         AKG5ufRdF45fIEgdzkZg8rMH+SzQW3F51Y1RSLIjpP32LSY/sRgX9CeOZzXJK+O4sI8D
         61sB7BWFrYf4HaR+pyuiahhZMevnqM8r9d+1l27b0ykoNUXGMditTWhd91ivCCdo8A5K
         9iJmuR7LQ9NDmNhvXDV9AogpNhgMSD1qQA38AC6Z+NRNcVDQbwh1gUiE2ZxCTWcq2/Iv
         GP8Q==
X-Gm-Message-State: AOAM531nfTPXKBZ927w9eQaWgWGtfuasGs/kDIZMBeGNE2zo1scbdai2
        y5dlt9oNEKriTZmsafhoo9wBOtprevBxBPoVpBWFKOSr8EypMSPVmt04Kd5ewbtrjFTb3nGxvHm
        8p/jTB3p8SPE2l5ey
X-Received: by 2002:a17:906:9516:: with SMTP id u22mr35503418ejx.442.1625055133036;
        Wed, 30 Jun 2021 05:12:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1RNet7hJTadLeI9Tsu08HSFKQO+PCkN7Ksy3Me0p9lWphUkAZUHtlvFpAt4l+roFjoyUJXw==
X-Received: by 2002:a17:906:9516:: with SMTP id u22mr35503385ejx.442.1625055132807;
        Wed, 30 Jun 2021 05:12:12 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id b17sm3361405edd.58.2021.06.30.05.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:12:12 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:12:09 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 08/16] af_vsock: change SEQPACKET receive loop
Message-ID: <CAGxU2F5XtfKJ9cnK=J-gz4uW0AR9FsMc1Dq2jQx=dPGLRC+NTQ@mail.gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100331.571056-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628100331.571056-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 01:03:28PM +0300, Arseny Krasnov wrote:
>Receive "loop" now really loop: it reads fragments one by
>one, sleeping if queue is empty.
>
>NOTE: 'msg_ready' pointer is not passed to 'seqpacket_dequeue()'
>here - it change callback interface, so it is moved to next patch.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 31 ++++++++++++++++++++++---------
> 1 file changed, 22 insertions(+), 9 deletions(-)

I think you can merge patches 8, 9, and 10 together since we
are touching the seqpacket_dequeue() behaviour.

Then you can remove in separate patches the unneeded parts (e.g.
seqpacket_has_data, msg_count, etc.).

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 59ce35da2e5b..9552f05119f2 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2003,6 +2003,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>                                    size_t len, int flags)
> {
>       const struct vsock_transport *transport;
>+      bool msg_ready;
>       struct vsock_sock *vsk;
>       ssize_t record_len;
>       long timeout;
>@@ -2013,23 +2014,36 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>       transport = vsk->transport;
>
>       timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>+      msg_ready = false;
>+      record_len = 0;
>
>-      err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
>-      if (err <= 0)
>-              goto out;
>+      while (!msg_ready) {
>+              ssize_t fragment_len;
>+              int intr_err;
>
>-      record_len = transport->seqpacket_dequeue(vsk, msg, flags);
>+              intr_err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
>+              if (intr_err <= 0) {
>+                      err = intr_err;
>+                      break;
>+              }
>
>-      if (record_len < 0) {
>-              err = -ENOMEM;
>-              goto out;
>+              fragment_len = transport->seqpacket_dequeue(vsk, msg, flags);
>+
>+              if (fragment_len < 0) {
>+                      err = -ENOMEM;
>+                      break;
>+              }
>+
>+              record_len += fragment_len;
>       }
>
>       if (sk->sk_err) {
>               err = -sk->sk_err;
>       } else if (sk->sk_shutdown & RCV_SHUTDOWN) {
>               err = 0;
>-      } else {
>+      }
>+
>+      if (msg_ready && !err) {
>               /* User sets MSG_TRUNC, so return real length of
>                * packet.
>                */
>@@ -2045,7 +2059,6 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>                       msg->msg_flags |= MSG_TRUNC;
>       }
>
>-out:
>       return err;
> }
>
>--
>2.25.1
>

