Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C662B6F2A5D
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 20:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjD3SyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 14:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjD3SyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 14:54:13 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2077.outbound.protection.outlook.com [40.107.7.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F331BD5;
        Sun, 30 Apr 2023 11:54:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efX+6vpuZiNjCMw4pSciRB2Cb3u5kQolK7bCG36ldj8pSsv7Gzu9dlid+WPEpL5R9TPxClPna2LDBIQqWeYLT8wBmjXX3hSrPuzAgUSH+NoOuGP680fYtK43cKh6UJBvlRh1p4+dfABKS6gpL1ObTTvXZCdQlh9DSfO+Uu7hzI0gBnKYFfD5i8kVYA7cnGuBSLkDP5/OqW4ei+e/qBhGmrvJrB30DDwCHSUBtEwKZHbRG93ynjb4eJn+ElEx3NkVTg//m915/MV7a0YxJPHt9kobqOiKl22OfNkz8AWkewEa8wevLFp9hRFAVX/kFJ1yrHOBhV9UZyAJ8xiiosE6fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjyI3Ec6hBAgKPVbHgM1feHYm8VrJlo6KUshV39oG9A=;
 b=AQKZ/GhutXm4D/hO16w9XL1YAQYAO+YW/hp0+NBnYojjY3govnyKnPhg6mwFIxe5XooJ4nptv12A3+W19KMevBciEgize+fDXsb7HmYh0n37Y920C96u4Y4JSFvouTmgCp6BbokR53KqqU9RK8e244HExAUKt2cH5Cl52RtPEF30wW486Kj6OE6BhjM/kKE9J+l1658GyB8SJp86jWrkgR+F4z9n/AV/q3U/FXNeANyfkhDzzDukopdgVWAn4E8nf3oVVd3q87IQdstOKOMSXZLU3VCnZOKlcTZF4e/DngzXkf/3IDrfdCxdhZckyKlxwgMjkbGdnRcLncnS9Qm5rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjyI3Ec6hBAgKPVbHgM1feHYm8VrJlo6KUshV39oG9A=;
 b=frV4ec4VXT9yfd2RXAF+tSqbl2P8PngjwfMZ2c7SYD175Gm1ctDcSuYtnkEIv5us8vICMagEscnDqKmmCSKjuAFMuCtK0h4Hya7IfhDt3dHeiMgWPyZvIFYNe7z8rnt+bnzVWuoQyDQlurR391+Xnn5zD5GuSSsHEj+Nko6yyVA=
Received: from AM6PR04MB4725.eurprd04.prod.outlook.com (2603:10a6:20b:7::14)
 by DB9PR04MB9646.eurprd04.prod.outlook.com (2603:10a6:10:30a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.29; Sun, 30 Apr
 2023 18:54:08 +0000
Received: from AM6PR04MB4725.eurprd04.prod.outlook.com
 ([fe80::2d9e:92b4:e92e:9e5a]) by AM6PR04MB4725.eurprd04.prod.outlook.com
 ([fe80::2d9e:92b4:e92e:9e5a%6]) with mapi id 15.20.6340.028; Sun, 30 Apr 2023
 18:54:08 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC PATCH net 2/3] virtio-net: allow usage of vrings smaller
 than MAX_SKB_FRAGS + 2
Thread-Topic: [RFC PATCH net 2/3] virtio-net: allow usage of vrings smaller
 than MAX_SKB_FRAGS + 2
Thread-Index: AQHZe2XXxDQ9u/7pQUe+LxobnBX4G69D4sMAgABG2xQ=
Date:   Sun, 30 Apr 2023 18:54:08 +0000
Message-ID: <AM0PR04MB4723043772ACAF516D6BFA79D4699@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
 <20230430131518.2708471-3-alvaro.karsz@solid-run.com>
 <20230430093009-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230430093009-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR04MB4725:EE_|DB9PR04MB9646:EE_
x-ms-office365-filtering-correlation-id: 97e80c4e-fc15-4602-3163-08db49ac478a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xZ/Hy5ScHhnx7N/dk0+wfDW8pGo8zzzI+3RPnKtY7evb4h/yoEQjxyKzh7MjHT/g7j8+fWYeu4EKi/WMKJHHj965Afu84Qe2GMVmdKhc0wrMhjUYhb4KtjsH+YRFFQt0GONKeuc/XgRI0cO6nUWrFzPlzORjUL7IilnYi+6H2DnTIGCPtEVDYo8W4tI16yvEwXTcvyf0OuBTHKpsIWWFGCxE2481ee1j7EjcG3wpsjn/eoOIurERaChKjCaufBeT5xpEy8nm+8eWDNeIaZWDO0UKuglxtMgIhTy8Ef+VYQkCuQCuCGQXVdzeyvhyEhhaYBX11iAczJavq1UT78Or7NQa8it5r96Lew6TL7zDM4WFgi6fvz31nlz2zS/UsNn1uf9RQ4wgm9Fh8ZEDZEoYPEvQXvJwOZw9xXrzMhLTrgukpybQ9VOAr019wbSfBaXuK/05FO/pKVUqXeuJTh+cp55crBxZ2kyQAG1q+KR/XFXK3hvWsltdUtdYY+bx+qyXFfIFOvIL+WApuTJMy7oxbs4XjS5qkXRdqFBxSYDfWN+0csBUHm7G88d9xi8Nk10jVY/yDLIMrCg/jNENWLYVYcpiXkWZngGuN+HirCESbwU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4725.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(366004)(376002)(39840400004)(451199021)(54906003)(66899021)(71200400001)(478600001)(2906002)(52536014)(44832011)(5660300002)(7416002)(66446008)(316002)(64756008)(4326008)(91956017)(6916009)(66476007)(76116006)(66556008)(66946007)(8936002)(41300700001)(8676002)(86362001)(83380400001)(122000001)(38100700002)(38070700005)(33656002)(966005)(6486002)(186003)(6512007)(9686003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jY7R0o9QD+O2ILUVGWiUInIjmuqa8LzMdjuBuykthAGrWeexAMiP4Oa1rY?=
 =?iso-8859-1?Q?MQTXYDNwWqo/oJjHMR0f26zEJrwV00yTS8SGMsji+D4yCSurhLSTD1+ueW?=
 =?iso-8859-1?Q?qMCc0kNuFehMwqR01rPuDI+JgMH0HZTt2ZTrhoJ30z9oc4SyfKgFfaZ7UY?=
 =?iso-8859-1?Q?cqrP1+uZXb0g4S1qbD6JMS/jLxpvCAoX0TyvtOr3J5B9j2/vj6x6FDRQWY?=
 =?iso-8859-1?Q?cdkL4aeLKtFNWMIg3oghZk3pvY8FMMRkwiEiQBbXR4vd10fEWGE++wM1iG?=
 =?iso-8859-1?Q?SN9/yIJP3KvlXTvJ66MXKirZTSSQCYdBqvz5vGimBGLxrFjJS7Q+uASULx?=
 =?iso-8859-1?Q?ePSkc7gK58/XqCB+iwu7xCuLkp8l9E0YBpVABW0CKyp1LMtN7FGUQfkhjA?=
 =?iso-8859-1?Q?nnwllz+RSQ+f6MCngjZLjJsS9YFBO78IvOz6yPunGGK8dAwoaj3QoXGiNL?=
 =?iso-8859-1?Q?XPA+JEZhg71h/zUBBZ2XGxGJLA3Z22ylNGIglhNnAZoLCvnE7hCFtQZ5/I?=
 =?iso-8859-1?Q?zNFul/VIMmstzx9hzuezb6FWTGE0S9VgX7LoG/TncKMAYedgkyqU+E1wFp?=
 =?iso-8859-1?Q?XmKRLBTEc9KFyJt6qVrTolK+7IPOSIJZJbnKqAVc1upLZ1tzWRSPTHfQ0J?=
 =?iso-8859-1?Q?++aKfKiQ4Zzc91DzvuX2KttrJjxK8WKuHSeM872sKildnpSC7jGrgJuZgm?=
 =?iso-8859-1?Q?UuF4/bhzppw0QJ4TWQRXe1mokYsrCRiXaHvS8DMPWAYSLapJkQT9xVZORZ?=
 =?iso-8859-1?Q?g8vnBFkK7ISYrxDKCRXWpIuEBN9KuD7RV8IOO1J+5GlNLbUZzYKjNHaUTn?=
 =?iso-8859-1?Q?CkWyeSNJQJTeKWhjoOF/YoHCrgnizyLiC8/vRkpnxik2rNQbVuIWc67XPF?=
 =?iso-8859-1?Q?1afhjI1P1IhpyTxXjlv+628PMENIyISmgjFFAn8MqNLS0KFEhXBdMwRUHD?=
 =?iso-8859-1?Q?/XUvt+X8bQ0BWTVIExqr8TCyhyippTO5Lgt2AeMytezybKqrK8vHZO0XTG?=
 =?iso-8859-1?Q?40hk8eNlAtFEvnF/bMA92eJI+LZwfTAsJ0mSrejj/0DAYmJheAATZNjGQN?=
 =?iso-8859-1?Q?b6kwCSNPJ8lbq0itGXAqq9t+OGL5dlLsW+MZ3j8hluFIwSk7GdYWrdxQxo?=
 =?iso-8859-1?Q?9caqFBPnWdQLM0S+U3nK6sAHv8IG0tJO4ckG4FZZ1rhxuDVb5PQt3AIIe+?=
 =?iso-8859-1?Q?IaelfX0JgPcDOjDObm9GhRQ9SdS8AkK/+BbrVzcyJPH+pLcpsY+YhG83bN?=
 =?iso-8859-1?Q?FIBvjJCPOKFHJWHayCzGwhAQQEM1B+0ca5EEVdfrsGTDVJawzrfoA0mu0g?=
 =?iso-8859-1?Q?WvP77+XzKb2TDQGYOtXu2jfJdTQmnKYCNhk/wB1H7w3drGAhOHJpEtgxax?=
 =?iso-8859-1?Q?dGqsBUutR7znH5GCEQmEado492bup19OaIcQLSE0kNLKtTUUbZElgOstGF?=
 =?iso-8859-1?Q?QVSJRaFDJ16t2aHzflqX3C9tq3Sa/Iz9ylzZjOak6DXmYkTyxz6JjiE5YV?=
 =?iso-8859-1?Q?l96Iexkc+MaVXAO0PVrilNCuNKxOuBpBi9Ptf9Vi12oohTQ0hBOzWGI+bH?=
 =?iso-8859-1?Q?ehGTCCUxEgn4ymhJ1SdwWGbssCgao3AbP7id3KyA61Gmw0lTyE/y1/FAva?=
 =?iso-8859-1?Q?bX3OEFUP6eL6NYqH7ldU2ldCfvbsVzk3w2PkawTaiVvZNS8t2IRdbZAhKm?=
 =?iso-8859-1?Q?lC+YJhf+nk2TqIqslhlYF3On1pljTw1AmmFTKeKFyUR0wZ/XuH1SpKxhEM?=
 =?iso-8859-1?Q?OpZg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4725.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e80c4e-fc15-4602-3163-08db49ac478a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2023 18:54:08.5882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OH3SK30hSfxU0QCb/XBaKpdB4I+lyqeHIUSUpMUeCoVuqyi8a5mci5zv48rOjeyWNxO6h5i5AwiX/vS53jKyx8FIkACfKUGfLf2hQp43y3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9646
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > At the moment, if a network device uses vrings with less than=0A=
> > MAX_SKB_FRAGS + 2 entries, the device won't be functional.=0A=
> >=0A=
> > The following condition vq->num_free >=3D 2 + MAX_SKB_FRAGS will always=
=0A=
> > evaluate to false, leading to TX timeouts.=0A=
> >=0A=
> > This patch introduces a new variable, single_pkt_max_descs, that holds=
=0A=
> > the max number of descriptors we may need to handle a single packet.=0A=
> >=0A=
> > This patch also detects the small vring during probe, blocks some=0A=
> > features that can't be used with small vrings, and fails probe,=0A=
> > leading to a reset and features re-negotiation.=0A=
> >=0A=
> > Features that can't be used with small vrings:=0A=
> > GRO features (VIRTIO_NET_F_GUEST_*):=0A=
> > When we use small vrings, we may not have enough entries in the ring to=
=0A=
> > chain page size buffers and form a 64K buffer.=0A=
> > So we may need to allocate 64k of continuous memory, which may be too=
=0A=
> > much when the system is stressed.=0A=
> >=0A=
> > This patch also fixes the MTU size in small vring cases to be up to the=
=0A=
> > default one, 1500B.=0A=
> =0A=
> and then it should clear VIRTIO_NET_F_MTU?=0A=
> =0A=
=0A=
Following [1], I was thinking to accept the feature and a let the device fi=
gure out that it can't transmit a big packet, since the RX buffers are not =
big enough (without VIRTIO_NET_F_MRG_RXBUF).=0A=
But, I think that we may need to block the MTU feature after all.=0A=
Quoting the spec:=0A=
=0A=
A driver SHOULD negotiate VIRTIO_NET_F_MTU if the device offers it.=0A=
If the driver negotiates VIRTIO_NET_F_MTU, it MUST supply enough receive bu=
ffers to receive at least one receive packet of size mtu (plus low level et=
hernet header length) with gso_type NONE or ECN.=0A=
=0A=
So, if VIRTIO_NET_F_MTU is negotiated, we MUST supply enough receive buffer=
s.=0A=
So I think that blocking VIRTIO_NET_F_MTU  should be the way to go, If mtu =
> 1500.=0A=
=0A=
[1] https://lore.kernel.org/lkml/20230417031052-mutt-send-email-mst@kernel.=
org/=0A=
=0A=
> > +     /* How many ring descriptors we may need to transmit a single pac=
ket */=0A=
> > +     u16 single_pkt_max_descs;=0A=
> > +=0A=
> > +     /* Do we have virtqueues with small vrings? */=0A=
> > +     bool svring;=0A=
> > +=0A=
> >       /* CPU hotplug instances for online & dead */=0A=
> >       struct hlist_node node;=0A=
> >       struct hlist_node node_dead;=0A=
> =0A=
> worth checking that all these layout changes don't push useful things to=
=0A=
> a different cache line. can you add that analysis?=0A=
> =0A=
=0A=
Good point.=0A=
I think that we can just move these to the bottom of the struct.=0A=
=0A=
> =0A=
> I see confusiong here wrt whether some rings are "small"? all of them?=0A=
> some rx rings? some tx rings? names should make it clear.=0A=
=0A=
The small vring is a device attribute, not a vq attribute. It blocks featur=
es, which affects the entire device.=0A=
Maybe we can call it "small vring mode".=0A=
=0A=
> also do we really need bool svring? can't we just check single_pkt_max_de=
scs=0A=
> all the time?=0A=
> =0A=
=0A=
We can work without the bool, we could always check if single_pkt_max_descs=
 !=3D MAX_SKB_FRAGS + 2.=0A=
It doesn't really matter to me, I was thinking it may be more readable this=
 way.=0A=
=0A=
> > +static bool virtnet_uses_svring(struct virtnet_info *vi)=0A=
> > +{=0A=
> > +     u32 i;=0A=
> > +=0A=
> > +     /* If a transmit/receive virtqueue is small,=0A=
> > +      * we cannot handle fragmented packets.=0A=
> > +      */=0A=
> > +     for (i =3D 0; i < vi->max_queue_pairs; i++) {=0A=
> > +             if (IS_SMALL_VRING(virtqueue_get_vring_size(vi->sq[i].vq)=
) ||=0A=
> > +                 IS_SMALL_VRING(virtqueue_get_vring_size(vi->rq[i].vq)=
))=0A=
> > +                     return true;=0A=
> > +     }=0A=
> > +=0A=
> > +     return false;=0A=
> > +}=0A=
> =0A=
> I see even if only some rings are too small we force everything to use=0A=
> small ones. Wouldn't it be better to just disable small ones in this=0A=
> case? That would not need a reset.=0A=
> =0A=
=0A=
I'm not sure. It may complicate things.=0A=
=0A=
What if all TX vqs are small?=0A=
What if all RX vqs are small?=0A=
What if we end up with an unbalanced number of TX vqs and RX vqs? is this a=
llowed by the spec?=0A=
What if we end up disabling the RX default vq (receiveq1)?=0A=
=0A=
I guess we could do it, after checking some conditions.=0A=
Maybe we can do it in a follow up patch?=0A=
Do you think it's important for it to be included since day 1?=0A=
=0A=
I think that the question is: what's more important, to use all the vqs whi=
le blocking some features, or to use part of the vqs without blocking featu=
res?=0A=
=0A=
> > +=0A=
> > +/* Function returns the number of features it blocked */=0A=
> =0A=
> We don't need the # though. Make it bool?=0A=
> =0A=
=0A=
Sure.=0A=
