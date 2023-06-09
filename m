Return-Path: <netdev+bounces-9540-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9419B729AC5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E43028192A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BB0171AC;
	Fri,  9 Jun 2023 12:55:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B9479E5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:55:46 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42F2359D;
	Fri,  9 Jun 2023 05:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686315321; x=1717851321;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=061P1wg2g+6VkqUo9I1Pvb77zeSCA6Gwvlb7eTHgIP8=;
  b=DBr5J+Q8AJlt96v0Lewqfzec0roAtsmxKe/ofB3XfyYKC7GXoCMP4mYn
   KOH/uHTNT9rdSFpfdIsQZU5Wa7zKvgYE6tVaYYfZ9gsH2oqY7etoxN19o
   IYYs+OJJlpJd/TMBKG++l0xSo/i0oj/dKcrVG5swzioD8Pf4OtFJfu9+m
   XuSUA2GIRRZPsn4ul3PgX6zn2sQSjTg130a04Iinhkn8QRzog/yK2c4V7
   xtY41SSyzN2keKQlfdC289QlT5clPdqS14xJYOleYt3V2SxRl2ReCSnmQ
   01DSaGqdJfgs7sBmExeh0LhpmERU9l6qqOXbsooGlL9YLbddC1UdvRgR1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="357591657"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="357591657"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 05:53:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="660753412"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="660753412"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 09 Jun 2023 05:53:32 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 05:53:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 05:53:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 05:53:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrpIbMqYA6h3jiFr6ku455noIOZHOEJgLSVsp0bWEqMYUNsNiELp1W/mpG5Jy/qEV02gPaCEiFCfNgHdvdheUs7GFiaTs86UsW8pZOn6ZK5YMhieruQwWIA39u1wO1DBgg503KN3qfbJtkm+toO0joBkbZ+ZdXXIoQFs2FQDTOxfdx9P/LPgyi1nhdhMUQK0hawTSsy4ZN5eJs0fVYX7mNiM2EO5/qJZ+u+0LC8EhksI+ryQzuZYLEfAmJdzLclh7HarHeJFUImvbS+smGTKmTjQmBS3BLkvphTwu8LwVI0Z/o4ulZyZ0rltb4T6JbWr48/PadE/LVg2NrL5aTVyug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOs6ftPVUFQxVcW39M4ac8g0wLVj50tfWQGYgQqGf40=;
 b=DQbc4ACea1h5FQZFD0Wn9vMVpQuvcaV5oHErTt0OQl7AD1SHI5GWk1hFvfUIUqOYDTAXGSuEftj0/iuBPjMVD4E5l7kpGD/yt9qolVQmB/pV0FE+tnyxSZWNNhZfjrN79Zvc8p0vT/uDfnrPc2YHHeTIbG6VcNeUh5zXc7YwEn+pXOctQQaBRMG+6PrLNinYq+7bgGfBkKi1m5tzsucCtc78k9XEhlfrUFspubxycZRU4sQT7+XzerqdEE+tEKNQVKR/SAc/8OZSTjVhH8DTzTVcaiXQ8toAVAbmjauHMSVxAZDqGkEkzKmGKwCsUlVHV60+DDMvLBqV8rc+xf4Gyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.41; Fri, 9 Jun 2023 12:53:27 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 12:53:27 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC: Jakub Kicinski <kuba@kernel.org>, Jonathan Lemon
	<jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, "Olech, Milena"
	<milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Index: AQHZeWdERHWnlPmo9kOdLErcTLxvj69SBLEAgDCq4oA=
Date: Fri, 9 Jun 2023 12:53:27 +0000
Message-ID: <DM6PR11MB4657C1D51F8FEB83C219B1509B51A@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-3-vadfed@meta.com> <ZFpNMAUkKbl7SFoV@nanopsycho>
In-Reply-To: <ZFpNMAUkKbl7SFoV@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM4PR11MB6020:EE_
x-ms-office365-filtering-correlation-id: d994080c-01b4-4f38-6188-08db68e884eb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5nLJyFI7pYH6pXj9Be7Mzx+Hb9ZMOgnoB4aggQVBko5EWeLbwZSXbdmN6r8gtny3nQRKlX83xloV6Vf3w79QGNMk1s9zNiY6vQnMW8FCUhw45FTTyAA+5WVTMGjak0DMMsWrzO43rC4MZovhxI89HxC1rQPZO/NtYn/1qVCVbEP6ArjTCB0d0jSTYU1zYlRKN7PmwtanSsMdRpjnam0NbOwf1Kge4G/G7qP0eA77ADiQ2vGuCPULdWm3XCnTIIbN8x01s5JB+grdTuaafLwac2kBqeCoemvjTv4QfLlxKC3nR3ZTms1fwXNc6biI9ko2eolL12MLoi6R9uaKne5p+pT5+zaQ0fLFy86+c0Y3+LivMwgRMuVg58QYI+hsJwmHc2u5ZLgDsArFybsdsnfsUfnzGEUP/tRIbYLrpsglk/RPfexhv4sAwbj8WZY08luLrmQ045jrBByU1ilZsy48icLeDN34avAmDwD1LfFQZAsxobrSOax58BNrHLeBXq5QROMAfxAZfOZHA0pfw3oDryHHKECwOVgx85ObnTATx8fYOrRDjdnzbcpO8+u19u5hEBDXOa8iYBiI+XXgRyZtbcHw8vkkZbpVHeDy3R7cJmvIvmHeSsrQDMwXEIeJTBY4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(6506007)(9686003)(186003)(26005)(7696005)(71200400001)(82960400001)(122000001)(76116006)(66556008)(66446008)(64756008)(66946007)(66476007)(4326008)(478600001)(83380400001)(38070700005)(8676002)(55016003)(8936002)(86362001)(33656002)(5660300002)(52536014)(38100700002)(110136005)(54906003)(7416002)(316002)(41300700001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Us18FSNk1PZ4qkPrisDvXM/2afH+CtA3oaqja3Ay93StAUFgO7GCmGdyuWoX?=
 =?us-ascii?Q?KJQ4e2l7tx4qjABCUQIDfylvqzPFgmFQUWnAu6LKENupdN9QnM4tkV/HYe3N?=
 =?us-ascii?Q?epOkjRF6JOT1LNMFAooiwMzyczVz4l/6Oj5t+7E2TcaVBC8f9XfKD3+avCju?=
 =?us-ascii?Q?0cOj0hk13jY7/9+FACNs9uapNLkf6yCDtDYqbht4I7UE7N2myBr9gWp/IwJH?=
 =?us-ascii?Q?I5qqljiACzViewBACu0NheMxB7vZcwXvSxBRro+MAKcZyg2D9QjM1d8vpviL?=
 =?us-ascii?Q?qrXft8fUE5+93bbzmRB/RZPehqQKwgshqo4IFouJEIQfo6XaIrc3w7qkC5rC?=
 =?us-ascii?Q?v6XMiAWfPadE9OrERVYwV3HTT/0/KNBsqSZu/V20LklHoNuQUkUqdc81ju89?=
 =?us-ascii?Q?RQXeZ5V25SE4GwY7QRTvxF4G57L9eFLBtA+faUGRmGAqSc2zu1TryIVzI0mf?=
 =?us-ascii?Q?yujRsEkpELgoMR8SqVzzlW3WhZZ773H+Wjkwa5fmEHHy1LMUe+jkxJfkhgnY?=
 =?us-ascii?Q?pq6bEV5MDF+ezQzLUOyhjp6w580uPcqA/NluLUfxp21chmT9Vavv28qbnAGc?=
 =?us-ascii?Q?QePC6CfIALzIaWqZwPhM3TG93H0LDWHZiIJm4TVDfpKYWSnluwgGFxJy52BY?=
 =?us-ascii?Q?OcpCrVIbeaWryTjcR6TXPYImGjg0zhYeWT/m6KwvawpgHkXoeOb7icjGfNYd?=
 =?us-ascii?Q?q8X3Ei7K46nzGsAUs1lTeeKMKhduVIEEj+owQPwLUjCpg6Q2cVP/haHHWEio?=
 =?us-ascii?Q?AIlt6MGn6NzpJxkxOJBc8buENICzkdTAvQScmKV4GQgxgi198GBNsyIXjzgP?=
 =?us-ascii?Q?K61gcS2zRWh/QFP8U6IcRlwxiR5Z1wfiUd7ojSSVEzaWZlgcOiL+Daam6T3Y?=
 =?us-ascii?Q?vgBip4UEiZMaGUw20ETmHkui5jQEmtZLuPr5iyqwhpnkDQ7mRPOkNA0Rzb50?=
 =?us-ascii?Q?HD1O1lcWs+IJmQDm4udMwzK4GVxxQCZ2UuUyXqYfLZpnn2R6yLes+VD57/FF?=
 =?us-ascii?Q?b+ffnN7ujPgQGTjGMWtgbWiHggEGgcF0TgiZZOQAxAbS8m6eIMfF3hfIUhRP?=
 =?us-ascii?Q?7DzuGBk5Cgd5v5e2t6clehsOJUu50uqXbVs3A0piOOesRhOxS1E+ToeqxCaO?=
 =?us-ascii?Q?Jomxx1oNKNdAbv8Ipc24elcVv9HYb24vttECYKHMyq/vPgIPs91ZN0ox98gR?=
 =?us-ascii?Q?0hg6Cf13Mun7O2PZnzVQ9VUpJgmgC/N+sngifwIwOXOVJmpfWuBYQPw8+9Si?=
 =?us-ascii?Q?J71abaHZ/LD2rWMbtQskEIaDBdmFr6McW6YQLQzGQbyfxoDx6eIxMoQ8R+sJ?=
 =?us-ascii?Q?LSJiTHwc1CKnt35z4rZN2T4E5OPq2ZphJUBt59qMT/h2gmMyjiZAMz/iFY20?=
 =?us-ascii?Q?QlIjNWgvxGUXUVif4qgOO+UmHn28ranBYGXbooctf5wSTve2/8m+Q2Dbh8pv?=
 =?us-ascii?Q?fSs1Crz+O/RuUIudyruTtEK5Gt5BejFp1/JQ4p1FF+JPK/g3wZJfpuPrCTqI?=
 =?us-ascii?Q?lU1GgQFIv/YJuTNx3dsl9pQ4kx0N9QmDkF7LDfGraUOt06i8a4Ez8ufwo4YO?=
 =?us-ascii?Q?vY858FPFi0JYCDq8Y6I69JuAHf9VgA9i1NXxbC8HC6dB5LYJZDw3YAcW4Ks4?=
 =?us-ascii?Q?Eg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d994080c-01b4-4f38-6188-08db68e884eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 12:53:27.4579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LP2FokMx/hvKFeJXdWVAn8muw9naQPoT3H88R3L7eiM2nPWs6Y+6Tyv6DOB411vCIaef8Rn27KCOnKInGBqKA+BflCNuJBJ2l7L2gxSyy+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6020
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, May 9, 2023 3:40 PM
>
>Fri, Apr 28, 2023 at 02:20:03AM CEST, vadfed@meta.com wrote:
>>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>
>
>[...]
>
>>+int dpll_pre_dumpit(struct netlink_callback *cb)
>>+{
>>+	mutex_lock(&dpll_xa_lock);
>
>Did you test this?
>
>I'm gettting following deadlock warning:
>
>[  280.899789] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>[  280.900458] WARNING: possible circular locking dependency detected
>[  280.901126] 6.3.0jiri+ #4 Tainted: G             L
>[  280.901702] ------------------------------------------------------
>[  280.902378] python3/1058 is trying to acquire lock:
>[  280.902934] ffff88811571ae88 (nlk_cb_mutex-GENERIC){+.+.}-{3:3}, at:
>netlink_dump+0x4a/0x400
>[  280.903869]
>               but task is already holding lock:
>[  280.904559] ffffffff827d1c68 (dpll_xa_lock){+.+.}-{3:3}, at:
>dpll_pin_pre_dumpit+0x13/0x20
>[  280.905464]
>               which lock already depends on the new lock.
>
>[  280.906414]
>               the existing dependency chain (in reverse order) is:
>[  280.907141]
>               -> #1 (dpll_xa_lock){+.+.}-{3:3}:
>[  280.907711]        __mutex_lock+0x91/0xbb0
>[  280.908116]        dpll_pin_pre_dumpit+0x13/0x20
>[  280.908553]        genl_start+0xc6/0x150
>[  280.908940]        __netlink_dump_start+0x158/0x230
>[  280.909399]        genl_family_rcv_msg_dumpit+0xf9/0x110
>[  280.909894]        genl_rcv_msg+0x115/0x290
>[  280.910302]        netlink_rcv_skb+0x54/0x100
>[  280.910726]        genl_rcv+0x24/0x40
>[  280.911106]        netlink_unicast+0x182/0x260
>[  280.911547]        netlink_sendmsg+0x242/0x4b0
>[  280.911984]        sock_sendmsg+0x38/0x60
>[  280.912384]        __sys_sendto+0xeb/0x130
>[  280.912797]        __x64_sys_sendto+0x20/0x30
>[  280.913227]        do_syscall_64+0x3c/0x80
>[  280.913639]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
>[  280.914156]
>               -> #0 (nlk_cb_mutex-GENERIC){+.+.}-{3:3}:
>[  280.914809]        __lock_acquire+0x1165/0x26b0
>[  280.915254]        lock_acquire+0xce/0x2b0
>[  280.915665]        __mutex_lock+0x91/0xbb0
>[  280.916080]        netlink_dump+0x4a/0x400
>[  280.916488]        __netlink_dump_start+0x188/0x230
>[  280.916953]        genl_family_rcv_msg_dumpit+0xf9/0x110
>[  280.917448]        genl_rcv_msg+0x115/0x290
>[  280.917863]        netlink_rcv_skb+0x54/0x100
>[  280.918301]        genl_rcv+0x24/0x40
>[  280.918686]        netlink_unicast+0x182/0x260
>[  280.919129]        netlink_sendmsg+0x242/0x4b0
>[  280.919569]        sock_sendmsg+0x38/0x60
>[  280.919969]        __sys_sendto+0xeb/0x130
>[  280.920377]        __x64_sys_sendto+0x20/0x30
>[  280.920808]        do_syscall_64+0x3c/0x80
>[  280.921220]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
>[  280.921730]
>               other info that might help us debug this:
>
>[  280.922513]  Possible unsafe locking scenario:
>
>[  280.923095]        CPU0                    CPU1
>[  280.923541]        ----                    ----
>[  280.923976]   lock(dpll_xa_lock);
>[  280.924329]                                lock(nlk_cb_mutex-GENERIC);
>[  280.924916]                                lock(dpll_xa_lock);
>[  280.925454]   lock(nlk_cb_mutex-GENERIC);
>[  280.925858]
>                *** DEADLOCK ***
>
>[  280.926488] 2 locks held by python3/1058:
>[  280.926891]  #0: ffffffff827e2430 (cb_lock){++++}-{3:3}, at:
>genl_rcv+0x15/0x40
>[  280.927585]  #1: ffffffff827d1c68 (dpll_xa_lock){+.+.}-{3:3}, at:
>dpll_pin_pre_dumpit+0x13/0x20
>[  280.928385]
>               stack backtrace:
>[  280.928853] CPU: 8 PID: 1058 Comm: python3 Tainted: G             L
>6.3.0jiri+ #4
>[  280.929586] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>[  280.930558] Call Trace:
>[  280.930849]  <TASK>
>[  280.931117]  dump_stack_lvl+0x58/0xb0
>[  280.931500]  check_noncircular+0x11b/0x130
>[  280.931916]  ? kernel_text_address+0x109/0x110
>[  280.932353]  __lock_acquire+0x1165/0x26b0
>[  280.932759]  lock_acquire+0xce/0x2b0
>[  280.933130]  ? netlink_dump+0x4a/0x400
>[  280.933517]  __mutex_lock+0x91/0xbb0
>[  280.933885]  ? netlink_dump+0x4a/0x400
>[  280.934269]  ? netlink_dump+0x4a/0x400
>[  280.934662]  ? netlink_dump+0x4a/0x400
>[  280.935054]  netlink_dump+0x4a/0x400
>[  280.935426]  __netlink_dump_start+0x188/0x230
>[  280.935857]  genl_family_rcv_msg_dumpit+0xf9/0x110
>[  280.936321]  ? genl_family_rcv_msg_attrs_parse.constprop.0+0xe0/0xe0
>[  280.936887]  ? dpll_nl_pin_get_doit+0x100/0x100
>[  280.937324]  ? genl_lock_dumpit+0x50/0x50
>[  280.937729]  genl_rcv_msg+0x115/0x290
>[  280.938109]  ? dpll_pin_post_doit+0x20/0x20
>[  280.938526]  ? dpll_nl_pin_get_doit+0x100/0x100
>[  280.938966]  ? dpll_pin_pre_dumpit+0x20/0x20
>[  280.939390]  ? genl_family_rcv_msg_doit.isra.0+0x110/0x110
>[  280.939904]  netlink_rcv_skb+0x54/0x100
>[  280.940296]  genl_rcv+0x24/0x40
>[  280.940636]  netlink_unicast+0x182/0x260
>[  280.941034]  netlink_sendmsg+0x242/0x4b0
>[  280.941439]  sock_sendmsg+0x38/0x60
>[  280.941804]  ? sockfd_lookup_light+0x12/0x70
>[  280.942230]  __sys_sendto+0xeb/0x130
>[  280.942616]  ? mntput_no_expire+0x7e/0x490
>[  280.943038]  ? proc_nr_files+0x30/0x30
>[  280.943425]  __x64_sys_sendto+0x20/0x30
>[  280.943817]  do_syscall_64+0x3c/0x80
>[  280.944194]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>[  280.944674] RIP: 0033:0x7f252fd132b0
>[  280.945042] Code: c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 41 89 ca 64
>8b 04 25 18 00 00 00 85 c0 75 1d 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 05
><48> 3d 00 f0 ff ff 77 68 c3 0f 1f 80 00 00 00 00 41 54 48 83 ec 20
>[  280.946622] RSP: 002b:00007ffdbd9335d8 EFLAGS: 00000246 ORIG_RAX:
>000000000000002c
>[  280.947328] RAX: ffffffffffffffda RBX: 00007ffdbd933688 RCX:
>00007f252fd132b0
>[  280.947962] RDX: 0000000000000014 RSI: 00007f252ede65d0 RDI:
>0000000000000003
>[  280.948594] RBP: 00007f252f806da0 R08: 0000000000000000 R09:
>0000000000000000
>[  280.949229] R10: 0000000000000000 R11: 0000000000000246 R12:
>0000000000000000
>[  280.949858] R13: ffffffffc4653600 R14: 0000000000000001 R15:
>00007f252f74d147
>[  280.950494]  </TASK>
>
>Problem is that in __netlink_dump_start() you take dpll_xa_lock
>(in control->start(cb)) while holding nlk->cb_mutex, then you unlock
>the nlk->cb_mutex and take it again in netlink_dump().
>I hear "Chiquitita" from the distance :)
>
>[...]

Well I tested it, but haven't seen such outcome, do you have any script
for reproducing this behavior?

Thank you,
Arkadiusz

