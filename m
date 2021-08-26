Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213A53F8A44
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 16:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242755AbhHZOkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 10:40:46 -0400
Received: from mx0a-0038a201.pphosted.com ([148.163.133.79]:26114 "EHLO
        mx0a-0038a201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231458AbhHZOkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 10:40:45 -0400
X-Greylist: delayed 789 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Aug 2021 10:40:45 EDT
Received: from pps.filterd (m0171340.ppops.net [127.0.0.1])
        by mx0a-0038a201.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17QDoRj0026299;
        Thu, 26 Aug 2021 14:26:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0038a201.pphosted.com with ESMTP id 3anuv2shwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 14:26:44 +0000
Received: from m0171340.ppops.net (m0171340.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17QEQiSn028686;
        Thu, 26 Aug 2021 14:26:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-0038a201.pphosted.com with ESMTP id 3anuv2shwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 14:26:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qqc3dZ4oYBKNrVfajYZsPL91sU97+hGaOaS1FXVxgMo/qXdTEygJZyRVpMeV0mqNidFOuprGPpFw+8QsuDFHBnM4XQbrTdqs1ztQCoQ8MZDWgikXOOfrHUAaikDwgnx+d1YW8Zc/wYi0Ukm2bfamf/ScKpwB2EcpJSyvk+deoEvfKecuNDsbDDoow64ZTWzGd1v/t1rVNe46kAEABIIIuzVmlRUAfe+Ul3lhmA27yE0NU1LUJoiG7aLXIHbYV3N63TK0ehdYqoKMtHX96E8jJMTLxSzrGZ9Ik6dF+UrTBRzRBJplAf5T4gH4fA7J8JwJ5FGDseNFrxJ+as2Nfz4sdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7Za68dTG/f7h/yJd+seUjXMDkJHiSIIgEccrkGWpik=;
 b=CSSn03djaQ6oL1UuvgPre6I2TRh7iJi59yOgSeD7o989gCu7adEb0bjXH2qwCljMkGth6Q+VEYBCC4MorSb7s01FBper+HyU0ac8IYt2Wte60PUOKjelYsOWEu+d0eDhLck9II2ilDN4fK5CmGFqZU63QylOb3djJe9xm5ytPcB66TktjnI4b2P7GxIGQh4YSIImynopTuo5e5mnkv9asyEFWsjUfI9vgyPlvR+/u+kQdRvI/TJ9aEDIwDsNIIgQhZNagYxXB8PJ1UIY4kGRFfw/3YiPilZh2g+oj0u05gGf6Wc0QLUrei/1e23wjxkFsrL2onsTnRWctRyMR1WaGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jumptrading.com; dmarc=pass action=none
 header.from=jumptrading.com; dkim=pass header.d=jumptrading.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jumptrading.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7Za68dTG/f7h/yJd+seUjXMDkJHiSIIgEccrkGWpik=;
 b=fAeaHS8vKL6SkdEg1C8iAa12Vdy3zVXWy/ey2PtJx/2LeOHzh7phQGNMFosLn9rrkX3cWLo76TgQxNk+1V0Qsbwc0tQ53kr0rlZGTub1XBKC1/5V6AJJAXrGwy6hxRRFpaMGE+2caEOkr7OVzwxMFZTOSf6ESLxpANam6AbQWYE=
Received: from MW4PR14MB4796.namprd14.prod.outlook.com (2603:10b6:303:109::19)
 by MWHPR14MB1614.namprd14.prod.outlook.com (2603:10b6:300:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 26 Aug
 2021 14:26:41 +0000
Received: from MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::ac34:c9bf:9730:5563]) by MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::ac34:c9bf:9730:5563%6]) with mapi id 15.20.4436.027; Thu, 26 Aug 2021
 14:26:41 +0000
From:   PJ Waskiewicz <pwaskiewicz@jumptrading.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        PJ Waskiewicz <pjwaskiewicz@gmail.com>
Subject: RE: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Topic: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Index: AQHXmebDEXT4AQXD9EOuR3kqIbOYgauFbf+AgABpNUA=
Date:   Thu, 26 Aug 2021 14:26:41 +0000
Message-ID: <MW4PR14MB47964089AAC74D802220F462A1C79@MW4PR14MB4796.namprd14.prod.outlook.com>
References: <20210825192321.32784-1-pwaskiewicz@jumptrading.com>
 <20210826080349.GA32032@ranger.igk.intel.com>
In-Reply-To: <20210826080349.GA32032@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=jumptrading.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 964c141f-ffb8-41c1-a628-08d9689d8602
x-ms-traffictypediagnostic: MWHPR14MB1614:
x-microsoft-antispam-prvs: <MWHPR14MB1614F10E9BBFB567CD430D19A1C79@MWHPR14MB1614.namprd14.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xLfhjlP2UCK7MPtqOLJRo+8MUZSW+kPppKEBqUEOZ9sW9eTiMGfNR6nj7j1NobHC366TEgzWD7SgKgqg+Ks1rnFCeHygdRRTCXS0HgmEaTEt1RrwKx2OQODbjvnmHMkNpG4rxl6enQ7xYnaEfjf8TuNYdEkiqpS1iUAogJOo5jftbm/nMzQVmT5qWadSEK7eTo4nJ9S0EbhlNp+YPuBFkxxN0NiswEGlyIK3hj0DtsqlTTITDUcNzenvOVpGRIa7ruoBFEKXqY0fr/FTP7oDvUtWZlMXJb/dXAfMyhGvoSm/lPkJMQq3bvVD2w6d6hrH+fEyE9pUtTp30FAWjkvCNtyCZt+UJ5N0vCJXjIuc4SiUALk75OOxDaT6ZFbwmC+Uu40jR7Eab+n8leoabzFoDYakCWIkRvJUXYXtfoVvzdh5eW+A7R9f5qzZeo7JLwl2SD1KRSA19JkGReKzLehxqA1ASSFdoti0Rw3oVm2l2z8Hf1eKKGB6ejRdIzdjdrjrO4G72Je1Rsh6pI5+n+YCVJT8YA92BuglZ6AokC3pAjpmuILhseo6uB5/xVt4hsBeOWaXfpG5a011y3kvx0gmsM7bc/EfFiEz211GI1rx4bVe8VLLdK1uVsWf1xDnlcnSC2FKvH1ZqxXTVX5KKZ7z4TwLP/8BgVdIOE4v3WNE/HZYNyzd2VCNYUv6KYT8l5/wCfD9MX8vLdq0XUQfjiWNFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR14MB4796.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(6916009)(6506007)(52536014)(53546011)(478600001)(5660300002)(54906003)(26005)(33656002)(71200400001)(186003)(8936002)(2906002)(9686003)(4326008)(122000001)(38100700002)(83380400001)(86362001)(316002)(66946007)(38070700005)(66476007)(76116006)(66556008)(55016002)(66446008)(7696005)(8676002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T202UVNwNXRoZkNtWDF0dlhJWkpVenAwaXhPbnE3NUNGcWtuWTVxOUlrTWVC?=
 =?utf-8?B?TGdDTlQxN1V2UTBPT3NIaTVNUStvMVlXbDhzTU94WkFsNlp6czFCOG40cVl4?=
 =?utf-8?B?amlXT0VCRExGRUsweEhVcDR3YXhoajhnT0pvYkJvcjdWS09rQTBnSVNRTWdN?=
 =?utf-8?B?QUUxaEVNZHZqcGc2OVQzQzJmTTF4MXFzVy8rOFFDQ0VRcnVTTFhCTXYxSmxw?=
 =?utf-8?B?bUFEVzJaZjdNZzg4eVMyYTJVSCs1WUYxNEhwaUNnbHhQZ1FxNXZxWkZaRHdF?=
 =?utf-8?B?bnI1NWNIL1dJMXg5RWtRSXN3eCtKU2llSVBTOHpFamdyRXVrd2prQXNDYjN3?=
 =?utf-8?B?MmlWdFU1VG1lUWwwbUtZV0lmNDVieXhrMlpjM0Y4UlcvaUNzRkdBU3F0YWNr?=
 =?utf-8?B?SHQ1TUZwNW9laVEveUJaQlpidW5iTFhpWWNqTWF1RE5nbytaUmxibXY1YUdP?=
 =?utf-8?B?VEQyTm5INXdWa2Zmd2VzeVMzMUtZVUV0N3pkSExMTzg3eEc3ekpydENJZHYv?=
 =?utf-8?B?OHJPaVJNbHo1dGJvMGw4MFdWR2FNejZTeFZlNnFnbnFQNVV4em1PV2VoN0cy?=
 =?utf-8?B?QXJUQXZoTVRsZDhOZ3UrUTlIZ3RINlBacE9jRFRDVjFFWlM5c3JyL245ZmVF?=
 =?utf-8?B?QlphbjMwZ29CQkxYZjJzMVZRdzRFejRoM2RZbmxKMzNwOSsvTmVPSjkxU0xB?=
 =?utf-8?B?d0U3aytkTS9LSmpOdmZ3ZWIxYklrVXFZVDNYaWs0TE9GbG1pdEtGQ2dXU1g5?=
 =?utf-8?B?UzlVakhXZHd5VEcvQ0tqS1VXUE1jUXQrZG43YWNyWndndU93dzROTklJTmFk?=
 =?utf-8?B?MDM3ck8yMTkvKzlFSXp3WVF5eXk5QklxaUJxOG14dElMRksrWW5Pc1lXeDZ1?=
 =?utf-8?B?bTdHQm43RnZXcTRuQkdVSmx3WEpFcURRR1NWbmp1V2pYVENIYk1TVTlIL3h5?=
 =?utf-8?B?aUZha1hzRk8zK0hFQ1ROczBMQU42RUpBTkhxTDh0SUM5eTFDUGZLWUoxRS9M?=
 =?utf-8?B?UWVsQktuSnl6dExpR3gwN29xNW0rY1hCVlh4a2xOem1WNmxqRjRiUWhSMzN4?=
 =?utf-8?B?Mm5oTk1JZ3hnaUtXd2taNHBvN1kyS2JWdmdhUW93TjcrNEdGT0ZxTXdmNXJh?=
 =?utf-8?B?ZmhIVTJXVDZWRjZyZjZUUUpJUFZlYzF6MCtrZmU0WWFqVUZoK1cyRGJBL0ZD?=
 =?utf-8?B?eElCZzltenFFZEt1RUlHUjlneEI1ekFqeDJCUEFHT3ZTNE1nQ0tyQjR2YlF5?=
 =?utf-8?B?T1RXU0ZoamhacWRvc1ZrSDhWUFNpcXJxSWs0ZkkvdStoL3N1R3VxWWovdjVl?=
 =?utf-8?B?ZHJHZmlzRmpNb3hxN2RFczFFdHAxamdTT21EdWdVOUZvZ1RPMDVTQS9MRDE0?=
 =?utf-8?B?cGFmODdsK1FNdkszTVpSTkl2UHFaVGxzK0h0cG0vUGlmT0VhdmFHUkVqRitG?=
 =?utf-8?B?eDViZHZWMU5CY3JMWldJbkJENnkwYmpuLzhsbGtOYlhMQWNhRVdEajhjbEhT?=
 =?utf-8?B?OUI5ZmFyRGJYNHl3QjZtRjYzblFRL3l2cU52RXhPbWNuSEpLZ1BIZ3B5Y0dV?=
 =?utf-8?B?dm1mUU53T0hIQ0d2NFE0Vm1WQVBuMnJNVUZLdUxhaFBDZFNmbWVIcEpXVXhV?=
 =?utf-8?B?aFdqTE04a3JvUklOaVlPRzJGNk5vS0JJZ2x6d3pkS2VDcXJwR0k1QlNFemQ2?=
 =?utf-8?B?UjF5Q3krRUQvbXJBVW83YUxHaDUvNDBxQXBrY0NFOHZUVElDcU50OU56RVhs?=
 =?utf-8?Q?7tlRdxBO3Va3Kfkv1C5OJTBG/5Awx3SLId6ePMi?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jumptrading.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR14MB4796.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964c141f-ffb8-41c1-a628-08d9689d8602
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 14:26:41.5228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 11f2af73-8873-4240-85a3-063ce66fc61c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 10yCA8h9z3EXc9VKhbGGYKMBTZCnp4AqogZKNs3Co0txq+znZZcXWSiYzU19tYNI5Lh31uPZIV6SsmpP/1rm2R9RTWAg7c19UULwnc5Io8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR14MB1614
X-Proofpoint-GUID: yT6Wk3JjTafAjD8ArtfhmlZWfmS5E6qq
X-Proofpoint-ORIG-GUID: -OjjUEuFfheDz2Fn6PK9occnG7Oog8Ys
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-26_04,2021-08-26_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108260085
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYWNpZWogRmlqYWxrb3dza2kg
PG1hY2llai5maWphbGtvd3NraUBpbnRlbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3Qg
MjYsIDIwMjEgMTowNCBBTQ0KPiBUbzogUEogV2Fza2lld2ljeiA8cHdhc2tpZXdpY3pAanVtcHRy
YWRpbmcuY29tPg0KPiBDYzogRGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47
IEplc3NlIEJyYW5kZWJ1cmcNCj4gPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgaW50ZWwtd2lyZWQtDQo+IGxhbkBsaXN0cy5vc3Vvc2wub3JnOyBQ
SiBXYXNraWV3aWN6IDxwandhc2tpZXdpY3pAZ21haWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIDEvMV0gaTQwZTogQXZvaWQgZG91YmxlIElSUSBmcmVlIG9uIGVycm9yIHBhdGggaW4gcHJv
YmUoKQ0KPg0KPiBUaGlzIG1lc3NhZ2UgaGFzIG9yaWdpbmF0ZWQgZnJvbSBhbiBFWFRFUk5BTCBT
RU5ERVINCj4NCj4gT24gV2VkLCBBdWcgMjUsIDIwMjEgYXQgMDI6MjM6MjFQTSAtMDUwMCwgUEog
V2Fza2lld2ljeiB3cm90ZToNCj4gPiBUaGlzIGZpeGVzIGFuIGVycm9yIHBhdGggY29uZGl0aW9u
IHdoZW4gcHJvYmUoKSBmYWlscyBkdWUgdG8gdGhlDQo+ID4gZGVmYXVsdCBWU0kgbm90IGJlaW5n
IGF2YWlsYWJsZSBvciBvbmxpbmUgeWV0IGluIHRoZSBmaXJtd2FyZS4gSWYgdGhhdA0KPiA+IGhh
cHBlbnMsIHRoZSBwcmV2aW91cyB0ZWFyZG93biBwYXRoIHdvdWxkIGNsZWFyIHRoZSBpbnRlcnJ1
cHQgc2NoZW1lLA0KPiA+IHdoaWNoIGFsc28gZnJlZWQgdGhlIElSUXMgd2l0aCB0aGUgT1MuIFRo
ZW4gdGhlIGVycm9yIHBhdGggZm9yIHRoZQ0KPiA+IHN3aXRjaCBzZXR1cCAocHJlLVZTSSkgd291
bGQgYXR0ZW1wdCB0byBmcmVlIHRoZSBPUyBJUlFzIGFzIHdlbGwuDQo+DQo+IE5pY2UgdG8gaGVh
ciBmcm9tIHlvdSBQSi4NCj4gTG9va3MgbGlrZSBhICduZXQnIGNhbmRpZGF0ZSwgc28gd2UgbmVl
ZCBhIEZpeGVzOiB0YWcuDQoNCkxpa2V3aXNlLCBuaWNlIHRvIGJlIHN1Ym1pdHRpbmcgcGF0Y2hl
cyBhZ2Fpbi4NCg0KSSdsbCByZXNwaW4gYW5kIHNlbmQgdG8gbmV0Lg0KDQo+IEFsc28sIHlvdSBw
cm9iYWJseSBzaG91bGQgc2VuZCBpdCB0byBpd2wgd2l0aCBjYyB0byBuZXRkZXYgYW5kIFRvbnkg
d2lsbCBwaWNrDQo+IGFuZCBjb21iaW5lIGl0IGludG8gaGlzIHB1bGwgcmVxdWVzdC4NCg0KUm9n
ZXIgdGhhdCwgSSdsbCByZWFycmFuZ2UgdGhlIFRvOiBhbmQgQ2M6IG1lbWJlcnMuDQoNCj4gUGF0
Y2ggTEdUTS4NCj4gUmV2aWV3ZWQtYnk6IE1hY2llaiBGaWphbGtvd3NraSA8bWFjaWVqLmZpamFs
a293c2tpQGludGVsLmNvbT4NCg0KVGhhbmtzLg0KDQpbLi4uc25pcC4uLl0NCg0KPiA+IEBAIC00
ODY1LDcgKzQ4NjUsOCBAQCBzdGF0aWMgdm9pZCBpNDBlX3Jlc2V0X2ludGVycnVwdF9jYXBhYmls
aXR5KHN0cnVjdA0KPiBpNDBlX3BmICpwZikNCj4gPiAgICogQHBmOiBib2FyZCBwcml2YXRlIHN0
cnVjdHVyZQ0KPiA+ICAgKg0KPiA+ICAgKiBXZSBnbyB0aHJvdWdoIGFuZCBjbGVhciBpbnRlcnJ1
cHQgc3BlY2lmaWMgcmVzb3VyY2VzIGFuZCByZXNldCB0aGUNCj4gPiBzdHJ1Y3R1cmUNCj4gPiAt
ICogdG8gcHJlLWxvYWQgY29uZGl0aW9ucw0KPiA+ICsgKiB0byBwcmUtbG9hZCBjb25kaXRpb25z
LiAgT1MgaW50ZXJydXB0IHRlYXJkb3duIG11c3QgYmUgZG9uZQ0KPiA+ICsgc2VwYXJhdGVseSBk
dWUNCj4gPiArICogdG8gVlNJIHZzLiBQRiBpbnN0YW50aWF0aW9uLCBhbmQgZGlmZmVyZW50IHRl
YXJkb3duIHBhdGggcmVxdWlyZW1lbnRzLg0KPg0KPiBTbWFsbCBuaXQ6IG5vIG5lZWQgZm9yIGEg
ZG90IGluICd2cy4nID8NCg0KQXBwYXJlbnRseSB0aGlzIGlzIGRpZmZlcmVudCBiZXR3ZWVuIEJy
aXRpc2ggRW5nbGlzaCBhbmQgQW1lcmljYW4gRW5nbGlzaCAobm8gZG90IGluIHRoZSBmb3JtZXIp
LiAgV2hvIHdvdWxkIGhhdmUgdGhvdWdodC4uLkknbGwgdXBkYXRlIGFuZCBkcm9wIHRoZSAnLicu
DQoNCj4gPiAgICoqLw0KPiA+ICBzdGF0aWMgdm9pZCBpNDBlX2NsZWFyX2ludGVycnVwdF9zY2hl
bWUoc3RydWN0IGk0MGVfcGYgKnBmKSAgeyBAQA0KPiA+IC00ODgwLDcgKzQ4ODEsNiBAQCBzdGF0
aWMgdm9pZCBpNDBlX2NsZWFyX2ludGVycnVwdF9zY2hlbWUoc3RydWN0DQo+IGk0MGVfcGYgKnBm
KQ0KPiA+ICAgICAgICAgZm9yIChpID0gMDsgaSA8IHBmLT5udW1fYWxsb2NfdnNpOyBpKyspDQo+
ID4gICAgICAgICAgICAgICAgIGlmIChwZi0+dnNpW2ldKQ0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgIGk0MGVfdnNpX2ZyZWVfcV92ZWN0b3JzKHBmLT52c2lbaV0pOw0KPiA+IC0gICAgICAg
aTQwZV9yZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eShwZik7DQo+ID4gIH0NCj4gPg0KPiA+ICAv
KioNCj4gPiBAQCAtMTA1MjYsNiArMTA1MjYsNyBAQCBzdGF0aWMgdm9pZCBpNDBlX3JlYnVpbGQo
c3RydWN0IGk0MGVfcGYgKnBmLCBib29sDQo+IHJlaW5pdCwgYm9vbCBsb2NrX2FjcXVpcmVkKQ0K
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAqLw0KPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgIGZyZWVfaXJxKHBmLT5wZGV2LT5pcnEsIHBmKTsNCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICBpNDBlX2NsZWFyX2ludGVycnVwdF9zY2hlbWUocGYpOw0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgIGk0MGVfcmVzZXRfaW50ZXJydXB0X2NhcGFiaWxpdHkocGYpOw0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgIGlmIChpNDBlX3Jlc3RvcmVfaW50ZXJydXB0X3NjaGVtZShwZikp
DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGVuZF91bmxvY2s7DQo+
ID4gICAgICAgICAgICAgICAgIH0NCj4gPiBAQCAtMTU5MjgsNiArMTU5MjksNyBAQCBzdGF0aWMg
dm9pZCBpNDBlX3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqcGRldikNCj4gPiAgICAgICAgIC8qIENs
ZWFyIGFsbCBkeW5hbWljIG1lbW9yeSBsaXN0cyBvZiByaW5ncywgcV92ZWN0b3JzLCBhbmQgVlNJ
cyAqLw0KPiA+ICAgICAgICAgcnRubF9sb2NrKCk7DQo+ID4gICAgICAgICBpNDBlX2NsZWFyX2lu
dGVycnVwdF9zY2hlbWUocGYpOw0KPiA+ICsgICAgICAgaTQwZV9yZXNldF9pbnRlcnJ1cHRfY2Fw
YWJpbGl0eShwZik7DQo+ID4gICAgICAgICBmb3IgKGkgPSAwOyBpIDwgcGYtPm51bV9hbGxvY192
c2k7IGkrKykgew0KPiA+ICAgICAgICAgICAgICAgICBpZiAocGYtPnZzaVtpXSkgew0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgIGlmICghdGVzdF9iaXQoX19JNDBFX1JFQ09WRVJZX01PREUs
DQo+ID4gcGYtPnN0YXRlKSkgQEAgLTE2MTUwLDYgKzE2MTUyLDcgQEAgc3RhdGljIHZvaWQgaTQw
ZV9zaHV0ZG93bihzdHJ1Y3QNCj4gcGNpX2RldiAqcGRldikNCj4gPiAgICAgICAgICAqLw0KPiA+
ICAgICAgICAgcnRubF9sb2NrKCk7DQo+ID4gICAgICAgICBpNDBlX2NsZWFyX2ludGVycnVwdF9z
Y2hlbWUocGYpOw0KPiA+ICsgICAgICAgaTQwZV9yZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eShw
Zik7DQo+ID4gICAgICAgICBydG5sX3VubG9jaygpOw0KPiA+DQo+ID4gICAgICAgICBpZiAoc3lz
dGVtX3N0YXRlID09IFNZU1RFTV9QT1dFUl9PRkYpIHsgQEAgLTE2MjAyLDYgKzE2MjA1LDcNCj4g
PiBAQCBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkIGk0MGVfc3VzcGVuZChzdHJ1Y3QgZGV2aWNl
ICpkZXYpDQo+ID4gICAgICAgICAgKiB0byBDUFUwLg0KPiA+ICAgICAgICAgICovDQo+ID4gICAg
ICAgICBpNDBlX2NsZWFyX2ludGVycnVwdF9zY2hlbWUocGYpOw0KPiA+ICsgICAgICAgaTQwZV9y
ZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eShwZik7DQo+ID4NCj4gPiAgICAgICAgIHJ0bmxfdW5s
b2NrKCk7DQo+ID4NCj4gPiAtLQ0KPiA+IDIuMjcuMA0KPiA+DQo+ID4NCj4NCj4gQW5kIHByb2Jh
Ymx5IHRhbGsgdG8geW91ciBJVCBkZXAgdG8gZ2V0IHJpZCBvZiB0aGUgZm9vdGVyIDpQDQoNCkkg
a25vdywgdGhhdCBpcyBzb21ldGhpbmcgSSd2ZSBiZWVuIHdvcmtpbmcgb24uICBOb3Qgc3VyZSBJ
IGhhdmUgbXVjaCBjb250cm9sIG92ZXIgdGhhdCB1bmZvcnR1bmF0ZWx5Lg0KDQotUEoNCg0KPiA+
IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+ID4NCj4gPiBOb3RlOiBUaGlzIGVt
YWlsIGlzIGZvciB0aGUgY29uZmlkZW50aWFsIHVzZSBvZiB0aGUgbmFtZWQgYWRkcmVzc2VlKHMp
IG9ubHkNCj4gYW5kIG1heSBjb250YWluIHByb3ByaWV0YXJ5LCBjb25maWRlbnRpYWwsIG9yIHBy
aXZpbGVnZWQgaW5mb3JtYXRpb24gYW5kL29yDQo+IHBlcnNvbmFsIGRhdGEuIElmIHlvdSBhcmUg
bm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIHlvdSBhcmUgaGVyZWJ5IG5vdGlmaWVkDQo+IHRo
YXQgYW55IHJldmlldywgZGlzc2VtaW5hdGlvbiwgb3IgY29weWluZyBvZiB0aGlzIGVtYWlsIGlz
IHN0cmljdGx5IHByb2hpYml0ZWQsDQo+IGFuZCByZXF1ZXN0ZWQgdG8gbm90aWZ5IHRoZSBzZW5k
ZXIgaW1tZWRpYXRlbHkgYW5kIGRlc3Ryb3kgdGhpcyBlbWFpbCBhbmQNCj4gYW55IGF0dGFjaG1l
bnRzLiBFbWFpbCB0cmFuc21pc3Npb24gY2Fubm90IGJlIGd1YXJhbnRlZWQgdG8gYmUgc2VjdXJl
IG9yDQo+IGVycm9yLWZyZWUuIFRoZSBDb21wYW55LCB0aGVyZWZvcmUsIGRvZXMgbm90IG1ha2Ug
YW55IGd1YXJhbnRlZXMgYXMgdG8NCj4gdGhlIGNvbXBsZXRlbmVzcyBvciBhY2N1cmFjeSBvZiB0
aGlzIGVtYWlsIG9yIGFueSBhdHRhY2htZW50cy4gVGhpcyBlbWFpbCBpcw0KPiBmb3IgaW5mb3Jt
YXRpb25hbCBwdXJwb3NlcyBvbmx5IGFuZCBkb2VzIG5vdCBjb25zdGl0dXRlIGEgcmVjb21tZW5k
YXRpb24sDQo+IG9mZmVyLCByZXF1ZXN0LCBvciBzb2xpY2l0YXRpb24gb2YgYW55IGtpbmQgdG8g
YnV5LCBzZWxsLCBzdWJzY3JpYmUsIHJlZGVlbSwgb3INCj4gcGVyZm9ybSBhbnkgdHlwZSBvZiB0
cmFuc2FjdGlvbiBvZiBhIGZpbmFuY2lhbCBwcm9kdWN0LiBQZXJzb25hbCBkYXRhLCBhcw0KPiBk
ZWZpbmVkIGJ5IGFwcGxpY2FibGUgZGF0YSBwcm90ZWN0aW9uIGFuZCBwcml2YWN5IGxhd3MsIGNv
bnRhaW5lZCBpbiB0aGlzDQo+IGVtYWlsIG1heSBiZSBwcm9jZXNzZWQgYnkgdGhlIENvbXBhbnks
IGFuZCBhbnkgb2YgaXRzIGFmZmlsaWF0ZWQgb3IgcmVsYXRlZA0KPiBjb21wYW5pZXMsIGZvciBs
ZWdhbCwgY29tcGxpYW5jZSwgYW5kL29yIGJ1c2luZXNzLXJlbGF0ZWQgcHVycG9zZXMuIFlvdQ0K
PiBtYXkgaGF2ZSByaWdodHMgcmVnYXJkaW5nIHlvdXIgcGVyc29uYWwgZGF0YTsgZm9yIGluZm9y
bWF0aW9uIG9uIGV4ZXJjaXNpbmcNCj4gdGhlc2UgcmlnaHRzIG9yIHRoZSBDb21wYW554oCZcyB0
cmVhdG1lbnQgb2YgcGVyc29uYWwgZGF0YSwgcGxlYXNlIGVtYWlsDQo+IGRhdGFyZXF1ZXN0c0Bq
dW1wdHJhZGluZy5jb20uDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQoNCk5v
dGU6IFRoaXMgZW1haWwgaXMgZm9yIHRoZSBjb25maWRlbnRpYWwgdXNlIG9mIHRoZSBuYW1lZCBh
ZGRyZXNzZWUocykgb25seSBhbmQgbWF5IGNvbnRhaW4gcHJvcHJpZXRhcnksIGNvbmZpZGVudGlh
bCwgb3IgcHJpdmlsZWdlZCBpbmZvcm1hdGlvbiBhbmQvb3IgcGVyc29uYWwgZGF0YS4gSWYgeW91
IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgeW91IGFyZSBoZXJlYnkgbm90aWZpZWQg
dGhhdCBhbnkgcmV2aWV3LCBkaXNzZW1pbmF0aW9uLCBvciBjb3B5aW5nIG9mIHRoaXMgZW1haWwg
aXMgc3RyaWN0bHkgcHJvaGliaXRlZCwgYW5kIHJlcXVlc3RlZCB0byBub3RpZnkgdGhlIHNlbmRl
ciBpbW1lZGlhdGVseSBhbmQgZGVzdHJveSB0aGlzIGVtYWlsIGFuZCBhbnkgYXR0YWNobWVudHMu
IEVtYWlsIHRyYW5zbWlzc2lvbiBjYW5ub3QgYmUgZ3VhcmFudGVlZCB0byBiZSBzZWN1cmUgb3Ig
ZXJyb3ItZnJlZS4gVGhlIENvbXBhbnksIHRoZXJlZm9yZSwgZG9lcyBub3QgbWFrZSBhbnkgZ3Vh
cmFudGVlcyBhcyB0byB0aGUgY29tcGxldGVuZXNzIG9yIGFjY3VyYWN5IG9mIHRoaXMgZW1haWwg
b3IgYW55IGF0dGFjaG1lbnRzLiBUaGlzIGVtYWlsIGlzIGZvciBpbmZvcm1hdGlvbmFsIHB1cnBv
c2VzIG9ubHkgYW5kIGRvZXMgbm90IGNvbnN0aXR1dGUgYSByZWNvbW1lbmRhdGlvbiwgb2ZmZXIs
IHJlcXVlc3QsIG9yIHNvbGljaXRhdGlvbiBvZiBhbnkga2luZCB0byBidXksIHNlbGwsIHN1YnNj
cmliZSwgcmVkZWVtLCBvciBwZXJmb3JtIGFueSB0eXBlIG9mIHRyYW5zYWN0aW9uIG9mIGEgZmlu
YW5jaWFsIHByb2R1Y3QuIFBlcnNvbmFsIGRhdGEsIGFzIGRlZmluZWQgYnkgYXBwbGljYWJsZSBk
YXRhIHByb3RlY3Rpb24gYW5kIHByaXZhY3kgbGF3cywgY29udGFpbmVkIGluIHRoaXMgZW1haWwg
bWF5IGJlIHByb2Nlc3NlZCBieSB0aGUgQ29tcGFueSwgYW5kIGFueSBvZiBpdHMgYWZmaWxpYXRl
ZCBvciByZWxhdGVkIGNvbXBhbmllcywgZm9yIGxlZ2FsLCBjb21wbGlhbmNlLCBhbmQvb3IgYnVz
aW5lc3MtcmVsYXRlZCBwdXJwb3Nlcy4gWW91IG1heSBoYXZlIHJpZ2h0cyByZWdhcmRpbmcgeW91
ciBwZXJzb25hbCBkYXRhOyBmb3IgaW5mb3JtYXRpb24gb24gZXhlcmNpc2luZyB0aGVzZSByaWdo
dHMgb3IgdGhlIENvbXBhbnnigJlzIHRyZWF0bWVudCBvZiBwZXJzb25hbCBkYXRhLCBwbGVhc2Ug
ZW1haWwgZGF0YXJlcXVlc3RzQGp1bXB0cmFkaW5nLmNvbS4NCg==
