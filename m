Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1376E33F66F
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhCQRSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:18:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhCQRSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 13:18:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HHE5A6097888;
        Wed, 17 Mar 2021 17:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LgaKo7Dp5Ti7MJErwr1z/es+e/tnsPLKOjvndwnb/6k=;
 b=yYNxxFS4K1Fx7OPNCD6EQvqZsr7gHlxcF5eTpgAYqlXWnVYwwfyzxjLAczn4ezUwx6Nb
 4LNrKEThO6d1+wVcSxmwx5NH80PeBfcz5amWDCvRmHxYw1i9JOMg6lE2Y7DcPVth7gXa
 vF25OslFyUmnS5+fw5lTO6NULvh617fPvv5+fEMtq8gLMtcJnXhhve2dD72OONvWqS1u
 RNfRsPoTp8CegOOKOBvj23a6LTH3mEhRogJsBsmY7TA8f82Nxw/39HiRTOMjilxeTeaQ
 j4Eug53uBoqq3uGU+vf9dSrlA2Hy3v/e9ZvUkKbgFqLKQr5GW24WrfCQrmsY8ZkVo+8r 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 378p1nvuds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 17:18:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HHG0FZ158787;
        Wed, 17 Mar 2021 17:18:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 3797b1spm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 17:18:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtjnhGtIvcTv8H0JppRzg1kiqFgCt5du8KPOTsubfvN9ZpmTbOE9V9X8LbIdU8v0Otf9uKKn8PMXuyOK8h0EA+AOurphriy6sZGEGaY04sCF/0/T1600IRaoSky4zqSzSMwCW7CDADqHbZIGEsZsc35AV390eSltzaXzp9hxQf4CLcLtJ+r086Ptc3VPnWARqXIZ98NYTKtbBj5vbvqt2dg9gWq8kjAgYbmkLEdusjVyn3jZGixgR2ZYWIQYGrtwbx5dEeGUiotswjM9y8+7I0ouIw26bAoSAcxEJrJ34K3AE9s8XExaoT1mbIo4P1Dxx9EoMqwR1AkDy5keaooplA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgaKo7Dp5Ti7MJErwr1z/es+e/tnsPLKOjvndwnb/6k=;
 b=RNg+LJcxwMxB2q8OtST5wqEU8c4/yYIOqwv17Zf8jpOA1Q/RGkeGe0eXwe1KA/Z4ATetRTTmBYdZ2SO9CqxyogchBlQW1Mg9yRRZWwzhvtE24WeJk/BIPcHlob1Z+FO/+HUiRu7F1VgQhXDTleT1OO+TFC1EU2fPXndTBxo+wSWPtcRCHdvX/25WSYHY/UAjjl0aUu+UQ7gD7GMU7P9562V4qL2sVU+4ojTprvuMZ6p2W3hzdPvBwxWy8qwe5MzP7O1/EBa1e6wjKiyePfmzK6wmfQhBOhtf7MeWLksZMPPj11gQJMCcpRIBvznYcqdAfWWsheVv8cpLjY3DwoAL7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgaKo7Dp5Ti7MJErwr1z/es+e/tnsPLKOjvndwnb/6k=;
 b=EnB2BpTmw0mmhJjLEfIWz+R8BzyVihqy81ecWf5+dKc5q0xoav0N1fLkngTJWkshxeQ1oygzBoZ2KKdszWE11dZQak9Dc4hfFnvwfoQrUGz+uud2V5cwLJT7dxwtbpUvyri4BhpflM6Zt52EHzjLGKJvy3ZokrmqjB5cAXnisLU=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by BYAPR10MB2520.namprd10.prod.outlook.com (2603:10b6:a02:b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Wed, 17 Mar
 2021 17:18:16 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::9ceb:27f9:6598:8782]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::9ceb:27f9:6598:8782%5]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 17:18:15 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     William Kucharski <william.kucharski@oracle.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/rds: correct socket tunable error in rds_tcp_tune()
Thread-Topic: [PATCH] net/rds: correct socket tunable error in rds_tcp_tune()
Thread-Index: AQHXGz0d3lsNoFDqykS7ZFaQCiLC36qIbI2A
Date:   Wed, 17 Mar 2021 17:18:15 +0000
Message-ID: <0C2A7C81-CD35-4703-89EC-45F922CC8C25@oracle.com>
References: <20210317145204.7282-1-william.kucharski@oracle.com>
In-Reply-To: <20210317145204.7282-1-william.kucharski@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [138.3.200.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c74feb7-9f89-47c6-eb7c-08d8e968a6db
x-ms-traffictypediagnostic: BYAPR10MB2520:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR10MB2520828C8A5753755AC67FD2936A9@BYAPR10MB2520.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dCuypCO3Ccb2AlPTqFlHO6e1rq6KE0RCp9supn9RBWoy/33KUXs7KOCatQo2zkNR3YndUjzMciVdcizKM37FL8NAOjKteR0n3BxX1x5aE0+6haJ5D225PrZPaE/mzm1oc6Iw+dSye23b/Bf8aIigyryx7Vj75NNKRfvKpaEWprypJnYaV4tjhmSf9yJ2glBTPLLVV9jT35tRvKxpsekUDyTqdMPqisUEKS0fNvSVrW574dcOfoMtvyhfwhlq2lTS2rbMyjtGFRpOuVKeQ/47SCyjfnQ6Iu7uuFhZN8FHUtr8zUJX/OJRYAHmUdASOucD3/TWYs9Dh0cnTsYVBo381fwd1cvBy+by7l+kK7Bwce0UAGeboJCkxC66uRY2jidwKxwnr5J91ZMTtaj38jt6+hm/FU4pP7eEJyVYhT7JrZDVUWPQZCqB/QxRN287XHBvBEaoNWM9/Ftax4nRzpr00ttWK7wM9hSJH1cZpPu10Pr/ulljp8S1yJYzkl56g9iLkJ6hbJKgc6NcdmK03W0a/14mnVLpVC7PRkHjs/sSzDCmkwDrVvhHWqCLE9pstY3ubdduYylOFdMY0lMGVaNqbuIok57GS20/kkthuRKSYBkK+XGZkmvRblIH/aKRpCxj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(39860400002)(366004)(346002)(33656002)(5660300002)(478600001)(54906003)(26005)(8936002)(64756008)(6486002)(6636002)(186003)(36756003)(2906002)(66476007)(66556008)(8676002)(316002)(4744005)(37006003)(76116006)(450100002)(6512007)(71200400001)(2616005)(66446008)(4326008)(66946007)(44832011)(53546011)(6506007)(6862004)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L3NHY0s1QkhOVHVHaEtoVnVtRU52bTlYTGIyaEtjOVFrOS8rc05INTZPRmRi?=
 =?utf-8?B?Tk55bXREN3RzYWNrWFZDRno1MlpZWDV2R1BWY2RCSm9ZQ3Z0ZXdyNmpLYlNW?=
 =?utf-8?B?TmhXTUlHS2h6ZnhCTkxwV2NybndVUHgzeWg4WjJhZkRSeFpnZ2xuVVFTMXBk?=
 =?utf-8?B?VVkxRkJPRWErb3V1OWVrM0NNd0ZGU2VuYlBWR0JLdlMvWDFzRlNkNWZHaGlG?=
 =?utf-8?B?eGw3OVl1UDFNY3Fkei9Rb3o1czh4RVlFd3BTZUtrbDc1c3ljU0NuOWVoeHBF?=
 =?utf-8?B?aHNFVnBwbDhjMkRnWmE1cnRvb09pZEw4QjU5YjVTUS93blRQOHJ5M1Btcmdj?=
 =?utf-8?B?WDRyZGRia1A2QU1rakVyZFNHZDAxS2xheUwzc3hkZHhJNjM5WWV2c3g5WlBF?=
 =?utf-8?B?blY1UndTc0Y2a2k3OE5sbTFWZmZxU3c1bDVPenNscEQ2cldpZUp5WTBqcDdq?=
 =?utf-8?B?VHEyNGNDRUFhcFJGaFVKbG9XWitnZ3pnWXcxR2dBWSswVE9TSzQvS1E5SkND?=
 =?utf-8?B?VVd5dGJjZmgyY1lDY0lMVVBhVy96dFdvTWFTL2I1Zjdydkx6YzNwaDZTN2NY?=
 =?utf-8?B?VU4vQkZCMVg0eGd1NURXblA4UzBXdi9QV2ZDUVdFdSsrckloVDhXT1ZYY2hT?=
 =?utf-8?B?L3J5RTdhUFR1VHNyeHdUc2dTUE11bE5YNnplNVBMSit1L1Y1bUNKOWJSdE5y?=
 =?utf-8?B?WVZscEJXR0dsMEp2d1RmOWI3MVNscFlIeWJKcWdsdGUwdHZmb1ZnUjNmVnJu?=
 =?utf-8?B?Wmc0eFpRaGVWMER0U2d1MGpGNWtpV1QwbjBBQlZuM2dycWg1NkRVcXJ2Rmsy?=
 =?utf-8?B?UTQ3R1ZtZmFaT1YrVWFvY0pPajNzSUZBSG96TjdBMVNOTmViajlGbDM0Y3pZ?=
 =?utf-8?B?V0pJVjdIOVNJNzUzeEZzaG5vdmNrUGhFMnRzVllnWWd2SWpuSGZ5VU45aUNy?=
 =?utf-8?B?L1Z4UVQ3SDQ1OXhja25NZW1FdCtXMm5KU08rTzhsakZhNm43NzZxNkRBNTBu?=
 =?utf-8?B?enFGeU5DQVRlTVR3STRCTVNhT2VjcHQ5UC9oQjY1dEd0am5BcHp1U09UdUVC?=
 =?utf-8?B?cXBsMGtDMXFlSVg2Nmp5RTNRdVJrU1hBY1hJNmRmMWNJOU4vUWw4dldjdnRG?=
 =?utf-8?B?RnBRcENuWjNXclB2Y2U2VGR0OW1IbHcwSHBjUElKREJMY2JKM0lmTDZrZlNT?=
 =?utf-8?B?KzRRK29qL0MrRzVHUlk2c29vdXQvdm52ZGRCQlFQT3NaT1hjSDFSQzlhQVNG?=
 =?utf-8?B?bGwrRk1xU1lBUmJTd2lGM2gzTFMrS1JFMFY3UlVLaFJoTjY0NUh2NGt3M0Q0?=
 =?utf-8?B?eXZSNkdMNUdDdFFjRC96YkprS3M1TkVtSTFvL29NNWxzQmxFZkVHSEtMY3ZI?=
 =?utf-8?B?NGtOOHRGZ1cyZGsycXZWcHBINEcvSXVITG4zSHI0dHdZMVNzNmtkaFZNRXhN?=
 =?utf-8?B?L09scnl2VmUxSjQvOEZLdnhYL1JTU1E1QTMzSmVxU2g5Vm1NSmtLWXR1NHBH?=
 =?utf-8?B?eUs1UTB0eU9Wd0JVY0xwcFFjV1BZQjJpakYwVHZJNjJ4S0kzbEoyZUcyRnpi?=
 =?utf-8?B?eThvOEwrOTdSTXJXWG5VbUR6KzZEVHlhOGRnQ1lhT2xMUmNOcTBWOTNwVTQr?=
 =?utf-8?B?V2ZiMzZDdGJ4M0JRbmZvUDlIanRuLzVzQ3cydWpNUDZWejU1cDBoK0dTWXNr?=
 =?utf-8?B?cGVkZ3N5ZE1ick9QTmY3OXp0WG5aRlh5QTVML2JaK29RdUdPMEw3K2sxK1px?=
 =?utf-8?Q?D+iOdY356WGJSUN9c0RJXDzq8qVa8GEPXtY8AHq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D44304E39C1664C907AA96CC2A82F23@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c74feb7-9f89-47c6-eb7c-08d8e968a6db
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 17:18:15.7026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lAzM9cMyAXgYr7NRpkwdVRuj7KBP6yNmcS1zeEfy48yS2vfXSMG3EicuFgVZ3nnSy8cqDK0XHT3KKN3S6mcvPi/byeB30kofLIIk82hGpp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2520
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KFByZXZpb3VzIHJlcGx5IGJvdW5jZWQgZHVlIHRvIGZvcm1hdCBzbyByZS1zZW5kaW5nIHRvIHRo
ZSBsaXN0IGZvciBhcmNoaXZlcykNCg0KT24gTWFyIDE3LCAyMDIxLCBhdCA3OjUyIEFNLCBXaWxs
aWFtIEt1Y2hhcnNraSA8d2lsbGlhbS5rdWNoYXJza2lAb3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0K
PiBDb3JyZWN0IGFuIGVycm9yIHdoZXJlIHNldHRpbmcgL3Byb2Mvc3lzL25ldC9yZHMvdGNwL3Jk
c190Y3BfcmN2YnVmIHdvdWxkDQo+IGluc3RlYWQgbW9kaWZ5IHRoZSBzb2NrZXQncyBza19zbmRi
dWYgYW5kIHdvdWxkIGxlYXZlIHNrX3JjdmJ1ZiB1bnRvdWNoZWQuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBXaWxsaWFtIEt1Y2hhcnNraSA8d2lsbGlhbS5rdWNoYXJza2lAb3JhY2xlLmNvbT4NCj4g
4oCUDQpMb29rcyBnb29kLiBUaGFua3MgISENCkFja2VkLWJ5OiBTYW50b3NoIFNoaWxpbWthciA8
c2FudG9zaC5zaGlsaW1rYXJAb3JhY2xlLmNvbT4NCg0K
