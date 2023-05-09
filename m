Return-Path: <netdev+bounces-1036-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B8776FBEB9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C92C1C20AD9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 05:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B362109;
	Tue,  9 May 2023 05:30:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2DC191
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:30:24 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732949028
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 22:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daAvYpEFwHBd7bYy9PpQ8XdA70d7SESJRzFvX82EjtI744nc/0L1kMq6thihRgKTui4o467FdHo/PuPDLxGaEHGIs1XAkjihX508xpOsLzTaXtAjmQbPIyUCd5rin9GvRWaj+D/k2HEowgy9nn6OQXtDrHJ+HhSIlbPnY/Dvyp+r1r3zomy2nINWEHsBagCTH7QYKDFsqF8kT/KGpbuXeWqWuf/TNNzyBxqDkCrG9EkF9IrTnPexu7ThMbmOc+EQPaq/ybcwWsTfE9IKSMvZE9XsDj82tJ4hV2uQz5Rz0eycB7NXHgZ82hMSd2X+xP41mvReGChkV/4r3lmrNq3hyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lj+AnFLbORr8NmPQrMZFWTgqNDZI9C/hpbtckK621PM=;
 b=oQGqZBJN6ZVIkQ6wgCD2Xd8LJbLlt5yckkWCWuuHK9I4TxIoYDkENLy6IoHR/xnYiVVHI/mDr2zNhzW9KWsBwAfzu9Jtxhnp3UH1xza9TOm5CUJPlYE6Bd+fbzpRkCKuqpp5rPXwF+JItg38qsQgbQoHQQhQM94qrmiGUIqnl0qOvXt4InN+y8z6X+bNI4VYwURHMOP54VcuPTh2nZV6uc05gSRg2e8Aa9y4K1Kv1JSUOkpPLaHFtg9Vx//fawxIKkS/DUQC8CmdQta4CsYTQYq3mRxtYXWkeuBmYgR1D0fUkkh9dE1cNs4IWcE6Q7TnwRQn5HrRivwG/3CZcjabuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lj+AnFLbORr8NmPQrMZFWTgqNDZI9C/hpbtckK621PM=;
 b=FvBSxsoQCMVb4QZXG+9C7hCHRZarpQH9nDULDsD4ilU1MznuXyQTk08ZV8Uig9GQgna4n6UKfDCFzBqwNhI6/9UbKI8hn8qdxWcH32y7jQAUitcKQl+y8OWlkop28Zw7WxYasecUWF4yndvZBBgNQ6MYXl306mbxFHLYNoYzOIo=
Received: from BYAPR12MB2903.namprd12.prod.outlook.com (2603:10b6:a03:139::22)
 by IA1PR12MB6139.namprd12.prod.outlook.com (2603:10b6:208:3e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 05:30:19 +0000
Received: from BYAPR12MB2903.namprd12.prod.outlook.com
 ([fe80::a9c9:515f:968a:423]) by BYAPR12MB2903.namprd12.prod.outlook.com
 ([fe80::a9c9:515f:968a:423%6]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 05:30:19 +0000
From: "Jain, Harsh (DCG-ENG)" <h.jain@amd.com>
To: Jakub Kicinski <kuba@kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "Rangoju, Raju" <Raju.Rangoju@amd.com>,
	"S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>, "harshjain.prof@gmail.com"
	<harshjain.prof@gmail.com>, "Gangurde, Abhijit" <abhijit.gangurde@amd.com>,
	"Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>, "Agarwal, Nikhil"
	<nikhil.agarwal@amd.com>, "Reddy, tarak" <tarak.reddy@amd.com>, "Habets,
 Martin" <martin.habets@amd.com>, "Cascon, Pablo" <pablo.cascon@amd.com>,
	"Cree, Edward" <edward.cree@amd.com>
Subject: RE: [PATCH  0/6] net: ethernet: efct Add x3 ethernet driver
Thread-Topic: [PATCH  0/6] net: ethernet: efct Add x3 ethernet driver
Thread-Index: AQHZPVAVSvN+e75DxkePrQ8pRPAyPq7Ij0cAgIlb/2A=
Date: Tue, 9 May 2023 05:30:19 +0000
Message-ID:
 <BYAPR12MB29034105AFAA34E1C2A2FD7597769@BYAPR12MB2903.namprd12.prod.outlook.com>
References: <20230210130321.2898-1-h.jain@amd.com>
 <20230210112202.6a4d6b9f@kernel.org>
In-Reply-To: <20230210112202.6a4d6b9f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_ActionId=133257b2-ded0-4124-8b7f-90843cb0e37c;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_ContentBits=0;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Enabled=true;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Method=Privileged;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Name=Non-Business-AIP
 2.0;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_SetDate=2023-05-09T05:29:14Z;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB2903:EE_|IA1PR12MB6139:EE_
x-ms-office365-filtering-correlation-id: bae11554-298f-4a70-23b4-08db504e7a68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 U8ARnuGtrzKUixTwDBGRU+aShGg1j45In+jHwFzUWS5Hfvnv8+FexIGn/z8NTrUkEN+O5gwVrc27IwQdMRxarKN1QZmOY30HaEUe+E9K+dZyvTNqeU9TIk8RI8o8XIYPxZhH7xiFZ32ERt3rwE3l6uD9QhZAg6jdeiosheXh2nNKMXvOn0td80wLKF299TCn6cbpvZQkwFWb74SU27OvOB7tLzcmBKW5QOJHasNpJnd1uMd4CItEz/sMs4jJAQc7it118Rbp18hv4TZqNf971kK9sSdTfXwMnRPw2fRpk+jc7fV2J3T71sIPt2f6gj73pogbz4E/P2UkDXs3fW7Bqpg8Hl0HUstegq4Qrw4zFoS4Zi2NCagmA1Bo1DvKMCHzOQojWhPxia7kk9GiUL/pPLMyYzNTKJXqfEXpEJ9ShARc32cQuJ19A5svgj/iUqOHzyAcrX5/KcVWu9spP/Bd/i1gLnAUNuyzsD+bH+UpK/dQU3Qz3rEohjsOnXpvtv8UXX/gTihNi3hBC4/KkEBSahQc6HUPmLsHq0Q5Gayta8pyFOPylL82vIXcwiZJs0MIu//60DPenUJLOJW9zFEAZ/yBvtRAIeEdzF06ZAtB/WJRI7MxT6J23dB4wC9gdSEe
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2903.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(451199021)(66556008)(66476007)(64756008)(478600001)(4326008)(7696005)(110136005)(66946007)(76116006)(316002)(54906003)(66446008)(86362001)(33656002)(83380400001)(53546011)(26005)(9686003)(6506007)(8936002)(52536014)(41300700001)(2906002)(8676002)(55016003)(5660300002)(38070700005)(186003)(38100700002)(122000001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ybvu1RnTZdEBtWct3bGI3kr7K+vaeTLm6wW/br7ihGawr0heQ1//ahIRQ3Zx?=
 =?us-ascii?Q?hc13CNCdT7s6BlD82BEQHbeed5Iyob9XmCsgvtecdDGVo0OZIs9BE76mXp6d?=
 =?us-ascii?Q?GgBvd8RX3ZqWjaeXWyhE8mwjeay2jVWkX+LR/6/sliyRhYAZrLFxskof/MHH?=
 =?us-ascii?Q?EACChiWNfZqEY9w46aP/56eTWNYOl8CJS4FHFb1BSABK2QS4DTnbVVplzlaw?=
 =?us-ascii?Q?h1fd1oa2IW2DNamX5A2NKPoDkHKbdoNt0e/l+wkxl1H9YYI1ajXoFn0D+jMz?=
 =?us-ascii?Q?GqMLD7G3303xsXV73uGkhvlIg8YYpo5Q3O6NmcLCswAeWhe3OAE4rXArCXfO?=
 =?us-ascii?Q?2bXftihyeILzBm989sxLbqPTLObKZ/UWcKO3fGIVacebNCdfzbgrnxM4WQx3?=
 =?us-ascii?Q?o3fqBRViuanopLHzYU2/JIf5fcooQDCjFFmRuRf3Y3zqWtSFSndIwHLgVNMI?=
 =?us-ascii?Q?4KvLjGlD8Yex0UpCnkdiCAcFUfFbxs6JwBgpmGRf5zTIe/3uThAydgJp/8Sj?=
 =?us-ascii?Q?AzbginvH9VvIb+yelNeQT1eqLy3huWRbK3CCgIofuumZfncZIQcXvomzg3Iw?=
 =?us-ascii?Q?STvSGFAesSj5seOBuWUBS1xVRDCyHuf2VKmTzxr7Zk4Fd+wDNcE0EdmyHwMX?=
 =?us-ascii?Q?wrE7nt08oriBgtkstVLozSostacuiB6FUUh/bpapSCXLHtTldmcAlP6UeU/X?=
 =?us-ascii?Q?X6Qc+bLamr16WV0KNl6uyHTkCOwEncsaAQoy+X1ZPfmFiFGSZEQIZEb+Z8pN?=
 =?us-ascii?Q?frjJb70MdFK9z3kAweRVNs18snIdw4sC2XIDL3xXv5OqIfQN9iUMupNKZOON?=
 =?us-ascii?Q?YAvc6TU5FuGjTz6ihI2YjkxL067DayM2c3WUw8n71sTeb5IbW6xOsiyLleSc?=
 =?us-ascii?Q?4dW4jJ7JdONL/oxKr5p2fRXWfy9u19jZsDmNUteq65xSWPmLqEwYzCY+PPtU?=
 =?us-ascii?Q?9xYbUN/CQ6M+NUG6bbFX8e+3zlPz0c2upFkxMiOABd9uAMp+Nu6+pl58df8y?=
 =?us-ascii?Q?XJV6bsKCM6gBaLdKLX65kiWyIn6WIBYDk6SbJvg3xWn4zRHmycRD9V4O6IMo?=
 =?us-ascii?Q?7McC9IYFBeBiRQ+ccxHwr5KZiyhmGb5g/T9+2+aJYoZCLtq9qSRUyLRnEFXw?=
 =?us-ascii?Q?lQeJh3AP/dyZmRFh/lIp5KvnrzMrV677bgcLMVbaumW9oUHnsc9ZKGPlKBsB?=
 =?us-ascii?Q?XAzl5HbkP33eh/YW9fm6GS2OI2CWkBOgI82lusjuCBA29Ys6a7uzk0kgjzlD?=
 =?us-ascii?Q?t18GTqC5UTYCe8X6pDlPa9hYznzEuvEfAmcUCVOMXNNXX5lf0ZtpSYio/uLh?=
 =?us-ascii?Q?2XevPjk2bzUO7A5gm06tEwHErDFbw1FdgHpV4KeSxRT5z6BPOfLv9WNQMQql?=
 =?us-ascii?Q?B9sHBMiEKg8MSDxlTy1VKTy4e/xq0PoCENXvif+enzm2JcFuENqZ02SRk7zG?=
 =?us-ascii?Q?xJ6chOjyuv4KQK36VDxovqb6EzLprFQn757cu5MiQ8t441V8KG2GNHDillUC?=
 =?us-ascii?Q?qe8ykT2iRCjvyVuFDxEgpyPGOH3yUirnvqHrSZt//hcVZumJTw4BeQ+VXAvc?=
 =?us-ascii?Q?imvirZz54IlaO345xH8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2903.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bae11554-298f-4a70-23b4-08db504e7a68
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 05:30:19.4215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a4JdoPwB/iw8gApWMLG/NtR6MBXpkQ8YMvDL0xzxOgBgUOjLofyAVV8Zy4/Ogvtx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6139
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, February 11, 2023 12:52 AM
> To: Jain, Harsh (DCG-ENG) <h.jain@amd.com>
> Cc: davem@davemloft.net; edumazet@google.com; pabeni@redhat.com; Lendacky=
, Thomas <Thomas.Lendacky@amd.com>;
> Rangoju, Raju <Raju.Rangoju@amd.com>; S-k, Shyam-sundar <Shyam-sundar.S-k=
@amd.com>; harshjain.prof@gmail.com; Gangurde,
> Abhijit <abhijit.gangurde@amd.com>; Gupta, Puneet (DCG-ENG) <puneet.gupta=
@amd.com>; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; Reddy, tarak <tarak.reddy@amd.com>; netdev@vger=
.kernel.org
> Subject: Re: [PATCH 0/6] net: ethernet: efct Add x3 ethernet driver
>=20
>=20
>=20
> On Fri, 10 Feb 2023 18:33:15 +0530 Harsh Jain wrote:
> > This patch series adds new ethernet network driver for Alveo X3522[1].
> > X3 is a low-latency NIC with an aim to deliver the lowest possible
> > latency. It accelerates a range of diverse trading strategies
> > and financial applications.
>=20
> Please get this reviewed by people within AMD who know something
> about netdev. Ed, Martin, Alejandro, etc.. This driver seems to
> share similarities with SFC and you haven't even CCed them.
>=20
> This pile a 23kLoC has the same issues the community has been
> raising in reviews of other drivers from your organization.
> We don't have the resources to be engaging with badly behaving,
> throw-the-code-over-the-wall-open-source vendors.
Thanks Jakub,
We will review this internally and get back with a new approach.

