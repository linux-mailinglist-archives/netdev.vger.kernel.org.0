Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26B2EC4F4
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 21:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbhAFUeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 15:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbhAFUeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 15:34:08 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2913C061575
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 12:33:27 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c7so5611531edv.6
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 12:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xgy3DNQexECKB+SL5FKqq5xsmsJH3tjYPP1oRbD9jII=;
        b=NiqSAmNXeWDM4T6nGCpMwGLt8Be0VxkzXj0Bxth1MPWCPkb6xoHrW3lDueQl8dlSAD
         PPng7wf42XRIjlaLiabH2ddUkvRpvufHvHlWv0IClmDgjr8hlXgG3jNduAXEpS7Gj0J0
         VbokGxt7VJpHaIRX3u0PSufeo4BX6A0rS/Nt6U5bSNXNHGy7zW9YOQt8oKS9izdPnia3
         o8elmGDfxV3OJFkOuI3FUHRWf6lFaBHDTV6LfzlBQXyEqk7uf3IIDDJ7h95YviKwbO0g
         set+YvtysdfavWJoGw8nldnNz7t8AwnV5Q44SPVNNwSwd0k2vpFKJ6iwMtgi1mAMMiMf
         9vnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xgy3DNQexECKB+SL5FKqq5xsmsJH3tjYPP1oRbD9jII=;
        b=Qzai/dm+2biAwtwFXXQSjmiZhB00UzbomIyQjn0f8vs7Ub/Zhn+OINh/RJW1dM4QK2
         VkZYXCphOeGi3/hE8iHFgAyod3z9n5OolGrVY1gnDRQlS45h9Xj52XCgp1HEynFhFU+j
         m7otsVyhzZ+mSH/FCH64sZ24fQIUg0RJqrkGYl2QRAViF3Pim4MEG9G+q1lJiEAUi69J
         SnpqDD2336ct44NncViv0UAl9A2ejTbYAt8tJHfMFDc3kM4lIqvNDhX8hp4zK8s3qcNI
         OFVnUv4q8gZL3oYvv3up+URovYNG7n7yva1CTs0R1S+RcxFi6ICQS+OQLugTimcl7n1l
         +9OA==
X-Gm-Message-State: AOAM532V+ihyg7kyOfAH+f2iUqYbIGceR3Q5v/FTDaMomU+70QG4JBIy
        LuGA1ScDNO6s6iXXJZ6xorvBnQ3L3GMdryf2bhw=
X-Google-Smtp-Source: ABdhPJyTPhYfvO6fTENOiywBZ+EY93uQ0G8gs2t6CeI71eeiWAWzNReR9wfka39pPjXTLEkyaX0wGmht+sdzd5Opqiw=
X-Received: by 2002:a05:6402:350:: with SMTP id r16mr5025422edw.176.1609965206530;
 Wed, 06 Jan 2021 12:33:26 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228122911-mutt-send-email-mst@kernel.org> <CA+FuTScXQ0U1+rFFpKxB1Qn73pG8jmFuujONov_9yEEKyyer_g@mail.gmail.com>
 <20201228163809-mutt-send-email-mst@kernel.org> <CA+FuTSdEqk8gxptnOSpNnm6YPSJv=62wKHqe4GbVAiKQRUfmXQ@mail.gmail.com>
In-Reply-To: <CA+FuTSdEqk8gxptnOSpNnm6YPSJv=62wKHqe4GbVAiKQRUfmXQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 6 Jan 2021 15:32:51 -0500
Message-ID: <CAF=yD-Lcad6Sw6zkQGrCqck+s3rit-m6FLL6th9=G2pZOr=1Gw@mail.gmail.com>
Subject: Re: [PATCH rfc 0/3] virtio-net: add tx-hash, rx-tstamp and tx-tstamp
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 8:15 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Dec 28, 2020 at 7:47 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Dec 28, 2020 at 02:51:09PM -0500, Willem de Bruijn wrote:
> > > On Mon, Dec 28, 2020 at 12:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Dec 28, 2020 at 11:22:30AM -0500, Willem de Bruijn wrote:
> > > > > From: Willem de Bruijn <willemb@google.com>
> > > > >
> > > > > RFC for three new features to the virtio network device:
> > > > >
> > > > > 1. pass tx flow hash and state to host, for routing + telemetry
> > > > > 2. pass rx tstamp to guest, for better RTT estimation
> > > > > 3. pass tx tstamp to host, for accurate pacing
> > > > >
> > > > > All three would introduce an extension to the virtio spec.
> > > > > I assume this would require opening three ballots against v1.2 at
> > > > > https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio
> > > > >
> > > > > This RFC is to informally discuss the proposals first.
> > > > >
> > > > > The patchset is against v5.10. Evaluation additionally requires
> > > > > changes to qemu and at least one back-end. I implemented preliminary
> > > > > support in Linux vhost-net. Both patches available through github at
> > > > >
> > > > > https://github.com/wdebruij/linux/tree/virtio-net-txhash-1
> > > > > https://github.com/wdebruij/qemu/tree/virtio-net-txhash-1
> > > >
> > > > Any data on what the benefits are?
> > >
> > > For the general method, yes. For this specific implementation, not  yet.
> > >
> > > Swift congestion control is delay based. It won the best paper award
> > > at SIGCOMM this year. That paper has a lot of data:
> > > https://dl.acm.org/doi/pdf/10.1145/3387514.3406591 . Section 3.1 talks
> > > about the different components that contribute to delay and how to
> > > isolate them.
> >
> > And for the hashing part?
>
> A few concrete examples of error conditions that can be resolved are
> mentioned in the commits that add sk_rethink_txhash calls. Such as
> commit 7788174e8726 ("tcp: change IPv6 flow-label upon receiving
> spurious retransmission"):
>
> "
>     Currently a Linux IPv6 TCP sender will change the flow label upon
>     timeouts to potentially steer away from a data path that has gone
>     bad. However this does not help if the problem is on the ACK path
>     and the data path is healthy. In this case the receiver is likely
>     to receive repeated spurious retransmission because the sender
>     couldn't get the ACKs in time and has recurring timeouts.
>
>     This patch adds another feature to mitigate this problem. It
>     leverages the DSACK states in the receiver to change the flow
>     label of the ACKs to speculatively re-route the ACK packets.
>     In order to allow triggering on the second consecutive spurious
>     RTO, the receiver changes the flow label upon sending a second
>     consecutive DSACK for a sequence number below RCV.NXT.
> "
>
> I don't have quantitative data on the efficacy at scale at hand. Let
> me see what I can find. This will probably take some time, at least
> until people are back after the holidays. I didn't want to delay the
> patch, as the merge window was a nice time for RFC. But agreed that it
> deserves stronger justification.

The practical results mirror what the theory suggests: that in the
presence of multiple paths, of which one goes bad, this method
maintains connectivity where otherwise it would disconnect.

When IPv6 FlowLabel was included in path selection (e.g., LAG/ECMP),
flowlabel rotation on TCP timeout avoided the vast majority of TCP
disconnections that would otherwise have occurred during to link
failures in long-haul backbones, when an alternative path was
available.

So it's not a matter of percentages, just the existence of an
alternative healthy path on which the packets will eventually land
quite deterministically as it rotates the txhash on each timeout.

This method can be deployed based on a variety of "bad connection"
signals. Besides timeouts, the aforementioned spurious retransmits,
for one. This TCP connection-level information can independent of
flowlabel rotation be valuable information to the cloud provider to
detect and pinpoint network issues. As mentioned before, ideally we
can pass along such details of the type of signal along with the hash.
But that also requires passing that state in the guest from the TCP
layer to the virtio-net device. So left for separate later work. For
now we just have the reserved space in the header.

Michael, what is the best way to proceed with this? Send the patches
for review to net-next, or should I start by opening ballots to
https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio
first? Thanks.
