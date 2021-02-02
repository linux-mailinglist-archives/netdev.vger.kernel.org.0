Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF91330B3F7
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 01:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhBBAP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 19:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhBBAPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 19:15:23 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EE6C0613ED
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 16:14:42 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id m22so25392876lfg.5
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 16:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oIN7OuiOoW+FgbETZokN5O9RJywkHLZUJdMPKSpaFs8=;
        b=Bd8rQ43K0OPYJfFjYB2qI7hjKts8f5816RsQDiiS1Vgbo3gQBfre5cl/UafgsELnrG
         AzrWt7mBRszzuwsg5cavPatcNtBkZSDQ/N8s8NO/wTRL3mYinYoWBXtm37XaqyA2Zd+W
         aMwUcKuIMdFsfmsfJhANlo2fsPqZsBBJC/X1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oIN7OuiOoW+FgbETZokN5O9RJywkHLZUJdMPKSpaFs8=;
        b=W0FmLsKcnm04UX8MAYobbE+m7dIQURrbm52SOuOKEicsPIcn8MPnZTCjo+d4EaU4qM
         12wPDXCfl99masJduLXvfEtvgwZnihlu/uZpQqNkmV1VxoqezTRfTA9Yz0vxCHimzNO0
         GYInVM7bWhzWGqnLeMs9kogXcdF7zpCYK9InFvaa4e0ZYVfLQtCYn5UEzBz4fgxa89Eo
         5mhjq8vJrIW4nvSmg41ctrBGTpsj1d2VIwAxy6itYmrlXy500EZ7u6Bhls88oXGtzdwQ
         8ECFyv+WwTqNxem872GvzVnhweitCSaXjxxmQHtDgPqQOD3vnoTRePQisNMT/uhrKNn/
         sNLQ==
X-Gm-Message-State: AOAM531yvuhL3liBX/zfkO+iY1N1jHXyTOO8oWeO+WnmAM0HJT/3B2Bw
        mOAE3Z44+KgZfsXyupjQHsQ2sSRYWhwgJkobsyqOUw==
X-Google-Smtp-Source: ABdhPJziqq95Y+JBSLsvvnb389QnCmMrQp/+8qo8ohvJMNGKtm+hdPAWjqDNJBRbS6GC4PcVanfmzjiPmM3ThF8nSfc=
X-Received: by 2002:a19:d3:: with SMTP id 202mr9043769lfa.570.1612224881393;
 Mon, 01 Feb 2021 16:14:41 -0800 (PST)
MIME-Version: 1.0
References: <20210120093713.4000363-1-danieller@nvidia.com>
 <DM6PR12MB4516DD64A5C46B80848D3645D8BC9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTyRyz+KTZvQ8XAZ+kehjbTtqeA3qv+r9DJmS-f9eC6qWg@mail.gmail.com>
 <DM6PR12MB45161FF65D43867C9ED96B6ED8BB9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <20210128202632.iqixlvdfey6sh7fe@lion.mk-sys.cz> <DM6PR12MB4516868A5BD4C2EED7EF818BD8B79@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTy2wSmBjRnbhmD6xQgy1GAdiXAxoRX7APNto4gDYUWNRw@mail.gmail.com>
 <DM6PR12MB45168B7B3516A37854812767D8B69@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTw2Z_SdPNsDeTanSatBLZ7=vh2FGjn_NASVUK2hbK7Q3Q@mail.gmail.com>
 <20210201122939.09c18efa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKOOJTw75uLVPpzV1a85SFsO7Gz9bcfS9M1CWHQONCfMLC4H6g@mail.gmail.com>
 <20210201134156.14693076@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKOOJTzcEPXmU=mu8PMvzkhv1CxWbL9pnmjYeYGgJHXnFW5W_g@mail.gmail.com> <20210201142029.4b7bd903@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201142029.4b7bd903@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Mon, 1 Feb 2021 16:14:05 -0800
Message-ID: <CAKOOJTzRs5xLwGHFDvCAhK8v88stoPhzrbg-hPBte9c+ia0yxg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Danielle Ratson <danieller@nvidia.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005f251c05ba4f5b68"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005f251c05ba4f5b68
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 1, 2021 at 2:20 PM Jakub Kicinski <kuba@kernel.org> wrote:

> > Should they not be the same thing?
>
> Okay. Does "supported modes" in ethtool for bnxt get ANDed with the
> supported modes of the plugged in module?
>
> What happens when no module is plugged in? List all?
>
> I've surveyed this behavior a few years back and three vendors I tested
> all had different interpretation on what to list in supported modes :/

Fair enough, I can't argue there. ;)

> > Yes, there would be multiple link modes that map to the same speed and
> > lane combination, but that doesn't mean you need to accept them if the
> > media doesn't match what's plugged in also. In the above scenario, the
> > supported mask should not list SR because CR is physically plugged in.
> > That way, the user knows what options are legal and the kernel knows
> > what it can reject.
>
> If the modes depend on what's plugged in - what happens if cable gets
> removed? We (you, Danielle, I) can agree what we think is best, but
> history teaches us that doesn't matter in long run. We had a similar
> conversation when it comes to FEC. There simply is no way for upstream
> developers to review the behavior is correct.

Given that supported is only defined in the context of autoneg today,
once could still specify. But again, you raise a fair concern.

The asymmetry in interface is still ugly though, you get to decide
which ugly is worse. :P

Regards,
Edwin Peer

--0000000000005f251c05ba4f5b68
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
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgc5Sua6ZbxJ9CZvm+r1vm
LBoxRnZhQKgRd8HS/iFQL44wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMjAyMDAxNDQxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJRTDT+ngaszRzHaN696eTLnx0i+vBJZQ6gZadp0
UvElcV4TpIqESHz9ftvRpzXHYhofSDcX/1ikZH8H64gbmSG0rprWJGKcIlsgCxfF4oQLPQ921JBE
pjiSLa57htjyQNKFTyF3H9Pd9jmIAur/XhHD7eSNI6ofGLdO4yVHcMW8arZXyWVlPYcJGsjtYLAD
QfU3ru21XPo1jya6t9TFchIEhu57evXj8TAd4Vv0Ar21pmOKSgF5pAF821wwJWPBX+ivRl9UpPUg
0r1ohFSzdy1nErnluHNVXuSTpWFzn04+AI0R0KQ/HzJktR6iFJ2nt654vBzegP1JmPiKQ8ZcT6Q=
--0000000000005f251c05ba4f5b68--
