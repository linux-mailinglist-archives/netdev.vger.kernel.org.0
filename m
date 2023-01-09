Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D4B663087
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbjAITgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbjAITgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:36:11 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CE26171;
        Mon,  9 Jan 2023 11:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673292970; x=1704828970;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k6/svlzUf6FGyFG9Fm8Xh/8XpCZxwj4et1xnrhSiHpk=;
  b=S46Xn/+POd924wmU8mhUoTCfoVlTp1n8SjDnGxh8dmNjF3JvgGAXu9UA
   8jzDukkpVDKwvkvHYNuAjiLiDJrdInwyJjcPD1CQUZjAsogXfmJF9b73q
   MRRau6wwXTgYVZ3JdFvejwGfuhZIWBdSaTWY3DEmhDWo3L6yHVd9/pRc4
   6ihjeR9dvVZcVKYtras82WF267ClpjuV4S/3+a/QumTxrdjiv3XcDMr3a
   ixTcBg8pkXbCH0g9jDuP6/P8AL/qlzFmpTlquOe5coaEMedqaDK9a6X8O
   lPRzgDvjlqDkS8bqgXEmeFl/3J7w9Ry/DvbA7rz1gkH/ekKo2QtRcg6HW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="303325570"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="303325570"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 11:36:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="830718420"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="830718420"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 09 Jan 2023 11:36:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 11:36:09 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 11:36:09 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 11:36:09 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 11:36:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRmEhTqphgHdqZ2VtCbdNxPFIr6p2k6yid07iIzj87PYVjbSoQf1JjBj31HUZhirMIYamnZAFHFZyPzCENmE3BDJDFwno3K2PAtv+jfjc84+CTedvcnCfrTpwFHAPqTNiUi8RUzHyfc0Me/yjf3puJzMA7FynVjmvRjHm0eWSvEpRY80aEEMdP8nUPjP5ROawwv6dTWMW3FaNK4LzKOTUUg4wdTUBJpOs8bOZal4ucKx8wTiAnyNIIDIYH+4oXZl0JYDNA8RsGEKsu+vjHj6zaqwWCqSa/CVmtllKBtkDsj7xls7ElGNBIOXjNqyv95mhUWcS1Sz0ZAsDp073Rqv9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9epwuuoS9+BL0nHpw5CKQy1cfR7xrvbi68KdFpDS2E=;
 b=eJY0Iu9LSXipIBmoL500Oup87Vwl550tIVD+3pS7EFI+adlYXtkUw//7SKKQHQCdCuCggw/rUR6AMqG9kle17kGquxD7G1/jBR0dRkaETyPQmK6ypMoc8lixa+esGB/SfmSrZ7jecr6oxJXRD6SJTLAYO4d8V07zgZYrA0+/R6wD7YRP0LaQKh5CT2uIgcMR0TnrccByYik9mRujS5zivbYDn6EfThhKKAliLCXwChPAqzaCO4QTm4Lit3Sv+9Ifqc/B29Cs4vyxVkCplvqot8fmQ749wuXDIw26rQBPw5xmpY+/13DqMi6W19jBGQeGNwCMesESxgIoUxTTAzg7og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0029.namprd11.prod.outlook.com (2603:10b6:301:67::25)
 by DM6PR11MB4532.namprd11.prod.outlook.com (2603:10b6:5:2aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 19:36:06 +0000
Received: from MWHPR11MB0029.namprd11.prod.outlook.com
 ([fe80::61f7:7850:6203:bf55]) by MWHPR11MB0029.namprd11.prod.outlook.com
 ([fe80::61f7:7850:6203:bf55%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 19:36:06 +0000
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Wesierski, DawidX" <dawidx.wesierski@intel.com>
CC:     "kamalheib1@gmail.com" <kamalheib1@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Raits <igor.raits@gooddata.com>
Subject: RE: Network do not works with linux >= 6.1.2. Issue bisected to
 "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the correct
 link speed)
Thread-Topic: Network do not works with linux >= 6.1.2. Issue bisected to
 "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the correct
 link speed)
Thread-Index: AQHZIaRUDwkvtVlwNkuIokzp///BR66RkO6AgASiD+A=
Date:   Mon, 9 Jan 2023 19:36:06 +0000
Message-ID: <MWHPR11MB00299035ECB2E34F60BC2C74E9FE9@MWHPR11MB0029.namprd11.prod.outlook.com>
References: <CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com>
 <Y7hJJ5hIxDolYIAV@ziepe.ca>
In-Reply-To: <Y7hJJ5hIxDolYIAV@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB0029:EE_|DM6PR11MB4532:EE_
x-ms-office365-filtering-correlation-id: 29b5a8d5-d319-4227-a545-08daf278c05f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9wCVq/uOdha/JpSqqj4z6B24XmSGI2Jr4XPnBD/dPcfL0z11tzUy9in88xrf5FSHhBCByO2bp64cCy05VEure5gu7YqdOKERVfKxeKkYq/adp1vxLBcN+Z1fD8/PEesGMJS3+Tm8gGBBnLM42Vwaq7N3JG2cIJ8/G+ORtjNNiBUZk8hI17E2UsrH2RcoShutmZmRo40ob88IwSAXQ1azeQdZG8nzJ/UN5x8WhABZie72G6UkBzPD70Rv7vNQKTF1akfrdj6cviAcUA9XNTgl/KB9x3r+SQs+1BQD41rdQlLOLJ2/wLAr1VxwdSDLuzONKATepOA+PFtkZBeEFkGEoWUChDoTeKhlVpUKWnhz5hltIE0giCdlCmdMbjZN0A2oCvgi+IzGD74CXkyzgtn8TZoYWND9r8TvGukC8pX9xzNyUDJNFSaVVCyx2ImjAA6pJGGSVNerSifVD6VBW6ekP+afVlq5K2m3Re9Bw5WOmBsthrhzpodDzHhBpM5BhSIKRROGyCxk8LzuRM26jU3r+RohRg5ollmExFmFVuKiwNJSwiypajpeE/uDRrIRgj8fEYihIn+pR8xrzmblM10pXg/YXybRROKc17rZBkpj7iD9Zpai9ZmqdmHAARZBxPx6MQbDR465BsmjkX6H22hQtUHlAYWLaeFPYOipKB8xNuccnAmStmEHUGvAqf6zxOfh+pEEBC5vl6TulmLCiVewlOxGAIaiITmfKDonqxAhETE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0029.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199015)(83380400001)(122000001)(82960400001)(2906002)(41300700001)(52536014)(8936002)(5660300002)(55016003)(38100700002)(186003)(6506007)(478600001)(9686003)(66446008)(4326008)(26005)(966005)(66476007)(8676002)(64756008)(316002)(7696005)(6636002)(54906003)(71200400001)(66946007)(110136005)(86362001)(66556008)(76116006)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vz7QviYLpvjDWzYUN49cySV1wZ1cLBEblI/FRZ92HRm+jeg+ph/w7xTAQS5y?=
 =?us-ascii?Q?U+TalrZe2lm8/xoSaanO5L/Fbj8IjBLVi9y6UHFEG7Ot1rpottunVKVumtip?=
 =?us-ascii?Q?t2QVbDG+9K6FZ5D9J4G46bNoZCrmPRHJpVORP5BrQ58h7RPz8M4uBGKowiIe?=
 =?us-ascii?Q?MpdYYamY09rJE8eiUsBfJlIjiIu4d+Pvyw/B1xtF9GQ/Y8NaQYn3JTY24GHV?=
 =?us-ascii?Q?lloshkBdh7fnnJwxX/5FWQMLO3xoHzuHh177y+5VvhIZgJkB2LR7vtjdYrE1?=
 =?us-ascii?Q?SqzljwaL07E+4+N/KOE2ktcBkOM9DTizjWLewiwhR1tK7bMJxCrmrmr0XlK/?=
 =?us-ascii?Q?IJ/qOpVKYUinfGh3bYE8ifqVUwSUyuZ+gapZ6zVC5u28o/7NZ23f6BvX+soc?=
 =?us-ascii?Q?UACCwqs8g/1Gtu0cUleHGQIx5CROVyCq2DD0NH32o1nlkkM+niA2HS5hSUr8?=
 =?us-ascii?Q?gde7p85RLdLUqfAlpiogKXjh2dkKcjJ6yInPv7W18WjMu7+35ZeFUwfvuiNC?=
 =?us-ascii?Q?XvhSRRhSkTy9nQMLKM9B0rW5AjA5xlvX/0DRYb6l22Vqs2JZyrqd1cL7DNNK?=
 =?us-ascii?Q?g+eSv/cL2QFs9s/nMoJe3qbl9REsAoXlJntOswQjv2PGJxtZm6Sxpy2IszSU?=
 =?us-ascii?Q?M3cfeffexlaItzv2Vc+PVPLZ40T6QJ0hstz4U8hMruMlNbfM1SIx89vL+L0v?=
 =?us-ascii?Q?e1wNOoiAUTI4UjBV48s1jzXi2KeIKjD8sa6Sk5Sbp2hBH20Ij8HRjPAIBNbj?=
 =?us-ascii?Q?dR8u/RRO3OwOx7jPOYqVc7N7Q7HptvJkusZdSwLOYMKc44E8tayO/loDTpnl?=
 =?us-ascii?Q?PhAB01zE16+ZBcXWw/N5ni5WhVNHtULDgi54aigixbpCxRSYsC57q2OxNmQU?=
 =?us-ascii?Q?jxqpQ8ddrRueqWRd19/+XNdNifdq8jcbV0tbpcgRAI+mA71hPvblbsjQGETP?=
 =?us-ascii?Q?93h6ikBsWL10lWeOCoGJ+P8zmz/WjfBBO+mSkQgKimsuYyWPN8Jtz/iIbxDB?=
 =?us-ascii?Q?wY7k2hI9gPyIjBKyj9ekyOfSCbD6/x/vzp1GKL8fWbQdbXjW2/0+zmXn9VDu?=
 =?us-ascii?Q?op4EJqRrMyx0WLL1zptEn6v3MwJSfqjXvXWEMGQBgsOSSL3ia84bRPd5o/c7?=
 =?us-ascii?Q?Z+YOSTvsSj9vD5QwPs4FbhDcwCFKAAhBsmcTXE3p3Ly0PIBdzSjJ0jMexziP?=
 =?us-ascii?Q?rWPwziGH8yefeMh4AZBsLYS6gYbadT/BK7o/eCOFP3QoRnIWArKhGhH31P5p?=
 =?us-ascii?Q?aeWO6K98J5O8NdYBSrI8yphfvxJ5GZh5QgjSgMS3WX9lwqxMFo4xrs8Ue5AR?=
 =?us-ascii?Q?sQF8L8I5o97D0/MKUXetaKlx4pbnihWMFVw2Zt9bfbNGa60IqAVf3J54PqDz?=
 =?us-ascii?Q?0eGl3PQ0+TabQ9pwHU5esHkxBb1jAIyn2J/uKd/ePKkz0uNZRcFWaOzWUFBW?=
 =?us-ascii?Q?SKJTe1LhQp0QFtjkdgsNt3Rlw/Z7KQ9JAULrWntP9FPD0Kmay4Xd6gg8KXQX?=
 =?us-ascii?Q?RopO22SOvPLmj6u1N7bzxnU3tTuBJsVR0RBqrqQs7fXdDijbfwIQI/x8eXxJ?=
 =?us-ascii?Q?7tb1hlkyE/p5UeKWpdLw4Tzn6zn7XgOZX0t0Jzw1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0029.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b5a8d5-d319-4227-a545-08daf278c05f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 19:36:06.3212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WBy78Hnqr0+B+GVWmvyoUdJIAYnwAm1GicJGxtBEG+GX16KaV7Zm0o/tG7q43YsMxuwo631jKIUFiSS0xcrc8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4532
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: Network do not works with linux >=3D 6.1.2. Issue bisected t=
o
> "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the
> correct link speed)
>=20
> On Fri, Jan 06, 2023 at 08:55:29AM +0100, Jaroslav Pulchart wrote:
> > [  257.967099] task:NetworkManager  state:D stack:0     pid:3387
> > ppid:1      flags:0x00004002
> > [  257.975446] Call Trace:
> > [  257.977901]  <TASK>
> > [  257.980004]  __schedule+0x1eb/0x630 [  257.983498]
> > schedule+0x5a/0xd0 [  257.986641]  schedule_timeout+0x11d/0x160 [
> > 257.990654]  __wait_for_common+0x90/0x1e0 [  257.994666]  ?
> > usleep_range_state+0x90/0x90 [  257.998854]
> > __flush_workqueue+0x13a/0x3f0 [  258.002955]  ?
> > __kernfs_remove.part.0+0x11e/0x1e0
> > [  258.007661]  ib_cache_cleanup_one+0x1c/0xe0 [ib_core] [
> > 258.012721]  __ib_unregister_device+0x62/0xa0 [ib_core] [  258.017959]
> > ib_unregister_device+0x22/0x30 [ib_core] [  258.023024]
> > irdma_remove+0x1a/0x60 [irdma] [  258.027223]
> > auxiliary_bus_remove+0x18/0x30 [  258.031414]
> > device_release_driver_internal+0x1aa/0x230
> > [  258.036643]  bus_remove_device+0xd8/0x150 [  258.040654]
> > device_del+0x18b/0x3f0 [  258.044149]  ice_unplug_aux_dev+0x42/0x60
> > [ice]
>=20
> We talked about this already - wasn't it on this series?

This is yet another path (when ice ports are added to a bond) I believe whe=
re the RDMA aux device
is removed holding the RTNL lock. It's being exposed now with this recent i=
rdma patch - 425c9bd06b7a,
causing a deadlock.

ice_lag_event_handler [rtnl_lock]
 ->ice_lag_changeupper_event
     ->ice_unplug_aux_dev
        ->irdma_remove
            ->ib_unregister_device
               ->ib_cache_cleanup_one
                  ->flush_workqueue(ib)
                     ->irdma_query_port
                         -> ib_get_eth_speed [rtnl_lock]

Previous discussion was on ethtool channel config change, https://lore.kern=
el.org/linux-rdma/Y5ES3kmYSINlAQhz@x130/,
which David E. is taking care of.

We are working on a patch for this issue.

>=20
> Don't hold locks when removing aux devices.
>=20
> > [  258.048707]  ice_lag_changeupper_event+0x287/0x2a0 [ice] [
> > 258.054038]  ice_lag_event_handler+0x51/0x130 [ice] [  258.058930]
> > raw_notifier_call_chain+0x41/0x60 [  258.063381]
> > __netdev_upper_dev_link+0x1a0/0x370
> > [  258.068008]  netdev_master_upper_dev_link+0x3d/0x60
> > [  258.072886]  bond_enslave+0xd16/0x16f0 [bonding] [  258.077517]  ?
> > nla_put+0x28/0x40 [  258.080756]  do_setlink+0x26c/0xc10 [
> > 258.084249]  ? avc_alloc_node+0x27/0x180 [  258.088173]  ?
> > __nla_validate_parse+0x141/0x190 [  258.092708]
> > __rtnl_newlink+0x53a/0x620 [  258.096549]  rtnl_newlink+0x44/0x70
>=20
> Especially not the rtnl.
>=20
> Jason
