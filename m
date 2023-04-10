Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450E36DCA03
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 19:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjDJRal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 13:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjDJRah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 13:30:37 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1055A2681;
        Mon, 10 Apr 2023 10:30:36 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id l1so6956982qvv.4;
        Mon, 10 Apr 2023 10:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681147835; x=1683739835;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfMMmtPEDLwOl/JKAguDStI8/SqoqRX9kqOTCMn7AGw=;
        b=d6LAhlAD/HEDF+Wi2ybYcJFdo5uqQjKD+ha83RTcAkYnwlYy8WSeJfOvlZFPAIf3UE
         KPtg1YNJ7TlBD+GKSKjI4yLiOGlnGtWiyQmbQAcYk/mWXWWnNTQO05v7COcmFDGUzIi6
         8vLm8er86fjdvyL923sUS2gsfaEByCa3lik6RiqHL04t4DeyitM0XlmFew1GOxmaGh/r
         yV72FYZY+xa61IkQv2SE/2R1zvp7ktDe3tiVDuOqae9c/WLk2oA3V/fBi7iaosPFDkpT
         LVacqWc9OW0hy6q8Dh/Us02lNHs2jbpuGDE326h2PEVWDZk+XknOL6JDCCy9RqlvObfr
         ArkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681147835; x=1683739835;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mfMMmtPEDLwOl/JKAguDStI8/SqoqRX9kqOTCMn7AGw=;
        b=C19ExgAg+B2v1ugWCrvC2V7Mz761OOoQoThLCg/O3T2eHP3OGs97yGtlLAp2CDFPH0
         zbbae8zn4B8/MBf/qW5L1Y+Od4pEWFclPSeEtHuRWuVGuaL8aUBhI7Y+8Sz5oTLAQfly
         Zrhw8UdNvT4jkfyQT6UtYHPAm1n88X9vkEJlDRyjSOkCppvShZhrCxf7JOTC2/QHE0GQ
         0W+Ut5qaQo0KzhmDOUb1ZHkEd6d7mZTKY9999Z7KoHZsZFtZg7jEEuwra5Fz+/Jidhl9
         LqYx5WaawQCgeg6PyhOHqvrbclf2QUB1/4HLzBxXUOV5r535C4uZ5YaXmIVh2jfNYH2U
         JWKA==
X-Gm-Message-State: AAQBX9cBW43t/ccEar+Ggd3Lp36trulm2FvViBanaJQNNFqXXy1u1WOo
        lwiJqHNkBOMeZ4Wg5qM7l8VcqWXHY5M=
X-Google-Smtp-Source: AKy350btNdvQi8RnKbkYq8pj3Vj+PYTvnVtml87+DRqgn0usWQrRdpJIUR64NxGg9qmQZKQy8iX0/Q==
X-Received: by 2002:ad4:5de8:0:b0:5ed:68ba:ce6b with SMTP id jn8-20020ad45de8000000b005ed68bace6bmr7079818qvb.4.1681147835104;
        Mon, 10 Apr 2023 10:30:35 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id e15-20020a0cf74f000000b005ead964bfa2sm1257153qvo.127.2023.04.10.10.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 10:30:34 -0700 (PDT)
Date:   Mon, 10 Apr 2023 13:30:34 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Eric Dumazet <edumazet@google.com>, Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com, brouer@redhat.com,
        keescook@chromium.org, jbenc@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <643447ba5224a_83e69294b6@willemb.c.googlers.com.notmuch>
In-Reply-To: <CANn89iKFLREJV_cfHEk6wz6xXVv_jSrZ_UyXAB8VpH7gMXacxQ@mail.gmail.com>
References: <20230410022152.4049060-1-luwei32@huawei.com>
 <CANn89iKFLREJV_cfHEk6wz6xXVv_jSrZ_UyXAB8VpH7gMXacxQ@mail.gmail.com>
Subject: Re: [PATCH net] net: Add check for csum_start in
 skb_partial_csum_set()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:
> On Mon, Apr 10, 2023 at 4:22=E2=80=AFAM Lu Wei <luwei32@huawei.com> wro=
te:
> >
> > If an AF_PACKET socket is used to send packets through a L3 mode ipvl=
an
> > and a vnet header is set via setsockopt() with the option name of
> > PACKET_VNET_HDR, the value of offset will be nagetive in function
> > skb_checksum_help() and trigger the following warning:
> >
> > WARNING: CPU: 3 PID: 2023 at net/core/dev.c:3262
> > skb_checksum_help+0x2dc/0x390
> > ......
> > Call Trace:
> >  <TASK>
> >  ip_do_fragment+0x63d/0xd00
> >  ip_fragment.constprop.0+0xd2/0x150
> >  __ip_finish_output+0x154/0x1e0
> >  ip_finish_output+0x36/0x1b0
> >  ip_output+0x134/0x240
> >  ip_local_out+0xba/0xe0
> >  ipvlan_process_v4_outbound+0x26d/0x2b0
> >  ipvlan_xmit_mode_l3+0x44b/0x480
> >  ipvlan_queue_xmit+0xd6/0x1d0
> >  ipvlan_start_xmit+0x32/0xa0
> >  dev_hard_start_xmit+0xdf/0x3f0
> >  packet_snd+0xa7d/0x1130
> >  packet_sendmsg+0x7b/0xa0
> >  sock_sendmsg+0x14f/0x160
> >  __sys_sendto+0x209/0x2e0
> >  __x64_sys_sendto+0x7d/0x90
> >
> > The root cause is:
> > 1. skb->csum_start is set in packet_snd() according vnet_hdr:
> >    skb->csum_start =3D skb_headroom(skb) + (u32)start;
> >
> >    'start' is the offset from skb->data, and mac header has been
> >    set at this moment.
> >
> > 2. when this skb arrives ipvlan_process_outbound(), the mac header
> >    is unset and skb_pull is called to expand the skb headroom.
> >
> > 3. In function skb_checksum_help(), the variable offset is calculated=

> >    as:
> >       offset =3D skb->csum_start - skb_headroom(skb);
> >
> >    since skb headroom is expanded in step2, offset is nagetive, and i=
t
> >    is converted to an unsigned integer when compared with skb_headlen=

> >    and trigger the warning.
> =

> Not sure why it is negative ? This seems like the real problem...
> =

> csum_start is relative to skb->head, regardless of pull operations.
> =

> whatever set csum_start to a too small value should be tracked and fixe=
d.

Right. The only way I could see it go negative is if something does
the equivalent of pskb_expand_head with positive nhead, and without
calling skb_headers_offset_update.

Perhaps the cause can be found by instrumenting all the above
functions in the trace to report skb_headroom and csum_start.
And also virtio_net_hdr_to_skb.
