Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F8E2D1594
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgLGQIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgLGQIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:08:20 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A3CC061749;
        Mon,  7 Dec 2020 08:07:34 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id m19so20185807ejj.11;
        Mon, 07 Dec 2020 08:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WM/4xKSlXYVQWjEHfbWD8YX/luYlEiJYgCc/oLAT72M=;
        b=qKgDPJDPA18nffgQ211xSgkPcAycCzVVcqW7ZbuMWzxFCl++LQpCcZ0C8J9T4DBrb6
         p2DyTpTDyOyGEmGwTleB4Bx0L0GLAX5iez4RwZzXoWT1pdfjAq/co6NNNvtB7OLGfOKI
         1uX0OOQSymZjTgwxQdxqYq/qFmw5H3489UCNx2Z2BRcY0cSZQVaZhYcWNkZ9TAhWc1K5
         QuRFZclmSDh7OabGFcl1oAqmMQL9EuZqUQ6WGjkmo192doqD6wBVw4b1H/xZ3ctMDW7n
         OWOuLFt2ht5DYzcpHSswwkatv6rFQKTbuggtu44/Ptnhuxws2wgN22HqGQOxjgpyOA8u
         lW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WM/4xKSlXYVQWjEHfbWD8YX/luYlEiJYgCc/oLAT72M=;
        b=I06gYwwQyMWjGxy5hJ/YCNBs9CYyY6ylhwPCQrHjvrMk5hnaGWkRpjUajfYsVTvdEa
         ynmU0NhhhvjoxAn4eA2i1TFmxqbCfiG5/Yc6cbw+tgu+dpUVJBcaLACUSPpga778Xc76
         Yero6HczDsHa4RYSt6DDDgco+JuLWOCvwaw/bM0St0H+mKJkErAEB1g44/zfIhUX/Wfy
         oOovlVdoiVd8MAV/n/V2G+ads6LAMvHdIRAldhYHKydD35dAw7TwnzvlGqFgjNyhwp0X
         8MWZF8R+Ts0dvmEhK2WbVFALWJLWBsOGG4pnlbsYhGUyAnpWYxVOlcomqhrBne3dT8CN
         VaQA==
X-Gm-Message-State: AOAM530av7WoJnQTM0cOPS9RIrXe9JZC1qUMQWEnsrNoLqBAPoOZGJwB
        OCHjrnChAvbEuZxabcTzWFQ=
X-Google-Smtp-Source: ABdhPJzwCMTqsxTqqO4VotBrTjalTBZGvqcXJVYEDpt0nKWW3uuKzpE893tD69cUr19XrpsPZQAWzg==
X-Received: by 2002:a17:906:c1c6:: with SMTP id bw6mr20020182ejb.199.1607357252890;
        Mon, 07 Dec 2020 08:07:32 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id e21sm13941813edv.96.2020.12.07.08.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 08:07:31 -0800 (PST)
Date:   Mon, 7 Dec 2020 16:07:30 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost scsi: fix error return code in
 vhost_scsi_set_endpoint()
Message-ID: <20201207160730.GI203660@stefanha-x1.localdomain>
References: <1607071411-33484-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ev7mvGV+3JQuI2Eo"
Content-Disposition: inline
In-Reply-To: <1607071411-33484-1-git-send-email-zhangchangzhong@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ev7mvGV+3JQuI2Eo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 04, 2020 at 04:43:30PM +0800, Zhang Changzhong wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>=20
> Fixes: 25b98b64e284 ("vhost scsi: alloc cmds per vq instead of session")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/vhost/scsi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--ev7mvGV+3JQuI2Eo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/OU0IACgkQnKSrs4Gr
c8gAeQf+MEz4NCEr2G4ywg8AHw7rf050IHblQEjkZBazrQQ706YvtfGZssxTae9f
psRCnNLjHsZ2mFYWbtyPqI91egzIyJTNuu7odm3ILPfrXA7Lv8Uo2vZ9TNMN4+ZG
L060RA9br9G2+DYTn7yC6M9B1a6mKdDS68rzDQSMAHns29WLSoRLYXIJBsoxd/sv
Q9hxE1Sns6QVw/zOGCD9bre1pEWU2der61Qa4SfblpZgY9c9hXYNeKztrnznYufl
TsFTa02ME99jRC71/mG/qoT+Nh1OEtpcJ6ZqkU2lHEaYAng800NpNTIOaqEMmEZV
DfiQZ9kcrCzp+QXcuRpFFk/5rcaGdg==
=tZ45
-----END PGP SIGNATURE-----

--ev7mvGV+3JQuI2Eo--
