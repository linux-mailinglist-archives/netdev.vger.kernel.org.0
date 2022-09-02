Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0405AA572
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiIBCGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiIBCGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:06:06 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2063.outbound.protection.outlook.com [40.107.249.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACCA54643;
        Thu,  1 Sep 2022 19:06:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CE6QVtZCQ6brf9hon+MsB5baGYarzvzYqCPG1kl1fGF/NqjEsF9lHgxqIvgKtm5nRXOugC9qGbkBKpyIZRPgilG/mmq7ttklsDQUhTk6PvXhSGgIAx6KXb2BHc6td6nv/5/L0f7eNJPkpC/z29hI9w2sLDJTDKcJJmK/gq1OM3PCn3qs7AwrUcxBx6oKkXTlYgTUkNz09Q9rMtufPJdBfvDe43hP2lSqY30b9ZMFmBpVku9Ly/bNxkITq+PzDuKLc/6fkARpBMeuqcVm2ZnClMcFwtTca3eIUOiJgtbjrqHKvYDr0RyzBJVK6h6sWS7XqMMRfnZRIfjyME4PmX2ZkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uf8+OblpHtDdt5sbcPNs9mkWuu4YA5Ozw+FKsm5DQdQ=;
 b=hVqkuu34Ag1tSpFF0F3ENFowgqKNG6ibenb5D1gWAFFdW1O1g000718u8ZHd6Mtx1AIMEgZ1NKl7OPRh9SWCLZkq5PyBvnfhGu/+gfuwVRfLvhBzfWlsm+EyrqrlY6UxR8xH0AF85DYUWkdDbvkK5ZCvF0BKf5DsUcpLQhymhI1oG7uFqPT6le2NFBVAU9F+JDjkgmtm1qIs3Q+fJpsZkLiBzx+WPhN6ui7c+pyib3QpW6Zh3MV4xl7J+Ud2ILjVY9/at2Z/sJk/zXHv/peKBF7J5W5r8YM7JG4AOcVQcG7Y/ly2wmPmkXBMls/eASGSBvxHSOeQNuvGmsAHzQfn2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uf8+OblpHtDdt5sbcPNs9mkWuu4YA5Ozw+FKsm5DQdQ=;
 b=pokikdWYd7BJNYJQ4cgIictN9wQoXgEL/XuADdPwtmEclCmqWhv/qmaJ1ReN9WaIO2vOZJ2DsRth4IdKrvgNFtuMVuqm9ARKmZfMA7msCMfQRtio+U1ZgS2Gh/jLGQR571vqJVjKJCbNX5cHujMH/zp0b/yEQteJp10T37bczqc=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DBBPR04MB6187.eurprd04.prod.outlook.com (2603:10a6:10:ca::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Fri, 2 Sep
 2022 02:05:59 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 02:05:59 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: fec: add pm_qos support on imx6q platform
Thread-Topic: [PATCH net] net: fec: add pm_qos support on imx6q platform
Thread-Index: AQHYvD5wRF3hDujxKUysPDIgKEiycK3KLVaAgAE1PfA=
Date:   Fri, 2 Sep 2022 02:05:59 +0000
Message-ID: <DB9PR04MB8106C5795E096F2CC87389B1887A9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220830070148.2021947-1-wei.fang@nxp.com>
 <703b0c990f4c7b7db8496cb397fdc6dbccdc1c67.camel@redhat.com>
In-Reply-To: <703b0c990f4c7b7db8496cb397fdc6dbccdc1c67.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 827503ac-058d-48d2-ef4a-08da8c87adff
x-ms-traffictypediagnostic: DBBPR04MB6187:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kJE3TSRBQpGV2Jwf5DmscO1vmE6rDFfuoftxVNN/wUxe4bjjr/QkRryOU3rg+8kCVr6ZZGcixnhXcQHs7K24W1UwauAkbEtyZQICKR/dio1jqxeEqysCd1yz2I7mnlpuxlRAxyaRkesl8HxACcHnU+xv3jl7Qk6Xl+t2C2XJyN7jJcOGYsWNBk5j7OTnK+eA51ty7gYvgO7HbLqTvfH/09/B4wrj/9HTGRl5VIzI57RDIccvftUCWX4++HnquMNfQq6q+wloUN1yW5C+f08BLX2l9l+13SzZ7dO7QXC4XJPjtI5lWawb3g0ZAUuGOzZtldR5XK72PfLid7clBtNY48mOXUbMM6xA3LUakALzmS3sJPUo8JqumqHwk6ruQ/1gHzBskBx52ZwPiiACFXAPnWez/czo32Cpny5sb5tuLFW53gI++ITDR+1bg+ghGO3OWtK8LBcMyZH3VpXvMfDVjQmppuhj6QEg6JwkHuX2f+Rcjb7tNTkbr7FKzeQ6sj9RSjsyTyPKTJo4QDgiWDyWpoYKmkEZBeKHtV3L3bM7tpQJcrYu9fG0sjAK7ex+KWyV1HKgpzp7GVUN8KWdx6eVYvEMiF5bp/R5yH7pAkz9rH/FDFTYCW1a+eRW+rp6fX7xQBdLrQpP0oiLMidrTVvJrd0QKIRXGQ/h04v4SAQopDGO6kfO1pyL1sieslLN7JybHy1o5N8sSNEoV8Qp4huQCNFmpayIusJw2PnkESSDoppLXeJ6Y0fJ93+BiIAsTjFtY20x04NzlvRRI5uYyMlWm4OV6qMULug1DK+yH4/GRPs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(110136005)(54906003)(478600001)(66556008)(66946007)(66446008)(71200400001)(186003)(66476007)(8676002)(4326008)(76116006)(316002)(64756008)(5660300002)(38070700005)(8936002)(52536014)(41300700001)(86362001)(7696005)(44832011)(38100700002)(2906002)(53546011)(6506007)(122000001)(26005)(55016003)(83380400001)(33656002)(9686003)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NE1HYzh5YmIvTVBpZGZnRmpoMmx4VkRWVGprV3E1bFBLVndiaERtK3pENWVD?=
 =?utf-8?B?TkNHeG5WZ1RtZTR2VTg5aGV4Y3k5R01ld2VjUjNzZGNiRUYwVElyOVFtNkgv?=
 =?utf-8?B?aHJVQzlQZ0dEOCtVT0tyV1BlVWtJVTBrRUNWazY0NVhqT0hsMVNEekNOVDkx?=
 =?utf-8?B?M0wyaDY4Q0hpS0dRTEVJb09RTUJjTUp4T1dMVWVDcEdtZ2hVRmVBalZoV2NR?=
 =?utf-8?B?Uzk0ZjdqcWptY1V3NU1ObWhtK1E3MHNKY2w2VlZFS1h1d2hPdk1tOG9TQU82?=
 =?utf-8?B?OU5HNld3VmowTFc5eEdEY1pmZjRWbUI3RXZQanVmdEZ6QzNFSHA1SjhaOU9u?=
 =?utf-8?B?TURhMjdrMVJjdWxKZit2dFg1YWx3S00xY3RUSytiNE9rTUhMV29GeXZJNU5C?=
 =?utf-8?B?V1FmTVhxdnZHOWhEMytIbCthQWpvUXo1VzcrY05jUmtJVzd4dFBtbFZ0a21Q?=
 =?utf-8?B?TnFvcThBOVFINlpkYnZlTjJ0Mk9EV2hSK0huOTVwR2t3ZjI3dVF5Tm9mbmk3?=
 =?utf-8?B?U2lUYTRhN3A2bW9nZFE5WUJ6ZzQwRitpV0o5eEM5cDhudjI3b2QrNmd3aGJ2?=
 =?utf-8?B?V1djUTJpTXdqaHFPbGhMbm1xeU96VVFmcUJjNGxWSHlNSlNFWXA3N3hOOVVj?=
 =?utf-8?B?K1l4ZzFlamdTRWtNUmtsYUw4b0lkMW14SXlENDlob01uVnFTM21HQ0srejJB?=
 =?utf-8?B?YlhQNVZ3YXpiSDFxQXM3ck91NWg4VWliSFhYMWRHaEJ6NWpCYXErcTFLODRu?=
 =?utf-8?B?R0FWenJRNVRVZ0Z6Q2ZXbExBNkFXclQ3dTBsZGdNSS9BYisvQjZ1YzRCNEZr?=
 =?utf-8?B?U1Via2w4bWt5c0VsV1RuMXIxSzZCbjJnazZmWU95eE1tOHV5S1ZVRzY3WDAw?=
 =?utf-8?B?cGFwYmh6NklFTXR4dWlyVHBVUHZPVllWNGZKM0ordC80dzRVeEQrbDh5NTZz?=
 =?utf-8?B?aDR4TVNYM2NxRVBxem9LYlZ5RkV5QTd5NXBNWEFzN3ozWG9zUkRXVFEyMVd4?=
 =?utf-8?B?cGtVYjNzQTFQOHNhT2tsVE1DdjluL3Y5Z3pWYkxUcTdIWkZYczhlcEhYZTVM?=
 =?utf-8?B?bjJ4SW1sRG12WDNYaUJ1VE1LRlJ6R3RzZVBnVGlPWlEyMTdEODllK3FvcHdJ?=
 =?utf-8?B?azlJQ3FtcUFKUENoT1FYejlVaFY4dXdOeDBJR0ZqbEZRd2NiY1JFeXNTMlNF?=
 =?utf-8?B?R0VoSHMzd01pb1FZRDRVNVd6MXk5L0hqRkRPUHBjUFJ5bFNDcnJ0VVduNlcv?=
 =?utf-8?B?RjJKenlLekFCT0R0TE9OaXlZTDBDWm1JbXlNdFNxSC82M2FlVjNnWUhEWDc2?=
 =?utf-8?B?TFN1eWNCRXlSSW1BeWxQVU45dk9PUmNOMGhBeWhRQk5nNEJVK2Q0TlpQQjdw?=
 =?utf-8?B?T2tKazdtNmdYcTRmYVZjZWR6b1BnQyswQVFaWFN4cDFQcG91bVRRTkp6ZklY?=
 =?utf-8?B?bEJ6eFBkcE8yOExkUkxXY1JLUi81Ni9aT0lGdldGcHdlL1ZuVDA0bjdWM2U2?=
 =?utf-8?B?VVp3d2w3VkJEcjdySmxnTDFpWkdNa2lxVFYyVTlPS1g3MXdiVmZUSHpVOTEx?=
 =?utf-8?B?RC9HUUlyTnpLeVRCdVhBd1laK3Y0aFlNS1B3MmF0c0dhQUpnVlpKWG9obWtR?=
 =?utf-8?B?T2xaMzAvU3U2VEN2MEQzVHNaMFRZSXM1L1lFaGpYSTdPdUhjSnRKNGtLM01j?=
 =?utf-8?B?M1NvR2g3WHAvNWNWRWlBazIxZmxhaWJGYTZpdXdyV0xDSFBUT251c2JUQXU3?=
 =?utf-8?B?VjlkUjB3ZXVTcmtNdzg4VnVGTndyQnBzc0REbi9tM042VkpLKzl3V2ZsaEQ4?=
 =?utf-8?B?QWV3OTN6VjZzNlVFdUVrMFRlSXhkYi96VFFya015MUViYXNZOWFUbElHRmVr?=
 =?utf-8?B?VjhnbncvRkVtRko0bHJQdEFLRisvU2JpemN1YUFYdjI4K2FZcFArYWJmSGhl?=
 =?utf-8?B?Qlh5ZmVwRi9oK3RNYm4ycTZJYWJRc2s2SjdkUFlwL1lhb1RVcGNPQllSdXVB?=
 =?utf-8?B?K1ZOdXV0RUpXZ25HOWxRRFRseHNLUEt6QkRGQ2pzZzF5TmtIVFpySGJUZ25E?=
 =?utf-8?B?MjRSVWRwSUtZZWx1UG9OQWVQV1NKM0hhMjlTRERkanI3SDZSdklUeThmTUVL?=
 =?utf-8?Q?PuRc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 827503ac-058d-48d2-ef4a-08da8c87adff
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 02:05:59.3426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1vNZQaej7Pz+mjlK7iZKJhD5OqRgb9IC/tLkKTMuGIjACDod0F6K+pFhNFSVgxVpg8nw6phsqkJcjwXzYWigbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6187
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQWJlbmkgPHBh
YmVuaUByZWRoYXQuY29tPg0KPiBTZW50OiAyMDIy5bm0OeaciDHml6UgMTU6MTgNCj4gVG86IFdl
aSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gZWR1bWF6
ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
bmV0XSBuZXQ6IGZlYzogYWRkIHBtX3FvcyBzdXBwb3J0IG9uIGlteDZxIHBsYXRmb3JtDQo+IA0K
PiBPbiBUdWUsIDIwMjItMDgtMzAgYXQgMTU6MDEgKzA4MDAsIHdlaS5mYW5nQG54cC5jb20gd3Jv
dGU6DQo+ID4gRnJvbTogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQo+ID4NCj4gPiBUaGVy
ZSBpcyBhIHZlcnkgbG93IHByb2JhYmlsaXR5IHRoYXQgdHggdGltZW91dCB3aWxsIG9jY3VyIGR1
cmluZw0KPiA+IHN1c3BlbmQgYW5kIHJlc3VtZSBzdHJlc3MgdGVzdCBvbiBpbXg2cSBwbGF0Zm9y
bS4gU28gd2UgYWRkIHBtX3Fvcw0KPiA+IHN1cHBvcnQgdG8gcHJldmVudCBzeXN0ZW0gZnJvbSBl
bnRlcmluZyBsb3cgbGV2ZWwgaWRsZXMgd2hpY2ggbWF5DQo+ID4gYWZmZWN0IHRoZSB0cmFuc21p
c3Npb24gb2YgdHguDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBXZWkgRmFuZyA8d2VpLmZhbmdA
bnhwLmNvbT4NCj4gDQo+IFNpbmNlIHRoaXMgSU1ITyBjYXVzZXMgYSBzaWduaWZpY2FsIGJlaGF2
aW9yIGNoYW5nZSBJIHN1Z2dlc3QgdG8gdGFyZ2V0IHRoZQ0KPiBuZXQtbmV4dCB0cmVlLCBkb2Vz
IHRoYXQgZml0IHlvdT8NCj4gDQpJbiBteSBvcGluaW9uLCB0aGUgcGF0Y2ggaXMgdG8gZml4IGEg
YnVnIHJhdGhlciB0aGFuIGFkZCBhIG5ldyBmZWF0dXJlLCBzbyBJIHRoaW5rDQppdCBzaG91bGQg
YmUgbmV0IHRyZWUuIEJ1dCBpdCdzIGZpbmUgdGhhdCBpZiB0aGUgbWFqb3JpdHkgdGhpbmsgdGhl
IG5ldC1uZXh0IGlzIG1vcmUgDQpzdWl0YWJsZS4NCg0KPiBBZGRpdGlvbmFsbHksIGl0IHdvdWxk
IGJlIGdyZWF0IGlmIHlvdSBjb3VsZCBwcm92aWRlIGluIHRoZSBjaGFuZ2Vsb2cgdGhlDQo+IHJl
ZmVyZW5jZXMgdG8gdGhlIHJlbGV2YW50IHBsYXRmb3JtIGRvY3VtZW50YXRpb24gYW5kIChldmVu
IHJvdWdoKSBwb3dlcg0KPiBjb25zdW1wdGlvbiBkZWx0YSBlc3RpbWF0ZXMuDQo+IA0KDQo=
