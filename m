Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7634EF19
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhC3RMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:12:12 -0400
Received: from mail-mw2nam12on2114.outbound.protection.outlook.com ([40.107.244.114]:47393
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232556AbhC3RLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:11:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZy2DG4PE/skgaLGef7zUEsUaAY4v4wJpia2EFCeR/QrbwIMSwydVQaVNrKAuz+aO/kUhWVTa/CL78g1k5+6yWNb5tviaA5tRCJJYgn/P6vEDAcKG9aHnrZba9/r2wdX62hHsFbsQAc8UcluZRZjxl7APbc2nBkE/hgHfXbI2uyQwmdhZ6ZBAyX00djAuQXR6NLHmdoigQICQUXHBQj9yF/265NALMgSBwdTK/ekfbRni/bC7RdlN0dpKp24f6DAScCB6LId21FrqqbpcvqTlivaxCrjMkymnal9w2wRYSRKCdrtrH0bcrp0qng6xp5Uej+45b8BctRcnf2P+2pBMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsnLfw9c8kCXOw0kKrYRcWuMWYqJUdibm8x9i7SqkwY=;
 b=cv69adAvW1tO3f/zG/AEE3bc2pplSAmp5cCeNeLoKM7WKs6M5U6zDf3s91xK+Wl/nRyJFoMH959D8ZY3SnwFVD1xgQ+bK55Uxc8EkCH7ZHtSHPQuv1HqJT8KqFnTyJR/cJcz6cBcvKGiVE52w3yLmXgoYOQbqT44gwjR3z0b+HojI6A/yqzRP7kvkiou7bCIyHUYBu82nu52ngTS+kqUVuxftg2pcBHT9iZguAFHzmyn5PGsXM39QKpjQhwwRzX+vAHzO+8f22ZtAq+8mszlxU9wb4mW7KQCfAIIatSIuEHT+XGa/jRLn7H9GgAvACE97LNgG5nrcOrjjyxTKIe3lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsnLfw9c8kCXOw0kKrYRcWuMWYqJUdibm8x9i7SqkwY=;
 b=fc/wsZqlvuS7yCz320r0zumb2VdvlfViMhKO+SJ7rfKjlYJeWexti+61Mxv8zfOJ2xHpaHztuF4AZ6ET47jFZwuedN187NtzKpgO4Se2aojNKxUi4LNDq7bjCFEnbMqFipIvw6Z68djKYth15HoVaikQPK6+fu2gQ9X1fVPYPYM=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by MN2PR21MB1502.namprd21.prod.outlook.com
 (2603:10b6:208:20b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.1; Tue, 30 Mar
 2021 17:11:37 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::6924:5b07:7e08:93c4]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::6924:5b07:7e08:93c4%6]) with mapi id 15.20.3999.019; Tue, 30 Mar 2021
 17:11:37 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     vkuznets <vkuznets@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] hv_netvsc: Add error handling while switching
 data path
Thread-Topic: [PATCH net-next] hv_netvsc: Add error handling while switching
 data path
Thread-Index: AQHXJPJjFBAMivnBdUuSFTqYBa3+baqcadGAgABbgiA=
Date:   Tue, 30 Mar 2021 17:11:36 +0000
Message-ID: <BL0PR2101MB093063137127B0268C285456CA7D9@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <1617060095-31582-1-git-send-email-haiyangz@microsoft.com>
 <87lfa4uasy.fsf@vitty.brq.redhat.com>
In-Reply-To: <87lfa4uasy.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7beb0274-fd66-4b6f-bace-cdb335fa096f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-03-30T17:10:39Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a6358e8-390a-4d23-922b-08d8f39ee09a
x-ms-traffictypediagnostic: MN2PR21MB1502:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1502EB71CF8CF096B63A136ECA7D9@MN2PR21MB1502.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IZwVnQtGQDoLLhIQbsvOH/MtFARbURp+MWvGvYyFt0C5cNXXVjmydcXS+Pquqo6GjszLtO5/B+OkXdvR/uXpfTfhv7Cymb3BP9xxOLW7TvawK5TzLm7oTmHxjQduYln628ylne3DgsOK5EqGeg74QcrzWGrdX8TcCFylVn6AEOA+MxdL7NJEFBeb8isbK78Pfnvga3eg46u+dktMOcPZNNa1KySSFAnicOzdd3lEbD/k4vVuN1ijyoy59sUM/NVmPKeJ14O51wP6d2xv1HdIhsMqF9oN30u6rpeXpdFnTaQ98zFHdDer71D1vpLjsdj9ay+oFE+Chu/6UAR+0yJ1B6LeNmE9F9Xo+wJA6AVeIO4RWM7AYtxzRK7+9w4mxR/nb2PEnNtjrkuBs4ojNcydd6DEWMI77ybBSH0Ily+NNpaSaMlPu9Pog6igoCeKD+TQXn7ufavbCdH5eNrVCatQ5klULSqqMRKqRCQsn9evZLvEowZ39L1Qj8L3KKSg3x03ktg+RJM5afSj6smgbwDMfyzSz0gzLsfjjISPUNuOQzRuEHO+vMm6rTrO+8Rhx7Em643WlxAiIPmwzH4Fc+S4KS/tUiYXmnB2QPeVs662YTYvgX8HTGRSivayoECYllkWISEIZTZpbxm1/+fBogQ6o3tXuMRdY1KcHcJ88aX0a7s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(9686003)(186003)(76116006)(7696005)(53546011)(8936002)(316002)(6506007)(4326008)(38100700001)(5660300002)(83380400001)(86362001)(52536014)(33656002)(26005)(71200400001)(2906002)(66946007)(66446008)(10290500003)(66556008)(66476007)(54906003)(64756008)(110136005)(478600001)(55016002)(82960400001)(8676002)(8990500004)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?osOTpx28zHfRve7zQLyif146QJIK0S/9l/a2wl+nCSAt8zIn4A+M0aodyIU+?=
 =?us-ascii?Q?fsoBLJGqXkR0AX98Ny87D3Bagg1KqJtXpLUtGhtuoGdTzTtEfDy+e5qmnCA4?=
 =?us-ascii?Q?fTIC91zdTBw/4gk/e9ZkLV3TzCLPqiBv9poU/WbpWrlYtRoiwr2jNMHEYjgg?=
 =?us-ascii?Q?V7K6/+Hac+Ozx8MvHh0jcYn3uTEpi93v1sd5yoxGM+QBxUW5atcOmDE6V5hc?=
 =?us-ascii?Q?+tSVO74xkqM9LrINimCOgUnXqfihSncu0QIuYhueImOJPUE5QeuNjgQDw3hP?=
 =?us-ascii?Q?024Qw20IOlD23b15X4KyO1/WUuNOzPN7BqsRFDdWUDZvvqPcyGziMfEPnza8?=
 =?us-ascii?Q?75YOc4Q5m4kcggMXPgUBxawW8BqDIwZACMLnVgfmH6Rrzi6aV/v23cxibdq/?=
 =?us-ascii?Q?F+xOKSfwP9D4naz1bCSW+unfg5MVZEEjlID6l0R6amFN4l0BZdEu3LVNVcxi?=
 =?us-ascii?Q?uKcjFiBUc6Q7j9Ge1poByKIf4AX5DDhHM10HKdp+obrMQ0Gxwzc/awjBdIxs?=
 =?us-ascii?Q?aSjiuKov8uWgDSyF+D6o3W/SxkUBoHn7tiTgC9R0uHo7IMEhBTxJDZMWXBA5?=
 =?us-ascii?Q?zHGhXjUZjKezj36n5HZJhKe44koRw9JtsWlVm/eJooN3SzqQ8NRsQnwX5F6S?=
 =?us-ascii?Q?mzA1nXeo+GMo4mFq/0Sy3lxydn35IbCvt8l2mc4U25HEwc2pJHjchz7FT8fB?=
 =?us-ascii?Q?KZsWFWABXUg2YaVIuAfg1P+wSKj2kJWLFL0rPXW32JlrQx2X/Fuk5NkYV+Vg?=
 =?us-ascii?Q?dHXqUH4WntsR48p8szQwFsw4kvbJ+jrE2si7E8yw8gp+4F5JocRfckOsowqP?=
 =?us-ascii?Q?TX7rWphMSprQdfKC8YqQ/HQHOlnua7d6/aZUNPiBJK4mKMfMmv9M5gx5I1Rb?=
 =?us-ascii?Q?RDh18rMtRWcmqRZavcTP/m35Ke3+tDkFODwrIvLAEXS3cajPe4u+L+hYHtuM?=
 =?us-ascii?Q?Vw5PgyejTgb6I7TmlNsF6LEXNgeMU2mH0C230IBAEce5iJ18CEo9tJlgzwfg?=
 =?us-ascii?Q?dVEk7d+uR87cLPooD9F9kjWdXlqfkYfrtY645CcjzyTULLJBE2LPBevXxAhk?=
 =?us-ascii?Q?7hoYAtC1JPS73mLjvBvN2CDQjuQW7uTrMO2CV1O80q5x7KNewf8zB/51/I5h?=
 =?us-ascii?Q?cnDAzs8T3mrBM/scQtLS20ky6FDEhHA4IbuR3AQ/MQQdyKDRGhNNPaeSuUe5?=
 =?us-ascii?Q?aQjiLtTvSySShWtDfzPoeu+duN72Dlr60XTwcb31zVW70RK2zE6L/cifMUkW?=
 =?us-ascii?Q?M7aDnE2wKi71/3/EirFUyQ+howHzSUq4aQUvkTYVg597x2eSEDMWiVhhb5En?=
 =?us-ascii?Q?kohiQW1emi3ZbmgCbXjmcARd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6358e8-390a-4d23-922b-08d8f39ee09a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 17:11:36.9537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6IIwgZ5+p4UI8bt+HiKV6yzMsVc5NY99wmdLg8Gu5gzlQJrxTU8Q6GanPR4VbwiiwtrwnCpIKt99/tcrG5eXIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Sent: Tuesday, March 30, 2021 7:43 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; KY Srinivasan
> <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> olaf@aepfle.de; davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] hv_netvsc: Add error handling while switchi=
ng
> data path
>=20
> Haiyang Zhang <haiyangz@microsoft.com> writes:
>=20
> > Add error handling in case of failure to send switching data path messa=
ge
> > to the host.
> >
> > Reported-by: Shachar Raindel <shacharr@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> >
> > ---
> >  drivers/net/hyperv/hyperv_net.h |  6 +++++-
> >  drivers/net/hyperv/netvsc.c     | 35 +++++++++++++++++++++++++++++-
> ---
> >  drivers/net/hyperv/netvsc_drv.c | 18 +++++++++++------
> >  3 files changed, 48 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/hyperv_net.h
> b/drivers/net/hyperv/hyperv_net.h
> > index 59ac04a610ad..442c520ab8f3 100644
> > --- a/drivers/net/hyperv/hyperv_net.h
> > +++ b/drivers/net/hyperv/hyperv_net.h
> > @@ -269,7 +269,7 @@ int rndis_filter_receive(struct net_device *ndev,
> >  int rndis_filter_set_device_mac(struct netvsc_device *ndev,
> >  				const char *mac);
> >
> > -void netvsc_switch_datapath(struct net_device *nv_dev, bool vf);
> > +int netvsc_switch_datapath(struct net_device *nv_dev, bool vf);
> >
> >  #define NVSP_INVALID_PROTOCOL_VERSION	((u32)0xFFFFFFFF)
> >
> > @@ -1718,4 +1718,8 @@ struct rndis_message {
> >  #define TRANSPORT_INFO_IPV6_TCP 0x10
> >  #define TRANSPORT_INFO_IPV6_UDP 0x20
> >
> > +#define RETRY_US_LO	5000
> > +#define RETRY_US_HI	10000
> > +#define RETRY_MAX	2000	/* >10 sec */
> > +
> >  #endif /* _HYPERV_NET_H */
> > diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> > index 5bce24731502..9d07c9ce4be2 100644
> > --- a/drivers/net/hyperv/netvsc.c
> > +++ b/drivers/net/hyperv/netvsc.c
> > @@ -31,12 +31,13 @@
> >   * Switch the data path from the synthetic interface to the VF
> >   * interface.
> >   */
> > -void netvsc_switch_datapath(struct net_device *ndev, bool vf)
> > +int netvsc_switch_datapath(struct net_device *ndev, bool vf)
> >  {
> >  	struct net_device_context *net_device_ctx =3D netdev_priv(ndev);
> >  	struct hv_device *dev =3D net_device_ctx->device_ctx;
> >  	struct netvsc_device *nv_dev =3D rtnl_dereference(net_device_ctx-
> >nvdev);
> >  	struct nvsp_message *init_pkt =3D &nv_dev->channel_init_pkt;
> > +	int ret, retry =3D 0;
> >
> >  	/* Block sending traffic to VF if it's about to be gone */
> >  	if (!vf)
> > @@ -51,15 +52,41 @@ void netvsc_switch_datapath(struct net_device
> *ndev, bool vf)
> >  		init_pkt->msg.v4_msg.active_dp.active_datapath =3D
> >  			NVSP_DATAPATH_SYNTHETIC;
> >
> > +again:
> >  	trace_nvsp_send(ndev, init_pkt);
> >
> > -	vmbus_sendpacket(dev->channel, init_pkt,
> > +	ret =3D vmbus_sendpacket(dev->channel, init_pkt,
> >  			       sizeof(struct nvsp_message),
> > -			       (unsigned long)init_pkt,
> > -			       VM_PKT_DATA_INBAND,
> > +			       (unsigned long)init_pkt, VM_PKT_DATA_INBAND,
> >
> VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
> > +
> > +	/* If failed to switch to/from VF, let data_path_is_vf stay false,
> > +	 * so we use synthetic path to send data.
> > +	 */
> > +	if (ret) {
> > +		if (ret !=3D -EAGAIN) {
> > +			netdev_err(ndev,
> > +				   "Unable to send sw datapath msg,
> err: %d\n",
> > +				   ret);
> > +			return ret;
> > +		}
> > +
> > +		if (retry++ < RETRY_MAX) {
> > +			usleep_range(RETRY_US_LO, RETRY_US_HI);
> > +			goto again;
> > +		} else {
> > +			netdev_err(
> > +				ndev,
> > +				"Retry failed to send sw datapath msg,
> err: %d\n",
> > +				ret);
>=20
> err is always -EAGAIN here, right?
>=20
> > +			return ret;
> > +		}
>=20
> Nitpicking: I think we can simplify the above a bit:
>=20
> 	if (ret) {
> 		if (ret =3D=3D -EAGAIN && retry++ < RETRY_MAX) {
> 			usleep_range(RETRY_US_LO, RETRY_US_HI);
> 			goto again;
> 		}
> 		netdev_err(ndev, "Unable to send sw datapath msg,
> err: %d\n", ret);
> 		return ret;
> 	}
>=20

Yes this looks cleaner.

Thanks,

Haiyang
