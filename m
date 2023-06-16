Return-Path: <netdev+bounces-11549-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE145733880
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:55:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E007F1C20FC6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0251DCB1;
	Fri, 16 Jun 2023 18:54:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55684101F6
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:54:41 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1149C3C01;
	Fri, 16 Jun 2023 11:54:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxGDuAhvdM1YV3OOCZwge7+cLuFPKhSXX2IVvQ2Q45ZuX7CmNYgbtTtywgtDddG9lifeaBRH+6cy82KrTKg9d1zT+G4eCY5vSf/8nx3MhTozSS5t9eenES/dLYTmPXAp131yR+OrDgD/Zb10CgcR3LypUI4+HgrkmjLP80z7t5JTwO3vnwcSxAZJJPJDRbHdZklbRQW8WBAYpZf163iAWmOP9QMKzv6T+PE0lNXZFPOfPPRYhmhA4siebRnQHMbk3MU+1Sqk8CtTnP44qlyTpMSXp26btlUlEgxcvH+Nl+nPxydVVX2luTaMMWgPtITRK/n2PrwLhZuwI+6kxroD6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WYlls6laxxWim1T/6gHEid/WWrkZmkvMjANp0eVWpQA=;
 b=OEJqNk24xkUwFk9kLkuaA+or+YsvEQHRJUoTRa3I6/UgA/YGFy7uCzxNf81VQGhepJl+9EsPvrriDiJnec5yFonue1xln3DL6QANXkv94hsRMYziGglnv23Kn1xdacXLu19DwLzirzq5v9GcnM3hkNfTFUTIW0ZxCZc4I16uqYs9MUPvWryL7wchc+OvcjcCB8Gb6ShLChUMj2j6aKkKY9kSzRywLR9a853DhgVN/NotXjo++Dl8uOyDlv5ppgJLLxdmrMPRo1bqcYNhoWiA0soho1Q7zTiBqtCBrSZHDE0IINvZIau1G/zhuZphFemuI3JnPxsXWlf7R/kfmNc3hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYlls6laxxWim1T/6gHEid/WWrkZmkvMjANp0eVWpQA=;
 b=WVrm/J6uJdp1ONZjZCgsseEms1jjbo7De5G93J5njnhk53B6ZdRa7zF2pC6g0knNiTqWr10/3L+q5k7Ua3kiW5E0QnUtEESS31yEsYV99edYhZrdVPefmSYMKWAlIVzsuqViC3h5ibNVhDuSq0PrczfZGkvoiqvcuAmIQ64jHoY=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by BY5PR21MB1410.namprd21.prod.outlook.com (2603:10b6:a03:232::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.11; Fri, 16 Jun
 2023 18:54:33 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::eee5:34cd:7c3b:9374]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::eee5:34cd:7c3b:9374%4]) with mapi id 15.20.6521.009; Fri, 16 Jun 2023
 18:54:33 +0000
From: Long Li <longli@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>, "longli@linuxonhyperv.com"
	<longli@linuxonhyperv.com>, KY Srinivasan <kys@microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Leon Romanovsky
	<leon@kernel.org>, Shradha Gupta <shradhagupta@linux.microsoft.com>, Ajay
 Sharma <sharmaajay@microsoft.com>, Shachar Raindel <shacharr@microsoft.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] net: mana: Batch ringing RX queue doorbell on receiving
 packets
Thread-Topic: [PATCH] net: mana: Batch ringing RX queue doorbell on receiving
 packets
Thread-Index: AQHZn+EJXTKD1broDkaYLVl7X2Pogq+NpSyAgAAiyDA=
Date: Fri, 16 Jun 2023 18:54:33 +0000
Message-ID:
 <PH7PR21MB3263C8E5FC38C20767865717CE58A@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1686871671-31110-1-git-send-email-longli@linuxonhyperv.com>
 <PH7PR21MB3116FB2C7E12556B0007C9BFCA58A@PH7PR21MB3116.namprd21.prod.outlook.com>
In-Reply-To:
 <PH7PR21MB3116FB2C7E12556B0007C9BFCA58A@PH7PR21MB3116.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d3303894-c75d-406b-aad1-a94f96e78183;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-16T16:47:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|BY5PR21MB1410:EE_
x-ms-office365-filtering-correlation-id: 3981ea71-9239-482c-b876-08db6e9b1fa4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xmls1en0WHyDZ/aYtbEWj9EzETsPhmLkXTcsI5GUhVz5a4o7a5KHxhxJ9NJ2um6/OZxALsZrmUb7deViCcPaxgqP+5u49LJZ61/HLUFTRYdCF/Xu20dbyVbeREwZbV/2kOItTzpLGHVa0KwTGGZApSZB4Vnbj9ROc02h/10bjsXmAk+W9ah1T8LlRlpvY3IqI5xxSjGTsNDl3ujGGmKHJ7IRJgVI3RAx//1ERKqxsCn5ecgBdrYBDac4z4Z3VclSrVl2YSymhgXt3LRy6GmC2EA5EnhGAvQY+4p75tKBN8Ah9IAJnU16nUnJYJC9Pws4mdmX23IhCAotEk3hoyabdbug9q/4bv+TlkmnV1SY5mCThfjGAVQ5uqu1T/Q+OoGvfYr7mRHfbCjDSuC40SVbq089qupw+IvN3tTXMDTnCTnDeglk8OW5RRtZBJ+DjBoiIVlqB84UmtPH/qVTBE6D+VwpoiYWoivmZeA4NB3xyqtQ9nFgqATa6XC69ewQ4Gyhpa+zFapkS2QyWwh+36EA035xadWAdCD705UKIF8ZJE2MB8jP7ScoJ3MdjtCkD1m5Pz8A8JD94Dc4DAbpg9XgBwj6pwtGaT75BGCS6lqZ234sZ3AM//y5a7Qpqh7yyXZZSMsoujBlu2eTxQUCGpkGcnDXCWe2uDtDPOQo+0hRnA9PjhHqjYPRRJnVSsx+zlvY
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199021)(7416002)(52536014)(5660300002)(8990500004)(55016003)(71200400001)(54906003)(2906002)(41300700001)(8676002)(8936002)(316002)(4326008)(66446008)(66556008)(66946007)(76116006)(66476007)(64756008)(33656002)(10290500003)(478600001)(110136005)(7696005)(9686003)(38100700002)(53546011)(86362001)(186003)(921005)(122000001)(82960400001)(82950400001)(6506007)(38070700005)(83380400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?vmtFf4LH1IEbYVAEwCJ1gCl1e/gx7fZ95qqCSNNNUb3NlBDxig53lP04f2dd?=
 =?us-ascii?Q?Yzq2Cy/5aExnb+zrISN0ATiD3bfFVcXB3c0BU3ZQV6K/xMJ87m2rQDwd8Tlw?=
 =?us-ascii?Q?mPG3VwrbGIAtFjXdAexjf+2rJsC1R4bScFgyexW8+KPOPrOo84qnLZHNPhMY?=
 =?us-ascii?Q?YKdh/Yklts2dYD1ETSlEliE3hZQPHENlkuo7Y5NhejuijWQNEQfnsF6Cr8H7?=
 =?us-ascii?Q?HaJTQ42ndLXoBQPnhIPqydInsCis11DYDI5gRhuABVKoCWX9nvowou6yknOB?=
 =?us-ascii?Q?YKlJX02Bdfs4se3IEG4UTwAV7eCFd1ZSTPddQzOBpVBECbMO7+8JwCVOyHy8?=
 =?us-ascii?Q?pd3YIhYfAKZ9jinCm5BnshFJSygABnhV/K5OPMD0DYV35F9UXmMv+f0nmpIW?=
 =?us-ascii?Q?dhtksJ+7eaT0fqB6yR4xvIzTXv1CguQpV4Oy86hwBHSP044UX0g3xKQ91NZv?=
 =?us-ascii?Q?Mr/E/Lq/gP9J6apzUlKza0k7YaswIqiMc/eZm5CxubmdX47dssxFVDZEJx50?=
 =?us-ascii?Q?s4c4baTbgNZDJXpAohXtLWhcWu8Bu2+05adDs/fCHamwZtyyZNkCW6MszwgG?=
 =?us-ascii?Q?wZQ7OWtVkDRz6X+ensWuR5qM/BxU2FOKhd/JrfsyeJr7NRBBBVl0Cp1Q7UUA?=
 =?us-ascii?Q?Rcx8ZdKOWXUGBTi6LsPWeigCh10FhHLadwHGuO4ehERw4RA0mVVh5PnQ3pGx?=
 =?us-ascii?Q?hK95jsLi1JE/bXIMFNaX7KDIkqXvOEKUhrMYam2v92Lw/Enfa3fITgo3lM/L?=
 =?us-ascii?Q?GQCSULCF501kDlkF8mI0hV2Oc4mmWkRU1AqnImNt3YLTIk9pq6drfg/tzuNd?=
 =?us-ascii?Q?JKQf5ZVe4ohcvM64RRp/eq9h37J0+G/CcSpTgt97Lio6UVuDX40dFNa17pVs?=
 =?us-ascii?Q?ZgmAvyxAUrU2V0FqkJ1C/ThGo5gkBobcT/27zUmeBc4hyKcHdFQArvJ2RxaK?=
 =?us-ascii?Q?Hb+8s3pvArSE/mPG3yUVdYLCrcwOQukGw8A8VeUAaX/0KhfxxLDdpJrmmcht?=
 =?us-ascii?Q?TvbvHTD/UVMI0ducLe7MdBpex5iIPWeRLembq4zJ5Db2FddjUkkWMkSUL8Jm?=
 =?us-ascii?Q?8KFRqVK0uF3qlKxM3CEbR1RYhCfZeHnLLFmoOaMYzYE5qvSLfb8y6adJ4DHD?=
 =?us-ascii?Q?s2ZUd91VsAaAzxi3CKqrUw7SIrLZve3QAietcT2olm+2w7mpdop00Z8nrGmB?=
 =?us-ascii?Q?/QhE5hIZY0RTegyvwtnxHL73l0fp7JlEkVgSv6/7bAoHvBSOr1uTmdU3G3PT?=
 =?us-ascii?Q?tn6KXa+s1j35ThBfme6gXL19nVAhKsg+htaTXW243G8ZeezWqTlr4BJ5QEK2?=
 =?us-ascii?Q?9qbs7Zw1K3XWT3/qgDr3TV3nCCbxSH2yhHbqOD22JNVOx0eVeiexqZZhA5d4?=
 =?us-ascii?Q?x89dZlhUGslmvCOEOWO/5ZL1IXGzf908M3G8hc8Kx68yBboQGN5POPIyXl2e?=
 =?us-ascii?Q?653hJWTNcqMbFjX4gTP6VcPZXWOJZdu7tPtzBine7nntZc4gvo9VG2OEAIGN?=
 =?us-ascii?Q?cCad5uqLhKh51byNEKMCOdLLheATteNdzzeZm/NV5SdOicsdxVVfboCmaezm?=
 =?us-ascii?Q?pYp9SeErMDTtPKpvlXG9doB2eqMnL6SB+XLI5kfp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3981ea71-9239-482c-b876-08db6e9b1fa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 18:54:33.2314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Ywym2nUktyrcTYNM7hVSpYBhf9WupU4F2wy8qc804p4wkj8klCmNukGcPOTnfRtjeXzWVdBziiR24H86g4sBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1410
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I'm sending v2 to address some corner cases discovered during tests.

Thanks,
Long

> -----Original Message-----
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Sent: Friday, June 16, 2023 9:49 AM
> To: longli@linuxonhyperv.com; KY Srinivasan <kys@microsoft.com>; Wei Liu
> <wei.liu@kernel.org>; Dexuan Cui <decui@microsoft.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Leon
> Romanovsky <leon@kernel.org>; Shradha Gupta
> <shradhagupta@linux.microsoft.com>; Ajay Sharma
> <sharmaajay@microsoft.com>; Shachar Raindel <shacharr@microsoft.com>;
> Stephen Hemminger <stephen@networkplumber.org>; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org; Long Li <longli@microsoft.com>;
> stable@vger.kernel.org
> Subject: RE: [PATCH] net: mana: Batch ringing RX queue doorbell on receiv=
ing
> packets
>=20
>=20
>=20
> > -----Original Message-----
> > From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> > Sent: Thursday, June 15, 2023 7:28 PM
> > To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> > <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Eric
> > Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo
> > Abeni <pabeni@redhat.com>; Leon Romanovsky <leon@kernel.org>;
> Shradha
> > Gupta <shradhagupta@linux.microsoft.com>; Ajay Sharma
> > <sharmaajay@microsoft.com>; Shachar Raindel <shacharr@microsoft.com>;
> > Stephen Hemminger <stephen@networkplumber.org>; linux-
> > hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Cc: linux-rdma@vger.kernel.org; Long Li <longli@microsoft.com>;
> > stable@vger.kernel.org
> > Subject: [PATCH] net: mana: Batch ringing RX queue doorbell on
> > receiving packets
> >
> > From: Long Li <longli@microsoft.com>
> >
> > It's inefficient to ring the doorbell page every time a WQE is posted
> > to the received queue.
> >
> > Move the code for ringing doorbell page to where after we have posted
> > all WQEs to the receive queue during a callback from napi_poll().
> >
> > Tests showed no regression in network latency benchmarks.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure
> > Network Adapter (MANA)")
> > Signed-off-by: Long Li <longli@microsoft.com>
> > ---
> >  drivers/net/ethernet/microsoft/mana/mana_en.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > index cd4d5ceb9f2d..ef1f0ce8e44d 100644
> > --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > @@ -1383,8 +1383,8 @@ static void mana_post_pkt_rxq(struct mana_rxq
> > *rxq)
> >
> >  	recv_buf_oob =3D &rxq->rx_oobs[curr_index];
> >
> > -	err =3D mana_gd_post_and_ring(rxq->gdma_rq, &recv_buf_oob-
> > >wqe_req,
> > -				    &recv_buf_oob->wqe_inf);
> > +	err =3D mana_gd_post_work_request(rxq->gdma_rq, &recv_buf_oob-
> > >wqe_req,
> > +					&recv_buf_oob->wqe_inf);
> >  	if (WARN_ON_ONCE(err))
> >  		return;
> >
> > @@ -1654,6 +1654,12 @@ static void mana_poll_rx_cq(struct mana_cq
> *cq)
> >  		mana_process_rx_cqe(rxq, cq, &comp[i]);
> >  	}
> >
> > +	if (comp_read) {
> > +		struct gdma_context *gc =3D rxq->gdma_rq->gdma_dev-
> > >gdma_context;
> > +
> > +		mana_gd_wq_ring_doorbell(gc, rxq->gdma_rq);
> > +	}
> > +
>=20
> Thank you!
>=20
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


