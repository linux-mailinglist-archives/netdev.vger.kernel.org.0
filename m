Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6276D5865
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbjDDGFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjDDGFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:05:24 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2052.outbound.protection.outlook.com [40.107.7.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1D7BD
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 23:05:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UV+6Xbx/lI9A8TYYolJIH1AN/HRsvsyyraO6QovivlKvbLt3c9L8nvXR8DAbDyGtZBOW5FkyY9kVkbEQ72iITW31h3Bhg86tgm5P9nPuvR+CqII7+LPnFeiV8gLAmgqO0tHAWta77rrtB6z1gaVC0vc8GwvXRZ8SGwAzCV6WyznjijwLGrUqgajvvi31On2ZkF6daiC+W1NCqSfR2ce1Do4q5dZxUzQLggyRSgHsEwzWo4fDJkefxlbjdxJ76KHbi5y4bmucm695SJgxclibMeeM2mPjh967cf4eeZ4YL4Ib0ive9XhDjr5lLZ8IwgeI4ln/3l2mkMylSW2XsewplQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uq9MoG9lW+ly38BgJNwy+qI1CxvZ84/OifZMkHTNXeE=;
 b=oTNFSaNjPP4cn7TvXRo40aH8c1C9B47WNZWQoOHdYmKDjfLDcNC5sfOeAj7xYE43nB34CNc/jfltdqvLksKz1rc6OOQaczs+NXwRxmIS5YvAy+Sb1/xKah3ZllB8sZ+lQmEZHsSM9hSWbhWluhWMo5M3dTR5wa+B28vXYlvwaQJtv2P6rjh4LVQEq0kUjbZjtQJo8DJ+MpLWPWN8GFVt2XlNH1X22bGRpeINkd5BU72W593BlOpRH0RwzfgztVGb9pFjJeg1uX2OqQ0ew6XAMaNW0S0GeSH+tzCKTarN/5hzEFZUXtxVQaa3KCfiAC+4jRQzehSh3+uX+YW+zP++1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uq9MoG9lW+ly38BgJNwy+qI1CxvZ84/OifZMkHTNXeE=;
 b=H1J2TzS9T3vmcfk00lvCj33teNlpJKYQeT/BGH1S0tKapQ1SuEF1MEumDtacjv5zXXr0CA0JTALyzIf7vDINmms7s8oSxYR123Vv8Gb+ju8bq9+FBM32fERSZdja4QPyCrt+6Rw9Z7z1HrDX/haiQn/T1vQWSxTnKP6InS9eN0s=
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by AM7PR04MB7144.eurprd04.prod.outlook.com (2603:10a6:20b:11b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 06:05:20 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::7570:a694:21d6:f510]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::7570:a694:21d6:f510%4]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 06:05:20 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Greg Ungerer <gerg@linux-m68k.org>
CC:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [PATCH] net: fec: make use of MDIO C45 quirk
Thread-Topic: [PATCH] net: fec: make use of MDIO C45 quirk
Thread-Index: AQHZZrV2yTYflEuirUW+DXv3D3sGm68ap/YQ
Date:   Tue, 4 Apr 2023 06:05:19 +0000
Message-ID: <AM5PR04MB31391F3638611D67EEC1DC3488939@AM5PR04MB3139.eurprd04.prod.outlook.com>
References: <20230404052207.3064861-1-gerg@linux-m68k.org>
In-Reply-To: <20230404052207.3064861-1-gerg@linux-m68k.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM5PR04MB3139:EE_|AM7PR04MB7144:EE_
x-ms-office365-filtering-correlation-id: e372135d-2cc3-4467-4083-08db34d291f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vkHlYpD/LBTblCcWfLKZceQ49wfN/1O/OddsRbmsiXDwaa0hqPXeSiUx7J1zYtak3KQaxLGZ4h3xOZhp6c756xyt7dKLDMdlCHj0XtQqvHUw+sB7ACL3IcUj5VSWyJqoZipGdvRaSSt3VexJ4lerGWbDGjo9w/GhgfcyZTYgPVro/rzfa6iPuW/wmzmxU5Dsg2OAGz0yZiDH3kU6CI0KGb8C5+BL5aNIVJCCZ2/xDJ72jXVZ2/96XWUS50jHlibuto/2DpwGVp682H1gAgdsncsCz/OMlnujp9GYs4Of9AO7Yd9WfGfYA0x0twIn4lhUot0XrRllOsB0l8LIYag5Xcnxt1f8t6DD4YIh32i/u9D1yXB801x1qXV+nVOIx14Hs/mMkCQCEpoEQkdOcwup9B3GozAZ4umRqK6vlzKHN9S9cJdKHnyFH2+AFjmT/hLkw6awsVb+Q8OBKo4xr5TPr7UKswrzFRSiTLTkr5SUr/ITDS6qMoyo24TscF9r4dqbGn8l8Fa2G60Aec7zk8Aw8JOpKj082i+kfQjoulo88T0omE0JQ32R6C1vaDp3pAdLKruozcrSriqVQsTo7b7q0jHO03FqwEgIEKG/M/gUgRzB9HYs1NrBq+EF6XGhETNM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(478600001)(316002)(54906003)(5660300002)(52536014)(8936002)(38070700005)(33656002)(44832011)(2906002)(4326008)(55016003)(86362001)(8676002)(6916009)(64756008)(76116006)(66446008)(66556008)(38100700002)(122000001)(41300700001)(26005)(6506007)(9686003)(53546011)(66946007)(83380400001)(186003)(66476007)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?V2hEbjZoYjRqVm9DV1E3NEtkNWVtYkJYUmlGNE5rKzk1RjRsV1pTdHJXbGxN?=
 =?gb2312?B?SFlGd0hDWVI4c0Z0S3VmbXd2Qmx6ZkQwdXR6L2NCOTVlUXVFRVYvcE5PTmd0?=
 =?gb2312?B?UFpxWFoyeFB5SXdZTy8zQXo1Q3BKMm1QdldDWFJMUm5vNStHRVZDM3BXVlhm?=
 =?gb2312?B?UnBtVDhQRk5BczdUTUxvWFY0eWg4RzhsaUJLRTJGeUQvMnFSMmZnUUtMM2xa?=
 =?gb2312?B?RlBXdEJkaVZHeVY5MjJhTXhUWUNxaDl0NEJZYXUwTUI3RndralYySm1FQkZ5?=
 =?gb2312?B?bTRvUHlYN1hhYnovMTA3T1dGQ3kxek1NMGcrc25TRUtReUZqTVozTEVPbXdq?=
 =?gb2312?B?ZkNnOUtEM0M5R2NwU0xXYWNmWGJBcG1YK0JGci9wK0MxeDRMZGcwWTZqMlZZ?=
 =?gb2312?B?YVB5QVlLa00vc3ZyM0s2SFN6bHZSOEovZkMxeXBQRHpicDZFZWwrbW0wUDVE?=
 =?gb2312?B?R1pXMW1XMENJZDhlVDIzck5tOXJJODFHajFaNnZuOC9INjZIaWJUanNvdFpz?=
 =?gb2312?B?ZkgyZTE4V0V1RGFpbThZSHlwT1d0MDhvWWdENFhHdDhJK3RYOXBkT1ZmMVZN?=
 =?gb2312?B?K3pLYTk2Y3VPTzhGM0N3S3piLzhzdlcwQnkrV3FaK3hVZWIyK3hvbTduTFpH?=
 =?gb2312?B?ZE1lUFN2eW5kYU1NUGRmK0duUFpXMGtBU2o3VDE1S29RcmQySUpXV3FOcEVs?=
 =?gb2312?B?c0NJWFlnTkFqd3kxd1ZPNXhSR05sOEgxNlNpblJ1UmFLTU0zVTdMMDVXRXk3?=
 =?gb2312?B?NDdWN0NjZnNRK2o3ajNVTG5oZ0EwcWtVVncrWlo3UU42K0puVFVzWDdFY1Fx?=
 =?gb2312?B?YmFzKy85eHRQWFpzS1kyYWdDd2t0WFV5UEhRZzRxVE13SWcyejEyMCtFcktk?=
 =?gb2312?B?MXlDNTM5LzRaRzFkakVWa3NnMG1jaWhhRFpMeEVCWDd4UE9tMHlWZlRjUW1P?=
 =?gb2312?B?ZkJWbHlsY1I0YlYrQWl5ZjFtMTdaYTZRamh6NWtCWWdwakZLSDduV2hsc2J1?=
 =?gb2312?B?dDBJSWNYamNWSEw3c2xSR2RYZDYvMnpqODV0b1NxTXM3NEVXZjl1Z3pxYjlt?=
 =?gb2312?B?ZlZxQTNjeWwydFJEbHFrM1pFVHJZK2Jnd0pYWjQ3ZXJ1V3ptd2NlOFlMbTNh?=
 =?gb2312?B?QWY5REVFQ3B2ODdDak8yaWZsTWtFeVBUelBkdjZBNUF1N0ZoNEV3QS9Wek42?=
 =?gb2312?B?c2txYXpYKzJGV3BUUkx4SUNYRWFHdWcvUVd3S2FudFNqZU1FSW93MkxWcThQ?=
 =?gb2312?B?Y1pmeWtzVFFjaFcvaDd1TmFpMWxzSVo3M2dvWGF2cm9Pa1NyejFoVkt2VGhI?=
 =?gb2312?B?VitzdDR3TXpTbEZicmZIKzQwYUxWcFdQOEhxQU8vV2FrcVlEb05jOVZPSVFT?=
 =?gb2312?B?NjdzSkwrV1cwclh3cGNpVFluaWI0TUJBYm1LNVR4U1FWUll4QTlaYjBvRWtK?=
 =?gb2312?B?TXd0WEtlSnNSTUNCRVRuT1dtSUJJcVdwbG1xVEdybHR2UXZ0RmtWWW9nWEJj?=
 =?gb2312?B?TFQvWThHdGhVRGM5NDM5ZlUyQnlxQmpabnpqR1gzV2dLK05wb0FmV1h6RlNm?=
 =?gb2312?B?cW5vd3k1VHJ0RTN3T0tGMnhkc1FGKzk4bW13TUdwV2h2VDV2aFd6RFIzc3l5?=
 =?gb2312?B?MXRVWXNVQkZ0cFV3YjNVYW5PQmJ5Mis2b1VQVnhET1Z1eThUanNYd1E4T3Nu?=
 =?gb2312?B?ZVc5MmROVVdUTEx5VHFDQlB1L1NqdGZUbWx6ZFNRL3FOd1BnektzQ2U3S2lW?=
 =?gb2312?B?YWZ2R0QrWkxYdDR2MHRhVnE0UWczckh4NHFYaTZKcEZPajgzam1udUpZOGxz?=
 =?gb2312?B?bHFmWklzRTFBMldRdUk4V1VjUG8wLzJYVXFFZUtNZmRrc21qVVJMOUl1UmRa?=
 =?gb2312?B?aE9xdlNkNDFrVzNnMXZsdzZMdk9pOWpXWDJqVlUvNVlkOVd2aDR1ci9DK2tr?=
 =?gb2312?B?b1YxclRMcHdXTFRBKy9MVnZ1VUZ6TW03bXo0WHFKK2swL0RvUmdKTVQvUUV0?=
 =?gb2312?B?dTZKanhvTEZiOW9XWlpxN1RqNVV4N3pPUEYycWMvcGxLeU1HRXhUclpTdFdR?=
 =?gb2312?B?K210L282TXZGcFkvdmJMakdWamRPODVGRE5Hb0FseG5CNnpxQWtESzM4V2Jo?=
 =?gb2312?Q?2QL8=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e372135d-2cc3-4467-4083-08db34d291f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 06:05:19.8943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xz9hDSkwHYMqsAzUCq1CKRQykPYrIxvD2m9oHDu4UN5wGfGMP3PwoLhrBaUeJC167vZrxcxrYSLczeKCSoYsQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7144
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIFVuZ2VyZXIgPGdlcmdA
bGludXgtbTY4ay5vcmc+DQo+IFNlbnQ6IDIwMjPE6jTUwjTI1SAxMzoyMg0KPiBUbzogV2VpIEZh
bmcgPHdlaS5mYW5nQG54cC5jb20+DQo+IENjOiBTaGVud2VpIFdhbmcgPHNoZW53ZWkud2FuZ0Bu
eHAuY29tPjsgQ2xhcmsgV2FuZw0KPiA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsgZGwtbGludXgt
aW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGFuZHJl
d0BsdW5uLmNoOyBHcmVnIFVuZ2VyZXINCj4gPGdlcmdAbGludXgtbTY4ay5vcmc+DQo+IFN1Ympl
Y3Q6IFtQQVRDSF0gbmV0OiBmZWM6IG1ha2UgdXNlIG9mIE1ESU8gQzQ1IHF1aXJrDQo+IA0KPiBO
b3QgYWxsIGZlYyBNRElPIGJ1cyBkcml2ZXJzIHN1cHBvcnQgQzQ1IG1vZGUgdHJhbnNhY3Rpb25z
LiBUaGUgb2xkZXIgZmVjDQo+IGhhcmR3YXJlIGJsb2NrIGluIG1hbnkgQ29sZEZpcmUgU29DcyBk
b2VzIG5vdCBhcHBlYXIgdG8gc3VwcG9ydCB0aGVtLCBhdA0KPiBsZWFzdCBhY2NvcmRpbmcgdG8g
bW9zdCBvZiB0aGUgZGlmZmVyZW50IENvbGRGaXJlIFNvQyByZWZlcmVuY2UgbWFudWFscy4NCj4g
VGhlIGJpdHMgdXNlZCB0byBnZW5lcmF0ZSBDNDUgYWNjZXNzIG9uIHRoZSBpTVggcGFydHMsIGlu
IHRoZSBPUCBmaWVsZCBvZiB0aGUNCj4gTU1GUiByZWdpc3RlciwgYXJlIGRvY3VtZW50ZWQgYXMg
Z2VuZXJhdGluZyBub24tY29tcGxpYW50IE1JSSBmcmFtZXMgKGl0IGlzDQo+IG5vdCBkb2N1bWVu
dGVkIGFzIHRvIGV4YWN0bHkgaG93IHRoZXkgYXJlIG5vbi1jb21wbGlhbnQpLg0KPiANCj4gQ29t
bWl0IDhkMDNhZDFhYjBiMCAoIm5ldDogZmVjOiBTZXBhcmF0ZSBDMjIgYW5kIEM0NSB0cmFuc2Fj
dGlvbnMiKSBtZWFucw0KPiB0aGUgZmVjIGRyaXZlciB3aWxsIGFsd2F5cyByZWdpc3RlciBjNDUg
TURJTyByZWFkIGFuZCB3cml0ZSBtZXRob2RzLiBEdXJpbmcNCj4gcHJvYmUgdGhlc2Ugd2lsbCBh
bHdheXMgYmUgYWNjZXNzZWQgbm93IGdlbmVyYXRpbmcgbm9uLWNvbXBsaWFudCBNSUkNCj4gYWNj
ZXNzZXMgb24gQ29sZEZpcmUgYmFzZWQgZGV2aWNlcy4NCj4gDQo+IEFkZCBhIHF1aXJrIGRlZmlu
ZSwgRkVDX1FVSVJLX0hBU19NRElPX0M0NSwgdGhhdCBjYW4gYmUgdXNlZCB0bw0KPiBkaXN0aW5n
dWlzaCBzaWxpY29uIHRoYXQgc3VwcG9ydHMgTURJTyBDNDUgZnJhbWluZyBvciBub3QuIEFkZCB0
aGlzIHRvIGFsbCB0aGUNCj4gZXhpc3RpbmcgaU1YIHF1aXJrcywgc28gdGhleSB3aWxsIGJlIGJl
aGF2ZSBhcyB0aGV5IGRvIG5vdyAoKikuDQo+IA0KPiAoKikgaXQgc2VlbXMgdGhhdCBzb21lIGlN
WCBwYXJ0cyBtYXkgbm90IHN1cHBvcnQgQzQ1IHRyYW5zYWN0aW9ucyBlaXRoZXIuDQo+ICAgICBU
aGUgaU1YMjUgYW5kIGlNWDUwIFJlZmVyZW5jZSBNYW51YWxzIGNvbnRhaW4gc2ltaWxhciB3b3Jk
aW5nIHRvDQo+ICAgICB0aGUgQ29sZEZpcmUgUmVmZXJlbmNlIE1hbnVhbHMgb24gdGhpcy4NCj4g
DQo+IEZpeGVzOiA4ZDAzYWQxYWIwYjAgKCJuZXQ6IGZlYzogU2VwYXJhdGUgQzIyIGFuZCBDNDUg
dHJhbnNhY3Rpb25zIikNCj4gU2lnbmVkLW9mZi1ieTogR3JlZyBVbmdlcmVyIDxnZXJnQGxpbnV4
LW02OGsub3JnPg0KDQpJdCBsb29rcyBnb29kIHRvIG1lLg0KUmV2aWV3ZWQtYnk6IFdlaSBGYW5n
IDx3ZWkuZmFuZ0BueHAuY29tPg0K
