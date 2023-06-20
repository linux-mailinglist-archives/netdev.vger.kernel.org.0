Return-Path: <netdev+bounces-12263-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC62736EA9
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E5CB1C20BDC
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0499168B6;
	Tue, 20 Jun 2023 14:29:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0371154A3
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:29:26 +0000 (UTC)
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7646E68
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:29:24 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b4826ba943so26843911fa.0
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1687271363; x=1689863363;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tJwcUZ12rx5Rk8RCVoQucqnl36uwWiihF8qYobMlEyE=;
        b=XOZu7I9GZ1FqMzG2VsIZNo5+qRM6qSLAgolLhRjXMvYi5nD1loreyrb/CHysinOjD7
         OGQdyYPp980KTc4jVliS/uubDNJmZ1T1OfEs1Qim78IXsYiumU208bL1zxiBu2sRIqIc
         CW6nL+Gp3tGsObYG6Y3RQ87lrIcNeynIQc/4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687271363; x=1689863363;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJwcUZ12rx5Rk8RCVoQucqnl36uwWiihF8qYobMlEyE=;
        b=Nu0XspqFtqAclpuW1YVnwnpCP3YFH4gMMs2Hcweit7ANnzV0F7O1J+wm4+N3+HS+SQ
         fOlMg5hKuDP6KYMq/EkJn0NPn0PiwgQFApV2YmpPl4RrRbD0d5lQ4AtKUN1bJLlaOhDx
         VSIPpLS+W18omQ9WA8t3VRAtYO74ot9k3T2s9rKlNMflkKdKiwVLmE7IFJjkHCyrYp7y
         yNXmdqeidv9B7Sysb82v5Q3mSJdEE2NObWYQf5EOQuFnX0OnEdc6x1TdoXTw9MxaXzR8
         k3X1u/eWkhfKdKvPFqOyirH/peiJ1j9bEgqiwhfogbnyW9pjpk4XrEPXzkHbOraSr+GA
         9SkA==
X-Gm-Message-State: AC+VfDyRu9mWOUacTVgQ/hoBxbFaqPbDSPNiC9BLRBzK4HvTZ2xkn07C
	dPgUk25GNZaM2TCvjScTExLvpdNnQoSyw48V2COt+gXz8fNCX3wJPVg=
X-Google-Smtp-Source: ACHHUZ4UJpbSKfRRNBkx2b3QRYdBfwdkzYZnA6M2PnQpF06FXy3ABT1nIqqnr6NlY05eE6abLl6Up0zkCRy26ZW+y0c=
X-Received: by 2002:a2e:6e06:0:b0:2b1:c54b:12e5 with SMTP id
 j6-20020a2e6e06000000b002b1c54b12e5mr8090268ljc.4.1687271362812; Tue, 20 Jun
 2023 07:29:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <53f95829-1a94-4565-aa75-f0335cd64b8a@moroto.mountain>
In-Reply-To: <53f95829-1a94-4565-aa75-f0335cd64b8a@moroto.mountain>
From: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Date: Tue, 20 Jun 2023 19:59:11 +0530
Message-ID: <CAH-L+nNpDQka_tfT7U007MujWizP-NQ32rAP=uWngneww13YhA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/mlx5: Fix error code in mlx5_is_reset_now_capable()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	kernel-janitors@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000003fa6e905fe907a7e"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HTML_MESSAGE,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--0000000000003fa6e905fe907a7e
Content-Type: multipart/alternative; boundary="00000000000038d36005fe907a45"

--00000000000038d36005fe907a45
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2023 at 7:13=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro=
.org>
wrote:

> The mlx5_is_reset_now_capable() function returns bool, not negative
> error codes.  So if fast teardown is not supported it should return
> false instead of -EOPNOTSUPP.
>
> Fixes: 92501fa6e421 ("net/mlx5: Ack on sync_reset_request only if PF can
> do reset_now")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
> b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
> index 7af2b14ab5d8..fb7874da3caa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
> @@ -327,7 +327,7 @@ static bool mlx5_is_reset_now_capable(struct
> mlx5_core_dev *dev)
>
>         if (!MLX5_CAP_GEN(dev, fast_teardown)) {
>                 mlx5_core_warn(dev, "fast teardown is not supported by
> firmware\n");
> -               return -EOPNOTSUPP;
> +               return false;
>         }
>
>         err =3D pci_read_config_word(dev->pdev, PCI_DEVICE_ID, &dev_id);
> --
> 2.39.2
>
>

--=20
Regards,
Kalesh A P

--00000000000038d36005fe907a45
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Jun 20, 2023 at 7:13=E2=80=AF=
PM Dan Carpenter &lt;<a href=3D"mailto:dan.carpenter@linaro.org">dan.carpen=
ter@linaro.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padd=
ing-left:1ex">The mlx5_is_reset_now_capable() function returns bool, not ne=
gative<br>
error codes.=C2=A0 So if fast teardown is not supported it should return<br=
>
false instead of -EOPNOTSUPP.<br>
<br>
Fixes: 92501fa6e421 (&quot;net/mlx5: Ack on sync_reset_request only if PF c=
an do reset_now&quot;)<br>
Signed-off-by: Dan Carpenter &lt;<a href=3D"mailto:dan.carpenter@linaro.org=
" target=3D"_blank">dan.carpenter@linaro.org</a>&gt;<br></blockquote><div>R=
eviewed-by: Kalesh AP &lt;<a href=3D"mailto:kalesh-anakkur.purayil@broadcom=
.com">kalesh-anakkur.purayil@broadcom.com</a>&gt;=C2=A0</div><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid=
 rgb(204,204,204);padding-left:1ex">
---<br>
=C2=A0drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/fw_reset.c<br>
index 7af2b14ab5d8..fb7874da3caa 100644<br>
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c<br>
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c<br>
@@ -327,7 +327,7 @@ static bool mlx5_is_reset_now_capable(struct mlx5_core_=
dev *dev)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!MLX5_CAP_GEN(dev, fast_teardown)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mlx5_core_warn(dev,=
 &quot;fast teardown is not supported by firmware\n&quot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EOPNOTSUPP;=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D pci_read_config_word(dev-&gt;pdev, PCI_=
DEVICE_ID, &amp;dev_id);<br>
-- <br>
2.39.2<br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div><span class=3D"gmail_si=
gnature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><d=
iv dir=3D"ltr">Regards,<div>Kalesh A P</div></div></div></div>

--00000000000038d36005fe907a45--

--0000000000003fa6e905fe907a7e
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
AQkEMSIEIH7aP37aX+9KoK1ss7Fe4NxvVKGrzFFAortZf/4mOZuhMBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYyMDE0MjkyM1owaQYJKoZIhvcNAQkPMVwwWjAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCELAIhwvIO
zhKkEP5Zh5gYQecbS3fO/ff1MP8vmi4o0AEuOIsh+FJYPQJsd0pNU5ZDVwRZIgnLHFoYRVADQimd
XMa0wBK//ezTINzYhqkoNKeGa5ffvnTXRtNxa7G79yyCLMm9en5Iib3HJZ+rvxFD870okq3aSx9U
HaVCLXqCD10n3WCj1JSad3Qz/79Dx5NNAvJXMuqIRDGi+ldxzViHVpzA/7FIXX+1eKMApCbgKCZs
3bpsQZJgSDZkwACHL3XJRecT+bRXYPqDDBX5SDdmb/TsdgV4qZpGt3c6EpSIlGKqLdwVO8YNAVFL
wi3BWzAqeTv6BltYbUR4RI1tdB2i
--0000000000003fa6e905fe907a7e--

