Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE20E227045
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 23:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgGTVXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 17:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGTVXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 17:23:32 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB69C0619D2
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 14:23:31 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id o2so5811459qvk.6
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 14:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rgyRtYnNvY6PzkPf6ZuYkKVb6oC5kyDe+KQm0jCt07Y=;
        b=MlCKsAM5idumzOQOyW+wwW8Xg1LELS33yTEQ5E/ycG52Gnp9MW2GmcRCyG2yRJ2jah
         2NVy3B8rqp4Yo2HsyIg657hPorwH9k6Is39e3Oj174PLKbNF24U9zZL60SVrw+TSfqRP
         wDJ9zsvOUbHDbzAYBeNK308U77Gnkm+5W6gNNmQ4oLIDCMxlL38KzfVjZ+WC4PTpAehy
         Lt7zpgjJ1RLZcqCh8a5cV01ELfwUoF1aidBzKihCRA6TgraKWbqAhz1NPZRq3+sD6uHe
         IBQF2yZYiMwKfNCAVWFbfJiTBpHrOdsSQBV24Z5Ul8/zJAMB/upNc+/7yRr4xbKr7KAw
         sTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rgyRtYnNvY6PzkPf6ZuYkKVb6oC5kyDe+KQm0jCt07Y=;
        b=XWxAzJMgt1tw3hiMYWrDC7WHonv7PiNskCWDSoMzn75rUndqFg3QcLCqzSeqjuTpFj
         p/quGGBqN5RW1kpxf5iUwyzFaSWZ2RUPkKlf9QIQWwv01teBlzEYyrmJtJUsad4y2p1w
         SfGL/3MRhjbBoV4rs+NzkqpVUeYBwTBatXcGC/Cn4cu2LqG3x9fbIGJLYES2JSLRFW6o
         mbS2cLMr/9WM6bmpe418xxLn/HElazsucrJPEIhjwtH0EmlFTW/8ZB+BLameGCFJD0YK
         67ELul0HWO3DQF67NuhzX27uaouTVdoQ/WB5utY5JVQ4EOo34saAiUPyU89YFCgH2Lx5
         Ocmw==
X-Gm-Message-State: AOAM531fsPdCYHuxAU3KgW8XzXwwPOvdpKzhg5nROu5yiRdZQApG8xTN
        E+QVBN7QI8ym8rkQOaA129t9olWM
X-Google-Smtp-Source: ABdhPJz5taBSoO3QF+TnxafOiK8ZTX9b0YhpV1YCYqodJmGFkf7RMrQCjMIj8SIcDWMH+zZeOHC4eA==
X-Received: by 2002:a05:6214:969:: with SMTP id do9mr23840490qvb.85.1595280209812;
        Mon, 20 Jul 2020 14:23:29 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id q126sm653296qke.34.2020.07.20.14.23.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 14:23:28 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id 134so8976037ybd.6
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 14:23:27 -0700 (PDT)
X-Received: by 2002:a25:ae4f:: with SMTP id g15mr37680671ybe.441.1595280206799;
 Mon, 20 Jul 2020 14:23:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200718091732.8761-1-srirakr2@cisco.com> <CA+FuTSdfvctFD3AVMHzQV9efQERcKVE1TcYVD_T84eSgq9x4OA@mail.gmail.com>
 <CY4PR1101MB21013DCD55B754E29AF4A838907B0@CY4PR1101MB2101.namprd11.prod.outlook.com>
 <CAF=yD-+gCkPVkXwcH6KiKYGV77TvpZiDo=3YyXeuGFk=TR2dcw@mail.gmail.com> <20200720135650.1939665b@hermes.lan>
In-Reply-To: <20200720135650.1939665b@hermes.lan>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 20 Jul 2020 17:22:49 -0400
X-Gmail-Original-Message-ID: <CA+FuTScwyB_xo0q+ZfihnQCfyVYy_zibg7Kx-QYEVbnauykKDQ@mail.gmail.com>
Message-ID: <CA+FuTScwyB_xo0q+ZfihnQCfyVYy_zibg7Kx-QYEVbnauykKDQ@mail.gmail.com>
Subject: Re: [PATCH v2] AF_PACKET doesnt strip VLAN information
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Sriram Krishnan (srirakr2)" <srirakr2@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "Malcolm Bumgardner (mbumgard)" <mbumgard@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 4:57 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 20 Jul 2020 09:52:27 -0400
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
>
> > On Mon, Jul 20, 2020 at 12:27 AM Sriram Krishnan (srirakr2)
> > <srirakr2@cisco.com> wrote:
> > >
> > > +Stephen Hemminger
> > >
> > > Hi Willem,
> > > Thanks for looking into the code, I understand that this is more of a=
 generic problem wherein many of the filtering functions assume the vlan ta=
g to be in the skb rather than in the packet. Hence we moved the fix from t=
he driver to the common AF packet that our solution uses.
> > >
> > > I recall from the v1 of the patch you had mentioned other common area=
s where this fix might be relevant (such as tap/tun), but I'm afraid I cant=
 comprehensively test those patches out. Please let me know your thoughts
> >
> > Please use plain text to respond. HTML replies do not reach the list.
> >
> > Can you be more precise in which other code besides the hyper-v driver
> > is affected? Do you have an example?
> >
> > This is a resubmit of the original patch. My previous
> > questions/concerns remain valid:
> >
> > - if the function can now fail, all callers must be updated to detect
> > and handle that
> >
> > - any solution should probably address all inputs into the tx path:
> > packet sockets, tuntap, virtio-net
> >
> > - this only addresses packet sockets with ETH_P_ALL/ETH_P_NONE. Not
> > sockets that set ETH_P_8021Q
> >
> > - which code in the transmit stack requires the tag to be in the skb,
> > and does this problem after this patch still persist for Q-in-Q?
>
> It matters because the problem is generic, not just to the netvsc driver.
> For example, BPF programs and netfilter rules will see different packets
> when send is through AF_PACKET than they would see for sends from the
> kernel stack.
>
> Presenting uniform data to the lower layers makes sense.

Are all forwarded and locally generated packets guaranteed to always
have VLAN information in the tag (so that this is indeed only an issue
with input from userspace, through tuntap, virtio and packet sockets)?

I guess the first might be assured due to this in __netif_receive_skb_core:

        if (skb->protocol =3D=3D cpu_to_be16(ETH_P_8021Q) ||
            skb->protocol =3D=3D cpu_to_be16(ETH_P_8021AD)) {
                skb =3D skb_vlan_untag(skb);
                if (unlikely(!skb))
                        goto out;
        }

and the second by this in vlan_dev_hard_start_xmit:

        if (veth->h_vlan_proto !=3D vlan->vlan_proto ||
            vlan->flags & VLAN_FLAG_REORDER_HDR) {
                u16 vlan_tci;
                vlan_tci =3D vlan->vlan_id;
                vlan_tci |=3D vlan_dev_get_egress_qos_mask(dev, skb->priori=
ty);
                __vlan_hwaccel_put_tag(skb, vlan->vlan_proto, vlan_tci);
        }

But I don't know this code very well, so that is based on a very
cursory glance only. Might well be missing other paths. (update: I
think pktgen is another example.)

Netfilter and BPF still need to handle tags in the packet for Q-in-Q,
right? So does this actually simplify their logic?

If the above holds and Q-in-Q is not a problem, then doing the same on
ingress from userspace may make sense. I don't know the kind of BPF
or netfilter programs what would be affected, and how.

Then it would be good to all those inputs at once to really plug the hole.
See also virtio_net_hdr_to_skb for another example of code that
applies to all of tuntap, virtio, pf_packet and uml.
