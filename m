Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46D662433F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiKJNaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiKJNaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:30:00 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2063.outbound.protection.outlook.com [40.107.105.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB526B207;
        Thu, 10 Nov 2022 05:29:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJgCzHU8B8ffEs5IvbkVjVCKy4cx+UovXDUV0cMLk8iHJzETh9HTKK4ffyTgdmaPcufRhY1B7C8y/m/7fI4soJJxQOSbNB5QrQO+ZVbINpk8CoiKfD2xQ6dZh6gqFYVFkIAL3pkDv/qR/Dv1MyAVaokl/xH47m2xHC44jLTRVU9cVCV1WvmyPwuJQMM4hgVpNNap+f9CtffdQteo55QspVRiOLhul5d2CSVrhy2I/ktkFbcwjN66DoBRMdnh7E9cMdwdeY/SaUftpOBB1lXMsz2R+4E+RdOjVutsir/bk/Y4Soa63fnjaEXEU0UVZukCi1cf2Oq4aBxFLEJqV7fF7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ef5aPW2NrQkNItROQRbZPHDdx3Ny4avTGXj03025QH0=;
 b=gilv46WRGnTupFewbCc7vOSktqHTVF6cFUNN4AnVNlihnfTX/U7JaXcNfCf32Urw+fMijSfW3rCMSS0Xe7pvmqELG+911t9J3Pb12T+eChoLKZRlVNx9bsEnZdLphUxjEJx1Lam6lHPcowGZcg4mhiGC138l9tuqytfgQv+q0nrJIYw8kFaK+Ok/oa7eegRQExRZ3NHn6Grl6vrClIxfeHVXfD7EFcMxe58TPiwfPoFYkFcr+zHGO844VklpeSjlsxgYwYVLE3IDYN61l8k+LkCmAOgq+MAUjB7ehgznlmAnbn2PoZN07YFl23D74cZQPrSiNqR1hmTETO+3iSwCYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ef5aPW2NrQkNItROQRbZPHDdx3Ny4avTGXj03025QH0=;
 b=cMuYYBAb2n3P/xto+bfF9giPrwnIcxKxvamKB+VrEKJ8FjWq7Sf5UHosISxK94yF6k4yT4ZU46zKCm3U+HO/ILXFYw5b2s2S3E5+zVmHPfldHLRMYrDAm38ikbU2oxOxcR+NjIBgd3od00HGyuoGrz6Swr3PusW1LdwGjYPooxU=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB7505.eurprd04.prod.outlook.com (2603:10a6:20b:285::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 10 Nov
 2022 13:29:56 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 13:29:56 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 RESEND 1/1] net: fec: add xdp and page pool
 statistics
Thread-Topic: [EXT] Re: [PATCH v2 RESEND 1/1] net: fec: add xdp and page pool
 statistics
Thread-Index: AQHY8+NzKrQRZ3k0YEy+QDrsvHgkC644DoaAgAAaV3A=
Date:   Thu, 10 Nov 2022 13:29:56 +0000
Message-ID: <PAXPR04MB91853A6A1DDDBB06F33C975E89019@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221109023147.242904-1-shenwei.wang@nxp.com>
 <4349bc93a5f2130a95305287141fde369245f921.camel@redhat.com>
In-Reply-To: <4349bc93a5f2130a95305287141fde369245f921.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM9PR04MB7505:EE_
x-ms-office365-filtering-correlation-id: 552e8db2-1e5c-4664-9575-08dac31fa877
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QmY7JZb9EzXzjknYun+qIllCQ5rVmBpYDz1MyoayrsezCX6ex5Zel0TdZQGmjbPOwuo0E1+8GLNr/gbg41IeEN6/BUkcDRWXPf8QhZGVlQaCMuvRt1NpK5eiy+C2oS+2vriXWQCk2dDng9TprarkKb9awoErsrHc0B6lezOtv0qP2bpsEKMSdydUq6/7jAIPzavYj039HRux+CFZ+ha+ztRcTJDAkyc1BdAa+tDputcVjyxfoLTxf/pK/xUXy/oyKosOVWDwei/Z509+ds6k5xgpFlw2VPEEqFIh7mNT0GJgThX0kSSpUQv0IZeH8usxuCgm+Xj6f7FVdAw4I0xQaIVpOmpMCrhdEiuVgt1AsjRgAWCwCtuAGEucQGblKjN6NA5j4dBOmGKiHIz6+Q6BFyLpMHX8eWpHFhubtO/abwr/no2FGsHcdKizpKjnRC6QxrtzuuI9jqeDQ9WfFTPma/1brCgLgABHZvrh6cwqGb7tEFlVvGbiOyKrPSirHvBJpIpwCYVrYwtVFkhNi4xlkENdRLSzKGycMa0g5OhLXmpNkREg3UOKvGtNmxfIuDFzs8TxnlqEUhzmmrwTEUMwYMydyb0shLlEY3TqhZ9bJs/Nfi/IMqPHNBuAQ+WdspKYUbnJm3UtP8dPf38oNN50E9W8rEgdoMKAM9PlXTunrONnhb0KXC0ECotS/WXUl2WiyeJJRFru9vdnCnjaCUw4JYFoojKnVa6CkLteMzfolooYtwAv9t5whvTMAUPxoRN5YwbyDZTmmT6ctCFK7AeQiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199015)(76116006)(64756008)(66556008)(83380400001)(66476007)(66446008)(66946007)(7696005)(6506007)(110136005)(38070700005)(8676002)(4326008)(55236004)(53546011)(71200400001)(38100700002)(54906003)(33656002)(316002)(86362001)(122000001)(8936002)(9686003)(52536014)(55016003)(41300700001)(44832011)(478600001)(186003)(7416002)(2906002)(5660300002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXU2K1A2ZlhiczlxeEtWSWdncmZlWHVOS3RFbTFuWm1JU1lZTjgzVDhqa2t4?=
 =?utf-8?B?czMxZXdKTmNrZDNLSzJLVEdCOGhMbDluYndxZWZHVmRuS2dVdEpGN09QTW1J?=
 =?utf-8?B?ZUpCNnhPRzdaMTFJSVk5bXMrdWtvTEFmaHZBN0k4VDZJbjViM3BDRjk5WEww?=
 =?utf-8?B?MWd6K1ZzRTI3KzZvZEp4aTFFUStYRDhqSUNxQkkzT0Mya2NtQ0U4c1JEVk56?=
 =?utf-8?B?MDk5QlNuZGhVSUFFc1F5THdpT3p2TStOY2MrWUwzUVIvTWhwS3BrVTgwSUNO?=
 =?utf-8?B?a3BoRTVDRGVSekp1dXdzUjFXY2hKUjhQeFdQWUg2OUFyV3czdXNwOUpsV1k1?=
 =?utf-8?B?QTFEUjdLUDh1SFh4S015TVpaR3VXKzRGM0ovVEI1YmZyeHIyN0pkdjgwS3lW?=
 =?utf-8?B?UzBnQzNjRWNuL1F1TjNXSGZKU2NVa3FmejBvclczYjlaSnJqVzJmdytGSnRK?=
 =?utf-8?B?RGlMTnF6Zmg3b0RRZXZrWUJ2NFh4c01WL1JHM0NTSldTc3hHUkxqNjdYczBq?=
 =?utf-8?B?QnJkVmNKSjJMV212SEh3SzZYWnp2aW9HWmgrcnZiWkRVL0J3a3hXSkQ4RnN6?=
 =?utf-8?B?STNiMEtZQUc1NW03elptaXc0R1pVK2RjZGlPbjdYSWV1bWN0ODVCYWMvSGZP?=
 =?utf-8?B?TjNCWEdlbHRLNWs5RE53cGNGTG8waXhNOG9zaTVVSnFobFBWNGpSc1Y1OXho?=
 =?utf-8?B?RW0wQldjOUtEVXMzSE9pZ3VHbWxEeVREMmRIUTg0RURRQmFEUVpyQ214M3FM?=
 =?utf-8?B?cytPV21qclpCV0NrYTVRZ2Z6WE5ZZFdUTjFSL2pnMmZIUEU0TzBkNWRYdnB5?=
 =?utf-8?B?VTBsN2pRNStqd05EV0NSUU00dmtUSERwbFcwdG1tSEc0a2M3ckt0cnlHdFhL?=
 =?utf-8?B?VGo2R01TZnljbXU1OVdMTkFxM0xlTXcrbzZDRDVwcHhvc2tVeG5vMjlZRnlY?=
 =?utf-8?B?M0RhcW1MSDhrT2czMEYvK2NyK211ay80eTVqbkVZMTNQa0dMTkVvT3JockE4?=
 =?utf-8?B?a2JONUNmRzMzb2hORVN2Sldrdi9xWlJDMVJZMktQeTRwZDh0R2NlZ1hZWnQ0?=
 =?utf-8?B?UzJ1UUJpZHk0bnFTcXRDRk16ZWNuTHp4UDlWS3ppVU8xSXlDWWppUW9URWlx?=
 =?utf-8?B?UjY2OThlUm9XT2RIWko1RzZ0ZHNKTmQzc0tsNFZxaURabStWSUVrUWgxbkZJ?=
 =?utf-8?B?TnltbkZoVVh6SndFSFRsRTQwVE5mSit1emdBS0t2VnRwSmhjWlpIbVFQYlZN?=
 =?utf-8?B?eE1LNU9LUm1XNW9tNmw4U2xKdnRSbVFLQTNCY0dOWjFxM0h6QzNvOGxMMzJD?=
 =?utf-8?B?WXFqU2NDblFYd2FLRExBNUlXQmpRWXcvbFpHM0pydllUYi9memVEcm03TCty?=
 =?utf-8?B?c2JUdnV0Tk8wallUTGZGS3ZoOTZLS1lFbkE0dGV2WjFrYWZxQThnSWlMSXl3?=
 =?utf-8?B?bFV2WHc1M1BhaDVFYndocUVvMTJVaWlqVWFzWmY5ZFpYbDY0QUk4RHpPTmFy?=
 =?utf-8?B?dGYvWGVLMHo2aUtzclZyYWRTV1p2Q0NkWU00dDc0Y3dqT0R2MmUvc0FpOHJh?=
 =?utf-8?B?ell6K05TRTBISDJXMkFsT1kzV0xCQ1Zmd2xEVEZoMkpIZEd6TTNRZnBUTVZh?=
 =?utf-8?B?R1FWQ2dGMCtMOEdXOHFuenFoZ3lqLzZOQmxSNlN2UnlDd09SQjBHZFZUVmVE?=
 =?utf-8?B?ZUtUU2plcitVVGpQSWxGaTgxRVNIMEZDc0dGTkhRZktueW9DOEtNN2RsYzlj?=
 =?utf-8?B?eW4rUGdpemhLVnhHZFdkZnM4WDBSZVV5ZmVzay9UZGRKVWNiV2dhbkRieHkw?=
 =?utf-8?B?TmQxTDlkbEc2Zzc5bEhVNjZ2UUc2bUp5emM0TUo4a05DUlNvSXIvSS9uUjhh?=
 =?utf-8?B?TTgrTS9GSWRneVA2dyswbnQyalZlRW5NdVBYemlDTi9ZK2JTRWFDVVI2R0RK?=
 =?utf-8?B?Q280UGUyS0JUKy9naUc2Zk4vS1FJY3BrY09yTG83VkZmVTBjSUMrOC9tMFpk?=
 =?utf-8?B?VWxlaU9FMEN0Mk1jSjhDVDBRRkZsL1JBOEtOSk5GaDZJYWd2bWs1TldMMGVU?=
 =?utf-8?B?Ym80ZjFzUGdLMFUzVklXcGdqcmRGNVdKcjcxZUI2aDF5M0haNFhqc1RpVWQ3?=
 =?utf-8?Q?x2v2EEYXA/uW3xmf4WobKQZdG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 552e8db2-1e5c-4664-9575-08dac31fa877
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 13:29:56.3689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3/NLyrn1x7m5inzm6xlLYSjs3qRyTW7Q6r1MNIpkTr4Ya6KXuAEaFatlpH+bc7XgWxzbZp5tT/5Lzu+ao/3jjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7505
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQWJlbmkgPHBh
YmVuaUByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTm92ZW1iZXIgMTAsIDIwMjIgNTo1
NCBBTQ0KPiBUbzogU2hlbndlaSBXYW5nIDxzaGVud2VpLndhbmdAbnhwLmNvbT47IERhdmlkIFMu
IE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRA
Z29vZ2xlLmNvbT47IEpha3ViDQo+IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+ID4gICAg
ICAgY2FzZSBFVEhfU1NfU1RBVFM6DQo+ID4gLSAgICAgICAgICAgICBmb3IgKGkgPSAwOyBpIDwg
QVJSQVlfU0laRShmZWNfc3RhdHMpOyBpKyspDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgIG1l
bWNweShkYXRhICsgaSAqIEVUSF9HU1RSSU5HX0xFTiwNCj4gPiAtICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBmZWNfc3RhdHNbaV0ubmFtZSwgRVRIX0dTVFJJTkdfTEVOKTsNCj4gPiArICAg
ICAgICAgICAgIGZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKGZlY19zdGF0cyk7IGkrKykgew0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICBtZW1jcHkoZGF0YSwgZmVjX3N0YXRzW2ldLm5hbWUs
IEVUSF9HU1RSSU5HX0xFTik7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGRhdGEgKz0gRVRI
X0dTVFJJTkdfTEVOOw0KPiA+ICsgICAgICAgICAgICAgfQ0KPiA+ICsgICAgICAgICAgICAgZm9y
IChpID0gMDsgaSA8IEFSUkFZX1NJWkUoZmVjX3hkcF9zdGF0X3N0cnMpOyBpKyspIHsNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgbWVtY3B5KGRhdGEsIGZlY194ZHBfc3RhdF9zdHJzW2ldLCBF
VEhfR1NUUklOR19MRU4pOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBkYXRhICs9IEVUSF9H
U1RSSU5HX0xFTjsNCj4gDQo+IFRoZSBhYm92ZSB0cmlnZ2VycyBhIHdhcm5pbmc6DQo+IA0KPiBJ
biBmdW5jdGlvbiDigJhmb3J0aWZ5X21lbWNweV9jaGvigJksDQo+ICAgICBpbmxpbmVkIGZyb20g
4oCYZmVjX2VuZXRfZ2V0X3N0cmluZ3PigJkNCj4gYXQgLi4vZHJpdmVycy9uZXQvZXRoZXJuZXQv
ZnJlZXNjYWxlL2ZlY19tYWluLmM6Mjc4ODo0Og0KPiAuLi9pbmNsdWRlL2xpbnV4L2ZvcnRpZnkt
c3RyaW5nLmg6NDEzOjI1OiB3YXJuaW5nOiBjYWxsIHRvIOKAmF9fcmVhZF9vdmVyZmxvdzJfZmll
bGTigJkNCj4gZGVjbGFyZWQgd2l0aCBhdHRyaWJ1dGUgd2FybmluZzogZGV0ZWN0ZWQgcmVhZCBi
ZXlvbmQgc2l6ZSBvZiBmaWVsZCAoMm5kDQo+IHBhcmFtZXRlcik7IG1heWJlIHVzZSBzdHJ1Y3Rf
Z3JvdXAoKT8gWy1XYXR0cmlidXRlLXdhcm5pbmddDQo+ICAgNDEzIHwgICAgICAgICAgICAgICAg
ICAgICAgICAgX19yZWFkX292ZXJmbG93Ml9maWVsZChxX3NpemVfZmllbGQsIHNpemUpOw0KPiAg
ICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fg0KPiANCj4gSSB0aGluayB5b3UgY2FuIGFkZHJlc3MgaXQgY2hhbmdp
bmcgZmVjX3hkcF9zdGF0X3N0cnMgZGVmaW5pdGlvbiB0bzoNCj4gDQo+IHN0YXRpYyBjb25zdCBj
aGFyIGZlY194ZHBfc3RhdF9zdHJzW1hEUF9TVEFUU19UT1RBTF1bRVRIX0dTVFJJTkdfTEVOXSA9
DQoNClRoYXQgZG9lcyBhIHByb2JsZW0uIEhvdyBhYm91dCBqdXN0IGNoYW5nZSB0aGUgbWVtY3B5
IHRvIHN0cm5jcHk/IA0KDQpSZWdhcmRzLA0KU2hlbndlaQ0KDQo+IHsgLy8gLi4uDQo+IA0KPiBD
aGVlcnMsDQo+IA0KPiBQYW9sbw0KDQo=
