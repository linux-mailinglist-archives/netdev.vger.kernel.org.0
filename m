Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B762410C0B7
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 00:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfK0Xkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 18:40:35 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32820 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfK0Xkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 18:40:35 -0500
Received: by mail-lf1-f65.google.com with SMTP id d6so18574409lfc.0
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 15:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=p7axeNoTAof088gM7pzbSHLI6Q/IQavsCGxKE7DXG/U=;
        b=EyY2nlfReMtFjJhWIYjXR2lZFGKN4Zxf+p2xXXwuUeYE/thGc7BcZYIsa+r4Hf8mnd
         TKBLZ15GD+6CKe2qkfeSo8KkpsN3/rUtvJtEycKFhjcs67kO0LTOGnGXVSE+jOJFLVv/
         WS6LWthjkpLLyBqJO/TZ3sQbkxjzULIuN6tVh9rUJf31RKjLaVvoD0RaqL6pzbADkd8j
         aakeWcKVvnSeZKIKXqRh3zjZi5ERGoFEoIRXukGrxQY+JQmiTGZ65UM3qocrIYOstl27
         FWYyWPDSKnQE/qyeeZFSrEdRD3IxCnNqDoeoI/h0GPmcnmsjUUeWu7xpf2+CCuPQDiUc
         7XCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=p7axeNoTAof088gM7pzbSHLI6Q/IQavsCGxKE7DXG/U=;
        b=OkYMdf3lZCvBon33XM2AGC8bzuCTYT2Gnxg9QmBMNFig9RQcPuMUTeowzM93xXs8AW
         EXqNlJ7NrIIpeU4C6CxH8z/ePzd59shmlpT+uBwuh4E1vl3eVSsuKTqDG2wE0rETNSpg
         pwQji99Y4264vg2XMyfQRC35S6cSf+8C32PK2u/ilZOwUkZR/CYmpI4R9e6iKWWr6m0h
         nKWrdrfFJcIb/6DZsUXfJnZfbf/o3HuMUnqutQYLtocnd7YzCsXV2C+06URZbRY2P/Bz
         4F0kiPN1V56YEkboj8BiFNhjQV6BfA+nq5ShS38L8MRUWGk1sowwBGldCAs3PMm1A6Kz
         C0bQ==
X-Gm-Message-State: APjAAAWW7Vnk56Gjwa+qwBUZG3KQLkjEtCQq2WmCHRyX4hO0mGPBbdl1
        bTDRZTJ7w24v7B9CRivw78ZShA==
X-Google-Smtp-Source: APXvYqxHUECno26xNrBVPfFt+5AMB/6kpfKtdY093O3UHDC9X/C0eO6xU3lDRl+QXYtjPWxzJz4u4Q==
X-Received: by 2002:a19:e343:: with SMTP id c3mr4626704lfk.192.1574898033168;
        Wed, 27 Nov 2019 15:40:33 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q13sm317527ljc.17.2019.11.27.15.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 15:40:32 -0800 (PST)
Date:   Wed, 27 Nov 2019 15:40:14 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC net-next 00/18] virtio_net XDP offload
Message-ID: <20191127154014.2b91ecc2@cakuba.netronome.com>
In-Reply-To: <20191127152653-mutt-send-email-mst@kernel.org>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
        <20191126123514.3bdf6d6f@cakuba.netronome.com>
        <20191127152653-mutt-send-email-mst@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Nov 2019 15:32:17 -0500, Michael S. Tsirkin wrote:
> On Tue, Nov 26, 2019 at 12:35:14PM -0800, Jakub Kicinski wrote:
> > On Tue, 26 Nov 2019 19:07:26 +0900, Prashant Bhole wrote:  
> > > Note: This RFC has been sent to netdev as well as qemu-devel lists
> > > 
> > > This series introduces XDP offloading from virtio_net. It is based on
> > > the following work by Jason Wang:
> > > https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net
> > > 
> > > Current XDP performance in virtio-net is far from what we can achieve
> > > on host. Several major factors cause the difference:
> > > - Cost of virtualization
> > > - Cost of virtio (populating virtqueue and context switching)
> > > - Cost of vhost, it needs more optimization
> > > - Cost of data copy
> > > Because of above reasons there is a need of offloading XDP program to
> > > host. This set is an attempt to implement XDP offload from the guest.  
> > 
> > This turns the guest kernel into a uAPI proxy.
> > 
> > BPF uAPI calls related to the "offloaded" BPF objects are forwarded 
> > to the hypervisor, they pop up in QEMU which makes the requested call
> > to the hypervisor kernel. Today it's the Linux kernel tomorrow it may 
> > be someone's proprietary "SmartNIC" implementation.
> > 
> > Why can't those calls be forwarded at the higher layer? Why do they
> > have to go through the guest kernel?  
> 
> Well everyone is writing these programs and attaching them to NICs.

Who's everyone?

> For better or worse that's how userspace is written.

HW offload requires modifying the user space, too. The offload is not
transparent. Do you know that?

> Yes, in the simple case where everything is passed through, it could
> instead be passed through some other channel just as well, but then
> userspace would need significant changes just to make it work with
> virtio.

There is a recently spawned effort to create an "XDP daemon" or
otherwise a control application which would among other things link
separate XDP apps to share a NIC attachment point.

Making use of cloud APIs would make a perfect addition to that.

Obviously if one asks a kernel guy to solve a problem one'll get kernel
code as an answer. And writing higher layer code requires companies to
actually organize their teams and have "full stack" strategies.

We've seen this story already with net_failover wart. At least that
time we weren't risking building a proxy to someone's proprietary FW.

> > If kernel performs no significant work (or "adds value", pardon the
> > expression), and problem can easily be solved otherwise we shouldn't 
> > do the work of maintaining the mechanism.
> > 
> > The approach of kernel generating actual machine code which is then
> > loaded into a sandbox on the hypervisor/SmartNIC is another story.  
> 
> But that's transparent to guest userspace. Making userspace care whether
> it's a SmartNIC or a software device breaks part of virtualization's
> appeal, which is that it looks like a hardware box to the guest.

It's not hardware unless you JITed machine code for it, it's just
someone else's software.

I'm not arguing with the appeal. I'm arguing the risk/benefit ratio
doesn't justify opening this can of worms.

> > I'd appreciate if others could chime in.  
