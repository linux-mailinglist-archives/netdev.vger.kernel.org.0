Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33D840788E
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 16:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhIKOCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 10:02:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18940 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235809AbhIKOCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 10:02:15 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18BDvaSQ021355;
        Sat, 11 Sep 2021 14:00:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=et9qqDMR+7/u/obxQmwY3YfsvsJ0YBPXx29EdqFtIA8=;
 b=J5DWEogM7pD13d/wBPJXxYG6GsIYd4k7LziWz/9YExHnhwntuBwNsXJGADRCsvvF0Fcb
 ltHf8sYViYUsFxcZCq2ATvpf3ZzGNLWnZvUPe8VU4DX+jBGA8UhqEa2dZkyTg4EonhVy
 3oPDTuYJ0gRaHFVhE0aVE/oaYRs/sSeXzbZndCPt4xK5OM2pimNBB6+j/I55HzwhalJu
 P1ZcxWNMuasK7MzVf/5xKo1iKYWeQXi1sLwqat2JSA8Ay+97RiEGKYzaBTt6EXlnmVOg
 Maa3NXEqdiKc1khVVQuqxE9CA/oaKtNS9jeQ62rcDyL8pko6mpahpJ5sMxVTdrLbeE1T GA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=et9qqDMR+7/u/obxQmwY3YfsvsJ0YBPXx29EdqFtIA8=;
 b=afrpla5D12F2qUyPyj2JLv2WF5mqVHClDWHd/UU26wjq3dB5CrJpq1e7sXu8WjlZk5/J
 t3NOWP5Lu0SQysgRT81g7RUvBo7YRL6LEqghJIMWYZJ0qapkJ8xJYpYOyxUCWGUgBY1v
 BLndZdAVw/Z6bt5rHWiDFGc5fC5+FyTEr/JSwuYEHKtDme0fYMMFG/bVFznituo6ZD11
 KXfccTqLQ5VH2aQv71qB4WnZcPSKPFOiMExXEHE5lP+u6UJd98pDvjaYYvttZaQM7Nsc
 q2BWedrWpxbU+4hKVYQ5vs1o1RxzNDn/oKZY0fnFG5/+P0KJYDHTgZJJ7fMWPHPz8VcZ zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b0m2srh94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:00:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18BE0Ebe103872;
        Sat, 11 Sep 2021 14:00:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 3b0m932bxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:00:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9FIjaWUvDd79US/HdAA3nhy3Mrc2jU0uJxBsxJR87Wmax07QXgS6ULlSRX+dyGvCzpS4AWcPRNf3bRbc3uvnR7GOANTLxTqbWG4Ofltmqm3lyA83MNcYBR193Fc25rxssaM5153oG7hCVzDHlEh5LOb4kp9IS1gLowTRp8+sDnRIV1nIdvq64JXAcDWau9jOW+3/Mqgap9y9R2hRQChTCBj7sTgGLS3zmc6x7CoiZhO0jV6b+LjiRb8pVqBE+9iGGf6GkU8U5GH2zQPo+qjEKg1MuChGP0P7doZ6Mk1Rfru01fI0brw57PonFBt160MJMJd1xoRoPJeYQpLuShMug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=et9qqDMR+7/u/obxQmwY3YfsvsJ0YBPXx29EdqFtIA8=;
 b=EyypZ/XF3vX+6awr4cP4GaRx9LcF0CNQnCXfTghzn1KT3kYqYaaPUl0a81HYfG+aozqHo2HXFjBPtVxfbZ2kwOoSfCxKXDLbzaKzGFJTDnwH+TgSIhL7MVzWy3hs3gChBPHhlI22STJJzJ9nz1HSTmDqhQsXHsvy1AaiJNBVjxbM/Dp+CRD8qXFSxxVAHHOpk3HDigcLXDEHWv+6+wDsgNOS47TrBoLgZixoqB5ngtH7WkK6kOw9RxGc/AUJ14hgT/kos5Gx69q5aTb4D+wlmV2McVgsiOKFuEcOtvdRcBfVVZXDtsPgkQT3/myl0lml5UQcAPFVJCYFmXQitlt85w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=et9qqDMR+7/u/obxQmwY3YfsvsJ0YBPXx29EdqFtIA8=;
 b=ewodYyNMDnb7UVbAoxeDf1ih6Cz/SKiU/T5N6LMpUB2Ii/fJROI71lAg9I+qpPtBsOWfDqTk/SV11Xs8weV6mpfJ1Asz5Qn67nhr6KfFm0FlbjAcD7qEWAXbwZsd33MaSnQnDuxpXftln8bEEucCzXf3B1FH+n6HtridQogMDv8=
Received: from DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17)
 by DM6PR10MB3498.namprd10.prod.outlook.com (2603:10b6:5:17a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Sat, 11 Sep
 2021 14:00:55 +0000
Received: from DS7PR10MB4863.namprd10.prod.outlook.com
 ([fe80::847d:80e0:a298:6489]) by DS7PR10MB4863.namprd10.prod.outlook.com
 ([fe80::847d:80e0:a298:6489%7]) with mapi id 15.20.4500.018; Sat, 11 Sep 2021
 14:00:54 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "sashal@kernel.org" <sashal@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnault@redhat.com" <gnault@redhat.com>
Subject: Re: [PATCH 5.4] netns: protect netns ID lookups with RCU
Thread-Topic: [PATCH 5.4] netns: protect netns ID lookups with RCU
Thread-Index: AQHXpxU2tDAvcaFoaku33EfY6VaEl6ue3LQA
Date:   Sat, 11 Sep 2021 14:00:54 +0000
Message-ID: <148BE7D6-7626-4358-B2A5-A30C9C460F9E@oracle.com>
References: <1631368730-22657-1-git-send-email-haakon.bugge@oracle.com>
In-Reply-To: <1631368730-22657-1-git-send-email-haakon.bugge@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d6bac3d-30bc-4f3d-47dd-08d9752c92b5
x-ms-traffictypediagnostic: DM6PR10MB3498:
x-microsoft-antispam-prvs: <DM6PR10MB3498E344342DB3985E8776E2FDD79@DM6PR10MB3498.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:262;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QsMqeUiBjdAEHnL8i7vn0H2fANbPQJOFka1jRj6DKINCjonINsEkUIsEXA0zaiuR/8faMKdU99Z8NE8JhFem6j0OOZ3WwuTL3oKF4YCNDyf678gzebeMKI5EJMsFqQBYkruIM8ZlNhLbiLdIXWODSUOSaNjeWpZD5f6JyMlw+qQx4b37McUq4PtErXJfNiekYlz0nM5W6RhlxApUol2dPqasIdu18DAg4oULfZuAHbOM0OC0JcIPIzXM/MkUkCV/bHqZz5VrCk3hrb4ymGGfoVkaX70p2gSHoXF5a5ZABgY+reIy8LYOcYJ+gN6BWNuWJCLs9EIVRr3YQ4Tku+DbuNhTCOZ1NH/NpZ/3hAupPxHCuAX72NSjeejmHYTiesiwYnhFu6MW/M5v/WWtTIJylS+GDDUBvwIprmERUANgZ5wpFwzzVANLDYhCD4dUdYT55+3LHv34E8bDr5AsOApyHPPPl0FlnQLydLpT4297hDr+7j3p/wCGHi0T/O0DtxKKPjT2QnFoorSbahbMcvWlutNIiTwx+r8fjJpCPhGWsPkNuAx+ENHLuM4s9ynbWEqewtrg9PuYME8H/S6huSwDgA2wMG8qsKdVSe7vrzOOQvvlCMZhf7yp0cda1F5Bi5kdlEiNoyYgdhW8x0U4GM1uXdRbPqCZt/bywaM2wAVUave2Iv8PKLAjL9DceXFKVX9oic4yk31WBRw5XDX+oley0wb+9y2OLoVKYYpGZu8aMXQ6TufotP0+8jlCUzNVEdLuV5IHgOE+LSTkgZ1b3VVwx1vTwSevL4LWMUAdgWPRmGXTxQxfQRXqKtw8/7pn07C0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4863.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66446008)(64756008)(66556008)(66476007)(66574015)(33656002)(71200400001)(110136005)(83380400001)(122000001)(8676002)(44832011)(54906003)(6506007)(53546011)(316002)(7416002)(6486002)(76116006)(66946007)(91956017)(5660300002)(8936002)(38100700002)(4326008)(38070700005)(508600001)(86362001)(2616005)(6512007)(186003)(36756003)(2906002)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEdJdCtrNzR0VWRaTmwxQWxlVFIxM1JsemVYTytWSjlNOC9MZFljTXlveGtS?=
 =?utf-8?B?NGdoTGQ5MVIyUHhoSUt6WkozMG5EeGhzbThGMkhoL2d3UHo0RTR0alRPMysx?=
 =?utf-8?B?Y3VyVHU0WWk2QTErZW02bXZmYkkyM0ZUZHE4cEVKN3RDZmR3dmxiUC9EMDBI?=
 =?utf-8?B?ZUI2VVdxR0ZQdTFxWEltdEs0bjBxY3FvdEUvMVNzMXIzckxSaTNFZ1F2TU5P?=
 =?utf-8?B?YUk0Q1BLMitQQ055N2tjQUZSZTE2Qm83dStHaDAwS05NZzVxUHZneWJhVUJp?=
 =?utf-8?B?LzhSN3ZQeDZQdEk3SXdIcWRKc241eWthM1Btd1VzYUNqQ0xDUzhRazF3b2ZS?=
 =?utf-8?B?bHNMOTJwdHptMXp0TkM0b2YvSHNOMk81TXJUQ1JlN0Z4NGFlbWJrdjIvbGlQ?=
 =?utf-8?B?dVJrR0srQWpUMHcxRXNoU0JObE5YRWpTQ2x3Z0EvNkhLUklTdjlmTG5UbDhv?=
 =?utf-8?B?UlhxU2VybnlhMVdlVHorV2pHbmFvYlB5QmpMMlVkeVFrU1Z6T0pyb3BSdDVM?=
 =?utf-8?B?T2NTK0FvZkkxc0lXV0lkQndZM3lpVzNlb0o0SXozclc2LzJaSGpITFV3eG1h?=
 =?utf-8?B?SjVKVGp5TWpMU2w2ampraWJvRURpRnRwaGRmZDZRdTJkVE1EbEk5S2tSMGcx?=
 =?utf-8?B?Sk9kR1V5T2NUT0dBeGcrU0Z0bkJ6ZFNTUllqdDBGUEhHcWYrSjhkaUhOcXAz?=
 =?utf-8?B?enVaczJmUGcrbHN3NmhQMktLSnE3RW9Sa1QxcS9IM1lLT0NCellqbEd3eFhC?=
 =?utf-8?B?b3hKcnB6aTUvYTRxZHlVWWlqT0JxUWQyb1h2c2ZnNVNLaGNZV2xDdXIyQk43?=
 =?utf-8?B?RDF2UDkza3RlNmRDTWQ1ajBKMW5LNHlwZHNRenNGT3E1M09sZ1d5NkxnYjUy?=
 =?utf-8?B?aUJxcWplUmN4OVJtS3dKNkpOanRHcEdIVzBCamVjbFkwS29KT2w2Ym1xcTlC?=
 =?utf-8?B?TUdLVnd3UjczeXRKT3Q5TEMvb3hGUU1KM1Y0dkJjRndRM3RhY0k2M2NiUVYr?=
 =?utf-8?B?R0J1WkluV3lwN253LzdjUkFtalRsMzcxV0JGRGVxZEJ3eVd0M0RzbVpmRTdJ?=
 =?utf-8?B?S2tNMlkyaktReXQ4SnkwTmIrckhGS2JUNzBtd3ZQWlo0NlZqWlFQanZYaTh3?=
 =?utf-8?B?dzdadG81WmtJakxrRTBWeDlBWnhzSUpGQmQ2WENDSGc3YnYvR1JGdktGVCth?=
 =?utf-8?B?SlhIQU9FdDNqTzhyVURDMW94NHVGYmxxa1dkSlRNMXpoTExySG53b1RmT1B2?=
 =?utf-8?B?a3QrdXBjU1UwL3lZcEt0azRkYUFzSjBsNXRnenBOWnd2WXozVDh0VUhPMjZO?=
 =?utf-8?B?Nml2Nkw2cVFjUkpiZGsyWUJ1amIzUjY5VjJsY0ExQy9iTUJiWitMRjBTNUVq?=
 =?utf-8?B?R1FYcDBaTjFQanhjUHZZSkRzTkVsLytsclNqa2VTcE5QMVZlU2RVRUw3eGZa?=
 =?utf-8?B?NHlxWVY2bWlNRmpzQTkvZWtPUjVNLzZIVjh3V0tMaFVDOGxWVUt4SGxYUG5K?=
 =?utf-8?B?eDlYZGlBYTZ1ano2cGFaY2FLSkxESXpsL2wxSCtuMUZad0hPa1JFU25panU0?=
 =?utf-8?B?dVM1NnNtOVlJbG50VFlqZHRKeFpxSmZJL1UxUkVuL04vamJ2d2hOWTlKQml2?=
 =?utf-8?B?SFdXMkIzeXgrTzU1STZqbkFDNWlzK2tuRk1CSkxuYUNtemxEK1h3ck9DT0Fi?=
 =?utf-8?B?TWZqbjBJUmZieDlCN0NtUDJGRnBteUlZZkh5dnFUZGJOdEZBMlJHaTI0cmZI?=
 =?utf-8?B?TGJ2SWNmMmFNUTFLNDFsV0grQlBhRWFnRnFqM280TjhTcXA0L0JKWm1rMWxE?=
 =?utf-8?B?TmRhWUZmTnVDTlRBc0oxZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E16136D8FCC3D44B6C53F5546ACA073@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4863.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d6bac3d-30bc-4f3d-47dd-08d9752c92b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2021 14:00:54.8865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hX6wO0gOrOfGJUGsZ/1djzLTsMS2GTNJ25qqCow4ZGNq3b+lECN+bOwSrzva86DpRHAQ5lOIOFi+6/IGnxLByA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3498
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109110096
X-Proofpoint-GUID: KcxfftqbhRjQgk4IvTrmzlKnbaE7g1t8
X-Proofpoint-ORIG-GUID: KcxfftqbhRjQgk4IvTrmzlKnbaE7g1t8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGxlYXNlIGRpc3JlZ2FyZCwgd3JvbmcgdmVyc2lvbiBpbiAkU3ViamVjdC4NCg0KDQpUaHhzLCBI
w6Vrb24NCg0KPiBPbiAxMSBTZXAgMjAyMSwgYXQgMTU6NTgsIEjDpWtvbiBCdWdnZSA8aGFha29u
LmJ1Z2dlQG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogR3VpbGxhdW1lIE5hdWx0IDxn
bmF1bHRAcmVkaGF0LmNvbT4NCj4gDQo+IF9fcGVlcm5ldDJpZCgpIGNhbiBiZSBwcm90ZWN0ZWQg
YnkgUkNVIGFzIGl0IG9ubHkgY2FsbHMgaWRyX2Zvcl9lYWNoKCksDQo+IHdoaWNoIGlzIFJDVS1z
YWZlLCBhbmQgbmV2ZXIgbW9kaWZpZXMgdGhlIG5zaWQgdGFibGUuDQo+IA0KPiBydG5sX25ldF9k
dW1waWQoKSBjYW4gYWxzbyBkbyBsb2NrbGVzcyBsb29rdXBzLiBJdCBkb2VzIHR3byBuZXN0ZWQN
Cj4gaWRyX2Zvcl9lYWNoKCkgY2FsbHMgb24gbnNpZCB0YWJsZXMgKG9uZSBkaXJlY3QgY2FsbCBh
bmQgb25lIGluZGlyZWN0DQo+IGNhbGwgYmVjYXVzZSBvZiBydG5sX25ldF9kdW1waWRfb25lKCkg
Y2FsbGluZyBfX3BlZXJuZXQyaWQoKSkuIFRoZQ0KPiBuZXRuc2lkIHRhYmxlcyBhcmUgbmV2ZXIg
dXBkYXRlZC4gVGhlcmVmb3JlIGl0IGlzIHNhZmUgdG8gbm90IHRha2UgdGhlDQo+IG5zaWRfbG9j
ayBhbmQgcnVuIHdpdGhpbiBhbiBSQ1UtY3JpdGljYWwgc2VjdGlvbiBpbnN0ZWFkLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogR3VpbGxhdW1lIE5hdWx0IDxnbmF1bHRAcmVkaGF0LmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiANCj4g
QSBuaWNlIHNpZGUtZWZmZWN0IG9mIHJlcGxhY2luZyBzcGluX3tsb2NrLHVubG9ja31fYmgoKSB3
aXRoDQo+IHJjdV9zcGluX3tsb2NrLHVubG9ja30oKSBpbiBwZWVybmV0MmlkKCkgaXMgdGhhdCBp
dCBhdm9pZHMgdGhlDQo+IHNpdHVhdGlvbiB3aGVyZSBTb2Z0SVJRcyBnZXQgZW5hYmxlZCB3aGls
c3QgSVJRcyBhcmUgdHVybmVkIG9mZi4NCj4gDQo+IEZyb20gYnVnemlsbGEucmVkaGF0LmNvbS9z
aG93X2J1Zy5jZ2k/aWQ9MTM4NDE3OSAoYW4gYW5jaWVudA0KPiA0LjkuMC0wLnJjMCBrZXJuZWwp
Og0KPiANCj4gZHVtcF9zdGFjaysweDg2LzB4YzMNCj4gX193YXJuKzB4Y2IvMHhmMA0KPiB3YXJu
X3Nsb3dwYXRoX251bGwrMHgxZC8weDIwDQo+IF9fbG9jYWxfYmhfZW5hYmxlX2lwKzB4OWQvMHhj
MA0KPiBfcmF3X3NwaW5fdW5sb2NrX2JoKzB4MzUvMHg0MA0KPiBwZWVybmV0MmlkKzB4NTQvMHg4
MA0KPiBuZXRsaW5rX2Jyb2FkY2FzdF9maWx0ZXJlZCsweDIyMC8weDNjMA0KPiBuZXRsaW5rX2Jy
b2FkY2FzdCsweDFkLzB4MjANCj4gYXVkaXRfbG9nKzB4NmEvMHg5MA0KPiBzZWN1cml0eV9zZXRf
Ym9vbHMrMHhlZS8weDIwMA0KPiBbXQ0KPiANCj4gTm90ZSwgc2VjdXJpdHlfc2V0X2Jvb2xzKCkg
Y2FsbHMgd3JpdGVfbG9ja19pcnEoKS4gcGVlcm5ldDJpZCgpIGNhbGxzDQo+IHNwaW5fdW5sb2Nr
X2JoKCkuDQo+IA0KPiBGcm9tIGFuIGludGVybmFsIChVRUspIHN0YWNrIHRyYWNlIGJhc2VkIG9u
IHRoZSB2NC4xNC4zNSBrZXJuZWwgKExUUw0KPiA0LjE0LjIzMSk6DQo+IA0KPiBxdWV1ZWRfc3Bp
bl9sb2NrX3Nsb3dwYXRoKzB4Yi8weGYNCj4gX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsweDQ2LzB4
NDgNCj4gc2VuZF9tYWQrMHgzZDIvMHg1OTAgW2liX2NvcmVdDQo+IGliX3NhX3BhdGhfcmVjX2dl
dCsweDIyMy8weDRkMCBbaWJfY29yZV0NCj4gcGF0aF9yZWNfc3RhcnQrMHhhMy8weDE0MCBbaWJf
aXBvaWJdDQo+IGlwb2liX3N0YXJ0X3htaXQrMHgyYjAvMHg2YTAgW2liX2lwb2liXQ0KPiBkZXZf
aGFyZF9zdGFydF94bWl0KzB4YjIvMHgyMzcNCj4gc2NoX2RpcmVjdF94bWl0KzB4MTE0LzB4MWJm
DQo+IF9fZGV2X3F1ZXVlX3htaXQrMHg1OTIvMHg4MTgNCj4gZGV2X3F1ZXVlX3htaXQrMHgxMC8w
eDEyDQo+IGFycF94bWl0KzB4MzgvMHhhNg0KPiBhcnBfc2VuZF9kc3QucGFydC4xNisweDYxLzB4
ODQNCj4gYXJwX3Byb2Nlc3MrMHg4MjUvMHg4ODkNCj4gYXJwX3JjdisweDE0MC8weDFjOQ0KPiBf
X25ldGlmX3JlY2VpdmVfc2tiX2NvcmUrMHg0MDEvMHhiMzkNCj4gX19uZXRpZl9yZWNlaXZlX3Nr
YisweDE4LzB4NTkNCj4gbmV0aWZfcmVjZWl2ZV9za2JfaW50ZXJuYWwrMHg0NS8weDExOQ0KPiBu
YXBpX2dyb19yZWNlaXZlKzB4ZDgvMHhmNg0KPiBpcG9pYl9pYl9oYW5kbGVfcnhfd2MrMHgxY2Ev
MHg1MjAgW2liX2lwb2liXQ0KPiBpcG9pYl9wb2xsKzB4Y2QvMHgxNTAgW2liX2lwb2liXQ0KPiBu
ZXRfcnhfYWN0aW9uKzB4Mjg5LzB4M2Y0DQo+IF9fZG9fc29mdGlycSsweGUxLzB4MmI1DQo+IGRv
X3NvZnRpcnFfb3duX3N0YWNrKzB4MmEvMHgzNQ0KPiA8L0lSUT4NCj4gZG9fc29mdGlycSsweDRk
LzB4NmENCj4gX19sb2NhbF9iaF9lbmFibGVfaXArMHg1Ny8weDU5DQo+IF9yYXdfc3Bpbl91bmxv
Y2tfYmgrMHgyMy8weDI1DQo+IHBlZXJuZXQyaWQrMHg1MS8weDczDQo+IG5ldGxpbmtfYnJvYWRj
YXN0X2ZpbHRlcmVkKzB4MjIzLzB4NDFiDQo+IG5ldGxpbmtfYnJvYWRjYXN0KzB4MWQvMHgxZg0K
PiByZG1hX25sX211bHRpY2FzdCsweDIyLzB4MzAgW2liX2NvcmVdDQo+IHNlbmRfbWFkKzB4M2U1
LzB4NTkwIFtpYl9jb3JlXQ0KPiBpYl9zYV9wYXRoX3JlY19nZXQrMHgyMjMvMHg0ZDAgW2liX2Nv
cmVdDQo+IHJkbWFfcmVzb2x2ZV9yb3V0ZSsweDI4Ny8weDgxMCBbcmRtYV9jbV0NCj4gcmRzX3Jk
bWFfY21fZXZlbnRfaGFuZGxlcl9jbW4rMHgzMTEvMHg3ZDAgW3Jkc19yZG1hXQ0KPiByZHNfcmRt
YV9jbV9ldmVudF9oYW5kbGVyX3dvcmtlcisweDIyLzB4MzAgW3Jkc19yZG1hXQ0KPiBwcm9jZXNz
X29uZV93b3JrKzB4MTY5LzB4M2E2DQo+IHdvcmtlcl90aHJlYWQrMHg0ZC8weDNlNQ0KPiBrdGhy
ZWFkKzB4MTA1LzB4MTM4DQo+IHJldF9mcm9tX2ZvcmsrMHgyNC8weDQ5DQo+IA0KPiBIZXJlLCBw
YXkgYXR0ZW50aW9uIHRvIGliX25sX21ha2VfcmVxdWVzdCgpIHdoaWNoIGNhbGxzDQo+IHNwaW5f
bG9ja19pcnFzYXZlKCkgb24gYSBnbG9iYWwgbG9jayBqdXN0IGJlZm9yZSBjYWxsaW5nDQo+IHJk
bWFfbmxfbXVsdGljYXN0KCkuIFRoZXJlYWZ0ZXIsIHBlZXJuZXQyaWQoKSBlbmFibGVzIFNvZnRJ
UlFzLCBhbmQNCj4gaXBvaWIgc3RhcnRzIGFuZCBjYWxscyB0aGUgc2FtZSBwYXRoIGFuZCBlbmRz
IHVwIHRyeWluZyB0byBhY3F1aXJlIHRoZQ0KPiBzYW1lIGdsb2JhbCBsb2NrIGFnYWluLg0KPiAN
Cj4gKGNoZXJyeSBwaWNrZWQgZnJvbSBjb21taXQgMmRjZTIyNGY0NjlmMDYwYjk5OThhNWE4Njkx
NTFlZjgzYzA4Y2U3NykNCj4gRml4ZXM6IGZiYTE0M2M2NmFiYiAoIm5ldG5zOiBhdm9pZCBkaXNh
YmxpbmcgaXJxIGZvciBuZXRucyBpZCIpDQo+IFNpZ25lZC1vZmYtYnk6IEjDpWtvbiBCdWdnZSA8
aGFha29uLmJ1Z2dlQG9yYWNsZS5jb20+DQo+IA0KPiBDb25mbGljdHM6DQo+IAluZXQvY29yZS9u
ZXRfbmFtZXNwYWNlLmMNCj4gDQo+IAkJKiBydG5sX3ZhbGlkX2R1bXBfbmV0X3JlcSgpIGhhcyBh
IHZlcnkgbWluaW1hbA0KPiAgICAgICAgICAgICAgICAgIGltcGxlbWVudGF0aW9uIGluIDQuMTQs
IGhlbmNlIG9ubHkgYSBzaW1wbGUNCj4gICAgICAgICAgICAgICAgICBzdWJzdGl0dXRpbmcgb2Yg
c3Bpbl97bG9jayx1bmxvY2t9X2JoKCkgd2l0aA0KPiAgICAgICAgICAgICAgICAgIHJjdV9zcGlu
X3tsb2NrLHVubG9ja30oKSB3YXMgcmVxdWlyZWQNCj4gLS0tDQo+IG5ldC9jb3JlL25ldF9uYW1l
c3BhY2UuYyB8IDE4ICsrKysrKysrKystLS0tLS0tLQ0KPiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5z
ZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9u
ZXRfbmFtZXNwYWNlLmMgYi9uZXQvY29yZS9uZXRfbmFtZXNwYWNlLmMNCj4gaW5kZXggMWFmMjVk
NS4uMzdmNDMxMyAxMDA2NDQNCj4gLS0tIGEvbmV0L2NvcmUvbmV0X25hbWVzcGFjZS5jDQo+ICsr
KyBiL25ldC9jb3JlL25ldF9uYW1lc3BhY2UuYw0KPiBAQCAtMTgxLDkgKzE4MSw5IEBAIHN0YXRp
YyBpbnQgbmV0X2VxX2lkcihpbnQgaWQsIHZvaWQgKm5ldCwgdm9pZCAqcGVlcikNCj4gCXJldHVy
biAwOw0KPiB9DQo+IA0KPiAtLyogU2hvdWxkIGJlIGNhbGxlZCB3aXRoIG5zaWRfbG9jayBoZWxk
LiBJZiBhIG5ldyBpZCBpcyBhc3NpZ25lZCwgdGhlIGJvb2wgYWxsb2MNCj4gLSAqIGlzIHNldCB0
byB0cnVlLCB0aHVzIHRoZSBjYWxsZXIga25vd3MgdGhhdCB0aGUgbmV3IGlkIG11c3QgYmUgbm90
aWZpZWQgdmlhDQo+IC0gKiBydG5sLg0KPiArLyogTXVzdCBiZSBjYWxsZWQgZnJvbSBSQ1UtY3Jp
dGljYWwgc2VjdGlvbiBvciB3aXRoIG5zaWRfbG9jayBoZWxkLiBJZg0KPiArICogYSBuZXcgaWQg
aXMgYXNzaWduZWQsIHRoZSBib29sIGFsbG9jIGlzIHNldCB0byB0cnVlLCB0aHVzIHRoZQ0KPiAr
ICogY2FsbGVyIGtub3dzIHRoYXQgdGhlIG5ldyBpZCBtdXN0IGJlIG5vdGlmaWVkIHZpYSBydG5s
Lg0KPiAgKi8NCj4gc3RhdGljIGludCBfX3BlZXJuZXQyaWRfYWxsb2Moc3RydWN0IG5ldCAqbmV0
LCBzdHJ1Y3QgbmV0ICpwZWVyLCBib29sICphbGxvYykNCj4gew0KPiBAQCAtMjA3LDcgKzIwNyw3
IEBAIHN0YXRpYyBpbnQgX19wZWVybmV0MmlkX2FsbG9jKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0
IG5ldCAqcGVlciwgYm9vbCAqYWxsb2MpDQo+IAlyZXR1cm4gTkVUTlNBX05TSURfTk9UX0FTU0lH
TkVEOw0KPiB9DQo+IA0KPiAtLyogc2hvdWxkIGJlIGNhbGxlZCB3aXRoIG5zaWRfbG9jayBoZWxk
ICovDQo+ICsvKiBNdXN0IGJlIGNhbGxlZCBmcm9tIFJDVS1jcml0aWNhbCBzZWN0aW9uIG9yIHdp
dGggbnNpZF9sb2NrIGhlbGQgKi8NCj4gc3RhdGljIGludCBfX3BlZXJuZXQyaWQoc3RydWN0IG5l
dCAqbmV0LCBzdHJ1Y3QgbmV0ICpwZWVyKQ0KPiB7DQo+IAlib29sIG5vID0gZmFsc2U7DQo+IEBA
IC0yNDAsOSArMjQwLDEwIEBAIGludCBwZWVybmV0MmlkKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0
IG5ldCAqcGVlcikNCj4gew0KPiAJaW50IGlkOw0KPiANCj4gLQlzcGluX2xvY2tfYmgoJm5ldC0+
bnNpZF9sb2NrKTsNCj4gKwlyY3VfcmVhZF9sb2NrKCk7DQo+IAlpZCA9IF9fcGVlcm5ldDJpZChu
ZXQsIHBlZXIpOw0KPiAtCXNwaW5fdW5sb2NrX2JoKCZuZXQtPm5zaWRfbG9jayk7DQo+ICsJcmN1
X3JlYWRfdW5sb2NrKCk7DQo+ICsNCj4gCXJldHVybiBpZDsNCj4gfQ0KPiBFWFBPUlRfU1lNQk9M
KHBlZXJuZXQyaWQpOw0KPiBAQCAtNzYxLDYgKzc2Miw3IEBAIHN0cnVjdCBydG5sX25ldF9kdW1w
X2NiIHsNCj4gCWludCBzX2lkeDsNCj4gfTsNCj4gDQo+ICsvKiBSdW5zIGluIFJDVS1jcml0aWNh
bCBzZWN0aW9uLiAqLw0KPiBzdGF0aWMgaW50IHJ0bmxfbmV0X2R1bXBpZF9vbmUoaW50IGlkLCB2
b2lkICpwZWVyLCB2b2lkICpkYXRhKQ0KPiB7DQo+IAlzdHJ1Y3QgcnRubF9uZXRfZHVtcF9jYiAq
bmV0X2NiID0gKHN0cnVjdCBydG5sX25ldF9kdW1wX2NiICopZGF0YTsNCj4gQEAgLTc5MSw5ICs3
OTMsOSBAQCBzdGF0aWMgaW50IHJ0bmxfbmV0X2R1bXBpZChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBz
dHJ1Y3QgbmV0bGlua19jYWxsYmFjayAqY2IpDQo+IAkJLnNfaWR4ID0gY2ItPmFyZ3NbMF0sDQo+
IAl9Ow0KPiANCj4gLQlzcGluX2xvY2tfYmgoJm5ldC0+bnNpZF9sb2NrKTsNCj4gKwlyY3VfcmVh
ZF9sb2NrKCk7DQo+IAlpZHJfZm9yX2VhY2goJm5ldC0+bmV0bnNfaWRzLCBydG5sX25ldF9kdW1w
aWRfb25lLCAmbmV0X2NiKTsNCj4gLQlzcGluX3VubG9ja19iaCgmbmV0LT5uc2lkX2xvY2spOw0K
PiArCXJjdV9yZWFkX3VubG9jaygpOw0KPiANCj4gCWNiLT5hcmdzWzBdID0gbmV0X2NiLmlkeDsN
Cj4gCXJldHVybiBza2ItPmxlbjsNCj4gLS0gDQo+IDEuOC4zLjENCj4gDQoNCg==
