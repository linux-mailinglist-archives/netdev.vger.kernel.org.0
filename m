Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB262542BE
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgH0JuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:50:18 -0400
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:46130 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgH0JuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 05:50:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1679; q=dns/txt; s=iport;
  t=1598521816; x=1599731416;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1H3xhU738wh5NTvecnSBnFPICq0+XGrgqQHAe3kJtMw=;
  b=BBgpzYaVWG59je/0D57t+Hbh1lTJ77lxd2OQ6xy++kcZ6wt3MwOpr7tr
   0rP/LdTslWbnPx9X+psYyyfZSIJaZdJ29cudS5TYeAuh3BYtANkfkhDrx
   WIXpr849uS71I20ubZ3e+IXisYOqHEfOhiTUYYG9jzgMAv5u9gQCXl1Uu
   g=;
IronPort-PHdr: =?us-ascii?q?9a23=3AsOlgUxVxzEwwQkGomVVvd3HuysPV8LGuZFwc94?=
 =?us-ascii?q?YnhrRSc6+q45XlOgnF6O5wiEPSBNyDuelZkOeQuLKzEWAD4JPUtncEfdQMUh?=
 =?us-ascii?q?IekswZkkQmB9LNEkz0KvPmLklYVMRPXVNo5Te3ZE5SHsutfEDJrzu5/21aFh?=
 =?us-ascii?q?D2LwEgIOPzF8bbhNi20Obn/ZrVbk1IiTOxbKk0Ig+xqFDat9Idhs1pLaNixw?=
 =?us-ascii?q?=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BaDgBegUdf/40NJK1gHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgUqBUlEHgUgvLAqHcwONRCWYcYJTA1ULAQEBDAEBLQIEAQG?=
 =?us-ascii?q?ETAKCQgIkOBMCAwEBCwEBBQEBAQIBBgRthVwMhXMBAQQSFRkBATcBDwIBCA4?=
 =?us-ascii?q?KLjIlAgQNAQUCAQEegwSCTAMuAQOnYgKBOYhhdIEBM4MBAQEFgkuCbxiCEAm?=
 =?us-ascii?q?BOIJxijQbgUE/gREnDIJdPoQ9hXe2VgqCY5ohBQcDHoMHiWcFk1GyFQIEAgQ?=
 =?us-ascii?q?FAg4BAQWBayOBV3AVgyRQFwINjh+DcYpWdDcCBgoBAQMJfI8cAYEQAQE?=
X-IronPort-AV: E=Sophos;i="5.76,359,1592870400"; 
   d="scan'208";a="726787273"
Received: from alln-core-8.cisco.com ([173.36.13.141])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 27 Aug 2020 09:50:15 +0000
Received: from XCH-RCD-002.cisco.com (xch-rcd-002.cisco.com [173.37.102.12])
        by alln-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id 07R9oFKV021820
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 27 Aug 2020 09:50:15 GMT
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by XCH-RCD-002.cisco.com
 (173.37.102.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 Aug
 2020 04:50:15 -0500
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rcd-003.cisco.com
 (173.37.227.248) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 Aug
 2020 04:50:14 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 27 Aug 2020 04:50:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTS68B14o7OHfG88sUv20KPcY9NDRK6CVaLVzuZUPE7vUGWzuXhC3fEHmOkXiaRvXfyiZkHsyi/E/Cw97xvS/AFSN5Pn2T8mgz8R3ySpQQlePGIjrw/anVf9tCE570sunYyUFAMJrRR7Q++eyJUz399RZQyqBgLmg6lQNPLS/OuCOJ9t4pJ6hAuPpeOycBHG++Cqbds8UMJO4bMSYqIQ0MP0eAifDVCLk1boLJYIEVwDERpDrhosSJrveCwf+GvQiZQy4d24m8y3XCuejjCS0GKn85+hAmg4HLxOEjE3Z1M9OQN+k3pX3n0W5bABSC0wu+gKLHqZW/uLNQNMqqCqCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqA0+zWEUCLfWkBi507sWelNqJ0zouXFMi65UUJQwgw=;
 b=dFOcXrl46mmqzKlq0P2W2PnowyYikDHcfs9b2AvMMP27akVipOr+4m5pUiK+f7e+DEyPpQORFoi8Q964e/TDJjFcyinO7xTONUCDDwlKdMKrTCP9I8MWwtdVCEJX4z+cysBS3Dt1CLxbK1elSv/FkONgBong+A2zRp0aNWRmLxyZpIiEO2QYlK9oNri7r6Int9MiJbdk1k/qz2tkufcAvrWWUJZVPhr+fWDloiwuQEQKYzsmcKXsxmCDWPTbW3BQRLhoGiT/CbO5kVbXydSLDcfyb8lp38+ZPnHCBeWkiESnDz8YuUhiUZhylDxf2nRJQBvXhdrd29cNTWQii6rl+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqA0+zWEUCLfWkBi507sWelNqJ0zouXFMi65UUJQwgw=;
 b=qF3ZUuwHII8M5EmDWwLxA0/kLUTwoQV0HTS0bWIvnC8ZEp2VwpYHtCoBZe1ttGZgY53SXsphy20YCjWzUYApE89HP6ulBILU6qv2d/a99GBR+S9xofiNI+nu/zYC5uZKMRLYMw9QfoNmUeOgeBXB9YR6AzbAdrmXp3IalTQRk5k=
Received: from MN2PR11MB3871.namprd11.prod.outlook.com (2603:10b6:208:13c::31)
 by MN2PR11MB3982.namprd11.prod.outlook.com (2603:10b6:208:13b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Thu, 27 Aug
 2020 09:50:13 +0000
Received: from MN2PR11MB3871.namprd11.prod.outlook.com
 ([fe80::c074:3e0e:4d7c:3ead]) by MN2PR11MB3871.namprd11.prod.outlook.com
 ([fe80::c074:3e0e:4d7c:3ead%6]) with mapi id 15.20.3305.026; Thu, 27 Aug 2020
 09:50:13 +0000
From:   "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] ioctl: only memset non-NULL link settings
Thread-Topic: [PATCH] ioctl: only memset non-NULL link settings
Thread-Index: AQHWfEtP/HkzRykyN0mqLLXK63yRD6lLtlMA
Date:   Thu, 27 Aug 2020 09:50:13 +0000
Message-ID: <0273aa12-60e1-85b0-1373-c5d0fc6bb2e8@cisco.com>
References: <20200824064630.3836539-1-hegtvedt@cisco.com>
 <20200827082304.ju7wsvf2xfego2a5@lion.mk-sys.cz>
In-Reply-To: <20200827082304.ju7wsvf2xfego2a5@lion.mk-sys.cz>
Accept-Language: en-DK, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [62.16.133.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60cd1945-f10a-4575-9115-08d84a6e987d
x-ms-traffictypediagnostic: MN2PR11MB3982:
x-microsoft-antispam-prvs: <MN2PR11MB398291E1144E23948D3B7E9ADD550@MN2PR11MB3982.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RDVDtZNGkxLz+qoySbK7fGCb94nNWXM/BI7DEkNDhbmFyABvwyccsL3ZwfOJR66A31jGB8upxingObMYRIW7np0pz8K80QijBjldxp2i/eZxbRpiHxgKwCZOn92VJCZJMS9ASKxk+N4aNuU27wqnu8lq8yVJbeIw9AIgOtPFFNOwtNh/9kdLH2dIKGWSyKUNwgFBt5WRnnZx6+afvXecNT0b+o6psiTKWM4gvy3BGEzAxIiE2JhfRhlwyZNDBBVESYExZvL7LpoXzOp/DUvMzZ5b10Bo7SBk48HFN3P9bcQ+NLXciC4i8ZoVRRO49lXy8ibdydzz/9JuPSVSLtRmk41GG2JskIuTTl9oq9ASnx3oDTig2nNJTpDr7xbCtmCL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3871.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(66446008)(66476007)(6512007)(6916009)(6486002)(53546011)(86362001)(478600001)(316002)(36756003)(31686004)(6506007)(71200400001)(5660300002)(26005)(186003)(91956017)(2906002)(66556008)(76116006)(66946007)(64756008)(31696002)(2616005)(83380400001)(4326008)(8676002)(8936002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iy2vKmD816kz8YLkudE8eaPcXOpMoNkh28TBBBA0EL4/Qsei5oUHGSr+6y9NwYjVOEdatofsFwutMHFiET9Xl4aDfZQxxyXfb7E3GK/tfClyD82nX0DblTBNMVeuCGnREX1VKqaxsOmzP6tBnHfn6rIvUM2r02TWzBI87KRVda6zXUtQ3KdxlkE88rR5cuQAHZnydk6YgDqf48bl633ffHuoXYimL0Aqgl5aB45eyiKdLxSMJ6Dq/LHlMMUQTs2d4qRieuvm+3Cd/IGhvjZ0W9c2L5oXTmeyiYyFrrz8mB6gIZ16/x/xnbyzKvXfyE2w2POpxgX8QaUk6jecHnuaPCYuzOnuuljG4cBuF4hi/T1LhC/Nx2dDeeYQV5Q46t4n95dJs/3UvpDy4MkcP4WlgQDoe3R+ZO9rQkzmkAnrabADC0EWzR7kcWqOVNqXQfbIMsrR/n+7/GSReC7yYhOJ5KedvUlRb5VxtKUMm6jjpAOxebsJDPjiPdYXVjbD20lM860VYClIaHNn+zVdPAWCUnNuDY/DRvH6/xkwk7qPgPso36OSyfGH+3bUCdG+on7Kz+XMc0OHu2Bd8dO6l11w0FCOurkn7KIlPDtQmZBkelqPKtElLBDbUx/jzKNx30unP4zXUHsRlxmZLQOT4oiYLg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <3A74CFFDC8F6244CB4F529F9089E4817@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3871.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60cd1945-f10a-4575-9115-08d84a6e987d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 09:50:13.5970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fxMbaw4ze3geHNowlvhVDGG1HTtRjXknOTWDCqYv/yVXYVE4Xm0Ek7WDvNSTuXaJkAMm/rzUeFHWI7TRC6+3Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3982
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.12, xch-rcd-002.cisco.com
X-Outbound-Node: alln-core-8.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/08/2020 10:23, Michal Kubecek wrote:
> On Mon, Aug 24, 2020 at 08:46:30AM +0200, Hans-Christian Noren Egtvedt wr=
ote:
>> In commit bef780467fa ('ioctl: do not pass transceiver value back to
>> kernel') a regression slipped. If we have a kernel that does not support
>> the ETHTOOL_xLINKSETTINGS API, then the do_ioctl_glinksettings()
>> function will return a NULL pointer.
>>
>> Hence before memset'ing the pointer to zero we must first check it is
>> valid, as NULL return is perfectly fine when running on old kernels.
>>
>=20
> Please add a standard "Fixes:" line here, i.e.
>=20
> Fixes: bef780467fa7 ("ioctl: do not pass transceiver value back to kernel=
")
>=20
>> Signed-off-by: Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
>> ---
>>   ethtool.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/ethtool.c b/ethtool.c
>> index c4ad186..8267d6b 100644
>> --- a/ethtool.c
>> +++ b/ethtool.c
>> @@ -2908,8 +2908,10 @@ static int do_sset(struct cmd_context *ctx)
>>   		struct ethtool_link_usettings *link_usettings;
>>  =20
>>   		link_usettings =3D do_ioctl_glinksettings(ctx);
>> -		memset(&link_usettings->deprecated, 0,
>> -		       sizeof(link_usettings->deprecated));
>> +		if (link_usettings) {
>> +			memset(&link_usettings->deprecated, 0,
>> +			       sizeof(link_usettings->deprecated));
>> +		}
>>   		if (link_usettings =3D=3D NULL)
>>   			link_usettings =3D do_ioctl_gset(ctx);
>=20
> This is correct fix but now we have two if statements with exactly
> opposite conditions here; please combine them into one if-else.

Thank you for the review, a v2 will arrive shortly.
