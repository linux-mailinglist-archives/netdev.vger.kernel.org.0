Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474C22E6CF4
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 02:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgL2BPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 20:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgL2BPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 20:15:46 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87574C0613D6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:15:06 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id t15so3888289ual.6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SbqLbRke1/tZuT48N3REwNxRIKEJD5OV/xAoIFM8zPA=;
        b=APQZkNtmSnxPxncNFX+uV5nTlgaL27xMv+FNab7qQutiv+XT6IDinNb0ibB7l2gTjH
         FlQ6Nm0s6n+LR4ehsY1qNSgiRjuZ0KbPOiE4NWHixilX4rvCLoqQezvQ7PAf2VPTuAgG
         l2RuOScZF+TIv/WW7ACCvADR+MEcRjVIfqNgIZwVpyRWRL9eJiEtnOfR3rnq2XZpE2aS
         1nxvS7lAGBH+n7XPZxr1Sy1tBedh0PBw5vOvQCz4cUjDQw7fxlc8sVxFNapyl17G5hxt
         oaakEi1Dutovh9YK7j4BlVRElK6yT0lK/i11CYbBZasovMIlNXoy2zSv1yTHdHkzteY9
         eSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SbqLbRke1/tZuT48N3REwNxRIKEJD5OV/xAoIFM8zPA=;
        b=mZfbtNvxShE4IMf26hZ56HKuuOf/SUrvI4Df/AhRCkcKS3qJTBN8YXaHiXJ/yowfcH
         YrtThSPYgAFWi118nw4Wgq1cN+k5Txr1LECZf4K/lcBqznl0hEDcz2fFY2XPE2m0Q5eM
         sRkoo1Uyk6rFrze603vhjgqvgBA3l6yWpYx/qbmSVTV4W8tM1aNpTPDL25usR/cw1JXD
         DT3KBgxhMIi7OO9lhE8NHSDmQ7HU+TMmdwIQgQiU8iUsH2EWBPsC3ZD1vPRw0XzcFU47
         6Wxer/H5ISxAzUcmT0uzq/Tkw3/DrkPttkM3fGcBzSPm+rXTdD2gKtUwBQd+8RGhHRPH
         eVDw==
X-Gm-Message-State: AOAM530oULDorQVgxxaG2vlBYvCjti9iemeKwrkT/dRXtEveIx2eGoZE
        rScwexe4EPdsVHjRCmD41z9z/8aX3e8=
X-Google-Smtp-Source: ABdhPJxz1zG2b3yTuFX2W4+iJaXQ3P6i+8CXa7XFk+np42qolcle8p3LHrNrHYJaEkzGTmd/scYZgQ==
X-Received: by 2002:ab0:2052:: with SMTP id g18mr29882930ual.60.1609204504838;
        Mon, 28 Dec 2020 17:15:04 -0800 (PST)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id n190sm2303993vsc.22.2020.12.28.17.15.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 17:15:03 -0800 (PST)
Received: by mail-ua1-f49.google.com with SMTP id k47so3900842uad.1
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:15:03 -0800 (PST)
X-Received: by 2002:a9f:2356:: with SMTP id 80mr29925448uae.92.1609204503328;
 Mon, 28 Dec 2020 17:15:03 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228122911-mutt-send-email-mst@kernel.org> <CA+FuTScXQ0U1+rFFpKxB1Qn73pG8jmFuujONov_9yEEKyyer_g@mail.gmail.com>
 <20201228163809-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201228163809-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Dec 2020 20:14:26 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdEqk8gxptnOSpNnm6YPSJv=62wKHqe4GbVAiKQRUfmXQ@mail.gmail.com>
Message-ID: <CA+FuTSdEqk8gxptnOSpNnm6YPSJv=62wKHqe4GbVAiKQRUfmXQ@mail.gmail.com>
Subject: Re: [PATCH rfc 0/3] virtio-net: add tx-hash, rx-tstamp and tx-tstamp
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 7:47 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 28, 2020 at 02:51:09PM -0500, Willem de Bruijn wrote:
> > On Mon, Dec 28, 2020 at 12:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Dec 28, 2020 at 11:22:30AM -0500, Willem de Bruijn wrote:
> > > > From: Willem de Bruijn <willemb@google.com>
> > > >
> > > > RFC for three new features to the virtio network device:
> > > >
> > > > 1. pass tx flow hash and state to host, for routing + telemetry
> > > > 2. pass rx tstamp to guest, for better RTT estimation
> > > > 3. pass tx tstamp to host, for accurate pacing
> > > >
> > > > All three would introduce an extension to the virtio spec.
> > > > I assume this would require opening three ballots against v1.2 at
> > > > https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio
> > > >
> > > > This RFC is to informally discuss the proposals first.
> > > >
> > > > The patchset is against v5.10. Evaluation additionally requires
> > > > changes to qemu and at least one back-end. I implemented preliminary
> > > > support in Linux vhost-net. Both patches available through github at
> > > >
> > > > https://github.com/wdebruij/linux/tree/virtio-net-txhash-1
> > > > https://github.com/wdebruij/qemu/tree/virtio-net-txhash-1
> > >
> > > Any data on what the benefits are?
> >
> > For the general method, yes. For this specific implementation, not  yet.
> >
> > Swift congestion control is delay based. It won the best paper award
> > at SIGCOMM this year. That paper has a lot of data:
> > https://dl.acm.org/doi/pdf/10.1145/3387514.3406591 . Section 3.1 talks
> > about the different components that contribute to delay and how to
> > isolate them.
>
> And for the hashing part?

A few concrete examples of error conditions that can be resolved are
mentioned in the commits that add sk_rethink_txhash calls. Such as
commit 7788174e8726 ("tcp: change IPv6 flow-label upon receiving
spurious retransmission"):

"
    Currently a Linux IPv6 TCP sender will change the flow label upon
    timeouts to potentially steer away from a data path that has gone
    bad. However this does not help if the problem is on the ACK path
    and the data path is healthy. In this case the receiver is likely
    to receive repeated spurious retransmission because the sender
    couldn't get the ACKs in time and has recurring timeouts.

    This patch adds another feature to mitigate this problem. It
    leverages the DSACK states in the receiver to change the flow
    label of the ACKs to speculatively re-route the ACK packets.
    In order to allow triggering on the second consecutive spurious
    RTO, the receiver changes the flow label upon sending a second
    consecutive DSACK for a sequence number below RCV.NXT.
"

I don't have quantitative data on the efficacy at scale at hand. Let
me see what I can find. This will probably take some time, at least
until people are back after the holidays. I didn't want to delay the
patch, as the merge window was a nice time for RFC. But agreed that it
deserves stronger justification.
