Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C82F633BB2
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbiKVLpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbiKVLoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:44:54 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119D41707D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669117441; x=1700653441;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=UUT4ZZv4msNGBCYwpuTeQ5jss1SV8dzhUW7R+GkEi1U=;
  b=lD5jrwEfAYm/DtA6zATi525pPc63zDwTudXYhFWNWiqVfRc6F6Zyi3o6
   ZksDfY8pNqgaJcx3k2quwTM2rlPOZolU6+FmVfPqj9ScGJcj1U0bRrnez
   nBbqCMfueY8eEP5RzqFosmCad/y8ZIwhgpsg9T+dXmSu9V2qTrBPTVpub
   lEHKEwlf2wcloX8oR0i0dVWTDrxsuSd+gvOqB5Dz54PU8YIGoF0cZMecn
   veFHcVOvePyfGVm/vTwXr9LMXIHWeDixeiUCamlpreK5hdYUiHpB1WCw5
   qRLgt/yDJsAAAOV4u297YaB9UJnz6XIVkDdjn0htFhUWSmIAacF7TLjOX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="378053590"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="378053590"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 03:44:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="747321843"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="747321843"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 22 Nov 2022 03:43:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 03:43:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 03:43:59 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 03:43:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRfD0DDP+oUINwGWchPSixiI3WHBF+W3e6Kv+trUn0S1sTknKFLZn0Mq/b0qh/9T+DiBS17kn6zc15an3D63Bbu9zFQO3BxVFHlRM6NU8qXSg+qjP+h8qD2FpZd0dbxdg9N+CPcYVNgVszLLPW7WNdUGt+FP8uJuLHVfy/rp13AnrQJ0DuclH/TokzUN07Fo/M/Wlb0RupJMc/C4RL6Z6Ns1QC4QnviMlBicDnd5qhnJWn+FwvC0YUkfZIeWCWiGXNHgwaQUObzg9wZp40aaayZfxbAtEBQ+5PIjNdnLNrVbAtFPVqEJZaiIKVdPZF04Q9iYAUUaxyGrVRiIPFfBQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3WTU6jRxNbqtpzdTyjbOh02sQHXyJJPXFnAPjWnQw1o=;
 b=RNzou8HD8QDtLPPitbNh5+d3+edJRMH62tQASARdjRgzlhTBq/Tvm8u19Om1KkdO+8lnY7PyKLIHIHSWgFbxlr+FL3N8Lp720li0cm2gO1M0Osj9fxG2YLNqPhBGx4/w5DOIaqy3fzRdmeDqu/Ks+6bNZX25me5tH1IR29hNlBpbrpzWAfVv/Stp3u/Sb3a+BkpJcUKBhAf4GkFP9Qk2hVSM+TlaDh93N8KOj9nxwvpxpuQrJQjCAksjq6Mf3+qXRSdLgFkNUvaawse7Gsem/7HvzM16pN8LOw8Fvd01BW/+idbcMdwHjoDQyWvSLip0Hupp7ElDSXaB6SZApJPLPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 11:43:57 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::38d9:fdfd:ec27:1da2]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::38d9:fdfd:ec27:1da2%5]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 11:43:57 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ixgbevf: Fix resource leak in
 ixgbevf_init_module()
Thread-Topic: [Intel-wired-lan] [PATCH] ixgbevf: Fix resource leak in
 ixgbevf_init_module()
Thread-Index: AQHY+EN7gk4CjUllakCUC0IB5EQ0Ua5K3sRw
Date:   Tue, 22 Nov 2022 11:43:57 +0000
Message-ID: <DM8PR11MB56217CDE2373674693118CE0AB0D9@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20221114025758.9427-1-shangxiaojing@huawei.com>
In-Reply-To: <20221114025758.9427-1-shangxiaojing@huawei.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5621:EE_|CO1PR11MB5154:EE_
x-ms-office365-filtering-correlation-id: c760b4c1-17c0-448c-e76d-08dacc7ed74f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mV657465h6zWejvIe4oBd892XFyDk2zPd8sR3BzWrfgUuZpYMM0+WamAoVS71r3cppFOQjx0iI7CTXEB0LXBGJDy2sz31KW9iHq0dKSCkeDuw+Cpz/yxOp654t4esb9fuL6IRzV78umE2CNi9cZO6Z4bGX+3MBRzTVxgKjjLFQTZzPoIkP03unurtFVW9egpNOWrqe8ywVgZvmm4ZugiFL0ON32mNQa9zitPDFMh5dV9t01I8+xX8TolvpCSs0bgDyZxv0u24BlCw9kQYZFCt8rvvhAwEYJx/6rEGujGVfaRylJYT5wdSRWYINMu7k86os/yLG04Qcs9+fIAtv+msRrikFy/ZhudSPYcgGJ5Roh+ORGrQcybHJQolZMqr+UiQM7pdjhuuFaW0x8vFd8haC+OwkrFR6C3BuetqkO4Er8sPx25ayzY7qfwbqxW1TwEIun86YWiNcXujk1CmzCOKzVYdfxj7cmL4AoftvTuS+ZIuiEZjSaWjLD+EnTYAbDdKaeeA/SNeROcMNpOt+QrGTtCLTsJX/RyH5ZW19tl9MGpGG4jXGrGQvzY3MsK8OlWaq5MucSFQpP6MsPHx1kLetvh01XAYO5K5t84Nkb+PNM1gzN174Zlxn7kXtKh0eQcfKlI+jyM3ATM72Xmi6WABrthLDspuW+MbY/Ey5kOdLheC/DqfnGpkZRUMY2vDRfGDJo+b7RmWY4Kc8Oi6xUq81P29N/XmlsXIVWWdcs3s49aXUd2hcSR82ixkN01cYb/QHiK7cpDhKOfhhy9IYrgBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(86362001)(66556008)(38070700005)(66446008)(33656002)(53546011)(41300700001)(76116006)(55016003)(66946007)(52536014)(66476007)(186003)(5660300002)(8936002)(64756008)(8676002)(26005)(71200400001)(478600001)(9686003)(316002)(6506007)(122000001)(110136005)(921005)(7696005)(82960400001)(38100700002)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FnbvVpPQLMRdKzywe4ygLSiF96MxEuMZX5xBSXTOZdbwxIPoFVyUGYj45JvF?=
 =?us-ascii?Q?mFk/5G4gtt80UAtrSg4Yk7YDl8OT9s0Ss2BOS9KJnPZes6Qbe5NR/pbqS0z3?=
 =?us-ascii?Q?uCORZiJhCjrxqwwQObm2w/UX5OOmpyUk9uBMtI7XGVUKnKJX4hOSNIYQPDM7?=
 =?us-ascii?Q?Vn81JYPQxYiMRYEZlFpmvnalfr+b7/LYi4iNKKvuaW7/XMQmGLV+48be3mui?=
 =?us-ascii?Q?UH4eZfgNpVV707L/RTbEbMskCj1JdXqJROODLhgDjfZSQAaBGcoDYzkjlfBc?=
 =?us-ascii?Q?QxITXK03+U09YgAELOKJcfOR43fT1j1aidmCTDQXpTw6tDNNb5lxlXt1FBWa?=
 =?us-ascii?Q?q5N4CAYUaTLrAhe9ZQNxE+rO7pY1vNJz94WcHIT0OcTlABFLqMwBAYLwtZlE?=
 =?us-ascii?Q?MBOw2BsEqNuh4Hma2mK9D2tCIEY1d1doKAI02F7ZHWfTK2GYWsenG6LpZcgC?=
 =?us-ascii?Q?piGl1ES1vQmIFjVeH8eZkAlZXjUKnzlcFMZV/GZFqnYM+9EzMLL7Uirph+2p?=
 =?us-ascii?Q?4nFAZkHL9D9kge67Lj5TGhvEaTXGHywzCLDFljvsB4UzvCUNpLgRRasrsKRe?=
 =?us-ascii?Q?bir+BTx3A6Pnzbfr8cR2SHW1c9cnh9IimgZbYdTIGIno8cgHFjotdv7O8J1T?=
 =?us-ascii?Q?++gzwtJaqwDKcaya0gt8xaYOeFfJd/K3DF0bdBqlLNBtFO6yMSeX2xC307nq?=
 =?us-ascii?Q?XDV1cwerggea91RRcI3HD99dN+uAnnIRspqEJ/kCffG89BlqrE31FIlM54SF?=
 =?us-ascii?Q?gdPOY+R6SfO44dxWgeJF2avfDwcplX/19Itty7JSdTOOrTk+8Je0KeWXNKOg?=
 =?us-ascii?Q?IowDKb5n43eL8J11BeeLW6qvdbCcziFyUyaIc7GsMkSd2gkqwhg+sN7OoZog?=
 =?us-ascii?Q?mv80EOsBzthN2HCUTVmXK/xkSBVp7DntVykuFplWEtS5WFw78b/lUO6KUd8L?=
 =?us-ascii?Q?XzrLDK+ZDXqx0jXVb8nhLPvGPRuFcbcL67Ci1VSl7WQS+kR990i2VruFPzsg?=
 =?us-ascii?Q?JT7F8az6Jr1Ltxu926slZFCqZj2HGgGc7iuFXf+dEaW+XARDMtf7TGB0O7ao?=
 =?us-ascii?Q?5IKO+1BXMX6ChGxf2tD+EGq70ymB7lFjnIwB903efHvnQiy+GHCHd0G1zdqP?=
 =?us-ascii?Q?f+7ow1H3SRy49eBOJkqxAEJibR4os3m0kehdGs3EI/ou2faXeTWRds9QNKDk?=
 =?us-ascii?Q?jkNHiiyjk17YVtdQWDXmOiCZ++RvzlFDskkOFUWECs3fVeDURPx0+KwWF6Ka?=
 =?us-ascii?Q?SN5awTrRIAbEhnVrK12BMKEqhJsoxnfhGZxekcb7jMs5cMO9hFUoW5B6c1tE?=
 =?us-ascii?Q?Q22RRE4xI4BGBkzu1uibnrIalKDg1n7cllzQEbUdKPl8qEquQYEr/l7zL7gb?=
 =?us-ascii?Q?fYvuuZLC8vU+RfaIpfQHDij02ABk2crG7OUmYeBGsfQc+TsUA5j/znmRJriS?=
 =?us-ascii?Q?L4n06PD9/MHKrOPEaUOoeCIvPsB3Rgq8Qaaf4DBCJdyw3EzpvWDeGN4e+XY0?=
 =?us-ascii?Q?vy9AyHiJdKXHgnd0CupRaJdE3qilNJMvFr1eZSR1RUbBAWH/+w9NjAuUmHwW?=
 =?us-ascii?Q?YXEsqh1KYWo4+6f2KtrILprDqdOppHFdh3winhvm2IEYNLq4QQ65XkoBfE/3?=
 =?us-ascii?Q?VQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c760b4c1-17c0-448c-e76d-08dacc7ed74f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 11:43:57.6473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pOM/iiVjXx9jntkUOMee9YTESFfAIkY/FwIDPH3OEEtybzs6sHfCiAvvNFwVn2xFDpkJ1IiQPwUccmzL5RD2yVSbBawPgTt3um8Vi09P0F0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5154
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
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of S=
hang
> XiaoJing
> Sent: Monday, November 14, 2022 3:58 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> jeffrey.t.kirsher@intel.com; Rustad, Mark D <mark.d.rustad@intel.com>; in=
tel-
> wired-lan@lists.osuosl.org; netdev@vger.kernel.org
> Cc: shangxiaojing@huawei.com
> Subject: [Intel-wired-lan] [PATCH] ixgbevf: Fix resource leak in
> ixgbevf_init_module()
>=20
> ixgbevf_init_module() won't destroy the workqueue created by
> create_singlethread_workqueue() when pci_register_driver() failed. Add
> destroy_workqueue() in fail path to prevent the resource leak.
>=20
> Similar to the handling of u132_hcd_init in commit f276e002793c
> ("usb: u132-hcd: fix resource leak")
>=20
> Fixes: 40a13e2493c9 ("ixgbevf: Use a private workqueue to avoid certain p=
ossible
> hangs")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> index 99933e89717a..e338fa572793 100644
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> @@ -4869,6 +4869,8 @@ static struct pci_driver ixgbevf_driver =3D {

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
