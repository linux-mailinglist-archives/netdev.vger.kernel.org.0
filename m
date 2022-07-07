Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2777B569BF6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbiGGHqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbiGGHqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:46:01 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD65B32EE0;
        Thu,  7 Jul 2022 00:46:00 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v16so13632529wrd.13;
        Thu, 07 Jul 2022 00:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LKzuTu76HYq009jrFW4ITnArK6nwSQEv+W7XUzoR33w=;
        b=YgLS/IVL8oJWf9znw9oBwb5dk75wPgcOWZKPGd8C7nYr/y9V3x0Ntie2J/s+1Eqyyi
         qQpcUAA/lpMg2ASeAPMN1qOUEsr7hZlW/HzPSIF4MvumFnjFJ+HGDfJSXwLeXNYj0ZXF
         9FhIpkpwDIokwLnR8GNvrdDT1C/hTm9FldOHRT3uOqw5MmcKd82DAV8igV4Iro6cR3fJ
         wkzYxYFhlb7dZPDlPLq1twTHw4Jq/+bprDDv8Hs55Oi8IPiaHV/XZxfVrvq+RaHpGbfF
         QPUvpZoL+DFH9R+TXgyh7ppWyvulqYCXS5+4bVN/OfAFBzO+A+HkN78xXlTvDZj97+HZ
         Wn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LKzuTu76HYq009jrFW4ITnArK6nwSQEv+W7XUzoR33w=;
        b=2TByTxhh72/GMtlhH3bzMLYoAuGTGxrHYyfs7qwH0mjLjxRwchZPqnyT+7rv+FUmL8
         FnioyiwztcqfmgpRKag/CAOd65cKIlwvkisd/sX5n7MnAJkXlKm349Gjb0Tz+bAE7MyZ
         D+gefPadrdNHIQFLNMfflzz7VbhOoaeYrn4y0XdA9B3kS1r3WUHOvejZV0Ti2/BWSB29
         Oc0Pl1C7mu1fQMY+5p3stjirZAvJ6rPfwC5pzJexxr6ZQlcU2beJijl/3YTbZnh5bR17
         h9CBdvD/5yIdQmOTiWF0MfUD4wyv9rmJy9w0PDnIeQP4k+uUjRkDO5l0IVLp0zUPWKoO
         XiXg==
X-Gm-Message-State: AJIora+zIed5NFd4J7S04ZiLFQBN5dyJpyJxRPIAbKp8L/1TwxqxTlAC
        4FYu0dZjuZV0+u29uq+Xjv4=
X-Google-Smtp-Source: AGRyM1uhNJyllReG0ZArRd/Db+rq+lfBdkqIvwYsQC/sf+JccUaUBgU538nikPnfBjvsYoPAzW47Nw==
X-Received: by 2002:a5d:5505:0:b0:21d:6549:70bd with SMTP id b5-20020a5d5505000000b0021d654970bdmr23439119wrv.612.1657179959185;
        Thu, 07 Jul 2022 00:45:59 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id n15-20020a05600c4f8f00b003a1980d55c4sm16955077wmq.47.2022.07.07.00.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:45:58 -0700 (PDT)
Date:   Thu, 7 Jul 2022 09:45:56 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 5/9] dt-bindings: net: Add Tegra234 MGBE
Message-ID: <YsaPNKSeQcfYw0FK@orome>
References: <20220706213255.1473069-1-thierry.reding@gmail.com>
 <20220706213255.1473069-6-thierry.reding@gmail.com>
 <f85d59ba-4f2c-130f-2455-bc28ac060f8c@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X8MNCt9n/wN8o+J9"
Content-Disposition: inline
In-Reply-To: <f85d59ba-4f2c-130f-2455-bc28ac060f8c@linaro.org>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--X8MNCt9n/wN8o+J9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2022 at 08:56:49AM +0200, Krzysztof Kozlowski wrote:
> On 06/07/2022 23:32, Thierry Reding wrote:
[...]
> > +        - mac
> > +        - pcs
> > +
> > +  interconnects:
> > +    items:
> > +      - description: memory read client
> > +      - description: memory write client
> > +
> > +  interconnect-names:
> > +    items:
> > +      - const: dma-mem # read
>=20
> I propose to drop the comment - it is obvious from "interconnects" above.

Yeah, fair enough. I've addressed all of the other comments in v4 as
well.

Thanks for the review!
Thierry

--X8MNCt9n/wN8o+J9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmLGjzQACgkQ3SOs138+
s6Gv4Q//bbgi+ifGsHmooNRh+8eZisJE63igGhF8VcPWQfg5KVsHp9t29GRGjYDZ
kEJNUNfwY+MNRthNCkSZ4TELThrtWfkQ9JczYVL77zvs4emll0uPKnLvInBq4yBl
JtOPBsfBJ6smp7q+24r2MxFk/8UqkWWHquGfxsD4Y9o22LpTRtVoqlxpjwQlcKDm
FRIwsNJVnR3E7LJvJgiBud11nNDJSFChWsx/Fs8lQUGbtw4/gVqvBDWajaQG936z
ondimFfrYTlKcPZ17taf9Ye/hkuK4HqxqT6V/kZ37iavFePjyE4N353UiZmDP7wx
jbwwH/ughM5r3/9uyouSHcUOEsksnZjwVz7AeeWl18DvzXsFRhuVjji2gbA8MkY5
PKmBndRUIkAXror5j/GI5J1JwGhbPF1Zj8StlD743wkWj3N7E6QOrrQsU2Xuzoez
KoADKZQ12dkbnbUOAmM6OHL9xVQ0rk82xEKKZS9a64IK5jsOxhnvqJuozZEnwUeG
esyoDtOz65fuNrqwYmdDDUPcRB75CEB7nclBzigpqCL3sukRVttqQRKGgtjU1rt2
5V/wk7us2EgtcxiBxXgz59ugg8Bp7K1GzLCBqrpVNbkqklfezUkQz+od/+5vbgxA
sZpFqmOrq8Ta3Cq95u2z2tDvI+4vYjLPLG0r2ZFojct/Ale/V4E=
=f3wq
-----END PGP SIGNATURE-----

--X8MNCt9n/wN8o+J9--
