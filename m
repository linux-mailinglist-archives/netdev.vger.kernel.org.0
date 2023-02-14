Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18766966D2
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjBNO2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbjBNO2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:28:40 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A04A8
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:28:17 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id 5so17528054qtp.9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnfZ4oANvZCuqL9+AVk47StSxBLXqrzbcTDgReI76Hc=;
        b=hMpMKRyXEDhkIimop9xFc2PzAT5+RBNC6oF4ehzapjNI75FCcxINC1rbKK1BOSCHlN
         9TT0CAK2VqYuwjl0EWYj6iUhAWPt99XpqBxgC3d+INw+SXnAIpAbKz6ngv9VEg5lejme
         RH2Y7VI/vizc1A5DSmwNKdmC+eIq2GrQ13G9NLRioq9a3ZTCE5xfGJxm6C9xvdfc5iHN
         3RdrDNdyNjG6Hzcg+/pWqoGF44y+Ff+jM306FI3NABQWsMa8fH+BrOchlNqxBYvAp2Oe
         hVK6eIjW4/70d+G6y3tQY+Wq7RUeHnR3vX1JspY256UdP8VTNYbLTKpqK5TSk9JDwf/G
         IHdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AnfZ4oANvZCuqL9+AVk47StSxBLXqrzbcTDgReI76Hc=;
        b=Xh6K47Czu76Lql1HbBhFe+fDn0hhmxiwwkOTjOGXKhPO3qwod9+amEQB5sQOufsllu
         gcqrW21gNjt1h1ZC/4K0YDoIDgEIlXD041pFy9lwjc0nmmZs91T9jGLVIUcBucgM0bfw
         Aw2hq71nF/0H0MJpO7H5ukBDjWbvbVVHcaL/V7BYUTMIjxy23mloRXHAUfG/Xz/uNYD8
         EkgfxnriXezxXa1CFXU2UlaMe6zIgHooS13mXtlgl7w1zkQ61EBt8nf1WYHaM3GwjDRt
         P0ut4jqwtuqrUcKRUOvpqlj2l3XkmexrbNLKAhEIdUa2it0EYufHlVTM5/zV3On6DUt5
         uM8g==
X-Gm-Message-State: AO0yUKVeFNCS5T3moB+orOUn/F8Nwpx2Dh9A6Cg5KNysxPEJn7Tq7j7R
        V2ae7Vh7MqVgFEmzX7KHY7o=
X-Google-Smtp-Source: AK7set9L4d895qYLp4N4zT8NLw3kOJI+Tca7yzSPdO+k/BZB8+Pbj3lUsKrjueKxG26cFY6k350Wyg==
X-Received: by 2002:a05:622a:2:b0:3b8:6763:c25f with SMTP id x2-20020a05622a000200b003b86763c25fmr4080273qtw.13.1676384896670;
        Tue, 14 Feb 2023 06:28:16 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 10-20020a37030a000000b007068b49b8absm11722147qkd.62.2023.02.14.06.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:28:16 -0800 (PST)
Date:   Tue, 14 Feb 2023 09:28:15 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Message-ID: <63eb9a7fe973e_310218208b4@willemb.c.googlers.com.notmuch>
In-Reply-To: <d759d787-4d76-c8e1-a5e2-233a097679b1@antgroup.com>
References: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
 <1675946595-103034-3-git-send-email-amy.saq@antgroup.com>
 <20230209080612-mutt-send-email-mst@kernel.org>
 <858f8db1-c107-1ac5-bcbc-84e0d36c981d@antgroup.com>
 <20230210030710-mutt-send-email-mst@kernel.org>
 <63e665348b566_1b03a820873@willemb.c.googlers.com.notmuch>
 <d759d787-4d76-c8e1-a5e2-233a097679b1@antgroup.com>
Subject: Re: [PATCH 2/2] net/packet: send and receive pkt with given
 vnet_hdr_sz
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

=E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> =

> =E5=9C=A8 2023/2/10 =E4=B8=8B=E5=8D=8811:39, Willem de Bruijn =E5=86=99=
=E9=81=93:
> > Michael S. Tsirkin wrote:
> >> On Fri, Feb 10, 2023 at 12:01:03PM +0800, =E6=B2=88=E5=AE=89=E7=90=AA=
(=E5=87=9B=E7=8E=A5) wrote:
> >>> =E5=9C=A8 2023/2/9 =E4=B8=8B=E5=8D=889:07, Michael S. Tsirkin =E5=86=
=99=E9=81=93:
> >>>> On Thu, Feb 09, 2023 at 08:43:15PM +0800, =E6=B2=88=E5=AE=89=E7=90=
=AA(=E5=87=9B=E7=8E=A5) wrote:
> >>>>> From: "Jianfeng Tan" <henry.tjf@antgroup.com>
> >>>>>
> >>>>> When raw socket is used as the backend for kernel vhost, currentl=
y it
> >>>>> will regard the virtio net header as 10-byte, which is not always=
 the
> >>>>> case since some virtio features need virtio net header other than=

> >>>>> 10-byte, such as mrg_rxbuf and VERSION_1 that both need 12-byte v=
irtio
> >>>>> net header.
> >>>>>
> >>>>> Instead of hardcoding virtio net header length to 10 bytes, tpack=
et_snd,
> >>>>> tpacket_rcv, packet_snd and packet_recvmsg now get the virtio net=
 header
> >>>>> size that is recorded in packet_sock to indicate the exact virtio=
 net
> >>>>> header size that virtio user actually prepares in the packets. By=
 doing
> >>>>> so, it can fix the issue of incorrect mac header parsing when the=
se
> >>>>> virtio features that need virtio net header other than 10-byte ar=
e
> >>>>> enable.
> >>>>>
> >>>>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> >>>>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> >>>>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> >>>> Does it handle VERSION_1 though? That one is also LE.
> >>>> Would it be better to pass a features bitmap instead?
> >>>
> >>> Thanks for quick reply!
> >>>
> >>> I am a little confused abot what "LE" presents here?
> >> LE =3D=3D little_endian.
> >> Little endian format.
> >>
> >>> For passing a features bitmap to af_packet here, our consideration =
is
> >>> whether it will be too complicated for af_packet to understand the =
virtio
> >>> features bitmap in order to get the vnet header size. For now, all =
the
> >>> virtio features stuff is handled by vhost worker and af_packet actu=
ally does
> >>> not need to know much about virtio features. Would it be better if =
we keep
> >>> the virtio feature stuff in user-level and let user-level tell af_p=
acket how
> >>> much space it should reserve?
> >> Presumably, we'd add an API in include/linux/virtio_net.h ?
> > Better leave this opaque to packet sockets if they won't act on this
> > type info.
> >   =

> > This patch series probably should be a single patch btw. As else the
> > socket option introduced in the first is broken at that commit, since=

> > the behavior is only introduced in patch 2.
> =

> =

> Good point, will merge this patch series into one patch.
> =

> =

> Thanks for Michael's enlightening advice, we plan to modify current UAP=
I =

> change of adding an extra socketopt from only setting vnet header size =

> only to setting a bit-map of virtio features, and implement another =

> helper function in include/linux/virtio_net.h to parse the feature =

> bit-map. In this case, packet sockets have no need to understand the =

> feature bit-map but only pass this bit-map to virtio_net helper and get=
 =

> back the information, such as vnet header size, it needs.
> =

> This change will make the new UAPI more general and avoid further =

> modification if there are more virtio features to support in the future=
.
>

Please also comment how these UAPI extension are intended to be used.
As that use is not included in this initial patch series.

If the only intended user is vhost-net, we can consider not exposing
outside the kernel at all. That makes it easier to iterate if
necessary (no stable ABI) and avoids accidentally opening up new
avenues for bugs and exploits (syzkaller has a history with
virtio_net_header options).
