Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38276C6A95
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbjCWOS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjCWOSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:18:23 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2133.outbound.protection.outlook.com [40.107.114.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7795E19D;
        Thu, 23 Mar 2023 07:18:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9tLRob2Vn/Qw+bjxHK/PGtM6ybCFsdyL30F1aL/Lvj6/qEZjyhXu15rD20oi32NH9s9nKJeTanXuiKNi19sMq7DQUQ33CDh55HzgU1KRNsIM+JIBKy16cgAGg5kWHQF3X4nUQHuvVhTT6KMWT4EeutTYdsx3PSBGDPPH1gP5gx2Xop7pDkgjMucIYrDGdV6KNmF0fVl+oirllANbYLjFw9zMUQbGl/JjBvH4okWc2Undixg2De1GzKWSQQSIBICYWBCYm77z7AuaeipSL++EtBs6foAhbDs0sO2WP1SeVTBGX3npOJmZfPkBtM7Xi19ugbvUcIB+mqIZy7QRTHq7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/loPbq+kzR4pmMBA59Z+5Xn7XF1bMGvAYV1k9r0wcoM=;
 b=EJ3OCdiydfEEYY+b7LB9yRo60NuiwA+bVAW7M5H5blSZx+vElDtW63JJdlmc8MvLnSF5bljpwX4BS1ZYsPEHaW7rwGJsPVU+4t3+wMSqcB55tW+ZBg8NkgkLVAZBQJuplm6WapdjKj2TRvp4mwr9Y3CovsYVZqn9REWSMeCZOiBkNrk1L7PgKZRnylWbagy43mQdd9lFMU2tbIM4iit4bAwcVeskGZ0l8GfsFQfB3dvJ9XAXKZ10+8SidPo+/5d0VSz6oEEhv8gjwECfWw4SPJ4DRv+kXcmuXtQA0Jf1ME6DCtkKVQE9aOIjda7yBaLIjidBANijr3GWfEPyQylkDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/loPbq+kzR4pmMBA59Z+5Xn7XF1bMGvAYV1k9r0wcoM=;
 b=pej2JjU8YqobbwSR8+0mofehoDPOuzF3cIawyalEpPjzTCuKzzBXxwUqvcccD8j/mRbNDIFYJUCcEsbpS+BucngjejYpnvlHeSsDu7azY1+DQVDnDeFQmgElcGhu3vzhoIRtfW9aGj7X2f5KZWsEnrmDD3fLAJE3o2sdnhnIq/Q=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TYCPR01MB10365.jpnprd01.prod.outlook.com (2603:1096:400:241::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 14:18:16 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::24d:9af3:518d:5159]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::24d:9af3:518d:5159%6]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 14:18:16 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>, Min Li <lnimi@hotmail.com>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "lee@kernel.org" <lee@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH mfd 1/1] mfd/ptp: clockmatrix: support 32-bit address
 space
Thread-Topic: [PATCH mfd 1/1] mfd/ptp: clockmatrix: support 32-bit address
 space
Thread-Index: AQHZXCjUCj5+k/s/xkuefo+qVAurWq8HOGuAgAEsrQA=
Date:   Thu, 23 Mar 2023 14:18:16 +0000
Message-ID: <OS3PR01MB65937690235A4DF614329A96BA879@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <MW5PR03MB69323E281F1360A4F6C92838A0819@MW5PR03MB6932.namprd03.prod.outlook.com>
 <20230322125619.731912cf@kernel.org>
In-Reply-To: <20230322125619.731912cf@kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB6593:EE_|TYCPR01MB10365:EE_
x-ms-office365-filtering-correlation-id: 07e57e0d-e7b4-4e3a-2025-08db2ba971fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JbTIzTd+UsUhtcl9bPVZsjL8o8CnN7AO+wj/qnKLOE390VNwrmldg1ipy3XEAtHY1HDGim/iFss1KEXEJZBrwUXIH+MYYpkWqFDr2j7W7RZ+b5FXIcff9ykugdu+ZwIAHNui4bZA/hXACQG7AJSdS7g1GkyKtUntOZBIa2csWmGXuBHSLPIRWaXI/a1BOzx57Ek5TEuugN2eM9xiqrN5z+C3vlgHdx1Nx5aBi0XB2V1G216+Epd103y0OQeZvTo5MAHvF/F6GOs0ZT1ufzlnbZCchsHWZ3SlovwRI3O8x6X76fliFSrTn+A+mkQFo7t0Lp5j0noC0TNa9C0nnz2WUnkOOmIVSUbtXWssxXaSYmRfBMIkNR6pc6UQeldi1yLALOZV9kTQsl6Dcttw2gNbNZqLuTgkYeRVbTcJaGDGrj7zcuSE+q25+IQ416n/ObADZDF5vKrF0wINRogn7vOgOZsY4y6HmPMJixOPYsoKjUIaSF669TEaH3FBKYBBcSLV00fwPMGGsrpHhpdB8XxUuargkjhJVYL2NW45y6wRlwF0x17ZekA3GjZ1Z5XL2G9Imozk+jQmoydNCBpQjQ84mFdsvfutyV+eMkRm+N5f/YXb0O/lTh7+z/LqvOjDOtV6yznIk4kX5r3f1Ht51faDhSZ0H5EF0jDYgQuk2KMeRlGY31F2fh3yD6eiwBtP1yNQjaSl0XuDj6kyhGyZzu3WYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199018)(66556008)(66446008)(4326008)(76116006)(8676002)(66946007)(66476007)(64756008)(110136005)(54906003)(5660300002)(122000001)(41300700001)(8936002)(52536014)(26005)(6506007)(316002)(186003)(9686003)(478600001)(71200400001)(86362001)(33656002)(7696005)(55016003)(38100700002)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XcGEntPqzFLKJ4g4Qr3hhMvLgG12xgKjvcygb8mJEWKrK9XdzCOnU48KDDOZ?=
 =?us-ascii?Q?sU/eN65OltFlI5ooiT1XhSMBYy/4DZR8V/FNmwZu5XggB/B+V+BfUMkpla4D?=
 =?us-ascii?Q?rJaaT+/lYEkkFbbpJDf0Y8lymG3L6cMU6R3/espJbPyCw8S/huroODoKD4G6?=
 =?us-ascii?Q?7e/Z1xiT4jLG1QQagjQgnlWYtPjfAJpoudTQHw9XNiR/VJAXJBuHqEfoWSnL?=
 =?us-ascii?Q?KIzYeFS1SHO0fxYkvea9LkM2rwZQvdmoldlgk/16Wy6UM4DRaT40xsaKREjT?=
 =?us-ascii?Q?nvYl564j26I0uz9QbXo1zmtfDrppjuQwQ3pxCmz6YIuNUizPY5yM0aRFtVkQ?=
 =?us-ascii?Q?aCcfXXlCK2mVYf/Nqog7LEnwZzlE5f17BWcoNURJHKvZPJWCW8zPRlxuVGvY?=
 =?us-ascii?Q?kpd0hBFMB8RKfJsy12tuCUhCeo1VTB3k08Ab/CJcyxDdSnueBDOfBG9vZYhF?=
 =?us-ascii?Q?c3CQ0QLLBQjVGvWBhd022hrdhxDzIek/coK7u7mySCGiLR851xqPq7P1OHbW?=
 =?us-ascii?Q?YMH2VbzwmGtQftKDDvuNZ40K8Pn0tTfc1KRZ74ynjEILjipB2qCi9hkGwreu?=
 =?us-ascii?Q?6Bg06E58TtEPSZ0FCHBGMVPeJIr0Asa7U1y1bih8stP8bP0vVQzxK6Ys6rGR?=
 =?us-ascii?Q?UhgVnMXuxSgV9p4GUihNTUV2+SU4WV6rfy2LN2p6iUTBvn3grZxHSMgWrd4x?=
 =?us-ascii?Q?pYrBQkNpPi7QqO6l28nOwmwflE1sSgpUV9dzGEMlpQev+r03UPUvSTEv0lkr?=
 =?us-ascii?Q?51ySsnmqUvMBC/TRA9Hz4w5Okuh5BTFTvCDvX31wRCzps9ucUVHcArJw2vky?=
 =?us-ascii?Q?zdC53PpeyCdg7wS2AZfQax8fpKw8PdNQR6HL6RFLi1Jd+7Wi6PKeqg/lGkCl?=
 =?us-ascii?Q?OGuImQPJIA5KoYWxT8dGexkBQRfuUPJfkmjhIiaTN+cGtSsmq500uCe4bsdP?=
 =?us-ascii?Q?4TG3bGoMzZe+nYT8uZXocDJN5PgW1PFPOmX6s4Pv1YQIKTCagU1qh76JW7dj?=
 =?us-ascii?Q?u91dtK4BLBX4sQFSeu+nDS7zHbYodRXzgV/pSzu9cWNKK9fQnWOq0lO0oEX+?=
 =?us-ascii?Q?sEIGgepo0YqLBAFR2oAucMy86jV/HOQ6BNwclHDXLfUMUi19pOtH9vFc/Z6i?=
 =?us-ascii?Q?lrhNox8Qp/ew/+M7hWRbhPXWJtILH8bcDE/cTyk+vH9ibUudrmQF/yLBzdv4?=
 =?us-ascii?Q?AhEv/qmoDDdBH3TPk2+g+F4IToN2Gdrm0DY0C9MwXu0jBvjQoj0GqSiQaeo7?=
 =?us-ascii?Q?zPbwFvD2wDY3SiMG73IODh+FJPilCWZlvqErhkd4MAauJYjhrb0dDry2YJmb?=
 =?us-ascii?Q?8S2SrgtW/zNpXRusNaZoue1ak4HhqvcTUGxBgycvFz5nDMzbqiNVvAYA6mJ3?=
 =?us-ascii?Q?Q6Cvdw/b+B0XJzhc2+VLEpA1heQtuj9zGrxP6Wz3u4+uyOurvum6UbHGufzK?=
 =?us-ascii?Q?dme09yQknrRjThVCffcOC+9qUCO51Ut1XgtL3Dpp/C+KX2gluDs4QxvTkRAs?=
 =?us-ascii?Q?MtKVxibivEZnTffFmdBNG4JjNAVU5fmelcxpQPI+T+4x5b/s8LaYDZFuL0iA?=
 =?us-ascii?Q?m8tp9XkMDhMY5QK42xfDFM3B1V3/fAerhUVHvZwS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e57e0d-e7b4-4e3a-2025-08db2ba971fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 14:18:16.4586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PUvcugd6kzJoZjr152sMBcV6CiqyNMGk6zT1nNX9DDFuCFcIAVnJzfQeY7/ZFg1LHXUoU/T1AKwXXIePYryahw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10365
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, 21 Mar 2023 15:10:06 -0400 Min Li wrote:
> > -		buf[0] =3D (u8)(page & 0xff);
> > -		buf[1] =3D (u8)((page >> 8) & 0xff);
> > +		buf[0] =3D (u8)(page & 0xFF);
> > +		buf[1] =3D (u8)((page >> 8) & 0xFF);
>=20
> why did you decide to change from 0xff to 0xFF as part of this big change=
?
> It's unnecessary churn.

I will revert it back to 0xff

> > -		err =3D idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
> > +		err =3D idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
> >  				  &temp, sizeof(temp));
> >  		if (err)
> >  			return err;
> >
> >  		temp |=3D Q9_TO_Q8_SYNC_TRIG;
> >
> > -		err =3D idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
> > +		err =3D idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
> >  				  &temp, sizeof(temp));
> >  		if (err)
> >  			return err;
>=20
> Why are you flipping all these arguments?
> Isn't HW_Q8_CTRL_SPARE regaddr?

static inline int idtcm_write(struct idtcm *idtcm,
-			      u16 module,
+			      u32 module,
 			      u16 regaddr,
 			      u8 *buf,
 			      u16 count)

HW_Q8_CTRL_SPARE is the module and is a u32. regaddr is the offset within t=
he module.=20
They used to be both u16 but after the change, module becomes u32.

> Could you to split your patches into multiple steps to make them easier t=
o
> reivew?

I will split the change into ptp and mfd respectively.
