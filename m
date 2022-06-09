Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E3B5440A2
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 02:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiFIAoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 20:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiFIAoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 20:44:22 -0400
X-Greylist: delayed 122 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Jun 2022 17:44:18 PDT
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97275D571C;
        Wed,  8 Jun 2022 17:44:18 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id DWZ00012;
        Thu, 09 Jun 2022 08:42:12 +0800
Received: from jtjnmail201620.home.langchao.com (10.100.2.20) by
 jtjnmail201624.home.langchao.com (10.100.2.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 9 Jun 2022 08:42:11 +0800
Received: from jtjnmail201620.home.langchao.com ([fe80::24f6:b8e5:a824:6a6b])
 by jtjnmail201620.home.langchao.com ([fe80::24f6:b8e5:a824:6a6b%9]) with mapi
 id 15.01.2308.027; Thu, 9 Jun 2022 08:42:11 +0800
From:   =?utf-8?B?dG9tb3Jyb3cgV2FuZyAo546L5b635piOKQ==?= 
        <wangdeming@inspur.com>
To:     "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virtio: Directly use ida_alloc_range()/ida_free()
Thread-Topic: [PATCH] virtio: Directly use ida_alloc_range()/ida_free()
Thread-Index: Adh7mb9eZpqq33w2TJqw0eKPxw85VQ==
Date:   Thu, 9 Jun 2022 00:42:11 +0000
Message-ID: <aff7bba2680b49fab6a14694e33fd41d@inspur.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.200.104.82]
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
        micalg=SHA1; boundary="----=_NextPart_000_0000_01D87BDC.CEDC3830"
MIME-Version: 1.0
tUid:   20226090842122a7f7fdd4e8e961b0d4b71845f6bf44e
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

------=_NextPart_000_0000_01D87BDC.CEDC3830
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,
> Hi,
>=20
> Le 08/06/2022 =C3=A0 08:08, Deming Wang a =C3=A9crit :
> > Use ida_alloc_range()/ida_free() instead of deprecated
> > ida_simple_get()/ida_simple_remove() .
> >
> > Signed-off-by: Deming Wang <wangdeming@inspur.com>
> > ---
> >   drivers/vhost/vdpa.c | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c index
> > 935a1d0ddb97..384049cfca8d 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -1293,7 +1293,7 @@ static void vhost_vdpa_release_dev(struct =
device
> *device)
> >   	struct vhost_vdpa *v =3D
> >   	       container_of(device, struct vhost_vdpa, dev);
> >
> > -	ida_simple_remove(&vhost_vdpa_ida, v->minor);
> > +	ida_free(&vhost_vdpa_ida, v->minor);
> >   	kfree(v->vqs);
> >   	kfree(v);
> >   }
> > @@ -1316,8 +1316,7 @@ static int vhost_vdpa_probe(struct vdpa_device
> *vdpa)
> >   	if (!v)
> >   		return -ENOMEM;
> >
> > -	minor =3D ida_simple_get(&vhost_vdpa_ida, 0,
> > -			       VHOST_VDPA_DEV_MAX, GFP_KERNEL);
> > +	minor =3D ida_alloc_range(&vhost_vdpa_ida, 0, VHOST_VDPA_DEV_MAX -
> 1,
> > +GFP_KERNEL);
>=20
> ida_alloc_max() would be better here. It is less verbose.
>=20
> An explanation in the commit log of why the -1 is needed would also =
help
> reviewer/maintainer, IMHO.
>=20
> It IS correct, but it is not that obvious without looking at
> ida_simple_get() and ida_alloc_range().
>=20
> CJ
>=20
>=20
> >   	if (minor < 0) {
> >   		kfree(v);
> >   		return minor;


can I mention one patch about repair ida_free  for this.





------=_NextPart_000_0000_01D87BDC.CEDC3830
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

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
AgICAIAwDgYIKoZIhvcNAwQCAgCAMAcGBSsOAwIHMAoGCCqGSIb3DQMHMB0GA1UdDgQWBBT2m8+B
pv3zOH+FCDvTbpfMkvPbAzAfBgNVHSMEGDAWgBReWQOmtExYYJFO9h61pTmmMsE1ajCCAQ8GA1Ud
HwSCAQYwggECMIH/oIH8oIH5hoG6bGRhcDovLy9DTj1JTlNQVVItQ0EsQ049SlRDQTIwMTIsQ049
Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRp
b24sREM9aG9tZSxEQz1sYW5nY2hhbyxEQz1jb20/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9i
YXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50hjpodHRwOi8vSlRDQTIwMTIuaG9t
ZS5sYW5nY2hhby5jb20vQ2VydEVucm9sbC9JTlNQVVItQ0EuY3JsMIIBKQYIKwYBBQUHAQEEggEb
MIIBFzCBsQYIKwYBBQUHMAKGgaRsZGFwOi8vL0NOPUlOU1BVUi1DQSxDTj1BSUEsQ049UHVibGlj
JTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1ob21lLERD
PWxhbmdjaGFvLERDPWNvbT9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNh
dGlvbkF1dGhvcml0eTBhBggrBgEFBQcwAoZVaHR0cDovL0pUQ0EyMDEyLmhvbWUubGFuZ2NoYW8u
Y29tL0NlcnRFbnJvbGwvSlRDQTIwMTIuaG9tZS5sYW5nY2hhby5jb21fSU5TUFVSLUNBLmNydDBH
BgNVHREEQDA+oCUGCisGAQQBgjcUAgOgFwwVd2FuZ2RlbWluZ0BpbnNwdXIuY29tgRV3YW5nZGVt
aW5nQGluc3B1ci5jb20wDQYJKoZIhvcNAQELBQADggEBAKD6Oh0Yu1g2xXDIaczYlx8WZiYqTi7t
bFCmsNT5DmNUfLaJre5UDyaWjgwW6Z/KN1X19Piy6oS8ex93gaeF4siDuQimREZoKxePJyUeyFs5
oC6kpsw95f/0RM5zhHb4I8L4AgplfwySCGAeMRr74rThzkYWfoU1AM+c8cBtViIispknx6KxJFo2
b533lCx168UKeNRb1n7pUANxFYd+1jjdRKCPrszdJcJddFmnLBetcnD4DG0ID62hnw+/g0KoAlfd
ORikFVBLobsDNy+NQ++5ZYgx1ahEQ6BESIjeWxut+2Zqis6Zbwd5ZsBhm892l5EdzJCuYe5xDEZw
0Z0bGvUxggOTMIIDjwIBATBwMFkxEzARBgoJkiaJk/IsZAEZFgNjb20xGDAWBgoJkiaJk/IsZAEZ
FghsYW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhvbWUxEjAQBgNVBAMTCUlOU1BVUi1DQQITfgAA
1tjc3okYpZWK7QAAAADW2DAJBgUrDgMCGgUAoIIB+DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMjA2MDkwMDQyMTBaMCMGCSqGSIb3DQEJBDEWBBQSXfJFjwYfXihF
ATmEqDUeJAftwzB/BgkrBgEEAYI3EAQxcjBwMFkxEzARBgoJkiaJk/IsZAEZFgNjb20xGDAWBgoJ
kiaJk/IsZAEZFghsYW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhvbWUxEjAQBgNVBAMTCUlOU1BV
Ui1DQQITfgAA1tjc3okYpZWK7QAAAADW2DCBgQYLKoZIhvcNAQkQAgsxcqBwMFkxEzARBgoJkiaJ
k/IsZAEZFgNjb20xGDAWBgoJkiaJk/IsZAEZFghsYW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhv
bWUxEjAQBgNVBAMTCUlOU1BVUi1DQQITfgAA1tjc3okYpZWK7QAAAADW2DCBkwYJKoZIhvcNAQkP
MYGFMIGCMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCGjALBglghkgBZQMEAgMwCwYJ
YIZIAWUDBAICMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC5guG5hJQTHJKG4/c3I74H
4rkIrbjacytPy6bhtVvLHwmXYKok1jDtcMKLGp+e8m3aCYFRRnM0D3op+Mg/sNmxVxrXFVVdmy1x
ZcZZzw1HHh2cc/SC/f0cNFbafxzjDQceMOoIj7TQwD/Ehrjwk1D2pMlT4ThlztqDevKfpf+BPVgF
stVcxzPAKkok9Ec85JpucfCuB5yaRyqPZ0WckpE3ivjJVdYIZoPg1LIAbYLKybl2XWwCaMLYdzaW
2Af06+X+rLV/337lClu+Tc62j0RVPinF7lwahRA3za5ndlETRv0h1ILpFFty4JfQW0Vvf6lh5LYZ
kf9JUQDkoUfgYDZhAAAAAAAA

------=_NextPart_000_0000_01D87BDC.CEDC3830--
