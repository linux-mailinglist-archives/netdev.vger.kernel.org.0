Return-Path: <netdev+bounces-12107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6F5736253
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 05:50:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6B0A1C20AB8
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 03:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2564015CF;
	Tue, 20 Jun 2023 03:50:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EBF15B2
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:50:27 +0000 (UTC)
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9BC10DC
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:50:25 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b4745834f3so29017921fa.2
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1687233024; x=1689825024;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M/zi1zBa/EVsDMhbmq9uIEap51gbCsXEbPrdBx17DIo=;
        b=I90HmS3qNK3u4AF5ZHVmeHfqZGBr1grYoNLYw4w2IpZqPyls9aCqjgbUMnoNO8tZK9
         c+snOT7NLQZGim+pbvyEPMidlmcssva5M1rZR+ovq4NuSv6g7pXrVZN264QFfaGAyp0c
         3JJM31tlpWylCGAJUqGmOVFlIyp1eyad5zu0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687233024; x=1689825024;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/zi1zBa/EVsDMhbmq9uIEap51gbCsXEbPrdBx17DIo=;
        b=ajiPfUFko6aOO2kH+xLyrxdG0ELNC2dz+wYLzwEiVBDHVnxOCbMefp/umI9eBgA9h/
         dFibwLwLKmi4gxpgvA+NOP7qhjarVQ0gIdfgPztFVeWXPBlUj7AnMs3xR0xJtnnQ0QDJ
         JSZd6eG7ymW1bO0HCgSFTpNAHR7Z9mn93tcfolevohdMpT4xv2Wh6w1/7zRJtL/Qij3c
         uvxHzzfl5+E0XPe88xVdlt1GlhkGXBiqVXdEIwFa/nRoTHtg3hhEI8kVIp0UxpsQE6Go
         C3LaVD56MVWL3geBMQD17IWrWvBGLsagg18aT6vLEcFjzPFIumXe4WcZx6oxNmL0KBhk
         sXsA==
X-Gm-Message-State: AC+VfDzpUhUxIj8EHDwNtFMYhWARM/8QsaUeSqh8ppbR3ircEngO8ek/
	35dVbo4+ni+WmptgDxwCmDjBOR8zR873MB3a0JrKKA==
X-Google-Smtp-Source: ACHHUZ59fsIiSDkthRM/Z/5ctzoI1DowXyyL7G2LIpjosjJF10j9XXmEMQ5VnrXvBZ113t0HFtRoZk9rlRzW/ZXtyRw=
X-Received: by 2002:a2e:9b13:0:b0:2b4:6c47:6257 with SMTP id
 u19-20020a2e9b13000000b002b46c476257mr4144342lji.40.1687233023738; Mon, 19
 Jun 2023 20:50:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230619204700.6665-1-ansuelsmth@gmail.com> <20230619204700.6665-4-ansuelsmth@gmail.com>
In-Reply-To: <20230619204700.6665-4-ansuelsmth@gmail.com>
From: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Date: Tue, 20 Jun 2023 09:20:11 +0530
Message-ID: <CAH-L+nO12Gn4OGepr7KcCjLzMmisNYjYbFp13Aqu2Q14Rc77RA@mail.gmail.com>
Subject: Re: [net-next PATCH v5 3/3] leds: trigger: netdev: expose hw_control
 status via sysfs
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Dan Carpenter <dan.carpenter@linaro.org>, 
	linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000000f76c905fe878d91"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HTML_MESSAGE,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--0000000000000f76c905fe878d91
Content-Type: multipart/alternative; boundary="00000000000008e8c105fe878ded"

--00000000000008e8c105fe878ded
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2023 at 2:18=E2=80=AFAM Christian Marangi <ansuelsmth@gmail=
.com>
wrote:

> Expose hw_control status via sysfs for the netdev trigger to give
> userspace better understanding of the current state of the trigger and
> the LED.
>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/leds/trigger/ledtrig-netdev.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/leds/trigger/ledtrig-netdev.c
> b/drivers/leds/trigger/ledtrig-netdev.c
> index 2c1c9e95860e..32b66703068a 100644
> --- a/drivers/leds/trigger/ledtrig-netdev.c
> +++ b/drivers/leds/trigger/ledtrig-netdev.c
> @@ -406,6 +406,16 @@ static ssize_t interval_store(struct device *dev,
>
>  static DEVICE_ATTR_RW(interval);
>
> +static ssize_t hw_control_show(struct device *dev,
> +                              struct device_attribute *attr, char *buf)
> +{
> +       struct led_netdev_data *trigger_data =3D
> led_trigger_get_drvdata(dev);
> +
> +       return sprintf(buf, "%d\n", trigger_data->hw_control);
>
[Kalesh]: How about using sysfs_emit?

> +}
> +
> +static DEVICE_ATTR_RO(hw_control);
> +
>  static struct attribute *netdev_trig_attrs[] =3D {
>         &dev_attr_device_name.attr,
>         &dev_attr_link.attr,
> @@ -417,6 +427,7 @@ static struct attribute *netdev_trig_attrs[] =3D {
>         &dev_attr_rx.attr,
>         &dev_attr_tx.attr,
>         &dev_attr_interval.attr,
> +       &dev_attr_hw_control.attr,
>         NULL
>  };
>  ATTRIBUTE_GROUPS(netdev_trig);
> --
> 2.40.1
>
>
>

--=20
Regards,
Kalesh A P

--00000000000008e8c105fe878ded
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Jun 20, 2023 at 2:18=E2=80=AF=
AM Christian Marangi &lt;<a href=3D"mailto:ansuelsmth@gmail.com">ansuelsmth=
@gmail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">Expose hw_control status via sysfs for the netdev trigger to giv=
e<br>
userspace better understanding of the current state of the trigger and<br>
the LED.<br>
<br>
Signed-off-by: Christian Marangi &lt;<a href=3D"mailto:ansuelsmth@gmail.com=
" target=3D"_blank">ansuelsmth@gmail.com</a>&gt;<br>
Reviewed-by: Andrew Lunn &lt;<a href=3D"mailto:andrew@lunn.ch" target=3D"_b=
lank">andrew@lunn.ch</a>&gt;<br>
---<br>
=C2=A0drivers/leds/trigger/ledtrig-netdev.c | 11 +++++++++++<br>
=C2=A01 file changed, 11 insertions(+)<br>
<br>
diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/l=
edtrig-netdev.c<br>
index 2c1c9e95860e..32b66703068a 100644<br>
--- a/drivers/leds/trigger/ledtrig-netdev.c<br>
+++ b/drivers/leds/trigger/ledtrig-netdev.c<br>
@@ -406,6 +406,16 @@ static ssize_t interval_store(struct device *dev,<br>
<br>
=C2=A0static DEVICE_ATTR_RW(interval);<br>
<br>
+static ssize_t hw_control_show(struct device *dev,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct device_attribute *attr, char *buf)<b=
r>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct led_netdev_data *trigger_data =3D led_tr=
igger_get_drvdata(dev);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return sprintf(buf, &quot;%d\n&quot;, trigger_d=
ata-&gt;hw_control);<br></blockquote><div>[Kalesh]: How about using sysfs_e=
mit?=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
+}<br>
+<br>
+static DEVICE_ATTR_RO(hw_control);<br>
+<br>
=C2=A0static struct attribute *netdev_trig_attrs[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;dev_attr_device_name.attr,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;dev_attr_link.attr,<br>
@@ -417,6 +427,7 @@ static struct attribute *netdev_trig_attrs[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;dev_attr_rx.attr,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;dev_attr_tx.attr,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;dev_attr_interval.attr,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;dev_attr_hw_control.attr,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 NULL<br>
=C2=A0};<br>
=C2=A0ATTRIBUTE_GROUPS(netdev_trig);<br>
-- <br>
2.40.1<br>
<br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div><span class=3D"gmail_si=
gnature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><d=
iv dir=3D"ltr">Regards,<div>Kalesh A P</div></div></div></div>

--00000000000008e8c105fe878ded--

--0000000000000f76c905fe878d91
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
AQkEMSIEICk0GboruR7+D1QrUfymY4CQT0XXjyC6eUu7ePxNQj8XMBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYyMDAzNTAyNFowaQYJKoZIhvcNAQkPMVwwWjAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAiFOsA+PeW
CAN0GrenIyANdvfoxX5L6QkK2NGPRXmSuQSVQyYbq4EomBbAcRA4+HgZ/gm9F0TPncOtUp4hWXrg
7fPmA/5GEObqMXfepY72SO+qFOGda3VoO//PCcMOjcKCis1L0/9cs3K2x7wzM2m6/u0iCfbfgO6C
WM1wrWAlQ97xJfJwBtgoilFAHGdaoVkvdMkcV8I2/RhjEw7QLMEWHBDiw0o+ZcfJYDdMHjZOnJTc
PqlYMuor8GXm7G1yDUoU1mL9GqL7hZj7BlT8JDTddY8gwjPbjqiWaLAbtluvrZ86lTgA/B59bjSd
TkNwGmDJp8vNWlWjE4VJLFxqYhgL
--0000000000000f76c905fe878d91--

