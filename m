Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B54965F3F8
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbjAESts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjAEStq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:49:46 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1345B14E
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 10:49:45 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id e76so4665377ybh.11
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 10:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lK0zkJ8c1Q8dCJA4B3jTfL84ruSHo/CLLhGDyIyLdGU=;
        b=OdnVw3/JmR19/BLn7L6BweU6YuRQ4VTPl+1VpFH/ZKZxwjr+cOazS0BwI7JcbXBZI1
         IcJnYlj91gLVIVFWGaOkMUEUJcnaloYbDFOjzLy2SG4KwVKVogn+hVZx8hoHH7qTGxFC
         U0ZlWQYm0s7TTbFqtdWvTxViqRIAfjWs5+XU1QdUG/ooH8ufdfzlsgZekVPNEHyTcCuB
         1uqaLayjVP10sLQfuRPj/j10++4G77Z44uCl6Z1cChhJFEwLX4+xjWQAv5LPkkMHywK7
         7P4IAZnQqwjbu/SFkS5LuLw8imNqEDLhsY5wCpw/XQ2d4UrsicuBIvGzdwDQQLn5hdj4
         FMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lK0zkJ8c1Q8dCJA4B3jTfL84ruSHo/CLLhGDyIyLdGU=;
        b=dOYj8/wOrgg+YTuGv+LNYUKRaWYknRqo9ZtuR0A7Yj6sSj3n1lMzXYKBd92/ews3IN
         /3rL9NV6csxtlohdeyQTq1BC437BDuLR6z8/tpAo/7ve5HXTvxC3Ig3bSOrOxFYhtnBP
         2O616EoMdPxSMCSHZIGST0ZBjLSeO7CNJzLA9U1jkWI9SjQ+tmq2t77gjtxnTWvKLLwu
         mxypa3/HKN6rwnhw2QwPcCuG1Vll0hRsINwgWJBfcZQlux8X3reCtjQakHyz+zZKRvly
         AIGyMy4jqYbGrWSAwElFHW+euWf2N/xXt5xXcm5Wb4VP+U4e3mWyRZjO+Dw3rIjoIheQ
         /rWA==
X-Gm-Message-State: AFqh2komT0wrVZm3BMYkPBV63HKpWXBXP4wBI6aYOrI8Z+CjwDypcyt9
        YhsrfCaOUArI77Ynk0yTjvOvI1txN71cUAzeiSD74A2gkgr1xi/P
X-Google-Smtp-Source: AMrXdXuumbNmNEeoHtX/YDoy7gbOlrI6bbWM/hgM6j3X9k7vIXDCqsBGH17jKb1b/gJDDD8shOKHWR36J5u/rWxDGGs=
X-Received: by 2002:a25:3f06:0:b0:769:e5aa:4ac9 with SMTP id
 m6-20020a253f06000000b00769e5aa4ac9mr4666525yba.598.1672944584809; Thu, 05
 Jan 2023 10:49:44 -0800 (PST)
MIME-Version: 1.0
References: <CAK8fFZ5pzMaw3U1KXgC_OK4shKGsN=HDcR62cfPOuL0umXE1Ww@mail.gmail.com>
 <CANn89iJFmfv569Mu7REiP5OBMscuv8EBSGJqi_7c4pxcJymrKw@mail.gmail.com> <CAK8fFZ7cyhnUsFiCE-mpQF9P_Q7M70RiDbXGNvjA+2Y_PyuQYQ@mail.gmail.com>
In-Reply-To: <CAK8fFZ7cyhnUsFiCE-mpQF9P_Q7M70RiDbXGNvjA+2Y_PyuQYQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 5 Jan 2023 19:49:33 +0100
Message-ID: <CANn89iKeNj4uUAVW2GJUiD5COqvUJjey-4-gpuUTp-er=2hAWg@mail.gmail.com>
Subject: Re: Network performance regression with linux 6.1.y. Issue bisected
 to "5eddb24901ee49eee23c0bfce6af2e83fd5679bd" (gro: add support of (hw)gro
 packets to gro stack)
To:     Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc:     netdev@vger.kernel.org, lixiaoyan@google.com, pabeni@redhat.com,
        davem@davemloft.net, Igor Raits <igor.raits@gooddata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 5, 2023 at 6:54 PM Jaroslav Pulchart
<jaroslav.pulchart@gooddata.com> wrote:
>
> It is at KVM based VMs "CentOS 9 Stream" and "CentOS 8 Stream" using
> upstream kernel 6.1.y. Hosted on Dell PowerEdge 7525 servers (2x AMD
> 74F3) and OS CentOS 9 Stream again with upstream kernel 6.1.y or
> 6.0.y.
>
> # ethtool -k eth0
> Features for eth0:
> rx-checksumming: on [fixed]
> tx-checksumming: on
> tx-checksum-ipv4: off [fixed]
> tx-checksum-ip-generic: on
> tx-checksum-ipv6: off [fixed]
> tx-checksum-fcoe-crc: off [fixed]
> tx-checksum-sctp: off [fixed]
> scatter-gather: on
> tx-scatter-gather: on
> tx-scatter-gather-fraglist: off [fixed]
> tcp-segmentation-offload: on
> tx-tcp-segmentation: on
> tx-tcp-ecn-segmentation: on
> tx-tcp-mangleid-segmentation: off
> tx-tcp6-segmentation: on
> generic-segmentation-offload: on
> generic-receive-offload: on
> large-receive-offload: off [fixed]
> rx-vlan-offload: off [fixed]
> tx-vlan-offload: off [fixed]
> ntuple-filters: off [fixed]
> receive-hashing: off [fixed]
> highdma: on [fixed]
> rx-vlan-filter: on [fixed]
> vlan-challenged: off [fixed]
> tx-lockless: off [fixed]
> netns-local: off [fixed]
> tx-gso-robust: on [fixed]
> tx-fcoe-segmentation: off [fixed]
> tx-gre-segmentation: off [fixed]
> tx-gre-csum-segmentation: off [fixed]
> tx-ipxip4-segmentation: off [fixed]
> tx-ipxip6-segmentation: off [fixed]
> tx-udp_tnl-segmentation: off [fixed]
> tx-udp_tnl-csum-segmentation: off [fixed]
> tx-gso-partial: off [fixed]
> tx-tunnel-remcsum-segmentation: off [fixed]
> tx-sctp-segmentation: off [fixed]
> tx-esp-segmentation: off [fixed]
> tx-udp-segmentation: off [fixed]
> tx-gso-list: off [fixed]
> fcoe-mtu: off [fixed]
> tx-nocache-copy: off
> loopback: off [fixed]
> rx-fcs: off [fixed]
> rx-all: off [fixed]
> tx-vlan-stag-hw-insert: off [fixed]
> rx-vlan-stag-hw-parse: off [fixed]
> rx-vlan-stag-filter: off [fixed]
> l2-fwd-offload: off [fixed]
> hw-tc-offload: off [fixed]
> esp-hw-offload: off [fixed]
> esp-tx-csum-hw-offload: off [fixed]
> rx-udp_tunnel-port-offload: off [fixed]
> tls-hw-tx-offload: off [fixed]
> tls-hw-rx-offload: off [fixed]
> rx-gro-hw: on
> tls-hw-record: off [fixed]
> rx-gro-list: off
> macsec-hw-offload: off [fixed]
> rx-udp-gro-forwarding: off
> hsr-tag-ins-offload: off [fixed]
> hsr-tag-rm-offload: off [fixed]
> hsr-fwd-offload: off [fixed]
> hsr-dup-offload: off [fixed]
>
> # ethtool -i eth0
> driver: virtio_net
> version: 1.0.0
> firmware-version:
> expansion-rom-version:
> bus-info: 0000:03:00.0
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: no
> supports-priv-flags: no

Random guess, can you try:

diff --git a/net/core/gro.c b/net/core/gro.c
index fd8c6a7e8d3e2e6b439109d0089f44a547c7347e..f162674e7ae1bdf96bcbf7e1ed7=
326729d862f9a
100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -500,7 +500,8 @@ static enum gro_result dev_gro_receive(struct
napi_struct *napi, struct sk_buff
        BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
                                        sizeof(u32))); /* Avoid slow
unaligned acc */
        *(u32 *)&NAPI_GRO_CB(skb)->zeroed =3D 0;
-       NAPI_GRO_CB(skb)->flush =3D skb_has_frag_list(skb);
+       NAPI_GRO_CB(skb)->flush =3D skb_has_frag_list(skb) ||
+                                 (skb_shinfo(skb)->gso_type & SKB_GSO_DODG=
Y);
        NAPI_GRO_CB(skb)->is_atomic =3D 1;
        NAPI_GRO_CB(skb)->count =3D 1;
        if (unlikely(skb_is_gso(skb))) {



>
> =C4=8Dt 5. 1. 2023 v 18:43 odes=C3=ADlatel Eric Dumazet <edumazet@google.=
com> napsal:
> >
> > On Thu, Jan 5, 2023 at 6:37 PM Jaroslav Pulchart
> > <jaroslav.pulchart@gooddata.com> wrote:
> > >
> > > Hello,
> > >
> > > I would like to report a 6.1,y regression in a network performance
> > > observed when using "git clone".
> > >
> > > BAD: "git clone" speed with kernel 6.1,y:
> > >    # git clone git@github.com:..../.....git
> > >    ...
> > >    Receiving objects:   8% (47797/571306), 20.69 MiB | 3.27 MiB/s
> > >
> > > GOOD: "git clone" speed with kernel 6.0,y:
> > >    # git clone git@github.com:..../.....git
> > >    ...
> > >    Receiving objects:  72% (411341/571306), 181.05 MiB | 60.27 MiB/s
> > >
> > > I bisected the issue to a commit
> > > 5eddb24901ee49eee23c0bfce6af2e83fd5679bd "gro: add support of (hw)gro
> > > packets to gro stack". Reverting it from 6.1.y branch makes the git
> > > clone fast like with 6.0.y.
> > >
> >
> > Hmm, please provide more information.
> >
> > NIC used ? (ethtool -i eth0)
> >
> > ethtool -k eth0  # replace by your netdev name
> >
> > And packet captures would be nice (with and without the patch)
> >
> > Thanks.
>
>
>
> --
> Jaroslav Pulchart
> Sr. Principal SW Engineer
> GoodData
