Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FAF5A25B7
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245608AbiHZKSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbiHZKS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:18:28 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5AFC7F9C;
        Fri, 26 Aug 2022 03:18:27 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id w4so460927qvs.4;
        Fri, 26 Aug 2022 03:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=Dz1GW/Qdi1YcI9Rfv5plP/JWYi7tLRS+C8AU1QTYQKM=;
        b=D48GTQF7KO2zZxm7doJR9hiYjP+rQLopidCqriofrar9KMROGbttiOMdAebR3nsvCE
         IvBaBGfD5xuRinOe2tvjQngrl1bJdxcF9LssKckg6iDmylRpyzezxlehsM94rRo0TdO3
         QOt0V85Wzbg6pXb8MjrGJ0qbKAmsvZ6stSVQbH0+Se7e2350iuDGRu1WTfyBZXtL6Vhp
         i+LIF+OiW3iegj4MCxnpJq3OBiLyDlpuND2mggYFpXaprtKcP2fVZjPbR5jsMljclkhb
         GenL3Aoet8LM2nxBIKqiDPJ2xK42jGclPWw4wkrHjzD7smCwSs07clwB1ESlmUUQxZuZ
         Mf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=Dz1GW/Qdi1YcI9Rfv5plP/JWYi7tLRS+C8AU1QTYQKM=;
        b=jxs5t7s4AphzYSfmOG2eIW+gQxDuWQ0/gd+sRqlOJ4YTaAA4ZchNvJmPSiLYYXEC0q
         uZCrg2XfKRIxbJwi1n3ULBoj4ICdG/1JdtH6SDMhbaxVdiXS/psob9AJHj1iu5n7waqr
         b/kV5ZNG9457EJjeMKi7/Yq2HnQqMQEOvWU3/ti0jzXiZSGQefp7VDMWFCv0Ki8G1MPO
         VgjKnVaShlirRcQuFj4/tgdAAys/0oh6U4sp9KfECpTYeivPTM5T/gY6LiKb2Uq21tQ2
         e5p4H0qXrU1qjIz0FSFZNjxwvbcXFVZKDNQuixhjnUUUAn7SPMbKd4FyyKVQFeYT2nHv
         sn0A==
X-Gm-Message-State: ACgBeo3dtj3KXYvZKUhvy0E5v8CJ6cud2ouWkojvDEaJ3OduEYlE8r6U
        n56OK3iCTJTpldBnXSvroWPwzt8Xvp0M503E4gg=
X-Google-Smtp-Source: AA6agR5th4qDafvY0qj03IiT7hBWvuJvo5zRaN4bUbXPWfeYKUa7bh48/mHS/OkbnSvysREOMB0sNDRZak6S/SS0Ec4=
X-Received: by 2002:a0c:90a2:0:b0:47b:6b36:f94a with SMTP id
 p31-20020a0c90a2000000b0047b6b36f94amr7363554qvp.26.1661509106310; Fri, 26
 Aug 2022 03:18:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220825154630.2174742-1-eyal.birger@gmail.com>
 <20220825154630.2174742-4-eyal.birger@gmail.com> <d2836dfb-6666-52cc-0d9c-17cb1542893c@6wind.com>
In-Reply-To: <d2836dfb-6666-52cc-0d9c-17cb1542893c@6wind.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Fri, 26 Aug 2022 13:18:15 +0300
Message-ID: <CAHsH6Gt3kU6tLVpSiq4jk7QQnVDzQin8qQyv_occKhL2RM8edA@mail.gmail.com>
Subject: Re: [PATCH ipsec-next,v3 3/3] xfrm: lwtunnel: add lwtunnel support
 for xfrm interfaces in collect_md mode
To:     nicolas.dichtel@6wind.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org, razor@blackwall.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
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

On Fri, Aug 26, 2022 at 11:05 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
>
> Le 25/08/2022 =C3=A0 17:46, Eyal Birger a =C3=A9crit :
> > Allow specifying the xfrm interface if_id and link as part of a route
> > metadata using the lwtunnel infrastructure.
> >
> > This allows for example using a single xfrm interface in collect_md
> > mode as the target of multiple routes each specifying a different if_id=
.
> >
> > With the appropriate changes to iproute2, considering an xfrm device
> > ipsec1 in collect_md mode one can for example add a route specifying
> > an if_id like so:
> >
> > ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1
> >
> > In which case traffic routed to the device via this route would use
> > if_id in the xfrm interface policy lookup.
> >
> > Or in the context of vrf, one can also specify the "link" property:
> >
> > ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1 link_dev eth15
> >
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> >
> > ----
> >
> > v3: netlink improvements as suggested by Nikolay Aleksandrov and
> >     Nicolas Dichtel
> >
> > v2:
> >   - move lwt_xfrm_info() helper to dst_metadata.h
> >   - add "link" property as suggested by Nicolas Dichtel
> > ---
> >  include/net/dst_metadata.h    | 11 +++++
> >  include/uapi/linux/lwtunnel.h | 10 +++++
> >  net/core/lwtunnel.c           |  1 +
> >  net/xfrm/xfrm_interface.c     | 85 +++++++++++++++++++++++++++++++++++
> >  4 files changed, 107 insertions(+)
> >
> > diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> > index e4b059908cc7..57f75960fa28 100644
> > --- a/include/net/dst_metadata.h
> > +++ b/include/net/dst_metadata.h
> > @@ -60,13 +60,24 @@ skb_tunnel_info(const struct sk_buff *skb)
> >       return NULL;
> >  }
> >
> > +static inline struct xfrm_md_info *lwt_xfrm_info(struct lwtunnel_state=
 *lwt)
> > +{
> > +     return (struct xfrm_md_info *)lwt->data;
> > +}
> > +
> >  static inline struct xfrm_md_info *skb_xfrm_md_info(const struct sk_bu=
ff *skb)
> >  {
> >       struct metadata_dst *md_dst =3D skb_metadata_dst(skb);
> > +     struct dst_entry *dst;
> >
> >       if (md_dst && md_dst->type =3D=3D METADATA_XFRM)
> >               return &md_dst->u.xfrm_info;
> >
> > +     dst =3D skb_dst(skb);
> > +     if (dst && dst->lwtstate &&
> > +         dst->lwtstate->type =3D=3D LWTUNNEL_ENCAP_XFRM)
> > +             return lwt_xfrm_info(dst->lwtstate);
> > +
> >       return NULL;
> >  }
> >
> > diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunne=
l.h
> > index 2e206919125c..229655ef792f 100644
> > --- a/include/uapi/linux/lwtunnel.h
> > +++ b/include/uapi/linux/lwtunnel.h
> > @@ -15,6 +15,7 @@ enum lwtunnel_encap_types {
> >       LWTUNNEL_ENCAP_SEG6_LOCAL,
> >       LWTUNNEL_ENCAP_RPL,
> >       LWTUNNEL_ENCAP_IOAM6,
> > +     LWTUNNEL_ENCAP_XFRM,
> >       __LWTUNNEL_ENCAP_MAX,
> >  };
> >
> > @@ -111,4 +112,13 @@ enum {
> >
> >  #define LWT_BPF_MAX_HEADROOM 256
> >
> > +enum {
> > +     LWT_XFRM_UNSPEC,
> > +     LWT_XFRM_IF_ID,
> > +     LWT_XFRM_LINK,
> > +     __LWT_XFRM_MAX,
> > +};
> > +
> > +#define LWT_XFRM_MAX (__LWT_XFRM_MAX - 1)
> > +
> >  #endif /* _UAPI_LWTUNNEL_H_ */
> > diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
> > index 9ccd64e8a666..6fac2f0ef074 100644
> > --- a/net/core/lwtunnel.c
> > +++ b/net/core/lwtunnel.c
> > @@ -50,6 +50,7 @@ static const char *lwtunnel_encap_str(enum lwtunnel_e=
ncap_types encap_type)
> >               return "IOAM6";
> >       case LWTUNNEL_ENCAP_IP6:
> >       case LWTUNNEL_ENCAP_IP:
> > +     case LWTUNNEL_ENCAP_XFRM:
> >       case LWTUNNEL_ENCAP_NONE:
> >       case __LWTUNNEL_ENCAP_MAX:
> >               /* should not have got here */
> > diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> > index e9a355047468..495dee8b0764 100644
> > --- a/net/xfrm/xfrm_interface.c
> > +++ b/net/xfrm/xfrm_interface.c
> > @@ -60,6 +60,88 @@ struct xfrmi_net {
> >       struct xfrm_if __rcu *collect_md_xfrmi;
> >  };
> >
> > +static const struct nla_policy xfrm_lwt_policy[LWT_XFRM_MAX + 1] =3D {
> > +     [LWT_XFRM_IF_ID]        =3D NLA_POLICY_MIN(NLA_U32, 1),
> > +     [LWT_XFRM_LINK]         =3D NLA_POLICY_MIN(NLA_S32, 1),
> IMHO, it would be better to keep consistency with IFLA_XFRM_LINK.
>
> $ git grep _LINK.*NLA_U32 net/ drivers/net/
> drivers/net/gtp.c:      [GTPA_LINK]             =3D { .type =3D NLA_U32, =
},
> drivers/net/vxlan/vxlan_core.c: [IFLA_VXLAN_LINK]       =3D { .type =3D N=
LA_U32 },
> ...
> net/core/rtnetlink.c:   [IFLA_LINK]             =3D { .type =3D NLA_U32 }=
,
> ...
> net/ipv4/ip_gre.c:      [IFLA_GRE_LINK]         =3D { .type =3D NLA_U32 }=
,
> net/ipv4/ip_vti.c:      [IFLA_VTI_LINK]         =3D { .type =3D NLA_U32 }=
,
> net/ipv4/ipip.c:        [IFLA_IPTUN_LINK]               =3D { .type =3D N=
LA_U32 },
> net/ipv6/ip6_gre.c:     [IFLA_GRE_LINK]        =3D { .type =3D NLA_U32 },
> net/ipv6/ip6_tunnel.c:  [IFLA_IPTUN_LINK]               =3D { .type =3D N=
LA_U32 },
> net/ipv6/ip6_vti.c:     [IFLA_VTI_LINK]         =3D { .type =3D NLA_U32 }=
,
> net/ipv6/sit.c: [IFLA_IPTUN_LINK]               =3D { .type =3D NLA_U32 }=
,
> net/sched/cls_u32.c:    [TCA_U32_LINK]          =3D { .type =3D NLA_U32 }=
,
> ...
> net/xfrm/xfrm_interface.c:      [IFLA_XFRM_LINK]        =3D { .type =3D N=
LA_U32 },
> $ git grep _LINK.*NLA_S32 net/ drivers/net/
> net/core/rtnetlink.c:   [IFLA_LINK_NETNSID]     =3D { .type =3D NLA_S32 }=
,
> $
>
> They all are U32. Adding one S32 would just add confusion.

Thanks for this input!

Indeed going over the other references it seems ifindex is treated as U32
when interfacing with userspace almost everywhere including netlink and
bpf. In the IOCTL interface it seems to be implemented as int, but at
least on my Ubuntu machine the manpage for e.g. if_nametoindex() describes
it as returning unsigned int.

Therefore I intend to resubmit this as U32.

Thanks,
Eyal.
