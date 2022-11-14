Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502D262861C
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbiKNQyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbiKNQym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:54:42 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11020016.outbound.protection.outlook.com [40.93.198.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C9ADF0B;
        Mon, 14 Nov 2022 08:54:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXgq3AcDwa5BPnQsYl+hZnlYFWVIqX9xNCvgriT4+FhFKgXlSsX60BrIe2W95Ywaf7fm8va15NANjWrLCwOXxN3RsjIJkUJ33ivYa2q/zjbpZXq91GmvQGo1rGRecISucIoLb3hbeZWr73aSz5JuF0t+FnoG00u7kNoTugHWhlzaoEz/hlpqhy/UIbR2IXVjznEI5igJrNd9/gu5a5Mb6UOVEnLPJJIKs72IEqMYXybZSdOYYBkEKKw+wR20sccYbC2hX2AML/q6K00JlMnKAHf0E2WKIilpiXMdEUhl8qXXXSbuI5xzqxw7D14xLDOQQ2SnxYTRwDrLP5KOJnqvkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWEO5zSbZSz2nM/hcKKkCeS6Xi/KOcdwO4abtB6AG4Q=;
 b=cDfi9qOslsq1kYcDk0RQhTpTWAaKv/jJltmM/AhsZqdrHIv8Hx4RhmHzrpVeCTlEvbmaLTBk+sAZqdc4MZ/pF6jqqRWCA8emcVabI2iTQm3yVfZPAlosIRfCxLBDb3sty/kw1d/rzWfmiZaL1yrYWDAfWaRB9Kv/Q3b7JrgWLq8cBZnRHS/3+4/JwblrUgYdapQSFHwhJ1gScI9vM7QIikntLsejqiiBT0criD0LVK5Xcyjj2vRjo9dg0LvQ/bIOBVuh++fCwNQcX1VKFaRfRDUubpwVL3zP9ogMdGbVFzirtsSRWpwsTz/KtaH7lIzkWYaM3z9TZ5uJZJr2eaBBOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWEO5zSbZSz2nM/hcKKkCeS6Xi/KOcdwO4abtB6AG4Q=;
 b=HETf6T8R5bHYNtopZL/ReRhpTzMFZfKy3SRfWGmb1Dm4XZcwJ977wBgfeetm9aVt2jhgDCzfxgOHs5COjY28nn4zHYq1/yVvadsqcAfdjkCTKTfQ6lBXUZIMrMbyQfsOt616Bm8pqp0aplJ9bsWbejYuQ5VlXwYiaTG8zFNvurY=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MN0PR21MB3557.namprd21.prod.outlook.com (2603:10b6:208:3d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Mon, 14 Nov
 2022 16:54:38 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::6468:9200:b217:b5b7]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::6468:9200:b217:b5b7%3]) with mapi id 15.20.5834.006; Mon, 14 Nov 2022
 16:54:38 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
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
        "bp@alien8.de" <bp@alien8.de>,
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
Subject: RE: [PATCH v2 02/12] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Thread-Topic: [PATCH v2 02/12] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
Thread-Index: AQHY9ZXxgPWJEvDlW0KqJPPwNb8jV646blKAgABF+cCAA+tkAIAACG5Q
Date:   Mon, 14 Nov 2022 16:54:38 +0000
Message-ID: <BYAPR21MB1688D90D14EBD1363F340A57D7059@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-3-git-send-email-mikelley@microsoft.com>
 <50a8517d-328e-2178-e98c-4b160456e092@intel.com>
 <BYAPR21MB168860D4D19F088CB41E7548D7039@BYAPR21MB1688.namprd21.prod.outlook.com>
 <ac5f0e24-cac8-828c-3b4b-995f77f81ce3@intel.com>
In-Reply-To: <ac5f0e24-cac8-828c-3b4b-995f77f81ce3@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=659f5979-58b5-4c2e-865f-096e496cd88e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-14T16:53:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MN0PR21MB3557:EE_
x-ms-office365-filtering-correlation-id: 92e0725b-4e3a-4687-fe07-08dac660eaaa
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XA+sxGMWIvTSmxTIP3vPBpGxNzh+6WqK3D0dWsHMIP/LAe8TWlvKXyZetgvpfosKHo4DQ2AU1wyF7lxFKp354engTU5CymiqbJ/eAfMc74hPyqKcMExSj8Z9HNTZ4inODOWoQACS13tl4v+nBVooqUWEbTogbV3FxMMuevThAbEAhS5g+EfSivhpdEzOoUJlv5zbAOLEDup6T2Xv7rQi9CpiqJT5e1S/SiU5RpJkS2XG8MP0g16yxRzJ+8Ha+h+NgJ/hDAcrKpJyVB5BiFFt3lAX6vs8+UmhmbiLtJHcX+sg7fK3fy6zizgkhYoo6gU5k5uYnDix14jbKCJiai2zN41r084YjeXnch/v71E8wMgSj+BIBuTOcH5sV/oGup7/pq5HVCMa4aRv5PfUxRw+VPkAAcKq7ysoRFCixbQvHOzKJ66ezrt/ixT0jPQSBn2h8FgkZCfyaxcyg9tWLBYDVIqYf1Q81hrfxqln0aF0Zfyse1N+Sy2HwJFFe+xWdXg6Jfyx74nfXxfYTj1K0truczz9upxDn8hQcJzAg5+3aQifND4vBYE4ANu7eaZtjbhhmnuoVkXR+IIYf1mxFN/iaxn0LsngVq4P4LADeeZJZlOHdnzxn/pY0PqLUM1dH3crY2dXMtH/z9PEKrsp0+QUlA3bMdswYc30tETiVCEz3EG5/IKAOJu9S3qit3tdIb19bhSgOYcRv3HqOciuQKzjOwglY+LRp1YaLsLDyV44fJYncU8TU/NOWHIFJh6IF+ooRQAQmNjN/fsYciMDvNNrUaCyL6cfv9rbXm73N5mEuo54w/rRb96s+j2qSiUCxZaR3IkICR5chdxdYm6MFyZ8OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199015)(5660300002)(9686003)(86362001)(6506007)(55016003)(7696005)(7416002)(7406005)(110136005)(71200400001)(2906002)(64756008)(316002)(66556008)(66476007)(66446008)(76116006)(66946007)(122000001)(8676002)(83380400001)(186003)(33656002)(52536014)(41300700001)(10290500003)(26005)(8936002)(53546011)(8990500004)(82960400001)(82950400001)(38100700002)(478600001)(38070700005)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFkrTnZ4U2JDcmtjUXJOdHoxbUZadzF2ZFhwS3lLVHluWFpvTTdqVjdCZjI0?=
 =?utf-8?B?eXRuNnQ1MGppdDcvSDEvUjJaSWJpT0tvSDVUeGxGSlBMRFd1T0NzbEpySXJn?=
 =?utf-8?B?a2lIQm4wQVVkR3RldHhWbHJuUm1LNWtLY29XTWdqeGx1VFpYc2ZFM1A1N3RV?=
 =?utf-8?B?aW9obkpzU0w5QTMvMGRONS9KLys3ZS9tVU1hK2VuT2xMWXRXZUU4emdWQzY4?=
 =?utf-8?B?WDBUOHpJYmQ0bjduU2VpaGxrUklaV2ExRWJWOTVZZDNTcHBEbTZVY1pFaFVR?=
 =?utf-8?B?bzd2bG4zNjRCalFyOVVId2NzcElZNlBaYjkzcHBpdS9vTy83eFl3K0hQLytI?=
 =?utf-8?B?Y1E4Skd1TUE4RXpLNTZmdVFNL0YxTlJoMWVhOXNBNitjUFFqUlV1TlhhcEp4?=
 =?utf-8?B?bzZHYkhGNmFaQmxNYVZUaEtQV2dGN21OY2hXZjBucko3R0RpSDBvYkhqRG1z?=
 =?utf-8?B?b1MyQzRPekY1Q1IvZDVTc1FTdnBkeVNWMzZxemg5Q0pkeEYxRjQweUJnOXpz?=
 =?utf-8?B?L285d3JhMWNHaEtrVFNTdHQ3SHdRSURwTktWNU50bDZQNGtOYzlNditRVi94?=
 =?utf-8?B?ZStIY3hwdVFKOThIVlpibExyYXFIWHJYWlFaaTU0M3JWTjRvbWlib1EycjhV?=
 =?utf-8?B?cFJaV1pGRjVydFkyQzNDQ3ZUWVpwUzNsNmU0amRHMVRmdVRLZWY0Si9Ucm5P?=
 =?utf-8?B?S2xwNHFwaXl2Y2VSY3FVTmY5bklZNUJUcEpMdmtUeGtISDQyK3lpeC9neGVQ?=
 =?utf-8?B?OXR1SEVwS05pcFp1VmszekJWQ2dMdEloZUtCNDU5b3psb2JXZE1BbFkwbkJ4?=
 =?utf-8?B?TEE3ZVFMMzFFWTR4K3c4bmRzcStuNlQ1dVBTNzl5cUFJN1UwaTNVbTFKODNE?=
 =?utf-8?B?NUhudXp1ck1ONEJoQVY1SlpTVTN2TUZITXd0VEZjV21zbVVtcVE5ZW94WWts?=
 =?utf-8?B?UWRVbFQ5MXdvSXlrQUNERjFWZi9wR0xhNlpyb2hFZy9NR2lKUFBVNWJHZE8r?=
 =?utf-8?B?K2NhbmZuRmNXVEFqN21IWGFpU2Eray9Tb2hxWEE2TUVKMlVlOTNIbzg1Lzlq?=
 =?utf-8?B?UUlkWFJUb2RwWFJkYnRBU3RydHEyV3IwZHFYczQ5S1pmdzZTdEVLbzNmek1r?=
 =?utf-8?B?dlNWSXREeEJEV0hsc1Z5dkNGeFVqdGhYamtEeWpTNXZ2d0k2bEZ4bEoxV21a?=
 =?utf-8?B?UStIMUJqOVV1aldjcldtaW9TZFUyRVhNUzJaV2RtTmdUYVQ4YThKam1BVjUy?=
 =?utf-8?B?L2ltM0M2MlN2aFNlaTA2SjhNZm5kTGtzaU9uMFprdlB3eW5Sd25lTncrZU8z?=
 =?utf-8?B?MitJbi82aDl0YVRHR0REc2dmK3ZOaE5qQzRpUlN6aW5NbW5uWS9VZzJjbGI0?=
 =?utf-8?B?TnVnd0drODQrbVB2QnZrdmR3cUZkN1FHdklJZXNqY3UyVzZGSHZFR2d0SEJ3?=
 =?utf-8?B?amRmTVlhTnBoc2o0Y0F2NUdKMit0NWk0RXRvUGt1OTBaOW5GcGdrWWZlT0JG?=
 =?utf-8?B?bUwyL0ZKdi8vUG9ZSGh2QnNQR3VraUFBS0t5eWdNQm5KV2t4ZUFVQVRuUTk0?=
 =?utf-8?B?UzBZR1VrWTlRek5XQ0NVVzdhVktnRU1HOXJraC9KbG9UZHZiWUk4dUd3emxv?=
 =?utf-8?B?Z1VMTWVDakxlQ0ZOMmhlTkNRRFU4clJ6K2hxK0hGc25yRk1Md3RWQzNaYmpF?=
 =?utf-8?B?TGlIWndmMEJQTzFMKzRNQlUxOXM0MHBLdG5rWlZqQThxOVc3MWNyczhoZUc4?=
 =?utf-8?B?ZFUwako4RjRaNU5INXU1bjVEQ09RbGNtZ0V4Q0t1aEcycThWUjdaSDNydk16?=
 =?utf-8?B?MW1FTHJYVlVFZVh1cVpuZ2U0OE5yVXh3TlBPZzN4RWxtMk5HVlIzZ05mYiti?=
 =?utf-8?B?ZjloKzR5NXZlVzVGVC9yZUtlU2lIeXNBS1A5eHFLVnRXaUFZL3V0YnZVV2Qv?=
 =?utf-8?B?UUd5YVlWRk5vYmNCcW1iSmVxWU5OQ1luUHE4UDlGZUVON0t3QUhyTWc3V2Ri?=
 =?utf-8?B?eURKRVlITXUyenJrVjhkbDhuMzZuODY3N3hCSkdHZGN6M2RsWUtNTjEreXNW?=
 =?utf-8?B?RStrYzhBNmh6TGt4T0loaWVEMWx4SlhFRk8xci8wU2h1QmVyQ3I4WHdzeHhn?=
 =?utf-8?B?Vk5jVGFRR1QzaEsrOWxUdWo0WFFOdUp1eDE4NEdpU2dGVTVXVFR4Z1duMllp?=
 =?utf-8?B?ckE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e0725b-4e3a-4687-fe07-08dac660eaaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 16:54:38.2425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r8xxeAiYAgKtsk9al2ognlCF/FJ5Eem79FZ1irZj+glcMdRisV/gdx5qlyfx/o5D8edTCN+gXt6lvYWvUQwTsXVTfdFx3+Y+37AIxWQVwN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3557
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4gU2VudDogTW9uZGF5LCBO
b3ZlbWJlciAxNCwgMjAyMiA4OjIzIEFNDQo+IA0KPiBPbiAxMS8xMS8yMiAyMDo0OCwgTWljaGFl
bCBLZWxsZXkgKExJTlVYKSB3cm90ZToNCj4gPiBGcm9tOiBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5z
ZW5AaW50ZWwuY29tPiBTZW50OiBGcmlkYXksIE5vdmVtYmVyIDExLCAyMDIyIDQ6MjINCj4gUE0N
Cj4gPj4gT24gMTEvMTAvMjIgMjI6MjEsIE1pY2hhZWwgS2VsbGV5IHdyb3RlOg0KPiA+Pj4gIAkg
KiBFbnN1cmUgZml4bWFwcyBmb3IgSU9BUElDIE1NSU8gcmVzcGVjdCBtZW1vcnkgZW5jcnlwdGlv
biBwZ3Byb3QNCj4gPj4+ICAJICogYml0cywganVzdCBsaWtlIG5vcm1hbCBpb3JlbWFwKCk6DQo+
ID4+PiAgCSAqLw0KPiA+Pj4gLQlmbGFncyA9IHBncHJvdF9kZWNyeXB0ZWQoZmxhZ3MpOw0KPiA+
Pj4gKwlpZiAoIWNjX3BsYXRmb3JtX2hhcyhDQ19BVFRSX0hBU19QQVJBVklTT1IpKQ0KPiA+Pj4g
KwkJZmxhZ3MgPSBwZ3Byb3RfZGVjcnlwdGVkKGZsYWdzKTsNCj4gPj4gVGhpcyBiZWdzIHRoZSBx
dWVzdGlvbiB3aGV0aGVyICphbGwqIHBhcmF2aXNvcnMgd2lsbCB3YW50IHRvIGF2b2lkIGENCj4g
Pj4gZGVjcnlwdGVkIGlvYXBpYyBtYXBwaW5nLiAgSXMgdGhpcyBfZnVuZGFtZW50YWxfIHRvIHBh
cmF2aXNvcnMsIG9yIGl0IGlzDQo+ID4+IGFuIGltcGxlbWVudGF0aW9uIGRldGFpbCBvZiB0aGlz
IF9pbmRpdmlkdWFsXyBwYXJhdmlzb3I/DQo+ID4gSGFyZCB0byBzYXkuICBUaGUgcGFyYXZpc29y
IHRoYXQgSHlwZXItViBwcm92aWRlcyBmb3IgdXNlIHdpdGggdGhlIHZUT00NCj4gPiBvcHRpb24g
aW4gYSBTRVYgU05QIFZNIGlzIHRoZSBvbmx5IHBhcmF2aXNvciBJJ3ZlIHNlZW4uICBBdCBsZWFz
dCBhcyBkZWZpbmVkDQo+ID4gYnkgSHlwZXItViBhbmQgQU1EIFNOUCBWaXJ0dWFsIE1hY2hpbmUg
UHJpdmlsZWdlIExldmVscyAoVk1QTHMpLCB0aGUNCj4gPiBwYXJhdmlzb3IgcmVzaWRlcyB3aXRo
aW4gdGhlIFZNIHRydXN0IGJvdW5kYXJ5LiAgQW55dGhpbmcgdGhhdCBhIHBhcmF2aXNvcg0KPiA+
IGVtdWxhdGVzIHdvdWxkIGJlIGluIHRoZSAicHJpdmF0ZSIgKGkuZS4sIGVuY3J5cHRlZCkgbWVt
b3J5IHNvIGl0IGNhbiBiZQ0KPiA+IGFjY2Vzc2VkIGJ5IGJvdGggdGhlIGd1ZXN0IE9TIGFuZCB0
aGUgcGFyYXZpc29yLiAgQnV0IG5vdGhpbmcgZnVuZGFtZW50YWwNCj4gPiBzYXlzIHRoYXQgSU9B
UElDIGVtdWxhdGlvbiAqbXVzdCogYmUgZG9uZSBpbiB0aGUgcGFyYXZpc29yLg0KPiANCj4gUGxl
YXNlIGp1c3QgbWFrZSB0aGlzIGNoZWNrIG1vcmUgc3BlY2lmaWMuICBFaXRoZXIgbWFrZSB0aGlz
IGEgc3BlY2lmaWMNCj4gSHlwZXItVitTVk0gY2hlY2ssIG9yIHJlbmFtZSBpdCBIQVNfRU1VTEFU
RURfSU9BUElDLCBsaWtlIHlvdSB3ZXJlDQo+IHRoaW5raW5nLiAgSWYgcGFyYXZpc29ycyBjYXRj
aCBvbiBhbmQgd2UgZW5kIHVwIHdpdGggdGVuIG1vcmUgb2YgdGhlc2UNCj4gdGhpbmdzIGFjcm9z
cyBmaXZlIGRpZmZlcmVudCBwYXJhdmlzb3JzIGFuZCBzZWUgYSBwYXR0ZXJuLCAqdGhlbiogYQ0K
PiBwYXJhdmlzb3Itc3BlY2lmaWMgb25lIG1ha2VzIHNlbnNlLg0KDQpJJ20gZ29vZCB3aXRoIHRo
YXQuICBJJ2xsIHVzZSBIQVNfRU1VTEFURURfSU9BUElDIGluIHYzLg0KDQpNaWNoYWVsDQo=
