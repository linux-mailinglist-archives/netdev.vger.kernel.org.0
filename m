Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150032DA0AB
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502553AbgLNThT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:37:19 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:42184 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502451AbgLNThR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 14:37:17 -0500
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEJWCV4026017;
        Mon, 14 Dec 2020 14:36:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=VVHLWo1gcbZyJvAR6C+jBodfRtePQtPzjkOuxfOYkBk=;
 b=oP66Pjtr+F7zFdcpzIuStRKWPxtciCuMDfwMEW5MiFoLTYvlIwHJ/F3mTXuc/YjaJdis
 bylSiNXV4JtOXXV7ClTXbcOVZypIrbH+v3EdQxzZQAYEBpJQ+/Vs+Da90UvOxmVdRWFs
 EfPvI/dHXSOnU38T4/26WVx/CswGvB3l80Yw2Y6m4r1C75ynA7q17h6e5OS7NDfOLEHV
 KjNZEaI1pj2Kz7QnqYMBQ7TP3pmBv3Usy7BferpbrAlGHDPwi8DVaszwfOAQ5m8SADyA
 Ey2gJkH1bkZDRtH6RrIWajBKKi6Hjf4BK71VDNp/15LBP67VchbcXrDblMwv5BOt6Qe+ TQ== 
Received: from mx0a-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 35ct2ppka6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 14:36:23 -0500
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEJUEk9070867;
        Mon, 14 Dec 2020 14:36:22 -0500
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0b-00154901.pphosted.com with ESMTP id 35ed2ahr2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 14:36:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzbOiOT0dXdJAbfeiNmC5FVZaJsxkMaKPSY1yoxRSvlNwmkUqvPR0IXYQMmu+CGNdcYTSoPkpmbHUhFrXH8ZN/OwX8NKaU9d/EcY2ZGYNwDXDsxAxtqVcm0cex3qVnWMHHjKQCuZ4laA/iuFJWWibyzA0wAxhaXIi/08QOCLMARoFCwHTxLu76ps+aZBNWRIciaKWGdsVRII7w91rxz6EzYM1dz/wj5bqPZZMfN4p2EDgp66KHsw4XgArDwzoebsPOK4rvOHSK/N6AaktVoFpPSyD1BuBS3wSkfBTjxSwnSDqgR/1/TVD5z/6aUCfkY2x/uCq8/FwfUHa2cj9ZFXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVHLWo1gcbZyJvAR6C+jBodfRtePQtPzjkOuxfOYkBk=;
 b=E5m30idy1GH1EWxpcVqDMkewBbAoYX29P4+ohtxtG+CsncSuwhEIhNITe7DBkBeadq7wU1axPSr5zily4I3v4hJvSxLwF4KaE9a2dFZp7ngVBRlfohGh0DXb6Bn0GlsJM+8y/s83qANkrjvmTJ/yzo7OgxQ4kSq+9D7Z7/MK3BFMa8ncI9zggJZNZkRbYuyZvJ1SU81lOU30RM2scKV05qzlvDkK7CVOYRltC2S/3ixGwNas/m3QNwRIcF8x5E5O+sHxWUq5+UeEgPQ9zTIJU0vkLu61sjIis6e6lij5XAHdxswpXJWMr1ze5goJGr8SM5mRaEsBV2CvIrPG3sDOtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVHLWo1gcbZyJvAR6C+jBodfRtePQtPzjkOuxfOYkBk=;
 b=UNGEfGC8HgPAo93VF+dac4/chppM9lBdkh6qkRji5Wlp8g2hlE1Kj4KUEFKn5XZCzgEjz5yw1ON+gxBam95323vCtTaujXTg6Zo8aTzLWZyUN9f7tAaBTjVFlmKV6W5fLRPe+Kq53EAeFVw1htJ2HzOuL6ruqRFKu/oQIFTsHC0=
Received: from MN2PR19MB2637.namprd19.prod.outlook.com (2603:10b6:208:104::20)
 by MN2PR19MB3229.namprd19.prod.outlook.com (2603:10b6:208:155::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.21; Mon, 14 Dec
 2020 19:36:19 +0000
Received: from MN2PR19MB2637.namprd19.prod.outlook.com
 ([fe80::9014:6833:9711:8f6]) by MN2PR19MB2637.namprd19.prod.outlook.com
 ([fe80::9014:6833:9711:8f6%6]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 19:36:19 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        Aaron Ma <aaron.ma@canonical.com>,
        Mark Pearson <mpearson@lenovo.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>
Subject: RE: [PATCH v4 0/4] Improve s0ix flows for systems i219LM
Thread-Topic: [PATCH v4 0/4] Improve s0ix flows for systems i219LM
Thread-Index: AQHW0i6xs9Hb0tASW0mYD0yDIIAYe6n26HEAgAASdaA=
Date:   Mon, 14 Dec 2020 19:36:18 +0000
Message-ID: <MN2PR19MB26376EA92CE14DC3ADD328BEFAC70@MN2PR19MB2637.namprd19.prod.outlook.com>
References: <20201214153450.874339-1-mario.limonciello@dell.com>
 <80862f70-18a4-4f96-1b96-e2fad7cc2b35@redhat.com>
In-Reply-To: <80862f70-18a4-4f96-1b96-e2fad7cc2b35@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-12-14T19:36:17.4920032Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=c4e0b09a-0dc6-461a-9d57-56ddd5c99550;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0eee7bd-d7d6-4164-9da0-08d8a06787c4
x-ms-traffictypediagnostic: MN2PR19MB3229:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR19MB3229926849A7BFA055FEE892FAC70@MN2PR19MB3229.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2t2fcpCpIumMItP7sKXMNXoCO4PuRo3H0tHD4hUsx7Gl+8M9OcmcXLg1I3A8MK1Z7pRH4cEhFbsWQClDNPihblZNtWppm0HtaMmHSSbc9j+zeBaKfwYa/5KjidaabAtqnt4EUhsv+1KA7USmHeoige98XWzI0h4BBVvw0ghZgkhLyV5guQaEcaI9nmNIwcoEDpHHrTtch5A/kNbeNt6+/zwFjCKAPF0Lv/625Nbv3rZMTxtBD/jIgqvZeywESom4T+pSGnS/ICZLJaKui4GSGk+KcKYJEAe9SCUI2aCTvlUbEnVWJSkn3jjhSNobfZCoUdESAm90FJGMmeAlrCfMbbmlOH8Cp2MyYl0GLOl8oS7G4aOes2I2W9ZduW34+7gt2pfqBUq1pjdOyGYzjJBNwwr6/STU3YCvQGCvfolcPmj+xrTrG1uewPRLjzllmTqfYw7DHGO/8SxRksLNg2hDuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR19MB2637.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(8676002)(53546011)(6506007)(55016002)(8936002)(966005)(7416002)(7696005)(508600001)(9686003)(83380400001)(66946007)(33656002)(76116006)(110136005)(786003)(4326008)(186003)(66446008)(2906002)(66476007)(71200400001)(66556008)(5660300002)(64756008)(86362001)(52536014)(26005)(54906003)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Y2dMQ0xrZ0tUdE9zdkNvUytvdERxL3p4YTB4SWZubXp4NzNCWWhFaEVnOW02?=
 =?utf-8?B?OGpyNkw3bGNpekdvSmhMSDZZalhua3d0YWdUemFaSndRb0FwUWVYazZSeDNJ?=
 =?utf-8?B?eDZlTU9ZU3FCUlEzRUl4VHdoMTlJVVEvZ3FKb25aVzJoaktka2Rad2pSR25w?=
 =?utf-8?B?blNEU25Jb3kxM2N6RjdNcDVrMDFuOTdERDFEQzlpVVp6emxOakFjM1NmVGtr?=
 =?utf-8?B?T3p4YVpubWY5a0V0VVc5ZEpGVVUya2NrZEphR0Z5R0xKTE1Wa0NTNTlhU0dw?=
 =?utf-8?B?Y2tvcjd0ay95cC9HbWI4MVIvdEdWWHd3TzJldFhBRk1PcHlWMUw4eDhzN3Rs?=
 =?utf-8?B?U1VuT2hxUUpJeEVHRUQzRGxENlBWWXprMERudnJoOGtZb0Q2aTlZT3ZJVmNS?=
 =?utf-8?B?NC9QSGN2SEhzUHozK00vSlFSNFFuQUxKSm5LR3YzWGE1ZjBGWDI3R0pJSksy?=
 =?utf-8?B?MDJWY2VYYVpmNyszM1V0eU9nNUFSRkxVT2JjOWh6akhaeTkwNHI1WGFUWGFY?=
 =?utf-8?B?QThPb3hGQTBPQk1pOUkzV0cyV29CZ3NtRzVpMU92ZXdGUlZUczM5d0JhY3B6?=
 =?utf-8?B?ODlHNjQyU2wwVDNyRmZ1VzNnSnY0TlNCNnZhYytza2Y3WEp2eDYybDU3QUxr?=
 =?utf-8?B?VHNLWlRmNFFTNFRRMHdmbDM5dHBnZ01YZzZRVlc0eXdwZFJhdjFYdUEwS0Jn?=
 =?utf-8?B?ZGhxY3QwS2FjL0FMb0lGdlp0aHo5TlRjYWp4QWVGcXdJQzJDVUFtamt3VW5o?=
 =?utf-8?B?b2tzQ2t3Z2U2bTdXbWlFbUZ4cEJQSmd6Z210VU1aQlJxVlQyRU5rTkptOVVI?=
 =?utf-8?B?cnFwNmxrOVRvSFcrSWRwdy9TN25xK3pPMGE0czU3MW1ERXJ4N2t2ZXJDWW5x?=
 =?utf-8?B?bkllT0JMVitBcXlMeWd6eFNBWE4xRXBmN1Z5Q1l0aUhuR2RuSTFRZlVjZldW?=
 =?utf-8?B?ZlFmOFU3cFVMc0wvR280Mkl4VlRLZCtsOUZPNWxiNndHM093dFJPMUVlb0dS?=
 =?utf-8?B?L3lxTTNXbjczMFJzSkU4dlRnUHNZeVBHdlYvVkkzQTZZVmdvQVRaREtnUlhM?=
 =?utf-8?B?dHhiOXYzVXpYQ3AzUisyWlRybXFNR1ZnL080TnU4a3U3Y2hYbjQ3eEJqT0Fj?=
 =?utf-8?B?QnNYS2E2WTlpZUdBSGNLYys2MzE2dW1haERma253YXpMYkk3bjhkb1VkTGxH?=
 =?utf-8?B?SFVLSUFBV1VQaGFvbFhKK2p2WVF0UFY3VkY0aXQveVA3L2pGQ2EyYjYvNFJW?=
 =?utf-8?B?bkhvbTRiUnpFVUNYS0E2OGNMd1M4b0ROakJlQjZxanA0Ry9ydE44Z0hrWGVO?=
 =?utf-8?Q?FZcI/6FOn6+uQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR19MB2637.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0eee7bd-d7d6-4164-9da0-08d8a06787c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2020 19:36:18.8602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VBrI4T+6CmGI+mblQpXo/lNgcLp3x5uLvvF1HLgSV7DodmxyfAlR/8tSKGfHQ/+m0n5eZxpqjvTcT3OHGSPOuMDJcmNMnnGwUDWUs95y+yU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR19MB3229
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_10:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1011 malwarescore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140129
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBIaSBBbGwsDQo+IA0KPiBTYXNoYSAoYW5kIHRoZSBvdGhlciBpbnRlbC13aXJlZC1sYW4gZm9s
a3MpLCB0aGFuayB5b3UgZm9yIGludmVzdGlnYXRpbmcgdGhpcw0KPiBmdXJ0aGVyIGFuZCBmb3Ig
Y29taW5nIHVwIHdpdGggYSBiZXR0ZXIgc29sdXRpb24uDQo+IA0KPiBNYXJpbywgdGhhbmsgeW91
IGZvciBpbXBsZW1lbnRpbmcgdGhlIG5ldyBzY2hlbWUuDQo+IA0KDQpTdXJlLg0KDQo+IEkndmUg
dGVzdGVkIHRoaXMgcGF0Y2ggc2V0IG9uIGEgTGVub3ZvIFgxQzggd2l0aCB2UFJPIGFuZCBBTVQg
ZW5hYmxlZCBpbiB0aGUNCj4gQklPUw0KPiAodGhlIHByZXZpb3VzIGlzc3VlcyB3ZXJlIHNvb24g
b24gYSBYMUM3KS4NCj4gDQo+IEkgaGF2ZSBnb29kIGFuZCBiYWQgbmV3czoNCj4gDQo+IFRoZSBn
b29kIG5ld3MgaXMgdGhhdCBhZnRlciByZXZlcnRpbmcgdGhlDQo+ICJlMTAwMGU6IGRpc2FibGUg
czBpeCBlbnRyeSBhbmQgZXhpdCBmbG93cyBmb3IgTUUgc3lzdGVtcyINCj4gSSBjYW4gcmVwcm9k
dWNlIHRoZSBvcmlnaW5hbCBpc3N1ZSBvbiB0aGUgWDFDOCAoSSBubyBsb25nZXIgaGF2ZQ0KPiBh
IFgxQzcgdG8gdGVzdCBvbikuDQo+IA0KPiBUaGUgYmFkIG5ld3MgaXMgdGhhdCBpbmNyZWFzaW5n
IHRoZSB0aW1lb3V0IHRvIDEgc2Vjb25kIGRvZXMNCj4gbm90IGZpeCB0aGUgaXNzdWUuIFN1c3Bl
bmQvcmVzdW1lIGlzIHN0aWxsIGJyb2tlbiBhZnRlciBvbmUNCj4gc3VzcGVuZC9yZXN1bWUgY3lj
bGUsIGFzIGRlc2NyaWJlZCBpbiB0aGUgb3JpZ2luYWwgYnVnLXJlcG9ydDoNCj4gaHR0cHM6Ly9i
dWdzLmxhdW5jaHBhZC5uZXQvdWJ1bnR1Lytzb3VyY2UvbGludXgvK2J1Zy8xODY1NTcwDQo+IA0K
PiBNb3JlIGdvb2QgbmV3cyB0aG91Z2gsIGJ1bXBpbmcgdGhlIHRpbWVvdXQgdG8gMjUwIHBvbGwg
aXRlcmF0aW9ucw0KPiAoYXBwcm94IDIuNSBzZWNvbmRzKSBhcyBkb25lIGluIEFhcm9uIE1hJ3Mg
b3JpZ2luYWwgcGF0Y2ggZm9yDQo+IHRoaXMgZml4ZXMgdGhpcyBvbiB0aGUgWDFDOCBqdXN0IGFz
IGl0IGRpZCBvbiB0aGUgWDFDNw0KPiAoaXQgdGFrZXMgMiBzZWNvbmRzIGZvciBVTFBfQ09ORklH
X0RPTkUgdG8gY2xlYXIpLg0KPiANCj4gSSd2ZSByYW4gc29tZSBleHRyYSB0ZXN0cyBhbmQgdGhl
IHBvbGwgbG9vcCBzdWNjZWVkcyBvbiBpdHMNCj4gZmlyc3QgaXRlcmF0aW9uIHdoZW4gYW4gZXRo
ZXJuZXQtY2FibGUgaXMgY29ubmVjdGVkLiBJdCBzZWVtcw0KPiB0aGF0IExlbm92bydzIHZhcmlh
bnQgb2YgdGhlIE1FIGZpcm13YXJlIHdhaXRzIHVwIHRvIDIgc2Vjb25kcw0KPiBmb3IgYSBsaW5r
LCBjYXVzaW5nIHRoZSBsb25nIHdhaXQgZm9yIFVMUF9DT05GSUdfRE9ORSB0byBjbGVhci4NCj4g
DQo+IEkgdGhpbmsgdGhhdCBmb3Igbm93IHRoZSBiZXN0IGZpeCB3b3VsZCBiZSB0byBpbmNyZWFz
ZSB0aGUgdGltZW91dA0KPiB0byAyLjUgc2Vjb25kcyBhcyBkb25lIGluICBBYXJvbiBNYSdzIG9y
aWdpbmFsIHBhdGNoLiBDb21iaW5lZA0KPiB3aXRoIGEgYnJva2VuLWZpcm13YXJlIHdhcm5pbmcg
d2hlbiB3ZSB3YWl0ZWQgbG9uZ2VyIHRoZW4gMSBzZWNvbmQsDQo+IHRvIG1ha2UgaXQgY2xlYXIg
dGhhdCB0aGVyZSBpcyBhIGZpcm13YXJlIGlzc3VlIGhlcmUgYW5kIHRoYXQNCj4gdGhlIGxvbmcg
d2FpdCAvIHNsb3cgcmVzdW1lIGlzIG5vdCB0aGUgZmF1bHQgb2YgdGhlIGRyaXZlci4NCj4gDQoN
Ck9LLiAgSSd2ZSBzdWJtaXR0ZWQgdjUgd2l0aCB0aGlzIHN1Z2dlc3Rpb24uDQoNCj4gIyMjDQo+
IA0KPiBJJ3ZlIGFkZGVkIE1hcmsgUGVhcnNvbiBmcm9tIExlbm92byB0byB0aGUgQ2Mgc28gdGhh
dCBMZW5vdm8NCj4gY2FuIGludmVzdGlnYXRlIHRoaXMgaXNzdWUgZnVydGhlci4NCj4gDQo+IE1h
cmssIHRoaXMgdGhyZWFkIGlzIGFib3V0IGFuIGlzc3VlIHdpdGggZW5hYmxpbmcgUzBpeCBzdXBw
b3J0IGZvcg0KPiBlMTAwMGUgKGkyMTlsbSkgY29udHJvbGxlcnMuIFRoaXMgd2FzIGVuYWJsZWQg
aW4gdGhlIGtlcm5lbCBhDQo+IHdoaWxlIGFnbywgYnV0IHRoZW4gZ290IGRpc2FibGVkIGFnYWlu
IG9uIHZQcm8gLyBBTVQgZW5hYmxlZA0KPiBzeXN0ZW1zIGJlY2F1c2Ugb24gc29tZSBzeXN0ZW1z
IChMZW5vdm8gWDFDNyBhbmQgbm93IGFsc28gWDFDOCkNCj4gdGhpcyBsZWFkIHRvIHN1c3BlbmQv
cmVzdW1lIGlzc3Vlcy4NCj4gDQo+IFdoZW4gQU1UIGlzIGFjdGl2ZSB0aGVuIHRoZXJlIGlzIGEg
aGFuZG92ZXIgaGFuZHNoYWtlIGZvciB0aGUNCj4gT1MgdG8gZ2V0IGFjY2VzcyB0byB0aGUgZXRo
ZXJuZXQgY29udHJvbGxlciBmcm9tIHRoZSBNRS4gVGhlDQo+IEludGVsIGZvbGtzIGhhdmUgY2hl
Y2tlZCBhbmQgdGhlIFdpbmRvd3MgZHJpdmVyIGlzIHVzaW5nIGEgdGltZW91dA0KPiBvZiAxIHNl
Y29uZCBmb3IgdGhpcyBoYW5kc2hha2UsIHlldCBvbiBMZW5vdm8gc3lzdGVtcyB0aGlzIGlzDQo+
IHRha2luZyAyIHNlY29uZHMuIFRoaXMgbGlrZWx5IGhhcyBzb21ldGhpbmcgdG8gZG8gd2l0aCB0
aGUNCj4gTUUgZmlybXdhcmUgb24gdGhlc2UgTGVub3ZvIG1vZGVscywgY2FuIHlvdSBnZXQgdGhl
IGZpcm13YXJlDQo+IHRlYW0gYXQgTGVub3ZvIHRvIGludmVzdGlnYXRlIHRoaXMgZnVydGhlciA/
DQo+IA0KDQpQbGVhc2UgYmUgdmVyeSBjYXJlZnVsIHdpdGggbm9tZW5jbGF0dXJlLiAgQU1UIGFj
dGl2ZSwgb3IgQU1UIGNhcGFibGU/DQpUaGUgZ29hbCBmb3IgdGhpcyBzZXJpZXMgaXMgdG8gc3Vw
cG9ydCBBTVQgY2FwYWJsZSBzeXN0ZW1zIHdpdGggYW4gaTIxOUxNDQp3aGVyZSBBTVQgaGFzIG5v
dCBiZWVuIHByb3Zpc2lvbmVkIGJ5IHRoZSBlbmQgdXNlciBvciBvcmdhbml6YXRpb24uDQpPRU1z
IGRvIG5vdCBzaGlwIHN5c3RlbXMgd2l0aCBBTUQgcHJvdmlzaW9uZWQuDQoNCkkgZG9uJ3Qga25v
dyB0aGF0IHRoaXMgc2VyaWVzIHdpbGwgd29yayBwcm9wZXJseSB3aXRoIEFNVCBhY3RpdmUsIGFu
ZA0Kd2Ugd2lsbCBuZWVkIG1vcmUgZ3VpZGFuY2UgZnJvbSBJbnRlbCdzIHRlYW0gdG8gZW5hYmxl
IHRoYXQgZmVhdHVyZS4NClBsZWFzZSBsZXRzIGtlZXAgdGhhdCBkaXNjdXNzaW9uIHNlcGFyYXRl
IGZyb20gdGhpcyBzZXJpZXMuDQoNCg0KPiBSZWdhcmRzLA0KPiANCj4gSGFucw0KPiANCj4gcC5z
Lg0KPiANCj4gSSBhbHNvIGhhdmUgYSBzbWFsbCByZXZpZXcgcmVtYXJrIG9uIHBhdGNoIDQvNCBJ
IHdpbGwNCj4gcmVwbHkgdG8gdGhhdCBwYXRjaCBzZXBhcmF0ZWx5Lg0KPiANCg0KVGhhbmtzLg0K
DQo+IA0KPiANCj4gDQo+IA0KPiANCj4gDQo+IA0KPiBPbiAxMi8xNC8yMCA0OjM0IFBNLCBNYXJp
byBMaW1vbmNpZWxsbyB3cm90ZToNCj4gPiBjb21taXQgZTA4NmJhMmZjY2RhICgiZTEwMDBlOiBk
aXNhYmxlIHMwaXggZW50cnkgYW5kIGV4aXQgZmxvd3MgZm9yIE1FDQo+IHN5c3RlbXMiKQ0KPiA+
IGRpc2FibGVkIHMwaXggZmxvd3MgZm9yIHN5c3RlbXMgdGhhdCBoYXZlIHZhcmlvdXMgaW5jYXJu
YXRpb25zIG9mIHRoZQ0KPiA+IGkyMTktTE0gZXRoZXJuZXQgY29udHJvbGxlci4gIFRoaXMgd2Fz
IGRvbmUgYmVjYXVzZSBvZiBzb21lIHJlZ3Jlc3Npb25zDQo+ID4gY2F1c2VkIGJ5IGFuIGVhcmxp
ZXINCj4gPiBjb21taXQgNjMyZmJkNWViNWIwZSAoImUxMDAwZTogZml4IFMwaXggZmxvd3MgZm9y
IGNhYmxlIGNvbm5lY3RlZCBjYXNlIikNCj4gPiB3aXRoIGkyMTktTE0gY29udHJvbGxlci4NCj4g
Pg0KPiA+IFBlciBkaXNjdXNzaW9uIHdpdGggSW50ZWwgYXJjaGl0ZWN0dXJlIHRlYW0gdGhpcyBk
aXJlY3Rpb24gc2hvdWxkIGJlIGNoYW5nZWQNCj4gYW5kDQo+ID4gYWxsb3cgUzBpeCBmbG93cyB0
byBiZSB1c2VkIGJ5IGRlZmF1bHQuICBUaGlzIHBhdGNoIHNlcmllcyBpbmNsdWRlcw0KPiBkaXJl
Y3Rpb25hbA0KPiA+IGNoYW5nZXMgZm9yIHRoZWlyIGNvbmNsdXNpb25zIGluIGh0dHBzOi8vbGtt
bC5vcmcvbGttbC8yMDIwLzEyLzEzLzE1Lg0KPiA+DQo+ID4gQ2hhbmdlcyBmcm9tIHYzIHRvIHY0
Og0KPiA+ICAtIERyb3AgcGF0Y2ggMSBmb3IgcHJvcGVyIHMwaTMuMiBlbnRyeSwgaXQgd2FzIHNl
cGFyYXRlZCBhbmQgaXMgbm93IG1lcmdlZA0KPiBpbiBrZXJuZWwNCj4gPiAgLSBBZGQgcGF0Y2gg
dG8gb25seSBydW4gUzBpeCBmbG93cyBpZiBzaHV0ZG93biBzdWNjZWVkZWQgd2hpY2ggd2FzDQo+
IHN1Z2dlc3RlZCBpbg0KPiA+ICAgIHRocmVhZA0KPiA+ICAtIEFkanVzdCBzZXJpZXMgZm9yIGd1
aWRhbmNlIGZyb20gaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMjAvMTIvMTMvMTUNCj4gPiAgICAq
IFJldmVydCBpMjE5LUxNIGRpc2FsbG93LWxpc3QuDQo+ID4gICAgKiBEcm9wIGFsbCBwYXRjaGVz
IGZvciBzeXN0ZW1zIHRlc3RlZCBieSBEZWxsIGluIGFuIGFsbG93IGxpc3QNCj4gPiAgICAqIElu
Y3JlYXNlIFVMUCB0aW1lb3V0IHRvIDEwMDBtcw0KPiA+IENoYW5nZXMgZnJvbSB2MiB0byB2MzoN
Cj4gPiAgLSBDb3JyZWN0IHNvbWUgZ3JhbW1hciBhbmQgc3BlbGxpbmcgaXNzdWVzIGNhdWdodCBi
eSBCam9ybiBILg0KPiA+ICAgICogcy9zMGl4L1MwaXgvIGluIGFsbCBjb21taXQgbWVzc2FnZXMN
Cj4gPiAgICAqIEZpeCBhIHR5cG8gaW4gY29tbWl0IG1lc3NhZ2UNCj4gPiAgICAqIEZpeCBjYXBp
dGFsaXphdGlvbiBvZiBwcm9wZXIgbm91bnMNCj4gPiAgLSBBZGQgbW9yZSBwcmUtcmVsZWFzZSBz
eXN0ZW1zIHRoYXQgcGFzcw0KPiA+ICAtIFJlLW9yZGVyIHRoZSBzZXJpZXMgdG8gYWRkIHN5c3Rl
bXMgb25seSBhdCB0aGUgZW5kIG9mIHRoZSBzZXJpZXMNCj4gPiAgLSBBZGQgRml4ZXMgdGFnIHRv
IGEgcGF0Y2ggaW4gc2VyaWVzLg0KPiA+DQo+ID4gQ2hhbmdlcyBmcm9tIHYxIHRvIHYyOg0KPiA+
ICAtIERpcmVjdGx5IGluY29ycG9yYXRlIFZpdGFseSdzIGRlcGVuZGVuY3kgcGF0Y2ggaW4gdGhl
IHNlcmllcw0KPiA+ICAtIFNwbGl0IG91dCBzMGl4IGNvZGUgaW50byBpdCdzIG93biBmaWxlDQo+
ID4gIC0gQWRqdXN0IGZyb20gRE1JIG1hdGNoaW5nIHRvIFBDSSBzdWJzeXN0ZW0gdmVuZG9yIElE
L2RldmljZSBtYXRjaGluZw0KPiA+ICAtIFJlbW92ZSBtb2R1bGUgcGFyYW1ldGVyIGFuZCBzeXNm
cywgdXNlIGV0aHRvb2wgZmxhZyBpbnN0ZWFkLg0KPiA+ICAtIEV4cG9ydCBzMGl4IGZsYWcgdG8g
ZXRodG9vbCBwcml2YXRlIGZsYWdzDQo+ID4gIC0gSW5jbHVkZSBtb3JlIHBlb3BsZSBhbmQgbGlz
dHMgZGlyZWN0bHkgaW4gdGhpcyBzdWJtaXNzaW9uIGNoYWluLg0KPiA+DQo+ID4gTWFyaW8gTGlt
b25jaWVsbG8gKDQpOg0KPiA+ICAgZTEwMDBlOiBPbmx5IHJ1biBTMGl4IGZsb3dzIGlmIHNodXRk
b3duIHN1Y2NlZWRlZA0KPiA+ICAgZTEwMDBlOiBidW1wIHVwIHRpbWVvdXQgdG8gd2FpdCB3aGVu
IE1FIHVuLWNvbmZpZ3VyZSBVTFAgbW9kZQ0KPiA+ICAgUmV2ZXJ0ICJlMTAwMGU6IGRpc2FibGUg
czBpeCBlbnRyeSBhbmQgZXhpdCBmbG93cyBmb3IgTUUgc3lzdGVtcyINCj4gPiAgIGUxMDAwZTog
RXhwb3J0IFMwaXggZmxhZ3MgdG8gZXRodG9vbA0KPiA+DQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2UxMDAwZS9lMTAwMC5oICAgfCAgMSArDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2UxMDAwZS9ldGh0b29sLmMgfCA0MCArKysrKysrKysrKysrKw0KPiA+ICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvaWNoOGxhbi5jIHwgIDQgKy0NCj4gPiAgZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jICB8IDU5ICsrKystLS0tLS0t
LS0tLS0tLS0tLQ0KPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDUzIGluc2VydGlvbnMoKyksIDUxIGRl
bGV0aW9ucygtKQ0KPiA+DQo+ID4gLS0NCj4gPiAyLjI1LjENCj4gPg0KDQo=
