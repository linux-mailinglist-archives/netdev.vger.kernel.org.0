Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031D068E0BE
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 20:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjBGTBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 14:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBGTB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 14:01:29 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021018.outbound.protection.outlook.com [52.101.57.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3330323C53;
        Tue,  7 Feb 2023 11:01:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxSyLRjS4S7gf5+p15Tg/KSwhve7INzKbWmkwZboAnIGPlwBOip3pbtAdVN7HnbIYdgAX5W3KeNbKyZqu1TTnEExEOROh5COLtmGpeE9qXSDtKkQX0QS8YVJ02dwxo6dTE4u/Dnb9/Ct/aN6BTVHc2aCSPde6A/wDrd3LqAY/pCgSK1HikKXINJwHKcs7WEGUlcKxzaeYA91eeFFrBkbjJLZCJo8mBrzUFfCXt6T1z7o8swsFEbbf1QKy6Q4g9wN9WSWr6F0i5c1ZEWLzsusulfHC0MUDVRzRtU38JQ3pXXSTulFnbubewF3NXyh1EdzwDzNZsW2/nTipmmrA+l96g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v04jy0RFVP1uhrtTqvyAIfLe6Xl8TMfDhAlArSoW9O8=;
 b=k1BJ4DfEP47Tlck0o2BF2BB30L522EM1/v7T33hhIhK1TjH17SojR9IX0aN/DxLoqlN9Yszgz/5fYexUwPxZ+/HF7FIutL1+J5xxG5F9oKIjdy6oKchr5HVcgLi5DeN4dppPtonieyT91jinAorcaeq2mvp9u76lp5XJMGKo/BPMX9yUS6hEPFFcuBrOX9bJAXz/mHEg4evcDuJrU1DgIfFeS4U3hgfqfzRjGwoz/KPRN3Em5rlYAAYFsNDdyuzynFBNHWUIOhaoTwvbPe+EpO20FPZqeG2+lcWBbLRqqRu4GHGaWz/ghf7TnUicd6cyntDGEpKIQkNDmp1A7PIuxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v04jy0RFVP1uhrtTqvyAIfLe6Xl8TMfDhAlArSoW9O8=;
 b=PMqQrc+CkkPu0eFGPpj8Q9wVPWG7Q3KK2kpRFwz9tQucZezpJpWVUZ4o9EhhGWYV1wOWpEAgGatgWvB7wcG3G1ypnmNH4Vqr65rp+3WQDYCxXdgnxrPp7Q+5L6SRLdoaSjFya4wMP8Mi3UsYM/Nn+yS03Yzl4x61HOMP3abf/lU=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH7PR21MB3287.namprd21.prod.outlook.com (2603:10b6:510:1db::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.2; Tue, 7 Feb
 2023 19:01:25 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.002; Tue, 7 Feb 2023
 19:01:25 +0000
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
Thread-Index: AQHZJs7d1RPl+inmE0Kn2DbFJZ3EJa6nyiwAgAAUafCAB237AIAL8mwQgAhWY4CAAGgMUA==
Date:   Tue, 7 Feb 2023 19:01:25 +0000
Message-ID: <BYAPR21MB1688A80B91CC4957D938191ED7DB9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y9FC7Dpzr5Uge/Mi@zn.tnic>
 <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic>
In-Reply-To: <Y+JG9+zdSwZlz6FU@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2af81798-9a72-498b-83de-2f29a1746324;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-07T18:53:50Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH7PR21MB3287:EE_
x-ms-office365-filtering-correlation-id: 86490e83-75ec-47e9-28af-08db093db5d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t59vLh28ipENJRYPtyt0mZcqeIUkryxTucS3jeAhci0UxbBr5Mtmf0eyfsyy7Zv6/N2fwMJQ+99ko52cHFqRTKaVoBUrrJRJy0BSOw9PtsYGQWQNaWd0MdIwnblBK/gTRPIKUJHusozYxK9mU+uCKirrI9uTvuwLPyhbNdxunEoSomu7RSb1ZAKJcAbTNtUqhbW2kQI9lrLnf3WMOYWOfTwTUMIlRPMZaNZbjcgNPLGpmEh+nMkUwKO2XP7XRHyh/nfmUkg2kuCb8QV6eZEXRQjTuNw2Ed45pCyqwJM7zBjJ9PnK7cJMOyClVsv0neVRdc54xduV+Hih2l4PIK7EqlXY74vg5AqYCUaaDhWO7/d1tj1GAn+AV/tzAui8D9jLfcQbatXvTkYr7ykOSa7FHcy5Zb1mtPPU+UiPaAfU1b2O/YhcIx/ocqg6EV4LAjTXQ+4ZmBpHzug7X0z+s+oJUwUO8zoeG+E1u3z1LxId1E5eHfOxrimO7l54mCjnhTo/3GImSX7WqlRT5pwppcYZ3dfLeEF2qKOWj3WC1LWkbCKD4O9QafKP6tebMs2H5I/Dwbr8Lm//NBaMowh/ZYuzQq2YnN1vL0HtSTOOfKagu/CCIXjeiOd6Vk6WGOWoUzVebwnGFKrn811GGYK8RmTNkPUt5j6fhXjzqSN8n7skLzz7BJB0M6xFaU8DfQVLdqeEddwNiYiU7UNAEF+lrDyMyNyEQrIX5AbK0Z6QQKUNUKSw9ZDL6PGaURa6KEzfvtIw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199018)(83380400001)(55016003)(7406005)(2906002)(5660300002)(8990500004)(7416002)(478600001)(71200400001)(6506007)(9686003)(7696005)(186003)(122000001)(8936002)(86362001)(38070700005)(38100700002)(82950400001)(82960400001)(66446008)(66476007)(66556008)(66946007)(41300700001)(64756008)(76116006)(52536014)(4326008)(26005)(6916009)(33656002)(8676002)(316002)(54906003)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DqzEpb0Pdgqb56tIbGFrYTbKyxUZyLPXrRQC9y7NuopaGWbMtXSB4X1mFKqj?=
 =?us-ascii?Q?Kp4EtSh/RZwDXIODJ78a/WOo8RENuDu8fApQx5kCgdfbM/NreYT9d9i8oMMR?=
 =?us-ascii?Q?qqnwbXeNLhv7VivDAeyFo6QEfEC3wsYZfYuUhVQ6ILcVw+jKAbiEDzPE7mpQ?=
 =?us-ascii?Q?NDF3dxL7qAWH33KvmkSeC0tkNISCu+vr5sggUJzk/BETU9PZNDIKgCHLNu1i?=
 =?us-ascii?Q?6kxDzJEl7GkdcZy4KuB8DQ4/en6p+d6z/5Os7hYXVIbuBivATkOXaLHuV79M?=
 =?us-ascii?Q?Y/xEFYYak4Wo+ABVTrCQC9T2ekFBgTcmWQFFXe1Lkx4VlN96YQT71rJxblPH?=
 =?us-ascii?Q?jtWC78//faIXpyL7uRhsduv+CL+MDj0wizkDcbX6pS9a3GLHpyiYBAiH2W4v?=
 =?us-ascii?Q?gC4eQgcl8agJn2mjceOQkgn6934D5yOkRK8zzkMypr3kuJ0w4aI72SLmNdw4?=
 =?us-ascii?Q?woR0vZxdHRYv8WChx/xjjzDMKZoLryvqZ4S5yfWs6k4zpbiRXzAadth6nJtX?=
 =?us-ascii?Q?Ec0RmZ8fXaigWiOPG/PsaASvRWHDaB/DSlCPV3dllL9de2MuaaagpwWrvzy6?=
 =?us-ascii?Q?Bxuj1W0gZteveiqB5z79FgqdykXxwWr+D0fs0pos3L6sH1ri0M9B71w1Sl6T?=
 =?us-ascii?Q?1oNHASl/H/qi/gSEI7pEwVAv+0gpFsHuWPHkGiFGtPiaxCJBcZA+/2Z7JU81?=
 =?us-ascii?Q?ECQlh7nXv8tR3oNyk+/yKYoMcO4p5B3yF9aXp6MIB/jZZqOjVw6Ukhh4/BpJ?=
 =?us-ascii?Q?2y6u2TbcnKyxcNVji5YCeRQY2JgsNpIX5bOWVizqda8RQx4uO0AICNrfFGMa?=
 =?us-ascii?Q?pQaOnW5/tF9f/E9T/JfSLVhqoy9RDONe1j/a4PIAkGFuwKtL2TJQQIDiSYSf?=
 =?us-ascii?Q?yritY3ks03t8FpT25hMT0SAKPysgBlrw+eoRA/qbV49Pfob9EJXQD83fzOMR?=
 =?us-ascii?Q?9MuonqstgEjSnUFmGLOEbolfYUj9uyWefLUWCajVWibelk++lV2q8Yu8GfzE?=
 =?us-ascii?Q?Xrg0q4HtRZVA3vhNnHQ/EyAwMmo9HI+KFsvBrIAAGAVzxUtMzevTTqsiSQQK?=
 =?us-ascii?Q?lVDxtO4UVebIeFj4/VrgApnhNkrwEflGC8iRAMDEZPLwORdewSc6i+miqEHE?=
 =?us-ascii?Q?miDNU62IsctNU0hG0omvVoeK+us0pwLp6KwbhAlwlipG/Bnq5RO3V8+zOj3n?=
 =?us-ascii?Q?nKnrdSaRri6NJy3MVdNuc3snrzyKtlWmMlMKzqNOYm5zbRcf1ZNdwAKjl0mR?=
 =?us-ascii?Q?2D/qOf0FD23z5lib1mr2Ka4Ek8yRSlJiFib7686OeTAyb5gJmPf8hHnZjb07?=
 =?us-ascii?Q?rn8aDbCnDS25VftZeQPAMPnzVJgYI5s5Yqlbjcg0D3VM/WEd0Qz134bSxuga?=
 =?us-ascii?Q?y4vjmhPYzdctXqxdJCqAUWgcTcOYG8jJFkgZ7o5jVV66llLYjEc0lZivVwkL?=
 =?us-ascii?Q?GPRMqlB0B8QwovvMyXRMJjGfxxxCuQMuzIhXmRsy/o1JGi/lKpYXp5Da7qAX?=
 =?us-ascii?Q?DBGXcw/ttcWFsKNklYlTaDqvHxxeuJcNPhQFGKRIdtR37uRjqnFadsvmnEM2?=
 =?us-ascii?Q?W268eZDsi8jQyngkcoraQQi1FkhDhbxLRAKyO5kHdYZKhkSGkTYyeJSE3+Nf?=
 =?us-ascii?Q?XA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86490e83-75ec-47e9-28af-08db093db5d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 19:01:25.1307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ByyYbMg5QikRIVGq7bv6+33gT3R09pj/ioHluzl+wjyI/HIg38XnixKdgg7Ht16q2xrqSgQuk4GgfZj9JzuBTsIqUmJPm4KxgYy/l1w8uRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3287
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Tuesday, February 7, 2023 4:41 A=
M
>=20
> On Thu, Feb 02, 2023 at 05:49:44AM +0000, Michael Kelley (LINUX) wrote:
> > I could do:
> > 1.  CC_ATTR_PARAVISOR_SPLIT_ADDRESS_SPACE, which is similar to
> >     what I had for v1 & v2.   At the time, somebody commented that
> >     this might be a bit too general.
> > 2.  Keep CC_ATTR_ACCESS_IOAPIC_ENCRYPTED and add
> >     CC_ATTR_ACCESS_TPM_ENCRYPTED, which would decouple them
> > 3.  CC_ATTR_ACCESS_IOAPIC_AND_TPM_ENCRYPTED, which is very
> >     narrow and specific.
> >
> > I have weak preference for #1 above, but I could go with any of them.
> > What's your preference?
>=20
> Either 1. but a shorter name or something which works with the TDX side
> too.

Unless there are objections, I'll go with CC_ATTR_PARAVISOR_DEVICES,
which is shorter.  The full details of the meaning will be in a comment
where this is defined with all the other CC_ATTR_* values.

>=20
> Or are there no similar TDX solutions planned where the guest runs
> unmodified and under a paravisor?

The TDX plans are still being sorted out.  But if we end up with such
an approach, CC_ATTR_PARAVISOR_DEVICES will be correct for TDX
also.

Michael

>=20
> > For v6 of the patch series, I've coded devm_ioremap_resource_enc() to c=
all
> > __devm_ioremap(), which then calls ioremap_encrypted().  I've updated t=
he
> > TPM driver to use cc_platform_has() with whatever attribute name we agr=
ee
> > on to decide between devm_ioremap_resource_enc() and
> > devm_ioremap_resource().
> >
> > If this approach is OK with the TPM driver maintainers, I'm good with i=
t.
> > More robust handling of a mix of encrypted and decrypted devices can ge=
t
> > sorted out later.
>=20
> Makes sense to me...
>=20
> Thx.
