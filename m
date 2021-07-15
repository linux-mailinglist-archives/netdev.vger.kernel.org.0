Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296DE3CA060
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 16:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhGOOTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 10:19:21 -0400
Received: from mx0a-000c9b01.pphosted.com ([205.220.166.177]:61586 "EHLO
        mx0a-000c9b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236344AbhGOOTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 10:19:19 -0400
X-Greylist: delayed 1009 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2021 10:19:19 EDT
Received: from pps.filterd (m0234721.ppops.net [127.0.0.1])
        by mx0a-000c9b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FDwOax030721;
        Thu, 15 Jul 2021 13:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fiu.edu; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=Nov2020; bh=8BZTrFzRP0+/k4puWAXM4GQYvUzo4hRTo4mWgSeM0Xc=;
 b=Od4sXlX2rXCmNZDTi+weYrEVS7Ki0jK6RJK0qvkzFJSxnspZLe9x0kHeK5y6DQlcc2Tf
 KVEZshNx51PewwrAWHJLEb3jiuL9ijQ7gyQDmkrCY4qs1NmR0nCaudcJ0yDRHHt9E2XI
 uWya0QKwmiwPDdy+NXKHkAgjnftGZcGbpEoScxapfJrmx6BErSIvrxeczOayqjQFEsdY
 MfbGJMsCWKoWw/cnOicomhxPOr69ZcqdsNFbpdvEtJrfCoHC88mIHsgCioIXnDvsT2Hl
 ffc/yCo0DzAQGZGZTcm4XjJkQs1A2YtmNlyVDxXdhN17nV/XxS7UEnxNTqOfKxAKe0Qy oQ== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by mx0a-000c9b01.pphosted.com with ESMTP id 39sd0cu14u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 13:59:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRfDTOq0idLXPdhSNQuOeQ/nCUrGK6dHftTHNLJ4iFgct+VV9ROglEXuRgGIviVoz9Gi7xz8ixh34S1/zUZ1NMSJpmn40+UxL8PUsJ9hJ9q9vn2DMYdNmc863iD0NZZ+jAgPDtOg6lxaFSObSzOTjzEZKVQVEow9F8m/Uhq02qnv9By6yt59I/smCtGjgoHbDke+iNMDyDERTAtZ99XDc0h2sIZbbIBbuSq6B3T94dmv3MUsEavqjGO3C+GsBgE0oSPpFRzL7VKTcJPGCzF3dICo2XfZGL133Q4qHfqqZkJVpVy3wRTw8uEWVg8oI0F83FljhR6FPznmTM6pUxJ9jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BZTrFzRP0+/k4puWAXM4GQYvUzo4hRTo4mWgSeM0Xc=;
 b=j1s0nxL+RYMybYzh0DvEcZRk7cXA6yQNpWpdkc5iWT8bTZcVf2utnKrmtL0179dHbSbb3fLqA2hFTVO9O2xU2RZFAhgJUOzbcvZHC+9wInvn6joadcqiwMu9uP80FHE7imuv2jCQUjQnL8jjykRuRF0Yu6tFImesFbzp+jJriFBefTG6k2X8EX+yCexti54sFWdtzBIXOAltfuWtVI0PhQeANt0/sgnPLYeFPtLz4XhKJeoSxn0OaCXj9gvM0jXyS9w9Xhxn91CCoYllCcEUXinw8NdA/+yjUIhIqSbrT8j3CEJZ0HX7gsyNavz6NaSngvxEeommrAgbt02oJKxsNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fiu.edu; dmarc=pass action=none header.from=fiu.edu; dkim=pass
 header.d=fiu.edu; arc=none
Received: from BN7PR05MB5923.namprd05.prod.outlook.com (2603:10b6:408:9::28)
 by BN7PR05MB4195.namprd05.prod.outlook.com (2603:10b6:406:90::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.14; Thu, 15 Jul
 2021 13:59:32 +0000
Received: from BN7PR05MB5923.namprd05.prod.outlook.com
 ([fe80::e5c6:8134:83d0:8cc1]) by BN7PR05MB5923.namprd05.prod.outlook.com
 ([fe80::e5c6:8134:83d0:8cc1%6]) with mapi id 15.20.4352.011; Thu, 15 Jul 2021
 13:59:32 +0000
From:   David Ramirez <davramir@fiu.edu>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: XDP applications running in driver mode on mlx5_core can't access
 various helper functions
Thread-Topic: XDP applications running in driver mode on mlx5_core can't
 access various helper functions
Thread-Index: AQHXeYEANaj7XAKvZE2i1U9m15tDDA==
Date:   Thu, 15 Jul 2021 13:59:32 +0000
Message-ID: <BN7PR05MB592314B791EB8654A59E8841CC129@BN7PR05MB5923.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=fiu.edu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76e14970-49f0-4bf2-2b1f-08d94798c592
x-ms-traffictypediagnostic: BN7PR05MB4195:
x-microsoft-antispam-prvs: <BN7PR05MB4195D297422B363F24F2C648CC129@BN7PR05MB4195.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qAd2R5+HD7LBclOmBE9jgi2+WBeFoSgYsD8Uj5PucFW674KuvRjsyot3yfs0PYmem4r4CZzzOZmfxn27JJF6/+RyaQav6sNEHWxnJJb0J9bK+nJ6SkPVYwFDyK7sOjjpq1cezga1qMl6LZa7x5nNeAji3jb9nJ4PHdrdXO4APfgr2HmGN5JjA1IKbTvzieMFrL27uSrS7iIiTplApGj6HGT8bSV49/tYNxqQw19PA6/ca+HgPiH8tLXH7JyXDux8MEQ9A19T18GoNzeC7dO79h74hdWKfxTDiVrixrOTHzxPA7qbDWfLrJgxY9KPbuGCKcBqnyePwhN6OijQK/sv0XAHVZnRvxu29H1ImN1vRVn5lL4WyLdpcAiwMyXJ40PS/GDb/DdE9FZSCMt2SY6as9B+YmHG5B1IV8dJyrw+Fvq5LbnZbD/uDIloAdUVUs0hzElkvs9+HjDXiLzRYvyvOVgyMpwc2iIDGK4eXRcaVDcUsnDlg6xPxD52WEDaACVqEqXS+KvEoBgcgV+bSIPDC64N52RU16LiCTjZGs8qh9y5pP0G0sWGcCclG/Xfl/SKxokaHEsnVXQ+E8dJMs3LGk3Twc7pLVIfmLHqgkbMWtzJftgNIMv9TcYz4ypYAlx0HWT5QX72ovsLIE4uT/hNZtOBdu9qzvzhyG7NR9xEDQ/SeuDL5pKQbQZqd5PednaEG7CMYVQtdYt9JqFBHnJfzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR05MB5923.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66946007)(66446008)(64756008)(66556008)(66476007)(2906002)(86362001)(76116006)(9686003)(122000001)(4326008)(478600001)(186003)(71200400001)(8936002)(52536014)(316002)(786003)(5660300002)(8676002)(110136005)(7696005)(75432002)(54906003)(33656002)(83380400001)(55016002)(38100700002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?liIriXTFSGXSW4NTJVe0NjnTzaF+VD9Fr8Xq4qOIQ79GaICbfdJk5tFCQA?=
 =?iso-8859-1?Q?3X3p0V1eONwz/cANMvGpmt1au4V/8LF6pjcF8Bs68dpsDhKYR2tbsarVJX?=
 =?iso-8859-1?Q?TEFMZ0Vi8qRe10Ev9VvrDpfozQ8axZEDhbVaXGMfCZnmQYmJCKzbdTDlnv?=
 =?iso-8859-1?Q?FOFYr+4nqs4C00uo5lLbDn0+rVMNhrupkK+r5OlwQiQbow8p1ENlr8Po3s?=
 =?iso-8859-1?Q?oJnO1gw15qQqg9ILTbaGMqyGeJzxyZ0sweCs7FIfvoOHr235Wxh0TEJu49?=
 =?iso-8859-1?Q?G0FB5bmfpWmTsKPAXL4+duRWs3wJsc6t5LcW0YH90zX1We+7F696BsnivW?=
 =?iso-8859-1?Q?dsoWmBjtM8R7zTGCyjhOPjwuofXrNod7m3xM5qHo65cJDDs0a4LN86tdmd?=
 =?iso-8859-1?Q?mMdX31btFZlVIuMvXgZ0knkVGN21RTC/ZQ+BpykR3MmchVF9AovgyM9khL?=
 =?iso-8859-1?Q?214hP44GQJOATi60XpBgkEJX9+DYevaxnehYu3Vni+tJwck5mib5mva28N?=
 =?iso-8859-1?Q?LysRZUgdd9PF+g1x7OIhWOjpzunzFXRC1l3EGPB4MwrWvcS1Vp5/2uHQx6?=
 =?iso-8859-1?Q?VfWUKUrk5vUG1Z/o1tCkwNfolk4T6QkTkH3B1fZ9uFH7h4Ka+P+iAnofIF?=
 =?iso-8859-1?Q?rwN2NRKek/uJ1+z3CFz25YqvV18Q259A0527P5pvi+eG3lmTIGk2Es/W59?=
 =?iso-8859-1?Q?Z4o2IcZgY/bxU2nKiMzAH5Z3wqioqifKuIePEKel6tyOibRjCfbMwgS8au?=
 =?iso-8859-1?Q?96B4iU0qWvlkxVlOyONFK+5iTFFklP/pHxJAuCr7jq/C6zFrK8Nw7v2XVI?=
 =?iso-8859-1?Q?+n+osX5LxQa9JW9fU5Uaiaqr+D+8grZevCUHiUS9Tw1EIUHWkFrPUllk55?=
 =?iso-8859-1?Q?Mr7v51ZOX5Q1UN7X/qvIDLFIVxQJgCbnqUqLyR+lrv+FZuCgWbABTytkt4?=
 =?iso-8859-1?Q?cMG7DDiUfHlVJ+3HDiNDGgpWQG/M3Rjq9GJTwJoBatcxgWILCPrnm7LZfO?=
 =?iso-8859-1?Q?aGTh7+DIGzCvQN0+sRq7cXjPdmigzFsRaJ66BmPkW40Vb5BTCyiyUHBUPp?=
 =?iso-8859-1?Q?x5n3fqvX9PZT+wD3ZrT+cFJKKILLrk8UmNnAQ+hKtiDBC4QfQFTq7QuSsV?=
 =?iso-8859-1?Q?HCvahuC5giL0e+rcW4H9Ha7h3sweRdimwA/d3DB8VFGq8v5Z3zj8ORuFPJ?=
 =?iso-8859-1?Q?NmnN8n89nTKiCMSUgidBsPbaTfUp2cETeoDIBz+UDUGS9YSAJJqOWWqhPG?=
 =?iso-8859-1?Q?YaBdMUZkMdaMiVfM5XLfvwBBUnufgKxu98YPOLrIHAwIvVu448bH7W9X2D?=
 =?iso-8859-1?Q?WluDK8nl4a0lq8b7Q98pMnUjFsR0A/on95L5b5ndQfnB9ErSv+o8/AvRhV?=
 =?iso-8859-1?Q?DPN4tlP8mVllGC0uXCmH7/NUCFJdZPQpdrkiDL3lLRYdJUXhES6hg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fiu.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR05MB5923.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e14970-49f0-4bf2-2b1f-08d94798c592
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 13:59:32.2729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ac79e5a8-e0e4-434b-a292-2c89b5c28366
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KMSBO1OrOvdYvmMhWbvz3ec8Yd1Vzh2QavGm26Uob7LCJw3ZKWYlbSxci6bLSkp/VVU34c5gsGVnV0XVjZ6xag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR05MB4195
X-Proofpoint-ORIG-GUID: i_0JeASGDwGTUk_bv1GcT8Gv-mpJ6E9M
X-Proofpoint-GUID: i_0JeASGDwGTUk_bv1GcT8Gv-mpJ6E9M
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-15_07:2021-07-14,2021-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outboundspampolicy_notspam policy=outboundspampolicy score=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 mlxlogscore=732 malwarescore=0
 adultscore=0 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1011
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150100
X-Proofpoint-FIU-O365: True
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,=0A=
=0A=
I am having issues with calling some bpf helper functions=0A=
when running my XDP program in driver on the mlx5_core driver.=0A=
Several of the helpers I've tried to use for ringbuf and maps always return=
 0.=0A=
While this may seem to imply that for functions that merely return null ins=
tead of=0A=
a pointer in case of an error are working as intended,=0A=
some functions which return negative on failure and 0 on success are are al=
so affected,=0A=
as while they return 0, they do not result in the desired effect.=0A=
=0A=
Observed examples:=0A=
 - bpf_ringbuf_output always returns 0, but no data is pushed to the ringbu=
f=0A=
 - bpf_map_update_elem always returns 0, but the element is not updated=0A=
 - bpf_ringbuf_reserve always returns 0=0A=
 - bpf_map_lookup_elem always returns 0=0A=
 =0A=
I'm uncertain if this is a driver specific issue or an ebpf issue.=0A=
Testing with xdp in driver mode on veth devices works as expected,=0A=
which suggests this is more likely a driver issue.=0A=
=0A=
Additional Details:=0A=
=0A=
Linux Distro: Ubuntu 21.04=0A=
Linux Kernel version: 5.11.0-18-generic=0A=
driver: mlx5_core=0A=
version: 5.11.0-18-generic=0A=
=0A=
Thank you,=0A=
David Ramirez=
