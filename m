Return-Path: <netdev+bounces-889-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EBD26FB330
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:45:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABE9F1C209C7
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826FE15BD;
	Mon,  8 May 2023 14:45:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4A017D0
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:45:49 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021024.outbound.protection.outlook.com [52.101.57.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F8FC2;
	Mon,  8 May 2023 07:45:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ij6qiwk9HXw/YngIR5QFd7nDBdixqiJmZskDNCcSHvSvDQryIix9ayPEDXAi8E9BgGb/7R6rFaIu1ltwgt0pLPa62Bzs3ZAPbpg+e7EpwaIa3ysl/0YIiY3WsxmfmFmbrp/J47VkbceDfzMnk84/P28hSveh/o+x5gGDivwH2VSEK0c3Zt2Oni3TJCQVufr+fClG1Vx3nokdUCj9sCnILEktezbZZBfNdtl4I8P9fElSivuUPJTnbTKFrtGJd/L8kwXdVdkUi/pTjFODJJ8MNV8b3XT8y0TLcsy0UsZTrbWo8ZHG/gx3WwMT1flHDxjbmh0hV7LSocLbyoShGr9bqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tkh8n4op8lLZCPvzvWnDHXLvmgLoi5A/daRfvXarQuA=;
 b=jwG4rUPFhFWIgMDYAwHTCmhjXvGddFqgmvdEuUMwmBs0/I34phV+GQtVFU8KxX2XYRDvwmjObMoSx/NuO19VpqjUwbLm8MbTmEFo/BL6VU5MZ1SYdGu7vAMt2UJEjb5e89zqLboX35Bwf+YArIXJ/6e+3MuetTSbIkzC4StWoXeDXVAXX02B732UrU4aH8QbULneefJa0PvfN4Tl2ZKhZRV0fwbiyZaDj4tGQGH5twaZBDAMJrwbROpGC3RpTleHtWgHmTk+dAv94Xzll6XRWdZjbSauGuBwYSqir6ebw/YampZKEFPUFsfTl5VRg+7Kd/Qyxq+NsiFwOhJqKAvzBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tkh8n4op8lLZCPvzvWnDHXLvmgLoi5A/daRfvXarQuA=;
 b=bywMlXMjl9v12T+MvkhtQVAL9VepzhY99t40DgmEnt5A0STiNiXbX7xQajVuLUtmqTdWU/EbVkJlRBjowh5yoj21AmiTsL+GvjFCH0AqfbfalTa6KEYdDesouuRMVI+JNT69aP4OdFEZ8ZjYx4O9HDXEdqiVNEqfS2qoPR529b8=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by PH7PR21MB3848.namprd21.prod.outlook.com (2603:10b6:510:245::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.8; Mon, 8 May
 2023 14:45:44 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::7745:82a2:4a33:65c5]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::7745:82a2:4a33:65c5%6]) with mapi id 15.20.6411.004; Mon, 8 May 2023
 14:45:44 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Long Li <longli@microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>, Ajay
 Sharma <sharmaajay@microsoft.com>, Dexuan Cui <decui@microsoft.com>, KY
 Srinivasan <kys@microsoft.com>, Wei Liu <wei.liu@kernel.org>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Thread-Topic: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Thread-Index: AQHZf4Kxjex9WkNlekCvwwavSM4vhq9Od9yAgADgy0CAAI+qAIAAjikg
Date: Mon, 8 May 2023 14:45:44 +0000
Message-ID:
 <PH7PR21MB3116031E5E1B5B9B97AE71BCCA719@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1683312708-24872-1-git-send-email-longli@linuxonhyperv.com>
 <20230507081053.GD525452@unreal>
 <PH7PR21MB31168035C903BD666253BF70CA709@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230508060938.GA6195@unreal>
In-Reply-To: <20230508060938.GA6195@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=78a9b04a-730b-4f26-be14-e54bb584600d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-08T14:38:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|PH7PR21MB3848:EE_
x-ms-office365-filtering-correlation-id: e35a99fb-7dbe-4970-d577-08db4fd2e728
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 lP9te/PYR1Mi+dbbGhPzz3IeR4puxoL71KKZNEt0YBy5hXP/SVPmwFtRm6ES3UqRlCmFB/iDuxvUI1uGPH0M8i96aTwCKZLJ7h/iba3Jm5mEpzZEngx5mj4vBhFKnrSsCubNTiKAbbBN23Snlir7KKA0rF2yX1Wu9ReQjE8u414N29PGrOAMHKN0avE12Gk9k7itH7ub2OXSFul1OcdIO2iD4mSnvBeCGMXNYE2brdjL+hI+EUwJJhXofGo2SXaWVJzyzAJrNkM4eBR6Cz4fwYjiWpkXyodY8ja7K9xBQ5ghG76Mzx7Eu73muhU036MZgPmvQA/z6AXauikn/cWp9sssTd9WU0qu/VhGatvNzpV4og9mvoHUZFViR479GLFxbfzAfrU68FGu3CPMpRBHrM/JjpdwiwDq6yXRl9ZymKGy6bNTtIQTJFXVP2AeaR1vs65UIo5UUIN1ycxQ8fwELk4uaODDnGExuQhoh/yQuppM1k1gSONadWwueLYp5GeGXF987XfUUbJWDs/fMkfdEPgaeVkYKWJxNHddxRtYCrFXhEpN/6PZ0qUuVUM8COo2gs3XLhdUxDxCHKaBRi/uxK36gIgnpigfkO6curAC/IV9l615s6FSup073Yby6JWoUX3lqre3eml/nj6MqGx2AHwv1QVJwpe2WbxwEyUkid0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199021)(52536014)(8990500004)(2906002)(5660300002)(64756008)(10290500003)(66476007)(316002)(7416002)(33656002)(66556008)(41300700001)(478600001)(66446008)(76116006)(6916009)(7696005)(86362001)(4326008)(8936002)(54906003)(66946007)(71200400001)(55016003)(786003)(8676002)(38100700002)(83380400001)(26005)(122000001)(82950400001)(82960400001)(38070700005)(53546011)(9686003)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?7mWH/kbbHEZzjZyDTGkIzpUQuUwa5wXuKLSPjYvwvxZcxl1eluj3ldXTgW89?=
 =?us-ascii?Q?kIQptUf9GLBjCywVBASVPPEx5FGVrmU/R3sfzIY9Eo6r3+jeiDMqIi98dT1K?=
 =?us-ascii?Q?uAKveMhBRLvEUNr16Uu4SMbvhHbqrk6SPCkHDo87Vq/untk5Yc+g1LUcEtX9?=
 =?us-ascii?Q?rz068C13YamkyIY6GEgHbDR1nKS7vK6nnDDJMN6mF7X5zs1Q7/WsVWVkjdlp?=
 =?us-ascii?Q?hvbF2CPQlY4/OtXNYcZYlvxPYp8B0zFuYW16QsxpUJDTDldKq1LM7rp4yDLe?=
 =?us-ascii?Q?RNl6MS0jhiO5rsheZLScM/66LXUwp+FkjIx5FpQY6vjnVfdi3jUEciEpErnX?=
 =?us-ascii?Q?9krI0NTyMzv0Iun6EveXXDneV66WAUR4a7KzLm5pP6ItPeLJ5UKPXxLmOJ1e?=
 =?us-ascii?Q?2oGEIi/qVpL2J+7eLKo/NLcvVTFnONs4laczEiFJWUwrU0XzkhyIdLmTF+Er?=
 =?us-ascii?Q?J9xJYsScstHYCxS7QDKZz09XdjKfrUMiIInAN337wBeOrjb5eqjLXn1zh1jA?=
 =?us-ascii?Q?z8Nj/vKPS2V66C+/+5/HeTM2x1E2/6lt1dYUu1qCf9R//pJIDDaG1UY6ErN6?=
 =?us-ascii?Q?nuxWFMBA2tEQJ+PjxpzXcy05UJQdZ7iI1QuhaAMibsuoXOJhWfAou7dxQ4vn?=
 =?us-ascii?Q?kVBfiqLd7ayeRnOB8PHYo8nAG0ib8QUQV9dPzmkc3TysXSFgt8MBLWJ39xdh?=
 =?us-ascii?Q?8Ijwk/ttgFgAuGSXkvwuZaHwQOZi9T3XSa3aDDvzg9ieDm3Gh8hpmQl0k69j?=
 =?us-ascii?Q?+YyMFBOL0s1RLM+aPcj7Ijpvl7McA9aWR4HU4AzB6rdmqlHTJsfp3t2gfXyH?=
 =?us-ascii?Q?KKgGP1Wf5eLTSk8FCZZnEjrCRSF6ZCCluS5KzwMKUg6rB7iWBgZgA+7e26iE?=
 =?us-ascii?Q?gllm1xwU0ryLqe7WEWXQu/E0pS15XjOIZGjBhO37IEJACy6DlzcpvFeYIPqd?=
 =?us-ascii?Q?78/Okgz4CTmNeFe6YtHW6KJ40fDgipHjIP0xzqDk8DM64qh32JjB0F6hHfGS?=
 =?us-ascii?Q?dr/6g2PI0r7qHuv0oHjxk5UzVp+f9O8+1qlS4m1r6k0pN+VgSLYvLRxokuiV?=
 =?us-ascii?Q?9gLuT+CXotB+znQFPJkghj7pzvtOECKE5UT0ZsM3dctzveNXBDbOrUU/cZfv?=
 =?us-ascii?Q?qGbdpgcoOKDd5ACObm+PXCrpk1qPkhY2Skt1/7FRFsjGteApzGoHPG4CuKxx?=
 =?us-ascii?Q?22gdhoI5mNevQSz1XHCmYrtO1io2cKMFam1lElgoMNb65TD/Z69IW3t/zjHT?=
 =?us-ascii?Q?GcJwuxH2HoWKehHPJT40WFHijIjxHvKk4ufaYiuTtNMMrVzXR4Y+Ni24JIvj?=
 =?us-ascii?Q?Qk+qckXyhqxvPYTYNAnb9IlpNcPwQmPGTFA4TBCV0TZtrvJVTs8rbNT+uL1h?=
 =?us-ascii?Q?gNkN0g2i+sEN1HnWoVyFdcQ+2HJklj8R+Q0UQy9E8cUwHROfC7SWhwip0p0K?=
 =?us-ascii?Q?Am0p3gvwpFcXKWsiX4mYV5ssLDs2Qf3kS3aHcGBO4sj3BpIgHPTEzUdxl71U?=
 =?us-ascii?Q?cX+Neg3EK3If30sGBnSNFnwYe7J9+832FDCfuwHmrRMwGwHVeea1I965rExC?=
 =?us-ascii?Q?ZMG8rDfhaU+p4+7eyThywB+hh0bPWSZBDES6QohG?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e35a99fb-7dbe-4970-d577-08db4fd2e728
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 14:45:44.2492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X7mAiHpPSUKxsDZMIp6bYN5+NrxETEHwsRD4runandtJguRuW6cQX3JKpmxsnHyjUPrF/7traYfxcpRWWwpRrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3848
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Monday, May 8, 2023 2:10 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Long Li <longli@microsoft.com>; Jason Gunthorpe <jgg@ziepe.ca>; Ajay
> Sharma <sharmaajay@microsoft.com>; Dexuan Cui <decui@microsoft.com>;
> KY Srinivasan <kys@microsoft.com>; Wei Liu <wei.liu@kernel.org>; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; linux-
> rdma@vger.kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
> enable RX coalescing
>=20
> On Sun, May 07, 2023 at 09:39:27PM +0000, Haiyang Zhang wrote:
> >
> >
> > > -----Original Message-----
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Sunday, May 7, 2023 4:11 AM
> > > To: Long Li <longli@microsoft.com>
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Ajay Sharma
> > > <sharmaajay@microsoft.com>; Dexuan Cui <decui@microsoft.com>; KY
> > > Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>;
> > > Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; =
Eric
> > > Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo
> > > Abeni <pabeni@redhat.com>; linux-rdma@vger.kernel.org; linux-
> > > hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> > > kernel@vger.kernel.org
> > > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req
> to
> > > enable RX coalescing
> > >
> > > On Fri, May 05, 2023 at 11:51:48AM -0700, longli@linuxonhyperv.com
> > > wrote:
> > > > From: Long Li <longli@microsoft.com>
> > > >
> > > > With RX coalescing, one CQE entry can be used to indicate multiple
> packets
> > > > on the receive queue. This saves processing time and PCI bandwidth =
over
> > > > the CQ.
> > > >
> > > > Signed-off-by: Long Li <longli@microsoft.com>
> > > > ---
> > > >  drivers/infiniband/hw/mana/qp.c |  5 ++++-
> > > >  include/net/mana/mana.h         | 17 +++++++++++++++++
> > > >  2 files changed, 21 insertions(+), 1 deletion(-)
> > >
> > > Why didn't you change mana_cfg_vport_steering() too?
> >
> > The mana_cfg_vport_steering() is for mana_en (Enthernet) driver, not th=
e
> > mana_ib driver.
> >
> > The changes for mana_en will be done in a separate patch together with
> > changes for mana_en RX code patch to support multiple packets / CQE.
>=20
> I'm aware of the difference between mana_en and mana_ib.
>=20
> The change you proposed doesn't depend on "support multiple packets /
> CQE."
> and works perfectly with one packet/CQE also, does it?

No.
If we add the following setting to the mana_en / mana_cfg_vport_steering(),
the NIC may put multiple packets in one CQE, so we need to have the changes
for mana_en RX code path to support multiple packets / CQE.
+	req->cqe_coalescing_enable =3D true;

So we plan to set this cqe_coalescing_enable, and the changes for mana_en=20
RX code path to support multiple packets / CQE in another patch.

Thanks,
- Haiyang


