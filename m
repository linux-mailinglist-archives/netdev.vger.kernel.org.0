Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC27E6DF790
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjDLNod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjDLNo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:44:29 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231DC448E;
        Wed, 12 Apr 2023 06:44:28 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id bl15so9799091qtb.10;
        Wed, 12 Apr 2023 06:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681307067; x=1683899067;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QqLOoYuvJJRPIcZm3TZ6Y4nV3VYZ7jXaulXKmOxSn9k=;
        b=ANvgwCCz62nQ/08Mw3shAPAJdUPaG0u16mdpguShxt8MQLTLv8vZPpc0pTRdKTvOqd
         6Ivd/1YD3Ylk7MDdpY5VMWNw46WRjZKKG1JJE0b9muI+tesC35hql0zpChQ8w4zj4SLd
         X4F/d3rK29ZhxgYhqD5e6v+kiVN1YJ/T38txEj/srN4y3paI/I0Ag73zhsz8VC6Ba+cP
         1auvevIgpuDyKTlOVeNq+kk9YUg8nfHlMj4EC2f+Njlj7iNkQmKq3gWe4jfcNzcufzwk
         8pbmF311OrGNvc2SGeLyq0ERyIIy02BOhDagJ1eNebC21AryAEmiLLuaLWbLYFvsv6NA
         pJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681307067; x=1683899067;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QqLOoYuvJJRPIcZm3TZ6Y4nV3VYZ7jXaulXKmOxSn9k=;
        b=EZR19cM3bq6/WXYXa4P9JkarV8hPkz5/euMkDnTKh+r4Rw8SGI1QVhYgmp5L+1Qwev
         2YVAGWVr1S29z7k24RCNCP/sNWjPin+NnydJV4aaz5Ez8J6kKIfxYQAmNpMng/nQKYzN
         DEObPceCHgv82dnWbWacca4XUV+TbK6zXCJYkGLEjimab+1wTnMP24CIfe2P8MMWfi+2
         fe/FlVI+I/sxsoV0FJfQtZvrrLkuOG+rOZwGkRJOaOW4VUsmfDpxnGeFA2wQ0GcM0v1l
         aYX+9TZ7BNeTHDgvLQBnSYhsIlqVJcmMfMHYxsdy/AGEsKfBl5iRQSLqJkdjpHBD6nrT
         P3aQ==
X-Gm-Message-State: AAQBX9ejdEYUarmj0FzKdlMO1J/BOoD2XOF9UwZNUUn7POLAKbL7lGC1
        EbhRO0qeYeGz+OEh1nOBSqc=
X-Google-Smtp-Source: AKy350YbHdOz/3OZgKhx+v5bbxoyF4knB2oy71velQXUl0AZyVh44iGNNDBDSfOtNK3f+eCz2ioEqQ==
X-Received: by 2002:a05:622a:1a9d:b0:3e4:bfb2:1f64 with SMTP id s29-20020a05622a1a9d00b003e4bfb21f64mr21467660qtc.20.1681307067222;
        Wed, 12 Apr 2023 06:44:27 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id h2-20020ac87442000000b003e3914c6839sm4276917qtr.43.2023.04.12.06.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:44:26 -0700 (PDT)
Date:   Wed, 12 Apr 2023 09:44:26 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     "luwei (O)" <luwei32@huawei.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com, brouer@redhat.com,
        keescook@chromium.org, jbenc@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <6436b5ba5c005_41e2294dd@willemb.c.googlers.com.notmuch>
In-Reply-To: <c90abe8c-ffa0-f986-11eb-bde65c84d18b@huawei.com>
References: <20230410022152.4049060-1-luwei32@huawei.com>
 <CANn89iKFLREJV_cfHEk6wz6xXVv_jSrZ_UyXAB8VpH7gMXacxQ@mail.gmail.com>
 <643447ba5224a_83e69294b6@willemb.c.googlers.com.notmuch>
 <450994d7-4a77-99df-6317-b535ea73e01d@huawei.com>
 <CANn89iLOcvDRMi9kVr86xNp5=h4JWpx9yYWicVxCwSMgAJGf_g@mail.gmail.com>
 <c90abe8c-ffa0-f986-11eb-bde65c84d18b@huawei.com>
Subject: Re: [PATCH net] net: Add check for csum_start in
 skb_partial_csum_set()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

luwei (O) wrote:
> =

> =E5=9C=A8 2023/4/11 4:13 PM, Eric Dumazet =E5=86=99=E9=81=93:
> > On Tue, Apr 11, 2023 at 4:33=E2=80=AFAM luwei (O) <luwei32@huawei.com=
> wrote:
> >>
> >> =E5=9C=A8 2023/4/11 1:30 AM, Willem de Bruijn =E5=86=99=E9=81=93:
> >>
> >> Eric Dumazet wrote:
> >>
> >> On Mon, Apr 10, 2023 at 4:22=E2=80=AFAM Lu Wei <luwei32@huawei.com> =
wrote:
> >>
> >> If an AF_PACKET socket is used to send packets through a L3 mode ipv=
lan
> >> and a vnet header is set via setsockopt() with the option name of
> >> PACKET_VNET_HDR, the value of offset will be nagetive in function
> >> skb_checksum_help() and trigger the following warning:
> >>
> >> WARNING: CPU: 3 PID: 2023 at net/core/dev.c:3262
> >> skb_checksum_help+0x2dc/0x390
> >> ......
> >> Call Trace:
> >>   <TASK>
> >>   ip_do_fragment+0x63d/0xd00
> >>   ip_fragment.constprop.0+0xd2/0x150
> >>   __ip_finish_output+0x154/0x1e0
> >>   ip_finish_output+0x36/0x1b0
> >>   ip_output+0x134/0x240
> >>   ip_local_out+0xba/0xe0
> >>   ipvlan_process_v4_outbound+0x26d/0x2b0
> >>   ipvlan_xmit_mode_l3+0x44b/0x480
> >>   ipvlan_queue_xmit+0xd6/0x1d0
> >>   ipvlan_start_xmit+0x32/0xa0
> >>   dev_hard_start_xmit+0xdf/0x3f0
> >>   packet_snd+0xa7d/0x1130
> >>   packet_sendmsg+0x7b/0xa0
> >>   sock_sendmsg+0x14f/0x160
> >>   __sys_sendto+0x209/0x2e0
> >>   __x64_sys_sendto+0x7d/0x90
> >>
> >> The root cause is:
> >> 1. skb->csum_start is set in packet_snd() according vnet_hdr:
> >>     skb->csum_start =3D skb_headroom(skb) + (u32)start;
> >>
> >>     'start' is the offset from skb->data, and mac header has been
> >>     set at this moment.
> >>
> >> 2. when this skb arrives ipvlan_process_outbound(), the mac header
> >>     is unset and skb_pull is called to expand the skb headroom.
> >>
> >> 3. In function skb_checksum_help(), the variable offset is calculate=
d
> >>     as:
> >>        offset =3D skb->csum_start - skb_headroom(skb);
> >>
> >>     since skb headroom is expanded in step2, offset is nagetive, and=
 it
> >>     is converted to an unsigned integer when compared with skb_headl=
en
> >>     and trigger the warning.
> >>
> >> Not sure why it is negative ? This seems like the real problem...
> >>
> >> csum_start is relative to skb->head, regardless of pull operations.
> >>
> >> whatever set csum_start to a too small value should be tracked and f=
ixed.
> >>
> >> Right. The only way I could see it go negative is if something does
> >> the equivalent of pskb_expand_head with positive nhead, and without
> >> calling skb_headers_offset_update.
> >>
> >> Perhaps the cause can be found by instrumenting all the above
> >> functions in the trace to report skb_headroom and csum_start.
> >> And also virtio_net_hdr_to_skb.
> >> .
> >>
> >> Hi, Eric  and Willem,  sorry for not describing this issue clearly e=
nough. Here is the detailed data path:
> >>
> >> 1.  Users call sendmsg() to send message with a AF_PACKET domain and=
 SOCK_RAW type socket. Since vnet_hdr
> >>
> >> is set,  csum_start is calculated as:
> >>
> >>                        skb->csum_start =3D skb_headroom(skb) + (u32)=
start;     // see the following code.
> >>
> >> the varible "start" it passed from user data, in my case it is 5 and=
 skb_headroom is 2, so skb->csum_start is 7.
> >>
> > I think you are rephrasing, but you did not address my feedback.
> >
> > Namely, "csum_start < skb->network_header" does not look sensical to =
me.
> >
> > csum_start should be related to the transport header, not network hea=
der.
> =

>  =C2=A0=C2=A0=C2=A0 csum_start is calculated in pakcet_snd() as:
> =

>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0 =C2=A0 skb->csum_start=
 =3D skb_headroom(skb) + (u32)start;
> =

>     the varible "start" it passed from user data via vnet_hdr as follow=
s:
> =

>      packet_snd()
>      ...	=

> 	if (po->has_vnet_hdr) {
> 		err =3D packet_snd_vnet_parse(msg, &len, &vnet_hdr);   // get vnet_hd=
r which includes start
> 		if (err)
> 		    goto out_unlock;
> 		has_vnet_hdr =3D true;
> 	}
>      ...
> =

>    csum_start should be at the transport header but users may pass an i=
ncorrect value.

Thanks for the clarification.

So this is another bogus packet socket packet, with csum_start set
somewhere in the L2 header, and that gets popped by ipvlan, correct?

Do you have the exact packet and the virtio_net_hdr that caused this,
perhaps?

skb_partial_csum_set in virtio_net_hdr_to_skb has some basic bounds
tests for csum_start, csum_off and csum_end. But that does not
preclude an offset in the L2 header, from what I can tell.

Conceivably this can be added, though it is a bit complex for
devices with variable length link layer headers. And it would have
to happen not only for packet sockets, but all users of
virtio_net_hdr.
