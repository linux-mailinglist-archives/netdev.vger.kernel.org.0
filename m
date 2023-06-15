Return-Path: <netdev+bounces-10964-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5220A730DA2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 05:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A549D281608
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 03:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A4562E;
	Thu, 15 Jun 2023 03:40:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1B8625
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 03:40:46 +0000 (UTC)
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADDE211F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:40:44 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b1c30a1653so20354241fa.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686800442; x=1689392442;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WDX6iYZeUHZlKS0QzOKXrv12n3NVtOxgv8+p0mKoWyQ=;
        b=bOyCeF532raXFonVqqMpd6RtAT99ss06VmtBsAIKNKXjo2WO8OWABak4A8gsW53H+k
         CEkrIH0T678q3ctWbBEgXMoNFR3PpYKqd6hugbygrHH5jQFlqPHyj2wRvylrf3xYquHk
         TtzZAjkIZnNwJWPWg5qnEeoERc6aGuCDMHWuc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686800442; x=1689392442;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WDX6iYZeUHZlKS0QzOKXrv12n3NVtOxgv8+p0mKoWyQ=;
        b=P6d60dNiqeDBU30mC0YMscAP2ZBfJv/J4qBBf+lhJx3AS60dKIW3YJNzQbecDoQmIF
         fIYfgngCcZgMiORXcGEPqvg1ZUoC75kH7LN6jyAeQAOx93hdb+YZVeYnrak1JkyMZcDK
         /DHcYhtJ/fn0jMjwqtEv0dCIjG92vtwgUV0ntj6vYbd13FEorllpXyR5aszcdEXmopcL
         waEtxkRrU7JBGO9Tm4EGcTa1pRVif5KfSA8Z7/jN6Lebg+jXwxaXVVyMLrxk2xp2VF5Q
         FpwIAr5hec0f8JsFxQWCCZeOv9dWTcQmBdXbT0LU38oa6iKypz/qin70QuVnz9dX6Tvj
         ecmg==
X-Gm-Message-State: AC+VfDxYWZtRs7p05o7iBCp6Es1c0TJ5tDc1sdGpVLfNNXb3O6ZDQKWU
	Sj8uTJ0KrCNmYXx1n5bI+oWrBTt2yGBv5Du88U/u0w==
X-Google-Smtp-Source: ACHHUZ4/idPOg57zhNCnr6Q9Fz2g52pYMHYifN6v7xAXCvMKg9vN3Uw93Xvvmz9q+CuMAmWqTLCzpUqbUActng+ZLIA=
X-Received: by 2002:a2e:6e19:0:b0:2b1:c61f:9d1e with SMTP id
 j25-20020a2e6e19000000b002b1c61f9d1emr8464869ljc.30.1686800442082; Wed, 14
 Jun 2023 20:40:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230615033400.2971-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20230615033400.2971-1-jiasheng@iscas.ac.cn>
From: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Date: Thu, 15 Jun 2023 09:10:30 +0530
Message-ID: <CAH-L+nNdVO4xYxcE0jg6uE8gzA2hCE=9UEz_0n7+BfNvsW9SdA@mail.gmail.com>
Subject: Re: [PATCH v2] octeon_ep: Add missing check for ioremap
To: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: kuba@kernel.org, vburru@marvell.com, aayarekar@marvell.com, 
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com, 
	sburla@marvell.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000030f93a05fe22d516"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HTML_MESSAGE,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--00000000000030f93a05fe22d516
Content-Type: multipart/alternative; boundary="00000000000028ac9a05fe22d52a"

--00000000000028ac9a05fe22d52a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 15, 2023 at 9:04=E2=80=AFAM Jiasheng Jiang <jiasheng@iscas.ac.c=
n> wrote:

> Add check for ioremap() and return the error if it fails in order to
> guarantee the success of ioremap().
>
> Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device
> initialization")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>

Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

> ---
> Changelog:
>
> v1-> v2:
>
> 1. Rewrite the error handling.
> ---
>  drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index e1853da280f9..43eb6e871351 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -981,6 +981,9 @@ int octep_device_setup(struct octep_device *oct)
>                 oct->mmio[i].hw_addr =3D
>                         ioremap(pci_resource_start(oct->pdev, i * 2),
>                                 pci_resource_len(oct->pdev, i * 2));
> +               if (!oct->mmio[i].hw_addr)
> +                       goto unmap_prev;
> +
>                 oct->mmio[i].mapped =3D 1;
>         }
>
> @@ -1015,7 +1018,9 @@ int octep_device_setup(struct octep_device *oct)
>         return 0;
>
>  unsupported_dev:
> -       for (i =3D 0; i < OCTEP_MMIO_REGIONS; i++)
> +       i =3D OCTEP_MMIO_REGIONS;
> +unmap_prev:
> +       while (i--)
>                 iounmap(oct->mmio[i].hw_addr);
>
>         kfree(oct->conf);
> --
> 2.25.1
>
>
>

--=20
Regards,
Kalesh A P

--00000000000028ac9a05fe22d52a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Thu, Jun 15, 2023 at 9:04=E2=80=AF=
AM Jiasheng Jiang &lt;<a href=3D"mailto:jiasheng@iscas.ac.cn">jiasheng@isca=
s.ac.cn</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-lef=
t:1ex">Add check for ioremap() and return the error if it fails in order to=
<br>
guarantee the success of ioremap().<br>
<br>
Fixes: 862cd659a6fb (&quot;octeon_ep: Add driver framework and device initi=
alization&quot;)<br>
Signed-off-by: Jiasheng Jiang &lt;<a href=3D"mailto:jiasheng@iscas.ac.cn" t=
arget=3D"_blank">jiasheng@iscas.ac.cn</a>&gt;<br></blockquote><div>=C2=A0</=
div><div>Reviewed-by: Kalesh AP &lt;<a href=3D"mailto:kalesh-anakkur.purayi=
l@broadcom.com">kalesh-anakkur.purayil@broadcom.com</a>&gt; =C2=A0</div><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t:1px solid rgb(204,204,204);padding-left:1ex">
---<br>
Changelog:<br>
<br>
v1-&gt; v2:<br>
<br>
1. Rewrite the error handling.<br>
---<br>
=C2=A0drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 7 ++++++-<br>
=C2=A01 file changed, 6 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/=
net/ethernet/marvell/octeon_ep/octep_main.c<br>
index e1853da280f9..43eb6e871351 100644<br>
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c<br>
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c<br>
@@ -981,6 +981,9 @@ int octep_device_setup(struct octep_device *oct)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 oct-&gt;mmio[i].hw_=
addr =3D<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ioremap(pci_resource_start(oct-&gt;pdev, i * 2),<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_resource_len(oct-&gt;pdev, i * 2=
));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!oct-&gt;mmio[i=
].hw_addr)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto unmap_prev;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 oct-&gt;mmio[i].map=
ped =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
@@ -1015,7 +1018,9 @@ int octep_device_setup(struct octep_device *oct)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0unsupported_dev:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; OCTEP_MMIO_REGIONS; i++)<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0i =3D OCTEP_MMIO_REGIONS;<br>
+unmap_prev:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (i--)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iounmap(oct-&gt;mmi=
o[i].hw_addr);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(oct-&gt;conf);<br>
-- <br>
2.25.1<br>
<br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div><span class=3D"gmail_si=
gnature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><d=
iv dir=3D"ltr">Regards,<div>Kalesh A P</div></div></div></div>

--00000000000028ac9a05fe22d52a--

--00000000000030f93a05fe22d516
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBWowggRSoAMCAQICDDfBRQmwNSI92mit0zANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwODI5NTZaFw0yNTA5MTAwODI5NTZaMIGi
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xHzAdBgNVBAMTFkthbGVzaCBBbmFra3VyIFB1cmF5aWwxMjAw
BgkqhkiG9w0BCQEWI2thbGVzaC1hbmFra3VyLnB1cmF5aWxAYnJvYWRjb20uY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxnv1Reaeezfr6NEmg3xZlh4cz9m7QCN13+j4z1scrX+b
JfnV8xITT5yvwdQv3R3p7nzD/t29lTRWK3wjodUd2nImo6vBaH3JbDwleIjIWhDXLNZ4u7WIXYwx
aQ8lYCdKXRsHXgGPY0+zSx9ddpqHZJlHwcvas3oKnQN9WgzZtsM7A8SJefWkNvkcOtef6bL8Ew+3
FBfXmtsPL9I2vita8gkYzunj9Nu2IM+MnsP7V/+Coy/yZDtFJHp30hDnYGzuOhJchDF9/eASvE8T
T1xqJODKM9xn5xXB1qezadfdgUs8k8QAYyP/oVBafF9uqDudL6otcBnziyDBQdFCuAQN7wIDAQAB
o4IB5DCCAeAwDgYDVR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZC
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3J0MEEGCCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3Iz
cGVyc29uYWxzaWduMmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcC
ARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNV
HR8EQjBAMD6gPKA6hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNp
Z24yY2EyMDIwLmNybDAuBgNVHREEJzAlgSNrYWxlc2gtYW5ha2t1ci5wdXJheWlsQGJyb2FkY29t
LmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGP
zzAdBgNVHQ4EFgQUI3+tdStI+ABRGSqksMsiCmO9uDAwDQYJKoZIhvcNAQELBQADggEBAGfe1o9b
4wUud0FMjb/FNdc433meL15npjdYWUeioHdlCGB5UvEaMGu71QysfoDOfUNeyO9YKp0h0fm7clvo
cBqeWe4CPv9TQbmLEtXKdEpj5kFZBGmav69mGTlu1A9KDQW3y0CDzCPG2Fdm4s73PnkwvemRk9E2
u9/kcZ8KWVeS+xq+XZ78kGTKQ6Wii3dMK/EHQhnDfidadoN/n+x2ySC8yyDNvy81BocnblQzvbuB
a30CvRuhokNO6Jzh7ZFtjKVMzYas3oo6HXgA+slRszMu4pc+fRPO41FHjeDM76e6P5OnthhnD+NY
x6xokUN65DN1bn2MkeNs0nQpizDqd0QxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYD
VQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25h
bFNpZ24gMiBDQSAyMDIwAgw3wUUJsDUiPdpordMwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcN
AQkEMSIEIJg9Xe2duXRyC9tqE6T6aV96k2WSp7Cc2L8lKaTVFmT6MBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYxNTAzNDA0MlowaQYJKoZIhvcNAQkPMVwwWjAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAy54/t9e1v
bvQMO+gY1/BQYMQruhShe0Iz8AcWuMfaaAWrrLRgISNYeawjHWq/52HO/r5aJiF1DxhrU75/cxel
4nolr4C+Kg7spHNDHvFx7sVatf1UBKGlTQi9Y2O91o5FxPziqYjAjrcWnOd7Qm6tIU1lcsVrr0gj
5s+xW+vMmBRp140TVzm5sbehJTLEQSmJR6y4UNYQ0cNGJ+37zP6E6sz2yI8uMmi7xzcaALI7a4yu
vOYoquh66XwSteev1jHGW02K9yskdKvAifyS/xssWmUdn5Fc1iIG3ztF/jowfqL4JZKf09LyxKo+
Bzh+CQnYpGqIplo7RSqIalKik8Lh
--00000000000030f93a05fe22d516--

