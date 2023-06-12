Return-Path: <netdev+bounces-10153-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D2872C8DF
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8D07281179
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59EAD19BA9;
	Mon, 12 Jun 2023 14:44:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C30E19903
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:44:42 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2071d.outbound.protection.outlook.com [IPv6:2a01:111:f400:feab::71d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB2493;
	Mon, 12 Jun 2023 07:44:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfvrtfvdgD85rqbmbuqlAYMRefXs1odV/GCRhYeZYhMpqPGHGVwR7zm34SfYxWsvBIufObqVs2kIijLVo2nS8SUnLB5GmavOiYXgjal1oNKvQ7IPepqkjRD59B608RvxQ1ZC69Z321F87EUBwCfT15mQKZF5HUMeekb+1CjY2tVXXmleOWZgU2bkbWJfULycYVlI25xOtnY9RlUW4iuSYy7fBulwxzYVBIU6lSi4oYLvO6lfbXUYCnTj+o9QlgYJp5ueXX3eVTL5gFC0mNl9659u4QCjDlLO/B+iol4jNVgXHiQQEQ0ze9QPEh0vJRSf9RdOFKg0JwrfsmCSkZ0FBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+3lUFWKopzi1eL14CGUb1EQdG4zbouTP+jHyGexqsc=;
 b=LHIkq1J3eUJfBGwCrajznLBIFMHnD62CLehgUBo9touI2TuxqSoEwJ4cWcdDV6UP28+JHWfZghXBK+cKmZPXwJR/oI5SotX2TEwPw3PelWuINoBdXMmOH25HsuaRTx9BXUqYZtRwjD9M3OoQDqlOC8sszIlzONSIRA5SfKcHX741F/SzuvWLtbsoMevgN+uPJYoJvEBBF5fvijqlQIEAaXeSRhyonosu501Ns+yKebpOam6TFk0TJOdHdYFA61USKMLVFyx0OA8pX7cxjEppRZWVQ7Z7ibFhDZVp4N/giNs4wwokzCj2GAmh8fkUsg3S2nw3zAUZHXO3UEvsmgGjSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+3lUFWKopzi1eL14CGUb1EQdG4zbouTP+jHyGexqsc=;
 b=Jt1I8qgAGVFcontxA4gUiDVlTzMvzVFZdPlG805A8DkllE9wfQw8kI2HjuExV2QQjmK0iqsnMM6BhlkCsP139/QQB0/onXP8Ny+iQqaSMiciRSE5X/Q1hpX+YtZN9za/XSVHOTiCtv2rZc6VORMOkybcqYcEjX2ZbmGOoWdczxE=
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM (2603:1096:4:fc::7) by
 SEZP153MB0789.APCP153.PROD.OUTLOOK.COM (2603:1096:101:a4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.0; Mon, 12 Jun 2023 14:44:33 +0000
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::7d79:7433:e57b:55b5]) by SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::7d79:7433:e57b:55b5%4]) with mapi id 15.20.6521.002; Mon, 12 Jun 2023
 14:44:33 +0000
From: Wei Hu <weh@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Long Li
	<longli@microsoft.com>, Ajay Sharma <sharmaajay@microsoft.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, KY Srinivasan <kys@microsoft.com>, Haiyang
 Zhang <haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "ssengar@linux.microsoft.com"
	<ssengar@linux.microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>
Subject: RE: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Thread-Topic: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Thread-Index: AQHZmIoyK0/pJvWPX0+gdBo6594smK+F8UuAgAFVmQA=
Date: Mon, 12 Jun 2023 14:44:32 +0000
Message-ID:
 <SI2P153MB04417877A20ADE1B1AEE1DABBB54A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
References: <20230606151747.1649305-1-weh@microsoft.com>
 <20230611181857.GK12152@unreal>
In-Reply-To: <20230611181857.GK12152@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5b880b88-b598-4ea6-8161-006080eb9296;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-12T14:41:34Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2P153MB0441:EE_|SEZP153MB0789:EE_
x-ms-office365-filtering-correlation-id: f759156b-e1f1-41b8-ebe2-08db6b5388ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 6ZGJVWGGQL0RkQ/bhw80Z6t9XDZbBb0/vFW7MOiNipZFjEEwBa8SWbdNGogmq9yHU662+U8V1XhXvufpyfInQehOs/brhmkMy3N+APu7IgAieU7eVZqVt0zPyV1H8GD94L/QxaQ+FIt12I/R0C1dN7ziP5cRh6zplZm6fm9svJ32yrbLIXjgp7xyzT0UZWPE86X5E/SUs1rbSJjH2uyRZlaRKSQuimr54W+mgZdOaTUZhZQOmDeJTYqis8OAglqA85/0rBFhLUs/sgDWrRM0k64R9bL5OroILm9a8pFbwslOVELcVssOx+mKGbXKbh8vWawvYfipWSgTCq1K56hyfgeA2BCQEDl5fD2R4n/pQEop3Xte7fTWKGtkAC2NIC81lHvivyLnVrrwPbk859VYuUAFrkB4QJVSBCU18killq1Bq6hQE3tEW2TQn8e4ikJQGgPIIdbC61RFCAcW/7QoQSWidHTuN/GSd4G8x3eN+coI/p6FvBdB7ILWPTtJR40r2n8qvtB/9iXR61cKNFUGxYAU9gaoTTMG9rCVjz+fmc4IK4Qb47/OPLe+3J0QwucyUucaHuRSxZh+ruFAfb3uBbYjuAd9X3JIwsZi3iOfWSyAiYxMYJYhS7EDWTywNgwZgWhjGJzbGulZAayIxDT6XUeC6uCKEmUs9FBDlEm+llg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2P153MB0441.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199021)(10290500003)(41300700001)(316002)(7696005)(5660300002)(52536014)(4326008)(66446008)(66476007)(66556008)(64756008)(76116006)(66946007)(71200400001)(6916009)(478600001)(54906003)(8936002)(8676002)(7416002)(38070700005)(86362001)(107886003)(9686003)(186003)(38100700002)(6506007)(26005)(33656002)(82950400001)(82960400001)(122000001)(8990500004)(2906002)(4744005)(83380400001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1AtSPlLvrC4fst75FvZ+7jBvR1vDzbSobTmA+9fVnhEaikJB4MK+62PN8x2D?=
 =?us-ascii?Q?/aTjj6Ff4Gl60r28ntGJnL48LSjGFDpMeSu1u03MwAPpEw7sZdrd/DdkswE1?=
 =?us-ascii?Q?wH1+pi7djTAIUm+sHh0IvmiTnQ3T/Nh3GxS0YcJNHHNG0A4t8HBhE6vYqyEA?=
 =?us-ascii?Q?wycqPjWoA4lZoZ4/OvbT8ZJwqtOK+v96q1MSOECFx4HOELLe+igThVn3Xsne?=
 =?us-ascii?Q?lCiPJMtYL9j9BwTUvYcHR1BmP70EXUU2bVG1MnTst0Ujjq0o8ll7eDM+MFSf?=
 =?us-ascii?Q?/CQHD4VhqZ3iEu00gLjG8dUnDtH8WGhVWUuov9EMgwF1bIYba1T6MDTa7+Ov?=
 =?us-ascii?Q?g34LFaTPNfTxIGS7LOTeVeO1j81cWMXSgGfmXrGDN8QbpTogu1sbdeX50apX?=
 =?us-ascii?Q?HFNBvvK4ITP4wQgr4DOypRkATzpXdZOguuaYkUsSaNWd8uMlYXTyjSmDTs47?=
 =?us-ascii?Q?f9q/l+FGWgNYlh5nqU6RQJnUZ1ewO4ot2v8i02/i7K1iowRPu3YdAfR9C255?=
 =?us-ascii?Q?m5vYGWENJxyWwIX9zS8J07YU9HZDJFM1Sf6Bm8PR13YRCzvYCyHmClZ2jVEn?=
 =?us-ascii?Q?Ra3hzGfDhio28YL/L9uuArRGetDA03X4iJk2I4HygSs4ENyVFcXpo8XgscQI?=
 =?us-ascii?Q?DRZUtFPYcQnWIose/Z5nqKamkeu56RAvD5gU/NaZr2y3Pmyp53lxFKbEFTRQ?=
 =?us-ascii?Q?XX84iHfN7iI+eM0vP83Oli3VoYO3/gYqRfAEyelrorCGSkSVZgE6RzLFR8LV?=
 =?us-ascii?Q?XGnmU4+0QS4zc8X1nYPyjMwBWV/a5d6fSS7vc2sUucJPoMwDoxg3Ln4HG9B9?=
 =?us-ascii?Q?Gzz+guE6yHbCeqDwp5rsG4Ue5NwwpkTEY/2JxVGO4Ga2vcYPi7KK/DMKM2XM?=
 =?us-ascii?Q?alwlpVY/pRLhLTYZ/UvuB7Yk1CYbMrho6lJCefjuGifIXcvQFPhfW/EvMibO?=
 =?us-ascii?Q?MmvNCFnR31Hh4x1ZpSNnmugD9TOXSbplos85wn+HeXGHHWsW2r9GMMSvc9zl?=
 =?us-ascii?Q?0nEDf7ByPFWVDKU8g+svgkJXg4V791dMqTBTxG/jQjaNAV1QJoIbuDEXvCKi?=
 =?us-ascii?Q?CBDeDgZTFVOkX78l0ea45nsVct6g3sSpQjMIwLjst7yzk6q8NUEkDvvL7tgc?=
 =?us-ascii?Q?xQBV5XsdGAf/9xEvcvKWL5J5FST1TvUGZdxIPI+1wXMYEB/2u2OKHG7INLwl?=
 =?us-ascii?Q?ehTwcjmnVwcD1AFGx88gQbkwU6ohcI8cJpO2i5+oGdG6YpvWk84Nphw1QumV?=
 =?us-ascii?Q?ZPhVrk2OhhAZwRmuAy5MxARJ7+iur5vMmHkLhpmFWBIHETxN/kI3HlHeadKT?=
 =?us-ascii?Q?4pBYJ0rWYUlnK0w/05JhnXd70n/jgS1pt50aXiZuhAIrSXAHwq/16+pGQBKN?=
 =?us-ascii?Q?RDSnPAK73wtkw6CvgjEvTRF+nM+zKAUb/4oNXzVP1jZhC5XG928j2WS++/5C?=
 =?us-ascii?Q?YCAcDZbbX90FCkvDgMha6QaBxekjSdc5TqLhv6Ch/U99yH3eV2fCs/XPYNSe?=
 =?us-ascii?Q?IPUEJ+5I0T8U9xudVOQQ7YvMgYMcJBucAeRg5KQmjPg7rWCFYFRqqIvIC08O?=
 =?us-ascii?Q?TmeT27PYgdpHG9r5CrE=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f759156b-e1f1-41b8-ebe2-08db6b5388ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 14:44:32.6257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S695oSh5HqIb0b4bktkHQByPE9Imp/mUt/MHEgUTAhel+D9Y06w/r4K/wOinGf34T0dClokE5pGeUqNFEQVkeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZP153MB0789
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Monday, June 12, 2023 2:19 AM
>=20
> > +
> > +void mana_ib_cq_handler(void *ctx, struct gdma_queue *gdma_cq) {
> > +	struct mana_ib_cq *cq =3D ctx;
> > +	struct ib_device *ibdev =3D cq->ibcq.device;
> > +
> > +	ibdev_dbg(ibdev, "Enter %s %d\n", __func__, __LINE__);
>=20
> This patch has two many debug prints, most if not all should go.
>=20
Thanks. I will remove the debug prints in the normal path.=20

Wei

