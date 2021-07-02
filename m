Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679703B9D53
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 10:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhGBILL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 04:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGBILK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 04:11:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9F0C061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 01:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Zlqj0LJn1xf8WJtqOlFxWVvjIetaBEGl61ht+q5aI+o=; b=SOdjnfq7CxLouBsLcIOz7NLsfY
        hnwEPltaRWjijrigtsOeX9ATynXbiyD7m6gObNPmRfXPHXWuwGTofEt91dYp1sDPQ0jE4GJZImbkZ
        7Q31psjw5g46Nu62TVcfKMXUAeNOIl3khKybzCLmB28yW57btbjsDfbwLNpg+uDVuro4xmEfS9azY
        iSGeTb9jvyG0yHefL37DvyMlDkpNk4TAw5IRLESvZsdSrW7EhwabWDCFXeZ75kNtT/YIpiLV//kRM
        N1E52zQVlAsWRoDgd0VnMZtGM0c7FtnmamJwQQdDXYTQkDrdiW3InZjjz4ElqCtB3Dh88MP0rxqVJ
        8EGTiY4w==;
Received: from dyn-239.woodhou.se ([90.155.92.239] helo=u3832b3a9db3152.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzEE1-002Qtw-Hs; Fri, 02 Jul 2021 08:08:37 +0000
Message-ID: <511df01a3641c2010d875a61161d6da7093abd4a.camel@infradead.org>
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
From:   David Woodhouse <dwmw2@infradead.org>
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Cc:     Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
Date:   Fri, 02 Jul 2021 09:08:35 +0100
In-Reply-To: <ccf524ce-17f8-3763-0f86-2afbcf6aa6fc@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
         <20210624123005.1301761-1-dwmw2@infradead.org>
         <20210624123005.1301761-3-dwmw2@infradead.org>
         <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com>
         <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
         <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com>
         <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org>
         <80f61c54a2b39cb129e8606f843f7ace605d67e0.camel@infradead.org>
         <99496947-8171-d252-66d3-0af12c62fd2c@redhat.com>
         <cdf3fe3ceff17bc2a5aaf006577c1cb0bef40f3a.camel@infradead.org>
         <500370cc-d030-6c2d-8e96-533a3533a8e2@redhat.com>
         <aa70346d6983a0146b2220e93dac001706723fe3.camel@infradead.org>
         <b6192a2a-0226-2767-46b2-ae61494a8ae7@redhat.com>
         <1d5b8251e8d9e67613295d5b7f51c49c1ee8c0a8.camel@infradead.org>
         <ccf524ce-17f8-3763-0f86-2afbcf6aa6fc@redhat.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-f4jiAr2/HZk/YwprOVbE"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-f4jiAr2/HZk/YwprOVbE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-07-02 at 11:13 +0800, Jason Wang wrote:
> =E5=9C=A8 2021/7/2 =E4=B8=8A=E5=8D=881:39, David Woodhouse =E5=86=99=E9=
=81=93:
> >=20
> > Right, but the VMM (or the guest, if we're letting the guest choose)
> > wouldn't have to use it for those cases.
>=20
>=20
> I'm not sure I get here. If so, simply write to TUN directly would work.

As noted, that works nicely for me in OpenConnect; I just write it to
the tun device *instead* of putting it in the vring. My TX latency is
now fine; it's just RX which takes *two* scheduler wakeups (tun wakes
vhost thread, wakes guest).

But it's not clear to me that a VMM could use it. Because the guest has
already put that packet *into* the vring. Now if the VMM is in the path
of all wakeups for that vring, I suppose we *might* be able to contrive
some hackish way to be 'sure' that the kernel isn't servicing it, so we
could try to 'steal' that packet from the ring in order to send it
directly... but no. That's awful :)

I do think it'd be interesting to look at a way to reduce the latency
of the vring wakeup especially for that case of a virtio-net guest with
a single small packet to send. But realistically speaking, I'm unlikely
to get to it any time soon except for showing the numbers with the
userspace equivalent and observing that there's probably a similar win
to be had for guests too.

In the short term, I should focus on what we want to do to finish off
my existing fixes. Did we have a consensus on whether to bother
supporting PI? As I said, I'm mildly inclined to do so just because it
mostly comes out in the wash as we fix everything else, and making it
gracefully *refuse* that setup reliably is just as hard.

I think I'll try to make the vhost-net code much more resilient to
finding that tun_recvmsg() returns a header other than the sock_hlen it
expects, and see how much still actually needs "fixing" if we can do
that.


> I think the design is to delay the tx checksum as much as possible:
>=20
> 1) host RX -> TAP TX -> Guest RX -> Guest TX -> TX RX -> host TX
> 2) VM1 TX -> TAP RX -> switch -> TX TX -> VM2 TX
>=20
> E.g  if the checksum is supported in all those path, we don't need any=
=20
> software checksum at all in the above path. And if any part is not=20
> capable of doing checksum, the checksum will be done by networking core=
=20
> before calling the hard_start_xmit of that device.

Right, but in *any* case where the 'device' is going to memcpy the data
around (like tun_put_user() does), it's a waste of time having the
networking core do a *separate* pass over the data just to checksum it.

> > > > We could similarly do a partial checksum in tun_get_user() and hand=
 it
> > > > off to the network stack with ->ip_summed =3D=3D CHECKSUM_PARTIAL.
> > >=20
> > > I think that's is how it is expected to work (via vnet header), see
> > > virtio_net_hdr_to_skb().
> >=20
> > But only if the "guest" supports it; it doesn't get handled by the tun
> > device. It *could*, since we already have the helpers to checksum *as*
> > we copy to/from userspace.
> >=20
> > It doesn't help for me to advertise that I support TX checksums in
> > userspace because I'd have to do an extra pass for that. I only do one
> > pass over the data as I encrypt it, and in many block cipher modes the
> > encryption of the early blocks affects the IV for the subsequent
> > blocks... do I can't just go back and "fix" the checksum at the start
> > of the packet, once I'm finished.
> >=20
> > So doing the checksum as the packet is copied up to userspace would be
> > very useful.
>=20
>=20
> I think I get this, but it requires a new TUN features (and maybe make=
=20
> it userspace controllable via tun_set_csum()).

I don't think it's visible to userspace at all; it's purely between the
tun driver and the network stack. We *always* set NETIF_F_HW_CSUM,
regardless of what the user can cope with. And if the user *didn't*
support checksum offload then tun will transparently do the checksum
*during* the copy_to_iter() (in either tun_put_user_xdp() or
tun_put_user()).

Userspace sees precisely what it did before. If it doesn't support
checksum offload then it gets a pre-checksummed packet just as before.
It's just that the kernel will do that checksum *while* it's already
touching the data as it copies it to userspace, instead of in a
separate pass.

Although actually, for my *benchmark* case with iperf3 sending UDP, I
spotted in the perf traces that we actually do the checksum as we're
copying from userspace in the udp_sendmsg() call. There's a check in
__ip_append_data() which looks to see if the destination device has
HW_CSUM|IP_CSUM features, and does the copy-and-checksum if not. There
are definitely use cases which *don't* have that kind of optimisation
though, and packets that would reach tun_net_xmit() with CHECKSUM_NONE.
So I think it's worth looking at.


--=-f4jiAr2/HZk/YwprOVbE
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEw
NzAyMDgwODM1WjAvBgkqhkiG9w0BCQQxIgQgPamXJUpX8s8M9c9q88Wvz3970aPdFLCqHzb2/rHG
qFswgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAIQQ7gHJn4COBEe5aShMiDsaODN62o17APsV1LNAGgJvkO8cyjwKaJ2hW7q5bQFg
LrM+HRWGgppVhrcx7nKgBIcTYpOwPbsBAQwC90D3ZsYk2duY/Er2orYGYLpx6WeN87Uc2EsQpUj/
DozX0ghVjlyjEKwU6OgPHOiPZPlLSHSXHMyiVa6NzZ+k9ZdEARYIZp3ljex8bWURUCbCEyqxSd/U
mibdoozohlKL5+24G8i/JSn9rgry/gFvhsxu3KVUTKbeHrfJDRbl6mrUWx2bpQSugjN1trlWs9DY
tTDEP+QlejyyRi7ILj5c6vEpR2ryRJBSlm9LEVL92ILPRVQd7J8AAAAAAAA=


--=-f4jiAr2/HZk/YwprOVbE--

