Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1003B9595
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 19:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhGARle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 13:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhGARle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 13:41:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0174C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 10:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wutHQnSFuSsbpWDjhp5LbXwI1xk6Pmj5T8hInVm+r8E=; b=eU4Tr9VYJv79RXyPaw+Vby2lKS
        GlcGCxDZGJ4rqImZbxCQrbC/7urrb4uy5D7jyNqq6iuNrlh/4kalNf7YxT61Qy2oCjoCE95ny0ErX
        D0m3CY1+jQrUDvUgOBIll68Z/9QqzYqrN23gyHkNyyuxNgbtdAc2cemDhkfcs79hCk6b5jDLqjoR7
        TtunRpzUMP544Bn7Byt+B4vTB6U2mc4WxnVSOBcyo/0t70rpNmeoRFb9ri+z4R0wnXybWRN8qAWhk
        wknMI3pOcd2oG5D9llLYjSI8SnFRZ1HD6bDDbxHaBHbTM/vSSn9cDAsjwrZwYPw5GliNpHuWM+c9Z
        enrOluGA==;
Received: from 54-240-197-232.amazon.com ([54.240.197.232] helo=freeip.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lz0eV-000dwP-2U; Thu, 01 Jul 2021 17:39:03 +0000
Message-ID: <1d5b8251e8d9e67613295d5b7f51c49c1ee8c0a8.camel@infradead.org>
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
From:   David Woodhouse <dwmw2@infradead.org>
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Cc:     Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
Date:   Thu, 01 Jul 2021 18:39:00 +0100
In-Reply-To: <b6192a2a-0226-2767-46b2-ae61494a8ae7@redhat.com>
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
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-CAlq5QINaohkmriR4npb"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-CAlq5QINaohkmriR4npb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-07-01 at 12:13 +0800, Jason Wang wrote:
> =E5=9C=A8 2021/6/30 =E4=B8=8B=E5=8D=886:02, David Woodhouse =E5=86=99=E9=
=81=93:
> > On Wed, 2021-06-30 at 12:39 +0800, Jason Wang wrote:
> > > =E5=9C=A8 2021/6/29 =E4=B8=8B=E5=8D=886:49, David Woodhouse =E5=86=99=
=E9=81=93:
> > > > So as I expected, the throughput is better with vhost-net once I ge=
t to
> > > > the point of 100% CPU usage in my main thread, because it offloads =
the
> > > > kernel=E2=86=90=E2=86=92user copies. But latency is somewhat worse.
> > > >=20
> > > > I'm still using select() instead of epoll() which would give me a
> > > > little back =E2=80=94 but only a little, as I only poll on 3-4 fds,=
 and more to
> > > > the point it'll give me just as much win in the non-vhost case too,=
 so
> > > > it won't make much difference to the vhost vs. non-vhost comparison=
.
> > > >=20
> > > > Perhaps I really should look into that trick of "if the vhost TX ri=
ng
> > > > is already stopped and would need a kick, and I only have a few pac=
kets
> > > > in the batch, just write them directly to /dev/net/tun".
> > >=20
> > > That should work on low throughput.
> >=20
> > Indeed it works remarkably well, as I noted in my follow-up. I also
> > fixed a minor stupidity where I was reading from the 'call' eventfd
> > *before* doing the real work of moving packets around. And that gives
> > me a few tens of microseconds back too.
> >=20
> > > > I'm wondering how that optimisation would translate to actual guest=
s,
> > > > which presumably have the same problem. Perhaps it would be an
> > > > operation on the vhost fd, which ends up processing the ring right
> > > > there in the context of *that* process instead of doing a wakeup?
> > >=20
> > > It might improve the latency in an ideal case but several possible is=
sues:
> > >=20
> > > 1) this will blocks vCPU running until the sent is done
> > > 2) copy_from_user() may sleep which will block the vcpu thread furthe=
r
> >=20
> > Yes, it would block the vCPU for a short period of time, but we could
> > limit that. The real win is to improve latency of single, short packets
> > like a first SYN, or SYNACK. It should work fine even if it's limited
> > to *one* *short* packet which *is* resident in memory.
>=20
>=20
> This looks tricky since we need to poke both virtqueue metadata as well=
=20
> as the payload.

That's OK as we'd *only* do it if the thread is quiescent anyway.

> And we need to let the packet iterate the network stack which might have=
=20
> extra latency (qdiscs, eBPF, switch/OVS).
>=20
> So it looks to me it's better to use vhost_net busy polling instead=20
> (VHOST_SET_VRING_BUSYLOOP_TIMEOUT).

Or something very similar, with the *trylock* and bailing out.

> Userspace can detect this feature by validating the existence of the ioct=
l.

Yep. Or if we want to get fancy, we could even offer it to the guest.
As a *different* doorbell register to poke if they want to relinquish
the physical CPU to process the packet quicker. We wouldn't even *need*
to go through userspace at all, if we put that into a separate page...
but that probably *is* overengineering it :)

> > Although actually I'm not *overly* worried about the 'resident' part.
> > For a transmit packet, especially a short one not a sendpage(), it's
> > fairly likely the the guest has touched the buffer right before sending
> > it. And taken the hit of faulting it in then, if necessary. If the host
> > is paging out memory which is *active* use by a guest, that guest is
> > screwed anyway :)
>=20
>=20
> Right, but there could be workload that is unrelated to the networking.=
=20
> Block vCPU thread in this case seems sub-optimal.
>=20

Right, but the VMM (or the guest, if we're letting the guest choose)
wouldn't have to use it for those cases.

> > Alternatively, there's still the memory map thing I need to fix before
> > I can commit this in my application:
> >=20
> > #ifdef __x86_64__
> > 	vmem->regions[0].guest_phys_addr =3D 4096;
> > 	vmem->regions[0].memory_size =3D 0x7fffffffe000;
> > 	vmem->regions[0].userspace_addr =3D 4096;
> > #else
> > #error FIXME
> > #endif
> > 	if (ioctl(vpninfo->vhost_fd, VHOST_SET_MEM_TABLE, vmem) < 0) {
> >=20
> > Perhaps if we end up with a user-visible feature to deal with that,
> > then I could use the presence of *that* feature to infer that the tun
> > bugs are fixed.
>=20
>=20
> As we discussed before it could be a new backend feature. VHOST_NET_SVA=
=20
> (shared virtual address)?

Yeah, I'll take a look.

> > Another random thought as I stare at this... can't we handle checksums
> > in tun_get_user() / tun_put_user()? We could always set NETIF_F_HW_CSUM
> > on the tun device, and just do it *while* we're copying the packet to
> > userspace, if userspace doesn't support it. That would be better than
> > having the kernel complete the checksum in a separate pass *before*
> > handing the skb to tun_net_xmit().
>=20
>=20
> I'm not sure I get this, but for performance reason we don't do any csum=
=20
> in this case?

I think we have to; the packets can't leave the box without a valid
checksum. If the skb isn't CHECKSUM_COMPLETE at the time it's handed
off to the ->hard_start_xmit of a netdev which doesn't advertise
hardware checksum support, the network stack will do it manually in an
extra pass.

Which is kind of silly if the tun device is going to do a pass over all
the data *anyway* as it copies it up to userspace. Even in the normal
case without vhost-net.

> > We could similarly do a partial checksum in tun_get_user() and hand it
> > off to the network stack with ->ip_summed =3D=3D CHECKSUM_PARTIAL.
>=20
>=20
> I think that's is how it is expected to work (via vnet header), see=20
> virtio_net_hdr_to_skb().

But only if the "guest" supports it; it doesn't get handled by the tun
device. It *could*, since we already have the helpers to checksum *as*
we copy to/from userspace.

It doesn't help for me to advertise that I support TX checksums in
userspace because I'd have to do an extra pass for that. I only do one
pass over the data as I encrypt it, and in many block cipher modes the
encryption of the early blocks affects the IV for the subsequent
blocks... do I can't just go back and "fix" the checksum at the start
of the packet, once I'm finished.

So doing the checksum as the packet is copied up to userspace would be
very useful.

--=-CAlq5QINaohkmriR4npb
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
NzAxMTczOTAwWjAvBgkqhkiG9w0BCQQxIgQgVhewBAFQcYyIFEK/LXK5fkSb/rJPosiwWyfI+Gx2
22Awgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAHSDYc7iqjtvXKKTDoPkcDH9xgRnOreGSA9a7D0r7wBr90jDVbi16YWI/2jA5kAb
nzyii+qMD0RHsXkSvMUPUxwDAc1kgoLS3wj6DWxqMzsykirc6lloZw9dqSCw5sczXp04OJjywYZT
qSuhsFApGpOTTf5S9cf04ZXVKiYMNli8AMkwNdeDsN2l/GZRGdd3aLxTOO7qfJLHrgPaz5W1iO7R
+3PGBVAhkU8LGNKcvd920z0jP0IxDTB6z1QpoQOC85NlI0U6peAGEW93j8xo6GV01xFLhVLc12oR
SUyRlrK1ydwcUrQxkqh1+4tjDmNVVjRsdLQPr46y3tfglrXCmbIAAAAAAAA=


--=-CAlq5QINaohkmriR4npb--

