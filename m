Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2A63B0B50
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhFVRV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:21:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbhFVRVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 13:21:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624382379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oCmhYX4FMHa1vHCb0sAJt4ZxgQGn9P18XQ4+1q0bk94=;
        b=dq1mU7keWv4t/UVjV/TQWZamou0Al/AcofwXon5FeA304FocdXQw4jRnMZmW+iHkdS0PbE
        SoDwrcja/jCyN0/fXscIexVheO3RLo8UoEsaQnWTjguB+Ub8ZFHuaaB/JUqWGVYcZntZdS
        fcTZgZcXcsmYsi5Cu5Xb2B3LQcqL0Jk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-3dmbF07CPKu_5jHHG20X9w-1; Tue, 22 Jun 2021 13:19:37 -0400
X-MC-Unique: 3dmbF07CPKu_5jHHG20X9w-1
Received: by mail-ed1-f69.google.com with SMTP id j19-20020aa7c4130000b029039497d5cdbeso5818442edq.15
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:19:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oCmhYX4FMHa1vHCb0sAJt4ZxgQGn9P18XQ4+1q0bk94=;
        b=OG3WxD7s6mBTWud1UW1VJPDvkvyexgy30LaXX/S4waAqm3grWFpV26ZqyE0ymTWWlQ
         2f9dIVODYRDeHfwHyZ8AqpNjtvKbl86PKmJBvqcCtWwByfuPQhrbESgwM6oz2s6KmBPA
         x+EFWdZUCtgJGUOiX8NM5sXq4xblxA6BnmVBliUoRRqwGEG+tsShdxwdZhMaSSQU0nEY
         6xd8AQwt3XQN/PXIBmhi8zbvYuVZhx8viLUGvowxXdITDqb6AnO/g664/SqYKmnkfu1W
         yrshdG2g17O0NjyJ0evcn9uWFAa4d/ieIPVMCbp148nVakmppdnCKqKwKzaE8+aliajm
         f5Fg==
X-Gm-Message-State: AOAM530yzt7nfgNwmJcfpKe+CjTxo9s7ulyOYFpreHe4FXLSBUDPPa22
        UlJwIcGl98ga65IF5QF+iklUWICrax2QBB/+oySTTQxhVcWZxGZ5FMfpgCLDckmkhY+2ZJsn8ja
        qUAZL8v0IIL7vjdkU
X-Received: by 2002:a17:906:2513:: with SMTP id i19mr4948427ejb.164.1624382376356;
        Tue, 22 Jun 2021 10:19:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDN9E0exQEIgJ92bAsxoIVdsDt6RUASv5gDictcsjcMzaS9Ki/x6rj9N/8BmTCbQt4HqZoUQ==
X-Received: by 2002:a17:906:2513:: with SMTP id i19mr4948411ejb.164.1624382376200;
        Tue, 22 Jun 2021 10:19:36 -0700 (PDT)
Received: from localhost (net-130-25-105-72.cust.vodafonedsl.it. [130.25.105.72])
        by smtp.gmail.com with ESMTPSA id ml22sm4899602ejb.93.2021.06.22.10.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 10:19:35 -0700 (PDT)
Date:   Tue, 22 Jun 2021 19:19:32 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, mcroce@linux.microsoft.com,
        kuba@kernel.org, sgoutham@marvell.com, sbhatta@marvell.com,
        stefanc@marvell.com, brouer@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        mw@semihalf.com
Subject: Re: [PATCH net-next] net: marvell: return csum computation result
 from mvneta_rx_csum/mvpp2_rx_csum
Message-ID: <YNIbpP4gFDNz1YIU@lore-desk>
References: <73619ca7d64b1dee91ed8ed2dcf0ddbbc57b4b0a.1623943981.git.lorenzo@kernel.org>
 <YNGdw+T283xPwQDM@lore-desk>
 <20210622.100556.369690653202936593.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Z1sed/+xHzYYIBDR"
Content-Disposition: inline
In-Reply-To: <20210622.100556.369690653202936593.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Z1sed/+xHzYYIBDR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jun 22, David Miller wrote:
> From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Date: Tue, 22 Jun 2021 10:22:27 +0200
>=20
> >> This is a preliminary patch to add hw csum hint support to
> >> mvneta/mvpp2 xdp implementation
> >>=20
> >> Tested-by: Matteo Croce <mcroce@linux.microsoft.com>
> >> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >=20
> > Hi Dave and Jakub,
> >=20
> > I have just noticed this patch is marked as "Not Applicable" in patchwo=
rk. I
> > tried to rebase it on top of net-next and it applies and compiles so I =
am
> > wondering why it is "not applicable". Am I missing something?
>=20
> It did not apply cleanly for me, please resend.
>=20
> Thank you.
>=20

ack, I will post v2 soon.

Regards,
Lorenzo

--Z1sed/+xHzYYIBDR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYNIboQAKCRA6cBh0uS2t
rKaeAQChmgiEN9pSDq4KF0t+jKqsfIz8q92RXodB7bcGI0tv5AD+INkMGo/H2mK8
1cyu9kCTWstg8OW/1bKiZLJNrL8S6QI=
=BjOQ
-----END PGP SIGNATURE-----

--Z1sed/+xHzYYIBDR--

