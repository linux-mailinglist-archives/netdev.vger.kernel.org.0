Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C161C68E19E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 20:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjBGT5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 14:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbjBGT5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 14:57:41 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021016.outbound.protection.outlook.com [52.101.57.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541F93F292;
        Tue,  7 Feb 2023 11:57:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fi0yrOzttQRlLnaR7egzq+YvKPPbKerJweEdXw62K1AM1ULRztbe7KNfTafuV6KT4HyEJ5j1EAq3iOn4W/iDJV4uAQBcQNvAROf+PieAn/3O2TBGgkewENzOS5LfLpxAjS3MKKTgk5WnOXoQw2yujdUrWdgRcy+nM1uzXseyvJsbSyqxPs07BRBfBKhlo4dn13gpczwvscEsHq3uq1CAblSlOJ6r5/Tlf57emp0bD4DTbGkQdwVjIgXD/tcVtuuZ9nJZu6ybobF1dJ9lJrRu0aZA8Nu96wdcaXg88Vo3+ixmAM6IyKM4PhDWv3Fx9tUbPcOkjd1H/QdxdY6fUzm5/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZpo2WVkzsBdGMbQNwZmYbivMdzFQ1qDlOWqnBjcMKQ=;
 b=JJXk2ok98dxCJ2hDP5GLV+HNTlONFDK6JKi6Mza74ybxByt0oGDqCKH6chO5i0ASbRMpTiKzRruCFGHLOhE5HuFD+146u6F8sZTtqsDXTvoiY7FlSA2QI8mj/UjTN4OIJuRIdWJsGOBmZbdYvvaEo7x2dk9C3ctqUygokoPrmCORdOl7ER0/gIdDf7HFuOtTfzHWSEOJf17t0pCl1/hitpsVTBzrandftFpozkcWjB+MFmSLgmDTzrRxuzUrYmmBTBaaL0Pj5okkUrc11NTgrwXASbMg2e529m0H61NoiW5OAIJ5BmNSCEKakKr86uTLvfDBd5gk8x6qE999jrmkjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZpo2WVkzsBdGMbQNwZmYbivMdzFQ1qDlOWqnBjcMKQ=;
 b=WUuEvSOB8KS6oBwQy43SZktdI7Ne9A3sJZDuqZ7+yqAmmp6EWx+xprrF7AJq48QgaVgpkiL6gAyGLgwOdXqaTdHVPYR0oPtT2hiaCT5z3N/LmBPXdxX4oqQ6AKcZKEnjebqX5SqnPrpSYNpERu1ISi/0Prt3O67/P4MietJMrqw=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DS7PR21MB3503.namprd21.prod.outlook.com (2603:10b6:8:90::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.1; Tue, 7 Feb 2023 19:57:25 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.002; Tue, 7 Feb 2023
 19:57:25 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Topic: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAGgMUIAACvuAgAACa5CAAAOQgIAAAJSQ
Date:   Tue, 7 Feb 2023 19:57:25 +0000
Message-ID: <BYAPR21MB1688CFE2DA221D85CFB4B4DBD7DB9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y9FC7Dpzr5Uge/Mi@zn.tnic>
 <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic>
 <BYAPR21MB1688A80B91CC4957D938191ED7DB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+KndbrS1/1i0IFd@zn.tnic>
 <BYAPR21MB1688608129815E4F90B9CAA3D7DB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+KseRfWlnf/bvnF@zn.tnic>
In-Reply-To: <Y+KseRfWlnf/bvnF@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=56d1b323-23f1-41f9-acec-e5c0d5774639;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-07T19:56:37Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DS7PR21MB3503:EE_
x-ms-office365-filtering-correlation-id: 461ca20d-c926-4ad1-fdce-08db0945888d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DQt6V00Bp60vUicF6zZIT8dV5xG5qdG6357gzrAdIjPPxjbw2jG4q3yNRam1qpYHq4IMWeIdMoqmlBukCV88rAMXDuMWE68UCViknBYhHWXRnhJvinYNZkzgNtotnqkouM31QhzukzzpZNtkAHi/KSR5S1wYMsPfL3Npgo/zsWWOHnsz1yZQAz1EVk/dSVm42nyw0UXkLLMch0qwWeGD0PNtUztNK7qLmuEbPcvO2SwurxGQOCM6ITcv2+0vkNZ6tVeQgXR3ab3k08zQ0JIcznXMbSJYl2tz50+MA6ZpYGCnJcZCpqaiYB7VztqvXJjlil1fmOsGCliOFr9qmcP/CoNN7m0TzkCNbWQdTQMS9TjkosAAhDEmlNKBWdfiWflfSuZCDFHpXrrRXHjKivD7OIkFzHDu/60dIF49ucgcQNpwf7CcCAfYLUhU7SSfbAfsjvwSe8CiaY9hgfWFLp9ZJA/6OSk7SE+VB62/HhSpXWgesLTYdvhUId+OPEmi9k77P2PoU38Ugewrbc2w5NCsBY+0NhD87kvxrzDrIzI+rG3fwHeekco+xlbRcFqVgN17bc5SoIkwEkqHHXp5P78+C9zNlKMcNqxLiwSR8KKlmAndvDObBACWUyics7pp4+VF6mWiYsTOvrVZ0NM9WubiTf8r6VMIth/YOsqLKt4umdVY21XQFFwFTw216jlEQRDo3Mck/LQkDjHh00heBwPBE9E9iv8dKghsyHtcVgzWxZt7ordO5jlQnzT31wzUWVFh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(86362001)(122000001)(38100700002)(33656002)(38070700005)(2906002)(82950400001)(83380400001)(9686003)(186003)(6506007)(26005)(8990500004)(7696005)(76116006)(478600001)(71200400001)(55016003)(6916009)(10290500003)(4326008)(4744005)(7406005)(5660300002)(8936002)(82960400001)(41300700001)(7416002)(52536014)(8676002)(66556008)(66946007)(66446008)(316002)(66476007)(64756008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UpXNwbX178qvKbLvDVBzOkljSDSc5Tbs30WMVs44r0IhzvM4W7cubENmP7Gl?=
 =?us-ascii?Q?E/yg/wbJt4kN/8ug9iil6aKDtA12zMq6hIT2j8RaUvhb2KGanT+sYTpj1Va/?=
 =?us-ascii?Q?044FVul7spL1Zc3qy98IWEE78kSz0CACDTpa587GgLgUEe51pOYB3aMaL9qG?=
 =?us-ascii?Q?zadr8D9Ef9PQ/rCPExOoHDJBc+NweoV2a7NKLrZv1YtU0rHwD8+Ol4XWDZVU?=
 =?us-ascii?Q?Q2mRoi/Lk1xqurI5cTrwwAI+YW9IeCV+i+d1rhrmmRw1uReYbJNI+YnWXuFh?=
 =?us-ascii?Q?gBdjJ2Z6PGXbiN/IoaMffGL7QXQGaaTg6M69eaBFTAUgRZ4xMhPHj5Xm5Dqm?=
 =?us-ascii?Q?PvgzxJa9yd+fseGXL0OZqmH09ogvq5c/YbjizvIR0kZOi3hviD+26uJrQIFV?=
 =?us-ascii?Q?0rdOlV4bDnnWNPj1SNjE0pHk8hk6Ln/Su9L0/3jhmJQSoITZwjOsmZ5/hkqk?=
 =?us-ascii?Q?olFz7HUEG0jmLhf9uCQkw8ekSyRNn3PnLMSMvv+W10f6oS02gnTK4sGFJlLw?=
 =?us-ascii?Q?sxR+DDO9/8J90fEC326GThPwzJxns3ZBa4ZKHPcPtQKe4wQPfMqL1LJvJr3w?=
 =?us-ascii?Q?juczptp1nAmg3gT+VCBWbToHw1iEPLY3/6DeHlbVj6rZCbAHpXIef6JIDQY/?=
 =?us-ascii?Q?Dkb6JXfZPmjcqcR/Xk1PRdR6Bz0ZSCekc3Si7YMrsPHJb2cN4gKSZmL4Iowa?=
 =?us-ascii?Q?DnQ/Pa2xxy82KHcY9we+YBRLaF0ox84BNxlKjlS93deG8UgOIHNn5XyTxAHg?=
 =?us-ascii?Q?Z/J9gCn6z/jJBGagfUnRzbVOOGjvS2KdAv2yTV0styrfMBQlxSXvYTiWVizn?=
 =?us-ascii?Q?MR4vnsuTEklfLi5Dzn3QwB4o3O/Qwi9xvLJqWddS06kh0YszylQL5irTEW2Z?=
 =?us-ascii?Q?ow8TfSTR8/z1YKwqo2pv7MU7E/hY9ztPrNh/FybG/1M9q27KpnBMd0vyQa1J?=
 =?us-ascii?Q?5Qu8CRCB95V/Ug/3rQfdtb6R3q/cJkBj3EhmWKzfHzne6GBAknlix0xN+Zyu?=
 =?us-ascii?Q?iCP1vHPl7S88oK+subdZ+q4OKWZUcLQGY60W6zwkt19e5PTukh7O2CGhhGmT?=
 =?us-ascii?Q?WKIvw0aNur9tp49kR8watPY75oVw+nnClIw89m8Ttwy95Zy5VS3z+zl1zzE/?=
 =?us-ascii?Q?KwvbSYSVGJkR4x43tbJhkbLewwTfDa70B9kOnHEpZYvy6eIVWX8FbM15Xv+Z?=
 =?us-ascii?Q?uwe2W2EGwJpqUrnhJyRIUnqHViB2ZM+SrZj3zpfsPuvpCjZpQyGlO9o6iOlY?=
 =?us-ascii?Q?DSrC04qSZSZc0JK8EqnsS8WcgAiWAEkq9sJLZFhtLw4I/idcYqQQQpgKUMdn?=
 =?us-ascii?Q?I/7NK28PtV/UDizEzGP2+1T3HFrMHJXfxr9VkQ2bKGi+dNUxvNxiaP8lZ7gd?=
 =?us-ascii?Q?umbKnxMguBjuGG22c01S6AKg1Tm7XtS2RZWl8gPVp8ufRgIu4d2n6lIKqfad?=
 =?us-ascii?Q?TCizafzExd3blOJc7nj00fhQinA4jSDxQlK/5wrkOVww1OIqSs75I7nHBTZ/?=
 =?us-ascii?Q?9YGY+6Gb9E82NBuWylhMW3jaoRbLK10U2k2eNxE6cqhaHkevFe7j4u4zCgQw?=
 =?us-ascii?Q?mInl4sgVk476oSLWTH3tvIi0Pwti3rjuS05Iibo19R7efwJq0+GXo+up+AU6?=
 =?us-ascii?Q?NQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461ca20d-c926-4ad1-fdce-08db0945888d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 19:57:25.1301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J6ODPXe0tfcb6+igXh/1nsR7KcKxm7oCznVwCcDsoGQkS1QxxVtqzOEjtqcgpW60UioM33EfFQ+WFwRdxarj/XHhhWFILxUKtK+idvZAROw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3503
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, February 7, 2023 11:55 =
AM
>=20
> On Tue, Feb 07, 2023 at 07:48:06PM +0000, Michael Kelley (LINUX) wrote:
> > From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, February 7, 2023 11=
:33 AM
> > >
> > > On Tue, Feb 07, 2023 at 07:01:25PM +0000, Michael Kelley (LINUX) wrot=
e:
> > > > Unless there are objections, I'll go with CC_ATTR_PARAVISOR_DEVICES=
,
> > >
> > > What does "DEVICES" mean in this context?
> > >
> > > You need to think about !virt people too who are already confused by =
the
> > > word "paravisor". :-)
> > >
> >
> > Maybe I misunderstood your previous comment about "Either 1".   We can
> > avoid "PARAVISOR" entirely by going with two attributes:
>=20
> No, I'm fine with CC_ATTR_PARAVISOR. Why would you have to have
> CC_ATTR_PARAVISOR_DEVICES? I.e., the string "_DEVICES" appended after
> "PARAVISOR". Isn't CC_ATTR_PARAVISOR enough?
>=20

Works for me. :-)

Michael
