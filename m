Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368EFE6324
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 15:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfJ0One (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 10:43:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42530 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfJ0Onc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 10:43:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so7217328wrs.9;
        Sun, 27 Oct 2019 07:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YTHjpx5tynN5ysNBWnDF8q0AZsL3oz0jYtEIvTs3UB8=;
        b=nywAXHaYFmYMIY+hAOelcPD7dFa0WvtZ4hopNPXAcgcSOOWBR3qexe4p3jR+opMRem
         lCugMtCFnPAa3bYeCi5XUQ9nsJjqAlyMBdtErBu6QfX4HiRClOJ9XlX/YzaCltObVthY
         kmmcXvFX9SHiQPo0V8Unp3F6q7o//WoKIRf54n4rgXnKWx+n76nNudLg2fyVX0LLKjl/
         PT3bvONLPl3UJdPbe/wn9J2+LWtGQS93qOk5kt8AjOXmyRaf7eStSgqKHH+1RGIB+vJI
         cYBywcXCz6MGJOcKDf2v81F7FSxmlhMvDjS20n5zV5P+PuVCUmoFOu+G1edytmO2HiIq
         fAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YTHjpx5tynN5ysNBWnDF8q0AZsL3oz0jYtEIvTs3UB8=;
        b=hbznPDJfkTNrC9Ntt4U37iS7KHe77nmsA2yqUe2KJTWUzdfbyiIehJdoRj7OnWSnPO
         1uSrOWMVZVmJUVCb2qhRGg/Jc0ObHU3kVHgHHIfd/A6uBvrCCEASm18lXV3TgG6ZoIJQ
         gh0YCO1TXBy9GMF0OtVTSW4FWmKECKIir8QYiKrPkddMkCfgIR9iEwSBOPrVzocNKrxj
         kPCVXP3tvfAGBxsP6iIMPUA00GIzEKlcFm+foh8GTn6em1/d2M4jE7We3N4rHPgwE3Lq
         1RvVxVYJHrIl9onzMTu0L9rJu3ySNSsO/To/zfXNcz7Vu9D/N/27e8zjdlMN4tse/CYP
         4TTQ==
X-Gm-Message-State: APjAAAWkP05kOCZmplb7+lnt5T94vGIUzDCmcRVQ8S8fH6rqV7FUz0B/
        tNUMXjQBChZCCgmrcpusD60=
X-Google-Smtp-Source: APXvYqwJ+H4xcrTifNRyujk7kct3/jugAiLCESyoG4j0g4CEAKEOyPB8CuSko//m+TkPGmo0KYgcvQ==
X-Received: by 2002:a5d:4705:: with SMTP id y5mr11261749wrq.364.1572187410396;
        Sun, 27 Oct 2019 07:43:30 -0700 (PDT)
Received: from localhost (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id n17sm7655453wmc.41.2019.10.27.07.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 07:43:29 -0700 (PDT)
Date:   Sun, 27 Oct 2019 09:01:46 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 00/14] vsock: add multi-transports support
Message-ID: <20191027080146.GA4472@stefanha-x1.localdomain>
References: <20191023095554.11340-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20191023095554.11340-1-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2019 at 11:55:40AM +0200, Stefano Garzarella wrote:
> This series adds the multi-transports support to vsock, following
> this proposal: https://www.spinics.net/lists/netdev/msg575792.html
>=20
> With the multi-transports support, we can use VSOCK with nested VMs
> (using also different hypervisors) loading both guest->host and
> host->guest transports at the same time.
> Before this series, vmci-transport supported this behavior but only
> using VMware hypervisor on L0, L1, etc.
>=20
> RFC: https://patchwork.ozlabs.org/cover/1168442/
> RFC -> v1:
> - Added R-b/A-b from Dexuan and Stefan
> - Fixed comments and typos in several patches (Stefan)
> - Patch 7: changed .notify_buffer_size return to void (Stefan)
> - Added patch 8 to simplify the API exposed to the transports (Stefan)
> - Patch 11:
>   + documented VSOCK_TRANSPORT_F_* flags (Stefan)
>   + fixed vsock_assign_transport() when the socket is already assigned
>   + moved features outside of struct vsock_transport, and used as
>     parameter of vsock_core_register() as a preparation of Patch 12
> - Removed "vsock: add 'transport_hg' to handle g2h\h2g transports" patch
> - Added patch 12 to register vmci_transport only when VMCI guest/host
>   are active

Has there been feedback from Jorgen or someone else from VMware?  A
Reviewed-by or Acked-by would be nice since this patch series affects
VMCI AF_VSOCK.

Stefan

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl21TucACgkQnKSrs4Gr
c8jY1wf9G0k0TNCkBEFILNq2f7qw5oF5+pTf1Of9V+p/S4tsTcWiHPLrYThBzZui
QJ/Zws7KFQcXB/7+e8RQ4SXI/iMLoPtaEFK3euKQg0N48xlULtw2XuiMVuaAsTsl
iaEmsyI21PQlM7zeMFTfqt0wxt2H6MebdP4DyrfhbKvFKmzAAy7v0Xq3vtv6/ZX6
AIVIDuKDo19J9oe9ZKF51lvMe4Ndd7ynKNDD+2s2ZrrF31/uuQkE6K2ZUMjTDQVR
zcK2K/aHtAnz+98XtneyrQAlc4JV0lTIZOMB2aTS4ZQ1sHssYiwGbF/j4fR2Dj0n
iFHeCiwo4mQ5+1RKCoFZbtObs2ilQw==
=wYuh
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
