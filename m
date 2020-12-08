Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3B12D364B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731503AbgLHWbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:31:01 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:61608 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729323AbgLHWa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 17:30:57 -0500
Received: from pps.filterd (m0170391.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B8MRliG006967;
        Tue, 8 Dec 2020 17:30:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=kp/Bpq+3NbwA3l43WwGt/1idEobWLR64ZWCKRc/eR1o=;
 b=cXfRqLor74ur4bvz5B04YgPYh2JdJeK5pPtaZWwjL+fzQZ75JXEkJDl9qSJhKJ12UCYq
 Tf/HHNQ/UGjNK0P7fjvHSyDonbc3Lo8O5btpyQaGImu3EOEs/Uc9DXIToD8hZny2fson
 N2/ruhkV+wBZbszyPwA1OzVvh0jDmxIDXtQrIi8+YC0LvI558WE2Ql2caXGrs7PijT9Q
 cYVeeYtrS9cK3BHYOq573ASkjU6FlfhXG0r+oyIyt5uAFwT5NljdyvBZwaA+nY5Mheqt
 v/AHwwE2SxESNdycU2DS/5cZDDrhaScQd29kSeFHH8yHwoTjDpsc/NyHXWDtUHI2r6Th rg== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 3587gycdn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 17:30:07 -0500
Received: from pps.filterd (m0142699.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B8MRJqS185888;
        Tue, 8 Dec 2020 17:30:07 -0500
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2050.outbound.protection.outlook.com [104.47.38.50])
        by mx0a-00154901.pphosted.com with ESMTP id 35agkj1fke-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 17:30:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCsPgVPU68x1SVJZtSnntEwbT44cgNs5NN8913xl0JoM+oZUJw1v2SLTf3wDv4xYO2E+Tn2XSBRYy3BVL5+qOwwWZeiCsOumElhFJSyzIoUsN7V0k8QoA6wXjrgF0ImEpKR3vF2KdGmWPQu+DfEO1Pvftd+V2vedLWa5KRO9kM0IH3ZhOfYTuQ8BJyoWNFPQTMVSs2WEaNYaLmJEYMCJpfasP87mnBpsStsEtZTwX6lWyGX/0/hPApj7sBWKykOOLm2ASX69IkbTLCW9LmyemV46VoZG3zgGAJY93Ybv5UzHmdEof3aim257tsugQ+cniJ2br1eB0fiQtjqj2OsHjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kp/Bpq+3NbwA3l43WwGt/1idEobWLR64ZWCKRc/eR1o=;
 b=X7XbP4AvM/vVcyuxsMRPcJsxfZQs0arPN9SF3522vH+Q863eyndC8KjscsUsct0h+EMEmaf2iMBtz4a6QoppLd8JS24gSSbrkHzfuXwvaZbehCInd1h0BvulDJ6qd19M3sZDukjPLVG96YluSfWgMetOvVF5YszC4bwJeZNTYeMmOCZcllLJeci22gKxtb/IbCdOyzCRjIzswB6Mu+vF+7njBC2PWZxDoWqH2ljDinZ74FcHxGim5ESgBQEDSp0EKJvpXeuFbiL91nHeXGQciFmbP3Ouq6ysIwLcFPL8InQoDfPbNIuMgj9eYgJFtrUloeDh9r5+3qb5HeJmQ/5jsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kp/Bpq+3NbwA3l43WwGt/1idEobWLR64ZWCKRc/eR1o=;
 b=jynGft1C6iw0eTmfwmP+OfienuJzb/gk5Fj28dJgLiYTHkhOmL+RNxOmqDftJ+TugabLlIgaU8NfYdiyzdbBHwGuea1Oodw8Ct7Ek0k6v4yGB+ABFZRmyvvpinDHIEQp5L4LPtLOZO+VVhphK46ccjM9BRW2QMQv0uu7nRkpp9U=
Received: from DM6PR19MB2636.namprd19.prod.outlook.com (2603:10b6:5:15f::15)
 by DM6PR19MB2396.namprd19.prod.outlook.com (2603:10b6:5:c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Tue, 8 Dec
 2020 22:29:10 +0000
Received: from DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914]) by DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914%7]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 22:29:10 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
CC:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>,
        "viltaly.lifshits@intel.com" <viltaly.lifshits@intel.com>
Subject: RE: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
Thread-Topic: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
Thread-Index: AQHWynlfqP1K6e0vqUqfE6etAZ98TqnrpJ0AgAAfsNCAAObyAIAASWEAgABw+ACAACbLEA==
Date:   Tue, 8 Dec 2020 22:29:10 +0000
Message-ID: <DM6PR19MB2636BAAB459B3895EC5F0A98FACD0@DM6PR19MB2636.namprd19.prod.outlook.com>
References: <20201204200920.133780-1-mario.limonciello@dell.com>
 <d0f7e565-05e1-437e-4342-55eb73daa907@redhat.com>
 <DM6PR19MB2636A4097B68DBB253C416D8FACE0@DM6PR19MB2636.namprd19.prod.outlook.com>
 <383daf0d-8a9b-c614-aded-6e816f530dcd@intel.com>
 <e7d57370-e35e-a9e6-2dd9-aa7855c15650@redhat.com>
 <CAKgT0UebNROCeAyyg0Jf-pTfLDd-oNyu2Lo-gkZKWk=nOAYL8g@mail.gmail.com>
In-Reply-To: <CAKgT0UebNROCeAyyg0Jf-pTfLDd-oNyu2Lo-gkZKWk=nOAYL8g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-12-08T22:29:07.3087018Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=1c42d836-1b27-44ce-a14c-6544365ab8bc;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d14ae7a-fff8-4b9a-2637-08d89bc8af3a
x-ms-traffictypediagnostic: DM6PR19MB2396:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR19MB23968CB2EB3AC41ECC1ECB26FACD0@DM6PR19MB2396.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: arWZPqm2ZAKCfcnDlAEJMGgjefIL2kA6IZDotsN7Pmise5ynKAEX4lye0PbpZPjRr1ZaoDen5+1kMDR3AKo9tYeZqtnx+R96+E4odR3ez3GDpyr3HyGwG75DD5UqH2I3lQRTN65drh8YP8lmgKemyUS+NFM7w20qNMhzy5tJmhjXfmK1Ez5Jrs8HxsGVHHRN2PLaa72Nwclc1287OKDY8hpezTAxuuuICwOnpl7tiXuh/pDHxLSEp0/3PQjDZpFh+3cV/hjumvLFqDF+IA2Ps4Oss32aEtFdztapkqRQUExvrwfIr6omJInFia2VXY8YynRhVcl2gOaJ/lMVur7DaNY0n2JOzmX0wrWit3sUWRFIY9k2vxEbGMw71A4PHqIJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB2636.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(4326008)(8676002)(2906002)(6506007)(7416002)(83380400001)(186003)(786003)(110136005)(54906003)(7696005)(26005)(8936002)(508600001)(66476007)(33656002)(5660300002)(55016002)(76116006)(64756008)(66446008)(71200400001)(66946007)(66556008)(9686003)(52536014)(86362001)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?amoxNTdnWU1hcWplQzV3NzFkWkpaQzVBZDhvWm1TRTN1ODgyR0dEc1YzNnQw?=
 =?utf-8?B?MGVNWTdYL2RaUis5K3IwajlQWWxpZkhzSHpNOHcyN0RvS1RoL3k3R3VvSE4y?=
 =?utf-8?B?Zzd5cGJYYlVSRG03OGd5QmtIRHBpSC9DMjZWcWhueStvZWFkSFpZNFV4NkpN?=
 =?utf-8?B?Nm0zRDU0Z2ZOVWxvbzIxb1ZlSDA5ckYrNWRxNkxMeHBTdlpZWXpJUGkyMTVN?=
 =?utf-8?B?SlQ1WUtRWmFveGRiSS9jTmRBd3ljbGlxTFlpemh4OFlEWEtlUXhpVThNbWRt?=
 =?utf-8?B?djhHUzJjYlVuVTNDcXJrOTUxUHREYndKTmllTWNFNjBpRjdDY2QyM3RiWG5H?=
 =?utf-8?B?a2FnUHhMNGlnd1NOYzBRMEJrRllxMlRUYUtpdURWSDcrenBTMHlGLytueHhM?=
 =?utf-8?B?dVZwOFplRnVwR1k3d2kwa0NZUXdZaE1Oc0lNN0N4d094QS9jMWdYenRIR0lY?=
 =?utf-8?B?a0lhY01UM2ZRb0krTFhXTXRGSUxZajMvQVE4Vmx4eE5vUXBZcTZXSUNkQnRa?=
 =?utf-8?B?c21TR1NOQUQvZy8yZFhuejVQN3RvWXBuTVRaWm1wZTM0WXk2M2dHdThpVnJZ?=
 =?utf-8?B?WmVtaEMxZHNoZFpHK3BNRjV5VDhCcTEwMGFXMFJ1RllhQi9TRXpzemxubzMx?=
 =?utf-8?B?VWtFUzdVMCs0aUpwZUlTdzFvcGNncnVwZEV5UnVWeHZjczNsdjJBY3VVcW9W?=
 =?utf-8?B?bDArdnBxdEdaNnFTd3FUWWl5Tm1iS1ZSbjd6NmptS1A2b0lqQWhDNFlreWZR?=
 =?utf-8?B?YTZhRGZLZzI5eFhyQkZRQlkwd2lwbm9OSW5ZcmtIQldNV2VzbVgzOUsvemR3?=
 =?utf-8?B?V3VsQTRTL0xhVW1Eb1JacVVaa29YUG5sUWpCaW9OaEgyNW5WMmF3SWZyWENK?=
 =?utf-8?B?YnJBYXBmUTZLRy92ellMSm1lOTdsc3ZOMGZKbFpSSzVEck9mQmZ1REVJaGts?=
 =?utf-8?B?bTFmbVljY3RMRmJZc3pUWUlLOUdyVVlKdDNld2pXNWJYUFJkdGxldGdacVh6?=
 =?utf-8?B?V2ZwT2d5UVA1UGlrUjB5WS9ZU1haWWpkWTlxRitMUkx5Rngzb0xWL3ZHQ0tr?=
 =?utf-8?B?QXIwT2JsVDdQV3VpZVdTQzk5K2RXTnpSUG12dCsvOWt0aDcrTkl3RE5QZytS?=
 =?utf-8?B?Yy9lK2MwdmptbVZrakdVZnorLzRRWU5oVFpFaUd5d1Q2cFgvck9tSlR2SWcz?=
 =?utf-8?B?ajVsUTN4ZGtqZGZid1FLZW5vdzdJUGdZTDcvR0thQzZ5dzBiK3JhejBrVnI1?=
 =?utf-8?B?UFBzaytiNHlWVFJKc3VlY01JVlgxZ2JTTlg1WlZMaTNzMnFDZm95cFVlRFQ5?=
 =?utf-8?Q?nrBS2EFuKXl7w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB2636.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d14ae7a-fff8-4b9a-2637-08d89bc8af3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 22:29:10.7793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvmN3P64zR2YERoLuZULTlluRpGbiPfoM9cVNsI4GMfZlBG6gYWiQj2AgsV5pFlcFNdfTaia0KaB0XwAiTxQynOhN49/18OvUle1Pl/b/JY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB2396
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_17:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 clxscore=1011 suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080140
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gQmFzZWQgb24gdGhlIGVhcmxpZXIgdGhyZWFkIHlvdSBoYWQgcmVmZXJlbmNlZCBhbmQg
aGlzIGNvbW1lbnQgaGVyZSBpdA0KPiBzb3VuZHMgbGlrZSB3aGlsZSBhZGRpbmcgdGltZSB3aWxs
IHdvcmsgZm9yIG1vc3QgY2FzZXMsIGl0IGRvZXNuJ3QNCj4gc29sdmUgaXQgZm9yIGFsbCBjYXNl
cy4gVGhlIHByb2JsZW0gaXMgYXMgYSB2ZW5kb3IgeW91IGFyZSB1c3VhbGx5DQo+IHN0dWNrIGxv
b2tpbmcgZm9yIGEgc29sdXRpb24gdGhhdCB3aWxsIHdvcmsgZm9yIGFsbCBjYXNlcyB3aGljaCBj
YW4NCj4gbGVhZCB0byB0aGluZ3MgbGlrZSBoYXZpbmcgdG8gZHJvcCBmZWF0dXJlcyBiZWNhdXNl
IHRoZXkgY2FuIGJlDQo+IHByb2JsZW1hdGljIGZvciBhIGZldyBjYXNlcy4NCj4gDQo+ID4gQXJl
IHlvdSBzYXlpbmcgdGhhdCB5b3UgaW5zaXN0IG9uIGtlZXBpbmcgdGhlIGUxMDAwZV9jaGVja19t
ZSBjaGVjayBhbmQNCj4gPiB0aHVzIG5lZWRsZXNzbHkgcGVuYWxpemluZyAxMDBzIG9mIGxhcHRv
cHMgbW9kZWxzIHdpdGggaGlnaGVyDQo+ID4gcG93ZXItY29uc3VtcHRpb24gdW5sZXNzIHRoZXNl
IDEwMHMgb2YgbGFwdG9wcyBhcmUgYWRkZWQgbWFudWFsbHkNCj4gPiB0byBhbiBhbGxvdyBsaXN0
IGZvciB0aGlzPw0KPiA+DQo+ID4gSSdtIHNvcnJ5IGJ1dCB0aGF0IGlzIHNpbXBseSB1bmFjY2Vw
dGFibGUsIHRoZSBtYWludGVuYW5jZSBidXJkZW4NCj4gPiBvZiB0aGF0IGlzIGp1c3Qgd2F5IHRv
byBoaWdoLg0KPiANCj4gVGhpbmsgYWJvdXQgdGhpcyB0aGUgb3RoZXIgd2F5IHRob3VnaC4gSWYg
aXQgaXMgZW5hYmxlZCBhbmQgdGhlcmUgYXJlDQo+IGNhc2VzIHdoZXJlIGFkZGluZyBhIGRlbGF5
IGRvZXNuJ3QgcmVzb2x2ZSBpdCB0aGVuIGl0IHN0aWxsIGRvZXNuJ3QNCj4gcmVhbGx5IHNvbHZl
IHRoZSBpc3N1ZSBkb2VzIGl0Pw0KPiANCj4gPiBUZXN0aW5nIG9uIHRoZSBtb2RlbHMgd2hlcmUg
dGhlIHRpbWVvdXQgaXNzdWUgd2FzIGZpcnN0IGhpdCBoYXMNCj4gPiBzaG93biB0aGF0IGluY3Jl
YXNpbmcgdGhlIHRpbWVvdXQgZG9lcyBhY3R1YWxseSBmaXggaXQgb24gdGhvc2UNCj4gPiBtb2Rl
bHMuIFN1cmUgaW4gdGhlb3J5IHRoZSBNRSBvbiBzb21lIGJ1Z2d5IG1vZGVsIGNvdWxkIGhvbGQg
dGhlDQo+ID4gc2VtYXBob3JlIGV2ZW4gbG9uZ2VyLCBidXQgdGhlbiB0aGUgcmlnaHQgdGhpbmcg
d291bGQgYmUgdG8NCj4gPiBoYXZlIGEgZGVueS1saXN0IGZvciBzMGl4IHdoZXJlIHdlIGNhbiBh
ZGQgdGhvc2UgYnVnZ3kgbW9kZWxzDQo+ID4gKG5vbmUgb2Ygd2hpY2ggd2UgaGF2ZSBlbmNvdW50
ZXJlZCBzb2ZhcikuIEp1c3QgbGlrZSB3ZSBoYXZlDQo+ID4gZGVueWxpc3QgZm9yIGJ1Z2d5IGh3
IGluIG90aGVyIHBsYWNlcyBpbiB0aGUga2VybmVsLg0KPiANCj4gVGhpcyB3b3VsZCBhY3R1YWxs
eSBoYXZlIGEgaGlnaGVyIG1haW50ZW5hbmNlIGJ1cmRlbiB0aGVuIGp1c3QNCj4gZGlzYWJsaW5n
IHRoZSBmZWF0dXJlLiBIYXZpbmcgdG8gaW5kaXZpZHVhbGx5IHRlc3QgZm9yIGFuZCBkZW55LWxp
c3QNCj4gZXZlcnkgb25lLW9mZiBzeXN0ZW0gd2l0aCB0aGlzIGJhZCBjb25maWd1cmF0aW9uIHdv
dWxkIGJlIGEgcHJldHR5DQo+IHNpZ25pZmljYW50IGJ1cmRlbi4gVGhhdCBhbHNvIGltcGxpZXMg
c29tZWJvZHkgd291bGQgaGF2ZSBhY2Nlc3MgdG8NCj4gc3VjaCBzeXN0ZW1zIGFuZCB0aGF0IGlz
IG5vdCBub3JtYWxseSB0aGUgY2FzZS4gRXZlbiBJbnRlbCBkb2Vzbid0DQo+IGhhdmUgYWxsIHBv
c3NpYmxlIHN5c3RlbXMgdGhhdCB3b3VsZCBpbmNsdWRlIHRoaXMgTklDLg0KPiANCj4gPiBNYWlu
dGFpbmluZyBhbiBldmVyIGdyb3dpbmcgYWxsb3cgbGlzdCBmb3IgdGhlICp0aGVvcmV0aWNhbCoN
Cj4gPiBjYXNlIG9mIGVuY291bnRlcmluZyBhIG1vZGVsIHdoZXJlIHRoaW5ncyBkbyBub3Qgd29y
ayB3aXRoDQo+ID4gdGhlIGluY3JlYXNlZCB0aW1lb3V0IGlzIG5vdCBhIHdvcmthYmxlIGFuZCB0
aGlzIG5vdCBhbg0KPiA+IGFjY2VwdGFibGUgc29sdXRpb24uDQo+IA0KPiBJJ20gbm90IGEgZmFu
IG9mIHRoZSBhbGxvdy1saXN0IGVpdGhlciwgYnV0IGl0IGlzIHByZWZlcmFibGUgdG8gYQ0KPiBk
ZW55LWxpc3Qgd2hlcmUgeW91IGhhdmUgdG8gZmlyc3QgdHJpZ2dlciB0aGUgYnVnIGJlZm9yZSB5
b3UgcmVhbGl6ZQ0KPiBpdCBpcyB0aGVyZS4gSWRlYWxseSB0aGVyZSBzaG91bGQgYmUgYW5vdGhl
ciBzb2x1dGlvbiBpbiB3aGljaCB0aGUgTUUNCj4gY291bGQgc29tZWhvdyBzZXQgYSBmbGFnIHNv
bWV3aGVyZSBpbiB0aGUgaGFyZHdhcmUgdG8gaW5kaWNhdGUgdGhhdCBpdA0KPiBpcyBhbGl2ZSBh
bmQgdGhlIGRyaXZlciBjb3VsZCByZWFkIHRoYXQgb3JkZXIgdG8gZGV0ZXJtaW5lIGlmIHRoZSBN
RQ0KPiBpcyBhY3R1YWxseSBhbGl2ZSBhbmQgY2FuIHNraXAgdGhpcyB3b3JrYXJvdW5kLiBUaGVu
IHRoaXMgY291bGQgYWxsIGJlDQo+IGF2b2lkZWQgYW5kIGl0IGNhbiBiZSBzYWZlbHkgYXNzdW1l
ZCB0aGUgc3lzdGVtIGlzIHdvcmtpbmcgY29ycmVjdGx5Lg0KPiANCj4gPiBUaGUgaW5pdGlhbCBh
ZGRpdGlvbiBvZiB0aGUgZTEwMDBlX2NoZWNrX21lIGNoZWNrIGluc3RlYWQNCj4gPiBvZiBqdXN0
IGdvaW5nIHdpdGggdGhlIGNvbmZpcm1lZCBmaXggb2YgYnVtcGluZyB0aGUgdGltZW91dA0KPiA+
IHdhcyBhbHJlYWR5IGhpZ2hseSBjb250cm92ZXJzaWFsIGFuZCBzaG91bGQgSU1ITyBuZXZlciBo
YXZlDQo+ID4gYmVlbiBkb25lLg0KPiANCj4gSG93IGJpZyB3YXMgdGhlIHNhbXBsZSBzaXplIGZv
ciB0aGUgImNvbmZpcm1lZCIgZml4PyBIb3cgbWFueQ0KPiBkaWZmZXJlbnQgdmVuZG9ycyB3ZXJl
IHRoZXJlIHdpdGhpbiB0aGUgbWl4PyBUaGUgcHJvYmxlbSBpcyB3aGlsZSBpdA0KPiBtYXkgaGF2
ZSB3b3JrZWQgZm9yIHRoZSBjYXNlIHlvdSBlbmNvdW50ZXJlZCB5b3UgY2Fubm90IHNheSB3aXRo
DQo+IGNlcnRhaW50eSB0aGF0IGl0IHdvcmtlZCBpbiBhbGwgY2FzZXMgdW5sZXNzIHlvdSBoYWQg
c2FtcGxlcyBvZiBhbGwNCj4gdGhlIGRpZmZlcmVudCBoYXJkd2FyZSBvdXQgdGhlcmUuDQoNCisx
DQpJSVJDIGl0IHdhcyBqdXN0IExlbm92byB0aGF0IHdhcyBjaGVja2VkIGFuZCBqdXN0IGEgZmV3
IHN5c3RlbXMuDQoNCj4gDQo+ID4gQ29tYmluaW5nIHRoaXMgd2l0aCBhbiBldmVyLWdyb3dpbmcg
YWxsb3ctbGlzdCBvbiB3aGljaCBldmVyeQ0KPiA+IG5ldyBsYXB0b3AgbW9kZWwgbmVlZHMgdG8g
YmUgYWRkZWQgc2VwYXJhdGVseSArIGEgbmV3DQo+ID4gInMwaXgtZW5hYmxlZCIgZXRoZXJ0b29s
IGZsYWcsIHdoaWNoIGV4aXN0ZW5jZSBpcyBiYXNpY2FsbHkNCj4gPiBhbiBhZG1pc3Npb24gdGhh
dCB0aGUgYWxsb3ctbGlzdCBhcHByb2FjaCBpcyBmbGF3ZWQgZ29lcw0KPiA+IGZyb20gY29udHJv
dmVyc2lhbCB0byBqdXN0IHBsYWluIG5vdCBhY2NlcHRhYmxlLg0KPiANCj4gSSBkb24ndCB2aWV3
IHRoaXMgYXMgcHJvYmxlbWF0aWMsIGhvd2V2ZXIgdGhpcyBpcyBzb21lIG92ZXJoZWFkIHRvIGl0
Lg0KPiBPbmUgdGhpbmcgSSBkb24ndCBrbm93IGlzIGlmIGFueW9uZSBoYXMgbG9va2VkIGF0IGlz
IGlmIHRoZSBpc3N1ZSBvbmx5DQo+IGFwcGxpZXMgdG8gYSBmZXcgc3BlY2lmaWMgc3lzdGVtIHZl
bmRvcnMuIEN1cnJlbnRseSB0aGUgYWxsb3ctbGlzdCBpcw0KPiBiYXNlZCBvbiB0aGUgc3ViZGV2
aWNlIElELiBPbmUgdGhpbmcgd2UgY291bGQgbG9vayBhdCBkb2luZyBpcw0KPiBlbmFibGluZyBp
dCBiYXNlZCBvbiB0aGUgc3VidmVuZG9yIElEIGluIHdoaWNoIGNhc2Ugd2UgY291bGQNCj4gYWxs
b3ctbGlzdCBpbiBsYXJnZSBzd2F0aHMgb2YgaGFyZHdhcmUgd2l0aCBjZXJ0YWluIHRydXN0ZWQg
dmVuZG9ycy4NCg0KQWx0aG91Z2ggaXQgd291bGQgZGVjcmVhc2UgdGhlIG92ZXJoZWFkIG15IHBy
ZWZlcmVuY2UgaXMgdGhhdCB3ZSBkb24ndCBsdW1wDQphbGwgb2YgYW4gT0VNJ3MgaGFyZHdhcmUg
dG9nZXRoZXIgdW50aWwgaXQncyBhY3R1YWxseSBiZWVuIGNoZWNrZWQuICBJdCdzIGdvaW5nDQp0
byBiZSB2ZXJ5IA0KRXZlbiBpbiBhIHNpbmdsZSBPRU0gdGhlcmUgYXJlIGEgdmFyaWV0eSBvZg0K
QklPUyB2ZW5kb3JzIGluIHRoZSBtaXgsIGRpZmZlcmVudCBPRE1zIHdvcmtpbmcgYXNzaXN0aW5n
IG9uIGRlc2lnbnMsIGFuZCBsb3RzDQpvZiBtb3ZpbmcgcGllY2VzIG9mIGZpcm13YXJlIGR1cmlu
ZyBkZXZlbG9wbWVudC4gIFlvdSdsbCBub3RpY2UgSSBpbnRlbnRpb25hbGx5DQpoYXZlIG9ubHkg
aW5jbHVkZWQgYSBzdWJzZXQgb2YgRGVsbCdzIFRHTCBkZXNpZ25zIGluIHRoZSBsYXRlciBwYXRj
aGVzIGFuZA0Kc2VwYXJhdGVkIHRoZW0gb3V0IGZvciBlYXN5IHJldmVydHMgaW4gdGhlIHNlcmll
cyBiZWNhdXNlIHRoZXkncmUgZmFyIGVub3VnaA0KaW4gZGV2ZWxvcG1lbnQgdG8gYmUgY29uc2lk
ZXJlZCBhIHN0YWJsZSBiYXNlbGluZSBhbmQgaGF2ZSBiZWVuIHZhbGlkYXRlZC4NCg0KSSdtIGEg
ZmFuIG9mIGNvbGxhcHNpbmcgdGhlIGxpc3RzIGFuZCBoZXVyaXN0aWNzIGFmdGVyIGEgZ2VuZXJh
dGlvbiBvZiBzeXN0ZW1zDQppcyBkb25lIGlmIHRoZXkgY2FuIGFsbCBiZSBjaGVja2VkLCBidXQg
YmV5b25kIHRoYXQgaXQgYmVjb21lcyB2ZXJ5IGRpZmZpY3VsdA0KdG8gcHVsbCBvdXQgb25lIHNp
bmdsZSBzeXN0ZW0gdGhhdCBoYXMgYSBmYWlsdXJlLg0KDQo+IFRoZSBvbmx5IGlzc3VlIGlzIHRo
YXQgaXQgcHVsbHMgaW4gYW55IGZ1dHVyZSBwYXJ0cyBhcyB3ZWxsIHNvIGl0IHB1dHMNCj4gdGhl
IG9udXMgb24gdGhhdCBtYW51ZmFjdHVyZXIgdG8gYXZvaWQgbWlzY29uZmlndXJpbmcgdGhpbmdz
IGluIHRoZQ0KPiBmdXR1cmUuDQoNCkFzIFNhc2hhIHNhaWQgaXQncyBub3QgYSBQT1IgY29uZmln
dXJhdGlvbiByaWdodCBub3cuICBTbyB1bnRpbCBpdCdzIGJlY29tZQ0KUE9SIGNvbmZpZ3VyYXRp
b24gaXQgc2hvdWxkIGJlIGNhc2UgYnkgY2FzZSBiYXNpcyBlbmFibGVkIHdoZXJlIGl0IHdvcmtz
Lg0KDQo=
