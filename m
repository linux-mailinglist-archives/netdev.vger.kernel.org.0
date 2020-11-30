Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F385E2C8BEE
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387561AbgK3SBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbgK3SBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:01:34 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83182C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:00:54 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id f16so12134750otl.11
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k3W82n2RGNhJaGuuiMCpv5fyXlF0/PTBAdOQgP56ER0=;
        b=XB8SGAz7wd19BeHCZgft4hxr539WSTS07afDDM0ebPlUzuAHxBfqt2D9MhCgwxW/X1
         KLJJl6QTuFTYI9NQXG3LSFzUoryT+lS478exDI+sDCDSHlqio/xJR4XdjnkNaU95hXWD
         zmjoXBhKu79m/8XavAf9Jpz/NHkh8rsJm3PJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k3W82n2RGNhJaGuuiMCpv5fyXlF0/PTBAdOQgP56ER0=;
        b=sX5j3dEUta0m2Mh6WWOjBjEkwnq8V8SFMzCSeA9mLJBo1kVrWKY8rIRNd6vc/XvVLT
         js8JvFbEohZakaqQSEv8RJvYIP/Ui62gUehdAy1YTykJY3cmEQv1ve+rPiIBNmQFpua3
         GomWxOoPhs6fW0DEmROaYKlfBCRAzygb6EDSQXjbce30uKsI8AQFjtHKg4xsF/Ha2gTP
         5/GIcPZ7oKR/7g6kXHMBCAgi1i/QmWx3JHfO2CxgCPpP/M9qiDU6wg9iLKfdh89kbFB2
         a1VBiLrWoUyLjhtubEZNdYBe/U5JLgPnbMBFghKD89moGY+KEWeh0WaZYo5hjgpYdvWi
         t3EA==
X-Gm-Message-State: AOAM530ZLAzQmY3y5OW2PoN5axtVbaP7xRRsfZF3Hfv21AkhufhNZy5B
        KHoDV2LarfaYQPa4DlLXFH2JeBBdLFxbabBE3fMCDGeABIVhdRwn
X-Google-Smtp-Source: ABdhPJwIDqyhTgIrMqhGdaJQvgkVcv7Wv7Rku4JCjLnDjlZlR3Dnc4djyJRH/9R2+HjIEeKBfKIdSQW/3bP4Er+kOGU=
X-Received: by 2002:a9d:5904:: with SMTP id t4mr17809590oth.109.1606759252431;
 Mon, 30 Nov 2020 10:00:52 -0800 (PST)
MIME-Version: 1.0
References: <20201010154119.3537085-1-idosch@idosch.org> <20201010154119.3537085-2-idosch@idosch.org>
 <CAKOOJTw1rRdS0+WRqeWY4Hc9gzwvPn7FGFdZuVd3hFYORcRz4g@mail.gmail.com>
 <20201123094026.GF3055@nanopsycho.orion> <CAKOOJTxEgR_E5YL2Y_wPUw_MFggLt8jbqyh5YOEKpH0=YHp7ug@mail.gmail.com>
 <20201130171428.GJ3055@nanopsycho.orion>
In-Reply-To: <20201130171428.GJ3055@nanopsycho.orion>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Mon, 30 Nov 2020 10:00:16 -0800
Message-ID: <CAKOOJTw54DxitbYHW7vNVWRv9BbsdmW_ARTgpMu5HBVjkTeQ5w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000095114905b556ca50"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000095114905b556ca50
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 30, 2020 at 9:14 AM Jiri Pirko <jiri@resnulli.us> wrote:

> >> There is a crucial difference. Split port is configured alwasy by user.
> >> Each split port has a devlink instace, netdevice associated with it.
> >> It is one level above the lanes.
> >
> >Right, but the one still implies the other. Splitting the port implies fewer
> >lanes available.
> >
> >I understand the concern if the device cannot provide sufficient MAC
> >resources to provide for the additional ports, but leaving a net device
> >unused (with the option to utilize an additional, now spare, port) still
> >seems better to me than leaving lanes unused and always wasted.
>
> I don't follow what exactly are you implying. Could you elaborate a bit
> more?

Perhaps an example...

Consider a physical QSFP connector comprising 4 lanes. Today, if the
speed is forced, we would achieve 100G speeds using all 4 lanes with
NRZ encoding. If we configure the port for PAM4 encoding at the same
speed, then we only require 2 of the available 4 lanes. The remaining 2
lanes are wasted. If we only require 2 of the 4 lanes, why not split the
port and request the same speed of one of the now split out ports? Now,
this same speed is only achievable using PAM4 encoding (it is implied)
and we have a spare, potentially usable, assuming an appropriate break-
out cable, port instead of the 2 unused lanes.

So concretely, I'm suggesting that if we want to force PAM4 at the lower
speeds, split the port and then we don't need an ethtool interface change
at all to achieve the same goal. Having a spare (potentially usable) port
is better than spare (unusable) lanes.

Now, if the port can't be split for some reason (perhaps there aren't
sufficient device MAC resources, stats contexts, whatever), then that's
a different story. But, even so, perhaps the port lane topology more
appropriately belongs as part of a device configuration interface in
devlink and the number of lanes available to a port should be a
property of the port instead of a link mode knob?

Regards,
Edwin Peer

--00000000000095114905b556ca50
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQPAYJKoZIhvcNAQcCoIIQLTCCECkCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2RMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFPjCCBCagAwIBAgIMJeAMB4FhbQcYqNJ3MA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTIxMTQw
MDAxWhcNMjIwOTIyMTQwMDAxWjCBijELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRMwEQYDVQQDEwpFZHdp
biBQZWVyMSYwJAYJKoZIhvcNAQkBFhdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBALZkjcD2jH2mN5F78vzmjoqoT5ujVLMwcp2NYaxxLTZP01zj
Tfg7/tZBilGR9qgaWWIpCYxok043ei/zTP7MdRcRYq5apvhdHM6xtTMSKIlOUqB1fuJOAfYeaRnY
NK7NAVZZorTl9hwbhMDkWGgTjCtwsxyKshje0xF7T1MkJ969pUzMZ9UI9OnIL4JxXRXR6QJOw2RW
sPsGEnk/hS2w1YGqQu0nb/+KPXW0yTC6a7hG0EhCv7Z14qxRLvAiGPqgMF/qilNUVBKEkeZQYfqT
mbo++PCnVfHaIk6rK1M0CPodEV0uUttmi6Mp/Ha7XmNgWQeQE3qkFIwAlb/kPNmJAMECAwEAAaOC
Ac4wggHKMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUHMAKGQWh0
dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNoYTJnM29j
c3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25h
bHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1UdHwQ9MDsw
OaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hhMmczLmNy
bDAiBgNVHREEGzAZgRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcD
BDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU9IOrXBkaTFAmOmjl
0nu9X2Lzo+0wDQYJKoZIhvcNAQELBQADggEBADL+5FenxoguXoMm8ZG+bsMvN0LibFO75wee8cJI
3K8dcJ8y6rPc6yvMRqI7CNwjWV5kBT3aQPZCdqOlNLl/HnKJxBt3WJRWGePcE1s/ljK4Kg1rUQAo
e3Fx6cKh9/q3gqElSPU5pBOsCEy8cbi6UGA+IVifQ2Mrm5tsvYqWSaZ1mKTGz8/z8vxG2kGJZI6W
wL3owFiCmLmw5R8OH22wqf/7sQFMRpH5IQFLRYdU9uCUy5FlUAgiCEXegph8ytxvo8MgYyQcCOeg
BMfFgFEHuM2IgsDQyFC6XUViX6BQny67nlrO8pqwNRJ9Bdd7ykLCzCLOuR1znBAc2wAL9OKQe0cx
ggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMw
MQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDCXgDAeB
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgLU8uYi3E2Z0E8R2sjt1T
rIkuCVU6oI8f78Q6NOFon4kwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjAxMTMwMTgwMDU0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAH4MSpxdt/6qKbbvOEOLYlVzGZuUdkLaSF70EVjl
faxJ0Qy4vhFORilVaCkhbbeQeKChW4jXTYPsk3V7cIrFgdHeLWW9uf0CSQKfE/KD3UsrMoTVSdov
+53vnA4yRQNCkkvQBV5NwSOPVmQIf40fHJm+VfpGUeYbyCIzGNMHDi6Q9KEFQIhO0akWgPVa7mAB
LU9tkVgxG9K/xk/Giv8nhOrv6EP88Ilaeet1gzYeojMqQUeux0lkwbxN74nbKLKoYuvY/A74j8ao
ea6vwbokC07sneaknIoa6PM4/YabY3Cwa8uGxY6llJUqogcJ/j1WLxXIrFL6l9NN//1zTtJz4pI=
--00000000000095114905b556ca50--
