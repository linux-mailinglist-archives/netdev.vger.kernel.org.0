Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A86A506282
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 05:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245300AbiDSDRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 23:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiDSDRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 23:17:23 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AD721E20
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 20:14:42 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c23so13977663plo.0
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 20:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ducxELbA3ew+r4raZNlzBzU/6aG62+EEJloA2OmmkZY=;
        b=BYxA8z0hnMRnB/V3icLvQZjGNZLxEqAaJEIGK3gdj+vGIoglvBDPMa3aoRiNcQCBXR
         j9qaDNs2rJ4uCWvTJ1z9bKRmTypxrGogqz8g1N1DarKUfCosysdj30lRxC/9/FrBgfv7
         zd4Aq1dIHHB6TR7faFERS0EJ8wzp3jBeRahgKbLNMcf6p04KSKwj2yAVe86Q6+lyJi1t
         UIl8SyyQW3Y6QkhET14IF+/3ioJzRUWC0PHCgrSAlDMxyPAakVMA6iNVMtfzqSWhp38P
         afryRqvDLWElZ+DAnkZa7grdGX6yq9WD/JzzKtr6Q4XGY7O/1SBIh2lJCWMcW1VEL6sV
         r+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ducxELbA3ew+r4raZNlzBzU/6aG62+EEJloA2OmmkZY=;
        b=F6JKw9j8dtjgQczMpm7+sjCGamLbUEusKeozWDlAoWd2wlXan2n7FtK9FBs61IIhDI
         0YpZH+63Xh3sA+Dv3uhuxMYZavZsX998p2pmCghFTwBgtkSb2cQtrMo7be7YAzFgnPK0
         VRrNzQiT0dQEjpeZIsXVs3sJs9lKy/86a4kss5rw5w/RunG1HpBBQdZuDo28QuKved/r
         OjyyqKKaIrJLuHI8xB3N/9pMi1BHcDcVuWqB2g3RgGT9tMOmsa5OPz350TdnTkBMIjZ+
         4h1vzwWbCgDlv/gu/SYLEedK2G1bHF1Cq5ou7h2xF1aSOKp2ybVCi+vfd5ZRC+nMfj+s
         tjGQ==
X-Gm-Message-State: AOAM531+HM6+6+MhRNaDpBLV4StyjXfg2+suVwwSphwSB0w/XY+1428c
        Rz5IpGoEDM4P39VJwwzciro=
X-Google-Smtp-Source: ABdhPJwt7TxBxz6wzqT7F1m1cyDzaHpVvNo4hU4qUKFi2hziivBJ+AX6LGz/uAVuOeGSUJIbMAMcCQ==
X-Received: by 2002:a17:90b:164b:b0:1d1:b0b7:9033 with SMTP id il11-20020a17090b164b00b001d1b0b79033mr16263936pjb.164.1650338082279;
        Mon, 18 Apr 2022 20:14:42 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00230d00b004f427ffd485sm15401225pfh.143.2022.04.18.20.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 20:14:41 -0700 (PDT)
Date:   Tue, 19 Apr 2022 11:14:35 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Mike Pattrick <mpattric@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 2/2] virtio_net: check L3 protocol for VLAN packets
Message-ID: <Yl4pG8MN7jxVybPB@Laptop-X1>
References: <20220418044339.127545-1-liuhangbin@gmail.com>
 <20220418044339.127545-3-liuhangbin@gmail.com>
 <CA+FuTSdTbpYGJo6ec2Ti+djXCj=gBAQpv9ZVaTtaJA-QUNNgYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSdTbpYGJo6ec2Ti+djXCj=gBAQpv9ZVaTtaJA-QUNNgYQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 11:40:44AM -0400, Willem de Bruijn wrote:
> On Mon, Apr 18, 2022 at 12:44 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > For gso packets, virtio_net_hdr_to_skb() will check the protocol via
> > virtio_net_hdr_match_proto(). But a packet may come from a raw socket
> > with a VLAN tag. Checking the VLAN protocol for virtio net_hdr makes no
> > sense. Let's check the L3 protocol if it's a VLAN packet.
> >
> > Make the virtio_net_hdr_match_proto() checking for all skbs instead of
> > only skb without protocol setting.
> >
> > Also update the data, protocol parameter for
> > skb_flow_dissect_flow_keys_basic() as the skb->protocol may not IP or IPv6.
> >
> > Fixes: 7e5cced9ca84 ("net: accept UFOv6 packages in virtio_net_hdr_to_skb")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  include/linux/virtio_net.h | 26 +++++++++++++++++++-------
> >  1 file changed, 19 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > index a960de68ac69..97b4f9680786 100644
> > --- a/include/linux/virtio_net.h
> > +++ b/include/linux/virtio_net.h
> > @@ -3,6 +3,7 @@
> >  #define _LINUX_VIRTIO_NET_H
> >
> >  #include <linux/if_vlan.h>
> > +#include <uapi/linux/if_arp.h>
> >  #include <uapi/linux/tcp.h>
> >  #include <uapi/linux/udp.h>
> >  #include <uapi/linux/virtio_net.h>
> > @@ -102,25 +103,36 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
> >                  */
> >                 if (gso_type && skb->network_header) {
> 
> This whole branch should not be taken by well formed packets. It is
> inside the else clause of
> 
>        if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
>           ..
>        } else {
> 
> GSO packets should always request checksum offload. The fact that we
> try to patch up some incomplete packets should not have to be expanded
> if we expand support to include VLAN.

Hi Willem,

I'm not sure if I understand correctly. Do you mean we don't need to check
L3 protocols for VLAN packet without NEEDS_CSUM flag? Which like

if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
	...
} else if (!eth_type_vlan(skb->protocol)) {
	...
}

Thanks
Hangbin
