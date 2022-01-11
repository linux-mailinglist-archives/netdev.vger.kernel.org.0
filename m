Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A78348B432
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344525AbiAKRnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:43:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30912 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344029AbiAKRnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:43:51 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20BHRMHB013868;
        Tue, 11 Jan 2022 09:43:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=xFbetSnZ+AefgGbTTtyYUT9+M5i9iJtEiABgOgQ+K+4=;
 b=rsGhzvPKiZuuApAf+IK2gohWTL7hwkJIIABHdjOb3ZQFfBtycnYkFjvPxwMSs5GxbkUF
 Mln8amEbelf+iFbQUMWHhJESo/48Yk8C8JBryIw93D5TEme10nQEa+ug6OBi9B8xgp4e
 vblKl9g9qfi7x9SVDQCylEftLg0AdNRB+IA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3dh6cvug65-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 11 Jan 2022 09:43:50 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 09:43:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPuX5y78EiqSzX7xfrhTTNHp4q2CRv9RcxP1+00+s53gS5pgoEtDeEgxwoFARFikllubEc9+i6lZ+9ySGojU3ek2QgzkHfjre+NTzhDWpXo3mbZQ4zOXXfdv/jbCRs+MuGhHgu+V0PBRFEEqggVwFSvtORLW6EMc9aQrLfI2WxhN2U47ONBtBC2+I6hJ3Ov+vVf7bICPXiclap+eke0ZpubGO96xCX87D1ge8zPdiIlh0ypm5Mio+qUp7XwQwXIp9q1L3Z5Uq5EQiaGCiYUpNoTLyKbWS6OgFU0FrSNr23adM4L/3JAvRxOCFwZl4yqIeHlCBu+uQr0CP8NWqdOAlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFbetSnZ+AefgGbTTtyYUT9+M5i9iJtEiABgOgQ+K+4=;
 b=hgM74RLkV2xsB/eRzcPFpGf3CfSVovBLkCigA+YG9+0Vl/93oFEwI5ya5285FVrmVL/sx/VlcQp1s5+y7CE66/aQ9Iz2b7ZzvwE0x89kzcCGr8FJ3FtqaYfX7LXxS7IG1PKEnV5S+nZxpJlJ1mTKjlsNZrrdGmahaoaYXxmP/ahf3DHV3Cay1BnYbjD7uwVzJOznxHu1d/qEa8uh+uA/HdQcZzglwwIGtjyleIKNT5/YinLhm3RasvGwsEBId46Ai2U0owY/x5qRMrfd63jQri9bIUpZ4toREfk+8IH4qk9IsZzU7R+e0UQDbZAZqPy+4q9dtP5Ge2CYIjHqnxgxIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5096.namprd15.prod.outlook.com (2603:10b6:806:1df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 17:43:47 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%4]) with mapi id 15.20.4867.011; Tue, 11 Jan 2022
 17:43:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 bpf-next 5/7] x86/alternative: introduce text_poke_jit
Thread-Topic: [PATCH v3 bpf-next 5/7] x86/alternative: introduce text_poke_jit
Thread-Index: AQHYAqTPOIWcijzdr0uhWm4W1NDGq6xdxCCAgABcKIA=
Date:   Tue, 11 Jan 2022 17:43:47 +0000
Message-ID: <48AD9DA0-5E09-4EBD-AFF0-DA63ADA5A247@fb.com>
References: <20220106022533.2950016-1-song@kernel.org>
 <20220106022533.2950016-6-song@kernel.org>
 <Yd10heJVckednY07@hirez.programming.kicks-ass.net>
In-Reply-To: <Yd10heJVckednY07@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a85994d-85dc-4d12-b1b5-08d9d529ebd0
x-ms-traffictypediagnostic: SA1PR15MB5096:EE_
x-microsoft-antispam-prvs: <SA1PR15MB5096168D819C780A71A2B7BDB3519@SA1PR15MB5096.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L532mGyYMKzZjJ8Q3jYEE6AmIZGrsVxGzF7aiQFpaxOSCSjFcjHks+A6bUhBHX0PClrJGfQU1Hd0qQ1v5Yeu0CeCR9AsJyWYYKSrJYzyK6gyfZr40NO5VDoJO8CXtL+6poJKh0hD5v7o4FZmoeFL0NeO08+pwSeNXWA/PzX4LRuPdyJvnhHyaajiNNUtSiuPLM/v3N9d9M+jqHAn2X6AoHgylFYtlV3edi8SNkAS+r2svTx2f6cyf5+Fw1OV7WSYPVHiVsXGTMhh7Gw5o9/C748+c8eGU4YGUmPGjERw5kHHjWfnL7luDTwVSjSXHeYuutJKfVjowXRh7RnFYbB0PZ5sFIBHoW0f/l+WyoTOX6IC/E8oIn2dsG0R+n3TFmhWm/ta72gc/LQdgUdGDGJ4P5Ht6Q7G04x14ZpLznfPkFWSaT+sHoaJ9IW5sYm3xyLSFzWq0fyXgbaRmPIevVqHvocN1pcMyEWxrZUiZzpQCLHyGRqwsjQ4OuYlUr8hmiqrLCEZYmLtX7EcpbydmLW+UR1L30VAffBoJ+vENk5ZZJBcDmll7OEA8RdY93aNdWknYfy8ptNMIG97G0xScZ0YKGWly4O18EDhle8thJCnAx5QSb/HrOTf/2oSz2a7IRka5B3hGKc4uYj+XbZ0SDsuloWnNcA/eLTUg48ytIq86xx1hjXhoKfs0R1ziT+tbBVirAouttiemg82o5nX7/Ah0miZ99IGXhoSRy7T7jRGM1VO67VNR6BaqDBZolflaRXL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(91956017)(66556008)(76116006)(36756003)(66946007)(186003)(66446008)(64756008)(38100700002)(66476007)(8676002)(6512007)(33656002)(8936002)(122000001)(6486002)(6506007)(54906003)(2906002)(83380400001)(316002)(53546011)(5660300002)(508600001)(86362001)(4326008)(6916009)(2616005)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R+YY9rN6ZbCoSejrb2sbKposzk2cuFl/C+Xr9Icgfi+ZOtaVleBHhIChnwTc?=
 =?us-ascii?Q?9qkRaAFCUyLgVTTlr4u8JfI8L9Nu7UUdPW43eK/nJvgO9srJL46j5vAIoAi/?=
 =?us-ascii?Q?sIelW0j2MySFS8ncOk4feU7pzshe2RejrEJDJUiMxlG6pmMEZ9eRjW/y/4gz?=
 =?us-ascii?Q?uiJL9bNOWmDO7pzYGM6WmVT0kSK/p4JNjO3lQOeGcVMd8g+2SoFcgeqqtpYY?=
 =?us-ascii?Q?awV/pbGaMatp5IZ8BBa8N00Ekb5b6n23pfvIQ9I6dRYW+WOIAQlqMcIx6Zh4?=
 =?us-ascii?Q?fMoF83YlpnlBQfQ7xzXr4XKU2N7uSTxtEjYqbZnxQlrBWl1Ey0jA2NSIwcdm?=
 =?us-ascii?Q?icrdqMVli0mNkp/8a1oAh5jqpx0hoqUxBtKadckwg0Oud2/Lx83Rv3eAZI2H?=
 =?us-ascii?Q?1tEUI4CAtaipz5MG3XHDA4wwTr0g+IK0xVIYNUuSlrVPikiLhG3j5m66G/+L?=
 =?us-ascii?Q?9SsxKX+/gYAifQ34IdFhV4Uw89W4uV3fKRa85bvp/yoYIdIE8rQ+5UU7DzGb?=
 =?us-ascii?Q?oYfXUD6GH7SawpnVn1UxGoYErClyFqr0md/6SDfGE83Vqp87RT25m1cJhzS+?=
 =?us-ascii?Q?JTzGkuy08ynCkvcMmf4x9rEAaWvKvXpiyCOhOMO3+kIC1V/hDeD/c4iIGF1M?=
 =?us-ascii?Q?a5R+YjyRpDLDxKguO7sMNW5If5KFeO09+hSVhk1bM+BCwh3aFz0Unw2CVlwc?=
 =?us-ascii?Q?JaH/YzIIG5+DoT/lrUyM+MqaCNsAikIlIimixaJVcH90aMqAWVyqgZNPWbak?=
 =?us-ascii?Q?Y1qk0kER+5PrMPLJaDJvwKoyr0Zq73ao5jv7ojkNIQKJcW0ZzGk4tD5rbvp2?=
 =?us-ascii?Q?1iLn2ndzyMxG2hdASChoTeLxTt8QvQ2pJqF77QVhz2O2/henoSjGUgwoFsBJ?=
 =?us-ascii?Q?y+MxK6dWthSUa6OGyecbAesSHlxVYoKIAKIZHyRxtp+dJq0Qg0hq0EqTizQL?=
 =?us-ascii?Q?7ls0ue708bx0D0qZAfgqor/SwQixLnpWMk6ksZPdAdvDxh7XYBKIbbYIMGpl?=
 =?us-ascii?Q?I1jpYbJ70MDvxeZ1xbRfVCipfuTN8aAd7Pop9O/zASsU9OpFEYyJryCaMCt5?=
 =?us-ascii?Q?51IELVyVQdZhNfNrW6LWA5k7WjoyQcrgmG20pcIzMZM//Npoyzr+Y+TAxBjz?=
 =?us-ascii?Q?7yKXMzZFUqf4j9sPkjc9dtFRH0G28HhMzjzGsw1VaeiLKpfzddzjCLjA4yKv?=
 =?us-ascii?Q?IcRhUOH7/e1CxXjsLA9aVoLGU3me2JmoMqjDNcwFTH4wb6yVuE76A2iFapsd?=
 =?us-ascii?Q?7MWzIg8hO/OSNgFj8JX7zb3TGe3OS6KT2mV0c7Ayzj10eSfEhLh5w1DR1rBV?=
 =?us-ascii?Q?IRQ26IubirKBB7mEAR82Jt4nLLncFkIxw+QEhaifBQ+YgynKL94NbwIofgW4?=
 =?us-ascii?Q?ZQwxBOxKWlWy4yCO0EvBWTNhtV+ot2iVUJI4dZ5BM+t8sOvIVMEoiBuW/Jb6?=
 =?us-ascii?Q?IsChuPuVV5ecsdEh6KNo5McQIoH8mwzGpSFX1TGalIYtZJrCAWUuxmv9ddf2?=
 =?us-ascii?Q?U2PMRgs9XRSjBFgiPpstHj4Et8tOQfiFsoSf6we9ztp1gZwAvXrHnHAv/q35?=
 =?us-ascii?Q?vWDIJRfxnhpsRE9N0jeSDRi0NQAN8RjOtHkmh0WZrmPF3VPMu7GQfZF6cjTv?=
 =?us-ascii?Q?P+zAq6vk1p6qx5q9KFwPlWw9L0+1wHQO3LIS93+19zwwRV/DejwFmAdUIf5Z?=
 =?us-ascii?Q?Xi+J+Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CC912B980F671C4487781726F62DE142@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a85994d-85dc-4d12-b1b5-08d9d529ebd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 17:43:47.6021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D0uBkqLhjgRwJbt6873x3ZBwru7OIW9i0iUSzI2XkR4QxajB90JXvkH+hLNa/U84KOx3zkAcZxWER9Lk9Lxtwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5096
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: -h3TO3i9w8m53dirHpLREERAUuV8EoyL
X-Proofpoint-ORIG-GUID: -h3TO3i9w8m53dirHpLREERAUuV8EoyL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=865
 spamscore=0 impostorscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110097
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 11, 2022, at 4:13 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Wed, Jan 05, 2022 at 06:25:31PM -0800, Song Liu wrote:
> 
>> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
>> index 23fb4d51a5da..02c35725cc62 100644
>> --- a/arch/x86/kernel/alternative.c
>> +++ b/arch/x86/kernel/alternative.c
>> @@ -1102,6 +1102,34 @@ void *text_poke_kgdb(void *addr, const void *opcode, size_t len)
>> 	return __text_poke(addr, opcode, len);
>> }
>> 
>> +/**
>> + * text_poke_jit - Update instructions on a live kernel by jit engine
>> + * @addr: address to modify
>> + * @opcode: source of the copy
>> + * @len: length to copy, could be more than 2x PAGE_SIZE
>> + *
>> + * Only module memory taking jit text (e.g. for bpf) should be patched.
>> + */
> 
> Maybe:
> 
> 	text_poke_copy() - Copy instructions into (an unused part of) RX memory
> 	@args...
> 
> 	Not safe against concurrent execution; useful for JITs to dump
> 	new code blocks into unused regions of RX memory. Can be used in
> 	conjunction with synchronize_rcu_tasks() to wait for existing
> 	execution to quiesce after having made sure no existing
> 	functions pointers are life.
> 
> or something along those lines?

This sounds good! Thanks!

Song

