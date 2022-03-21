Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895554E220C
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 09:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345181AbiCUIVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 04:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239039AbiCUIVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 04:21:37 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2097.outbound.protection.outlook.com [40.107.215.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1832F55494;
        Mon, 21 Mar 2022 01:20:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hk4Nq0tNs1mi+ui1JDqNFF09+FWBXMKY6eFnSwA5NYzlkGY+DNK6YsokHYcoS7Peg21tXvdB2dtlA3a/llpUgGidpIOrqSpbgiTsilA5nlJzZol5SGNIiewyxNKkBQGzpgW78IpMw2/eJtwPFF1JPHXhDBKWYFqnADRXaQHkVdLDqvyzj3Y0UMXH1eUQ7Llgq9ILhY9cL2VWsHhpCHD9WzpKeUdR5ADyyKYX056H0sMaDCuxWYxR1Zf6sUNZSkHliKdMGvg1Bk/dMkJstlqpKWZijmb2/lI3lI+p6WpOSr2SPdhROdMxFE7w3sTqMZ/wJpvYowZZNlEfvuxAI4c5WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlTYLVM/xXJQuPAGZpF1VzEdPgxYKFV1B8WYulnf114=;
 b=J8viF+XYhN+DwNUhjmEbOKDFmEjf09PBMxXIxZttMA2tF0kH2Nu5c4QBQZgMgLFSMowX9JodQL+dtXM6+LgshPVtHDqlaOImap0A91bXMHwpZr3xV97fmSXScT9aZWUwIX0iVu8AnupZSBqV28u0vrxye2gT5HYwcTCh3RbrhrOLY49FsVjMQceVwraOEV+GWg8+O8Iq5S077O8bi71wYfAc12XRq0ydxffSqC+fx0sy0i+Yfxz8SNeAYRlfodPlbHBM+VflZKlFfYx+PxFPLxEKMy9yAyDZ8FKlugwnrN0RlAdKo3FafFzxuGxVEnOUROo5Qjke8Dt1xsNZkMEpzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlTYLVM/xXJQuPAGZpF1VzEdPgxYKFV1B8WYulnf114=;
 b=fOeRabW0eQ+AtSDFxEqiJGn/+6836ybkXOZjoeWcY8SgpejlaTJOXurJpsj2E/Uimy3uzpxJO6KkSZZJHnVVkVntPvPW6m3vgRRLGzGKIonyMERuGe0/XVjl5vFFXi9vSZdj0v5Sb3pU3judrRub/0MDe6etHMIGxtlijKw3Dn3uTb2rHWFWIw9y+5MgUdeq+c/xWMHbG5rdhqlVxPopl3y185/+eMeL1tVNMn7n/aY44yw4P5oskRRe97QZXw4SiTsTq1+Hi2SvRHMDay0XxLv0NXyFWwRNbONcx9YaXB2V3yCfB+pAFFEBx3AwIzo2AhMi+rESJjs1wpP8M+C/aQ==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by TY0PR06MB5378.apcprd06.prod.outlook.com (2603:1096:400:215::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Mon, 21 Mar
 2022 08:20:01 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::e175:c8be:f868:447]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::e175:c8be:f868:447%5]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 08:20:01 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     BMC-SW <BMC-SW@aspeedtech.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] net: mdio: add reset deassertion for Aspeed MDIO
Thread-Topic: [PATCH 1/2] net: mdio: add reset deassertion for Aspeed MDIO
Thread-Index: AQHYPPFx/umctORn0UKGhI6VxBXKAKzJfYcAgAAAu/A=
Date:   Mon, 21 Mar 2022 08:20:01 +0000
Message-ID: <HK0PR06MB28349EC113B35E5C2741BC3A9C169@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20220321070131.23363-1-dylan_hung@aspeedtech.com>
         <20220321070131.23363-2-dylan_hung@aspeedtech.com>
 <84f2c72ced35506522ea3a6be72879d1699f885b.camel@pengutronix.de>
In-Reply-To: <84f2c72ced35506522ea3a6be72879d1699f885b.camel@pengutronix.de>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1eda4615-c72b-4c2a-e026-08da0b13984d
x-ms-traffictypediagnostic: TY0PR06MB5378:EE_
x-microsoft-antispam-prvs: <TY0PR06MB537876CD7034220D6058DE769C169@TY0PR06MB5378.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D78ObKmrUX6F3IjfT+LXdtoYAFJeTsuE7cMeBUQKuUte5OZcf60JZVgy69YmQv+ojztk35rKDbCaKFoWQfMwezx7R1hTFqu3TM2B1MNgZBOWjDrh6CyZed3CDjIf2NPpxog8FQviylixpGt1gr2TBplnLYomdq0XaMh5qZVbCwYmbC6qZVSBUpxseG08PAPMATqLyxrIgK7fYef5+38oqTVlcZg5chmitQ1wmzIpMCzIRiyDKzaG3QBiZTuYjhcMzWXsNB3w0ft+2G1tOpdHgz/xR30FoOr3i7V/yuCf5WteTQFcSfHDXinmQ0idSjN3lNbQRQU2Kc9Z2Hqm/PHMR41hSTEcCRdFHnlfSyNiia0viXX0pQPIND2KsPvVN3QMslZHVGTn/qOGmPXTQXVe+GEEn3VDPEjBdl5kzvvDG0hrQt64DCwV0Ib/NdD0CHwl8mR6mvATesycalgdwh5zraj1uibpdScteg67uoArwNFyGCRF/JWBCv4L2IKvstgzL91fQNTZPNwOBDaD8TnLPZNsCqXhkLJGfOAS7uRTHLLVSg5fqJyaiY6ZDhatW+NQyxyeSidyl5CWBKnX2IRqKML9p0cyGRoAY02T/yT3LSJHytc7i9nZ1Efotq7/CnvaAd4ikWS780opRZcN1X64ZmRILC8O/ejgXKJjx95bw5QTSUwfylnybookN2TlooGIc2cKuwenMdhaDCh0GLZKeYD7XuTWmnhTczu1ufDJGkM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(396003)(366004)(136003)(39850400004)(376002)(66476007)(64756008)(66556008)(66446008)(66946007)(5660300002)(33656002)(4326008)(86362001)(6506007)(52536014)(38070700005)(55016003)(76116006)(71200400001)(7696005)(9686003)(53546011)(7416002)(26005)(921005)(186003)(8936002)(8676002)(83380400001)(2906002)(316002)(38100700002)(54906003)(122000001)(508600001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dytlMmxjWlRyOC9xTEZ3L0NUT3ZUR0NBeG9mM3M2SkxDRzZweVNKVUkzTDQw?=
 =?utf-8?B?ajFwSS9wK0NpbHVvZEhsaUN1cVpYaG5kbnBTUVRURC9veWRuOG9ZTW0zcUNm?=
 =?utf-8?B?TGFuUmN3YzgyZGVFamgvL0dVWmRyQ3BMa1RaY29PUWVzaXBsM3VFK2hBc3ZU?=
 =?utf-8?B?T21WZFRUdFpzcUFJRnJhdktRUUpJZDJpRHpjMzdTYkczRWo5eW1WZmxTWHJV?=
 =?utf-8?B?cGRoUWxWQjVBd3g0a0hKVFQxbmZyTmhQMGlrR05qZzVrbDlJcE0vY0pHRWxF?=
 =?utf-8?B?ZVV5c3U5T1lpWFNBTUR5cmxxdnliUU9LaHdVcDY5U2tCSVZVdkxVSUlURFAw?=
 =?utf-8?B?cUl4S2FjSEE5dkhxY0JsQlVoKzlrU1JCRWN0bXBZRUdUMWU5RnZKdjlUbms0?=
 =?utf-8?B?Z1V5R0d1Q25MTWJMYXo4dkRFT2VZTGl5MGRzc2tqOUl0UHhLTmpJT2xsYUZw?=
 =?utf-8?B?MHU0WWtkaFZpbGJNSE9jUmpLTU9jS0t1c3hhUnE4azZXZThDZEFtYTcxNFd5?=
 =?utf-8?B?T0dCZElaWjBzcGc0UmMyUTNwaS8yZWdSY2tsUGtGalUxME9TSjJ4K0JHTGw1?=
 =?utf-8?B?RG1MeFBiTmtCVVlORnl1cmN3UVZ3TVdxNXplb28zVS9jNDloa3FBSnlwNHYv?=
 =?utf-8?B?UFZjUUdpa2QvWmJSWkdLaW02WWdKNmVCcldpNUdNcU1hZzlicFlHd0VUd2dz?=
 =?utf-8?B?a0FhVHdrT1ljNnFGcDRtODdYVVR4UHcrcjJwRHdnWnhuTmFQOEhLb2YvS3Vx?=
 =?utf-8?B?SUZJREUzSEhEM0ZxT3dyQWpqdGpWdDE0RTY1V0pGSDN1akY4bTk5aDhnUTYy?=
 =?utf-8?B?bzNtbG9LcGJoREQ1a21za1h3WjFweXZPQmlFdTJMeDYrSXVxRTBTOTllcGlk?=
 =?utf-8?B?NEJ3Z05idURsL2ZvaFRpcUJBUWFqS01zOHF1dXNJZEU1alFqM0huYUE5N0pP?=
 =?utf-8?B?UlcvWmVXa2hhR1pkRkZqekgvMllmaDJaTzU4NWx5RWhERFkxb05NcEgrVnIr?=
 =?utf-8?B?c0ZCaFYraTUydTlrYWsvTkhOV1FWSXlpWVczN1BKdlhLZEsxSHJoNHQrQTU1?=
 =?utf-8?B?S21jdFhTcmFaZThsb2dCaDFjK2xtVHNLaHRZSFJEaitTSi82VjNVRjNqUzRR?=
 =?utf-8?B?T1ZJdFNPTUtWTGVOakxMdHRFSGRNUWJwNGdmWGMrTG1sZlZuMkQ1ajhaVzYv?=
 =?utf-8?B?ekQ5aTMvbWpZSUNzb0FMbGJoZXRJejNuSkRXTHlJWDBoZjhkTlViTzZEdnYy?=
 =?utf-8?B?WXhIL2lUTTNXcjZJaXhDVGZjTXgvUEw3ZzNEWjFsZmQrTUJkWmJjWm5XWVZP?=
 =?utf-8?B?OHVRc2ZhMEZKdGZOUVVVaGJ4N1liQXdtZm1DcDJYN3hFbVBXUkZ6VFNkMkZu?=
 =?utf-8?B?Z3VjWTI3VmtxU3ZrdzlRc0k3clI3dkhrR0FXUE1RMSttOGpkNDJGajk3Tzg0?=
 =?utf-8?B?a1o0OXJwa3ZDMTFnejBlakVqZUN5akE3QUhFZ2VITm1wUUpvNHNyT0xkSXBP?=
 =?utf-8?B?djc4eDYyc0p3ZEpqelA2b01yQzUybEcyaXRPRmRUNE1mVTgvVlJ1dVB2L2JM?=
 =?utf-8?B?dHg1TENRUnNza0RaM1lEeGxVN3krNisvalVvZE4rZWRpRGNCdnp0dmZzN2VF?=
 =?utf-8?B?d0lYUzhmeXBkTXdlTW1CZC82K1U2RHBQZEFCQVhmeHNmNXd5NlRtSTdCUTJT?=
 =?utf-8?B?QWJUUlZEUVpHK3BwOWx4QStGLzhCb0NMbjcrbjRzcmxMdEljWVkxaWtsanUx?=
 =?utf-8?B?Ni9RaU5zb0djalpvbnNrSkQ0OUpvVWZVRlRkTFZJQWRFdmFVUjVpZWtjbUdB?=
 =?utf-8?B?K3RuR2tja2NyVkxJU1NCeitvMnJ6MW0xSkFwQm5obmJ5TWRUZmRadnMwOVBj?=
 =?utf-8?B?TUNyMVhseVdrN2h5Mi8wcE52VHZsaWZCdTJaS1JBRlRIaC8zbUZOaFFjbW5C?=
 =?utf-8?B?WkI5TVBKa0Z0UlEvWXMrdHE2LzFOOHJORnE4MWdaNnpsZ0FMVHZDbTUwMzha?=
 =?utf-8?B?YytzZG9Ba2dnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eda4615-c72b-4c2a-e026-08da0b13984d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2022 08:20:01.2465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7w4uNKisZS1G+W1FLNYz3wm+LLR2a6BWOPWgfdhNtCXTY206mne+qmXPBcQLGi69ys9YLwMSdObOKYdq2mtve5FO/SD/bWYzOwduwJAfA/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5378
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQaGlsaXBwIFphYmVsIFttYWls
dG86cC56YWJlbEBwZW5ndXRyb25peC5kZV0NCj4gU2VudDogMjAyMuW5tDPmnIgyMeaXpSA0OjE1
IFBNDQo+IFRvOiBEeWxhbiBIdW5nIDxkeWxhbl9odW5nQGFzcGVlZHRlY2guY29tPjsgcm9iaCtk
dEBrZXJuZWwub3JnOw0KPiBqb2VsQGptcy5pZC5hdTsgYW5kcmV3QGFqLmlkLmF1OyBhbmRyZXdA
bHVubi5jaDsgaGthbGx3ZWl0MUBnbWFpbC5jb207DQo+IGxpbnV4QGFybWxpbnV4Lm9yZy51azsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNv
bTsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMu
aW5mcmFkZWFkLm9yZzsgbGludXgtYXNwZWVkQGxpc3RzLm96bGFicy5vcmc7DQo+IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IEJNQy1T
VyA8Qk1DLVNXQGFzcGVlZHRlY2guY29tPjsgc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIDEvMl0gbmV0OiBtZGlvOiBhZGQgcmVzZXQgZGVhc3NlcnRpb24gZm9y
IEFzcGVlZCBNRElPDQo+IA0KPiBIaSBEeWxhbiwNCj4gDQo+IE9uIE1vLCAyMDIyLTAzLTIxIGF0
IDE1OjAxICswODAwLCBEeWxhbiBIdW5nIHdyb3RlOg0KPiA+IEFkZCByZXNldCBkZWFzc2VydGlv
biBmb3IgQXNwZWVkIE1ESU8uwqAgVGhlcmUgYXJlIDQgTURJTyBjb250cm9sbGVycw0KPiA+IGVt
YmVkZGVkIGluIEFzcGVlZCBBU1QyNjAwIFNPQyBhbmQgc2hhcmUgb25lIHJlc2V0IGNvbnRyb2wg
cmVnaXN0ZXINCj4gPiBTQ1U1MFszXS4gU28gZGV2bV9yZXNldF9jb250cm9sX2dldF9zaGFyZWQg
aXMgdXNlZCBpbiB0aGlzIGNoYW5nZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IER5bGFuIEh1
bmcgPGR5bGFuX2h1bmdAYXNwZWVkdGVjaC5jb20+DQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCj4gPiAtLS0NCj4gPiDCoGRyaXZlcnMvbmV0L21kaW8vbWRpby1hc3BlZWQuYyB8IDgg
KysrKysrKysNCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9tZGlvL21kaW8tYXNwZWVkLmMgYi9kcml2ZXJzL25l
dC9tZGlvL21kaW8tDQo+ID4gYXNwZWVkLmMgaW5kZXggZTIyNzM1ODhjNzViLi44YWMyNjJhMTJk
MTMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvbWRpby9tZGlvLWFzcGVlZC5jDQo+ID4g
KysrIGIvZHJpdmVycy9uZXQvbWRpby9tZGlvLWFzcGVlZC5jDQo+ID4gQEAgLTMsNiArMyw3IEBA
DQo+ID4NCj4gPiDCoCNpbmNsdWRlIDxsaW51eC9iaXRmaWVsZC5oPg0KPiA+IMKgI2luY2x1ZGUg
PGxpbnV4L2RlbGF5Lmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9yZXNldC5oPg0KPiA+IMKgI2lu
Y2x1ZGUgPGxpbnV4L2lvcG9sbC5oPg0KPiA+IMKgI2luY2x1ZGUgPGxpbnV4L21kaW8uaD4NCj4g
PiDCoCNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gPiBAQCAtMzcsNiArMzgsNyBAQA0KPiA+
DQo+ID4gwqBzdHJ1Y3QgYXNwZWVkX21kaW8gew0KPiA+IMKgwqDCoMKgwqDCoMKgwqB2b2lkIF9f
aW9tZW0gKmJhc2U7DQo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHJlc2V0X2NvbnRyb2wgKnJl
c2V0Ow0KPiA+IMKgfTsNCj4gPg0KPiA+IMKgc3RhdGljIGludCBhc3BlZWRfbWRpb19yZWFkKHN0
cnVjdCBtaWlfYnVzICpidXMsIGludCBhZGRyLCBpbnQNCj4gPiByZWdudW0pDQo+ID4gQEAgLTEy
MCw2ICsxMjIsMTIgQEAgc3RhdGljIGludCBhc3BlZWRfbWRpb19wcm9iZShzdHJ1Y3QNCj4gPiBw
bGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChJU19FUlIoY3R4
LT5iYXNlKSkNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBQVFJf
RVJSKGN0eC0+YmFzZSk7DQo+ID4NCj4gPiArwqDCoMKgwqDCoMKgwqBjdHgtPnJlc2V0ID0gZGV2
bV9yZXNldF9jb250cm9sX2dldF9zaGFyZWQoJnBkZXYtPmRldiwgTlVMTCk7DQo+IA0KPiBUaGUg
ZGV2aWNlIHRyZWUgYmluZGluZ3Mgc2hvdWxkIGhhdmUgYSByZXF1aXJlZCByZXNldCBjb250cm9s
IHByb3BlcnR5DQo+IGRvY3VtZW50ZWQgYmVmb3JlIHRoaXMgaXMgYWRkZWQuDQo+IA0KDQpPSywg
SSB3aWxsIGFkZCBhIGNvbW1pdCBmb3IgdGhlIGRvY3VtZW50IGluIFYyLg0KDQo+ID4gK8KgwqDC
oMKgwqDCoMKgaWYgKElTX0VSUihjdHgtPnJlc2V0KSkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuIFBUUl9FUlIoY3R4LT5yZXNldCk7DQo+ID4gKw0KPiA+ICvCoMKg
wqDCoMKgwqDCoHJlc2V0X2NvbnRyb2xfZGVhc3NlcnQoY3R4LT5yZXNldCk7DQo+ID4gKw0KPiAN
Cj4gVGhpcyBpcyBtaXNzaW5nIGEgY29ycmVzcG9uZGluZyByZXNldF9jb250cm9sX2Fzc2VydCgp
IGluDQo+IGFzcGVlZF9tZGlvX3JlbW92ZSgpIGFuZCBpbiB0aGUgZXJyb3IgcGF0aCBvZiBvZl9t
ZGlvYnVzX3JlZ2lzdGVyKCkuDQo+IFRoYXQgd291bGQgYWxsb3cgdG8gYXNzZXJ0IHRoZSByZXNl
dCBsaW5lIGFnYWluIGFmdGVyIGFsbCBNRElPIGNvbnRyb2xsZXJzIGFyZQ0KPiB1bmJvdW5kLg0K
DQpUaGFuayB5b3UgZm9yIHlvdXIgY29tbWVudC4gSSB3aWxsIGZpeCBpdCBpbiBWMi4NCg0KPiAN
Cj4gcmVnYXJkcw0KPiBQaGlsaXBwDQoNCi0tDQpEeWxhbg0K
