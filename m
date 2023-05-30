Return-Path: <netdev+bounces-6609-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D972717133
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A8F51C208CC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED6934CE8;
	Tue, 30 May 2023 23:04:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C040A927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:04:46 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7FEE5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685487885; x=1717023885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=syAoLU9pQbCDn9sKqOZVbQIPNzP2s+2MyjwgWZqkh6c=;
  b=TQmqDXHtxt6RwvjI6QPuHwk75CBIGIMQNmR1fqYKrTZU8YRiLio+Xaq3
   suazU5Kp1J8dhi3Lww85UDlz2YlS5crsklseHo0tZXDwWq7c359rPYvuj
   4E0vdGI7JJSra5B19mCQgfLf1iZZpT0ClzpBStqEemN7hCRmlyE2c3AiB
   fkpXcjOUWSAvFkuEx5QUT9IKZuRBY3o/XmRds0XDZIUCOKl8gM7kpFVjW
   d5WFhCpa8Z4LP+8vIaFWDCmiDCom1tVwl2ISYmZue2BZIzKxGj91PQiR/
   u77h/E1MtSmISJe6iYZsLvY1wLUozFzgez0VGYBCmC/LqE6MMKCVP1pFz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418557322"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418557322"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 16:03:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="684171739"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="684171739"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 30 May 2023 16:03:56 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 16:03:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 16:03:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 16:03:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVJbXI0crpyDyXr73oT+zCUoG1RWAUqmK8y0MBWZ0jJivZ5xSzTDEdZuv8+FVvJP405K4eRZKU9KrRIN8MbOQmILzFCrYDMg/vK2411EDiEeyXAZIfhfsnWJ+aRio3sx+aNJ2XOBuAV6SZ43j0ukV3/BroMbnddv/ZGBCgJhLCmGjAJRoyOSLfV4D4GP1qGowKIaHN+IhlONt1zhLbKZJLyTsKiiGCCT44W+Whb47yWoS7uQ6eCnXeR8SAXoKY9vXSX5ejZEki29yh9zNRFhUo/0eA6Umx+48SApqEPLzpCViQWyfLwtLCqJ7Ume8kFSFTEi2kgWzXSl+GEA8FUYRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=blJAdr6P/97pXKN+EPhPyp0KWxPoE5RFbL4N4PRRG3U=;
 b=lsxb8a7VFMomeecIVEMMdeCkOMz60ssKzo0qHVCdm1lipLPRwBbCvKG4XP/a27u3SlZdWnmh/YwtO4hToZbDt5RfMA9OLk/WYiRcV38oOlknP5rl+UHAwKNLqnIZc9DA5pRc9+8/yyke4fjCZu9WU8VbNAJG4QY4Bb/ve4rPpu1OnPQ3jlgk0GIGKJf7eOAKp2a209K0poj5iqYA9bdY/lllSDjFjPcoMrBQQwvAvVV1L0mQbVPgs2eiRBPNyrbFcTWWtDDi+imyjpbnk1Ur4VLDDhRWaKwxGoiLbV7+tjxmvwhxH2kIJFXfUH91wsW4p9KmGWxUyq92ae3YrZ1mzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16)
 by SN7PR11MB6897.namprd11.prod.outlook.com (2603:10b6:806:2a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 23:03:53 +0000
Received: from MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8]) by MW4PR11MB5911.namprd11.prod.outlook.com
 ([fe80::d06:5841:d0e0:68b8%4]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 23:03:52 +0000
From: "Singh, Krishneil K" <krishneil.k.singh@intel.com>
To: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "willemb@google.com" <willemb@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "leon@kernel.org" <leon@kernel.org>, "mst@redhat.com"
	<mst@redhat.com>, "simon.horman@corigine.com" <simon.horman@corigine.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"edumazet@google.com" <edumazet@google.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "kuba@kernel.org" <kuba@kernel.org>, "Burra, Phani
 R" <phani.r.burra@intel.com>, "decot@google.com" <decot@google.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "shannon.nelson@amd.com"
	<shannon.nelson@amd.com>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v6 13/15] idpf: add singleq
 start_xmit and napi poll
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v6 13/15] idpf: add singleq
 start_xmit and napi poll
Thread-Index: AQHZjQ1+BR1Ko78EBEOiP7VPEzPrtK9ze75g
Date: Tue, 30 May 2023 23:03:52 +0000
Message-ID: <MW4PR11MB591199D21A80AC76432927DABA4B9@MW4PR11MB5911.namprd11.prod.outlook.com>
References: <20230523002252.26124-1-pavan.kumar.linga@intel.com>
 <20230523002252.26124-14-pavan.kumar.linga@intel.com>
In-Reply-To: <20230523002252.26124-14-pavan.kumar.linga@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5911:EE_|SN7PR11MB6897:EE_
x-ms-office365-filtering-correlation-id: e66375d5-daac-4b80-60a6-08db61622337
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fT8nX/V97AQOMJD8uF4dLWvOnnEioxtA+JqcVsabOkNO4Cv548I/EH8YdR25PUTfnGHydXILAUm118ZtI5+kqy3oTvja4KCiQbk3xP8vvT17gCv0SH16pRglPmxeL9sw9hVZAxFAYHzvLXo7W0BfFsMlsRs4EDel9M4tQCbNqAfuBC355daFX1tZxVmr5Uf9ZvfVWA5KSYbaJQr1f51/iGuPFcfc5FM7ys+AXg8viCWja4yrYsydoxVIzDP35X1qx+ZSh9ewf2OIybc4F+qXjkXvcBdf0mY1bFOuBSg+PwMSCexSfMm74bh8jhhp61ng4o7v1NMdFZBtUe8azQiTqjbdkc3dExuzjbmKmWyFRQEwyjzyGsoBTnhdiTBfQdruKErM6CbjhcTOc9oobknvpfGyaz5pEK+3yeJhpsVa252nJdjK2VE7F21my4W3qWeGoV4y30OwFV2OSEKBZc0AD1eAm/4nNopWd5T3uvj1MxBsPTrMfPQwkYAhVU+EA6yPCJfwHrJOw0lta9pPHBu41InCJIy3/bSJI/Hryx6/o8jxLIHaSPO2vE72o15qd/PXzLsbniFC5r0Zc6u6pfBe+/uX33Vv/Wt5tcpyny6LnRWjHhhtCHkKbxuM0L+84aY6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199021)(66946007)(4326008)(7416002)(76116006)(66556008)(66476007)(66446008)(83380400001)(64756008)(52536014)(55016003)(5660300002)(38100700002)(86362001)(41300700001)(186003)(8936002)(7696005)(8676002)(122000001)(2906002)(38070700005)(82960400001)(71200400001)(6506007)(316002)(110136005)(26005)(53546011)(33656002)(478600001)(54906003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xvy93hD/N2gc5wg4C660zaSsSlq15AD3KssKORyrugcrIOZI74HG5+pNzkSf?=
 =?us-ascii?Q?YjKhuWWDp9ZNC8j8ghNz79Fn8xQIBe6cfOghKo0qDaOTwCJzTTMMjCtb0f97?=
 =?us-ascii?Q?k87ejfIdB76oX9zp91v1fMGe2EzYC2le5N0EmX3/bW4Om4aRPhb2Y8SX/i28?=
 =?us-ascii?Q?qWPvvhWfA1Q0TWqunSpYkBjaLpH6mx8QLUZrLiXX7JVE9yai1hgo2sqNkmJ7?=
 =?us-ascii?Q?BwsFg2OLji+8cg/fAiz4I7ZfowSkw0lfXwGuyMCl0/D+Js/sggs49tCwrNI0?=
 =?us-ascii?Q?C1P3CYfjpXdP39Clrb19d13NM+hlgFZNDC8AmobzDlLkvygOTHdOoGlPV6WZ?=
 =?us-ascii?Q?5IFBCIMqxgl/Fbwy0QiSOVePdEiJYMXKWw2gqFNoje7OI7MKydQT0jhDXq/e?=
 =?us-ascii?Q?WFY31AEON0HO2egoK88EWLSK/NB94T6dF8vURFeAYewaqfMuYClRfXqoOmsj?=
 =?us-ascii?Q?SoLvUzUvdovB5jjJ5ugzrTgq1e88fmgfOyjp9JNatZO/NWBSzAiezUdj0knK?=
 =?us-ascii?Q?sooTPWp1Sb+6ERsERCl8h1nfUOymNYlYw7iPzQoNfDEn9RwHx3HO9bxA8xt4?=
 =?us-ascii?Q?d8dUKyc0NUYehGAidjXP8aDG5fT97Izx67OizR+qLTkkrk9+hCL+rbcqbokR?=
 =?us-ascii?Q?Xze8wWb9fMKxkvOMN4qfC9isOv0DPw46MweClRHeWXmNru/txtRqcVzjaOB1?=
 =?us-ascii?Q?5Wwa+3CMkQ+7OMiGFDoweq/lUXOuKj9YHYLdLN7zCFn0gv+EjsOLpU4Q2omL?=
 =?us-ascii?Q?dcWmM6cwp+TrWh/1KW800s59Fy0rEvk2E0EKKlm1UMfut07LGixL6rwSOWe5?=
 =?us-ascii?Q?o3hUKOjmxny8ZrqzMgaKnhND34dA8w0Pc4dnJ3NRDRmH0hK1fJgARVXpqDhs?=
 =?us-ascii?Q?LmaF6TChr82jYuWzPtl+mIBbr30Jb4LgB57mswOLkZs8MWQY0aI7HKIRUi6k?=
 =?us-ascii?Q?NQcss1h4F8M6KOF0vrLaZEtfezvYE+KPH+8mrWk44Nix1AEYANGk2HIrvVlX?=
 =?us-ascii?Q?mJN0FlO4VjVd/VX+ZIEUN8BWe3HTREYDuo4lwn640ityfePC0WXmFfForpz0?=
 =?us-ascii?Q?A/aDtGlw45/Rk3U3SljvoEDiXc2aQgQJTwtRDRIR/GWDmiI3UO+Wo9QJgaly?=
 =?us-ascii?Q?sCWA31wqayEAIS1Dy+66DTFFdAgkWPULZPFYR9HwhryE9BhN0fb9qY59GhSj?=
 =?us-ascii?Q?wqzgMpeU8NIhqFOzRH6lPjjYTOBwi7iPyDmx+ZDA1CEsfcwT7cLN2sdLmLnS?=
 =?us-ascii?Q?12HUjmPsESin7ul/vUND+HiIslsV7x1aX72Ncm7/tWH7DXe0nBCPCzzC6rPA?=
 =?us-ascii?Q?41WJctqRLwpb4SKeJi8W4mKDRtI6V5u2sJopD1Z38MSJeTwEwWWE0ILamWA/?=
 =?us-ascii?Q?v7etRa61lbml9ARwlUvnImZzFa/8aeAHSLznHq/wRA+DMBgTheNxUPzS5VEz?=
 =?us-ascii?Q?C93dyUvwHs3P2CP8c1xbk2RMf8wFL8ZL6zyw/y4pfZRgW/zgWrGudgQy/b8+?=
 =?us-ascii?Q?oYG9kTGfCcIoZEt7vWOpItmatr8WKIlNIUdXm16Ckd6WSrIVrwkNthoO52Ba?=
 =?us-ascii?Q?7o9OfEvgiwJl6yAADyA2JTV1raWiFsLjZOUVR2z+Bg/wCz6AgNXEtBBBF4Hm?=
 =?us-ascii?Q?xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e66375d5-daac-4b80-60a6-08db61622337
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 23:03:52.8148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R7ZKePxd4x1UmovnM8w1wb8Y2rBoPmgltPSK/XODYUU+u7254cXA0vyIDgn4cF8lGoNlUNgYGoLdHkJKduIOwSfK6SfLP+3Q+EC/K5agX0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6897
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Pavan Kumar Linga
> Sent: Monday, May 22, 2023 5:23 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: willemb@google.com; pabeni@redhat.com; leon@kernel.org;
> mst@redhat.com; simon.horman@corigine.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; stephen@networkplumber.org;
> edumazet@google.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; kuba@kernel.org;
> Burra, Phani R <phani.r.burra@intel.com>; decot@google.com;
> davem@davemloft.net; shannon.nelson@amd.com
> Subject: [Intel-wired-lan] [PATCH iwl-next v6 13/15] idpf: add singleq
> start_xmit and napi poll
>=20
> From: Joshua Hay <joshua.a.hay@intel.com>
>=20
> Add the start_xmit, TX and RX napi poll support for the single queue
> model. Unlike split queue model, single queue uses same queue to post
> buffer descriptors and completed descriptors.
>=20
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/net/ethernet/intel/idpf/idpf.h        |    8 +
>  .../net/ethernet/intel/idpf/idpf_lan_txrx.h   |   57 +
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    |    1 +
>  drivers/net/ethernet/intel/idpf/idpf_main.c   |    1 +
>  .../ethernet/intel/idpf/idpf_singleq_txrx.c   | 1184 ++++++++++++++++-
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   |   67 +-
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   |   74 +-
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   |    2 +
>  8 files changed, 1359 insertions(+), 35 deletions(-)
>=20
Tested-by: Krishneil Singh  <krishneil.k.singh@intel.com>

