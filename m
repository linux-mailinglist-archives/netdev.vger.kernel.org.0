Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C404B12AE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244186AbiBJQ0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:26:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244177AbiBJQ0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:26:20 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60097.outbound.protection.outlook.com [40.107.6.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4B0C51
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:26:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtb5EZbiud3MXQTruFTFcegc6xYA9IzGG6y3GNYfKuctxnNEQqClBJAl9dWrnXDjaZ6E5/+FnQNQouvI0qIjaOX2DphRzFW8xQUYl5+Wgfxrf2NvyYyFFgxwOtcIhouCCymZZ6SFzyCJ01AUjW8t/KU3bneTGCKuqFVRU3P/DyKjkxCQQPxNh117QcadzpyXGQ7fe/3cG8SIlJlVP1Jaid2+Py8hwyHFgcJrl3sLbENOGi8z3ReKEAwctkpcRyTWj0QLRvbDSVyinnTNS9AJvNnl/C+4O9Yk5qCuYZUplNviYNElJ2CvYw8uuwCh0/0wksihbrt4EDt9DrQ7Rkryyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QTCYru22ePdotNJw1ICVmTM/gJsKPlHxK5UWfO+ax7U=;
 b=S+SFmPvDQ91Snjp+x4yDm8XfUtJMKiDtuab3mqeLcd9lXg29ShsNhmWIPBcTGJUqj9jOm8vPN1vp0WCmgQ+ZprI3j1PjZpwlayr46jOoliOifTbqbtnVLG9x4kULSyym4Q2cnCtNkehXVoWa0TzzVyZdsmwFc64Z/qRFZPY4XPrQB1oju6x4BII7s9uxy9uBrnFd7DQ/18No8BsGYEpt4b+VLEPVK1UQkhHrN7D3wj1UIo7mCXNxaJw7mVR5MB0gop03VbxqNwVujJ/rEVWutmF0W0HKNKZHPIcti5rP3SNHRDIWzetgpMJLZq0Pp8h7hEpK7QdMQKCsGzNrNSCpeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTCYru22ePdotNJw1ICVmTM/gJsKPlHxK5UWfO+ax7U=;
 b=lyNZZC7S412+kaOUW/AUKWqjzyzyz4CxsUScdRjq88pqjjXsFVgUmwjqZm3J7nhL2yHuVMYWk2Kb2ncTtiJ7p/BlGaMWg1eJfJ6yY02VKsFORpWhQfEKJxKpXlsbgC2zrJUx2UOxme0lLlQoJe22l7BTv3QQ4VybfXSseA1Ad/TraTJ6DMRKErMbRxZdyU4SfrNrzxTcBtxv0U9APDwbQzS9f8c1dXQHJrAufH+EdqlA1VVigCVVoPNnDF1LcaJawvJTemfVqblCVgFSlf68Vm6/DgMwed5ieyrhuXewM8iEaYXByhZ1wkwbhgZFA9AKVUKDPIEgpEJAgYrWuG2gWA==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by AM0PR06MB5889.eurprd06.prod.outlook.com (2603:10a6:208:11c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Thu, 10 Feb
 2022 16:26:17 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d%4]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 16:26:17 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: [v6] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Topic: [v6] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Index: AQHYHlpEynlMQ5eAj0yXwprBsgTggayM1OqAgAAiCmA=
Date:   Thu, 10 Feb 2022 16:26:17 +0000
Message-ID: <AM0PR0602MB3666A3A51C6F92ABAB6ED213F72F9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20220210084322.15467-1-holger.brunck@hitachienergy.com>
 <20220210151635.4b170f5c@dellmb>
In-Reply-To: <20220210151635.4b170f5c@dellmb>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe70f461-25cd-47ce-f9af-08d9ecb2108b
x-ms-traffictypediagnostic: AM0PR06MB5889:EE_
x-microsoft-antispam-prvs: <AM0PR06MB58891FC38B568829D03FFB39F72F9@AM0PR06MB5889.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 93s4/cC1Wl+MEHYRCUqy+0O6XFx7kkQ+wNSGJjTdUHIEhvhChd0boqt+8i81SMlNdrcwdFHAObLUpCOxqU0JBvayn0LKwEFOvsTzeVNTQIr7bk8hR1QURFkbm6hCQ6N50j0V6RCNnpi+PFZHvs4eynf7K65JQejpZwYnDw2g513LmzM6PzqIEZbxeJeYr0wmE/JmMpPw4h1CJAa/VlSoW2eo1NPcQPdj7pJGdiTZA7FRuauaOV2nTvfD5SasFr308DvLNmMJtt+zjqgqNgpV2t4x9ZKBssbKr5owm98/h7yrNj5QxMulcZQmSx4leH1UQwbka9oRDWogmOFYf1BLU1m1FHF6NSBidLLKX5AHqWzK/4FiKEf0sIu0/Sle/Wd1io0YCYonb1VfsNo769OvvUa483/0ZiPdA8eVbdCI525QGF9BO7rE3moibOHgH5C/3nAB/A3cjfWE+b6tExubDTMw90CC0lG434/EbouQ251MrvhSfNehxyLHEi/uKAGsI6YP/oRGDCVzN/kscTFO3sjiXUwk0CLPXOWfJqhsjq68xL3xiBYG2LFa+RVLLfAXSUlu2KzYrProRGAKEWX2jyw40fzvI13axjYV5gdF1HBjYhuvkM64p4RLLexd9B+ZArzB8g9DbrAT0CL158q0ROipYcA8Y/CVYWAxMf9OkBNpoE0kAi48AHNLzOrdfL/U2iHcEiQvDMt00TIwhYyrLMiiEL9NsJXHj1WgOR0DdMEjBZQViUCyJ0r/b/UALzNKJ2/MXhxV86fzRtkN8OqElMS/VoPum8bywVDtjBmoGPQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(7696005)(2906002)(9686003)(33656002)(38070700005)(186003)(26005)(508600001)(4326008)(44832011)(52536014)(55016003)(966005)(5660300002)(64756008)(122000001)(316002)(66476007)(66446008)(8936002)(8676002)(66946007)(66556008)(6916009)(54906003)(76116006)(82960400001)(38100700002)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUNKNUgyOTZhNzJwV2dLME0vZm9aQ3JQenk0THBDdGc2dmFxM3BwUDhYSXBP?=
 =?utf-8?B?STc3L2c0TkRRVUoyNE1VN1JtMjhXRzhqWXcrbzBWUkNGU09xdmx2QWR2eFFQ?=
 =?utf-8?B?RUhoUkVYQXcwQVBRWjlRWEFyZTVkQWMxK2JCQzBZWHE4TDlTeTZzK2hmVEhK?=
 =?utf-8?B?L1R0Qk9PUGY3RHlBQUJJU3pHUFhheHlZUE93WjZPeVJyUmkraWhHT1R3Z3BL?=
 =?utf-8?B?ZEdpQklveGFHZDl2T0RVT3lEbVNwRmx2MTV5THE5Y2N1ZUhpVDN2MVRZZEpu?=
 =?utf-8?B?bHpZdkIwRXQwV3IwYXE5VHR6L0N5VTZ4a0hPWll0bEN2SithNmVRaEdkdGRp?=
 =?utf-8?B?eGVldWgzWTRqV2lhNnZENFlUVGZZeWRrajd2aWhLTko1T09IUU9vSVZkQkVn?=
 =?utf-8?B?bnFDc3NpdG1wbEpXQ2p2TUk4WTZ2OHZiU1MycXgwdEViakU3bWVXSHM4dUIy?=
 =?utf-8?B?dGQrNThoYmlTTVVaRWwrRTFiUkpnQW1kWHhGYmZYSTQvMTRHNE9JVjdZQXd2?=
 =?utf-8?B?MlR3RHVRZ1gvZlB5TjBXOXRwUzBhdW9JVk5Mb0JxRVRtUnBCRXZ0bEQ2YWoy?=
 =?utf-8?B?UURSOTlLK1J5dXN3Z3YxSi9jdTB2ck1PSGZLeFA0Q1hGNWFQQnZNUzVOb0Yx?=
 =?utf-8?B?SFAzdEZIWFQ1djRSeFUzSDFaMnRVc1FpU2c0WUFSVUZWNUF5RCt0MmtYUVVS?=
 =?utf-8?B?SWFXV2xoVHhML1ZzRGc3ZmNscEFWYURQd0Q5TzJGeWpFeVA3emlXaVB1U2NE?=
 =?utf-8?B?TkdBNklmTnRneUFLc1pHQ28wcktWWDZTNzlmQWxXRUhkLzluaWV3OEpIRGFk?=
 =?utf-8?B?S1pJNlNnSnpISXpTbjBpQ0pKbWxPRURab1Y2eFJUQWtkSXB2cDNZQmN4L09s?=
 =?utf-8?B?SXd1azVEazFvT28vdldMSi9KYjdvT3EzU3l3TEErU2lMdDdUcnNIRTVaYXVS?=
 =?utf-8?B?UXIxZlJjcWpTZUVTMmdNaGppbmFsQ2lENEF3V1Zic1kxQ3pIdVprWUVoeWpM?=
 =?utf-8?B?SGN6QUJRcEpseXNreXQySGU0ZG9DenAycWNmWmdYZDNObjA5U1ZqRHdWcmRD?=
 =?utf-8?B?THZ5NGl1a2dWTDJqRkxFb1VKNEttUGZZZzBLOUlaaGtLcjYvOHNTK0lndGlO?=
 =?utf-8?B?aENrTXlrYnlPbDA3K2VxK0kzWm1wQUJ2YUhFTkd3TUZlRzU0MGRGdkFTZC9O?=
 =?utf-8?B?UzBZaHl0NWtESHpldlQxV0dkdHBhWkdtT1dXSFVxckJNMEI2UTBiMms1KzIy?=
 =?utf-8?B?dmRGMEYzL1NLc3Nia0lUcjFTVzNCTkZpcFZrS3I5WG5RekJYaWpzY2RDTWEz?=
 =?utf-8?B?a1padmFRWlVCSnVpd3d0ajdOelRxUVk1WU9TK2FzckNZcW5SZnlWa1NsbDdR?=
 =?utf-8?B?SEs1ZGsxemo4K0k0YjB2RFJGMTZlQ1JiQkFNaWdjTWh5eHR5dTQzSStpNXZh?=
 =?utf-8?B?eC9VWjJlUDB1dmhyRUZ2NjF4Y0ZJeVVYQjlCYkI1VzZmZ2FnNHB2dzgvWE9r?=
 =?utf-8?B?QXBlaXBlNUlYMnZmZ1dRL2cxZTBnekE5MmNqR29ydXNEV2ZDaGkySlU1Y2ND?=
 =?utf-8?B?YWZJc3R4b0dZZ3VvcTRXeU5PSkhUVFMyZDFLTUJMN0M3ZG1sNDdyb1JLeFRY?=
 =?utf-8?B?ejMxUTVLNXBsZGoydzRUcHZsV1RUWld0TW1ta1NIZnpPY2U2T0ZGak9mcjF5?=
 =?utf-8?B?Vm4xbnpGblBvYS9IemM4ZWxLUVNWcFprdi8wM0k5UGd1K0M5cEtIV1BvdGdy?=
 =?utf-8?B?RW5hYkFzRkdqbzc1aXZxbTE4VDVsc1BtZnQ1QWNFVWo0Z1RmeTBkeElQNmUv?=
 =?utf-8?B?aXk2bjhHZndwbmlFeFFpOWxaZndoWFFLV2ttajYrc2U1bDExYWljbXJZeXNj?=
 =?utf-8?B?eFlQK1lRM2l5UXMzMUxRNy9aVUhjaFNtOEorSTVHR1VBTHU0SXk1QXpLK1ZS?=
 =?utf-8?B?ZzdLZ2xXbldzcVZZUFk3cEFURUJlZmFCMkFzRHVGQStCZVhWSURSbHhHdTJR?=
 =?utf-8?B?dTg2cGNnM1hrSkN0ZnhaN0hxVEUxNFN2ZUNsM2toSm5NUEhOSDZrVjBtNVkv?=
 =?utf-8?B?NUVPU1NDVXpNY0hVeU1rWGJhOW5sWnJlRFpMY1pEekdMOHlJeGpGRlN0azE1?=
 =?utf-8?B?RXVpbDZ5UVlJUG5iUjQrTVY3YXQ0WHIyMnJGMSs1eEZjTVBhOEl5VFRZcUVx?=
 =?utf-8?B?NjRRRWJsUGxTazQrSWtCUXpvNEo0TzU2QldGam5scFZnMEZQTUJQNnU2dk9F?=
 =?utf-8?B?Y1lxYzhoRDJUcjdBMnJseG9WcUFBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe70f461-25cd-47ce-f9af-08d9ecb2108b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 16:26:17.4797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KjBH/Aq1+CVbbTlcJW8eI/eIxUMgbdOm6pLHBF3kdtcvTDJ6vQx2YbPklF7qFkJZdYBePW5adxsPlPrXot+iz+pnm9hJSstgsazFKioBnAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB5889
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IFRoZSBtdjg4ZTYzNTIsIG12ODhlNjI0MCBhbmQgbXY4OGU2MTc2ICBoYXZlIGEgc2VyZGVz
IGludGVyZmFjZS4gVGhpcw0KPiA+IHBhdGNoIGFsbG93cyB0byBjb25maWd1cmUgdGhlIG91dHB1
dCBzd2luZyB0byBhIGRlc2lyZWQgdmFsdWUgaW4gdGhlDQo+ID4gcGh5LWhhbmRsZSBvZiB0aGUg
cG9ydC4gVGhlIHZhbHVlIHdoaWNoIGlzIHBlYWsgdG8gcGVhayBoYXMgdG8gYmUNCj4gPiBzcGVj
aWZpZWQgaW4gbWljcm92b2x0cy4gQXMgdGhlIGNoaXBzIG9ubHkgc3VwcG9ydHMgZWlnaHQgZGVk
aWNhdGVkDQo+ID4gdmFsdWVzIHdlIHJldHVybiBFSU5WQUwgaWYgdGhlIHZhbHVlIGluIHRoZSBE
VFMgZG9lcyBub3QgbWF0Y2ggb25lIG9mDQo+ID4gdGhlc2UgdmFsdWVzLg0KPiA+DQo+ID4gQ0M6
IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gPiBDQzogSmFrdWIgS2ljaW5za2kgPGt1
YmFAa2VybmVsLm9yZz4NCj4gPiBDQzogTWFyZWsgQmVow7puIDxrYWJlbEBrZXJuZWwub3JnPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IEhvbGdlciBCcnVuY2sgPGhvbGdlci5icnVuY2tAaGl0YWNoaWVu
ZXJneS5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTogTWFyZWsgQmVow7puIDxrYWJlbEBrZXJuZWwu
b3JnPg0KPiANCj4gS2VlcCBpbiBtaW5kIHRoYXQgdGhlIHR4LXAycC1hbXBsaXR1ZGUgRFQgcHJv
cGVydHkgaXMgbm90IG1lcmdlZCBpbiBEVCB5ZXQuIEkNCj4gc3VnZ2VzdCB5b3UgcmVzZW5kIHRo
aXMgcGF0Y2ggYXMgYSBzZXJpZXMgb2YgMiBwYXRjaGVzLCB0aGUgZmlyc3QgYmVpbmcgdGhlIERU
DQo+IHBhdGNoOg0KPiAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWRldmljZXRyZWUv
MjAyMjAxMTkxMzExMTcuMzAyNDUtMS0NCj4ga2FiZWxAa2VybmVsLm9yZy8NCj4gd2hlcmUgeW91
IHNob3VsZCBhbHNvIGFkZCBSb2IncyByZXZpZXdlZC1ieSB0YWcsIHdoaWNoIGhlIHNlbnQgaW4N
Cj4gICBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC0NCj4gZGV2aWNldHJlZS9ZZ0dCZTBC
UyUyRmQwbE9WdFVAcm9iaC5hdC5rZXJuZWwub3JnLw0KPiANCg0KSSBjYW4gZG8gdGhhdC4gQnV0
IHRoZW4gaXQgaGFzIHRvIGdvIHRocm91Z2ggdGhlIG5ldGRldi1uZXh0IHRyZWUgb3I/IEFzIEkg
aGF2ZQ0Kbm93IGRlcGVuZGVuY2llcyB0byBSdXNzZWxzIGNoYW5nZXMgd2hpY2ggYXJlIHNpdHRp
bmcgaW4gbmV0ZGV2LW5leHQuDQoNCkJlc3QgcmVnYXJkcw0KSG9sZ2VyDQoNCg==
