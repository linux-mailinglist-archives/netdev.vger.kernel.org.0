Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D4D2E6C0A
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgL1Wzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729546AbgL1VkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 16:40:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609191523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X+h6xBZQ8ndgC3VNMVrPXo1dbdTCDoH6RKRNge8RjHo=;
        b=YLBPRb3pUY8QOap9+QIT7eR6Omy1q1owbUXfNjTaVxbuS29fVMIHoZkel1STNDQmHRC8LU
        i3FD/rLf3P0wQiBqkbAHaju8Vi8A+CyvUpaMdk53cPEN2HayXfHxdYXIQSYTs2JcQYNQmc
        GFsozMJ9u1BCR+TxDzhSGkvZPWdr0ms=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-ylghuPj4MaKOPDfH_t2aOQ-1; Mon, 28 Dec 2020 16:38:38 -0500
X-MC-Unique: ylghuPj4MaKOPDfH_t2aOQ-1
Received: by mail-wm1-f70.google.com with SMTP id r5so250045wma.2
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 13:38:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X+h6xBZQ8ndgC3VNMVrPXo1dbdTCDoH6RKRNge8RjHo=;
        b=d68IFOUCbBhYE3RfOy2P+aXBq6TX93q/M3W+j9lBZptzwhkpZJ/+j0L+mj/RaNbk7Q
         bz9DTYRdXpnuNivg2wpnre9KMeQNP/TETWUuGzA49n3CkFN8uVDyJ4pi+T+ggV2Gf2O7
         Y26L9oBdnfsltMv2JJvxxrXgT3mmJjOohC/twC5pkUb0/MTs9kbLVy7qNt0RTADwXoWN
         mCh3VkDXDSoixOWDoqSWnLRdcahASF6/0YUkNrZvfSYQj+4e0ltm52jnuGQc7rpXq4Q2
         sqs+YIxYqX5gPT2JLsi++rMPjKmWQzZJIaBatvsuoiNM2CRqgmDNsEef+ie3HnGEHP33
         pMqw==
X-Gm-Message-State: AOAM532B/hCofwPO5XNlu+8yIFZJUBgYE96ATDjJpITEZNEwZFQEtgcr
        kN82XNtoWbpgdcF6sCYF+qfjhnhbz+Wf1dKhloWSIVq6lS4NprcSXEYIaoLnTAHpMpcJxTaFYAi
        neT4Mn9OKvhzLRBLG
X-Received: by 2002:a1c:2586:: with SMTP id l128mr712220wml.78.1609191517158;
        Mon, 28 Dec 2020 13:38:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLvHKsMhRWVlc2v2JHTTq6/C+o0cYwmf6h/6sEiwqjtzKc8WKyVPgo5VIW58g/+CS4LJb6Ng==
X-Received: by 2002:a1c:2586:: with SMTP id l128mr712211wml.78.1609191516992;
        Mon, 28 Dec 2020 13:38:36 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id c20sm707561wmb.38.2020.12.28.13.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 13:38:36 -0800 (PST)
Date:   Mon, 28 Dec 2020 16:38:33 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH rfc 0/3] virtio-net: add tx-hash, rx-tstamp and tx-tstamp
Message-ID: <20201228163809-mutt-send-email-mst@kernel.org>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228122911-mutt-send-email-mst@kernel.org>
 <CA+FuTScXQ0U1+rFFpKxB1Qn73pG8jmFuujONov_9yEEKyyer_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTScXQ0U1+rFFpKxB1Qn73pG8jmFuujONov_9yEEKyyer_g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 02:51:09PM -0500, Willem de Bruijn wrote:
> On Mon, Dec 28, 2020 at 12:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Dec 28, 2020 at 11:22:30AM -0500, Willem de Bruijn wrote:
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > RFC for three new features to the virtio network device:
> > >
> > > 1. pass tx flow hash and state to host, for routing + telemetry
> > > 2. pass rx tstamp to guest, for better RTT estimation
> > > 3. pass tx tstamp to host, for accurate pacing
> > >
> > > All three would introduce an extension to the virtio spec.
> > > I assume this would require opening three ballots against v1.2 at
> > > https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio
> > >
> > > This RFC is to informally discuss the proposals first.
> > >
> > > The patchset is against v5.10. Evaluation additionally requires
> > > changes to qemu and at least one back-end. I implemented preliminary
> > > support in Linux vhost-net. Both patches available through github at
> > >
> > > https://github.com/wdebruij/linux/tree/virtio-net-txhash-1
> > > https://github.com/wdebruij/qemu/tree/virtio-net-txhash-1
> >
> > Any data on what the benefits are?
> 
> For the general method, yes. For this specific implementation, not  yet.
> 
> Swift congestion control is delay based. It won the best paper award
> at SIGCOMM this year. That paper has a lot of data:
> https://dl.acm.org/doi/pdf/10.1145/3387514.3406591 . Section 3.1 talks
> about the different components that contribute to delay and how to
> isolate them.

And for the hashing part?

> BBR and BBRv2 also have an explicit ProbeRTT phase as part of the design.
> 
> The specific additional benefits for VM-based TCP depends on many
> conditions, e.g., whether a vCPU is exclusively owned and pinned. But
> the same reasoning should be even more applicable to this even longer
> stack, especially in the worst case conditions.

