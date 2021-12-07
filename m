Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D653E46C807
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 00:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238110AbhLGXOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 18:14:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27908 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238125AbhLGXOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:14:39 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JECth021497;
        Tue, 7 Dec 2021 15:11:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IWKic/9bS+gTqaautHZPb7r6EeWvNQUI46zstZZxDeI=;
 b=BLqv70LfRw17zr2HC4qIzi190E+jaC9httvoIFcfESztiuu1co/P5piOrZ0ekrT1LWyb
 Zrm53LujtFfko3We7444WVKRBIIxqUtPNnxWEriTxvDvdzMFZy2OmfQbhYhGiyOPUKt/
 Py091gYMg6aWZ17SA0ribev3RLDkbYvKZgA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ct4p85b6f-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Dec 2021 15:11:08 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 15:10:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZxtdM0pTngNhsUUjLSfvTm5FuaaOgcwbgBnaC9cQ1qZLI54dAaSY3FlNqRh7lYXYamrSdp7oS3Z81r6l1oi513VziLP7jGGzbNvJK5+1EcwwrfECHgBsjnLBb/mog7spbXb7C8rXlPtTd260Rw8WdZeiC/pz/zPSonkX6uLpe+8vsKQjLmkQZofZzU2bGxLNCdhnEz7FdDtkmtM0EAGc/wANEmdRZeMWg4zc/4jgKN2E0CLNXpSackmmnvfOQyE+VnrmNy+9Y+pu/1Vi7W0v8ESkKVtJgrZigM3Oe4aH/3p5pR4lZ7juori6XbyyDk30sqqfqZYrU7iZLA7XRNkBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWKic/9bS+gTqaautHZPb7r6EeWvNQUI46zstZZxDeI=;
 b=cuZ/cPvG0Txfn4F0OfrrPntikI9gD5iBm6tRZL/FijijIyhtrTZCglHEAtslYCh4dbdxpl7gA+Jlr26Nibb0CvumBQNUzD/WRV5tvqbTM97jX0FP5aaVPaZUXjWvS/t5m5sfVJb6vInaL9oM+SY5q+z3EdFKHdoqpSMSe7b8ze53px1bMbGNJeQs4Y6WuXDVTdWVB680k5oxSuGgA1SfEH/3UhDNGM68Xs9pGTor/uyMiyVr99C2mo9U5AN7nQIZggnCOpAaYW7v1zAqUkuoVvzjkYkgsuVRwbutQuRDrLA5VCopqpb+6XxWpOk9PGcpenKde1jjII6N3GVSnw+XaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5283.namprd15.prod.outlook.com (2603:10b6:806:23b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 23:10:36 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%4]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 23:10:36 +0000
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
Thread-Index: AQHX6vYzhWKFIoT0wkePQg16MtlXfawmUPOAgAAf5QCAAAuIAIAAFYSAgAEVKwCAAAJMgA==
Date:   Tue, 7 Dec 2021 23:10:36 +0000
Message-ID: <1D69F857-BCD9-40C1-87CA-90C55B42984D@fb.com>
References: <20211206230811.4131230-1-song@kernel.org>
 <CAEf4BzbaBcySm3bVumBTrkHMmVDWEVxckdVKvUk=4j9HhSsmBA@mail.gmail.com>
 <3221CDA7-F2EF-404A-9289-14F9DF6D01DA@fb.com>
 <CAEf4BzbN17eviD18-_C2UN+P5gMm4vFXVrdLd9UHx0ev+gJsjw@mail.gmail.com>
 <08EB4596-7788-4570-B0B0-DE3B710BBDD8@fb.com>
 <CAEf4BzaCioWRGktgk1TvdyaB-zF_6Hyj+67j7DzPzTLGqkigYg@mail.gmail.com>
In-Reply-To: <CAEf4BzaCioWRGktgk1TvdyaB-zF_6Hyj+67j7DzPzTLGqkigYg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45abb8cc-7dd9-4318-274d-08d9b9d6c73b
x-ms-traffictypediagnostic: SA1PR15MB5283:EE_
x-microsoft-antispam-prvs: <SA1PR15MB52832862FE3850EE2B020650B36E9@SA1PR15MB5283.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7r3SjVJFYqKOZ1FJtZzLKsvQmnDLY2olGjUYENlcUoyRJg13sDQi61hA1iQEE9+em//Q9jCLhuV7aTN3nR6d/9kpQOXXmXcg236pzPpmQtRLFDt+a4i3e4GcASn/1hdrGNeIcCMXgFoEqf6hNgOMewQOZP5xIMO0zb04lbqOt+thwlo2X+VBG404/jO93Xqp6H2knuGSyAbvZJ4Dy8g7PnwqA4d8vrek5/noMABh7bOrYaOHFj0IOK+1jtywV+OlqjMH2u7L78syPsIKovcsLpbDPgMVrgJo9JhbqOQeQqQdsuXlAq0bMTx0SKXKZGjoTmXE0ZqA7IDLpP3n4/Wru9bI31t7F//fvIMb3Z7z1pntuOPfBxaRIjqOjI/emdyBx741RWD8r2Q4ELxTWj/7LF7CBwEwhhdfu0dIJ1IIOS4KONxEVl7p7l9s34BG6WZva9WnhtVcgZkqeUCafCvQJcnghvCBKgXimITK/ZbDvH2VvDFFQxaVyEuv7FU1P4JDz/muqj8UV14BzRJmoMObQggfKDr3XLST+0yjfxHm6QN6uPxGsvirJ99ic5nnphqNm0K693sG3DvQzf5+87HxjiFD4tQM8A98x8mh97RO1uEezoLa5elrSjckOMPKBnbV5lTKGwPNByDir2K/syOYnw5U07atVX0b6DjmncYQqZoPujs5Y9crccdIU1w6+Y8UcHHW0gY6BVbmr2N7T0MZE/ZXXZypUlt+XWntB6Yk5CcRZoV8OHZSwpTCOi+T+CUeLWyBNkBRaH/ya25TANKeZTBOILK30M7evlXrq3r+oX0dIcjhd7fRM+gGQAgjP/lnB5X2wYLBRt7KFgO/d07SVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(6486002)(38070700005)(5660300002)(83380400001)(6916009)(316002)(508600001)(66446008)(54906003)(966005)(6506007)(4326008)(122000001)(6512007)(33656002)(66556008)(2906002)(36756003)(186003)(71200400001)(86362001)(8676002)(8936002)(91956017)(66946007)(76116006)(66476007)(2616005)(53546011)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YSs5eU5JY2VDcjFJR25PRzZuVEFaMTVQOER4OWY1andPNFpUa2tWUHVXN3V5?=
 =?utf-8?B?SWVnS2dHd2FhT1lCUEdKL3l2T3FNQ3VkV2YxYldKTGVSbEVlRWFxNUFUSUFR?=
 =?utf-8?B?WEdXZlFxOElPaFFCbEdsclhLajlsS2FaZ29EMmhKdkJ0MTBGT2JBS01ZL0di?=
 =?utf-8?B?YTJXWjQ5RUZRTkRNUjRiTWplSm0xT3R3ckRNUGVjbHY3ZG15M1MwTGZTL0V3?=
 =?utf-8?B?cWJvRWc3WjV5UFFJMHY1ZjJ2VEdoTHppdGZCK0lhQmdkYU5pNjlWbC9BTnNN?=
 =?utf-8?B?dGVwWkVLajNROGxlamRSaTBLSHYrMDJMNzBkd1BWVWVsRDQ4bmdnYm00dW9s?=
 =?utf-8?B?dVBFdmxHWXcyVTVHQVFiVUc3a0ZGQjF4ejJRU1VlRFQzVm5WOGRnVHRWNVNo?=
 =?utf-8?B?dkZDQjB6RnJHT3pFak1BZGlVNTUvUm9PTVFpNHdJSUE4aUo5Ym0yTis2YURQ?=
 =?utf-8?B?bHFUSmI2ays3cTRwZEZMS0oxcW51SmJ4TkRJNWN6QTZWRDROWmp3N2lmajVl?=
 =?utf-8?B?MEllZVNUTHhFekNXMzNqQkdKeXQ2aUx2V3QvT3Y1S0RqSFc0cHExSHFlSit0?=
 =?utf-8?B?SmV0ZTg1N05VdkxEV0k2Ukk4S2pqMWtzM1o1NUpYcTB0T2tIbUlFWS9UV1BF?=
 =?utf-8?B?ekF1ZzhMWEk4ODM5c084Ym9pdTNoa2Nyd2ZRMytCRjUwRm1jdDJEWDFLZ0tC?=
 =?utf-8?B?V2xITzJuZUJTS3NjTk5RVUdQa0ppVDBrUXVMTzduTE91MTRCUVU4VHJnMDY5?=
 =?utf-8?B?YldqSEl3aXdLOXF6Q2hCWmF0dDJ5dDEvQVY3ZVF4aFhiN2RJbDMwZFhmZW1Z?=
 =?utf-8?B?eml2eEVvZVBySUFMQnFNODRhWSt4OXBDYjN0eVB2cThLZjR4STJpYnZ0ekpx?=
 =?utf-8?B?MndtMWY3WjhqcWFEM3R5K01HNWZ3STVscW02Ym0rVkpCUkQ2bkhueEZFVjZF?=
 =?utf-8?B?S3NxRXdqU1NEUzQwOFE2KzhVaVBGcW5LdGIrYk9aMVh4cDJSZnR0ZXhIbUxV?=
 =?utf-8?B?amkzcDJmcnNZbzc0U05yWURhQWFGMk85d0oxYWJ5bW1meHNPRk1iMDQ4UStZ?=
 =?utf-8?B?UzlNcmpZcFROWUUyRXFFRDY4bDFHeEo2WjFsekdkYXhBY1ErQlYrTmlBRTJM?=
 =?utf-8?B?QldoOEJlUHlrZ1VkSzl1QWxQRnMzSUFPY01PVmRvNE9TKzJYdnVzWWIxdE8v?=
 =?utf-8?B?aW9mMEJqalhSOVNHK3NId1hkRWs2Sk5aa00vR1ArUzMzUDBGVlJoVnRLMFJI?=
 =?utf-8?B?Z1VEN2lpVzR1cFpVQ3NKYTNycktBZ3RuTDAvdWdlNmEyM0lNbDlGSXdha2Js?=
 =?utf-8?B?TzJ4aDFETjhCVmd0RWhRSDNIZTQ2ZGZrQ2YxS1ljYysxdFpRRUd1Vy9hVW1s?=
 =?utf-8?B?TStrRFBoTUJxSkVWV1NTN0xnakgxWmtudkNQN0docHVFbmJCTTdtbENkV0pU?=
 =?utf-8?B?OXA1ellQOE1NemczcTR1WC81UTJjd20wYkNqSG5wWmx2QWdnUndMalZoZnVn?=
 =?utf-8?B?M3M0dFBjWDdpOGtKa3k4Zi9OcjZKWnhNcnB5ZDh4L2NuT1NmQklQSTZ4K3FS?=
 =?utf-8?B?b2o2QUszUGxTa1h2K0o0am5WYTVSU2lmZm1WWndEMjU5RENhMFdtY0RybDlT?=
 =?utf-8?B?MzNTTHhsenB4SmR0VklIL2pnR0Rwdy9CQi84VnArRzJpZ1I4Si9rQStiVXA0?=
 =?utf-8?B?blNvZEZWQ3dsa0NMNzFGSHM0YjZTOFpzTjJMWnlxUytITU54aHFXR2tvRkxV?=
 =?utf-8?B?RzZhUDJHc0hyODRtODRpcEMzd3l0L3czZXplSHJkT3VQMWZ6TkI3V2tCQkto?=
 =?utf-8?B?S0c2Q3FTSEpYZ1NwdG9ZUURaamZSM0lieUN2YWxGMElHZGdBSnRTNWhFSE0r?=
 =?utf-8?B?YXc2NVhxRnpMZVRrQTJHWVQ5bzkrZlpBQkFvZjdBSWlOY3pMNkxCRGhZcWQz?=
 =?utf-8?B?bVVxRHNYWlJEWkxoeFU1L0l6bHJqZCs4TlNHVndpb1I5YVdLUEM3c29TQ3lO?=
 =?utf-8?B?QVhKSmFTc2tyQnRpM3V4dzJCS1RkNmZNVllTVGRqa1VZT0RrclljRXhVMmlN?=
 =?utf-8?B?RUlkVHNaV3FBbXhOV3Y0U2t5VmNHM0pVUkhUenNHM25BNXdETjNYSS9mcGpZ?=
 =?utf-8?B?S1d0WSt2U1p3ZnZFN1B0VnlJWjBDT2V5cGJwam4zeDQwbDMyajIrR2Z5UExG?=
 =?utf-8?B?MGt5S3doaWs0dnN0ZjBuZlExajVETUVvZ3F3ajl2dHNhUVNOUUMzVUZBeFZV?=
 =?utf-8?B?RGNZVkMxYXZGME54SXV2Smt4YjlnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F9F40E62E1A464D86194A78382CD8E9@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45abb8cc-7dd9-4318-274d-08d9b9d6c73b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 23:10:36.5173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S079kBQ//nD6zwgzT0QpBDMUwr9k5y4FflRXAbaOe9nC/lDTkSTw6HU1rI/JEYWUpH5cS0FWPdoCyddJsp30DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5283
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: uCvauWSwJTmt9ThPWDSo2oNwbOlwE_rM
X-Proofpoint-GUID: uCvauWSwJTmt9ThPWDSo2oNwbOlwE_rM
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_09,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070141
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gRGVjIDcsIDIwMjEsIGF0IDM6MDIgUE0sIEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlp
Lm5ha3J5aWtvQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIERlYyA2LCAyMDIxIGF0
IDEwOjMwIFBNIFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+IHdyb3RlOg0KPj4gDQo+
PiANCj4+IA0KPj4+IE9uIERlYyA2LCAyMDIxLCBhdCA5OjEzIFBNLCBBbmRyaWkgTmFrcnlpa28g
PGFuZHJpaS5uYWtyeWlrb0BnbWFpbC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIE1vbiwgRGVj
IDYsIDIwMjEgYXQgODozMiBQTSBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPiB3cm90
ZToNCj4+Pj4gDQo+Pj4+IA0KPj4+PiANCj4+Pj4+IE9uIERlYyA2LCAyMDIxLCBhdCA2OjM3IFBN
LCBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaS5uYWtyeWlrb0BnbWFpbC5jb20+IHdyb3RlOg0KPj4+
Pj4gDQo+Pj4+PiBPbiBNb24sIERlYyA2LCAyMDIxIGF0IDM6MDggUE0gU29uZyBMaXUgPHNvbmdA
a2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4+Pj4gDQo+Pj4+Pj4gYnBmX2NyZWF0ZV9tYXAgaXMgZGVw
cmVjYXRlZC4gUmVwbGFjZSBpdCB3aXRoIGJwZl9tYXBfY3JlYXRlLg0KPj4+Pj4+IA0KPj4+Pj4+
IEZpeGVzOiA5OTJjNDIyNTQxOWEgKCJsaWJicGY6IFVuaWZ5IGxvdy1sZXZlbCBtYXAgY3JlYXRp
b24gQVBJcyB3LyBuZXcgYnBmX21hcF9jcmVhdGUoKSIpDQo+Pj4+PiANCj4+Pj4+IFRoaXMgaXMg
bm90IGEgYnVnIGZpeCwgaXQncyBhbiBpbXByb3ZlbWVudC4gU28gSSBkb24ndCB0aGluayAiRml4
ZXM6ICINCj4+Pj4+IGlzIHdhcnJhbnRlZCBoZXJlLCB0YmguDQo+Pj4+IA0KPj4+PiBJIGdvdCBj
b21waWxhdGlvbiBlcnJvcnMgYmVmb3JlIHRoaXMgY2hhbmdlLCBsaWtlDQo+Pj4+IA0KPj4+PiB1
dGlsL2JwZl9jb3VudGVyLmM6IEluIGZ1bmN0aW9uIOKAmGJwZXJmX2xvY2tfYXR0cl9tYXDigJk6
DQo+Pj4+IHV0aWwvYnBmX2NvdW50ZXIuYzozMjM6MzogZXJyb3I6IOKAmGJwZl9jcmVhdGVfbWFw
4oCZIGlzIGRlcHJlY2F0ZWQ6IGxpYmJwZiB2MC43KzogdXNlIGJwZl9tYXBfY3JlYXRlKCkgaW5z
dGVhZCBbLVdlcnJvcj1kZXByZWNhdGVkLWRlY2xhcmF0aW9uc10NCj4+Pj4gIG1hcF9mZCA9IGJw
Zl9jcmVhdGVfbWFwKEJQRl9NQVBfVFlQRV9IQVNILA0KPj4+PiAgXn5+fn5+DQo+Pj4+IEluIGZp
bGUgaW5jbHVkZWQgZnJvbSB1dGlsL2JwZl9jb3VudGVyLmg6NywNCj4+Pj4gICAgICAgICAgICAg
ICAgZnJvbSB1dGlsL2JwZl9jb3VudGVyLmM6MTU6DQo+Pj4+IC9kYXRhL3VzZXJzL3NvbmdsaXVi
cmF2aW5nL2tlcm5lbC9saW51eC1naXQvdG9vbHMvbGliL2JwZi9icGYuaDo5MToxNjogbm90ZTog
ZGVjbGFyZWQgaGVyZQ0KPj4+PiBMSUJCUEZfQVBJIGludCBicGZfY3JlYXRlX21hcChlbnVtIGJw
Zl9tYXBfdHlwZSBtYXBfdHlwZSwgaW50IGtleV9zaXplLA0KPj4+PiAgICAgICAgICAgICAgIF5+
fn5+fn5+fn5+fn5+DQo+Pj4+IGNjMTogYWxsIHdhcm5pbmdzIGJlaW5nIHRyZWF0ZWQgYXMgZXJy
b3JzDQo+Pj4+IG1ha2VbNF06ICoqKiBbL2RhdGEvdXNlcnMvc29uZ2xpdWJyYXZpbmcva2VybmVs
L2xpbnV4LWdpdC90b29scy9idWlsZC9NYWtlZmlsZS5idWlsZDo5NjogdXRpbC9icGZfY291bnRl
ci5vXSBFcnJvciAxDQo+Pj4+IG1ha2VbNF06ICoqKiBXYWl0aW5nIGZvciB1bmZpbmlzaGVkIGpv
YnMuLi4uDQo+Pj4+IG1ha2VbM106ICoqKiBbL2RhdGEvdXNlcnMvc29uZ2xpdWJyYXZpbmcva2Vy
bmVsL2xpbnV4LWdpdC90b29scy9idWlsZC9NYWtlZmlsZS5idWlsZDoxMzk6IHV0aWxdIEVycm9y
IDINCj4+Pj4gbWFrZVsyXTogKioqIFtNYWtlZmlsZS5wZXJmOjY2NTogcGVyZi1pbi5vXSBFcnJv
ciAyDQo+Pj4+IG1ha2VbMV06ICoqKiBbTWFrZWZpbGUucGVyZjoyNDA6IHN1Yi1tYWtlXSBFcnJv
ciAyDQo+Pj4+IG1ha2U6ICoqKiBbTWFrZWZpbGU6NzA6IGFsbF0gRXJyb3IgMg0KPj4+PiANCj4+
PiANCj4+PiBIbW0uLiBpcyB1dGlsL2JwZl9jb3VudGVyLmggZ3VhcmRlZCBiZWhpbmQgc29tZSBN
YWtlZmlsZSBhcmd1bWVudHM/DQo+Pj4gSSd2ZSBzZW50ICNwcmFnbWEgdGVtcG9yYXJ5IHdvcmth
cm91bmRzIGp1c3QgYSBmZXcgZGF5cyBhZ28gKFswXSksIGJ1dA0KPj4+IHRoaXMgb25lIGRpZG4n
dCBjb21lIHVwIGR1cmluZyB0aGUgYnVpbGQuDQo+Pj4gDQo+Pj4gWzBdIGh0dHBzOi8vcGF0Y2h3
b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9uZXRkZXZicGYvcGF0Y2gvMjAyMTEyMDMwMDQ2NDAuMjQ1
NTcxNy0xLWFuZHJpaUBrZXJuZWwub3JnLw0KPj4gDQo+PiBJIGd1ZXNzIHRoZSBkZWZhdWx0IGJ1
aWxkIHRlc3QgZG9lc24ndCBlbmFibGUgQlVJTERfQlBGX1NLRUw/DQo+IA0KPiBJIHNlZSwgcmln
aHQsIEkgdGhpbmsgSSBhbHJlYWR5IGFza2VkIGFib3V0IHRoYXQgYmVmb3JlIDooIElzIGl0DQo+
IHBvc3NpYmxlIHRvIHNldCBNYWtlZmlsZSBzdWNoIHRoYXQgaXQgd2lsbCBkbyBCVUlMRF9CUEZf
U0tFTD0xIGlmDQo+IENsYW5nIHZlcnNpb24gaXMgcmVjZW50IGVub3VnaCBhbmQgb3RoZXIgY29u
ZGl0aW9ucyBhcmUgc2F0aXNmaWVkDQo+ICh1bmxlc3Mgb3ZlcnJpZGRlbiBvciBzb21ldGhpbmcp
Pw0KDQpBcm5hbGRvIGlzIHdvcmtpbmcgb24gdGhpcy4gSSBndWVzcyB3ZSBjYW4gZmxpcCB0aGUg
ZGVmYXVsdCBzb29uLiANCg0KPiANCj4+IA0KPj4+IA0KPj4+PiBEbyB3ZSBwbGFuIHRvIHJlbW92
ZSBicGZfY3JlYXRlX21hcCBpbiB0aGUgZnV0dXJlPyBJZiBub3QsIHdlIGNhbiBwcm9iYWJseSBq
dXN0DQo+Pj4+IGFkZCAnI3ByYWdtYSBHQ0MgZGlhZ25vc3RpYyBpZ25vcmVkICItV2RlcHJlY2F0
ZWQtZGVjbGFyYXRpb25zIicgY2FuIGNhbGwgaXQgZG9uZT8NCj4+PiANCj4+PiBZZXMsIGl0IHdp
bGwgYmUgcmVtb3ZlZCBpbiBhIGZldyBsaWJicGYgcmVsZWFzZXMgd2hlbiB3ZSBzd2l0Y2ggdG8g
dGhlDQo+Pj4gMS4wIHZlcnNpb24uIFNvIHN1cHByZXNzaW5nIGEgd2FybmluZyBpcyBhIHRlbXBv
cmFyeSB3b3JrLWFyb3VuZC4NCj4+PiANCj4+Pj4gDQo+Pj4+PiANCj4+Pj4+PiBTaWduZWQtb2Zm
LWJ5OiBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPg0KPj4+Pj4+IC0tLQ0KPj4+Pj4+IHRvb2xz
L3BlcmYvdXRpbC9icGZfY291bnRlci5jIHwgNCArKy0tDQo+Pj4+Pj4gMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+Pj4+PiANCj4+Pj4+PiBkaWZmIC0t
Z2l0IGEvdG9vbHMvcGVyZi91dGlsL2JwZl9jb3VudGVyLmMgYi90b29scy9wZXJmL3V0aWwvYnBm
X2NvdW50ZXIuYw0KPj4+Pj4+IGluZGV4IGMxN2Q0YTQzY2UwNjUuLmVkMTUwYTliM2EwYzAgMTAw
NjQ0DQo+Pj4+Pj4gLS0tIGEvdG9vbHMvcGVyZi91dGlsL2JwZl9jb3VudGVyLmMNCj4+Pj4+PiAr
KysgYi90b29scy9wZXJmL3V0aWwvYnBmX2NvdW50ZXIuYw0KPj4+Pj4+IEBAIC0zMjAsMTAgKzMy
MCwxMCBAQCBzdGF0aWMgaW50IGJwZXJmX2xvY2tfYXR0cl9tYXAoc3RydWN0IHRhcmdldCAqdGFy
Z2V0KQ0KPj4+Pj4+ICAgICAgfQ0KPj4+Pj4+IA0KPj4+Pj4+ICAgICAgaWYgKGFjY2VzcyhwYXRo
LCBGX09LKSkgew0KPj4+Pj4+IC0gICAgICAgICAgICAgICBtYXBfZmQgPSBicGZfY3JlYXRlX21h
cChCUEZfTUFQX1RZUEVfSEFTSCwNCj4+Pj4+PiArICAgICAgICAgICAgICAgbWFwX2ZkID0gYnBm
X21hcF9jcmVhdGUoQlBGX01BUF9UWVBFX0hBU0gsIE5VTEwsDQo+Pj4+PiANCj4+Pj4+IEkgdGhp
bmsgcGVyZiBpcyB0cnlpbmcgdG8gYmUgbGlua2FibGUgd2l0aCBsaWJicGYgYXMgYSBzaGFyZWQg
bGlicmFyeSwNCj4+Pj4+IHNvIG9uIHNvbWUgb2xkZXIgdmVyc2lvbnMgb2YgbGliYnBmIGJwZl9t
YXBfY3JlYXRlKCkgd29uJ3QgYmUgKHlldCkNCj4+Pj4+IGF2YWlsYWJsZS4gU28gdG8gbWFrZSB0
aGlzIHdvcmssIEkgdGhpbmsgeW91J2xsIG5lZWQgdG8gZGVmaW5lIHlvdXINCj4+Pj4+IG93biB3
ZWFrIGJwZl9tYXBfY3JlYXRlIGZ1bmN0aW9uIHRoYXQgd2lsbCB1c2UgYnBmX2NyZWF0ZV9tYXAo
KS4NCj4+Pj4gDQo+Pj4+IEhtbS4uLiBJIGRpZG4ndCBrbm93IHRoZSBwbGFuIHRvIGxpbmsgbGli
YnBmIGFzIHNoYXJlZCBsaWJyYXJ5LiBJbiB0aGlzIGNhc2UsDQo+Pj4+IG1heWJlIHRoZSAjcHJh
Z21hIHNvbHV0aW9uIGlzIHByZWZlcnJlZD8NCj4+PiANCj4+PiBTZWUgInBlcmYgdG9vbHM6IEFk
ZCBtb3JlIHdlYWsgbGliYnBmIGZ1bmN0aW9ucyIgc2VudCBieSBKaXJpIG5vdCBzbw0KPj4+IGxv
bmcgYWdvIGFib3V0IHdoYXQgdGhleSBkaWQgd2l0aCBzb21lIG90aGVyIHVzZWQgQVBJcyB0aGF0
IGFyZSBub3cNCj4+PiBtYXJrZWQgZGVwcmVjYXRlZC4NCj4+IA0KPj4gRG8geW91IG1lYW4gc29t
ZXRoaW5nIGxpa2UgdGhpcz8NCj4+IA0KPj4gaW50IF9fd2Vhaw0KPj4gYnBmX21hcF9jcmVhdGUo
ZW51bSBicGZfbWFwX3R5cGUgbWFwX3R5cGUsDQo+PiAgICAgICAgICAgICAgIGNvbnN0IGNoYXIg
Km1hcF9uYW1lIF9fbWF5YmVfdW51c2VkLA0KPj4gICAgICAgICAgICAgICBfX3UzMiBrZXlfc2l6
ZSwNCj4+ICAgICAgICAgICAgICAgX191MzIgdmFsdWVfc2l6ZSwNCj4+ICAgICAgICAgICAgICAg
X191MzIgbWF4X2VudHJpZXMsDQo+PiAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBicGZfbWFw
X2NyZWF0ZV9vcHRzICpvcHRzIF9fbWF5YmVfdW51c2VkKQ0KPj4gew0KPj4gI3ByYWdtYSBHQ0Mg
ZGlhZ25vc3RpYyBwdXNoDQo+PiAjcHJhZ21hIEdDQyBkaWFnbm9zdGljIGlnbm9yZWQgIi1XZGVw
cmVjYXRlZC1kZWNsYXJhdGlvbnMiDQo+PiAgICAgICAgcmV0dXJuIGJwZl9jcmVhdGVfbWFwKG1h
cF90eXBlLCBrZXlfc2l6ZSwgdmFsdWVfc2l6ZSwgbWF4X2VudHJpZXMsIDApOw0KPj4gI3ByYWdt
YSBHQ0MgZGlhZ25vc3RpYyBwb3ANCj4+IH0NCj4+IA0KPj4gSSBndWVzcyB0aGlzIHdvbid0IHdv
cmsgd2hlbiBicGZfY3JlYXRlX21hcCgpIGlzIGV2ZW50dWFsbHkgcmVtb3ZlZCwgYXMNCj4+IF9f
d2VhayBmdW5jdGlvbiBhcmUgc3RpbGwgY29tcGlsZWQsIG5vPw0KPiANCj4gWWVzIGFuZCB5ZXMu
IEknbSBub3Qgc3VyZSB3aGF0IHdvdWxkIGJlIHBlcmYncyBwbGFuIHcuci50LiBsaWJicGYgMS4w
LA0KPiB3ZSdsbCBuZWVkIHRvIHdvcmsgdG9nZXRoZXIgdG8gZmlndXJlIHRoaXMgb3V0LiBBdCBz
b21lIHBvaW50IHBlcmYNCj4gd2lsbCBuZWVkIHRvIHNheSB0aGF0IHRoZSBtaW5pbXVtIHZlcnNp
b24gb2Ygc3VwcG9ydGVkIGxpYmJwZiBpcyB2MC42DQo+IG9yIHNvbWV0aGluZyBhbmQganVzdCBh
c3N1bWUgYWxsIHRob3NlIG5ld2VyIEFQSXMgYXJlIHRoZXJlIChubyBuZWVkDQo+IHRvIGJ1bXAg
aXQgYWxsIHRoZSB3YXkgdG8gbGliYnBmIDEuMCwgYnR3KS4NCg0KT0suIEkgd2lsbCBzZW5kIHRo
aXMgdmVyc2lvbi4gQW5kIHdlIGNhbiBkZWNpZGUgdGhlIG5leHQgc3RlcCB3aGVuIHdlDQpyZW1v
dmUgYnBmX2NyZWF0ZV9tYXAoKS4gDQoNClRoYW5rcywNClNvbmcNCg0K
