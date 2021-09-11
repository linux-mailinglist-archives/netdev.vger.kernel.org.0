Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B1540788B
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 16:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbhIKOBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 10:01:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31974 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230249AbhIKOBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 10:01:42 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18BDREFR006354;
        Sat, 11 Sep 2021 14:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=TDhijxd/0hHU2Kh/bUkBAUI3y2LZhpX+BPRgCHKMtLs=;
 b=bWQCOivgzWeTc3iwNpzxU5DZ/JZ+fhWDpbe8gKWHh6e0Mfte241ZsAWMTX8kmSWoWHAP
 bJtnP6rlD7OfG7JcVZVcXMjVxUHNz+hdaLciAqhVMkBxkV0NRqhnIjw0Vfl9jrfTIZdw
 7C6Cv3YJ8PkQHGq6MYDFafuUBOrk/k9Thgos11ZxjilrHwZ+SaX/GyxaEAs+8EAxd5R8
 GNWb+hygYQ0JQy6I7HJrgbzleelDYw0cgFO53F4EnCpSvBtuirQ0HJj7DcbFDzXVAWdL
 G6nmFSfVASQb0dN4pomxQwhjGS43lMzcKVTBR6HtmgS7S/HHpYK0XkuZSJRVWSRxNnpl nQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=TDhijxd/0hHU2Kh/bUkBAUI3y2LZhpX+BPRgCHKMtLs=;
 b=UeJ+FdiB9ghwECDwLxKA0/1Tn4ubvRsHfNVBM7m+gN7vgHZMzL8JsvTusVXpWt0AR27t
 ccRw8fEwDNDQ+acln3HHMOEdlD/xiurfJ/s/BNHDXj2q6hs3qaW9fEf6H+huIuR8/fAr
 346J81zZ5zsoXpDuDN5hf0kJ/KF3Ek6gDFykqwRPLgk3r99VRlDe9b6s4M2n7dII6Bqu
 dU4evcm+nKZz0PUhwRyQd34JtS2ezJVnmbjNKVYTo9IMTaAl0WFwMuHLKfOo0o7Os/IL
 66Nwp2JVqBBiBo7dv+v3GNNYeqf4k+0E6QPeSWGchsyKQY3vXxNie1ulqfmvy2egGZaD BA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b0k838jpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:00:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18BDsx09101638;
        Sat, 11 Sep 2021 14:00:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 3b0hjrrc64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:00:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PomxVoJEDifHVo60gaDnLVS+8BLYqFdUlyT6M31R7MwgrLHBLzB9hj5NWhKZDcCXCStUILXb9Ijo0oe7xDq0ddFDYD/jLnhfgdlbg4TVNHAhxFUBfJaQ76BedFGNPMFkBq/zhl7idZXSoOCeUA8C96lJ68QFxzEWTLFH4Niy6OAkRzg0qxeVTPQpbwWYcydyIqKEbrOA15UZucoc+pZ+YuGLkWqzc0rKdyfZDe1fzdoUwp3/Mmaj/Q0ZmWeZ/j7a2z3gc0AgRaQzlgH8LG2XAZe6KeTRSjV46RmYaex0TGw3LgmZcDnieoaqtTuPE+7QE3Enuo2sO3wfVSA5k7ppOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TDhijxd/0hHU2Kh/bUkBAUI3y2LZhpX+BPRgCHKMtLs=;
 b=eISn5Na2Ux5DdnGgC8s8OxqI3QYJs68//1BeEpajyWQx/aEfs288kxpaYADa8RdnxbJlXfK1PQQjjM1TiTznC6aWuwVw803mZf1TBfdtBE1aEPOa0fAdmLqWF5szwsxHoNFiKn99XFTR2PEPWhy+gVHOUeCW5u3Or5mJbiMX+dIo3krc2WLsx/U0DrW8RakRVyuBb77VgXORihh1wwMSPhJvx/4127tKpIbsVGH5vXLbGStlYrxz4ZG9yAdR5CKETMEGvcqvpi26VpieEXkBf2KIMev+3W7m6DxocF3GedSMqOB0vyaBZSKyqOiFqGHxuN3qECTR9hQcKqMXlbMr5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDhijxd/0hHU2Kh/bUkBAUI3y2LZhpX+BPRgCHKMtLs=;
 b=Yd5uMgOKyZv06beoGPK4yu4k7GNm8gsyubqL/ZhvjR0Zc6mh9HrGXTzaS0zeJ3Fd3F9Wyh9jHBpl2jAKKT8gRHdl1JYe7p6lTKvJ/In3dTQHeSk0tS19GCn5yW9RUmNUddu4CIwriSi1CF/Tv5gsyxUkWGMztPkp29X4QtQ9ZUM=
Received: from DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17)
 by DM6PR10MB3498.namprd10.prod.outlook.com (2603:10b6:5:17a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Sat, 11 Sep
 2021 14:00:20 +0000
Received: from DS7PR10MB4863.namprd10.prod.outlook.com
 ([fe80::847d:80e0:a298:6489]) by DS7PR10MB4863.namprd10.prod.outlook.com
 ([fe80::847d:80e0:a298:6489%7]) with mapi id 15.20.4500.018; Sat, 11 Sep 2021
 14:00:20 +0000
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
Thread-Index: AQHXpxUrTGTIZlYe/0m6B3QHAEetsKue3IuA
Date:   Sat, 11 Sep 2021 14:00:20 +0000
Message-ID: <9CA7AF69-609D-4929-8D64-3FD18149FD37@oracle.com>
References: <1631368722-22606-1-git-send-email-haakon.bugge@oracle.com>
In-Reply-To: <1631368722-22606-1-git-send-email-haakon.bugge@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f9a32bf-ddc6-4412-7034-08d9752c7e3c
x-ms-traffictypediagnostic: DM6PR10MB3498:
x-microsoft-antispam-prvs: <DM6PR10MB3498DEF007F57BCA5A1FFE90FDD79@DM6PR10MB3498.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:262;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kCZCZRh0o8WN+WXfo7palcLwQ1v8EXonRpl9J5O6WhPwFIXpxKMgDa+O03ljz0NaKz8H9ig/1kx9ZFDKZBgRZJOTbacOJcI/AYEawBRB5z8mzidpXC37gJz3QdgY3EDOXj2X4WjYLKHymWLlCe9MXHUOzZasO+2Z/LacJ8hWZS/ixEP8NdnypBxbcDxFR+DG4CN+XCguSRMvDFS06e09D0bU1Aji03WJzw8SCg7YiwcqhE4rrJcHZcH21G09t2KCWe88PFZKkQpAmfPTDwDImQDQKOvjVd+nOp67u356JLHfiNesWVao/J/Vi6Kszl3aHlQ/q3QVKmpNv3uuTRHQQfa7oP11VvRz4j89RCuuKeYWBxL9rLD8268L+nb83MtHVOzgTjRTepeFrNkDq0m1ssuotYpp1EoU8EqhBs9so/5/v2+lIyqQZG3Q0gz1b6Hhvn/emscDnstKMzfAccBGRiYU+I5z+iRRMljhMVzmbhCdzENOYV9BG8zrbFudzOjg3QEva5LON3cK753GurtKfGWw4Ynebgces8Kjybt0NbZ8jpPjrDuba5Vrdp25opaNy6OcTFjfGm5KAUmUj/XEpJ263c68/HiI1QHZ7p2v3Sr+JLAHei0+WsBtAQXHe0vhlalIMP91xPB9FoRt4v00coxPzbKccGWxH2Euo0X9xAifAhSBsxHZNIgSR7nZCV4CJD3OQqSqyHQXxgYF+xPRbAjDYqpaIqD+alIuGhr4KnDdRL/I/5eCxAuaTAUsBPK+pA1EypMVxAwae8q48qc2WuvbJkbC098ZWRrps6HD0RWChYH+vWcMBxeFE9LhxI+h
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4863.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66446008)(64756008)(66556008)(66476007)(66574015)(33656002)(71200400001)(110136005)(83380400001)(122000001)(8676002)(44832011)(54906003)(6506007)(53546011)(316002)(7416002)(6486002)(76116006)(66946007)(91956017)(5660300002)(8936002)(38100700002)(4326008)(38070700005)(508600001)(86362001)(2616005)(6512007)(186003)(36756003)(2906002)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTRVTzJRUzJsTjRDZzFjZ1VRNFpvWDdnOEx5TkJEMW1xODgvZW1HVlU4MTV0?=
 =?utf-8?B?ajlUdnErU3hRTlJOVlhsTWZDNFhBSUFRZkRlZG1FWU9DeDZ3Nk5INXpIUVlm?=
 =?utf-8?B?RjhDNlkreFVsNVpnZnBlL1ZOQVpqdWloUit3alNrVGQ5UTdrR3dTOVMwY1Uy?=
 =?utf-8?B?WFkyQlVRRStZUnpoVWNHQkdXZFZSdmdFTHB2QktnR29JUGpwQ0pmL0RObEhy?=
 =?utf-8?B?WHRVSSs0TkloaUJuUXMveVZTam1aQ20vaUIwcXk1TUdWK2s4djYxWXVQQ01r?=
 =?utf-8?B?QWFTcys0aXNPU3ZJMjNvQUtlWnloTmc2MThRSkVKMVBHdXplTmhZYzJVVEZX?=
 =?utf-8?B?M2JOZDNxOGFGWXM2dXo0WVZxSkQ3V3pZQ0Zqd0xQdy9uMlJHSWpDNWQ4Q2wr?=
 =?utf-8?B?SzgxQzlzKzJDZVJqRTBOMDZwRitvRWI0MXZFdmxtajY3bGVPWlpPMkpMYzhp?=
 =?utf-8?B?ZWxKd282U0ZxOEZQUzMvOW05Yk9CU21aMGVmNUZYWlNTSGVueW1EMWRrNm5F?=
 =?utf-8?B?d2JLUzU3MTRCT1hKVG1ZVEViczhSamRxQW1HRUxKajBZQno1VWlaYW5KRlN0?=
 =?utf-8?B?MGhLd1pvZ1N2Qmp0MjFOV1g4R2Q5T0ZLTHNSSUp3L2hDSTFwdEJ4N2kvaXdQ?=
 =?utf-8?B?MC9EM0g0WTdHZlRHVGk1K3lDVjNSeFhHOHlLT3JYRnR1Z3Iyam5RejVHelVv?=
 =?utf-8?B?ZmpnNUF0a09kU2VNSy9UcFJUcDl0VldTbE1xbkduTnpYT21kbVhFYTVXNWpK?=
 =?utf-8?B?RUpsNlM0SWNwTzFKN1BLaWJoNzBmL2l2VmRyS2xERCtQUkc0VG1uQ1ZQTkpM?=
 =?utf-8?B?ZWczK21ZVUM0VnFXSW1Tc21GWWgzWE13aU5XWHl4c2dlY3BIYUQ0SUtKVDJC?=
 =?utf-8?B?YzZndW1kK1hzdG42U0wveURnWWNsVURkQm9Ld0tNc28rZHBjZlJVWFphKy9o?=
 =?utf-8?B?T1BmOHpMRWF0SExSSDRtOFhvcDNKVTQxdXQ1Q3cvTWkvUGRkYnZTNDdHRmY4?=
 =?utf-8?B?N052WFJSWTMwT2lKSnZmd3pUYVk2RVdPbVRlNlJWTFVtNGROR09iQm4yNUp2?=
 =?utf-8?B?NzdwTGQwOW1YVVcwNlVQZ2NMM2FQKzBWWlE0ZkJHMHRPZEtMdGFnRkZzelBP?=
 =?utf-8?B?ZUZTN003QTRLVjM4TG5uZVlFTC9Ta0Z1NDFGei83YnlMTlJUbC9tVGUwR1Bo?=
 =?utf-8?B?STFtMTh3Q1BYRmIvbXEza0h2Wm8ybWRGNzY4ZDV0QmRUbHNEVVpaWGV0S0x6?=
 =?utf-8?B?aXhFK2FXUGRvOUowNXp2Vms3NHZnUDJEMXVKQk5DcUJWSEN0S3lUVThvck9G?=
 =?utf-8?B?ejhTMGxiMzVwMXR1S0ZVQXJPOWlpR2p4N3orSEtDaTRpYWl4M2RERnV3RWFH?=
 =?utf-8?B?TXRzR2xFSXpTQWIycFNia1luVFp2WG5CUkloS1QrOXREWThYckxvMjFZWktI?=
 =?utf-8?B?d0VqUXU1LzlsNVB5OUcwZ1B2endtMEt4WE9tUE5lV2pocmRoYkpVancrSWVt?=
 =?utf-8?B?UDdmRENQVGhRdTdRTWozZFJqYUJrRExweExOVmd2VEh4SkRCSjZDSmJXcmt3?=
 =?utf-8?B?ZUg0alArdHdYVWkrR2dsNDJSYXNHcjgyZEZybk54YldDRVByZUVsck9mZ2Jo?=
 =?utf-8?B?cEwvTGs5MWozSnVyNkZJc2c2RmUyNEptaUFiQ1MyOWdYZW4xeGUrWXlVSnNL?=
 =?utf-8?B?a01SdnZiNFhjWklSVUZuclc0d3JnMHlOaW5rZHQxMEZmOXNWWU85YjY4VVl0?=
 =?utf-8?B?WG5hNDd0ZWtqUWUvdWthWk44QnJmSzZCeFJodzJmTFFtL3A3a21XWUZvRmJl?=
 =?utf-8?B?blhBRmhaV2NZY0Zyb1BJZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <94D3BF3BB981EA4EAD40D461B92118A6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4863.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9a32bf-ddc6-4412-7034-08d9752c7e3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2021 14:00:20.5710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rXaMM6+tS8eF5Ph1XUKTa3gNmD3JdH9VfAAD6UmyEo/1YgQve6hFnSVJ0p4EBJxFXeQddV5BvxeXSmzCRo6Myg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3498
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109110095
X-Proofpoint-GUID: F5Ihe2ezjMxdRwyxRXN7_-oj_Rs1XDY4
X-Proofpoint-ORIG-GUID: F5Ihe2ezjMxdRwyxRXN7_-oj_Rs1XDY4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGxlYXNlIGRpc3JlZ2FyZCwgd3JvbmcgdmVyc2lvbiBpbiAkU3ViamVjdC4NCg0KDQpUaHhzLCBI
w6Vrb24NCg0KDQoNCj4gT24gMTEgU2VwIDIwMjEsIGF0IDE1OjU4LCBIw6Vrb24gQnVnZ2UgPGhh
YWtvbi5idWdnZUBvcmFjbGUuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IEd1aWxsYXVtZSBOYXVs
dCA8Z25hdWx0QHJlZGhhdC5jb20+DQo+IA0KPiBfX3BlZXJuZXQyaWQoKSBjYW4gYmUgcHJvdGVj
dGVkIGJ5IFJDVSBhcyBpdCBvbmx5IGNhbGxzIGlkcl9mb3JfZWFjaCgpLA0KPiB3aGljaCBpcyBS
Q1Utc2FmZSwgYW5kIG5ldmVyIG1vZGlmaWVzIHRoZSBuc2lkIHRhYmxlLg0KPiANCj4gcnRubF9u
ZXRfZHVtcGlkKCkgY2FuIGFsc28gZG8gbG9ja2xlc3MgbG9va3Vwcy4gSXQgZG9lcyB0d28gbmVz
dGVkDQo+IGlkcl9mb3JfZWFjaCgpIGNhbGxzIG9uIG5zaWQgdGFibGVzIChvbmUgZGlyZWN0IGNh
bGwgYW5kIG9uZSBpbmRpcmVjdA0KPiBjYWxsIGJlY2F1c2Ugb2YgcnRubF9uZXRfZHVtcGlkX29u
ZSgpIGNhbGxpbmcgX19wZWVybmV0MmlkKCkpLiBUaGUNCj4gbmV0bnNpZCB0YWJsZXMgYXJlIG5l
dmVyIHVwZGF0ZWQuIFRoZXJlZm9yZSBpdCBpcyBzYWZlIHRvIG5vdCB0YWtlIHRoZQ0KPiBuc2lk
X2xvY2sgYW5kIHJ1biB3aXRoaW4gYW4gUkNVLWNyaXRpY2FsIHNlY3Rpb24gaW5zdGVhZC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEd1aWxsYXVtZSBOYXVsdCA8Z25hdWx0QHJlZGhhdC5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4g
DQo+IEEgbmljZSBzaWRlLWVmZmVjdCBvZiByZXBsYWNpbmcgc3Bpbl97bG9jayx1bmxvY2t9X2Jo
KCkgd2l0aA0KPiByY3Vfc3Bpbl97bG9jayx1bmxvY2t9KCkgaW4gcGVlcm5ldDJpZCgpIGlzIHRo
YXQgaXQgYXZvaWRzIHRoZQ0KPiBzaXR1YXRpb24gd2hlcmUgU29mdElSUXMgZ2V0IGVuYWJsZWQg
d2hpbHN0IElSUXMgYXJlIHR1cm5lZCBvZmYuDQo+IA0KPiBGcm9tIGJ1Z3ppbGxhLnJlZGhhdC5j
b20vc2hvd19idWcuY2dpP2lkPTEzODQxNzkgKGFuIGFuY2llbnQNCj4gNC45LjAtMC5yYzAga2Vy
bmVsKToNCj4gDQo+IGR1bXBfc3RhY2srMHg4Ni8weGMzDQo+IF9fd2FybisweGNiLzB4ZjANCj4g
d2Fybl9zbG93cGF0aF9udWxsKzB4MWQvMHgyMA0KPiBfX2xvY2FsX2JoX2VuYWJsZV9pcCsweDlk
LzB4YzANCj4gX3Jhd19zcGluX3VubG9ja19iaCsweDM1LzB4NDANCj4gcGVlcm5ldDJpZCsweDU0
LzB4ODANCj4gbmV0bGlua19icm9hZGNhc3RfZmlsdGVyZWQrMHgyMjAvMHgzYzANCj4gbmV0bGlu
a19icm9hZGNhc3QrMHgxZC8weDIwDQo+IGF1ZGl0X2xvZysweDZhLzB4OTANCj4gc2VjdXJpdHlf
c2V0X2Jvb2xzKzB4ZWUvMHgyMDANCj4gW10NCj4gDQo+IE5vdGUsIHNlY3VyaXR5X3NldF9ib29s
cygpIGNhbGxzIHdyaXRlX2xvY2tfaXJxKCkuIHBlZXJuZXQyaWQoKSBjYWxscw0KPiBzcGluX3Vu
bG9ja19iaCgpLg0KPiANCj4gRnJvbSBhbiBpbnRlcm5hbCAoVUVLKSBzdGFjayB0cmFjZSBiYXNl
ZCBvbiB0aGUgdjQuMTQuMzUga2VybmVsIChMVFMNCj4gNC4xNC4yMzEpOg0KPiANCj4gcXVldWVk
X3NwaW5fbG9ja19zbG93cGF0aCsweGIvMHhmDQo+IF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHg0
Ni8weDQ4DQo+IHNlbmRfbWFkKzB4M2QyLzB4NTkwIFtpYl9jb3JlXQ0KPiBpYl9zYV9wYXRoX3Jl
Y19nZXQrMHgyMjMvMHg0ZDAgW2liX2NvcmVdDQo+IHBhdGhfcmVjX3N0YXJ0KzB4YTMvMHgxNDAg
W2liX2lwb2liXQ0KPiBpcG9pYl9zdGFydF94bWl0KzB4MmIwLzB4NmEwIFtpYl9pcG9pYl0NCj4g
ZGV2X2hhcmRfc3RhcnRfeG1pdCsweGIyLzB4MjM3DQo+IHNjaF9kaXJlY3RfeG1pdCsweDExNC8w
eDFiZg0KPiBfX2Rldl9xdWV1ZV94bWl0KzB4NTkyLzB4ODE4DQo+IGRldl9xdWV1ZV94bWl0KzB4
MTAvMHgxMg0KPiBhcnBfeG1pdCsweDM4LzB4YTYNCj4gYXJwX3NlbmRfZHN0LnBhcnQuMTYrMHg2
MS8weDg0DQo+IGFycF9wcm9jZXNzKzB4ODI1LzB4ODg5DQo+IGFycF9yY3YrMHgxNDAvMHgxYzkN
Cj4gX19uZXRpZl9yZWNlaXZlX3NrYl9jb3JlKzB4NDAxLzB4YjM5DQo+IF9fbmV0aWZfcmVjZWl2
ZV9za2IrMHgxOC8weDU5DQo+IG5ldGlmX3JlY2VpdmVfc2tiX2ludGVybmFsKzB4NDUvMHgxMTkN
Cj4gbmFwaV9ncm9fcmVjZWl2ZSsweGQ4LzB4ZjYNCj4gaXBvaWJfaWJfaGFuZGxlX3J4X3djKzB4
MWNhLzB4NTIwIFtpYl9pcG9pYl0NCj4gaXBvaWJfcG9sbCsweGNkLzB4MTUwIFtpYl9pcG9pYl0N
Cj4gbmV0X3J4X2FjdGlvbisweDI4OS8weDNmNA0KPiBfX2RvX3NvZnRpcnErMHhlMS8weDJiNQ0K
PiBkb19zb2Z0aXJxX293bl9zdGFjaysweDJhLzB4MzUNCj4gPC9JUlE+DQo+IGRvX3NvZnRpcnEr
MHg0ZC8weDZhDQo+IF9fbG9jYWxfYmhfZW5hYmxlX2lwKzB4NTcvMHg1OQ0KPiBfcmF3X3NwaW5f
dW5sb2NrX2JoKzB4MjMvMHgyNQ0KPiBwZWVybmV0MmlkKzB4NTEvMHg3Mw0KPiBuZXRsaW5rX2Jy
b2FkY2FzdF9maWx0ZXJlZCsweDIyMy8weDQxYg0KPiBuZXRsaW5rX2Jyb2FkY2FzdCsweDFkLzB4
MWYNCj4gcmRtYV9ubF9tdWx0aWNhc3QrMHgyMi8weDMwIFtpYl9jb3JlXQ0KPiBzZW5kX21hZCsw
eDNlNS8weDU5MCBbaWJfY29yZV0NCj4gaWJfc2FfcGF0aF9yZWNfZ2V0KzB4MjIzLzB4NGQwIFtp
Yl9jb3JlXQ0KPiByZG1hX3Jlc29sdmVfcm91dGUrMHgyODcvMHg4MTAgW3JkbWFfY21dDQo+IHJk
c19yZG1hX2NtX2V2ZW50X2hhbmRsZXJfY21uKzB4MzExLzB4N2QwIFtyZHNfcmRtYV0NCj4gcmRz
X3JkbWFfY21fZXZlbnRfaGFuZGxlcl93b3JrZXIrMHgyMi8weDMwIFtyZHNfcmRtYV0NCj4gcHJv
Y2Vzc19vbmVfd29yaysweDE2OS8weDNhNg0KPiB3b3JrZXJfdGhyZWFkKzB4NGQvMHgzZTUNCj4g
a3RocmVhZCsweDEwNS8weDEzOA0KPiByZXRfZnJvbV9mb3JrKzB4MjQvMHg0OQ0KPiANCj4gSGVy
ZSwgcGF5IGF0dGVudGlvbiB0byBpYl9ubF9tYWtlX3JlcXVlc3QoKSB3aGljaCBjYWxscw0KPiBz
cGluX2xvY2tfaXJxc2F2ZSgpIG9uIGEgZ2xvYmFsIGxvY2sganVzdCBiZWZvcmUgY2FsbGluZw0K
PiByZG1hX25sX211bHRpY2FzdCgpLiBUaGVyZWFmdGVyLCBwZWVybmV0MmlkKCkgZW5hYmxlcyBT
b2Z0SVJRcywgYW5kDQo+IGlwb2liIHN0YXJ0cyBhbmQgY2FsbHMgdGhlIHNhbWUgcGF0aCBhbmQg
ZW5kcyB1cCB0cnlpbmcgdG8gYWNxdWlyZSB0aGUNCj4gc2FtZSBnbG9iYWwgbG9jayBhZ2Fpbi4N
Cj4gDQo+IChjaGVycnkgcGlja2VkIGZyb20gY29tbWl0IDJkY2UyMjRmNDY5ZjA2MGI5OTk4YTVh
ODY5MTUxZWY4M2MwOGNlNzcpDQo+IA0KPiBGaXhlczogZmJhMTQzYzY2YWJiICgibmV0bnM6IGF2
b2lkIGRpc2FibGluZyBpcnEgZm9yIG5ldG5zIGlkIikNCj4gU2lnbmVkLW9mZi1ieTogSMOla29u
IEJ1Z2dlIDxoYWFrb24uYnVnZ2VAb3JhY2xlLmNvbT4NCj4gDQo+IENvbmZsaWN0czoNCj4gCW5l
dC9jb3JlL25ldF9uYW1lc3BhY2UuYw0KPiANCj4gCQkqIHJ0bmxfdmFsaWRfZHVtcF9uZXRfcmVx
KCkgaGFzIGEgdmVyeSBtaW5pbWFsDQo+ICAgICAgICAgICAgICAgICAgaW1wbGVtZW50YXRpb24g
aW4gNC4xOSwgaGVuY2Ugb25seSBhIHNpbXBsZQ0KPiAgICAgICAgICAgICAgICAgIHN1YnN0aXR1
dGluZyBvZiBzcGluX3tsb2NrLHVubG9ja31fYmgoKSB3aXRoDQo+ICAgICAgICAgICAgICAgICAg
cmN1X3NwaW5fe2xvY2ssdW5sb2NrfSgpIHdhcyByZXF1aXJlZA0KPiAtLS0NCj4gbmV0L2NvcmUv
bmV0X25hbWVzcGFjZS5jIHwgMTggKysrKysrKysrKy0tLS0tLS0tDQo+IDEgZmlsZSBjaGFuZ2Vk
LCAxMCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25l
dC9jb3JlL25ldF9uYW1lc3BhY2UuYyBiL25ldC9jb3JlL25ldF9uYW1lc3BhY2UuYw0KPiBpbmRl
eCA5MzlkOGEzLi4yNmQ3MGMwIDEwMDY0NA0KPiAtLS0gYS9uZXQvY29yZS9uZXRfbmFtZXNwYWNl
LmMNCj4gKysrIGIvbmV0L2NvcmUvbmV0X25hbWVzcGFjZS5jDQo+IEBAIC0xOTIsOSArMTkyLDkg
QEAgc3RhdGljIGludCBuZXRfZXFfaWRyKGludCBpZCwgdm9pZCAqbmV0LCB2b2lkICpwZWVyKQ0K
PiAJcmV0dXJuIDA7DQo+IH0NCj4gDQo+IC0vKiBTaG91bGQgYmUgY2FsbGVkIHdpdGggbnNpZF9s
b2NrIGhlbGQuIElmIGEgbmV3IGlkIGlzIGFzc2lnbmVkLCB0aGUgYm9vbCBhbGxvYw0KPiAtICog
aXMgc2V0IHRvIHRydWUsIHRodXMgdGhlIGNhbGxlciBrbm93cyB0aGF0IHRoZSBuZXcgaWQgbXVz
dCBiZSBub3RpZmllZCB2aWENCj4gLSAqIHJ0bmwuDQo+ICsvKiBNdXN0IGJlIGNhbGxlZCBmcm9t
IFJDVS1jcml0aWNhbCBzZWN0aW9uIG9yIHdpdGggbnNpZF9sb2NrIGhlbGQuIElmDQo+ICsgKiBh
IG5ldyBpZCBpcyBhc3NpZ25lZCwgdGhlIGJvb2wgYWxsb2MgaXMgc2V0IHRvIHRydWUsIHRodXMg
dGhlDQo+ICsgKiBjYWxsZXIga25vd3MgdGhhdCB0aGUgbmV3IGlkIG11c3QgYmUgbm90aWZpZWQg
dmlhIHJ0bmwuDQo+ICAqLw0KPiBzdGF0aWMgaW50IF9fcGVlcm5ldDJpZF9hbGxvYyhzdHJ1Y3Qg
bmV0ICpuZXQsIHN0cnVjdCBuZXQgKnBlZXIsIGJvb2wgKmFsbG9jKQ0KPiB7DQo+IEBAIC0yMTgs
NyArMjE4LDcgQEAgc3RhdGljIGludCBfX3BlZXJuZXQyaWRfYWxsb2Moc3RydWN0IG5ldCAqbmV0
LCBzdHJ1Y3QgbmV0ICpwZWVyLCBib29sICphbGxvYykNCj4gCXJldHVybiBORVROU0FfTlNJRF9O
T1RfQVNTSUdORUQ7DQo+IH0NCj4gDQo+IC0vKiBzaG91bGQgYmUgY2FsbGVkIHdpdGggbnNpZF9s
b2NrIGhlbGQgKi8NCj4gKy8qIE11c3QgYmUgY2FsbGVkIGZyb20gUkNVLWNyaXRpY2FsIHNlY3Rp
b24gb3Igd2l0aCBuc2lkX2xvY2sgaGVsZCAqLw0KPiBzdGF0aWMgaW50IF9fcGVlcm5ldDJpZChz
dHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBuZXQgKnBlZXIpDQo+IHsNCj4gCWJvb2wgbm8gPSBmYWxz
ZTsNCj4gQEAgLTI2MSw5ICsyNjEsMTAgQEAgaW50IHBlZXJuZXQyaWQoc3RydWN0IG5ldCAqbmV0
LCBzdHJ1Y3QgbmV0ICpwZWVyKQ0KPiB7DQo+IAlpbnQgaWQ7DQo+IA0KPiAtCXNwaW5fbG9ja19i
aCgmbmV0LT5uc2lkX2xvY2spOw0KPiArCXJjdV9yZWFkX2xvY2soKTsNCj4gCWlkID0gX19wZWVy
bmV0MmlkKG5ldCwgcGVlcik7DQo+IC0Jc3Bpbl91bmxvY2tfYmgoJm5ldC0+bnNpZF9sb2NrKTsN
Cj4gKwlyY3VfcmVhZF91bmxvY2soKTsNCj4gKw0KPiAJcmV0dXJuIGlkOw0KPiB9DQo+IEVYUE9S
VF9TWU1CT0wocGVlcm5ldDJpZCk7DQo+IEBAIC04MzcsNiArODM4LDcgQEAgc3RydWN0IHJ0bmxf
bmV0X2R1bXBfY2Igew0KPiAJaW50IHNfaWR4Ow0KPiB9Ow0KPiANCj4gKy8qIFJ1bnMgaW4gUkNV
LWNyaXRpY2FsIHNlY3Rpb24uICovDQo+IHN0YXRpYyBpbnQgcnRubF9uZXRfZHVtcGlkX29uZShp
bnQgaWQsIHZvaWQgKnBlZXIsIHZvaWQgKmRhdGEpDQo+IHsNCj4gCXN0cnVjdCBydG5sX25ldF9k
dW1wX2NiICpuZXRfY2IgPSAoc3RydWN0IHJ0bmxfbmV0X2R1bXBfY2IgKilkYXRhOw0KPiBAQCAt
ODY3LDkgKzg2OSw5IEBAIHN0YXRpYyBpbnQgcnRubF9uZXRfZHVtcGlkKHN0cnVjdCBza19idWZm
ICpza2IsIHN0cnVjdCBuZXRsaW5rX2NhbGxiYWNrICpjYikNCj4gCQkuc19pZHggPSBjYi0+YXJn
c1swXSwNCj4gCX07DQo+IA0KPiAtCXNwaW5fbG9ja19iaCgmbmV0LT5uc2lkX2xvY2spOw0KPiAr
CXJjdV9yZWFkX2xvY2soKTsNCj4gCWlkcl9mb3JfZWFjaCgmbmV0LT5uZXRuc19pZHMsIHJ0bmxf
bmV0X2R1bXBpZF9vbmUsICZuZXRfY2IpOw0KPiAtCXNwaW5fdW5sb2NrX2JoKCZuZXQtPm5zaWRf
bG9jayk7DQo+ICsJcmN1X3JlYWRfdW5sb2NrKCk7DQo+IA0KPiAJY2ItPmFyZ3NbMF0gPSBuZXRf
Y2IuaWR4Ow0KPiAJcmV0dXJuIHNrYi0+bGVuOw0KPiAtLSANCj4gMS44LjMuMQ0KPiANCg0K
