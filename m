Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD7A6800F8
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 19:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbjA2SvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 13:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjA2SvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 13:51:21 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020027.outbound.protection.outlook.com [52.101.56.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CAE9C;
        Sun, 29 Jan 2023 10:51:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtrxIViZxFpI5ILycOpHTNqbQP0EtjdipG44ra1h1WDtESjwY4JKyY4WTFbNZiHRci9JuKVnCYx7+uqgY3spUQZcP8H6ggp5ry0VLXW13WhveaS7HaHr7eJHDJcdPEWD3aAcq3kDkY4tCmWM1eWGkTK2fRG8kNViDBfbbRT7IMBQvJyPDxaTCcg30cLT/9GPsDW17kI+N5Indc813VMV0bnhO4SOAuTH1gK0mWubPO2pmL7UnNUuT6BeXyajNfNVoNK8mMG+RjqhenO+A68EYBiV+m7UDncMJMNiPjx+EoU0LIawUkOJPEZE3po5YMmIIDFrFkUCJlxJNjMOuLfcDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WT8cwQKcZRzJyWw4fHb2yy8XTgxPpDGuLoaQhDlCoN8=;
 b=AtJHwmW/UlHA7McMuux10osgxP2SS/TKaHsZyXwbCcprknkYQIjcXKqP+mjn25zW0/UCdUoHqv3AjCR97u/3TdflmAczE+TyY7BaKB22kY+lWsEGTjtFlJaN6rTwAcMdzQtkDjv+UaEOze5h7HGzYP8vI/432yoh4VXAQM3Aoy4i87gIoQHuQGTM/6f2+rxHzjLwK3dE9A3TjimZP7ZjoULbdJubPtIHpaEl6MWdCzc8U3/KYLsVtO/O4ZP17uXOV7BY5d5ZBWCiNfeIqHSb0ubSJutvNnP2+WEcyMKcy8E4cxjSGz0FeobsHtAAD+482nSC4K4fGIi1yLfC638lHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT8cwQKcZRzJyWw4fHb2yy8XTgxPpDGuLoaQhDlCoN8=;
 b=R60uni2Q/FFhRq5LF+c61UKL5Z4FI2avgGEwzlallPykUILmdiueyqIVS+Ir4ZSTceZrCnaUYLx9MP9f7gGKyzsiWCFT6728yNOEFDR+3Q6YaK+GlSVKCRmDFHnJxIOhEHQ4WEZMqtuHLldJyt0OBt80steCU15qqASybKfJppU=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by SJ1PR21MB3745.namprd21.prod.outlook.com (2603:10b6:a03:453::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.3; Sun, 29 Jan
 2023 18:51:17 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce%8]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 18:51:17 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net, 2/2] net: mana: Fix accessing freed irq affinity_hint
Thread-Topic: [PATCH net, 2/2] net: mana: Fix accessing freed irq
 affinity_hint
Thread-Index: AQHZMcn4aI2nsbHR902MpaNNd4HTWq61d9eAgABJsAA=
Date:   Sun, 29 Jan 2023 18:51:17 +0000
Message-ID: <PH7PR21MB311613A4A8C7436BA78506F0CAD29@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
 <1674767085-18583-3-git-send-email-haiyangz@microsoft.com>
 <BYAPR21MB1688D54F89D19932B3654E0ED7D29@BYAPR21MB1688.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB1688D54F89D19932B3654E0ED7D29@BYAPR21MB1688.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ed50092a-4a52-4891-b37c-98888b68e03a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-29T14:04:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|SJ1PR21MB3745:EE_
x-ms-office365-filtering-correlation-id: 8b5aed20-c848-425a-7d62-08db0229cdea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X3K0nfnRYOYGTq0Scc6biwIv7X0kPv+XahqJTpoZ9l1jfgRE9VQkyV2tWtjSzTOA0l0idbhKJ2+BYrQfrMRZMbaj88aSSgKDhXSR7JlM/Cz/EEGGTCce5omuujsIRM4dOt/9b8qc3V1CQu7GD7Qn1gG6p6Jej1HrYwCKRHEvgjNzbBcQPaC3EVFXs6B75qeE0K9roBErLr3YY9RWvrSXRzMQIRH9Yi85wAablwXYXQ1+QPJ8fA+78AaVpYKqS3Fd7so8fR0S07EYKMFAjRyelC37ExtgUlwf/MSSmzi0XYJo5KmZVzEFaZMkJPp5YBtuVq16QpXcgvSbt5nS5onguBCGduwTzd3vdSaEmkgtN7AzUd10NOsxAk2J9IVCfEceJ+mFQ3DsThjfbcNRZw8eEHW3mYjhB/1Tu5KJ33wIt9L51XywImcGe/6Geo025CvzCkEUl6cMe9HHOntZNCzVM6R00eaKs9DcfwPk8umYBKjk8UKovbpSVYoXpJUKw8Y1Js0Q/8a+c/FHX6wsEygGoQKHpPcA3oimI/ih+6cIc7sdTi9gyAf24FFBDfNcAOkFMImc3xiGG65w111e9sbmlHjcF3xwutXU4+hq0hQyHlgdbUnuoWG956Qthq3IECo6CSV52RVJnuuW7JWLmS1dGXPXoRBR7eZPkoI/ixGHR2L5Qx6c6x7+RyXhz7Oa8WH1oLe6GzoAFytWwJI6T262RTogaOUxQmpzlk8473y9mTxG47KdMkhdfTTIn0l52+u9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199018)(110136005)(55016003)(82960400001)(82950400001)(54906003)(33656002)(38100700002)(10290500003)(38070700005)(66446008)(186003)(7696005)(71200400001)(26005)(83380400001)(53546011)(5660300002)(52536014)(8990500004)(41300700001)(2906002)(316002)(4326008)(9686003)(64756008)(122000001)(8936002)(86362001)(76116006)(66476007)(66946007)(478600001)(6506007)(66556008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eBS8WmwYQNZ7F+YeW6euqFUzltCJTkI1th+AfNNmNAhGannjVMWEOIyda/jq?=
 =?us-ascii?Q?8MDDJ+OalUMF+KZodgGy7A0SK4zWZqEm8KNmrdpZUfbTILAxQhsf7tEvKFiK?=
 =?us-ascii?Q?PbH2SAdWXDY4t8xQvSNeBsHX6jYTZSt19ZuULiPoYIrsZ4xFO7btDCwQqScn?=
 =?us-ascii?Q?x8BznZ1l5IQSVSUZ7IDP0CXU7LehI17lCbC6KkSE7y2k4jHX+JpXn0l3HsTd?=
 =?us-ascii?Q?qbXT6Lbs5L5C2u8WZ+4GXizP+5tMAODb0QUOpQMvFu3xcKhLYYUmg5xzGEs8?=
 =?us-ascii?Q?57+x3kzppFgGT3tA+5OJ5shJdq0CcaEZBAMdLBlll0nMtqdZQaPQeWDWFbWx?=
 =?us-ascii?Q?XKevGO3QsUt2oecio3Cv8gzikzaptRdBxQ42vGevsArqGfTdmiAZADmAWeW4?=
 =?us-ascii?Q?baff8zazVzjhHrw6+K5t73aM74gjx7ZJ4ZhseDDPCSOJCWt8kmpMjJTDk2lo?=
 =?us-ascii?Q?HCf6jtD1A/2ny8KRpVzMg6hQzuDbro/9t78qiVruw0aSjOoxTTe1WdROBh1N?=
 =?us-ascii?Q?WM+MjQlhAQwI8yniKtMHqOUfsOdI+PP9MITYjN+SV2znrjlp2E9kRoVph4Cb?=
 =?us-ascii?Q?zQSWtDFSjMxaNMzHjDNSUkbZwog9B1hdb66wAnaTzKiJjyJT5BQpEeXSaUEu?=
 =?us-ascii?Q?QF3Zs9qCmUFdIyhyDg3/JzWf5tEwYrNQyj2ciexQ/TILmbHKjGjXQBYnHBpO?=
 =?us-ascii?Q?MPsEwcIWk6Qw1FoLCW30rdtesqNF5zjGT5gFkVDPS1C7QPhRMQqbUCHjVf08?=
 =?us-ascii?Q?Dw0AT0kFlXoFnbiBWRyioMvVrS/iOFYhzscYUpmWrn6JHQlxZrnoDEwE21qh?=
 =?us-ascii?Q?ADoU3Otq8LJ1S60r3t3rcRk3OtqLBJGMCTqkmxaCOnVon113vE7vfWm24f+c?=
 =?us-ascii?Q?fMJscDVp+/AofWEY858c58qkjuavcxznS31fr518e5tHbVLtmG2DDsnGumYk?=
 =?us-ascii?Q?AKoSCt/PxrUNZ97MW1BlGk1cJzQN2+pBL7LvLechGSpJzuOeMbJvviiEj38G?=
 =?us-ascii?Q?sJ7Qy/Uhwdfx8YOl7UEHKS+dzVz0kAGoTsW8Pyfs9MH42QNnDauMBL3qoWgv?=
 =?us-ascii?Q?NYwVDmI04/6J5NALe68cmVyRdxJZrblH+ZZR8LI8I5ovy6Y65x9fByXOCPZb?=
 =?us-ascii?Q?Gu+vg38biXJl2MAwhY9Fa3Q5Ae9846/Hdhto/YNzQzvwnhOfdIjJQ0wlC7A6?=
 =?us-ascii?Q?drxQksUP5EPEJwosTuaq2XTRbtOYwCQDeJuvx04wg7IliaIjm1x+E/dTN9ok?=
 =?us-ascii?Q?GvXpeegDks6pz/X+WOtjAA/cM0Xee8W5p2monXmeVaxdYPfeBLj5XkI8lgOM?=
 =?us-ascii?Q?/Wr0TjB6/JoOMdGpCXemIf3pUI6hqVN788y3RTccwtJOuYmAUf2RrsVsFiFk?=
 =?us-ascii?Q?laAVUPD+VcUqyers0G+jpKBt9IRNRfFfPXau6xuhShaKxjOtvXTtFmG7cQ+G?=
 =?us-ascii?Q?n3QRjhoJ0ra3J5WXh/C8llXymhuYG0t5givkyyAI7lAtvseBXkclMyNF8UkL?=
 =?us-ascii?Q?2p75fC5Rry+0qsxSyNt0FmwPT8wrJS4yD/03OAPtt8UwSkzU5ZPhTJokkFvd?=
 =?us-ascii?Q?M+V/aQ4z7YHbKyQAz40oyeQ6cQGwKefNMMcJ8hy+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b5aed20-c848-425a-7d62-08db0229cdea
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 18:51:17.4356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fk5rCbVHy1D7AVLmJWGfRh6+ESIVNdamKhOxCrqdgElrz7tR2M6vyCkwOVDnk0x26ahdUAHhs2lxvPCntg/E4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3745
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Sunday, January 29, 2023 9:27 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: RE: [PATCH net, 2/2] net: mana: Fix accessing freed irq affinity=
_hint
>=20
> From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang
> Sent: Thursday, January 26, 2023 1:05 PM
> >
> > After calling irq_set_affinity_and_hint(), the cpumask pointer is
> > saved in desc->affinity_hint, and will be used later when reading
> > /proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
> > allocated per irq, and available until freeing the irq. Otherwise,
> > we are accessing freed memory when reading the affinity_hint file.
> >
> > To fix the bug, allocate the cpumask per irq, and free it just
> > before freeing the irq.
>=20
> Since the cpumask being passed to irq_set_affinity_and_hint()
> always contains exactly one CPU, the code can be considerably
> simplified by using the pre-calculated and persistent masks
> available as cpumask_of(cpu).  All allocation of cpumasks in this
> code goes away, and you can set the affinity_hint to NULL in the
> cleanup and remove paths without having to free any masks.
>=20
Great idea!
Will update the patch accordingly.

- Haiyang
