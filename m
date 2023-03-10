Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80246B3590
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 05:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjCJEW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 23:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjCJEV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 23:21:29 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A57197;
        Thu,  9 Mar 2023 20:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678421875; x=1709957875;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J1bCk1NcZnhumSoM/BdTPcUqJ9CaMCi4yBNRQwQQlC0=;
  b=QEOi/2tiJrofJeX5P5K5AYzw7Rmk/QTdVz2FwvhBK34kaf/UTbX0MQWP
   +oVIOddkcZBOXeteAF3UDMyn1TfVzsmGJ7MjquQuKCTfZ3F2JdEKUfXRE
   4/C4v4SLZbFQZ2KX57hJipQVZ+GSBu5dz968y3vuq7298i/YIqmUZZCF6
   wz4AetFCOYKsgVVKNed1YQx/og1YruWzP6FdS3WvX3FDUXKCYIxTJDgg0
   vT2kW9NvBLgvbTLP9lIHSAqQctSPni/7agi+IcM1FL+ru+C1b7DU1Ewdx
   rvrphXFVts102SQm7J4Zay2D0lIuobMHixzDv1OSPZVk+KbB0Beg6UH+V
   w==;
X-IronPort-AV: E=Sophos;i="5.98,248,1673938800"; 
   d="scan'208";a="200938543"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Mar 2023 21:17:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Mar 2023 21:17:52 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Mar 2023 21:17:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YS/fikUizy19UP9VzdDa7aI8KYsbIiOC1CHONlPRSCc5hJLXUHaAt/QarVWnOyooSLfre05x7LUO68oHIPSswWhbvRoZArLfeT990knEGBUVXxFI1gSNtt4oHeC9wLdkbZDxy6qqPf2NKfAB8NTDcM1/oeGwHwkl6weCqj4nqcFFf/3ob/q23ROOA+gNcpoVebKl6dkiF+0eiz0ruZMw0q1t9qAX1tF+l8oAIPQvyFNQk4ianLUxA5NnW0EdSF+vrnOFqp9Av0JfnXV3ZSUDyn6DysyRY4nncic8zp4s0SVTgn3BheKLooznzCYOordRUlKc7yWeVOO4aaPGUwo22Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1bCk1NcZnhumSoM/BdTPcUqJ9CaMCi4yBNRQwQQlC0=;
 b=UMcO+hdYu81SmOmBNCLMMN/0BCBfVWIBLB7hdD9UfW0VSjT2ulKvUILSTL96+kQ/LrnZwLh4H2SwPdGhYTz18FPWFDxm4ZuqLVyFYZ1/GO8ZCo6bPWFvz4zlUnSYapccE9IC7kW8j1SzsEih525IBv3B/PAQvRUOte+/KeMunQP6SaH7030SqZYz8JLevOFxxux5aKN4M5dFbd1Z1KhV+dq3vfdtGgx/07MmEDLVzN09lCNzkPWtTiWEe5dC+ucBT3DCY8qeeCjM3XIs70xbbBtxd52drQC1O5VHseR1yqv/KijQL9ePXVQjzT5ZubDQpFHECVldza4GwHZ+dmc91w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1bCk1NcZnhumSoM/BdTPcUqJ9CaMCi4yBNRQwQQlC0=;
 b=H81OaJ1Ej8zGCQdmeDYxI0ztFOKVRGHOl67LGIIjYswOYni7Wk0BWlbC/ao8Q4k8OydobAHCuRd0Vjstt0q5LpqrFuhC9MJ+P78EeNLmGrJD7hRDdeHI6JXARkj0XXCkg19AoE5EFRjMZ1pRNi8YHpvlpHkw37dPjmr4jtI/JgI=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DS0PR11MB8134.namprd11.prod.outlook.com (2603:10b6:8:15a::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Fri, 10 Mar 2023 04:17:50 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00%3]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 04:17:50 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v2 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Thread-Topic: [PATCH net-next v2 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Thread-Index: AQHZUZ4yEOeqEllMzkessysROUyzWa7za1KA
Date:   Fri, 10 Mar 2023 04:17:50 +0000
Message-ID: <1ac87648fb6401cd80abfcc045d9184c1532b09c.camel@microchip.com>
References: <20230308091237.3483895-1-o.rempel@pengutronix.de>
         <20230308091237.3483895-3-o.rempel@pengutronix.de>
In-Reply-To: <20230308091237.3483895-3-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DS0PR11MB8134:EE_
x-ms-office365-filtering-correlation-id: 821f247e-ab9d-4ab9-f5eb-08db211e6981
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0F/Hvo8wQnmu2IwRBFF/n8InpplfPc98Sviwsf8etZt/ig5tvhIMCDMbuEnZwe7wiJoYCoR2zaaJnjjGX66NgElLLRYHefD4ehJQHUDzen9bI0gA1XmgqmkZjI5Q5n280+9g04/jLDemnz7ft1H6hOOq7LsngITcEJFi+r0WLkWgQVkfmCQ50XWNdXaU68Nt8c3trMznkEFcjuZ8WbHWx7szf7g5E004yVih7PgGfLWaIXAs8oG+LSusc8Xe3VIm0MFHZCOVVfUUhIxuQHnhZZGqRCxxM6p3SWnYXWyR/V1rEVzlBuoLDkDKY68Oih37OQ5eFGO3YgDXKqfYJhu7pTOXvBK81o9e+uaRjbVVQtZiArq0xCPkK39WOiqAdd0tKOimwLLS33BRQfeVuM55jMr9ZgrT5gFIa3vjg0wQYFmLSNL7liRRv4kQbY7zWgbqPt4Bh5eWL3YoxFhxnpOQHUsn6JG62tcYzbd/xALUyu9izeUTmncRauzFFnMT5UGXJyuO2U0p8g4cytNN3fcjRTdYIgzusnEG93mgmvI3msg1jPztf/nHclBuV9b56ehyxQ4nXdpAXHZdNwaro7zKJZxqS9ThVSUQS7KJErl3n2ZvAtBkzW+Uz4yRL/K/Fjqx5Vg4+vo6DPeD/OnD0L1CCvrU5t2eprOU507dPv4/vKsTFFKSp9QRtBWVoOMxEc5rC+81ed6e5TjuhCbWQstJ6hRyN7G/Z4xzzOhxhZxWbJE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(366004)(39860400002)(346002)(451199018)(186003)(6486002)(36756003)(71200400001)(478600001)(110136005)(38100700002)(54906003)(122000001)(316002)(86362001)(38070700005)(6506007)(41300700001)(2616005)(6512007)(7416002)(5660300002)(4744005)(66556008)(91956017)(8936002)(76116006)(2906002)(66946007)(66446008)(66476007)(8676002)(64756008)(4326008)(26005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnpNa3NIU0RkSTlVNUxXclh1Z0laZHZyUXYrcVdzdkxxeS9TMzRieWcySGlo?=
 =?utf-8?B?RnJJeVNMWnkzT2F1VUttekp0UVRjcVpjNDJTN2Jkc2tzRnZkb2ZpMURXcGhk?=
 =?utf-8?B?WHl4cGVvRTNOcDY0RFRWdWFCdnZXRllYTmJ6UmhlVC9IaUZDQk9QUk1NdWFM?=
 =?utf-8?B?eVNqWXBEZXdTdTJWTTZJcENUOWF3Q0o1Tm1hWlJucHFCVzB5U0ltSWF0a2Ns?=
 =?utf-8?B?b241aEhVWEw2RG41OVNkUXZ3R3FRV3hkWlJZdHhUWlo4SzVyMGRyZ3g0cEM0?=
 =?utf-8?B?MUsvaEM5V0Vab3lvL0lSWi96WXNJam9XQUZoUGg3OER6NVh1eStteEFNZ0s1?=
 =?utf-8?B?ZzVIbU51VWpnaC9Db0dHcDZ5SGJDZXFFa3EwSG1STGpoMmlHMmtPdW54bFI1?=
 =?utf-8?B?MzZ3K0ppSHc1QzlSVWQ4Q1NiL3U1bWdlZ0orVUt0Ny9VYll4Z1gxS3lpQWJP?=
 =?utf-8?B?azlLWGRyM21ZaGh5dnk4d2VIbkFmT1hGT1h4cFZPbFFRczh2aU5Kc3RQWWlR?=
 =?utf-8?B?Q2l5QWloOWVtMXo1enFzcHlFQ2dtUndEU1pGWEV1eCtlNkxYUFVvNDJBeFUy?=
 =?utf-8?B?bDIxdmNYMGgxNjFpZVYyK0xMTEp6SFZENFZaTzBZeG5yaXhSdDIvVTg5UllN?=
 =?utf-8?B?eTU1U3pRVlgxRFp2bkMrNnNaVjBEdTJaY0RySFFrZGJOMkkrOFNNK01CQkY0?=
 =?utf-8?B?Z1hxU3A4VnVUTVRhY084M0x6SjdBWFlySW5TZG8wV2UxT2hMckR2L0w4QWFx?=
 =?utf-8?B?cDUxc1VWQ3dQMjhwZWtVZ2NtclYwMlJUWjQzNGI2dW9JUHFONmxqTjJFMnRS?=
 =?utf-8?B?bTdjZmNuZFdVRlNFaUxMaVN0LzVxWnA0NWljUjhBSEp3WlcxOFVkUkdvS0hl?=
 =?utf-8?B?bmMycUV3NnlXRlNCYzYwSTdXM3VVZitNbkZCZmp6eHFDUGhvdXhwdkhPR0F3?=
 =?utf-8?B?Qm92cjVHSWFSZy9OWi9Zd29hWjBOWWtrdzZNZ29tYUhzNlFDREM3RmxyNG9O?=
 =?utf-8?B?ZlRJQVlMTG9LZ3VDelI5RC9xWm1TeHp3Y1VGcXJSalJ1TWVxTmhmZjVQQ0E4?=
 =?utf-8?B?Q0N1cXYxVHZ2NVhqQmJ0dUpTUlZXcTdGdk0vajJ5Zk81a1I4dVdVaVpQME83?=
 =?utf-8?B?RHM3UUNPLzROaG95YTlneWVOT3pJckorZ1ZNNHZEUTZmR09tZFhWU2pNWWFk?=
 =?utf-8?B?eEJzSC9XOTI1QUxKcGtpK3I4M1lVS2NpdXFidGtNM21CV1pyek4rd0ZJQWJ4?=
 =?utf-8?B?Z2dEZXNxT1NNZmlPNnFPWFNnTzZBVkcvWkZoU0lybUhuZ2pRNkFaWnlETHJt?=
 =?utf-8?B?SVI1OGVzR0N0NWM3bWMzamI3c1QwVjJ1RW9tajRjb0VMRnRyaGxUM0Fybm4x?=
 =?utf-8?B?cUpvVTIyajdTb2RKNStTODVwS1J4eGtFU2xESm9ERUF6UzhtY2g5ejJObHUr?=
 =?utf-8?B?TnY0YUtuMEtFSXZwNWhJQVNPSXZ4RlNvaVRyRHRvS0tMRU5VWWdmTzdHbWlj?=
 =?utf-8?B?SzBzdTR6NjFoSG1PTWpXUytNQmFtdEFJNlZ0Uy80cmNjV0sxSWY0SkRrQzNn?=
 =?utf-8?B?MEdqVDU4TzhqSE1YaldFbkhTa1ZiNjZHR0M1dWk3VlFLTVJMOEVOcDdGRVNP?=
 =?utf-8?B?aXhBUDZaejcvdVJIeXpGZUJKcDVJVVVrVWVxNWxmWThQdjkrMFlMT0ViOUVZ?=
 =?utf-8?B?U1k2NzdpaHNPRmkzdkVQYVF0UWxZVEgzOVdTMFY0eGl5RUtIdWtDbHBZVm9U?=
 =?utf-8?B?cUl4c05yaEovblZVNGk5R2F6YnE3eUtPZzIvdWgxRzNQWm9WclVxS3A3ei82?=
 =?utf-8?B?VTNXVzRQcThQWHRGejRaTS9EYnpZUGY4OWVkZFhlMFpFeEVEa3hWSVhQWU51?=
 =?utf-8?B?THRWY1cvRXBvbTZBL0Njd2J3K0xrNXV4eEhZcHNqZ0o4N2hYc0JBa3RKNFNq?=
 =?utf-8?B?Nk9JMk5QTW84Skg5dXpCNVRGbGphY3lxR01OMW94SWs4eENNL1NGUDllM3hy?=
 =?utf-8?B?elp4cUpZWjBub3VQZExDNnhISnJPNFN1SHFKb0E4bGMrVXhZYmhQZVM1a2da?=
 =?utf-8?B?a1dnWVBla3plc0FNSWErMzVjMFc1SlgyaFlzeXdwaDhTZkdmN1Z3Q21qcGM3?=
 =?utf-8?B?cFkvYTcyYUdkajdxT09MUnBGdk5FdXRzTXk0dmFuR3MydXBrMTZnWWdyRE14?=
 =?utf-8?Q?ElTuphNccNdoGE2bFdu71+Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D54A42FD770B448B6D7D05B1879DBC8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 821f247e-ab9d-4ab9-f5eb-08db211e6981
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 04:17:50.5761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pbues+ff/hlXZ4KC3CqSTtpTyXJsZJD0Hz0cXYI+MgqTHtSA7Dn045EMIMuYefRGA8dIZKs2cn4OBxuaKGJ9I3GLbgpekpbYjd81g+kVqMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8134
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KPiArDQo+ICsjZGVmaW5lIEtTWjk0NzdfUE9SVF9NUklfVENfTUFQX180
ICAgICAweDA4MDgNCj4gKyNkZWZpbmUgS1NaOTQ3N19ERUZBVUxUX1RDX01BUCAgICAgICAgIDB4
MzMyMjExMDANCg0KS1NaOTQ3NyBhbmQgS1NaOCBzd2l0Y2hlcyBoYXMgNCBxdWV1ZXMgcGVyIHBv
cnQgd2hlcmVhcyBMQU45Mzd4IGhhcyA4DQpxdWV1ZXMuIFNvIERlZmF1bHQgVEMgTUFQIGZvciBM
QU45Mzd4IHdpbGwgYmUgMHg3NjU0MzIxMC4gSW5zdGVhZCBvZg0KdXNpbmcgdGhpcyB2YWx1ZXMg
Zm9yIGFsbCB0aGUgc3dpdGNoLCB0aGlzIHZhbHVlIG11c3QgYmUgZGVyaXZlZCBiYXNlZA0Kb24g
Y2hpcCBpbmZvLiBDYW4geW91IGNvbnNpZGVyIHRvIGFkZCB0aGlzIHZhbHVlIGluIGNoaXBfaW5m
byBhbmQgdXNlDQppdCBpbiBmdW5jaXRvbiBrc3pfdGNfZXRzX2RlbCBiYXNlZCBvbiB0aGUgc3dp
dGNoIHR5cGUsIFNvIHRoYXQgdGhlDQpmdW5jdGlvbiB3aWxsIGJlIGdlbmVyaWMuDQoNCj4gKw0K
PiArI2RlZmluZSBLU1o5NDc3X1BPUlRfVENfTUFQX1MgICAgICAgICAgNA0KPiArI2RlZmluZSBL
U1o5NDc3X01BWF9UQ19QUklPICAgICAgICAgICAgNw0KPiArDQo+ICAvKiBDQlMgcmVsYXRlZCBy
ZWdpc3RlcnMgKi8NCj4gICNkZWZpbmUgUkVHX1BPUlRfTVRJX1FVRVVFX0lOREVYX180ICAgIDB4
MDkwMA0KPiANCj4gQEAgLTY3MCw2ICs2NzksOSBAQCBzdGF0aWMgaW5saW5lIGludCBpc19sYW45
Mzd4KHN0cnVjdCBrc3pfZGV2aWNlDQo+ICpkZXYpDQo+ICAjZGVmaW5lIE1USV9TSEFQSU5HX1NS
UCAgICAgICAgICAgICAgICAgICAgICAgIDENCj4gICNkZWZpbmUgTVRJX1NIQVBJTkdfVElNRV9B
V0FSRSAgICAgICAgIDINCj4gDQo+ICsjZGVmaW5lIEtTWjk0NzdfUE9SVF9NVElfUVVFVUVfQ1RS
TF8xICAweDA5MTUNCj4gKyNkZWZpbmUgS1NaOTQ3N19ERUZBVUxUX1dSUl9XRUlHSFQgICAgIDEN
Cj4gKw0KPiAgI2RlZmluZSBSRUdfUE9SVF9NVElfSElfV0FURVJfTUFSSyAgICAgMHgwOTE2DQo+
ICAjZGVmaW5lIFJFR19QT1JUX01USV9MT19XQVRFUl9NQVJLICAgICAweDA5MTgNCj4gDQo+IC0t
DQo+IDIuMzAuMg0KPiANCg==
