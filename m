Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A823F1CF8
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbhHSPlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:41:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:60786 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238460AbhHSPlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 11:41:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="280319202"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="280319202"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 08:40:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="506134341"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga001.jf.intel.com with ESMTP; 19 Aug 2021 08:40:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 08:40:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 08:40:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 19 Aug 2021 08:40:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 19 Aug 2021 08:40:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBJuqeqJ1UrHekQtXWprePMpP+sypuAlaFmB96pX1gf8hN2BimpAJIZ9MKCIiaZhUMsnhL6uf0E6I+Bczv2iCzcG0cw98Tkj//DiyLQ60dgpeUs7/VKZnrw7B4a0KLTehW7Cs4lsi6WXA+eFjiRDytGjWo4zF8oJaUEgZ0uZFETMsBhcK4Hgn0pFgnhDOgDMd/x8Afk38P1D7gXqLZwG+0qhZK+57nvOfTHagU01NW+ASHisVOHfHFQkGqADbPmJHmye+3gm7kf58oosofBgkNaVhTGKGjZZa4R4oif/G8m4IaG9O2HmeXoagunvnHkKjxaJMgC0LLvc40I321qOVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F38fUsnp0QvsJY8dme42WCNh8F61hVogk/ckG8uRXzk=;
 b=R9+P7o52pxt3vu4eJsKH0ckoXzOZ8cZRL60sV+cc+tMN7ngPxx4xi4nZm1BRniZOQe84MUbHuvXm/P2necd2T9Kn7NGgYbUEqy3nehSZF+zyp2ITQA/UmDl1BouI28KpFKx42LHqdPxLM1wN2/yY9pm/mRi432Y6cONCAY4s+RrgVdCUo7D4ulhtJLkm4EpvWf2n1DdU2Cxr96g24OA4ZyD03CW44M3f8hmqYiNPkuQUH6RSdg8InJZ2+rE8VIWBSKwk02ckPwkwesfPAvbp7MuO0a9E3KbSXvb6KiH70s2TdUAXLmUU5l0T6GRL0s2267wq6ih5Dx0uspeoD0h4uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F38fUsnp0QvsJY8dme42WCNh8F61hVogk/ckG8uRXzk=;
 b=LJy8k/M5NHWYtwwhENbo7SgmyWodzFSmWVE6GznTXUiYWcmAv5GM/3++xfQfAC5yydZ+ANb2kNFrfh8ZGaAuPM7qLhQCFNfrKWxWJT3eE8I+f7KUigyERK3NwnXfe4Vf5YOCZv0LZUrYPHF2WcgNyBWFfAbpz2AyPjUO+S6TU0g=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 19 Aug
 2021 15:40:22 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.019; Thu, 19 Aug 2021
 15:40:22 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "Bross, Kevin" <kevin.bross@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Ahmad Byagowi <abyagowi@fb.com>
Subject: RE: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Thread-Topic: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Thread-Index: AQHXkrpDE4/97678+kqD5jc+QEB2qKt2zoSAgACcQzCAAhWPgIAAVWdwgAEkIgCAAAB9kA==
Date:   Thu, 19 Aug 2021 15:40:22 +0000
Message-ID: <PH0PR11MB4951F51CBA231DFD65806CDAEAC09@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
 <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210818170259.GD9992@hoboy.vegasvil.org>
 <PH0PR11MB495162EC9116F197D79589F5EAFF9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210819153414.GC26242@hoboy.vegasvil.org>
In-Reply-To: <20210819153414.GC26242@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 030ae196-4dee-4866-e26d-08d96327a859
x-ms-traffictypediagnostic: PH0PR11MB4790:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB479002DF6E7CDDBAB94D1A46EAC09@PH0PR11MB4790.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y7sH2xNF1ZZqm4F8h+e7ttYLhj/07TJU+rMCne2G5M7lN18HocDyDJEskFQ967me5zT6zWa24YrBPzd7otouVPOukiybOPC4oztN6OHx77QaWi59WQ1/U5fPP3B6mD1LUBHdGZ1IqLAhGBWWE/lMu36cBdUOJBX4MgqMbmWK0OQyWX1zMwzPl24gf8Yc/0rc02znxvWsdmuRTkEE4BgS1divhUbLUaEzw2F/Lk8zvT4EUC50L6E+MpiFWoIdvs8J+oYGHry3xDkV7wSB6jyk/pPQJEG7fC3qBkjpCWyER4wTG293+eYEEr0P5vq+2u+yFNiyoMT0Tr1gPfHDsaBWpRBm7ulS3eQjGBGrvR+rij1hcSpdghwE/ibwZAHfkWT3i/bnvdouAoa5DG6ausrMMgmYEyDsoQaHwam6La4wmiA/FqdHmJ/YLDj9cVWfGkE26uGtv9xsDQTJjjkTkFWwi+iHwNsVOvkHIBnffHpVeqS07hyefGmwfEtbB/6PuNXh0/iLaSF5zmwFZ5F1pP6j+pxwMTJxUeVjFtj/ktIErbv55/sosFeZsjbNVjARaNVP0q03CIpw73BBVBmGxEeT0e6H44ci6D8fFnZgUdNcf7wlbhlSNDNFrIP413betYbB07USnb37xsVAY+IftHu+KyqbwQIDkFOF32AxAWXLNnxMKFp++ka69pSVAhtSRuukCNJju0oisW4vQZN0YQlPbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(4326008)(2906002)(86362001)(7696005)(33656002)(8676002)(38100700002)(8936002)(83380400001)(71200400001)(478600001)(38070700005)(5660300002)(53546011)(122000001)(316002)(54906003)(9686003)(66946007)(6916009)(66556008)(66446008)(26005)(55016002)(186003)(7416002)(52536014)(76116006)(66476007)(6506007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fg3HnqoyYe8gb6pOqyB+bscP7PeDquuAJvhu8YB8B3S9s1IewmWGbWhsPwkh?=
 =?us-ascii?Q?tIEAkebbRNpJHz1NNfnexcpuxFlsLXwYPddC19YP3OC5Y2xw+B5Gemdnk+Lk?=
 =?us-ascii?Q?tbCtIPt61tXtORlctCmvPEJwyfGXSRsjhZ4mzVTgyM/lwhmCOYmECyAJo+0C?=
 =?us-ascii?Q?HqhHYwd7MEszqk8ZWequ96AfC4VOHLzM57P6rQbwLKkR06AW38ghl3M5pEGj?=
 =?us-ascii?Q?5k1Apo9AnzMBJuT1UmR3E8pKoWfPmun1h/MrWEqjJo3W0wRKkG2uAZqii8ml?=
 =?us-ascii?Q?bP3Ybihiu/G87ND9/uvW+sCg7s1Xl7MgZ8HUEsgYTlVgjtS3iwnREHGffhT/?=
 =?us-ascii?Q?nTGQ8FkEWrJkynUsekf4fsslFQAUmJrkRNLOeGU5WoJ2nCB+9Ns2EUneO1SG?=
 =?us-ascii?Q?MXQrEoG8YmI7KwASLem4i/gGHCuleOvlMscBvTZeatK41kJeA7UGkVDKpIOi?=
 =?us-ascii?Q?2nhQoGs47lvYMtSlQ7JUYyNAOQHTScPJ7oNK7m7SRF9ZSB5KQfLZCdz3z+Ab?=
 =?us-ascii?Q?niqb4EZK3oScAaMXbPFArwFb/Ga2EYzK7wItARm+XMqkCJcE1nzCZAijxvi/?=
 =?us-ascii?Q?8SnA72M8F0vJ9BqsqKY4AROg4SoYTFaG8uQMTTGRyzascGniPIEw8geBgofV?=
 =?us-ascii?Q?zSmNXkKGyedRqLgHwU+6r9WYHSCz73bVCMdaba8nDPJgJMmsE132hjQ+KT7H?=
 =?us-ascii?Q?ls5f4NMWP3aTCqIAGqT3RiCNgu+i0aJcY8MH/polLip7Ka1IxpjGX4s3VKFI?=
 =?us-ascii?Q?tAlMqknjbstH0OFP9urv0DnwjhH36nBnwK1Ph9iJ6MDCKyRUprmHvZ3kNWWx?=
 =?us-ascii?Q?qdhzPYDIzqrhRNZ6BD0UdQcSLvnX2yqfvO9OUiOsjPbFrmqydB8lZECrheM1?=
 =?us-ascii?Q?5zBuKtUQ0tbCtV3LiHb5F5YVusIJGhOrpuFV4Zy2xMs8C1PXaqg3aP4X2hi8?=
 =?us-ascii?Q?luY91YxSu1G07P8jVuCeCOqJvNwM1h5IHfjOsKnA+mOzYWnlbnHXmYWg0GNH?=
 =?us-ascii?Q?tyGjM/S25zvMNQLMOW5CViSkaTjAfiVb+UDLJY4jcdFkRNz7lsdqS6fX5OLp?=
 =?us-ascii?Q?8TnGqkIfQh5jt1/O+hLd53Qt+HryRk1hu4p30ACQb0fwehKmS5r1m05wYNOF?=
 =?us-ascii?Q?QEavJ9xOz5SgUl/JU2c0wWh200i45lcSM+tQ4FRv9GMhDPEsD1YvYONXCUpr?=
 =?us-ascii?Q?kKtV+sU4l6/F91+LBWxHMT/KJ1NavBcKy3nYVfd5Mfx9vAJfa4IOLSkVL6ql?=
 =?us-ascii?Q?iK2RKyw5lfOJycjJKDF4QqVxCAWUYdEgApWX4WLdBIjucfXj2qTUnTnEUYXp?=
 =?us-ascii?Q?xyLyVOHq3kbmHsWzUORyroxi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 030ae196-4dee-4866-e26d-08d96327a859
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 15:40:22.6215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EaZFXwnYt1+QyGm6g19qpcclshFqSwRdq7TrUf8LAHA7CObkagHVE9o+ksVouIcHApjFXrXOHnxwdfZ5JT9heXm80tYmHOxrNDk2HWyL6z4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Thursday, August 19, 2021 5:34 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Cc: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>; linux-
> kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kselftest@vger.kernel.org; Brandeburg,
> Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
> shuah@kernel.org; arnd@arndb.de; nikolay@nvidia.com;
> cong.wang@bytedance.com; colin.king@canonical.com;
> gustavoars@kernel.org; Bross, Kevin <kevin.bross@intel.com>; Stanton,
> Kevin B <kevin.b.stanton@intel.com>; Ahmad Byagowi <abyagowi@fb.com>
> Subject: Re: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL sta=
te
>=20
> On Wed, Aug 18, 2021 at 10:36:03PM +0000, Machnikowski, Maciej wrote:
>=20
> > OK, Let's take a step back and forget about SyncE.
>=20
> Ahem, the title of this series is:
>=20
>     [RFC net-next 0/7] Add basic SyncE interfaces
>=20
> I'd be happy to see support for configuring SyncE.
>=20
> But I guess this series is about something totally different.
>=20
>=20
> Thanks,
> Richard

If it helps we'd be happy to separate that in 2 separate RFCs.
This was squashed together under SyncE support umbrella to show one of the =
use cases, but PTP changes are more generic and cover all PTP clocks that u=
se DPLL for the physical clock generation.

Regards
Maciek
