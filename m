Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8624B64A575
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 18:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiLLREX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 12:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbiLLREJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 12:04:09 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1795710543;
        Mon, 12 Dec 2022 09:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670864625; x=1702400625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f3A3p4h4568dQz8hJuzyKhiLrl2QWgAodae7bNUWjiI=;
  b=hb39tjzZaEM6ZetwsdzeLXXdzlXsmbc0Cxc6gXJasIZsAhq8kQeTZDk5
   mrmsyFtlCEp7+rEMnlHCb6a+4EH6EDCpJR3hdefcmJwi8nWBRVDmEjPBG
   pcPXjEZOUcCqLQSFh9Mvns1Hz07eQb80iG4kf84aeD6LCJvm7x4dWyXCX
   ApylbKdXRPTNT/0+vypjr4p9VxmW/pjSF6RpHbM6i9d6jBqyEAVQr6+sf
   XO2GxMzQNkjwIxf4HMUDrtG0BVRO+ajVdu5ifb7GbpMaqkCquC61XXQ/q
   7jJlMy16+614YE1o9yxdC3AO9yxdM3GhWaYtLrZ5yn5Sj/G8wJftcgRDe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="404158810"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="404158810"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 09:03:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="737040786"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="737040786"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Dec 2022 09:03:42 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 09:03:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 09:03:41 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 09:03:41 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 09:03:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jz8PBKmQjl+cCnCE2TqZUjYoI4i4s6wHeE2TaAHgC/XjGqa2lwLaVYWAjBXXINW1w47uLbvopbFUULEme6wZCbLjJzlpTCRbqIjo4nEoahsfZy04HoTscYx4M1hfrPNKveWTBBN2selmOkY5jVCXAZx5DMo/zR03cbv3BWinbYiPy7iVwlmTd8E9bl5nS/1hPZYDLh7hiq4RsBetotM5Yva6Z2J2HdABHUSn78oX7Ep+a/JMWd2jRlxnBK26/6BIhfaVZT2r0sfNv1b6UO+7AW77EviNI3X5SxMrlegmGZu2lSsF+oNHLKhbBhaz+kLWGkWDTChhVfNLz+vzSLs96g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=udCG+uC7B0Gi7GE5BTQNBtIxL88p7VMajuefDwiV904=;
 b=PPo+4CFTluAxNeu0FDeHtCgZT0QsTCE6u9wXNfK/YrUU9f0sTZkw8n/MU/XzQ2rx/z/Iim5+wQiWSf+jI9dMvbe8bnGrvKuvxAjdXcbYu5aStLOZyQoG1p4y/61Ay6I+1ibLgT6XtZ1aIH2+gjd78hTCVa1OClWgS3FYgZRdpSzWB4HhNziY9YDW2k/yDS+N65LNuS9HwaCPWEERuSB0Ae3ypQNM09dyZCLfl9+Qdzm3Pfde3EI9kdYY4dybmDCtmkf1zBzJNH+/UGUCImTtg4RJAROqzGgzohRfKWYJ3ElZJkg7kX/CMAKpXjS8PXmz/TEDdqLG3XjBX0sIugjzSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by BN9PR11MB5355.namprd11.prod.outlook.com (2603:10b6:408:11c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 17:03:40 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::1bdb:fbd9:b48c:6e6f]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::1bdb:fbd9:b48c:6e6f%7]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 17:03:40 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Saeed Mahameed <saeed@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH net 2/4] ice: Correctly handle aux device when num
 channels change
Thread-Topic: [PATCH net 2/4] ice: Correctly handle aux device when num
 channels change
Thread-Index: AQHZCoBpTdDa1UJnHk2WsWg1c+9BN65jAKQAgALHjtCAACugAIAAATQAgASNM/A=
Date:   Mon, 12 Dec 2022 17:03:39 +0000
Message-ID: <MW5PR11MB5811C27393271A563A009821DDE29@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-3-anthony.l.nguyen@intel.com> <Y5ES3kmYSINlAQhz@x130>
 <MW5PR11MB5811E652D63BC5CC934F256DDD1C9@MW5PR11MB5811.namprd11.prod.outlook.com>
 <Y5OMXATsatvNGGS/@x130> <Y5ONXuY+TlvOx1aV@nvidia.com>
In-Reply-To: <Y5ONXuY+TlvOx1aV@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|BN9PR11MB5355:EE_
x-ms-office365-filtering-correlation-id: e0122de6-e37f-43a2-905c-08dadc62d119
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CfZGRnedeV1RoyrPSlk+7DrKbdM5Tj8JXn8kDMwA2bHmObOvzkJ0y4b2cshJrjD5V5yyQ73LQJ5Qlg0qzu0g8Y02GYzzSp4QLAvyOP+bRwB+Wv3T09dur+H0W29UVansmk0qSD/mrfg2DPDOBirkx3ZuedYMe7cIe6+MvNDUqDDGTctZNsJfjCM5OmGylL8f3OBn6+uLjKzp0PKyWh32+feZ2wayFTrhkW5K9Mxc75lPZmDdbgCEtvqWy+mbE2pT7Z2T6jYwAjZUDUzuq0JJkld9RnNlEa7zBWJJK2ADyKTj+r6y2YrmHfKN991VBWToxnnd55diF2QLDniJMCv0pdH5IeB3DrnoFLqYwgV9bMKuXB3CwpRkgCiuXblBOt9YqMZLdg1HnMyaWO7YZJD4XA3zAdibw8EzQTltkO8yvn2vPj8BPwxoUSWERals4xmAN1Mg6YLucws/YX+ZESM6Ajt2omdMECMYJZaA5FqkuaiTalRJ6zRAi/RRdiYvoxogITBl6D+2HEbjew/B+vm0002PdbqvHOubtb+g9QBzvACIAFEyPSowu+dhASxWU1bddMaI09A5q2y1afU6FxwAo7hkA6WRv3YHFuTqeEd+LfnVyXhIaFqoiyeOTYN9sVgyXkSbE68i0yV9lsK7PdqUvJ2HNFKuWDzwfPJ9FPCHux2d6KPtGl5CrcVBpAgLw7rFeybApHbcrkPiN7SrGPcK4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199015)(316002)(55016003)(107886003)(54906003)(110136005)(2906002)(33656002)(122000001)(38100700002)(4744005)(82960400001)(478600001)(7696005)(6506007)(38070700005)(71200400001)(83380400001)(53546011)(8936002)(5660300002)(52536014)(41300700001)(66946007)(76116006)(4326008)(186003)(8676002)(66446008)(26005)(66476007)(64756008)(66556008)(86362001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pmbMv2ppv8+uYEJQzSqOTkdZxhx9A2FIUr/f89l9M+UsS5UB4xKgQfr8my5g?=
 =?us-ascii?Q?iggvVa69z22WijKD8Gb0jkJTe1MH6YqhsTz59q/V+xFX7dIFW/tIWytv52zV?=
 =?us-ascii?Q?vgGhCco41MQYSvANtgKThIBQrlQeaiD3KkCp0l5gs7ew6ox6Qa6EJFxm6p1G?=
 =?us-ascii?Q?3sjpY9vTJBLBw5jaC/TyChV1sv76fTo86IL+Uv81R7S+4aHNv0rKvYgU5DfP?=
 =?us-ascii?Q?tVS6mD5w22EjVhbuXGBz4xwGpS1ctT/cIF5yLU29C/hhLRdqOGviAaqT5EBk?=
 =?us-ascii?Q?H2VfnGIfCOqMpj7sn69WZ9kAzqYcXbUESKejv6utP4zZgEArNc6kPsGO/bRC?=
 =?us-ascii?Q?gjlgAGQqYrIZpGRNjqPRkc41Q9vph8H+ELFhCqup2kjoaTHw8cpgyoYMWl0u?=
 =?us-ascii?Q?J5hhXwjWs8wCnnD2R/6hHaGFnpT+B/S8JFQMFz068cKoVxrA0BNhCY1acBD5?=
 =?us-ascii?Q?WuvLkwvS6YM62H/cCoYO2qelSZH359x8Xf+9+7ABaZI2A3NGkU2Iuo3+3LlT?=
 =?us-ascii?Q?sAfLlGMD1DbnAUrAdhdPPyfv+CjACKEboCgb5OuMHyvJg+WCtz+LUCiRHx1d?=
 =?us-ascii?Q?M4vgrRhko20bJcszBMGX5cFlXs9XYnLwuk59/VboJJKhGFSt9x8nsZ8AUJBd?=
 =?us-ascii?Q?Ycwn33yQV4rL99Hr2IH02NqgQtv9qJRMxeQoVZ/8T0Ch1SDGLTNbrSnZ1cG4?=
 =?us-ascii?Q?5Gcj/QLW1CxVprB9oMnaZ8GDCPHlZBXyx2EuADZsEAn4z7y4lTg/S3/K6A5s?=
 =?us-ascii?Q?EbeIqi5MSzy7R/eKN8uioap+B7tqmENlSjF6gMSQdlq2pHpEPyO+XKlzvJzl?=
 =?us-ascii?Q?RdlBLNuDJf8E29xbnKQHdmOcpXET7EmOfTOoqFXvQnwZs47CVqYZ/f6CKmFy?=
 =?us-ascii?Q?nU3RkLzpZKNT4i++gyYhlrx/ihnPhDI21BIZ1i6wd/vRLBEfvfN2b5cVWmYo?=
 =?us-ascii?Q?O64ZbyOdvmSZWnQU2mdeeCuqzHWI6OGO9nhm+FrPA+dtw3vdDjaJZIKOFNf3?=
 =?us-ascii?Q?16UKOsX1ZBCbFnfVi25dUUQ5QW+yj8cWeioeSvQ56M4EEEiccQj0LJ+eJVUN?=
 =?us-ascii?Q?04PJt5oVcAqNHrWP3FVdxTkNcNtDclQQUejRHoJMX4CDORVzJuzmMAif8DRg?=
 =?us-ascii?Q?vzmEN3MLQ+fyVl9OimF/sB+dHPlq/tm1moVUZNtn1l6Nw3CERL0j4IRmEIHo?=
 =?us-ascii?Q?BbymEX4s0at7rmTM9jtMmG0SQMqKCiq/t5f/zUp2hTwVlNgJxHxZLaSkZ//p?=
 =?us-ascii?Q?5bcBRdPkLDMpqdL0FTvM53uAQCXMAOW9BZgg4hshPkMyOIHNPW+9tvCJ5kb9?=
 =?us-ascii?Q?K2IuxOuIQKB6e7q++gwvutWTqsFqvUiUuXp78qgwA4I3Zveb1ifHBpmV+jt8?=
 =?us-ascii?Q?KqRgWkC9LT4hqQLrmYxaQAGdqPY9+Fk5Iy8gkSaxEkXSPXyHk6GF/Pj8obg3?=
 =?us-ascii?Q?MB4yjPFGv3tvQ6btZsNo59Pqg2sfCNlQytkjWX1nsgv7Q1ome7bulYJXxCwQ?=
 =?us-ascii?Q?tJJhnz4+C7eBb+JyAeJZ8CZdUA2WPsP5B2IG5/k9pWNnXntjOgTtd6Z86gP5?=
 =?us-ascii?Q?5HH7rdoKGf5hLxDQ4LPqJwUwLYGnttpls4F2jSxi0qRtKwn8XkEhR633ajNn?=
 =?us-ascii?Q?dg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0122de6-e37f-43a2-905c-08dadc62d119
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 17:03:39.8740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qZ0tz+NLcCxlfczw3xCyoLdzbH4rXKei+FNjG7Uln9sIahKyVXAoGVCt5jCOPXkYEtNua6QEs8aUTG3QO3zbv6dAjG8WBqO+MZHnlm1+7wI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5355
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, December 9, 2022 11:33 AM
> To: Saeed Mahameed <saeed@kernel.org>
> Cc: Ertman, David M <david.m.ertman@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
> pabeni@redhat.com; edumazet@google.com; netdev@vger.kernel.org;
> Saleem, Shiraz <shiraz.saleem@intel.com>; Ismail, Mustafa
> <mustafa.ismail@intel.com>; leonro@nvidia.com; linux-
> rdma@vger.kernel.org; G, GurucharanX <gurucharanx.g@intel.com>
> Subject: Re: [PATCH net 2/4] ice: Correctly handle aux device when num
> channels change
>=20
> On Fri, Dec 09, 2022 at 11:28:28AM -0800, Saeed Mahameed wrote:
>=20
> > IMO it's wrong to re-initialize a parallel subsystems due to an ethtool=
,
> > ethtool is meant to control the netdev interface, not rdma.
>=20
> We've gotten into locking trouble doing stuff like this before.
>=20
> If you are holding any locks do not try to unplug/plug an aux device.
>=20
> Jason

The unplug/plug is done outside the ethtool context.  No locks are being he=
ld.

DaveE
