Return-Path: <netdev+bounces-6567-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21016716F45
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCEC428130F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67BC21CE8;
	Tue, 30 May 2023 20:57:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D072E21CE0
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:57:59 +0000 (UTC)
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020025.outbound.protection.outlook.com [52.101.56.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADAEC9;
	Tue, 30 May 2023 13:57:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwzwhJru016O1/C80ailVDIKnWgjjwtDy0pOYCP7R8R5GSo9ZK/g8bf4pATABVLKDfyEJfQDpr4i0f3VU76jsAMkoO8sD69qMrZavXNzmt2L+P1ZmD+iKzbkASN9x+ysEH/osWXBQz6Tw8uWd+zwqbgq6LRyYCpmR7zdrxgmnOD0MhofoxycfPu/eOXb/hmGvpPGXFBKB/O4uvvfq0HI59Z/9Sw0XNLCRm7Z7VJNddqQsSGGtvxld//MZyRmlEyEnHYozNwAxPF69Qx6qyXog2GX7E3FdlebZk3CLuSqBwMX8K5BLAMKPmdqpqXGLMqK+0cfpt8gKxzVq8NTxd6ffQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmAdVmJ+s9xBHtzMAWJeWIqsMDJNg6FB/TQNH8GKT+0=;
 b=hD5Zbg2aR9nwXN36yF71uIsbPi3VN4YylXt8f5xtVFfL6xC8oqETDsQaQS9mZnSnRAYuRfMU0TEbpjmTibo/JEfxxF6BAT7saIUasf1xVk2CfqtFP/yKu+aUlRmoXsC2Cg1hLbwVRH8LeKEYZnoiKI4qa1+OgYWAlSZjjg4Gm3WlxknVDV1Wbmtx4mZGqT5IDrDrRaWL/jPSm487qH9zrPuh7umdTlDJf98kGKvMVE3NtXnuu1cHJ2y12PslMd8IZsndsItYWbDNFB7JqhlygAXedvQ2PCI9OgpetP6drgW47UeXAzVQ9zgs76m4z2IdNuBswES8lv7AZDgia2Acpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmAdVmJ+s9xBHtzMAWJeWIqsMDJNg6FB/TQNH8GKT+0=;
 b=N7f8SY6i36CcRD4KkaWMhL6xpz0fQaP+a3qMTEFXHNCT6Lzbilc0ATzR6Rcum9sUi9Kr5gnlegZqPxRkYS2TsfgmtW61Is30PfF8JQ096+shUknR9SWLLgdZNLDhwJQ45faR3aKpp8YX8lbDd9AyN3vDdArl4FJrajhLzjM4WRc=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by PH8PR21MB3874.namprd21.prod.outlook.com (2603:10b6:510:259::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.6; Tue, 30 May
 2023 20:57:54 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5600:ea5a:6768:1900%5]) with mapi id 15.20.6477.004; Tue, 30 May 2023
 20:57:54 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, KY Srinivasan <kys@microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li
	<longli@microsoft.com>, "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>, Steen Hegelund
	<steen.hegelund@microchip.com>, Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH v3] hv_netvsc: Allocate rx indirection table size
 dynamically
Thread-Topic: [PATCH v3] hv_netvsc: Allocate rx indirection table size
 dynamically
Thread-Index: AQHZj5er/bBY9ZTMu0KYwZ0WUJqKNK9zUsoA
Date: Tue, 30 May 2023 20:57:54 +0000
Message-ID:
 <PH7PR21MB3116EB7385703A79CB81580DCA4BA@PH7PR21MB3116.namprd21.prod.outlook.com>
References:
 <1685080949-18316-1-git-send-email-shradhagupta@linux.microsoft.com>
In-Reply-To:
 <1685080949-18316-1-git-send-email-shradhagupta@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b67308ee-b161-4093-ae93-90d3ff893b31;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-30T20:54:55Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|PH8PR21MB3874:EE_
x-ms-office365-filtering-correlation-id: f3051b16-945e-4124-bb55-08db61508a34
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 hy3gtgX2Dppvuh77P226svEpnTK4qn9yLs2gSwZQJQF45odTVAroBKle4yrZbCikdq35aj14krmVa9wna1zHsYg9ARGrWmNWxdLxn/9jO7Rm5waCtk+46MCEXZDRJZ8cmfM3c6UbnivAH8+zCrT8MXJdPoTRR7dWXxFdY5FZtNVeXlHPA3HAcnWrA9SpNwf3p5CU6fGXj3tzpbdm0b0nQqjMl+Pi3TdS+91C0PqSXm9BJKArrj54dZfe3qpQxS2SupqAj/IHfxRFujztnw2yP2tPU3rFkwlj3t+64dTROsGHzHF6eNrnlvP7oSPlz9OLLzeADvl8fbxMC/xyeTShc4oTE4QLDI++Zf5it5h5HiXopcjAGzJlbmUEcQBP+vGJfPBTJQz9RF5Whuwt1xScktViXi4h2ugpvm1z9yt6alszhFkrPAbuhTeYaBCwMQb1qsmIhrRNaW0PGocbukfZO2rlc6gUXeBkPRgBnBYl+66j3BKFi3iRicQ7e+MKhvq8ZIOcB6BiAgYjQ2WDvqvzKFEmAPLGaPFPTCiloFYNo6VE/BXY8G9ikqgcaklWVwmhxkbSL2Wd9eFJL4fLfRXU6kCt2mjb3Ioe+XjxaUuH3UvVEq++MFbbkeHyo8NdhZ2XuGQqHTZS7VUPtRWn4PrZqND6rjIRXjpCZhvfEMk87fw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199021)(2906002)(38070700005)(76116006)(41300700001)(66556008)(4326008)(64756008)(316002)(66946007)(7416002)(66446008)(8936002)(66476007)(5660300002)(33656002)(8990500004)(55016003)(86362001)(8676002)(786003)(38100700002)(82960400001)(186003)(9686003)(82950400001)(26005)(6506007)(53546011)(83380400001)(7696005)(122000001)(52536014)(10290500003)(110136005)(478600001)(71200400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UHl/FaInTqBUJxX+JmFp4lOFm8JVI8nbuoGAdGROkoYg+gLAt828D1B622iH?=
 =?us-ascii?Q?vYirUo82bY5BI58aJnKIQBA2GvS9JN+t+GDOe94pz3ktijeMrmASqgpokA2g?=
 =?us-ascii?Q?MpBhCtVxkGwCUxv2ZNU5YfJhVmStUlN6+x7mFU+iqLuWzm3oZtIMVBHnwR3L?=
 =?us-ascii?Q?RiIIcfqrnkiLc6wZlx+tB28qpTomfEy2l82Lj9fdovqHW25+MZLRIXOvTZZ5?=
 =?us-ascii?Q?zAm6dQEYF+6Gi1l2n0GmKkwjy+nWlrVafLAxASgW87/GQhSeXpWncIyYYqXF?=
 =?us-ascii?Q?a9qpdT+5lXHFrtLuAMMXSc6bnHtvHiPVaz3t3V0vneaTulZQhPVDz1XgMLpq?=
 =?us-ascii?Q?9XvmxM6alXYH6iilh6cHzT68goiaegdU9UOVCRVGV2LvS+/qeDW+xpgu8JCE?=
 =?us-ascii?Q?dNGiO2NACpU4sibUpMnHDyrAPPM3m7Xfx0vo4fhsS6IGQgrH880L//6pdMIR?=
 =?us-ascii?Q?gKb+H93TFunYCYHsnP9EfVMswFqxRsqlaUSOtNyLVonJGFVDb5mCAEwG28p1?=
 =?us-ascii?Q?Nild+ohcgBDkQLZknXdZbpwhEwIYTCRF9Km66n2px/yyxmldH75dsUcssGnd?=
 =?us-ascii?Q?5uJub+Jqd/qsMccWmGCnFTfCzf8a/oL0JWJWlLnG4YSKcX3oTVaqlthpILd1?=
 =?us-ascii?Q?MxII2Pfmzb/aL/B/48X0gqoYCvMl0726lGwKnPVgnKgCezkX1oek5ztErLjJ?=
 =?us-ascii?Q?XGyUYCPX3k5IaQ81pcu1saYM3hHReJB+GB/IfqIuHDvTcDF1QvnYJ/8G/L54?=
 =?us-ascii?Q?diUUgzj8FnWquMXJdbbiG6ka5rfkURunXplk68oJKkctVESN6Xb5nRkj3D0H?=
 =?us-ascii?Q?4TiLu32E4Bx22SmNex8tON/E3BC7riMYqlhOnKp9Mr9Q3U/ifCoPre1DYl82?=
 =?us-ascii?Q?MbT8ibui72mcbZHq4dhWR8nwwHHb7VY6gdbQvrAOaMX/FzPnrA7U0Tvy+JzD?=
 =?us-ascii?Q?+XD/Anfzv5kvIoqChSof0GsNUR67cD7ttVhm7v6nkONtIXJRYSCWZPiKcdiS?=
 =?us-ascii?Q?UJ2Ozk22nD4br8MijfBwb3vFVolx4Gj597H8L1GxZHBpadsXAewV5BxOAA7k?=
 =?us-ascii?Q?qtWcjtTLgcWAvIDchQrONmzCCKnVpqyVphgJ4CVKngp9b9Fdm5Cu+nUS0j/N?=
 =?us-ascii?Q?QoqlXDfyOCX9NVGxJquUDwmITdsp1P8LS8VCu0lohJtjsF6LVBOxbjLQb5oy?=
 =?us-ascii?Q?y71rNfKWTdz51GhEH/6S6Y5PjohKrMLSuZwHC/OZ54zwNIBJ2fhJdouHiWP7?=
 =?us-ascii?Q?4QzbzeJiCMpW5MNAgZIkzR1hSNcAii8ZHHkjwQsDOviJfYYwHMHmFe1bHK1G?=
 =?us-ascii?Q?Oi3rduHWgBOFIsGm+OQc35oI52MtNHQtmZBPFDVnM1dKLF7TjqcoNO5NDitv?=
 =?us-ascii?Q?pUnQdCfk6r1pMUUA822RQa9XFJPC0QdD4dV5yvL9U01GBx6Zve0AE0jm4DL0?=
 =?us-ascii?Q?tRmWPdsgPwXIOCJ2OThlzVzMsQf7VFOkSS0BqVp9srh/WMAwoRsJQ2maARr9?=
 =?us-ascii?Q?GulgbbdyA32snrzkO9jkaLb2mBNfIafZ8sRyA/85OM2GTEmCfz6s03e2wHj9?=
 =?us-ascii?Q?gt9zR2paGvZvOkaPpX4q4CqxxWlLF6PWKzjIBrFI?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f3051b16-945e-4124-bb55-08db61508a34
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 20:57:54.6657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M85l0+apjICiYcfDvlzDoHLlN6YW7Y7mMlBwNys3mRq4OPhDjpcjRw8YhE4tNDGk+rz7u9UjF8Tb4lqmVP9faw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR21MB3874
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Shradha Gupta <shradhagupta@linux.microsoft.com>
> Sent: Friday, May 26, 2023 2:02 AM
> To: linux-kernel@vger.kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Cc: Shradha Gupta <shradhagupta@linux.microsoft.com>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; Long Li <longli@microsoft.com>; Michael Kelley
> (LINUX) <mikelley@microsoft.com>; David S. Miller <davem@davemloft.net>;
> Steen Hegelund <steen.hegelund@microchip.com>; Simon Horman
> <simon.horman@corigine.com>
> Subject: [PATCH v3] hv_netvsc: Allocate rx indirection table size dynamic=
ally
>=20
> Allocate the size of rx indirection table dynamically in netvsc
> from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> query instead of using a constant value of ITAB_NUM.
>=20
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> Tested-on: Ubuntu22 (azure VM, SKU size: Standard_F72s_v2)
> Testcases:
> 1. ethtool -x eth0 output
> 2. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-
> NTTTCP-Synthetic
> 3. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-
> NTTTCP-SRIOV

Thank you!

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>



