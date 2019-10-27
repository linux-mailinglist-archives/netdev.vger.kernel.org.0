Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A758E6334
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 15:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfJ0On4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 10:43:56 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38436 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfJ0Onh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 10:43:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id v9so7233336wrq.5;
        Sun, 27 Oct 2019 07:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8m+44Vom44C3KhaUynaGnY+KEBMnlLX9FyMyBId8qoU=;
        b=NQH/OeWG8WdxJzcEjzA4jcs0prQEWO9Pvc/hRibnmA2kGfBX9GXKEPzG8QBt0r5gt5
         WjLH9+UgxdiMjt+Upsns+/VTt4xZduF/oj+56GLFkWyGTeKIpVPddDxRQ18hMU6VTzeS
         Q3APORHOhFrh88B0ZczEmBrll1sBbpDk005nfDYQ/7lqddPN6exe7WgjGRpcLNfCPILS
         +14lN+4eH5gYalHUk+tGCUcgJEewmLLRDKhU7lLUE4pyu4YYaZl3gnGoFEdH1F25bdIf
         XVk9yXZgNi8mgQrhxWHxwRSseL6MeWEYAlASPhmRobVUJyTznxd8fFxLT1eXbZbR6cvB
         bVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8m+44Vom44C3KhaUynaGnY+KEBMnlLX9FyMyBId8qoU=;
        b=rD7xonPjPw2V2NGlaZyxGxwFs34j3r58fKoXukBX8bXjL9qXBk0Hh57toN2tiwIkp3
         nT+GNmOpkJghtN4jBA+ke0kSwfLIg5MVhMy++nRhF6a46aTJZn+Tetkv3xp3TfsdzN4u
         tiUFa0q09oxHhG7Gfpkj2SevgBF4Y8vMaPtzmL4JLXeYr7xYO+LjVCfzuqimz8aXkfAd
         J0P+f3fchnqR22CHxNr8pwO7fsXoSbo26KqlJ6WzdRqCTFI/J6P//pOUPym1Y3b+EMxX
         gwpXhBac6xYK06L5X067hHB53r6whBVCJ2Whzv+8AsLaSYRzn6JIQsfYXm8jPTE+3WAR
         r+bw==
X-Gm-Message-State: APjAAAXfBajN564otYlbOLr34mb6/XQnoDYqbY65mqUHq5WXRSH7fr3m
        ZLNPNUzKEeo6pCqa90XvmZM=
X-Google-Smtp-Source: APXvYqyiG2KCZCSee9Vwv5D88dH0uhGwkGZqT0L2pQDFD9DyKBWheclB6McEARrC/xn+QILCohGoMQ==
X-Received: by 2002:a05:6000:92:: with SMTP id m18mr11842859wrx.105.1572187415060;
        Sun, 27 Oct 2019 07:43:35 -0700 (PDT)
Received: from localhost (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id f17sm8378029wrs.66.2019.10.27.07.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 07:43:34 -0700 (PDT)
Date:   Sun, 27 Oct 2019 09:17:52 +0100
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
Subject: Re: [PATCH net-next 12/14] vsock/vmci: register vmci_transport only
 when VMCI guest/host are active
Message-ID: <20191027081752.GD4472@stefanha-x1.localdomain>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-13-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="C1iGAkRnbeBonpVg"
Content-Disposition: inline
In-Reply-To: <20191023095554.11340-13-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--C1iGAkRnbeBonpVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 23, 2019 at 11:55:52AM +0200, Stefano Garzarella wrote:
> +static int __init vmci_transport_init(void)
> +{
> +	int features = VSOCK_TRANSPORT_F_DGRAM;

Where is this variable used?

--C1iGAkRnbeBonpVg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl21UrAACgkQnKSrs4Gr
c8iGGgf/YjP9kPT916spdjeVdu2Wg8PPuw60Kt/da2i6Qp1hdl0CTXaK1RJxoH8F
FYtdWNROfs6CPSHEP5xVD4xBeHvZEST4BgeVr/hFZYbw4F5vVb9OIDpSln7JkN/r
zldMb0Q+UjbvTUZm9buMeb08nbzn9CdeaCJDGPIRHOZjDNw+wL0cilfVm5NMDR4L
pNbLtyJJliiIZeh2CxCu0k8Kd25OUlwDfqHHuFvDn/kmcNyQlVOUwb0VRnDts8mW
ian+XNpRXDY24xdyZ9F2UxA6wvwOleFhEN/La2euNs8Iv38liHKNgiCDHe/+br/t
vuMWadKe9tonhgk7iUlCA5hNDKgKiQ==
=CXM0
-----END PGP SIGNATURE-----

--C1iGAkRnbeBonpVg--
