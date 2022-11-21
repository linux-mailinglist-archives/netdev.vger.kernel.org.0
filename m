Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B0A6329D6
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 17:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiKUQnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 11:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiKUQnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 11:43:06 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11021026.outbound.protection.outlook.com [40.93.199.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA531D650;
        Mon, 21 Nov 2022 08:43:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wkf4FUl1UJ9Rg87zR4Pquwh43h1OuMbxIajc9cwJbYqYqmip0lUPkJKgMeuS+w2qi0E2zu9lN1bLUmOsbE5mw/MihwhRsi49/F0yw2FKvR16fJaAQtbTFQTJ6vsjgjoudIsdX5QdcMbpn1LUwj+R0FyycbxtYvE5qsTK6tU6YNtQOFtbWboHyG3VAk8KmGXFUB7cTxCKUsdEZty03BDnKzgj5pZIMbQVOxS7iVZGkVIKD8Mnp0wqvoD1Dn1MV3lB27XqONHDfihw6MfHOg5/65tNysjbcVcQWPPB65PTX/32hl+YrTdwRiudfgFOJHAvcLz34zr4aVVK5zHcnY/7hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejeILJSykIlSuiquuA0I3LLEB6BiATdaSHJc2Aq/HEw=;
 b=hFprVJoEv4uyVzyNgVraeqjZlJdpNUmfUJX0kviuW/4cKI9Zpmzy7l6/vloFnH/y8YlnsYYVOBlMiwcOaH3sFi3qXVo4ihgtKAke+PtRRuIkuZZe4MOlbMDMU0GC41VOECgYsvABA+M9ebd8J7A47/JdHOTez94Y1vCf/XSME4xtXyq32xlZOGBHgBA2nvqBeiY/TUVtq4jjqIc3LieDP+/OBZjHlH4cpaNAkLZ9GlbJqhWmZb0ztIy8QxEqJShEXFyRSacHDHtL+H6tbu1E3A0IBz/lEFWs0h2ibfeoApln2lcf6AbuVo7vsnXTeZSqbq9Q6brpN+HRm6o4I4USwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejeILJSykIlSuiquuA0I3LLEB6BiATdaSHJc2Aq/HEw=;
 b=eiTb3QnlBF/8d1/ErkJxZaFG5WU8VG6NlmJp2M7zwaUhX5gxdnc0carhJDlgHSGflf3VE+Eiles+XGtI83XJ3WGyRXv0OqkJOmDzfvzKRC+Egx08MVXrJRxp+BbGuw2lyyaBx7H/zKSKEJagVLes1dPx6370rxgWlp/a05E0I7M=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MW4PR21MB2041.namprd21.prod.outlook.com (2603:10b6:303:11c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.2; Mon, 21 Nov
 2022 16:43:01 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%5]) with mapi id 15.20.5880.001; Mon, 21 Nov 2022
 16:43:01 +0000
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
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
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
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Subject: RE: [Patch v3 02/14] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Thread-Topic: [Patch v3 02/14] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Thread-Index: AQHY+esth9rK8u0tbUSv/V2oJn73Oa5JbKAAgAAvn0A=
Date:   Mon, 21 Nov 2022 16:43:01 +0000
Message-ID: <BYAPR21MB16881FF9B49F546CDDE95486D70A9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-3-git-send-email-mikelley@microsoft.com>
 <Y3uCLPInEaA0ufN4@zn.tnic>
In-Reply-To: <Y3uCLPInEaA0ufN4@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c5152d74-1eb5-414c-a238-db40af278373;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-21T16:41:02Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MW4PR21MB2041:EE_
x-ms-office365-filtering-correlation-id: 65212418-06f2-4f59-d55b-08dacbdf7439
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bmVHcw7keuJgW2WvPBoVep7MK6DFIsIYryL7Now8TEMbBm3oSPvm+YH2Ryz3TiK+qhLKMJhZuQKg5FMsY9hAjSdq4M4cBya8IiKan1WGX0qfLimoRlCEs//ta346NZcw74zVUztgtl53/gb0mFBC6sXHp6l82buNbudOka3zqRjhTl4hAevph9U42qLmCnFFcgIOlpNNUwgaPOzcHc4mCNbWmYIvjCGw91OuyKCkcgOqWJ2mb8RNVJuJ4N5Rs2gv7d9NsW1G9XHRdgJpCPPu2E2uNlQ3GV2/SzL0fnKC1/4L721E5zmdK+XHiC+Apje8jM9v4w0Inbi6tRpF3q5+tAqGZJ2w4m2rCKNs7Z9dLlz7SvzkM2njM3UE9tePRBBa9QjfWMM+XXaPapvE8LSdWyjyad/6A4Aq4p4yrdzZY5uojFuv+/mF3129I7uFE1XDrdyZIboTam13wsJFIpb2GWP1ocva6I+lJvuARAtAjid043ZMPNtBPBPMhwKGbNXK2G48Ow/tm2rjIAZuvjZOoFc5ER6m1R3o7fHxRbZDTwgX8cxczjrAd1dT+rx++HR7HbmDUI5TlDBFM/B/1HrLogcHzDbmpy8Uc108KSO9pFT1Y4g5KAQqQNUp1c9TOCqQEWcj13sEBcj54pNJhOUTYGva7vxlEiHqtC31NDnt2Taoc8eZ+HVs+1fIpDlD8PRuDHjGMyFVkc9rIDcUu4U56WnRdewZQsZ3GyZE4kHtAzt1Odtv7lC1AzvQroHy9KVX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199015)(86362001)(38070700005)(33656002)(55016003)(7416002)(7406005)(71200400001)(8936002)(8990500004)(26005)(2906002)(9686003)(52536014)(7696005)(6506007)(316002)(6916009)(54906003)(10290500003)(76116006)(5660300002)(8676002)(478600001)(66476007)(64756008)(66446008)(66946007)(4326008)(66556008)(41300700001)(122000001)(82960400001)(82950400001)(38100700002)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xAgEGv/j/Cn4yE6ni5ksVPbdPkGbCDZmYHUzXdq4CuXOp65tgy4JnPX4eXsy?=
 =?us-ascii?Q?9f+FGTJTSU+TSyTvRu6ZB5H8X99oSw9jkjKrcgvhuq2+Q/2rPicv5N6tUkGg?=
 =?us-ascii?Q?rkcKpq64FN/wjzEfpBJC8GzxrCngfgsklSBzpm8R3zUuJUQEVs4h5VuX5AWr?=
 =?us-ascii?Q?YJm8GcJNw2uIacn7xNdviu7iHZpyQipWSNMEJQciaFvASE/HKADofLRbjxd6?=
 =?us-ascii?Q?d1gC23lj6yCGDaOQ/d8O3I9u5VvD6TO3wwwMc+TcalcGKtbfm7JCfbEoaOyL?=
 =?us-ascii?Q?0ofXM1fNjbW1McdfNqQHYHlCGZqvO6Op7OYwwKUvJmhN1a/7Lt9YMHsP9PGj?=
 =?us-ascii?Q?uDe2hcR0O9xOC0X/7Z5IbNuWSpyiZioaNG5mpBj8M+uKQ7XggFEhjc0coNoP?=
 =?us-ascii?Q?b0YdZ5/XQrY2rochBcI1fWfHCV4tIz9wuHAF//lmdeGSH9TeaahCv+ZgkZc0?=
 =?us-ascii?Q?HmCBxEwpx6KSsWgObuA+H4DTRZ71yxhbF/KFZ7vGfbxpVfycG+A+1l39CD79?=
 =?us-ascii?Q?QnKvMJ3iHnzRIi+X8dSAr9kr4SA0yOYRn1vYyYNRWLPlZun6L0d+kzNHUKy0?=
 =?us-ascii?Q?9MEgxSa7H4YQE3X1gjRGyreQRi7gDs1znyahDUpjmd5pFcskNEGEOyrUn2/L?=
 =?us-ascii?Q?fOL5UXJAr1r8CaLrTaAAOoEJlUJTeAqyFfNNRC1aU01ZckBDIBQP1ryDD+dq?=
 =?us-ascii?Q?bIjMmreUMwmgO4+5MKJ9SAhwkusdds3gx127prY7QueeSmi3J+f72ibvInnU?=
 =?us-ascii?Q?IeIJs+xo9DszDFg0wXF1Q1QANrviClS6eHtkqJj4LcbYsIVgs4ihNrtsc81g?=
 =?us-ascii?Q?Nr+uQnCvaAWE95F1+/YceMobkLtkJJF2ccQ+VWKP/ybVodGrlc6jA/70OB8b?=
 =?us-ascii?Q?T49ZxI3GfuWJ8DCbzFQuCw7Dsjs9DyS7WhiwMkwUc0dLrcsa8ghKueamzHJD?=
 =?us-ascii?Q?0Nj5RH6CSkR5X70/XLD5iIIWw+aprpAIy3+COdPnPRX5qaf6WfvMtm6vYlOt?=
 =?us-ascii?Q?lOoFW7tGrbNrZpFsGUr20U5dSNw2VjxsnvdZDzc/OEGOwxwnw2rUkZ0vVxMw?=
 =?us-ascii?Q?QB2gWghg0p0WAyQBWEk2AdNbc58HMbY8ifIP9eBaRumnwWaubS7H4BxlpHI3?=
 =?us-ascii?Q?Kl/iOBCE2Rm7EwFB1JEfcR/V2UOStCP0VltBSxTabzbN+2Vg3DGbjeNb8UhW?=
 =?us-ascii?Q?ftoHkpyc3Xnc4AUwpGK+AgM66H4rO+Zw6uKadnDmGti7ko4AGybr5Hz0Kc1j?=
 =?us-ascii?Q?iNBBxz0mWsRMYSvusic3k63z1QHbAT069uCKWXjxdS53uGD+ZGyv75e+DZQ2?=
 =?us-ascii?Q?DTbIPGCEW+tChMXW9SqI8hEVCGd2hi+Vcae1M9XUP7OR+IdslGkLX/QakHOB?=
 =?us-ascii?Q?0XNoadYsFk9fPV3tzqOKr5zbtFjsVnuLYeGEdYU3UnEcOsCVqiYc7LqZ3WUK?=
 =?us-ascii?Q?6UWYefC8IlrQYpL+eRIeYlRnJaOwoQsAT5dagR4NpVojanH0wyJCbNil2cJa?=
 =?us-ascii?Q?QFKELrDmSxsYUbX6H/aDqNpiY2GN0fDHn5bCwq3nb/kesTO+owI+Kor/1vIx?=
 =?us-ascii?Q?UPkAaO5foqVKn1Uo+rUBHVM1gVNqNd5Go5MX+zRurjdJLObY1CD0doZwPVWu?=
 =?us-ascii?Q?xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65212418-06f2-4f59-d55b-08dacbdf7439
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 16:43:01.3970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XV0ay9lEPNTJW6ae1rzMS3in7QXATq439ujnIAMsIMC0cb23apBhbZVZ2i2caNEGxYY6dWkKLrm0FRZX1ry++kLDyBb8vv1epVZ35Rd26DY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2041
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@alien8.de> Sent: Monday, November 21, 2022 5:51 A=
M
>=20
> On Wed, Nov 16, 2022 at 10:41:25AM -0800, Michael Kelley wrote:
> > Current code always maps the IOAPIC as shared (decrypted) in a
> > confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
> > enabled use a paravisor running in VMPL0 to emulate the IOAPIC.
>=20
> "IO-APIC" I guess, in all your text.
>=20
> > In such a case, the IOAPIC must be accessed as private (encrypted).
>=20
> So the condition for the IO-APIC is pretty specific but the naming
> CC_ATTR_EMULATED_IOAPIC too generic. Other HVs emulate IO-APICs too,
> right?
>=20
> If you have to be precise, the proper check should be (pseudo code):
>=20
>  if (cc_vendor(HYPERV) &&
>      SNP enabled &&
>      SNP features has vTOM &&
>      paravisor in use)
>=20
> so I guess you're probably better off calling it
>=20
>   CC_ATTR_ACCESS_IOAPIC_ENCRYPTED
>=20
> which then gets set on exactly those guests and nothing else.
>=20
> I'd say.
>=20

I'm OK with naming it very narrowly.  When/if there's a more general
case later, we can generalize to whatever degree is appropriate.

Michael
