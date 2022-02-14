Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFED34B40D6
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 05:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiBNE2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 23:28:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbiBNE2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 23:28:42 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A48B4F449
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 20:28:35 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id g10so17406058vss.1
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 20:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BDXZaoizDr7YeP+Atw0KemHoKPFgMstyLuuzXFa0H7A=;
        b=JxVo9WTFlUz8ugjDViLyEpxDozrHP7l7WFND0eUKV3mTbcXf0yjHAUSqHC2vjTPcIY
         CnkabDxTOe6KQPS5T7g+LAfvUGte9ljzmdD4sX1Z8PN2XpCZorXV/yfxLyvyjHYc8KKp
         qB7gAgJpnBgCPYC1hdNb50ZTlVVIzreAa26SYJATmDWtc+VHNRLzcdnq0/KEzUaHjDwj
         xyCrKkEUgUWEerqlXegww/9o08SpIKQBvbLCZnRUe3FbXb73bz740rCUg7aj2tv1zYP5
         u8qdR8BSn4MuQDxZYZTdmVccUR1VOW2YfmcbfRTuVghM6i4arryelaYk8t9822kql6z8
         rlgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BDXZaoizDr7YeP+Atw0KemHoKPFgMstyLuuzXFa0H7A=;
        b=psEdyJYxiFvkQ55UCWVkhH9zXcRW+j/sT83SHbqgvX+HwJoXGmGTvC4FxVmfndLgw8
         FX7w9EeQ/HBqmajX5Kns6d3XzD6FbSdlJg64FG9HJjYOLbzX4pdKWUUjBtqP62m0OkL8
         JTAUp9pbtW+ecR30tLmfOl9H5+dDWFrQVW05Woqc5TYm0t9TudwMotcV+zGdE4yhRJEQ
         atv2W9Rg/3qsWeQ4MIF8VMpccpvyT3H02pnrU+LvXj36PuNpqr1fc+9rkFCGUgN56trd
         56MYjGk3MiO3FrsUoRxGDxqrQjY0/C6iKAf033jolVPB/lbgStiTIJPreAAHK46LPQdn
         u3LQ==
X-Gm-Message-State: AOAM530J23vCcxENf0e8r7qqOpzHRJ4xKo6YUNZK0blw6C9oPh9KzpNE
        b28Yfk7QuqkkeFMxw0hOR9TAPO/CTjw=
X-Google-Smtp-Source: ABdhPJxrDkhCdL4QkXTNSYj+p80xBvxTO0KOC4wQPXqDZuZklvemtwXGyK/3J0x0yBiPDc++Q5UwIw==
X-Received: by 2002:a67:f14c:: with SMTP id t12mr3364760vsm.85.1644812914442;
        Sun, 13 Feb 2022 20:28:34 -0800 (PST)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id s7sm2483440vsq.32.2022.02.13.20.28.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 20:28:34 -0800 (PST)
Received: by mail-ua1-f41.google.com with SMTP id d22so7552942uaw.2
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 20:28:33 -0800 (PST)
X-Received: by 2002:ab0:2710:: with SMTP id s16mr3410627uao.37.1644812913237;
 Sun, 13 Feb 2022 20:28:33 -0800 (PST)
MIME-Version: 1.0
References: <20220213150234.31602-1-thomas.liu@ucloud.cn> <CA+FuTSdODATw3hSAMv9aZUmJNM8ZE-YP58pr17bO9rGJUgfegw@mail.gmail.com>
 <CFD9B65A-6762-4D9B-ADEB-B4C0B1902E02@ucloud.cn>
In-Reply-To: <CFD9B65A-6762-4D9B-ADEB-B4C0B1902E02@ucloud.cn>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 13 Feb 2022 23:27:57 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfQOUEyEDnOU8VVZ=STw_ii-hTwyg-cvpcViPkVK4pLUA@mail.gmail.com>
Message-ID: <CA+FuTSfQOUEyEDnOU8VVZ=STw_ii-hTwyg-cvpcViPkVK4pLUA@mail.gmail.com>
Subject: Re: [PATCH] gso: do not skip outer ip header in case of ipip and net_failover
To:     Tao Liu <thomas.liu@ucloud.cn>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, edumazet@google.com, sridhar.samudrala@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 11:03 PM Tao Liu <thomas.liu@ucloud.cn> wrote:
>
> Sorry for bothering, just repost it.
>
> > 2022=E5=B9=B42=E6=9C=8814=E6=97=A5 09:28=EF=BC=8CWillem de Bruijn <will=
emdebruijn.kernel@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Sun, Feb 13, 2022 at 10:10 AM Tao Liu <thomas.liu@ucloud.cn> wrote:
> >>
> >> We encouter a tcp drop issue in our cloud environment. Packet GROed in=
 host
> >> forwards to a VM virtio_net nic with net_failover enabled. VM acts as =
a
> >> IPVS LB with ipip encapsulation. The full path like:
> >> host gro -> vm virtio_net rx -> net_failover rx -> ipvs fullnat
> >> -> ipip encap -> net_failover tx -> virtio_net tx
> >>
> >> When net_failover transmits a ipip pkt (gso_type =3D 0x0103), there is=
 no gso
> >> performed because it supports TSO and GSO_IPXIP4. But network_header h=
as
> >> been pointing to inner ip header.
> >
> > If the packet is configured correctly, and net_failover advertises
> > that it can handle TSO packets with IPIP encap, then still virtio_net
> > should not advertise it and software GSO be applied on its
> > dev_queue_xmit call.
> >
> > This is assuming that the packet not only has SKB_GSO_IPXIP4 correctly
> > set, but also tunneling fields like skb->encapsulated and
> > skb_inner_network_header.
> Thanks very much for your comment!
>
> Yes, the packet is correct. Another thing i have not pointed directly is
> that the pkt has SKB_GSO_DODGY. net_failover do not advertises GSO_ROBUST
> but virtio_net do.

If net_failover does not advertise NETIF_F_GSO_ROBUST, then
tcp_gso_segment will pass a packet with SKB_GSO_DODGY to the
software gso stack, not taking the branch

        if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {

> >> ---
> >> net/ipv4/af_inet.c | 10 +++++++++-
> >> 1 file changed, 9 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> >> index 9c465ba..f8b3f8a 100644
> >> --- a/net/ipv4/af_inet.c
> >> +++ b/net/ipv4/af_inet.c
> >> @@ -1425,10 +1425,18 @@ struct sk_buff *inet_gso_segment(struct sk_buf=
f *skb,
> >> static struct sk_buff *ipip_gso_segment(struct sk_buff *skb,
> >>                                        netdev_features_t features)
> >> {
> >> +       struct sk_buff *segs;
> >> +       int nhoff;
> >> +
> >>        if (!(skb_shinfo(skb)->gso_type & SKB_GSO_IPXIP4))
> >>                return ERR_PTR(-EINVAL);
> >>
> >> -       return inet_gso_segment(skb, features);
> >> +       nhoff =3D skb_network_header(skb) - skb_mac_header(skb);
> >> +       segs =3D inet_gso_segment(skb, features);
> >> +       if (!segs)
> >> +               skb->network_header =3D skb_mac_header(skb) + nhoff - =
skb->head;
> >> +
> >> +       return segs;
> >> }
> >
> > If this would be needed for IPIP, then the same would be needed for SIT=
, etc.
> >
> > Is the skb_network_header
> >
> > 1. correctly pointing to the outer header of the TSO packet before the
> > call to inet_gso_segment
> > 2. incorrectly pointing to the inner header of the (still) TSO packet
> > after the call to inet_gso_segment
> >
> > inet_gso_segment already does the same operation: save nhoff, pull
> > network header, call callbacks.gso_segment (which can be
> > ipip_gso_segment->inet_gso_segment), then place the network header
> > back at nhoff.
> >
> values print in skb_mac_gso_segment() before callbacks.gso_segment:
> ipip:               vlan_depth=3D0 mac_len=3D0 skb->network_header=3D206
> net_failover:  vlan_depth=3D14 mac_len=3D14 skb->network_header=3D186
> virtio_net:      vlan_depth=3D34 mac_len=3D34 skb->network_header=3D206
>
> agree to add sit/ip4ip6/ip6ip6, and patch can be simplified as:

If IPIP GSO was so broken, I think we would have found it long before.

As said, inet_gso_segment should already do the right thing for ipip:
it will be called twice.
