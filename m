Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDE72CF6BB
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgLDW3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:29:01 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:60092 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLDW3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 17:29:01 -0500
Received: from pps.filterd (m0170391.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4MM78F031024;
        Fri, 4 Dec 2020 17:28:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=9SQ4eCcXf/8EdWVtjKHn1UORD8kyuyJt6K2Vdryq/XM=;
 b=NWkqLmfnHg/+GfGCPEzUPmY+eeMBPu8XxrHHhDRFiwPVCtXR3rTIhtfSCp1SwhGeXXIb
 0FxZ7zoeeOEvGPwa7Uij0/t7E2KLPOFCM/Ulz1sCxNAeUMeZDg1GltkZNLIg/vzr/1h6
 SlbXOgTRsZ579vU/5nuNLe1blj/Y/csNTtevBZPvSQZ8ZmLfLQI99PenKKYpVg+DNxLA
 T8RF6fgtS/QlzLnfht4NHFgMw70VwdTM9HB0u9XUyOqvwizDX5K3briEaBnRHlxLv6pP
 pFy5N6NUk/nhdBmsBPtAYhpisLilQduINmHenBEi5AxpybA5r0notqaHAqGj+bQiAB+J gw== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 353jk34h0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 17:28:09 -0500
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4MRgMl038003;
        Fri, 4 Dec 2020 17:28:08 -0500
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by mx0a-00154901.pphosted.com with ESMTP id 357t88kddv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 17:28:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYuWzKN8u7P+mkvzfnt6EnEcFAKUE9asbNS3yjj3ToNEo/MKcRygpXmI8kaCAqvIGkTCNLULk4t1xHjd9dyEfSydjAxhuvBR4zNRzjDEj+tw1UrCDP1KAHASjorez4o+QWOZEtm2cKr59Gy/QNO+xpGJS1TzoIhnhT6BFbCuVPD485lLEaFIJ7i0650NGx6X6XU32Spa11P+1MTxex0bTXSDeBo3ilJy38F7t9h5zoIfV0lAsOgwrUZnwSfzKXuXbLnq8SaVOzZROJEJj99VSq2Z2SFx5EALH5XoIspVcJUXT1uaJTjoPK2MmuEGgIL1bgC9TYV1kegTW9LaVe83Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SQ4eCcXf/8EdWVtjKHn1UORD8kyuyJt6K2Vdryq/XM=;
 b=bx9ViK/iWd9pwMgnkMAOB/Or+uClO3o5pStyxlQMGBaUe5BvjMIq5iUSi7Lt5LDzIDmyDGbVOtEKF7UXDX2yS7jwd2U3E6QoPn7IAFkJ2J9755+6WsN8N3SwMR6L9jWAJujAkKeT45VWNih7girRJ70AuOhL902CYd0u4n0K63vPNQKu7RtuUoC21sS6dluZBJUFYnOR98LDnAIAlRIfua68nxP+219/Il82dqFKrz0BRy7p67YpwuUUfFg8D+EoTYc+D8vErZTsJl6tyXnExvhK4xh9TStnS/DA7thYAEmSVZ8fFHuRQT2VPHQToGsKU3wNBfJuNtwx//AYFS5nQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SQ4eCcXf/8EdWVtjKHn1UORD8kyuyJt6K2Vdryq/XM=;
 b=hUS9pOoTHZqqr7tMGVUFkbaLD2PY0WTojUI+Fb+O0vZptisfwO8Qq8PeCczscyOUKQQ3Y9BI3GOeRW73+e8UGLbBxHSgaht5ra1Kyxg4Pwk2+F+CQ38B9X78QJTMk288G12j7059TwRZ8LnZbMlcBCn3C44ILgC3a4G9i/bBCQo=
Received: from DM6PR19MB2636.namprd19.prod.outlook.com (2603:10b6:5:15f::15)
 by DM6PR19MB4216.namprd19.prod.outlook.com (2603:10b6:5:2bd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Fri, 4 Dec
 2020 22:28:06 +0000
Received: from DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914]) by DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914%7]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 22:28:06 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        David Arcari <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>
Subject: RE: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
Thread-Topic: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
Thread-Index: AQHWynlfqP1K6e0vqUqfE6etAZ98Tqnnc3yAgAAQmDA=
Date:   Fri, 4 Dec 2020 22:28:06 +0000
Message-ID: <DM6PR19MB2636B200D618A5546E7BBB57FAF10@DM6PR19MB2636.namprd19.prod.outlook.com>
References: <20201204200920.133780-1-mario.limonciello@dell.com>
 <CAKgT0Uc=OxcuHbZihY3zxsxzPprJ_8vGHr=reBJFMrf=V9A5kg@mail.gmail.com>
In-Reply-To: <CAKgT0Uc=OxcuHbZihY3zxsxzPprJ_8vGHr=reBJFMrf=V9A5kg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-12-04T22:26:33.9605036Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=966b8055-3d86-4004-8624-a644808bab78;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d61e4417-c178-4b38-1855-08d898a3df55
x-ms-traffictypediagnostic: DM6PR19MB4216:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR19MB4216A4B37EC5FCABE6F62074FAF10@DM6PR19MB4216.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iYwDJepitNaB6V9RPCBX/QV46M3SHCnHPCU1OF4gjv44If1MgqPNtm0qieoWIKPejVMRACePexE8gXA9IQOFqOsIwwkbB8FmJztg4beHsnoBWvU0C451o+LAC0aFAZwhmOLUTqQqClki4adgl7XFupF3nEmYWSZJX0DzGkW2kU1MKg+VNgWWQLJfgsksMpBzWQ8FdUW3EdfKHA+2M1bxwOaOZCDyx7ywtWYNVH2USszydFTqnPXncsdtDi0gNpvrXnDhQL1KCi4ZeukLqCopAHFlVpe8QgE0fuqBKdYwRhTjxjBSr94eEbbmN53WnzJlZSw9cnSoVHK3Mydh78ZVptxhJuDhIgVsPb5TqlTMYaR4ml6XIPurWKxo5nUB+A3ExY8XuDUqm0K/hXRQhJwlDW/Me/VBJ2D43HooYn+/0gcP9+tiumwse1VCQJTPkgcNu98ZBXJSrR0+2qypNtNg/FLyDPwhP7XwJ/vsy8RWp/g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB2636.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(26005)(52536014)(478600001)(8936002)(66946007)(5660300002)(83380400001)(9686003)(7416002)(8676002)(4326008)(71200400001)(2906002)(66556008)(33656002)(76116006)(53546011)(64756008)(66476007)(186003)(54906003)(966005)(86362001)(6506007)(66446008)(55016002)(6916009)(786003)(316002)(7696005)(32563001)(6606295002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?K2dpWG1acFgzdkljb2I1QVRRdEtTWW5HYW1LK2JuWmxkSng5K2hNQU5hTU1o?=
 =?utf-8?B?UG9sWlJDcE15Uy9menVMZm1CSU1nL2Z5SEhlTkhBVVdhaU1SdnlnUUNmZUVu?=
 =?utf-8?B?WW9TWG11Y1pGVllWM2QvTC9pdTRkL2M5amxleVBSb0RHeTIxc1pneW1VODNR?=
 =?utf-8?B?T2FOR2lSY2dyckFrMWY4R0tPU2EvVDBWcm5xaFVGQnc2NnQxWjFORmdBb3gv?=
 =?utf-8?B?bUNUUldaeHZRQllRMkIvNEEzc2NFbjZlZ0pFb2ZLZWFoTEpqMnVTcGNnOUxH?=
 =?utf-8?B?cnZRZFhJTmhPMlRyWHZ3RnVTejhZNDVjUlNSVDJwNHBDWWF2VzVFejVGMGFa?=
 =?utf-8?B?Nll0OUJqaERqcmcyOVlodXQwbWZIY28xejhtSnRuSGdob1BLc1hJNVpBcFFa?=
 =?utf-8?B?UkY0OXl2SGlORE9BYVFGbWZXTlA0NGlCeDEwZU5yQUVRM1kvMkcvZFBQRmln?=
 =?utf-8?B?UlFJV0hSekxmbVF0VE9HM1B1dStUUURybGFkRTdWTUpEWC8waTRmTWVpVmpk?=
 =?utf-8?B?Ync2Rk9oUTBFdFNvK3ZQb3dieDFMeldTZkdKa0JGbzNRNTl0U1pFQlVZUHBG?=
 =?utf-8?B?eDNaTlNabGx2a0REc1FMRGZZdHRZcTJrWWs0eEhCSkpnNmMyVFJORzB6R3NK?=
 =?utf-8?B?dDRBWklaKzV3Q3R0bmNCcktHRmNRQnptQUt2N1lVbDAzZlgzajNSNlFHVTFB?=
 =?utf-8?B?dnM1RHFjMG5uVm5XWFNvLzV4Y28vN1ZseCs4Q0ZpZ0NHN212cnZ1cVVpMXlP?=
 =?utf-8?B?MTBNbzN0RDVkMXgvU2drcGlIMDRCSWtFYUxHci95M01NbzU3Wko0ek0yYXZz?=
 =?utf-8?B?L3lZaFBhM0ZYc3Zsc25YMmRpS1BjdjAxM1pqVThHdkJnMnFxR3VzTnUzVmds?=
 =?utf-8?B?eVJzSHBJMVd6N2pDT2M2OEkrbmlrNWRyQTNIbTNvajZGdGQ0R3p3N244SzFt?=
 =?utf-8?B?cmQ3YVAxUHByR2p4K2ttSzlHaUZIVVBvYU9Qcy96dUdBR3lTSlh1OWZkbG5i?=
 =?utf-8?B?NWhzWDV4MUJPWG1jVGF6ZitTem4rbUdqbWlldE5tY1JvQ3BCaURkRmFUYjA5?=
 =?utf-8?B?M3I2bitvdlFUWUtscEFxdERnbWhJbk1lSVFiTjlkOU84RXRRK1BodEZpay9q?=
 =?utf-8?B?Q1BYcnBsd0Q5QUhzQ1hsc1dUb0prQS9MamlkYnZtbUlGbUE2VWpBb21tREFF?=
 =?utf-8?B?MkpDcWNWdWNYOWxuVVovNHFHTmZ6bStROGpFL1NnUHZQOE42ejA4T0RZbVJt?=
 =?utf-8?B?TU9iMjBtaFhpRVJnMVgwZzF5RXF6SjBUMGJNNzY0dmN2MzduRGw4WTc4RHRI?=
 =?utf-8?Q?5FtsFiSYNB8F4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB2636.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d61e4417-c178-4b38-1855-08d898a3df55
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 22:28:06.5433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PsqGL3v7hM9JBlzw59pLf+Gs2KHntOomrjlkLbJfhPcRPzZsdG4+LjCGyF/tAR4owSMdBQWaJ++TgJTnIxDY599qvMtJ6OR9Ni/dnyMS3Os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB4216
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_12:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1011 priorityscore=1501 spamscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040127
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4YW5kZXIgRHV5Y2sgPGFs
ZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgRGVjZW1iZXIgNCwgMjAy
MCAxNToyNw0KPiBUbzogTGltb25jaWVsbG8sIE1hcmlvDQo+IENjOiBKZWZmIEtpcnNoZXI7IFRv
bnkgTmd1eWVuOyBpbnRlbC13aXJlZC1sYW47IExLTUw7IExpbnV4IFBNOyBOZXRkZXY7IEpha3Vi
DQo+IEtpY2luc2tpOyBTYXNoYSBOZXRmaW47IEFhcm9uIEJyb3duOyBTdGVmYW4gQXNzbWFubjsg
RGF2aWQgTWlsbGVyOyBEYXZpZA0KPiBBcmNhcmk7IFNoZW4sIFlpanVuOyBZdWFuLCBQZXJyeTsg
YW50aG9ueS53b25nQGNhbm9uaWNhbC5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MyAwLzdd
IEltcHJvdmUgczBpeCBmbG93cyBmb3Igc3lzdGVtcyBpMjE5TE0NCj4gDQo+IA0KPiBbRVhURVJO
QUwgRU1BSUxdDQo+IA0KPiBPbiBGcmksIERlYyA0LCAyMDIwIGF0IDEyOjA5IFBNIE1hcmlvIExp
bW9uY2llbGxvDQo+IDxtYXJpby5saW1vbmNpZWxsb0BkZWxsLmNvbT4gd3JvdGU6DQo+ID4NCj4g
PiBjb21taXQgZTA4NmJhMmZjY2RhICgiZTEwMDBlOiBkaXNhYmxlIHMwaXggZW50cnkgYW5kIGV4
aXQgZmxvd3MgZm9yIE1FDQo+IHN5c3RlbXMiKQ0KPiA+IGRpc2FibGVkIHMwaXggZmxvd3MgZm9y
IHN5c3RlbXMgdGhhdCBoYXZlIHZhcmlvdXMgaW5jYXJuYXRpb25zIG9mIHRoZQ0KPiA+IGkyMTkt
TE0gZXRoZXJuZXQgY29udHJvbGxlci4gIFRoaXMgd2FzIGRvbmUgYmVjYXVzZSBvZiBzb21lIHJl
Z3Jlc3Npb25zDQo+ID4gY2F1c2VkIGJ5IGFuIGVhcmxpZXINCj4gPiBjb21taXQgNjMyZmJkNWVi
NWIwZSAoImUxMDAwZTogZml4IFMwaXggZmxvd3MgZm9yIGNhYmxlIGNvbm5lY3RlZCBjYXNlIikN
Cj4gPiB3aXRoIGkyMTktTE0gY29udHJvbGxlci4NCj4gPg0KPiA+IFBlcmZvcm1pbmcgc3VzcGVu
ZCB0byBpZGxlIHdpdGggdGhlc2UgZXRoZXJuZXQgY29udHJvbGxlcnMgcmVxdWlyZXMgYQ0KPiBw
cm9wZXJseQ0KPiA+IGNvbmZpZ3VyZWQgc3lzdGVtLiAgVG8gbWFrZSBlbmFibGluZyBzdWNoIHN5
c3RlbXMgZWFzaWVyLCB0aGlzIHBhdGNoDQo+ID4gc2VyaWVzIGFsbG93cyBkZXRlcm1pbmluZyBp
ZiBlbmFibGVkIGFuZCB0dXJuaW5nIG9uIHVzaW5nIGV0aHRvb2wuDQo+ID4NCj4gPiBUaGUgZmxv
d3MgaGF2ZSBhbHNvIGJlZW4gY29uZmlybWVkIHRvIGJlIGNvbmZpZ3VyZWQgY29ycmVjdGx5IG9u
IERlbGwncw0KPiBMYXRpdHVkZQ0KPiA+IGFuZCBQcmVjaXNpb24gQ01MIHN5c3RlbXMgY29udGFp
bmluZyB0aGUgaTIxOS1MTSBjb250cm9sbGVyLCB3aGVuIHRoZSBrZXJuZWwNCj4gYWxzbw0KPiA+
IGNvbnRhaW5zIHRoZSBmaXggZm9yIHMwaTMuMiBlbnRyeSBwcmV2aW91c2x5IHN1Ym1pdHRlZCBo
ZXJlIGFuZCBub3cgcGFydCBvZg0KPiB0aGlzDQo+ID4gc2VyaWVzLg0KPiA+IGh0dHBzOi8vbWFy
Yy5pbmZvLz9sPWxpbnV4LW5ldGRldiZtPTE2MDY3NzE5NDgwOTU2NCZ3PTINCj4gPg0KPiA+IFBh
dGNoZXMgNCB0aHJvdWdoIDcgd2lsbCB0dXJuIHRoZSBiZWhhdmlvciBvbiBieSBkZWZhdWx0IGZv
ciBzb21lIG9mIERlbGwncw0KPiA+IENNTCBhbmQgVEdMIHN5c3RlbXMuDQo+IA0KPiBUaGUgcGF0
Y2hlcyBsb29rIGdvb2QgdG8gbWUuIEp1c3QgbmVlZCB0byBhZGRyZXNzIHRoZSBtaW5vciBpc3N1
ZSB0aGF0DQo+IHNlZW1zIHRvIGhhdmUgYmVlbiBwcmVzZW50IHByaW9yIHRvIHRoZSBpbnRyb2R1
Y3Rpb24gb2YgdGhpcyBwYXRjaA0KPiBzZXQuDQo+IA0KPiBSZXZpZXdlZC1ieTogQWxleGFuZGVy
IER1eWNrIDxhbGV4YW5kZXJkdXlja0BmYi5jb20+DQoNClRoYW5rcyBmb3IgeW91ciByZXZpZXcu
ICBKdXN0IHNvbWUgb3BlcmF0aW9uYWwgcXVlc3Rpb25zIC0gc2luY2UgdGhpcyBwcmV2aW91c2x5
DQpleGlzdGVkIGRvIHlvdSB3YW50IG1lIHRvIHJlLXNwaW4gdGhlIHNlcmllcyB0byBhIHY0IGZv
ciB0aGlzLCBvciBzaG91bGQgaXQgYmUNCmEgZm9sbG93IHVwIGFmdGVyIHRoZSBzZXJpZXM/DQoN
CklmIEkgcmVzcGluIGl0LCB3b3VsZCB5b3UgcHJlZmVyIHRoYXQgY2hhbmdlIHRvIG9jY3VyIGF0
IHRoZSBzdGFydCBvciBlbmQNCm9mIHRoZSBzZXJpZXM/DQo=
