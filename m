Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E917D103DD1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 15:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731855AbfKTO5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 09:57:30 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37863 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731102AbfKTO5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 09:57:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574261848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/e2L4fQWIbJeH29Bf8OxPRM2k6SA+48XsmsKWLAdNU8=;
        b=DaTCOZ0T7avormhKmjfK8toj9qw7OqE5l57WwZcYMaTZM8U45hBzfSw1rQHOG+CI1UJNXu
        iycay0agqDfqzXOM/dLU/SMF9u1oM0cOJExXR0FK6DMHVOXH+qjvSkB1tmZKW0KFJEaMCp
        4YWJHEvT8OJD3vGYjOuWYPCh+dIlVLc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-nMdpoABiPDWnNhDrcvdjqQ-1; Wed, 20 Nov 2019 09:57:25 -0500
Received: by mail-qt1-f197.google.com with SMTP id s8so926qtq.17
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 06:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WqDORYpJqHQ9F17SzT1sEQBjLsrWPnppxBhytxuFIy4=;
        b=hJFQgQx0S4oq8vA+zwCrtg7LBAL0Cow1cgOiM2G4Iahjb6aoNsvIHtHFKUrvZ6SFtd
         OzpFaQQXJTQ1oCMZ/FLyhpWdDjbX7zJbTGFIVYazh784MCH4210WIo3Z3TLQPJ23j6nW
         8F5fLDHvtr2cRBA/4aX8XUfiG1Vr8uCIA2s9C9ryPoWc/sSy2Mu1OJwA9VXNl71Xlz0g
         xJFRbgyWfUp5E8BqTioi7chOYWBCeifD5F5A1Mw+B/LLxnNm4DuzDRgTBQK8X1t9zS6L
         FUn67e1vLTIwPEFylpjhWsmOy0/MJAHVfoDr3CSMS8/lMFGUeLCiCYYDLe1YYDebB9jB
         4p4A==
X-Gm-Message-State: APjAAAXdyIXP8L1jBlPT8pfpIymwQeVT5dltPzs1KR/t40zaLULNJ/Gt
        C1sabkh+hmU3VqUPyf/0H/v1ow8jqCpV7Rh7yOY3buOEFxNrMR40w/zXPKGTwdaaSTsdQB6DgwC
        V1HjM6XIJKNh15wAY
X-Received: by 2002:a37:6643:: with SMTP id a64mr2892528qkc.144.1574261845192;
        Wed, 20 Nov 2019 06:57:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6JJ9cNfodNG4pgBosP1ZHICUrPMUHOY0gwifDWTQqZF970JqUvdyeDoC863pJc6/AhmD/xw==
X-Received: by 2002:a37:6643:: with SMTP id a64mr2892489qkc.144.1574261844817;
        Wed, 20 Nov 2019 06:57:24 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id z3sm14404597qtu.83.2019.11.20.06.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 06:57:23 -0800 (PST)
Date:   Wed, 20 Nov 2019 09:57:17 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191120093607-mutt-send-email-mst@kernel.org>
References: <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <20191120022141-mutt-send-email-mst@kernel.org>
 <20191120130319.GA22515@ziepe.ca>
 <20191120083908-mutt-send-email-mst@kernel.org>
 <20191120143054.GF22515@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20191120143054.GF22515@ziepe.ca>
X-MC-Unique: nMdpoABiPDWnNhDrcvdjqQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 10:30:54AM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 20, 2019 at 08:43:20AM -0500, Michael S. Tsirkin wrote:
> > On Wed, Nov 20, 2019 at 09:03:19AM -0400, Jason Gunthorpe wrote:
> > > On Wed, Nov 20, 2019 at 02:38:08AM -0500, Michael S. Tsirkin wrote:
> > > > > > I don't think that extends as far as actively encouraging users=
pace
> > > > > > drivers poking at hardware in a vendor specific way. =20
> > > > >=20
> > > > > Yes, it does, if you can implement your user space requirements u=
sing
> > > > > vfio then why do you need a kernel driver?
> > > >=20
> > > > People's requirements differ. You are happy with just pass through =
a VF
> > > > you can already use it. Case closed. There are enough people who ha=
ve
> > > > a fixed userspace that people have built virtio accelerators,
> > > > now there's value in supporting that, and a vendor specific
> > > > userspace blob is not supporting that requirement.
> > >=20
> > > I have no idea what you are trying to explain here. I'm not advocatin=
g
> > > for vfio pass through.
> >=20
> > You seem to come from an RDMA background, used to userspace linking to
> > vendor libraries to do basic things like push bits out on the network,
> > because users live on the performance edge and rebuild their
> > userspace often anyway.
> >=20
> > Lots of people are not like that, they would rather have the
> > vendor-specific driver live in the kernel, with userspace being
> > portable, thank you very much.
>=20
> You are actually proposing a very RDMA like approach with a split
> kernel/user driver design. Maybe the virtio user driver will turn out
> to be 'portable'.
>=20
> Based on the last 20 years of experience, the kernel component has
> proven to be the larger burden and drag than the userspace part. I
> think the high interest in DPDK, SPDK and others show this is a common
> principle.

And I guess the interest in BPF shows the opposite?
I don't see how this kind of argument proves anything.  DPDK/SPDK are
written by a group of developers who care about raw speed and nothing
else. I guess in that setting you want a userspace driver. I know you
work for a hardware company so to you it looks like that's all people
care about.  More power to you, but that need seems to be
addressed by dpdk.
But lots of people would rather have e.g. better security
than a 0.1% faster networking.

> At the very least for new approaches like this it makes alot of sense
> to have a user space driver until enough HW is available that a
> proper, well thought out kernel side can be built.

But hardware is available, driver has been posted by Intel.
Have you looked at that?

So I am not sure it's a good idea to discuss whether code is "proper" or
"so-called", that just does not sound like constructive criticism.
And I think it might be helpful if you look at the code and provide
comments, so far your comments are just on the cover letter and commit
logs. If you look at that you might find your answer to why Alex did not
nak this.

> For instance, this VFIO based approach might be very suitable to the
> intel VF based ICF driver, but we don't yet have an example of non-VF
> HW that might not be well suited to VFIO.
>=20
> Jason

I don't think we should keep moving the goalposts like this.

If people write drivers and find some infrastruture useful,
and it looks more or less generic on the outset, then I don't
see why it's a bad idea to merge it.

*We don't want to decide how to support this hardware, write a userspace dr=
iver*
isn't a reasonable approach IMHO.

--=20
MST

