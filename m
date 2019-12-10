Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39D3118AF6
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfLJOdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:33:01 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27063 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727502AbfLJOc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 09:32:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575988378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oltekNksYL0JppEwk+sb0PIOexNRJT7sk8bU9jqVsg4=;
        b=hvsxfjmMoitupznPbVPVO//BXYXSHKyMsIxtCys1WOlZ2B9L70Y6M2zw8DPC/vpRluwlC2
        rz3q65bzM6vutyLKPIWTpOSJuqm3nttyKJgSZ/skpj4C9DEP8q5SOK3boV+BQqOWv5hNaQ
        m2j76VCWYKO5z8avRj49Cq0iK1hMTo0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-TIQn62CtNIOt19INVVzP5w-1; Tue, 10 Dec 2019 09:32:55 -0500
Received: by mail-wr1-f71.google.com with SMTP id b13so9007179wrx.22
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 06:32:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZX5clcawRs9HvyErreGyUr6byz6y4hiLe4x5yy5XB+w=;
        b=RmpCaTH70QTCs0wpHAu/+lQi9y6dyu+cjuFtzYaOdExsYBFTZsPkPZOPjB3dJ0XBOz
         fj8uFmsuiQQHhNkQKL18Qc9Wtk8h2RudLSqVjoXngTNRYk/15coEVUNNbC9EtbiJMYHJ
         K1Wrbx+3se+E+mJMkxHUVdyttPqpezfPf6Ad28v7rhVGnz2oAbBPG1VKnt5ZaYd0voVg
         30EYRhKCj7uh5NSGg6p7dwjzj2X8JQViDEp1hxGNpyoiIJwqPQW9mBKw9svSG8yMI/Rq
         mTBKcSaCimJ8/z50rhuc7s0h/JdXm2pns9kJjObwREXN1wUcBIkdsDL9JSL6yzs3LXx2
         Vf3g==
X-Gm-Message-State: APjAAAVi1LrMiN6MbkZqkxvYqAisHsWytFmojhl0JOuaRjQz7XKIbDhW
        6WyF04eFG5WkqP5JaPPoVkTQx/SAfJDQZmH/IVv+bhMSy+zGqtY+E/coPN25wkmhcFp2gekiB94
        w3zQLIUxLag5xL0Ub
X-Received: by 2002:a05:600c:2947:: with SMTP id n7mr5228099wmd.156.1575988374114;
        Tue, 10 Dec 2019 06:32:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqx5osq8iXaghf+DSPEJ+fI9zhfAtq/jAq/Ozou/cbeXTMCvexsR8V2x1X6t2Pp1+8eyRY0ljg==
X-Received: by 2002:a05:600c:2947:: with SMTP id n7mr5228075wmd.156.1575988373894;
        Tue, 10 Dec 2019 06:32:53 -0800 (PST)
Received: from steredhat ([95.235.120.92])
        by smtp.gmail.com with ESMTPSA id b185sm3483015wme.36.2019.12.10.06.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 06:32:53 -0800 (PST)
Date:   Tue, 10 Dec 2019 15:32:51 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: accept only packets with the right dst_cid
Message-ID: <20191210143251.szkicty23b6pojxh@steredhat>
References: <20191206143912.153583-1-sgarzare@redhat.com>
 <20191210090505-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20191210090505-mutt-send-email-mst@kernel.org>
X-MC-Unique: TIQn62CtNIOt19INVVzP5w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 09:05:58AM -0500, Michael S. Tsirkin wrote:
> On Fri, Dec 06, 2019 at 03:39:12PM +0100, Stefano Garzarella wrote:
> > When we receive a new packet from the guest, we check if the
> > src_cid is correct, but we forgot to check the dst_cid.
> >=20
> > The host should accept only packets where dst_cid is
> > equal to the host CID.
> >=20
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>=20
> what's the implication of processing incorrect dst cid?
> I think mostly it's malformed guests, right?

Exaclty, as for the src_cid.

In both cases the packet may be delivered to the wrong socket in the
host, because in the virtio_transport_recv_pkt() we are using the
src_cid and dst_cid to look for the socket where to queue the packet.

> Everyone else just passes the known host cid ...

Yes, good guests should do it, and we do it :-)

Thanks,
Stefano

