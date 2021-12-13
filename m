Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6FD473434
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 19:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241928AbhLMSk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 13:40:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26176 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230346AbhLMSkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 13:40:25 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BDHAFQa017022;
        Mon, 13 Dec 2021 10:40:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Qsjq9iZ8GMvQGFnFAOMqbEr33fXVy/UfXv1JkOzr78E=;
 b=DsUbQ2rYweGkASdfZirrCJQaMTU1dHMW9aKsg8e4xnqU5jUP6Uiua9TIb/M7GKMh4tjy
 3LnkqHkqqRi52w8zOYuiaWBncLytEidh8B0ltbjX1GTNzDx06Mq0POUazaldl+y3HpAM
 4QDSngfAF3RFq3JHgPRe40q5Uhqzs40h1WU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3cx9rp12ev-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Dec 2021 10:40:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 10:40:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eufYA1IK5gKml3sR28PaFYYbfK7hHJPtHEYGu0CfmRiDrjtROXP/K5ttRRoq4gPeQuwN0154TdgcOJVM3sQpp5rEz6frGPMdPrn3siZTbFxb8bT1RTC7V9qyUa7DDoyCqIJc/EiLlUqAllIKD5kWVFbzH0ABwti6IKUjDi4mI7OP75LAPKhiNSG+5r+2sb4Ab43JP/0ygjM/0Aa4xCSNLmme0gBU1FL2BZNmS43gAR4S5s48g6msoaeWhaPtgd4YO4uR+o43KG/oD1kXtJsmzyCKZlcrkwtbU3aZRoNr2pLiwAvZqQ+a40uDvWXNdksP3JIqGePeNXqnxidZqtTRmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qsjq9iZ8GMvQGFnFAOMqbEr33fXVy/UfXv1JkOzr78E=;
 b=YT762QSwrVdp4dw672OycWUc802Ktigq5q7L/p+NvD7n/LViLoh8/qr8nPNs3Lr7iPDnL5ULVDVhb3RsU5kHMXfRbXSE+zcLd7wcanCd9NhqkJo+ev/my7JmNCNoAiJnHqkPzeD1xW7Yr3XV7toUSL6MctgDQlYEQyGBdZbpKYVnV0KnaToxMH8t0fUR3M3FfbTu+sgK7iTn6UZPQud0pUqcPs6n71wvRBIHYTZjJgtavwdKq0Rh+3y+W1az+zaGGSdJLDidt2aeVjoLNqIZRXj4HancQH9RTIwlWz9gB7yt+a4v1G9Jrf54aD8sKLnrtt4Hw5Ab1QOx6w7cQS8t0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4762.namprd15.prod.outlook.com (2603:10b6:303:10b::15)
 by MW3PR15MB3770.namprd15.prod.outlook.com (2603:10b6:303:48::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 18:40:22 +0000
Received: from MW4PR15MB4762.namprd15.prod.outlook.com
 ([fe80::c808:945c:3b20:4b71]) by MW4PR15MB4762.namprd15.prod.outlook.com
 ([fe80::c808:945c:3b20:4b71%4]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 18:40:22 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Noah Goldstein' <goldstein.w.n@gmail.com>,
        'Eric Dumazet' <edumazet@google.com>
CC:     "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "'mingo@redhat.com'" <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        "'dave.hansen@linux.intel.com'" <dave.hansen@linux.intel.com>,
        'X86 ML' <x86@kernel.org>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'peterz@infradead.org'" <peterz@infradead.org>,
        'open list' <linux-kernel@vger.kernel.org>,
        'netdev' <netdev@vger.kernel.org>
Subject: RE: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
Thread-Topic: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
Thread-Index: AdfwSx7jhGb9mOkwS12sTJ1p5oR1JQABEUYA
Date:   Mon, 13 Dec 2021 18:40:22 +0000
Message-ID: <MW4PR15MB47622E3EB6776AEDB531F4A6BD749@MW4PR15MB4762.namprd15.prod.outlook.com>
References: <f1cd1a19878248f09e2e7cffe88c8191@AcuMS.aculab.com>
In-Reply-To: <f1cd1a19878248f09e2e7cffe88c8191@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6a54494-fa29-4359-b2e8-08d9be680566
x-ms-traffictypediagnostic: MW3PR15MB3770:EE_
x-microsoft-antispam-prvs: <MW3PR15MB37701DFE89896FC62CA94386BD749@MW3PR15MB3770.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8F3nYMOiFfe6Ua/3pbWWJRh/eIvoW7bBdSeHacWJ2kPey1V2/95QcsTPlWTXeVn/C9GV0zRdFrhwCGQ7oGJgjo8OTo0GFok4YsvgR09v5vV4S78BddmBeDmcJxfQStNjz5hE3xwFEUP/Uw4pkRdCvgHkrr0ElPtQD2mCSY7jP9ZIBzmKShzJue+asxPxDLMmbAwydipYh2ztYWk2lqCH3sQJIMFZW6D/puK2Q3uTLhcbdE9cP6GEQ7jEov3Q2eLq+e81a3rXQO/cPQrgZC9eTb93ghk4XModt3I/owLTvGYOxgKtB6xvakbi/KCAwu+RsqZ7EeWg7GxO1p5xJagaWdapfQ1hm0T2P/nvpzfVkwMtfj/X6jxKsd3MooYDwDWf061N7pI1zzlMObjE66uxIVh3zWbKQLVmVVR838w84EP/CAPl8bRYIMTTArM/hzI5zeE2qyZY8D5TMxSoQPsNhOWduZ2jtfXbq6DU1ylwehbcp6bszwmLx+DEJ7vH4Pz92C15QwQE+Wk5Kcv8Ia+eTYJ3QJ9cO4SwEshhgCbKPNJ+z2DFAT3zkAhN3CAbFsMnImciKUYFnaBtDmJuxZ3EoNfTQS4IeXKO6tptJVQzwkdH1HKgBmxdPjb6TxXUTapyfH+3xzYt7BucOy+kWdVsm5Eo7udshyDsZaxMPrmvwDcZz5Gsi7Xi4v9VKKSl8O6+MsvCU1AKZgfeoKQgyN7p7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4762.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(38100700002)(83380400001)(66556008)(54906003)(7416002)(186003)(9686003)(4326008)(122000001)(53546011)(26005)(66946007)(7696005)(6506007)(76116006)(8676002)(66476007)(64756008)(2906002)(8936002)(316002)(52536014)(71200400001)(33656002)(38070700005)(55016003)(86362001)(110136005)(66446008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVJDQWZGT3RYUjF6N01KMVdVVXNibVlPdUg2ei9ORVk5NmJuUDBWSGdWREZC?=
 =?utf-8?B?dDBRbkdybHVWNTlhNEg5NnhLdHB2ak1lTUozdzBpTWtYRGxqc3RBSDF2Y290?=
 =?utf-8?B?aEU2UUhrQ1V0M1diUHp0Q3gxYlJVNlNUWit6S3NTajNReTRRS3lmZGwvaWJz?=
 =?utf-8?B?Tlh1NDhjNDJWbjJjMHViYmRzSEFmbFFrZ3VXcGpzWm43YkJlYW5XSkxPYzhG?=
 =?utf-8?B?QXFKa0FBczNZdzd1YU0rSFBPaFU2RVEwTWJ6cWtveTJwZ0NFbkVtQy9zd2p1?=
 =?utf-8?B?VXR1K2Y5MGppNTdubFB3RGFDTzZuUzBIL1dJeDgwN2dyOXc4R3hoY2xEYXg1?=
 =?utf-8?B?b1pjVExoZXI3RjJaaEpBZkZ3UnlvUFhENDNFYk5iZmNXNnorVGEzVWYrcmdm?=
 =?utf-8?B?SVFySGV0VXd4cC9WUzZGZmtzTWFDU1IxUThkdHNSTmM0K1lqVHVXWThRdHJh?=
 =?utf-8?B?bHFxaHlOL1FNMHhDU3R2ZDkwRkE1SlZXMGNYRE9YQnJ3WnJRZERaWnppckRn?=
 =?utf-8?B?ZUMyTTMwQzhmRVByWmtrUmRLd3dhdFVMVVhCc1JjUHR2R0NKQ0gvTS9EVGJJ?=
 =?utf-8?B?MFpBdWdZR011L1dNbnBFSmVrb0o2M3BYTjVEcnlSaGNyUzJCdzJhTHpCTWlY?=
 =?utf-8?B?SE01dDhyTHdBeDRIVHFaUHdseTFPVmJVSmlENFlEUEpub0daYWMxWUVnV2Zj?=
 =?utf-8?B?TDFFNWdsOEFnSjdZcWljR1FnS2FVcEtPZkF3VFIxRmR6WnRlWUZ6dkRkOEpH?=
 =?utf-8?B?c3c3SE9YMHVKd2xCKzdmdDI2a2lNMGFuakhuL3BQR20zVnZLSTVmN1ArNVFu?=
 =?utf-8?B?cDFsa24xYkdtaU5XemdSK09WRGtoNjAvSFZ3dmh3d2VEQVZhNEMyUTBKNk9O?=
 =?utf-8?B?djRGWlQ0dWNlY1NBMTFJOEVjanpzQ1BDakhnNmg2LytSYTViY3R6QVNLWDJF?=
 =?utf-8?B?NzYza0pMRXNQUGI3eUgvN09nL0RxeEtiSUtra1pOOTlHSEpocVIrMkNqdk1r?=
 =?utf-8?B?MGpVK1FEeHRVTjdsekw3N0VoQXp2MjZBN1dRc0NJR3VWMXJLRnY0OUxMdXAv?=
 =?utf-8?B?RG9lVXUxOFBaT2lQZkl6V2g1Y1dVTWw0YTN6bGNGOEZrb0VUOGhQS1N3RkJ0?=
 =?utf-8?B?aVBmdS9kanE3VVhFL29tT2VMOXpaaWVzUWdEZXNFb3JMT0h2MWh6dEFvM00z?=
 =?utf-8?B?NmpQbFcxeHdlTVpSUm1UeTZKUWpFTVlpdTFISCtyaGhiOE1ubjRsbThhQTVk?=
 =?utf-8?B?Q1dlWDdMYVl5YjBsOWdTL3RoQjllQ3A5dzkrb1dWR0haUHhPVVk1V0xWS3BL?=
 =?utf-8?B?b1dYMThLM2QvbithUlZicHhQUEtvM0tSQnZ0bkJNS1Ntbm43S1ZNM2hXbG11?=
 =?utf-8?B?SjNUYkFxTmxCNmFGemliNXdRd1BMbXNSbzh2SDRXaUcrckZQT1pWTlJWeG9U?=
 =?utf-8?B?VTRLYTVzVGdnRlU4ejBTUGdjTnJYelJIZE9JRGIzM1ZvTCtjVGxGaWxkTzNX?=
 =?utf-8?B?WWVLQnBoQkdJamloSWE2dFFGSEM2eUtkUkxnTjhvcmR6REMwcDRpRDNzMW1L?=
 =?utf-8?B?MDNmM3NzR1F1dWFpeDYybFVuREZTNFQ2ZnMvNE9rL3NsRUJFYmplRHMwWERF?=
 =?utf-8?B?MDhXTG01ejVTc20rNktUTlpGRjE3NEFlQ0hBM1Fqd0FtWnAyYVMxSk1EUm9E?=
 =?utf-8?B?QUdEUGIzeG9xUzhwbkRvWi93ZjI2YmRxL2ZJUXEzZFU5RmduWEhIdUhiNnJR?=
 =?utf-8?B?eXFGdGloRk9NbFJyYVFEa2RlUjVSOWU3R3YxV3Q2eFRINXJkcUo0bTNCZnli?=
 =?utf-8?B?SXhCSytIZ2xFNGMzVWZ2Z0o0Y3RzVUR2c1Y0WkNISm1jNXo0Q1VDL2xFRHl2?=
 =?utf-8?B?TnlNdWpseGRldkEyeitkenhodGdEcmY1bk1ERTJYT1JOZVFRTUQ2anNEUU9K?=
 =?utf-8?B?ZDV2VnRBY0xkWHN4UHZraFRyWHZXdnE5UmY0Mzg0Q2k0eUZ2a3NkZHkzVXQy?=
 =?utf-8?B?ZzViZnNDaTJOZHJvUGpJaVNyNitoSHJ3bTFWdWhXcHY3Q0RsblNxNG16QzJj?=
 =?utf-8?B?VU12eXBZcEpyZFFEQlBpbUlDTTQ4SmhkSkszSzZUVWVsbE5ERTZEcjRVWXRF?=
 =?utf-8?B?eU1Sa3BPWVUzcHZVMWpnRzluNS9YUS9tNHpJZWtsdTBFbmZzNWR4bkdzYzky?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4762.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6a54494-fa29-4359-b2e8-08d9be680566
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 18:40:22.4878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8xYUdSehVdSvdspBec6mSOyZ9jBV7ptnDUZtvngt7SH1gughfDdBkL63uBOk40Q5YnGF2UZAoJpLY/F7Mhlhkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3770
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 2IqZe4DRwvDdKtqOBqG3EyOKpDQ6pNBR
X-Proofpoint-GUID: 2IqZe4DRwvDdKtqOBqG3EyOKpDQ6pNBR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_08,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 phishscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBMYWlnaHQgPERhdmlk
LkxhaWdodEBBQ1VMQUIuQ09NPg0KPiBTZW50OiBNb25kYXksIERlY2VtYmVyIDEzLCAyMDIxIDEw
OjAxIEFNDQo+IFRvOiAnTm9haCBHb2xkc3RlaW4nIDxnb2xkc3RlaW4udy5uQGdtYWlsLmNvbT47
ICdFcmljIER1bWF6ZXQnDQo+IDxlZHVtYXpldEBnb29nbGUuY29tPg0KPiBDYzogJ3RnbHhAbGlu
dXRyb25peC5kZScgPHRnbHhAbGludXRyb25peC5kZT47ICdtaW5nb0ByZWRoYXQuY29tJw0KPiA8
bWluZ29AcmVkaGF0LmNvbT47ICdCb3Jpc2xhdiBQZXRrb3YnIDxicEBhbGllbjguZGU+Ow0KPiAn
ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tJyA8ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29t
PjsgJ1g4NiBNTCcNCj4gPHg4NkBrZXJuZWwub3JnPjsgJ2hwYUB6eXRvci5jb20nIDxocGFAenl0
b3IuY29tPjsNCj4gJ3BldGVyekBpbmZyYWRlYWQub3JnJyA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+
OyBBbGV4YW5kZXIgRHV5Y2sNCj4gPGFsZXhhbmRlcmR1eWNrQGZiLmNvbT47ICdvcGVuIGxpc3Qn
IDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsNCj4gJ25ldGRldicgPG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFtQQVRDSF0gbGliL3g4NjogT3B0aW1pc2UgY3N1bV9w
YXJ0aWFsIG9mIGJ1ZmZlcnMgdGhhdCBhcmUgbm90DQo+IG11bHRpcGxlcyBvZiA4IGJ5dGVzLg0K
PiANCj4gDQo+IEFkZCBpbiB0aGUgdHJhaWxpbmcgYnl0ZXMgZmlyc3Qgc28gdGhhdCB0aGVyZSBp
cyBubyBuZWVkIHRvIHdvcnJ5IGFib3V0IHRoZSBzdW0NCj4gZXhjZWVkaW5nIDY0IGJpdHMuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBMYWlnaHQgPGRhdmlkLmxhaWdodEBhY3VsYWIuY29t
Pg0KPiAtLS0NCj4gDQo+IFRoaXMgb3VnaHQgdG8gYmUgZmFzdGVyIC0gYmVjYXVzZSBvZiBhbGwg
dGhlIHJlbW92ZWQgJ2FkYyAkMCcuDQo+IEd1ZXNzaW5nIGhvdyBmYXN0IHg4NiBjb2RlIHdpbGwg
cnVuIGlzIGhhcmQhDQo+IFRoZXJlIGFyZSBvdGhlciB3YXlzIG9mIGhhbmRpbmcgYnVmZmVycyB0
aGF0IGFyZSBzaG9ydGVyIHRoYW4gOCBieXRlcywgYnV0IEknZA0KPiByYXRoZXIgaG9wZSB0aGV5
IGRvbid0IGhhcHBlbiBpbiBhbnkgaG90IHBhdGhzLg0KPiANCj4gTm90ZSAtIEkndmUgbm90IGV2
ZW4gY29tcGlsZSB0ZXN0ZWQgaXQuDQo+IChCdXQgaGF2ZSB0ZXN0ZWQgYW4gZXF1aXZhbGVudCBj
aGFuZ2UgYmVmb3JlLikNCj4gDQo+ICBhcmNoL3g4Ni9saWIvY3N1bS1wYXJ0aWFsXzY0LmMgfCA1
NSArKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwg
MTkgaW5zZXJ0aW9ucygrKSwgMzYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYvbGliL2NzdW0tcGFydGlhbF82NC5jIGIvYXJjaC94ODYvbGliL2NzdW0tcGFydGlhbF82
NC5jDQo+IGluZGV4IGFiZjgxOWRkODUyNS4uZmJjYzA3M2ZjMmI1IDEwMDY0NA0KPiAtLS0gYS9h
cmNoL3g4Ni9saWIvY3N1bS1wYXJ0aWFsXzY0LmMNCj4gKysrIGIvYXJjaC94ODYvbGliL2NzdW0t
cGFydGlhbF82NC5jDQo+IEBAIC0zNyw2ICszNywyNCBAQCBfX3dzdW0gY3N1bV9wYXJ0aWFsKGNv
bnN0IHZvaWQgKmJ1ZmYsIGludCBsZW4sDQo+IF9fd3N1bSBzdW0pDQo+ICAJdTY0IHRlbXA2NCA9
IChfX2ZvcmNlIHU2NClzdW07DQo+ICAJdW5zaWduZWQgcmVzdWx0Ow0KPiANCj4gKwlpZiAobGVu
ICYgNykgew0KPiArCQlpZiAodW5saWtlbHkobGVuIDwgOCkpIHsNCj4gKwkJCS8qIEF2b2lkIGZh
bGxpbmcgb2ZmIHRoZSBzdGFydCBvZiB0aGUgYnVmZmVyICovDQo+ICsJCQlpZiAobGVuICYgNCkg
ew0KPiArCQkJCXRlbXA2NCArPSAqKHUzMiAqKWJ1ZmY7DQo+ICsJCQkJYnVmZiArPSA0Ow0KPiAr
CQkJfQ0KPiArCQkJaWYgKGxlbiAmIDIpIHsNCj4gKwkJCQl0ZW1wNjQgKz0gKih1MTYgKilidWZm
Ow0KPiArCQkJCWJ1ZmYgKz0gMjsNCj4gKwkJCX0NCj4gKwkJCWlmIChsZW4gJiAxKQ0KPiArCQkJ
CXRlbXA2NCArPSAqKHU4ICopYnVmZjsNCj4gKwkJCWdvdG8gcmVkdWNlX3RvMzI7DQo+ICsJCX0N
Cj4gKwkJdGVtcDY0ICs9ICoodTY0ICopKGJ1ZmYgKyBsZW4gLSA4KSA8PCAoOCAtIChsZW4gJiA3
KSkgKiA4Ow0KPiArCX0NCj4gKw0KDQpJIGRvbid0IHRoaW5rIHlvdXIgc2hpZnQgaXMgaGVhZGVk
IGluIHRoZSByaWdodCBkaXJlY3Rpb24uIElmIHlvdXIgc3RhcnRpbmcgb2Zmc2V0IGlzICJidWZm
ICsgbGVuIC0gOCIgdGhlbiB5b3VyIHJlbWFpbmluZyBiaXRzIHNob3VsZCBiZSBpbiB0aGUgdXBw
ZXIgYnl0ZXMgb2YgdGhlIHF3b3JkLCBub3QgdGhlIGxvd2VyIGJ5dGVzIHNob3VsZG4ndCB0aGV5
PyBTbyBJIHdvdWxkIHRoaW5rIGl0IHNob3VsZCBiZSAiPj4iIG5vdCAiPDwiLg0KDQo+ICAJd2hp
bGUgKHVubGlrZWx5KGxlbiA+PSA2NCkpIHsNCj4gIAkJYXNtKCJhZGRxIDAqOCglW3NyY10pLCVb
cmVzXVxuXHQiDQo+ICAJCSAgICAiYWRjcSAxKjgoJVtzcmNdKSwlW3Jlc11cblx0Ig0KPiBAQCAt
ODIsNDMgKzEwMCw4IEBAIF9fd3N1bSBjc3VtX3BhcnRpYWwoY29uc3Qgdm9pZCAqYnVmZiwgaW50
IGxlbiwNCj4gX193c3VtIHN1bSkNCj4gIAkJCTogIm1lbW9yeSIpOw0KPiAgCQlidWZmICs9IDg7
DQo+ICAJfQ0KPiAtCWlmIChsZW4gJiA3KSB7DQo+IC0jaWZkZWYgQ09ORklHX0RDQUNIRV9XT1JE
X0FDQ0VTUw0KPiAtCQl1bnNpZ25lZCBpbnQgc2hpZnQgPSAoOCAtIChsZW4gJiA3KSkgKiA4Ow0K
PiAtCQl1bnNpZ25lZCBsb25nIHRyYWlsOw0KPiAtDQo+IC0JCXRyYWlsID0gKGxvYWRfdW5hbGln
bmVkX3plcm9wYWQoYnVmZikgPDwgc2hpZnQpID4+IHNoaWZ0Ow0KDQpZb3VyIGNvZGUgYWJvdmUg
c2hvdWxkIGJlIGVxdWl2YWxlbnQgdG8gdGhlIGxvYWRfdW5hbGlnbmVkX3plcm9wYWQoKSA8PCBz
aGlmdCwgc28gdGhlIHNoaWZ0IHlvdSBhcmUgcGVyZm9ybWluZyBhYm92ZSBpcyBlcXVpdmFsZW50
IHRvIHRoZSBsYXRlciBvbmUuDQoNCj4gDQo+IC0JCWFzbSgiYWRkcSAlW3RyYWlsXSwlW3Jlc11c
blx0Ig0KPiAtCQkgICAgImFkY3EgJDAsJVtyZXNdIg0KPiAtCQkJOiBbcmVzXSAiK3IiICh0ZW1w
NjQpDQo+IC0JCQk6IFt0cmFpbF0gInIiICh0cmFpbCkpOw0KPiAtI2Vsc2UNCj4gLQkJaWYgKGxl
biAmIDQpIHsNCj4gLQkJCWFzbSgiYWRkcSAlW3ZhbF0sJVtyZXNdXG5cdCINCj4gLQkJCSAgICAi
YWRjcSAkMCwlW3Jlc10iDQo+IC0JCQkJOiBbcmVzXSAiK3IiICh0ZW1wNjQpDQo+IC0JCQkJOiBb
dmFsXSAiciIgKCh1NjQpKih1MzIgKilidWZmKQ0KPiAtCQkJCTogIm1lbW9yeSIpOw0KPiAtCQkJ
YnVmZiArPSA0Ow0KPiAtCQl9DQo+IC0JCWlmIChsZW4gJiAyKSB7DQo+IC0JCQlhc20oImFkZHEg
JVt2YWxdLCVbcmVzXVxuXHQiDQo+IC0JCQkgICAgImFkY3EgJDAsJVtyZXNdIg0KPiAtCQkJCTog
W3Jlc10gIityIiAodGVtcDY0KQ0KPiAtCQkJCTogW3ZhbF0gInIiICgodTY0KSoodTE2ICopYnVm
ZikNCj4gLQkJCQk6ICJtZW1vcnkiKTsNCj4gLQkJCWJ1ZmYgKz0gMjsNCj4gLQkJfQ0KPiAtCQlp
ZiAobGVuICYgMSkgew0KPiAtCQkJYXNtKCJhZGRxICVbdmFsXSwlW3Jlc11cblx0Ig0KPiAtCQkJ
ICAgICJhZGNxICQwLCVbcmVzXSINCj4gLQkJCQk6IFtyZXNdICIrciIgKHRlbXA2NCkNCj4gLQkJ
CQk6IFt2YWxdICJyIiAoKHU2NCkqKHU4ICopYnVmZikNCj4gLQkJCQk6ICJtZW1vcnkiKTsNCj4g
LQkJfQ0KPiAtI2VuZGlmDQo+IC0JfQ0KPiArcmVkdWNlX3RvMzI6DQo+ICAJcmVzdWx0ID0gYWRk
MzJfd2l0aF9jYXJyeSh0ZW1wNjQgPj4gMzIsIHRlbXA2NCAmIDB4ZmZmZmZmZmYpOw0KPiAgCXJl
dHVybiAoX19mb3JjZSBfX3dzdW0pcmVzdWx0Ow0KPiAgfQ0KPiAtLQ0KPiAyLjE3LjENCj4gDQo+
IC0NCj4gUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZh
cm0sIE1pbHRvbiBLZXluZXMsDQo+IE1LMSAxUFQsIFVLIFJlZ2lzdHJhdGlvbiBObzogMTM5NzM4
NiAoV2FsZXMpDQo=
