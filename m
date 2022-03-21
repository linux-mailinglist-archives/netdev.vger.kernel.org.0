Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBD64E3098
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 20:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349399AbiCUTPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 15:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345444AbiCUTPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 15:15:18 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1E826578
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 12:13:52 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22LGXHQo002011
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 12:13:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 mime-version; s=facebook; bh=QRcu38MgYelMpOPe8dLHNuSpjpNeGcg7p+MQQY6CwTE=;
 b=IBZ7LfbBXhgO7sYBSFy2i9L5NuIBBj8MbRcBNC6rPh6vN5Ep0EPQ+Oh+csbgILCQ2I1u
 zfXxPARze9apf3GUKA8BOvS72lX2KRcr52iTbkxyM5CTDXvJH/I38ikWkUhKdUuVRKso
 Rc/5qTfvz6SMEk55R0ZVR3mTXRWzr/fbUWw= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ewd0tkwu1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 12:13:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXRQGxaJR8446rzllz9Y2AVSM8pIHpdLV/TU3Vp6A5DicSoahzAkB8xPsGD51UhpMhyl5I8l9Njlb7AgsMzpEdGcdurjZHuZesfKXHSDl/xGGxMTPjJ4RZHVdtYCfCJG53DpP3ZQ73aKPzizwQlqUqTrOR4y8xpU/tEjUAp36PkyrH2KKiq/e/XDIR5ykiWL6NMMP75SlcTW2lsEiIQYGdGrdfXKcVcti7L0QimIFBf0sGFsGcVqAoqzm7DjxGWsTW4HqZicDe7yYUsMSGKK2L+T0SHVQC8HvfkR//TuPurcutCtz1NjfSvZyrjbJPqMdGUltgJ6eiWQ2zzdSNwhHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRcu38MgYelMpOPe8dLHNuSpjpNeGcg7p+MQQY6CwTE=;
 b=iSiRCpMeCtMUSyVJVLDbpqHeq7PVyNC5mY4hWPn/DL78oBq5xOd04arll/tlcfGP8vCr1g/dupb91WhVA+zFZUOUFDpaXR1OsWYTXpi1L6raVodMNxD2gSMxULol7X2Q0w+jIZPuREiybr0/JnCPqc1miDF6iU6bzdndsIR3eip5COkEt5jCuEJZQ14NoKR76oOFn+04I4mnh72Xbx7YftIEg/gmbqNkwGQQtrEkzUX85C2PG53S7RQ0fIaH1bVap/iPy9lAr6O5Wmp6Hg1tR7skbtQR1z9IiaGV8tDahEYXByRikF2N5UL1onk0/O8STLHnTE90gaOlhiIfD/posw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5137.namprd15.prod.outlook.com (2603:10b6:806:231::17)
 by MWHPR15MB1839.namprd15.prod.outlook.com (2603:10b6:301:51::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.23; Mon, 21 Mar
 2022 19:13:49 +0000
Received: from SA1PR15MB5137.namprd15.prod.outlook.com
 ([fe80::3dfa:5b2b:a0ba:6013]) by SA1PR15MB5137.namprd15.prod.outlook.com
 ([fe80::3dfa:5b2b:a0ba:6013%5]) with mapi id 15.20.5061.028; Mon, 21 Mar 2022
 19:13:49 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Possible to use both dev_mc_sync and __dev_mc_sync?
Thread-Topic: Possible to use both dev_mc_sync and __dev_mc_sync?
Thread-Index: AQHYPUE8MVfkK9Fj00ejhhCMSFHdfKzKJrgggAAFvoCAAACwAIAAAIQw
Date:   Mon, 21 Mar 2022 19:13:49 +0000
Message-ID: <SA1PR15MB51371E4E673D51C1F17E49A6BD169@SA1PR15MB5137.namprd15.prod.outlook.com>
References: <20220321163213.lrn5sk7m6grighbl@skbuf>
 <SA1PR15MB513713A75488DB88C7222C2DBD169@SA1PR15MB5137.namprd15.prod.outlook.com>
 <20220321184259.dxohcx6ae2txhqiy@skbuf>
 <20220321184526.cdpzksga2fu4hyct@skbuf>
In-Reply-To: <20220321184526.cdpzksga2fu4hyct@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7b7deaa-6426-4b07-6c85-08da0b6eede5
x-ms-traffictypediagnostic: MWHPR15MB1839:EE_
x-microsoft-antispam-prvs: <MWHPR15MB1839DDC43FD5FA6FC2C1EBA1BD169@MWHPR15MB1839.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TFTVn+8SkkWrgmZmqcGPHyVkN99CLoqD6fI1MIrb3GB+Ng4QtmjN9oyqbPsaaBiu38zLFzOAlytk8XveMl0cYcQ4u2gYtarmIhKUGO5dAsesZQ2EjlwW0l4zPx5vWRLpdxoMrAMn0EPvGQRhoWZ8vsKS5BIgzTO8aOprWKRz2qEOBWKqNIH6hzgkMjxNMi7ytcYcHR9upytEiRW6cUGoc53++MfEMrSCcpjBEV9GA0pLrlgILqUOnUpQhAtr7oySuHuiNczrFnk5VToOdtQbKRH0O5PtsFGwHTysha4FNZFrVqfKZ7n43VEQ32t7chiVwnyYbKJNHYHKVq+/LwdUGKHM2RK611sn2CsXx9Ky3RicMJ9owl3tI+A4SbsMd9JoPwSXEPeDGZCuRkMu1JTEzg6F4AtYAU1VyugIAxDhpPrW4BXzv/MiTsPCt7b/imGyrkAhzoj/nnXCQOJW53szf6PVLA8zPij/ikOqN5daVcvvGlmsu28/Nzf116yc7h3KObuFgaq+xoqMXXyk5iY3i6ou3SsX2sI/V1HVGYxPTBalae8DkOFfNu368D0QJRXMzxyGwoQ940M9/mX+o1AMmnwa+KyGaSSlDQEnlUyVdm6wUsOCegPo3u5FE1jWhiAJ1N3W0+AQB3CSbvl2Y5CB1AFtJuFsXf4va4jSX61qO4fba1zt0oW3gXi6CQZ86HPaTLz1PuuxSdWcJrMWtEke3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5137.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(33656002)(71200400001)(6916009)(38100700002)(76116006)(4326008)(316002)(8676002)(55016003)(66446008)(64756008)(66476007)(66556008)(66946007)(508600001)(186003)(38070700005)(83380400001)(5660300002)(122000001)(9686003)(6506007)(7696005)(52536014)(8936002)(2906002)(53546011)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Agna6lUCIboO+4j7HX8wDM4x+9/Gvc8xUSINmkxLGZciaef/egbY2gyIQr1S?=
 =?us-ascii?Q?RIx7uF2dXevaoBqR2ZQjiacBTG50jZHMKTEWhgY7SaeOzP4R62/UzY1AcwXN?=
 =?us-ascii?Q?yxquU/UE3pM4RmkhooAZLqU+7UOszuTdAVTnBkS8AXqHdtm48ZPPDX4Ykj8S?=
 =?us-ascii?Q?/ugpJKZ7Fo+w9Npv65MPTRsH0QMDGcIrmzudpprsiC0FfXm2Kz+R4C2G3/Oz?=
 =?us-ascii?Q?mHj0oll0H9mCD+RF8RUbIl82mkB86HacV8MyPyTIv+gQA62bEK59MC1OSltH?=
 =?us-ascii?Q?HFSlTWfiCnP2xBJWSAOIakBLtfrhoNu2E++aFOXS3kyr/YpQPukSROJU6p2O?=
 =?us-ascii?Q?shPYgN+loCzwQJ3XzYGGXluKk2/pWSch/ScmWhAttrptYcVdwy/s5dGZfHF7?=
 =?us-ascii?Q?Si8aXKRG5Of4QgMSvov92Ao1aeNQSw+TA3hj+zOquwyZE9uCuwXGVW2ql/9H?=
 =?us-ascii?Q?4b/yoZBPWgHHW5wcQB8bnAb1u/iUfbcNh+tDxe1H9Y7sLMBmiRxaO7l9NDef?=
 =?us-ascii?Q?SNRgpVvTVgz/0FEo/jN/FYUTummtBN6NCXPvBbJZZqSP+Bf/GcuLmK6c/hsO?=
 =?us-ascii?Q?1RJWFp233Lxccu1QL5UaAFlS0AB4VJGq7d2m53/CjqtwReMuZ6i4ULHUYWTG?=
 =?us-ascii?Q?m+4H3BjOabJxJbUBU5oMPrZft4iFg/i6PHJKrXZL/TYz23eQxG4Q7ZESi7LG?=
 =?us-ascii?Q?xfqngZgxITpN8d/fX/bQIu5pIdfPyO4u3YmCXrhpwenHJB0QwgwIYXcJphQF?=
 =?us-ascii?Q?obHnkUHZxxMgZAduuJ1bpr8nPigOaK6VkXZRDa8DK6AYo2z6nOVReuGjjhLb?=
 =?us-ascii?Q?+PTC8qSAF2mbjvfo1f8s4BMsLQBu1fOrNDBhNILZ+WI+ss91MGEThA+5BBZR?=
 =?us-ascii?Q?OZRGI4kx5+nb6Os5TRylidReAUsGpCqsU2E5msxkZSj/xKlw0NGiatdqiU43?=
 =?us-ascii?Q?Wx5rt5oiiPkppWcTX2m9dNL83fkgsBc3K17TAh5SMKzwlqWKc/wYMqahRNC6?=
 =?us-ascii?Q?hAizGik32iX7lOwznZ5WQcIOdkg9E3Tmp7o8DSpJf45L0hmtfvsLXQo2DNLg?=
 =?us-ascii?Q?feStyvugLj+qoSXByjpUlu0TLHXs93J7eZeT4VaDOrpxeoHnI+4Nun2g4Ew+?=
 =?us-ascii?Q?BMGsKrF3L3TV2OAnXqaLShrF4wT1eqY0cxKwrQn/z+CGmC2SxCTNJkJZMl1V?=
 =?us-ascii?Q?viOgFLfJSv6qKdnSlpjsoYP+mUONxCbxpvxrsfeaTNmz6pAs7BA0ldhOZZlb?=
 =?us-ascii?Q?2wsf/zBa7nTGKUaN3SfQhRNiJr5s+BWWHtYhWSxGqS4tOTenmdNVGFjBdRu1?=
 =?us-ascii?Q?+Dze21LswRBh08oIG52clAjcnLvuFDtlwS04crQuNyhGlRW9ts5absg6V9i4?=
 =?us-ascii?Q?97NJChXmshIoM9TwE09QaSofw6VDafzmrQNF267r/HCsEiayJHuqnD89wUPT?=
 =?us-ascii?Q?cU7CE6XPXVEwHmLl3qdnArGJrosV4ZqXutp7PZeA7N6zhsW5DX1aAsTpPkXl?=
 =?us-ascii?Q?hHYgQD3llcOuNL4ftGlDBVTlw7JK+Hx+E82K?=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5137.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b7deaa-6426-4b07-6c85-08da0b6eede5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2022 19:13:49.1109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PoJNwfSpzCSVgFrItsZPHRgA9DANOd1/NXcVy+FL9MpkroR1k20Y89ky3di5sfozjg+/IcUyA9wnMrDA6D7RPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1839
X-Proofpoint-ORIG-GUID: hP7_lUHIizxhArjs9uzYoKJFS-oQXZlE
X-Proofpoint-GUID: hP7_lUHIizxhArjs9uzYoKJFS-oQXZlE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_08,2022-03-21_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Monday, March 21, 2022 11:45 AM
> To: Alexander Duyck <alexanderduyck@fb.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; Jiri Pirko <jiri@nvidia.com>; Florian
> Fainelli <f.fainelli@gmail.com>; netdev@vger.kernel.org
> Subject: Re: Possible to use both dev_mc_sync and __dev_mc_sync?
> 
> On Mon, Mar 21, 2022 at 08:42:59PM +0200, Vladimir Oltean wrote:
> > On Mon, Mar 21, 2022 at 06:37:05PM +0000, Alexander Duyck wrote:
> > > > -----Original Message-----
> > > > From: Vladimir Oltean <olteanv@gmail.com>
> > > > Sent: Monday, March 21, 2022 9:32 AM
> > > > To: Alexander Duyck <alexanderduyck@fb.com>; Jakub Kicinski
> > > > <kuba@kernel.org>; Jiri Pirko <jiri@nvidia.com>; Florian Fainelli
> > > > <f.fainelli@gmail.com>
> > > > Cc: netdev@vger.kernel.org
> > > > Subject: Possible to use both dev_mc_sync and __dev_mc_sync?
> > > I hadn't intended it to work this way. The expectation was that
> > > __dev_mc_sync would be used by hardware devices whereas
> dev_mc_sync
> > > was used by stacked devices such as vlan or macvlan.
> >
> > Understood, thanks for confirming.
> >
> > > Probably the easiest way to address it is to split things up so that
> > > you are using __dev_mc_sync if the switch supports mc filtering and
> > > have your dsa_slave_sync/unsync_mc call also push it down to the
> > > lower device, and then call dev_mc_sync after that so that if it
> > > hasn't already been pushed to the lower device it gets pushed.
> >
> > Yes, I have a patch with that change, just wanted to make sure I'm not
> > missing something. It's less efficient because now we need to check
> > whether dsa_switch_supports_uc_filtering() for each address, whereas
> > before we checked only once, before calling __dev_uc_add(). Oh well.
> >
> > > The assumption is that the lower device and the hardware would be
> > > synced in the same way. If we can't go that route we may have to
> > > look at implementing a different setup in terms of the reference
> > > counting such as what is done in __hw_addr_sync_multiple.
> >
> > So as mentioned, I haven't really understood the internals of the
> > reference/sync counting schemes being used here. But why are there
> > different implementations for dev_mc_sync() and
> dev_mc_sync_multiple()?
> 
> And on the same not of me not quite understanding what goes on, I wonder
> why some multicast addresses get passed both to the lower dev and to
> dsa_slave_sync_mc (which is why I didn't notice the problem in the first
> place), while others don't.

It all depends on the complexity of the setup. The standard __hw_addr_sync basically assumes you are operating in one of two states.
Sync: sync_cnt == 0, refcount == 1 -> sync_cnt = 1, refcount++
Unsync: sync_cnt == 1, refcount == 1 -> sync_cnt = 0, entry deleted

I myself am not all that familiar with the multiple approach either, however it seems to operate on the idea that the reference count should always be greater than the sync count. So the device will hold one reference and it will sync the address as long as it doesn't already exist in the lower devices address table based on the rules in __hw_addr_add_ex.

Also this might explain why some were synching while others weren't. It is possible that the lower dev already had the address present and as such was rejected for not being an exclusive address for this device.
