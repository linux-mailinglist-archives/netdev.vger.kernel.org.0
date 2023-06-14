Return-Path: <netdev+bounces-10597-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D984A72F45F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B75641C2087E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 06:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A65417F7;
	Wed, 14 Jun 2023 06:03:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247EB17F4
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 06:03:33 +0000 (UTC)
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057D21A7
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:03:32 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2b1badb8f9bso3923561fa.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686722610; x=1689314610;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5aOs+20gUhcqPqUP6L3B27i3xRe0Dt5PdeH3cCFKGs=;
        b=Pd4ScTQ6R8DA9yYl1HWRX2c8JefoPErZTpMs8ho3nIpJ/Il7v+AHN6/YUjCUQxdESZ
         zylaFmb4JF4iq6bN9W6rsUnSpGLywHilw2efaxLng2duyYUxcY3BQYfYB6f331QMY84l
         MMp8o+u2DUjDrF2s42kUJ3bniO13MAUiuhy+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686722610; x=1689314610;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q5aOs+20gUhcqPqUP6L3B27i3xRe0Dt5PdeH3cCFKGs=;
        b=a8ofCCcl7lhO0jFcyF6/BYrHcfeIj28gglyCB67Tbe1bhGjyQnWF421KBwaRLxTi0r
         wEO6ViaHvlr32Sfa2mbJmqTAhDQ4XQmdZmPbGy/6o7/IEP4yA+92BgV5D1jV+2BzfV/s
         wVL84mjoQo6MJyRzMRAqt4vYXUJCyAWvpIyRDuFsNI90i0P/nMY7J57pamO7vKVNsuKO
         T8dAUeitwJXtxsnNpkIxVPeVcgaebxEJKtBUtD5b9Y/e43i2MYICcCOdoKmzv71LeDlV
         Z2DWtP/sgvb7sA0e93rZuqTLy4BJaFN8zon7ccqIVlr16yC0aHxmEC1vwa31WnPkRAc7
         9tNA==
X-Gm-Message-State: AC+VfDz8ONuF2IkCdvulmqFC5c49021CdmADiohtND995aonX/happ4M
	P38ogEYe7/NjrAy07gK1jNg1Hcn6UFfjMC9KsQuEXg==
X-Google-Smtp-Source: ACHHUZ4NJ4xy+0G5NcvexceVGcDtt9QFGOgG9CP12gCHIt5kFLu11O82lrCqkdGAJmWuwzxKFhAJaXmg8edoK6IpAG8=
X-Received: by 2002:a2e:88ca:0:b0:2b1:cba2:39ae with SMTP id
 a10-20020a2e88ca000000b002b1cba239aemr6247824ljk.38.1686722609939; Tue, 13
 Jun 2023 23:03:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230614032347.32940-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20230614032347.32940-1-jiasheng@iscas.ac.cn>
From: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Date: Wed, 14 Jun 2023 11:33:17 +0530
Message-ID: <CAH-L+nM3kPWxyLn_iO7ktmd5E+URG=EfPW2FWnd6fxdSVdb7Hg@mail.gmail.com>
Subject: Re: [PATCH] octeon_ep: Add missing check for ioremap
To: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, sburla@marvell.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000009a44a05fe10b667"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HTML_MESSAGE,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--00000000000009a44a05fe10b667
Content-Type: multipart/alternative; boundary="000000000000006bfe05fe10b64c"

--000000000000006bfe05fe10b64c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

One suggestion inline.

LGTM otherwise

On Wed, Jun 14, 2023 at 8:54=E2=80=AFAM Jiasheng Jiang <jiasheng@iscas.ac.c=
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
>  drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index e1853da280f9..06816d2baef8 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -969,7 +969,7 @@ static const char *octep_devid_to_str(struct
> octep_device *oct)
>  int octep_device_setup(struct octep_device *oct)
>  {
>         struct pci_dev *pdev =3D oct->pdev;
> -       int i, ret;
> +       int i, j, ret;
>
>         /* allocate memory for oct->conf */
>         oct->conf =3D kzalloc(sizeof(*oct->conf), GFP_KERNEL);
> @@ -981,6 +981,9 @@ int octep_device_setup(struct octep_device *oct)
>                 oct->mmio[i].hw_addr =3D
>                         ioremap(pci_resource_start(oct->pdev, i * 2),
>                                 pci_resource_len(oct->pdev, i * 2));
> +               if (!oct->mmio[i].hw_addr)
> +                       goto unsupported_dev;
> +
>                 oct->mmio[i].mapped =3D 1;
>         }
>
> @@ -1015,8 +1018,8 @@ int octep_device_setup(struct octep_device *oct)
>         return 0;
>
>  unsupported_dev:
> -       for (i =3D 0; i < OCTEP_MMIO_REGIONS; i++)
> -               iounmap(oct->mmio[i].hw_addr);
> +       for (j =3D 0; j < i; j++)
> +               iounmap(oct->mmio[j].hw_addr);
>
>         kfree(oct->conf);
>         return -1;
>
[Kalesh]: fix to return -ENOMEM instead of -1.

> --
> 2.25.1
>
>
>

--=20
Regards,
Kalesh A P

--000000000000006bfe05fe10b64c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">One suggestion inline.<div><br></div><div=
>LGTM otherwise</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" =
class=3D"gmail_attr">On Wed, Jun 14, 2023 at 8:54=E2=80=AFAM Jiasheng Jiang=
 &lt;<a href=3D"mailto:jiasheng@iscas.ac.cn">jiasheng@iscas.ac.cn</a>&gt; w=
rote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Add check =
for ioremap() and return the error if it fails in order to<br>
guarantee the success of ioremap().<br>
<br>
Fixes: 862cd659a6fb (&quot;octeon_ep: Add driver framework and device initi=
alization&quot;)<br>
Signed-off-by: Jiasheng Jiang &lt;<a href=3D"mailto:jiasheng@iscas.ac.cn" t=
arget=3D"_blank">jiasheng@iscas.ac.cn</a>&gt;<br></blockquote><div>=C2=A0</=
div><div>Reviewed-by: Kalesh AP &lt;<a href=3D"mailto:kalesh-anakkur.purayi=
l@broadcom.com">kalesh-anakkur.purayil@broadcom.com</a>&gt;=C2=A0</div><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left=
:1px solid rgb(204,204,204);padding-left:1ex">
---<br>
=C2=A0drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 9 ++++++---<br>
=C2=A01 file changed, 6 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/=
net/ethernet/marvell/octeon_ep/octep_main.c<br>
index e1853da280f9..06816d2baef8 100644<br>
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c<br>
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c<br>
@@ -969,7 +969,7 @@ static const char *octep_devid_to_str(struct octep_devi=
ce *oct)<br>
=C2=A0int octep_device_setup(struct octep_device *oct)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct pci_dev *pdev =3D oct-&gt;pdev;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int i, ret;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int i, j, ret;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* allocate memory for oct-&gt;conf */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 oct-&gt;conf =3D kzalloc(sizeof(*oct-&gt;conf),=
 GFP_KERNEL);<br>
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
=A0 =C2=A0goto unsupported_dev;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 oct-&gt;mmio[i].map=
ped =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
@@ -1015,8 +1018,8 @@ int octep_device_setup(struct octep_device *oct)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
=C2=A0unsupported_dev:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; OCTEP_MMIO_REGIONS; i++)<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iounmap(oct-&gt;mmi=
o[i].hw_addr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (j =3D 0; j &lt; i; j++)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iounmap(oct-&gt;mmi=
o[j].hw_addr);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(oct-&gt;conf);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br></blockquote><div>[Kalesh]: fix t=
o return=C2=A0-ENOMEM instead of -1.=C2=A0</div><blockquote class=3D"gmail_=
quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,=
204);padding-left:1ex">
-- <br>
2.25.1<br>
<br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div><span class=3D"gmail_si=
gnature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><d=
iv dir=3D"ltr">Regards,<div>Kalesh A P</div></div></div></div>

--000000000000006bfe05fe10b64c--

--00000000000009a44a05fe10b667
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
AQkEMSIEIHTlueVLlcDch2X+Y1J+A48JhM2l2263uxZVxJRFAdgOMBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYxNDA2MDMzMFowaQYJKoZIhvcNAQkPMVwwWjAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCQqou1BC48
mxkqisFigYE45eton2Xe9Y6/tqaIIgf1f4hwXuikxWtdNgZe2eeFxiryDUtLW40nG+O51VlR41po
GroJ5/wdhqwbAnCoXV55zmGBKScwW4K58pcsDeADoiXSc4bOm1tLUm4AZZcSVO7CSwLsv+vVvwZ9
rYKOU1dARFGbIE1tTESW6/lfDmI6hxdb5Ub29l71L+80NBr4g5t+Xxu+1wEF3TU0HIiObXfj1ZJD
BBK9O1N6LJESLgVTiJfnui7Vo+tjiA+3of9PRVeeSYu+UKiYdXnB5t5o1MCO+GWoxbpBZQOP+hw/
e4hUBb9lfMAdztzbCkNlRcrcdYb8
--00000000000009a44a05fe10b667--

