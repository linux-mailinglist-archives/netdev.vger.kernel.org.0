Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EC12DB851
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgLPBNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgLPBNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 20:13:51 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53705C0613D6
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:13:10 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id 9so5339881ooy.7
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jymBp9EI2lMAQGBLoPKzKkxzIj4Pl50pDUtp9uQKJnE=;
        b=Zqx4LsElrEXpvNYSmNvY58Wa7E/UxF1ut7tb2P0ymkVVkkTULahb8ER6HtaDIxLx+/
         EPUzoPlSFKOaVPc5X9LrLRY5CfkBem5C+EPouAwKPR/aMG8yJ4kLd1+JcGFF5S6PBbTr
         4j0CQYOV6PsGDMy64+mPXr/cWHPiG+r2qL4ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jymBp9EI2lMAQGBLoPKzKkxzIj4Pl50pDUtp9uQKJnE=;
        b=GqbZXpI0ebgxtOJCyAfudI7J7ceQbQktndeNMMn8z2ygMk0vQdvsKbTU9ZuZa0FG5U
         XY5ZFGgnvA7dRodvvUyIQE7TH2HvqViWcswK6rbd8wAzftgUqdtgGYQt/rylKClgcaK6
         Z1SazsU34nf5s7P1AUp65DfpNKxnn+D53p9XPRIWyXe2ViSWvWuRlOARj3BaqoTuJ7yf
         +b+hwxNBRAQM3ipjX0MSuuSC242E/syaM6hx7VnMk6Uk9MkfH2N5DiI3chufs0/b956m
         uTLsGImA8y7lYVrGcsLzSyEmTsGe+gbHmzOv+7Ubhfroj83G9nB3jbh2afXZ2FN9Ecuo
         PkUw==
X-Gm-Message-State: AOAM532SfxPzyDxbVfVwVV3t6pXqPalWfHHEOKoBjq3HCtmn+EEBDbmT
        wCs5lxFDGuq8rmftq+y+IQ1Nl6YAiWGev5cWZ5NgWtFNYaWaMvNDw5DnLFPRu79V6U7qHOK7g2e
        RugAtEVndaXeQViZGNzAaY2Q=
X-Google-Smtp-Source: ABdhPJxaP60i928JyYAyFj3l7wwYYF9ZABNzeLOOx3CP1HFSeVMuIXFX8I663HoY3QCHSKuHb8525NUuYFUbOYja6wg=
X-Received: by 2002:a4a:e1c1:: with SMTP id n1mr24085332oot.36.1608081189519;
 Tue, 15 Dec 2020 17:13:09 -0800 (PST)
MIME-Version: 1.0
References: <20201214214352.198172-1-saeed@kernel.org> <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <BY5PR12MB43221CE397D6310F2B04D9B4DCC60@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKgT0Uf9C5gwVZ1DnkrGYHMUvxe-bqwwcbTo7A0q-trrULJSUg@mail.gmail.com>
In-Reply-To: <CAKgT0Uf9C5gwVZ1DnkrGYHMUvxe-bqwwcbTo7A0q-trrULJSUg@mail.gmail.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Tue, 15 Dec 2020 17:12:33 -0800
Message-ID: <CAKOOJTybz71h6V5228vk1erusfb-QJQEQPOaRKzmspfotRHYhA@mail.gmail.com>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000179f3105b68a94c4"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000179f3105b68a94c4
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 15, 2020 at 10:49 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:

> It isn't "SR-IOV done right" it seems more like "VMDq done better".

I don't think I agree with that assertion. The fact that VMDq can talk
to a common driver still makes VMDq preferable in some respects. Thus,
subfunctions do appear to be more of a better SR-IOV than a better
VMDq, but I'm similarly not sold on whether a better SR-IOV is
sufficient benefit to warrant the additional complexity this
introduces. If I understand correctly, subfunctions buy two things:

1) More than 256 SFs are possible: Maybe it's about time PCI-SIG
addresses this limit for VFs? If that were the only problem with VFs,
then fixing it once there would be cleaner. The devlink interface for
configuring a SF is certainly more sexy than legacy SR-IOV, but it
shouldn't be fundamentally impossible to zhuzh up VFs either. One can
also imagine possibilities around remapping multiple PFs (and their
VFs) in a clever way to get around the limited number of PCI resources
exposed to the host.

2) More flexible division of resources: It's not clear that device
firmwarre can't perform smarter allocation than N/<num VFs>, but
subfunctions also appear to allow sharing of certain resources by the
PF driver, if desirable. To the extent that resources are shared, how
are workloads isolated from each other?

I'm not sure I like the idea of having to support another resource
allocation model in our driver just to support this, at least not
without a clearer understanding of what is being gained.

Like you, I would also prefer a more common infrastructure for
exposing something based on VirtIO/VMDq as the container/VM facing
netdevs. Is the lowest common denominator that a VMDq based interface
would constrain things to really unsuitable for container use cases?
Is the added complexity and confusion around VF vs SF vs VMDq really
warranted? I also don't see how this tackles container/VF portability,
migration of workloads, kernel network stack bypass, or any of the
other legacy limitations regarding SR-IOV VFs when we have vendor
specific aux bus drivers talking directly to vendor specific backend
hardware resources. In this regard, don't subfunctions, by definition,
have most of the same limitations as SR-IOV VFs?

Regards,
Edwin Peer

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000179f3105b68a94c4
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
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgaR0hgHssL/p+abFgNRqm
+wM4Df3eZtI5YSU0B+Hc+S0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjAxMjE2MDExMzA5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAD8EyXA0bsIw0R0pCodxRB74eGBhhqANUQqUXRuB
j0yqFHt2FkeAmfd48tWfpA1CAIj7oXE7UrBWgABr9a9Z4HY9ArEjBLslNNORgTtCTzBmF/OuQdUO
5scpWPOMA7UN0GVwsmHN0kMAJr8VmqBg2F9ZDBCV/kWS8K9Ka6qzImonmK2UkB0ZwzxbgcbzngrK
YVCZs5nEHsi/PLko9//E5N4inwSqVzqZYy9tcvQ5Z4Z1Bw4Azjg9ccwRGxreWpzZ9VTq+ZYp40py
O755ergdpKVz4dN8WOTZY1dck7ktcoE2EM2uqEmizZ5YSgC+jvaK+cUAUhOn0fawOGIsIqD0kVQ=
--000000000000179f3105b68a94c4--
