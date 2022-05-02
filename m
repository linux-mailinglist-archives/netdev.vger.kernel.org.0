Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2E55170CB
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 15:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352541AbiEBNpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 09:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348415AbiEBNpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 09:45:31 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE942BEC;
        Mon,  2 May 2022 06:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651498921; x=1683034921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L/KgHbLqKXXyapS4sO8vnZX2hl59qGyVXcRvqUThtoA=;
  b=gySESfxqr48iJPQgGtZjm3ONOIv/OIhTPV/4YZGK91wnGQfPLoA5Psqb
   L3YcdJuxSBO1RrApsbHvkVqtu6ec2Ha1TYTitqD9BMW/mpBVV90lsJuBZ
   OrvlXdYM2caJYL11Q1eBXIN2rWA3rIAqG/reqvdA9APgfPMMsjwx5+H+P
   33SWMcpBXrKSR36P4JfC1U49ttUbOT3thCi/4SeR0vLuK3Z3Gt8ll36Tq
   1BZldqVAYGlrx/eu7fiJaMXq7UYZTewepb1aTA43ljZm8qvv5lqMUhCse
   Li39NaFd4a06v73Q6ppubEU0Dct+iMmnVUEzX30HPbsBYi2S65OtLEpVT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="292392627"
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="292392627"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 06:42:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="733433516"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 02 May 2022 06:42:01 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 2 May 2022 06:42:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 2 May 2022 06:42:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 2 May 2022 06:42:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 2 May 2022 06:42:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJ1uD0leU49ZvDvs42xy0E/efnazGf4cUtu9lhUORh4MVcOOxVOyo8a1CdKR8V59TNXd+oCqxw5M3wzYiLnQCY5omDXT0gigldFEXERSGcuGRN5Pqfk2G0ipRg8DHTLusQOCn5kuMkks4qeYzQvZ/V7GmGSoIO+cmVVPNRA4YV5TH1So6DxRcCSm10z+3FWpfqs/TcJc+T9Jhy3hEJ26JCGb2abhkGU21Q4WG6twoMP6hdAw/aNs8ppyresaxfkG/Ozmb51iSy++1+hzVBXTzU5gAD66KWQYku4YH2hzZPzoCioy6espFjIBXE8/KAaUcFhUvS03RW5hHgKpY6TGxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZKO8KumteCmPzof9dQoXBMrEPgMJC3neiqVCPOEBcQ=;
 b=Zy7HEhrI1C2LsfR2Em/uOCughigTplTdq3VefDG49/KXj7fOh3O/G93cWkmaGyWnkXwwz893JV5PrxkthP9rycDbDMqMR1wxLSbsI60+bkhcrUBt+G7mGEd1ULLNgu0ZBYKEeN8ME3xINmNrrg/61svpfnYxJlxsJ6f5LUFw+i6p1qTyzwLEeHYa3lzrzD6loh3DDZQYuP9zPBQL4zXqPGZgPYMVlsnvH/5fDu3HwRk6hY3MtbcP8/HJN2e0hwUXR3fp0TWXJzGw6GWr/Yvrn/1HIkJIAJEHPX/vBdBlyx1hMIqj37GR7B5Sol6/lRO2ceZKelzB9kysvNNMe1h89Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by CO1PR11MB4882.namprd11.prod.outlook.com (2603:10b6:303:97::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 13:41:57 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 13:41:57 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        mschmidt <mschmidt@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH net v4] ice: Fix race during aux device
 (un)plugging
Thread-Topic: [Intel-wired-lan] [PATCH net v4] ice: Fix race during aux device
 (un)plugging
Thread-Index: AQHYVvvSP9/hrK026ku0d+nsQE+Uzq0LpqaQ
Date:   Mon, 2 May 2022 13:41:57 +0000
Message-ID: <BYAPR11MB33679575EACCE0581E710D83FCC19@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220423102021.4056946-1-ivecera@redhat.com>
In-Reply-To: <20220423102021.4056946-1-ivecera@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24695ede-9410-4005-9e2e-08da2c4186d8
x-ms-traffictypediagnostic: CO1PR11MB4882:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CO1PR11MB4882CC0742004EFFF0B5474FFCC19@CO1PR11MB4882.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E3PMmv8P25YNkV2hDO9sK68kuS/MxT5btg+mD963gXY68/roO1xeyL+gvCxK0hLVf2Xz1/Btexsx8WG3jhITSXD1hr1Q8y62topvwMJcuI4fBoB6t8eEDJBxP/EMxsWQcUnkw1EOM3H3vrxY32MPqhc1HTBY3rOx7kMeZiAfTwZbI0J4crbmWPt67No1gYONiVoQP5xScsNslmPRCgd75wj4O/TmWoRYocotd4yEJEtohTyju+Obi527W8tVe90alkseMTZ41NYB3ftAkUXeub0NyUGDD/d2/MefOb5jNMT5Rqx9TFKhJfsHEFBH+xZXJ8lywbqglI3MnKyexxrXsUDHpaT/EwUq8HFk///ZLK/NeYi8YGTc8zdvPQ1pqn+YFk+L1BX9B0zAmbZhXMWlVs+Po5vJsM45S4Dl6p1CoTkC27pPhoZ1IyF6IMhlpq346LBQaH56ll98rxIpyYmpScb2aIs+oYPF9gfE4hOiK07VLE9pq0FuMZ5EmmNlxlfpurcyCA5JeCTM+lCedEFutuw2FcebF29GjByo4aYXBlaBYy7rZMuBpH1pLq7IjVFYwwjXCbv/e20QEsyHLSeOLEPtDAivtwNzBbz681roiSLiHMKyqcdw4isIiUkdYdSEmzZP9r7M1Q6p+/1+7NL/y+hQ38ocLYgtqEOvz91z07nr+DadsCOsyoC9qDr8R9lOQJG0Eo69imI7OreT0/NPMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(110136005)(26005)(54906003)(508600001)(82960400001)(2906002)(122000001)(38070700005)(52536014)(6506007)(38100700002)(71200400001)(186003)(86362001)(83380400001)(9686003)(53546011)(7696005)(55016003)(5660300002)(76116006)(8676002)(8936002)(64756008)(66476007)(66556008)(4326008)(33656002)(66446008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wGIihok+wQvyFIo7ouu2Vqt+Ca5DyKJ9x1u4cNRVsdltUKotcvzuvbNXTZ7h?=
 =?us-ascii?Q?ETpEXYbtpMPs/4Y2riioDiMfLDZFZ3yIeNJ2BVboJ0lLO/MPAkkIdqj9+uAc?=
 =?us-ascii?Q?Ts4p9/FHScoQztkTK5Ni02NRxO0vmpeR/7Dbz4Hadqd2yb2EPYCYercQuN2m?=
 =?us-ascii?Q?pdoAIAPHGZFre47nsQUuGTcK4EFWWDQPFte6iGKKUhiIpNDdKqNZE8KDKKwd?=
 =?us-ascii?Q?B2xRbOPBka7zJ8ZqS/mXFxdFZXj4LQ+hE0lhrQy59fKsU4jtrJ4+YoxY8Gle?=
 =?us-ascii?Q?4IicxfBFHjaZxfw0d7XR9w5gXnH3jnD/wbvAWgZTqCfNJsWhkfl6TFt3/jKc?=
 =?us-ascii?Q?Z3cAWRnCR2eUHwASJAxanU31fQGYW7owqGqsJa20DbKuSZK40Kop+E7AAx0z?=
 =?us-ascii?Q?yL7No9b3tqR6SOubpR5/DotCtALHhTDt5Adydy+GnfsWjpYdvfKWrdGnfSS8?=
 =?us-ascii?Q?kNtq7o9OMK1dB0qpU2gv83BnywqurbTOSYPD2J7Rm0UrEKhDeMXL/puX37a0?=
 =?us-ascii?Q?U6EznhKKdtQ/2+as/IcZmM9cvQzv44GIyU8OQ+CLTNwqrY+mQV47ghG43lkq?=
 =?us-ascii?Q?KKlMgLi9OuOTnnXcG4JarVd0Qbtsxp0VoS8R3W4Cq4GE1cofIMyCI/BQya9j?=
 =?us-ascii?Q?xSakFDpBOll6MJpPqYCbn2qnJaENZNPeKO2eSTIXFNvcQZeVIPXhCZeZjsFK?=
 =?us-ascii?Q?F8eJnLEZrR5vJgvWubB1xiW6s8IxIaPkkHftPmvnw6kvbvsyMV6JlCX9NOCL?=
 =?us-ascii?Q?lPg/rs572GolEs5T5RkgKLBsLmV792G5gxFSahusB2wxe8r4JYEjpSMjndQX?=
 =?us-ascii?Q?kQ7kxsNocRz1LpkD6kCeswDW/dkn3GUerIMuZBW2zDv5Ll3JAvhj9sFguxYH?=
 =?us-ascii?Q?XFH4pJM7Pr76Ekm/0iwHZqac3V9e90eF81blEosOOjPLzlr2/BXhUeRif9V6?=
 =?us-ascii?Q?J52DHjsI3gu2X4dmc/e4l3vQlv4C2aoqluVuxDwKFb34CafPU0WtY4vlDg3q?=
 =?us-ascii?Q?TxWPgoI01yOOHNiiURsdQDUF2qLp3ataKEZC/+fJYSVRYR9v/pUe5AjNSXh4?=
 =?us-ascii?Q?KGD+Dx9x+dax/A2ftaDjUsDgxvQJoAB5BPSNqJtjGG4mGPot+Yzcq8Dvg5Kl?=
 =?us-ascii?Q?Zq4QFZWipyR2gUsWsSvIbKxccjxq/3Stlr2Cnswev6nuTMI5an2I/DgXczj7?=
 =?us-ascii?Q?YLQtOBfvqEsg6Mjmvk7s9E1Fhz7aJN3pCa5yQJ8SitE/I7h/qeUpmv6pf3We?=
 =?us-ascii?Q?oyPVCrbn/8E8pV3a/Ab8/SE+MQMb8mCHzAQaNxVFcOKi3M1JVGnFp3iG8EJj?=
 =?us-ascii?Q?8MC5NHPB6B7Sdz/lFz70X6HjPN9gaR4pOxsvzyo7kQXJF5Ite0cC6PGqpnRq?=
 =?us-ascii?Q?/CY/A5A+vsP2WigrSxfmEMELcqa1oXe4G6P/0EpXV7j0jMsdu0UGu3V6eLEQ?=
 =?us-ascii?Q?BV1MMC/EoxLr1bn6zE1sHRukw5Al+AE97rWhY7SB8UI5sJ+sLelNG+q2dhNJ?=
 =?us-ascii?Q?6T86m/DNDsiWnrFZITXYy+KeDRSUVnAp4IrFe5BS/dNiKuXiHsjXv4pWKcI6?=
 =?us-ascii?Q?4DXvoPaKGR99Z17fgXN1GEx4oV1+ccNgmH8waMIz0TXjHR4bQ1HaeN+KQuqi?=
 =?us-ascii?Q?4e6t69rqkP3XunjEK9YmvRIkSTOcV5sQMfeD1RVtBtu7jnOiAh4FhjsE0aWN?=
 =?us-ascii?Q?MXeCc0GlLBHs0qQh13VHGl11GidiENQK+lcBnZYGOPQgMlMtkHKanvvc/5Lc?=
 =?us-ascii?Q?lVEMSC4TFw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24695ede-9410-4005-9e2e-08da2c4186d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2022 13:41:57.3029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nlqatlMGmiU5Lb6NSkLWcbhFxAQB9QrSVo572IwIcjQSWl/JS05dfCLmPIKPN8YbSqoHu/Wa0Lo3yXj+CSzRMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4882
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Ivan Vecera
> Sent: Saturday, April 23, 2022 3:50 PM
> To: netdev@vger.kernel.org
> Cc: Saleem, Shiraz <shiraz.saleem@intel.com>; mschmidt
> <mschmidt@redhat.com>; open list <linux-kernel@vger.kernel.org>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Leon
> Romanovsky <leonro@nvidia.com>; David S. Miller
> <davem@davemloft.net>; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>
> Subject: [Intel-wired-lan] [PATCH net v4] ice: Fix race during aux device
> (un)plugging
>=20
> Function ice_plug_aux_dev() assigns pf->adev field too early prior aux de=
vice
> initialization and on other side ice_unplug_aux_dev() starts aux device d=
einit
> and at the end assigns NULL to pf->adev.
> This is wrong because pf->adev should always be non-NULL only when aux
> device is fully initialized and ready. This wrong order causes a crash wh=
en
> ice_send_event_to_aux() call occurs because that function depends on non-
> NULL value of pf->adev and does not assume that aux device is half-
> initialized or half-destroyed.
> After order correction the race window is tiny but it is still there, as =
Leon
> mentioned and manipulation with pf->adev needs to be protected by
> mutex.
>=20
> Fix (un-)plugging functions so pf->adev field is set after aux device ini=
t and
> prior aux device destroy and protect pf->adev assignment by new mutex.
> This mutex is also held during ice_send_event_to_aux() call to ensure tha=
t
> aux device is valid during that call.
> Note that device lock used ice_send_event_to_aux() needs to be kept to
> avoid race with aux drv unload.
>=20
> Reproducer:
> cycle=3D1
> while :;do
>         echo "#### Cycle: $cycle"
>=20
>         ip link set ens7f0 mtu 9000
>         ip link add bond0 type bond mode 1 miimon 100
>         ip link set bond0 up
>         ifenslave bond0 ens7f0
>         ip link set bond0 mtu 9000
>         ethtool -L ens7f0 combined 1
>         ip link del bond0
>         ip link set ens7f0 mtu 1500
>         sleep 1
>=20
>         let cycle++
> done
>=20
> In short when the device is added/removed to/from bond the aux device is
> unplugged/plugged. When MTU of the device is changed an event is sent to
> aux device asynchronously. This can race with (un)plugging operation and
> because pf->adev is set too early (plug) or too late
> (unplug) the function ice_send_event_to_aux() can touch uninitialized or
> destroyed fields. In the case of crash below pf->adev->dev.mutex.
>=20
> Crash:
> [   53.372066] bond0: (slave ens7f0): making interface the new active one
> [   53.378622] bond0: (slave ens7f0): Enslaving as an active interface wi=
th an u
> p link
> [   53.386294] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes
> ready
> [   53.549104] bond0: (slave ens7f1): Enslaving as a backup interface wit=
h an
> up
>  link
> [   54.118906] ice 0000:ca:00.0 ens7f0: Number of in use tx queues change=
d
> inval
> idating tc mappings. Priority traffic classification disabled!
> [   54.233374] ice 0000:ca:00.1 ens7f1: Number of in use tx queues change=
d
> inval
> idating tc mappings. Priority traffic classification disabled!
> [   54.248204] bond0: (slave ens7f0): Releasing backup interface
> [   54.253955] bond0: (slave ens7f1): making interface the new active one
> [   54.274875] bond0: (slave ens7f1): Releasing backup interface
> [   54.289153] bond0 (unregistering): Released all slaves
> [   55.383179] MII link monitoring set to 100 ms
> [   55.398696] bond0: (slave ens7f0): making interface the new active one
> [   55.405241] BUG: kernel NULL pointer dereference, address:
> 0000000000000080
> [   55.405289] bond0: (slave ens7f0): Enslaving as an active interface wi=
th an u
> p link
> [   55.412198] #PF: supervisor write access in kernel mode
> [   55.412200] #PF: error_code(0x0002) - not-present page
> [   55.412201] PGD 25d2ad067 P4D 0
> [   55.412204] Oops: 0002 [#1] PREEMPT SMP NOPTI
> [   55.412207] CPU: 0 PID: 403 Comm: kworker/0:2 Kdump: loaded Tainted: G
> S
>            5.17.0-13579-g57f2d6540f03 #1
> [   55.429094] bond0: (slave ens7f1): Enslaving as a backup interface wit=
h an
> up
>  link
> [   55.430224] Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.4.4
> 10/07/
> 2021
> [   55.430226] Workqueue: ice ice_service_task [ice]
> [   55.468169] RIP: 0010:mutex_unlock+0x10/0x20
> [   55.472439] Code: 0f b1 13 74 96 eb e0 4c 89 ee eb d8 e8 79 54 ff ff 6=
6 0f 1f 84
> 00 00 00 00 00 0f 1f 44 00 00 65 48 8b 04 25 40 ef 01 00 31 d2 <f0> 48 0f=
 b1 17 75
> 01 c3 e9 e3 fe ff ff 0f 1f 00 0f 1f 44 00 00 48
> [   55.491186] RSP: 0018:ff4454230d7d7e28 EFLAGS: 00010246
> [   55.496413] RAX: ff1a79b208b08000 RBX: ff1a79b2182e8880 RCX:
> 0000000000000001
> [   55.503545] RDX: 0000000000000000 RSI: ff4454230d7d7db0 RDI:
> 0000000000000080
> [   55.510678] RBP: ff1a79d1c7e48b68 R08: ff4454230d7d7db0 R09:
> 0000000000000041
> [   55.517812] R10: 00000000000000a5 R11: 00000000000006e6 R12:
> ff1a79d1c7e48bc0
> [   55.524945] R13: 0000000000000000 R14: ff1a79d0ffc305c0 R15:
> 0000000000000000
> [   55.532076] FS:  0000000000000000(0000) GS:ff1a79d0ffc00000(0000)
> knlGS:0000000000000000
> [   55.540163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   55.545908] CR2: 0000000000000080 CR3: 00000003487ae003 CR4:
> 0000000000771ef0
> [   55.553041] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [   55.560173] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [   55.567305] PKRU: 55555554
> [   55.570018] Call Trace:
> [   55.572474]  <TASK>
> [   55.574579]  ice_service_task+0xaab/0xef0 [ice]
> [   55.579130]  process_one_work+0x1c5/0x390
> [   55.583141]  ? process_one_work+0x390/0x390
> [   55.587326]  worker_thread+0x30/0x360
> [   55.590994]  ? process_one_work+0x390/0x390
> [   55.595180]  kthread+0xe6/0x110
> [   55.598325]  ? kthread_complete_and_exit+0x20/0x20
> [   55.603116]  ret_from_fork+0x1f/0x30
> [   55.606698]  </TASK>
>=20
> Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      |  1 +
>  drivers/net/ethernet/intel/ice/ice_idc.c  | 25 +++++++++++++++--------
> drivers/net/ethernet/intel/ice/ice_main.c |  2 ++
>  3 files changed, 20 insertions(+), 8 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
