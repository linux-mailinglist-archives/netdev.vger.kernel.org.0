Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D7D2909A4
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410179AbgJPQYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 12:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410089AbgJPQYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 12:24:37 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC7CC061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 09:24:37 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id v23so1752983vsp.6
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 09:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aGwi/RpySDZYppSaDgd7spsiiNIIBn4NVmIkGVV4WYM=;
        b=Vhqnr0uHOEmkvAQ2Be2cW+7LAi82uMfm5m+iQ3JbXBYDRcidM0TaDAi+4JEVl+a2Wv
         5E2cfMx84P5e/Mx5PTiis6GybmogAItiTPaCu+I4q59KFNLenq9h+YWmVPItty+fcW2f
         Kh9B6CNvrU1kF8QgVo60fr0D9Q4rSXTLMqas7Zw2igCEuJr8pJmSPdJtMjsdfTxstjDg
         +m6xENf4A5DLuJLK3alCBjYARd5EzbMRysxRhoxYhrjjQHiAgh1oC7XwXuTpCJPchTqh
         y0dIo6hcsMmttkZlv1mWjxltXFv7nD8/yrwiGoyRJXJ++c3/TH/UIiHORUhNGwLDsiPU
         MaFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aGwi/RpySDZYppSaDgd7spsiiNIIBn4NVmIkGVV4WYM=;
        b=YvNOWKqibRS4zb8E5v4dIhipGDnaZ2/4G8rnJnSUWvfB+sikloebq2qY4e9gOxzKWS
         YDZ0y0WkDfl9xACTops3yM0IF2BH5y3YJvNbJ/IP+p3JRPFqtZTQx+drGtvap9nEP/Fl
         THsNaTYw5XQ8znMzyApfAp6rRnuAjaJiuSZ7EQj4qAM9Shl7UBOVpTMQPQ/XGUc1j7Sd
         irDx+wD/B3rDXHZnasuiQPKjsU1SX9LnyRLfbxz2D6tjUBNWL2RNpvGZmlIcSeROBJvo
         cIECkNB27HUYdiDgGSuw8aUt3kH0zohCRVyYyePWQ9F7k9n273M2yZBFiJ7xiDHf7+Hb
         tD1w==
X-Gm-Message-State: AOAM5324fFULN58cY/VRm5jH50T+piesn3T7q2kdJN51LkcD95LZTqOa
        Pei+x0wTPYNYL6jalqi1Nz980E2tt88=
X-Google-Smtp-Source: ABdhPJz+mHkCmtg10yfl042C/dXQzSeImavJLY8RgubVZdXcv7FblAcfY0DAq66eq1AyXXI/xKSGOQ==
X-Received: by 2002:a67:ffd8:: with SMTP id w24mr2891730vsq.18.1602865476040;
        Fri, 16 Oct 2020 09:24:36 -0700 (PDT)
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com. [209.85.221.175])
        by smtp.gmail.com with ESMTPSA id m205sm415657vke.36.2020.10.16.09.24.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 09:24:33 -0700 (PDT)
Received: by mail-vk1-f175.google.com with SMTP id a8so772732vkm.2
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 09:24:30 -0700 (PDT)
X-Received: by 2002:a1f:c149:: with SMTP id r70mr2867291vkf.1.1602865470138;
 Fri, 16 Oct 2020 09:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
 <20201007231050.1438704-3-anthony.l.nguyen@intel.com> <CA+FuTSfX55yiPHZ-Pf051RqMkKbyvHWT86HFB135Tb4kjm6PjQ@mail.gmail.com>
 <DM6PR11MB28768492F2D085ADA9ECBFFAE5030@DM6PR11MB2876.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB28768492F2D085ADA9ECBFFAE5030@DM6PR11MB2876.namprd11.prod.outlook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 16 Oct 2020 12:23:53 -0400
X-Gmail-Original-Message-ID: <CA+FuTScSOfLy8=s2-J-kki6TD9TWK+aU08KcNoPN5Vm+m4O+Og@mail.gmail.com>
Message-ID: <CA+FuTScSOfLy8=s2-J-kki6TD9TWK+aU08KcNoPN5Vm+m4O+Og@mail.gmail.com>
Subject: Re: [net-next 2/3] i40e: Fix MAC address setting for a VF via Host/VM
To:     "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 6:46 AM Loktionov, Aleksandr
<aleksandr.loktionov@intel.com> wrote:
>
> Good day Willem
>
> The issue patch fixes has been introduced from the very beginning.
> So as fixes tag I can suggest the very first commit 5c3c48ac6bf56367c4e89=
f6453cd2d61e50375bd  "i40e: implement virtual device interface"

Fixes: 5c3c48ac6bf5 ("i40e: implement virtual device interface")

Sounds great. Thanks, Alex.

>
> With the best regards
> Alex
> ND ITP Linux 40G base driver TL
>
> -----Original Message-----
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Sent: Friday, October 9, 2020 7:47 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: David Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;=
 Loktionov, Aleksandr <aleksandr.loktionov@intel.com>; Network Development =
<netdev@vger.kernel.org>; nhorman@redhat.com; sassmann@redhat.com; Kubalews=
ki, Arkadiusz <arkadiusz.kubalewski@intel.com>; Andrew Bowers <andrewx.bowe=
rs@intel.com>
> Subject: Re: [net-next 2/3] i40e: Fix MAC address setting for a VF via Ho=
st/VM
>
> On Wed, Oct 7, 2020 at 7:11 PM Tony Nguyen <anthony.l.nguyen@intel.com> w=
rote:
> >
> > From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> >
> > Fix MAC setting flow for the PF driver.
> >
> > Without this change the MAC address setting was interpreted
> > incorrectly in the following use cases:
> > 1) Print incorrect VF MAC or zero MAC
> > ip link show dev $pf
> > 2) Don't preserve MAC between driver reload rmmod iavf; modprobe iavf
> > 3) Update VF MAC when macvlan was set
> > ip link add link $vf address $mac $vf.1 type macvlan
> > 4) Failed to update mac address when VF was trusted ip link set dev
> > $vf address $mac
> >
> > This includes all other configurations including above commands.
> >
> > Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> > Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>
> If this is a fix, should it target net and/or is there a commit for a Fix=
es tag?
>
> > @@ -2740,6 +2744,7 @@ static int i40e_vc_del_mac_addr_msg(struct
> > i40e_vf *vf, u8 *msg)  {
> >         struct virtchnl_ether_addr_list *al =3D
> >             (struct virtchnl_ether_addr_list *)msg;
> > +       bool was_unimac_deleted =3D false;
> >         struct i40e_pf *pf =3D vf->pf;
> >         struct i40e_vsi *vsi =3D NULL;
> >         i40e_status ret =3D 0;
> > @@ -2759,6 +2764,8 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_v=
f *vf, u8 *msg)
> >                         ret =3D I40E_ERR_INVALID_MAC_ADDR;
> >                         goto error_param;
> >                 }
> > +               if (ether_addr_equal(al->list[i].addr, vf->default_lan_=
addr.addr))
> > +                       was_unimac_deleted =3D true;
> >         }
> >         vsi =3D pf->vsi[vf->lan_vsi_idx];
> >
> > @@ -2779,10 +2786,25 @@ static int i40e_vc_del_mac_addr_msg(struct i40e=
_vf *vf, u8 *msg)
> >                 dev_err(&pf->pdev->dev, "Unable to program VF %d MAC fi=
lters, error %d\n",
> >                         vf->vf_id, ret);
> >
> > +       if (vf->trusted && was_unimac_deleted) {
> > +               struct i40e_mac_filter *f;
> > +               struct hlist_node *h;
> > +               u8 *macaddr =3D NULL;
> > +               int bkt;
> > +
> > +               /* set last unicast mac address as default */
> > +               spin_lock_bh(&vsi->mac_filter_hash_lock);
> > +               hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hli=
st) {
> > +                       if (is_valid_ether_addr(f->macaddr))
> > +                               macaddr =3D f->macaddr;
>
> nit: could break here
> ---------------------------------------------------------------------
> Intel Technology Poland sp. z o.o.
> ul. Sowackiego 173 | 80-298 Gdask | Sd Rejonowy Gdask Pnoc | VII Wydzia G=
ospodarczy Krajowego Rejestru Sdowego - KRS 101882 | NIP 957-07-52-316 | Ka=
pita zakadowy 200.000 PLN.
> Ta wiadomo wraz z zacznikami jest przeznaczona dla okrelonego adresata i =
moe zawiera informacje poufne. W razie przypadkowego otrzymania tej wiadomo=
ci, prosimy o powiadomienie nadawcy oraz trwae jej usunicie; jakiekolwiek p=
rzegldanie lub rozpowszechnianie jest zabronione.
> This e-mail and any attachments may contain confidential material for the=
 sole use of the intended recipient(s). If you are not the intended recipie=
nt, please contact the sender and delete all copies; any review or distribu=
tion by others is strictly prohibited.
>
