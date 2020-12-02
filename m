Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1042CC459
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgLBRzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgLBRzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:55:10 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000C5C0613D4
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 09:54:29 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id y24so2450564otk.3
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 09:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XKXDSwzwN3DvDbrQ1CTHSLUB3du6MYM5ojk411EZVbU=;
        b=CZjUd2guM5b9M/zv1S/4YP9kviqicyFdedMYvVVXXYBhDaC9WiQsNNiYxKqBOmVxJY
         rKVxf8H9gOT8WxoJoeORf0/ee6T8/d1tGidqFT28GkOORF+LwOyxnhxp3Dla9XGOVg97
         Uz0MD5YCkP6/Vz475DGnNAGGe70OG9xjRpjRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XKXDSwzwN3DvDbrQ1CTHSLUB3du6MYM5ojk411EZVbU=;
        b=rpXSoLQGgOjPH+X1OMPk4co0AHHaqrbNUxf/FalMCVsBrlZrSlBWNqJwl+bm8VwK0W
         /SWSJW1PBnSed2dTcmdmT2REMpGVGlBJPFN9LGfKSppBXyZw5NFgNStYzD9+eZLSBi4J
         3xRn5jFbNwG5VDWaruUozJ7rk+LVBz446IlEhNZeJPkAifBob/XNNwG7g5RZmD41x3KV
         lsiIAnuGfs1Gk5vJvBdgPhqQZuubBc47FIOTDOc6Vymk/AHcgK7VRoTmsOJrdrJ+35Xx
         AXyeCZJyhxUcLT2UV5le+GUtu4vbRacgqZ0zdKhZ0kVTqKyJfz1TS2YAw7QD1qolDtN6
         41rQ==
X-Gm-Message-State: AOAM533cO2iUHIgakkU6pE70S8NTjXYL/cAAhFyYAK2YgyXZDxRTv5H6
        jpJywBKBKwf4qq49+KNLH3p5kOIGcK4qvPctvpvxVmULEaeF0Q==
X-Google-Smtp-Source: ABdhPJzeobTHIJ8r3s9hjQetVecQT1Q0Vcf+2v7FAb6gSFva90CUBWdHZrZAye21M5UQThz2Fj0GZ1AIcWLs4H3k4pA=
X-Received: by 2002:a9d:5904:: with SMTP id t4mr2783212oth.109.1606931667897;
 Wed, 02 Dec 2020 09:54:27 -0800 (PST)
MIME-Version: 1.0
References: <20201010154119.3537085-1-idosch@idosch.org> <20201010154119.3537085-2-idosch@idosch.org>
 <CAKOOJTw1rRdS0+WRqeWY4Hc9gzwvPn7FGFdZuVd3hFYORcRz4g@mail.gmail.com>
 <20201123094026.GF3055@nanopsycho.orion> <CAKOOJTxEgR_E5YL2Y_wPUw_MFggLt8jbqyh5YOEKpH0=YHp7ug@mail.gmail.com>
 <20201130171428.GJ3055@nanopsycho.orion> <CAKOOJTw54DxitbYHW7vNVWRv9BbsdmW_ARTgpMu5HBVjkTeQ5w@mail.gmail.com>
 <20201201112250.GK3055@nanopsycho.orion> <CAKOOJTxS8Lssq_CxhorCk33Byj+mM-FQLp+zSiCZSQhJpTMQDg@mail.gmail.com>
 <20201202100922.GM3055@nanopsycho.orion>
In-Reply-To: <20201202100922.GM3055@nanopsycho.orion>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Wed, 2 Dec 2020 09:53:51 -0800
Message-ID: <CAKOOJTwENt5HOon4rsGwB+PoJUxq1a1pWzNXVJsWmhe8198P0A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, f.fainelli@gmail.com,
        Michal Kubecek <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000058880e05b57eefe6"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000058880e05b57eefe6
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 2, 2020 at 2:09 AM Jiri Pirko <jiri@resnulli.us> wrote:

> >I'm not suggesting the port split be dynamic at all. I'm suggesting that if
> >the admin wants or needs to force PAM4 on a port that would otherwise
> >be able to achieve the given speed using more lanes with NRZ, then the
> >admin should split the port, so that it has fewer lanes, in order to make
> >that intent clear (or otherwise configure the port to have fewer lanes
> >attached, if you really don't want to or can't create the additional split
> >port).
>
> Okay, I see your point now. The thing is, the port split/unsplit causes
> a great distubance. Meaning, the netdevs all of the port
> disappear/reappear. Now consider following example:

I guess that's a detail of the present implementation and/or device
capabilities (I'm not particularly familiar), but presumably it is at least
possible, in principle, to modify a device's port config without taking
down the netdev. That said, after spending more time thinking about
this, I'm coming around to the idea of being able to explicitly set
encoding (not lanes) via ethtool. And, in this context, by encoding,
I technically mean line code signalling, not symbol encoding.

Although it does for today's link modes, the number of lanes does
not generally imply signalling mode. In future we may have PAM8
signalling and then the present proposal of deriving the signalling
mode for a given speed from the lane count falls down. We should
be specifying signalling mode via ethtool instead of lanes.

Alternatively, we need to be specifying the fully defined link mode.
But, doing so is fraught with other issues, including how to represent
it in the interface and the fact that the user doesn't necessarily want
to specify physical media in these cases, something that is implied
by the full link mode definition.

Regards,
Edwin Peer

--00000000000058880e05b57eefe6
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
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg8SyHluqgcFOn9f5/s70F
dgHRbvzUiFhEMGxaJgcmhWQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjAxMjAyMTc1NDI5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAEwimYMA21N9OkUcsagFQCcGZ2AsZNpUhGgOX63T
4KRo16UptEPHfaSy5IkWbtISOwS6vTq2CP2cIJ7rZCSywug4JI6xm8tYik2wWPcD8iJc1D1q1VYS
ZsdBgu+hOeLk80uNa4Gk9HfNnDFcB8kE9mDuMnVdrzf+Q0TSBIt721vdpNpr94xAWHV+B0xOBPa5
DcIYR/P2MF10OjVHMdYUlSMsVvS2lt1Vq2LPhVxYWqCD/n2DFWsfJK0yRGo3xEs2Ij0wuPY4JeVX
wF5SHiJakPx/3ZvaifivsTX7XZG3Xm1spEFva8OYD1h7OGo9jIBpmr2YasIld+YQWsml5rveK20=
--00000000000058880e05b57eefe6--
