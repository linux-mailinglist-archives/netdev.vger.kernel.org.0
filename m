Return-Path: <netdev+bounces-7248-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A65371F4FE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:47:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB2C61C2113F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 21:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB2524144;
	Thu,  1 Jun 2023 21:47:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8044A182D0
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 21:47:48 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2088.outbound.protection.outlook.com [40.107.96.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E17B107
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:47:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P145oSknhZRtPiifet2EEVBTMHu1vPkLfDefBap8V0aXYpIZc5FZZzPYp/6RZ/ffYPj0i69WqE2Fk4OD82uD3bjjDLVPXkv2EbIGxsXaXrQxuB9ExoDiITpLvbn+Or6GKAmuZ150DxSJXu9+2oWmPHQ39UPBqV0oXlDJD31YUrk88tMkFEtftl4PKiarZBiu8zBqUGwg3MFnVYV8pAGEi3O1V/QHVZ2NB0kQ5XgtDhJ2JBuTy8fmzdKMJx2GwqD78v/qNJCUZMiE+jcbIl1ZR+bmQF4iC990yETSG+G8Mt5js6iGRj+6i1ETxOVU2Lj5jvgtTuYzTkIdiGzxAbBgEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+ixc64N3DSOcbq4VvdT7HPkO+hdkC03m+0aWZcuSso=;
 b=GTvdz4kJACIyue0YX41z9i907I9xKXsT54xEMvb3v5imE414ELtvYD7xSkGPkpYRF7DmJLjDazb2hr/XKcdLWO1WWnOMss+nCmpaB5QuaIQMmstuY4tL63W0YD2ZmS6L+oH/Cqe+LRSErAkT6Zky8PnAUYQuZ5H9RoV1Z6Df/wg6Eelen855l3c/K9SsWsYl2VMmfPR1un1GgiaprOcYMKbflr8GmP4bWUauvd4URGo1erfgXPeNHTdQjTxUrP6KHTRIxurQaD/bjG9hMFgnG6WYEJDyrWzhfHSc8H5Vfscn4TOvavSAKD23o29VFouocqrzKbZTsXf7UTVE0pWU/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+ixc64N3DSOcbq4VvdT7HPkO+hdkC03m+0aWZcuSso=;
 b=B7BpTEsxGQnnoy4i7TjTZFsGSEVcDBYZAotd1MU3yNL4/n0yqRZEb0y1T0SUsH9qOIs5+67/4WK3tslhmbfiSvHBp+cP4DPLSA7RLstKQ9I5eDumDYo3vaKMAgWptMfJsaCDsxURLoCAeRu6blIINwI7r8POoING2tn7nkzOJEM=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by SN7PR14MB6711.namprd14.prod.outlook.com (2603:10b6:806:359::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Thu, 1 Jun
 2023 21:47:44 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64%3]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 21:47:43 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Thread-Topic: [PATCH net-next v4] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Thread-Index: AQHZk+gMB5XEvTvQP0CsGsHWLeSHJ691c+CAgAEIuFA=
Date: Thu, 1 Jun 2023 21:47:43 +0000
Message-ID:
 <BYAPR14MB29181AC66013A7E044703CD6E349A@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230531174720.7821-1-msmulski2@gmail.com>
 <20230531225645.4b219034@kernel.org>
In-Reply-To: <20230531225645.4b219034@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|SN7PR14MB6711:EE_
x-ms-office365-filtering-correlation-id: 60fbc9cc-88ab-4ea6-ea67-08db62e9d46c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 buA4+NrE6L6MSO7Z4mpNm44arP9ob3RyIeToUiiew7y0W0gIDs7SwN03cN68mPunKPcOe7jDxC4W2Q/vb9eau25GLSlXry+lnxOr4YGGjRaQJvCa1ajg2r0GwyMIstOfBthZHm7zY5yfob4vmPNVQ4BsS5I6owYY+KFo0QJ5TemMqQGBj4tUOCrb55rf+zdQG23rNE0N8D2B2idVL+Rj7R46dM9R4JslDdCiupX8YYMUlhpXzpB5MOv1z2Z5H7P98rETKaKBiNBVkfqPauYIGRm7i0DMqRVV91D2AOxj1CbM3vDzGqAin9lxVRaXLV6cgtTlOIeGsd0qyQiVQhXYXVm+LJkkwRT5WWcsfILSaVlZzIc2dz0tapXPPIGG+qXYAEO00JxwSQIzLkkocPPyMX41qO9UAlezWFYGCACHzIRKxdL01vLYPja/xH8DINfBQ7wCTCxg+7hpkokXBPt7285QGttXL/xolw2nudzPWHjCCyBEu0GXVEnjG8WBL54+B5u77ciwkQU5KNyEekdJkRdFU9gyMTQdq77DpIVuwg/FW6CJ8gTekHx/wxCZf1LF3Z7v60IRLi/BfKAcsJ6KDvRM8rI0aZ0odXaSOy7LRCspRznm3Uz+5u8Rj/Me2aaPNKkbvXXwuZLi/iE8cMdbfA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(366004)(39850400004)(376002)(451199021)(2906002)(44832011)(86362001)(33656002)(52536014)(38070700005)(5660300002)(55016003)(83380400001)(7696005)(71200400001)(186003)(26005)(53546011)(6506007)(9686003)(478600001)(66476007)(66446008)(64756008)(66556008)(76116006)(4326008)(122000001)(6916009)(41300700001)(316002)(38100700002)(66946007)(8936002)(8676002)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?rS9t2GJLvTu6HA32eeiPEAD1WDMpyDmoyEbiJw514OytbH2x6rkqWKnQE3Pt?=
 =?us-ascii?Q?H5HPDgjuwVOPJaGVWSjrr5cv1DJqHSqlCNYEvENCkYNLtriDqSbtPo9vFvLY?=
 =?us-ascii?Q?BRHF6Sjmpu45GwELq9bwAlfYlq4K8PAtzS15mUY/kP7EVIb8M3lyzZRylUH2?=
 =?us-ascii?Q?5nUZVd3FEGcWGHmffTYY/sPQJsaaIJLVqiK4kGfhZVHseg0pcDCtVRUU0z7m?=
 =?us-ascii?Q?jC4i/eZj/OFojJzVljuEJeViZkYjRVGniVh4g5auUA9mVFkAzY4EWFTV+pFd?=
 =?us-ascii?Q?wiWn18PvhjF/Q67UEPAn/bmTg990BmSfhoNyqSIkd5ieVBfYLbHVbokroJyl?=
 =?us-ascii?Q?TYPxV7KNOuDZVAGIVWT93mI3vqCOgXwNF5v4JfBITT5tEISvD2ys/PQEqA3V?=
 =?us-ascii?Q?GLenXVb1QeGkL5kH50HPq+dC4xqyTzBPGOhiya9hi90Di6r/eVndyYnsZ0Iq?=
 =?us-ascii?Q?tcHwrYr0Etfc5vsLaAKCy3r+35bHIm4oPTvR362VQ4/r4XwNdOR0LCztH2t6?=
 =?us-ascii?Q?WmeF0yJf+UyiDNV4ck+Lo5OkxCk4Lsja7rfw3vtJ7eTKbT/hRbWu0HOj/0xo?=
 =?us-ascii?Q?NLYaNClZt+X32Jq6z/kcrVA4AsDmwSTfBCbkWQxyFEDE5mk5i46qreZ971J3?=
 =?us-ascii?Q?rLtTw5CNLSMf9oSc1J/KWMLgfdBvnROlQlIIkHnH5c4N2A8wEKs2/NrwLkK7?=
 =?us-ascii?Q?n6Idydmw5rS9flyyLq1z7U+wdol0LOxqAc8K9MM9UGwJH3g2ExrErvBb7WLd?=
 =?us-ascii?Q?99/kPIPmjZKa4t96QKi/xfLaDUMVJwJGKycKLpNWSMhx4OXYL892Zb+AtrLD?=
 =?us-ascii?Q?Uyv94NPXelVOBopWGoZ4Yqe/qsIoW4outWevMFpATA3vmLN4K12aUfaIOn4e?=
 =?us-ascii?Q?CW4JUtzVEnzq6QmevasqoULeJkem9JMLg+mQFQQNTAyRs9+HhaIMS1fhR5ZP?=
 =?us-ascii?Q?qiux3H2VECw2sX1l3fQshrp7UgsJQJTka4kkjUzAxQCrHeEphvm1IM01gFPA?=
 =?us-ascii?Q?riDWOglaPQ39JX58X3cliA5mEqqmCoFC0v0K5Hp3p0eGzm8QE5BYespzzHzv?=
 =?us-ascii?Q?x4z+2tAiGopHRCuZpQcadR4CgWa5+KRTIjX6Xg43MtncVJRB9s5eHhlOYuC1?=
 =?us-ascii?Q?mxj8U8OkWba02XylCQbsyY0XWptiYkKYEYXpHa4EX1f6TZ2pjLK+bgUlJXkY?=
 =?us-ascii?Q?o2taieemgtJoc2QaLmUpU/Ack25btsi+hc8HYVlg5g5RH4qEBhinfULKVtKJ?=
 =?us-ascii?Q?DQuGzQ1QpAI7CwVGg0JtYdNQ8Rwt/JiLkZLvd7c3LbCIXvoTYH+WymoFMPsr?=
 =?us-ascii?Q?EjIWuAJKrTbo5k+oM0KEwdULblQADLhivsDVc2fylBQ4N/rr6leClokcD45k?=
 =?us-ascii?Q?0W+n3eRSLadGTPkABwHn+e7bvgm6XxxN0gBNZHuJXnmHzSI4lFV9l9hJEnVM?=
 =?us-ascii?Q?Kw03GHbLws8OQ68zCYa6R7eMaGGHVov1/KPFVTh7zfJc6AYRP74pFftlSE1K?=
 =?us-ascii?Q?yZoxHKILSAuk3uQwxX15Hqg8nlaLOvLfb/eJmcHBXbXJxfuT/DWHYO6Z+0g7?=
 =?us-ascii?Q?kGGigkleiMsktE2nyCuEKyM1tO9vjOtIZaU9XdRo?=
Content-Type: text/plain; charset="us-ascii"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fbc9cc-88ab-4ea6-ea67-08db62e9d46c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 21:47:43.3609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J4fJb5j2vh7EE9CsbJwIFMkx42/xpMMvdOYM3U0U93fcDr/ilsQzYcuwBrlk7i3JYA4vsavB55hXhi+PwH18Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR14MB6711
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Both of your suggestions are excellent.

It appears that there were a few changes made to chip.c and port.c since I =
submitted this patch.  I re-generated this patch against latest state of ne=
t-next(main) as v5 and will email to all maintainers and anyone who else wh=
o commented on this patch.

Regards,
Michal

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Wednesday, May 31, 2023 10:57 PM
To: msmulski2@gmail.com
Cc: netdev@vger.kernel.org; Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v4] net: dsa: mv88e6xxx: implement USXGMII mod=
e for mv88e6393x

CAUTION: This email is originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.


On Wed, 31 May 2023 10:47:20 -0700 msmulski2@gmail.com wrote:
> From: Michal Smulski <michal.smulski@ooma.com>
>
> Enable USXGMII mode for mv88e6393x chips. Tested on Marvell 88E6191X.

Doesn't seem to apply to net-next, and the CC list is definitely way
too short. You must CC people who responded to previous version of
the patch and the maintainers.

Failed to apply patch:
Applying: net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6393x
Using index info to reconstruct a base tree...
M       drivers/net/dsa/mv88e6xxx/chip.c
M       drivers/net/dsa/mv88e6xxx/port.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/dsa/mv88e6xxx/port.c
Auto-merging drivers/net/dsa/mv88e6xxx/chip.c
CONFLICT (content): Merge conflict in drivers/net/dsa/mv88e6xxx/chip.c
Recorded preimage for 'drivers/net/dsa/mv88e6xxx/chip.c'
error: Failed to merge in the changes.
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
Patch failed at 0001 net: dsa: mv88e6xxx: implement USXGMII mode for mv88e6=
393x
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

--
pw-bot: cr

