Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56B16601C3
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbjAFOEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbjAFOEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:04:21 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DC978163
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:04:17 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-4c24993965eso17088637b3.12
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 06:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RF+wIfzy90rp6Z0wJzzXjyOTpsCxV1fMJjjAZTsI6JY=;
        b=eCFgkCxq2X0G50X10AIpscGks0MMTYDH+vTPQtLUQ0FkjCLrD2eBToIW5nAJ92aIrK
         7jjW74pGjjl8B79GS5muCoHrQikt2prc2pDBRhaYDn5fX5PtRDF11iW4W59JfnkMUuEv
         yHY2wQCz7N/xlwc5N1SWE23Mw+j8GayM23xSira1ptY4yEfihikPzTtliFF79oz1QClP
         uobz5JfTfX1sm/QSMMlHJpIaghKNHJsoRwkpujCF4VmipfiAMhroun/N7alUNahhKQ6p
         27B6jhh4pEzWpHVQPVMH61svxzAPYjogbQddPD8ljEWBDCojdomTxeffvyjm/UrN/d0X
         fwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RF+wIfzy90rp6Z0wJzzXjyOTpsCxV1fMJjjAZTsI6JY=;
        b=ADmelCb6kxsZoNDhB7eg+YYSmqW7jBC2Ku4z6TiR5cVbDqe2MpdUOSz/b+DPlmIXOn
         QqeeSXthLdqc0RDeIjebQ95fDohnZ8ehe9TOC+mt+lTFr5IXXGHhKWzlxNtrtgcyj0Hq
         BMCgOQLzBAaNcpDjU2mr4VBYyXseGLglRRTSVwW6DzTzDfH8BsrJFis6bc99wyAKbiBK
         FzdEDm6NQPEtaf+aP/5TVAcxpVL2c0R7PCkz9HU3/4KNsQJfEx/AR7JosFGgwcvT8/RA
         QveZCxISkeG+Pdl804nAn31bB+l+3jDnDhqjMr37+X/HWbkZRiVK4fE5W8ecvGTIagCV
         Sk5A==
X-Gm-Message-State: AFqh2kq9CSf8lEUOZUzahDI0m8ER+IkgsFOB9D1JNt9WFIux0vFsNGzT
        7c56mEb2KyIZja5mL16STSnJg8SLK/7HiU4INePe/A==
X-Google-Smtp-Source: AMrXdXut7nmVLQpAiiYVmCdWPqzm9Iv9LnrqmmhLaWnddwFsjGHCMZd5tLtJ2nsf70KAyOBt//IF98WeglFpxsdj5lQ=
X-Received: by 2002:a81:1441:0:b0:4bc:6c9c:bf9a with SMTP id
 62-20020a811441000000b004bc6c9cbf9amr1040186ywu.255.1673013856060; Fri, 06
 Jan 2023 06:04:16 -0800 (PST)
MIME-Version: 1.0
References: <CAK8fFZ5pzMaw3U1KXgC_OK4shKGsN=HDcR62cfPOuL0umXE1Ww@mail.gmail.com>
 <CANn89iJFmfv569Mu7REiP5OBMscuv8EBSGJqi_7c4pxcJymrKw@mail.gmail.com>
 <CAK8fFZ7cyhnUsFiCE-mpQF9P_Q7M70RiDbXGNvjA+2Y_PyuQYQ@mail.gmail.com>
 <CANn89iKeNj4uUAVW2GJUiD5COqvUJjey-4-gpuUTp-er=2hAWg@mail.gmail.com> <CAK8fFZ7cYRkGjUJD2D86G6Jh9YRmP_L+7Ke6CLFSyFmRkoe-Hg@mail.gmail.com>
In-Reply-To: <CAK8fFZ7cYRkGjUJD2D86G6Jh9YRmP_L+7Ke6CLFSyFmRkoe-Hg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 Jan 2023 15:04:04 +0100
Message-ID: <CANn89i+x+ogekTUieW3DD1wYTxZFrNW9XSLnm1KBy8KEkRYDxA@mail.gmail.com>
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

On Thu, Jan 5, 2023 at 8:56 PM Jaroslav Pulchart
<jaroslav.pulchart@gooddata.com> wrote:
>
> I can and I did. Your "Random guess" patch fix the problem and speed
> is like with 6.0.y:
>
>   # git clone ...
>   ...
>   Receiving objects: 100% (571306/571306), 350.58 MiB | 67.51 MiB/s, done=
.
>
> Thanks,

Excellent :)

I will move the new test out of the fast path though, in a section we
are sure gso_size is !=3D 0.

Something like this.

diff --git a/net/core/gro.c b/net/core/gro.c
index fd8c6a7e8d3e2e6b439109d0089f44a547c7347e..506f83d715f873c9bc3727e28ac=
e71e00fa79d2f
100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -505,8 +505,9 @@ static enum gro_result dev_gro_receive(struct
napi_struct *napi, struct sk_buff
        NAPI_GRO_CB(skb)->count =3D 1;
        if (unlikely(skb_is_gso(skb))) {
                NAPI_GRO_CB(skb)->count =3D skb_shinfo(skb)->gso_segs;
-               /* Only support TCP at the moment. */
-               if (!skb_is_gso_tcp(skb))
+               /* Only support TCP and non DODGY users. */
+               if (!skb_is_gso_tcp(skb) ||
+                   (skb_shinfo(skb)->gso_type & SKB_GSO_DODGY))
                        NAPI_GRO_CB(skb)->flush =3D 1;
        }



> JP
>
> =C4=8Dt 5. 1. 2023 v 19:49 odes=C3=ADlatel Eric Dumazet <edumazet@google.=
com> napsal:
> >
> > On Thu, Jan 5, 2023 at 6:54 PM Jaroslav Pulchart
> > <jaroslav.pulchart@gooddata.com> wrote:
> > >
> > > It is at KVM based VMs "CentOS 9 Stream" and "CentOS 8 Stream" using
> > > upstream kernel 6.1.y. Hosted on Dell PowerEdge 7525 servers (2x AMD
> > > 74F3) and OS CentOS 9 Stream again with upstream kernel 6.1.y or
> > > 6.0.y.
> > >
> > > # ethtool -k eth0
> > > Features for eth0:
> > > rx-checksumming: on [fixed]
> > > tx-checksumming: on
> > > tx-checksum-ipv4: off [fixed]
> > > tx-checksum-ip-generic: on
> > > tx-checksum-ipv6: off [fixed]
> > > tx-checksum-fcoe-crc: off [fixed]
> > > tx-checksum-sctp: off [fixed]
> > > scatter-gather: on
> > > tx-scatter-gather: on
> > > tx-scatter-gather-fraglist: off [fixed]
> > > tcp-segmentation-offload: on
> > > tx-tcp-segmentation: on
> > > tx-tcp-ecn-segmentation: on
> > > tx-tcp-mangleid-segmentation: off
> > > tx-tcp6-segmentation: on
> > > generic-segmentation-offload: on
> > > generic-receive-offload: on
> > > large-receive-offload: off [fixed]
> > > rx-vlan-offload: off [fixed]
> > > tx-vlan-offload: off [fixed]
> > > ntuple-filters: off [fixed]
> > > receive-hashing: off [fixed]
> > > highdma: on [fixed]
> > > rx-vlan-filter: on [fixed]
> > > vlan-challenged: off [fixed]
> > > tx-lockless: off [fixed]
> > > netns-local: off [fixed]
> > > tx-gso-robust: on [fixed]
> > > tx-fcoe-segmentation: off [fixed]
> > > tx-gre-segmentation: off [fixed]
> > > tx-gre-csum-segmentation: off [fixed]
> > > tx-ipxip4-segmentation: off [fixed]
> > > tx-ipxip6-segmentation: off [fixed]
> > > tx-udp_tnl-segmentation: off [fixed]
> > > tx-udp_tnl-csum-segmentation: off [fixed]
> > > tx-gso-partial: off [fixed]
> > > tx-tunnel-remcsum-segmentation: off [fixed]
> > > tx-sctp-segmentation: off [fixed]
> > > tx-esp-segmentation: off [fixed]
> > > tx-udp-segmentation: off [fixed]
> > > tx-gso-list: off [fixed]
> > > fcoe-mtu: off [fixed]
> > > tx-nocache-copy: off
> > > loopback: off [fixed]
> > > rx-fcs: off [fixed]
> > > rx-all: off [fixed]
> > > tx-vlan-stag-hw-insert: off [fixed]
> > > rx-vlan-stag-hw-parse: off [fixed]
> > > rx-vlan-stag-filter: off [fixed]
> > > l2-fwd-offload: off [fixed]
> > > hw-tc-offload: off [fixed]
> > > esp-hw-offload: off [fixed]
> > > esp-tx-csum-hw-offload: off [fixed]
> > > rx-udp_tunnel-port-offload: off [fixed]
> > > tls-hw-tx-offload: off [fixed]
> > > tls-hw-rx-offload: off [fixed]
> > > rx-gro-hw: on
> > > tls-hw-record: off [fixed]
> > > rx-gro-list: off
> > > macsec-hw-offload: off [fixed]
> > > rx-udp-gro-forwarding: off
> > > hsr-tag-ins-offload: off [fixed]
> > > hsr-tag-rm-offload: off [fixed]
> > > hsr-fwd-offload: off [fixed]
> > > hsr-dup-offload: off [fixed]
> > >
> > > # ethtool -i eth0
> > > driver: virtio_net
> > > version: 1.0.0
> > > firmware-version:
> > > expansion-rom-version:
> > > bus-info: 0000:03:00.0
> > > supports-statistics: yes
> > > supports-test: no
> > > supports-eeprom-access: no
> > > supports-register-dump: no
> > > supports-priv-flags: no
> >
> > Random guess, can you try:
> >
> > diff --git a/net/core/gro.c b/net/core/gro.c
> > index fd8c6a7e8d3e2e6b439109d0089f44a547c7347e..f162674e7ae1bdf96bcbf7e=
1ed7326729d862f9a
> > 100644
> > --- a/net/core/gro.c
> > +++ b/net/core/gro.c
> > @@ -500,7 +500,8 @@ static enum gro_result dev_gro_receive(struct
> > napi_struct *napi, struct sk_buff
> >         BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct napi_gro_cb, zeroed),
> >                                         sizeof(u32))); /* Avoid slow
> > unaligned acc */
> >         *(u32 *)&NAPI_GRO_CB(skb)->zeroed =3D 0;
> > -       NAPI_GRO_CB(skb)->flush =3D skb_has_frag_list(skb);
> > +       NAPI_GRO_CB(skb)->flush =3D skb_has_frag_list(skb) ||
> > +                                 (skb_shinfo(skb)->gso_type & SKB_GSO_=
DODGY);
> >         NAPI_GRO_CB(skb)->is_atomic =3D 1;
> >         NAPI_GRO_CB(skb)->count =3D 1;
> >         if (unlikely(skb_is_gso(skb))) {
> >
> >
> >
> > >
> > > =C4=8Dt 5. 1. 2023 v 18:43 odes=C3=ADlatel Eric Dumazet <edumazet@goo=
gle.com> napsal:
> > > >
> > > > On Thu, Jan 5, 2023 at 6:37 PM Jaroslav Pulchart
> > > > <jaroslav.pulchart@gooddata.com> wrote:
> > > > >
> > > > > Hello,
> > > > >
> > > > > I would like to report a 6.1,y regression in a network performanc=
e
> > > > > observed when using "git clone".
> > > > >
> > > > > BAD: "git clone" speed with kernel 6.1,y:
> > > > >    # git clone git@github.com:..../.....git
> > > > >    ...
> > > > >    Receiving objects:   8% (47797/571306), 20.69 MiB | 3.27 MiB/s
> > > > >
> > > > > GOOD: "git clone" speed with kernel 6.0,y:
> > > > >    # git clone git@github.com:..../.....git
> > > > >    ...
> > > > >    Receiving objects:  72% (411341/571306), 181.05 MiB | 60.27 Mi=
B/s
> > > > >
> > > > > I bisected the issue to a commit
> > > > > 5eddb24901ee49eee23c0bfce6af2e83fd5679bd "gro: add support of (hw=
)gro
> > > > > packets to gro stack". Reverting it from 6.1.y branch makes the g=
it
> > > > > clone fast like with 6.0.y.
> > > > >
> > > >
> > > > Hmm, please provide more information.
> > > >
> > > > NIC used ? (ethtool -i eth0)
> > > >
> > > > ethtool -k eth0  # replace by your netdev name
> > > >
> > > > And packet captures would be nice (with and without the patch)
> > > >
> > > > Thanks.
> > >
> > >
> > >
> > > --
> > > Jaroslav Pulchart
> > > Sr. Principal SW Engineer
> > > GoodData
>
>
>
> --
> Jaroslav Pulchart
> Sr. Principal SW Engineer
> GoodData
