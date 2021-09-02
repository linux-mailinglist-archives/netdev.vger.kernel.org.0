Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A583FF0E5
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346107AbhIBQPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:15:18 -0400
Received: from mail-eastus2namln1004.outbound.protection.outlook.com ([40.93.3.4]:22589
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234786AbhIBQPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 12:15:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNoAqQoI71meammxhfj/gx/c4tb7ezx8HjYle3+uh/lGS+KUgOHxk2xCR+m9lPzeQ4UqiOR0CNZ6slDBS3fO1CGM202k3dYbdbApMSIGBz9zRY/stncl6btwYCpR2M9FI+YBX9p+V53Lflh6Yhia5ir8QsDONyyw8HGewaV2YIcYSrIAzIRVjiOqtfO1Ul17Bp1IysbZxz5EommUMrNUbtySJg28jD7ZJ/Ja1QLSmGfnJCP5tAYJwuD2O0a/fbrMNvYBaw17RNoPYjyM/ak6B1Yonc7FtOhFvsCIrqVRCKcBrRofVLzQ0AAk47ltrFR24kiplPOhsTY42R6Ey5DJMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=h8kFc9GqemG3bgd5NrDd4yM/37itRP5ArxE57wxbEBg=;
 b=RIpmuxN6L/mRNY3I47H+xtO3SGaKme1u7YzdHF90Gx6MRF0jLM09QwOS54FQpv3/Cwot/atmlLIYXSqjh7L2cWt/wFJ6Zsas9JyVk2vxiWT8PcOL6/mGBq2abT3tY0oh6phldoRgDtfYLrP4e7tBLYJ6dK0g5BdT/g740+I8tpb71g6hPp7p+Sx6u+ci8pvRiwMEAJ7rT7ZsbzEcMeT8cQdRCQ8nbXULJL7+6RvpifaZIZkYOFTNi2KE/q0oNRXC++y4RWbvQbzyznu4dFkSt4S9xONtE2tP2SH4vDWMPELiBS8KlSacXyUnwf4Gp0kMt6L/u0HdnvCicxBO9QxWWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8kFc9GqemG3bgd5NrDd4yM/37itRP5ArxE57wxbEBg=;
 b=bxo3sTyL6l/ajEMjZ4L7vv/WZ91eFA0PYD0Qm08JtECVJgnf10eigJ2XiYudU8qhGB/WxQbZ1VqS/az+2znapb61sHQFHw4p0tPsJ2W7y5zXIalp1ombnzzPBaSO8gem6IdwAUO09cIrWmse5A1T5/fqbZiLTw+QCIfkpezMqhg=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0287.namprd21.prod.outlook.com (2603:10b6:300:7a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.7; Thu, 2 Sep
 2021 16:14:04 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::3c8b:6387:cd5:7d86%8]) with mapi id 15.20.4478.014; Thu, 2 Sep 2021
 16:14:04 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V4 08/13] hyperv/vmbus: Initialize VMbus ring buffer for
 Isolation VM
Thread-Topic: [PATCH V4 08/13] hyperv/vmbus: Initialize VMbus ring buffer for
 Isolation VM
Thread-Index: AQHXm2gFIWSYU02+UUyReBHQOl5/ZauK4YnAgAXmhwCAACrvQA==
Date:   Thu, 2 Sep 2021 16:14:04 +0000
Message-ID: <MWHPR21MB1593917C95C95128A4E835D5D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-9-ltykernel@gmail.com>
 <MWHPR21MB1593B416ED91CD454FC036E5D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
 <e864b95d-ecb7-074b-ff0b-85cc451bad52@gmail.com>
In-Reply-To: <e864b95d-ecb7-074b-ff0b-85cc451bad52@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ef79cd5e-7331-4c0e-adbb-97b052469058;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-02T16:09:28Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a10f30f-c31a-4b0c-12e9-08d96e2caf25
x-ms-traffictypediagnostic: MWHPR21MB0287:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0287AA3A53ED847207E23899D7CE9@MWHPR21MB0287.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vGOnTAxLePV4piCloHPg0HNrCCKjFqOJ03ruJTD+GCTP4UF1PaIK8gwhHPNNJd14psyj+2zOuqCghmd5/QHhATYperkokL2M12IxevdCyHmBPDh+Qgm6ulnw8OMa5ixVRiPXubatO98NxHkDlLHXQUYyQDkDpwkGuNzcMm0ceaN/LcPSGXJfiqeX56JxG/D/uUS39/B5AuEwZcK6As1J8g4sor69545UO6Zw+KPQgxxsQmYjmqMEJsdmrJCjFXrsx8JqF7WaVkuG80PlsWUK79QEgR3bcQ0nyfBortk07bKMHcZ35skTY6qzrPGorYewMWQgW7ai29WoD38r29USg8yQ3U2bhhWvFl37eFF9YTwinIwhxogysj2bI79io89Y7VyxlN7DU/n8mQJ60i8cjI/FYto8urP0xwEWSp12oOSmIna5dv1Gr7In4RIe6Aw1q0CXcDf9t9h7QQN5ITJWn3nLGev7fAQPS19uuHLBSlg/oUnWlfDmYUGgyet6+vRl1jbMMuoA0ZXO3Ll/QtTH1oVj29pRnpB2uZs9gQXV/nOD5I59sKFWbhIUffkaNQL7wGNZlKoQGOZVi7jO3Qhz4L/dqJKsEHjgAs+24BrkcJmvkQJbqI0aOXolLK/UdCD9mI4IJdtorvhNLuBa5KVLBkiBBNxKYAJcWS5CkREIS4XdcWAKUpOo9I951VnvK0yLIoLqeI6VUItSznjK6B2tuQG/8/7nHfE+YPP3bp8m8U0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(10290500003)(186003)(86362001)(76116006)(8936002)(7416002)(7366002)(122000001)(38100700002)(71200400001)(82960400001)(2906002)(82950400001)(38070700005)(8676002)(55016002)(26005)(7406005)(53546011)(4326008)(921005)(64756008)(66446008)(66556008)(66476007)(66946007)(6506007)(316002)(52536014)(33656002)(8990500004)(110136005)(7696005)(9686003)(5660300002)(54906003)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SCt0SWxWdDhBK1BQSUR2TUFWS1dNcWpkb2htRDJLT3VSTmp1aEdWaDRFZzFP?=
 =?utf-8?B?aUtuSW1QTEJSR3AzOTV4bFhWZ0RBOGkveUxzMWk3Q0pKRk52cmpwWW0wTTEz?=
 =?utf-8?B?MlNMYVFPYVk3bEJ1N1puSXJGSjJvWVZXS1dWL2U0T0RwYWJidmJMMDlEd2xj?=
 =?utf-8?B?TnJLREpxN2VJWE1vWTlJS1lkWDhMTExzd1BqbjFMRFFLSUQweGZpZmFXZllL?=
 =?utf-8?B?OStUY3VLc2h0STZFUWt4MG1Rb2F6MDlXdyttT0pHb28yWElzT3lPMEJobnhG?=
 =?utf-8?B?SjQzWWtVU1FwZkNuSXpvYXkwRWlOMUVFRDBsNG5oQ1FnTi90VXdYSitoQml4?=
 =?utf-8?B?TkNoZmZDbVpJWS81Q3BVTmxLZ0RpY0JqR1pjUjRPa29vT3RyYnZhcHBZSTJj?=
 =?utf-8?B?cVZMM2dOU1dmYnJzVFhFUDJETlBoWWdYYVU4Yml0TDFFS21uU094L21CaktI?=
 =?utf-8?B?dFYrSTkvd0I0dVMxL3JJZE9DRVlCeXNzck1ZRlFjaHBVVHhLaDE2ME5FN2hl?=
 =?utf-8?B?ZEx4eCtEOXNjcEN4RGFBQnNVSHM1cGMyN2VEajgxdW1ucGNPLzNONXdlRG1m?=
 =?utf-8?B?MUN1MnE1S2xISmx1bFl0YldCREFEM2UxSFhrM0R1M1IzR3VRSVRaN1czUzlR?=
 =?utf-8?B?TldwejRPcXNyQWdxNmVWeEdNcHJGcEt4dWRmQWljRFc2WXAxMkJFM2NOU2Mw?=
 =?utf-8?B?b2ZhdDJHU3gzZ1dLMll4b3JlYlg0NlRMYlV6UW5odVROL2hVdlZIVFdkdnVn?=
 =?utf-8?B?QUtIODVrTXVhd0hTVFVob0p1N0gycjRvSUJDTjdiWDZVZURUcGFlNkdFYzkz?=
 =?utf-8?B?R1JEVjRPWDVQa1Z4eVUzNCs2OFlJdWd6UXVyWWR5b2I1T0poWFo4cEZwMXJQ?=
 =?utf-8?B?YkdRby9pQTczUmdCd1NBcE95Um96SytST1NQWUtQaENwRkRReG1paTF5M3NG?=
 =?utf-8?B?VFhFSFlvSVAwMUVsUUNPNUF0NStDcGdNWVNvdjVHcWJaV25vdC9WdU4ySkUx?=
 =?utf-8?B?SFFnMXJZZDFlc01sTGk5YUJ3UWRqbHIvOUYxMXN0MW8xai9SaW5oblVWTXly?=
 =?utf-8?B?ZGg4cnVYKytXR1BUSVVGdndPL2ZyY1ZUdXFibWdHMkt0QUFBenAxYVZzdnRP?=
 =?utf-8?B?SmxwOWh5K1p5blQvZlFYZnN5TStHb0dnV3hNVFB3b1JGOEQvbFFzOXpOUlpa?=
 =?utf-8?B?S1IrTU1ROVZ6U0ExSXhhMTNCM0xyN00zRkN6d0pHUi9LOEl6YlI3VjNKVjdK?=
 =?utf-8?B?SDE5bnRGa01DQS92dGxET0p0YVJMNCtMYm9OOTVFa3dWZEpFeGtkbHVPQmhw?=
 =?utf-8?B?cnNVUVNYdFdXWW9SNzQ0ajFQWUpXc2Y5YmdNVUVpWW9QREozVlRyL3YyUHFW?=
 =?utf-8?B?cU1kVHFFRFJ3QWdZQm1WTFlGeU8rcWM4di9DTUc2dW5qMmJYZFZ6L2h4aVVM?=
 =?utf-8?B?RUx1VmVuY2VqODB4QjBoTEh3N0ZHUENkWjdHVktmcGVXV3F6TkhmRDNra1ht?=
 =?utf-8?B?UUtLQ0x5dGFJYVE5ejRaMnlKbVdKUzN4MGh1N3hIV3NVNDRLbEYvT2s1SXE5?=
 =?utf-8?B?bFVTOG1jQklFZkIrRlNFVkhQeldLeSszMXpUc2xwdk9KMThiYk8xL3ZxTmVR?=
 =?utf-8?B?bTBkelJ6aDVubW1GcmY2R0ZOSUIrcmJaM21pMFQzcmI1WHQwdUEySzBpUmZR?=
 =?utf-8?B?ZGJlTFFSdDBaMXlFMlhyZHFQSnhyV1dKUGZpdVBtQUt0Q1IxS1JlaXpQWkJH?=
 =?utf-8?Q?/KsbFS+FFu/eogW6zR47LkfqSJoFw1GvK9smoaR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a10f30f-c31a-4b0c-12e9-08d96e2caf25
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 16:14:04.3146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yw5Wps3Lv7L2sgCGbAiKeaqoXpEbacvM3u28PlfRsJjUhekwDNXnedm/jETY+2tdzXKwgkE0gULqGhseUsLO+Qp5f6JA9+HASQ+PuOVd7Os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0287
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGlhbnl1IExhbiA8bHR5a2VybmVsQGdtYWlsLmNvbT4gU2VudDogVGh1cnNkYXksIFNl
cHRlbWJlciAyLCAyMDIxIDY6MzYgQU0NCj4gDQo+IE9uIDkvMi8yMDIxIDg6MjMgQU0sIE1pY2hh
ZWwgS2VsbGV5IHdyb3RlOg0KPiA+PiArCX0gZWxzZSB7DQo+ID4+ICsJCXBhZ2VzX3dyYXBhcm91
bmQgPSBrY2FsbG9jKHBhZ2VfY250ICogMiAtIDEsDQo+ID4+ICsJCQkJCSAgIHNpemVvZihzdHJ1
Y3QgcGFnZSAqKSwNCj4gPj4gKwkJCQkJICAgR0ZQX0tFUk5FTCk7DQo+ID4+ICsNCj4gPj4gKwkJ
cGFnZXNfd3JhcGFyb3VuZFswXSA9IHBhZ2VzOw0KPiA+PiArCQlmb3IgKGkgPSAwOyBpIDwgMiAq
IChwYWdlX2NudCAtIDEpOyBpKyspDQo+ID4+ICsJCQlwYWdlc193cmFwYXJvdW5kW2kgKyAxXSA9
DQo+ID4+ICsJCQkJJnBhZ2VzW2kgJSAocGFnZV9jbnQgLSAxKSArIDFdOw0KPiA+PiArDQo+ID4+
ICsJCXJpbmdfaW5mby0+cmluZ19idWZmZXIgPSAoc3RydWN0IGh2X3JpbmdfYnVmZmVyICopDQo+
ID4+ICsJCQl2bWFwKHBhZ2VzX3dyYXBhcm91bmQsIHBhZ2VfY250ICogMiAtIDEsIFZNX01BUCwN
Cj4gPj4gKwkJCQlQQUdFX0tFUk5FTCk7DQo+ID4+ICsNCj4gPj4gKwkJa2ZyZWUocGFnZXNfd3Jh
cGFyb3VuZCk7DQo+ID4+ICsJCWlmICghcmluZ19pbmZvLT5yaW5nX2J1ZmZlcikNCj4gPj4gKwkJ
CXJldHVybiAtRU5PTUVNOw0KPiA+PiArCX0NCj4gPiBXaXRoIHRoaXMgcGF0Y2gsIHRoZSBjb2Rl
IGlzIGEgYmlnICJpZiIgc3RhdGVtZW50IHdpdGggdHdvIGhhbHZlcyAtLSBvbmUNCj4gPiB3aGVu
IFNOUCBpc29sYXRpb24gaXMgaW4gZWZmZWN0LCBhbmQgdGhlIG90aGVyIHdoZW4gbm90LiAgVGhl
IFNOUCBpc29sYXRpb24NCj4gPiBjYXNlIGRvZXMgdGhlIHdvcmsgdXNpbmcgUEZOcyB3aXRoIHRo
ZSBzaGFyZWRfZ3BhX2JvdW5kYXJ5IGFkZGVkLA0KPiA+IHdoaWxlIHRoZSBvdGhlciBjYXNlIGRv
ZXMgdGhlIHNhbWUgd29yayBidXQgdXNpbmcgc3RydWN0IHBhZ2UuICBQZXJoYXBzDQo+ID4gSSdt
IG1pc3Npbmcgc29tZXRoaW5nLCBidXQgY2FuIGJvdGggaGFsdmVzIGJlIGNvbWJpbmVkIGFuZCBh
bHdheXMNCj4gPiBkbyB0aGUgd29yayB1c2luZyBQRk5zPyAgVGhlIG9ubHkgZGlmZmVyZW5jZSBp
cyB3aGV0aGVyIHRvIGFkZCB0aGUNCj4gPiBzaGFyZWRfZ3BhX2JvdW5kYXJ5LCBhbmQgd2hldGhl
ciB0byB6ZXJvIHRoZSBtZW1vcnkgd2hlbiBkb25lLg0KPiA+IFNvIGdldCB0aGUgc3RhcnRpbmcg
UEZOLCB0aGVuIGhhdmUgYW4gImlmIiBzdGF0ZW1lbnQgZm9yIHdoZXRoZXIgdG8NCj4gPiBhZGQg
dGhlIHNoYXJlZF9ncGFfYm91bmRhcnkuICBUaGVuIGV2ZXJ5dGhpbmcgZWxzZSBpcyB0aGUgc2Ft
ZS4NCj4gPiBBdCB0aGUgZW5kLCB1c2UgYW4gImlmIiBzdGF0ZW1lbnQgdG8gZGVjaWRlIHdoZXRo
ZXIgdG8gemVybyB0aGUNCj4gPiBtZW1vcnkuICBJdCB3b3VsZCByZWFsbHkgYmUgYmV0dGVyIHRv
IGhhdmUgdGhlIGxvZ2ljIGluIHRoaXMgYWxnb3JpdGhtDQo+ID4gY29kZWQgb25seSBvbmNlLg0K
PiA+DQo+IA0KPiBIaSBNaWNoYWVsOg0KPiAJSSBoYXZlIHRyaWVkIHRoaXMgYmVmb3JlLiBCdXQg
dm1hcF9wZm4oKSBvbmx5IHdvcmtzIGZvciB0aG9zZSBwZm5zIG91dA0KPiBvZiBub3JtYWwgbWVt
b3J5LiBQbGVhc2Ugc2VlIHZtYXBfcGZuX2FwcGx5KCkgZm9yIGRldGFpbCBhbmQNCj4gcmV0dXJu
IGVycm9yIHdoZW4gdGhlIFBGTiBpcyB2YWxpZC4NCj4gDQoNCkluZGVlZC4gIFRoaXMgdGllcyBp
bnRvIHRoZSBkaXNjdXNzaW9uIHdpdGggQ2hyaXN0b3BoIGFib3V0IGNvbWluZyB1cA0Kd2l0aCBn
ZW5lcmFsaXplZCBoZWxwZXIgZnVuY3Rpb25zIHRvIGFzc2lzdCBpbiBoYW5kbGluZyB0aGUNCnNo
YXJlZF9ncGFfYm91bmRhcnkuICAgSGF2aW5nIGEgc2luZ2xlIGltcGxlbWVudGF0aW9uIGhlcmUg
aW4NCmh2X3JpbmdidWZmZXJfaW5pdCgpIHdvdWxkIGJlIGEgZ29vZCBnb2FsIGFzIHdlbGwuDQoN
Ck1pY2hhZWwNCg0K
