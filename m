Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCC220FF9
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfEPVZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:25:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbfEPVZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 17:25:03 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4GLKECJ001056;
        Thu, 16 May 2019 14:24:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mQ8A1ecUYFrszUMC8naN33R6nVXsyKskoB/CXSSD4Q8=;
 b=cb9mJ4lvhazoTya68Aj+U/j26JDh0Y43wcF/7F1Nv6Xk+a9fmXF3HGYpV7yOKHl4AdqK
 Wlz0b1itF9xLC54mlWZQQMhb6n9FiDZbdB0qJfCSnX6BrITBeq1nzK1an9cvPaTJ40Iq
 4oZoXHpEFMFWkvgTdWW+wOw3rzLBQFmPnyg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2shcxy8nxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 May 2019 14:24:50 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 16 May 2019 14:24:49 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 16 May 2019 14:24:49 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 16 May 2019 14:24:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQ8A1ecUYFrszUMC8naN33R6nVXsyKskoB/CXSSD4Q8=;
 b=CaZKzeWyH86CeHfR/bvQ8ogwgO5gZQkqt41eK2Q7wFI1StsE8GOm60lAqUz+XBYeYAQasgU+XOqH670ZfxYOv9g+wGIClNmmEge2obsyVj9E9Oytny12qJKc8lwsEHrzVUsLLQjmzaQn+IBjUSVsQXEbhripsBN4PTIU7fuobO0=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1328.namprd15.prod.outlook.com (10.175.3.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Thu, 16 May 2019 21:24:36 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Thu, 16 May 2019
 21:24:36 +0000
From:   Martin Lau <kafai@fb.com>
To:     Wei Wang <tracywwnj@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Wang <weiwan@google.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v3 net] ipv6: fix src addr routing with the exception
 table
Thread-Topic: [PATCH v3 net] ipv6: fix src addr routing with the exception
 table
Thread-Index: AQHVDCZcC+R92eyRoESKvZ3P0mldRqZuQzYA
Date:   Thu, 16 May 2019 21:24:36 +0000
Message-ID: <20190516212434.6c6vamcykzq4b6x2@kafai-mbp>
References: <20190516203054.13066-1-tracywwnj@gmail.com>
In-Reply-To: <20190516203054.13066-1-tracywwnj@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0030.namprd16.prod.outlook.com (2603:10b6:907::43)
 To MWHPR15MB1790.namprd15.prod.outlook.com (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2b6d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf070bf7-27b1-4ed9-41d5-08d6da44e546
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1328;
x-ms-traffictypediagnostic: MWHPR15MB1328:
x-microsoft-antispam-prvs: <MWHPR15MB13280308BD276AF35125371ED50A0@MWHPR15MB1328.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(39860400002)(376002)(366004)(346002)(396003)(199004)(189003)(51914003)(256004)(9686003)(14444005)(6512007)(6246003)(1076003)(446003)(2906002)(102836004)(8936002)(52116002)(478600001)(25786009)(5660300002)(81156014)(76176011)(6436002)(99286004)(6486002)(305945005)(7736002)(8676002)(33716001)(4326008)(14454004)(1411001)(229853002)(386003)(6506007)(81166006)(11346002)(476003)(316002)(486006)(186003)(64756008)(6916009)(66556008)(46003)(68736007)(86362001)(6116002)(53936002)(66476007)(66946007)(73956011)(71190400001)(54906003)(71200400001)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1328;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1ivRIL53iCR9h197ecEkTbwIcCM3wsBj445lJy2AGNV/QVU/9U2jdRcU8LfgVipsDp/PJuwgkZl9oINQbErv29rbz2MBJE2/LV3X4KQjNtwZfOBp2XT/NoRgSxCKlPo5mAqXuAQQiBEBYzES5b9COqJpDcY2YuLemfXMdHciwWVHizpTKmvDI4vNC77He2qohoxArVdzCSPIg+L0vvrbZ5Z7hRl7/clCGxWz/9Ly9wFsYYnQmM6q3yp7PxSRP1YXmtAgE+5LaSnEB+FKy7koy+XBaoeHwPP8uPhacWhc9SFEdjILc8mnxn393eehe8VuctBjlBeWdtOJnyyDdeXBTZHcybb9dR9Rcom1TS5GAjc4s0sY2Iuj6kEtnKuRMs+22OKM7y/kVExxjh5TI7LWRGS0iwV8360+YSYAzm9h4NI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C842E8B489B99B44A3B6ABC96F00D5E4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cf070bf7-27b1-4ed9-41d5-08d6da44e546
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 21:24:36.3495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1328
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_16:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 01:30:54PM -0700, Wei Wang wrote:
> From: Wei Wang <weiwan@google.com>
>=20
> When inserting route cache into the exception table, the key is
> generated with both src_addr and dest_addr with src addr routing.
> However, current logic always assumes the src_addr used to generate the
> key is a /128 host address. This is not true in the following scenarios:
> 1. When the route is a gateway route or does not have next hop.
>    (rt6_is_gw_or_nonexthop() =3D=3D false)
> 2. When calling ip6_rt_cache_alloc(), saddr is passed in as NULL.
> This means, when looking for a route cache in the exception table, we
> have to do the lookup twice: first time with the passed in /128 host
> address, second time with the src_addr stored in fib6_info.
>=20
> This solves the pmtu discovery issue reported by Mikael Magnusson where
> a route cache with a lower mtu info is created for a gateway route with
> src addr. However, the lookup code is not able to find this route cache.
>=20
> Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
> Reported-by: Mikael Magnusson <mikael.kernel@lists.m7n.se>
> Bisected-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Cc: Martin Lau <kafai@fb.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
> Changes from v2:
> - modified the check in rt6_find_cached_rt() to prevent infinite loop
> - add const to src_key to prevent kernel compile warning
>=20
> Changes from v1:
> - restructure the code to only include the new logic in
>   rt6_find_cached_rt()
Acked-by: Martin KaFai Lau <kafai@fb.com>

Thanks for the fix and changes!
