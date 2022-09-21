Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C965BF585
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 06:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiIUEmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 00:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiIUEmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 00:42:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F93C7E814;
        Tue, 20 Sep 2022 21:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663735326; x=1695271326;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tbKQxnukv2PBwA7Mdw9B+nz9lf3PaxZ8GxkATrUMz9c=;
  b=eoi4L9HHq70PGmMzC8EusPaKNDKg5FcFIuhSuiwvED17eoY/Gl28bcLt
   AvXH+tOgbDodXCqtcOy4d5GYRK/DLyLIM9+fEaNBDHoulUjAiNZFeD3Nd
   ToTrewlm8XjtC3ZMkHKg2SmUuIut8tztwcQO/gsZPNS8pLxm00g85zy9r
   achlolfKqKCuwNQwBeQW4nEWOVM0AexQpnQXJixMIE+99SIkAXyPk6n/+
   hJG76/v2bOyzpKWr19l8YI5JiVg/bP4Bl2fzE2MjWD6/Oqc0tJ9oluz1f
   qSUkpRHZb32nCEF4esisqSabnfKGKbji5NtrgtGCX3BzTtEGv0yGlbZiW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="386182585"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="386182585"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 21:42:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="708284209"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Sep 2022 21:42:05 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 21:42:05 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 21:42:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 20 Sep 2022 21:42:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 20 Sep 2022 21:42:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZYNjNqrIokgoDaFKyJc3OEhw/fA05aLgi+oDzkiNCHHE4yYyBFlXiPhAO17NG9es6aO+Vsz1CgzFU17snV7MHhb6IPGRDCqwxrvKtrxhBzSOrZ4M152e6tYUe3GXGOeUCXD/f5Iw5R3sLTJyBdvKgZesYxNNhIc6N2jxYOONQNtv1aDwn1lQA2+Noc+54SENJYYXYem+H03qhuhD90OvpNxEqnb1FdayR3YAW02eMXqjsXjlf5jDTHNPRfZw+7Xq0kNBFHyXC/0iqdCTzqX+8OBd2biC6pB+Jfolbj4JrJrQJK1SP+QFsKssM9wl3yVLp+6Z8tdF1mRS3/6S1DOHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fDRe20bQ07CA3TlU8CZaB2/0yFeIlzqmlsCZSowolN8=;
 b=hex6UYar2hbWzYSwiA7rwz58J9ujimBM7cucpdtn6A+7lN/H81/65jhZl0XtjL20jq4f12TwnqG/+EM63Yr/0ofv3j+fGLxAnKlAUlkRyEq3/m9Eyo/qUSCAajlRLyUHPHXUX2Mre/Fw96+tweSUkKn8HtrjgNdNRVluV6cU3bkZqRxcV8+UO8vCMx3I0lh02MlHCR/MxY/WX+abD0XkgZRp6x5Sp8DmMwd9CzrMuizy5Iz/b3iIU+sC2j1bgETkrsx7y7hfiM8h3mtzog/lDMFTPiIsXFomXz+CakbV7RFktz6t0PtPjuLz0N90ZxnnoGE8CS8fAC6A1IszoMdkaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by MN2PR11MB4584.namprd11.prod.outlook.com (2603:10b6:208:264::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 04:42:03 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::d1ff:f036:e0a7:9af6]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::d1ff:f036:e0a7:9af6%3]) with mapi id 15.20.5654.017; Wed, 21 Sep 2022
 04:42:02 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "alasdair.mcwilliam@outlook.com" <alasdair.mcwilliam@outlook.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v3 intel-net 1/2] ice: xsk: change
 batched Tx descriptor cleaning
Thread-Topic: [Intel-wired-lan] [PATCH v3 intel-net 1/2] ice: xsk: change
 batched Tx descriptor cleaning
Thread-Index: AQHYve9gnSeJ4Jo9uUyaKzrUHhLtMa3pa9Jw
Date:   Wed, 21 Sep 2022 04:42:02 +0000
Message-ID: <PH0PR11MB5144EA7C4111E52713BABD1BE24F9@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20220901104040.15723-1-maciej.fijalkowski@intel.com>
 <20220901104040.15723-2-maciej.fijalkowski@intel.com>
In-Reply-To: <20220901104040.15723-2-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5144:EE_|MN2PR11MB4584:EE_
x-ms-office365-filtering-correlation-id: 7054045d-1078-46db-775c-08da9b8ba0eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VvNiCPdpzUAr04IUQ+1z7Rg231l1V1BtTeIypiezmhvVeRzY8YWNKOZBwWymo0WjnC2seQGG/Http4+fXdNBOQlDxhJ0ON8QkYI/nwH76ZQ0tjM0jg21by3NpHbDUi35Iz7gWnZy6HPfb+9amtZIdCGT8s1NlZKhoPcN865ihYCgJ0wpfHZXkDyqiJcmNFTTLj3f1pSJluyoODTFjk43jMmYt1PQpt7l6S5LAw6tk+C5DiT6tlpBco+r1u+GFwdoag3x00JDniGH2haTz0NK4PO7EeghFzHp62nf12TM12O6CM0uEXebPX3UsP4OXT5BZ44HlYNTs2xGJ1GGuNFQyBNmNNn9M04xCSC5MgvYLUSpt062t3Y69Lh8m/N9/fb4mCeMhYVtqiSMUZoLm+wqMp1tO4kKSi/MLg6SQrP8W4APUKLoNzODCKt+8DY+A11W8AfRDveBRBHuerd16tx7n/vWK9PXEWNzDiRYoAhzvrPbSQM6CmYwmpX3Ly9hngaUS4SldxcmsHNX43GGRYOpW9LWePxd256GRxarkFp33mf92QCvwSayIbPWg9vo/hTbyORmhTrH1VL5bKJqL4EWs2V2PbI/BxfaoQCcjE3VF4h59y9cy3cEIMWvlZbyOhwDa+tTSoDopjN9LlgByHEGiB6I/aRRscXwK1MCM2acP95Hi2vTj6J7K7BdHe+ed+ACem5Zhc36UAR5ZIwe3OU3e3Ism36OQLCUG2/5ajmwe0cuZc7G0ajRxnNFwlPTnRi/fFSIfHVJhAry2RYPiExWhUgjuwjGaF9q/2nMF0HF9J0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199015)(83380400001)(2906002)(8676002)(54906003)(110136005)(316002)(52536014)(66446008)(76116006)(5660300002)(33656002)(66476007)(66556008)(64756008)(66946007)(4326008)(86362001)(966005)(45080400002)(107886003)(41300700001)(478600001)(71200400001)(8936002)(6506007)(7696005)(53546011)(9686003)(186003)(26005)(38070700005)(38100700002)(82960400001)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xktHTo14kcHTqokOXhNJMc3z+neF3iAtHWQEANIR9MRW/gJWXzmnveIWQ5v+?=
 =?us-ascii?Q?nnEri5meaRwLmikwwUZEDjVkUi+VgY+Q59WWjpMF+jM4OGeMX6AehPoagKrq?=
 =?us-ascii?Q?Ui30CdRqU/KNQtUnWlQnnmF9pXK7ome9QObT2p30KWrCXtwQ66d3iVtOFVKh?=
 =?us-ascii?Q?77AIlYguvPxpdiKaxYwaV0i5OjaN5Vn6nl3uKpJz9NGv3lPHLWu1UCIT5iUH?=
 =?us-ascii?Q?uoJ6sqSrNJ58p+86QOi728s+tatTp5zxldNf08IYL94/H6ssgHZXuYlDEdPN?=
 =?us-ascii?Q?sL9Qu3akCtpXwcHlOzIWtfmX5prsSVyNytWfUSdJbCJJ7vJIDq1iM5d5hQ8G?=
 =?us-ascii?Q?VjiReIVDJGIT6ByLf+mw1bJclg56NBCH0wIG16Ty8s4GWwYd1akb/n7MAHYa?=
 =?us-ascii?Q?HVsG9UdHq5BMDBH2SU6PDvQjxrYl58XCvqPs2lkMppgP3kNX21dvOlku4P4F?=
 =?us-ascii?Q?eEeWPK0gHXIslyGvLqApgZALkWSBJZndWB3quMSg+5iMyjhupbjoePNIW/rI?=
 =?us-ascii?Q?BLhoG7q2FN09+GBvwkpNAAk1RnUNUnDGd01Kv/cNsWeNv7PflOac5TvxpDP6?=
 =?us-ascii?Q?tH1jJR7KaaV5Uty5lDg/emUy6iee649jrM33QQ8EjJuzTNaZmkb5LCFAqTSo?=
 =?us-ascii?Q?BUOXqnDIeLwvDuOfzy+2UlyDDJvonx3N/x/m1pIcL1BI2orJzi4qbvz86uX5?=
 =?us-ascii?Q?EcXWwJ8exMQVGPCCDbCetpjzHSKIG4y/YuKglMwP9RH/v3YiQtMJGC/jhFxl?=
 =?us-ascii?Q?M2qWDwKOFLVNhoOVNRk4KKw1wTjG6T0fSXJcGpIy3BrahAElTYEK4SMphhwQ?=
 =?us-ascii?Q?EDVs3iXZ4bbqdgaYOkhacUbNHSbraYrSYOClMzhahkxqTEOUvsYJ0cWIKmSf?=
 =?us-ascii?Q?HsACeQfRtE6pj9aDqteHKH0FxT91Sb8w4PWqhM6cRDn44dsMH6ayR++1Kbnx?=
 =?us-ascii?Q?ZdAFMea2RnFATl+UBRU3tY9j22AWeEmcLG/gocpJ3fb7RC9vi85rJdtVE5ky?=
 =?us-ascii?Q?IoQPqqwgn2aUsaGyQuw0ETsz5KEnMbUfgI+85GYvCogkSFQymp2GpkO4HPX+?=
 =?us-ascii?Q?khQ/u5uHV1C9ExSnj/JRba2Mcc89nnzn6yDelSqm46W1UkHt0WNA5S710+hs?=
 =?us-ascii?Q?YKuhXWL99dZatU9mECPNF4yoNonMmY6D420sSS0oG/mGn2x7PI8ZKDZ0kGTG?=
 =?us-ascii?Q?V2mmH7DbWv2tNMGsiKwYH1BhS7ac4dmvuifN2t71LRh+UHTw0OvygS1J1w8s?=
 =?us-ascii?Q?wyyvsa1I9qtapS81A+rQ9xJJ8WtY55+RozMqfyL+GrWetlFy04qaUmOxedml?=
 =?us-ascii?Q?TAvSSigOmyEaxxWFTRraq3fonOhXKn3NrtsdYqlgDLabFBMfdYF9luSadO2G?=
 =?us-ascii?Q?HqWbzLlynpWFQgiJKiXjNS5smETTmny9LVlEOObbgeaaWfwRpFC7J22FAXuR?=
 =?us-ascii?Q?ScDZTgn4wvXAbDvv8bkWNIazgz7dqaJ5B7bjleoxVDixdZjNENUWwPiyPrnl?=
 =?us-ascii?Q?/3D8fuYgn2m9IArscOzuuRVrszDouedObKPEtO5vkPeh5gyESaFg0wpv6Xd4?=
 =?us-ascii?Q?mA/xXdrEDpR0WG+rRh2LsOFSrRhYJNvelW5UnrIhruTHzOHOsyNqQBkj4b3Z?=
 =?us-ascii?Q?4Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7054045d-1078-46db-775c-08da9b8ba0eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 04:42:02.8267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hZkF5dDuqwd1EN1R+LBzE7JjUl4wwWc0qfLOW6LD61LBxusnxtLwlg5npmqQhc1Z5xt6S4heN1TjbmHF2yWJHZhmZ3xrr3MIifozO0drLf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4584
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
aciej
> Fijalkowski
> Sent: Thursday, September 1, 2022 4:11 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: alasdair.mcwilliam@outlook.com; netdev@vger.kernel.org;
> bpf@vger.kernel.org; Karlsson, Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v3 intel-net 1/2] ice: xsk: change batc=
hed Tx
> descriptor cleaning
>=20
> AF_XDP Tx descriptor cleaning in ice driver currently works in a "lazy"
> way - descriptors are not cleaned immediately after send. We rather hold =
on with
> cleaning until we see that free space in ring drops below particular thre=
shold. This
> was supposed to reduce the amount of unnecessary work related to cleaning=
 and
> instead of keeping the ring empty, ring was rather saturated.
>=20
> In AF_XDP realm cleaning Tx descriptors implies producing them to CQ.
> This is a way of letting know user space that particular descriptor has b=
een sent,
> as John points out in [0].
>=20
> We tried to implement serial descriptor cleaning which would be used in
> conjunction with batched cleaning but it made code base more convoluted a=
nd
> probably harder to maintain in future. Therefore we step away from batche=
d
> cleaning in a current form in favor of an approach where we set RS bit on=
 every
> last descriptor from a batch and clean always at the beginning of ice_xmi=
t_zc().
>=20
> This means that we give up a bit of Tx performance, but this doesn't hurt=
 l2fwd
> scenario which is way more meaningful than txonly as this can be treaten =
as
> AF_XDP based packet generator. l2fwd is not hurt due to the fact that Tx =
side is
> much faster than Rx and Rx is the one that has to catch Tx up.
>=20
> FWIW Tx descriptors are still produced in a batched way.
>=20
> [0]: https://lore.kernel.org/bpf/62b0a20232920_3573208ab@john.notmuch/
>=20
> Fixes: 126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API=
")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c  | 143 +++++++++-------------
>  drivers/net/ethernet/intel/ice/ice_xsk.h  |   7 +-
>  3 files changed, 64 insertions(+), 88 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
