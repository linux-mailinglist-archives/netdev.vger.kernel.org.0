Return-Path: <netdev+bounces-243-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C4D36F64CF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 08:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 555AB280C68
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 06:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0042710FA;
	Thu,  4 May 2023 06:18:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE9B10EC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 06:18:14 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808FD198A;
	Wed,  3 May 2023 23:18:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OD6wpJj8poRY9VRgyGqnUVt6MeC8vuo9CUOA/N2AQHy8McJX6VUiiHq5t1qdXQmHmVb1JaJ9ENlDDx9U7c86K+EpfL3zL+DDov8e4AJfsAHMIp5wVqSHh2lrbVWpjFAWjEycsyPj1o0lFogFtgPf8m5fZS/2uztQDR5y+34tZ+uzHYYIl3pS15WYYGJ0JbxBbYmB/FXDIlbL3YaWnjVSLjjR6v0Ht8Xj+l0APeufWiBzOyPQdLYrkS/uDYyYlTUL4r6/hDG6HhLXQq0jBBFFHFsRtszYCERyjWEaMQs7njvStMfYEARxH1U7lij/o7eZIJ6G88LKVolP/0N2PlXXzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1XfMC2+3QY75hM6L2/QVFuodaf+prTcmOCktLIGREE=;
 b=OYsEJ1DOHvpkd+zmKSpNpKGIQ5r3XC3HPt9czATiOEuxeYDRUmvlICF7Qi5PSsxYftEN2+3KN/nVxfYG42FLYB1ykkTHb1Rx9dyT4wfWI8XIuJo9Cw+2BmODcMGu8mGvXNy5lJmXdYRrgVYIU1c01AmLgaVKeJrOfTCS3GldxdvY1YxUT1OoP3/T1TTUcIEHyyLeVDSKtT4GVQdkjlOKqLGfgo9ZvrV6nHw+D0shdpD5aFmcDu7/dayZkTzwdrm+dIBS6htrjNTCvPT1b/SrrxnE7k1xSywiJeU+NSCpGu2eQ/GhM0aaNjNN2UrwZX8sIiqsMfd5//M9tZZnyJ8eRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1XfMC2+3QY75hM6L2/QVFuodaf+prTcmOCktLIGREE=;
 b=UD3XpBOGiBm8X4dKCvJR5PTTeHLhSgo+MkhimoyVkwWSsBeCSPz31ceawmbp6bvOK9Y3uF9ghmCAl+EIojtIH5V+9huivzKypkSa8sRN2Hyn236ZNA+sfxBJhIOp990MRnyl29XEuVYRjqvI1MlPNF0alSnQGoZz1ShFbXfCIyM=
Received: from DM4PR12MB5310.namprd12.prod.outlook.com (2603:10b6:5:39e::10)
 by IA0PR12MB7627.namprd12.prod.outlook.com (2603:10b6:208:437::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Thu, 4 May
 2023 06:18:11 +0000
Received: from DM4PR12MB5310.namprd12.prod.outlook.com
 ([fe80::238f:76bc:c6c5:1ac]) by DM4PR12MB5310.namprd12.prod.outlook.com
 ([fe80::238f:76bc:c6c5:1ac%7]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 06:18:11 +0000
From: "Vyas, Devang nayanbhai" <Devangnayanbhai.Vyas@amd.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: "hkallweit1@gmail.com" <hkallweit1@gmail.com>, "linux@armlinux.org.uk"
	<linux@armlinux.org.uk>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jakub Kicinski
	<kuba@kernel.org>
Subject: RE: [PATCH] net: phy: aquantia: Add 10mbps support
Thread-Topic: [PATCH] net: phy: aquantia: Add 10mbps support
Thread-Index: AQHZeBdn9YFJNn84tUeT90/fDSGu1q89jCmAgApWsgCAAcogMA==
Date: Thu, 4 May 2023 06:18:11 +0000
Message-ID:
 <DM4PR12MB53109312920C5C666507F12B8A6D9@DM4PR12MB5310.namprd12.prod.outlook.com>
References: <20230426081612.4123059-1-devangnayanbhai.vyas@amd.com>
	<7ae81127-a2aa-4f02-8c07-b8f158e0ef83@lunn.ch>
 <20230502194654.093afb13@kernel.org>
In-Reply-To: <20230502194654.093afb13@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-05-04T06:18:07Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=b6356aa3-2527-4110-a3b3-0de993116f8e;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5310:EE_|IA0PR12MB7627:EE_
x-ms-office365-filtering-correlation-id: d957d592-f63d-4efc-251b-08db4c675607
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 YpsGDYwmixBuq6/nBdSDF7U4NQWZ0snbaZj4Dc72IDVDdNydz8ZyKocebZkwcmJYMv6tU7Z5S1m/l1LidHINVmKWOJ0dNeHwiJtoWaIhCptQhwbCb1w22rQb0M7beErn7QDp8IcHfIbnIvvBiWkcszi8lWAM3laWbWo/Fj/UPuKePg4QSnHR192XND/hC8nM4kuG6uPKYtAQ0PA9k8NT8kdQR79L5+IiIVUFngXmMumAaB5GRBL2Gw0pgUrsWn1FDqORGdSqFSQOzzmDchJe8ALInPVKayrQn9bj/wTORaKE4iyq20s1wlrpyWXtqEmpdzw3B7qng2LFxFwLkpm/MIaWQRAcUjAlofcDhadKnhRT0n9ll5o81I+EoWaefY/c6t1E6UoFhwBjBkHFIHATDva3WKP+b3Rb4V5ZMA9mgGzQqvLVh6Sfof2sLFxTS+eXXuTLWdZ+0a13emErZ/HcWCnLUwJN0KrnGAQX/fGubE7MDvyqQx9CZ3s148CXL6YLPeUVJGWj4hfuxQrK4cY1UNWT47GywZgE/BmxlkW5f4io9ZQuSf7DUrIJsViGuP/5ZyK36VmEnVsOaLT6hjzX/THQlQ3S1manrjcEo5FRS50C0/5iD75TDEdWWMD4zHNG
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5310.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199021)(55236004)(26005)(6506007)(9686003)(53546011)(186003)(83380400001)(2906002)(71200400001)(7696005)(52536014)(5660300002)(316002)(478600001)(8936002)(122000001)(86362001)(8676002)(33656002)(38100700002)(64756008)(54906003)(38070700005)(4326008)(66446008)(76116006)(66946007)(6916009)(66556008)(66476007)(41300700001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?EuuCE/okTdn71nhg1v8Ha9KUCFslw/UEpCQCdRBohANRpaoPycCrGGJQ8vLN?=
 =?us-ascii?Q?AJuhFJ8RSoH7qsxrr2UCOUSnRv3CWrff7IvRkNUStZD01gSmeBaRvecU2EYj?=
 =?us-ascii?Q?LEdZZ2Fk++3ks9et9jq5fKdNiFnSQONrb0qFh1EYp6CjqPHAaioVacJGX+pL?=
 =?us-ascii?Q?yadUEIKPAIcZL5ILaZxmZStxayiuRNQW4Vf3PDV+512yWfCmR8vqeEU3Slps?=
 =?us-ascii?Q?26bNc7npTFKCBafnZ0NYPrIPAqiCnUCY5d8/1MFCJSgS79+WFdUkr+GkGkDh?=
 =?us-ascii?Q?0dNUl3WVkMTOgTWluYCDFNNcggZRgddBW/vdnoWNKZQPAsXZOq8qWXm53NLX?=
 =?us-ascii?Q?ItnT32mgDuTPKjdSi07zIuflKRyMCHvOLjK+4/mCI8cAYe+tra2qUg61oKNt?=
 =?us-ascii?Q?aEVQc9p8kRSt1ouAVrSIYhSgMDw+8/i4nyLvJMFx8Ht9eWBEAta0x9V7Gv3i?=
 =?us-ascii?Q?Nm1uC+mKm2TZPz98IGEh9u4eHhcN8LsPzwrNksnqzis/jZchkoRRdxeWE7l3?=
 =?us-ascii?Q?v1fTPdBJep4P1RtshS2G2CFSDG/RJ6Xxl0lpWZy69C4ZTDQ/A187+LP5hIaY?=
 =?us-ascii?Q?b8C6DaNQkGkOiR58PQViankXrRFpQnfDfS1XdMVkWlc7mpG4uXxwwG1DGnsZ?=
 =?us-ascii?Q?bodY3RTNuScoBymyK7xMZJHEA/ppjZpeRwMy+iPJkJP1tKnGoaPWtGSJjgGx?=
 =?us-ascii?Q?7cvlIddhfj6Fa2vhzFg6+P3S2lrbZ6KxOYm43l2svi7qpirdpwHFZDqDY6sL?=
 =?us-ascii?Q?WI59Tldx382FoyS1WMPsA6dW+OC5wl3hFtL2SKck4u8UPq/jNmboI5RbrPjq?=
 =?us-ascii?Q?OPc3CA0KpeML5mpwk2A8qbLChgbs5Ul+L+Dmk72C43h1XbubJF68CXB/gfP6?=
 =?us-ascii?Q?xMfkUIDgWngoiyVNNGsDs5uc1EAWpL20ZVoA4+QDYUi9UFEd/6hWY41xOY/s?=
 =?us-ascii?Q?+EYX5aCUcANdYjwGT37BjOkL+bcgy0sq75WQg5Wn36irNIykItWRDoS8nsdL?=
 =?us-ascii?Q?oSIv2YQIhhdbkpCAx+id8aApyQfQYscjnguLF4t4fBEu3gvEnPKtwtEcH8wp?=
 =?us-ascii?Q?tCWd9/cxnXPPcJX3iY187qAFlu69f5zUn0+dDSQl+K8pT1pNq5k8BxjjDNPg?=
 =?us-ascii?Q?rHPDSoLW24td8WP0JOgyCyCXevY3V92e/vXnX7ZnHpJN0COvo7elgQE5LL3k?=
 =?us-ascii?Q?q2vEB1XnV++/A5r5btUGKzcOfcg3MiB/hn5QlS1GlVjP65erzu9Qm30XImIb?=
 =?us-ascii?Q?KX/bt9dL0iKq6EUa9K3CcakSpUfOsJI98bogef1oiZ/EbT9UvBFhJHToGF5L?=
 =?us-ascii?Q?BHep3ehtQEbic5qcEaV0ta8TRKoWuPfHSZTsyfdA77G9c6YbYvNz4OwTP2EN?=
 =?us-ascii?Q?OLhnT9u0YKRzQO8f/+tcpKKhVr9RHsG6gWuH+EjVsISyKBoaZ7V+C2xmP9fB?=
 =?us-ascii?Q?38Fw6TtQ0an2qcC8CTQLBo4bg+i06IjHD8SVM6wvR6nF+SR2FSkv3CqE2M/K?=
 =?us-ascii?Q?0ENSsVPfVNKsTLFYJ3H3uArfG7FMLfncROICHf4ip0+m6fiZu2ZJNz1Ge17p?=
 =?us-ascii?Q?EzTP3Ee0tHVjRNkpNRA=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5310.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d957d592-f63d-4efc-251b-08db4c675607
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2023 06:18:11.1448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eHKhega+rauPYuDPMt1ZAFwr3agnF7982CdnQSz6kz6CXp0K1d2GAOnRLD3sPYEc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7627
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[AMD Official Use Only - General]

Hi Andrew,

We are using AQR113C Marvell PHY which is CL45 based and based on below che=
ck in phy_probe() function:
        if (phydrv->features)
                linkmode_copy(phydev->supported, phydrv->features);
        else if (phydrv->get_features)
                err =3D phydrv->get_features(phydev);
        else if (phydev->is_c45)
                err =3D genphy_c45_pma_read_abilities(phydev);    -> it rea=
ds capability from PMA register where 10M bit is read-only static and value=
 is 0
        else
                err =3D genphy_read_abilities(phydev);

Based on PHY datasheet, it supports 10M and we have made the change for the=
 same and verified successfully.

Below code should set the supported field under genphy_c45_pma_read_abiliti=
es(), but as the value is 0, we have to set the 10M mode explicitly.

                linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
                                 phydev->supported,
                                 val & MDIO_PMA_EXTABLE_10BT);

Please share your inputs further.

Thanks & Regards,
Devang Vyas

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Wednesday, May 3, 2023 8:17 AM
To: Vyas, Devang nayanbhai <Devangnayanbhai.Vyas@amd.com>
Cc: Andrew Lunn <andrew@lunn.ch>; hkallweit1@gmail.com; linux@armlinux.org.=
uk; davem@davemloft.net; edumazet@google.com; pabeni@redhat.com; netdev@vge=
r.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: aquantia: Add 10mbps support

On Wed, 26 Apr 2023 14:54:01 +0200 Andrew Lunn wrote:
> On Wed, Apr 26, 2023 at 01:46:12PM +0530, Devang Vyas wrote:
> > This adds support for 10mbps speed in PHY device's "supported" field=20
> > which helps in autonegotiating 10mbps link from PHY side where PHY=20
> > supports the speed but not updated in PHY kernel framework.
>=20
> Are you saying it is not listed in BMSR that the PHY supports 10 Mbps?
> Bits BMSR_10HALF and BMSR_10FULL are not set?

I didn't see any reply to Andrew's question so dropping this from patchwork=
 for now. It feels like -next material too, so please hold off any repostin=
g until Monday.
--
pw-bot: defer

