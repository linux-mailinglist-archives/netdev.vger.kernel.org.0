Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6EF492E93
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 20:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348837AbiARTnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 14:43:07 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33512 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348675AbiARTnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 14:43:07 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IHShJJ024417;
        Tue, 18 Jan 2022 19:42:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2TOhv6zDSaM+KnfLFy7fNYG3DteDgTWeqjXXvF/HLaA=;
 b=xIfD9a5gVXywE8FWDjTWvwouTBaNjTXZqvcsMKIdOCcUPdINDnDk385omzbh0x04vDPj
 1uALrKvA/l/+vJt7iXQVG5CFec2VLwseihS0eciDh8hp2penDMccYCZuhg58LGnXSS09
 MFSxhwx8lsWbEY7aqxjdoakbtnXst7uU8STlWbSzMjalp4eofqUad82iLCZ4KAy3Mo9O
 TiYGVuuI3BEKbApTIBhb69nLCt02h5y3ZstZOvqaS9UpS6borfGYsOe5pAFsujproiWk
 0TOCYayyBAqO6TJtiCon2zKl906YxUEO1VhzjJYc6pdRavF+Ap1IUMiMzwHF9S2rrNIZ uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4q30mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 19:42:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20IJaQN2092212;
        Tue, 18 Jan 2022 19:42:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by aserp3020.oracle.com with ESMTP id 3dkp34q55h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 19:42:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOnHUKFgwBYlPFdPM+C+upuBDGZWHupFV6T/sizuv5GewBfMnRQEKew5e/MCoZ4wKXGdOkaLGUNbhwKx/4sY+cTUpmLWszdo16/3Aj3HlRlwQwP0Sh5AwIWyTVvUmYcwpCx6ahAe44vEPDKOFMQSrbqgIFRkdXpO+4W3FVvCMapzGUthzB+SN3mQYMbVMlLyVKogEGRTGESDWY77GH0l6oqARPnLwdo9TDmF5WTBpizNlQEoUh68hQKZDstkcxFj13jnRjCDgqcCAq5TPfIm+IAInC4UGPnwnNqKgAcuB+BsQzPIan0ZcgViYa3sE37LkoC+F0VBqlP6w3PbKRt/xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2TOhv6zDSaM+KnfLFy7fNYG3DteDgTWeqjXXvF/HLaA=;
 b=NWekrniu5a9Pre+uwZdra6nnStqf8qfbkohvwwc8/po22O3lrqmVsnwFPYWa9JydpPFcigS7iqeqd/2kD4oNIYm1KFGrm0KGduV+I48icFXecxV0mzAvhfKQTcto0R6qXic3zDcqX4Y9x9nQL1Wge7K+ftILwyeo2RwVi3XlsalmAWvBi9Pff6ul9Nm/iJAZczcuRi0wRSFh6t+STOe1xa+8ybx/x+6BiBbPLfWnrhi2NNyzBDtXEwVvtlsh8qvPBmgBvCc27uLjrR1aC9ZV2h9IrUywlWA/RyAVegd05iZ3KOkxzl9f2Z+dRwBO83m8QecRoOxRsaZ6A3nyEM0Ang==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TOhv6zDSaM+KnfLFy7fNYG3DteDgTWeqjXXvF/HLaA=;
 b=YJH/a3KS5rb+94MShwpzmedtjM1f2UdAfC4RpZWAhYgU+8tOx8oalOGejT66e+1PgNqLljFKDre+sN4CYD3s4H+dQw9bNSeXtwPrZ/tsLV6gxVMfR6tCP8LNH4t2lETliKuMz2XNhRKg9sQ1EI44qSGDl3pCfJh3mnwlGzbLdwU=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by SN6PR10MB2941.namprd10.prod.outlook.com (2603:10b6:805:dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 19:42:55 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::a990:7ead:6a5f:7577]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::a990:7ead:6a5f:7577%4]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 19:42:55 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Praveen Kannoju <praveen.kannoju@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>
Subject: Re: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Topic: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Index: AQHYDKOWiOwJtrci00KwdU7kpVIrMw==
Date:   Tue, 18 Jan 2022 19:42:54 +0000
Message-ID: <CEFD48B4-3360-4040-B41A-49B8046D28E8@oracle.com>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
 <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
 <20220118191754.GG8034@ziepe.ca>
In-Reply-To: <20220118191754.GG8034@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf42c7c7-2ef4-4c6e-b1ef-08d9dabab8ea
x-ms-traffictypediagnostic: SN6PR10MB2941:EE_
x-microsoft-antispam-prvs: <SN6PR10MB29418CB8FF07812F11570F0593589@SN6PR10MB2941.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SnrGs1jv9Td6j7dBOVPbt+ggyErJxCS0x0vQHqPZUQNxzalv3FTmyX+1UvTd47gBrwzWSoA+bpFnfpoL73rzECXO3b1AY9TS9HaDGjPWuQfbuPwNU2wE6M2c5qv6ua4oYXlI5YXPvVYcI7M2tR/ha3vTiI+bBojDo0q0JS+Vz7aWxzHmynzzngrmt9kJ0fJ414SXYKb3CLld9zEFa3/QCBtiG6QCdLD7z7/UWDZtVEt/mEux/eejdKFUCnA0EocflkX75Z/axM6TC9/CkLV566bENwMwtAUXKmxYA1XriW9pHLiVChOafhGwovlMxvpKwipEDaIHmvD70G79Qh19Brh8VWvnIqbjgKPZmf9Xp2k9WjvzXdxyTn3CJCV69QuPYDwo9M1hf08dsTgpuy1ohgiGHPC0OMwD/Klb8LALDj8iBhwv+RaDe/9ttWzhL9LkccWRjgrFVe1aSj5prEaeH3T33pQP99gKbwRdht3UNEXaICXfkU4bpnSfj6k7XtFlMISIPoU1m3NPO4QRrvzDwgvf/5igYQOanMh4acJlognorrWHRVXnsvTt16j67AyW23ILhmPFSqV3foyjUIv0iYqoPV832ny5aNc2eaPZ1pfjKr5TAkNoXwUKwXcxXBXFnlyotn9myI290tblr+B+DQmfGyq47paah38E8/I0G6fw96Tt905LFAG1yS1rAWlGIKQ/NKxHNJriu+8qAMN4Tv2prFuQvAU0/4L2hgy8yI4hENdoCM2pyzEL0ykJO33m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(83380400001)(66946007)(91956017)(53546011)(66476007)(64756008)(66556008)(107886003)(38070700005)(26005)(8936002)(54906003)(44832011)(6486002)(76116006)(186003)(2616005)(38100700002)(86362001)(6512007)(2906002)(36756003)(8676002)(316002)(5660300002)(6916009)(4326008)(122000001)(33656002)(71200400001)(508600001)(66446008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlI4UnZZV2JLRVFqWEZldFBZS25aRWsvbGNZU3lKbzJ2cUV3NjdTWWtXN3l1?=
 =?utf-8?B?ZXN4YXVWU1Z1cmwzbkpHQWE2TnJJdEFHM3V6V3ZlemZRa1NRNGZ1N1hreEZF?=
 =?utf-8?B?djN0cVppLzVBQmZ2L3hTamxFQ0tBMUI1YXZueWd0SHRBTU5qSFlHa3FRNnhZ?=
 =?utf-8?B?eFJvektNOUNVUzJJelVablZWQTMrbDVxb1FkRTl5M3ZHMXZxeGVSU0t5VVdL?=
 =?utf-8?B?cWNMTlJSOXJPb1NnWXVWUmNSRG16Zzk2NFBYcU9heTROMENmYXNDWlVsY2tl?=
 =?utf-8?B?RHFwU0grdEZjNlBiVHZRWDdDU2NubmVGUVhhNC9iTGZ4emZ6S09CTTYvSW5I?=
 =?utf-8?B?L2lEZ3RrWE1sdzRxUm5haENCcCtBZndLRk1qMzJPalBxZGY1OWVNSU9jMkZR?=
 =?utf-8?B?ZWQxaGlrY3RUL1pJOGtJOS9BYVJLS3dRTTIxMkxQMzB4bnRhcFBuVkpOQjdF?=
 =?utf-8?B?bXRlUnFLVjhsbDMrenY0N1NKRmt1MTB0VXpIdnFQMktKTC9iK0MvWUp6d3J0?=
 =?utf-8?B?VGRock56WHl4YXpmLzJHT20xUUNtbGFGNVdLdFhUMmZhQmZtYUtNRE9GV0g0?=
 =?utf-8?B?YXFFQ1pWWk5nRFpxUXp0alVPT1drbVJxRjJpV2JsMHptb2hxZk1FSzh4cDdT?=
 =?utf-8?B?QWxKeXlSVkFMUWdQREhpcjVpZDlqdE8rUHBPLzFocVBnM1FWd01YMzc3YjlS?=
 =?utf-8?B?MUN5cU5laFA3RmYwcEM2WFArV29DaGJnYzcxa2dxZGFMTEtqRUM3ekg0Ujgz?=
 =?utf-8?B?SVRFUzB4VUtJVzhFWUw1N1d3MGhtYlpBUGllMjc0Q0JZU2tJdmM2akF2NXNa?=
 =?utf-8?B?Tm91YTM1d1B1c1BxQmZHU0lQYVc1UmhrMmp0R0NZdTZpOXNZaW1FRkNIOFVz?=
 =?utf-8?B?YWk1N3Bpa0ZaSm5IM3Q2elFXNFZlU0dkbC9qN0dQUm1iSER0NElJRjNZeU53?=
 =?utf-8?B?cktUUEliTXhIclZxQWc4RXZOblcvL1FCeVMwNEZ6eW8yeVdXRThhVXlJNTY3?=
 =?utf-8?B?WXIyZlBhQkE0bzljU2hSL2U2U1lWcGFjQ3JtYVQ1ZTNxZXVVUXZYSFdQOU5j?=
 =?utf-8?B?d0FSdzRBL29IWE11elA2Qk4zaXZKTGgxV001R3Q2cmwxR0d2OGpOa2dFSDhL?=
 =?utf-8?B?bld0MVpGNmU4aWVUZVhTUUtWa2dlY0dxdjZCYWxrTUtZUU9qNHdBeWVSZjhR?=
 =?utf-8?B?ZDloSTJteWJsek0vSjV0ZXVKdDBIcHJmam5jTm8yalkxcUk3cjRZNWprV01F?=
 =?utf-8?B?T1QvQ0tFZitZbEk5TldrVDgybVJVUHNjVzdRQnZ3dUJKZERMdXNqUFYrLzgy?=
 =?utf-8?B?bmluSEdBWUhqV2pwbzZiTzcrUFREZjNOUHIvSlNESzh5dERXT2ppcnVFQzh3?=
 =?utf-8?B?dUMxZEpsQUNySC95K25LNWRscGRBMnY1RnR2eElQK2JqOXVYT083NmNmVFJI?=
 =?utf-8?B?dHdvc2t4cnpySHFtL2I3UzZaS1B5bWhId2dETW9pc1pFU1hoVUk1VzFyUEZ6?=
 =?utf-8?B?YzM0TXJiTEVrYTZ4TU9BMU53ZDFJOUptZ1VXRVlQWm5PcllOVzNWU2tnZU1B?=
 =?utf-8?B?ZDRMOGYrenZFVFkrMWxNOXhoY2Y1Q0UyMy8yOWZUTlhrZlVlZXg0UjJsYjB6?=
 =?utf-8?B?b0ZiN1M1Z0dXZ1Jmbk0xek1VT1ArTkxHMnBpRmlvM3kyTWZXMGNjdEFvRUxl?=
 =?utf-8?B?d2dmcGR4T1oySHBwV09obTNVZUx2dHhCeVFwQWdCZXk5YTJpMmgwVDMxRU93?=
 =?utf-8?B?dlJ1ZWRKeDlKbUZDWVk2Qm5DeW1wSHlWWFhpSWNHcGVZTWNoYy9qdnA5Kzdn?=
 =?utf-8?B?c3dEc0dIeTFpaDd3cm5mUnE1SkhDaVZxNFpTVUJLWnRPQml1LzMzNXlHSXR0?=
 =?utf-8?B?RVRXWEZZc2poUWxFWkl2c21EQ3hCeEdHdThSMW9WNjkwSi9sOFFDbk9GNDJ0?=
 =?utf-8?B?amdhUDY2aUx5b3ZaMGR2Uy9HVTg3UjlreTUvanM2MzRaTFJpVTlCVDVQTGR4?=
 =?utf-8?B?UVdSdzBKczBJQmhtdy9UMmF0ZHkxSForS2ZhTDF3TG9RU0FvZTQrODluSHVI?=
 =?utf-8?B?ZXRWUTJvMGJ1R056NjR5WE1zRjZudUVlbWhKYkZ1am9uNWpCTThnbDRGMTF4?=
 =?utf-8?B?SjZaZkRaRjZkOHBaNkhXanhCM09oc2l4YVJwSXBUcjBYQjFkUXFLa0NoUVBT?=
 =?utf-8?B?dG94TnVXTk8xc0dPTFM2NlpyWGQ5Zm5xS01TK1kxWHJxWlQ2Z1FVejdGNlh6?=
 =?utf-8?Q?rVEbJSXXAWCcLIE28jb9OZY1U2ZkiDNZtq/2iQWFrE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49ED443442E80344B7C84AC1419252D8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf42c7c7-2ef4-4c6e-b1ef-08d9dabab8ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 19:42:54.9703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N9CBqhsMubYEnNxjbz82gTTcXeDWHkHvDr+zbSrA1AYZsYBz/uN68uP62fKHeC3dR8UQtMjYdvYD6VOM9LP7g0Z16o2WZJU0/GWYgr40S38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2941
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180116
X-Proofpoint-GUID: kLE1Ty4UDZFfV8XkUaq771FwlnmaNC_5
X-Proofpoint-ORIG-GUID: kLE1Ty4UDZFfV8XkUaq771FwlnmaNC_5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gSmFuIDE4LCAyMDIyLCBhdCAxMToxNyBBTSwgSmFzb24gR3VudGhvcnBlIDxqZ2dAemllcGUu
Y2E+IHdyb3RlOg0KPiANCj4gT24gVHVlLCBKYW4gMTgsIDIwMjIgYXQgMDQ6NDg6NDNQTSArMDAw
MCwgU2FudG9zaCBTaGlsaW1rYXIgd3JvdGU6DQo+PiANCj4+PiBPbiBKYW4gMTgsIDIwMjIsIGF0
IDY6NDcgQU0sIFByYXZlZW4gS2Fubm9qdSA8cHJhdmVlbi5rYW5ub2p1QG9yYWNsZS5jb20+IHdy
b3RlOg0KPj4+IA0KPj4+IFRoaXMgcGF0Y2ggYWltcyB0byByZWR1Y2UgdGhlIG51bWJlciBvZiBh
c3luY2hyb25vdXMgd29ya2VycyBiZWluZyBzcGF3bmVkDQo+Pj4gdG8gZXhlY3V0ZSB0aGUgZnVu
Y3Rpb24gInJkc19pYl9mbHVzaF9tcl9wb29sIiBkdXJpbmcgdGhlIGhpZ2ggSS9PDQo+Pj4gc2l0
dWF0aW9ucy4gU3luY2hyb25vdXMgY2FsbCBwYXRoJ3MgdG8gdGhpcyBmdW5jdGlvbiAicmRzX2li
X2ZsdXNoX21yX3Bvb2wiDQo+Pj4gd2lsbCBiZSBleGVjdXRlZCB3aXRob3V0IGJlaW5nIGRpc3R1
cmJlZC4gQnkgcmVkdWNpbmcgdGhlIG51bWJlciBvZg0KPj4+IHByb2Nlc3NlcyBjb250ZW5kaW5n
IHRvIGZsdXNoIHRoZSBtciBwb29sLCB0aGUgdG90YWwgbnVtYmVyIG9mIEQgc3RhdGUNCj4+PiBw
cm9jZXNzZXMgd2FpdGluZyB0byBhY3F1aXJlIHRoZSBtdXRleCBsb2NrIHdpbGwgYmUgZ3JlYXRs
eSByZWR1Y2VkLCB3aGljaA0KPj4+IG90aGVyd2lzZSB3ZXJlIGNhdXNpbmcgREIgaW5zdGFuY2Ug
Y3Jhc2ggYXMgdGhlIGNvcnJlc3BvbmRpbmcgcHJvY2Vzc2VzDQo+Pj4gd2VyZSBub3QgcHJvZ3Jl
c3Npbmcgd2hpbGUgd2FpdGluZyB0byBhY3F1aXJlIHRoZSBtdXRleCBsb2NrLg0KPj4+IA0KPj4+
IFNpZ25lZC1vZmYtYnk6IFByYXZlZW4gS3VtYXIgS2Fubm9qdSA8cHJhdmVlbi5rYW5ub2p1QG9y
YWNsZS5jb20+DQo+Pj4g4oCUDQo+Pj4gDQo+PiBb4oCmXQ0KPj4gDQo+Pj4gZGlmZiAtLWdpdCBh
L25ldC9yZHMvaWJfcmRtYS5jIGIvbmV0L3Jkcy9pYl9yZG1hLmMNCj4+PiBpbmRleCA4ZjA3MGVl
Li42YjY0MGI1IDEwMDY0NA0KPj4+ICsrKyBiL25ldC9yZHMvaWJfcmRtYS5jDQo+Pj4gQEAgLTM5
Myw2ICszOTMsOCBAQCBpbnQgcmRzX2liX2ZsdXNoX21yX3Bvb2woc3RydWN0IHJkc19pYl9tcl9w
b29sICpwb29sLA0KPj4+IAkgKi8NCj4+PiAJZGlydHlfdG9fY2xlYW4gPSBsbGlzdF9hcHBlbmRf
dG9fbGlzdCgmcG9vbC0+ZHJvcF9saXN0LCAmdW5tYXBfbGlzdCk7DQo+Pj4gCWRpcnR5X3RvX2Ns
ZWFuICs9IGxsaXN0X2FwcGVuZF90b19saXN0KCZwb29sLT5mcmVlX2xpc3QsICZ1bm1hcF9saXN0
KTsNCj4+PiArCVdSSVRFX09OQ0UocG9vbC0+Zmx1c2hfb25nb2luZywgdHJ1ZSk7DQo+Pj4gKwlz
bXBfd21iKCk7DQo+Pj4gCWlmIChmcmVlX2FsbCkgew0KPj4+IAkJdW5zaWduZWQgbG9uZyBmbGFn
czsNCj4+PiANCj4+PiBAQCAtNDMwLDYgKzQzMiw4IEBAIGludCByZHNfaWJfZmx1c2hfbXJfcG9v
bChzdHJ1Y3QgcmRzX2liX21yX3Bvb2wgKnBvb2wsDQo+Pj4gCWF0b21pY19zdWIobmZyZWVkLCAm
cG9vbC0+aXRlbV9jb3VudCk7DQo+Pj4gDQo+Pj4gb3V0Og0KPj4+ICsJV1JJVEVfT05DRShwb29s
LT5mbHVzaF9vbmdvaW5nLCBmYWxzZSk7DQo+Pj4gKwlzbXBfd21iKCk7DQo+Pj4gCW11dGV4X3Vu
bG9jaygmcG9vbC0+Zmx1c2hfbG9jayk7DQo+Pj4gCWlmICh3YWl0cXVldWVfYWN0aXZlKCZwb29s
LT5mbHVzaF93YWl0KSkNCj4+PiAJCXdha2VfdXAoJnBvb2wtPmZsdXNoX3dhaXQpOw0KPj4+IEBA
IC01MDcsOCArNTExLDE3IEBAIHZvaWQgcmRzX2liX2ZyZWVfbXIodm9pZCAqdHJhbnNfcHJpdmF0
ZSwgaW50IGludmFsaWRhdGUpDQo+Pj4gDQo+Pj4gCS8qIElmIHdlJ3ZlIHBpbm5lZCB0b28gbWFu
eSBwYWdlcywgcmVxdWVzdCBhIGZsdXNoICovDQo+Pj4gCWlmIChhdG9taWNfcmVhZCgmcG9vbC0+
ZnJlZV9waW5uZWQpID49IHBvb2wtPm1heF9mcmVlX3Bpbm5lZCB8fA0KPj4+IC0JICAgIGF0b21p
Y19yZWFkKCZwb29sLT5kaXJ0eV9jb3VudCkgPj0gcG9vbC0+bWF4X2l0ZW1zIC8gNSkNCj4+PiAt
CQlxdWV1ZV9kZWxheWVkX3dvcmsocmRzX2liX21yX3dxLCAmcG9vbC0+Zmx1c2hfd29ya2VyLCAx
MCk7DQo+Pj4gKwkgICAgYXRvbWljX3JlYWQoJnBvb2wtPmRpcnR5X2NvdW50KSA+PSBwb29sLT5t
YXhfaXRlbXMgLyA1KSB7DQo+Pj4gKwkJc21wX3JtYigpOw0KPj4gWW91IHdvbuKAmXQgbmVlZCB0
aGVzZSBleHBsaWNpdCBiYXJyaWVycyBzaW5jZSBhYm92ZSBhdG9taWMgYW5kIHdyaXRlIG9uY2Ug
YWxyZWFkeQ0KPj4gaXNzdWUgdGhlbS4NCj4gDQo+IE5vLCB0aGV5IGRvbid0LiBVc2Ugc21wX3N0
b3JlX3JlbGVhc2UoKSBhbmQgc21wX2xvYWRfYWNxdWlyZSBpZiB5b3UNCj4gd2FudCB0byBkbyBz
b21ldGhpbmcgbGlrZSB0aGlzLCBidXQgSSBzdGlsbCBjYW4ndCBxdWl0ZSBmaWd1cmUgb3V0IGlm
DQo+IHRoaXMgdXNhZ2Ugb2YgdW5sb2NrZWQgbWVtb3J5IGFjY2Vzc2VzIG1ha2VzIGFueSBzZW5z
ZSBhdCBhbGwuDQo+IA0KSW5kZWVkLCBJIHNlZSB0aGF0IG5vdywgdGhhbmtzLiBZZWFoLCB0aGVz
ZSBtdWx0aSB2YXJpYWJsZSBjaGVja3MgY2FuIGluZGVlZA0KYmUgcmFjeSBidXQgdGhleSBhcmUg
dW5kZXIgbG9jayBhdCBsZWFzdCBmb3IgdGhpcyBjb2RlIHBhdGguIEJ1dCB0aGVyZSBhcmUgZmV3
DQpob3QgcGF0aCBwbGFjZXMgd2hlcmUgc2luZ2xlIHZhcmlhYmxlIHN0YXRlcyBhcmUgZXZhbHVh
dGVkIGF0b21pY2FsbHkgaW5zdGVhZCBvZg0KaGVhdnkgbG9jay4gDQoNClJlZ2FyZHMsDQpTYW50
b3NoDQoNCg==
