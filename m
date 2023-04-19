Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551CF6E7B6C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjDSOAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjDSN7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:59:43 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BC312D;
        Wed, 19 Apr 2023 06:59:42 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id m16so21185274qvx.9;
        Wed, 19 Apr 2023 06:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681912781; x=1684504781;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mksm0VsOLdOSoNAlcmc7x0LG0P70M6uaU5xaJTR9Yi8=;
        b=DK6QZdWzS5tUiY0UP95E6A9p627Ll66ULAwC7NBNG4nAQpMiyCtJEeQujRVq1f56wH
         YCv53uh/b41UZ+f2O+fWlx9iNUguAQkUlmnB2qYA+ciNzIS5sbj36s0TEC8lRHVkDzBi
         nEwJdJORaidlqP4NNMTe3ruSJxcQzV5WlBRhQzOFOG7jjk7tkYGno/QgmIoNiOw8i5UM
         mANnQFW0biJC68/3SmdPnOC+aMZ/yZs4KzrAJG3Ls90L25ahihrIXfjITgjLlJMacEnT
         5DKHNgidoVua5RHtW8tSZjh4OXJvZXFOM232QD0SaaLHWRWXbD065+z/LMD5XDpGSwdU
         iBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681912781; x=1684504781;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Mksm0VsOLdOSoNAlcmc7x0LG0P70M6uaU5xaJTR9Yi8=;
        b=fHzvM+/P9LKQw+C6qRhhtKaWECimJRJNplGgemHJxt1oKOEd8cH0Gb1TfYWbu2/Vlx
         W1tHymLQ/JNjwgHGLIUpXByBkLv5enPHuEu0fAuIJ/Ij99iD2fZThq9L2+5hTbEX2AQa
         lA1AfEzBiTJFZ2FsgxYGhVGeIW4SL8L5RREp1cS30OdGqlUkv/R0FHIHJLnST9NLG3k8
         MEREC1VywhFL2ix1YTpPmPw+9h1FoFRiWxJn+wQ2iliH+KIJabwrSc5SJIZKTXShrlAj
         DMNny8QYWE5VEcxvuVBcJG6OPZ9ie8TPOpgWmbYi0E99EtxcrXWKpCllPWPj7InmNHXJ
         18yA==
X-Gm-Message-State: AAQBX9ex+AhUqXIpTAS/bc/GxMkLXIcqj0qpo5RK10NNUnWZJdf08GBA
        KaZloZT0dJUKKnbTIVnYVoo=
X-Google-Smtp-Source: AKy350aacSqCCamQs8C2+X5RFlGsOFZb873CDbTZNZWiKQFbiTg+fmna358YypM+rd1FraYeP50eTg==
X-Received: by 2002:ad4:5baf:0:b0:5ef:50ea:2914 with SMTP id 15-20020ad45baf000000b005ef50ea2914mr26894910qvq.22.1681912781381;
        Wed, 19 Apr 2023 06:59:41 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id l3-20020a0ce083000000b005f44239c1d6sm160189qvk.68.2023.04.19.06.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:59:40 -0700 (PDT)
Date:   Wed, 19 Apr 2023 09:59:40 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>,
        =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Message-ID: <643ff3cca2eb3_38347529476@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230419072420.315079-1-amy.saq@antgroup.com>
References: <20230419072420.315079-1-amy.saq@antgroup.com>
Subject: RE: [PATCH v9] net/packet: support mergeable feature of virtio
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

=E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> From: Jianfeng Tan <henry.tjf@antgroup.com>
> =

> Packet sockets, like tap, can be used as the backend for kernel vhost.
> In packet sockets, virtio net header size is currently hardcoded to be
> the size of struct virtio_net_hdr, which is 10 bytes; however, it is no=
t
> always the case: some virtio features, such as mrg_rxbuf, need virtio
> net header to be 12-byte long.
> =

> Mergeable buffers, as a virtio feature, is worthy of supporting: packet=
s
> that are larger than one-mbuf size will be dropped in vhost worker's
> handle_rx if mrg_rxbuf feature is not used, but large packets
> cannot be avoided and increasing mbuf's size is not economical.
> =

> With this virtio feature enabled by virtio-user, packet sockets with
> hardcoded 10-byte virtio net header will parse mac head incorrectly in
> packet_snd by taking the last two bytes of virtio net header as part of=

> mac header.
> This incorrect mac header parsing will cause packet to be dropped due t=
o
> invalid ether head checking in later under-layer device packet receivin=
g.
> =

> By adding extra field vnet_hdr_sz with utilizing holes in struct
> packet_sock to record currently used virtio net header size and support=
ing
> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
> sockets can know the exact length of virtio net header that virtio user=

> gives.
> In packet_snd, tpacket_snd and packet_recvmsg, instead of using
> hardcoded virtio net header size, it can get the exact vnet_hdr_sz from=

> corresponding packet_sock, and parse mac header correctly based on this=

> information to avoid the packets being mistakenly dropped.
> =

> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>=
