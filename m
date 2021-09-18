Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2976F4102D8
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 04:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhIRCDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 22:03:14 -0400
Received: from mx0a-0038a201.pphosted.com ([148.163.133.79]:46960 "EHLO
        mx0a-0038a201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233488AbhIRCDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 22:03:12 -0400
Received: from pps.filterd (m0171340.ppops.net [127.0.0.1])
        by mx0a-0038a201.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18I216Ws004032;
        Sat, 18 Sep 2021 02:01:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0038a201.pphosted.com with ESMTP id 3b55j2r17b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 18 Sep 2021 02:01:46 +0000
Received: from m0171340.ppops.net (m0171340.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18I21kIN004737;
        Sat, 18 Sep 2021 02:01:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by mx0a-0038a201.pphosted.com with ESMTP id 3b55j2r179-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 18 Sep 2021 02:01:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrPHbc05/yjLjnP6AFMIRSMJ+V9XC2gZhGRg7Z7HQ7DLXVfn3VDaD7tEH6t6Rzc+5O6DXHLgmxjhXRXU+6CGRbwZ/8lSWWbkCS5EBA/IvSB6t86HVSavxxCpNKJmmXcCfd4M+07C7GTmC3gdZWxCcx0eUDD+4CaCFsHVT0zEEJhI13IDEC3Fgz2NvEEvxUnmenJY9F8d9LSCmzDTB8cdyCS20Tm07t3XN60PfFzb/3/dyfjgLBiABkLw8zNJR2pkHUiHG6u4MhB3+2MdpOyDdK6PjfKkT4dpWVI+e+CfPR5rIpMwAz4W0KTJGvtmtI/IzIb7ZFOxlekHVCWL1IE3sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AvNBrNmWGvbTqEdJJrhZ1aVcBewfliKFJy58YNdaOtU=;
 b=Eohs3smO1t8thbrXQpGEZVpCcQpszUvWj56ra/Kf7A9NI3JlF5sIiDUBt8XFa6p8o7p2eprbTfQtgHE3DVBQE1937Cx6p4mCjkmWr7PPjflNWRQDjZQ1uzN6hhjoDUJib+5gym8LkOWt/VFPk/qsUpgblm5RBEU7e95QMoZaIK9dg42Sge5DaEeOgAgBXTTpseEN2LgQ8LVMTng/Q1U65AR66dtIJMj0+R9V2MT1uNm9FP62yggkNTfvL8ia6p73zariPXKoVqyfe6lAuDXKUUirkxvyWncGbx8Kdj6DpkhjhoSOazhHZaFSA5QEctyxRXtj2A5QlYc02w52eRVxNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jumptrading.com; dmarc=pass action=none
 header.from=jumptrading.com; dkim=pass header.d=jumptrading.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jumptrading.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvNBrNmWGvbTqEdJJrhZ1aVcBewfliKFJy58YNdaOtU=;
 b=nh0Z+w+1tSY9x9qt1wTIi+pe5/E3UdSMFdoG04Fac7UR0akVJBa4qqutIypcmbF2k5dQbxrZLdIVijS3TaWfij9Opw2Boj5AfnJb1kgTXKEwrlWvd9gNqqF2ZxsB6tAIyk80f54lvMOJetoVCu+VKCQWyWPSNXqfi7krGPmd0Lk=
Received: from MW4PR14MB4796.namprd14.prod.outlook.com (2603:10b6:303:109::19)
 by CO6PR14MB4514.namprd14.prod.outlook.com (2603:10b6:5:350::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Sat, 18 Sep
 2021 02:01:43 +0000
Received: from MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::2c0d:7614:3aed:f97e]) by MW4PR14MB4796.namprd14.prod.outlook.com
 ([fe80::2c0d:7614:3aed:f97e%9]) with mapi id 15.20.4523.017; Sat, 18 Sep 2021
 02:01:43 +0000
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
Thread-Index: AQHXmsh2FN3baon3J0C4ms4cTGoQHauMjGGAgAGT9oCAFFbJcIAAD3CAgADHjICAANwswIAAz1YAgAQuqaA=
Date:   Sat, 18 Sep 2021 02:01:43 +0000
Message-ID: <MW4PR14MB4796F279908B7E4D11622C66A1DE9@MW4PR14MB4796.namprd14.prod.outlook.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
         <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
         <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
         <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
 <bebb58f34ed68025e95f8bc060af58a24333374b.camel@intel.com>
 <DM6PR11MB3371A3D1F314F3B8541FAF03E6DA9@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB47960CC778789EEE8E8A54EDA1DA9@MW4PR14MB4796.namprd14.prod.outlook.com>
 <DM6PR11MB3371B4431AD7C46672C7E439E6DB9@DM6PR11MB3371.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB3371B4431AD7C46672C7E439E6DB9@DM6PR11MB3371.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=jumptrading.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e32db84-a191-4594-a113-08d97a48433e
x-ms-traffictypediagnostic: CO6PR14MB4514:
x-microsoft-antispam-prvs: <CO6PR14MB45146F329304B9CD3490D26DA1DE9@CO6PR14MB4514.namprd14.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IrmuBqvcjRDpU/5wvgrnGQpglv+WiSPFk1dYjbOBVSuLKCoE8wexOWVqCRvsrkFHZ/bJiuQF70xBYXVek2RDX+6iG9QD7WazfMDuaNEjAwKbISvqeMfjS4cLaFJpxtbHX/RmO0fayFLwZkptA28YvyjgOPkiuewyr0lpUkYDDpmBIpNE/kxUugpI4XT77qDTvCmlsicPz8zbp5m4ZTvs5uLXMOHvcTVspdy4fVaXQpCELE6bmMUP1XIuE4DtVeKZfCXyyMfUyQtuDNqA+ZGU6ZBMWw5EUj3MkXNeWDWfB13/E9FREXNxnclKtsl34AG0sbkzm2L5xNkENrME51tm2b034ooDT3LgDSHk83i1wDknUe85Zr3PtUD6Ywd+MizHWh5QXBS2zOmpPzpY8USesaFqVOk0gMYrMvVV3EkwqG0PywFIpNhcQILdOhMcE4Lq3NxTUHg4NkR3eI1PSDdu4A556fTLt9IQZmb7cTvU7Qvg3gcp/g98XePn9+8dXaO0e+oEIZhu77IaPYQp5Q8rBgsfY4ZLxs/qmfVjzEIYmxkIB4lGSKFstji6GFFQKKZb8gKmEhe90RwhFvg9tMeKrlu2lGnZyU2fB2P812xxVJF5FmJ5c9viak3s7vaZbX8pVXfTgPBRIm7q3SN95D7RNzh9RU/id/JBXks7bS8JtyjhOOuUq03E5WupWuBtaNKt8Sl3/mgBqbo6yjU3DzxPsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR14MB4796.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(54906003)(316002)(8936002)(8676002)(4326008)(110136005)(5660300002)(33656002)(86362001)(66556008)(66476007)(76116006)(66946007)(38070700005)(52536014)(478600001)(2906002)(66446008)(186003)(55016002)(6506007)(9686003)(122000001)(38100700002)(26005)(7416002)(7696005)(83380400001)(71200400001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2ZFbUNaNTBxTHJZQ2FlWlIwVURGb2Y0am94aU5NZ0lJZExMQWZpNk11bEo2?=
 =?utf-8?B?a2R5a3p3RENpQjhiK3dEaE52bGVNcWUvMzhTaGRsYTJPcVBLdUM0MjhTWkUw?=
 =?utf-8?B?SmlmOEdxTVpaM1lTSXl0b09EQklKTXJwejI1VGY1VnN1ajhaOHc5cDFmdHhj?=
 =?utf-8?B?SmRRRFdtQ3FkS0ZidlBVZVRVZkVJV25XakJzbmhaaW4rc29ZSCtmcHc1OVdC?=
 =?utf-8?B?dEo4SmlDemp5VWNlZG5ESWdqY3dNdHBQQThtVmNjY3NodmZ1LzJyM0kwOGNq?=
 =?utf-8?B?WjFMR3poR0xjSlRDSm1Oc3N1cUdOZU55NjRVbW9UQVlGMTBqcm9naVFTSTBy?=
 =?utf-8?B?YXdXb2pwVmYyKzVpTkNWS1dZM0s2TzZIQnR2OFhDKzh2eUFsUkVJWDUydysz?=
 =?utf-8?B?QjhWcnA2c09WUjlVbzJrQm16dHl0TGxSdFcyRG5CSEFuL0hsZFZoWkFCcmNY?=
 =?utf-8?B?STZmNkUyaUJjQUxxa0VTamhGMHNFNERNVVErM05hT0ZwbWprblRFMFdzRWJD?=
 =?utf-8?B?U3pDME90TUdnbUNQU05VcGNiaVNhYk5tWUg0d2E1L2h2VG1iMVluaUtUYjk2?=
 =?utf-8?B?UHdtdWxMNUhKd2oxTWpiNE5hdE1acTdhTC9xMllCQ0ljcVBiMUF2NisvL3Iy?=
 =?utf-8?B?UjdKSzhrSzFsYk1zYllEQzJya3poai9FOWlwa2NpV2JneXEvUm9wWGhEQnhV?=
 =?utf-8?B?MjVvTTViejdZWEowbGlyNTQrN2VZMjh1Kyt5OHZVcDZsZDZXMUQ5YVJmRzNG?=
 =?utf-8?B?eUFGZmIyNHRxQnAvOG8yZXNXZFVLVWNDeTBHWkRtSlN5aDI0L0srdExqNmtj?=
 =?utf-8?B?ZnNPR0puTWdvakRtZU52eUwzTnViY0lEN3lEQkorMzlpMTUyZDE5N1dMVlJK?=
 =?utf-8?B?bmk3VzQ3TWhSbUxLUjB1RUhDcUZYZ3krWmtDeHhqRE04YzBkVFN3RWhuV1M4?=
 =?utf-8?B?SXBGMlM5c0pCdnBCWVpSTnBRTjhzSmluUkJ4NW1XUG5ZbFhvNGFDQ1g5dE5k?=
 =?utf-8?B?RDUyRXdpNkxtbXNrVEtuZVo5Q3ZvN3I0VE16Y0xKOUI2eVBuSzRta1UvbGp0?=
 =?utf-8?B?clZwNmttU1FMY0FFdEVyUnNyL3MzMThWRHRQVVZuVHF1aElBVDZ3UlNKSnZC?=
 =?utf-8?B?QnRhamZlVC9rQ2JmZkgxeE5ubzN0N1IzcC9qRnVCMjV2NG8zYTlSZEFYbUNu?=
 =?utf-8?B?YTJ3QjZjbUdXR29VN0lUaG1Ec0ZnN2JNcUl3QUltb2VOb1RKWE9XRnNIby9Y?=
 =?utf-8?B?aTZmTHV0U0l2OTJ0UUExU1RFOXJlcEZqQmNlSWQya0tUbU1jL25wUTVPaDBn?=
 =?utf-8?B?SVBmaVJMdzdrc2haNHJlaDR2dnFUcTkrZ1R5KzdvdnhvYlNTN0xaSUZvV0l2?=
 =?utf-8?B?MFhVdEdIR1MwT0FmeDJWcCtJeTFiRDdwVWtzZnBYdDhmdkhLZjZxMWlCN2Jr?=
 =?utf-8?B?elFzQk1qM20remk2RzU3bmtUS1RSMTlhL1BJZUlUQ0xUU0NBVXMraU5ER01I?=
 =?utf-8?B?TzhzaTV1M2hFWlRJODd3R3gxckF5NzlkME9kaVlMY1VhUWQ4NS9Hc1d2U0lu?=
 =?utf-8?B?d2pXeFQ3TVp1T1B4bTZSWTJMQTlZKytVNmVWdGxLV0JwQk44eWVJRzZ0NWR5?=
 =?utf-8?B?YXM2WFo2OUVtcUx3dDlGaG02ckdxNmZ4emJHdUpvZG9IQy9mZEdmVlZiVDlO?=
 =?utf-8?B?UlVDbjJXYlcyZSt5QUliSG9ib0kzdHY5Mmxna3BkcDl0cE03S3o2Zm9VS2px?=
 =?utf-8?Q?J3mng6XYQ8xZpcMx+e4mo2/3RWKuW1kKdn2ksKi?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jumptrading.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR14MB4796.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e32db84-a191-4594-a113-08d97a48433e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2021 02:01:43.3241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 11f2af73-8873-4240-85a3-063ce66fc61c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kwPchAZXZ+ujFikx0hokODIJ4/wbAs0UBw5JrLgZm464h5W/JH7Ou3H7+18GkHA+G+QBNYlgGS8Bcr1PUR6UPmaDsYcrSB4XVhMv5GJVGkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR14MB4514
X-Proofpoint-GUID: LdX3Cjbi6LQZEXyKM_stHp2iZEIsS423
X-Proofpoint-ORIG-GUID: 5Y6vo3YQBQN8PDtd8A0j1ImgiVJ01Jgz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_09,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109180012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3lsd2VzdGVyLA0KDQo+DQo+IFlvdSBhcmUgcmlnaHQgdGhlIHByb2JsZW0gaXMgd2l0aCBt
aXNjIElSUSB2ZWN0b3IgYnV0IGFzIGZhciBhcyBJIGNhbiBzZWUgdGhpcw0KPiBwYXRjaCBvbmx5
IG1vdmVzIGk0MGVfcmVzZXRfaW50ZXJydXB0X2NhcGFiaWxpdHkoKSBvdXRzaWRlIG9mDQo+IGk0
MGVfY2xlYXJfaW50ZXJydXB0X3NjaGVtZSgpLiBJdCBkb2VzIG5vdCBmaXggdGhlIHByb2JsZW0g
b2YNCj4gaTQwZV9mcmVlX21pc2NfdmVjdG9yKCkgb24gdW5hbGxvY2F0ZWQgdmVjdG9yIGluIGVy
cm9yIHBhdGguIFdlIGhhdmUgYQ0KPiBwcm9wZXIgZml4IGZvciB0aGlzIHRoYXQgYWRkcyBhZGRp
dGlvbmFsIGNoZWNrIGZvcg0KPiBfX0k0MEVfTUlTQ19JUlFfUkVRVUVTVEVEIGJpdCB0byBpNDBl
X2ZyZWVfbWlzY192ZWN0b3IoKToNCg0KSXQgZG9lcyBmaXggdGhlIHByb2JsZW0gaWYgeW91IGNh
bGwgdGhlIGZ1bmN0aW9uIHdoZW4gdGhlIE1JU0MgdmVjdG9yIGhhc24ndCBiZWVuIGFsbG9jYXRl
ZC4gIFllcywgSSBtb3ZlZCByZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eSgpIG91dCBzbyBpdCBj
b3VsZCBiZSBzZXBhcmF0ZWx5IGNhbGxlZCBpbiB0aGUgcHJvYmUoKSBlcnJvciBjbGVhbnVwIHBh
dGguDQoNCj4gICAgICAgICBpZiAocGYtPmZsYWdzICYgSTQwRV9GTEFHX01TSVhfRU5BQkxFRCAm
JiBwZi0+bXNpeF9lbnRyaWVzICYmDQo+ICAgICAgICAgICAgIHRlc3RfYml0KF9fSTQwRV9NSVND
X0lSUV9SRVFVRVNURUQsIHBmLT5zdGF0ZSkpIHsNCj4NCj4gVGhpcyBiaXQgaXMgc2V0IG9ubHkg
aWYgbWlzYyB2ZWN0b3Igd2FzIHByb3Blcmx5IGFsbG9jYXRlZC4gVGhlIHBhdGNoIHdpbGwgYmUg
b24NCj4gaW50ZWwtd2lyZWQgc29vbi4NCg0KVGhpcyBpc24ndCBldmVuIGluIHRoZSBPT1QgZHJp
dmVyIGZyb20gU291cmNlRm9yZ2UuICBBbmQgZXZlbiBpZiB5b3UgdXNlZCB0aGF0IHRvIGd1YXJk
IGZyZWVpbmcgdGhlIHZlY3RvciBvciBub3QsIHRoZSBmaXJzdCBiaXQgb2YgdGhhdCBmdW5jdGlv
biBpcyBzdGlsbCB3cml0aW5nIHRvIGEgcmVnaXN0ZXIgdG8gZGlzYWJsZSB0aGF0IGNhdXNlIGlu
IHRoZSBoYXJkd2FyZToNCg0Kc3RhdGljIHZvaWQgaTQwZV9mcmVlX21pc2NfdmVjdG9yKHN0cnVj
dCBpNDBlX3BmICpwZikNCnsNCiAgICAgICAgLyogRGlzYWJsZSBJQ1IgMCAqLw0KICAgICAgICB3
cjMyKCZwZi0+aHcsIEk0MEVfUEZJTlRfSUNSMF9FTkEsIDApOw0KICAgICAgICBpNDBlX2ZsdXNo
KCZwZi0+aHcpOw0KDQpXb3VsZCB5b3Ugc3RpbGwgd2FudCB0byBkbyB0aGF0IGJsaW5kbHkgaWYg
dGhlIHZlY3RvciB3YXNuJ3QgYWxsb2NhdGVkIGluIHRoZSBmaXJzdCBwbGFjZT8gIFNlZW1zIGV4
Y2Vzc2l2ZSwgYnV0IGl0J2QgYmUgaGFybWxlc3MuICBTZWVtcyBsaWtlIG5vdCBjYWxsaW5nIHRo
aXMgZnVuY3Rpb24gYWx0b2dldGhlciB3b3VsZCBiZSBjbGVhbmVyIGFuZCBnZW5lcmF0ZSBsZXNz
IE1NSU8gYWN0aXZpdHkgaWYgdGhlIE1JU0MgdmVjdG9yIHdhc24ndCBhbGxvY2F0ZWQgYXQgYWxs
IGFuZCB3ZSdyZSBmYWxsaW5nIG91dCBvZiBhbiBlcnJvciBwYXRoLi4uDQoNCkkgYW0gcmVhbGx5
IGF0IGEgbG9zcyBoZXJlLiAgVGhpcyBpcyBjbGVhcmx5IGJyb2tlbi4gIFdlIGhhdmUgYW4gT29w
cy4gIFdlIGdldCB0aGVzZSBvY2Nhc2lvbmFsbHkgb24gYm9vdCwgYW5kIGl0J3MgcmVhbGx5IGFu
bm95aW5nIHRvIGRlYWwgd2l0aCBvbiBwcm9kdWN0aW9uIG1hY2hpbmVzLiAgV2hhdCBpcyB0aGUg
ZGVmaW5pdGlvbiBvZiAic29vbiIgaGVyZSBmb3IgdGhpcyBuZXcgcGF0Y2ggdG8gc2hvdyB1cD8g
IE15IGRpc3RybyB2ZW5kb3Igd291bGQgbG92ZSB0byBwdWxsIHNvbWUgc29ydCBvZiBmaXggaW4g
c28gd2UgY2FuIGdldCBpdCBpbnRvIG91ciBidWlsZCBpbWFnZXMsIGFuZCBzdG9wIGhhdmluZyB0
aGlzIHByb2JsZW0uICBNeSBwYXRjaCBmaXhlcyB0aGUgaW1tZWRpYXRlIHByb2JsZW0uICBJZiB5
b3UgZG9uJ3QgbGlrZSB0aGUgcGF0Y2ggKHdoaWNoIGl0IGFwcGVhcnMgeW91IGRvbid0OyB0aGF0
J3MgZmluZSksIHRoZW4gc3RhbGxpbmcgb3Igc2F5aW5nIGEgZGlmZmVyZW50IGZpeCBpcyBjb21p
bmcgInNvb24iIGlzIHJlYWxseSBub3QgYSBncmVhdCBzdXBwb3J0IG1vZGVsLiAgVGhpcyB3b3Vs
ZCBiZSBncmVhdCB0byBtZXJnZSwgYW5kIHRoZW4gaWYgeW91IHdhbnQgdG8gbWFrZSBpdCAiYmV0
dGVyIiBvbiB5b3VyIHNjaGVkdWxlLCBpdCdzIG9wZW4gc291cmNlLCBhbmQgeW91IGNhbiBzdWJt
aXQgYSBwYXRjaC4gIE9yIEknbGwgYmUgaGFwcHkgdG8gcmVzcGluIHRoZSBwYXRjaCwgYnV0IHN0
aWxsIGNhbGxpbmcgZnJlZV9taXNjX3ZlY3RvcigpIGluIGFuIGVycm9yIHBhdGggd2hlbiB0aGUg
TUlTQyB2ZWN0b3Igd2FzIG5ldmVyIGFsbG9jYXRlZCBzZWVtcyBsaWtlIGEgYmFkIGRlc2lnbiBk
ZWNpc2lvbiB0byBtZS4NCg0KLVBKDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
DQoNCk5vdGU6IFRoaXMgZW1haWwgaXMgZm9yIHRoZSBjb25maWRlbnRpYWwgdXNlIG9mIHRoZSBu
YW1lZCBhZGRyZXNzZWUocykgb25seSBhbmQgbWF5IGNvbnRhaW4gcHJvcHJpZXRhcnksIGNvbmZp
ZGVudGlhbCwgb3IgcHJpdmlsZWdlZCBpbmZvcm1hdGlvbiBhbmQvb3IgcGVyc29uYWwgZGF0YS4g
SWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgeW91IGFyZSBoZXJlYnkgbm90
aWZpZWQgdGhhdCBhbnkgcmV2aWV3LCBkaXNzZW1pbmF0aW9uLCBvciBjb3B5aW5nIG9mIHRoaXMg
ZW1haWwgaXMgc3RyaWN0bHkgcHJvaGliaXRlZCwgYW5kIHJlcXVlc3RlZCB0byBub3RpZnkgdGhl
IHNlbmRlciBpbW1lZGlhdGVseSBhbmQgZGVzdHJveSB0aGlzIGVtYWlsIGFuZCBhbnkgYXR0YWNo
bWVudHMuIEVtYWlsIHRyYW5zbWlzc2lvbiBjYW5ub3QgYmUgZ3VhcmFudGVlZCB0byBiZSBzZWN1
cmUgb3IgZXJyb3ItZnJlZS4gVGhlIENvbXBhbnksIHRoZXJlZm9yZSwgZG9lcyBub3QgbWFrZSBh
bnkgZ3VhcmFudGVlcyBhcyB0byB0aGUgY29tcGxldGVuZXNzIG9yIGFjY3VyYWN5IG9mIHRoaXMg
ZW1haWwgb3IgYW55IGF0dGFjaG1lbnRzLiBUaGlzIGVtYWlsIGlzIGZvciBpbmZvcm1hdGlvbmFs
IHB1cnBvc2VzIG9ubHkgYW5kIGRvZXMgbm90IGNvbnN0aXR1dGUgYSByZWNvbW1lbmRhdGlvbiwg
b2ZmZXIsIHJlcXVlc3QsIG9yIHNvbGljaXRhdGlvbiBvZiBhbnkga2luZCB0byBidXksIHNlbGws
IHN1YnNjcmliZSwgcmVkZWVtLCBvciBwZXJmb3JtIGFueSB0eXBlIG9mIHRyYW5zYWN0aW9uIG9m
IGEgZmluYW5jaWFsIHByb2R1Y3QuIFBlcnNvbmFsIGRhdGEsIGFzIGRlZmluZWQgYnkgYXBwbGlj
YWJsZSBkYXRhIHByb3RlY3Rpb24gYW5kIHByaXZhY3kgbGF3cywgY29udGFpbmVkIGluIHRoaXMg
ZW1haWwgbWF5IGJlIHByb2Nlc3NlZCBieSB0aGUgQ29tcGFueSwgYW5kIGFueSBvZiBpdHMgYWZm
aWxpYXRlZCBvciByZWxhdGVkIGNvbXBhbmllcywgZm9yIGxlZ2FsLCBjb21wbGlhbmNlLCBhbmQv
b3IgYnVzaW5lc3MtcmVsYXRlZCBwdXJwb3Nlcy4gWW91IG1heSBoYXZlIHJpZ2h0cyByZWdhcmRp
bmcgeW91ciBwZXJzb25hbCBkYXRhOyBmb3IgaW5mb3JtYXRpb24gb24gZXhlcmNpc2luZyB0aGVz
ZSByaWdodHMgb3IgdGhlIENvbXBhbnnigJlzIHRyZWF0bWVudCBvZiBwZXJzb25hbCBkYXRhLCBw
bGVhc2UgZW1haWwgZGF0YXJlcXVlc3RzQGp1bXB0cmFkaW5nLmNvbS4NCg==
