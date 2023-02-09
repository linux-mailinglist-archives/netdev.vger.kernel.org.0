Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D920690B71
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 15:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjBIOOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 09:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjBIOOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 09:14:38 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2079.outbound.protection.outlook.com [40.107.104.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F7330B3F;
        Thu,  9 Feb 2023 06:14:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnnWRlNOiq8NDMy3nbIIwHZKirV2fiIyng9jWcLzDAZq2XMCafkYN08Z3+H+pGeaz3FjqlirAa04FXYYN6gNnqyh7PHbxcOvNWmVKMFhlOmgNZTVMaRRoNZNHHXVdxOf8tXuNFJ7oHr35aqRzd6EG5rjKo+dl1fd0WXdO4kFxCxRhdb2YNo1A3itNSIz32xji2hn7xoO56YboICYmlpUCJDvOx6LGqRJ06JIn0gI/AEa2tsATJ4XfSqSNcKAbrfEFmZkosilUcbhppb8QwiKH9jAfLWoRMaVAbzx21OfXjsBknLQ1wyDvCvvFO3Bm87PrTg9/7a6WNDTuRKCW4uwUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAN7tY0bpBECorX2EdasSqP+vBnx09Ziemj20ISiHhs=;
 b=hGV/AH5VJWhnTE7JLc5MNcBCZGb8sm3VNsUGgEumiP30nG9HU6JMHpDQ7e7spHGknh8cXjGgCyFgInRk1KGFnuQi3w0cxdLqAGPhPXAE7tud8KDjsv3kihi0DlOux63IMX7lvtpNEf7IzrTGd7FQElxdyM4CPCAvjEDJV9K7RQKJf1ZZgqAod4Pb3inWuvBSeBpXsKkwKFsvYz9gNJtt8Tgc0s5/NX+65KJbSyJkfeoaZY16w2dJIe8ZUKLT2pUFssI3IvuRVewWPQSKUWEHOUUCxW274p8n2xWXqjSAxP0rT+M2YrNgcuPL1lyCzdg1LlA/LCzJgFigdewfV+a6kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAN7tY0bpBECorX2EdasSqP+vBnx09Ziemj20ISiHhs=;
 b=ZqFibBEz0zaxBSiLnERlNdMWkc+/5pEvbRWiQe50ngwzaHlNPdVPyC330Z+PT5wIf2dnOce3jDivAKOv9rXyKEmwhwtvhgIvAO/Ny1POqWzopKxw2XpFkKefhPf8tJmshevnuI36142NCjuY4lLoY2heZkisxHIRaRB35MF/1x27PAK0HJcP0lSTWCtrqdAOQQK6T4HxXRHrK01hVQpvqoHST2UXKeL4AgreQUoxQlzUvvgvh6ZDaacpbzULHjxWuRsXJT5sY2m4/3/MsCnfRz6edzSRjhanoi0IwS2PWqdzaECeabPi4tufgUws+3Q8IiWdduIlRbADV4qStoygJw==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by GV1PR10MB6562.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:82::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 14:14:34 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::41bf:a704:622e:df0d]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::41bf:a704:622e:df0d%4]) with mapi id 15.20.6064.034; Thu, 9 Feb 2023
 14:14:34 +0000
From:   "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "wei.fang@nxp.com" <wei.fang@nxp.com>,
        "xiaoning.wang@nxp.com" <xiaoning.wang@nxp.com>,
        "shenwei.wang@nxp.com" <shenwei.wang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Thread-Topic: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Thread-Index: AQHZO6axGn/PBMQQZUCM4xDb48lCTa7FyycAgABtnACAAB6UgIAADvWAgAA5JwCAAArpgA==
Date:   Thu, 9 Feb 2023 14:14:33 +0000
Message-ID: <e3497a4b2b690d0b946601f2eae7779bac772555.camel@siemens.com>
References: <20230208101821.871269-1-alexander.sverdlin@siemens.com>
         <Y+REjDdjHkv4g45o@lunn.ch>
         <9a520aac82f90b222c72c3a7e08fdbdb68d2d2f6.camel@siemens.com>
         <DB9PR04MB81063375BAC5F0B9CBBB6A0D88D99@DB9PR04MB8106.eurprd04.prod.outlook.com>
         <60f22dab4c51ee7e1a62d91c64e55205c18b9265.camel@siemens.com>
         <Y+T2oku3ocAuafe0@lunn.ch>
In-Reply-To: <Y+T2oku3ocAuafe0@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|GV1PR10MB6562:EE_
x-ms-office365-filtering-correlation-id: 745766f7-c8b1-4a6e-b812-08db0aa7f801
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y8fNIumRikduk+VUfGBMB7/veZkWZRDiLgkySrCxEg+mRiLv/pb/aABdwgB7/F1mtExnRKGCi4WRMxVlllC7gD2EEtoP4TFBdTRYQhBZIE02c0NBrztPaiozIysbx2VkJgrmpCx5xyNPWOLS299Xo2Ql4kpC+ddeUYX6nP8ewK1qIcDroohtzMsM1dpvTKuRw6pgQGXcLRoDPhTuCMiafB2IXnn98k9qWhm8QNZm1zqfi+35JbhvtE2/8FD73o7aZum+f2nbR5li5pWJBotTc8UihnBHe27bgWumniC2ER5vZ8ccHazpGi5hp2dJbr1s11WMe5SHnyFqafAIJF+MNDmox4yq5h+rheQLSp1q99gcfTXvc3zMmH0dPWufulEdIKxU7N5kS0kTM0bUV8+8VMQ32yvSfmJwLjyJrPiM6ub0Yx0cgQI/AJKVfGlanCNuiUSvrwTq9HjOTMdkyyYNngN7pryrd+vhrbFGc9dcMJLPyEBS6xma32t7QhMwD3dAdCXyGGyqcQsR8K6FuRk7OtEHlYjjSBohYYNO3Z1K4Gh3+XnpSNOuZU4nkv23+1mvHYjiACNwO7D/zPX50/rTH7FDbgwodZUwfk1+uNGSozmPQjAA/RxX2bapk7PkzKkoef6+VreMcWWHln2Xmu7ZHlXOjweka2QCmx3ek7Kd6x220ie2o97mCkhZDsn/M1NPoiGk/Q10+SZqdNs7Gzv6bgFdHbsdVAB6SmzXC+tSzoqgcw4WHEiuwhVFCHw5gfpq7735pNIcfBpL9xGl4OvvjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199018)(122000001)(82960400001)(38100700002)(8936002)(6512007)(186003)(26005)(5660300002)(6486002)(2616005)(36756003)(38070700005)(71200400001)(76116006)(6506007)(55236004)(15974865002)(66556008)(64756008)(91956017)(4326008)(316002)(6916009)(66946007)(8676002)(478600001)(86362001)(66476007)(66446008)(2906002)(41300700001)(54906003)(83380400001)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGk0dkZsZ3RqcXFzUE0rUU1GMXZ1eEVUK1Bub29rT050NDR5T0hTS2c2ank2?=
 =?utf-8?B?dDBXUFd0QXAyVVZrbm0xM3ppd3NxRVhoT3hKeHFuUE9MTzk0U1BKbEpwL2Fo?=
 =?utf-8?B?b05zb3FyRWJXQW5KTWt5S20vK1JhbWorNk9kaXk0Z3dYYWtkSWduMElCM2Fr?=
 =?utf-8?B?aTNneGMrWWRCcWwxUjBCQ0FvUElWRkVGaWJ4OGxUalFHMlFTMk1mMTJYaUNM?=
 =?utf-8?B?M0hwT1BTYkhvYytjSlVIYmNhS3VDSC9jdFpVSHJMTUp1dFJ3UGpza2N2S0pV?=
 =?utf-8?B?Q21lNkNiaHQ2aXFTY05sWEdHYWRsbEE0aUtqZVNWczVZQnkrQURGa2tZdDlB?=
 =?utf-8?B?TjFablFDQmFxNWtTOXdhV2VIVHZQR2N2TXlGZHZ4Z3doZk5ENkdXdmU5NmFm?=
 =?utf-8?B?UnBTRXAzbG1Xa0xCdzFqVVlvKzRiaFAyTDFmSThhYTNnQzlablBQcC9xODhu?=
 =?utf-8?B?aHBORmtVOGlVTk1aOVJFbmN4aHNLMlExdUxhaXBTaE5zWFQ3L29UMVBqUDdG?=
 =?utf-8?B?eTVqbzErNkFSVnJjWXRmQk5DTWtycGdyeGlmS0JSTmo1WGNJeFF6clhSNXls?=
 =?utf-8?B?eldzczZlRlpDMUY4aGt1VTZvUEk1cVF0ckpmZEtvUWswWk5WTERJTDZ6UTVv?=
 =?utf-8?B?aEUrWWFpazUzNVJFVEpDMFB3Y09iSXBVSzVGblN1N2g3b0lLbjRiQnVKZTZW?=
 =?utf-8?B?UWlOTDdPMk9KU1dadldHL0Y2SnUwTHBtNzM3VGVuNXBuNHJHeEE3WmJPQUlN?=
 =?utf-8?B?ajk2cDUyS3dUUjZTcUxMaDRIK2VGUG14UHVpSEV4YytaVEFvTVYwaXE0anNV?=
 =?utf-8?B?RGJGZHczMUM2ZkF6bXVxVHNYUDNXOTVTWXkvaHl6dzFsSndIOGlzRWd3dG1i?=
 =?utf-8?B?RS8rUW5yLzgzdW9pZHBUalZEbW5yK3UydXJOd1Q5Tk51RDQwRlBEb1N6SHFz?=
 =?utf-8?B?amVvU01xUXVkZXIzOGpWY1JXSWVCaG5nOFFaOFpqd0tJa1RNKzFPR2xnNG5O?=
 =?utf-8?B?OEpkVWl6VDlzWWdmTGU3eGQ0ejJQd3NScHZ4eVFHWTFrb0tJSjQ4ZTNXMW9L?=
 =?utf-8?B?Vk9XQWtwQVhoSEdiNjBIT0xabGVoTThFOXppSUVKSU4yeUxlbUJnaXp5b3RZ?=
 =?utf-8?B?eVFwa3h5b3hYcWRSWVZzK1ZaN2pIOWhJRks0d0xZdnhQN1dFa2VLbHNzakhr?=
 =?utf-8?B?b09QNWdmOTBCSjdid0dHWkZ6M051THdEUHFlOGwzTk52aVpDcGhoZEphWnkx?=
 =?utf-8?B?ckFqV0liY0c5RCsyam80RTg3MHo0U3Z6R2lnSVB2bVJkVjI0N3hpeVpkOFpt?=
 =?utf-8?B?MGtyM0xmMTdEMWJZSlhhMDVJRE0raWR2R21NMGFCK3lLTmFGL2x5aHdwWFRP?=
 =?utf-8?B?K0hVdEREajBhOUovRk9TdXVwbzlxcHBZUTE1U2xqeGU1UExha2tENzhOSDJk?=
 =?utf-8?B?U3Bock5zdnBpd0dyTytLeG1VZVQreXBRNjNEQ3hKZlBGUlQvZmNpMlhhNkE1?=
 =?utf-8?B?NnBZMFdVM2wvSGxoelROTDM4QmhsWTAzNXJaMmNOVUp6TTN5YUkwRTlGNzZF?=
 =?utf-8?B?OERWcjhWSHhpUXo0bWFMdnM0cXJzUmNCTG5hMU5lVWFQWmh5T1FLaWs5a0RL?=
 =?utf-8?B?VXhwN0NFdFNCeFdLMThPQ3Z2SkFuS3VnS3ZXaXdZY3dQYVJhN3JRYnM5Qm1J?=
 =?utf-8?B?QmFocURzQmhUL3kydGNpdWsxRW9rYjV0REZ2eUNmbngzTkNZSXBFKzZYeEFN?=
 =?utf-8?B?b0REN2QzYVZmY1A5Rk9wTXRYUy9PaTNsUGFjejIyU0lRWXZmenRubEJiRkFR?=
 =?utf-8?B?OXNUTFd3Zm0yaVAvbmUyMFh4dFRqM3hkcHNJcFVnYkg0ZWpPUjEzSU9PVXVi?=
 =?utf-8?B?WWZUSU92cm5hcVowMnhVamwxd2cvcmhUcktWREpnWitxOUFuc2lLTDBGZzMr?=
 =?utf-8?B?cjRBR2REZnJ3Qld4dVpZR2liMUhKVktRdkpnelpGMFBieXJSekg0TjNCdzRL?=
 =?utf-8?B?bG5rdlhqcUhEMEtnbTh4czc0ZnVZdnlLM2JxTFVRUXZUTndpenVlQk1MWlBB?=
 =?utf-8?B?MHRGMEpYdUFiejhzd0NNZmkrVENYbzQra1lMdzdWcDBtbG1CTGJialZ4YUtK?=
 =?utf-8?B?ZHZHeDJkNVJ5czU3V1MvWXBrUGFKa2haRWtIaHJRc2o4OC9oSXJ5TlpOR1Zz?=
 =?utf-8?Q?vM1Big+AqO7aFySOAPbWZ10=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <690954D6A126BE4088779CCCA08CFDE5@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 745766f7-c8b1-4a6e-b812-08db0aa7f801
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 14:14:33.9578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S1rDX08QahppWY9MQcqxdFepxK9wv9/qq7RdPRde98N/JfNU+u7ZKWimezucIestTf60kbzQLQWZRKQQsYpA0bbxO8yJWCnfiOmhnsuCN2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR10MB6562
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gQW5kcmV3LA0KDQpPbiBUaHUsIDIwMjMtMDItMDkgYXQgMTQ6MzUgKzAxMDAsIEFuZHJl
dyBMdW5uIHdyb3RlOg0KPiA+IFlvdSBhcmUgcmlnaHQsIHRoZXJlIGlzIHVuZm9ydHVuYXRlbHkg
bm8gaS5NWDggc3VwcG9ydCBpbiB0aGUNCj4gPiB1cHN0cmVhbQ0KPiA+IHRyZWUsIHNvIGl0J3Mg
bm90IHBvc3NpYmxlIHRvIHJlcHJvZHVjZSBhbnl0aGluZy4NCj4gDQo+IGNvbW1pdCA5NDcyNDBl
YmNjNjM1YWIwNjNmMTdiYTAyNzM1MmMzYTQ3NGQyNDM4DQo+IEF1dGhvcjogRnVnYW5nIER1YW4g
PGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+IERhdGU6wqDCoCBXZWQgSnVsIDI4IDE5OjUxOjU5IDIw
MjEgKzA4MDANCj4gDQo+IMKgwqDCoCBuZXQ6IGZlYzogYWRkIGlteDhtcSBhbmQgaW14OHFtIG5l
dyB2ZXJzaW9ucyBzdXBwb3J0DQo+IMKgwqDCoCANCj4gwqDCoMKgIFRoZSBFTkVUIG9mIGlteDht
cSBhbmQgaW14OHFtIGFyZSBiYXNpY2FsbHkgdGhlIHNhbWUgYXMgaW14NnN4LA0KPiDCoMKgwqAg
YnV0IHRoZXkgaGF2ZSBuZXcgZmVhdHVyZXMgc3VwcG9ydCBiYXNlZCBvbiBpbXg2c3gsIGxpa2U6
DQo+IMKgwqDCoCAtIGlteDhtcTogc3VwcG9ydHMgSUVFRSA4MDIuM2F6IEVFRSBzdGFuZGFyZC4N
Cj4gwqDCoMKgIC0gaW14OHFtOiBzdXBwb3J0cyBSR01JSSBtb2RlIGRlbGF5ZWQgY2xvY2suDQo+
IA0KPiBBcmUgeW91IHVzaW5nIHNvbWUgb3RoZXIgaW14OCBTb0M/DQoNCkknbSByZWZlcnJpbmcg
dG8gaW14OHF4cC9pbXg4ZHhwIGFuZCBteSAiZ2l0IGRpZmYgLS1zdGF0IiBzaG93cw0KdGhhdCB1
cHN0cmVhbSBoYXMgb25seSA5JSBvZiBMb0NzIHVzZWQgdG8gYm9vdCB0aGlzIFNvQy4NClRoZXJl
IGlzIGEgYml0IG1vcmUgdGhhbiBqdXN0IEV0aGVybmV0IGluIGl0Li4uDQoNCkkgaG93ZXZlciBi
ZWxpZXZlIHRoYXQgbXkgcGF0Y2ggcHJlc2VydmVkIHRoZSBsZWdhY3kgYmVoYXZpb3IsIGluDQpE
VC1sZXNzIGNhc2VzIGFuZCBjYXNlcyB3aXRoIG9ubHkgb25lIG9mIHRoZSB0d28gRkVDIHBvcnRz
IGVuYWJsZWQNCmluIERULiBCdXQgSSBjYW4gbWFpbnRhaW4gdGhlIHBhdGNoIGxvY2FsbHkgYXMg
d2VsbCBpZiB0aGVyZQ0KaXMgbm8gaW50ZXJlc3QgdG8gdGhpcyBmaXguDQoNCi0tIA0KQWxleGFu
ZGVyIFN2ZXJkbGluDQpTaWVtZW5zIEFHDQp3d3cuc2llbWVucy5jb20NCg==
