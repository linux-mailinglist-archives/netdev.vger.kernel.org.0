Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B8E6CA842
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjC0Oyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjC0Oyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:54:46 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2096.outbound.protection.outlook.com [40.107.114.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23F01718;
        Mon, 27 Mar 2023 07:54:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJllfvlIIqGnksyHbnx92npnJUmuALjS4PJ6ofgdwXPkPk7KxQHbHpMfoYFWZ9Vl0OQSzp2sdQziX9nDIssotshQEeRXWmx+cNsl3lTCP33Te/A9ecLAi16qIdd5FJTGcWCkJ7gn1T8PfviYJSqkuHq5x+W/eL6Xv77hOVlemsT9/4ZrJkEsh1yOW1Ypsl2KocaxodlAYGn7yFQcKQpDLXf9m3jM5KCo/IMsq650LIogQygiU0UFq08yYfbpHzCtfjvd6YLNUBjsRUXQvl/FhhI4MJdIMT/mMdmiUdHpyIWsMIyulhjcQcR81C2r155Dh3si2+b4lpuTuegVNfMLKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYxq00AZ2DOL58guT/tLLB9jPhzZz0p3qsXtTqA5sus=;
 b=dJlsB+kkPpqjUc6HZZCL9RE1/9ba1+j5NcZKXv5jtre5Yd8I/eMcVqfVbYut+nGLJ2e/vCEMdpIuewR2zNDGaCx+9g006D9YMyCEmGsCp2Squ8p0sYYeNwgbJkddfck7QXjOA/Zvmj1AIfbGRUSq084kL99/AGKc0ItqzeGt+kkKhE75Jl0TGUQ2tA2Vb9qRmr/mczPWchEwZERWQ6RQMSO+u+JXbkWmpnPgYUfOdK76KI83POFrrlOeNFfwau+BWDKRrxJJSrcnSdseNVesDPyDOCzPSkgndZ6JYJukj3y2hcFk+QpIArahrHJmzTjSnG5I1RNLEmjKk4QP4H+SGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYxq00AZ2DOL58guT/tLLB9jPhzZz0p3qsXtTqA5sus=;
 b=GXUYS78ux6RRR06qrQXXzmIVoMUlAdI5RjNsa3BM3JqEH13gYupHDzJcWofYrGHJznvOzV+WuGsf9aFe2dMK207McSJFGhspw2DSP88P8Hw4aDhzXPkE8TMz66oPu1ttdUAVhlwZeysfjNqjs6TyR++9QwGRYs04+351WheGx8g=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OS0PR01MB5794.jpnprd01.prod.outlook.com (2603:1096:604:b3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Mon, 27 Mar
 2023 14:54:41 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::24d:9af3:518d:5159]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::24d:9af3:518d:5159%8]) with mapi id 15.20.6222.030; Mon, 27 Mar 2023
 14:54:41 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>, Min Li <lnimi@hotmail.com>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "lee@kernel.org" <lee@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH mfd-n 1/2] ptp: clockmatrix: support 32-bit address space
Thread-Topic: [PATCH mfd-n 1/2] ptp: clockmatrix: support 32-bit address space
Thread-Index: AQHZXaK16pJGRIZ5hkeh4WQsD7hXI68IlYoAgAYl9XA=
Date:   Mon, 27 Mar 2023 14:54:41 +0000
Message-ID: <OS3PR01MB6593510463322D4410EB8D59BA8B9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <MW5PR03MB69324DE0DEA03E3C62C57447A0879@MW5PR03MB6932.namprd03.prod.outlook.com>
 <20230323095626.14d6d4da@kernel.org>
In-Reply-To: <20230323095626.14d6d4da@kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB6593:EE_|OS0PR01MB5794:EE_
x-ms-office365-filtering-correlation-id: f27991e3-6136-4029-b2a9-08db2ed33220
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r/rpPAbjMqinzs/LDCMK4NTgEj0yKgGgneN83jPCkDlXNe7jcUtUQm1IfAyYq6MC23tq1GG2DIVq3/meA1akjbVMxb4RGLhqz/0f+NMOkE1ZaPRKPCy3+LhPrcZ3BrrLAe01UsnTzxLnGiRmlSxE8G1HeEeKyuRZH6FXVIT+2RUr9Cd0XeqbUxIFZuKXMEjrYAhY4It1Y1biXG3y3+Qs8Rfvn4DuqpypcPAUUe6IUbXqCk2NdqxhIdNJJ0OGyQbNAon4GKVNJPaEQZztYkFomGr8+DAP8eTNUbQgLwr8V8KzKnvDkeC8eixiuHybv2+IL+0tPICqrdYZLqRC1+llW6h0qRn/0GvT13eDciZ11eNsi4aODdvPQlWgL9hNgRVDDnVXUnm1Hh6KAg+KrtMX1D7xJJGrc0Rc7sbgM27UOFd8eL1ONE/Z0cy1zIOio/T46qyz7euna/bGeaE08eFFrANJiPd6rKpQQaxbQx9+RjUqzMZ13t+Xuxc4TcYCH+vj3mMqqFtF/O6OqfrGmpPbCYCK9yMfMwoOe3wh8w6hxjJ7MKk8G2Wl9ogvR7oEoi4uNqX33pFrgUR2vZ5424SVRiH7/fj62u0EPpwY9i6H8H1TUNVwuoSkrO1JXvSOjRgv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199021)(66556008)(66476007)(66446008)(64756008)(8676002)(76116006)(4326008)(66946007)(110136005)(54906003)(316002)(122000001)(5660300002)(8936002)(4744005)(41300700001)(52536014)(186003)(26005)(9686003)(6506007)(7696005)(71200400001)(478600001)(38100700002)(55016003)(38070700005)(86362001)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oXNr6qDlPkCZnFXuhzSWLG79SmF9igGfpfz9t2eVZHi6dgilMpwqFi5PGz3X?=
 =?us-ascii?Q?RT6uX1+Mk+gPW7w5R95icMl9AmKBqwC2yWLDvDaDa6X9ZZD7Bf6qoxsNx/YC?=
 =?us-ascii?Q?OeCNpIjIeuurC7M9NTkCIoxU9cAOIr5fcUkF31/+mw/kaT1tGPII8udqI1k5?=
 =?us-ascii?Q?22wdfMwFJzMprWo/262kRxHkFBDl41QTaYdTKfn7CfAgwkyNvkkum6sDcmqa?=
 =?us-ascii?Q?kJMvqUbNnaM8vo/5rK8mtHBdW+nSlnL2J84MNyK4LE98ZVuvVZz3q0fFcyPT?=
 =?us-ascii?Q?FNqrvq6WuenEs26iR+L542tOL3M3dL1VubuFpAXHHlG7bilrK47kietHOj22?=
 =?us-ascii?Q?X2Egd4suv2O/qr/ZNPRGgMIGRZa2pWVwnraYwyfH/M7A9NdjqaqBRfrwKtkk?=
 =?us-ascii?Q?yQ1v28ZG5f+pcM1XRWpOUIaF3L/dxIF4QctX8LWsS6O2RgnjXfjTkdNGQnDH?=
 =?us-ascii?Q?6WLkK7VJdT9TstA4I5gnbhULwKwWMSt7/ETYZ0pKBM7tio62bkHQldro7mGt?=
 =?us-ascii?Q?1pVSsUQ1p9axV6SwKmy8I82BXiATfDKxDEJC1oac081IaX+YpYqlN0i2Zbjf?=
 =?us-ascii?Q?oWQFUm3LF77fMduDZW7Z3fxhXO0vcRk0yYWZ3dPmfC56gki87ZDqsz2RPqfx?=
 =?us-ascii?Q?aTR9gyIgoyxVUNM6ylwPrhcQR9/kHB0l03sZihEgwKMbAWT+7ldbFeFoMtai?=
 =?us-ascii?Q?VnYVV2usdY4hBmhUSTgSbzOTypUyB3MtVDK2spA3+pMbFTCbJFkJRs9mn3lD?=
 =?us-ascii?Q?NgkStpoXO5wcTWmB6zjOaZD+pJl09nUug/7eo4ClgSICU9KLyUA8JaQ0RfWL?=
 =?us-ascii?Q?tVB63oDW+LzapmiHWl+avJCqaMIJhloLdnzFQtq82Q4IFXh5vy7ADzzNaLsL?=
 =?us-ascii?Q?ysRYvgvWVjxr7dx3Vm2pqh2LNtgcMobsYdeqJjIReXk+upnOYgOsUgHPt7um?=
 =?us-ascii?Q?eEQYmPCp2GgfwLSAyQny/Fk3ENyGeDhzda68wK/hjK30LbIf7BkEZiyfQ+aa?=
 =?us-ascii?Q?kG4JfAx+YQ9rCVqXGVjZEbnC4y3QF1CV/+F4t+1hYp1oF6dOu+r7u8tJtx1Z?=
 =?us-ascii?Q?tsgvgg0yNxjEQ0j2G94JQG502zkAA+oItkl67KF27hxLkjudizZ3D/TKmntj?=
 =?us-ascii?Q?5K7JqRR2gm9vY8vdYtxeFnS9F4i2rb6CCLzr1gYafdPGTrkqGyjqqasjcefD?=
 =?us-ascii?Q?PtPKc8Yu7RWKzSHLTdOSUJhfdD8DWoTbU5vdoW8HpiaoqWYSY3CXm8PyoFJ2?=
 =?us-ascii?Q?fsNgwmebtaNzhefyW+qS/QzsFZwTnkZsxQNZQq26JnVoCUrkcZdjjxvynygA?=
 =?us-ascii?Q?HdKlcWU9ujYkdYrH9CooDV1hyYeXYfkavNXBhL8sXl/lMaix2tAfu+1ecxbK?=
 =?us-ascii?Q?eFhUJuFrXuMhxQjCdkAOJr9ru2zBm0d2iEyzqu+5o60FIvtnids8CkPL1gTz?=
 =?us-ascii?Q?nESoRWFSryN3MXyTi/JFwwGZWfKRunSs/Rz1oxc9znw8j7AgK9DVQ2gCuOjj?=
 =?us-ascii?Q?wWzqwjnJChoJZgCr6L8rcixog553JpVfJNEFurvkmZL9Z4XmQhaUIQFVD+iQ?=
 =?us-ascii?Q?y9oEdfBlv3kY14gcmgyHi/2+6F3SRrWSVx+blwMx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f27991e3-6136-4029-b2a9-08db2ed33220
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2023 14:54:41.6951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z8I9eV72d7PnnKBQEZrQovlPBqjk32ViZEs4FvsLoIDjGnpUpEBjxV+MshNp7kXGdvPnaMryXt1sXBV+sm7cTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5794
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Thu, 23 Mar 2023 12:15:17 -0400 Min Li wrote:
> > -		err =3D idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
> > +		err =3D idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
> >  				  &temp, sizeof(temp));
>=20
> The flipping of the arguments should also be a separate patch.

Hi Jakub

If I separate this change, the other patch would be broken since it changed
HW_Q8_CTRL_SPARE from a u16 value to u32 and it doesn't fit the function's
particular parameter anymore
