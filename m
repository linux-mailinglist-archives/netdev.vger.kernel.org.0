Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D559842C681
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhJMQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhJMQj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 12:39:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F58760E0C;
        Wed, 13 Oct 2021 16:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634143074;
        bh=W+2/9wVvy3OXFif7aibs4MTQTGM10pnrSSZw8KlMu5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KFL66a5V11OL0IMYFij2TTTVt7ogh1DmI0bZeA7mxkadBNvIIqnn0j3jpv2gi5/MF
         jkGZCPLxj6FcNkGWH5HYdJgiW3t42qw4fEDyFP1n6SmUVdhsSudvAvuXApLKUB/mID
         ow9SF9QXMexWF7FqjdsoIlnSarSMa+ZJcJJUAqOomoAmNT2iGnrrgtPPJkLtPhgklp
         HaeX9GetjeR5gbqlaYkZEKrCdh/jyHA9/a3ztHOWNA/XSwQiBQwHHRnBEfWPHMJWrv
         +9s43JDaR9gft3YcVu29u92DDsHOBTRJCQwsJ9o2CSCJzhHsBCbbdIJRdLPbk+GmUR
         XSymRrZSzIq1w==
Date:   Wed, 13 Oct 2021 09:37:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andreas Oetken <ennoerlangen@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH] net: hsr: Add support for redbox supervision frames
Message-ID: <20211013093753.11c7cd91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2c7eb569aa7058cd8c0251c0e0894368f69cad62.camel@gmail.com>
References: <20211013072951.1697003-1-andreas.oetken@siemens-energy.com>
        <20211013085014.4beb11e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2c7eb569aa7058cd8c0251c0e0894368f69cad62.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 18:13:48 +0200 Andreas Oetken wrote:
> Am Mittwoch, dem 13.10.2021 um 08:50 -0700 schrieb Jakub Kicinski:
> > On Wed, 13 Oct 2021 09:29:51 +0200 Andreas Oetken wrote: =20
> > > added support for the redbox supervision frames
> > > as defined in the IEC-62439-3:2018.
> > >=20
> > > Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com> =20
> >=20
> > This does not apply to netdev/net-next. =20
> Sorry, I will not include it next time.

To be clear - please rebase on that tree, and also include=20
[PATCH net-next] in the subject.

> > > =C2=A0
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (hsr_sup_tag->HSR_TLV_t=
ype !=3D HSR_TLV_ANNOUNCE &&
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hsr_sup=
_tag->HSR_TLV_type !=3D HSR_TLV_LIFE_CHECK &&
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hsr_sup=
_tag->HSR_TLV_type !=3D PRP_TLV_LIFE_CHECK_DD &&
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hsr_sup=
_tag->HSR_TLV_type !=3D PRP_TLV_LIFE_CHECK_DA)
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (hsr_sup_tag->tlv.HSR_T=
LV_type !=3D HSR_TLV_ANNOUNCE &&
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hsr_sup=
_tag->tlv.HSR_TLV_type !=3D HSR_TLV_LIFE_CHECK &&
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hsr_sup=
_tag->tlv.HSR_TLV_type !=3D PRP_TLV_LIFE_CHECK_DD
> > > &&
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hsr_sup=
_tag->tlv.HSR_TLV_type !=3D PRP_TLV_LIFE_CHECK_DA)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return false;
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (hsr_sup_tag->HSR_TLV_l=
ength !=3D 12 &&
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hsr_sup=
_tag->HSR_TLV_length !=3D sizeof(struct
> > > hsr_sup_payload))
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (hsr_sup_tag->tlv.HSR_T=
LV_length !=3D 12 &&
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hsr_sup=
_tag->tlv.HSR_TLV_length !=3D sizeof(struct
> > > hsr_sup_payload))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return false;
> > > =C2=A0
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return true;
> > > diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> > > index bb1351c38397..e7c6efbc41af 100644
> > > --- a/net/hsr/hsr_framereg.c
> > > +++ b/net/hsr/hsr_framereg.c
> > > @@ -265,6 +265,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info
> > > *frame)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct hsr_port *port=
_rcv =3D frame->port_rcv;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct hsr_priv *hsr =
=3D port_rcv->hsr;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct hsr_sup_payloa=
d *hsr_sp;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct hsr_sup_tlv *hsr_su=
p_tlv;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct hsr_node *node=
_real;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sk_buff *skb =
=3D NULL;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct list_head *nod=
e_db;
> > > @@ -312,6 +313,40 @@ void hsr_handle_sup_frame(struct
> > > hsr_frame_info *frame)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Node has already been merged */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0goto done;
> > > =C2=A0
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Leave the first HSR sup=
 payload. */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0skb_pull(skb, sizeof(struc=
t hsr_sup_payload));
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Get second supervision =
tlv */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hsr_sup_tlv =3D (struct hs=
r_sup_tlv *)skb->data;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* And check if it is a re=
dbox mac TLV */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (hsr_sup_tlv->HSR_TLV_t=
ype =3D=3D PRP_TLV_REDBOX_MAC) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* We could stop here after pushing
> > > hsr_sup_payload,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * or proceed and allow macaddress_B and for
> > > redboxes.
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* Sanity check length */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (hsr_sup_tlv->HSR_TLV_length !=3D 6) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0skb=
_push(skb, sizeof(struct
> > > hsr_sup_payload));
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0got=
o done;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0}
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* Leave the second HSR sup tlv. */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0skb_pull(skb, sizeof(struct hsr_sup_tlv));
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* Get redbox mac address. */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0hsr_sp =3D (struct hsr_sup_payload *)skb->data;
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* Check if redbox mac and node mac are equal. */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (!ether_addr_equal(node_real->macaddress_A,
> > > hsr_sp->macaddress_A)) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* =
This is a redbox supervision frame for a
> > > VDAN! */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* =
Push second TLV and payload here */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0skb=
_push(skb, sizeof(struct
> > > hsr_sup_payload) + sizeof(struct hsr_sup_tlv));
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0got=
o done;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0}
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/* Push second TLV here */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0skb_push(skb, sizeof(struct hsr_sup_tlv));
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Push payload here */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0skb_push(skb, sizeof(struc=
t hsr_sup_payload)); =20
> >=20
> > Is this code path handling frames from the network or user space?=20
> > Does it need input checking? =20
> This code path is handling frames from the network. The supervision
> frames are broadcasted by each device. What type of additional input
> checking are you thinking of? I think I should check skb->len before
> pulling/accessing right?

Yes, skb->len would be the start, but skb can also have fragments, so
skb->len > N does not guarantee that N bytes are accessible directly
via skb->data. I think that calling pskb_may_pull() would be the best
fit for your use.

I'm not sure why this function doesn't do it already, perhaps there=20
is some guarantee I'm missing.
