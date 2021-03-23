Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A21C345A47
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 10:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCWJDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 05:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhCWJDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 05:03:01 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABA8C061574;
        Tue, 23 Mar 2021 02:03:00 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u9so25799799ejj.7;
        Tue, 23 Mar 2021 02:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tdkSK+R1riQKAoCpREZVcTjh4HWnayDQqvtAktxgMDQ=;
        b=VBkq4ob4KJSX3ViPZ0rZdhA/Hvcw2VvW98tqWIhHLLnDUNZ2NHuaav0yI2eS4xNMW9
         2RGg8r9rWVYI8RoWeeka+DInmLyUTFpxCzXmwnyRK697Rcq0fZf7LRnCsGV6muo9JUZF
         3Sw68Nn/sKcj7NFsJ+tZ6wFGYdsIhBIzWDVzdG56r5xmZXLp2p7ZnUTZogj1cuZEyUYq
         evuQD04LvhcKWIoI8MB6Jyyn5if7eNVMZdFSgVFCyN+RRS5lmqrYPsgFGFcamsdu4k9U
         oBDcWX5a5GdJYr2SXnaRjfs3pEcwzS/1gcBpBXx6SGPPohWupSMyVpFAdE5LfaP0mh1y
         aF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tdkSK+R1riQKAoCpREZVcTjh4HWnayDQqvtAktxgMDQ=;
        b=F8DEf76Ua0ZkvUOwAV/EbzuYKFWEm76bnoZhIfDaJL8OfpWW4F7Dha9gofU/2TEiHj
         u0qoyq+AjqvWMRdht6d+ep2UsJ9L4z3iOsqgzsJBseJhAnyiufDMfy3PYzgRVrdowNvg
         ly3hawbXSmaQspSXCTt11vbgqg3TKMmwpc7XDhnSsB2Qc/1Pn4BF/tf0MUTj1N2FhuPy
         3Clx9EnyFisU1oNxllPGjADUlQV5BfveRhkJR6oA3oLzrlJomX1bEwczVKBUmPuo4Whz
         gLf4yNVWeVVLBidDWNjTFrPed/+ZuTNsMARKDEscp7JZ4ZUBoaVZFqWyiY8prD1EReLp
         uInQ==
X-Gm-Message-State: AOAM533CAZLpSRF7OwJRvKKWovtc48vRU014pKLCGxW+m/ppcW871XyN
        o3CyYK5FFhvE+GI1ppMzNcI=
X-Google-Smtp-Source: ABdhPJxXF2ES5+RcmlzvZXYOhpDpMvgFn72V9MOebicNv3SXsWBckUzFLI2S3FI9OZcURhq/orFosQ==
X-Received: by 2002:a17:906:f10c:: with SMTP id gv12mr3937407ejb.53.1616490179676;
        Tue, 23 Mar 2021 02:02:59 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id q12sm10930976ejy.91.2021.03.23.02.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 02:02:58 -0700 (PDT)
Date:   Tue, 23 Mar 2021 10:03:18 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Dipen Patel <dipenp@nvidia.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kent Gibson <warthog618@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Networking <netdev@vger.kernel.org>
Subject: Re: GTE - The hardware timestamping engine
Message-ID: <YFmu1pptAFQLABe3@orome.fritz.box>
References: <4c46726d-fa35-1a95-4295-bca37c8b6fe3@nvidia.com>
 <CACRpkdbmqww6UQ8CFYo=+bCtVYBJwjMxVixc4vS6D3B+dUHScw@mail.gmail.com>
 <CAK8P3a30CdRKGe++MyBVDLW=p9E1oS+C7d7W4jLE01TAA4k+GA@mail.gmail.com>
 <20210320153855.GA29456@hoboy.vegasvil.org>
 <a58a0ec2-9da8-92bc-c08e-38b1bed6f757@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bVTvMWO8mJlbNrI0"
Content-Disposition: inline
In-Reply-To: <a58a0ec2-9da8-92bc-c08e-38b1bed6f757@nvidia.com>
User-Agent: Mutt/2.0.6 (98f8cb83) (2021-03-06)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bVTvMWO8mJlbNrI0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2021 at 01:33:38PM -0700, Dipen Patel wrote:
> Hi Richard,
>=20
> Thanks for your input and time. Please see below follow up.
>=20
> On 3/20/21 8:38 AM, Richard Cochran wrote:
> > On Sat, Mar 20, 2021 at 01:44:20PM +0100, Arnd Bergmann wrote:
> >> Adding Richard Cochran as well, for drivers/ptp/, he may be able to
> >> identify whether this should be integrated into that framework in some
> >> form.
> >=20
> > I'm not familiar with the GTE, but it sounds like it is a (free
> > running?) clock with time stamping inputs.  If so, then it could
> > expose a PHC.  That gets you functionality:
> >=20
> > - clock_gettime() and friends
> > - comparison ioctl between GTE clock and CLOCK_REALTIME
> > - time stamping channels with programmable input selection
> >=20
> GTE gets or rather records the timestamps from the TSC
> (timestamp system coutner) so its not attached to GTE as any
> one can access TSC, so not sure if we really need to implement PHC
> and/or clock_* and friends for the GTE. I believe burden to find correlat=
ion
> between various clock domains should be on the clients, consider below
> example.

I agree. My understanding is the the TSC is basically an SoC-wide clock
that can be (and is) used by several hardware blocks. There's an
interface for software to read out the value, but it's part of a block
called TKE (time-keeping engine, if I recall correctly) that implements
various clock sources and watchdog functionality.

As a matter of fact, I recall typing up a driver for that at some point
but I don't recall if I ever sent it out or what became of it. I can't
find it upstream at least.

Anyway, I think given that the GTE doesn't provide that clock itself but
rather just a means of taking a snapshot of that clock and stamping
certain events with that, it makes more sense to provide that clock from
the TKE driver.

Thierry

--bVTvMWO8mJlbNrI0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmBZrtYACgkQ3SOs138+
s6HbFg/9G7X90pqDEW3JLgijJ69+zOPxjnEtd7Y38eusl2F11qEb74F8Kmk3+CWr
MPM/iRekB4+INhuzDih0zkNK8a8vvKSuQI9PelFHM2ZQhlHgtD6Sh8otjrx6qRxP
JmqeOPFxmHkeZ2y5ddHYnP/4OTMOsQJNK8xxGF1OaJ8thhsQmh7f9SKQ1CX5v0Yd
JgDbbB0FqvoMLmmhyFbz14lfVN9O364X7Ji7EgpSGU1bPo5/VObQTc4gZLkSNXbC
IStd/kQ9V6Mu5zZeAoNSteQMWnX75PS50p+m4jotH6tysVxIYKFUYp4VnnpEojIq
UBE1KPE53IhNVgOAom95sDATD6KO4/wfvGSf6iqQFBw/ictceHEh/MsQ2YtzaVC1
/S4pinQ5vf60WqtSCIUBuc5BdsX/YnbPD8y6+s/Nx35/+7JVA63l3AmKEBBZ8nHo
sRxveUV/dkwuR4yPyAwIh2G7K7viXb4SkgPLZJ1bl3ooQFeGdOXiiVJYJ//NJ16z
+gjJ6wp7m/mzSqFbd/P5eTo6Pc+5866tOSrmePJ2TYnRFDcI3ytBawUHexz8RJlL
Wo20Q3av8w8Xpg01aNvg5nqnPfGq5sZXTKE58utV4k1NJcGSfx0zrgDCj+q+x9IM
xckpjOkqyFAK1KcPvvk0E0roZJNc8AEMOVWcWrLZ3SLR6uUm4os=
=8TIr
-----END PGP SIGNATURE-----

--bVTvMWO8mJlbNrI0--
