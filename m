Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843EB104647
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfKTWFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:05:11 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54512 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726038AbfKTWFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 17:05:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574287510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4YpMbJX5XyxRp8q7h/jm7rfnus2WLxi2XgTkFPCvRSw=;
        b=BgICZNakp9UJkI95K9ANlTaCed9PRBFxMH/3uCeNXOrXekyh08WN32/6Y0jR6B6V9ehrH2
        H8u1mKSbXxtmlVEFEsduXkd31JuFiYLSebYgA0qMuORP+ZidU6/Vmc5CzqtZIDyu5CJxO/
        Almz6tBc9c6wOTWocXJDDjeNWhrHaTw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-08AxcJzhNxmHyxwNLVxp5w-1; Wed, 20 Nov 2019 17:05:08 -0500
Received: by mail-qv1-f69.google.com with SMTP id b1so843052qvm.0
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 14:05:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ix0u7hdNyTJABkb8oloHDZIWR+Nd0ngaOCu5R4X4iSI=;
        b=aGAuwDfVjtG7JZWfRCzgOrf2iNmgDjsNRoHZlglMkzBV+ZRX1v51X5gFPJx5FZcr8H
         /CvrG1vS7hI75FvbyswVebpJlq8PYgrN7T+YOC8bQiUE/Fs1fBp9Sc9IgNPeSAs0IxdI
         3J0qlSzdGhc9deV4enATTv23hVHfEVCiZiO7+Tps8a7y8HDSM7ie4j4E7DQLLaoCpzqo
         TgRj8Qrs6RmzQOMh4r81Ogn9B3exnPZP/OYUF1qPQmLUzGZL2oTUte9xp5Zqr8vFLc+B
         SVn6Ts1BBi/Kv20kEVX3rEi7pcw+LGtpeeZUbJ09e0/Af3tThiAGgqNQXYBmt7RQUyD6
         E2HA==
X-Gm-Message-State: APjAAAUIBGZ8xWi+OSqeQVY79p89U6q1sAgI3ofrk+Zf7gm43OcTl9YA
        4dk1XjCqV1flz09zpZ2s42pjPDxhAt/sZCDVNlA+2w4Y3tOkHBj5c8uoCeXHHVdhiJdztRkAA28
        TDudezCSCjqCzdNwU
X-Received: by 2002:ac8:51c3:: with SMTP id d3mr5040947qtn.14.1574287508113;
        Wed, 20 Nov 2019 14:05:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqxdsih9DHA5lFir/c/3IJa6bxqZOBG7X8LxPArtXfaUgPz+4d3X0P+nI2I9fnkkPKWKJeAeIg==
X-Received: by 2002:ac8:51c3:: with SMTP id d3mr5040914qtn.14.1574287507889;
        Wed, 20 Nov 2019 14:05:07 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id i75sm353431qke.22.2019.11.20.14.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 14:05:06 -0800 (PST)
Date:   Wed, 20 Nov 2019 17:05:00 -0500
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
Message-ID: <20191120165748-mutt-send-email-mst@kernel.org>
References: <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <20191120022141-mutt-send-email-mst@kernel.org>
 <20191120130319.GA22515@ziepe.ca>
 <20191120083908-mutt-send-email-mst@kernel.org>
 <20191120143054.GF22515@ziepe.ca>
 <20191120093607-mutt-send-email-mst@kernel.org>
 <20191120164525.GH22515@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20191120164525.GH22515@ziepe.ca>
X-MC-Unique: 08AxcJzhNxmHyxwNLVxp5w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 12:45:25PM -0400, Jason Gunthorpe wrote:
> > > For instance, this VFIO based approach might be very suitable to the
> > > intel VF based ICF driver, but we don't yet have an example of non-VF
> > > HW that might not be well suited to VFIO.
> >
> > I don't think we should keep moving the goalposts like this.
>=20
> It is ABI, it should be done as best we can as we have to live with it
> for a long time. Right now HW is just starting to come to market with
> VDPA and it feels rushed to design a whole subsystem style ABI around
> one, quite simplistic, driver example.

Well one has to enable hardware in some way. It's not really reasonable
to ask for multiple devices to be available just so there's a driver and
people can use them. At this rate no one will want to be the first to
ship new devices ;)

> > If people write drivers and find some infrastruture useful,
> > and it looks more or less generic on the outset, then I don't
> > see why it's a bad idea to merge it.
>=20
> Because it is userspace ABI, caution is always justified when defining
> new ABI.


Reasonable caution, sure. Asking Alex to block Intel's driver until
someone else catches up and ships competing hardware isn't reasonable
though. If that's your proposal I guess we'll have to agree to disagree.

--=20
MST

