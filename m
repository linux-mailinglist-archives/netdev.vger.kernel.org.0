Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1692DB26D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgLORWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:22:19 -0500
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:65102 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727655AbgLORWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:22:18 -0500
Received: from pps.filterd (m0170396.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFHIN6g026089;
        Tue, 15 Dec 2020 12:21:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=+dImOIgf/WhChsYMaSXZ9U9b+gsHTK6ynz3diJd4PLQ=;
 b=QrHL9IuD8LcclHA4s5idbhww4mFaHMOOUJgZoGKZnnbA2OWiSyzeOM6UVNEUwceb/12J
 KhJU3ImGSQVmiu76KONhO2XIRrBcKM9kYIyV6mWe0xFRLwCmg1XedMg0oOjuPx2UeN6T
 ip9s9s4x1S2ZDN3pxjdKY/0TI3gO6CmOzWJzntGTkA9VdWQ1OeD+TBafZ1TtxPtiMGVo
 vZMPiQVYJPgZx7P93aTXjyEB6Y7/xGsV1F9hZNWRyBmpCtH5F4zdNC5k8+6nBHL0kY5c
 C8qYX1ImyeSCGLmmoFDAugn3Jci9ELYpP4Iwd+Kf9NlEGI67gULd5Zx58tOQx4IujvxL sA== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0b-00154904.pphosted.com with ESMTP id 35ctk4k0xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 12:21:26 -0500
Received: from pps.filterd (m0134318.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFHJZIs025160;
        Tue, 15 Dec 2020 12:21:26 -0500
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2053.outbound.protection.outlook.com [104.47.45.53])
        by mx0a-00154901.pphosted.com with ESMTP id 35f0rf93a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 12:21:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOkgBNaiu0llxy1eOJE8HXqGkzxZEsk4wMN0AItBiFTaQ02OZw8XVa4LE0Y+kaLKhDK/A6dcXQnb8J2g/JKWhkZVVDi2fFcyDbFezIVgEv+XtAO7CpZ/YTyaNXgkzlo6vYn4rVbllChg+rYT33qaMr4pKTK73ltEcqY9SVY5iYVRO4l/5fdje2j43Rn3KFXEEB/4AnChNA317kC7NW3UvK6h1adf7IvCMeK8X4gqmEBydiCgtdireHDriVzLNfbcC9JmDYxOtyLUBTwD5GRt06dmDi4fkl926MT5iszKRmRRm8252zqQQDJZffQnuhH/Br41Fi58aoCPJi4ucwm07A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dImOIgf/WhChsYMaSXZ9U9b+gsHTK6ynz3diJd4PLQ=;
 b=X8/L/1K7U3UZ1ca9CRuxT1scqkaarL4E/sr38tBC5v4s+WayfZofoCmJFHXr6s0Iwbxw2NIdSLfiPD/lR4HBl2g26DbQDUzpnkpxFzNw7P9t/OdfAfY68O2vu2ftRulwkft9AbKGilliDHNhuEM66imZL4UK6+eoqIkvAxobGrDUqFIqhvmExeK+qeCf0p0i71rq4Asx701SatPIg58kWWu93/w5N2EK3qMCvboWhM2IPmc3OwH53AUcl4T1GDN53eXL5576OT9eMdAW9GMB09YA7JFuinHJ0Ln2LZQAWiNsWK/zIYIYg2ocZR2GH2EDwJx3mCoZyJCO1dwN8dlaQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dImOIgf/WhChsYMaSXZ9U9b+gsHTK6ynz3diJd4PLQ=;
 b=d5RMQIjRCvt7lOeoHvDEMGyU8+WzMVRNuk9UkKugSzbJ65PQT0JfTFLW5CJB+tauaYcECyjDM44g8eysvBz9ARj+FXq2uAxIYC8+zxxOZfhk8UWEJGJzcV/huR7MHgVYhqA3MpAMm3feONSDBUzOAaIZveid+YREdiKH39Q/w7E=
Received: from DM6PR19MB2636.namprd19.prod.outlook.com (2603:10b6:5:15f::15)
 by DM5PR19MB1579.namprd19.prod.outlook.com (2603:10b6:3:14f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.21; Tue, 15 Dec
 2020 17:20:19 +0000
Received: from DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914]) by DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914%7]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 17:20:19 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        Mark Pearson <markpearson@lenovo.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        Aaron Ma <aaron.ma@canonical.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Efrati, Nir" <nir.efrati@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
Subject: RE: Fw: [External] Re: [PATCH v4 0/4] Improve s0ix flows for systems
 i219LM
Thread-Topic: Fw: [External] Re: [PATCH v4 0/4] Improve s0ix flows for systems
 i219LM
Thread-Index: AQHW0i6xs9Hb0tASW0mYD0yDIIAYe6n26HEAgAAGRJGAATfAgIAAQcuw
Date:   Tue, 15 Dec 2020 17:20:18 +0000
Message-ID: <DM6PR19MB2636FA6E479914432036987BFAC60@DM6PR19MB2636.namprd19.prod.outlook.com>
References: <20201214153450.874339-1-mario.limonciello@dell.com>
 <80862f70-18a4-4f96-1b96-e2fad7cc2b35@redhat.com>
 <PS2PR03MB37505A15D3C9B7505D679D7BBDC70@PS2PR03MB3750.apcprd03.prod.outlook.com>
 <ae436f90-45b8-ba70-be57-d17641c4f79d@lenovo.com>
 <18c1c152-9298-a4c5-c4ed-92c9fd91ea8a@intel.com>
In-Reply-To: <18c1c152-9298-a4c5-c4ed-92c9fd91ea8a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-12-15T17:20:00.3750999Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=8ae9a86e-cabc-4264-8c49-694692c9756b;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5397ae9e-eb53-4b5c-efe7-08d8a11db249
x-ms-traffictypediagnostic: DM5PR19MB1579:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR19MB1579BA21FA9BC1BCB8864C6AFAC60@DM5PR19MB1579.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ropzliua6JKpR58Z1V/Plx/AKlE/jM/V5AKGg+DujfZsd7ogCzzj4I53DQIOOmLJz4kBSIH+uzu1x6gJDCmLxDxipO43J4INpCTmLxHMXoihxqK9TB8n4OGDzjHJudBfwPJbDdqODSjoEU5tehY2Y7Z0d7R3rjZwTp4hSBdxY0fq+G5gu32NK6q9Ia/6qKfN25iIFwbf2tkAvKzb903yahe128RMl7MOLPYIPneoE7BZUbrpt4g/oCNJvjOSCM+IQsFMeTL/WcE+GEbcL2Sbv0rNU3zW9QtbLeRAuHuRGpw3AtPFJtTIdQTGQdERgvcI/KB2+kIOlBoQKkVeVuEB8TKFTukDKkbW1p4v+euje5b9gzzhnLA9xboPICBoL496
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB2636.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(54906003)(26005)(508600001)(6506007)(55016002)(66476007)(110136005)(83380400001)(66946007)(66556008)(8936002)(64756008)(33656002)(71200400001)(66446008)(4326008)(52536014)(786003)(8676002)(7696005)(4744005)(86362001)(76116006)(9686003)(186003)(7416002)(5660300002)(2906002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WFJSK0JqVHNpZjNPNDkxc3g2ek5pZSsxcFFTYnFPOEtKRml2S05Vd1VaSVM1?=
 =?utf-8?B?alE5M2QvTTZKcXlzWXdkRlhiOFc4UVJWd3dvKytsc3Q1NjZUWUJuTTZlYzlB?=
 =?utf-8?B?VGI2MlNpUWhya0hiREFsUjdrNTB3aXd1dSt4WFVVZ3ZaQ0NjeHdRVzlORGl3?=
 =?utf-8?B?eHhvbUE5LzFKMEJFbW0yZ2REWGh3MytyaDlwYmlMSTRzeGZ3WXhwSTFVYm9n?=
 =?utf-8?B?YmVWT0pGbE5wRG9TV2daT3BvOGxzcHlVTTZZYlk4dGV6Q3UwSGYzcTd2RURp?=
 =?utf-8?B?WHp6U0FRckJOc2VRSFl1cjFSamJQaU9OWjM2UEJKUUpDWTB6MTc4enREYnpa?=
 =?utf-8?B?cnpzaGxlOHFhMFpxT3hTcTVBVS9aMmZoY1BTTjFHSVgxYnlOOXhSU25tK1lL?=
 =?utf-8?B?YmdUSW56STREM3IzMjVtVERiOHU2MHNTamVHVWdzRW8wcUJIRzJRY0doZC9s?=
 =?utf-8?B?QkJTdVZNSDZCeEMvNld0OGswckxKRklwVUhYRzFqZ1BoOW94NEgrbURaTWhz?=
 =?utf-8?B?MTErTUxERTJJdXprN2pCRVRVTHJyTXJBRURzdlNBWlhKQ3ZhTDZTL3BWR2Y2?=
 =?utf-8?B?SERzL0daV2xZZ2FYRTg0b0VUa2wxR1hWajlsT0YvSitESkgrVmVuTjQ4Q0g2?=
 =?utf-8?B?djhjSGV0cWgrTUxTQU4yWXc3cU1jMWVxSHl4QlFjNHdMWkdUaHFoNVpWeTNh?=
 =?utf-8?B?eUdyeTR1SERWYmtwOHd6enJ5SzhJWGgyUGFucUhFeXk2emFpS0RNZG1QSERM?=
 =?utf-8?B?OEFSalROaXVBV055V292L29tUXN1cHlHSElFWHUrM3JFVFJ6N2Y2cmhQSTJm?=
 =?utf-8?B?V0JXSXZPQjc3SXF6ZEx4a0FtNjRYL0tNUmZrRDVEN2diajRDbFluUWd6OWFQ?=
 =?utf-8?B?NVFPSkFRWlJnV2Vja29RaXRxS1h3WVlLZWN4ajd3Znl1WHY5ZUpYSi9STFRN?=
 =?utf-8?B?eDBGV1hSOVBtLzdYaUpKRGUrK3A0RVFwckhRRUZlaGZCQ3VhcVcrZVRWNDhW?=
 =?utf-8?B?RHovVEVGdmlJSTBYb3pYRW9UcFVSV3NDaDBrU3Qxa1VoK25IemhXTTRZcmZJ?=
 =?utf-8?B?Y0pwZWk3TTRSSDM5eU41T3hzemNDMGhwbXNuMXZ5RlFhZjBzcEVzMEtoSHRD?=
 =?utf-8?B?L2FsVkFLcFFQVnZFWTNWL2tES05yOWdpM04wQVhSd01FSzV1bWYxeUM1clQz?=
 =?utf-8?B?YXdQY3JYSENRQ1pZdk9vRGdaK3Q1d2E3N0xzSVV0TzFJN2tpaEd1UFQyZ0Y4?=
 =?utf-8?B?NjdMTnF4WmRIN1V2bFBiU0RnbllIMkk0Z0VzdWg0RXFDTjhVb2hnc3JPcWV0?=
 =?utf-8?Q?trzuzoO0U5kPk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB2636.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5397ae9e-eb53-4b5c-efe7-08d8a11db249
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 17:20:18.8499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: frVIvWWnmrBPbchgIwGh2SE7fjEnYZYj5yte3D03PpuWO04pUktatW3YTYfvH3n9b0f34PLyS8MfpEnqS5nHxBQ2cONyG44Y/b88cQmKn90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR19MB1579
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 clxscore=1011 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150116
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+ID4gQWJzb2x1dGVseSAtIEknbGwgYXNrIHRoZW0gdG8gbG9vayBpbnRvIHRoaXMgYWdhaW4u
DQo+ID4NCj4gd2UgbmVlZCB0byBleHBsYWluIHdoeSBvbiBXaW5kb3dzIHN5c3RlbXMgcmVxdWly
ZWQgMXMgYW5kIG9uIExpbnV4DQo+IHN5c3RlbXMgdXAgdG8gMi41cyAtIG90aGVyd2lzZSBpdCBp
cyBub3QgcmVsaWFibGUgYXBwcm9hY2ggLSB5b3Ugd2lsbA0KPiBlbmNvdW50ZXIgb3RoZXJzIGJ1
Z2d5IHN5c3RlbS4NCj4gKE1FIG5vdCBQT1Igb24gdGhlIExpbnV4IHN5c3RlbXMgLSBpcyBvbmx5
IG9uZSBwb3NzaWJsZSBhbnN3ZXIpDQoNClNhc2hhOiBJbiB5b3VyIG9waW5pb24gZG9lcyB0aGlz
IGluZm9ybWF0aW9uIG5lZWQgdG8gYmxvY2sgdGhlIHNlcmllcz8NCm9yIGNhbiB3ZSBmb2xsb3cg
dXAgd2l0aCBtb3JlIGNoYW5nZXMgbGF0ZXIgb24gYXMgbW9yZSBpbmZvcm1hdGlvbiBiZWNvbWVz
DQphdmFpbGFibGU/DQoNCkZvciBub3cgdjUgb2YgdGhlIHNlcmllcyBleHRlbmRzIHRoZSB0aW1l
b3V0IGJ1dCBhdCBsZWFzdCBtYWtlcyBhIG1lbnRpb24NCnRoYXQgdGhlcmUgYXBwZWFycyB0byBi
ZSBhIGZpcm13YXJlIGJ1ZyB3aGVuIG1vcmUgdGhhbiAxIHNlY29uZCBpcyB0YWtlbi4NCg==
