Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE104568903
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbiGFNJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbiGFNJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:09:13 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F251A064
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 06:09:13 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266Ba56s030505;
        Wed, 6 Jul 2022 06:09:11 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h4yvr28sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:09:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gl5hRccSQW7s0isb8Gry33vxMnMVdol0cCxZhhbLPqUEj6JwUeKdcoX7W650nPwiBkDStRhUh8psTZDsd2PHEk6SnLF+zmHG7iAIxXuOcHjjbYa5NZOOjJDeZej34d52QP74vZs6TvGXTEybaXTjNLpQog7DJ3WZjVVWxKZlvgT8ZhYbGN1OLIpa4wPvFTLhGDSY6BEGbwSsmZRDQvJ/vlrwvz+PiK0cC7hXtr+IICQmv6WN+PApJ9jZPmLxPDrZvDKjtwjzOZPULpnq+fguuW++TxF/NVSr7aqvWK5b2opxiyf1QXGd+mof217Od35b7ngqFxLqtSvls2Ge0awN2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ttA4t/WtSy+dis7eNb2ySssl+kO7ZUxU/lna7Sjed4=;
 b=JZ/C8IY6uKUyzKCYPmd+VZFKrLjs+IP16df4RknnIbGhp8S9QHpME/2VtfSNUtwDEGf60hiEgm/bN3XKQVHxvZOfDwygTQCol3oYUXUqmuCiAEg6n7doDPi+tnEXWj7G0I8YpSFHATZoPWSp1igLva2JLdEUwHmoDhGWU4CdGSFrVzujr2crao3cIV6VB8DbyoIJpSM/R+xO/DB68Sx/f6XwIsc+KANpb1tt5r0FjZRihKhfgodYD7Sg7kG0xhnGAYUrltbCv2NQZMlOLOBPR24BGW/M38Yl/YvSfqVpKB2YIKS/n/TSamGjJdEVAvSjytrxAVIfDEGsYnVkoqUqyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ttA4t/WtSy+dis7eNb2ySssl+kO7ZUxU/lna7Sjed4=;
 b=dOt/TEmJQiEVePAsh5otIZZ29IvmllKAyC7vm+QhgJbB/tJ4WgtOdo03BtGVvjgS+NjziSDJnvp0g+x3vKqsgWTgZanhon1YpLhdxqIYTVg5i/Ca+OdnZMgP2PW4s0KMpmbNGDvuAoqztUq3SYJxHopU4ZEFaPF9dANE3+MUXbc=
Received: from CY4PR1801MB1911.namprd18.prod.outlook.com
 (2603:10b6:910:7b::20) by SA1PR18MB4774.namprd18.prod.outlook.com
 (2603:10b6:806:1dd::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 13:09:08 +0000
Received: from CY4PR1801MB1911.namprd18.prod.outlook.com
 ([fe80::cdd2:82:892c:8b3d]) by CY4PR1801MB1911.namprd18.prod.outlook.com
 ([fe80::cdd2:82:892c:8b3d%2]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 13:09:08 +0000
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     kernel test robot <lkp@intel.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [net-next:master 9/16]
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1080:14: warning:
 variable 'rc' set but not used
Thread-Topic: [EXT] [net-next:master 9/16]
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1080:14: warning:
 variable 'rc' set but not used
Thread-Index: AQHYkSmjbu+aSbqjDE6Fk2nEvLXJu61xUAmQ
Date:   Wed, 6 Jul 2022 13:09:08 +0000
Message-ID: <CY4PR1801MB1911DA4C9A06B835B3EF46A2D3809@CY4PR1801MB1911.namprd18.prod.outlook.com>
References: <202207061918.lo2TMG5P-lkp@intel.com>
In-Reply-To: <202207061918.lo2TMG5P-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1110f46e-0109-45f5-73dd-08da5f50b62f
x-ms-traffictypediagnostic: SA1PR18MB4774:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gg4BV6QHLaRmWjX22N7aZNLcqXmHlAOIBQALzQTNemBy7hQga9M7VcExTfSnmNKMTOqv38iJZabyFz2kuc1WgWVtISojKHWIRki6exKolDZphcYUvg8no/i5m4EuZZ/PThepPVDX+tefpwWrGGl1MGdoyHeejMWCyq3cZ4Oxz2en96bN9wOUMVohFiw8wPLQWIgt46BixwWvH0vIadmOEjsk8U1qBmzHMxRgbaZI6BOQPvBDScQitQ0O/9EyC7KaPfaf7lJlRbFmO3/LP5GTG4z4LTdIsgsmHIjm+1GEPiXN5tyikv8ICYDl5GcOYC2kWaOPBVf45pH3l+mPzCi5SyZC8PqNDkjCEGBFhzP1NasG+St9fakam86Ia4GR2iP9yRMReCKGINGE+bPeO/pEHj/dZX4KaWsE+m6TMDdMCKInEBZei89W/tOJFknHdS/PbYrzXGo7NbLlajTsbtbVZLOJlBKu6B6eBn9o3rppnhNvjRSePuhEKDl2PnQVRpd/NhCeOfYhziwYteY4UAU2qswxNJsya0OvVaojRDWDSOtMdh6NmZ83Dc9zn1mreW/wYlWQ4n5jTaFb2B14tSXuit6crFjE5e+HLSVC/0rHKZdABawxKNluE1dZeNcSx4P17adpJWoUo468gacnQgehfEJLFlOgubgaTdT7Kug/OzoIsPFEIDO5zGYKDeA1sEPMSjlJyxI6fyQrwsCpbCy+8f/3DFuLTTZDouWfQg8Ei5r9WptaOl4Ygjj7YK/ECbAGQuVnnPc8MadrrxoBNsCOk08r0mdj3R/yoc/wnniurogtfD3+KrsLukua9CZy3ptUEhrUsduCQY/O6XYJCm1EKI1Kdjz5XRWZt3Dd+L95zRI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1801MB1911.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(8936002)(966005)(86362001)(478600001)(52536014)(5660300002)(83380400001)(4744005)(186003)(6916009)(316002)(55016003)(54906003)(9686003)(38070700005)(2906002)(26005)(6506007)(38100700002)(122000001)(41300700001)(53546011)(66946007)(76116006)(4326008)(8676002)(7696005)(66446008)(66556008)(66476007)(64756008)(33656002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3YY/U9khenL+L4qV6dRMT8y0c/Qn1xKtgXTfjnY7XZ9GGciglb1hUQ4XwOxR?=
 =?us-ascii?Q?ALiDNf4D0MPV0BGEZ1523DLVJaq2OvG4osT86KcnHctT/5u6toFsfBqHpThD?=
 =?us-ascii?Q?CimMORBlye2cEJk08FBbWvj2B6EMCUFxqROBgiMKl0F5HRzSG6fYGQXiDzLI?=
 =?us-ascii?Q?94NOYaRidAIligE8N44TlUUQD5L94c9ahB501+5LqEdAvUj/32tj73kTCR53?=
 =?us-ascii?Q?1vrqyMvKckISpJ1diPk3zi36EjD19ChWlQrRrpEfdVGFf6XaUx/TI3DpVoTM?=
 =?us-ascii?Q?v4nEv1LuQIxQirVx40SglVZX3SqcGJAOXeexy07ifppMkoxCT4f8pEKhwYgr?=
 =?us-ascii?Q?0mNSkoETFV8gJux4swFi6irx0BVV7K+VVuR98dDRx3zoti1uJoJ/XoFeH/+L?=
 =?us-ascii?Q?vjYahB+r2Mjw6P+1SKm80y0yFOWLQnH7OsMB/v8RLzBeCJT/C9vTLoq6ofEK?=
 =?us-ascii?Q?H1lOXsrxTeoIMyCi1A1I8TyptsYn9Ak3/tPYfdI+JLEnZOFnxhi9TikRxeXe?=
 =?us-ascii?Q?iHFRAwM7HfCqNYtMU3eLwkFmIsqP/bgtTqY+W0hXXYxJrIoECL+NcaTZDpMO?=
 =?us-ascii?Q?kZ++wZ2yzMZOsQ1FhxbgmQWaRZvUS25sckPAevHFxtO2TrZ5pUPUe2Oxvr++?=
 =?us-ascii?Q?tzSnXxUyEnTQZ27w/Ey2aDpwzzhSXswRjvFkGvG9YI+UjxHUPKF2Z/lnGRTo?=
 =?us-ascii?Q?xOctp0HHHNlKACxxGsdQ1r3l0mIJAgjx400cKaMdlUK2uCsATdGVPweIHZpp?=
 =?us-ascii?Q?d0zAYmafs4ofrkUOU4BD9ifdwYRmvXJHz60LY5kNhRTTtC8jcDV6TFqfSSTH?=
 =?us-ascii?Q?KplGQqYa/Deuh2QjqWxQ+ROXDK7zY3GHHNOA2lxiVBzOvZikVDNpspEpU6MT?=
 =?us-ascii?Q?6Dzfmp18LZiy/nb7OXvRIcvgLXetzAhTlqiIzVa833XI6S5V6qCkeH1lI3IJ?=
 =?us-ascii?Q?UVk1ZZaOuOnWE2HKnkR3gQ1cA1CF3pRcYaj+VLQo+bVQEAAk5V3KvhLbAYQ/?=
 =?us-ascii?Q?foVczhKNQdl0fHmCfcXU/J2z6u8LjaxE8aMDAiieW/9hyL5gB97lRFJfU1eU?=
 =?us-ascii?Q?olWS6hFMY//N1mZjZ/tOcMlEM4dRHxwIDs7lBtL22m3qaFqszvkpnYmmmo4A?=
 =?us-ascii?Q?gN9s0tm19C5SC1Ih1UJXOENtlt9DRFhwfysNjoaRnLF2GW00shXPjIlrOjZA?=
 =?us-ascii?Q?qIY53Y13gId4SazFxyVuWcajLfhKwIGI+5jyo7qUn9z0uBF5y9fjpqwesa93?=
 =?us-ascii?Q?WYSjfziQKenZ23IDFjoXufkhFHTktGP3ZwEYqKibrBj9u4i+2G6uVV4P+EwA?=
 =?us-ascii?Q?vWn9vinE8uZ1vXHfV6iYXNJENFbuTx4jVqh4QMcCjybLXdvT3MeG6LgyqTou?=
 =?us-ascii?Q?5i9U+NhjXPQLA5Bkp5eUbL7FTu+etzAdh8FnYy8Tj/UyPezu3FuViAide0QM?=
 =?us-ascii?Q?VwfYPLp5jitnlVz4YwllE+o+rTTPHLzSU7tcYj0ZfpXHzgpafpklzHEhDHMs?=
 =?us-ascii?Q?ANnySQG5DAtSlxFmhDPvdUSzpLdWaDw+NwVV4oSsk0Ou96Y9wwntRyHLPpAI?=
 =?us-ascii?Q?wMHZ1cBKuhzHydGaYUv2xVYczLR5IfldiQxVkQ/h?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1801MB1911.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1110f46e-0109-45f5-73dd-08da5f50b62f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 13:09:08.4463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9aGEwj0+hnQlGv1szD65XfFta0lV3HcRGrgcf18EgM9Wk7+Eculte1/sCPu0mlvDjDtDxIZkWIA8pvR00OBgKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB4774
X-Proofpoint-GUID: 9xjFSWUn1ZgSX4iSq__TWpvGszchL30M
X-Proofpoint-ORIG-GUID: 9xjFSWUn1ZgSX4iSq__TWpvGszchL30M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: kernel test robot <lkp@intel.com>=20
Sent: Wednesday, July 6, 2022 4:44 PM
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: kbuild-all@lists.01.org; netdev@vger.kernel.org
Subject: [EXT] [net-next:master 9/16] drivers/net/ethernet/marvell/octeontx=
2/af/rvu_npc_hash.c:1080:14: warning: variable 'rc' set but not used

Compiler warning fixes pushed for upstream review. =20

Please review.
https://lore.kernel.org/netdev/20220706130241.2452196-1-rkannoth@marvell.co=
m/T/#u=20
