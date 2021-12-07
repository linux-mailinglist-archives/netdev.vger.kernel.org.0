Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8027046B2EB
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 07:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbhLGGd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 01:33:56 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49896 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234928AbhLGGdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 01:33:55 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1B71h0YD028568;
        Mon, 6 Dec 2021 22:30:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5ASqIii2aXKE/pUQLPd3u0I+h+zbFPgh8nzoBeNXXH8=;
 b=gTMwQrdI8/QSmop4m9VrzCREbW8LxQ8Ad7i97X0RgnZIm26APx93j6scjJGsJhd+5/jT
 rZJ35ApAIoRIRm6gDBR8J6opr+15LbtpmWYUpHb5APC05HRR1tkpzN/HNXHals7JDvnF
 Ys4a0U1nbWnU6UmQYC3Ej7Sp7C7SxeroG2w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3csx6ds6ae-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 06 Dec 2021 22:30:25 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 22:30:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7dOvRLJKtf4I7TjbteKtXG45wiUrXUHkOP+K1TIczXqATcJdjNJyOUACshy9KjP3IVrnpbm6cCuj2K1tnBZA2iV0S7mi6jJ5WT2A8O6OH1cTHIfMjHRSrFJFSA1Ixo2+wzQSKYWsluSmTuqJ6CcgFlpxjDcMv7tWgexRqT64a6WaMJl6MbHSSub35T2TrH4vrAZQtVkOfDm4jzxXmHvph64iSb4NElkEsoa6rduAW94Yr00wFJZfaNtLyTCalEG5VI7TD2VcUs8aLBgVtpY/4WsxyiPSwT+wEXPJ7OwyCXOsJlG0sI0If4yU/ke1JiODBuLnz50xLKp4LHwFybgAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ASqIii2aXKE/pUQLPd3u0I+h+zbFPgh8nzoBeNXXH8=;
 b=hflIC1DS83GvWn94uOyZxO7xOKpj/Ch9a6x2Gycb8do5R6Ey7nMxnfXblIDMdd/WLlCqcvRwd30xIhYc/N8JD0HJhJiTktAfq0o93dK/uKDNrIPdHLUJCTeMovPR0kLk3jhXdbJg4tWW6um71yfVRtnDxKfc95T/bNmrbiZFYAfMmadVfHhOb/1IfMV1PApdeiyeE0wzka9dN0fO8VtJCscuWwx/7BN8IVUiYjXthUc6ZdaYVrzULuN5CBK1FhWg3N5GHgXPN5EHjmqc0VVm84BrjnJpZjU+VOEIFbL7bfLvgoQx/sPD7P5VXwVL5YYapSSLDbLQxAezb88kTptKZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5139.namprd15.prod.outlook.com (2603:10b6:806:233::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 06:30:22 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%4]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 06:30:22 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH bpf-next] perf/bpf_counter: use bpf_map_create instead of
 bpf_create_map
Thread-Topic: [PATCH bpf-next] perf/bpf_counter: use bpf_map_create instead of
 bpf_create_map
Thread-Index: AQHX6vYzhWKFIoT0wkePQg16MtlXfawmUPOAgAAf5QCAAAuIAIAAFYSA
Date:   Tue, 7 Dec 2021 06:30:22 +0000
Message-ID: <08EB4596-7788-4570-B0B0-DE3B710BBDD8@fb.com>
References: <20211206230811.4131230-1-song@kernel.org>
 <CAEf4BzbaBcySm3bVumBTrkHMmVDWEVxckdVKvUk=4j9HhSsmBA@mail.gmail.com>
 <3221CDA7-F2EF-404A-9289-14F9DF6D01DA@fb.com>
 <CAEf4BzbN17eviD18-_C2UN+P5gMm4vFXVrdLd9UHx0ev+gJsjw@mail.gmail.com>
In-Reply-To: <CAEf4BzbN17eviD18-_C2UN+P5gMm4vFXVrdLd9UHx0ev+gJsjw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da281673-3d84-4771-5ea5-08d9b94b0c3a
x-ms-traffictypediagnostic: SA1PR15MB5139:EE_
x-microsoft-antispam-prvs: <SA1PR15MB51395875BAB4FA2F1CF09653B36E9@SA1PR15MB5139.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Svo1XfwR2fC9C/1FA9vKt808rSdQedAiMnaKuqjODd8F06VAkqcZOv2NCEPmYCs2zc03nfgjOZN0jZ0nal2cZZZVYoExj5x9SMdWKAWu267MNsuYOxN7M1hmpP+Aq0Z8BTN1Ti0SNLvKHci9psKauOB2U82nJH/taEYTFfqTXJDoWZgtrd9LP4ST/yBtEi9PryXAslvR89voLAeBT40X8MYqRQRi1MNIxF36Vi8xgALuJ3nkY0n1WlaGX3/uctaI+G6bKTLHLfoCISjaiFU0qObWHgdZ2nBlk9h58zfB8mFqxoSWOuaz07Zc2Gm0ee9f+aGrBbKSi9mWxk+D3hM9XNfhOYop/PYu+Z0WHuWxlL6RIfEBVTCiku1ZJqTmerUYhsKfzUcSyZ3atE3x2iy+GXNhI4m0D9gLuVmMvzpaWD2nrEZk/m2dc8IHRVS2ytu3HiKK79jJa48ozPd2d98lm0dTlWizOhSgWSahBlzNayTB5NWYeNsIIE6dqC5yXDEre5YUxUW3SqhXBa4h42xGliJzO16+vBm/Sng3PiKXmoLdbifQrh/yvGM/IRc2Yke6ZrQpeRxxHye6o2yX8ymynJoScsTn20Y9dD4ykZzF9LZA4xbgis1lS4fAZaSL53Smnb577NHSm/O8YC2Sea3oIb/7Rpf3Q6VPXVpVqHZbqQ4Qz0v73k8cLdH9BiWkdOsl3doEFdT/ZPuTKTZ17ZcgVyBSr2S05zVhR6eQ/N/w19BiOmRGkwUAW80HxVrUk07h+83MO4jre+TOenpQGM7cBzSYFRJsYuXZdz5tLP1mXdDXaCqfD1bVhl7Eln7p3y4ZAYkT9tYxke664f/P3o9MLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(508600001)(83380400001)(33656002)(64756008)(66476007)(91956017)(8676002)(316002)(6506007)(66556008)(186003)(71200400001)(76116006)(36756003)(66946007)(122000001)(86362001)(2906002)(6486002)(38070700005)(6916009)(6512007)(2616005)(966005)(54906003)(5660300002)(8936002)(4326008)(66446008)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTZQbnl2Y1VMODlKa0RxWmJ2eG1iOVN0a3lkVG1jenNOZnd4M1MzdmVDVnl0?=
 =?utf-8?B?Qjg0WVd4S1M1cGxjS0trTzJOZ0tKZjhPZEs3bVNGTUdtaEpjUDI0OHVKclhv?=
 =?utf-8?B?V0VsRDUrTXJlS2RlN1IrVXpjYmhaUlFaNTBmRVNXcUh6emM4Y1ZFQ1JWY1dJ?=
 =?utf-8?B?eEdXMjI4TlVWUERZSmVLQU4ybkdRcjBrdm1tSTE4UW5mVVZyOFNTRGF6TDhL?=
 =?utf-8?B?VVBvMkZpQm84N056NDIwYnNtTmZCc3AycnljUnQvc3F3SDB0V3A0Zi9mZ0VG?=
 =?utf-8?B?REZWd3MxZFJsQjBPMXduUSt4ZnJIRzFFY3hkL3ZUWUN0cXZlWVVNNk5xdlg0?=
 =?utf-8?B?VmQwSVNSM3VvUTNKWUNiS3cybEw4SWJOWHVIeXdvTVFoajljZDlzZnpMVHJO?=
 =?utf-8?B?MXVhRUUrVEVnOGVGSzFweFhqdThrOC81Q0RMUWw1bTZ3K2VPbWt6aFpMdzBt?=
 =?utf-8?B?WHVGdWtGbUx3clR1VTJ5RnZhTUQ5TFR2SGV6K3l6VU9YQWFWajBzS2xXSkd6?=
 =?utf-8?B?eUZqa0ppc1IybWNHanM4blFnOTNFN05IZHdINFpqeHFUVS9rSDBsU3lkSDB1?=
 =?utf-8?B?MEVXckpUZVZGbFdEcFAraUhlZUo4M1hSQVJNWVhjL05WYXIzUkZwZXBKTG9k?=
 =?utf-8?B?cXFEaHNOVWM2U2ljTmZydnI5VDJXMFB1QmE0MHlQUG9MU0R5Snp4MEE4NlBl?=
 =?utf-8?B?SVVNdFZkd0FrenVNblhmV1lhOEU5enJ6cTVXMCtrMTBpRm03cmEyYUdQaDN5?=
 =?utf-8?B?OHBwWjVPTmszK2dwSVV3SXpDZGxVd0F1cDh0ejRUeElJVlhuMVZzY2VQMXhz?=
 =?utf-8?B?SFoyZkt0YXVoWjRBMEIvYmZ1cGNLb09xTFhNWk9PZEgzMUFPcEZRMFVBVDRY?=
 =?utf-8?B?MU5QY21LcVE0bUZzYmd6MldJblJPMlJUOWZBZHFyR2FHQkJBRTJBZlVYTFVn?=
 =?utf-8?B?QjBoMDlib2JYZStVNkhJaHh4V3F0RXdFWHZEZ2gyR2p5VmpaR1NBbE1FRGYw?=
 =?utf-8?B?NVFCUktlQkhpUXZGMTR4ZFRvYlkxaHYybWFmLzUwL0V3ZWpBNDRObzhWOVF3?=
 =?utf-8?B?bFdscm11U1ZvdHdrMWJEbXdkQ3RSVzkzWXVyeUxNd1FMUVNkUlBvekVyQ2Uv?=
 =?utf-8?B?Umg1THBDSXpXd3JtY3pZZlhhOWZKYm9jcUZuZ3FDejQ4dVA1b1QrMUpKTnRP?=
 =?utf-8?B?ZTZqRHREb0o5SUJRS0swS3VaVW42VEIzVHlFY3dvT28wVWU2aGFKZmFacjJX?=
 =?utf-8?B?TStpWk1ZVGZNTmVBNjhYbVg4WmVhTDA3NHNxdk9GVFZzTjBxYklPcjczN1lw?=
 =?utf-8?B?WmQvRnBBRVBLSmJpL3ZBOGp2aWEzNTk2NG9nQVMrQnNTWGs3VzhYeW9oVmxw?=
 =?utf-8?B?TWdxeW11dHJEdDRZTDZOLzQ2ekxOWG9WbU5ZNGRIdTBYOHZYbHgvbmUzOGRv?=
 =?utf-8?B?ZTh3REVYZ1FrSkhuMHlUc2xSWFFIZTNOVmlIRzQ5aHoyNDhFMVpJZFdibFdx?=
 =?utf-8?B?RjJHOW9OUm55eFI4Q0JrQVN0WXh6NjcrT01aeFUrQzVTbEtOcXp4Q1poV3VX?=
 =?utf-8?B?cmp5RVRGWjlkek1ZY0VRelU1WitQWi83bFd6MS95YkQ1RnQydXp0aFRQTUkx?=
 =?utf-8?B?RHo2ZWFVV1RTV01qREdoSXdtQjNnb3BDdG5TZWdSWEpXUkdmejF0VTY5Y0w5?=
 =?utf-8?B?WjdLYS91K3U0YnZUcy93R09XZ09XL2loUVo2NDM0QnZWc05qbExXZFVrMDd3?=
 =?utf-8?B?b2dlQUU0NnBzR2hmdlZoU01iVDBiZk5FdHhjTEF2QW5FUmwrL0lZN3hVL2F1?=
 =?utf-8?B?dW51UjU2WTUwMzFkRms4K0VtcDF4WlZaM2hMWDRBZlgrSG5wTnlqNDdFL2wy?=
 =?utf-8?B?eHlvZExTd0dHNEZOamw4ZnVIV2JvbDVYZjIyRkdWaDF3ZXdEeHdyV25HUVho?=
 =?utf-8?B?RXhkVnpaSWZMc2k5Y0pML2hUcXRaRnV0YVRNWXp4alhBQ0RPVm5vY0xQcEl2?=
 =?utf-8?B?bjRMSXF6enJka2h3QXcvSlpIcDlmT21YYVhJNVJOa0puWTRROEJwZGZhTkVP?=
 =?utf-8?B?c21lNHJKUGd0djhDRTJpQ1VtRW1xdGpKRFlDQmtXcGswaWFIejFnZ04vU2p1?=
 =?utf-8?B?b0wxZGhMUzB3dEtQZUVqbGY3UnJLOVl3T1I5YVFiRDE3SWVRSEtaenhMeWVh?=
 =?utf-8?B?VjFFWUtvcDhTUFdtZjVKUE1EamRHVEE2c2U3ZWpWZElCQkppdVFHMUd3RzV4?=
 =?utf-8?B?UkRFajA5KzFtN3hxb29tUWloZG9BPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <593EC37D410ED14B9AFF91D47C394EE2@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da281673-3d84-4771-5ea5-08d9b94b0c3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 06:30:22.7696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4kgq+LKR0ieNPuNuJ5V7Eh5kWJ4A2CExoe0/N1hidPCiFThRFGg1JtnSRLtbKfsGAtww9ezkn+wCakjguxr9PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5139
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: pQWJuQNW0blN0Clk3Xvk7Hh-qAtsO90T
X-Proofpoint-ORIG-GUID: pQWJuQNW0blN0Clk3Xvk7Hh-qAtsO90T
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_02,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=999
 clxscore=1015 spamscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070036
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gRGVjIDYsIDIwMjEsIGF0IDk6MTMgUE0sIEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlp
Lm5ha3J5aWtvQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIERlYyA2LCAyMDIxIGF0
IDg6MzIgUE0gU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZiLmNvbT4gd3JvdGU6DQo+PiANCj4+
IA0KPj4gDQo+Pj4gT24gRGVjIDYsIDIwMjEsIGF0IDY6MzcgUE0sIEFuZHJpaSBOYWtyeWlrbyA8
YW5kcmlpLm5ha3J5aWtvQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gT24gTW9uLCBEZWMg
NiwgMjAyMSBhdCAzOjA4IFBNIFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+IHdyb3RlOg0KPj4+
PiANCj4+Pj4gYnBmX2NyZWF0ZV9tYXAgaXMgZGVwcmVjYXRlZC4gUmVwbGFjZSBpdCB3aXRoIGJw
Zl9tYXBfY3JlYXRlLg0KPj4+PiANCj4+Pj4gRml4ZXM6IDk5MmM0MjI1NDE5YSAoImxpYmJwZjog
VW5pZnkgbG93LWxldmVsIG1hcCBjcmVhdGlvbiBBUElzIHcvIG5ldyBicGZfbWFwX2NyZWF0ZSgp
IikNCj4+PiANCj4+PiBUaGlzIGlzIG5vdCBhIGJ1ZyBmaXgsIGl0J3MgYW4gaW1wcm92ZW1lbnQu
IFNvIEkgZG9uJ3QgdGhpbmsgIkZpeGVzOiAiDQo+Pj4gaXMgd2FycmFudGVkIGhlcmUsIHRiaC4N
Cj4+IA0KPj4gSSBnb3QgY29tcGlsYXRpb24gZXJyb3JzIGJlZm9yZSB0aGlzIGNoYW5nZSwgbGlr
ZQ0KPj4gDQo+PiB1dGlsL2JwZl9jb3VudGVyLmM6IEluIGZ1bmN0aW9uIOKAmGJwZXJmX2xvY2tf
YXR0cl9tYXDigJk6DQo+PiB1dGlsL2JwZl9jb3VudGVyLmM6MzIzOjM6IGVycm9yOiDigJhicGZf
Y3JlYXRlX21hcOKAmSBpcyBkZXByZWNhdGVkOiBsaWJicGYgdjAuNys6IHVzZSBicGZfbWFwX2Ny
ZWF0ZSgpIGluc3RlYWQgWy1XZXJyb3I9ZGVwcmVjYXRlZC1kZWNsYXJhdGlvbnNdDQo+PiAgIG1h
cF9mZCA9IGJwZl9jcmVhdGVfbWFwKEJQRl9NQVBfVFlQRV9IQVNILA0KPj4gICBefn5+fn4NCj4+
IEluIGZpbGUgaW5jbHVkZWQgZnJvbSB1dGlsL2JwZl9jb3VudGVyLmg6NywNCj4+ICAgICAgICAg
ICAgICAgICBmcm9tIHV0aWwvYnBmX2NvdW50ZXIuYzoxNToNCj4+IC9kYXRhL3VzZXJzL3Nvbmds
aXVicmF2aW5nL2tlcm5lbC9saW51eC1naXQvdG9vbHMvbGliL2JwZi9icGYuaDo5MToxNjogbm90
ZTogZGVjbGFyZWQgaGVyZQ0KPj4gTElCQlBGX0FQSSBpbnQgYnBmX2NyZWF0ZV9tYXAoZW51bSBi
cGZfbWFwX3R5cGUgbWFwX3R5cGUsIGludCBrZXlfc2l6ZSwNCj4+ICAgICAgICAgICAgICAgIF5+
fn5+fn5+fn5+fn5+DQo+PiBjYzE6IGFsbCB3YXJuaW5ncyBiZWluZyB0cmVhdGVkIGFzIGVycm9y
cw0KPj4gbWFrZVs0XTogKioqIFsvZGF0YS91c2Vycy9zb25nbGl1YnJhdmluZy9rZXJuZWwvbGlu
dXgtZ2l0L3Rvb2xzL2J1aWxkL01ha2VmaWxlLmJ1aWxkOjk2OiB1dGlsL2JwZl9jb3VudGVyLm9d
IEVycm9yIDENCj4+IG1ha2VbNF06ICoqKiBXYWl0aW5nIGZvciB1bmZpbmlzaGVkIGpvYnMuLi4u
DQo+PiBtYWtlWzNdOiAqKiogWy9kYXRhL3VzZXJzL3NvbmdsaXVicmF2aW5nL2tlcm5lbC9saW51
eC1naXQvdG9vbHMvYnVpbGQvTWFrZWZpbGUuYnVpbGQ6MTM5OiB1dGlsXSBFcnJvciAyDQo+PiBt
YWtlWzJdOiAqKiogW01ha2VmaWxlLnBlcmY6NjY1OiBwZXJmLWluLm9dIEVycm9yIDINCj4+IG1h
a2VbMV06ICoqKiBbTWFrZWZpbGUucGVyZjoyNDA6IHN1Yi1tYWtlXSBFcnJvciAyDQo+PiBtYWtl
OiAqKiogW01ha2VmaWxlOjcwOiBhbGxdIEVycm9yIDINCj4+IA0KPiANCj4gSG1tLi4gaXMgdXRp
bC9icGZfY291bnRlci5oIGd1YXJkZWQgYmVoaW5kIHNvbWUgTWFrZWZpbGUgYXJndW1lbnRzPw0K
PiBJJ3ZlIHNlbnQgI3ByYWdtYSB0ZW1wb3Jhcnkgd29ya2Fyb3VuZHMganVzdCBhIGZldyBkYXlz
IGFnbyAoWzBdKSwgYnV0DQo+IHRoaXMgb25lIGRpZG4ndCBjb21lIHVwIGR1cmluZyB0aGUgYnVp
bGQuDQo+IA0KPiAgWzBdIGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9uZXRk
ZXZicGYvcGF0Y2gvMjAyMTEyMDMwMDQ2NDAuMjQ1NTcxNy0xLWFuZHJpaUBrZXJuZWwub3JnLw0K
DQpJIGd1ZXNzIHRoZSBkZWZhdWx0IGJ1aWxkIHRlc3QgZG9lc24ndCBlbmFibGUgQlVJTERfQlBG
X1NLRUw/IA0KDQo+IA0KPj4gRG8gd2UgcGxhbiB0byByZW1vdmUgYnBmX2NyZWF0ZV9tYXAgaW4g
dGhlIGZ1dHVyZT8gSWYgbm90LCB3ZSBjYW4gcHJvYmFibHkganVzdA0KPj4gYWRkICcjcHJhZ21h
IEdDQyBkaWFnbm9zdGljIGlnbm9yZWQgIi1XZGVwcmVjYXRlZC1kZWNsYXJhdGlvbnMiJyBjYW4g
Y2FsbCBpdCBkb25lPw0KPiANCj4gWWVzLCBpdCB3aWxsIGJlIHJlbW92ZWQgaW4gYSBmZXcgbGli
YnBmIHJlbGVhc2VzIHdoZW4gd2Ugc3dpdGNoIHRvIHRoZQ0KPiAxLjAgdmVyc2lvbi4gU28gc3Vw
cHJlc3NpbmcgYSB3YXJuaW5nIGlzIGEgdGVtcG9yYXJ5IHdvcmstYXJvdW5kLg0KPiANCj4+IA0K
Pj4+IA0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPg0KPj4+
PiAtLS0NCj4+Pj4gdG9vbHMvcGVyZi91dGlsL2JwZl9jb3VudGVyLmMgfCA0ICsrLS0NCj4+Pj4g
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+Pj4gDQo+
Pj4+IGRpZmYgLS1naXQgYS90b29scy9wZXJmL3V0aWwvYnBmX2NvdW50ZXIuYyBiL3Rvb2xzL3Bl
cmYvdXRpbC9icGZfY291bnRlci5jDQo+Pj4+IGluZGV4IGMxN2Q0YTQzY2UwNjUuLmVkMTUwYTli
M2EwYzAgMTAwNjQ0DQo+Pj4+IC0tLSBhL3Rvb2xzL3BlcmYvdXRpbC9icGZfY291bnRlci5jDQo+
Pj4+ICsrKyBiL3Rvb2xzL3BlcmYvdXRpbC9icGZfY291bnRlci5jDQo+Pj4+IEBAIC0zMjAsMTAg
KzMyMCwxMCBAQCBzdGF0aWMgaW50IGJwZXJmX2xvY2tfYXR0cl9tYXAoc3RydWN0IHRhcmdldCAq
dGFyZ2V0KQ0KPj4+PiAgICAgICB9DQo+Pj4+IA0KPj4+PiAgICAgICBpZiAoYWNjZXNzKHBhdGgs
IEZfT0spKSB7DQo+Pj4+IC0gICAgICAgICAgICAgICBtYXBfZmQgPSBicGZfY3JlYXRlX21hcChC
UEZfTUFQX1RZUEVfSEFTSCwNCj4+Pj4gKyAgICAgICAgICAgICAgIG1hcF9mZCA9IGJwZl9tYXBf
Y3JlYXRlKEJQRl9NQVBfVFlQRV9IQVNILCBOVUxMLA0KPj4+IA0KPj4+IEkgdGhpbmsgcGVyZiBp
cyB0cnlpbmcgdG8gYmUgbGlua2FibGUgd2l0aCBsaWJicGYgYXMgYSBzaGFyZWQgbGlicmFyeSwN
Cj4+PiBzbyBvbiBzb21lIG9sZGVyIHZlcnNpb25zIG9mIGxpYmJwZiBicGZfbWFwX2NyZWF0ZSgp
IHdvbid0IGJlICh5ZXQpDQo+Pj4gYXZhaWxhYmxlLiBTbyB0byBtYWtlIHRoaXMgd29yaywgSSB0
aGluayB5b3UnbGwgbmVlZCB0byBkZWZpbmUgeW91cg0KPj4+IG93biB3ZWFrIGJwZl9tYXBfY3Jl
YXRlIGZ1bmN0aW9uIHRoYXQgd2lsbCB1c2UgYnBmX2NyZWF0ZV9tYXAoKS4NCj4+IA0KPj4gSG1t
Li4uIEkgZGlkbid0IGtub3cgdGhlIHBsYW4gdG8gbGluayBsaWJicGYgYXMgc2hhcmVkIGxpYnJh
cnkuIEluIHRoaXMgY2FzZSwNCj4+IG1heWJlIHRoZSAjcHJhZ21hIHNvbHV0aW9uIGlzIHByZWZl
cnJlZD8NCj4gDQo+IFNlZSAicGVyZiB0b29sczogQWRkIG1vcmUgd2VhayBsaWJicGYgZnVuY3Rp
b25zIiBzZW50IGJ5IEppcmkgbm90IHNvDQo+IGxvbmcgYWdvIGFib3V0IHdoYXQgdGhleSBkaWQg
d2l0aCBzb21lIG90aGVyIHVzZWQgQVBJcyB0aGF0IGFyZSBub3cNCj4gbWFya2VkIGRlcHJlY2F0
ZWQuDQoNCkRvIHlvdSBtZWFuIHNvbWV0aGluZyBsaWtlIHRoaXM/DQoNCmludCBfX3dlYWsNCmJw
Zl9tYXBfY3JlYXRlKGVudW0gYnBmX21hcF90eXBlIG1hcF90eXBlLA0KICAgICAgICAgICAgICAg
Y29uc3QgY2hhciAqbWFwX25hbWUgX19tYXliZV91bnVzZWQsDQogICAgICAgICAgICAgICBfX3Uz
MiBrZXlfc2l6ZSwNCiAgICAgICAgICAgICAgIF9fdTMyIHZhbHVlX3NpemUsDQogICAgICAgICAg
ICAgICBfX3UzMiBtYXhfZW50cmllcywNCiAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBicGZf
bWFwX2NyZWF0ZV9vcHRzICpvcHRzIF9fbWF5YmVfdW51c2VkKQ0Kew0KI3ByYWdtYSBHQ0MgZGlh
Z25vc3RpYyBwdXNoDQojcHJhZ21hIEdDQyBkaWFnbm9zdGljIGlnbm9yZWQgIi1XZGVwcmVjYXRl
ZC1kZWNsYXJhdGlvbnMiDQogICAgICAgIHJldHVybiBicGZfY3JlYXRlX21hcChtYXBfdHlwZSwg
a2V5X3NpemUsIHZhbHVlX3NpemUsIG1heF9lbnRyaWVzLCAwKTsNCiNwcmFnbWEgR0NDIGRpYWdu
b3N0aWMgcG9wDQp9DQoNCkkgZ3Vlc3MgdGhpcyB3b24ndCB3b3JrIHdoZW4gYnBmX2NyZWF0ZV9t
YXAoKSBpcyBldmVudHVhbGx5IHJlbW92ZWQsIGFzIA0KX193ZWFrIGZ1bmN0aW9uIGFyZSBzdGls
bCBjb21waWxlZCwgbm8/DQoNClRoYW5rcywNClNvbmc=
