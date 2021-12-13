Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886594734E4
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 20:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242336AbhLMTXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 14:23:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62540 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241599AbhLMTXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 14:23:35 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BDHAGMA002001;
        Mon, 13 Dec 2021 11:23:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Nq6V88Dv8h7OrpCwPtg7GalG2uE+VWe/t5WUSYfnb0M=;
 b=gcnm7gpB/Izpq6M3p1SkxGWyznIHitpUXOOr+cDSnpUTAC92iwJ90n9tjp+SJZTja2/2
 Gi9f5wOJ4I+/iq8qlTUs20oloqOG3aSjSsxD6Zh0hWkyf3IF9L5EpYRJcrlds6hBQLuw
 0kbv1nzw3b6TcaXowYn20VvYTyzuvOBfWPQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3cx9rpsbvk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Dec 2021 11:23:34 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 11:23:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUAggcJWADbYBDh4H3kc9cF+YU02mxlGtYODpzwYj6E/Gob+JhW8o3f64cPc47oFFHdRxzqxPIVfXg6nkoHBr7ym7vCOCUzBYOsTY+N170Ds4vwGoBenX/odG53D2crPt26WAjr7KWIr6P2iZnq626mEdhHzZwq9BcmzsBiUdYX/Xy4zzsLkXcEsAPzUzeDnN2G9UqNl0dQDhdM4lCJkglZdQdvu4ZIoBqE36aCnj9H7KEpVjYl8To2lpW39DGcG4pSVDI3V7zjUYT2ddWGi7ceEw2auYl+krvsf24egvqJA3YnS7/HJ9CJ56eToezjX7jkdWLvLgePVHEyUtcBDgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nq6V88Dv8h7OrpCwPtg7GalG2uE+VWe/t5WUSYfnb0M=;
 b=Gumng/J4FE8OTFczmV2Z22e+qYjMXqnWbicfcHJcA0kTOFwcdRYx1LElZZKyQpGSvPNm7zFb/WOFIZEr+UJYqd1l3OwrWGbMVBpHa8Rp2eLHshfHFmsC75ja/GVLq0JNXgWM4VDN8DWpWnrJvoFLWzzJx1XyvzXGwwQn469QSwc+qLgLD6EuO6qWtsGhYkVqjSjGK55+n18YX2LhyiIN6tiXupxijyYGUti49T7IBKwFJwKigY+Z5v3rMdhQ1i4mS6+kvORzqRF1lMex7tadvHHBd5EfEvNQZ27/+9V2vd6p2x0K4HslHskzWenZh1g2EeSAUSTj2GeTj9DCI4STjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4762.namprd15.prod.outlook.com (2603:10b6:303:10b::15)
 by MW4PR15MB4779.namprd15.prod.outlook.com (2603:10b6:303:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Mon, 13 Dec
 2021 19:23:27 +0000
Received: from MW4PR15MB4762.namprd15.prod.outlook.com
 ([fe80::c808:945c:3b20:4b71]) by MW4PR15MB4762.namprd15.prod.outlook.com
 ([fe80::c808:945c:3b20:4b71%4]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 19:23:27 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>
CC:     Noah Goldstein <goldstein.w.n@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
Thread-Topic: [PATCH] lib/x86: Optimise csum_partial of buffers that are not
 multiples of 8 bytes.
Thread-Index: AdfwSx7jhGb9mOkwS12sTJ1p5oR1JQABnEiAAACuc2A=
Date:   Mon, 13 Dec 2021 19:23:27 +0000
Message-ID: <MW4PR15MB4762B9F48EA56F477EDA63A1BD749@MW4PR15MB4762.namprd15.prod.outlook.com>
References: <f1cd1a19878248f09e2e7cffe88c8191@AcuMS.aculab.com>
 <CANn89i+FCddAJSAY1pj3kEDcP5wMnuQFVCa5ZbJwi1GqJ89Hkg@mail.gmail.com>
In-Reply-To: <CANn89i+FCddAJSAY1pj3kEDcP5wMnuQFVCa5ZbJwi1GqJ89Hkg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 880eeafb-c1fb-4c0c-4d3f-08d9be6e09f4
x-ms-traffictypediagnostic: MW4PR15MB4779:EE_
x-microsoft-antispam-prvs: <MW4PR15MB477988D61C1786C67D66FEF3BD749@MW4PR15MB4779.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ZN8UhaCzEViVlGXJbzFDwspHIFJ3DuvjtnHPGsnvHfbLxulB7zWELp3TcypEdTsCFOkrE/1jx3Frudd6yLLolZeKl956ij4XIKnKqaywCXKw5sk9NsEXeq6whlmNJwrsP4Q7PkkbBVtNHp1MkfWnChvkdlssACLbjO5Mo/2lnn2BMioerVSvnE2rr/CtHWCWWPsNZLb60jyAr839RVuHGUwC91fQZ1laSgCBUcG5TgLgNrQ7+19rFYRp33QrL80JN829z9So0pnk/kTmoH2G8NyjESV0Tio8zSgeugKx4ZTEVzOY3ZyYaCt045OetR49UI1CMHWSoeDwSkYGl/jY1i9uh4CozKpvZ8o6dZmrhFfIuvjVnNLX4B+m+sLvIkllwF7nZtEfS8kBQ1oDrtgjuxB3HNHJVhjK7U/BSDYpKTFAPGHge1yaSCfZ+muUcXCyMRsRI8qU4Id2hm/wmnCT3NUr93XnJnZ5pEb8AgWOxE1V5x3EZZdG+SVHARhE7wy09TlLwesyedgFdDBLjA4qNTztf8kGwXbMs8t9qwaDPyipHOX6m7sQzG/PslhjTRIuw7PEE8orvSDI0WY0qUIdWuH9Q+3OgbnMHKHb8xTJcdSOG62W+8/Qzc7ixIt15FJSshY+qXBlzK0I4G1dt4bipWWvU68vk7HIgpiB4L8UyOwY0GsyxzW0hWrkL8X75sTR4ZJoQdBuM8iP4VXwV7izQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4762.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(4326008)(55016003)(7416002)(186003)(86362001)(53546011)(83380400001)(26005)(6506007)(71200400001)(38100700002)(8676002)(38070700005)(7696005)(76116006)(33656002)(66556008)(54906003)(66446008)(508600001)(8936002)(110136005)(52536014)(66476007)(64756008)(66946007)(9686003)(316002)(122000001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3Nkc2NEcUJhc3ZKc2tQcHQrU1M1cXE2YnVhRlFSV250YmFFcEtwWTFLZjhJ?=
 =?utf-8?B?RHcra3lSSEtqTmRCNWNGalFTZTUvRVpxYnBOKzZGTlgxd1JQbTZQNm5JamdE?=
 =?utf-8?B?MExZRXg5Q1B0czFVZ2w3UVFZK3h6b1JhMVBjdHJCWUlBQlJURkJzdURkWVNE?=
 =?utf-8?B?Q1MvcHVNVk5nT2tJa2NCWU4wUFo0dy8xZVQ0VDkzVzJ4VW5BYXJmaHZXQVVG?=
 =?utf-8?B?SW5mR0hWYmkvTk9nQy9WS0dxZUF6d1IvMlYzaDQzQlFuOU80YVJzQ1hRVnoy?=
 =?utf-8?B?NHpVOElqRVpDWnRGa2d0MnhOT3dHL25nRW1haW5ONXN3Wm44cWJVMVpMZm95?=
 =?utf-8?B?UitBQ05Fd1FsNStMSGVCUWlSb1A2S2tOWldobldRcWZhczdZTzl4T3FyQWZJ?=
 =?utf-8?B?U1Q2VTdaRGhjdFJaYXVDNE43d1lNNnFPZGFIQ1lqSHBpelFaaWZUVmt6NCtD?=
 =?utf-8?B?TjVNS0NsSnM3MG1OWUtubWhxVFJaKzdZRGozdWZBRUJWVjQvcDJNcWgrZWNR?=
 =?utf-8?B?aS9ON2tXbDFuRHBPWVRtQWt6S2Z4VTVYMDN1akVCeWl6WUJEZk02eFlodDlE?=
 =?utf-8?B?bXJQelltY01Fb0xoNW1XUENQZEE3U08venNuUHRCRWRCMnRzcjBHNnd3YlRP?=
 =?utf-8?B?SHVjcnc1SnF6YTVmclZJZTNMejF5K0dxQW96SkxwQmRFQ2M0QjBwZldIYXhs?=
 =?utf-8?B?UTd1ZStUcFlJandGUkR1eXhRM1dMbVk0cGYyOTVISFRscTY4dThKRjdlUG5Q?=
 =?utf-8?B?MHVrNzNWOUhWWmZTMnQ3TVFVV0l1Q0R3ZSt2aEc0aGZFS3cyV2dLbENBZHhY?=
 =?utf-8?B?dnJtRHhlM1oxeWM0OCtzdjUxcDAraEhwTHcyUVhGaEcvdjl3a2dKcjN0Y2dz?=
 =?utf-8?B?b1JmQzdjMlY4UzhNVGcxbzlDdE04em9XRVVOSlZsQVRuY2FvcmFPbllJRVMx?=
 =?utf-8?B?MEM1dlJxWFVaWFlmQnlNK3dJWWRRRC9NdnZiVHF2NEFHSm52dnUrY2d6WERJ?=
 =?utf-8?B?R1pnbWwrc2tyNTBZTU1mZUl3WHhYd2E5dlovUnVvV1RmbkVHUmM3dkYrdEky?=
 =?utf-8?B?VHBkTW55cEo5N0UvN2FXcTIrRTZzY1MzcCtqa0IrVDRac2lyNU5CSFRHNHE0?=
 =?utf-8?B?ZW9NaFA1N3hDUEtlay9oWmlJa2pudjZoZ2pqeEN0aGVjUHIrUkM3M2NFcklR?=
 =?utf-8?B?ZEJHRHVnczBDNFZ1QmVOUDBkd0UwZ3VISHpyakJvNHBxUkVROVVIWVJzd1M2?=
 =?utf-8?B?MWRQK1VBQ1oxZTlaMStmbStDL2l5TTd4NWw3UjJIUjNBd1Q1bEg5TXBaOXJk?=
 =?utf-8?B?cllSRnV6QTEra1dNMlJndnEvYVd6RnFHK3llbjJNSm53dkZFbHZoaHR1NFAy?=
 =?utf-8?B?OWMwZDJuNllVUC8zOTlEZk1HV3g2MThqMjlwVHJBejgxeU55U2JadHpEQWJj?=
 =?utf-8?B?Z2YxT1FVSkRTbHdubnFyQm83VUJXUGFJc01PNWQvcHRSNlRqTWZVd0tVeURS?=
 =?utf-8?B?SE1ZM0hVTU1WNTNXMUo1WGExZ2ZNS0hhUFRtZExybUpDeXgyOG54aUxQZldG?=
 =?utf-8?B?RW5pTzZaWGd0SytBUm9NUTRqYmlzM2FGVy9BVFRqODJ2Ynh1VEJBQmlnbEJ6?=
 =?utf-8?B?YUlCZG1JTy9xd2xUWEp4UlNicXFZazNWWTJMU2dMOFdaRWRNa1RYVElZeENZ?=
 =?utf-8?B?UENlbTE1WHY5UjlDQ1RSbHo2NWQzalNBdE1zZU9ZOXkraEJHeHFYSWw4OGtl?=
 =?utf-8?B?V1R6L1Q3eWJ2MFpJVVRQUGtxeXB0S0gwUjJIVEw1eGNjeUs2a0RCeEdRY0Ez?=
 =?utf-8?B?Uk5kSU9nekZ5SlZrTjVVVkZ2TzlVaEd0ZkRBR29SZGs2akJWMVplVlBqQURD?=
 =?utf-8?B?and1MnpiR0pXblpIT0NvVUFNYWk1c2FFQXlGWnBjeUxSNGFtL1pYSDhLbU9C?=
 =?utf-8?B?a0R6OTBnMGdqdTRJWllPWERnbUpsRWdvUC9sa0ZYOCtNblNNbXVwZ09GK1Zz?=
 =?utf-8?B?ZXhMdWFHTlpHNzZUQW1oRm5KVHc1SUpob3dwQ2cyR21IOU9nWjU1a1h6TFhw?=
 =?utf-8?B?TE9xb3U2UDlzbFE5aTlCaDVNWGYzbUZYd0cvTkhqRVl1OW5sRk1neW0ycDVS?=
 =?utf-8?B?aG9FUDZIdWJKV2pONDJKWXZ3eFUwSWpBOUdoSWk5dDBQcHJkclkwaE5rTEVk?=
 =?utf-8?B?SVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4762.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 880eeafb-c1fb-4c0c-4d3f-08d9be6e09f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 19:23:27.1071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DjTWKCuFBKvXRkDddLFbFAPKYTl9h12l3peEMCm6ZjPNN+ggRTIRK4x/Y+etFc7adXsGw+znjzt6OuSD5+bhyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4779
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: o1v1_NDkFo5buL40jxjbNOJ2cvvxdm3G
X-Proofpoint-GUID: o1v1_NDkFo5buL40jxjbNOJ2cvvxdm3G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_09,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112130119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
ZHVtYXpldEBnb29nbGUuY29tPg0KPiBTZW50OiBNb25kYXksIERlY2VtYmVyIDEzLCAyMDIxIDEw
OjQ1IEFNDQo+IFRvOiBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBhY3VsYWIuY29tPg0KPiBD
YzogTm9haCBHb2xkc3RlaW4gPGdvbGRzdGVpbi53Lm5AZ21haWwuY29tPjsgdGdseEBsaW51dHJv
bml4LmRlOw0KPiBtaW5nb0ByZWRoYXQuY29tOyBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFsaWVuOC5k
ZT47DQo+IGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNvbTsgWDg2IE1MIDx4ODZAa2VybmVsLm9y
Zz47IGhwYUB6eXRvci5jb207DQo+IHBldGVyekBpbmZyYWRlYWQub3JnOyBBbGV4YW5kZXIgRHV5
Y2sgPGFsZXhhbmRlcmR1eWNrQGZiLmNvbT47IG9wZW4NCj4gbGlzdCA8bGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZz47IG5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4NCj4gU3ViamVj
dDogUmU6IFtQQVRDSF0gbGliL3g4NjogT3B0aW1pc2UgY3N1bV9wYXJ0aWFsIG9mIGJ1ZmZlcnMg
dGhhdCBhcmUgbm90DQo+IG11bHRpcGxlcyBvZiA4IGJ5dGVzLg0KPiANCj4gT24gTW9uLCBEZWMg
MTMsIDIwMjEgYXQgMTA6MDAgQU0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAYWN1bGFiLmNv
bT4NCj4gd3JvdGU6DQo+ID4NCj4gPg0KPiA+IEFkZCBpbiB0aGUgdHJhaWxpbmcgYnl0ZXMgZmly
c3Qgc28gdGhhdCB0aGVyZSBpcyBubyBuZWVkIHRvIHdvcnJ5DQo+ID4gYWJvdXQgdGhlIHN1bSBl
eGNlZWRpbmcgNjQgYml0cy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IERhdmlkIExhaWdodCA8
ZGF2aWQubGFpZ2h0QGFjdWxhYi5jb20+DQo+ID4gLS0tDQo+ID4NCj4gPiBUaGlzIG91Z2h0IHRv
IGJlIGZhc3RlciAtIGJlY2F1c2Ugb2YgYWxsIHRoZSByZW1vdmVkICdhZGMgJDAnLg0KPiA+IEd1
ZXNzaW5nIGhvdyBmYXN0IHg4NiBjb2RlIHdpbGwgcnVuIGlzIGhhcmQhDQo+ID4gVGhlcmUgYXJl
IG90aGVyIHdheXMgb2YgaGFuZGluZyBidWZmZXJzIHRoYXQgYXJlIHNob3J0ZXIgdGhhbiA4IGJ5
dGVzLA0KPiA+IGJ1dCBJJ2QgcmF0aGVyIGhvcGUgdGhleSBkb24ndCBoYXBwZW4gaW4gYW55IGhv
dCBwYXRocy4NCj4gPg0KPiA+IE5vdGUgLSBJJ3ZlIG5vdCBldmVuIGNvbXBpbGUgdGVzdGVkIGl0
Lg0KPiA+IChCdXQgaGF2ZSB0ZXN0ZWQgYW4gZXF1aXZhbGVudCBjaGFuZ2UgYmVmb3JlLikNCj4g
Pg0KPiA+ICBhcmNoL3g4Ni9saWIvY3N1bS1wYXJ0aWFsXzY0LmMgfCA1NQ0KPiA+ICsrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDE5IGluc2Vy
dGlvbnMoKyksIDM2IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2xpYi9jc3VtLXBhcnRpYWxfNjQuYw0KPiA+IGIvYXJjaC94ODYvbGliL2NzdW0tcGFydGlhbF82
NC5jIGluZGV4IGFiZjgxOWRkODUyNS4uZmJjYzA3M2ZjMmI1DQo+ID4gMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC94ODYvbGliL2NzdW0tcGFydGlhbF82NC5jDQo+ID4gKysrIGIvYXJjaC94ODYvbGli
L2NzdW0tcGFydGlhbF82NC5jDQo+ID4gQEAgLTM3LDYgKzM3LDI0IEBAIF9fd3N1bSBjc3VtX3Bh
cnRpYWwoY29uc3Qgdm9pZCAqYnVmZiwgaW50IGxlbiwNCj4gX193c3VtIHN1bSkNCj4gPiAgICAg
ICAgIHU2NCB0ZW1wNjQgPSAoX19mb3JjZSB1NjQpc3VtOw0KPiA+ICAgICAgICAgdW5zaWduZWQg
cmVzdWx0Ow0KPiA+DQo+ID4gKyAgICAgICBpZiAobGVuICYgNykgew0KPiA+ICsgICAgICAgICAg
ICAgICBpZiAodW5saWtlbHkobGVuIDwgOCkpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
ICAvKiBBdm9pZCBmYWxsaW5nIG9mZiB0aGUgc3RhcnQgb2YgdGhlIGJ1ZmZlciAqLw0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGlmIChsZW4gJiA0KSB7DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB0ZW1wNjQgKz0gKih1MzIgKilidWZmOw0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgYnVmZiArPSA0Ow0KPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgIH0NCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBpZiAobGVuICYgMikgew0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGVtcDY0ICs9ICoodTE2ICopYnVmZjsNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJ1ZmYgKz0gMjsNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICB9DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKGxlbiAm
IDEpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0ZW1wNjQgKz0gKih1OCAq
KWJ1ZmY7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZ290byByZWR1Y2VfdG8zMjsNCj4g
PiArICAgICAgICAgICAgICAgfQ0KPiA+ICsgICAgICAgICAgICAgICB0ZW1wNjQgKz0gKih1NjQg
KikoYnVmZiArIGxlbiAtIDgpIDw8ICg4IC0gKGxlbiAmIDcpKQ0KPiA+ICsgKiA4Ow0KPiANCj4g
VGhpcyBpcyByZWFkaW5nIGZhciBhd2F5IChlbmQgb2YgYnVmZmVyKS4NCj4gDQo+IE1heWJlIGlu
c3RlYWQgcmVhZCB0aGUgZmlyc3QgYnl0ZXMgYW5kIGFkanVzdCBAYnVmZiwgdG8gYWxsb3cgZm9y
IGJldHRlcg0KPiBoYXJkd2FyZSBwcmVmZXRjaGluZyA/DQoNClRoYXQgd2lsbCBjYXVzZSB0aGUg
d3N1bSB0byBiZSBhbGlnbmVkIHRvIHRoZSBsZW5ndGggaW5zdGVhZCBvZiB0aGUgYnVmZiB3b3Vs
ZG4ndCBpdD8gU28gd2Ugd291bGQgbmVlZCBhbiBleHRyYSByb3RhdGlvbiBhdCB0aGUgZW5kIHRv
IHJlYWxpZ24gb2RkIGxlbmd0aCBzZWN0aW9ucyB3b3VsZG4ndCB3ZT8NCg0KU2luY2Ugb3VyIG9u
bHkgY29uY2VybiBoZXJlIHdvdWxkIGJlIGxhcmdlIGJ1ZmZlcnMgd291bGQgaXQgbWF5YmUgbWFr
ZSBzZW5zZSB0byBqdXN0IHJ1biB0aGUgbG9vcCBpbiB0aGUgY2FsbCBpbiByZXZlcnNlIGlmIHdl
IG1ha2UgdGhpcyBjaGFuZ2U/IFRoYXQgd2F5IHdlIHdvdWxkIHN0aWxsIGJlIGFjY2Vzc2luZyB0
aGUgc2FtZSBjYWNoZSBsaW5lIG9uY2Ugd2Ugc3RhcnQgdGhlIGxvb3AuIEZvciBzbWFsbGVyIGJ1
ZmZlcnMgSSB3b3VsZCBpbWFnaW5lIHRoZSBvdmVyaGVhZCBzaG91bGQgYmUgbWluaW1hbCBzaW5j
ZSB3ZSBsaWtlbHkgd291bGQgaGF2ZSB0aGUgZW5kIG9mIHRoZSBidWZmZXIgc3RpbGwgaW4gY2Fj
aGUgc2luY2UgaXQgd291bGQgYmUgc29tZXRoaW5nIGxpa2UgNDBCIG92ZXIgYW55d2F5Lg0K
