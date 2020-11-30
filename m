Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF402C90CD
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387937AbgK3WQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:16:49 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:2106 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727041AbgK3WQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:16:48 -0500
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMCfvU024785;
        Mon, 30 Nov 2020 17:16:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=OIoYYB4sm4dyMEsCFtweJtsjPvDWV7CS3DoYf2UGDC8=;
 b=Qs0rpWoXZP5RtR+1wRKCXafQuwNPaV0FaGNYLdEeJ76auOkjjEg893BWQmO7S16Y6kS1
 ghpQFbCIFrEAfwXZwRIB2YTp1i0Kim1Of8KU57zXbKTj+G0xOysJa9tu4oE6ImaVxY8U
 Lr3zOPK2VPrK5Dgt4aDsA6RoM+dgYAVXEzlkCPAMRDeDhdYCinCIN5qCXANpqdCyHSpr
 mrREOJOydFpWfrvbLj00aYNjbiZUygksAGysr6wKSu78ZkuItpGZTqSznZotrrt8GQgA
 sPUZ5zwSQkHwY/q5MGWsfo/0gBu+1xXPtBfADSHP8qZ7YGCyQLwsxSv/t2p+g/jJA1Eg RA== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 353jrpqnpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 17:16:00 -0500
Received: from pps.filterd (m0089483.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUM8Z2K156337;
        Mon, 30 Nov 2020 17:15:59 -0500
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by mx0b-00154901.pphosted.com with ESMTP id 3558xk0f0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 17:15:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Snkok1qPX/UpqXN3cseBLr609CfkW9kFZnMpi8j03iTR0eUr+M4eR4MuMIG2lDM8Vu4NBPxIQUOUG94bkGFrJUjzRpgMW/n0rKp3p6j0wTu/MyvB8G3CrXtRbqZjKrc4XYDZ4g1mDWUwS4RWGVO2uJQEpM++HnFShONNagRU7osQyRgAyXHTkDVj4mOUXf3OJLiR7hps04tWl0DMB3SspNryKHXqejNSXdsHl/a42ABj+ETlmqn5cW1Z2SY1TmQygDI2W3RAkm8UbRn1Pj+eVI26FAywbQk6pwQRdSXRee6CjjyoZn5lcudLSI2gqMEXza/GPlXEyEbnfh9xpRzlOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIoYYB4sm4dyMEsCFtweJtsjPvDWV7CS3DoYf2UGDC8=;
 b=EodXJKPcU+TFApCajtwJeOyulgwvkeb+9iGNXdylKx9J9K7tNjvpdG6tU/W69I8cxguvSg+NRJcQjedQhTEKrE0RePhgvKses40xe0IL8t5tPCqCrpubzF9A3bpkhL6Ed8KRJ9daDmB8PyW2wH5xCySekmPLb01Md0hzI//vy+oE/sJ6bxPU+t2VWuikp35WMiG9k5/+faaW/013J6qVmM88isMFA/AgjDm9JsVnWwcGgw33pc4FWwarQ9/7tg7o/bTGhiAGrKFqUPaCqs2sxIGnCozUccoYB9ZGzl4DTQjqjYwH0TaFRfU1AeODg8AjU7ANPBn2AItmksepR6CIrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIoYYB4sm4dyMEsCFtweJtsjPvDWV7CS3DoYf2UGDC8=;
 b=euZaGd660/IBCUmiWfKTsP9B25cwb1N0slnZMWXa3woYpFRPNO4x9MQOgXTl+SG4Diy8UqO3CDiijnCfq14LqdJa4OSbmPiAyfNS0BGqC0ephta169yolOLJf29bbVuzRiWql1SZer1lGbPeWmy8x8VkndIhpddIczHhDRIyUIc=
Received: from DM6PR19MB2636.namprd19.prod.outlook.com (2603:10b6:5:15f::15)
 by DM6PR19MB3209.namprd19.prod.outlook.com (2603:10b6:5:194::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Mon, 30 Nov
 2020 22:15:55 +0000
Received: from DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914]) by DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914%7]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 22:15:55 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Stefan Assmann <sassmann@redhat.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: RE: [net-next 1/4] e1000e: allow turning s0ix flows on for systems
 with ME
Thread-Topic: [net-next 1/4] e1000e: allow turning s0ix flows on for systems
 with ME
Thread-Index: AQHWx2BlnSBfbFNF7kaA8I5RcYCtH6nhOZsAgAAAO7A=
Date:   Mon, 30 Nov 2020 22:15:55 +0000
Message-ID: <DM6PR19MB263628DAC7F032E575C5E5EAFAF50@DM6PR19MB2636.namprd19.prod.outlook.com>
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
 <20201130212907.320677-2-anthony.l.nguyen@intel.com>
 <CAKgT0Uf7BoQ5DAWD8V7vhRZfRZCEBxc_X4Wn35mYEvMPSq-EaQ@mail.gmail.com>
In-Reply-To: <CAKgT0Uf7BoQ5DAWD8V7vhRZfRZCEBxc_X4Wn35mYEvMPSq-EaQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-11-30T22:01:07.0709033Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=8b12a31e-c38e-4b87-a3cf-472208a79574;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09b41144-e5cf-4ecc-e50b-08d8957d81cb
x-ms-traffictypediagnostic: DM6PR19MB3209:
x-microsoft-antispam-prvs: <DM6PR19MB32096FFA68BC36E3796C486FFAF50@DM6PR19MB3209.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XQ5xHDBRSUjtHrsgLg8ON0Yyzz8pk4FmPM71rd2E3mvwfId2r4zppMGzqHF5/em+LfF4O1Pju++krA7gSSgZKlaAVBgVCNC2IGZjBIv4kaVG0Bl6qyKzRTtsyghp+GVNrZLhFfQ6vYqunazjeDT8M438dwdFJLvMziQpt72IoctLt7Y8aWDPXrEL9petT/eUm7FJ1uSbPSMPF/eiRDWjvU8ie84vuUj+tM28lxnXMegnQoeA/atIah5j2h8rMb6VNxf7IEok02wB3GZ0VeQPfCpUUW406qHP+oeR+4/WCU8MuJrtMvhqxbaia1mGz4xX02ybWwFaq//FC6P7qx3J8p3vGpFc2JrUW/5rVDXg6+8ycjJahm4uzbof2oCu9rh8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB2636.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(33656002)(26005)(786003)(316002)(4326008)(52536014)(55016002)(110136005)(478600001)(71200400001)(54906003)(9686003)(186003)(66446008)(7696005)(66556008)(66476007)(64756008)(2906002)(8676002)(8936002)(5660300002)(6506007)(66946007)(76116006)(86362001)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dVNJZ1dpRWUxa2FhbHowbkNuWHdieGIzd0YyUmdaSWhnNHVyRmFLRHI3Smc2?=
 =?utf-8?B?eW9UZHNHeEwydkRvNVhmd1VOY1ZCY3lxcHhoTENnaGlJSGlsanhpcHZodjhv?=
 =?utf-8?B?azI0NUZXM1hrYzJFUDlWTzl6UERleTBrTjBzY1gvZ3JPdHA5Wm9VZmsxMVEx?=
 =?utf-8?B?MG1tM05VN28xSm9GYjZFc1ZoOWU3WnpEU25kc20rRVJ2Qm5ZVXJlbzFleFVm?=
 =?utf-8?B?MTJxdXM3UkIvR2paaTk0a3YxY2trUC91RU8yeGM1WFk4enozZkQvSmwzWjh2?=
 =?utf-8?B?N1E5NWFQVUVYRWJLYVN5SFdHNEJ2V2FFT0d2cjBGREIzZzhyMndjUGZ3c25J?=
 =?utf-8?B?akk1K0NTSVZ4T3F3ek1PY2ZhOVFhMGdqdnUyV0NMMkVaMmdMNmZ4ZHBLSzF4?=
 =?utf-8?B?VXR3azhEbHVyeHIwbGNLTk9QUzFZTmNUeTdtNmhTa0NucGxVbUYxVkZ5elA3?=
 =?utf-8?B?bjZXWXhxVkFZV0lZYklzcW1zOTJMa0xvZTdmRk5sWG1XaG9Db01JZ2k1aXd4?=
 =?utf-8?B?SVQyWHRnM3FYQkZJMXk4WjRqaUhvL0xpSmNSVkEyaVpHOGt4YTBXNFgwem5i?=
 =?utf-8?B?cjRIN0I2dHJvTVhYLzZ0RnJFVVZwR1N1M0lqdHJJQjdQNlNOTVhGM3ZqenJl?=
 =?utf-8?B?anc0dW9sN1A2TWRETkdmTlhVVitiK2xKUTVtcHhiTm1UTjRJMGdTdHNxNGYr?=
 =?utf-8?B?RkpTWXNDYWpYT0JkUFF2TEQya1hsYzJTQ2xUZUFjRVk3RVJ0WkgvS3kvT2E2?=
 =?utf-8?B?UjNYdHRWZE9IYlpPeEtRNGxpL05aK0VOVUNFaXRobFZBNTZGQjNTSGVRZklu?=
 =?utf-8?B?Q3RBN1JKSldjOThMVy9kOURJblExQkNRbExhdWp0dGg2ckNGWFlBRFJRQkV3?=
 =?utf-8?B?OEhwdlJTcW12SEtoRTF5SHJ0SUFwQjFnTGZSZGZCTkhCUFBMd2RvRHNjdHd3?=
 =?utf-8?B?QlE5ZnZyNk9sKzF6ekkyclhaV04wK2orNnM2c2J5SFFtOXk4MHoxL3I4bm9P?=
 =?utf-8?B?M2dyc1FHVTN1MkFSU09XMzN3aXVwMUhZVjlXVjRQdm5Kd29IL3V2V3h1SnZY?=
 =?utf-8?B?SjdIMm9zZVBWbkVpSUovLzFCT3lYYzZrZFlRYkZDV3NjdEhhZHVwZ2pudWp0?=
 =?utf-8?B?ajd1TXBGNXh3ME43OEpZdTFIV0tNK3V5Z0s5bTdHUjJRN1pRNDZ2NXdoV2hm?=
 =?utf-8?B?bm42a3ZUak5JWUtsekxWcGtYeTZFTWFKNjdpcCtqSHR3cnhNK29IRUsxVm5H?=
 =?utf-8?B?VlA5N3Nmck1MbTZtdHJxbDFaQlNueWRSeG5sR2xiZXJpZWllb1IzOUtlZEtv?=
 =?utf-8?Q?jGrAlWQTje9IQ=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB2636.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b41144-e5cf-4ecc-e50b-08d8957d81cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 22:15:55.2809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TY80asbs7PrywSeOZdOU01IoEoqpcrgGWsKTH1BmejuYlFJHhz7LXx8LYyo2LvAocECupnlnM2EUfa7GnaSEx6mY1QYIi/KZA0+rQO9+ig0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB3209
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_11:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300137
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gR2VuZXJhbGx5IHRoZSB1c2Ugb2YgbW9kdWxlIHBhcmFtZXRlcnMgYW5kIHN5c2ZzIHVz
YWdlIGFyZSBmcm93bmVkDQo+IHVwb24uIA0KDQpJIHdhcyB0cnlpbmcgdG8gYnVpbGQgb24gdGhl
IGV4aXN0aW5nIG1vZHVsZSBwYXJhbWV0ZXJzIHRoYXQgZXhpc3RlZA0KYWxyZWFkeSBmb3IgZTEw
MDBlLiAgU28gSSBndWVzcyBJIHdvdWxkIGFzaywgd2h5IGFyZSB0aG9zZSBub3QgZG9uZSBpbg0K
ZXRodG9vbD8gIFNob3VsZCB0aG9zZSBwYXJhbWV0ZXJzIGdvIGF3YXkgYW5kIHRoZXkgbWlncmF0
ZSB0byBldGh0b29sDQpmb3IgdGhlIHNhbWUgcmVhc29ucyBhcyB0aGlzPw0KDQo+IEJhc2VkIG9u
IHRoZSBjb25maWd1cmF0aW9uIGlzbid0IHRoaXMgc29tZXRoaW5nIHRoYXQgY291bGQganVzdA0K
PiBiZSBjb250cm9sbGVkIHZpYSBhbiBldGh0b29sIHByaXYgZmxhZz8gQ291bGRuJ3QgeW91IGp1
c3QgaGF2ZSB0aGlzDQo+IGRlZmF1bHQgdG8gd2hhdGV2ZXIgdGhlIGhldXJpc3RpY3MgZGVjaWRl
IGF0IHByb2JlIG9uIGFuZCB0aGVuIHN1cHBvcnQNCj4gZW5hYmxpbmcvZGlzYWJsaW5nIGl0IHZp
YSB0aGUgcHJpdiBmbGFnPyBZb3UgY291bGQgbG9vayBhdA0KPiBpZ2JfZ2V0X3ByaXZfZmxhZ3Mv
aWdiX3NldF9wcml2X2ZsYWdzIGZvciBhbiBleGFtcGxlIG9mIGhvdyB0byBkbyB3aGF0DQo+IEkg
YW0gcHJvcG9zaW5nLg0KDQpJIGRvbid0IGRpc2FncmVlIHRoaXMgc29sdXRpb24gd291bGQgd29y
aywgYnV0IGl0IGFkZHMgYSBuZXcgZGVwZW5kZW5jeQ0Kb24gaGF2aW5nIGV0aHRvb2wgYW5kIHRo
ZSBrZXJuZWwgbW92ZSB0b2dldGhlciB0byBlbmFibGUgaXQuDQoNCk9uZSBhZHZhbnRhZ2Ugb2Yg
dGhlIHdheSB0aGlzIGlzIGRvbmUgaXQgYWxsb3dzIHNoaXBwaW5nIGEgc3lzdGVtIHdpdGggYW4N
Cm9sZGVyIExpbnV4IGtlcm5lbCB0aGF0IGlzbid0IHlldCByZWNvZ25pemVkIGluIHRoZSBrZXJu
ZWwgaGV1cmlzdGljcyB0bw0KdHVybiBvbiBieSBkZWZhdWx0IHdpdGggYSBzbWFsbCB1ZGV2IHJ1
bGUgb3Iga2VybmVsIGNvbW1hbmQgbGluZSBjaGFuZ2UuDQoNCkZvciBleGFtcGxlIHN5c3RlbXMg
dGhhdCBhcmVuJ3QgeWV0IHJlbGVhc2VkIGNvdWxkIGhhdmUgdGhpcyBkb2N1bWVudGVkIG9uDQpS
SEVMIGNlcnRpZmljYXRpb24gcGFnZXMgYXQgcmVsZWFzZSB0aW1lIGZvciBvbGRlciBSSEVMIHJl
bGVhc2VzIGJlZm9yZSBhDQpwYXRjaCB0byBhZGQgdG8gdGhlIGhldXJpc3RpY3MgaGFzIGJlZW4g
YmFja3BvcnRlZC4NCg0KPiANCj4gSSB0aGluayBpdCB3b3VsZCBzaW1wbGlmeSB0aGlzIHF1aXRl
IGEgYml0IHNpbmNlIHlvdSB3b3VsZG4ndCBoYXZlIHRvDQo+IGltcGxlbWVudCBzeXNmcyBzaG93
L3N0b3JlIG9wZXJhdGlvbnMgZm9yIHRoZSB2YWx1ZSBhbmQgd291bGQgaW5zdGVhZA0KPiBiZSBh
bGxvd2luZyBmb3IgcmVhZGluZy9zZXR0aW5nIHZpYSB0aGUgZ2V0X3ByaXZfZmxhZ3Mvc2V0X3By
aXZfZmxhZ3MNCj4gb3BlcmF0aW9ucy4gSW4gYWRkaXRpb24geW91IGNvdWxkIGxlYXZlIHRoZSBj
b2RlIGZvciBjaGVja2luZyB3aGF0DQo+IHN1cHBvcnRzIHRoaXMgaW4gcGxhY2UgYW5kIGhhdmUg
aXQgc2V0IGEgZmxhZyB0aGF0IGNhbiBiZSByZWFkIG9yDQo+IG92ZXJ3cml0dGVuLg0KDQpJZiB0
aGUgY29uc2Vuc3VzIGlzIHRvIG1vdmUgaW4gdGhpcyBkaXJlY3Rpb24sIHllcyBJJ2xsIHJlZG8g
dGhlIHBhdGNoDQpzZXJpZXMgYW5kIG1vZGlmeSBldGh0b29sIGFzIHdlbGwuDQoNCg==
