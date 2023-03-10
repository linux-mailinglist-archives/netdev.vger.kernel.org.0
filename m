Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482086B4944
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbjCJPK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbjCJPKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:10:31 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9502212DDC1
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 07:02:45 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id o4-20020a9d6d04000000b00694127788f4so3063944otp.6
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 07:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678460509;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HB4nklEPtrXrRyH2g7FCxO3X2KK/IqtRi6lPGzK5pdw=;
        b=TDHNmCbjQyMrU6V6v5st7Axdi9qq+xUV++c17LuekvpHam9sjmJ19ZDuEQF6axFVYZ
         LkL/NAOmUrYb1j3g5jiBhuse6r22h5dP2khdyjGAX6qlGtMAxUerOiNf18ATliHRcUms
         YEwDeVffb5WAc+z7+SS6a+nSF63PmUP2nPvXyKexnX4lFKF48YNCoDfUfeDOSIje7+4I
         xTO8fgLqTGWF9HrEUnpUS4jZRqJ1ROu3YkPXTXeqy1ileX+vMXZZc2ACqajoCmgjwxKP
         MwiqTc1mq56pYsKbHZTG52ffn6MStKjxbb8fVJMy5erjdeflLMQ3EMwom6pif/SnLe3e
         7L/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678460509;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HB4nklEPtrXrRyH2g7FCxO3X2KK/IqtRi6lPGzK5pdw=;
        b=2jgVKhgdTt+CX9dgc9zq/mEE7mkyKZi4qNwhh3JXbsnDlzTHyRUixQXRpDlcXiNWrz
         zjm7tRSPa1Z+swqclRw16UNjltDzSTNGAjJ35MsdXaho+9uQ2bO+fLs/56sKwTwRXwwc
         9Zge6qK0Sx8hjsiVcKcp61btrK0wNYgnMYFAbPDuKFRleAv9BA5aTWuvG3r9VNaaZn8I
         Ae2Of6aWMPsjfhP2ALhMu4MiWdltdpm114CfaXi7ju0jSOA0BTrC6az60WSeL7wsDFty
         Uw72oP4qkXX5/V1Bdj5Dt27Jo5+R0yE2yb06SoBtJxIZxwohrRuK+zr9C5dBSzUqCQwk
         NV8w==
X-Gm-Message-State: AO0yUKUfFIwZEnZDdivJJnvx/cnLvz2CDYFsn3x103eaC9RX1ZhoTFhR
        LuAHS8YEYCErK6jgUHX5Q+E=
X-Google-Smtp-Source: AK7set+EWYNFCQ3eDVtfmhtRGRsoD3cqNo/yX7RMQjCA7QmF2NunCxRl/tYObq7ytDD1nOCkoqvQlQ==
X-Received: by 2002:a9d:3e4:0:b0:694:88ea:6719 with SMTP id f91-20020a9d03e4000000b0069488ea6719mr6447410otf.28.1678460508127;
        Fri, 10 Mar 2023 07:01:48 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id z184-20020a3765c1000000b007437c92943csm163812qkb.91.2023.03.10.07.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:01:47 -0800 (PST)
Date:   Fri, 10 Mar 2023 10:01:47 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     mst@redhat.com, davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Message-ID: <640b465b85d3e_1dc964208be@willemb.c.googlers.com.notmuch>
In-Reply-To: <9ff86804-fe40-6e03-7ed4-6b431220e202@antgroup.com>
References: <1678168911-337042-1-git-send-email-amy.saq@antgroup.com>
 <64075d1f7ccfc_efd1020865@willemb.c.googlers.com.notmuch>
 <a55816a9-073b-c030-f7f8-19588124e08b@antgroup.com>
 <6409f8bf71c9e_1abbab2088e@willemb.c.googlers.com.notmuch>
 <9ff86804-fe40-6e03-7ed4-6b431220e202@antgroup.com>
Subject: Re: [PATCH v3] net/packet: support mergeable feature of virtio
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

> =E5=9C=A8 2023/3/9 =E4=B8=8B=E5=8D=8811:18, Willem de Bruijn =E5=86=99=E9=
=81=93:
> > =E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> >> =E5=9C=A8 2023/3/7 =E4=B8=8B=E5=8D=8811:49, Willem de Bruijn =E5=86=99=
=E9=81=93:
> >>> =E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> >>>> From: Jianfeng Tan <henry.tjf@antgroup.com>
> >>>>
> >>>> Packet sockets, like tap, can be used as the backend for kernel vh=
ost.
> >>>> In packet sockets, virtio net header size is currently hardcoded t=
o be
> >>>> the size of struct virtio_net_hdr, which is 10 bytes; however, it =
is not
> >>>> always the case: some virtio features, such as mrg_rxbuf, need vir=
tio
> >>>> net header to be 12-byte long.
> >>>>
> >>>> Mergeable buffers, as a virtio feature, is worthy of supporting: p=
ackets
> >>>> that are larger than one-mbuf size will be dropped in vhost worker=
's
> >>>> handle_rx if mrg_rxbuf feature is not used, but large packets
> >>>> cannot be avoided and increasing mbuf's size is not economical.
> >>>>
> >>>> With this mergeable feature enabled by virtio-user, packet sockets=
 with
> >>>> hardcoded 10-byte virtio net header will parse mac head incorrectl=
y in
> >>>> packet_snd by taking the last two bytes of virtio net header as pa=
rt of
> >>>> mac header.
> >>>> This incorrect mac header parsing will cause packet to be dropped =
due to
> >>>> invalid ether head checking in later under-layer device packet rec=
eiving.
> >>>>
> >>>> By adding extra field vnet_hdr_sz with utilizing holes in struct
> >>>> packet_sock to record currently used virtio net header size and su=
pporting
> >>>> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, pac=
ket
> >>>> sockets can know the exact length of virtio net header that virtio=
 user
> >>>> gives.
> >>>> In packet_snd, tpacket_snd and packet_recvmsg, instead of using
> >>>> hardcoded virtio net header size, it can get the exact vnet_hdr_sz=
 from
> >>>> corresponding packet_sock, and parse mac header correctly based on=
 this
> >>>> information to avoid the packets being mistakenly dropped.
> >>>>
> >>>> Besides, has_vnet_hdr field in struct packet_sock is removed since=
 all
> >>>> the information it provides is covered by vnet_hdr_sz field: a pac=
ket
> >>>> socket has a vnet header if and only if its vnet_hdr_sz is not zer=
o.
> >>>>
> >>>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> >>>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> >>>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> >>>> ---
> >>>> diff --git a/net/packet/internal.h b/net/packet/internal.h
> >>>> index 48af35b..9b52d93 100644
> >>>> --- a/net/packet/internal.h
> >>>> +++ b/net/packet/internal.h
> >>>> @@ -119,9 +119,9 @@ struct packet_sock {
> >>>>    	unsigned int		running;	/* bind_lock must be held */
> >>>>    	unsigned int		auxdata:1,	/* writer must hold sock lock */
> >>>>    				origdev:1,
> >>>> -				has_vnet_hdr:1,
> >>>>    				tp_loss:1,
> >>>> -				tp_tx_has_off:1;
> >>>> +				tp_tx_has_off:1,
> >>>> +				vnet_hdr_sz:8;
> >>> just a separate u8 variable , rather than 8 bits in a u32.
> >>>
> >>>>    	int			pressure;
> >>>>    	int			ifindex;	/* bound device		*/
> >>
> >> We plan to add
> >>
> >> +	   u8	vnet_hdr_sz:8;
> >>
> >> here.
> >> Is this a proper place to add this field to make sure the cacheline =
will not be broken?
> > When in doubt, use pahole (`pahole -C packet_sock net/packet/af_packe=
t.o`).
> >
> > There currently is a 27-bit hole before pressure. That would be a goo=
d spot.
> =

> =

> Thanks for the advice! We will try the tool.
> =

> Besides, we wonder whether it will be better to use unsigned char or u8=
 =

> here to be more consistent with other fields.

u8 is good=
