Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D060D0FC1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 15:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbfJINQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 09:16:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41904 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJINQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 09:16:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id q9so2942296wrm.8;
        Wed, 09 Oct 2019 06:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NqNWhKNuCxFUkqS6MSW/V4hcC4NeZ3p7cRwpDVaRvJU=;
        b=RZx/O7qMfkNbDIazZ56VS7ESeE2Z2sLtUueTWwQkf7SSsC3l8tYZzyA/zENcCZu5V7
         Xkh5tMeMIroML0fjI/u88dqhMAER0sSvU2/NZO4s6hWZKWwoQHR7H5d2jVhAZBQ9JUE9
         k/d5jIxtHEdcwfxQpVJ7gse++fkOhKrysRGRuqQt8IkMF5MTz6nw6t/sknS82VcWmxOU
         /5+z1EGFMKdlCbKg8etnls7MfwpreLW+oMaVAikKJ4E5EdYIYjKbZHXlmso3VgwUVcoL
         2WVVAuIWPrvNdUcvDa+bC7yRb6Em2jU09II/RlPt9E5r4uJ9kOc68WKqTw2iL3hG4tee
         nU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NqNWhKNuCxFUkqS6MSW/V4hcC4NeZ3p7cRwpDVaRvJU=;
        b=eN+ETgUgEuZsbC28moWVT7hblRRIEmDN8xqZj0/HkySzt4c+z6hg6/MdBHC2Ll4tYx
         UeTZTLxeE2V1ZSx/cKKdIszz3AUv3/2ZvRmrFuBdhCcw05R04xFU1cOGFW8N9zoosyVi
         tKE5/lsymtxqEquTW8rJhfUhYl9T46rxLDjBVn4mk4ZgMaau4JzuRsFUNZH7N7OPplzC
         QQ1W32OSq/lUxbibSstOc02o+kt67GhjTht/J7Ohx+Jiufe8hFFBeKDI+nEv+h7MfHFw
         /5b0SSwNn8KLiXdZxdE4bYqaQ1s+1ypRV2wIw3A9bD8TnygOBFDKvV8TyAbs2anLrbE0
         L/Mg==
X-Gm-Message-State: APjAAAXN0Gcbm3UbHZGAG55TmjKSThP41wKSq7KkFBtpsHk8W+82XFp/
        B2yS9PFyxaMnMINlSdmo1qIAFMB2MLM=
X-Google-Smtp-Source: APXvYqynU7qFd7yDda1viaOJp3TtU+OF6WkbTnfJ4JhjvUDrcR6isTKKdN0nskgcBotiInIqXq9Pgw==
X-Received: by 2002:a5d:6ad0:: with SMTP id u16mr2810067wrw.313.1570627005754;
        Wed, 09 Oct 2019 06:16:45 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id z9sm2771325wrl.35.2019.10.09.06.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 06:16:44 -0700 (PDT)
Date:   Wed, 9 Oct 2019 14:16:43 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 11/13] vsock: add 'transport_hg' to handle g2h\h2g
 transports
Message-ID: <20191009131643.GL5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-12-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1hKfHPzOXWu1rh0v"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-12-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1hKfHPzOXWu1rh0v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2019 at 01:27:01PM +0200, Stefano Garzarella wrote:
> VMCI transport provides both g2h and h2g behaviors in a single
> transport.
> We are able to set (or not) the g2h behavior, detecting if we
> are in a VMware guest (or not), but the h2g feature is always set.
> This prevents to load other h2g transports while we are in a
> VMware guest.

In the vhost_vsock.ko case we only register the h2g transport when
userspace has loaded the module (by opening /dev/vhost-vsock).

VMCI has something kind of similar: /dev/vmci and the
vmci_host_active_users counter.  Maybe we can use this instead of
introducing the transport_hg concept?

--1hKfHPzOXWu1rh0v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2d3bsACgkQnKSrs4Gr
c8iGmQf8CrTUBmiSd3MH3EamjJ8bZk3tA9Ej+1ywL//u+F4Qx3lKOoX+rWnMK5O0
pkoMAUGpvkKpC23xoV8gFfS9jtRax71aGCjFHnCDj6AoIOu/EwdqWTN28DjF0pF/
v2D3y2FJtItZeyB2JxnV/ouq9wnglcYDXuvVzwlIGvQi7cV2pj4TyVUzo55Qbtqb
+pbmGCQ845YsfBrmNGA28L7r7OiGp0XCXkrNiTpmgBvQpkUiYg5sKxbWZQj13dKU
UMBAQV8O4rNjJuEW/9oGehzTzq7JqwiA0TPRGlqkdfovgqA3m0dvSAVbZm/D74al
Y7NuoOX5k8zZlatP7hk+KQoph/MKrg==
=Wk8M
-----END PGP SIGNATURE-----

--1hKfHPzOXWu1rh0v--
