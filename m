Return-Path: <netdev+bounces-9056-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 806DB726D6C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:41:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9A9F1C20EC0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3BA34459;
	Wed,  7 Jun 2023 20:41:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B4F28C1D;
	Wed,  7 Jun 2023 20:41:51 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020027.outbound.protection.outlook.com [52.101.61.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33851FF0;
	Wed,  7 Jun 2023 13:41:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1oCQvWXZ0E7fm6Hj93yiDUmP3YstV20q9jsZZqLxBod0do5Nuw3Wy9OPyQCMAtUfRJ6fP+0vMOvUbbocZFWfWNcZOSn7HX45ZujMjVEI3JBN/TfJWB/chU6B2+QqAaJJIRZe1RbIvHO/871J6wfn5RF+ZWLJpYOELf2TvO8/uyhdZOT1cHUZkmVjKZcSHyauq7rCxLY/wWDETDeqtX9xR+m+wMl4QgLwH9zqEVMsYmzs2XU/wgxkk4R3f7/aVPHrpzW79eWcZLrAvdlI41tmBuLRFBkE2icA0mwHqrAYzeyCGN2Eapr1F66MqDhuCClKFemNQfGOFpEzDVzbkuvBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CsZCx65f8xxi0YLc5Mr75GnsJpUKyOi2A7hDGMMkEDc=;
 b=MHdqFq5yL6z0fCrBjxusMdsuAaTU1OvMgGNagv/xEpz+d47ZY4j7wwVDeMNk7x1o0gYAhUXZCAA10jBR0reMJbErXSO4Bov/6gVjHfH7AGYNAFZJA6bdsjNJh6Xo6mnULpycsu+MyDaiNVVfaCNYgDklVOj5YwdJ84Cf531ofbIa/RR7ufpte53aXTL1GuisXRawlOUNnmLJauMcR9lbPPk4hHOk45qm+XfFW3S01laOrYdk/9TafWGL8Ic9OnPZAfTJJ3VKgME38ZUqPdtUAnBB4ehkZ3ogXC/6mVF7q1utkWhRHqor/QWEMhsuwDJKdL4X+D1nZfaqPJ3wOT3r+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsZCx65f8xxi0YLc5Mr75GnsJpUKyOi2A7hDGMMkEDc=;
 b=icpGM6FlCtED0KGvw4ZPaI7QlAu9pPo9s7kww5FHMk1RCrDWdRJMcD+ap97vFRvS8fm3ybUyLSWUZhEciWFt0syub8VwqFcmaU1XoivZcP30f5GlUZmGO4SLVXG4w1Q+Truk9KRv6jFFcuME+0SXKo2205iiAwIcQgN/DJd0d6w=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by MN0PR21MB3219.namprd21.prod.outlook.com (2603:10b6:208:37c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.12; Wed, 7 Jun
 2023 20:41:44 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900%5]) with mapi id 15.20.6500.000; Wed, 7 Jun 2023
 20:41:44 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Dexuan Cui
	<decui@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Paul Rosswurm
	<paulros@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "leon@kernel.org" <leon@kernel.org>, Long Li
	<longli@microsoft.com>, "ssengar@linux.microsoft.com"
	<ssengar@linux.microsoft.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>, Ajay Sharma
	<sharmaajay@microsoft.com>, "hawk@kernel.org" <hawk@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next,V2] net: mana: Add support for vlan tagging
Thread-Topic: [PATCH net-next,V2] net: mana: Add support for vlan tagging
Thread-Index: AQHZmX92yIuAi0G4h0mxUi5NN4QwlK9/zOyAgAAAs5A=
Date: Wed, 7 Jun 2023 20:41:44 +0000
Message-ID:
 <PH7PR21MB31161CAAE393DF3602515B24CA53A@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1686170042-10610-1-git-send-email-haiyangz@microsoft.com>
 <20230607133805.58161672@kernel.org>
In-Reply-To: <20230607133805.58161672@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2f57be81-e8f1-4830-a966-b1eec87be3b8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-07T20:40:34Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|MN0PR21MB3219:EE_
x-ms-office365-filtering-correlation-id: 994f0637-bb60-4249-cd00-08db67979b47
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 WsY5B9rCmmxi8vyP+J+Oboj0xjHRFsnwD3wbyZCyhtc95R0Izthmawg5d8l4o3J4+rCLkuLJ6uE+5O/IQfgIlCuWXaYnjv9kroXX5NauxxNBrFwX8eIkqA75V3c49NHdWKVWVweYgCtiRiy8XIDYpKWarsDAzzFcIIQzmD0JfWRm346nDPrNBXYLddguRBSFRTHvD5YtPmBF3ijkydA4cTaLXSjyA05RBFTnAkAhDRRqdnBaFvbPvxzzGq3YjJpKvinfMi0cHMpq8q1hP8ARUb/coEktLT8ko0KoPyWrHI4FegUgwgoIvBDMaGutgpyKUAs4zpbxnB3TNMHMmbH6jgA4O8N6vX7lWamHpTaosGTyrONWh1qUYEyE1dHnKbNfVGDSDEVeRv1X1rH7U9WPUtYGI+PGNcEYSFknk0yCwUZ3lAfhB+UkOI0q+HbWjSHFXuVAb3SuF8MB5UDQpEZufVZYsjs8Ku274G360xruC0e9YLLQ+iGMgam/18buNOLfisZrQsWrDwZPlHtHqrZ7AaVkLN//7WuyxJTeqbHuwM2oyvSLG3q+Wzw8v91dYm89Ij72Z23J3w2DpcKaX+nsQNlbt+mpqOwhvs/qLoxvk8nroVadNEEDuwLyavv6qHDe7M/BX/9kVzMYm74wdqUO8ttrEGORyXVQZVx9Q24Vxa4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(7416002)(64756008)(5660300002)(38070700005)(8936002)(8676002)(4326008)(2906002)(52536014)(6916009)(38100700002)(82950400001)(316002)(122000001)(66946007)(76116006)(66556008)(86362001)(66446008)(66476007)(82960400001)(8990500004)(41300700001)(54906003)(10290500003)(33656002)(478600001)(71200400001)(53546011)(9686003)(6506007)(83380400001)(7696005)(55016003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Zc79y3tLshB8kq6ED8PGWupKeDs1dNAgDHbuVaTwfNWV+QgLnZRUBF3MVPsw?=
 =?us-ascii?Q?j1vJ5LN8uGY/VYL2jaQYVUhrUMg3B/e891szEozaljDsbreUHl0+MyyZ3AqA?=
 =?us-ascii?Q?il2TFjb7QjRAu2cdlUwaQJCj4nJV3jXgU8fWtVZ1mSJInNDcIIUbo5dD/2nT?=
 =?us-ascii?Q?Jyhdwf5empgCQv+f7W10JTXrsqXlk6K+z7onQUXV+TDJ/DI6WFBcFAIC+gQM?=
 =?us-ascii?Q?ifQ4PCUOTFWB8kc9LkN2Drvz6WTu1pCEZSMWml9NsT6RhxWSq9z3eRcPscMd?=
 =?us-ascii?Q?VIbE0knYbEnrewgf/UZqvM9JRnZ+uqmIiU5BiiyKiTQ++q9irp7XEkt5aYPu?=
 =?us-ascii?Q?x3+R//ECD4euJXyeA/OJ9xNSxzn2sr1VhvsPRODEK7fLWWXWCpifaXF3AcI8?=
 =?us-ascii?Q?6PVy0abg1+eMuCnOzmmRPGA3f7US1jUZiJZK2YNAwRZFtQfc6fMZn756IvBh?=
 =?us-ascii?Q?30TGwrbE22SpM4dL0LH5WG7EaAtsXjK1jkoM212A+aDs+g2YOgiAUWC/mI83?=
 =?us-ascii?Q?0sqkAHmgeWdmKTWmPi1NnZmYFqPEslO2N+twerDzPZI8dwjZ2WT2rFFqs8CH?=
 =?us-ascii?Q?kqslBxN0nrQV3n6pZabIi8TsOVrAP7kbqP9FJoILiTHjTLPnKJBBDL7m5lcz?=
 =?us-ascii?Q?26Uljbdsd75SQG/q+CN/MBeVWTBhoT2+b4gZ/AbuLDsuBHwxzbx83hYdJUo8?=
 =?us-ascii?Q?bEoaXHRcT0N3VYu+IHQwnpys4ljxD38Ujs4XxFQbC+ussrzN8oHMEMRPqDuZ?=
 =?us-ascii?Q?gPfCO2+Q8S0zIWAByHVpqenh7yrN0Itf04l56V0w2TCbseUOpUoE+MQbATO6?=
 =?us-ascii?Q?fiRK4nqzJP4p6X+YB33T6U391YXNOCLkVn221iPg8Up3j3T5BSAOJOrN4xRs?=
 =?us-ascii?Q?sQ5NTehBhVWGiU0lv1n0ZshNZ3bfdxKmKL/70wQqBxlu96+Diwg/0sNmo/KJ?=
 =?us-ascii?Q?QtOu4FoZPry+Yc9tu9Y058/4GWnOXHHkxQEBRpCCydCl+Hq9/qk2X6evBuBR?=
 =?us-ascii?Q?RSatFCziTzm7+mT9aAB5WtxNfB2LPmi2U4Yt58v+ycBd0Z+CG/IKOlXQLE2W?=
 =?us-ascii?Q?SFLnbjB/pBxzHtguRw8gxbq3ShD7rLsRhiRopvxsXD/aORP4qyORM//ikJvQ?=
 =?us-ascii?Q?YcF2kjegAq+CbIsp0+mIG7MSch9SMDPsnZbtGP8a7JjrhUl7FJ9YynC1BW8b?=
 =?us-ascii?Q?LN7ocVOcxPFEEc2UWOsSQFhGHkHY275UrIwYR1Eu/tdD4XPDnh0YJGaBNJg6?=
 =?us-ascii?Q?GEYock34wWIs2P/BcNKYLDRtqAVvDTb6/UqtIf0ptBADKfAaxOwaTXZgmIjT?=
 =?us-ascii?Q?+Agt6mOUuhdbb8eiabSMnrb+JcA44G4vE9YtrKKspjxw8jsS0gS3f6l58N01?=
 =?us-ascii?Q?ZKKcVP1KQsVJEZfGFSWCKTTTy8bwayfv2wgb/dxIU2mBQXDOmG7rYXaM/izv?=
 =?us-ascii?Q?ERzS/LX0AhocICIp+zP3kaK/6QT+XVyEqZMGeFVJ0KCLZRsosbHYwaXsWCid?=
 =?us-ascii?Q?J0jrQNNGgqb+makH5Pw52qtyqq/DjKHXDEWKSZP9ev5chlEeQBU6IU+gMIyQ?=
 =?us-ascii?Q?MV/Am1WVEVtGNBmVItNgUfG8VUYaDr1CneGlddSqNLpVHtL3EthOQQHmPSs6?=
 =?us-ascii?Q?IB0lEWOg8Drs0UB6bHP2e3haQ9T9QxbWrfoTAYasa9X5?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 994f0637-bb60-4249-cd00-08db67979b47
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 20:41:44.5393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 61iDldTP9vTp/IYdAKVx07SmdAsodQDszMIAzOuiI9UxLYxlRiKkUykpivrSx7c6ShnTfFziwEcAobndT1cr9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3219
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, June 7, 2023 4:38 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> pabeni@redhat.com; leon@kernel.org; Long Li <longli@microsoft.com>;
> ssengar@linux.microsoft.com; linux-rdma@vger.kernel.org;
> daniel@iogearbox.net; john.fastabend@gmail.com; bpf@vger.kernel.org;
> ast@kernel.org; Ajay Sharma <sharmaajay@microsoft.com>;
> hawk@kernel.org; tglx@linutronix.de; shradhagupta@linux.microsoft.com;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next,V2] net: mana: Add support for vlan tagging
>=20
> On Wed,  7 Jun 2023 13:34:02 -0700 Haiyang Zhang wrote:
> > To support vlan, use MANA_LONG_PKT_FMT if vlan tag is present in TX
> > skb. Then extract the vlan tag from the skb struct, and save it to
> > tx_oob for the NIC to transmit. For vlan tags on the payload, they
> > are accepted by the NIC too.
> >
> > For RX, extract the vlan tag from CQE and put it into skb.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> > V2:
> > Removed the code that extracts inband tag, because our NIC accepts
> > inband tags too.
>=20
> Please don't rush multiple versions, if your previous version is buggy
> you have to reply to it saying so and then wait before posting v2.

Will do. Thanks.


