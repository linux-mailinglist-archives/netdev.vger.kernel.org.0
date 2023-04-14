Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDDD6E28AF
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjDNQs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDNQs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:48:57 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2C610B;
        Fri, 14 Apr 2023 09:48:56 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id w38so4604381qtc.11;
        Fri, 14 Apr 2023 09:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681490935; x=1684082935;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYFrhpQ9RuklqZMm5Jov4jQs/du3fa9ax2+V/T8I3B4=;
        b=HAsC2KFx4ZhC9Vk9eTh1uvqyaFzAv3u47L8Ts0I38lyKkn3QuXONTE9bTJLZOSh1ai
         6t8HICSzdwEU6pIGLWT4fYLYbhdij/bmiRgKhBPfod8qXIhK5PmLLFrUb5Ap7hAQYF0C
         /cX9U9dZagVOKBPdJxSh4osZvjd0HPp4CqvkM1E//oyX2IN9yqxqE8Yoz5Kx2ie1dD50
         wNJTp0+JoT/fF46MVHsa40JEszjarSFTYUpxrPXz5eoutthPAoBuMcsfKzosCAKeVxok
         AXssnqd5dqBHQ4c9CjR1z4KjxKqrZhr39MybeuXwQBGubqO+naukWGIQGjY/GcIJdzzl
         JJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681490935; x=1684082935;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IYFrhpQ9RuklqZMm5Jov4jQs/du3fa9ax2+V/T8I3B4=;
        b=O7Rzq0HP23TuOGB8fBtyKt/6P1DpKfjxF8noXBPTj9nbgtzvEcq+SSnT0k+TNo61bf
         4TkYkFXvZAm+oj4de4dFmzAyCYOzhMPaVW+1xC4s1R5Uy8IhjfItyp3RrU1QpTHxCAGK
         UwVN6Zl+JIAd3ny9U0mvlNS4eNwXDTBawXdUPm0a3MFKvWaMCd9dOQSHI8zmF5NRLEsT
         6Q2kJP/zAYgKW4jc++0p22FOwVKyOd46AXUkiq/kL7CHOx0UNCgEGKvYzdofx5fFU1ZW
         +xxhVYHKaCPQTp6RenEd3uEvs6n0bBKVjIjA/dyPNoezK0nfwt/XdgX+O7r9mX1vO5J9
         sjNg==
X-Gm-Message-State: AAQBX9dZufuMRoMYB5dS735wK1VJcF2y60eKgeSBi03SRuvXDvmmE/Yu
        M3x4eZtWPj4raqfvFxE7VvQ=
X-Google-Smtp-Source: AKy350Zvk6jAfuUHT9FBoZ123svM7TwOPzzzQXDIohAAiQ4zTKfkdnsFVteMhhwXargl3pdR2R7Yvg==
X-Received: by 2002:ac8:5c85:0:b0:3e4:cee3:7e4a with SMTP id r5-20020ac85c85000000b003e4cee37e4amr9163332qta.22.1681490935252;
        Fri, 14 Apr 2023 09:48:55 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id bj16-20020a05620a191000b0074c440eca7bsm135559qkb.116.2023.04.14.09.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 09:48:54 -0700 (PDT)
Date:   Fri, 14 Apr 2023 12:48:54 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     "luwei (O)" <luwei32@huawei.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "imagedong@tencent.com" <imagedong@tencent.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jbenc@redhat.com" <jbenc@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <643983f69b440_17854f2948c@willemb.c.googlers.com.notmuch>
In-Reply-To: <a30a8ffaa8dd4cb6a84103eecf0c3338@huawei.com>
References: <20230410022152.4049060-1-luwei32@huawei.com>
 <CANn89iKFLREJV_cfHEk6wz6xXVv_jSrZ_UyXAB8VpH7gMXacxQ@mail.gmail.com>
 <643447ba5224a_83e69294b6@willemb.c.googlers.com.notmuch>
 <450994d7-4a77-99df-6317-b535ea73e01d@huawei.com>
 <CANn89iLOcvDRMi9kVr86xNp5=h4JWpx9yYWicVxCwSMgAJGf_g@mail.gmail.com>
 <c90abe8c-ffa0-f986-11eb-bde65c84d18b@huawei.com>
 <6436b5ba5c005_41e2294dd@willemb.c.googlers.com.notmuch>
 <a30a8ffaa8dd4cb6a84103eecf0c3338@huawei.com>
Subject: =?UTF-8?Q?RE:_=E7=AD=94=E5=A4=8D:_[PATCH_net]_net:_Add_check_for?=
 =?UTF-8?Q?_csum=5Fstart_in_skb=5Fpartial=5Fcsum=5Fset=28=29?=
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
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

luwei (O) wrote:
> yes, here is the vnet_hdr:
> =

>     flags: 3
>     gso_type: 3
>     hdr_len: 23
>     gso_size: 58452
>     csum_start: 5
>     csum_offset: 16
> =

> and the packet:
> =

> | vnet_hdr | mac header | network header | data ... |
> =

>   memcpy((void*)0x20000200,
>          "\x03\x03\x02\x00\x54\xe4\x05\x00\x10\x00\x80\x00\x00\x53\xcc\=
x9c\x2b"
>          "\x19\x3b\x00\x00\x00\x89\x4f\x08\x03\x83\x81\x04",
>          29);
>   *(uint16_t*)0x200000c0 =3D 0x11;
>   *(uint16_t*)0x200000c2 =3D htobe16(0);
>   *(uint32_t*)0x200000c4 =3D r[3];
>   *(uint16_t*)0x200000c8 =3D 1;
>   *(uint8_t*)0x200000ca =3D 0;
>   *(uint8_t*)0x200000cb =3D 6;
>   memset((void*)0x200000cc, 170, 5);
>   *(uint8_t*)0x200000d1 =3D 0;
>   memset((void*)0x200000d2, 0, 2);
>   syscall(__NR_sendto, r[1], 0x20000200ul, 0xe45ful, 0ul, 0x200000c0ul,=
 0x14ul);

Thanks. So this can happen whenever a packet is injected into the tx
path with a virtio_net_hdr.

Even if we add bounds checking for the link layer header in pf_packet,
it can still point to the network header.

If packets are looped to the tx path, skb_pull is common if a packet
traverses tunnel devices. But csum_start does not directly matter in
the rx path (CHECKSUM_PARTIAL is just seen as CHECKSUM_UNNECESSARY).
Until it is forwarded again to the tx path.

So the question is which code calls skb_checksum_start_offset on the
tx path. Clearly, skb_checksum_help. Also a lot of drivers. Which
may cast the signed int return value to an unsigned. Even an u8 in =

the first driver I spotted (alx).

skb_postpull_rcsum anticipates a negative return value, as do other
core functions. So it clearly allowed in certain cases. We cannot
just bound it.

Summary after a long story: an initial investigation, but I don't have
a good solution so far. Maybe others have a good suggestiong based on
this added context.

Slightly tangential: this check in gso_reset_checksum seems needlessly
indirect:

         SKB_GSO_CB(skb)->csum_start =3D skb_checksum_start(skb) - skb->h=
ead;


> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Willem de Bruijn [mailto:willemdebruijn.ke=
rnel@gmail.com] =

> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2023=E5=B9=B44=E6=9C=8812=E6=97=A5=
 9:44 PM
> =E6=94=B6=E4=BB=B6=E4=BA=BA: luwei (O) <luwei32@huawei.com>; Eric Dumaz=
et <edumazet@google.com>
> =E6=8A=84=E9=80=81: Willem de Bruijn <willemdebruijn.kernel@gmail.com>;=
 davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com; asml.silence@gm=
ail.com; imagedong@tencent.com; brouer@redhat.com; keescook@chromium.org;=
 jbenc@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> =E4=B8=BB=E9=A2=98: Re: [PATCH net] net: Add check for csum_start in sk=
b_partial_csum_set()
> =

> luwei (O) wrote:
> > =

> > =E5=9C=A8 2023/4/11 4:13 PM, Eric Dumazet =E5=86=99=E9=81=93:
> > > On Tue, Apr 11, 2023 at 4:33=E2=80=AFAM luwei (O) <luwei32@huawei.c=
om> wrote:
> > >>
> > >> =E5=9C=A8 2023/4/11 1:30 AM, Willem de Bruijn =E5=86=99=E9=81=93:
> > >>
> > >> Eric Dumazet wrote:
> > >>
> > >> On Mon, Apr 10, 2023 at 4:22=E2=80=AFAM Lu Wei <luwei32@huawei.com=
> wrote:
> > >>
> > >> If an AF_PACKET socket is used to send packets through a L3 mode =

> > >> ipvlan and a vnet header is set via setsockopt() with the option =

> > >> name of PACKET_VNET_HDR, the value of offset will be nagetive in =

> > >> function
> > >> skb_checksum_help() and trigger the following warning:
> > >>
> > >> WARNING: CPU: 3 PID: 2023 at net/core/dev.c:3262
> > >> skb_checksum_help+0x2dc/0x390
> > >> ......
> > >> Call Trace:
> > >>   <TASK>
> > >>   ip_do_fragment+0x63d/0xd00
> > >>   ip_fragment.constprop.0+0xd2/0x150
> > >>   __ip_finish_output+0x154/0x1e0
> > >>   ip_finish_output+0x36/0x1b0
> > >>   ip_output+0x134/0x240
> > >>   ip_local_out+0xba/0xe0
> > >>   ipvlan_process_v4_outbound+0x26d/0x2b0
> > >>   ipvlan_xmit_mode_l3+0x44b/0x480
> > >>   ipvlan_queue_xmit+0xd6/0x1d0
> > >>   ipvlan_start_xmit+0x32/0xa0
> > >>   dev_hard_start_xmit+0xdf/0x3f0
> > >>   packet_snd+0xa7d/0x1130
> > >>   packet_sendmsg+0x7b/0xa0
> > >>   sock_sendmsg+0x14f/0x160
> > >>   __sys_sendto+0x209/0x2e0
> > >>   __x64_sys_sendto+0x7d/0x90
> > >>
> > >> The root cause is:
> > >> 1. skb->csum_start is set in packet_snd() according vnet_hdr:
> > >>     skb->csum_start =3D skb_headroom(skb) + (u32)start;
> > >>
> > >>     'start' is the offset from skb->data, and mac header has been
> > >>     set at this moment.
> > >>
> > >> 2. when this skb arrives ipvlan_process_outbound(), the mac header=

> > >>     is unset and skb_pull is called to expand the skb headroom.
> > >>
> > >> 3. In function skb_checksum_help(), the variable offset is calcula=
ted
> > >>     as:
> > >>        offset =3D skb->csum_start - skb_headroom(skb);
> > >>
> > >>     since skb headroom is expanded in step2, offset is nagetive, a=
nd it
> > >>     is converted to an unsigned integer when compared with skb_hea=
dlen
> > >>     and trigger the warning.
> > >>
> > >> Not sure why it is negative ? This seems like the real problem...
> > >>
> > >> csum_start is relative to skb->head, regardless of pull operations=
.
> > >>
> > >> whatever set csum_start to a too small value should be tracked and=
 fixed.
> > >>
> > >> Right. The only way I could see it go negative is if something doe=
s =

> > >> the equivalent of pskb_expand_head with positive nhead, and withou=
t =

> > >> calling skb_headers_offset_update.
> > >>
> > >> Perhaps the cause can be found by instrumenting all the above =

> > >> functions in the trace to report skb_headroom and csum_start.
> > >> And also virtio_net_hdr_to_skb.
> > >> .
> > >>
> > >> Hi, Eric  and Willem,  sorry for not describing this issue clearly=
 enough. Here is the detailed data path:
> > >>
> > >> 1.  Users call sendmsg() to send message with a AF_PACKET domain =

> > >> and SOCK_RAW type socket. Since vnet_hdr
> > >>
> > >> is set,  csum_start is calculated as:
> > >>
> > >>                        skb->csum_start =3D skb_headroom(skb) + (u3=
2)start;     // see the following code.
> > >>
> > >> the varible "start" it passed from user data, in my case it is 5 a=
nd skb_headroom is 2, so skb->csum_start is 7.
> > >>
> > > I think you are rephrasing, but you did not address my feedback.
> > >
> > > Namely, "csum_start < skb->network_header" does not look sensical t=
o me.
> > >
> > > csum_start should be related to the transport header, not network h=
eader.
> > =

> >  =C2=A0=C2=A0=C2=A0 csum_start is calculated in pakcet_snd() as:
> > =

> >  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0 =C2=A0 skb->csum_sta=
rt =3D skb_headroom(skb) + (u32)start;
> > =

> >     the varible "start" it passed from user data via vnet_hdr as foll=
ows:
> > =

> >      packet_snd()
> >      ...	=

> > 	if (po->has_vnet_hdr) {
> > 		err =3D packet_snd_vnet_parse(msg, &len, &vnet_hdr);   // get vnet_=
hdr which includes start
> > 		if (err)
> > 		    goto out_unlock;
> > 		has_vnet_hdr =3D true;
> > 	}
> >      ...
> > =

> >    csum_start should be at the transport header but users may pass an=
 incorrect value.
> =

> Thanks for the clarification.
> =

> So this is another bogus packet socket packet, with csum_start set some=
where in the L2 header, and that gets popped by ipvlan, correct?
> =

> Do you have the exact packet and the virtio_net_hdr that caused this, p=
erhaps?
> =

> skb_partial_csum_set in virtio_net_hdr_to_skb has some basic bounds tes=
ts for csum_start, csum_off and csum_end. But that does not preclude an o=
ffset in the L2 header, from what I can tell.
> =

> Conceivably this can be added, though it is a bit complex for devices w=
ith variable length link layer headers. And it would have to happen not o=
nly for packet sockets, but all users of virtio_net_hdr.


