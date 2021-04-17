Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B973631DE
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 20:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbhDQSkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 14:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbhDQSkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 14:40:21 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F04C061574
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 11:39:54 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id f19so14494354qka.8
        for <netdev@vger.kernel.org>; Sat, 17 Apr 2021 11:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YreiVG4YmXwbqiTIWQqrUhNEO+Smib4+eBCRhnHIE2A=;
        b=TdOya7sR7UAtkEGdBdWjgQ5Vx3kXun4cFGFP8cqCxL4ltAqPdiq1U3QLCxZdU56vq2
         wReneQickNVr7Kg8JnpIg3Z5BywUst0i7wlKm15PYt+NSVWkl2hSFfxCE+eQCypSd3Mf
         nx8da86HvgCVwkKBI+427udGLBKpGWpw8IaPI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YreiVG4YmXwbqiTIWQqrUhNEO+Smib4+eBCRhnHIE2A=;
        b=O6p7WtmhltGiOlCrqkKQjCfGagSuT96bS5H1Iw6iFumG1jdGu+p8NJcwSTlO57+JLO
         KVRK3SKVfWWquHfeZlNdxXEBlZTOp6vhfhA8+IdcLA1khyEtDy3O/bSCGc1lOMZvV/1t
         wxVnhlO0BEYuaM37XUQ9q1azmEienyjFD/tnGrd9OkGLB2iC/ku/on9lWXTUQ2UWi5JS
         B5wuv+6HJPoJHSIPObdUCnNYWz3p1VqKqtzS5ROERablSvPWMyH+WwVGjr8Ut4Abqy3K
         QjbRU51vqmPIpzUnBQ96bI0TXgRwckPCgMmvZhPyiknCtqfQp+pl5PZGxQ3rNyYvukyl
         vhMQ==
X-Gm-Message-State: AOAM5317H14rzyCH9DcUh9kxwkpUW3y8qVxyhCz4RObkv6x5B9Dthwo2
        IvyqYEO0g8ITNVpwsqKDc3zRwYW1vEg6sEiil7MDiQ==
X-Google-Smtp-Source: ABdhPJyiVNjWBQm+XFcUTA+e76eTtbuZKCkTJdyxZZwOaB3FradsjnxrkvqJKMwxIud51/WtOilfsreF8XpufEPYM7M=
X-Received: by 2002:a37:9e4e:: with SMTP id h75mr4983695qke.169.1618684793427;
 Sat, 17 Apr 2021 11:39:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210401065715.565226-1-leon@kernel.org> <CANjDDBiuw_VNepewLAtYE58Eg2JEsvGbpxttWyjV6DYMQdY5Zw@mail.gmail.com>
 <YGhUjarXh+BEK1pW@unreal> <CANjDDBiC-8pL+-ma1c0n8vjMaorm-CasV_D+_8q2LGy-AYuTVg@mail.gmail.com>
 <YG7srVMi8IEjuLfF@unreal> <CANjDDBirjSEkcDZ4E8u4Ce_dep3PRTmo2S9-q7=dmR+MLKi_=A@mail.gmail.com>
 <YHP5WRfEKQ3n9O0s@unreal> <CANjDDBhpJPc6wypp2u3OC9RjYEpYmXuNozZ5fRHSmx=vLWeYNw@mail.gmail.com>
 <YHqY8Led24PuLU5W@unreal>
In-Reply-To: <YHqY8Led24PuLU5W@unreal>
From:   Devesh Sharma <devesh.sharma@broadcom.com>
Date:   Sun, 18 Apr 2021 00:09:16 +0530
Message-ID: <CANjDDBgsh9FrQOgB-uR0GGYZHcF5cnTy4Efnd3L_-T2_eWqxsg@mail.gmail.com>
Subject: Re: [PATCH rdma-next v2 0/5] Get rid of custom made module dependency
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000025e22c05c02f6c45"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000025e22c05c02f6c45
Content-Type: text/plain; charset="UTF-8"

On Sat, Apr 17, 2021 at 1:44 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Apr 14, 2021 at 07:15:37PM +0530, Devesh Sharma wrote:
> > On Mon, Apr 12, 2021 at 1:10 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Thu, Apr 08, 2021 at 08:42:57PM +0530, Devesh Sharma wrote:
> > > > On Thu, Apr 8, 2021 at 5:14 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > On Thu, Apr 08, 2021 at 05:06:24PM +0530, Devesh Sharma wrote:
> > > > > > On Sat, Apr 3, 2021 at 5:12 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > > >
> > > > > > > On Sat, Apr 03, 2021 at 03:52:13PM +0530, Devesh Sharma wrote:
> > > > > > > > On Thu, Apr 1, 2021 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > > > > >
> > > > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > > >
> > > > > > > > > Changelog:
> > > > > > > > > v2:
> > > > > > > > >  * kbuild spotted that I didn't delete all code in patch #5, so deleted
> > > > > > > > >    even more ulp_ops derefences.
> > > > > > > > > v1: https://lore.kernel.org/linux-rdma/20210329085212.257771-1-leon@kernel.org
> > > > > > > > >  * Go much deeper and removed useless ULP indirection
> > > > > > > > > v0: https://lore.kernel.org/linux-rdma/20210324142524.1135319-1-leon@kernel.org
> > > > > > > > > -----------------------------------------------------------------------
> > > > > > > > >
> > > > > > > > > The following series fixes issue spotted in [1], where bnxt_re driver
> > > > > > > > > messed with module reference counting in order to implement symbol
> > > > > > > > > dependency of bnxt_re and bnxt modules. All of this is done, when in
> > > > > > > > > upstream we have only one ULP user of that bnxt module. The simple
> > > > > > > > > declaration of exported symbol would do the trick.
> > > > > > > > >
> > > > > > > > > This series removes that custom module_get/_put, which is not supposed
> > > > > > > > > to be in the driver from the beginning and get rid of nasty indirection
> > > > > > > > > logic that isn't relevant for the upstream code.
> > > > > > > > >
> > > > > > > > > Such small changes allow us to simplify the bnxt code and my hope that
> > > > > > > > > Devesh will continue where I stopped and remove struct bnxt_ulp_ops too.
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > > >
> > > > > > > > > [1] https://lore.kernel.org/linux-rdma/20210324142524.1135319-1-leon@kernel.org
> > > > > > > > >
> > > > > > > > > Leon Romanovsky (5):
> > > > > > > > >   RDMA/bnxt_re: Depend on bnxt ethernet driver and not blindly select it
> > > > > > > > >   RDMA/bnxt_re: Create direct symbolic link between bnxt modules
> > > > > > > > >   RDMA/bnxt_re: Get rid of custom module reference counting
> > > > > > > > >   net/bnxt: Remove useless check of non-existent ULP id
> > > > > > > > >   net/bnxt: Use direct API instead of useless indirection
> > > > > > > > >
> > > > > > > > >  drivers/infiniband/hw/bnxt_re/Kconfig         |   4 +-
> > > > > > > > >  drivers/infiniband/hw/bnxt_re/main.c          |  93 ++-----
> > > > > > > > >  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   4 +-
> > > > > > > > >  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   1 -
> > > > > > > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 245 +++++++-----------
> > > > > > > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  32 +--
> > > > > > > > >  6 files changed, 119 insertions(+), 260 deletions(-)
> > > > > > > >
> > > > > > > > Hi Leon,
> > > > > > > >
> > > > > > > > After a couple of internal discussions we reached a conclusion to
> > > > > > > > implement the Auxbus driver interface and fix the problem once and for
> > > > > > > > all.
> > > > > > >
> > > > > > > Thanks Devesh,
> > > > > > >
> > > > > > > Jason, it looks like we can proceed with this patchset, because in
> > > > > > > auxbus mode this module refcount and ULP indirection logics will be
> > > > > > > removed anyway.
> > > > > > >
> > > > > > > Thanks
> > > > > > Hi Leon,
> > > > > >
> > > > > > In my internal testing, I am seeing a crash using the 3rd patch. I am
> > > > > > spending a few cycles on debugging it. expect my input in a day or so.
> > > > >
> > > > > Can you please post the kernel crash report here?
> > > > > I don't see how function rename in patch #3 can cause to the crash.
> > > > Hey, unfortunately my kdump service config is giving me tough time on
> > > > my host. I will share if I get it.
> > >
> > > Any news here?
> > Expect something by this Friday. yesterday was a holiday in India.
>
> Any update?
> This series is close to three weeks already and I would like to progress with it.
Hi Leon,

The host crash I indicated earlier is actually caused by patch 4 and
not by patch 3 from this series. I spent time to root cause the
problem and realized that patch-4 is touching quite many areas which
would require much intrusive testing and validation.
As I indicated earlier, we are implementing the PCI Aux driver
interface at a faster pace. While PCI Aux changes are in progress we
are willing to retain the existing bnxt_re and bnxt_en interface
untouched.
The problem of module referencing would be rectified with PCI aux
change by inheritance.
>
> Thanks




--
-Regards
Devesh

--00000000000025e22c05c02f6c45
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
TUsFTOuxP4FZ9JSu9FWkGJGPobx8FmEvg+HybmXuUG0+PU7EDHKNoW8AcgZvIQYbwfevqWBFwwRD
Paihaaj18xGk21lqZcO0BecWKYyV4k9E8poof1dH+GnKqwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRpkZXZlc2guc2hhcm1hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEe3qNwswWXCeWt/hTDSC
KajMvUgwDQYJKoZIhvcNAQELBQADggEBAGm+rkHFWdX4Z3YnpNuhM5Sj6w4b4z1pe+LtSquNyt9X
SNuffkoBuPMkEpU3AF9DKJQChG64RAf5UWT/7pOK6lx2kZwhjjXjk9bQVlo6bpojz99/6cqmUyxG
PsH1dIxDlPUxwxCksGuW65DORNZgmD6mIwNhKI4Thtdf5H6zGq2ke0523YysUqecSws1AHeA1B3d
G6Yi9ScSuy1K8yGKKgHn/ZDCLAVEG92Ax5kxUaivh1BLKdo3kZX8Ot/0mmWvFcjEqRyCE5CL9WAo
PU3wdmxYDWOzX5HgFsvArQl4oXob3zKc58TNeGivC9m1KwWJphsMkZNjc2IVVC8gIryWh90xggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwhg1OJo0VLRNay
SHwwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIP1cZpbcyPEn9JxTc1jxoFlAzx8l
cf1RKSDGJUT+T3hDMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQxNzE4Mzk1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBn+1GmkhQsfP0QR20NU7UDUE/Gre9MTu3/ugS+MfW/cAUx
d2/4ng+0OLnuOrVSOF6vp8TKW7+5Sieg+3todeB1Gl48pkXOQdZj5pYy5cnfXJgpx0uCCeSKlu8Y
sMe2G9oIJ5c5SWA+rTqfUfoL1XCkR4UJtJj2XXKFfZjq7rcbwDvNobmCQy2JYPp4t01y2eXgf4FM
/PrLhB6plSv5vuv9CsiSdQripP4HDPtgHNTqdngdtwgHEjN8gE0cyAqRrBskTSGPWXeHszoluUn3
c+AjiZC7+BziHs2oD2rRr5c0prGolXUx1PS5LyloUm7dxDNpyrUA/QhMMVffHXIAF1/R
--00000000000025e22c05c02f6c45--
