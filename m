Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825315E5F53
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiIVKFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiIVKFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:05:04 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23575A884
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 03:04:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyS++kJDUvXkufTRFbeZtqIh9uFE6iGeUNIki4Wl+AnjiCmnGZfbwJqMjnZ9I2R+b51ELKbYP8v4Mk+7wspUPiU+++xEdxUkg3ZjWzpCJotTZ29s81V79P0i0KfvocB7b8KWdEOD5VdFnJrgrE+LBBnm/ZkKB3nDnoophRVj5w8SiIKvE1rqJ4Jru5nrYdWG5GribqZLVBxLgsp8RGFHuUxmH4OIto2zz4qpX1jBcDvOflTTBQXsV9FO0j9SaDwPCmHVMn0KiAq8e0JTQmVlbWOnYDkMXJkzFYrKai7LaApAqLbbLnB2qiFh1gkztWlgVM90sFVPk3sjviyOZH/NGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+HxvLxaXIsdngJdvQ3V4S7TUR08l/EV8eBeRQL4JiY=;
 b=C4ODhxNYz1evDIqLjn04G514jP7Vlmlq6oAQQ9f8T9Q4VBOD3NfDZP1x3oLkn0yCwZiKYQtMfLKRccyNM2NX4wU7Drn+eNd+d4ADEst5IOlZWVRYFUjvFn5VMbHWoLhsKLRKL5kaOEUpitPI7Roak5Bp2oqPQ08wcLE3WB+NRDTvfSXeRsRiNWgDHkqBREx4oR/fKUzsDNHiKhYOnMPhxYEHs6ONLF4vrQyLD9M3vZGljQQf3zJjJqWGpKXPMzeNHJ3aBjk5c6XV6c/x92zk7Snckm4F9FgxwZbRBBnNoZUK5XwQ+BrDY0RqcvZ8YiJ2GhQRcIc1Rjxa0ZNsISVHdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+HxvLxaXIsdngJdvQ3V4S7TUR08l/EV8eBeRQL4JiY=;
 b=mQwK+P1VdC9kJYjWDsUXOh4dt3YRvqKyE2jRaXmbeFlxXdk8UX3qMDxtO01OpFNlVHnGAurjXgmulwQ/N/z5S2hXH2ALBmFXgjHthMtBU6Kq4+Az7FcoW6UcbXUQkGwDZddZWCDCs/X+AOgHCtfd0RdGSRtDDZNFz+fxBMTJFGQfvcYhg7zaf29V4H8wWBgVMFCWhNCDUZajQCNvPgfIC+mvwYs47fCZwaGiQV3SFAFB55o7iC4eeJ8j8QEYj7m06bS5Ug0KqBmHd1/85nr3s3EYwxwtj8SEmJ7fwebTE7AQnwjiF3nsEiKhIovx5PWmbihbSYHZYawOlCP3Up916g==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by IA1PR12MB6233.namprd12.prod.outlook.com (2603:10b6:208:3e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:04:53 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%9]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 10:04:53 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, Gavin Li <gavinl@nvidia.com>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: RE: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Topic: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Index: AQHYvagejmrtcrshK0GYXpgvFbRGE63rUekAgAAHfNA=
Date:   Thu, 22 Sep 2022 10:04:53 +0000
Message-ID: <PH0PR12MB5481374E6A14EFC39533F9A8DC4E9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
 <20220922052734-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220922052734-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|IA1PR12MB6233:EE_
x-ms-office365-filtering-correlation-id: 8d5da219-6317-41c1-1206-08da9c81e544
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: osFohmmE25k249Hb23iagB5n4G8IVf4QvuMlRHJGe59ljZGZ1VQsf7gciUkybFJCMdZeFg0+Yy1yv03PvKO2JaBmirFrCReg+fuvvGknYMFHv0Og/LjkzVW6C9mhune719wPQ5hUAIrKxSxFc0JKs707D919Txv1G86qq7k2BcZ7LfK07vSzrk4EEVRBlqYfB0aozisMTEwY9HF8UkB/sJ+V/Gj/75y95nREYPMsXiQoPVCRenlYTtI4xgC87nCHhEUjFU+MLe18QGzaqyplOkPGmaj+4zQv7Qjgkd7MfBT9F5K0TIHX4pJaUiMysm5YB48ty9ROrll+ABhyKsg/fbJk2GZiNgZ/82ywswd/w5ZnJftjg7cWT0Yn0HwTzd7/VqPtC7e3oQm76Hd12fom1ORL3rJyfq7I/36KK9u8CQUlScRP/tZfYtJKAxVwhFYIDXb/kwRBQezF5EEDIZCv7CPOZWsXG2/9OQIobPojkPDx3YWwdTojUWVjIs2NtoFQzcQHC/PQwZeEZUZiyLSqCCsTRUTjxs6cYFkPPAJPtKjrkD9LjZnC0E6VdnCiZx0/DarEZ96TUCiyqQxFHbDDQTuku0JUj9d39NE6lWirEIMsC/JKKtBirimJPo9RiHE/DwyTzhNrPUtM7aV8pj4K0iCraa127gzcK4oWQKnqOfEI2tPQjW1bZUeceREMF+ZhtfGGAltFQ9w7G++8U4vpTwNrjFCXMD6zdpdjPnOqp9kEb3mffAYDKWEqM+oWgNkiy8EFZHGiqbyTjpPOFSSsVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(451199015)(316002)(9686003)(7696005)(6636002)(33656002)(478600001)(6506007)(110136005)(71200400001)(122000001)(54906003)(38100700002)(38070700005)(83380400001)(186003)(55016003)(76116006)(86362001)(2906002)(4326008)(64756008)(8676002)(66446008)(8936002)(5660300002)(52536014)(7416002)(41300700001)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XtXX8PYkScMoeSYoOwwv7SlWT2G32IrzGlMUyPsclFLUnOsu9iRZxqmcr6bn?=
 =?us-ascii?Q?FDWC/+9aXXeFUqZlSRjcwJ6+OC+d+eR4Y7I7vI9XYiS647KPigv+wbtLipTf?=
 =?us-ascii?Q?2ZHQy8zo+BBKYPnZO6Oi0hI5LGSAAdhvk46SdQ4qObvcH37Yw6NICJh6A1Cg?=
 =?us-ascii?Q?rPAFyP4jTIL0ZazyhvdxmgnZzi4lWOXgAb8ndtxaAZynNtPcVw1IqKsklysa?=
 =?us-ascii?Q?aejF29NqxkV8zy4GPPkKm7Ibiv8PrazohBkRuwzLO3rWs+2m2LIBiNfWLwwF?=
 =?us-ascii?Q?KQdpQHZaGk+c3pl7gvROk4XDjJKKQpQfLr4l3iVaJBS5DvkKNCME1VqlvsId?=
 =?us-ascii?Q?zempxdNmVqXvb9qmeYkvQic2r4yzDKgvfDh4zbAf3zMHgxjBiDfJO7J8Xv4O?=
 =?us-ascii?Q?UstfcWH+mm18N3aZtv3m4zcDRPyYQ5URYC2CChbz+W0FYF5izXjqGd1vg324?=
 =?us-ascii?Q?uWAzwICF7MStgHNJgcIPwuF5SSd76oJtvGAGg1kqh7gSY0TUnNMYSa+V1YJJ?=
 =?us-ascii?Q?1tZMrQiQcRu+if20VWqlI5ZnTpYsaucF/q2S6n5PIU8yNqXWOVg5kkWHjlOz?=
 =?us-ascii?Q?+xFLF8nSl2r73PYnrusOXhn5jtMFZfD6rLMr2kKHsOabrFVZ4AE9xEjpGFtF?=
 =?us-ascii?Q?WGEZlAg2CJYpOSeM4rn9D4WU6HlQizhdaZzR/IVkID+atPaM6qyYWuED9Mv2?=
 =?us-ascii?Q?4n9pSM0Nt3qTsee64B1s09KsaxcgIcyA7NAGiff3Dwww4atfDORlmWSSOxab?=
 =?us-ascii?Q?5j8sAJ34u1Q3u2mVaxwU1vaK1YfFGFb7KyTqwaZtRyLo5hHYeBd77DSedRDU?=
 =?us-ascii?Q?LngCyIgxx/jO8706pqB6nh92/0XMRQ+uf2VXM/20I/29zdhSPuUEcIaZQ7nd?=
 =?us-ascii?Q?MpfbC5xlBjS7d26wwsz2yCabOxU5o9K8FGOo/OOe1tkzNO+TtDJR2joMSiyy?=
 =?us-ascii?Q?Qf2nJerdeZGQa++Ysk5OBSUxw4GA+RMhBwGq8wk/puX1H0IOd63Ol1bopO36?=
 =?us-ascii?Q?ghFe5qjVJAElcsPanpPw7XYNlydJoqfqnCW+5bfiKf+rhzoZBv+tGdri3G4Z?=
 =?us-ascii?Q?WYWJpO4TaRmPsUmVn5a7CCzqY1bhQdfmvMVG0hTTf1p2FtclbcA+fMEq8Aij?=
 =?us-ascii?Q?Qwdc/9++7if0TFsHeVm1PqD+FuKUIB0B9wFoEYJxl4tiiURXz5sh01VCnQPI?=
 =?us-ascii?Q?P/racZjt+OVAKz7KhVf/EM6JeQ4he/3lLTkNhf5Rn7IXYw0x+QFXwaz+2PTR?=
 =?us-ascii?Q?R7EuSraBYLlL9QhyM5c/GIDUuVTdS26xmEge/rTcwjJg7TJJ+8mMAHYZaSwt?=
 =?us-ascii?Q?xiFNLVt0DOfjwHGPOIoGT1KGnlOk3XZaC4EB8EYrObY7bGsLE1CJnY9WM6tK?=
 =?us-ascii?Q?y/zE35PR6hI1vnTLXJAEsLA1bX204VQscE8SFcL+Zwfzi7IkyZq1dKr13O7Q?=
 =?us-ascii?Q?TeDoPd+UmujylXKPtPbMb/zOlOw9ASou/nLV6TCOgI99F5kCNb3/dxNmfRQK?=
 =?us-ascii?Q?Xx05ME8l6v3IJa/wuJQNDSIXjaKmi2unsYOBVFdQvsaeT3DeoxW7rXBpWyaG?=
 =?us-ascii?Q?c2ylXV8MjWlNogLVbiZxUrznQt6gIRJ+eXHUPRNadrEXEysHH0SlijGT9PY+?=
 =?us-ascii?Q?KmbI+1Xi0lIRSpJn4YfDd/o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5da219-6317-41c1-1206-08da9c81e544
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 10:04:53.7035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 987HqWyq52EiENp1LlAgedJzisEqeHsk9/QamXPR0VaVU1hSKrjOj/hl1/Dix3jQu+VCf5OBAZWb3jbKlrXt4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6233
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Thursday, September 22, 2022 5:35 AM
>=20
> On Thu, Sep 01, 2022 at 05:10:38AM +0300, Gavin Li wrote:
> > Currently add_recvbuf_big() allocates MAX_SKB_FRAGS segments for big
> > packets even when GUEST_* offloads are not present on the device.
> > However, if guest GSO is not supported, it would be sufficient to
> > allocate segments to cover just up the MTU size and no further.
> > Allocating the maximum amount of segments results in a large waste of
> > buffer space in the queue, which limits the number of packets that can
> > be buffered and can result in reduced performance.
> >
> > Therefore, if guest GSO is not supported, use the MTU to calculate the
> > optimal amount of segments required.
> >
> > When guest offload is enabled at runtime, RQ already has packets of
> > bytes less than 64K. So when packet of 64KB arrives, all the packets
> > of such size will be dropped. and RQ is now not usable.
> >
> > So this means that during set_guest_offloads() phase, RQs have to be
> > destroyed and recreated, which requires almost driver reload.
> >
> > If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS has been negotiated, then it
> > should always treat them as GSO enabled.
> >
> > Accordingly, for now the assumption is that if guest GSO has been
> > negotiated then it has been enabled, even if it's actually been
> > disabled at runtime through VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> >
> > Below is the iperf TCP test results over a Mellanox NIC, using vDPA
> > for
> > 1 VQ, queue size 1024, before and after the change, with the iperf
> > server running over the virtio-net interface.
> >
> > MTU(Bytes)/Bandwidth (Gbit/s)
> >              Before   After
> >   1500        22.5     22.4
> >   9000        12.8     25.9
> >
> > Signed-off-by: Gavin Li <gavinl@nvidia.com>
> > Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> > Reviewed-by: Parav Pandit <parav@nvidia.com>
> > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
>=20
> OK I think the logic is correct, it's just a bit harder to read than nece=
ssary.
> Small improvement suggestions:
>=20
>=20
> > ---
> > changelog:
> > v4->v5
> > - Addressed comments from Michael S. Tsirkin
> > - Improve commit message
> > v3->v4
> > - Addressed comments from Si-Wei
> > - Rename big_packets_sg_num with big_packets_num_skbfrags
> > v2->v3
> > - Addressed comments from Si-Wei
> > - Simplify the condition check to enable the optimization
> > v1->v2
> > - Addressed comments from Jason, Michael, Si-Wei.
> > - Remove the flag of guest GSO support, set sg_num for big packets and
> >   use it directly
> > - Recalculate sg_num for big packets in virtnet_set_guest_offloads
> > - Replace the round up algorithm with DIV_ROUND_UP
> > ---
> >  drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++-------------
> >  1 file changed, 24 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c index
> > f831a0290998..dbffd5f56fb8 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -225,6 +225,9 @@ struct virtnet_info {
> >  	/* I like... big packets and I cannot lie! */
> >  	bool big_packets;
> >
> > +	/* number of sg entries allocated for big packets */
> > +	unsigned int big_packets_num_skbfrags;
> > +
> >  	/* Host will merge rx buffers for big packets (shake it! shake it!) *=
/
> >  	bool mergeable_rx_bufs;
> >
>=20
> big_packets_num_skbfrags -> big_packet_num_skbfrags
>=20
> > @@ -1331,10 +1334,10 @@ static int add_recvbuf_big(struct virtnet_info
> *vi, struct receive_queue *rq,
> >  	char *p;
> >  	int i, err, offset;
> >
> > -	sg_init_table(rq->sg, MAX_SKB_FRAGS + 2);
> > +	sg_init_table(rq->sg, vi->big_packets_num_skbfrags + 2);
> >
> > -	/* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
> > -	for (i =3D MAX_SKB_FRAGS + 1; i > 1; --i) {
> > +	/* page in rq->sg[vi->big_packets_num_skbfrags + 1] is list tail */
> > +	for (i =3D vi->big_packets_num_skbfrags + 1; i > 1; --i) {
> >  		first =3D get_a_page(rq, gfp);
> >  		if (!first) {
> >  			if (list)
> > @@ -1365,7 +1368,7 @@ static int add_recvbuf_big(struct virtnet_info
> > *vi, struct receive_queue *rq,
> >
> >  	/* chain first in list head */
> >  	first->private =3D (unsigned long)list;
> > -	err =3D virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
> > +	err =3D virtqueue_add_inbuf(rq->vq, rq->sg,
> > +vi->big_packets_num_skbfrags + 2,
> >  				  first, gfp);
> >  	if (err < 0)
> >  		give_pages(rq, first);
> > @@ -3690,13 +3693,27 @@ static bool virtnet_check_guest_gso(const
> struct virtnet_info *vi)
> >  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);  }
> >
> > +static void virtnet_set_big_packets_fields(struct virtnet_info *vi,
> > +const int mtu) {
> > +	bool guest_gso =3D virtnet_check_guest_gso(vi);
> > +
> > +	/* If device can receive ANY guest GSO packets, regardless of mtu,
> > +	 * allocate packets of maximum size, otherwise limit it to only
> > +	 * mtu size worth only.
> > +	 */
> > +	if (mtu > ETH_DATA_LEN || guest_gso) {
> > +		vi->big_packets =3D true;
> > +		vi->big_packets_num_skbfrags =3D guest_gso ?
> MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
> > +	}
> > +}
> > +
> >  static int virtnet_probe(struct virtio_device *vdev)  {
> >  	int i, err =3D -ENOMEM;
> >  	struct net_device *dev;
> >  	struct virtnet_info *vi;
> >  	u16 max_queue_pairs;
> > -	int mtu;
> > +	int mtu =3D 0;
> >
>=20
> I think it's better to drop this and instead just put the code
> where we already know the config. So:
>=20
> >  	/* Find if host supports multiqueue/rss virtio_net device */
> >  	max_queue_pairs =3D 1;
> > @@ -3784,10 +3801,6 @@ static int virtnet_probe(struct virtio_device
> *vdev)
> >  	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> >  	spin_lock_init(&vi->refill_lock);
> >
> > -	/* If we can receive ANY GSO packets, we must allocate large ones.
> */
> > -	if (virtnet_check_guest_gso(vi))
> > -		vi->big_packets =3D true;
> > -
> >  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> >  		vi->mergeable_rx_bufs =3D true;
> >
> > @@ -3853,12 +3866,10 @@ static int virtnet_probe(struct virtio_device
> *vdev)
> >
> >  		dev->mtu =3D mtu;
> >  		dev->max_mtu =3D mtu;
> > -
> > -		/* TODO: size buffers correctly in this case. */
> > -		if (dev->mtu > ETH_DATA_LEN)
> > -			vi->big_packets =3D true;
>=20
>     /* Size buffers to fit mtu. */
>     if (mtu > ETH_DATA_LEN) {
>                     vi->big_packets =3D true;
>                     vi->big_packets_num_skbfrags =3D DIV_ROUND_UP(mtu,
> PAGE_SIZE);
>     }
>=20
How doing things twice is better i.e. when mtu is > ETH_DATA_LEN and gso is=
 offered?
It calculates big_packets variable twice.

It also easier to read the code at single place where big_packets decision =
is taken.

> >  	}
> >
> > +	virtnet_set_big_packets_fields(vi, mtu);
> > +
>=20
> and here:
>         /* If device can receive guest GSO packets, allocate buffers for
>          * packets of maximum size, regardless of mtu.
> 	 */
>=20
> 	if (virtnet_check_guest_gso(vi)) {
> 		vi->big_packets =3D true;
> 		vi->big_packets_num_skbfrags =3D MAX_SKB_FRAGS;
>         }
>=20
>=20
> >  	if (vi->any_header_sg)
> >  		dev->needed_headroom =3D vi->hdr_len;
> >
> > --
> > 2.31.1

