Return-Path: <netdev+bounces-6160-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2130714EE4
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F149F280F4B
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A9BC2D1;
	Mon, 29 May 2023 17:23:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97CABE5B
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 17:23:18 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2065.outbound.protection.outlook.com [40.107.100.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75D8BE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 10:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9ZEuCbFEWFQJ/8PyQkqn049QH7WYPy5AH/WEjd8fzCNREjIbrgYPdid0gykwXaS5htGIPBogYCqDcoPftg+FSnTPoUvLArf4GHdrJhgCitvjpzoxOAVqlYhe+ojs2bQ3Qu/Q/ByAPIyTgBRDFVyxgx3j/uqETJwcxRY+wOJ/yXgk4uyHs9z0Lpb6n4fslegzheAUEM8w0+5PtuxmCmxVSWxAQMpcjn8x9/UlZsLgncyFBIesK2VvvMM0byE9+6JwjxTS8MLjMNKCXNoUn1GNrfprvZ1IqlOJB9PoJriXWn5Av8LVbxt38Yw24yLLMCeTF+FbbTtvM0QPe3oAyLMNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCELFYwH5dsgF5Gk0PzVxGvcaR3a2DZcc2ulnv5MSLQ=;
 b=EtdlRA1xxsNvOqQBWHTO5TsDABM9LN102orx0jRo6aCPtePemIMTPliv+mUS33R/fXE/qPsh8aMti3Z5gvO18yRmpj0/MHaK85741xJZk8jqEhA+Knx+kzOrNBN/wRYBjmBSFF0fFF6rKoLEz4uGBZE6z1jH2t59dNCo871JHhr4Wp/Sa1ySYX8cOAtEEJMsl1ydRghyBiNkv3JaAc7+pmuBXGqqn/5oCYiG5zD1KLeUqviXjVhr7S8vOd7dxReS/H1A/DjOfXUwcwzVWhzcP2nND1A9lNdakPXOMWymt33LsxwJQCxO426REYKN4v1huXdGoxR2uP/mTVrnfqXyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCELFYwH5dsgF5Gk0PzVxGvcaR3a2DZcc2ulnv5MSLQ=;
 b=VqlOX6oPLJFi8jQUOLHpE3muJzHeEmTgQlLV6syCWUOStifoBXziUWul3HRongC7nS8qRsuBo2rJVNRQ+bvNdNCBJ5H/Xq2zwGHk/7R33rWSpNQNRoTfgidw/qBrPhmvm5kIB/p6+UF0aJnq4UxrI7orWRcM08VDf1b5kNT64uM=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by MN2PR14MB3342.namprd14.prod.outlook.com (2603:10b6:208:1ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 17:23:13 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::3d7d:27a2:4327:e6fa]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::3d7d:27a2:4327:e6fa%4]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 17:23:12 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: Andrew Lunn <andrew@lunn.ch>, =?iso-8859-1?Q?Marek_Beh=FAn?=
	<marek.behun@nic.cz>
CC: "f.fainelli@gmail.com" <f.fainelli@gmail.com>, "olteanv@gmail.com"
	<olteanv@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Thread-Topic: [PATCH net-next v2] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Thread-Index: AQHZkL+NHkfrw6UQ4EebLP2q0dZYnq9vaygAgAHzBwCAACBmoA==
Date: Mon, 29 May 2023 17:23:12 +0000
Message-ID:
 <BYAPR14MB291865D8A5763CFA9552774FE34A9@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230527172024.9154-1-michal.smulski@ooma.com>
 <20230528092522.47enrnrslgflovmx@kandell>
 <512cef84-b7f0-4532-86a3-6972d05ca25d@lunn.ch>
In-Reply-To: <512cef84-b7f0-4532-86a3-6972d05ca25d@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|MN2PR14MB3342:EE_
x-ms-office365-filtering-correlation-id: 38e4adfe-238a-4dc7-74e8-08db60696187
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 lDC6VyQlyzhhhYiU9KybTAJ6AvIxo1R6D5x7nUtfbJxX/U280Y3a6thqMvpOmbgSL2yKBU7umwS3HAO3DgUzTOyQmVnrCj6QSyw6/MlpnGCAPx5hZCAUm8usAh/kIeonAARZu3Sn/0HuPYT/YXB7V7cgBDhu60nH5wGAvOWw1GxHALCgs3YeKgSH6jqfGWFFslJbaG4kmegVz/7WStUvFWyd45UlB9XgEn9hTl2YeioD38VtBb7OxOm3pR6Qus665GmPXF4+4GUz+J35uE+2Gc6JViD2OgHFV7ejdpVc2F3gQ3gYSI/iQeVZfbYrC4oAbPTIEQ+0wg9EGlRziN6lJXDnCWgWQUFQVGbuJuqZodnUW6Z4vJ17ectfb/naLO/DpPd77cCLGU3OI0nfL9a8ul3WVRfbAMi2NV+bM3a6OBaNXg8mMPtplI0ogJ72/CEnSWXBue9knvFuW0yk1bjlxzSPKgcvtXeKMiQs6etXvqZxXg2rgPIjBD5nNcFFq+nppTXHepHf676BOw6OFSGIIPp2kG45eWbgJ8mQu3SP+8H7Qp7qBTQY89K2q5aQbW20lkok6yEGvxnEZrpZZiuoJ1NnNdLL2qeN9EdnN+7sXfbtIrwzGZIpziXfq6lUPNfukniQ+wNW+p+mT54pnjXBrA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(136003)(376002)(396003)(366004)(346002)(451199021)(7696005)(86362001)(41300700001)(38070700005)(55016003)(4326008)(71200400001)(316002)(33656002)(66476007)(66446008)(66556008)(64756008)(66946007)(76116006)(44832011)(52536014)(5660300002)(186003)(478600001)(2906002)(9686003)(53546011)(6506007)(26005)(83380400001)(66574015)(122000001)(8676002)(54906003)(8936002)(110136005)(38100700002)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?BnYz8wqp1TMpFIkf5UpaxBksC8OFs+xrpHeS2TRXpG9Alh6r3PXD1OUwEK?=
 =?iso-8859-1?Q?aVolCgbZTnXC5JMBpFUXd5cprWZ0CXDd++9L8rOzgf00FO9NCWMi9kjzLk?=
 =?iso-8859-1?Q?GQV3JvzCskOPf+ST0SDfv7a+8P9bWXfjuumyuN938eve35W/Lpw9N1xQgK?=
 =?iso-8859-1?Q?Kdy4o2SIE8NlVOnmxUhMJYU2I84LCQ+dFpLRXesu6fqhyXCe0u4ztb5v0k?=
 =?iso-8859-1?Q?XkOZ0YcIFUV/JsZUfMUKNtpMSYJHCzvjHR7fC89/7QtYb97jZAQZkA+f+R?=
 =?iso-8859-1?Q?AYLcad59X1v2O611eYtDV2XTd57tXHFbGyIwYDokLBdvNIKHku1I4Zec3H?=
 =?iso-8859-1?Q?banQGDUQS66oZz5UKf2rNVs057a5zGTQqvpmNMM8B98DyUGihn920JNjEk?=
 =?iso-8859-1?Q?bzonkmHo9OLMSREMaXD62XAmFB1iZZuq8A0N8bj98DN0YRvLEfD9YoAeIB?=
 =?iso-8859-1?Q?hzeWWwfDSNn1OjbaDQRGhOiwcB3ufv1Y+LdsropfrJn15PVzsoaIOdNGbs?=
 =?iso-8859-1?Q?IG11L6wsB9GXI6HUiUCREa8FAQshTWZyNXxm/rJ3hxuNhl7Kf0jIYdO1Hm?=
 =?iso-8859-1?Q?MTDfRI73uV6ZawSGGwNzPUYaD7E5OHJxCK1WojuZxRhd3qsW3hN00T9r0g?=
 =?iso-8859-1?Q?I/v6KVZqBUdW9HkI+XlIdyzUtLR7M3VohWsN7+FOKfKS3+EwqS5yvArVdH?=
 =?iso-8859-1?Q?lex2ltS4RjMPk+VppYaJU3rr8B6pX+RHVd8BjLbwzWFciODyArO1zIUwAK?=
 =?iso-8859-1?Q?5RSRRmIY/mEJMfAz2CBMikayi1Q94NP5XKSIe+1cwiDdC45WXZxTh/Mbnt?=
 =?iso-8859-1?Q?L3FChSn8PMeCo4yhwnZStSgpUmKySZbdimb0ZeGTG706ODahA8MuXjGoPt?=
 =?iso-8859-1?Q?IGdf6bYo9i3ZoG5+no4EJBmd7xe0ilDemDzgz1wirkS6jdFvySMBUZPtG/?=
 =?iso-8859-1?Q?cRyFivSGFFWkm/9KzBqQqQV2CZpfftwljDUQiEXbeNFM8AZtlseQL8xS67?=
 =?iso-8859-1?Q?6RO7erfJfzISTxWTPiXyoScHPw+XXYqdMD+UqvhhrupepHcb5BkCq+o8Ua?=
 =?iso-8859-1?Q?ciUaKMJ8HBT7lhtKo7uQLrlmEmwcENtLNJNMRH5FOmH5sDT70o7VUAEACy?=
 =?iso-8859-1?Q?EfvJykYDdFAAhzpjJu454v/2JLC6+QLcHqrxk1aZDOIqcz5mr9bGySCdhE?=
 =?iso-8859-1?Q?LwVkblH/r9K9IY9c9t+mSxmSMUAoodNrnFw1TTaSQ6Bj2munU41bcWuxmf?=
 =?iso-8859-1?Q?0uuk0c9nIUf3FXBlio8ynBc9kTVaY7WbNx85gObGbb57dNEaHMmryACS3p?=
 =?iso-8859-1?Q?hMuaJEg22XNsvxkqzjhAI12ac0jzDHt45TC5/SqG6yL9I4d7qAbHbcKJaz?=
 =?iso-8859-1?Q?Q1pshbPgGUPaz4oTBYfR43bRwoqbEVTFsRwlpB+8aYuRP+z2MxPUffn8F7?=
 =?iso-8859-1?Q?hduEhCzz7mPy96Q4FwAwbs6HdyqvV4YF8U/Y2wAr/JO8UvGBKjclB/2hNm?=
 =?iso-8859-1?Q?fIjx1+JYfFbrFUn2Zz1CcQLWKuCgdUwnV81w3aspeAMa7vkRXHZz38aTVM?=
 =?iso-8859-1?Q?nK7l7InFB9IL4skEcTRHXmBuNatASxPcqmhG9cBrreIjQO7o0bRFBpKfuK?=
 =?iso-8859-1?Q?XWj10gVrUl71TXROtwBOE9CKXJVoXk995y?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ooma.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR14MB2918.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e4adfe-238a-4dc7-74e8-08db60696187
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2023 17:23:12.6640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gVtI1PiB304DeN2lgI+FiAAYjPV+zXQvc39EGCbClgHQYBIak7llW5OnH0Q54peOiRjTMPQjdmFj3m398OV6Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR14MB3342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


If I understand this correctly, you are asking to create a function for USX=
GMII similar to:

static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip=
,
	int port, int lane, struct phylink_link_state *state)

However, the datasheet for 88e6393x chips does not document any registers f=
or USXGMII interface (as it does for SGMII). You can only see that 10G link=
 is valid by looking at MV88E6390_10G_STAT1 & MDIO_STAT1_LSTATUS which has =
already been implemented in:
static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
	int port, int lane, struct phylink_link_state *state)
The datasheet states that in USXGMII mode the link is always set to 10GBASE=
-R coding for all data rates.

From the logs, I see that that the link is configured using in-band informa=
tion. However, there is no register access in MV88E6393x that would allow t=
o either control or get status information (speed, duplex, flow control, au=
to-negotiation, etc). Most of "useful" registers are already defined in mv8=
8e6xxx/serdes.h file.

[   50.624175] mv88e6085 0x0000000008b96000:02: configuring for inband/usxg=
mii link mode
...
[  387.116463] fsl_dpaa2_eth dpni.3 eth1: configuring for inband/usxgmii li=
nk mode
[  387.132554] fsl_dpaa2_eth dpni.3 eth1: Link is Up - 10Gbps/Full - flow c=
ontrol off

If I misunderstood what is requested, please give me a bit more information=
 what I should be adding for this patch to be accepted.

Regards,
Michal

-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch>=20
Sent: Monday, May 29, 2023 8:11 AM
To: Marek Beh=FAn <marek.behun@nic.cz>
Cc: Michal Smulski <msmulski2@gmail.com>; f.fainelli@gmail.com; olteanv@gma=
il.com; netdev@vger.kernel.org; Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: implement USXGMII mod=
e for mv88e6393x

CAUTION: This email is originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.


On Sun, May 28, 2023 at 11:25:22AM +0200, Marek Beh=FAn wrote:
> You need also to implement serdes_pcs_get_state for USXGMII.
>
> Preferably by adding USXGMII relevant register constants into=20
> include/uapi/linux/mii.h, and using them to parse state register.

And if a standard is being followed here, please try to make the code as he=
lpers, so other USXGMII implementations can use them.

Thanks

        Andrew

