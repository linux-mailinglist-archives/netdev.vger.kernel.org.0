Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D346DD4DA
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 10:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjDKIN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 04:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjDKINY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 04:13:24 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627273C1D
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 01:13:23 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-54ee108142eso146357587b3.2
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 01:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681200802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XO5OxXBtUApZnETMKg6BUEkuw3XDkJBM9olbC/KpGls=;
        b=iImShgytOWqwmjI1QZaM3g+IV1VXgt3UqZEXhNj7v1tH5Q5MxFJ3c5RCS/50eI1sF4
         ItmorCxYYdkYy0RMEOaHJEm2zcB/X822TjQNvEhy0MoLKS5IFZBpbO9mFdHDKH/B6S1w
         lnhsGgIC+JKq0hBSImQxHH0LO4b+8I0Wq6meXpb7tws31hL33Eb7R8NQDs2OpqUlwoTN
         tyWudDJ2SnR6uPRV9sbFyJd76mH3R+SLOYUL18jcZxTU2eQOyAKIKTPtIVy8Tl/Ake//
         yUgSAfqWD3mP61ce99sC/Y6tJbKujno5rj8U44FG9bbnVT5sh1K8cQIFGJ5RZRbT/XP+
         r2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681200802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XO5OxXBtUApZnETMKg6BUEkuw3XDkJBM9olbC/KpGls=;
        b=Gf5ncpkLEE3WT1JqtSZsQzpU8h6uLdEb5eUF8qlkuUo5HXJ2YFDB/KBTPlIAnRzbx2
         FtcnJHNr2UyAPwazE/qSGpl2d0HvW/NcKAbI8+T8J2Wi2FL/lmgdAfecuCwYLwBuA2T6
         V70U5dWmDDJIOqa/qj/kIIsjTQhoS42VtlS6/pyDrVbztrkKCVPq4myIYkEtyfcHe4iR
         A3WEq/PZkxn3/O51sRAohd9O58xkDAGQ0EEHHSGycqyH5ZGFz672PnLpEzBr7AuGOSvD
         pVVD3CaGWaWz/fvt+WXbLlR0c28YJ+RMuDWKeaf99d0bJ198mtLBYFciQEsylTx6L7DU
         uuEg==
X-Gm-Message-State: AAQBX9efSHjTsj7KcW8BleWz2bKFB7E7wJMBaW0+QqrBHTrmo50bBu8y
        IFhddI6AlKTkKdPFfHWXLOs1vg4cID+E64qA/bcVeQ==
X-Google-Smtp-Source: AKy350ZVjBTLigEso16gdVh01k35GsUyP2CHpwzOQC/h4+1X3MScbNdDNWvhqdUXLKYQ69UuOWc0iUdWHhwWWlgFd4g=
X-Received: by 2002:a81:bd10:0:b0:546:5b84:b558 with SMTP id
 b16-20020a81bd10000000b005465b84b558mr1209113ywi.10.1681200802307; Tue, 11
 Apr 2023 01:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230410022152.4049060-1-luwei32@huawei.com> <CANn89iKFLREJV_cfHEk6wz6xXVv_jSrZ_UyXAB8VpH7gMXacxQ@mail.gmail.com>
 <643447ba5224a_83e69294b6@willemb.c.googlers.com.notmuch> <450994d7-4a77-99df-6317-b535ea73e01d@huawei.com>
In-Reply-To: <450994d7-4a77-99df-6317-b535ea73e01d@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 Apr 2023 10:13:11 +0200
Message-ID: <CANn89iLOcvDRMi9kVr86xNp5=h4JWpx9yYWicVxCwSMgAJGf_g@mail.gmail.com>
Subject: Re: [PATCH net] net: Add check for csum_start in skb_partial_csum_set()
To:     "luwei (O)" <luwei32@huawei.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com, brouer@redhat.com,
        keescook@chromium.org, jbenc@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 4:33=E2=80=AFAM luwei (O) <luwei32@huawei.com> wrot=
e:
>
>
> =E5=9C=A8 2023/4/11 1:30 AM, Willem de Bruijn =E5=86=99=E9=81=93:
>
> Eric Dumazet wrote:
>
> On Mon, Apr 10, 2023 at 4:22=E2=80=AFAM Lu Wei <luwei32@huawei.com> wrote=
:
>
> If an AF_PACKET socket is used to send packets through a L3 mode ipvlan
> and a vnet header is set via setsockopt() with the option name of
> PACKET_VNET_HDR, the value of offset will be nagetive in function
> skb_checksum_help() and trigger the following warning:
>
> WARNING: CPU: 3 PID: 2023 at net/core/dev.c:3262
> skb_checksum_help+0x2dc/0x390
> ......
> Call Trace:
>  <TASK>
>  ip_do_fragment+0x63d/0xd00
>  ip_fragment.constprop.0+0xd2/0x150
>  __ip_finish_output+0x154/0x1e0
>  ip_finish_output+0x36/0x1b0
>  ip_output+0x134/0x240
>  ip_local_out+0xba/0xe0
>  ipvlan_process_v4_outbound+0x26d/0x2b0
>  ipvlan_xmit_mode_l3+0x44b/0x480
>  ipvlan_queue_xmit+0xd6/0x1d0
>  ipvlan_start_xmit+0x32/0xa0
>  dev_hard_start_xmit+0xdf/0x3f0
>  packet_snd+0xa7d/0x1130
>  packet_sendmsg+0x7b/0xa0
>  sock_sendmsg+0x14f/0x160
>  __sys_sendto+0x209/0x2e0
>  __x64_sys_sendto+0x7d/0x90
>
> The root cause is:
> 1. skb->csum_start is set in packet_snd() according vnet_hdr:
>    skb->csum_start =3D skb_headroom(skb) + (u32)start;
>
>    'start' is the offset from skb->data, and mac header has been
>    set at this moment.
>
> 2. when this skb arrives ipvlan_process_outbound(), the mac header
>    is unset and skb_pull is called to expand the skb headroom.
>
> 3. In function skb_checksum_help(), the variable offset is calculated
>    as:
>       offset =3D skb->csum_start - skb_headroom(skb);
>
>    since skb headroom is expanded in step2, offset is nagetive, and it
>    is converted to an unsigned integer when compared with skb_headlen
>    and trigger the warning.
>
> Not sure why it is negative ? This seems like the real problem...
>
> csum_start is relative to skb->head, regardless of pull operations.
>
> whatever set csum_start to a too small value should be tracked and fixed.
>
> Right. The only way I could see it go negative is if something does
> the equivalent of pskb_expand_head with positive nhead, and without
> calling skb_headers_offset_update.
>
> Perhaps the cause can be found by instrumenting all the above
> functions in the trace to report skb_headroom and csum_start.
> And also virtio_net_hdr_to_skb.
> .
>
> Hi, Eric  and Willem,  sorry for not describing this issue clearly enough=
. Here is the detailed data path:
>
> 1.  Users call sendmsg() to send message with a AF_PACKET domain and SOCK=
_RAW type socket. Since vnet_hdr
>
> is set,  csum_start is calculated as:
>
>                       skb->csum_start =3D skb_headroom(skb) + (u32)start;=
     // see the following code.
>
> the varible "start" it passed from user data, in my case it is 5 and skb_=
headroom is 2, so skb->csum_start is 7.
>

I think you are rephrasing, but you did not address my feedback.

Namely, "csum_start < skb->network_header" does not look sensical to me.

csum_start should be related to the transport header, not network header.

If you fix a bug, please fix it completely, instead of leaving room
for future syzbot reports.

Also, your reference to ipvlan pulling a mac header is irrelevant to
this bug, and adds confusion.

That is  because csum_start is relative to skb->head, not skb->data.
So ipvlan business does not change csum_start or skb->head.
