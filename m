Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825425A0249
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 21:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbiHXTuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 15:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiHXTuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 15:50:12 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2396FA21
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:50:11 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id y4so13715480qvp.3
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc;
        bh=5NyAkJn88q4fj6SVb21XXpvDThvqyp7dperb96zj7EA=;
        b=EbCmTW50WIzoFwzHhucV3eWUWHZhKnns7eKxXFnuuWn4e/p7Qij83wSPH60x9ohrFZ
         tQnZhLJpTMxdfB/uy4unDMmKXSFSZJsSux4rrSCcuLiG2QcIyPV8H63csjS1rOYjUX1h
         sBTIZlY285QmHJwz2O/hhFrvi7hRZ8RhZj3MI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-message-state:from:to:cc;
        bh=5NyAkJn88q4fj6SVb21XXpvDThvqyp7dperb96zj7EA=;
        b=KLxXALjKxLuJV/LlLln3vQiknY5RQ4QcnDOLnuVkT2Tz9mwyzXvovO9vRBgUWDbWYj
         XaGw4JZuYhjoOlGRO1Q5UyFcnTToESh9WQ4K/ffLy2G5eTzSGgJu/54kWXUlIf+MJjuN
         sHeHWnrz91jng5PCcONdA7Cu/SxJctcSJRlUjRUTguXiJe3qncBa36dCl5ziMFR8Zls7
         K+dCHtsRv9wnAiHi5lLdrcYWR2PvRl+iuJCmFtUHkmMtelqn9CPa2rJf8MB0UppMPVQL
         Oi3ezyIoNzUwOOpbGMkpl6tOgSNGg71FN6uZ/zJLyITYecc7xFEGdNqoXeWvLJXFMJaA
         8cWQ==
X-Gm-Message-State: ACgBeo033Q9lJAmbLHwan3wNKuIvhDqE53evkDX1Ral95EHWl7zfGKKo
        K+DI0ovnT3Vxktf66NZsgmA0xg==
X-Google-Smtp-Source: AA6agR5WUhJDBlKLV/P6rVoVw6+pe40uh9WGjgb+EEjPI1saai6WV22a8rsvKE80ozl3uNg3hEn51A==
X-Received: by 2002:a0c:9c48:0:b0:473:5e9e:741 with SMTP id w8-20020a0c9c48000000b004735e9e0741mr698073qve.63.1661370610188;
        Wed, 24 Aug 2022 12:50:10 -0700 (PDT)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id w11-20020a05620a424b00b006b929a56a2bsm15516970qko.3.2022.08.24.12.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 12:50:08 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Wed, 24 Aug 2022 15:49:46 -0400
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>
Subject: Re: [patch net-next v2 4/4] net: devlink: expose the info about
 version representing a component
Message-ID: <YwaA2hB27VRt6Utg@C02YVCJELVCG.dhcp.broadcom.net>
References: <20220822170247.974743-1-jiri@resnulli.us>
 <20220822170247.974743-5-jiri@resnulli.us>
 <20220822200116.76f1d11b@kernel.org>
 <YwR1URDk56l5VLDZ@nanopsycho>
 <20220823123121.0ae00393@kernel.org>
 <YwXmNqxEYDk+An2A@nanopsycho>
 <CO1PR11MB508905A2019ED7C98C2CEB6FD6739@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220824111202.140ad1fb@kernel.org>
 <CO1PR11MB508914851DFC032B7E6A3324D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <CO1PR11MB508914851DFC032B7E6A3324D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000012faa805e701fde8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000012faa805e701fde8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 24, 2022 at 06:46:13PM +0000, Keller, Jacob E wrote:
> 
> 
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, August 24, 2022 11:12 AM
> > To: Keller, Jacob E <jacob.e.keller@intel.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org; davem@davemloft.net;
> > idosch@nvidia.com; pabeni@redhat.com; edumazet@google.com;
> > saeedm@nvidia.com; vikas.gupta@broadcom.com; gospo@broadcom.com
> > Subject: Re: [patch net-next v2 4/4] net: devlink: expose the info about version
> > representing a component
> > 
> > On Wed, 24 Aug 2022 17:31:46 +0000 Keller, Jacob E wrote:
> > > > Well, I thought it would be polite to let the user know what component
> > > > he can pass to the kernel. Now, it is try-fail/success game. But if you
> > > > think it is okay to let the user in the doubts, no problem. I will drop
> > > > the patch.
> > >
> > > I would prefer exposing this as well since it lets the user know which names are
> > valid for flashing.
> > >
> > > I do have some patches for ice to support individual component update as well
> > I can post soon.
> > 
> > Gentlemen, I had multiple false starts myself adding information
> > to device info, flashing and health reporters. Adding APIs which
> > will actually be _useful_ in production is not trivial. I have
> > the advantage of being able to talk to Meta's production team first
> > so none of my patches made it to the list.
> > 
> > To be clear I'm not saying (nor believe) that Meta's needs or processes
> > are in any way "the right way to go" or otherwise should dictate
> > the APIs. It's just an example I have direct access to.
> > 
> > I don't think I'm out of line asking you for a clear use case.
> > Just knowing something is flashable is not sufficient information,
> > the user needs to know what the component actually describes and
> > what binary to use to update it.
> > 
> 
> At least for ice, the same binary would be used for individual component update. the PLDM firmware binary header describes where each component is within it, and is decoded by lib/pldmfw, we just need to translate the PLDM header codes to the userspace names.
> 
> The old tools which Intel supports do have support for such an individual component update, but the demand wasn't very high, so I never got around to posting the patches to support this. There are some corner cases where it might be helpful to flash (or reflash) a single component, but it seems somewhat less useful for most end-users and mostly would be useful for internal engineering and debugging.
> 
> Users would still need to know what each component is, and there isn't much the kernel API itself can do here. We do document a short description, but that is going to be limited in usefulness since it likely depends on a lot of related knowledge.
> 

I agree with this.  Individual component updates are most useful in a
dev/debug environment rather than in production.  I'm not sure there is
value in exporting this all the way out to kernel APIs.



--00000000000012faa805e701fde8
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
XzCCBVkwggRBoAMCAQICDBPdG+g0KtOPKKsBCTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDAyMzhaFw0yMjA5MjIxNDExNTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGDAWBgNVBAMTD0FuZHkgR29zcG9kYXJlazEtMCsGCSqGSIb3
DQEJARYeYW5kcmV3Lmdvc3BvZGFyZWtAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAp9JFtMqwgpbnvA3lNVCpnR5ehv0kWK9zMpw2VWslbEZq4WxlXr1zZLZEFo9Y
rdIZ0jlxwJ4QGYCvxE093p9easqc7NMemeMg7JpF63hhjCksrGnsxb6jCVUreXPSpBDD0cjaE409
9yo/J5OQORNPelDd4Ihod6g0XlcxOLtlTk1F0SOODSjBZvaDm0zteqiVZb+7xgle3NOSZm3kiCby
iRuyS0gMTdQN3gdgwal9iC3cSXHMZFBXyQz+JGSHomhPC66L6j4t6dUqSTdSP07wg38ZPV6ct/Sv
/O2HcK+E/yYkdMXrDBgcOelO4t8AYHhmedCIvFVp4pFb2oit9tBuFQIDAQABo4IB3zCCAdswDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDApBgNVHREEIjAggR5hbmRyZXcuZ29zcG9kYXJla0Bicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYI
KwYBBQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFKARn7Ud
RlGu+rBdUDirYE+Ee4TeMA0GCSqGSIb3DQEBCwUAA4IBAQAcWqh4fdwhDN0+MKyH7Mj0vS10E7xg
mDetQhQ+twwKk5qPe3tJXrjD/NyZzrUgguNaE+X97jRsEbszO7BqdnM0j5vLDOmzb7d6qeNluJvk
OYyzItlqZk9cJPoP9sD8w3lr2GRcajj5JCKV4pd2PX/i7r30Qco0VnloXpiesFmNTXQqD6lguUyn
nb7IGM3v/Nb7NTFH8/KUVg33xw829ztuGrOvfrHfBbeVcUoOHEHObXoaofYOJjtmSOQdMeJIiBgP
XEpJG8/HB8t4FF6A8W++4cHhv0+ayyEnznrbOCn6WUmIvV2WiJymRpvRG7Hhdlk0zA97MRpqK5yn
ai3dQ6VvMYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBu
di1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIM
E90b6DQq048oqwEJMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCC17+CAbL7mRo6v
7FCGluz4y69FjlaKLMwI26VU7jXw+zAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMjA4MjQxOTUwMTBaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCG
SAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEB
BzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAY8HFgN0CoZeAZUl4uDsYN09Wk/WIWl37
PN2Ar0ZnRWyiV64EbS26OtwBINnLyebv4Jdy1UNSwzaEm7fD3RqDHqB/HXW4cESKZRB3WiZy4pHO
iXOhOgj+QHpGu2IEkzhrpy3dJpLV/NrSbCjV57w+Ljsa6qcbVjPlTbrWobX6oFMOqqU8j0CKYArE
p0JaFUQXneQ2Og778S2jYgSSoMu4Yme9e5dZ9SJ10JZ2ulAGYlA026QweWS7RqhGoiGq0YGGhv6h
nwszBIJDAuNm0NXvhbisdDoNdobEigz0h9o3LpyxtOAnZCiLBJRNjSCL7R7B9giosAVMbpnpYCMr
wEQPFw==
--00000000000012faa805e701fde8--
