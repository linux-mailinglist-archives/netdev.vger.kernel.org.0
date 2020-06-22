Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB4620421F
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 22:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgFVUrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 16:47:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50003 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728490AbgFVUrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 16:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592858828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mLDSVjOYU6H2qZ2XbTR0s36/xyvZR4LxAxnV5LdzjNI=;
        b=IKfxNxtq2uUd+gZ3A4YPhLtBPX3DzlztkKCN+gkPZMQzkixEtxUKIYHTjsNO6f+QfXZOGR
        1cdhhd1no6zfyXhDIhyk4ddcWKFRtc5KDMt5q1Vj6QiSfHmC6FTIRW+WdoEEMnxAocbOxb
        vEqLzB5ukxUe7Q/xH5AfPnku1X+x20E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-h9qZZCPEOzqrn9HDiX8eXg-1; Mon, 22 Jun 2020 16:46:57 -0400
X-MC-Unique: h9qZZCPEOzqrn9HDiX8eXg-1
Received: by mail-wm1-f72.google.com with SMTP id t127so601939wmg.0
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 13:46:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mLDSVjOYU6H2qZ2XbTR0s36/xyvZR4LxAxnV5LdzjNI=;
        b=miwaR78Q4LGSNvwYq8qrVXxkQzEhLEhjxX9luJNMRHG3wVWgJaq1s5QdvXKWuDI49o
         Irkl2YvrPdrIIKiCljq8khigBTp9kWomQPcGooa+6oBKTVKmLo4DMu1WzANESYMTyVLP
         ycLdpxB9V4p5kqGg/sCJJIbcYsHbgIy5gu1claBvrgousIfCtMTn5bma0g1cgDj5yCZg
         FO8/5aPW1JYkoK5fO/ZhCnvY6J5QtXLPCy1xfpO4Xrh6SAv5l9n7nUJ6pbdfrKLT3WYX
         p+rVmEMXXlV14qLnKchycJicDxeSzKCDL5cwVdr8Yo1yNpiQo22Mail7QyqRA9k5Iqb+
         EvhA==
X-Gm-Message-State: AOAM531PW2++otDZf6P7J4IV70MmH1yFe5UTlc8W9AxtOd4fskvrZj2l
        EZTCSdcRE1TxdbPBwYPTr0gOJfxLfH2qJDbG80T78lHm09PK+PtafscBtnVtFz9yNEBZX4kzkRE
        sz5xmOev6bbF5MM2j
X-Received: by 2002:adf:e7ce:: with SMTP id e14mr22507595wrn.217.1592858815963;
        Mon, 22 Jun 2020 13:46:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+W3V+qkbhxw0VVzsQKUW3ljUGquFfT41Wf0hQt9KeawBLS6LFIm31yheEr1dw0D/W95J4IQ==
X-Received: by 2002:adf:e7ce:: with SMTP id e14mr22507574wrn.217.1592858815728;
        Mon, 22 Jun 2020 13:46:55 -0700 (PDT)
Received: from localhost ([151.48.138.186])
        by smtp.gmail.com with ESMTPSA id d28sm20951466wrc.50.2020.06.22.13.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 13:46:54 -0700 (PDT)
Date:   Mon, 22 Jun 2020 22:46:51 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Numan Siddique <nusiddiq@redhat.com>,
        Greg Rose <gvrose8192@gmail.com>, ovs dev <dev@openvswitch.org>
Subject: Re: [PATCH net] openvswitch: take into account de-fragmentation in
 execute_check_pkt_len
Message-ID: <20200622204651.GE27892@localhost.localdomain>
References: <74266291a0aba929919f71ff3dbd1c36392bb4c4.1592567032.git.lorenzo@kernel.org>
 <CAOrHB_B2GO51hRy_kj3kdJKrFURFbKubhGvanLKCRHDc9DKeyg@mail.gmail.com>
 <20200622120252.GC14425@localhost.localdomain>
 <CAOrHB_Dam4u4_AMyj2kbXc48pjP5ePDgMqy0Ghj5kUbS+OrGXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KuLpqunXa7jZSBt+"
Content-Disposition: inline
In-Reply-To: <CAOrHB_Dam4u4_AMyj2kbXc48pjP5ePDgMqy0Ghj5kUbS+OrGXw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KuLpqunXa7jZSBt+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Jun 22, 2020 at 5:02 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > > On Fri, Jun 19, 2020 at 4:48 AM Lorenzo Bianconi <lorenzo@kernel.org>=
 wrote:
> > > >
> > > > ovs connection tracking module performs de-fragmentation on incoming
> > > > fragmented traffic. Take info account if traffic has been de-fragme=
nted
> > > > in execute_check_pkt_len action otherwise we will perform the wrong
> > > > nested action considering the original packet size. This issue typi=
cally
> > > > occurs if ovs-vswitchd adds a rule in the pipeline that requires co=
nnection
> > > > tracking (e.g. OVN stateful ACLs) before execute_check_pkt_len acti=
on.
> > > >
> > > > Fixes: 4d5ec89fc8d14 ("net: openvswitch: Add a new action check_pkt=
_len")
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  net/openvswitch/actions.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > > > index fc0efd8833c8..9f4dd64e53bb 100644
> > > > --- a/net/openvswitch/actions.c
> > > > +++ b/net/openvswitch/actions.c
> > > > @@ -1169,9 +1169,10 @@ static int execute_check_pkt_len(struct data=
path *dp, struct sk_buff *skb,
> > > >                                  struct sw_flow_key *key,
> > > >                                  const struct nlattr *attr, bool la=
st)
> > > >  {
> > > > +       struct ovs_skb_cb *ovs_cb =3D OVS_CB(skb);
> > > >         const struct nlattr *actions, *cpl_arg;
> > > >         const struct check_pkt_len_arg *arg;
> > > > -       int rem =3D nla_len(attr);
> > > > +       int len, rem =3D nla_len(attr);
> > > >         bool clone_flow_key;
> > > >
> > > >         /* The first netlink attribute in 'attr' is always
> > > > @@ -1180,7 +1181,8 @@ static int execute_check_pkt_len(struct datap=
ath *dp, struct sk_buff *skb,
> > > >         cpl_arg =3D nla_data(attr);
> > > >         arg =3D nla_data(cpl_arg);
> > > >
> > > > -       if (skb->len <=3D arg->pkt_len) {
> > > > +       len =3D ovs_cb->mru ? ovs_cb->mru : skb->len;
> > > > +       if (len <=3D arg->pkt_len) {
> > >
> > > We could also check for the segmented packet and use  segment length
> > > for this check.
> >
> > Hi Pravin,
> >
> > thx for review.
> > By 'segmented packet' and 'segment length', do you mean 'fragment' and
> > 'fragment length'?
>=20
> I am actually talking about GSO packets.

ack. IIUC you mean to add a check for gso packets as well taking into accou=
nt
gso_size. I will fix in v2.

Regards,
Lorenzo

>=20
> Thanks.
>=20
> > If so I guess we can't retrieve the original fragment length if we exec
> > OVS_ACTION_ATTR_CT before OVS_ACTION_ATTR_CHECK_PKT_LEN (e.g if we have=
 a
> > stateful ACL in the ingress pipeline) since handle_fragments() will rec=
onstruct
> > the whole IP datagram and it will store frag_max_size in OVS_CB(skb)->m=
ru.
> > Am I missing something?
> >
> > Regards,
> > Lorenzo
> >
>=20

--KuLpqunXa7jZSBt+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXvEYuAAKCRA6cBh0uS2t
rN8MAP9ifqCksWyvSyUCW3ozp516LgfsJTgQUcvuKEHqEa+vIgEAoiMkoaggN2sS
0wXh+gcok11dKP7k8U5hr7xeZtYv3Ao=
=NQq3
-----END PGP SIGNATURE-----

--KuLpqunXa7jZSBt+--

