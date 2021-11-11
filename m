Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A9844D81A
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhKKOTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:19:55 -0500
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:28312 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233978AbhKKOTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 09:19:53 -0500
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ABDglEh013055;
        Thu, 11 Nov 2021 06:16:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=YQwgU1cJW8Q1jh5DbQRzKwVFMdc0zR5nUe45QXz6SAM=;
 b=K1d9Fcmqz1Ojux6mR/uOvTGTICAQoeHsJkOVTcTGXbiTcDK2gHD+7bC72itZQwfbYIk+
 sWN0w76Yxxn4l5x1XoAL8EDEePyvqFPACIU1d0gvn6/3ozPl95CnrwDK3V0SgJAoeY3K
 39QXdL9A7uORVlXJ1HV+0uQkkCpr8O/m6Om8oA/l6Ihk2XVbOQ+X3dMH6ALg083/ivJ5
 PHoBnWLGA4IUYe+ZtlL9mrDK+KLiqWhewWQ3W4BNF94WydM3aFN3Q2kn6UbXaVDKnFrs
 vcDb/tcdngnY+KgR6bwfNe1HF5tXMSr4NBktCZP6BhDM7gxo3tNmxsmY6DRp1cFlRPET vg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3c80d3htgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 06:16:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNzRucTrC9AkVAP4RsbKuOL63zq9zJDV+ZcvQ7uNSeWCodKJWu2qZi2NEXQcGeW/c+0hRTU7Re1Zw0F0szDb95doXqtn/22hwRn+kgY9vcKED6u443BVX9A5k+pzyrmFWGDli4x4dwVahDpU6ht1gkNSEsLK1mFXRePkajTTY6L7aNGZVeCWyjlvEhucWx4Gr8vGbwjt2zBy+HHM7PTPGUsxn62ZRSzEhJRxRUp5KzKJtNCyzTjBQoiFdBYs8fIYQrnAisAMchpVOSkMd/Blp0xMkg9A8gs/UUMnWJMFZZHyQGvYF+gpVc8F62A2UXTjZule2l9l+M+2JKGO9fZhyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQwgU1cJW8Q1jh5DbQRzKwVFMdc0zR5nUe45QXz6SAM=;
 b=SMXN6zlV+A1iH6KkkJ/1WemjxGq1RRHQyPPYozZPZzwlFT70Z3l/XCM17oDZdHnHf86aC4VNBpLtihwZ8BGAPY10LZU0HZrDIgIcNI3fEFb+2rpcgCwbWWTyQ7ig8YJ41lLXNDJoHgTNwBM4r38KSsbsXj4LAPyqFH1p6r8WT+2AkHnPBVoPY06KAzTJERn6m1b84mL6K6G+Xb4zyOqaZgVI/ZSyEo5QgBaIa7Q46Z8fEYxSbJN4vXMuf8fqVCGgxxs4cta9f1ysj/6/9xp2NNYIstb039ljMSByT4D5lFA5AHYAx3DmAb4eOJb1G1MmJJsoY293IqmgKhSgHux0qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 14:16:41 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4669.019; Thu, 11 Nov 2021
 14:16:41 +0000
From:   "Li, Meng" <Meng.Li@windriver.com>
To:     Denis Kirjanov <dkirjanov@suse.de>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: stmmac: socfpga: add runtime suspend/resume callback
 for stratix10 platform
Thread-Topic: [PATCH] net: stmmac: socfpga: add runtime suspend/resume
 callback for stratix10 platform
Thread-Index: AQHX1wP5VqdH/2I1IEyufRbZctMzR6v+W1AAgAAA5tA=
Date:   Thu, 11 Nov 2021 14:16:41 +0000
Message-ID: <PH0PR11MB5191582745F77F7D876001ECF1949@PH0PR11MB5191.namprd11.prod.outlook.com>
References: <20211111135630.24996-1-Meng.Li@windriver.com>
 <499952a2-c919-109d-4f0a-fb4db4ead604@suse.de>
In-Reply-To: <499952a2-c919-109d-4f0a-fb4db4ead604@suse.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=windriver.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 670f0010-d321-49b2-d997-08d9a51de1ed
x-ms-traffictypediagnostic: PH0PR11MB5144:
x-microsoft-antispam-prvs: <PH0PR11MB51444F55FBB87F7FFDD06C97F1949@PH0PR11MB5144.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0dBj3YKLYUIg+AUSeuni5MpLzPl9xQrF6Ff8uV2is/5Kmk5AFW5RakTtBpvpmgrTMy5SbBx5h5NQRLXI4TpzrCExkqeUwc/FGLpwBevKgs7wB4o2941za1pn5t0XpmFx+eLU8jRMx1Pgy8LmHYibc0yIeKvStUHYb5g0ZNSt/LwnFVoh3eN/5OZSr5VI8+RPUXdh49fSfoSnfzh7rVoBxT0znrlgGZ+shlhyZS1fwgAKZ9MrQQMq0PlTB1pJgZar/w3RyklaFgOwR1TpJQgpL9eiWPkaHoC2jxaPfiDTaDQogp26D4TIH97Dx6jZp/OQBTBUDpp7BsTwHhZUwlQJX7fNuxXun43hfY+G/51zjNkEx/hgxleZpF/ljlqwAyX3Zm6VefftSeNhNLKDxj/1CSGCH4hwtOt6602uB/nZ2MYC/7y4/DUpk3znIFWy0eRsW1sjyW8D7xbKGJT7Xk+X/fqtTz0rIS3FypJdd4aWHIXriRzueW6bKfmR2iRiMznf8rC94eLnmjiBwuzpOK4CbczZGTcmwqYwb2+W77ctRa0J2L2ZkQliBMYhhHL9J1QQ++p9hnalO/3k3134lmwuaxdw6an5E28BLYw3Cdlg9go5xPlM2vQtkcVvExQTP9ssJpEpR4xWlh8kiubffZl98T7H+OoZaeQWjqJhDVc+B5HKA11fFP4R2wa7s5kY4swzpL/zNMfdPlgeRN7lkcofZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(7696005)(4326008)(86362001)(110136005)(122000001)(55016002)(15650500001)(71200400001)(9686003)(2906002)(52536014)(38100700002)(6506007)(26005)(53546011)(8676002)(186003)(8936002)(76116006)(38070700005)(508600001)(33656002)(66556008)(5660300002)(66476007)(7416002)(64756008)(66446008)(54906003)(316002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnhVVytHenJmVzBZUjl1YTVOR2dhL0MzRlAzTCsyRnV5cEtvS0t5WFphZGdz?=
 =?utf-8?B?SXNYWFVscnczTm9qZkMwdXFtdVRjWTRheHMxK1UwdmxiV1pMQ1VMUmJCaEhG?=
 =?utf-8?B?TGRaYXZqNWMrdTErV1BEdktLVUJRNytySzNPZzY4ZVRsdmtUNnNXWks0bERl?=
 =?utf-8?B?cFJwelBYdTFEcU85TzFSd0VicXcyN0hPTS80dnRDTHJHZ3VwWEFSckllTVho?=
 =?utf-8?B?RmFKVXphWFRDc1dDMXRJZDlDMkQyY0k1WXVEVk5ha3R5R2NWZjRsSTdpZ0RL?=
 =?utf-8?B?bFVQWjVqT3NEUFF1T2UzVDAzdHRkTGJMOVRoOXVnZEZtb3NyMnE4c2ozZjRQ?=
 =?utf-8?B?V1NFb21yOHNuTURraExwSkZ3QWM3bnlTeERqL09EWmFFV3RHS1JaKzMzVktC?=
 =?utf-8?B?Y291WUJHQXd0QjFYUGw5NmtFckNyNkc5QmQ2emJ3MDBwNFBOV2dXcVJpcytV?=
 =?utf-8?B?WjhKRGZFSGRxN3dXelF5VlAyKzFmb29mVTlMUmNpUnNwalh2UDNWZCsyYzhY?=
 =?utf-8?B?UmFaT3E2d0pZTGlJa21jWnoyb1hhSlA4bVI0TUFWTmdlVFJGUEpvL3M3MXls?=
 =?utf-8?B?Q1lKcE1nV2FDZTA0eTJnZWRjS01pU3lJZVoyQzRlbEtCb1cybEhwdGVzR0E0?=
 =?utf-8?B?SDN0Rk9sUUtocytNZmszQ3ZFUW9BQTdRbHMySXFreGh5NG5TaFlveHZFRjR1?=
 =?utf-8?B?cHJZdGFTTFRBc2tZeklMZGs5YXNQRUtBSUlybCt0Vk9id0FkUzlmMFBDSUEx?=
 =?utf-8?B?RC9YQjZ5VGxyQjVCemppeC80VXk1Zkt6T1FUdkpMYWw0d0lGbVVYMFFHdlNo?=
 =?utf-8?B?RUF2ZDY1NExCakMxNVVReUlNREpGWkNKRHJTbEhWNHltcnBBVklWSTdwRjk5?=
 =?utf-8?B?VEt4VSsvdFNZdEtTMGJ4aW45d0N4eThLRDlOd0NQdit5WDJlVmhrOHZBS1Ux?=
 =?utf-8?B?WWRZc3I4YVZXbUZIN0kzekpRSVNkMzhjT0FMM2FpUkZYWC9XVEhFWDlyb1g3?=
 =?utf-8?B?Tkwwa1NqZ3htaGRRa2taVStJUk1VTnhtQzlVeFpiL0JRQmljQlJPT0NpTExt?=
 =?utf-8?B?NUJZN2doZ3JENTU3azQ3dEFIeG5jYjc4dE9zMlZXaU4vZ2NBNllNaDZ1dEM1?=
 =?utf-8?B?L1VqNFdyTVVGVDFRTE84Wk54OGV1YiszWEJIU1ZYcmMxa1pXdndvRW9GTXMv?=
 =?utf-8?B?cEF0eHBJNkFXdXo1OFEwejNpcGpNM3JBeTdKOG8weVJxQzlNSTRWWHlPRWcw?=
 =?utf-8?B?UXZQR2lPdmY4NjVESFQ0TXNEZkM4WWF5RkNpSWxXNER0dWRwNm1OVEw2UnlU?=
 =?utf-8?B?Wld1djFGNmdTVlNYNGo5ZWpUVis3blNwSmdaZ1VRcTZiVzZVd3pIRHA1OEw3?=
 =?utf-8?B?aUkrS1dXd0VvbzF2TnBuK0U2aWJPU1FJUk5LRklkNE5PUENGb1JFdVZRZXNy?=
 =?utf-8?B?UXcrMDRTZjlwN3dsL1NrT3ZLcjJpNUpVcVVudHdHYjdHV3VMNlZsSFFwRlFR?=
 =?utf-8?B?bm1DczhxSzhOT2tZWm1JNHVIVkMwdFpTaG1pOStyU09CbU9TR0c5STBBUTRG?=
 =?utf-8?B?VWJaT3pPV0NXVmxOVEYrV2hZUnA0c1RGZWdqZjBoZGQwaElhbnVlbkNaZmNr?=
 =?utf-8?B?TGtwSG1XRXU2Zzl2REM4ZGtudHMwYlhlSmc5YUk1ejEyamorY3lNbDI0RGJM?=
 =?utf-8?B?d01EcUpYRzdqMC9BdUdnNEFQOHNEWlFuR2krTCtWRm9VbjBUS0RwSVcyZ1ZF?=
 =?utf-8?B?UW9SZDB5cFRnUDJMZHhRVnR2Ti9TbEtuOFd5TFdTNE9CeVpXMXQ1ZkpKblY1?=
 =?utf-8?B?SEIzd0IxckFwM0ZqbHEvYk9LUG9XZ2NETkEzUW83blhEbTVqNnBPRWNWVlZZ?=
 =?utf-8?B?NHVubEFZU0VuSGtlNERYL2d2T3FZclhEVmQvaWNXeTJFd2R0cFFKM3k5SSsw?=
 =?utf-8?B?QVIya3hLbnRDTTYyTHZNczBBYUtDNmdqUzg5VERJSXM3RVMrYk1sWFBTTmh3?=
 =?utf-8?B?bDNpNDgrNUZHZng1dzRRRGdSQjdhMFN3S0pvRmUzaUFJcjFxUENSVXN2d0tt?=
 =?utf-8?B?a0wzYjhFcisvRmUwNTNOU3FiaEVYZVloc08zV1ZQdFhGSWRBamhFQTdUdFAv?=
 =?utf-8?B?QjBONWFVak8yZ3k4bHRIWkxWYzZ0K2FNWWJzQkhlcHhnd2E5NWtsRUwzT2RV?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 670f0010-d321-49b2-d997-08d9a51de1ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 14:16:41.0611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BJdRSWhU1KteUWXArn4JSnQCSpfbE+bbHJc6IBNh6/1l5rZoC6GGqcwzuoEyHKOvjDBcSmWZ9+m4IaxkexCCmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5144
X-Proofpoint-GUID: hzQ7XKcGKTXDh9SwM6YvFNNayh434kbj
X-Proofpoint-ORIG-GUID: hzQ7XKcGKTXDh9SwM6YvFNNayh434kbj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_04,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGVuaXMgS2lyamFub3Yg
PGRraXJqYW5vdkBzdXNlLmRlPg0KPiBTZW50OiBUaHVyc2RheSwgTm92ZW1iZXIgMTEsIDIwMjEg
MTA6MDIgUE0NCj4gVG86IExpLCBNZW5nIDxNZW5nLkxpQHdpbmRyaXZlci5jb20+OyBwZXBwZS5j
YXZhbGxhcm9Ac3QuY29tOw0KPiBhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tOyBqb2FicmV1
QHN5bm9wc3lzLmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBt
Y29xdWVsaW4uc3RtMzJAZ21haWwuY29tDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBs
aW51eC1zdG0zMkBzdC1tZC1tYWlsbWFuLnN0b3JtcmVwbHkuY29tOw0KPiBsaW51eC1hcm0ta2Vy
bmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
U3ViamVjdDogUmU6IFtQQVRDSF0gbmV0OiBzdG1tYWM6IHNvY2ZwZ2E6IGFkZCBydW50aW1lIHN1
c3BlbmQvcmVzdW1lDQo+IGNhbGxiYWNrIGZvciBzdHJhdGl4MTAgcGxhdGZvcm0NCj4gDQo+IFtQ
bGVhc2Ugbm90ZTogVGhpcyBlLW1haWwgaXMgZnJvbSBhbiBFWFRFUk5BTCBlLW1haWwgYWRkcmVz
c10NCj4gDQo+IDExLzExLzIxIDQ6NTYgUE0sIE1lbmcgTGkg0L/QuNGI0LXRgjoNCj4gPiBGcm9t
OiBNZW5nIExpIDxtZW5nLmxpQHdpbmRyaXZlci5jb20+DQo+ID4NCj4gPiBBY2NvcmRpbmcgdG8g
dXBzdHJlYW0gY29tbWl0IDVlYzU1ODIzNDM4ZSgibmV0OiBzdG1tYWM6DQo+ID4gYWRkIGNsb2Nr
cyBtYW5hZ2VtZW50IGZvciBnbWFjIGRyaXZlciAiKSwgaXQgaW1wcm92ZSBjbG9ja3MgbWFuYWdl
bWVudA0KPiA+IGZvciBzdG1tYWMgZHJpdmVyLiBTbywgaXQgaXMgbmVjZXNzYXJ5IHRvIGltcGxl
bWVudCB0aGUgcnVudGltZQ0KPiA+IGNhbGxiYWNrIGluIGR3bWFjLXNvY2ZwZ2EgZHJpdmVyIGJl
Y2F1c2UgaXQgZG9lc27igJl0IHVzZSB0aGUgY29tbW9uDQo+ID4gc3RtbWFjX3BsdGZyX3BtX29w
cyBpbnN0YW5jZS4gT3RoZXJ3aXNlLCBjbG9ja3MgYXJlIG5vdCBkaXNhYmxlZCB3aGVuDQo+ID4g
c3lzdGVtIGVudGVycyBzdXNwZW5kIHN0YXR1cy4NCj4gDQo+IFBsZWFzZSBhZGQgRml4ZXMgdGFn
DQoNClRoYW5rcyBmb3Igc3VnZ2VzdC4NClllcyEgdGhpcyBwYXRjaCBpcyB1c2VkIHRvIGZpeCBh
biBjbG9jayBvcGVyYXRpb24gaXNzdWUgaW4gZHdtYWMtc29jZnBnYSBkcml2ZXIsDQpCdXQgSSBh
bSBub3Qgc3VyZSB3aGljaCBGaXhpbmcgY29tbWl0IElEIEkgc2hvdWxkIHVzZS4NCkJlY2F1c2Ug
NWVjNTU4MjM0MzhlIGJyZWFrcyB0aGUgb3JpZ2luYWwgY2xvY2sgb3BlcmF0aW9uIG9mIGR3bWFj
LXNvY2ZwZ2EgZHJpdmVyLCBidXQgdGhpcyBjb21taXQgNWVjNTU4MjM0MzhlIGlzIG5vdCBhIGJ1
Zy4NCk1vcmVvdmVyLCBpZiB3aXRob3V0IDVlYzU1ODIzNDM4ZSBkd21hYy1zb2NmcGdhIGRyaXZl
ciBhbHNvIHdvcmtzIGZpbmUuDQoNCkhvdyBhYm91dCB5b3VyIHN1Z2dlc3Q/DQoNClRoYW5rcywN
CkxpbWVuZw0KDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBNZW5nIExpIDxNZW5nLkxpQHdpbmRy
aXZlci5jb20+DQo+ID4gLS0tDQo+ID4gICAuLi4vZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdt
YWMtc29jZnBnYS5jICAgfCAyNA0KPiArKysrKysrKysrKysrKysrKy0tDQo+ID4gICAxIGZpbGUg
Y2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYy1zb2NmcGdh
LmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLXNvY2Zw
Z2EuYw0KPiA+IGluZGV4IDg1MjA4MTI4ZjEzNS4uOTNhYmRlNDY3ZGU0IDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLXNvY2ZwZ2EuYw0K
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLXNvY2Zw
Z2EuYw0KPiA+IEBAIC00ODUsOCArNDg1LDI4IEBAIHN0YXRpYyBpbnQgc29jZnBnYV9kd21hY19y
ZXN1bWUoc3RydWN0IGRldmljZQ0KPiAqZGV2KQ0KPiA+ICAgfQ0KPiA+ICAgI2VuZGlmIC8qIENP
TkZJR19QTV9TTEVFUCAqLw0KPiA+DQo+ID4gLXN0YXRpYyBTSU1QTEVfREVWX1BNX09QUyhzb2Nm
cGdhX2R3bWFjX3BtX29wcywgc3RtbWFjX3N1c3BlbmQsDQo+ID4gLSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc29jZnBnYV9kd21hY19yZXN1bWUpOw0KPiA+ICtz
dGF0aWMgaW50IF9fbWF5YmVfdW51c2VkIHNvY2ZwZ2FfZHdtYWNfcnVudGltZV9zdXNwZW5kKHN0
cnVjdA0KPiBkZXZpY2UNCj4gPiArKmRldikgew0KPiA+ICsgICAgIHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2ID0gZGV2X2dldF9kcnZkYXRhKGRldik7DQo+ID4gKyAgICAgc3RydWN0IHN0bW1hY19w
cml2ICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4gKw0KPiA+ICsgICAgIHN0bW1hY19i
dXNfY2xrc19jb25maWcocHJpdiwgZmFsc2UpOw0KPiBjaGVjayB0aGUgcmV0dXJuIHZhbHVlPw0K
PiA+ICsNCj4gPiArICAgICByZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGlu
dCBfX21heWJlX3VudXNlZCBzb2NmcGdhX2R3bWFjX3J1bnRpbWVfcmVzdW1lKHN0cnVjdA0KPiBk
ZXZpY2UNCj4gPiArKmRldikgew0KPiA+ICsgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2ID0g
ZGV2X2dldF9kcnZkYXRhKGRldik7DQo+ID4gKyAgICAgc3RydWN0IHN0bW1hY19wcml2ICpwcml2
ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiBzdG1tYWNfYnVz
X2Nsa3NfY29uZmlnKHByaXYsIHRydWUpOyB9DQo+ID4gKw0KPiA+ICtjb25zdCBzdHJ1Y3QgZGV2
X3BtX29wcyBzb2NmcGdhX2R3bWFjX3BtX29wcyA9IHsNCj4gPiArICAgICBTRVRfU1lTVEVNX1NM
RUVQX1BNX09QUyhzdG1tYWNfc3VzcGVuZCwNCj4gc29jZnBnYV9kd21hY19yZXN1bWUpDQo+ID4g
KyAgICAgU0VUX1JVTlRJTUVfUE1fT1BTKHNvY2ZwZ2FfZHdtYWNfcnVudGltZV9zdXNwZW5kLA0K
PiA+ICtzb2NmcGdhX2R3bWFjX3J1bnRpbWVfcmVzdW1lLCBOVUxMKSB9Ow0KPiA+DQo+ID4gICBz
dGF0aWMgY29uc3Qgc3RydWN0IHNvY2ZwZ2FfZHdtYWNfb3BzIHNvY2ZwZ2FfZ2VuNV9vcHMgPSB7
DQo+ID4gICAgICAgLnNldF9waHlfbW9kZSA9IHNvY2ZwZ2FfZ2VuNV9zZXRfcGh5X21vZGUsDQo+
ID4NCg==
