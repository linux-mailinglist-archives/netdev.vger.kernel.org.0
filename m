Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1AF10B76C
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfK0Uca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:32:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22446 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726716AbfK0Uca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:32:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574886749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zH/T5jU4tH/8Gb+1qmuFB+rSdeHGBSoJ0BA6rM2mcnc=;
        b=S1ekSSoONW6WJ38wUMM7o0k/VTEavatvgWPE/oNWWSnrxmz+I8CqgKLZP24neXT74HScJG
        UrrAddVG7awCIO+vxSQB82T1uFxagtnd7Y4Kr743RqkaS24UxO+uNdCUQb8WLcwu2HzD2k
        28BTKeztYyKCBEU0aqbVYBX5tUN4A7g=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-kz4BgrnIOPyu8xS1apbq_w-1; Wed, 27 Nov 2019 15:32:25 -0500
Received: by mail-qt1-f198.google.com with SMTP id f14so15576389qto.2
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:32:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7MY+sx+Nuv189evu6jc/7Ff6+j+qSUxD3qsuDjudl3E=;
        b=o07Ku7ylapJvWVzQyTsvDVgFRcNdPba57iwnoJWEOPbcc9GzvniQEhyVaTQjM/yPyo
         gJp5vot22kM9Hfjenrhaj6VvYED5vPkYmTniaMWahOHVqZPzdlRumlaAZKoZGrGIT9tf
         OyFg13VPpe0PVMP/Nntn1DVQrO6GlpkqvIUr794fiXJ8u4ApUGs58WHqyQxxBVGU/qpf
         +F5820KLenmnaaQG+4WUQLJE9zUVRC2WbKXAz/fOrHEjODIdVmwAmEGVjaAVmBlxsEDl
         k/xmg0LeQTw/74nTnz5K79Ok2zueMGVCaihtu3BUkECJbgqV2+a34kfTS7o0vWL+lkjU
         PUtg==
X-Gm-Message-State: APjAAAXctSv5Zn+15N2ZmoZ89HHw/S5tdy1M6vOFYrzxa7lTMj87CycO
        SeH1EGE2WqFpS1fRZ5Q5lyAHbjZUdDvm/Yz/NSQatBIgIfVWxiae8vDMQsEd/OllG9Vis6UWAD1
        0U9nIF8kBqu0AyugG
X-Received: by 2002:ad4:55e8:: with SMTP id bu8mr3198574qvb.61.1574886745490;
        Wed, 27 Nov 2019 12:32:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqzOaXOFxvrAACGTJt/FeYHy85AqcOBKnTlQND1DqS/Jm+RE0uTl1tA+4+iDEbGw4t6w2fwm7A==
X-Received: by 2002:ad4:55e8:: with SMTP id bu8mr3198538qvb.61.1574886745141;
        Wed, 27 Nov 2019 12:32:25 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id o70sm7418083qke.47.2019.11.27.12.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 12:32:24 -0800 (PST)
Date:   Wed, 27 Nov 2019 15:32:17 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
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
Message-ID: <20191127152653-mutt-send-email-mst@kernel.org>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126123514.3bdf6d6f@cakuba.netronome.com>
MIME-Version: 1.0
In-Reply-To: <20191126123514.3bdf6d6f@cakuba.netronome.com>
X-MC-Unique: kz4BgrnIOPyu8xS1apbq_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 12:35:14PM -0800, Jakub Kicinski wrote:
> On Tue, 26 Nov 2019 19:07:26 +0900, Prashant Bhole wrote:
> > Note: This RFC has been sent to netdev as well as qemu-devel lists
> >=20
> > This series introduces XDP offloading from virtio_net. It is based on
> > the following work by Jason Wang:
> > https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net
> >=20
> > Current XDP performance in virtio-net is far from what we can achieve
> > on host. Several major factors cause the difference:
> > - Cost of virtualization
> > - Cost of virtio (populating virtqueue and context switching)
> > - Cost of vhost, it needs more optimization
> > - Cost of data copy
> > Because of above reasons there is a need of offloading XDP program to
> > host. This set is an attempt to implement XDP offload from the guest.
>=20
> This turns the guest kernel into a uAPI proxy.
>=20
> BPF uAPI calls related to the "offloaded" BPF objects are forwarded=20
> to the hypervisor, they pop up in QEMU which makes the requested call
> to the hypervisor kernel. Today it's the Linux kernel tomorrow it may=20
> be someone's proprietary "SmartNIC" implementation.
>=20
> Why can't those calls be forwarded at the higher layer? Why do they
> have to go through the guest kernel?

Well everyone is writing these programs and attaching them to NICs.

For better or worse that's how userspace is written.

Yes, in the simple case where everything is passed through, it could
instead be passed through some other channel just as well, but then
userspace would need significant changes just to make it work with
virtio.



> If kernel performs no significant work (or "adds value", pardon the
> expression), and problem can easily be solved otherwise we shouldn't=20
> do the work of maintaining the mechanism.
>=20
> The approach of kernel generating actual machine code which is then
> loaded into a sandbox on the hypervisor/SmartNIC is another story.

But that's transparent to guest userspace. Making userspace care whether
it's a SmartNIC or a software device breaks part of virtualization's
appeal, which is that it looks like a hardware box to the guest.

> I'd appreciate if others could chime in.

