Return-Path: <netdev+bounces-4796-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 562FC70E563
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 21:31:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 813FE1C20C8B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783DD21CE0;
	Tue, 23 May 2023 19:30:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1DA1F934
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 19:30:58 +0000 (UTC)
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021026.outbound.protection.outlook.com [52.101.62.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FA010C4;
	Tue, 23 May 2023 12:30:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lL5XwCbRaV+VE6R6jdF8NFvrP8/TtZP7t+xSv9pJ1kJHH6fEcadu7L92P6KCTxFFzUHqykvGMCUkgpioMg1mreNFX5COzOKu/a1HTeSn8yjGip02Ca2qzheY/9DYYPnmqw6jonwl8dYXzqMFHtVJiAYo6kha/EhYV3UZd2VGXPlXyval4DALdmy4ns5/4G/EmqhjJlfnwORfD0Opjmjvwogf0ctiOMH8kY182+ckJhU4BHZb7nL10KBVxyQT1a1KVOpT5689JsTBd58PNBc0X9eyWQ35ZBrgmOD4PR5QBK7IKE0Iqrdg8J6h9/1YbwSCR99Fvy6FYUOQ7OoEFG2QIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dUOrsJYrsFkCBHMJuybvyu+NhE81VgyEwuBOhHmc2I8=;
 b=h/oGks4kOeiQ2u09XZgROmaGOUc27TreEoAs1hSX5tdb8qxfX6vrceiDF/FKqLXlZCMMY667EfRTaHHC44PSf904q9OSvJe4gDcdgN3DVTQzT1nU0T7HRPiMdZWWlzCNs626SaDG3z6vliN+V63n8EAH4/m2+x1o8Y03C3wzdZA02/rMSHqOav9RWSSBb3aS8kIu0ppf4Uc3jE0le5PIjjVTkwHyUfIhKXQQS5myHNND3CizkB1qzTV94zpu5I6e6qQBsksHYkMtrU6ZVBUZcSuzvSoQZv84zNNZE8BQNeumSwNxWa3Nk5/piHze0Bi+bupZWlLkl28g3pwwVmYKLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUOrsJYrsFkCBHMJuybvyu+NhE81VgyEwuBOhHmc2I8=;
 b=jF1LqbhNmJ0oOEIkZ0EGYS/9D4ggb+Z0dsm5BapJ0sMlJVt1a/5tuYLVGWkkgX3yj4/Z3WCSI3CMTE9IdHPG0m0ZRWUCTKydTQ9xwUXif81jvP5SplGnZIWiMqGHXflPI9jpQYOTsst5zYu+lJmPXCe22cYQRibVMRu8CFTQDc4=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by BL1PR21MB3114.namprd21.prod.outlook.com (2603:10b6:208:392::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.13; Tue, 23 May
 2023 19:30:37 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::c454:256a:ce51:e983]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::c454:256a:ce51:e983%4]) with mapi id 15.20.6455.004; Tue, 23 May 2023
 19:30:37 +0000
From: Dexuan Cui <decui@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>, 'Lorenzo Pieralisi'
	<lpieralisi@kernel.org>, "'bhelgaas@google.com'" <bhelgaas@google.com>
CC: "'davem@davemloft.net'" <davem@davemloft.net>, "'edumazet@google.com'"
	<edumazet@google.com>, Haiyang Zhang <haiyangz@microsoft.com>, Jake Oshins
	<jakeo@microsoft.com>, "'kuba@kernel.org'" <kuba@kernel.org>,
	"'kw@linux.com'" <kw@linux.com>, KY Srinivasan <kys@microsoft.com>,
	"'leon@kernel.org'" <leon@kernel.org>, "'linux-pci@vger.kernel.org'"
	<linux-pci@vger.kernel.org>, "Michael Kelley (LINUX)"
	<mikelley@microsoft.com>, "'pabeni@redhat.com'" <pabeni@redhat.com>,
	"'robh@kernel.org'" <robh@kernel.org>, "'saeedm@nvidia.com'"
	<saeedm@nvidia.com>, "'wei.liu@kernel.org'" <wei.liu@kernel.org>, Long Li
	<longli@microsoft.com>, "'boqun.feng@gmail.com'" <boqun.feng@gmail.com>,
	Saurabh Singh Sengar <ssengar@microsoft.com>, "'helgaas@kernel.org'"
	<helgaas@kernel.org>, "'linux-hyperv@vger.kernel.org'"
	<linux-hyperv@vger.kernel.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, "'linux-rdma@vger.kernel.org'"
	<linux-rdma@vger.kernel.org>, "'netdev@vger.kernel.org'"
	<netdev@vger.kernel.org>, Jose Teuttli Carranco <josete@microsoft.com>,
	"'stable@vger.kernel.org'" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Topic: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Thread-Index: AQHZgxiydynY9JdEwE2LUDobn6ASSK9TueZQgAnkUiCACrRlcA==
Date: Tue, 23 May 2023 19:30:37 +0000
Message-ID:
 <SA1PR21MB1335467F58B7BB5EBC9AD543BF40A@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-7-decui@microsoft.com> <ZFtUgCVaneGVKBsW@lpieralisi>
 <SA1PR21MB13355D8F2A7AC6CA91FE1D1BBF779@SA1PR21MB1335.namprd21.prod.outlook.com>
 <SA1PR21MB133549FB41041ED218E2C73BBF7E9@SA1PR21MB1335.namprd21.prod.outlook.com>
In-Reply-To:
 <SA1PR21MB133549FB41041ED218E2C73BBF7E9@SA1PR21MB1335.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9404ba2f-9e11-476c-bee1-b05b22020f31;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-10T16:54:12Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|BL1PR21MB3114:EE_
x-ms-office365-filtering-correlation-id: ddd1e713-de15-432c-800e-08db5bc42f77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 B41YGk0lc3PlqemGwFGS+l+Im2r/DRCGRF/dIbNPWc3/Ri/OT8F+4KJSztAh/J9fF1WmUXF52jMLG+0rtwq008DwOSwxbzOUrXDabtyv1f4xJuzuHjd0F69HsV3mmRq6tKNS1TdLXFR6NL9dUYR/tphMCIQdqsQRnenSeCqN4EKjqNXkN8zBn4IqrNotFEXGajv/bqPsMFsIWOnuDOZ6r3QiYReB72khflsvKEF4QU6fOqlVH0lMK6tmJO+zOyy7TffGXZ7WhsunJECsobafU4vLVoGNboRRae/5il3GhUHf1bRoYzTXM9aJFK2qrlv4KafUXWo8KGt6+ESYV8RmRYyDFNapToMATSDglYJYMEYMTfFfILd88W5s9dIhS5WxjRfzythUq4yXELM1mOz5buG7MHMvfbexiFScltGgH9nZv2B1Fab6dj6qw3QUcd/ph3h6uOEIZudEEfvM/0RJ23aKSRvnESS3mDFIP7pR64oZtX3xzP5juzGD73ZK4i2uQA6mSwIvaJyvr7UEFiVeyOAzpObG5lfZvV+ryLOI096Af5PpH0qA7RJ71aS7hqrQcKciV/tTMTnC5YP7SClKWBP43mNCg6sX+MIMnl7s0H2T7OkJa5Tn+9HZm0Ypg3s9ftF1k7WkATdfXNd7A7A7qN4YfQ9pGz545QFHx4KNnHs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(8990500004)(83380400001)(186003)(2906002)(7696005)(4326008)(66446008)(64756008)(66556008)(66946007)(76116006)(41300700001)(786003)(316002)(54906003)(66476007)(478600001)(71200400001)(110136005)(8676002)(53546011)(52536014)(7416002)(5660300002)(9686003)(6506007)(26005)(966005)(8936002)(10290500003)(55016003)(38070700005)(82950400001)(86362001)(122000001)(82960400001)(38100700002)(33656002)(491001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?mchEVf1h9egY5lKW/SxxyamvQLzKyWARi6RuJXb5B+MOUiCT7HhARoSnWTcJ?=
 =?us-ascii?Q?CJySe9M00cKHs+xJ1RRV5bwJYvcG/fi23VD0wSdFvQzaLDrswVbx2g7vfqB3?=
 =?us-ascii?Q?TPjUuDuPJ2HGX11ibSbkCQxYYmOmls7jfcNjr86sSQUjtYs7BEr9QUQNaceM?=
 =?us-ascii?Q?zgkZyobTpBRl5oFBj635njrvGOYUCeE3WrHnhW5ao4FKF22MztcMellCYnDP?=
 =?us-ascii?Q?rGhbDIf+bOSm+Cp2mGpHLGYvHyf6heyp/snFo3gXSXMaCIAuB0wgNJanR155?=
 =?us-ascii?Q?tV7BGglzjdU32SDiAOOigHLdmcBkExFdF7ss1NORt6nvr2sIk5P7FDY4Yt5N?=
 =?us-ascii?Q?L3ysJuYG218KiNqKdX4W08O64sO3CXt+WG+90yxYgn3zIAk/BvjmUsT1yqaM?=
 =?us-ascii?Q?SOw89S0MYcqcxM2uXv6BOfk856GhpZTPCUFYjzJxW4uTMVFirFLMOn97k/OG?=
 =?us-ascii?Q?4qXWzFtTcL58iuHVfO9OdYSZOyx29dvUGCdAmIo23izYRvTUlgRibGYy1HAs?=
 =?us-ascii?Q?556bwQ9rh7+dQbVxRuSqsyfgBC8+E8N+DBv3aEPjtTgbV2ayuZi9YTxTTEpE?=
 =?us-ascii?Q?bIX4UUt+xbPKMEx8NHGcd6/ewAB4+n1YoIbFt9azuNV+Em/SOSuxvYsu3EzO?=
 =?us-ascii?Q?Z0B1JLpXjgHm/iu5js6yprFps38a/LErqdQEiJEzEBpe5TOCZEQZQy4kCYCY?=
 =?us-ascii?Q?/a6iZf7cRAVXyw2ul+5OrOKxFj5De8/0EE8C4UGlVn8RKXnOL6kx1UpvvA5V?=
 =?us-ascii?Q?2nKa2V+y7SFkbE+lXkBbUFZ7xQF123BA+UCkamRGIBE4/nuuGQAt1aNFoVg9?=
 =?us-ascii?Q?VyUfycYezPUqbTR30nY8bnQoEpI4BpqiXLtxkqteDUe/oiNcub1XmNQHpHZB?=
 =?us-ascii?Q?2msd6+2JineMz3Xb1VLcSktlRH5N4GtaLgHOQHVR5SR21hPOcv49Lbqiw793?=
 =?us-ascii?Q?NdJ4cuHeSiWLlOEwaK2K1zJL/IbIx4uVbO+RXlPUPDCW5cW4A6ZwgpF/1ZRg?=
 =?us-ascii?Q?9KWfuIma8b7SKnmME5N7Xi8d1LFNYROphRYq4OQM3oXDQEpGGIBkUZuONCvU?=
 =?us-ascii?Q?4umX49xJd0Ok2v37oRsdZrz8cWVep4hdQeB47BfBbhh5KEtL08UVQS5w2zxJ?=
 =?us-ascii?Q?GQBVt1II1dRSiWuYFlkisZzS4+HI3IF6UhbO39iCRdtFl35KtXaFJF+EIWbO?=
 =?us-ascii?Q?BcKF1lv+z/6fP9oLadePKBLF3jTSScHinUyia109YzpsR1gVIG4FnYnsn4YQ?=
 =?us-ascii?Q?XI1bxxG+pwW+M4kCVJ9Csocb2Xxd08usUAikfERzONUoCkP3V/tpIh9ach2z?=
 =?us-ascii?Q?mNhPY/j2bUsv+H30zfmKqQs04KLAsaZAZX/QNOUOXMsLYqgHFE3zyoL3jnBX?=
 =?us-ascii?Q?dc48HzGmEOEy/RLK1ZEd/GxxAJ332Nv0jZTZGHUOts18Y2yUuMyH97JmigmA?=
 =?us-ascii?Q?G6YrWQyOVY3q5+beEN3FFKykb+JGxi5wOfcRsvCqXW6+oU3qfAHTw/oJwpat?=
 =?us-ascii?Q?esEKGTiWe3Q1KlzfXWYwjhIzZgarebWqHrUiE/4EoF+Ysk7Oyg40ed3e2HEu?=
 =?us-ascii?Q?LagPtRx22ikdsZhQDJdsUlLgW9cvvAH6gbRpYdN2?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd1e713-de15-432c-800e-08db5bc42f77
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 19:30:37.0937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P3IOglv1Crv/ysxiRRViBEyGNjnprONM+s8q93IkiScQ95CiuyAa7fVPlrMnMdut4DbM0moj7qu/rcL6k5NZCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3114
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Dexuan Cui <decui@microsoft.com>
> Sent: Tuesday, May 16, 2023 5:03 PM
>  ...
> > From: Dexuan Cui
> > Sent: Wednesday, May 10, 2023 10:12 AM
> > To: Lorenzo Pieralisi <lpieralisi@kernel.org>
> > > ...
> > > This patch should be split, first thing is to fix and document what
> > > you are changing for pci_{lock,unlock}_rescan_remove() then add
> > > asynchronous probing.
> > >
> > > Lorenzo
> > Ok, I'll split this patch into two.
> >
> > Thanks for reviewing the patch.
> > Can you please give an "Acked-by" or "Reviewed-by" to patch 1~5
> > if they look good to you? The first 5 patches have been there for a
> > while, and they already got Michael's Reviewed-by.
>
> Hi Lorenzo, Bjorn and all,
> Ping -- it would be great to have your Acked-by or Reviewed-by for
> patch 1 to 5.

Gentle ping .

> > I hope the first 5 patches can go through the hyperv-fixes branch in
> > the hyperv tree
> >
> https://git.ke/
> rnel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fhyperv%2Flinux.git%2F
> log%2F%3Fh%3Dhyp&data=3D05%7C01%7Cdecui%40microsoft.com%7C65c86f
> fe8d8542dbae0708db566a1607%7C72f988bf86f141af91ab2d7cd011db47%
> 7C1%7C0%7C638198785892993948%7CUnknown%7CTWFpbGZsb3d8eyJWIj
> oiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3
> 000%7C%7C%7C&sdata=3Dh9vxjnGo6oYzare%2FqqcXndg2NZZ0Ap%2BH33q0i
> Mtf7D4%3D&reserved=3D0
> > erv-fixes
> > since they are specific to Hyper-V.
> >
> > After the first 5 patches are in, I can refer to the commit IDs, and I
> > will split this patch (patch 6).
> >
> > Thanks,
> > Dexuan


