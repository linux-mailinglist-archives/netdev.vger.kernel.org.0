Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A52735F55E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351623AbhDNNqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 09:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345747AbhDNNqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 09:46:37 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23685C061756
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 06:46:16 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c123so16563672qke.1
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 06:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B6K3Kp3Jum8GUJiAaE22hVg7gfQhowaIuewFGQAqiWg=;
        b=WcIePUAnXxeSXGU2okHL8z7hLA4hsjMLTJsS+K2Qqyn7sxjl2DY59J8Hv790GQFG0U
         0Ik+yRLsSAdrJJNbWMcO793fjVo2F69pXh/OvWLVWpDwdjBCvrPe4fTl2nyk+CmUGEOY
         Cw5zgQHFUl0KIGQmxdahs4XMxbJkhcEnj+FAU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B6K3Kp3Jum8GUJiAaE22hVg7gfQhowaIuewFGQAqiWg=;
        b=pyM07ngvdzBhnhokP8O9SVYRhCfuUVHInveyAT0OC33XLLN14Hty9TtYFt7ruN3Dxa
         kBTxF1R32OCLthOzlI43b7qUOM3lc6JOe2WrV632XzO1OfEDAoFDobVL3pkECrGcfCVt
         y6zeH9vtp3fRtQv+/9PZqPr2duRpxyDSD3Jsbo87aUlK5rZpyvqRZSXWsT/AUFdnhAsW
         rq0hG7/VlbHOgtTzMM1+FicaUm1sGzonY3xCybmAONekUdoQAvFmzFUHcjwcgWPTuHgu
         hJ2qXm+2/uwmamN1Ngv1l+U6X36Feq/gPYCsMcdO/6wz7lN+tEe4HYziqqu/5CzUX9N1
         85CA==
X-Gm-Message-State: AOAM531q/QL4HIayyQSjLnOd3z2jcbrN0rFtN59tP7tTBdfi0k9oyZbc
        JYiXpnqP85xCT+s2UBWaLOzeooJIqJwaYgTVM55anA==
X-Google-Smtp-Source: ABdhPJy8xY80DplXS4paRTfp3E7tP42+cJlzsvL/OGo72YajwPh9l5uX2JaB34Vo4fuoL6jZVXSJ9pt/M/AaiO9shMQ=
X-Received: by 2002:a37:9e4e:: with SMTP id h75mr19210936qke.169.1618407974725;
 Wed, 14 Apr 2021 06:46:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210401065715.565226-1-leon@kernel.org> <CANjDDBiuw_VNepewLAtYE58Eg2JEsvGbpxttWyjV6DYMQdY5Zw@mail.gmail.com>
 <YGhUjarXh+BEK1pW@unreal> <CANjDDBiC-8pL+-ma1c0n8vjMaorm-CasV_D+_8q2LGy-AYuTVg@mail.gmail.com>
 <YG7srVMi8IEjuLfF@unreal> <CANjDDBirjSEkcDZ4E8u4Ce_dep3PRTmo2S9-q7=dmR+MLKi_=A@mail.gmail.com>
 <YHP5WRfEKQ3n9O0s@unreal>
In-Reply-To: <YHP5WRfEKQ3n9O0s@unreal>
From:   Devesh Sharma <devesh.sharma@broadcom.com>
Date:   Wed, 14 Apr 2021 19:15:37 +0530
Message-ID: <CANjDDBhpJPc6wypp2u3OC9RjYEpYmXuNozZ5fRHSmx=vLWeYNw@mail.gmail.com>
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
        boundary="0000000000007be58305bfeef8a5"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007be58305bfeef8a5
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 12, 2021 at 1:10 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, Apr 08, 2021 at 08:42:57PM +0530, Devesh Sharma wrote:
> > On Thu, Apr 8, 2021 at 5:14 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Thu, Apr 08, 2021 at 05:06:24PM +0530, Devesh Sharma wrote:
> > > > On Sat, Apr 3, 2021 at 5:12 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > On Sat, Apr 03, 2021 at 03:52:13PM +0530, Devesh Sharma wrote:
> > > > > > On Thu, Apr 1, 2021 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > > >
> > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > >
> > > > > > > Changelog:
> > > > > > > v2:
> > > > > > >  * kbuild spotted that I didn't delete all code in patch #5, so deleted
> > > > > > >    even more ulp_ops derefences.
> > > > > > > v1: https://lore.kernel.org/linux-rdma/20210329085212.257771-1-leon@kernel.org
> > > > > > >  * Go much deeper and removed useless ULP indirection
> > > > > > > v0: https://lore.kernel.org/linux-rdma/20210324142524.1135319-1-leon@kernel.org
> > > > > > > -----------------------------------------------------------------------
> > > > > > >
> > > > > > > The following series fixes issue spotted in [1], where bnxt_re driver
> > > > > > > messed with module reference counting in order to implement symbol
> > > > > > > dependency of bnxt_re and bnxt modules. All of this is done, when in
> > > > > > > upstream we have only one ULP user of that bnxt module. The simple
> > > > > > > declaration of exported symbol would do the trick.
> > > > > > >
> > > > > > > This series removes that custom module_get/_put, which is not supposed
> > > > > > > to be in the driver from the beginning and get rid of nasty indirection
> > > > > > > logic that isn't relevant for the upstream code.
> > > > > > >
> > > > > > > Such small changes allow us to simplify the bnxt code and my hope that
> > > > > > > Devesh will continue where I stopped and remove struct bnxt_ulp_ops too.
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > > [1] https://lore.kernel.org/linux-rdma/20210324142524.1135319-1-leon@kernel.org
> > > > > > >
> > > > > > > Leon Romanovsky (5):
> > > > > > >   RDMA/bnxt_re: Depend on bnxt ethernet driver and not blindly select it
> > > > > > >   RDMA/bnxt_re: Create direct symbolic link between bnxt modules
> > > > > > >   RDMA/bnxt_re: Get rid of custom module reference counting
> > > > > > >   net/bnxt: Remove useless check of non-existent ULP id
> > > > > > >   net/bnxt: Use direct API instead of useless indirection
> > > > > > >
> > > > > > >  drivers/infiniband/hw/bnxt_re/Kconfig         |   4 +-
> > > > > > >  drivers/infiniband/hw/bnxt_re/main.c          |  93 ++-----
> > > > > > >  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   4 +-
> > > > > > >  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   1 -
> > > > > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 245 +++++++-----------
> > > > > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  32 +--
> > > > > > >  6 files changed, 119 insertions(+), 260 deletions(-)
> > > > > >
> > > > > > Hi Leon,
> > > > > >
> > > > > > After a couple of internal discussions we reached a conclusion to
> > > > > > implement the Auxbus driver interface and fix the problem once and for
> > > > > > all.
> > > > >
> > > > > Thanks Devesh,
> > > > >
> > > > > Jason, it looks like we can proceed with this patchset, because in
> > > > > auxbus mode this module refcount and ULP indirection logics will be
> > > > > removed anyway.
> > > > >
> > > > > Thanks
> > > > Hi Leon,
> > > >
> > > > In my internal testing, I am seeing a crash using the 3rd patch. I am
> > > > spending a few cycles on debugging it. expect my input in a day or so.
> > >
> > > Can you please post the kernel crash report here?
> > > I don't see how function rename in patch #3 can cause to the crash.
> > Hey, unfortunately my kdump service config is giving me tough time on
> > my host. I will share if I get it.
>
> Any news here?
Expect something by this Friday. yesterday was a holiday in India.
>
> > >
> > > Thanks
> > >
> > > > >
> > > > > > >
> > > > > > > --
> > > > > > > 2.30.2
> > > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > -Regards
> > > > > > Devesh
> > > > >
> > > > >
> > > >
> > > >
> > > > --
> > > > -Regards
> > > > Devesh
> > >
> > >
> >
> >
> > --
> > -Regards
> > Devesh
>
>


-- 
-Regards
Devesh

--0000000000007be58305bfeef8a5
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
SHwwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBRXI5v1G94bQ0pZOn1BtqOJ0Wrp
VYVSFelfkLrL9/mHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQxNDEzNDYxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCKWf3pqICG/SB11jnq9k2u+6o+E+a0NfQdtU9NC13GYjRj
IY5gONz8z8XCrnnMkUwQv3dSriK9sCHbLm/N2e/DvOlean7KHO8za7vQWArkqZXEw+QnivDuVvRB
1cNH2XCxMOaPpKKa9NYgAp61kPX1EzGuqy7IvWLnnVKoP/Qp4hl5R3tWO8iw9HanqsaKmO6FlCue
yEYbu6UM9RyuY8deBzXot3eK6Zs4ycHoXDowbS2Sfbp2hSpsjl6/enWYa6TjeJks3R42x9ikvSFL
e3dQneSEzbD1Iegmn7+Ifh4wk5GfVpTTm13XdIbMB0Ih94R9NVdgabnzqhCr7LsQWxwE
--0000000000007be58305bfeef8a5--
