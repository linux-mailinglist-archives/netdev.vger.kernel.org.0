Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29605ADF36
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 21:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbfIITLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 15:11:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45329 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfIITLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 15:11:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id l16so15306225wrv.12;
        Mon, 09 Sep 2019 12:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KIjd6UpCIFD0dhGNwXIvGRC5CReBQG4gOrl4Gbm3TD8=;
        b=l4eUr/IJmbHTuEjGrfgxe3UMDtiYLm56zRqgw4L+d9z9iZxD4NwSbWSZ+2sU9wMpVk
         U/ArR7eDDBwg4SWjU+/z5Y47G2E3IEliRrU5sIxnoICYi7/xNa6OrPZ99KlkoqXiMGz3
         KsrjVCwzXKVsyLoZdq8gnKdzkIBnvGLhw5+f8FkWxdrLSayeACTcbqb7bvKfEHUqC/Vp
         rAufKSdxmDVsruWvaEDFzZeNZe/4SK8TkYjlRcq8gg7IfKQchWaaWZlMjRRn0ayAYU8t
         1IOaWjNMYlhxTOyOcrgnndqV0dI6P/+5PXFxGvnQhPN/HptJdxzEcSAD5lBerdRYfdwf
         4zDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KIjd6UpCIFD0dhGNwXIvGRC5CReBQG4gOrl4Gbm3TD8=;
        b=gYzwmbQ9dlJCGTvzzBXoAPQxn+XDOldqdaPyVIL8U1m1iMxa8UEGtme6Sx4PpnhBl1
         6ma7UleEKYTdbr/XkYH6Zzhpr6a0lxmMWTmgIgEuh1xb/Wf9v0azE5uF0FJenY97SrA6
         eofyEDAyaU9XDyaJQTemhR7w2cI8gFL4fIQ3BTkOF44DSwAuzto4E03uT+6fwq8XhFdl
         voXjihVyjt5JjX3Qpvua0fbOV7yAQEHpBiG9gkV3MoEzoUbynIIWI6X11fGEXp3E44DF
         /XK7m89777r/q7vF3EOoLoOIxXaoL5qMjChGFB6VzT3ElyYWpUWuH5nMNLPdv5Qe7wej
         aQHA==
X-Gm-Message-State: APjAAAV9Zp10o8Nln+nODyVLN8ihTE2LuOXWuqdg35Ex5aMBPjVYo+SH
        VtFtBRoBX6W/YgQvNanWZC0=
X-Google-Smtp-Source: APXvYqxNmjofgmga2dvfArTQXd3r0mo3XfWEdTyemT2ZnB/qzPJP3RkKoxZbVfUM1lCxKIPSwGD2QQ==
X-Received: by 2002:adf:f7c3:: with SMTP id a3mr20777417wrq.141.1568056290125;
        Mon, 09 Sep 2019 12:11:30 -0700 (PDT)
Received: from localhost (p200300E41F12DF00021F3CFFFE37B91B.dip0.t-ipconnect.de. [2003:e4:1f12:df00:21f:3cff:fe37:b91b])
        by smtp.gmail.com with ESMTPSA id y6sm326012wmi.14.2019.09.09.12.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 12:11:28 -0700 (PDT)
Date:   Mon, 9 Sep 2019 21:11:27 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/2] net: stmmac: Only enable enhanced
 addressing mode when needed
Message-ID: <20190909191127.GA23804@mithrandir>
References: <20190909152546.383-1-thierry.reding@gmail.com>
 <BN8PR12MB3266B232D3B895A4A4368191D3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266B232D3B895A4A4368191D3B70@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2019 at 04:07:04PM +0000, Jose Abreu wrote:
> From: Thierry Reding <thierry.reding@gmail.com>
> Date: Sep/09/2019, 16:25:45 (UTC+00:00)
>=20
> > @@ -92,6 +92,7 @@ struct stmmac_dma_cfg {
> >  	int fixed_burst;
> >  	int mixed_burst;
> >  	bool aal;
> > +	bool eame;
>=20
> bools should not be used in struct's, please change to int.

Huh? Since when? "aal" right above it is also bool. Can you provide a
specific rationale for why we shouldn't use bool in structs?

Thierry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl12o9YACgkQ3SOs138+
s6FZNhAAs/HF4Oi/hCf8A2C4bHideeNCvGKRu9YRNGKKXXguVI7lKuL42Y124f8/
XGryFA2m75/GPk7QAzzydbzfoL9pxzfREPmVOZMBwcHWtXPWZhe6nWV12YKv7y5f
QYmjHhkuU1lH5GjMbnVXstpvrsCxm1nmRMr4IYiCTrs1Z4f2JCUOd6ULV+RHGZxv
z2evlo3r3PEFERKolVIWySf8JsXDGQVO8FouN1DbAGpAozQpTv609E+smIWwdHqP
QHts0VqiZPMgPb5jYl8qyEKVUZjiRGy3bSutBxteZB0rZb9hGXa8zmsbezkbai77
RBTwIf8l9cFDnxtoHSuZxFXtVxHrrCJStsWaM10pBu5dXXURJkXEmyYKLrz0/Gjo
e8KisHj5YWK8mtscN678q4sgAv6TnjfGi4zc0Emc1hR76dzj0/0AkC3vGWwIyfFs
xIcF+z/LdXsQnSxTfa9TRHf+h1i3goeYrqqllVYoZKRIiRB+XyIYYQ2O947wxdM1
09gjbCCrXlE4OMQkDyJRPSsfzmyGCp/f+qwXIfGbJpyzIiugnk9iX2EMokgLb4ey
s4/QhQASPF9jShtc5hXDzbjUUeIpXIAaXFX+mEoaLGIYeTJFsC3/nwufV7KRqh8D
bGukJ7d7u+rCbWWXWPcSjEjXMzr58yx1f1ta22SspJdIH7XPCbY=
=IXZb
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
