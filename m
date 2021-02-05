Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925E1310DAF
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 17:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhBEOfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 09:35:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:15404 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232676AbhBEOcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 09:32:16 -0500
IronPort-SDR: hJedh2ikky0ZtWzF1i1Bb47sNRuuua9xqGtduq2G8uTPzbMsKkGBz0Smotq/5JhZFcvTIY3ofJ
 77hpi9IXxVrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="181516519"
X-IronPort-AV: E=Sophos;i="5.81,155,1610438400"; 
   d="scan'208";a="181516519"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 08:09:40 -0800
IronPort-SDR: ICmJ6Jb7JilcmixOUQg5nmK8I6QjRNKmLcLSye8SCcAUfwWazv5m3sQcfCrtASCOrcq18Mmmci
 uN6obu5WQxmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,155,1610438400"; 
   d="scan'208";a="393920764"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 05 Feb 2021 08:09:36 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 08:09:35 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 08:09:35 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 5 Feb 2021 08:09:35 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 5 Feb 2021 08:09:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQWYDLBJgf9+5WR9YBd26/Lk52noJOSR44y2bWmlPeWHC4k+68pYUsRPho0Y1SwhhNDXPytvP6bUZijcdhMLJlMLkMz6VNHCjAhQUxJf0P0YVEkf6UT9ytYAFNGGS7TDaYtIUCRueR0A6ja3CdNIARjnhCbYbDuucRs9LLWaaGVo7nY79cJ4DAARKYHn8Dt8vULW/submO/GUAVqhauShzvriZXjCC0fpouN7U1QQN3/YfGF+MyDLSimursUUj+SIB2NWdqEb+G+eFgMnbY+xhcH7PV2l+ZwXsQeW549/ynjhr/hv7gKL9OC1kmYgAivVlydhkaFWJsClNcKge9Ssg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDd71PgmpcXa+jq/J0kX7j7z/PsV7hmzXIz/t3nUoyw=;
 b=P1iNomjLd7Qxr4WPHJ4DsU1Pstq4ifUqnbBRt3oMnS/bpE4ttTdp/LeWAA0jBpHN5ERh/YvYfdVHbmF4xjt/O7ToYwzeRNmrF1rUkq5xxwnqnsUbY4959f4+ROmr6gfWPrBDLlVTIxkfPXSI2u8gXOpHDie6LY+6ffNMdwB5uQgH3nvvhp21E8Ca7r0fogOdinCyh/OJ6zOZhkjJan39pXTZmiysYwy7pSu6Vys/aqKNUVZ7KiuTRXCftgM7nsgDzi2tfOq0ZeFnrWUx3/S1WJ1RHD516SCuZJIqyN7Xi64ytF/xvSWRh1ugyPCAXnTSVsW3pXOfFzY4Lrvt+dtzCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDd71PgmpcXa+jq/J0kX7j7z/PsV7hmzXIz/t3nUoyw=;
 b=h35VwyXs6fec4RdbZExhTT2c1qObob8/9bqzJ2KU37oVHx2RKDKOaGAznMcOxegm38MyVudso5/uiynyiN0/meDGBUvzrK09raTEiXomQOv23F7UMD3MBCFtCiQH8+P28nmHGx3iJ1TgR4VDVkAj6YL2DmUQyxuhTqKJLxK59Mg=
Received: from SN6PR11MB3008.namprd11.prod.outlook.com (2603:10b6:805:cf::18)
 by SA0PR11MB4528.namprd11.prod.outlook.com (2603:10b6:806:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Fri, 5 Feb
 2021 16:09:31 +0000
Received: from SN6PR11MB3008.namprd11.prod.outlook.com
 ([fe80::611e:f342:6f85:db95]) by SN6PR11MB3008.namprd11.prod.outlook.com
 ([fe80::611e:f342:6f85:db95%6]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 16:09:31 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next 3/3] ice: optimize for
 XDP_REDIRECT in xsk path
Thread-Topic: [Intel-wired-lan] [PATCH net-next 3/3] ice: optimize for
 XDP_REDIRECT in xsk path
Thread-Index: AQHWyL0FI7QEdtrZvkahaZcWBdjaOapKIOAQ
Date:   Fri, 5 Feb 2021 16:09:31 +0000
Message-ID: <SN6PR11MB3008BCD53DAE0FF5B77AB632E2B29@SN6PR11MB3008.namprd11.prod.outlook.com>
References: <20201202150724.31439-1-magnus.karlsson@gmail.com>
 <20201202150724.31439-4-magnus.karlsson@gmail.com>
In-Reply-To: <20201202150724.31439-4-magnus.karlsson@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [27.61.31.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae40b4e9-6105-4a81-4e0d-08d8c9f06bfc
x-ms-traffictypediagnostic: SA0PR11MB4528:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4528371DF91B8BB4812C2EC1E2B29@SA0PR11MB4528.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9sb1g7ziOmJxX48iUaBUrMZmtaGlYmCzBQh28TbtkzhK0fW5oMJFaKrQsgBDq53Mf2xqIxzoQl/UAEK6Hs7tyIQOCKLDBIiXmQ72BRrLQulCucbJqu6H/eEwZ5kwsWJE77RVZr2tF5D3JC1f5PFjpkc59tN750IMfrlIxb8SuN4iqVpYA2JSQxoW5B2VCpwwjAB1IT4BWYIXKTlZWEWkMcZnjZP2IYzhI6PZ+lDZM2n55/qSAL+PVODBNqhNR39p3z7XQGSS8FdmRB4O7BQVmjBh7P03VTtpAKSahmW76BgiM/rZB8UIzDfIZNSdF5hXNYdap9nqLQCb3tjtT/2IXRNV6GkMJYwa5s/C6H4o0A5YUZbwHz9wxptLgUFIG0Mr38COIo8zCzEcyVeOAOr2NqpRNgeIt3RSTvOh5aOsIQAO7nJ9nYo7nKV0ZPmWNWDRB9ZrnfuokbuZMkf5ePb7gH/L+xgrj8EQUP445QNofe+CRES9qi/TPy7a4cw/JD+LfamqIbzA4WriMQ6bT16ySQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(8936002)(83380400001)(5660300002)(6636002)(8676002)(33656002)(76116006)(4326008)(4744005)(478600001)(66446008)(64756008)(66556008)(6506007)(7696005)(2906002)(53546011)(26005)(71200400001)(66946007)(86362001)(52536014)(316002)(9686003)(66476007)(55016002)(54906003)(186003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hnxFEXYDovZyK87Q1eqQKOCDqdGaXiCUF91lopKc7Ta+76KEHmABTZ27wjDE?=
 =?us-ascii?Q?QuX/vZ6W08dGTT8CVKqRvfsPNdkj77xCpBjR/pa2bvv3elvAL6YTLpTgikra?=
 =?us-ascii?Q?jwieAT4EMnlJKrrUz3F7Klufg6n2Ck8m4O+u/oWvjhR4kra13sF/WXulnPMF?=
 =?us-ascii?Q?d4O7TAVUikD2hBCNHBPzTeOuaGyv3RkTl5hEnPpvJbUKQpkwA3IBQsr/RGC4?=
 =?us-ascii?Q?Dk/7YiWSQjyZm7ZQ2muj7Dopy0cqQ6zsWl9ZnLPK9qf7ubp515nAQxX1Xkm0?=
 =?us-ascii?Q?S3sQGn3r/dgQ4P9iFvPgmj80XY2yJyw7fDZKFmClaSNi3gFX95KcdeiOskAN?=
 =?us-ascii?Q?kbYnW+ucvGaQ7Bk387/S+crwuwppCRoOKm/U4yG9zwKYausPXi6PbPdXpGGu?=
 =?us-ascii?Q?wWx8sxLgrrFv4Tl0mm9qoDOvb3t20NF6Nq7tOKKXXJoCJMNc56jdagTQs/RY?=
 =?us-ascii?Q?cTRyP+Pnu3v9t4Rc4go4eugJKy0ww2Mg/4qI4fuLwqOtMrJ+CZT9gORqdimo?=
 =?us-ascii?Q?KEpvkqN/ARNWkWrBnZOx10D1he9G+f/m9t1sP9g41XvETNiVhcgBRpZcRfNy?=
 =?us-ascii?Q?nzLqy+3AYRnSIV9oeubbvczCW8lZokDaRP64dkuFpukIXyldRy0BZ42sZd4E?=
 =?us-ascii?Q?7BQkvQ5akl3zrnTKyhHGT3UxMtXouBBYfaDcXicN5Gd/ll+n8LZkv/UtFKHP?=
 =?us-ascii?Q?kajY1wL5NIMPJzIXek+r2M1L2IReKs4zI3RtwPDz+C1ApbD5VMk3G2U9oq4I?=
 =?us-ascii?Q?kjNLqTMG1W99lzZvkz36Jw7CPABloTSWgDWXrXmwKhJ5KYVI86ToVA1OwfZp?=
 =?us-ascii?Q?6DYR3+N7r6vwwjLmfjE4agPKMEpZEaORksJY9Asl5PIlJZeKuHNjtxax+xum?=
 =?us-ascii?Q?U93nyywbAw9Sd5yNtx4hjWXBPCW5X4fCi5hrOqiSO768jccIq059nTL9QN2P?=
 =?us-ascii?Q?P99Er/AYMLA0EcY23xs4zCL+r+8fLxbQ2EgKO4SAnwtSSC3emAqm4lczNydY?=
 =?us-ascii?Q?FAJmqhi8mVXK/4jGHTAlXX35nyUY/sqCWiqABBOE164bWKIgerSdWoNWNCJ/?=
 =?us-ascii?Q?3XoVVT2tZNIze1rvt/dl1Wl7QPm5EInbRUFzbCWTwUhDrzZj2Wv/hJiCilN9?=
 =?us-ascii?Q?7HbV3FwE3YYBZp6ZZ8KBb6aFTVMsGeIUc0IWBp/qj++ImL29Tmrm0MtZ37i1?=
 =?us-ascii?Q?fGJdyHf3GGRRzKoXELqMGMXz/ZsCCWOCW8TUaYQdXjk3DjI/Y4F30kKMVi4J?=
 =?us-ascii?Q?JBXFRUbJgJHMwG9vD9fFbpYSvgbtppp9ger5hwUvroM7E8+X+Ixt8gmHEGBL?=
 =?us-ascii?Q?cqV+4I5r05MBdvdMWJx0uVv4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae40b4e9-6105-4a81-4e0d-08d8c9f06bfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 16:09:31.2677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tMoxf8Qt4vvt/ZD81Z1J6U88gAlFWKMLsB4G/Ta5YBNGhyr5sbuv+cxnV3MG41xPVfNp129q3nWZeoYW9aOJIkACX+8RYfJEJAnGWdw2x4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4528
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
agnus
> Karlsson
> Sent: Wednesday, December 2, 2020 8:37 PM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; Topel, Bjorn
> <bjorn.topel@intel.com>; intel-wired-lan@lists.osuosl.org; Nguyen, Anthon=
y L
> <anthony.l.nguyen@intel.com>
> Cc: netdev@vger.kernel.org; maciejromanfijalkowski@gmail.com
> Subject: [Intel-wired-lan] [PATCH net-next 3/3] ice: optimize for XDP_RED=
IRECT in
> xsk path
>=20
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>=20
> Optimize ice_run_xdp_zc() for the XDP program verdict being XDP_REDIRECT =
in
> the zsk zero-copy path. This path is only used when having AF_XDP zero-co=
py on
> and in that case most packets will be directed to user space. This provid=
es a little
> over 100k extra packets in throughput on my server when running l2fwd in
> xdpsock.
>=20
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>

