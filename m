Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52884B7155
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbiBOPCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:02:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiBOPCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:02:09 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4D113FB5;
        Tue, 15 Feb 2022 07:01:59 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id b35so17492261qkp.6;
        Tue, 15 Feb 2022 07:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=78EMwAad67P7bAo3QUQ6bXtnkwhqSI/m9kJsVLcGj/k=;
        b=meo1miUHcsSJvQru3V9p75oQgJIH5SBCWHIKXEB/TwtaGfhU0cR4be62CMC/OFW72n
         8KEhkAheAvytB2j9xImDIpi1KBJ0tswcDQd+q/HUAqYNhVEUJB5I4pPqEa3xobh3LPRq
         RUX+ko0+K7BUZavzX789Xe4N65eFa0WrEseOVL6OcEOh1Q5SJwO96I8LeLoSFKZvJdK6
         Hxet4TRv7Jhdq0g4erUB8amiAoH4+yXLna9F4aJdgeBFhMU3lmtukJIzxOu+7hZKGjaW
         YXV2E8CajieXf+nIBeIxWifYMFb5AdE8GpNNu8FbLWBRgAmDt6bffi5BSRKn/8cMhkWU
         6jWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=78EMwAad67P7bAo3QUQ6bXtnkwhqSI/m9kJsVLcGj/k=;
        b=a+WWLUOHUja47otOCFfkoRhTwEcfyj5n/t4eYNJcs5coDox1VLei3IONWbJT9xDc1W
         S3FmfPZcnZlhUGWerDvxOjufbCtmVb731e5P3K0vWRQnLbjUwKIHjkHA7Ac67NdqcCkV
         xoNZbck374hAccLaqzBt8ioW7wS2a8Eix1Al+7uBF8VPaun/FeQFtEspWnHNBwX3IiSV
         T5zCZlKEzbx0ZlsMRj2P7HxmYBMH82Ps6vKPkzidfxP7oSpSGBgGIBZ2TI0S5nOI1fYc
         JtmNMj8rQJjAcaHXp/6oAFrYgnm67xGWLz+jRIOqWPfVPhRXH+yIS/4I/urO0WRyWrAU
         7U4g==
X-Gm-Message-State: AOAM532eJUU+jgTmXEGD7CGgHBam01v04VWcNzHWgrdU9xYESyyoPhv4
        rizcLNkPzE8XkdMgZdgtlHxddrDGBjFgtMZ4YXo=
X-Google-Smtp-Source: ABdhPJxlCXo4g+H0TJaGJZDZUAAspkcwT4TeqvyFGLSljHY3RAa0tj0rh6FtdVbr5j66Zr8z/+ty/p3+MELPZSJQ41Y=
X-Received: by 2002:a05:620a:1327:: with SMTP id p7mr463519qkj.741.1644937318254;
 Tue, 15 Feb 2022 07:01:58 -0800 (PST)
MIME-Version: 1.0
References: <20220213150234.31602-1-thomas.liu@ucloud.cn> <CA+FuTSdODATw3hSAMv9aZUmJNM8ZE-YP58pr17bO9rGJUgfegw@mail.gmail.com>
 <CFD9B65A-6762-4D9B-ADEB-B4C0B1902E02@ucloud.cn> <CA+FuTSfQOUEyEDnOU8VVZ=STw_ii-hTwyg-cvpcViPkVK4pLUA@mail.gmail.com>
 <42554FCB-9180-4B32-B5CF-6D3236237D99@ucloud.cn>
In-Reply-To: <42554FCB-9180-4B32-B5CF-6D3236237D99@ucloud.cn>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 15 Feb 2022 10:01:22 -0500
Message-ID: <CAF=yD-+1RSj_o8n5LDOLVyn_dvVQvmDQo5pacSoDFPOR3M2g5g@mail.gmail.com>
Subject: Re: [PATCH] gso: do not skip outer ip header in case of ipip and net_failover
To:     Tao Liu <thomas.liu@ucloud.cn>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 8:38 PM Tao Liu <thomas.liu@ucloud.cn> wrote:
>
> Sorry to resend it.
>
> 2022=E5=B9=B42=E6=9C=8814=E6=97=A5 12:27=EF=BC=8CWillem de Bruijn <willem=
debruijn.kernel@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, Feb 13, 2022 at 11:03 PM Tao Liu <thomas.liu@ucloud.cn> wrote:
>
>
> Sorry for bothering, just repost it.
>
> 2022=E5=B9=B42=E6=9C=8814=E6=97=A5 09:28=EF=BC=8CWillem de Bruijn <willem=
debruijn.kernel@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, Feb 13, 2022 at 10:10 AM Tao Liu <thomas.liu@ucloud.cn> wrote:
>
>
> We encouter a tcp drop issue in our cloud environment. Packet GROed in ho=
st
> forwards to a VM virtio_net nic with net_failover enabled. VM acts as a
> IPVS LB with ipip encapsulation. The full path like:
> host gro -> vm virtio_net rx -> net_failover rx -> ipvs fullnat
> -> ipip encap -> net_failover tx -> virtio_net tx
>
> When net_failover transmits a ipip pkt (gso_type =3D 0x0103), there is no=
 gso
> performed because it supports TSO and GSO_IPXIP4. But network_header has
> been pointing to inner ip header.
>
>
> If the packet is configured correctly, and net_failover advertises
> that it can handle TSO packets with IPIP encap, then still virtio_net
> should not advertise it and software GSO be applied on its
> dev_queue_xmit call.
>
> This is assuming that the packet not only has SKB_GSO_IPXIP4 correctly
> set, but also tunneling fields like skb->encapsulated and
> skb_inner_network_header.
>
> Thanks very much for your comment!
>
> Yes, the packet is correct. Another thing i have not pointed directly is
> that the pkt has SKB_GSO_DODGY. net_failover do not advertises GSO_ROBUST
> but virtio_net do.
>
>
> If net_failover does not advertise NETIF_F_GSO_ROBUST, then
> tcp_gso_segment will pass a packet with SKB_GSO_DODGY to the
> software gso stack, not taking the branch
>
>        if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {
>
> As i tested, packet with SKB_GSO_DODGY hits this branch. packet's gso_typ=
e=3D0x0103, which
> means SKB_GSO_TCPV4, SKB_GSO_DODGY and SKB_GSO_IPXIP4. net_failover match=
es
> the condition.
>
> Consequently, tcp_gso_segment returns NULL, there is no software gso did =
here. And
> network_header points to inner iph.
>
> Software gso is did by virtio_net which not advertises NETIF_F_GSO_IPXIP4=
. It skips the outer
> iph, and keeps it unchanged.
>
> ---
> net/ipv4/af_inet.c | 10 +++++++++-
> 1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 9c465ba..f8b3f8a 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1425,10 +1425,18 @@ struct sk_buff *inet_gso_segment(struct sk_buff *=
skb,
> static struct sk_buff *ipip_gso_segment(struct sk_buff *skb,
>                                       netdev_features_t features)
> {
> +       struct sk_buff *segs;
> +       int nhoff;
> +
>       if (!(skb_shinfo(skb)->gso_type & SKB_GSO_IPXIP4))
>               return ERR_PTR(-EINVAL);
>
> -       return inet_gso_segment(skb, features);
> +       nhoff =3D skb_network_header(skb) - skb_mac_header(skb);
> +       segs =3D inet_gso_segment(skb, features);
> +       if (!segs)
> +               skb->network_header =3D skb_mac_header(skb) + nhoff - skb=
->head;
> +
> +       return segs;
> }
>
>
> If this would be needed for IPIP, then the same would be needed for SIT, =
etc.
>
> Is the skb_network_header
>
> 1. correctly pointing to the outer header of the TSO packet before the
> call to inet_gso_segment
> 2. incorrectly pointing to the inner header of the (still) TSO packet
> after the call to inet_gso_segment
>
> inet_gso_segment already does the same operation: save nhoff, pull
> network header, call callbacks.gso_segment (which can be
> ipip_gso_segment->inet_gso_segment), then place the network header
> back at nhoff.
>
> values print in skb_mac_gso_segment() before callbacks.gso_segment:
> ipip:               vlan_depth=3D0 mac_len=3D0 skb->network_header=3D206
> net_failover:  vlan_depth=3D14 mac_len=3D14 skb->network_header=3D186
> virtio_net:      vlan_depth=3D34 mac_len=3D34 skb->network_header=3D206
>
> agree to add sit/ip4ip6/ip6ip6, and patch can be simplified as:
>
>
> If IPIP GSO was so broken, I think we would have found it long before.
>
> As said, inet_gso_segment should already do the right thing for ipip:
> it will be called twice.
>
>
> SKB_GSO_DODGY flag and net_failover conduct this issue. local traffic jus=
t works fine.

Got it. That is an uncommon combination. SKB_GSO_DODGY is set from
external virtio_net, which does not support tunnels. But a path with
an added tunnel might cause this combination.

And inet_gso_segment resets the network header, both times, before
calling callbacks.gso_segment()

        skb_reset_network_header(skb);
        nhoff =3D skb_network_header(skb) - skb_mac_header(skb);

        [...]

        if (likely(ops && ops->callbacks.gso_segment))
                segs =3D ops->callbacks.gso_segment(skb, features);

And resets that after for each skb in segs.

        skb =3D segs;
        do {
                [...]
                skb->network_header =3D (u8 *)iph - skb->head;

But does not do this if segs =3D=3D NULL.

The packet has to be restored before it is passed to the device. I
think we have to handle this case correctly in inet_gso_segment,
instead of patching it up in all the various tunnel devices.

The same holds for ipv6_gso_segment.
