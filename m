Return-Path: <netdev+bounces-8031-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA4F47227E0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DCA1281125
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12201D2B0;
	Mon,  5 Jun 2023 13:53:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC8F156EB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:53:12 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EBA9C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685973190; x=1717509190;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5n9aD7rolVurAUguJqyDFBvbdnMyFYKsOuMBDXiA4fM=;
  b=FF/9quIvxQlBZWqgOGeDJXhPI/cTgDjP5fTGjZ52wREr1wrjKMcd7APQ
   25vjw4lj/wUvA96OcDnYgbxpk/PHNCHpBbB2rpw4/XjbDJFh+5qCVfVeN
   YzDe9P+rjvryNc1p8QstaN1g1xnpr035TRltFiHLMjhzxzevIqvPsf5fd
   T38SEIIzhd0aSvT1B0XTgZwHAOlE8raRFgJGHfWefPx4Daq/3NxBPu1rT
   FcFpvT1+MbA/KQaFX5m7FckaNaWnei0QMbwkcXdy4QdwGGAv/95/7MQjW
   74ymO73Kb/KkEceo/YmbGceCsmj9YTWu6Ss7Thtq4vSAzLabt7G+3BvFx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="358818859"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="358818859"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 06:53:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="686127362"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="686127362"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 05 Jun 2023 06:53:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 06:53:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 06:53:09 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 06:53:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noT1e+o+N9U1+AwXx8WZ91/XHYXiVFCzMqAydE8BqcCzDlwV5YHZUFDHk71F6oC26WovtKSojbOcIuWFzvm/NsBAm++rFlYPsz3n6C3jOZ6havbwVKWmWe6b6Daan4u6xxx1AgsH22VvHyLfu5tKPbR5En8aX57VVveyx2qSkztcQuhZqmLKshYQjDKnkg2VprLAss4ZK3bv0v9lBSurogIuYHtrfkWzN1ouDI74y7PPTXD2vfBt7yChX9DSqjZ3yRoJW0K72BP2h5TJ+93JCXjd79I37KlHM4ANcDk5ZalFK7FQ73E53O6gjqmc+Ghz6JjQLiThQQUXtykLw1VbLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hcCqb5RDnV7wluFpapyTja98HX+QS8Ekbe8HI119V0=;
 b=kn3Xr37HAGVJvGEb27x92HaX0CA/7fgA8ZnlquEtu3ZRGW9oTBaeMm7+O0ctsc2gUEo1n0w/mPo6ffEWzIoe/ORDzON7uQoMi5v4Aws8ad1LU9zCQBv63UKnAnIe5XZ0aPC4fN+v5w2nAcMVSJfkRKCCVMyD0HTTAN6BD3XK0MWiSB78Nk7wmlt+8VcxVmq9Ktw83I2e6FjW5wdAEYdI9AZjAMv5wz9FGf7Z7s+BKqYoGjMFwH9e/vrnfJBFUhacCcwgaZJQV81FYii0rheTzyRaKk6xfP0/ZGMONnEjLWj0Li4ynO4UytAb7K3CIZwCtdEj5QjB2cQ4OKiwFLJouQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by PH7PR11MB8273.namprd11.prod.outlook.com (2603:10b6:510:1ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 13:53:06 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::7b23:e512:60c9:ce08]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::7b23:e512:60c9:ce08%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 13:53:06 +0000
From: "Drewek, Wojciech" <wojciech.drewek@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Lobakin, Aleksander"
	<aleksander.lobakin@intel.com>, "Ertman, David M" <david.m.ertman@intel.com>,
	"michal.swiatkowski@linux.intel.com" <michal.swiatkowski@linux.intel.com>,
	"marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
	"Chmielewski, Pawel" <pawel.chmielewski@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, "pmenzel@molgen.mpg.de"
	<pmenzel@molgen.mpg.de>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
	<edumazet@google.com>
Subject: RE: [PATCH iwl-next v4 07/13] ice: Switchdev FDB events support
Thread-Topic: [PATCH iwl-next v4 07/13] ice: Switchdev FDB events support
Thread-Index: AQHZlu9qoo4J5Xd74kKT5QXbJLLNwK98MJkA
Date: Mon, 5 Jun 2023 13:53:05 +0000
Message-ID: <MW4PR11MB57761738D8B4857AC627C11CFD4DA@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-8-wojciech.drewek@intel.com>
 <ZHydCI08zJip88rj@corigine.com>
In-Reply-To: <ZHydCI08zJip88rj@corigine.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|PH7PR11MB8273:EE_
x-ms-office365-filtering-correlation-id: 003a71ce-77e0-4441-6ed2-08db65cc3044
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CJYYhkKf+XTYhZragRMSsW9CM+/NOJgZrDapAAr5pnffoSvNyySQcr9G6CvYlCdIfnACzy5isGemEnCFa1qCHVFTAJI4cooND4MoJhi9RrdwlB12t+rIOXg9brkc0EnLykf5ycwOPQyJQ2f3hc2Sx7Xc/bKZ0QGAaSU09l3YvRpwysLOwA8YM3VMJGiATpHt+Y7LYYJN+3KtwQrw7cpWmEwcHaIGsM7eoemzoae/8/WfasukLwhzU5AS5jedIzZOH/D+zneM5rkaBmjrNnKa53EuiC+VzpShbLBD/C3hl1Hi8Hq5OENxVOW34jhmuvO5zwi6boyxUoArILTQipcC56z8t1sqU4LuDuO4Q6dl8tii5qJvCGi9VZxSG0SoE43LAtlsL0RGP+EdPnVQpnx0BEnEdwVHslfLe11NpAyI4jLGpKmfQ+tfhS1g4Wyyz1fBogTm1rauj/aVUMbndVtwpzyuT+t+1A454EitGOZTy2zWgeUhJJWf5Dd5DljenJczCtviW9WpuDoIm/vbmESscHJkLXQ2IV+KUMoV/gxLFzTFuuFAMllhP/ghpl01lco8TkysF3jjE4VxnK2kgE9WdCkK3XKzG6MJTyAXjSQZV8ZrOQ7KaCheohlPsoYbPnDi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(54906003)(66899021)(71200400001)(478600001)(52536014)(5660300002)(8936002)(8676002)(38070700005)(2906002)(86362001)(33656002)(4326008)(6916009)(122000001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(55016003)(82960400001)(38100700002)(41300700001)(53546011)(9686003)(6506007)(26005)(186003)(83380400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2YMWXPD8rTe+7i06QgLkrOleAe1ivO1B+bjBCLMsq9fr96WngXnqd5xwSpiJ?=
 =?us-ascii?Q?7HOXCCyYDY68Tt64/TgWNwpl4u8eShmSQUSEDNc7UTJMoOuCjNcsyHPM0f8f?=
 =?us-ascii?Q?/YY3Km50mamR4hqtJbSb640BV6sKe4ZN7sxXIAg4eUy52Y5E8OzcTQkbmMXU?=
 =?us-ascii?Q?cJOq5Wh1e55j/U8S9vw/NJL8HgaMNtKvLYQb8Un1q1NQFaeIxVCj5kVRmpME?=
 =?us-ascii?Q?R2tKQPPdfo9ZKRwfv+KB24/SvgAHzG9afvQqLkN9i04rGWfNFyjG4MANuF5O?=
 =?us-ascii?Q?EriJy3ZgtdM7pe3g/bD70Gmn1gra9UTISm7RtP9zY91oWv4brr5zOSEyOZ3S?=
 =?us-ascii?Q?IQNbb63fnr4U8WHuK1wlrhaxCpyVU3PdCFmb+W9M5gWxyORMt9us3oRt36p2?=
 =?us-ascii?Q?141SMa3tyzYkxAs+MCxpDHK2/BODSl9FzJ2+6M+imw656cTMy6bXPEfn3u5a?=
 =?us-ascii?Q?H1pccaa3NAubMvj0RJyZoMGYEgj69zXOiZ6M3HqJVoCuvz20txsnhhv/Q83p?=
 =?us-ascii?Q?rxQVLjEWffvur1RBYse15c+0Ud4+wttBd58geFobd05num0bBnS3wp+wxc7i?=
 =?us-ascii?Q?kpbNMcjuUpXGCbBeSz0Gw+y4s3y1YSezOgEV2sAzM26cBJSaoVmZNLGYCGFi?=
 =?us-ascii?Q?x3pV++j69+D65sbKSzPsRPP5puKkDEWs2Jk3tbj1R6FC3ahjoBG774GAHc3n?=
 =?us-ascii?Q?t8rVIkkbTPfvWNdt1qf8LElsEJNQqOBlEqe5ijwD5Edvwp25wW98fyhvm4PL?=
 =?us-ascii?Q?/xxtitFKVAjb06q1ZGkxgE4xqbOVnwkawBxlGj0qSBSgCM829ODOFymg3km7?=
 =?us-ascii?Q?KvOdHMViWdJ3kcNLB345NiAxPTmTqv5LJNYeQNLrlAZZB/JA5hIQHxnhVDXh?=
 =?us-ascii?Q?bAHKDAwd7ZTwBFurXBHjiguPE0Npmi2iUxfmVu/XCJW3pYG/vrUn4DFTKY+4?=
 =?us-ascii?Q?+YYXEC7TQBWqdvFzLSQ1qoTonagKjb7fQ566Sq2J9vB2vSPxS+2f+dyfj62t?=
 =?us-ascii?Q?X+rDyBjtgQ0406USKer4ibKVd3Q+eQTDEuF/TtXNtP2pPcvdQVmdhStHFJzN?=
 =?us-ascii?Q?76fPesJzW6E34uR5iZg79UewfqDmt8wQomqDeJW40uQIED/iZW7756lu5h8s?=
 =?us-ascii?Q?PcWWiPAGvfPWhXda6mR5qVZigjB/c5ORuAsCQNpQXK2EDOZukXFdpzEevTlE?=
 =?us-ascii?Q?TDvE/TnYtyZqC1KoreLB6RhYyztNARTqi2+Vfdk9I2gp76DSRXidA2NAJT2b?=
 =?us-ascii?Q?5Mfqj2pcD7qQvQdha+vtNmyw09xpG+E4KIrVuVwDa6YK4HYl9M7J1WPYh2/x?=
 =?us-ascii?Q?PFDsfLZT7L5Yz2kMHBmt99+XcANuJDOotAKL/tm58KbwRLxQR9nu8hu0shG+?=
 =?us-ascii?Q?Dlq8fy2rEHNfVJ+FXDJWkeb9onqJDSk9EKg1laiyxzJiLDs2jEAnrqZbtj79?=
 =?us-ascii?Q?MZUGvbLEs/jNoVnrgd26aYq+j7jtpw0Z565L8ALeU3vT6TFlJVZRIQus9mMy?=
 =?us-ascii?Q?PJ7EQubjhdRwrq1Q1ts4/W97m5J94ZRAgek8WZ+ho/Pl5+QMihzV8SwjmzuJ?=
 =?us-ascii?Q?oALOW9LmUPaRyyvDgaFbU4Oj4imoN0JVsuiegovR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 003a71ce-77e0-4441-6ed2-08db65cc3044
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 13:53:06.0125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kX6F1QTsAUDjJ9kM5jlEpMImz69SD/hRH0YbWomImPOKJJfPdq0qEg0exTpEwlcPIkS2+wWAK8dkPc2lG6rrV3DQexMwx9+jQ5YWcklZHpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8273
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: niedziela, 4 czerwca 2023 16:18
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Lobakin, Al=
eksander <aleksander.lobakin@intel.com>; Ertman, David M
> <david.m.ertman@intel.com>; michal.swiatkowski@linux.intel.com; marcin.sz=
ycik@linux.intel.com; Chmielewski, Pawel
> <pawel.chmielewski@intel.com>; Samudrala, Sridhar <sridhar.samudrala@inte=
l.com>; pmenzel@molgen.mpg.de;
> dan.carpenter@linaro.org; Jakub Kicinski <kuba@kernel.org>; Eric Dumazet =
<edumazet@google.com>
> Subject: Re: [PATCH iwl-next v4 07/13] ice: Switchdev FDB events support
>=20
> + Jakub, Eric
>=20
> On Wed, May 24, 2023 at 02:21:15PM +0200, Wojciech Drewek wrote:
> > Listen for SWITCHDEV_FDB_{ADD|DEL}_TO_DEVICE events while in switchdev
> > mode. Accept these events on both uplink and VF PR ports. Add HW
> > rules in newly created workqueue. FDB entries are stored in rhashtable
> > for lookup when removing the entry and in the list for cleanup
> > purpose. Direction of the HW rule depends on the type of the ports
> > on which the FDB event was received:
> >
> > ICE_ESWITCH_BR_UPLINK_PORT:
> > TX rule that forwards the packet to the LAN (egress).
> >
> > ICE_ESWITCH_BR_VF_REPR_PORT:
> > RX rule that forwards the packet to the VF associated
> > with the port representor.
> >
> > In both cases the rule matches on the dst mac address.
> > All the FDB entries are stored in the bridge structure.
> > When the port is removed all the FDB entries associated with
> > this port are removed as well. This is achieved thanks to the reference
> > to the port that FDB entry holds.
> >
> > In the fwd rule we use only one lookup type (MAC address)
> > but lkups_cnt variable is already introduced because
> > we will have more lookups in the subsequent patches.
> >
> > Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
>=20
> ...
>=20
> > +static void
> > +ice_eswitch_br_fdb_event_work(struct work_struct *work)
> > +{
> > +	struct ice_esw_br_fdb_work *fdb_work =3D ice_work_to_fdb_work(work);
> > +	bool added_by_user =3D fdb_work->fdb_info.added_by_user;
> > +	struct ice_esw_br_port *br_port =3D fdb_work->br_port;
> > +	const unsigned char *mac =3D fdb_work->fdb_info.addr;
> > +	u16 vid =3D fdb_work->fdb_info.vid;
> > +
> > +	rtnl_lock();
> > +
> > +	if (!br_port || !br_port->bridge)
> > +		goto err_exit;
> > +
> > +	switch (fdb_work->event) {
> > +	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> > +		ice_eswitch_br_fdb_entry_create(fdb_work->dev, br_port,
> > +						added_by_user, mac, vid);
> > +		break;
> > +	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> > +		ice_eswitch_br_fdb_entry_find_and_delete(br_port->bridge,
> > +							 mac, vid);
> > +		break;
> > +	default:
> > +		goto err_exit;
> > +	}
> > +
> > +err_exit:
> > +	rtnl_unlock();
> > +	dev_put(fdb_work->dev);
>=20
> Hi Wojciech,
>=20
> I notice that the CI flags this as use of a deprecated API.
> So I'm wondering if it would be better written using netdev_put()
> And likewise, I'm wondering if other users in the ice driver should be
> updated.

Sure I can use it but I don't see any examples of device drivers using it (=
API is quite new, that's probably why).=20
Also that would mean that I should declare my own tracker, right?
Is it safe to use such tracker for devices not owned by our driver (LAG cas=
e)? I feel like the tracker should
be corelated with only one device or it might be used for many devices?

>=20
> > +	ice_eswitch_br_fdb_work_dealloc(fdb_work);
> > +}
>=20
> ...
>=20
> > +static int
> > +ice_eswitch_br_switchdev_event(struct notifier_block *nb,
> > +			       unsigned long event, void *ptr)
> > +{
> > +	struct net_device *dev =3D switchdev_notifier_info_to_dev(ptr);
> > +	struct switchdev_notifier_fdb_info *fdb_info;
> > +	struct switchdev_notifier_info *info =3D ptr;
> > +	struct ice_esw_br_offloads *br_offloads;
> > +	struct ice_esw_br_fdb_work *work;
> > +	struct ice_esw_br_port *br_port;
> > +	struct netlink_ext_ack *extack;
> > +	struct net_device *upper;
> > +
> > +	br_offloads =3D ice_nb_to_br_offloads(nb, switchdev_nb);
> > +	extack =3D switchdev_notifier_info_to_extack(ptr);
> > +
> > +	upper =3D netdev_master_upper_dev_get_rcu(dev);
> > +	if (!upper)
> > +		return NOTIFY_DONE;
> > +
> > +	if (!netif_is_bridge_master(upper))
> > +		return NOTIFY_DONE;
> > +
> > +	if (!ice_eswitch_br_is_dev_valid(dev))
> > +		return NOTIFY_DONE;
> > +
> > +	br_port =3D ice_eswitch_br_netdev_to_port(dev);
> > +	if (!br_port)
> > +		return NOTIFY_DONE;
> > +
> > +	switch (event) {
> > +	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> > +	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> > +		fdb_info =3D container_of(info, typeof(*fdb_info), info);
> > +
> > +		work =3D ice_eswitch_br_fdb_work_alloc(fdb_info, br_port, dev,
> > +						     event);
> > +		if (IS_ERR(work)) {
> > +			NL_SET_ERR_MSG_MOD(extack, "Failed to init switchdev fdb work");
> > +			return notifier_from_errno(PTR_ERR(work));
> > +		}
> > +		dev_hold(dev);
>=20
> Likewise, I'm wondering if this should be netdev_hold().
>=20
> > +
> > +		queue_work(br_offloads->wq, &work->work);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +	return NOTIFY_DONE;
> > +}
> > +
>=20
> ...

