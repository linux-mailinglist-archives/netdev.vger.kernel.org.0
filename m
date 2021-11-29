Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C42461537
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354107AbhK2MkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:40:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:57224 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240045AbhK2MiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 07:38:06 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10182"; a="235888922"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="235888922"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 04:34:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="594597218"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Nov 2021 04:34:48 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 04:34:48 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 29 Nov 2021 04:34:48 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 29 Nov 2021 04:34:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbWZSaXJ4aqCsh8yVUaKv1Z5QYrjUBlQ6Z8/2isID7C/TyrK3btOsX2Typi3xM0l9gKV1sfxCqfhngsHV/0wV6aA+P2Lb/OLqUB3VuSE/1Rf8IANaOpWGVihE2PO+Pqrc5Hwk8UgmBTobp/xDX5V8bp2NNiuHvOgL8MPW/uJk56Y25+65wszUvrobgvCfzO5cadF8y5bWMpBP55JqMMFzRtVjq3pIXoeMc41py3p2I8EXc1X+pEkJ/2+FBZ05jgSkPprSjbqu/60DtnLm51QUZO7wgFKufaJobKQM3+TGOmgAIptQB/5FAkNW3vJLazE/v51miWu7cgxhda1rxP6xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RIw1Wo9vJPyJduFUg5zAnoN+8A+lh54o63YAHaj3XrE=;
 b=RtPgBMfeSvtFkHemlP81QuDH1nEk6xPJdCqQT0GkUQcoMqWDte0QsxAEWOMVnbbiczWOj1QvxeIbFrKqi8sFDCMIJQTlCzCFYABK8Zjx4aE0IBxphLZI2gahei5PulDGyUicNkbKT5dA6amPCiq1MANHIHco4pnTvzlnGS3Cmokc+RNYVDY7llOh4xJb/E1QN+ArEpIGLeypIfqSumjsO1JxyVWu10B/JwxRdr/xaLaqNFCDH9UJ2BsYP/uvvI2DR7U0EzkFnxL2FcU5cTq5HMlW/y8eA1C6pb0VMnz5CWsvUqks+cF798+A4qDOMLj8yC0lHtaoDvwmeToNMZ5nXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIw1Wo9vJPyJduFUg5zAnoN+8A+lh54o63YAHaj3XrE=;
 b=xJIHSy9p71F4mRncVSwlSRpSZdMLUWETFbgdfIeJTCx7Fvy4tzN5kJ5JrzsjlyMt3gM8eBmT6YiG9VvMlybq1cx8Nlucbzk2Gr3robYLd/nB1rjdU5htl4WpQFqUHNoG37grZSRHD+9nGtRU3CMxcJRPc8fClB7lpYLGDZE5cYo=
Received: from SA1PR11MB5825.namprd11.prod.outlook.com (2603:10b6:806:234::5)
 by SA0PR11MB4752.namprd11.prod.outlook.com (2603:10b6:806:99::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19; Mon, 29 Nov
 2021 12:34:46 +0000
Received: from SA1PR11MB5825.namprd11.prod.outlook.com
 ([fe80::787a:2f03:efff:c273]) by SA1PR11MB5825.namprd11.prod.outlook.com
 ([fe80::e814:a13b:4bbf:ef2%9]) with mapi id 15.20.4669.016; Mon, 29 Nov 2021
 12:34:46 +0000
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     Colin Ian King <colin.i.king@googlemail.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] iwlwifi: mei: Fix spelling mistakes in a devfs file
 and error message
Thread-Topic: [PATCH][next] iwlwifi: mei: Fix spelling mistakes in a devfs
 file and error message
Thread-Index: AQHX5Rw35cjeQsHIFE6yc06Pz5gLQ6wacIYQ
Date:   Mon, 29 Nov 2021 12:34:46 +0000
Message-ID: <SA1PR11MB58258E8E9DA01215009B2273F2669@SA1PR11MB5825.namprd11.prod.outlook.com>
References: <20211129122517.10424-1-colin.i.king@gmail.com>
In-Reply-To: <20211129122517.10424-1-colin.i.king@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e070ee61-c433-484e-bca1-08d9b334a07a
x-ms-traffictypediagnostic: SA0PR11MB4752:
x-microsoft-antispam-prvs: <SA0PR11MB47520791F1018D07F5BBE2A1F2669@SA0PR11MB4752.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qUbhJ6dT7fz5bFIVe6v52T9nFM8vzXvr1myltKCAOVhrHdKZ0+ACcnrtBPCndx8/KSCyVYIm9+UWPt2QGPlzTn3L4DBxmBgktGA3SI6Tq+wcJ19QusJBPnUvX4+KZZzWRp4x5/Mbst7GVjaXoksqvN4rc5YyfPvWpWtLTSHR75FyDpq/Yt+BKYT1Asl+M4/gaGzB5H29qAR+UhfH+KOsb5nLLHV0Bp/pWfggVo498bfcBcsCBgbaZ4JeFThOmDcVBgA2fmJMegTSNhkVTrb6SHTpkeIJ3a6sNlaIHbS/QCUF9HP/C9w72AITwLDazSoSTGVJGoLTxH1Zwz/6PhFSbnqd2POc91LeopYREdyGyZyBbnzB9Hv3/t4gPhQUKqQ+QB9vg3boVlOXYxv59s9KCeJhL7PxZUKlSxuup9j1CoOszTpcTP4lalDw1YkuLD56sgj+E3OLtYObc0HVQ8hOLwSud2c9CLQTRD7gpXGad8lsvMHwLapoh33pY9c+OCDRYCb3AAHW83sObdSmwilX478O0DfSbXmiT4bohsSMxFNrC5k71/EV4EPRaG7fYXmR0wGr0sTYa84PurAJrQeuY1GsJs20wZGTCyXIz8o3nYW07BraX22zLyTxaMyKVUDXKRuGKHJZ4A0o0SqJCQdLOFvpJaM2NffqciWTrHMRwfyO7rwzNAmfYoBgLMh/nhyLBnJ17Lw0h80xd2keAFhVeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5825.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(26005)(33656002)(38070700005)(86362001)(2906002)(186003)(6506007)(55016003)(15650500001)(508600001)(7696005)(4326008)(71200400001)(5660300002)(66946007)(110136005)(64756008)(66446008)(66556008)(76116006)(66476007)(316002)(38100700002)(122000001)(82960400001)(54906003)(8676002)(52536014)(8936002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkxUUmlVb2xDLy9pYit6K09jTXZhK3JGa0M2cDk1UW1TL0JCQ2E1VGJ2WXBY?=
 =?utf-8?B?RzA3ZDlTSlo5VVFGWHFTUlZlT0tvaGNhUy90TXNPcFkvT2tUSy9BN1F4NWJS?=
 =?utf-8?B?dmRWMlJFelh0bC9JVTNDWnZvS21WaW5IZU9ucFV5eFllUzMzRUtISzFIZVhm?=
 =?utf-8?B?U2pmUm1BOUFHcWdJZ05SUE9NN29KMzF2UEhoZitpdXRocVpUUkxhcEhFaGxo?=
 =?utf-8?B?TmdlRk14Vkd6cnZMRHk4NGI2d2txTFFDQmRjMGpYZ2VGY0lpR2lRR2tUZStn?=
 =?utf-8?B?S2lxSWxoQmVHQWI1aWs0cGdUMld5L3Z1QUo1QnpZZlZyYWNsaWJZWDdqSm5v?=
 =?utf-8?B?K0MzRVNWSkU1dCtXRndqK1RRUkxNK3daRW9IU29mU2dyNzg0dG5yQzJxK2E0?=
 =?utf-8?B?NThjUVhRd216NmY5cnQ1bnBBOUxaekVlL0VZaHg4aDdXUnZtSk9uQlN3N28x?=
 =?utf-8?B?eGc3SjdBeTdLbDNjSGpBcUwza1QxSjRWQ1ZoQ1Zrd0F6Zmt1SnFvdmtnY3Zq?=
 =?utf-8?B?T0pzU1Q2UlhFNHNweFpTZ25LanRjV1gxZ1dMYUJBYmxEczdVQXl2MW1TMkVz?=
 =?utf-8?B?c3laNkxpQWFjaFl3bFhjcFFQcWRyNWk1d3M4YzAva0FYSWRkdUFNbUtGQjBF?=
 =?utf-8?B?emxuSWJMclF1dklEaUJkSVFoZlYzSGZsMHVEdmFTNVdZa2JTNG5HT2lBWnk1?=
 =?utf-8?B?dWdQZ3hGakJaSXdxZktRcy9BT21iN0RlSHQyOHh3bTdBMnhRR3RNTi9rZ2Ra?=
 =?utf-8?B?eXNVeExDL2szTFRBK2RjMkRCdVhOU1lhbU9aWDMyd241TENMbDM3QldCNU9v?=
 =?utf-8?B?Z09HQkRVTFVmL2RRUXNOOG5oKzg1bFBsaFltZ1k3bXd0MFkrRHIyM3NRRWZZ?=
 =?utf-8?B?RmtIcVFuWFhoMm4vQnZWeFVLbU1iMXRkSWhCdVoweTJySkpWWUZBdVpDMlo3?=
 =?utf-8?B?aHAxbE9mTnFQV1hoUVRWaDlSTGErWEx4N05tYnNRcTJKSjIwL1poNWxJd0hk?=
 =?utf-8?B?MllndVBaNUpqZWxtV3RWN1phcG01aCsvcllqVHp5RXlPb0VVOFJPcldWQTVt?=
 =?utf-8?B?YS8weC96Y2VNQWNvMThKTTF2UWYxakpSQmxpd3JVbHpmMzJlcVA1UG9aMnR4?=
 =?utf-8?B?WjcrQUJYYjR3NlRiaGlxTVN4UGNVVkR3ckxBbFBXWXBRS3l5M1NzRGcvWG9s?=
 =?utf-8?B?MmJOYWFHY2ozZUhWZmpmalBncm1UV0MvVTFLelQzbTRlWmFnc2hyT3BTSTB1?=
 =?utf-8?B?bTF5ZFNibVVCMkR0M3JEZzA0SG43ZkxXbDdKNFN6M0cyOFJ5UWlsaElpaWg0?=
 =?utf-8?B?enNHUkhrbG9paDBZUEZ5L1hJdytydVZuODJJVE0xa2JQNE1qWUhjNWZLU01M?=
 =?utf-8?B?Z25oYXoyQWJBTk9mbTF6YmdIYzJzb2t3RzhrU2lVaEJVTm9vYkJXUStlQVA5?=
 =?utf-8?B?Nm5WMFFDRWZ2VUM1cGk0UTlDRHdLV0RORmc2NkYwWkxxZWx0K01QdHdRMiti?=
 =?utf-8?B?VFFjMnhTWFBqTzAvbWxxWlBNRDVQMTRhWGFBaDUyRWNGelZ4ZGhQMGFNNTVY?=
 =?utf-8?B?Mk1UaEN5Mkh1ZUN4bmwrRUtJVjhxdlNjRTgxSzdoNTNBM0RHVmVsbWVCcnJm?=
 =?utf-8?B?cXd6TWlCZ1dZaG1OdDlYdC9UcGtDNm8xZ2M2S0lyZ2Zubk4rZkh1SFh6TWxK?=
 =?utf-8?B?c0k1L2VET1dFU1N1cytLcm5hdWhaeGplaTVlVTcxTGhaaEhEb0dFWXorKzNP?=
 =?utf-8?B?V2pLTkYyU2d0NExWcnBuMHV0Zy95Slp0T3UvbWtGMWl6ODhkTmRxMmZHVHJQ?=
 =?utf-8?B?SVVHSmlWc0M5Tm9Tem84NnNsZHh1eUVYWGV2QzBkdDU0NHNtMURsd2ZsZWRY?=
 =?utf-8?B?a3Y0TndZOStyY2pLZmVOZVgzRW45blFvSTQ4aW5VRjdkcWhNdmFxZEdMdUhn?=
 =?utf-8?B?dll5RHFrWE5YcHlqTUtFYmRTQ2hIUGIvRmR6MjdRQzU5YkNldU5aMUE0TUdE?=
 =?utf-8?B?TUN6Z2hqK21XR2F1VUhXcksrcWFscS90ckdzM1RnelJmUGxHMXd2WWlwaXlq?=
 =?utf-8?B?SUdPbkR4enRaZ0F5NTV0MkJRNnFlNmQxUnZVN3pFOS94QzJtOC84Mm9XdW1T?=
 =?utf-8?B?QjVaWlhFdmJNVEpmQVJFUkp1RFprZUxwK3RFM1B0Vy9sVExYVG0wREhMcUJN?=
 =?utf-8?B?ZXF0RkR2bkZuR0I3SkdIMGVrbFVIR1VCUFk0VGx2Z1RxOHlrVURxakluWElp?=
 =?utf-8?B?ajZZaTdDblJNUDhOY0M5VkFTVTBBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5825.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e070ee61-c433-484e-bca1-08d9b334a07a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 12:34:46.0341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: drR1Hv0ASu4ibP8JIRTonuLEv3a0g9SEfawpH+a4x6y9SGwnOqH8WpnTAi8wFTmwlqf6EteF8wk4wrudzVn8Jo+Bfm4D3r0Po/gBxEkrZJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4752
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ29saW4sDQoNCj4gU3ViamVjdDogW1BBVENIXVtuZXh0XSBpd2x3aWZpOiBtZWk6IEZpeCBz
cGVsbGluZyBtaXN0YWtlcyBpbiBhIGRldmZzIGZpbGUgYW5kDQo+IGVycm9yIG1lc3NhZ2UNCj4g
DQo+IFRoZXJlIGlzIGEgc3BlbGxpbmcgbWlzdGFrZSBpbiBhIGRldl9lcnIgbWVzc2FnZSBhbmQg
YWxzbyBpbiBhIGRldmZzDQo+IGZpbGVuYW1lLiBGaXggdGhlc2UuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBk
cml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL21laS9tYWluLmMgfCA0ICsrLS0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tZWkvbWFpbi5j
DQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tZWkvbWFpbi5jDQo+IGlu
ZGV4IDExMmNjMzYyZThlNy4uZWQyMDhmMjczMjg5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL21laS9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tZWkvbWFpbi5jDQo+IEBAIC0yMDksNyArMjA5LDcgQEAg
c3RhdGljIHZvaWQgaXdsX21laV9mcmVlX3NoYXJlZF9tZW0oc3RydWN0DQo+IG1laV9jbF9kZXZp
Y2UgKmNsZGV2KQ0KPiAgCXN0cnVjdCBpd2xfbWVpICptZWkgPSBtZWlfY2xkZXZfZ2V0X2RydmRh
dGEoY2xkZXYpOw0KPiANCj4gIAlpZiAobWVpX2NsZGV2X2RtYV91bm1hcChjbGRldikpDQo+IC0J
CWRldl9lcnIoJmNsZGV2LT5kZXYsICJDb3VkbG4ndCB1bm1hcCB0aGUgc2hhcmVkIG1lbQ0KPiBw
cm9wZXJseVxuIik7DQo+ICsJCWRldl9lcnIoJmNsZGV2LT5kZXYsICJDb3VsZG4ndCB1bm1hcCB0
aGUgc2hhcmVkIG1lbQ0KPiBwcm9wZXJseVxuIik7DQo+ICAJbWVtc2V0KCZtZWktPnNoYXJlZF9t
ZW0sIDAsIHNpemVvZihtZWktPnNoYXJlZF9tZW0pKTsNCj4gIH0NCg0KSSBmaXhlZCB0aGlzIG9u
ZSBhbHJlYWR5IGluIGEgc2VwYXJhdGUgcGF0Y2ggdGhhdCBoYXNuJ3QgYmVlbiBhcHBsaWVkIHll
dC4NCg0KPiANCj4gQEAgLTE3NTQsNyArMTc1NCw3IEBAIHN0YXRpYyB2b2lkIGl3bF9tZWlfZGJn
ZnNfcmVnaXN0ZXIoc3RydWN0IGl3bF9tZWkNCj4gKm1laSkNCj4gIAkJCSAgICAgbWVpLT5kYmdm
c19kaXIsICZpd2xfbWVpX3N0YXR1cyk7DQo+ICAJZGVidWdmc19jcmVhdGVfZmlsZSgic2VuZF9z
dGFydF9tZXNzYWdlIiwgU19JV1VTUiwgbWVpLQ0KPiA+ZGJnZnNfZGlyLA0KPiAgCQkJICAgIG1l
aSwgJml3bF9tZWlfZGJnZnNfc2VuZF9zdGFydF9tZXNzYWdlX29wcyk7DQo+IC0JZGVidWdmc19j
cmVhdGVfZmlsZSgicmVxX293bnNlcmhpcCIsIFNfSVdVU1IsIG1laS0+ZGJnZnNfZGlyLA0KPiAr
CWRlYnVnZnNfY3JlYXRlX2ZpbGUoInJlcV9vd25lcnNoaXAiLCBTX0lXVVNSLCBtZWktPmRiZ2Zz
X2RpciwNCj4gIAkJCSAgICBtZWksICZpd2xfbWVpX2RiZ2ZzX3JlcV9vd25lcnNoaXBfb3BzKTsN
Cj4gIH0NCj4gDQo+IC0tDQoNCkkgaGFkbid0IHN0b3AgdGhpcyBvbmUuDQoNCj4gMi4zMy4xDQoN
Cg==
