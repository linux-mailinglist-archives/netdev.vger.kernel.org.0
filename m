Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E794161E1
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241883AbhIWPTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:19:09 -0400
Received: from mx0b-0038a201.pphosted.com ([148.163.137.80]:27580 "EHLO
        mx0b-0038a201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241807AbhIWPTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 11:19:08 -0400
Received: from pps.filterd (m0171341.ppops.net [127.0.0.1])
        by mx0b-0038a201.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18NEBojV013230;
        Thu, 23 Sep 2021 15:17:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0038a201.pphosted.com with ESMTP id 3b8atght1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 15:17:29 +0000
Received: from m0171341.ppops.net (m0171341.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18NF9lm8000400;
        Thu, 23 Sep 2021 15:17:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0b-0038a201.pphosted.com with ESMTP id 3b8atght18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 15:17:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVKH3dIIWcfbE1J9zZFEPnwL7Hw4i+p3q2P3HRoMvrKQt3UHb6boO3uHpKKWswfiDu0IAyUeF66AHdfVAAoXVYJAh6+yXjiRF9zR7B9Bl9kCOvjtKDj//WGlDsL+rSs9FRhaeWsAaTawpvMyCtH+oVRo0ToSkqTXKI8AcnLm/kK7nOYfU+vO3wmrFwH2YdKn64vEBF6WgBD8cJVgAXLYYBiywe+DsLUQD28IU3WOkZ1Y1mq/j8a/VR6XRNd8h7Wf9lE3qjdKrBsItgKfExzneT7vQlJf0U1J1ZeV0sW6OY4A0xL5kCVUS1quVlIWwbaP/wGPD00HO+eF7LM1ebIM5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xnmdU8rzMtEnfe44MHc3rBa4Zcy4Tf/6Xrp1yvaSU8c=;
 b=dag/ChMfrM2+YRgElKBz97b/324GQW4Mf+RuXxzq2EX17k3OxbjSeAivhh/WQPmCtnS4Tq8KeBeQAyUjpBzvfEX8CWsSa7gOUE7m2/tgupGmVomkOismpuX5xBxE3T3lI4nPrIDun4U/mxOSxBTJzrY7be52lP2Nzzx7K5Z5IHVthepUzhpUjFzqO4rJXuiIb69sHSM2K+ykibbtjRpvpr4iGBT0pyzbQSWVAvg/dHSemwJOQVfIW0BODcdHV5H+ilRc1UMu2Q2gJESNNp6BgbU/KrLL4lI2wu1ghpHAnmsZiEvUQri6x2c9vpLy5TMVmYQcwfgTY5/dMXGlgsvbNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jumptrading.com; dmarc=pass action=none
 header.from=jumptrading.com; dkim=pass header.d=jumptrading.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jumptrading.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnmdU8rzMtEnfe44MHc3rBa4Zcy4Tf/6Xrp1yvaSU8c=;
 b=Zw5/MUlG15EHKBD2+ZytahtzBOb3PVRUB5dGBt4OQ0lon1BqeGsi49ZPPK9i3XlCTzypRj/N/bIrK3GbCuh/QI9kFsRUkJBpfBfbPhBR+Zvky1o+fhRanWVUpJKP6S6PolcjbbAjS15mD0SMIj+wK3pALLHbEk7WkHq6nJkZZko=
Received: from MW4PR14MB4796.namprd14.prod.outlook.com (2603:10b6:303:109::19)
 by CO6PR14MB4308.namprd14.prod.outlook.com (2603:10b6:5:34d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 15:17:27 +0000
Received: from MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::2c0d:7614:3aed:f97e]) by MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::2c0d:7614:3aed:f97e%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 15:17:26 +0000
From:   PJ Waskiewicz <pwaskiewicz@jumptrading.com>
To:     "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Subject: RE: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Topic: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Index: AQHXmsh2FN3baon3J0C4ms4cTGoQHauMjGGAgAGT9oCAFFbJcIAAD3CAgADHjICAANwswIAAz1YAgAQuqaCAA4nqAIACJSpQgAMPF9A=
Date:   Thu, 23 Sep 2021 15:17:26 +0000
Message-ID: <MW4PR14MB479687DDEC1EB0C4AA5F5CF1A1A39@MW4PR14MB4796.namprd14.prod.outlook.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
         <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
         <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
         <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
 <bebb58f34ed68025e95f8bc060af58a24333374b.camel@intel.com>
 <DM6PR11MB3371A3D1F314F3B8541FAF03E6DA9@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB47960CC778789EEE8E8A54EDA1DA9@MW4PR14MB4796.namprd14.prod.outlook.com>
 <DM6PR11MB3371B4431AD7C46672C7E439E6DB9@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB4796F279908B7E4D11622C66A1DE9@MW4PR14MB4796.namprd14.prod.outlook.com>
 <DM6PR11MB3371A285032A583A73BA62E0E6A09@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB47967810D43031FF8C4C2265A1A19@MW4PR14MB4796.namprd14.prod.outlook.com>
In-Reply-To: <MW4PR14MB47967810D43031FF8C4C2265A1A19@MW4PR14MB4796.namprd14.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=jumptrading.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f345096b-82d2-4a3b-0719-08d97ea540ae
x-ms-traffictypediagnostic: CO6PR14MB4308:
x-microsoft-antispam-prvs: <CO6PR14MB430800EEA18C2FF7A6D38A26A1A39@CO6PR14MB4308.namprd14.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cse1pxGJOIRhE1F+i2Yzk9JvtL7vL1ij6tKsvVfYmcgZOzXh28qrQ2hNmgPq+EKj2cLG87YUPkqOR4qSGaNhDM4zyzinn3yXbHXdyMsHfcpAxTnZxr7RzIzjcSzJj7Pr+45aD6wNpS/kgmKs+pTVYbel70kuAN6OccUGEfNWB0N4yKN+waFbVK1cCjq+/ONp99spOfYLyqBjD55Z7POHdA/kOxxt4t0ieqOc0kY64jjPA3WpVVXRpS6nlniASN4jZQ94pbcGcv4VPWKwuyqk07kSL/fg3ifunfe1gN88bum9EEkA+OlpCJGqci0TUpkae+/MOq2s5XXIjSGrYSkYHBMk1aoUWzAFxhGfLyQSK0KoZXK6R+6WESSvmoYWx6W0CfGz63aIsUCfvXhsI1xkMX/sr71u1LBNMi2B85BJcPk+dSA5q6aFZEjQbKjDfPk88En/HIgCrg/xaeAj13e2GH5tQsiIfX8wg3mr5yNzVdNm+vEVNCTpmCByfiDixQ5Y1IwHuz47FMFZwqD+x0wGK5DtgAWr+k+L/rOsaiPk6ykgfZ5tXJjXs9McntJwptYGd6wPsjw8ZQjTtXs+XoUSfhHtFBWx9LnyvdPmNhOjRV2+Btg8nogJZWa8DT/b5zVQ03Pb+tDFnwrMDy+YHYqVKbN/Lr93IVTm9YPpnuHOjpaDlJ5AcDVKQWP1bzp4QduUSrH42UskAXjhghx/ZbB97Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR14MB4796.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(38070700005)(33656002)(66446008)(66946007)(38100700002)(64756008)(71200400001)(4326008)(122000001)(6506007)(8676002)(86362001)(66556008)(7696005)(66476007)(7416002)(54906003)(83380400001)(186003)(316002)(52536014)(9686003)(5660300002)(55016002)(508600001)(8936002)(2906002)(26005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TG9SQXpKTWJ0c3FoSmsxakZxclc4VlpjVHJDT0lLS3B0REtOb3craWUvdzdj?=
 =?utf-8?B?cnl4OFBlYW9CZVRYMUZnMWtCTHZ0VXhMWnI3VklKVDRYZnJ5WHpBUFhYNTNJ?=
 =?utf-8?B?VG41VUtuZHY2Y3ZWV1dyL2QzaWNHc0UwYTR4anI1WU1MZzJnRzJINElEYTZT?=
 =?utf-8?B?eEw3QTBmbGdjSFFwR1U4VVFOMG56RUhiUW9JcldEMU4xZS95akhsS2Uwc0Jk?=
 =?utf-8?B?QkhRRjNQRWJDdG1jaGlFNU1Hbk5KRURjS2NDdTZidEkzN09uTngyUlJhc3NR?=
 =?utf-8?B?TXUrb0pWakN2R2ZvMFFqZENMb1YzWGNvYStwRVB5aDVNYVRkL2JuOHN4Z0or?=
 =?utf-8?B?UTFqN2ozVWN4dWY4N1FtMjV5T01zUTBiOTlrR1RVUllzdnBzaS9YM0VTNUpJ?=
 =?utf-8?B?VGZzSE9kR2h5S2g3R0EzamE5N2NVNHNJb3g4L0tMeXZXbFQzN1FVODdoZWVu?=
 =?utf-8?B?ZlcwakQ0WCtXQmUyMlJqTUl1VDdLMExWekQ5MzFTWTNVQXJEZ0l6TEIyMllD?=
 =?utf-8?B?bkFiMlp6dkU2NXQ3a2p3K0ttNnNtT3VXYVl0NVE1c2Mxak5uTjV2blNoQVZU?=
 =?utf-8?B?cGt4QVAvbTdEeUZETEhQSXhzV0Jsb0RwZHpDK1FNTWc5aVdweXA1ZUtLV0ox?=
 =?utf-8?B?cFR0cTdGd3UvUUh4N2JZVEdZdk11YzNYL1EzeUozelhxWnVnSjBSYm5MM3JQ?=
 =?utf-8?B?VytJSjFST2JjaGlMUjcrOXluQ01TVHBjVm1zaHowU2d4VHJMM09nNnpNV0RJ?=
 =?utf-8?B?MkJhTWtnYXBubm8wSDVLMXVkbENpSmVEMFJqR0dUWHUyWHpCSHdrb21aODBk?=
 =?utf-8?B?WThicWJ2am5SVzhRWWJseFZNNTBLNXIvTkZZTXVEOVVKdzdYeXRDMENIU1Fl?=
 =?utf-8?B?K0dCdzR5ZTRISVpKMUNJNzEvYW5IUmZCb25VbTh4K3ZhbUVnZHJueWF6SUpy?=
 =?utf-8?B?RHpHYld6Y1IxSTR6M2Eza0pFdmg3SmloVWtRaDV6WGhwSytJT0tDdllvNXF1?=
 =?utf-8?B?VWVaOCt1dGlmbkRRKzBVUXlLbnA3NXlLWlQ2Q3F6blo5YWdEdy9LZTdxRXho?=
 =?utf-8?B?OTgwdSs3SXJ1WmpBNW1mOEpjcTJjc3B4eXA2RGFublhTSXNNOWZRdHd1MU5Q?=
 =?utf-8?B?UU9MUjRtRnFBa2xwZVczSWtURHlJcW9oYXpsWTJOVGt3dGVqWGhxN3J2TUFR?=
 =?utf-8?B?bzN6TjlaOUVIdVc2c3A4MFRjSDRoZk5NdXc3ajI0ZldBWVBkejVMdVUxTGlL?=
 =?utf-8?B?T2psQU5xcTMxUmNPM0VKT0VvRXJmTW9YSmFLNEZpYVNmVDNwWHltT01acXMz?=
 =?utf-8?B?MEI4UEJ1TFZGWjE2T3dhZXhlNCs2QTRwd1I4WEo2Qms5VlZKNHFyU0p3SXFT?=
 =?utf-8?B?bFY2L0JmQ2h5cG9oNVd4RGdlQWltNHVBM1FEWHUvOTh3SmFFNlFWWDNSK0VC?=
 =?utf-8?B?Z1ZzYitsZUVlL1BOQko5UGoxcWc1blQ2bjJrVS9Ld2hQU1AyTUJDb1VhV1VU?=
 =?utf-8?B?aE1ScXpRZFZZMTJsTVRPV1l6SnlkZUpFZ0pBYjNUV2QyZmZkZGdhUVpHK3F3?=
 =?utf-8?B?bXcwVm5yQ1ZkYVpTNkIzaXZEMmZTVUlvOXBEeVRhZldJbEhnUXArQUhDdDRC?=
 =?utf-8?B?bE5rZTNsVHNYNmp4UkpKbGdTMUk4N2JDRlFDYUdnR0F1WWtxWUhHQU56WVpz?=
 =?utf-8?B?N29qdVpsWEU3RVhnc0YwMFc3ZXlnUTBtdnE0bXlOL2NtVktnUUFldS96ZytZ?=
 =?utf-8?Q?jAY8wHjYcg+VMOt/UfGOL0kDQFI1hQgAVVRW5Wf?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jumptrading.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR14MB4796.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f345096b-82d2-4a3b-0719-08d97ea540ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 15:17:26.8630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 11f2af73-8873-4240-85a3-063ce66fc61c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z4nAxmATp58ex94I+mOr4IvI8Gr25h8Jl4MfSLSqFvVTczokNCluwNzhwdnO3Jcf1eWrcawNkwleOWnPykh1DBBECaK/Qy4GpbbFalJrj2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR14MB4308
X-Proofpoint-ORIG-GUID: ZRmEYt0E43DXIXIgNoKKDUAlSnPoe5tS
X-Proofpoint-GUID: NGeKZOl2V17ROjwmR1aPA2HPiu3Cuwhu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-23_04,2021-09-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 phishscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109200000 definitions=main-2109230095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IEhlbGxvIFBKLA0KPg0KPiBIZWxsbywNCg0KSGkgVG9ueSBhbmQgU3lsd2VzdGVyLA0KDQpB
bnkgdXBkYXRlcy9jb21tZW50cyBvbiBteSByZXBseSBmcm9tIGEgZmV3IGRheXMgYWdvIG9uIHRo
aXM/DQoNCi1QSg0KDQo+ID4NCj4gPiA+IHN0YXRpYyB2b2lkIGk0MGVfZnJlZV9taXNjX3ZlY3Rv
cihzdHJ1Y3QgaTQwZV9wZiAqcGYpIHsNCj4gPiA+ICAgICAgICAgLyogRGlzYWJsZSBJQ1IgMCAq
Lw0KPiA+ID4gICAgICAgICB3cjMyKCZwZi0+aHcsIEk0MEVfUEZJTlRfSUNSMF9FTkEsIDApOw0K
PiA+ID4gICAgICAgICBpNDBlX2ZsdXNoKCZwZi0+aHcpOw0KPiA+ID4NCj4gPiA+IFdvdWxkIHlv
dSBzdGlsbCB3YW50IHRvIGRvIHRoYXQgYmxpbmRseSBpZiB0aGUgdmVjdG9yIHdhc24ndA0KPiA+
ID4gYWxsb2NhdGVkIGluIHRoZSBmaXJzdCBwbGFjZT8gIFNlZW1zIGV4Y2Vzc2l2ZSwgYnV0IGl0
J2QgYmUNCj4gPiA+IGhhcm1sZXNzLiAgU2VlbXMgbGlrZSBub3QgY2FsbGluZyB0aGlzIGZ1bmN0
aW9uIGFsdG9nZXRoZXIgd291bGQgYmUNCj4gPiA+IGNsZWFuZXIgYW5kIGdlbmVyYXRlIGxlc3Mg
TU1JTyBhY3Rpdml0eSBpZiB0aGUgTUlTQyB2ZWN0b3Igd2Fzbid0DQo+ID4gPiBhbGxvY2F0ZWQg
YXQgYWxsIGFuZA0KPiA+IHdlJ3JlIGZhbGxpbmcgb3V0IG9mIGFuIGVycm9yIHBhdGguLi4NCj4g
PiA+DQo+ID4gPiBJIGFtIHJlYWxseSBhdCBhIGxvc3MgaGVyZS4gIFRoaXMgaXMgY2xlYXJseSBi
cm9rZW4uICBXZSBoYXZlIGFuIE9vcHMuDQo+ID4gPiBXZSBnZXQgdGhlc2Ugb2NjYXNpb25hbGx5
IG9uIGJvb3QsIGFuZCBpdCdzIHJlYWxseSBhbm5veWluZyB0byBkZWFsDQo+ID4gPiB3aXRoIG9u
IHByb2R1Y3Rpb24gbWFjaGluZXMuICBXaGF0IGlzIHRoZSBkZWZpbml0aW9uIG9mICJzb29uIiBo
ZXJlDQo+ID4gPiBmb3IgdGhpcyBuZXcgcGF0Y2ggdG8gc2hvdyB1cD8gIE15IGRpc3RybyB2ZW5k
b3Igd291bGQgbG92ZSB0byBwdWxsDQo+ID4gPiBzb21lIHNvcnQgb2YgZml4IGluIHNvIHdlIGNh
biBnZXQgaXQgaW50byBvdXIgYnVpbGQgaW1hZ2VzLCBhbmQgc3RvcA0KPiA+ID4gaGF2aW5nIHRo
aXMgcHJvYmxlbS4gIE15IHBhdGNoIGZpeGVzIHRoZSBpbW1lZGlhdGUgcHJvYmxlbS4gIElmIHlv
dQ0KPiA+ID4gZG9uJ3QgbGlrZSB0aGUgcGF0Y2ggKHdoaWNoIGl0IGFwcGVhcnMgeW91IGRvbid0
OyB0aGF0J3MgZmluZSksIHRoZW4NCj4gPiA+IHN0YWxsaW5nIG9yIHNheWluZyBhIGRpZmZlcmVu
dCBmaXggaXMgY29taW5nICJzb29uIiBpcyByZWFsbHkgbm90IGENCj4gPiA+IGdyZWF0IHN1cHBv
cnQgbW9kZWwuICBUaGlzIHdvdWxkIGJlIGdyZWF0IHRvIG1lcmdlLCBhbmQgdGhlbiBpZiB5b3UN
Cj4gPiA+IHdhbnQgdG8gbWFrZSBpdCAiYmV0dGVyIiBvbiB5b3VyIHNjaGVkdWxlLCBpdCdzIG9w
ZW4gc291cmNlLCBhbmQgeW91DQo+ID4gPiBjYW4gc3VibWl0IGEgcGF0Y2guICBPciBJJ2xsIGJl
IGhhcHB5IHRvIHJlc3BpbiB0aGUgcGF0Y2gsIGJ1dCBzdGlsbA0KPiA+ID4gY2FsbGluZyBmcmVl
X21pc2NfdmVjdG9yKCkgaW4gYW4gZXJyb3IgcGF0aCB3aGVuIHRoZSBNSVNDIHZlY3RvciB3YXMN
Cj4gPiBuZXZlciBhbGxvY2F0ZWQgc2VlbXMgbGlrZSBhIGJhZCBkZXNpZ24gZGVjaXNpb24gdG8g
bWUuDQo+ID4gPg0KPiA+ID4gLVBKDQo+ID4NCj4gPiBJIHRvdGFsbHkgYWdyZWUgdGhhdCB3ZSBz
aG91bGRu4oCZdCBjYWxsIGZyZWVfbWlzY192ZWN0b3IgaWYgbWlzYyB2ZWN0b3INCj4gPiB3YXNu
J3QgYWxsb2NhdGVkIHlldCBidXQgdG8gbWUgdGhpcyBpcyBub3Qgd2hhdCB5b3VyIHBhdGNoIGlz
IGRvaW5nLg0KPiA+IGZyZWVfbWlzY192ZWN0b3IoKSBpcyBjYWxsZWQgaW4gY2xlYXJfaW50ZXJy
dXB0X3NjaGVtZSBub3QNCj4gPiByZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eSgpLiBJbiB5b3Vy
IHBhdGNoIGNsZWFyX2ludGVycnVwdF9zY2hlbWUoKQ0KPiA+IHdpbGwgc3RpbGwgYmUgY2FsbGVk
IHdoZW4gcGYgc3dpdGNoIHNldHVwIGZhaWxzIGluIGk0MGVfcHJvYmUoKSBhbmQgaXQNCj4gPiB3
aWxsIHN0aWxsIGNhbGwgZnJlZV9taXNjX3ZlY3RvciBvbiB1bmFsbG9jYXRlZCBtaXNjIElSUS4g
T3RoZXIgcHJvcGVyDQo+ID4gd2F5IHRvIGZpeCB0aGlzIHdvdWxkIGJlIG1vdmluZyBmcmVlX21p
c2NfdmVjdG9yKCkgb3V0IG9mDQo+ID4gY2xlYXJfaW50ZXJydXB0X3NjaGVtZSgpIGFuZCBjYWxs
aW5nIGl0IHNlcGFyYXRlbHkgd2hlbiBtaXNjIHZlY3Rvcg0KPiA+IHdhcyByZWFsbHkgYWxsb2Nh
dGVkLiBBcyBmb3IgdGhlIGh3IHJlZ2lzdGVyIGJlaW5nIHdyaXR0ZW4gaW4gb3VyDQo+ID4gcGF0
Y2ggYXMgeW91IHNhaWQgaXQncyBoYXJtbGVzcy4gVGhlIHBhdGNoIHdlJ3ZlIHByZXBhcmVkIHNo
b3VsZCBiZSBvbiBpd2wNCj4gdG9kYXkuDQo+ID4NCj4NCj4gT2ssIEkgc2VlIHRoZSBwYXRjaCBv
biBJV0wuLi4ubGV0J3MgZGlzY3Vzcy4uLi4NCj4NCj4gSnVzdCBhYm92ZSwgSSBwb2ludGVkIG91
dCB0aGF0IGlmIHRoZSBNSVNDIHZlY3RvciBoYXNuJ3QgYmVlbiBhbGxvY2F0ZWQgYXQgYWxsLA0K
PiB0aGVuIHdlIGRvbid0IHdhbnQgdG8gY2FsbCBmcmVlX21pc2NfdmVjdG9yKCkgYXQgYWxsLiAg
VGhhdCB3b3VsZCBhbHNvIG1lYW4NCj4gdGhlIHN1Z2dlc3Rpb24gdG8gY2hlY2sgdGhlIGF0b21p
YyBzdGF0ZSBiaXQgdG8gYXZvaWQgdGhlIGFjdHVhbCBmcmVlIHdvdWxkDQo+ICpzdGlsbCogaGF2
ZSB0aGUgY29kZSBjYWxsIGZyZWVfbWlzY192ZWN0b3IoKSwgYW5kIG9ubHkgc2tpcCB0aGUgYWN0
dWFsIGZyZWUNCj4gKGFmdGVyIGRvaW5nIGFuIHVubmVjZXNzYXJ5IE1NSU8gd3JpdGUgYW5kIHRo
ZW4gcmVhZCB0byBmbHVzaCkuICBJIHBvaW50ZWQNCj4gb3V0IHRoYXQgd291bGRuJ3QgYmUgaWRl
YWwsIGFuZCB5b3UsIGp1c3QgYWJvdmUsIGFncmVlZC4gIFlldCwgdGhlIGZpeCB5b3UgZ3V5cw0K
PiBzdWJtaXR0ZWQgdG8gSVdMIGRvZXMgZXhhY3RseSB0aGF0LiAgU28gYXJlIHdlIGp1c3Qgc2F5
aW5nIHRoaW5ncyB0byBidXJ5IHRoaXMNCj4gdGhyZWFkIGFuZCBob3BlIGl0IGdvZXMgYXdheSwg
b3IganVzdCB3aWxsZnVsbHkgbm90IGRvaW5nIHdoYXQgd2UgYWdyZWVkIG9uPw0KPiBJdCdzIHBy
ZXR0eSBkaXNoZWFydGVuaW5nIHRvIGNvbnNpZGVyIGZlZWRiYWNrLCBhZ3JlZSB0byBpdCwgdGhl
biBjb21wbGV0ZWx5DQo+IGlnbm9yZSBpdC4gIFRoYXQncyBub3QgaG93IG9wZW4gc291cmNlIHdv
cmtzLi4uDQo+DQo+IEFsc28sIHJlZ2FyZGxlc3MgaG93IHlvdSBndXlzIHdhbnQgdGhlIGNvZGUg
dG8gd29yaywgaXQncyB1c3VhbGx5IGdvb2QgZm9ybQ0KPiB0byBpbmNsdWRlIGEgIlJlcG9ydGVk
LWJ5OiIgaW4gYSBwYXRjaCBpZiB5b3UncmUgZGVjaWRpbmcgbm90IHRvIHRha2UgYQ0KPiBwcm9w
b3NlZCBwYXRjaC4gIEl0J3MgZXZlbiBiZXR0ZXIgZm9ybSB0byBpbmNsdWRlIHRoZSBPb3BzIHRo
YXQgd2FzIHJlcG9ydGVkDQo+IGluIHRoZSBmaXJzdCBwYXRjaCwgc2luY2UgdGhhdCBtYWtlcyB0
aGluZ3MgbGlrZSAke1NFQVJDSF9FTkdJTkV9IHdvcmsgZm9yDQo+IHBlb3BsZSBydW5uaW5nIGlu
dG8gdGhlIHNhbWUgaXNzdWUgaGF2ZSBhIGNoYW5jZSB0byBmaW5kIGEgc29sdXRpb24uICBOb3QN
Cj4gZG9pbmcgZWl0aGVyIG9mIHRoZXNlIHdoZW4gc29tZW9uZSBlbHNlIGhhcyBkb25lIHdvcmsg
dG8gaWRlbnRpZnkgYW4gaXNzdWUsDQo+IHRlc3QgYSBmaXgsIGFuZCBwcm9wb3NlIGl0LCBpcyBu
b3QgYSBnb29kIHdheSB0byBhdHRyYWN0IG1vcmUgcGVvcGxlIHRvIHdvcmsgb24NCj4gdGhpcyBk
cml2ZXIgaW4gdGhlIGZ1dHVyZS4NCj4NCj4gSWYgd2Ugd2FudGVkIHRvIGRvIHNvbWV0aGluZyB3
aGVyZSBmcmVlX21pc2NfdmVjdG9yKCkgaXNuJ3QgY2FsbGVkIGlmIHRoZQ0KPiBzdGF0ZSBmbGFn
IGlzbid0IHNldCwgdGhlbiB3aHkgbm90IHNvbWV0aGluZyBsaWtlIHRoaXMsIHdoaWNoIHdvdWxk
IGtlZXAgaW4gdGhlDQo+IHNwaXJpdCBvZiB3aGF0IHdlIGFncmVlZCBvbiBhYm92ZToNCj4NCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV9tYWluLmMN
Cj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfbWFpbi5jDQo+IGluZGV4
IDFkMWY1Mjc1NmE5My4uYTQwMTkzYmNjN2I3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2k0MGUvaTQwZV9tYWluLmMNCj4gQEAgLTQ4NjgsNyArNDg2OCw5IEBAIHN0YXRp
YyB2b2lkIGk0MGVfY2xlYXJfaW50ZXJydXB0X3NjaGVtZShzdHJ1Y3QNCj4gaTQwZV9wZiAqcGYp
ICB7DQo+ICAgICAgICAgaW50IGk7DQo+DQo+IC0gICAgICAgaTQwZV9mcmVlX21pc2NfdmVjdG9y
KHBmKTsNCj4gKyAgICAgICAvKiBPbmx5IGF0dGVtcHQgdG8gZnJlZSB0aGUgbWlzYyB2ZWN0b3Ig
aWYgaXQncyBhbHJlYWR5IGFsbG9jYXRlZCAqLw0KPiArICAgICAgIGlmICh0ZXN0X2JpdChfX0k0
MEVfTUlTQ19JUlFfUkVRVUVTVEVELCBwZi0+c3RhdGUpKQ0KPiArICAgICAgICAgICAgICAgaTQw
ZV9mcmVlX21pc2NfdmVjdG9yKHBmKTsNCj4NCj4gICAgICAgICBpNDBlX3B1dF9sdW1wKHBmLT5p
cnFfcGlsZSwgcGYtPml3YXJwX2Jhc2VfdmVjdG9yLA0KPiAgICAgICAgICAgICAgICAgICAgICAg
STQwRV9JV0FSUF9JUlFfUElMRV9JRCk7DQo+DQo+IC1QSg0KDQpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXw0KDQpOb3RlOiBUaGlzIGVtYWlsIGlzIGZvciB0aGUgY29uZmlkZW50aWFs
IHVzZSBvZiB0aGUgbmFtZWQgYWRkcmVzc2VlKHMpIG9ubHkgYW5kIG1heSBjb250YWluIHByb3By
aWV0YXJ5LCBjb25maWRlbnRpYWwsIG9yIHByaXZpbGVnZWQgaW5mb3JtYXRpb24gYW5kL29yIHBl
cnNvbmFsIGRhdGEuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIHlvdSBh
cmUgaGVyZWJ5IG5vdGlmaWVkIHRoYXQgYW55IHJldmlldywgZGlzc2VtaW5hdGlvbiwgb3IgY29w
eWluZyBvZiB0aGlzIGVtYWlsIGlzIHN0cmljdGx5IHByb2hpYml0ZWQsIGFuZCByZXF1ZXN0ZWQg
dG8gbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkgYW5kIGRlc3Ryb3kgdGhpcyBlbWFpbCBh
bmQgYW55IGF0dGFjaG1lbnRzLiBFbWFpbCB0cmFuc21pc3Npb24gY2Fubm90IGJlIGd1YXJhbnRl
ZWQgdG8gYmUgc2VjdXJlIG9yIGVycm9yLWZyZWUuIFRoZSBDb21wYW55LCB0aGVyZWZvcmUsIGRv
ZXMgbm90IG1ha2UgYW55IGd1YXJhbnRlZXMgYXMgdG8gdGhlIGNvbXBsZXRlbmVzcyBvciBhY2N1
cmFjeSBvZiB0aGlzIGVtYWlsIG9yIGFueSBhdHRhY2htZW50cy4gVGhpcyBlbWFpbCBpcyBmb3Ig
aW5mb3JtYXRpb25hbCBwdXJwb3NlcyBvbmx5IGFuZCBkb2VzIG5vdCBjb25zdGl0dXRlIGEgcmVj
b21tZW5kYXRpb24sIG9mZmVyLCByZXF1ZXN0LCBvciBzb2xpY2l0YXRpb24gb2YgYW55IGtpbmQg
dG8gYnV5LCBzZWxsLCBzdWJzY3JpYmUsIHJlZGVlbSwgb3IgcGVyZm9ybSBhbnkgdHlwZSBvZiB0
cmFuc2FjdGlvbiBvZiBhIGZpbmFuY2lhbCBwcm9kdWN0LiBQZXJzb25hbCBkYXRhLCBhcyBkZWZp
bmVkIGJ5IGFwcGxpY2FibGUgZGF0YSBwcm90ZWN0aW9uIGFuZCBwcml2YWN5IGxhd3MsIGNvbnRh
aW5lZCBpbiB0aGlzIGVtYWlsIG1heSBiZSBwcm9jZXNzZWQgYnkgdGhlIENvbXBhbnksIGFuZCBh
bnkgb2YgaXRzIGFmZmlsaWF0ZWQgb3IgcmVsYXRlZCBjb21wYW5pZXMsIGZvciBsZWdhbCwgY29t
cGxpYW5jZSwgYW5kL29yIGJ1c2luZXNzLXJlbGF0ZWQgcHVycG9zZXMuIFlvdSBtYXkgaGF2ZSBy
aWdodHMgcmVnYXJkaW5nIHlvdXIgcGVyc29uYWwgZGF0YTsgZm9yIGluZm9ybWF0aW9uIG9uIGV4
ZXJjaXNpbmcgdGhlc2UgcmlnaHRzIG9yIHRoZSBDb21wYW554oCZcyB0cmVhdG1lbnQgb2YgcGVy
c29uYWwgZGF0YSwgcGxlYXNlIGVtYWlsIGRhdGFyZXF1ZXN0c0BqdW1wdHJhZGluZy5jb20uDQo=
