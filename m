Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4FA583D57
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbiG1LY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236128AbiG1LYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:24:38 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6492E6D9E8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659007321; x=1690543321;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q//qMIFl0Rt2W0j5t2lC0f/mU4V2SmDZskoVDiNqVIs=;
  b=RRSu5TAwMQba1X0wp014HVExPvMrY4Pp0BUpnknwqEnB3/IcV1UUmlzt
   BbACnH6IRvL+KdqijfmpBsZSKF/O4os22FCJ/ZEDrIHciWbXQbOIjbkeV
   lPK5SC2zJWncrlVixVu+4zFN3DGSKiEi12G8SDKyaim5K2smhUIqtMxVm
   iGqQyEeR1oKdtwJo0BdJOuJ3Ch7Pt6QsOusKHxnaOoO76fadbUsx7dFBx
   683UY0eLecVHilAVQjLVALhOHF2bNiP6FeHeMYjB1RWLPLRL246nQjJuo
   V40ubEfq6dzYXNLo9jTWB/7qyd8/PQoX6Zefevb/SV8zsFbmgRtE7AMlf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="350191954"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="350191954"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 04:22:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="604524510"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jul 2022 04:21:59 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 28 Jul 2022 04:21:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 28 Jul 2022 04:21:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 28 Jul 2022 04:21:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAprjzm4REp3XUsTVnfGlgK694VE48LNwQZNrBm95kGlLInkxuBPC1qBv5ROK9ZQY+Ci5NzRldctrjFNGIcM/vviik3vsXb08VgMPWhX7TbjUyOOdPUs0aI9aefOLrZJlnQ6Y5EP6blWqA8W6jF5/lneZjw3KQNoW2WMF5aBNZ3gOo/a2jZhfugrg8Dz+BxebpRRzbbuIQuCqQ5SH1Q57v4zJS39kwr/Pi4BCBMGbde9IP81fnWZGVjMWIZ++xD6L9TUDITa2QY+uhShHAHWfG2dJoPoAL871WGvIsCWm/YCnU95pbpSrj7tOA7w8Wj6jI8IixdcqdejC8NMsJA2Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q//qMIFl0Rt2W0j5t2lC0f/mU4V2SmDZskoVDiNqVIs=;
 b=MT4ZrQcBHJDZB1rcVt1c550D2s975smn1zcIMB91C+FLUhrgZf2A6hqFPppMvK5vW+04gkfNxgewObaT2CRaE2T9RUxEAS2gPLC1uUDDe8Ll0b+8XgF4GvZAeSV/H3AHqVhVN4DfDikMSgqhGTVSkxYbbMQqnKAr5XwoJEcRh9vqpZlFy2aPncHPP7xJN4J9TU2drEbaS6B9/guKGRA+Wb2w0i+VKXTJtCBIsRwgW8QojnvfehFRf8nu+xnKvbs0eF7KEm0HpQLenKasUNBhtuMkmFbk5DGtNQ4IJKuYS7yIpb/fhxb9qtx20v46QmSVJG0hEgPAdPRpMKWut2RUSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by DM6PR11MB2905.namprd11.prod.outlook.com (2603:10b6:5:62::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 11:21:52 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::d9cc:2f38:4be:9e8f]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::d9cc:2f38:4be:9e8f%4]) with mapi id 15.20.5458.022; Thu, 28 Jul 2022
 11:21:52 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Guillaume Nault <gnault@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: RE: [PATCH iproute-next v3 3/3] f_flower: Introduce PPPoE support
Thread-Topic: [PATCH iproute-next v3 3/3] f_flower: Introduce PPPoE support
Thread-Index: AQHYonPOzR/tXIAI6kuB0yISjEgfbK2TowFw
Date:   Thu, 28 Jul 2022 11:21:52 +0000
Message-ID: <MW4PR11MB5776C1D8CC2CAF39C05F3928FD969@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220728110117.492855-1-wojciech.drewek@intel.com>
 <20220728110117.492855-4-wojciech.drewek@intel.com>
 <20220728111827.GF18015@pc-4.home>
In-Reply-To: <20220728111827.GF18015@pc-4.home>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31638174-765d-49e3-8da1-08da708b5ee6
x-ms-traffictypediagnostic: DM6PR11MB2905:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qj5lPThrPH8jiULlCE1zoSYC6Cp4ob1IK0rFOpzi4FLYtupMiE9gurrdxz2QYz/MLHVvutqpB68n9D1LclPg7WCHvq93ztZms5hNzJ0DlI8LCffkfEos45GXgMDDIuM8YhjIiL+diZNnvPLl2bAEnlXsbwVvqLz08BIK6YA27naEeYEzMVHVmLYRfeq+ar7ii2vBhAQsh93dndlaEZYyrnhI4W4hakfmOLM+Q49MjyWOK4Ubap/s173UMFQjDqSX3z3GbuJ5CfGZYh79fpVOBME0NQDF3bUedhGf6OiwXhp09hPh/BEHGQZqm8Aiz4rerQVRyK+1Xi5u+oC3LJvvP7nZz9Wx6WFolxaZTR7CWxPOhTR2SZt8LTeY7Ukj+9wi+U0KTSkiIK8y19Q4BFk7OFek29BCGEFLUAyzA/3JoAxLoLHsxqL59XxnqqlPUuVjb22aXZBi8OS7S+qCtX8zLrz1it7uGTrOkGovs1mYO2MdquzHGpSlnKcmV01qPtX3SUQXACY8ccGVPItMooeEFn1KVoqEFaruA64POWfT7EV+ict6ECJmUWNbwZ1Gj5vbEy9pHPDdyTnU+7S/RSEFTo8DzJB9bzALMuFcN3isG2kH6nTv/p6GNclkltbsPAQsutEKz5giWk7NIVpZoKfdBgfYihtQhXETz1lX3/uyKiuUMIRuSx4xqKehpr828vYi0tFcxyoIeFBVOb5z1ptHqCZf+7dhoLjYQrwn2CB+hyF+cD3z2FUJi7xEy/oJggVD+AfMycPNoR4i9ZfBDZYVHTs4oj1tYr4B3ghGAnhrWa+SKhsuqgaqXMXQAUHlagQP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(396003)(136003)(366004)(6916009)(54906003)(316002)(76116006)(71200400001)(86362001)(4326008)(8676002)(66556008)(66476007)(66446008)(64756008)(38100700002)(66946007)(4744005)(5660300002)(38070700005)(52536014)(8936002)(82960400001)(478600001)(2906002)(83380400001)(41300700001)(9686003)(122000001)(6506007)(55016003)(26005)(186003)(33656002)(53546011)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AwfpKs6hHHfFuIEihYHnhG1nvFx0AIRauqargTNF4OnjkfeiEGbiOzFgSLrQ?=
 =?us-ascii?Q?rMrJWUWUiiFoQmh+so1sZ8CR6IkVjeYjS4iPlZKFkolSzhMSeHflHDmx51Mk?=
 =?us-ascii?Q?QYSOdvBhYSAF7/hZosaFgSrxH17EBBJXxRcKLFhmFEl/4szuZikuP3xtJp/P?=
 =?us-ascii?Q?Bz+wTmdZDWInA1p/5KnLsw5KDciAU+/B+ZtVnsXGDUeeZ5Dsex7nUvlN99kB?=
 =?us-ascii?Q?acQKimK/Jo+An2fG1lZKa/UysphoS9gK6/nilLhuWeI1gggMFg67Lx/8Nz7k?=
 =?us-ascii?Q?R/jEni3OVoxprynZ2Am9fVpOEg7URtITbde4sqxrBag3NLv0u4ncElktW7Qu?=
 =?us-ascii?Q?XG/qzWeaTW8WXU0+hePPD0Y/IJtShPns1QKJ+B+Yv/A8itzqYcivH7loujXr?=
 =?us-ascii?Q?yWY/oWNQVczG6k/fjgkSu5xQ4VOSIVcRQI4J0gmgx5rvT5S0R0+yEbJgcq45?=
 =?us-ascii?Q?hgrQZMqQuxsr+9lHOT4OfWaw7wbF/StVaw37hpeeFCHpYBg4oRU+U035Bejy?=
 =?us-ascii?Q?HZd5ywuvvHSXWtxtFkBmRRZ8azp7A35Sziv3PCLK+OSA1TFL0EDSndPhNgH9?=
 =?us-ascii?Q?8VPDXCTlQvXE9fLjf+jh+dfTYlXcfhrCHV1wyjI+El5hx58b9EsFpXoJvWrw?=
 =?us-ascii?Q?lD0Y4uxrh6OHY23y9bsd/vWh8k/fy5RepeerLheLZ5xcQ8C+4l6SpTdXDBk3?=
 =?us-ascii?Q?jbx3cQ4m5u4/jj34zfYpjVVa8feiBx/yUNKg2Vh8AAOQ/9yN9pEusrJrulBh?=
 =?us-ascii?Q?3/t8cEDtHTI1lxoWLHurnFVdXI7NVcrhTlBE/J32uVcqplZ8LQj8CqukKnsG?=
 =?us-ascii?Q?gyTACwZlBHPftaJLWl/9qXMOV03IbEZdZZROLEtqjzQbN3YMtiG9SKaGjCQ9?=
 =?us-ascii?Q?HoO/34Z2y9sxhdjD2qDG0hmIQSj6ZTC9nBwWWltXMD/rN5U9XJzQxGTjaRrF?=
 =?us-ascii?Q?o+AvBosyQ1lwTXSQkigVnbEIXsZmPjUTebSfvjvqivWOwE0JqEJJRWD8wk87?=
 =?us-ascii?Q?Rv/nytOE5+0Gt0e6EcymScfpYngQEmSRKHgltoy017UJ4D+AYDitxe3C5nco?=
 =?us-ascii?Q?zkI8jEfRt3/Jk5Mib5UYDPBTSo6XqlUCzCyL4fRmaSpkStjc0g/St/nAvT2o?=
 =?us-ascii?Q?aO3NLpuIAdCHHz7Vck3i/JrpOe+uJNL1qhmDwk5U0zMcWgO9sRDhX/VpyvQp?=
 =?us-ascii?Q?ZGLv2OVcMcpmhIWmi7bLZ6z84lf8z+OkBBoNNp62kX6sFdfyYuack6x3jZH4?=
 =?us-ascii?Q?aguA40Cwb8s7JE2SFnrggOJ2Uja/EK1oExmdVkiTtazA9LT9nvjfqdXEU521?=
 =?us-ascii?Q?cxf6M7Cpk7CbpIybggqlpANQgTkqi6bxacDnKCPIo6LsoJwqFkcDu0YSivRv?=
 =?us-ascii?Q?5C3O/A0MAWUbT6Gp3sGoMP8cNIVIWQoVOSvOHSwCtgcTBzdDnIMAm4Aq1fGn?=
 =?us-ascii?Q?r9x5HdzpxEP8+R+is0+nxazUWFpKbSXELgY+PHTCxwy6Uhy1ybb01IjmTpRi?=
 =?us-ascii?Q?5rW68K7faGzg8KJF9P58/GSO/E1rEXvQcb5q4OrZuFAHV7EELaXJmqrQAmGo?=
 =?us-ascii?Q?9WeBP1Cx8aKHA7vK2xabrJy++h3Oed7YosuFxsQ3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31638174-765d-49e3-8da1-08da708b5ee6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2022 11:21:52.0810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uwhQq8Ti3mmysG8c0jt/PHyyXk7GkWu8qtryv1XzFh0H9q7YjZqsqOIW0jmgmuHHCsmFjoYbNHY2a/3MopnOju0i3l7KXaQmyDcndApdaVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2905
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Guillaume Nault <gnault@redhat.com>
> Sent: czwartek, 28 lipca 2022 13:18
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: netdev@vger.kernel.org; dsahern@gmail.com; stephen@networkplumber.org
> Subject: Re: [PATCH iproute-next v3 3/3] f_flower: Introduce PPPoE suppor=
t
>=20
> On Thu, Jul 28, 2022 at 01:01:17PM +0200, Wojciech Drewek wrote:
> > Introduce PPPoE specific fields in tc-flower:
> > - session id (16 bits)
> > - ppp protocol (16 bits)
> > Those fields can be provided only when protocol was set to
> > ETH_P_PPP_SES. ppp_proto works similar to vlan_ethtype, i.e.
> > ppp_proto overwrites eth_type. Thanks to that, fields from
> > encapsulated protocols (such as src_ip) can be specified.
>=20
> Acked-by: Guillaume Nault <gnault@redhat.com>
>=20
> Thanks for working on PPP/PPPoE!

It's our pleasure. Thanks for your involvement in the review!

