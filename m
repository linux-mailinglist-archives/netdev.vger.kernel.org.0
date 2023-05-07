Return-Path: <netdev+bounces-761-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B14666F9BFD
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 23:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D04F01C20A8D
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 21:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B8FAD22;
	Sun,  7 May 2023 21:39:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1143B883C
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 21:39:32 +0000 (UTC)
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021027.outbound.protection.outlook.com [52.101.62.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4957EC8;
	Sun,  7 May 2023 14:39:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kf7uxYAaM4xksVNzt85zF/nzWDjyeWa4IkvTZQrOKI2H87imG1Gj3Q0pE+WYuOXT9GiECptiaMmX997+OC7c4VlwK1P3Q7/29IZ7WrL7GSfyFXgb5UB10OzfCX3uD7pDK1Disr8LOc7rAKP9BBC7OtP6hLVAmQ75pkFe0hAFor1Ya0gGV+SBrL8zdhD31cMNTPsErCUbQqhUagM7a8bYTsPtmMf8eHHyI6HzOHxwq/hZV9hDZS1XLnctsqxoIrdmPPzsnoE7OBo8FSaG+BBnZ8wZgUwAI+vfZTv2Al6TodD0Rg6vQAMIvs7GsVeSwZpPEj4e6FiuFfGhuGIafnv0nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4SgVEuOVztsMKhDvIoMJw7HcjSFAXyVwbzbn3pslGI=;
 b=SQ0VqZishsu6udW0r3yG2+zQgcIG/H1VovWD4/+EjPi0sblIg8HmF7zjPGg5ovJ/cNymsggavh1In+oD7Kgs50X0Pdjvh5Y4r1O1/1DIe4IjhLRNqxFMfj7pRJmG21UOf2XXsrHDgdYdPbIq/BkYp3+CknW/Q5ZzhRClCi4HjIrENYvT+/ksaOc2pk3dhhpBrF2ic0dZEYg8IPT5KwF/Md/EQo2xa13Cc7Mjili93brG7Ipwr34C3goEaBfQvdfGtMHb6af1Vb+y7MW76o1nDRJoM33/QAJkGdiD6rWjdSPJV7gP80DAym5UHbDzmoXUacc/FBd1/IHb7KtErW/QHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4SgVEuOVztsMKhDvIoMJw7HcjSFAXyVwbzbn3pslGI=;
 b=KlUD52BELT8HShVlMbtrevYlGreTWG2rsYOZWg0TaygrZ3r3MFHoOuEwf21VISyIWDuBppCMn5Hwz0EUQcL3TZo8sftL1QaKU0rwRm9LM2t5IsFRBC7+0KqIpFf84c5taLv/DHlmVY+xY4/8war3IB8xha48+pBZaHuJZCWc12k=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DS7PR21MB3479.namprd21.prod.outlook.com (2603:10b6:8:90::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.2; Sun, 7 May
 2023 21:39:27 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::7745:82a2:4a33:65c5]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::7745:82a2:4a33:65c5%6]) with mapi id 15.20.6411.002; Sun, 7 May 2023
 21:39:27 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>, Long Li <longli@microsoft.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Ajay Sharma <sharmaajay@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Thread-Topic: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Thread-Index: AQHZf4Kxjex9WkNlekCvwwavSM4vhq9Od9yAgADgy0A=
Date: Sun, 7 May 2023 21:39:27 +0000
Message-ID:
 <PH7PR21MB31168035C903BD666253BF70CA709@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1683312708-24872-1-git-send-email-longli@linuxonhyperv.com>
 <20230507081053.GD525452@unreal>
In-Reply-To: <20230507081053.GD525452@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2485ae63-c230-4ad8-96da-010ab44a00da;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-07T21:35:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DS7PR21MB3479:EE_
x-ms-office365-filtering-correlation-id: 0db7e0fe-41ef-4220-57df-08db4f438853
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 o9DozYYWcciSyW6r1SQ6uT6MG8Ol/eTBShc19cifIV2Kzp1NT3aWV2yXZ1SEPgyPf+tLKDmri3GjYC7/Q6YEVx083l6uyVIBT8uCaqQJTaaaFnlGqqaFjJhX73oATSw7CBHGqQeZNyOH6tjCFgOzfwZ+9kY78mb79JoX+HPYuPOlSKWkLom3DP1t3AEl1vwWjRYsS5etYGriEWII5pDOCJI5yJ9ew5/lJ2Hh1/WBzmF95hsRIT5EqF8E5QUTx4od17Lxc0I4wqNvSRmWhFppRhwqVlE+5fZWVepzCdUkbyMo8gxmtDbwyhNbWS7G/aDPzZkY5ke/t7VxTL17PoaZCz1FgqrrREq27vc3aVQfuBHZwsCaQEu70dSD6jblp+j4XyBvHGoei6k532uap8dG2QcOqC9+bEktnLRUXng5hHEwisJeqKVrImTdL4pl/VPlkYXpDMVUOZK/1W/jYavieoKjo3adhAMKYDIVXWFuJy8aNFd8QYjzbHvosxi7iL7tOUr3cNAWuuVS4Q6x+XGXSEVnQXM6uj0vG4PllVq3fkntolygXBSSFrdFzXAgo5ZmNhh58PCmwJotBdKGWa8HOALwoyqFqYAZpydzm7q7NI4cUHYY1G2kmDU0ZnFdZDV8tPRVnyNsOde+Ey+J9qVhVUHSyAJ8ViKYyXcoVpgPHBI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(83380400001)(10290500003)(478600001)(7696005)(71200400001)(54906003)(110136005)(9686003)(6506007)(26005)(53546011)(186003)(8990500004)(7416002)(2906002)(33656002)(52536014)(38100700002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(122000001)(82960400001)(82950400001)(6636002)(4326008)(41300700001)(5660300002)(8676002)(8936002)(786003)(38070700005)(86362001)(55016003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?nEEFc4vZ1GTPhaF7aV6RlzwwwPNwTPW5+DLNcU/vWEkIf/f7ZQMiMGNMlyzm?=
 =?us-ascii?Q?v/XwrNqLOmIhkz8KRcnBwlioivwjeZbYtn79192ismAMhu0YlMX8L0OMn27b?=
 =?us-ascii?Q?qtcJlt2yQuynNZ1P9xkkKJaN306pXrdTXfpKjOtsfVDW1y17JOxz2MaXNbEj?=
 =?us-ascii?Q?axNOIy/ucu7eUV5Vd1qXB+8tvomHR6Udk8kTpMiX6tdD/Zenc5roDJKPOpUK?=
 =?us-ascii?Q?tn4zz89CmYbLV0A1H0qGzlySLtkvKEGFS78mVi+KOTMKM31yu59y60EKOiGp?=
 =?us-ascii?Q?wXd+tBJXoeZLG7PoXWC6et/qUOyDFvP2ERpUloLoVdD3Z+2bgOxj2MkEWICJ?=
 =?us-ascii?Q?Wac+vG4daTDA4vKiV+DAEXfxZyjNffLhwzmEYAUIvRNaVvPRT6puzJfNDdK/?=
 =?us-ascii?Q?1mO/fSgPMxchN0v6o4aeLXSBjFpez9rwwwNe2YGZSyqM9KzEo5U7hqO14oLn?=
 =?us-ascii?Q?1rhwDQLZGIuucCPNA42kubOysU0x/s8U/m0OKs02GIuL3+Ds26JSOfGHZiQn?=
 =?us-ascii?Q?13d8vQxAaBaJzYlfKk+9UxdKYFBSs1daV1HZWwQDlV1Hgoi3rPLRLpS5b687?=
 =?us-ascii?Q?XpAA1yisb8bDk7EzPbJs4QDRtF96pBCkOuy7HguHlB4rNDA0P4pRuZXCKfGz?=
 =?us-ascii?Q?H/rcx9jlNnB5iNUegZ7UUcwKR2M2/zlvQOqN5jUe2cdaRs6rbIdzzirfn441?=
 =?us-ascii?Q?bM7a5AF2cSaQaZWCSpr8fseTFm3dBAKeLTwXC0eaN6zyjLLfyo6eoGVuV/7p?=
 =?us-ascii?Q?AQ5ByBOpA8Wtqz+pNqi25NFw7EFR1FvtlDD8nBnrrQ8RC9yP2kzC3UHsBqr1?=
 =?us-ascii?Q?I5qSCJsRrROFxfp3o5cnujV0cdu1KjWicRiJDe+P1pIHPOO5J8pkJBaSJaGN?=
 =?us-ascii?Q?3G6K9u+4zIO+1GS+v2a6vT/HXc+PDwlAGKwMLtcYjCHJS9OP5LFIaZdjhayh?=
 =?us-ascii?Q?j0IAPLa2zlO18kBvVBJOcLW6+g9nmHm/wB52qaHo5T20ejTMVezWBBS6LQCG?=
 =?us-ascii?Q?R9BXOZLG2L7MhkGtCqKx9OtWhgJfqenIgYMPKppeBIRRTRb7WMtDVi/Nqb9M?=
 =?us-ascii?Q?YCMxnuNf8IUt/URAMHU8cYiBeXJmJAt+pCRBjOp6IzUBc3RQnKI7oEQ4Rbhv?=
 =?us-ascii?Q?lFYfK9MFCE9SXHS6S4OdHq5MepzZLQw3/AlP113Cv+V36pwSZkRIg44fFo3P?=
 =?us-ascii?Q?S1BHji7Y0izUAU41q9qWKIiqgPQL6tMLGkehv6JzLncqCVhCJ+5r9zoYU0zA?=
 =?us-ascii?Q?qn0i2ikqhP8kPXfFRdM2CGuGgPLly+tvoKM/Zhkg/QoTIPIKkMV2focPwNh2?=
 =?us-ascii?Q?twU0jUKltMS17PW5FppA4Y64aw8KRtPBQlf0hj+1ag2R2afZY/VaVJEoQXnF?=
 =?us-ascii?Q?f/veKnn816AFRh9Y0YnsIbZBbSjRp38LVradC9yfsr9fCxCTh9+Z8A1m3O1m?=
 =?us-ascii?Q?q+LQImPiRXIqTSXfsrfRFuwHP+N7B4FC+OjIGOEz4FYWzl6JsR//r5OQV0GS?=
 =?us-ascii?Q?vBAyEKoFoMYdU+S7wlTLVDqjVYpOYDt7P+SBLJqqu3ZBUYkjefPiTbrbG9lU?=
 =?us-ascii?Q?rejhch4wMV40Vg1YNBAZJvC8PfOB6h5vz/UhHtg0?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db7e0fe-41ef-4220-57df-08db4f438853
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2023 21:39:27.1230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wN8UxlHjG57etxcZcHZ57I0RGh569eUJF94PI6/4QwHorBd9xn1ox/QM40hHZewAgbCibwYq9YFYlyyloM8YHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3479
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Sunday, May 7, 2023 4:11 AM
> To: Long Li <longli@microsoft.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>; Ajay Sharma
> <sharmaajay@microsoft.com>; Dexuan Cui <decui@microsoft.com>; KY
> Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
> Abeni <pabeni@redhat.com>; linux-rdma@vger.kernel.org; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
> enable RX coalescing
>=20
> On Fri, May 05, 2023 at 11:51:48AM -0700, longli@linuxonhyperv.com
> wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > With RX coalescing, one CQE entry can be used to indicate multiple pack=
ets
> > on the receive queue. This saves processing time and PCI bandwidth over
> > the CQ.
> >
> > Signed-off-by: Long Li <longli@microsoft.com>
> > ---
> >  drivers/infiniband/hw/mana/qp.c |  5 ++++-
> >  include/net/mana/mana.h         | 17 +++++++++++++++++
> >  2 files changed, 21 insertions(+), 1 deletion(-)
>=20
> Why didn't you change mana_cfg_vport_steering() too?

The mana_cfg_vport_steering() is for mana_en (Enthernet) driver, not the
mana_ib driver.

The changes for mana_en will be done in a separate patch together with
changes for mana_en RX code patch to support multiple packets / CQE.

Thanks,
- Haiyang


