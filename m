Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D7C3B287E
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 09:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhFXHZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 03:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhFXHZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 03:25:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE64C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Eh53tinUObkHv0K9i6b4BR2hizCvCU8jDJYD17Su9l8=; b=xklgLJwZu2pXaFLNQ5AT4HsgNM
        K9zQnp40doCgYb7ytf38GePoNmXUEDpyw4dnZJPKOPK/oRYRlN3eXJRmg6NOyRM6DKbZ4prKrEt3Z
        Maha89hyeH01eQHtJ9C+PYkHjCOo3u7BvZQ/mJBaNBmzGAwrn8v4+v+D3hSxZwGL+SF7KVcbvcYqN
        CyM4yr2loyi95vqEmiF0ijm3JPvP6YADc4kzH756wVNLhPdamMARabBIDuMVvxCT0NKbC4TqlbRXR
        wdw2nvK53ryjUsJsgZ4/BDg2EO8CH+JvI7bB5vQJ9DeYtv1bH2hGGgUUXXZkfUYZkxu//eiPpMVep
        8Ln2H4YA==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwJhs-00DBCc-Hw; Thu, 24 Jun 2021 07:23:24 +0000
Message-ID: <b25aa156491e2abd4f48da4d7bed82547024a40a.camel@infradead.org>
Subject: Re: [PATCH v2 1/4] net: tun: fix tun_xdp_one() for IFF_TUN mode
From:   David Woodhouse <dwmw2@infradead.org>
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Cc:     Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Date:   Thu, 24 Jun 2021 08:23:21 +0100
In-Reply-To: <12d5dc12-0b1a-eec1-2986-a971f660e850@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
         <20210622161533.1214662-1-dwmw2@infradead.org>
         <fedca272-a03e-4bac-4038-2bb1f6b4df84@redhat.com>
         <e8843f32aa14baff398584e5b3a00d20994836b6.camel@infradead.org>
         <f2e6498d310454e9c884f3f8470477e0cc527b58.camel@infradead.org>
         <e61c84062230d3454c0a6539ed372b84449d9572.camel@infradead.org>
         <12d5dc12-0b1a-eec1-2986-a971f660e850@redhat.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-4HHBHlWAU6IdyTaQRl7I"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-4HHBHlWAU6IdyTaQRl7I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-06-24 at 14:37 +0800, Jason Wang wrote:
> =E5=9C=A8 2021/6/24 =E4=B8=8A=E5=8D=886:52, David Woodhouse =E5=86=99=E9=
=81=93:
> > On Wed, 2021-06-23 at 18:31 +0100, David Woodhouse wrote:
> > > Joy... that's wrong because when tun does both the PI and the vnet
> > > headers, the PI header comes *first*. When tun does only PI and vhost
> > > does the vnet headers, they come in the other order.
> > >=20
> > > Will fix (and adjust the test cases to cope).
> >=20
> > I got this far, pushed to
> > https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/vho=
st-net
> >=20
> > All the test cases are now passing. I don't guarantee I haven't
> > actually broken qemu and IFF_TAP mode though, mind you :)
>=20
>=20
> No problem, but it would be easier for me if you can post another=20
> version of the series.

Ack; I'm reworking it now into a saner series. All three of my initial
simple fixes ended up with more changes once I expanded the test cases
to cover more permutations of PI/XDP/headers :)

> > As discussed, I expanded tun_get_socket()/tap_get_socket() to return
> > the actual header length instead of letting vhost make wild guesses.
>=20
>=20
> This probably won't work since we had TUNSETVNETHDRSZ.

Or indeed IFF_NO_PI.

> I agree the vhost codes is tricky since it assumes only two kinds of the=
=20
> hdr length.
>=20
> But it was basically how it works for the past 10 years. It depends on=
=20
> the userspace (Qemu) to coordinate it with the TUN/TAP through=20
> TUNSETVNETHDRSZ during the feature negotiation.

I think that in any given situation, the kernel should either work
correctly, or gracefully refuse to set it up.

My patch set will make it work correctly for all the permutations I've
looked at. I would accept and answer of "screw that, just make
tun_get_socket() return failure if IFF_NO_PI isn't set", for example.

> > Note that in doing so, I have made tun_get_socket() return -ENOTCONN if
> > the tun fd *isn't* actually attached (TUNSETIFF) to a real device yet.
>=20
> Any reason for doing this? Note that the socket is loosely coupled with=
=20
> the networking device.

Because to determine the sock_hlen to return, it needs to look at the
tun>flags and tun->vndr_hdr_sz field. And if there isn't an actual tun
device attached, it can't.

>=20
> >=20
> > I moved the sanity check back to tun/tap instead of doing it in
> > vhost_net_build_xdp(), because the latter has no clue about the tun PI
> > header and doesn't know *where* the virtio header is.
>=20
>=20
> Right, the deserves a separate patch.

Yep, in my tree it has one, but it's a bit mixed in with other fixes
until I do that refactoring.=20

> > diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
> > index 2a7660843444..8d78b6bbc228 100644
> > --- a/include/linux/if_tun.h
> > +++ b/include/linux/if_tun.h
> > @@ -21,11 +21,10 @@ struct tun_msg_ctl {
> >  =20
> >   struct tun_xdp_hdr {
> >   	int buflen;
> > -	struct virtio_net_hdr gso;
>=20
>=20
> Any reason for doing this? I meant it can work but we need limit the=20
> changes that is unrelated to the fixes.

That's part of the patch that moves the sanity check back to tun/tap.
As I said it needs a little reworking, so it currently contains a
little bit of cleanup to previous code in tun_xdp_one(), but it looks
like this. The bit in drivers/vhost/net.c is obviously removing code
that I'd made conditional in a previous patch, so that will change
somewhat as I rework the series and drop the original patch.

=46rom 2a0080f37244ec6dac8fb3e8330f9153a4373cfd Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Wed, 23 Jun 2021 23:32:00 +0100
Subject: [PATCH 10/10] net: remove virtio_net_hdr from struct tun_xdp_hdr

The tun device puts its struct tun_pi *before* the virtio_net_hdr, which
significantly complicates letting vhost validate it. Just let tap and
tun validate it for themselves, as they do in the non-XDP case anyway.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/net/tap.c      | 25 ++++++++++++++++++++++---
 drivers/net/tun.c      | 34 ++++++++++++++++++++++++----------
 drivers/vhost/net.c    | 15 +--------------
 include/linux/if_tun.h |  1 -
 4 files changed, 47 insertions(+), 28 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 2170a0d3d34c..d1b1f1de374e 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1132,16 +1132,35 @@ static const struct file_operations tap_fops =3D {
 static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 {
 	struct tun_xdp_hdr *hdr =3D xdp->data_hard_start;
-	struct virtio_net_hdr *gso =3D &hdr->gso;
+	struct virtio_net_hdr *gso =3D NULL;
 	int buflen =3D hdr->buflen;
 	int vnet_hdr_len =3D 0;
 	struct tap_dev *tap;
 	struct sk_buff *skb;
 	int err, depth;
=20
-	if (q->flags & IFF_VNET_HDR)
+	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len =3D READ_ONCE(q->vnet_hdr_sz);
+		if (xdp->data !=3D xdp->data_hard_start + sizeof(*hdr) + vnet_hdr_len) {
+			err =3D -EINVAL;
+			goto err;
+		}
+
+		gso =3D (void *)&hdr[1];
=20
+		if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
+		     tap16_to_cpu(q, gso->csum_start) +
+		     tap16_to_cpu(q, gso->csum_offset) + 2 >
+			     tap16_to_cpu(q, gso->hdr_len))
+			gso->hdr_len =3D cpu_to_tap16(q,
+				 tap16_to_cpu(q, gso->csum_start) +
+				 tap16_to_cpu(q, gso->csum_offset) + 2);
+
+		if (tap16_to_cpu(q, gso->hdr_len) > xdp->data_end - xdp->data) {
+			err =3D -EINVAL;
+			goto err;
+		}
+	}
 	skb =3D build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
 		err =3D -ENOMEM;
@@ -1155,7 +1174,7 @@ static int tap_get_user_xdp(struct tap_queue *q, stru=
ct xdp_buff *xdp)
 	skb_reset_mac_header(skb);
 	skb->protocol =3D eth_hdr(skb)->h_proto;
=20
-	if (vnet_hdr_len) {
+	if (gso) {
 		err =3D virtio_net_hdr_to_skb(skb, gso, tap_is_little_endian(q));
 		if (err)
 			goto err_kfree;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 69f6ce87b109..72f8a04f493b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2337,29 +2337,43 @@ static int tun_xdp_one(struct tun_struct *tun,
 {
 	unsigned int datasize =3D xdp->data_end - xdp->data;
 	struct tun_xdp_hdr *hdr =3D xdp->data_hard_start;
+	void *tun_hdr =3D &hdr[1];
 	struct virtio_net_hdr *gso =3D NULL;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb =3D NULL;
 	__be16 proto =3D 0;
 	u32 rxhash =3D 0, act;
 	int buflen =3D hdr->buflen;
-	int reservelen =3D xdp->data - xdp->data_hard_start;
 	int err =3D 0;
 	bool skb_xdp =3D false;
 	struct page *page;
=20
-	if (tun->flags & IFF_VNET_HDR)
-		gso =3D &hdr->gso;
-
 	if (!(tun->flags & IFF_NO_PI)) {
-		struct tun_pi *pi =3D xdp->data;
-		if (datasize < sizeof(*pi)) {
+		struct tun_pi *pi =3D tun_hdr;
+		tun_hdr +=3D sizeof(*pi);
+
+		if (tun_hdr > xdp->data) {
 			atomic_long_inc(&tun->rx_frame_errors);
-			return  -EINVAL;
+			return -EINVAL;
 		}
 		proto =3D pi->proto;
-		reservelen +=3D sizeof(*pi);
-		datasize -=3D sizeof(*pi);
+	}
+
+	if (tun->flags & IFF_VNET_HDR) {
+		gso =3D tun_hdr;
+		tun_hdr +=3D sizeof(*gso);
+
+		if (tun_hdr > xdp->data) {
+			atomic_long_inc(&tun->rx_frame_errors);
+			return -EINVAL;
+		}
+
+		if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
+		    tun16_to_cpu(tun, gso->csum_start) + tun16_to_cpu(tun, gso->csum_off=
set) + 2 > tun16_to_cpu(tun, gso->hdr_len))
+			gso->hdr_len =3D cpu_to_tun16(tun, tun16_to_cpu(tun, gso->csum_start) +=
 tun16_to_cpu(tun, gso->csum_offset) + 2);
+
+		if (tun16_to_cpu(tun, gso->hdr_len) > datasize)
+			return -EINVAL;
 	}
=20
 	xdp_prog =3D rcu_dereference(tun->xdp_prog);
@@ -2407,7 +2421,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 		goto out;
 	}
=20
-	skb_reserve(skb, reservelen);
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, datasize);
=20
 	if (gso && virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index e88cc18d079f..d9491c620a9c 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -716,26 +716,13 @@ static int vhost_net_build_xdp(struct vhost_net_virtq=
ueue *nvq,
 	buf =3D (char *)page_address(alloc_frag->page) + alloc_frag->offset;
 	hdr =3D buf;
 	if (sock_hlen) {
-		struct virtio_net_hdr *gso =3D &hdr->gso;
-
 		copied =3D copy_page_from_iter(alloc_frag->page,
 					     alloc_frag->offset +
-					     offsetof(struct tun_xdp_hdr, gso),
+					     sizeof(struct tun_xdp_hdr),
 					     sock_hlen, from);
 		if (copied !=3D sock_hlen)
 			return -EFAULT;
=20
-		if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-		    vhost16_to_cpu(vq, gso->csum_start) +
-		    vhost16_to_cpu(vq, gso->csum_offset) + 2 >
-		    vhost16_to_cpu(vq, gso->hdr_len)) {
-			gso->hdr_len =3D cpu_to_vhost16(vq,
-						      vhost16_to_cpu(vq, gso->csum_start) +
-						      vhost16_to_cpu(vq, gso->csum_offset) + 2);
-
-			if (vhost16_to_cpu(vq, gso->hdr_len) > len)
-				return -EINVAL;
-		}
 		len -=3D sock_hlen;
 	}
=20
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 8a7debd3f663..8d78b6bbc228 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -21,7 +21,6 @@ struct tun_msg_ctl {
=20
 struct tun_xdp_hdr {
 	int buflen;
-	struct virtio_net_hdr gso;
 };
=20
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
--=20
2.17.1



--=-4HHBHlWAU6IdyTaQRl7I
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
NjI0MDcyMzIyWjAvBgkqhkiG9w0BCQQxIgQgxtLjJsEuqGA15MwQpFmSLRNrKMIXv2R8wOYZO1RT
0fMwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBACHT9WehosRwhb8o5wj/KpyGNiVs69lYisNtPnYbrHN4C5Mlwq9fxWuRcM2onwUy
tTMrOR7KfVhzFpYEzk2TUTyeB10fWRG7pkSBREV5vokMjVi6yUMJS93hVn5LMx+hHwmEQ53os0h4
kpJFjxW1K8XAIuywOP32WSE/mCkaEPatZrGWmc7pu+7eooFGD/CFSojAQbDjF4bzG2OY51DoELdz
LpesVY+0N6f/TkQrBRBw7+58krnqvgdU0Ig3RaBD6kE59dQ1CpGKm5de2Tvyr3IfjSDkg5ZEYBqI
6NPx+pFFMTmRAsz+2xV9gPLUq9zTMoqQVFqVJ1MHz4jeLrbdMP4AAAAAAAA=


--=-4HHBHlWAU6IdyTaQRl7I--

