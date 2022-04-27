Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB1B511AE1
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbiD0OfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 10:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiD0OfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 10:35:18 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2133.outbound.protection.outlook.com [40.107.114.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A465C1FA6F;
        Wed, 27 Apr 2022 07:32:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkcUTNYEziQEaHYE/2n7+3eagM3cypNz3FqJ1F6kZ6padx2kBzUPSiXM8TVS9cOj8NJ3TMX3b8dsGcvRATjim92qn4L2ARc+o3o1PgoGovonBHd/FOUbhnS9w50JLT3ZCYClpc5XTteIK6ps6dRTUdEEFLjR3qJd+odiMmpPjTmwO8fFIAGsZga2h3ZtyUTEs0cJtvLwjgnTfme0Z59tgAzh3YUgH5GnhwznYHXrb3sR5bY+5kHHTkHirBjbsYXFIsCteonIzfJprb3yeYcV+vVKOgAGwd5BjIUArieQPWBf3mu91BKGZWUDbbjidguxkeN/0rR3HbjY+K4sIiOn9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9xt1Af93NnvzZI+ZBc34yLt27w4pz9djae310iRmfvY=;
 b=Xv3m5VTMO6yWLpzf9ISAAc/xIudBhMv2Sfukz1j5EXZUSaOqQpGwJlV+ovlPEwPDlkccI9CWNobj+iaPouVheYXgLMPC5haLdo8H69jgl3RA2TmwEPLYsKXmWJkKJnGPknztPf/nMKApa+I3KkU0pHNo1pjXMyGTouGl6Xwtbtqg422n6pPf/T3+kVjx3xl60B2LjLAFLtrWz6JVWRrjKszAEjQVMemnWUoU8Vc2LyQLXzGXPJk7G4ea36wbpwWVfPL/fLEaNS68ixJkl3W5RdCDmv2gExEiIctEDlj9mBkmf5EgjNFk6jXeXJ06usSPWLW7OZzCC4lKAjgCYNLWEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xt1Af93NnvzZI+ZBc34yLt27w4pz9djae310iRmfvY=;
 b=fiBPlhrW0zDyrVkXYzs6YiIvg96gS4kwRSsDGIVOKDHpE0/y0Vux1ye/7MAIxfcrL5Ya8Xvp3DcnTjFPaZyv5Ml2ajNPLjyZve1+fFny2jayO3VFoyxRxCovqoYIPt1gNSZm0D4ur6rhSedD9jmv8U+fyncFtygjzj+DFeZH/+A=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OS3PR01MB8090.jpnprd01.prod.outlook.com (2603:1096:604:170::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 27 Apr
 2022 14:32:03 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5206.012; Wed, 27 Apr 2022
 14:32:03 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Thread-Topic: [PATCH net 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Thread-Index: AQHYWaR3Qsdc/gnqv0WbXtgKN/pPKa0Cs/8AgAEffxA=
Date:   Wed, 27 Apr 2022 14:32:03 +0000
Message-ID: <OS3PR01MB6593BE917485C87E32D1E5FDBAFA9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
 <20220426142150.47b057a3@kernel.org>
In-Reply-To: <20220426142150.47b057a3@kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76414dc4-6bdb-4a80-4615-08da285ab2d2
x-ms-traffictypediagnostic: OS3PR01MB8090:EE_
x-microsoft-antispam-prvs: <OS3PR01MB8090A50A83935D63B5A1DC97BAFA9@OS3PR01MB8090.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 97ZhPUHaxP+iXRGsfPs/1m+be5UtRIXMA9pYCG1RH9UTmUYRSCSXHa5LytBfsjIenn8O0SAZ0dOzFLWtMtmmZEJJxh9z0iUU2qfHGmoo27Uu/5vOXL8aM070KXEHQhzPQ5ADuiHu3mR2h5x9qugzkYSRh1hTprxGyQwhNA+LJG7PhGZFLZ6iLi3uNLMspkcCnhn7EqXcRZYULD9wwdBmLGlV+u4vqYr3oy+vVaCIn7sS1Bpq1CmpJZtxcKxbVOFkaTNd0JU5Z4FV5wqSHsSzVlJm7CuiP16/J/Q2J930vNxkOCizuJuc8eYWB+vTHccJM8WzSA/XJIRnbFUklPO8YpuBBTp+UXcqeVGWjGP+uWgkRyKsW9uTgfZUQ5jl/ia8Z4++h4RE7xVHDTjAVO8B9ug6UkZf629WEO8ssnd1L7vqO4f4ijqcBvd0FL1R06BKtdkYJ6fOhuqg0Yh3WviB6lGuo04mGUnZGcK4Fdga9Up0yjIw3rdzit82tpzGS7rOFg1BOp+5zSJJ5Ia05XDSDukVZIHgiDS0N/oe15Cjxa67mLjLzk61PlmfXscoNPMrYfGAJ+U/SKPToieSAWScKlUmWx4duQQay5Cdeq0sk1YfbSb576sQ9gcZ/yJIPPQbWtaDvAQEaOTWc4QJszf1cNdzmVPtU1j9DlAAT3FJ+2fZZ/A15mm2RX8im2mFKe6lGHcfnRSUrkLnwPJGRTmgIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(4326008)(66446008)(71200400001)(38100700002)(558084003)(86362001)(38070700005)(26005)(7696005)(66476007)(66556008)(6506007)(2906002)(122000001)(52536014)(5660300002)(33656002)(64756008)(8936002)(8676002)(508600001)(55016003)(66946007)(316002)(186003)(76116006)(6916009)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ga5oHeF0iTFzBa6NuJIFmZlCff5J3qA5oUa0LBL9AMrmRDk1MgR2tkESLbjj?=
 =?us-ascii?Q?cz31jJUTQUawu+zEqJIgTk6DP26hP3UMt9YEPU/ZcJ+95G55EkpRz4atSYHX?=
 =?us-ascii?Q?y3Vwt3aQQsFdxz1VHMOV4osgKRolkgZIEd/XgQVfUFkXdOoiyx7gmZScA8JP?=
 =?us-ascii?Q?sFvWRrKIQdxua4a5g4567LPARnBZWN+b4IAceEC46Tsnc/DR+Sj98uegXfH8?=
 =?us-ascii?Q?MQholJAX+XgcAshSs6Nl/uJjozsx2CMll1q2+6B5T7YDRIoXE7y8mK06jOiH?=
 =?us-ascii?Q?HpGbL6l/jyAru9t0FFmhxB9zClbhi6/JAysEhspXs7fZ+SIIUUNHR3CJEWj6?=
 =?us-ascii?Q?JlW3FalE1vAFWXgPCV7ouD0TCta77gVMVyo2z9bMS+E9FeL8YgrEGWsfqGk3?=
 =?us-ascii?Q?djnIpZod7wa+nkbMoLadIXT0W7XWmzX6988w05XXfhsTb+XJVCgRVCMXJuEW?=
 =?us-ascii?Q?QS9SsL8KwcOhLEh1xjgex5880G9ayYTxLjE8Tb0DCnstxqkFYGsWiMV3hd5Y?=
 =?us-ascii?Q?2rMz+fpEMH3C0He9WW65qPaprDpwhWuDpNCPFVjbPRv4qSAuGO+ii53FFpV3?=
 =?us-ascii?Q?bow/jYq73XnfQdikbuqXo9lVqfFWy1K6N71bg9pThVyOl6hjZpzeNjE3tZpY?=
 =?us-ascii?Q?MsnNyXC8+x2KmMT+Pnfp+GzwTGQJ/m6r9Vv5+VL1AgCVY82UFsTRg5todL0l?=
 =?us-ascii?Q?p5eFHwjRAE1PtGX/yG9VvbDSU4ChNF7sUFGyph364dC4DD8sB6MwOIHr7llu?=
 =?us-ascii?Q?8aF7Nhq8BhIJivz9GMQ+nJXxUCKCP2lOeUTBYKQOZxQTdoyOpkKEeXGG70pg?=
 =?us-ascii?Q?c8bGhhS9mERH6WxNepxkV9PMnh5fy6cDF3BywzLtWC5ERWCgf7oj8cSqhHEL?=
 =?us-ascii?Q?kW8euJiX2o+SoP5nh5nrGtZtm6NTBNrHnGM54rI/eQhMiE15us4LO6SMeJnY?=
 =?us-ascii?Q?ieqhkT/In1eIYRwh0udfqAqUYunTkqw2HO2XKcevFfJHUCTyRfB3CCsEWz7N?=
 =?us-ascii?Q?4oz3D+HNjQymURVlr53yFf4xe87IJHAjnHmpe64AbVVnpvw+2CAhcsZYXnZd?=
 =?us-ascii?Q?loJq7R63o+5KvMgJW9/T9pJU0M3fJvsIGJVfqTM/nGy02ZnS+LDI/NsnHKqj?=
 =?us-ascii?Q?MKezc1v8g7LmenSGDPvzRAuGwcCaZenRwt7DGvvNfL/myIxHPipDv7p7beMR?=
 =?us-ascii?Q?8Dh/mzMpw3gs8b36QzkKO6PrIOqp7nHNBhoHKK3whLzcpnx23hTubgCYMa/U?=
 =?us-ascii?Q?S6xRkbvQH/Fkgh9BL8wJ3eA+wuUBuYpr7fdB0fevfB7mpJY1uE2qWiN+xyTL?=
 =?us-ascii?Q?FzICqkE9DCTnTclSUEqJqEDvxCrkPFpIm5iCAT1PVh5lVa7VSbwwkC952vxN?=
 =?us-ascii?Q?pDGpcRJZsOhCWC7g1IBLq/qbutjQ8y3+C6L+8jR4/NcRrJAYrgWt67kV7jbr?=
 =?us-ascii?Q?DdLMtoBqUOoYgZuofpR7JavUEa1OkYljMYmTAnVY+ek0Xleq/wqQV/2oAPBj?=
 =?us-ascii?Q?do8rYaERBFeC9hqdSdhCIPakOpmGs7dyIW5VdNWJXM0FNLdVneny0yKy9Lsu?=
 =?us-ascii?Q?3/xeSCVcXJnGH3o8BMZZAasJ4wqmpOrQtfch13+OMjve2qjRE9PGqk+8z7dR?=
 =?us-ascii?Q?6Tu5tYZvXwb8wysNv+EPAonx2Mj0THow0J3n3YQfZ3YPXJnNfkbQ9JWODkWT?=
 =?us-ascii?Q?9NK9i43MGjNP1qmUBll214qPTlpb3br8GBkXWVnyv4UfPz5+KKG6viIj5eNc?=
 =?us-ascii?Q?cWNIie3Wow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76414dc4-6bdb-4a80-4615-08da285ab2d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 14:32:03.8483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t4bSDYWhxr+UNBEFyYPGoKINMdV98NRac6rtDDZxCOhXdchpj7nNM6V19dVeUS/na02epORv3RUKAMwbIY229g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8090
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, 26 Apr 2022 15:32:53 -0400 Min Li wrote:
> > Use TOD_READ_SECONDARY for extts to keep TOD_READ_PRIMARY for
> gettime
> > and settime exclusively
>=20
> Does not build on 32 bit.
>=20

Hi Jakub

I compiled with arm-linux-gnueabi-

By 32 bit, did you mean x86?

Min=20
