Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A93B52EBB4
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 14:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348990AbiETMNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 08:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiETMN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 08:13:29 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2040.outbound.protection.outlook.com [40.107.22.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E349415EA4B
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 05:13:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VW0lWWf6peN6sxiBZxKWg1ptt1fqg0V30+TrOQoiGbDUALKQxjN/SEU9g/cksuRIGAuQd/Knamc45PjaboZIZN4ns2nOZhVHj71ebAkYYUDel250BFgfc5me/kQlkTQGU6kJlUq0NnuwuErq3djkXns6msLJdnqboQ4CuCJRYpT4i6pHO9upHNbw5hnYN7oO/vv6HFeEkSYe73pbjCsY6893ELrc8QkvOl08fQy7NiKgaGmAVNdui8U19B5yiVeHasWKvSOYbcm+NDoDsMdPZQ/QCYodeWSoHwzw4SW2sTr5Metr6AAB0RprZdfhaOkec2gMiZ7xpvRqWt2DfIW6fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jgt5eX4XHHKdNmemo9W1hlO2aZyvLEb79/ApCDzMjY=;
 b=UuX8oja7w6BHiR7uzRaedOxyMyllILzVLWPDcZmQRuFjmo34Jv0QdZX+wN1NSSp6H2DAaPgp3fvbcPsLyQ/LfYDrN9cMHLym1S3R8gHVZ709EJEAuzeu3zaMlx0nRZ0ONjZBzU+SeDWGRCkvr6eGgTF9xq25bCZZhMArJUoj8DpH7oF6daBgxKW1qTmsegRJKgeyrojvj9kpH+PYIQ5cKP3vr9GyL+kXVTvuSkTDS0u9k5v5zIasADajNSUqm+timdCXZAwsGyRVWTs7XoPRDesLjPiLkMP6Q0iFJ/XkzRU9pLtmdbI3k1v01kbR9qBGODk4+gLoW3YxjroyEpoDuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jgt5eX4XHHKdNmemo9W1hlO2aZyvLEb79/ApCDzMjY=;
 b=H0cmchRQg0044Fj7lznId23NUgCtfgHreVrdQhwqx2JX5pLvGy5yH0sAe1fq38oCNcUW11R6Xpa434j+NhJ61ajXuPOwSvT0wCFlWcMUFbJdIk+8/QtqCziv9XVFvyV1TRVId1gKcKdXcOKQUokKjQJ1rZa5FmX+KDYGmdefwxA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB9305.eurprd04.prod.outlook.com (2603:10a6:10:36f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 12:13:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Fri, 20 May 2022
 12:13:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Po Liu <po.liu@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v5 11/11] igc: Add support for exposing frame
 preemption stats registers
Thread-Topic: [PATCH net-next v5 11/11] igc: Add support for exposing frame
 preemption stats registers
Thread-Index: AQHYa+cwdCpoDWGY9kWwKzxLonQ9oK0nrjMA
Date:   Fri, 20 May 2022 12:13:25 +0000
Message-ID: <20220520121324.d54p2vjypwyuqhhz@skbuf>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
 <20220520011538.1098888-12-vinicius.gomes@intel.com>
In-Reply-To: <20220520011538.1098888-12-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebb75130-dc0c-489d-94a1-08da3a5a23f0
x-ms-traffictypediagnostic: DB9PR04MB9305:EE_
x-microsoft-antispam-prvs: <DB9PR04MB9305F7472CFA8EE93696412BE0D39@DB9PR04MB9305.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hrVcfNpZrQF2dsxCTa9aDB9UJAKJk4AcS+Dng0aPmA1J4xM3q/bEeib7aOFg9ODswqUMQRaw6Et1IgBJSwKcKOiRrmS/k/3nbxLnPgi+1AR5b59hUEUWa/+I6MGAaB1IBhoGvCYTS8PPO2FR5RYn6I+TvEteFjso8E3rHcPiZWtmNYgNBUp0WfG1tSuyFL3hugRUUIC/b1JtKCHrTjvFJT2tQN0wHfq7Mci082eCfVMfxGfqdWGA2YkMMg6v7Oo3pexGW6nA92UakW/O5Y4J4y3frlXg9KMLkqbp+sVRDnlZdPnR9JVzrNboVrDWhCEHqXrDb1baHuqs+1Tt35uYZq9yO/mtKq6nj4Km45cRXBryOwJUr9O0TqlisDJZWbXIvZUcwGmS9+r+WemzWkhe3RQQZ4GTTcUiXogEpLGla5ZUkeaoDZvVCUmGlUgptRqZQoWJYXIOcWLaNm5vvrL9jWPBcUvPrGF9DjAJcKKoY+bh/CAkDST+PWwUfp0K3hHEAfgUdqg+obixeGQN8cIXSBtxKdD/qjup3a5zD2m2Gsc2b+SU82d2O/9o0VplYQfxdwGfxwaD3S0kYvDTCHjDzsnYxDvjWkUW4b+YJz4RSPvcP4h4I6bfKrUiJ5S0guRTY3OtE/f4b2GPTKOIr1bnSKMT7B63t+Z1lYrcEp92CVw2Kvw/3MvjWbWMGF1fOQS2w9YjSHf0+WAOMmfGqhI5iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66446008)(66476007)(66946007)(66556008)(6486002)(316002)(64756008)(2906002)(1076003)(44832011)(71200400001)(186003)(122000001)(54906003)(76116006)(8676002)(6916009)(4326008)(33716001)(6512007)(38100700002)(508600001)(8936002)(86362001)(26005)(5660300002)(6506007)(38070700005)(83380400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDFJR1R5cWYvUTQrUjVDUG9BMUdmTWZ3eEJ4dk5kVnVrRW9pRVpJVWZBWFFS?=
 =?utf-8?B?VDFWUTJCN2dRZFhKUE5zaFRuZlZUNjM0aUNySTBack1EYlZrTGkyckRWL1l4?=
 =?utf-8?B?a2tUT0xSSVZqMCtsNlVCcG9uL1RCSVZjMXZmMzVOdzVXcWF5eGNqTkRLVjdF?=
 =?utf-8?B?S1h3b05pNmNEeW85aTBtbURvU0g4VWJUaE5laHF2NTd3QVF0QUpZbGtoMENv?=
 =?utf-8?B?SlZ0aXpYd3l6QkZ4NTR1OVZ1aktuVFlNY3NxUzVNWXlINklaZWNOTGpLa0xH?=
 =?utf-8?B?ZU04L2tnZUJ0WTlsMEN6ZTllMFdNMFJLVlM0bGJCdG1IYjBBR01iRFhzOGtV?=
 =?utf-8?B?K3ppcDdRcE1WWEttblE3anN5QWVuTTE3UWh5TWdZZG9xMEVabGVZd1V4ZFo3?=
 =?utf-8?B?bXNxd3RQanpxdHJWUWNiKzRVc0wzNkVGUm5kbjJ1ajlKYlg0QXpTWXpnS0h4?=
 =?utf-8?B?UWVsVTBSMXBFdDBJNVB6VmR6ek15WHo3bVkyU1IrWnF3L09aZ1dFWmVoa2JW?=
 =?utf-8?B?bDdOZ3R2Uy8yUUZhRVJSckVaY2x0WkRJZmlBNE1GL0J2RHFhNXJpMGNiQWFI?=
 =?utf-8?B?YzhqRzl3L2twajR0RnF1NHdRbllwRDY0cGNkL25yT3k4VnRmQnBLV2dTeVZa?=
 =?utf-8?B?amZydUdNdDdHL1ZkY2J0UHArMUg4TUxIWE5XNC9ia29hRitFMnZCTlNNUUJr?=
 =?utf-8?B?V3NMQVhJZVBiYTkrRVlPalJJYWVML0hwM3BpTXJ2Z0dnbzJLQVdMN2VONklP?=
 =?utf-8?B?dG1YZ0VyZ0x3Qm1QRjNpMEhMUHovRDJHUHprLytuN3JjSjluS3hVZFU0akxi?=
 =?utf-8?B?QUg5cGJwaUlBbnRGUDJvbEViT3VjNUhiMnc5Z0RHM2JLeDZvaEIxeDFUTDlD?=
 =?utf-8?B?cGJGb0EraHN2Q085VUVLcHFtQVQvVktHQzczYUgvcjhnNE9ZajF3RjlmY2xF?=
 =?utf-8?B?dlA5MWt4UUlRUDNleTZDY3NEZ3VMeGhTQ0hHaEdtcndKTG93dVppaUdiR2Jy?=
 =?utf-8?B?bXM1dnlvVFoyMk9ZdW55QkZXbTBpdDlKejh1YVVOUXUycTArUTF3RHhodFV6?=
 =?utf-8?B?YS9jbHhTdTM5ek1ucVRVM1N1bEhZTlZiRE5pSnYrUFZwQlI0SzEvalNWSDdq?=
 =?utf-8?B?ejhDWTdNU25QYjU0bkp1NkxTQm9YbWg2SVRPeGd5cDFZbks2QUpiMGFVZkhC?=
 =?utf-8?B?QXVESHVkTzNHNXg5MTZleERDU0pWZWRVQXI0UzB0RlhSbGtuNHhSUUVLeEpy?=
 =?utf-8?B?bkRKWmNMdjUvOTl3ZDFpWUNtZjcxTmZqQ2Jua2IzSWxUdkJ0K3R6MGpZTE1L?=
 =?utf-8?B?TlJrZXBqczlFTnE0YU1mdlMwcDhkT3llN05jNXRPZVloMU5Rc1hTQ1VYTk9m?=
 =?utf-8?B?anZBQWVOb3NqTDNrRzNwMVBSK05FdTU3bURxNUdiMEFteWQ5bngvbHc4NXNi?=
 =?utf-8?B?cldtM2I1bFdzVGZaRmJPdEg1SUV3b2M4Y1FIS0JLdFo5SlRZZ0s3S2NhVktV?=
 =?utf-8?B?QXo3Yk1oejYvcmpXMC9Pdll3ZDVMRFl3bU9rMURkOW8razczRFF2anJ5WVgy?=
 =?utf-8?B?em8xaVp4UU9TR3kxTzRXQXp4WTdQZjFLU08wVHZIbkRZancwOW5JeFN4VlIz?=
 =?utf-8?B?U2o3TCtxOEU2bDNkNk9oSXVPOW51YjU3Qk1jTTZqNURXOXdrdll3bjJ4TjNP?=
 =?utf-8?B?VU8zWVBBeTVNaERlckQyVFVMNU9GZUZydW9FUUdpZDM4dHduYWxkbkxlMGtq?=
 =?utf-8?B?NXNBeDJ5UzVuRVZqUEFUOHMwd1hGbExrQ3AxMmlUNDFKQm9YUHdpOWkvK0E4?=
 =?utf-8?B?T0Z5d3M2dVo1ZkhVMW1GTHpua1FWTnEzc3hkbVZsejlOOTgxeGpNaWJUV1A2?=
 =?utf-8?B?MU1LTEx0c0xHR2hab3NNcDM4aEs4RDVlL0N4N3ljaHI2MVVnT2Y1MEhLOTJq?=
 =?utf-8?B?MWR2LzhTeWp0RzA4czdrR3AxSTJrajBCQ2srSWN6L3lGZCtCdnh5WXMveWFh?=
 =?utf-8?B?YUJMOHBWaEgydEpPdlBvdEw5MTZEb3h5d0ZHUnd6RXFJSnM1dEJBQUpnQjNr?=
 =?utf-8?B?UnpsbVBmVHhRdk1aNnpDcEdKbitTdTNJTTQvTm1kQU55eVNPRnZvVWhKbFla?=
 =?utf-8?B?c3VoYjVLbzUxb0E4NlZqRDRlZWpWc0JCUWR0VC9ob0djRnIvQXJqOE9MVGpm?=
 =?utf-8?B?Vy9WbDVTVGt0L29ZWUZCdzl6MDAxcEhsOFpXZFlBV1dROEcrblNydUZPNENC?=
 =?utf-8?B?MHJtWXk1MlkycDQzZXZvY0FEZy9GS1NNd0FyNlcvNWttQnhZQjIwL0xYa3dz?=
 =?utf-8?B?Skc3b0g4QnVEaEx1aERvellwc0pFTUxwQkdsRG5lc0xhMllMMGt2OGFqeDJx?=
 =?utf-8?Q?jS+FNDJyJlVvZAUw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A55A5E6CDE3C1042B3FE64E5FA131B49@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb75130-dc0c-489d-94a1-08da3a5a23f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 12:13:25.0314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x6/x1m4oqrdVUHCaWZhMrIbhZLWNrZ9XWPwcneWGJIQJTat5hNZEweCqKBUmdMKdcCqIFDEUhJiB6oRxyBx6RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9305
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBNYXkgMTksIDIwMjIgYXQgMDY6MTU6MzhQTSAtMDcwMCwgVmluaWNpdXMgQ29zdGEg
R29tZXMgd3JvdGU6DQo+IEV4cG9zZSB0aGUgRnJhbWUgUHJlZW1wdGlvbiBjb3VudGVycywgc28g
dGhlIG51bWJlciBvZg0KPiBleHByZXNzL3ByZWVtcHRpYmxlIHBhY2tldHMgY2FuIGJlIG1vbml0
b3JlZCBieSB1c2Vyc3BhY2UuDQo+IA0KPiBUaGVzZSByZWdpc3RlcnMgYXJlIGNsZWFyZWQgd2hl
biByZWFkLCBzbyB0aGUgdmFsdWUgc2hvd24gaXMgdGhlDQo+IG51bWJlciBvZiBldmVudHMgdGhh
dCBoYXBwZW5lZCBzaW5jZSB0aGUgbGFzdCByZWFkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVmlu
aWNpdXMgQ29zdGEgR29tZXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT4NCj4gLS0tDQo+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX2V0aHRvb2wuYyB8ICA4ICsrKysrKysr
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX3JlZ3MuaCAgICB8IDEwICsr
KysrKysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfZXRodG9vbC5jIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19ldGh0b29sLmMNCj4gaW5kZXggOWE4
MGUyNTY5ZGMzLi4wYTg0ZmJkZDQ5NGIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2lnYy9pZ2NfZXRodG9vbC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2lnYy9pZ2NfZXRodG9vbC5jDQo+IEBAIC0zNDQsNiArMzQ0LDE0IEBAIHN0YXRpYyB2
b2lkIGlnY19ldGh0b29sX2dldF9yZWdzKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsDQo+ICAN
Cj4gIAlyZWdzX2J1ZmZbMjEzXSA9IGFkYXB0ZXItPnN0YXRzLnRscGljOw0KPiAgCXJlZ3NfYnVm
ZlsyMTRdID0gYWRhcHRlci0+c3RhdHMucmxwaWM7DQo+ICsJcmVnc19idWZmWzIxNV0gPSByZDMy
KElHQ19QUk1QVERUQ05UKTsNCj4gKwlyZWdzX2J1ZmZbMjE2XSA9IHJkMzIoSUdDX1BSTUVWTlRU
Q05UKTsNCj4gKwlyZWdzX2J1ZmZbMjE3XSA9IHJkMzIoSUdDX1BSTVBURFJDTlQpOw0KPiArCXJl
Z3NfYnVmZlsyMThdID0gcmQzMihJR0NfUFJNRVZOVFJDTlQpOw0KPiArCXJlZ3NfYnVmZlsyMTld
ID0gcmQzMihJR0NfUFJNUEJMVENOVCk7DQo+ICsJcmVnc19idWZmWzIyMF0gPSByZDMyKElHQ19Q
Uk1QQkxSQ05UKTsNCj4gKwlyZWdzX2J1ZmZbMjIxXSA9IHJkMzIoSUdDX1BSTUVYUFRDTlQpOw0K
PiArCXJlZ3NfYnVmZlsyMjJdID0gcmQzMihJR0NfUFJNRVhQUkNOVCk7DQo+ICB9DQo+ICANCj4g
IHN0YXRpYyB2b2lkIGlnY19ldGh0b29sX2dldF93b2woc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRl
diwNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfcmVn
cy5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19yZWdzLmgNCj4gaW5kZXgg
ZTE5N2EzM2Q5M2EwLi4yYjVlZjFlODBmNWYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ludGVsL2lnYy9pZ2NfcmVncy5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2lnYy9pZ2NfcmVncy5oDQo+IEBAIC0yMjQsNiArMjI0LDE2IEBADQo+ICANCj4gICNk
ZWZpbmUgSUdDX0ZUUUYoX24pCSgweDA1OUUwICsgKDQgKiAoX24pKSkgIC8qIDUtdHVwbGUgUXVl
dWUgRmx0ciAqLw0KPiAgDQo+ICsvKiBUaW1lIHN5bmMgcmVnaXN0ZXJzIC0gcHJlZW1wdGlvbiBz
dGF0aXN0aWNzICovDQo+ICsjZGVmaW5lIElHQ19QUk1QVERUQ05UCTB4MDQyODAgIC8qIEdvb2Qg
VFggUHJlZW1wdGVkIFBhY2tldHMgKi8NCj4gKyNkZWZpbmUgSUdDX1BSTUVWTlRUQ05UCTB4MDQy
OTggIC8qIFRYIFByZWVtcHRpb24gZXZlbnQgY291bnRlciAqLw0KPiArI2RlZmluZSBJR0NfUFJN
UFREUkNOVAkweDA0Mjg0ICAvKiBHb29kIFJYIFByZWVtcHRlZCBQYWNrZXRzICovDQo+ICsjZGVm
aW5lIElHQ19QUk1FVk5UUkNOVAkweDA0MjlDICAvKiBSWCBQcmVlbXB0aW9uIGV2ZW50IGNvdW50
ZXIgKi8NCj4gKyNkZWZpbmUgSUdDX1BSTVBCTFRDTlQJMHgwNDI4OCAgLyogR29vZCBUWCBQcmVl
bXB0YWJsZSBQYWNrZXRzICovDQo+ICsjZGVmaW5lIElHQ19QUk1QQkxSQ05UCTB4MDQyOEMgIC8q
IEdvb2QgUlggUHJlZW1wdGFibGUgUGFja2V0cyAqLw0KPiArI2RlZmluZSBJR0NfUFJNRVhQVENO
VAkweDA0MjkwICAvKiBHb29kIFRYIEV4cHJlc3MgUGFja2V0cyAqLw0KPiArI2RlZmluZSBJR0Nf
UFJNRVhQUkNOVAkweDA0MkEwICAvKiBQcmVlbXB0aW9uIEV4Y2VwdGlvbiBDb3VudGVyICovDQo+
ICsNCg0KQWgsIEkgZGlkbid0IG5vdGljZSB0aGlzLiBGV0lXLCB0aGUgc3RhbmRhcmQgdGFsa3Mg
YWJvdXQgdGhlIGZvbGxvd2luZywNCmF0IHRoZSBNQUMgbWVyZ2UgbGF5ZXI6DQoNCmFNQUNNZXJn
ZUZyYW1lQXNzRXJyb3JDb3VudA0KICBBIGNvdW50IG9mIE1BQyBmcmFtZXMgd2l0aCByZWFzc2Vt
Ymx5IGVycm9ycy4gVGhlIGNvdW50ZXIgaXMNCiAgaW5jcmVtZW50ZWQgYnkgb25lIGV2ZXJ5IHRp
bWUgdGhlIEFTU0VNQkxZX0VSUk9SIHN0YXRlIGluIHRoZSBSZWNlaXZlDQogIFByb2Nlc3Npbmcg
U3RhdGUgRGlhZ3JhbSBpcyBlbnRlcmVkIChzZWUgRmlndXJlIDk54oCTNikNCg0KYU1BQ01lcmdl
RnJhbWVTbWRFcnJvckNvdW50DQogIEEgY291bnQgb2YgcmVjZWl2ZWQgTUFDIGZyYW1lcyAvIE1B
QyBmcmFtZSBmcmFnbWVudHMgcmVqZWN0ZWQgZHVlIHRvDQogIHVua25vd24gU01EIHZhbHVlIG9y
IGFycml2aW5nIHdpdGggYW4gU01ELUMgd2hlbiBubyBmcmFtZSBpcyBpbg0KICBwcm9ncmVzcy4g
VGhlIGNvdW50ZXIgaXMgaW5jcmVtZW50ZWQgYnkgb25lIGV2ZXJ5IHRpbWUgdGhlIEJBRF9GUkFH
DQogIHN0YXRlIGluIHRoZSBSZWNlaXZlIFByb2Nlc3NpbmcgU3RhdGUgRGlhZ3JhbSBpcyBlbnRl
cmVkIGFuZCBldmVyeQ0KICB0aW1lIHRoZSBXQUlUX0ZPUl9EVl9GQUxTRSBzdGF0ZSBpcyBlbnRl
cmVkIGR1ZSB0byB0aGUgaW52b2NhdGlvbiBvZg0KICB0aGUgU01EX0RFQ09ERSBmdW5jdGlvbiBy
ZXR1cm5pbmcgdGhlIHZhbHVlIOKAnEVSUuKAnSAoc2VlIEZpZ3VyZSA5OeKAkzYpDQoNCmFNQUNN
ZXJnZUZyYW1lQXNzT2tDb3VudA0KICBBIGNvdW50IG9mIE1BQyBmcmFtZXMgdGhhdCB3ZXJlIHN1
Y2Nlc3NmdWxseSByZWFzc2VtYmxlZCBhbmQgZGVsaXZlcmVkDQogIHRvIE1BQy4gVGhlIGNvdW50
ZXIgaXMgaW5jcmVtZW50ZWQgYnkgb25lIGV2ZXJ5IHRpbWUgdGhlDQogIEZSQU1FX0NPTVBMRVRF
IHN0YXRlIGluIHRoZSBSZWNlaXZlIFByb2Nlc3Npbmcgc3RhdGUgZGlhZ3JhbSAoc2VlDQogIEZp
Z3VyZSA5OeKAkzYpIGlzIGVudGVyZWQgaWYgdGhlIHN0YXRlIENIRUNLX0ZPUl9SRVNVTUUgd2Fz
IHByZXZpb3VzbHkNCiAgZW50ZXJlZCB3aGlsZSBwcm9jZXNzaW5nIHRoZSBwYWNrZXQuDQoNCmFN
QUNNZXJnZUZyYWdDb3VudFJ4DQogIEEgY291bnQgb2YgdGhlIG51bWJlciBvZiBhZGRpdGlvbmFs
IG1QYWNrZXRzIHJlY2VpdmVkIGR1ZSB0byBwcmVlbXB0aW9uLg0KICBUaGUgY291bnRlciBpcyBp
bmNyZW1lbnRlZCBieSBvbmUgZXZlcnkgdGltZSB0aGUgc3RhdGUgQ0hFQ0tfRlJBR19DTlQNCiAg
aW4gdGhlIFJlY2VpdmUgUHJvY2Vzc2luZyBTdGF0ZSBEaWFncmFtIChzZWUgRmlndXJlIDk54oCT
NikgaXMgZW50ZXJlZC4NCg0KYU1BQ01lcmdlRnJhZ0NvdW50VHgNCiAgQSBjb3VudCBvZiB0aGUg
bnVtYmVyIG9mIGFkZGl0aW9uYWwgbVBhY2tldHMgdHJhbnNtaXR0ZWQgZHVlIHRvIHByZWVtcHRp
b24uDQogIFRoaXMgY291bnRlciBpcyBpbmNyZW1lbnRlZCBieSBvbmUgZXZlcnkgdGltZSB0aGUg
U0VORF9TTURfQyBzdGF0ZSBpbg0KICB0aGUgVHJhbnNtaXQgUHJvY2Vzc2luZyBTdGF0ZSBEaWFn
cmFtIChzZWUgRmlndXJlIDk54oCTNSkgaXMgZW50ZXJlZC4NCg0KYU1BQ01lcmdlSG9sZENvdW50
DQogIEEgY291bnQgb2YgdGhlIG51bWJlciBvZiB0aW1lcyB0aGUgdmFyaWFibGUgaG9sZCAoc2Vl
IDk5LjQuNy4zKQ0KICB0cmFuc2l0aW9ucyBmcm9tIEZBTFNFIHRvIFRSVUUuDQoNCkkgdGhpbmsg
d2UgaGF2ZSB0aGUgZm9sbG93aW5nIGNvcnJlc3BvbmRlbmNlOg0KIlRYIFByZWVtcHRpb24gZXZl
bnQgY291bnRlciIgLT4gYU1BQ01lcmdlRnJhZ0NvdW50VHgNCiJSWCBQcmVlbXB0aW9uIGV2ZW50
IGNvdW50ZXIiIC0+IGFNQUNNZXJnZUZyYWdDb3VudFJ4DQoiUHJlZW1wdGlvbiBFeGNlcHRpb24g
Q291bnRlciIgLT4gYU1BQ01lcmdlRnJhbWVBc3NFcnJvckNvdW50ICsgYU1BQ01lcmdlRnJhbWVT
bWRFcnJvckNvdW50Pw0KDQpUaGVuIHdlIGhhdmUgdGhlIGZvbGxvd2luZyB1bmNvdmVyZWQgY291
bnRlcnM6DQoNCkdvb2QgVFggUHJlZW1wdGVkIFBhY2tldHMNCkdvb2QgUlggUHJlZW1wdGVkIFBh
Y2tldHMNCkdvb2QgVFggUHJlZW1wdGFibGUgUGFja2V0cw0KR29vZCBSWCBQcmVlbXB0YWJsZSBQ
YWNrZXRzDQpHb29kIFRYIEV4cHJlc3MgUGFja2V0cw0KDQpUaGVzZSBhcmUgYXQgdGhlIGxldmVs
IG9mIGluZGl2aWR1YWwgTUFDcyAocE1BQywgZU1BQykgcmF0aGVyIHRoYW4gdGhlIE1BQyBtZXJn
ZSBsYXllci4NCg0KDQpGV0lXLCBFTkVUQyBoYXMgdGhlIGZvbGxvd2luZyBjb3VudGVycyBmb3Ig
RlA6DQoNClBvcnQgTUFDIE1lcmdlIEZyYW1lIEFzc2VtYmx5IEVycm9yIENvdW50DQpQb3J0IE1B
QyBNZXJnZSBGcmFtZSBTTUQgRXJyb3IgQ291bnQNClBvcnQgTUFDIE1lcmdlIEZyYW1lIEFzc2Vt
Ymx5IE9LDQpQb3J0IE1BQyBNZXJnZSBGcmFnbWVudCBDb3VudCBSWA0KUG9ydCBNQUMgTWVyZ2Ug
RnJhZ21lbnQgQ291bnQgVFgNClBvcnQgTUFDIE1lcmdlIEhvbGQgQ291bnQNCg0KVGhlbiBpdCBo
YXMgYSBzZXJpZXMgb2YgUk1PTiBjb3VudGVycyByZXBsaWNhdGVkIHR3aWNlLCBvbmNlIGZvciB0
aGUNClBvcnQgTUFDIDAgKGVNQUMpIGFuZCBvbmNlIGZvciBQb3J0IE1BQyAxIChwTUFDKS4NCg0K
U2ltaWxhcmx5LCB0aGUgRmVsaXggc3dpdGNoIGhhczoNCg0KY19yeF9hc3NlbWJseV9lcnINCmNf
cnhfc21kX2Vycg0KY19yeF9hc3NlbWJseV9vaw0KY19yeF9tZXJnZV9mcmFnDQoNCnBsdXMgUk1P
TiBjb3VudGVycyByZXBsaWNhdGVkIGZvciB0aGUgcmVndWxhciBNQUMgYW5kIGZvciB0aGUgcE1B
Qw0KKGNfcnhfcG1hY19vY3QgdnMgY19yeF9vY3QsIGNfcnhfcG1hY191YyB2cyBjX3J4X3VjLCBj
X3J4X3BtYWNfc3pfNjVfMTI3DQp2cyBjX3J4X3N6XzY1XzEyNywgZXRjIGV0YykuDQoNCkkgdGhp
bmsgdGhlcmUncyBhIHRlbmRlbmN5IGhlcmUuIE1heWJlIHdlIGNvdW50IGhhdmUgc3RydWN0dXJl
ZCBkYXRhIGZvcg0KTUFDIG1lcmdlIGxheWVyIGNvdW50ZXJzLCBwTUFDIGNvdW50ZXJzIGFuZCBl
TUFDIGNvdW50ZXJzPyBXZSBhbHJlYWR5DQpoYXZlIGVNQUMgY291bnRlcnMgaW4gdGhlIGZvcm0g
b2YgZXRodG9vbF9ldGhfbWFjX3N0YXRzLCBldGh0b29sX2V0aF9jdHJsX3N0YXRzLA0KZXRodG9v
bF9wYXVzZV9zdGF0cywgZXRjIGV0Yy4gV2UganVzdCBuZWVkIHRvIGZpZ3VyZSBvdXQgYSB3YXkg
b2YNCnJldHJpZXZpbmcgdGhlIHNhbWUgdGhpbmcgZm9yIHRoZSBwcmVlbXB0YWJsZSBNQUMuDQoN
Ckpha3ViLCBhbnkgaWRlYXM/DQoNCj4gIC8qIFRyYW5zbWl0IFNjaGVkdWxpbmcgUmVnaXN0ZXJz
ICovDQo+ICAjZGVmaW5lIElHQ19UUUFWQ1RSTAkJMHgzNTcwDQo+ICAjZGVmaW5lIElHQ19UWFFD
VEwoX24pCQkoMHgzMzQ0ICsgMHg0ICogKF9uKSkNCj4gLS0gDQo+IDIuMzUuMw0KPg==
