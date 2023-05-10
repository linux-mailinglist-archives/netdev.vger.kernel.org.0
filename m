Return-Path: <netdev+bounces-1535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9616C6FE2A1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A61E71C20E02
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D70D12B8D;
	Wed, 10 May 2023 16:38:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CD68C0F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 16:38:04 +0000 (UTC)
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021015.outbound.protection.outlook.com [52.101.62.15])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF042703;
	Wed, 10 May 2023 09:38:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+rxhYZjUFU/Mk4Tb8g9KV4rcKk2oBVVz/puEI19QR3hOYM/otR4ieZ0L4m9zVGB+V/GGRHI+UOJtuxPuNVMnedAeigYCs3+RgRV04JXRyz0XJV2JS6/3oAAc4e3TlJhPw8F/ajlMeZD2Mzre3cYPWkoNCmJCXy70Gomu9zHh9nrVV2Rg1dRVQ0rpgClCMV5Q6eJ1+qeFynAubYQ2yGyqDI+NodYE2u16s+KJcVJgHwyf4YpKyzKSIk+gOik1CnR/P2ZErUsrnjdrtQQwM1QnY6fb8qt0R/Sll7FTRYPR7Tz7WliluGknqBazE+EqBbS2OSgd3d/tWrBMXg6nuEEEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTp6cnKzG6yCK4gqb6NFBgRZquXHMQA5hK1oqZQVUdo=;
 b=KtuXkeXrB1xDYfQlod7jamXL6udFgZHim2JY7ws0CtlU1Nj5Pf/iLzjovLK9x0G8jJ3BQIyXZw7jcj4Skd1I0ke+TjvNveFA12qmsZaFWsCpJV/OipqscyOV3EEkxHH3QXNGzUJy2UEWo6krD08nFjifSEkOxPtE5UNalJ13FxcEkD9tEekZhU/LCDsgEY3PGkgnoZeSwbryCLtvCrazcpR9beaqAmxmhhkv0kytbm0dmD7UR7tXa2wY+ng9fROd6k7y9jwjTpjOR1W7nm6gqkl083NXiFTLioGqHSdxulADSjQxFEq7+sC41lApA12vzh2JcCp0TLoeAahip1ngnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTp6cnKzG6yCK4gqb6NFBgRZquXHMQA5hK1oqZQVUdo=;
 b=cKengA7ZTUzHr2Nyt+DStTT4ss61+qAJ82u5bHlLUSBHp1WBuwsgTvvAXJrbNi4zU+avEsJJhl1d38mtaEvy+sPnfvlU4dSLq4BSYksfze1l5Imri+MFpuB7IBq00EQGZsFfzL0JKiYQPz3WqtBlSVvrdxnyC/8aPg1rzfSSUEs=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by MN0PR21MB3779.namprd21.prod.outlook.com (2603:10b6:208:3d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.4; Wed, 10 May
 2023 16:37:58 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::e121:ed06:5da7:db88]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::e121:ed06:5da7:db88%6]) with mapi id 15.20.6411.003; Wed, 10 May 2023
 16:37:57 +0000
From: Long Li <longli@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Ajay Sharma <sharmaajay@microsoft.com>, Dexuan Cui <decui@microsoft.com>, KY
 Srinivasan <kys@microsoft.com>, Wei Liu <wei.liu@kernel.org>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Thread-Topic: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Thread-Index:
 AQHZf4Kx516JgSVbG0yUd0QoJdn9v69Od9yAgADh6oCAAI6LAIAAkDIAgAEYvwCAAMAoMIAAyUgAgACgKdA=
Date: Wed, 10 May 2023 16:37:57 +0000
Message-ID:
 <PH7PR21MB3263176E4B1E41A5A2088D6ACE779@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1683312708-24872-1-git-send-email-longli@linuxonhyperv.com>
 <20230507081053.GD525452@unreal>
 <PH7PR21MB31168035C903BD666253BF70CA709@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230508060938.GA6195@unreal>
 <PH7PR21MB3116031E5E1B5B9B97AE71BCCA719@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230509073034.GA38143@unreal>
 <PH7PR21MB326324A880890867496A60C5CE769@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20230510065844.GQ38143@unreal>
In-Reply-To: <20230510065844.GQ38143@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=61c0b480-207a-4464-9dfc-0157fb97dce9;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-10T16:31:57Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|MN0PR21MB3779:EE_
x-ms-office365-filtering-correlation-id: 553664a4-cab6-467f-feeb-08db5174e981
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 APangHn0fY2mrFifCdHFBi0imx9KGoxMAUssyns5e8x8HhPQ3QbK0Clqs3cqmloCXqtA0A71tItOrZtrcZDtj2VgxqP/1UcRq/8DwbUcCMflNkI0BNBHGdZP3QW9WNDNmMY+OVMSG1IKGK2IyP4rpevzmMbkY5FLFv3rIhixEDxnZt428tCZH9SSaWrsxl3qZiKAEUg1RX3OdMBdFz043a7tSC1fMceOpz7SJ2lJM+fSWT3wGOM4gwsvTF6tI3t9gDvNVoVkoL9Y43eatK09I2zlao19kKmI8D9PT8r3cqWqZ5xKmSa65FEjsYtcyzxqpyCpGTUWszjDs++tFor3WQSWEar7KTOPbQDp8tnoZhvTAg0xWYDbKyZTyKmQBS/mBLX7G4rA+v9krarmqbPLG8zp0ahdFdZG1M4d7W8UOt3bV4x7X53rd1eeMzAkbKzTjr1cPuxPo9LN6XEd8a0Kzg23x67tk8yqtB2wzw4DzrS8EjAonuarcWN77ixplGJSPN1BLNAUgnDSfPKl8SHPjn2XZ8u4jkHaz8H/xF1JQjcFPM+IKIQjrOcXT66Jcs7vIpkY4tkXv4+Zf31L+3vrRmCToWG3zBmMLg95l7SUSEbx1e3HK8tTcrE5du7CI/Q9ekrwVbKzt7ac10wSsL+1zIS9Ee6fgMo3ZqXYMiNSyGo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(451199021)(66556008)(66946007)(64756008)(71200400001)(6916009)(10290500003)(66476007)(4326008)(478600001)(66446008)(7416002)(76116006)(8936002)(52536014)(5660300002)(8676002)(66899021)(53546011)(54906003)(6506007)(9686003)(786003)(316002)(7696005)(41300700001)(26005)(2906002)(8990500004)(186003)(83380400001)(122000001)(82950400001)(55016003)(82960400001)(33656002)(38070700005)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YdiebQQPU6Om0kDDLH8xMJW7U3XWZvR6QX4PVbn+onpYoxm8hBY0RiZixK6A?=
 =?us-ascii?Q?xWb0vl5AHXzCUpKKk6oTTqHCvKwIbpBqAWNIcrWLdspBS7aswULqmhrOt4Hb?=
 =?us-ascii?Q?jWADh6Xn71nxI0zZpDVYuMoOQTx1KexHtQyY9jPUTa/CWhccVvCY4rJvoXvf?=
 =?us-ascii?Q?DQ2Pf6PD2la99PaVVAMDr+vXbLTorr4WmqsDFheWtOuMwSw97a/Njo+gC/DZ?=
 =?us-ascii?Q?WJkUUcfAdPT7NbVqj3ki/YEllBxUfKALQGEnyPtW4chpRJtydW0inJ0FKQmR?=
 =?us-ascii?Q?e5GVh4oH7YNEmYCVokuo62Our6PUvCayjiR+wiVcB+QXM+8UkedXAUFsgbMV?=
 =?us-ascii?Q?+Pqs49Cb6NgOM6F/yims3EsWUbRgudc1IHRt+5atfGh282Qed1xYXUqS/aWo?=
 =?us-ascii?Q?EFq3g02bFDH23My4DEkAFWI9wXobZpmTWbFkMQg92UW48q52I67Ppv8W5IhF?=
 =?us-ascii?Q?iotQ/hKk6ii3TxdxdlTky7ettuhxGRmVhkcceYo4KHksAegQF6nRbbQSefc8?=
 =?us-ascii?Q?zk9iUbumQYaqF1FB2MEMkOpB9ZIR3Fw5H0UV4/VTxNISkJqXWCPSCe0eiujJ?=
 =?us-ascii?Q?HAve9dur4WpCzG3RcoWT9vDCnS3R8VSiS1kLK5yap28f13pIZaRorCldwFMQ?=
 =?us-ascii?Q?41dS4rWLDRInpXL0DRGRWO5/Nx7OVg0R11kKvV9Yv68tvGhV0qBZM1RNMSRI?=
 =?us-ascii?Q?HZQXDakqL/8w8P9EiKE6bq5hdtHaPr+kfPikClE4Af1RKEEMZ89roep+8i7N?=
 =?us-ascii?Q?eUtbL50UQK0FnXyt9eKILeilN0jxjpL3LQ+Qvq95nIto9COylmwGTQmK5X4b?=
 =?us-ascii?Q?bU6X2IEbaSyfTW3LOD7UY34LeaXapDlG+lasDfWhaK+B7RrFQY8pQZUiykNT?=
 =?us-ascii?Q?+4kzcHrvc3X04QcLZBTfoEly1WnM4tDMT5sIzsCMh61mO0/LywrQ7oTUOLVk?=
 =?us-ascii?Q?4mcw8AOZjqThrlPhI0AjjFAOBE0F+fu+ZtPVFor/JEl/U/rjxPL4KLxwIvpT?=
 =?us-ascii?Q?XPdQWl7RMMj1WAJLHmJA7gpy90ujcN40kUg4HaNGwfpwsFlZHP6pn8a/fsE9?=
 =?us-ascii?Q?y3eVYxOL0YFGVG3M3QIn6QaBQ5k6Aadr1/bj3leX2nSRniqtM6tDeTwxwiX/?=
 =?us-ascii?Q?11QlCqvAWjNrJoOzwPCiv/wH31s2JMNdL6AZ3eVEKiHoZQO21KMRvU3FZGbg?=
 =?us-ascii?Q?VtZJJYynY8yb4sER8SAaGr/q8wLw2EG65QtyvGe5itAcwIpH0xNCELCTdquB?=
 =?us-ascii?Q?9oLHyy0JxvDknq7t3/jSfswlXkb0SZNUVWNKSZ8xO/f7pdN4kC+qBHstLHhc?=
 =?us-ascii?Q?6LolRJ/c/Ef8rKD+2KexCZreK/HkOo+fphtbzThhBp5FUdnktRrKDBXs2iz5?=
 =?us-ascii?Q?NeopYJUBtDaufAa7ruUGg7s9YZtdjW87UfqU5LJ6KOLv8/uZ3ERuoCGQ/cWG?=
 =?us-ascii?Q?RSOdlJVRgIIRJ/9mgt7mBaXNRtpFdTmpbi7axOo/GLivu3pOoD2oX6JmC8le?=
 =?us-ascii?Q?NChbtYxTFlHEel5/R4SM5FlYPgQHSQ3sZfgwpyh0h7QquboOR1ymft2qPXmo?=
 =?us-ascii?Q?nCkNPm75dcMVM1FFaCa2YJqBvwySWOGwRY1dVv9C?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 553664a4-cab6-467f-feeb-08db5174e981
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 16:37:57.8126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wzt1x0Lf661eHDl3KVvS8SHWqF7d4XAV6yRAe7FVMszFYwazF/TZzRCEafIevtRw84ENc2BOUC2ugCcEdED+wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3779
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
>enable RX coalescing
>
>On Tue, May 09, 2023 at 07:08:36PM +0000, Long Li wrote:
>> > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of
>> > cfg_rx_steer_req to enable RX coalescing
>> >
>> > On Mon, May 08, 2023 at 02:45:44PM +0000, Haiyang Zhang wrote:
>> > >
>> > >
>> > > > -----Original Message-----
>> > > > From: Leon Romanovsky <leon@kernel.org>
>> > > > Sent: Monday, May 8, 2023 2:10 AM
>> > > > To: Haiyang Zhang <haiyangz@microsoft.com>
>> > > > Cc: Long Li <longli@microsoft.com>; Jason Gunthorpe
>> > > > <jgg@ziepe.ca>; Ajay Sharma <sharmaajay@microsoft.com>; Dexuan
>> > > > Cui <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>;
>> > > > Wei Liu
>> > <wei.liu@kernel.org>; David S.
>> > > > Miller <davem@davemloft.net>; Eric Dumazet
>> > > > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
>> > > > Abeni <pabeni@redhat.com>;
>> > > > linux- rdma@vger.kernel.org; linux-hyperv@vger.kernel.org;
>> > > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>> > > > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of
>> > > > cfg_rx_steer_req to enable RX coalescing
>> > > >
>> > > > On Sun, May 07, 2023 at 09:39:27PM +0000, Haiyang Zhang wrote:
>> > > > >
>> > > > >
>> > > > > > -----Original Message-----
>> > > > > > From: Leon Romanovsky <leon@kernel.org>
>> > > > > > Sent: Sunday, May 7, 2023 4:11 AM
>> > > > > > To: Long Li <longli@microsoft.com>
>> > > > > > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Ajay Sharma
>> > > > > > <sharmaajay@microsoft.com>; Dexuan Cui
>> > > > > > <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>;
>> > > > > > Haiyang Zhang
>> > > > <haiyangz@microsoft.com>;
>> > > > > > Wei Liu <wei.liu@kernel.org>; David S. Miller
>> > > > > > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
>> > Jakub
>> > > > > > Kicinski <kuba@kernel.org>;
>> > > > Paolo
>> > > > > > Abeni <pabeni@redhat.com>; linux-rdma@vger.kernel.org;
>> > > > > > linux- hyperv@vger.kernel.org; netdev@vger.kernel.org;
>> > > > > > linux- kernel@vger.kernel.org
>> > > > > > Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of
>> > > > > > cfg_rx_steer_req
>> > > > to
>> > > > > > enable RX coalescing
>> > > > > >
>> > > > > > On Fri, May 05, 2023 at 11:51:48AM -0700,
>> > > > > > longli@linuxonhyperv.com
>> > > > > > wrote:
>> > > > > > > From: Long Li <longli@microsoft.com>
>> > > > > > >
>> > > > > > > With RX coalescing, one CQE entry can be used to indicate
>> > > > > > > multiple
>> > > > packets
>> > > > > > > on the receive queue. This saves processing time and PCI
>> > > > > > > bandwidth over the CQ.
>> > > > > > >
>> > > > > > > Signed-off-by: Long Li <longli@microsoft.com>
>> > > > > > > ---
>> > > > > > >  drivers/infiniband/hw/mana/qp.c |  5 ++++-
>> > > > > > >  include/net/mana/mana.h         | 17 +++++++++++++++++
>> > > > > > >  2 files changed, 21 insertions(+), 1 deletion(-)
>> > > > > >
>> > > > > > Why didn't you change mana_cfg_vport_steering() too?
>> > > > >
>> > > > > The mana_cfg_vport_steering() is for mana_en (Enthernet)
>> > > > > driver, not the mana_ib driver.
>> > > > >
>> > > > > The changes for mana_en will be done in a separate patch
>> > > > > together with changes for mana_en RX code patch to support
>> > > > > multiple packets /
>> > CQE.
>> > > >
>> > > > I'm aware of the difference between mana_en and mana_ib.
>> > > >
>> > > > The change you proposed doesn't depend on "support multiple
>> > > > packets / CQE."
>> > > > and works perfectly with one packet/CQE also, does it?
>> > >
>> > > No.
>> > > If we add the following setting to the mana_en /
>> > > mana_cfg_vport_steering(), the NIC may put multiple packets in one
>> > > CQE, so we need to have the changes for mana_en RX code path to
>> > > support
>> > multiple packets / CQE.
>> > > +	req->cqe_coalescing_enable =3D true;
>> >
>> > You can leave "cqe_coalescing_enable =3D false" for ETH and still
>> > reuse your new
>> > v2 struct.
>>
>> I think your proposal will work for both Ethernet and IB.
>>
>> The idea is that we want this patch to change the behavior of the IB dri=
ver. We
>plan to make another patch for the Ethernet driver. This makes it easier t=
o track
>all changes for a driver.
>
>And I don't want to deal with deletion of v1 struct for two/three kernel c=
ycles
>instead of one patch in one cycle.

I'm resubmitting this patch to replace v1 for both driver.

>
>>
>> >
>> > H>
>> > > So we plan to set this cqe_coalescing_enable, and the changes for
>> > > mana_en RX code path to support multiple packets / CQE in another
>patch.
>> >
>> > And how does it work with IB without changing anything except this
>> > proposed patch?
>>
>> The RX CQE Coalescing is implemented in the user-mode. This feature is
>always turned on from cluster. The user-mode code is written in a way that=
 can
>deal with both CQE Coalescing and CQE non-coalescing, so it doesn't depend=
 on
>kernel version for the correct behavior.
>
>Yes, but how does userspace know that CQE coalescing was enabled?

The user-mode doesn't know if CQE is enabled in advance. If this informatio=
n is required I can modify the patch to pass this information along to rdma=
-core. However, this is not useful as the cluster is running with CQE coale=
scing enabled by default, there is no need to know this information.

