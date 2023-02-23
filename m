Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EC66A062B
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjBWK1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbjBWK1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:27:14 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2055.outbound.protection.outlook.com [40.107.8.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E97326863;
        Thu, 23 Feb 2023 02:27:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHXW13a+wihzBsoJwLZzQ2fbNGm8uRu4uZtIVNwWnWuk67AO+JCizoC1nfDpA6ld6A6k07EUvxOLInGWGVi6ghdr1CU3fNz1YC7/Ja1mQsBi59pROhdhOR5w8Dt/6evSfJ9nunP4TENWNnto9DDROegKYm227vtHFHfp7wqSm5w13f/zPD1Vmm/KXDMvZlDMY0L3y1KJ6RBTwjD4lJbKYorEM24oAxiq/BIkUC75kzktcKuOCcDyWMaHgOPJanRxEGN3TowKAv9BH5frwVk1Kkh0TUBlqdKRs/lN/KP7Q+lQI9/FMeBmr+WFpGgP4bv04tRqvN/cZt4yUa0Hyt4P5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rn9qvShJ7OSqBuxMN1QurkHRLZWLr/eysDgYxRBSqJI=;
 b=ckbfnkQpp3PE7qsz4ikvAr42xnLZCUS4FKqFG7lTws/LvN10HF0Jkaoui8NytfgQMSze8rehI0CEz3ZDcb89vc3qVklJYTZgaaFnolH0ZFqq5+TTaq4m7VV7mj0u4O+SdUh01iSebrwXt1MDUHPhR2DPI2B1EuZbh7efldEPGuI/dkueg1SWk7M8vz6O6zB0QSzrL2Qu1ctq0q1QOMpyrZWvCIOWAC64NPVlFwXMheGfUnoKYBs8ShQRyPB0Ga8IeoBvqhe3zfA+grHz+THOFjk0doiiuTCT8HCqQc1+vuzbolt/7o4+Ea34crwld9Ttkg3c0xapcqXSrCTlLepXuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rn9qvShJ7OSqBuxMN1QurkHRLZWLr/eysDgYxRBSqJI=;
 b=R4n02ofQFGsDHcN2Xy0nGy4l3ThdFKRnlx6AnD3n5dEL2skRPuaMaAASSgwz7sqSd2w2wDjfdJ3MQJkfrC4l6pveXmVAGCoHEI5E4GmOMki1i9AdDQer4K3Wjlzt5cJHJW89sQyDSLr9tovowmfCl9zKLSB1c3/E/ngTCztYzFI=
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by PAXPR04MB8942.eurprd04.prod.outlook.com (2603:10a6:102:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 10:27:07 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1%4]) with mapi id 15.20.6134.018; Thu, 23 Feb 2023
 10:27:06 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V3 1/2] net: phylink: add a function to resume phy alone
 to fix resume issue with WoL enabled
Thread-Topic: [PATCH V3 1/2] net: phylink: add a function to resume phy alone
 to fix resume issue with WoL enabled
Thread-Index: AQHZNt66y8oIlom1RkenssUC8JY/F67cb/kAgAADgoCAAACGoA==
Date:   Thu, 23 Feb 2023 10:27:06 +0000
Message-ID: <HE1PR0402MB2939A09FD54E72C80C19A467F3AB9@HE1PR0402MB2939.eurprd04.prod.outlook.com>
References: <20230202081559.3553637-1-xiaoning.wang@nxp.com>
 <83a8fb89ac7a69d08c9ea1422dade301dcc87297.camel@redhat.com>
 <Y/c+MQtgtKFDjEZF@shell.armlinux.org.uk>
In-Reply-To: <Y/c+MQtgtKFDjEZF@shell.armlinux.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HE1PR0402MB2939:EE_|PAXPR04MB8942:EE_
x-ms-office365-filtering-correlation-id: ffd8f5ec-b2f4-4ded-24f5-08db15888371
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: to+3cOakSfvv2y1Q1rk8sMN1yjklqV2czX5UkX1126727agdAI/fij15282zHLoNlQNlKEyzYvzTSmifJowZICxfFSuDwTrk7PO/2Md/YdOsov6DQ3yOne80lH5J2AV8qQLv9+7AAF3KYyVqQwhJRHJoWkm5y0SDKlmGxDCOK2c7YwnUUswvfNrfR93shuNvn1ZkNlnaYXMKDHKROioLuyjU2TTezrY/x3SIV8uPxlOmW00NyB3HWW2W/L46OHvzYodHwSl1Op6gHaWvCLjiKpYr4Fny+1ieVlzg4qUC174beI0zPe7R+Vv7jdh7fM+s+qRssPWLH09b13Q6ukylcqgorw7DOaBnI+ljTgoqqzRiqbOyRF1uaD1PnChURjBDFvq2maIRl4sKKxPOIEDJojvunQChcYd2JFrqlWVHErlgwMozenGsi7q9QINlf92gDD0EHx2nkp534l7aJkr8cwDf3MHqocy9qla6QJ8Ng9VJAocgMfXjNJqMHKYULXQJnm68EsMHmDZnfIk2cU/UQ0cfxND0mWvski1E/NA16IeRyQhl7ojl3D1shTxjJi27pH82aOW9OV46yejJeCP5Tfw+D/rpPCeRRSuqD7m9XDoVEomvbj5kay44CpWQHHiv28VyhlE3aK1XpPGv9c3nXTmE5hpITBoaHTXTWCqYOSH8lDXhtOtzS/zhwNS4U6km
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199018)(41300700001)(8936002)(7416002)(71200400001)(86362001)(4326008)(76116006)(66946007)(5660300002)(66446008)(66476007)(66556008)(64756008)(52536014)(8676002)(2906002)(45080400002)(316002)(55016003)(83380400001)(7696005)(54906003)(966005)(33656002)(110136005)(478600001)(186003)(6506007)(9686003)(53546011)(26005)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Y29ubDZLVzQwVzVFSk5pcE9kbXNYdDk2R2FZVmR1djVoNkxnemRGUEdQTW1x?=
 =?gb2312?B?a01wZ085UVBCeVA2bEdmWVZwRVhvUHY1emVEUnh6OUJNVEFiV3gvcmdzSVUz?=
 =?gb2312?B?VFNNWnpWK0ZCKzVXa1Q3NUV3Y083T1J5OUhYVGdmTmlOQ0VpR21mNGJRMHIz?=
 =?gb2312?B?Y3RGTFZtdC8wYmNRanNkUkw5cThNREF4dzg5d1QzN0dlbEp5VzZBR3hlT3ZJ?=
 =?gb2312?B?ZjRPM3Fzd0o5RERlVnRHbjB2UHA4RkZXbU1oYXIwVitIK0FacWQwTjhVdkU0?=
 =?gb2312?B?TklkK0g5UEx6TG9JWExEaytsOWhaUXVZV2Y0VFlpZnpjM0Nza0JZVHQyZFgr?=
 =?gb2312?B?S3p3TC8xY1dOTldFT1ZkOUkyK213YkJkY2FtWDRIeitUUVZxang1M09sV3RO?=
 =?gb2312?B?RG1hMzZEOUtGMys3RVBhT0pVL3RHVFZpOVNSb1Q4cVdpa3p3ZkM0UVlGcGlx?=
 =?gb2312?B?RGNna3pLN0tEZEJmdWlHUkxJWVF4MEZ5MEllc2Jpako1QUdmWWlBd2Yvc1Mx?=
 =?gb2312?B?aEtiWUlGbFdXb2FpU2M4RE51M0NjbHYxMHEzcHNtMWx6aWZTd3VvWWFrTnBB?=
 =?gb2312?B?ei84djFUdTFrQksvVjJXNnR4eTZTdFRYQWdWTThoZWJibGYrRkJzbjZIRUxi?=
 =?gb2312?B?SENJOC9Sc3pWYUtUV0FNSUkyRXRldWJlTmE0dUxRVEIxQSs4eE1tZ2FIakt1?=
 =?gb2312?B?by9CNXhrbjRGRXhONW5YUEJRa2hPc0g4U1NXR3NQdlRpc2hLTUVaNmplVkRY?=
 =?gb2312?B?UGFiTkg4Q21tL1pHTFZXVERmaFN1YkczbXpHWW5lSGRrN21lVjBKUlYzcHdv?=
 =?gb2312?B?US82NWdoVi92Tzk1NlYvRGpRZTVHanJvZTNSVkNMKzJkSFZWaTlORVMrZHVl?=
 =?gb2312?B?OHlSdnhFcjRIcU5uQXJEZDNpbmQrRkw1ZmUvQTFQS1BYcTNnUFhZdDBnRnph?=
 =?gb2312?B?QW41UmhxMUlzeW80RzV5cW9uZDIyWVFjM2xvMlVDallnM05VRFZ6UFozcWVG?=
 =?gb2312?B?RVJDZFRrS2ordHRoNlJ4SExDRnFnOFlWdDBZSWdjanRZZVZMeGJNbm5scytC?=
 =?gb2312?B?dzVlRDRqbzkxbjNFYktBMk9tUW9pUkZpbmtQMHFRNkE4N2prVzBsVlNXMCtY?=
 =?gb2312?B?TGtvWlp1NmhOakwvRG1vTVRrdVV3MitmWUdsUk1YejNnTVNhVjFTTnFkOUdK?=
 =?gb2312?B?Z3hNbHJFNXY5T1BRbG1uR2wzcUMwTWJjcjRIR3R6UDZtdVVsZWNsS1dIMnJI?=
 =?gb2312?B?YmxkL2ZIL0EySExiU2IrSHJMcW9CYjd0TDU3cEs2eVJaaDZpVTJYY01YTVdv?=
 =?gb2312?B?S3I4YmVKRWwwZUxYRi83TktPRkUyR1dsRFRQdDJwUTdCY3hjU08yc0gySEpy?=
 =?gb2312?B?a0ZsSitjWUpSV1hMeEdORWF5d0FWSlRQdUMvK0I5N1pac0hLcGRtdCtwTEY3?=
 =?gb2312?B?aStQOGRHUkhnMTZHem85RHBmekMyS0ROWXZtaE5DTHlQZmJSeVRFRVhuNkxz?=
 =?gb2312?B?dVFTVURlcUllU2VMK0xYNUZGNmhqNWtKSGY3SFlxdmh4aWRpRWR4MVdVN1Rm?=
 =?gb2312?B?OVh4MHh6MlpXYzM4bnJ5ZThkOUptYUw2WkxIYVZ3ZzNSbHZNZFYyRUhOL1ZR?=
 =?gb2312?B?VUQyMG9mbzBDc1I1N3N3cVBBNHM2Y09tdG5vM0pGeDQ3RmNnSTlFUGlGbEtV?=
 =?gb2312?B?MHUxcEJOYWY1dDZ6STErem1WMDhReGxRa1RxZ1BiVmpVSFVOWDc5ODNpb0ho?=
 =?gb2312?B?Y203QThXUVVERmxML3ArUDh6d2JhTlJoTUVScHhmc0FndC9MbFdaYlBNMXRS?=
 =?gb2312?B?OU9WQ1lFZWVqMEtyYldGUTk3bUpmVlhrVkx0cE9pSHpZMy9RYXRNaXduSm41?=
 =?gb2312?B?ZHltYllPeVFzaDU4dUdMdkl2OXlHWktHWVVNbWdlUHVKS2psckJidWR2ZDUx?=
 =?gb2312?B?QVlWVlIvNFBZb3VjcHJPK2FsTENFcEpyQWVqY3VPcnQyWGxJVlhJWVRLNEx2?=
 =?gb2312?B?bk5aR0YrWVBZbllaL1ZadkY2WFZnMExEVWFkUnplaERDNmgzN2JNRkpDREk4?=
 =?gb2312?B?SHViOGJPNEtoMmN0TTh1OEV3Z01ya2VVbm5ZbTFwQ0FTV3hTRXRFUDNNcEVJ?=
 =?gb2312?Q?t6r+8Z01aM9wpFS8PZKVPSxWy?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd8f5ec-b2f4-4ded-24f5-08db15888371
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 10:27:06.7866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XM3bPdMVOFIvyz3FGb1YAvMgTjHiKfC6B4zDLPXn7Mb+SfsrXgjvjYmq6IY7RA3G0UQFoo4nuMKQy9tzQYLvQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8942
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJ1c3NlbGwgS2luZyA8bGlu
dXhAYXJtbGludXgub3JnLnVrPg0KPiBTZW50OiAyMDIzxOoy1MIyM8jVIDE4OjIyDQo+IFRvOiBQ
YW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+DQo+IENjOiBDbGFyayBXYW5nIDx4aWFvbmlu
Zy53YW5nQG54cC5jb20+OyBwZXBwZS5jYXZhbGxhcm9Ac3QuY29tOw0KPiBhbGV4YW5kcmUudG9y
Z3VlQGZvc3Muc3QuY29tOyBqb2FicmV1QHN5bm9wc3lzLmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBtY29xdWVsaW4u
c3RtMzJAZ21haWwuY29tOyBhbmRyZXdAbHVubi5jaDsgaGthbGx3ZWl0MUBnbWFpbC5jb207DQo+
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXN0bTMyQHN0LW1kLW1haWxtYW4uc3Rvcm1y
ZXBseS5jb207DQo+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMyAxLzJdIG5ldDogcGh5bGluazogYWRkIGEgZnVu
Y3Rpb24gdG8gcmVzdW1lIHBoeSBhbG9uZQ0KPiB0byBmaXggcmVzdW1lIGlzc3VlIHdpdGggV29M
IGVuYWJsZWQNCj4gDQo+IE9uIFRodSwgRmViIDIzLCAyMDIzIGF0IDExOjA5OjA0QU0gKzAxMDAs
IFBhb2xvIEFiZW5pIHdyb3RlOg0KPiA+IE9uIFRodSwgMjAyMy0wMi0wMiBhdCAxNjoxNSArMDgw
MCwgQ2xhcmsgV2FuZyB3cm90ZToNCj4gPiA+IElzc3VlIHdlIG1ldDoNCj4gPiA+IE9uIHNvbWUg
cGxhdGZvcm1zLCBtYWMgY2Fubm90IHdvcmsgYWZ0ZXIgcmVzdW1lZCBmcm9tIHRoZSBzdXNwZW5k
DQo+IHdpdGggV29MDQo+ID4gPiBlbmFibGVkLg0KPiA+ID4NCj4gPiA+IFRoZSBjYXVzZSBvZiB0
aGUgaXNzdWU6DQo+ID4gPiAxLiBwaHlsaW5rX3Jlc29sdmUoKSBpcyBpbiBhIHdvcmtxdWV1ZSB3
aGljaCB3aWxsIG5vdCBiZSBleGVjdXRlZA0KPiBpbW1lZGlhdGVseS4NCj4gPiA+ICAgIFRoaXMg
aXMgdGhlIGNhbGwgc2VxdWVuY2U6DQo+ID4gPg0KPiBwaHlsaW5rX3Jlc29sdmUoKS0+cGh5bGlu
a19saW5rX3VwKCktPnBsLT5tYWNfb3BzLT5tYWNfbGlua191cCgpDQo+ID4gPiAgICBGb3Igc3Rt
bWFjIGRyaXZlciwgbWFjX2xpbmtfdXAoKSB3aWxsIHNldCB0aGUgY29ycmVjdCBzcGVlZC9kdXBs
ZXguLi4NCj4gPiA+ICAgIHZhbHVlcyB3aGljaCBhcmUgZnJvbSBsaW5rX3N0YXRlLg0KPiA+ID4g
Mi4gSW4gc3RtbWFjX3Jlc3VtZSgpLCBpdCB3aWxsIGNhbGwgc3RtbWFjX2h3X3NldHVwKCkgYWZ0
ZXIgY2FsbGVkIHRoZQ0KPiA+ID4gICAgcGh5bGlua19yZXN1bWUoKSwgYmVjYXVzZSBtYWMgbmVl
ZCBwaHkgcnhfY2xrIHRvIGRvIHRoZSByZXNldC4NCj4gPiA+ICAgIHN0bW1hY19jb3JlX2luaXQo
KSBpcyBjYWxsZWQgaW4gZnVuY3Rpb24gc3RtbWFjX2h3X3NldHVwKCksIHdoaWNoDQo+IHdpbGwN
Cj4gPiA+ICAgIHJlc2V0IHRoZSBtYWMgYW5kIHNldCB0aGUgc3BlZWQvZHVwbGV4Li4uIHRvIGRl
ZmF1bHQgdmFsdWUuDQo+ID4gPiBDb25jbHVzaW9uOiBCZWNhdXNlIHBoeWxpbmtfcmVzb2x2ZSgp
IGNhbm5vdCBkZXRlcm1pbmUgd2hlbiBpdCBpcyBjYWxsZWQsDQo+IGl0DQo+ID4gPiAgICAgICAg
ICAgICBjYW5ub3QgYmUgZ3VhcmFudGVlZCB0byBiZSBjYWxsZWQgYWZ0ZXINCj4gc3RtbWFjX2Nv
cmVfaW5pdCgpLg0KPiA+ID4gCSAgICBPbmNlIHN0bW1hY19jb3JlX2luaXQoKSBpcyBjYWxsZWQg
YWZ0ZXIgcGh5bGlua19yZXNvbHZlKCksDQo+ID4gPiAJICAgIHRoZSBtYWMgd2lsbCBiZSBtaXNj
b25maWd1cmVkIGFuZCBjYW5ub3QgYmUgdXNlZC4NCj4gPiA+DQo+ID4gPiBJbiBvcmRlciB0byBh
dm9pZCB0aGlzIHByb2JsZW0sIGFkZCBhIGZ1bmN0aW9uIGNhbGxlZA0KPiBwaHlsaW5rX3BoeV9y
ZXN1bWUoKQ0KPiA+ID4gdG8gcmVzdW1lIHBoeSBzZXBhcmF0ZWx5LiBUaGlzIGVsaW1pbmF0ZXMg
dGhlIG5lZWQgdG8gY2FsbA0KPiBwaHlsaW5rX3Jlc3VtZSgpDQo+ID4gPiBiZWZvcmUgc3RtbWFj
X2h3X3NldHVwKCkuDQo+ID4gPg0KPiA+ID4gQWRkIGFub3RoZXIganVkZ2VtZW50IGJlZm9yZSBj
YWxsZWQgcGh5X3N0YXJ0KCkgaW4gcGh5bGlua19zdGFydCgpLiBUaGlzDQo+IHdheQ0KPiA+ID4g
cGh5X3N0YXJ0KCkgd2lsbCBub3QgYmUgY2FsbGVkIG11bHRpcGxlIHRpbWVzIHdoZW4gcmVzdW1l
cy4gQXQgdGhlIHNhbWUNCj4gdGltZSwNCj4gPiA+IGl0IG1heSBub3QgYWZmZWN0IG90aGVyIGRy
aXZlcnMgdGhhdCBkbyBub3QgdXNlIHBoeWxpbmtfcGh5X3Jlc3VtZSgpLg0KPiA+ID4NCj4gPiA+
IFNpZ25lZC1vZmYtYnk6IENsYXJrIFdhbmcgPHhpYW9uaW5nLndhbmdAbnhwLmNvbT4NCj4gPiA+
IC0tLQ0KPiA+ID4gVjIgY2hhbmdlOg0KPiA+ID4gIC0gYWRkIG1hY19yZXN1bWVfcGh5X3NlcGFy
YXRlbHkgZmxhZyB0byBzdHJ1Y3QgcGh5bGluayB0byBtYXJrIGlmIHRoZQ0KPiBtYWMNCj4gPiA+
ICAgIGRyaXZlciB1c2VzIHRoZSBwaHlsaW5rX3BoeV9yZXN1bWUoKSBmaXJzdC4NCj4gPiA+IFYz
IGNoYW5nZToNCj4gPiA+ICAtIGFkZCBicmFjZSB0byBhdm9pZCBhbWJpZ3VvdXMgJ2Vsc2UnDQo+
ID4gPiAgICBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+
ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9waHkvcGh5bGluay5jIHwgMzIgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLS0NCj4gPiA+ICBpbmNsdWRlL2xpbnV4L3BoeWxpbmsuaCAg
IHwgIDEgKw0KPiA+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMzEgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L3BoeWxp
bmsuYyBiL2RyaXZlcnMvbmV0L3BoeS9waHlsaW5rLmMNCj4gPiA+IGluZGV4IDMxOTc5MDIyMWQ3
Zi4uYzJmZTY2ZjBiNzhmIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L3BoeWxp
bmsuYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvcGh5L3BoeWxpbmsuYw0KPiA+ID4gQEAgLTgw
LDYgKzgwLDggQEAgc3RydWN0IHBoeWxpbmsgew0KPiA+ID4gIAlERUNMQVJFX1BIWV9JTlRFUkZB
Q0VfTUFTSyhzZnBfaW50ZXJmYWNlcyk7DQo+ID4gPiAgCV9fRVRIVE9PTF9ERUNMQVJFX0xJTktf
TU9ERV9NQVNLKHNmcF9zdXBwb3J0KTsNCj4gPiA+ICAJdTggc2ZwX3BvcnQ7DQo+ID4gPiArDQo+
ID4gPiArCWJvb2wgbWFjX3Jlc3VtZV9waHlfc2VwYXJhdGVseTsNCj4gPiA+ICB9Ow0KPiA+ID4N
Cj4gPiA+ICAjZGVmaW5lIHBoeWxpbmtfcHJpbnRrKGxldmVsLCBwbCwgZm10LCAuLi4pIFwNCj4g
PiA+IEBAIC0xNTA5LDYgKzE1MTEsNyBAQCBzdHJ1Y3QgcGh5bGluayAqcGh5bGlua19jcmVhdGUo
c3RydWN0DQo+IHBoeWxpbmtfY29uZmlnICpjb25maWcsDQo+ID4gPiAgCQlyZXR1cm4gRVJSX1BU
UigtRUlOVkFMKTsNCj4gPiA+ICAJfQ0KPiA+ID4NCj4gPiA+ICsJcGwtPm1hY19yZXN1bWVfcGh5
X3NlcGFyYXRlbHkgPSBmYWxzZTsNCj4gPiA+ICAJcGwtPnVzaW5nX21hY19zZWxlY3RfcGNzID0g
dXNpbmdfbWFjX3NlbGVjdF9wY3M7DQo+ID4gPiAgCXBsLT5waHlfc3RhdGUuaW50ZXJmYWNlID0g
aWZhY2U7DQo+ID4gPiAgCXBsLT5saW5rX2ludGVyZmFjZSA9IGlmYWNlOw0KPiA+ID4gQEAgLTE5
NDMsOCArMTk0NiwxMiBAQCB2b2lkIHBoeWxpbmtfc3RhcnQoc3RydWN0IHBoeWxpbmsgKnBsKQ0K
PiA+ID4gIAl9DQo+ID4gPiAgCWlmIChwb2xsKQ0KPiA+ID4gIAkJbW9kX3RpbWVyKCZwbC0+bGlu
a19wb2xsLCBqaWZmaWVzICsgSFopOw0KPiA+ID4gLQlpZiAocGwtPnBoeWRldikNCj4gPiA+IC0J
CXBoeV9zdGFydChwbC0+cGh5ZGV2KTsNCj4gPiA+ICsJaWYgKHBsLT5waHlkZXYpIHsNCj4gPiA+
ICsJCWlmICghcGwtPm1hY19yZXN1bWVfcGh5X3NlcGFyYXRlbHkpDQo+ID4gPiArCQkJcGh5X3N0
YXJ0KHBsLT5waHlkZXYpOw0KPiA+ID4gKwkJZWxzZQ0KPiA+ID4gKwkJCXBsLT5tYWNfcmVzdW1l
X3BoeV9zZXBhcmF0ZWx5ID0gZmFsc2U7DQo+ID4gPiArCX0NCj4gPiA+ICAJaWYgKHBsLT5zZnBf
YnVzKQ0KPiA+ID4gIAkJc2ZwX3Vwc3RyZWFtX3N0YXJ0KHBsLT5zZnBfYnVzKTsNCj4gPiA+ICB9
DQo+ID4gPiBAQCAtMjAyNCw2ICsyMDMxLDI3IEBAIHZvaWQgcGh5bGlua19zdXNwZW5kKHN0cnVj
dCBwaHlsaW5rICpwbCwgYm9vbA0KPiBtYWNfd29sKQ0KPiA+ID4gIH0NCj4gPiA+ICBFWFBPUlRf
U1lNQk9MX0dQTChwaHlsaW5rX3N1c3BlbmQpOw0KPiA+ID4NCj4gPiA+ICsvKioNCj4gPiA+ICsg
KiBwaHlsaW5rX3BoeV9yZXN1bWUoKSAtIHJlc3VtZSBwaHkgYWxvbmUNCj4gPiA+ICsgKiBAcGw6
IGEgcG9pbnRlciB0byBhICZzdHJ1Y3QgcGh5bGluayByZXR1cm5lZCBmcm9tIHBoeWxpbmtfY3Jl
YXRlKCkNCj4gPiA+ICsgKg0KPiA+ID4gKyAqIEluIHRoZSBNQUMgZHJpdmVyIHVzaW5nIHBoeWxp
bmssIGlmIHRoZSBNQUMgbmVlZHMgdGhlIGNsb2NrIG9mIHRoZSBwaHkNCj4gPiA+ICsgKiB3aGVu
IGl0IHJlc3VtZXMsIGNhbiBjYWxsIHRoaXMgZnVuY3Rpb24gdG8gcmVzdW1lIHRoZSBwaHkgc2Vw
YXJhdGVseS4NCj4gPiA+ICsgKiBUaGVuIHByb2NlZWQgdG8gTUFDIHJlc3VtZSBvcGVyYXRpb25z
Lg0KPiA+ID4gKyAqLw0KPiA+ID4gK3ZvaWQgcGh5bGlua19waHlfcmVzdW1lKHN0cnVjdCBwaHls
aW5rICpwbCkNCj4gPiA+ICt7DQo+ID4gPiArCUFTU0VSVF9SVE5MKCk7DQo+ID4gPiArDQo+ID4g
PiArCWlmICghdGVzdF9iaXQoUEhZTElOS19ESVNBQkxFX01BQ19XT0wsDQo+ICZwbC0+cGh5bGlu
a19kaXNhYmxlX3N0YXRlKQ0KPiA+ID4gKwkgICAgJiYgcGwtPnBoeWRldikgew0KPiA+ID4gKwkJ
cGh5X3N0YXJ0KHBsLT5waHlkZXYpOw0KPiA+ID4gKwkJcGwtPm1hY19yZXN1bWVfcGh5X3NlcGFy
YXRlbHkgPSB0cnVlOw0KPiA+ID4gKwl9DQo+ID4gPiArDQo+ID4NCj4gPiBNaW5vciBuaXQ6IHRo
ZSBlbXB0eSBsaW5lIGhlcmUgaXMgbm90IG5lZWRlZC4NCj4gDQo+IFRoZSBhdXRob3IgYXBwZWFy
cyB0byBoYXZlIGJlY29tZSBub24tcmVzcG9uc2l2ZSBhZnRlciBzZW5kaW5nIGhhbGYgb2YNCj4g
dGhlIHR3byBwYXRjaCBzZXJpZXMsIGFuZCBoYXNuJ3QgYWRkcmVzc2VkIHByZXZpb3VzIGZlZWRi
YWNrLg0KPiANCj4gSW4gYW55IGNhc2UsIHNvbWVvbmUgZWxzZSB3YXMgYWxzbyBoYXZpbmcgc2lt
aWxhciBpc3N1ZXMgd2l0aCBzdG1tYWMsDQo+IGFuZCBwcm9wb3NpbmcgZGlmZmVyZW50IHBhdGNo
ZXMsIHNvIEkndmUgcmVxdWVzdGVkIHRoYXQgdGhleSB3b3JrDQo+IHRvZ2V0aGVyIHRvIHNvbHZl
IHdoYXQgbG9va3MgbGlrZSBvbmUgY29tbW9uIHByb2JsZW0sIGluc3RlYWQgb2YgdXMNCj4gZW5k
aW5nIHVwIHdpdGggdHdvIHBhdGNoIHNlcmllcyBwb3RlbnRpYWxseSBhZGRyZXNzaW5nIHRoYXQg
c2FtZQ0KPiBpc3N1ZS4NCg0KDQpIaSBSdXNzZWwsDQoNCkkgaGF2ZSBzZW50IHRoZSBWNCBwYXRj
aCBzZXQgeWVzdGVyZGF5Lg0KWW91IGNhbiBjaGVjayBpdCBmcm9tOiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9saW51eC1hcm0ta2VybmVsLzIwMjMwMjIyMDkyNjM2LjE5ODQ4NDctMi14aWFvbmlu
Zy53YW5nQG54cC5jb20vVC8NCg0KDQpUaGFua3MuDQoNCkJlc3QgUmVnYXJkcywNCkNsYXJrIFdh
bmcNCj4gDQo+IC0tDQo+IFJNSydzIFBhdGNoIHN5c3RlbToNCj4gaHR0cHM6Ly9ldXIwMS5zYWZl
bGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGd3d3DQo+IC5h
cm1saW51eC5vcmcudWslMkZkZXZlbG9wZXIlMkZwYXRjaGVzJTJGJmRhdGE9MDUlN0MwMSU3Q3hp
YW9uaW5nLg0KPiB3YW5nJTQwbnhwLmNvbSU3QzY3NWZiM2NmYTY4ZjQ0MjQ3MzQwMDhkYjE1ODdj
MzBkJTdDNjg2ZWExZDNiDQo+IGMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2Mzgx
Mjc0NDUwNTc2NTgzMjglN0NVbmtubw0KPiB3biU3Q1RXRnBiR1pzYjNkOGV5SldJam9pTUM0d0xq
QXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxDQo+IGhhV3dpTENKWFZDSTZNbjAlM0Ql
N0MzMDAwJTdDJTdDJTdDJnNkYXRhPWszWm96WlRxJTJCUklpazY3DQo+ICUyRlFGQ0FFUTdJRGIl
MkZSQVBKQlhiaWdMZ3Ric1NVJTNEJnJlc2VydmVkPTANCj4gRlRUUCBpcyBoZXJlISA0ME1icHMg
ZG93biAxME1icHMgdXAuIERlY2VudCBjb25uZWN0aXZpdHkgYXQgbGFzdCENCg==
