Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D0E2CB194
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 01:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgLBAeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 19:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgLBAeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 19:34:03 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CDCC0613D4
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 16:33:23 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id b62so99155otc.5
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 16:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LXV87Nc+MGhVLRyRfZDnwomaTBRJMYY/v0U8fp2vpuc=;
        b=CHNIT0fNA0rDPNGEi2czspPWiEHH9gFXnTY+b4RbjyaChhWtMFaL4nCt76HP/oz+gg
         gMeLeB0K0UFINU2f40d5SgbRJeFEyE65yqEKyrLUBz0j3jwlK5e1OtO9qvkN9GFT2oBM
         JNI6Qvu6UE2CbDZDqnH7ARz8GjKyq/Hl+0Tas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LXV87Nc+MGhVLRyRfZDnwomaTBRJMYY/v0U8fp2vpuc=;
        b=DfqUhsXHTh0sN1o1Z4LDzxbah6euUuABYJIeat8HEH8lX+U7vQBY9JashWo6GyyHf2
         lLXXVmIxP1qmJujYH6ItK/G9dDm/v5UjYJlqOP/NCGVnTQBakgg9mNuf/yHds7rFpZMx
         4G5x5Fv8e9twEavgvOToPNMRX3K0IvmjqC3QcMmWlyb9ZFDh5SdYaZP8Lu4oV3qSSvMM
         HGLm/+ue5l39qNDZ+yJUISMQzQtoJFnZH6du1s+u2tzzk2tNk0OtnZZNqs/vmmLeIjWu
         D/iV2jAaOFDV9do2hfUkk7XbKSh9VDZjMbyLIqY2D7CkgqnsXcawViePaGTQcTDXhoM7
         SJvQ==
X-Gm-Message-State: AOAM533OBXA8A0ZrI342Kv8GxJlGQ324Ns9H97+XpxdLKc8aIOqFUE+I
        b+ZXodNcQLSYH26PK4kZQiC5sU3sZZ2/nydogXpgbA==
X-Google-Smtp-Source: ABdhPJwhBOZK0/hWypqVyvXwsmnTovV4q5kAy0qtXERTgn1rYOQ8yhGWpE059unRzKBBdo6LI7ZnYEOo85jrTg0JFws=
X-Received: by 2002:a9d:5904:: with SMTP id t4mr72745oth.109.1606869202450;
 Tue, 01 Dec 2020 16:33:22 -0800 (PST)
MIME-Version: 1.0
References: <20201010154119.3537085-1-idosch@idosch.org> <20201010154119.3537085-2-idosch@idosch.org>
 <CAKOOJTw1rRdS0+WRqeWY4Hc9gzwvPn7FGFdZuVd3hFYORcRz4g@mail.gmail.com>
 <20201123094026.GF3055@nanopsycho.orion> <CAKOOJTxEgR_E5YL2Y_wPUw_MFggLt8jbqyh5YOEKpH0=YHp7ug@mail.gmail.com>
 <20201130171428.GJ3055@nanopsycho.orion> <CAKOOJTw54DxitbYHW7vNVWRv9BbsdmW_ARTgpMu5HBVjkTeQ5w@mail.gmail.com>
 <20201201112250.GK3055@nanopsycho.orion>
In-Reply-To: <20201201112250.GK3055@nanopsycho.orion>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Tue, 1 Dec 2020 16:32:46 -0800
Message-ID: <CAKOOJTxS8Lssq_CxhorCk33Byj+mM-FQLp+zSiCZSQhJpTMQDg@mail.gmail.com>
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
        boundary="00000000000008175a05b5706468"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000008175a05b5706468
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 1, 2020 at 3:22 AM Jiri Pirko <jiri@resnulli.us> wrote:

> >Consider a physical QSFP connector comprising 4 lanes. Today, if the
> >speed is forced, we would achieve 100G speeds using all 4 lanes with
> >NRZ encoding. If we configure the port for PAM4 encoding at the same
> >speed, then we only require 2 of the available 4 lanes. The remaining 2
> >lanes are wasted. If we only require 2 of the 4 lanes, why not split the
> >port and request the same speed of one of the now split out ports? Now,
> >this same speed is only achievable using PAM4 encoding (it is implied)
> >and we have a spare, potentially usable, assuming an appropriate break-
> >out cable, port instead of the 2 unused lanes.
>
> I don't see how this dynamic split port could work in real life to be
> honest. The split is something admin needs to configure and can rely
> that netdevice exists all the time and not comes and goes under
> different circumstances. Multiple obvious reasons why.

I'm not suggesting the port split be dynamic at all. I'm suggesting that if
the admin wants or needs to force PAM4 on a port that would otherwise
be able to achieve the given speed using more lanes with NRZ, then the
admin should split the port, so that it has fewer lanes, in order to make
that intent clear (or otherwise configure the port to have fewer lanes
attached, if you really don't want to or can't create the additional split
port).

Using this approach, the existing ethtool forced speed interface is
sufficient to configure all possible lane encodings, because the
encoding that the driver must select is now implicit (note, we don't
need to care about media type here). That is, the driver can always
select the encoding that maximizes utilization of the lanes available
to the port (as defined by the admin).

> >So concretely, I'm suggesting that if we want to force PAM4 at the lower
> >speeds, split the port and then we don't need an ethtool interface change
> >at all to achieve the same goal. Having a spare (potentially usable) port
> >is better than spare (unusable) lanes.
>
> The admin has to decide, define.

I'm not sure I understand. The admin would indeed decide. This paragraph
merely served to motivate why a rational admin should prefer to have a
spare port rather than unused lanes he can't use, because they would be
attached to a port using an encoding that doesn't need them. If he wasn't
planning on using the additional port, he loses nothing. Otherwise, he gains
something he would not otherwise have had (it's win-win). From the
perspective of the original port, two unused lanes is no different than two
lanes allocated to another logical port.

Regards,
Edwin Peer

--00000000000008175a05b5706468
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgS5ZB15cszvxBYcT7JyDx
JFByDfqonmH3BJFVJEKrq7AwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjAxMjAyMDAzMzIyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFzwBafndNY3JYFDbBUOUwBKPcdIpDZmb0aXTUiM
LyzPehUZknc3D/DXl1puJCu/ubE415rFrd5nYwbXeHORFvw4x39iRgXE80xKq2UPoygAgWKLG5wd
yVU2r502l4q4A+kFeg6kUDNWQl8UtSkVXqr98XHKy+I07GQxQeS/CgScGNsIzG88+CUBVM8TJdap
9z8LIX2GHqHUEnDr6n7tA4oMYrTCG6AlLQuu4TTyzvfs/EnjNjniuObNSw/g5shE1h+Ty5TJpIY9
/O5GN+pcA1ihaLo+PtawyIyfyv1fU5flcuKSMavOQNYttQLV59MvQ4Glz80xPErnwv6s8REndzM=
--00000000000008175a05b5706468--
