Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B091C966C3
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfHTQtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:49:41 -0400
Received: from mail-wr1-f97.google.com ([209.85.221.97]:34564 "EHLO
        mail-wr1-f97.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbfHTQtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 12:49:41 -0400
Received: by mail-wr1-f97.google.com with SMTP id s18so13131874wrn.1
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 09:49:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fpjvOAIMdJRCU5oiOWiApHuczCv0tGrwTTKBy1Kzp7I=;
        b=mjFu191m+xMYFKqHEb2jC9YiX9RMVj9/5J5xwMn44lzUKDcygKGxXdgrZdKwlygtYF
         8iGD+OJpcuDl7w3KPn4irLRSKMG6c/7si0UWZvs+3jxhp/kGtT8ghx2MX8QITXFumZ3j
         yU8k60UT8787r3wCjK6xK1niuHitLiISZBoUm8DGve0Nzrtph8ppa7ZJAK2YtmKhKV0A
         UI17jsYXBcrqzmzsHy3mE5NJEwuLRw4TOczwX+YsfIz9DdHxEuFFnxpoZaJSfEbARZng
         dn3xhgfGF28oNv/MhVMIOMfShnFcP7JGd5hcU7hmXi/SRGTkqd7a+DVlQ4BwGRcYgMZV
         C4gg==
X-Gm-Message-State: APjAAAVmQt7X1nZ2WdImFaREcNlq5mV/prg/6zWg/jTkt4GRh7yl2u28
        AzTYC4dVpWkxCMz/AxS+gG0d3Butdfc2Of37M7g5iOWHRMU7eHQN5yR9yFYzwqZc2g==
X-Google-Smtp-Source: APXvYqyKaxLLzHpmoESaK8n/5tlU8bQH/IgXfoX2ONE9tfx2l0LnfuVabT7bPv+RSxIPPeSzV9J8iZ7OsIV4
X-Received: by 2002:adf:dec8:: with SMTP id i8mr34662792wrn.217.1566319778998;
        Tue, 20 Aug 2019 09:49:38 -0700 (PDT)
Received: from heliosphere.sirena.org.uk (heliosphere.sirena.org.uk. [2a01:7e01::f03c:91ff:fed4:a3b6])
        by smtp-relay.gmail.com with ESMTPS id d1sm354430wrj.19.2019.08.20.09.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 09:49:38 -0700 (PDT)
X-Relaying-Domain: sirena.org.uk
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1i07KE-0002vy-L3; Tue, 20 Aug 2019 16:49:38 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id A4DD52742ABD; Tue, 20 Aug 2019 17:49:37 +0100 (BST)
Date:   Tue, 20 Aug 2019 17:49:37 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 03/11] spi: Add a PTP system timestamp to
 the transfer structure
Message-ID: <20190820164937.GE4738@sirena.co.uk>
References: <20190816004449.10100-1-olteanv@gmail.com>
 <20190816004449.10100-4-olteanv@gmail.com>
 <20190816121837.GD4039@sirena.co.uk>
 <CA+h21hqatTeS2shV9QSiPzkjSeNj2Z4SOTrycffDjRHj=9s=nQ@mail.gmail.com>
 <20190816125820.GF4039@sirena.co.uk>
 <CA+h21hrZbun_j+oABJFP+P+V3zHP2x0mAhv-1ocF38miCvZHew@mail.gmail.com>
 <20190820125557.GB4738@sirena.co.uk>
 <CA+h21hr653oqOPxoJKWkP9ZhTywNR8EBjWV7U9LHwPRz=PJXsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KuLpqunXa7jZSBt+"
Content-Disposition: inline
In-Reply-To: <CA+h21hr653oqOPxoJKWkP9ZhTywNR8EBjWV7U9LHwPRz=PJXsw@mail.gmail.com>
X-Cookie: It's the thought, if any, that counts!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KuLpqunXa7jZSBt+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 20, 2019 at 04:48:39PM +0300, Vladimir Oltean wrote:
> On Tue, 20 Aug 2019 at 15:55, Mark Brown <broonie@kernel.org> wrote:
> > On Fri, Aug 16, 2019 at 05:05:53PM +0300, Vladimir Oltean wrote:

> > > Maybe the SPI master driver should just report what sort of
> > > snapshotting capability it can offer, ranging from none (default
> > > unless otherwise specified), to transfer-level (DMA style) or
> > > byte-level.

> > That does then have the consequence that the majority of controllers
> > aren't going to be usable with the API which isn't great.

> Can we continue this discussion on this thread:
> https://www.spinics.net/lists/netdev/msg593772.html
> The whole point there is that if there's nothing that the driver can
> do, the SPI core will take the timestamps and record their (bad)
> precision.

I'm not on that thread.

> > I'm not 100% clear what the problem you're trying to solve is, or if
> > it's a sensible problem to try to solve for that matter.

> The problem can simply be summarized as: you're trying to read a clock
> over SPI, but there's so much timing jitter in you doing that, that
> you have a high degree of uncertainty in the actual precision of the
> readout you took.

That doesn't seem like a great idea...

--KuLpqunXa7jZSBt+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1cJKAACgkQJNaLcl1U
h9Ajjwf7BKBd41sf2crMlSALL87ftWHff3zu1s9zzh4XvUN+afcw89zuNjTuCdJJ
soVj9H+nLOGS5Ylh22zu3scMpXcTtrRmYNoGixBW08UtkZDGTAxII5sM9kKdRNlj
e2u9fiqJ6bLLoWfQwlYodzO/5pXi0tCXoe+HuqP9a3GezNTR54EpO3iaCOeGSvq5
RXPXs6U76X+u8folfG1/s6N4yDDgWZatwBD+rjwhSOaWuNtDEf4/06UGLsczxoup
DkX/0FAAixRH/6twBZ4qs2gTTLeSsVt2zimSwfyDsfI0CRvfR6CQH6qIwKt3HOaO
kCue4zjaFxBzR6SU877WWSj6gMNZAA==
=SHGy
-----END PGP SIGNATURE-----

--KuLpqunXa7jZSBt+--
