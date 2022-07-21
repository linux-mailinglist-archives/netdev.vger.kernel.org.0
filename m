Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7BC57D3A6
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbiGUSz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbiGUSz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:55:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC521C927
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 11:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658429755; x=1689965755;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FdA16eqtbpRaR5NRhtzBrk7MaflNXQrTYwz6H9+A5AY=;
  b=AOdo7RXK9n3V2iRH+j6URRsek56bbroacXPEtuBYwysuFzneBJ1j2lks
   sEr3zGqL0xPqadqhZEpWXZVDdjve/fWKoRfnkPvLXA1BQoPykdVO+QCho
   qRyE17XYkNL0kJPP/5ItXzyR9QPy8hB87RHJJXLqU8H4vqK3UIp/9Ez/2
   HVmnZ1sD7fDll3FCDxh241+9jJx+8K0JBK/4SVnmFQcQNE7DruD8sLBUP
   xpF0aFYuini4tX9XfLAtENChOYUStdmjTt2G95o9CuKEbDrweMtRbDtcW
   im6YOZ1yj0ilYycf4RFSWSvo3dYddnMibsDgaPiAZSzWK7qnm58scRcA2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="267544930"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="267544930"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 11:55:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="573868203"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 21 Jul 2022 11:55:54 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 11:55:54 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 11:55:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 21 Jul 2022 11:55:53 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Jul 2022 11:55:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euC9lDnFWq+OC0OaujFDiHk2W7uA0GIB0KoTUgxb9EJr76pxdiA8AIdTZ4AzZ/leN5G8M49VHTEVJf9RMk9S51bXV8KdCZ5EiYzWndh9d0Ipmi61Csm/v2TLWOznltYdA/9vFJQIvJe4ncd6qxEg0IxMwhOsDJnAM4FHWeBb/7n+nXq9wux5yThjpU+bkZHqqlkphLktMdYOvogCPICB0Xsu2bR5WB/xuJGFeHtm8vUeRlkwLA8YSTUS1eJJhUzFJU92/d6LMJ26VjeSXwIsSA+WBuvmd3VL1/hftkXfWU+Re+jbokDzHv2IftuBa+w02dRmDXqIGj9dmJm0MHaVaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDlG99NLfh2voBlHZKtsyTRwI+ltUU2Uxt+4Tjuv/FA=;
 b=QZ0Cqyce7plclELsjMwG77ozQn77rWkNhJN/OCtNzSLrqHHE75zYToGILsKPw35YYYFsHdUsLqVqXJl+jXTXoCpY86moVFMN7m821gQuiUMALS8tbJp8q5wLue4rosjyc1Ex7msDZlmtDVMAeHsVmhW3WFvJfOKHTmvBgxhCzuCTA0oj6LdfC/4mUXN+pyaJGFZexFvpTu7LkXag1z83Rd90HFLxwLXKK/JCJ/YenbtQ/dkF/G/A1I7dOOS4tAfYqZup/+jBD2tvZO2q2mhpEAUhJHeM/6zieqR0CIxCqz5Yfzw+kAmHCOW2jCUrMfrH3W8CBjRvu7CO+m1mK4O1sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by DM5PR1101MB2139.namprd11.prod.outlook.com (2603:10b6:4:56::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Thu, 21 Jul
 2022 18:55:48 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 18:55:48 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [iproute2-next PATCH 3/3] devlink: add dry run attribute support
 to devlink flash
Thread-Topic: [iproute2-next PATCH 3/3] devlink: add dry run attribute support
 to devlink flash
Thread-Index: AQHYnGdxjDKJe3qDykysrHlj/Yx2nK2IVUYAgADYzuA=
Date:   Thu, 21 Jul 2022 18:55:48 +0000
Message-ID: <SA2PR11MB5100ECFCC7609C2067EAF022D6919@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220720183449.2070222-1-jacob.e.keller@intel.com>
 <20220720183449.2070222-4-jacob.e.keller@intel.com>
 <YtjrQhPVw1ZtBSAN@nanopsycho>
In-Reply-To: <YtjrQhPVw1ZtBSAN@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3449c8b8-38de-466f-1dbf-08da6b4aa03b
x-ms-traffictypediagnostic: DM5PR1101MB2139:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0UxuKtpAl/9vauzP5qbUJtI+LpD2vBTFsQVmgPPSjvT13+kH8ZC2UpiOHDRx5BnzH+rXeSNQHXcrk6jJLMR7Yvx56gQbVoUqJdlo2wKj4HfxodLKgB2YbGCZUfH/bW3/xa+xFxy529mEqJzzey6At617oMxm81F2eVoE0Rr6EeYp/iEJ/hC9hqzxr/q8zltpyNu41xeoQNwbeYXW3YKPxHr0SN3QDA0kHsIiskyz7jy2wXA+ZAoUtUKle1vlhrlgMuaX/p7gl4DOFjI42IdOsG3v5HvD0hFnvkl6i6oPm6AK+2X66jaGorqGRwP5ZkLrpQ3+iVpSshSOA8TWlsu1OtsOR7z8ToUnkhCelLoj3cov7Ay6kgpD+ZIfAQh2kcsp0kyPuvrWHenLg19dBmGDHF/hwZ7Tzt40Hsm+wPWwwpEaXCK/YBn1n0jTMiDwjOod+LhZYsnvN4qioDM1s3u8N+5FlHtGXzYSuBvGWg9Jx+29MF9EePtoddkkXOaoZDU7uYtrK79EWHf+8ESluS+qu7uTuoX22m/ncalooY2lTtFxsmkTTXVRHO3t3ppH5FsN5KwEY3Sw9/ZwkEz/rZNmxhID7ZGd66g+5QAKQ4x4UHr5Q6XSP8cpXdDWbbHe7syImj9gR2vxsY1CUuTfmv4vvlfePQydSph8TIY7zf7z+zrgnMiGWQHffG7IJ9kCs/0b+bB1Em0OAM9cPZbbn1Ie/owbDfpIlwtifFdmKU8aMWkhtmZ1kX1awFjcTuWdbmsU4wc4h627HpGQdTGOQVjjmyT7/9pOFGReyqXlOqTWm7g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(346002)(376002)(136003)(186003)(316002)(478600001)(41300700001)(26005)(6506007)(9686003)(122000001)(71200400001)(5660300002)(83380400001)(2906002)(55016003)(4326008)(54906003)(64756008)(8676002)(66556008)(66476007)(33656002)(66446008)(52536014)(8936002)(86362001)(82960400001)(53546011)(76116006)(38100700002)(66946007)(7696005)(38070700005)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NdwGoyoDbN8LX5mf7BTTulPLIR78ySw9ehaHDTskqlgJSO3U+eWmohejz3rJ?=
 =?us-ascii?Q?IvNchK1A5h8KzZKPM5J/yQyHg7PJVgkIvQmdd6IUwV3p1TlDNi8caQO2DT/I?=
 =?us-ascii?Q?O6dTfuf3x9jqHCM724/VpA/ca9CorJgcVxr+fRGQ5Rcsw256ACLCIHvZLvhK?=
 =?us-ascii?Q?j0j/sPc0mCG/wuyTx2/A9boF4P7eGyJrVz34OpbQMW+pbE29Yj3ehVC89a/J?=
 =?us-ascii?Q?w1r46PtfkNc4a7lQpBa4+z8LiCpKUG73DoLFsahyQC0canjXPAJBNpaN804l?=
 =?us-ascii?Q?3hEnLvj5BNOOkP7t1rek5l27FH/MKjyHbaUXaT7k6z+9/1K7PspU/3MORgnT?=
 =?us-ascii?Q?4rZxKBDw7HNVOzVyFxUlZlncKj5dpGnnxSirkpoNPqHwYcw/wjrT9cH704cA?=
 =?us-ascii?Q?ZtWIRWB2urGXpudGBNv97W8NmNu/wGX9TtPi9M21ML3kbmJwNBmtSGC4hzrV?=
 =?us-ascii?Q?7y0/asLTixvIdma2ltryF2c8kf4Jj0NnnkHfD31xABFMQh01MPo9x2rsJr+X?=
 =?us-ascii?Q?bdoAmD8+oMapVvwRAgvBqjr0tIT97Pz1+CLzOO+frBxkckkfEBoMTHj0PzVA?=
 =?us-ascii?Q?AXv/WszKyDiDnQB9P0ofK8haa/Kujj7H7diQWOUvKCIgMXG2jnT8svg5fOc2?=
 =?us-ascii?Q?c3OgDj2pk/kfES1JSsFKBmUApx4jzx5CLCaKnHHlIVIEDcti0hcKccMWhu7+?=
 =?us-ascii?Q?/ktq0Sv35oe8sXVTd1eH8bk9oddGJHmXkklF7rsX5ZMyJnGiiBK7tc0v0+PB?=
 =?us-ascii?Q?nEE+E/JppsjXVHVnl46LLHoQqbt0C92Y5eBZ48sBELbmVA8Qu4GK3WiN2dY7?=
 =?us-ascii?Q?EwFMza0DIdK0csO+gqhuaUJroHYyU7y2f4MbzQX1rvcgy7pWivoWUc9OLoG6?=
 =?us-ascii?Q?hZauT4gg6HvM259TVvQFvUAmuE8698Wi6e/J8h5lWqMW8gaXseM/pyrpl3EG?=
 =?us-ascii?Q?B4S4MLhlObIkncBbEPHXCyMylIiOaN7BQOCypRp9j5GQlHyeFR9j8M+bPUeo?=
 =?us-ascii?Q?b3CEwN+b9FSYSRyIYWpGc8yRvOc+WDRc9thFbZgntk/26FsqjLQkVdL/uXTl?=
 =?us-ascii?Q?C309c83f0SGE82XrO4dgt7/dgzxOprxGvwPTSMTTg2x6TAbvqRqbWDolRtyL?=
 =?us-ascii?Q?qdCR2KUDquWV61SAVvNlnCl3fxLHPKV0N9uJy0+3ovx1eoIAmy3v7IFihXnC?=
 =?us-ascii?Q?FD+6bbrVNmEhchITK9hyQKajS/PfRfxEz9l9d2dWGDzHJS11DyqyEs/GAMhH?=
 =?us-ascii?Q?bC4/yoJK5/61b4bkk3Eyd+hQUOnqCrMfWz/Mixao/aUC+JxzoSE0ptZ6qUiA?=
 =?us-ascii?Q?WYaXn7NtXK5eEm4pjaUWuGmWCVsl1FuzUU/HyxxQhScl365yvo9DfSxN6wG9?=
 =?us-ascii?Q?X/VhEOnzoBdMUbEPX3aknsrbQ0B4nFtMMt76bJPTJaSnqbdDmrIKWtcyUZHa?=
 =?us-ascii?Q?a3rf0yDEzSNtO7wtNr1GLzAF1/3EECTdrjEEbJB43Gk6KlR6PtZeru4XKZp0?=
 =?us-ascii?Q?xno8/yVFQ3w+INyXyd5nt2EWMQAFsZZPDbK5t7ZNOoxxTnsecrXzvlI7ZwdJ?=
 =?us-ascii?Q?zbivUDB6K4CY9tgHA+UTXtnLyajOmQJ+upP3rkfJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3449c8b8-38de-466f-1dbf-08da6b4aa03b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 18:55:48.6170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YgIpiaOzjHojdqJ1HyhS/Yd4M+2kA/erMnd7p6fQLkZQ0fsb5Lh7Tfn2PHYMQ4+wDM/QQaxumEjs61loF3XC+37mLpd4FsRJ5ByoGZzqf+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2139
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Wednesday, July 20, 2022 11:00 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
> Subject: Re: [iproute2-next PATCH 3/3] devlink: add dry run attribute sup=
port to
> devlink flash
>=20
> Wed, Jul 20, 2022 at 08:34:49PM CEST, jacob.e.keller@intel.com wrote:
> >Recent versions of the kernel support the DEVLINK_ATTR_DRY_RUN attribute
> >which allows requesting a dry run of a command. A dry run is simply
> >a request to validate that a command would work, without performing any
> >destructive changes.
> >
> >The attribute is supported by the devlink flash update as a way to
> >validate an update, including potentially the binary image, without
> >modifying the device.
> >
> >Add a "dry_run" option to the command line parsing which will enable
> >this attribute when requested.
> >
> >To avoid potential issues, only allow the attribute to be added to
> >commands when the kernel recognizes it. This is important because some
> >commands do not perform strict validation. If we were to add the
> >attribute without this check, an old kernel may silently accept the
> >command and perform an update even when dry_run was requested.
> >
> >Before adding the attribute, check the maximum attribute from the
> >CTRL_CMD_GETFAMILY and make sure that the kernel recognizes the
> >DEVLINK_ATTR_DRY_RUN attribute.
> >
> >Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> >---
> > devlink/devlink.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
> > 1 file changed, 43 insertions(+), 2 deletions(-)
> >
> >diff --git a/devlink/devlink.c b/devlink/devlink.c
> >index ddf430bbb02a..5649360b1417 100644
> >--- a/devlink/devlink.c
> >+++ b/devlink/devlink.c
> >@@ -294,6 +294,7 @@ static void ifname_map_free(struct ifname_map
> *ifname_map)
> > #define DL_OPT_PORT_FN_RATE_TX_MAX	BIT(49)
> > #define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(50)
> > #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
> >+#define DL_OPT_DRY_RUN			BIT(52)
> >
> > struct dl_opts {
> > 	uint64_t present; /* flags of present items */
> >@@ -368,6 +369,8 @@ struct dl {
> > 	bool verbose;
> > 	bool stats;
> > 	bool hex;
> >+	bool max_attr_valid;
> >+	uint32_t max_attr;
> > 	struct {
> > 		bool present;
> > 		char *bus_name;
> >@@ -693,6 +696,7 @@ static const enum mnl_attr_data_type
> devlink_policy[DEVLINK_ATTR_MAX + 1] =3D {
> > 	[DEVLINK_ATTR_TRAP_POLICER_ID] =3D MNL_TYPE_U32,
> > 	[DEVLINK_ATTR_TRAP_POLICER_RATE] =3D MNL_TYPE_U64,
> > 	[DEVLINK_ATTR_TRAP_POLICER_BURST] =3D MNL_TYPE_U64,
> >+	[DEVLINK_ATTR_DRY_RUN] =3D MNL_TYPE_FLAG,
> > };
> >
> > static const enum mnl_attr_data_type
> >@@ -1512,6 +1516,30 @@ static int dl_args_finding_required_validate(uint=
64_t
> o_required,
> > 	return 0;
> > }
> >
> >+static void dl_get_max_attr(struct dl *dl)
> >+{
> >+	if (!dl->max_attr_valid) {
> >+		uint32_t max_attr;
> >+		int err;
> >+
> >+		err =3D mnlg_socket_get_max_attr(&dl->nlg, &max_attr);
> >+		if (err) {
> >+			pr_err("Unable to determine maximum supported
> devlink attribute\n");
> >+			return;
> >+		}
> >+
> >+		dl->max_attr =3D max_attr;
> >+		dl->max_attr_valid =3D true;
> >+	}
> >+}
> >+
> >+static bool dl_kernel_supports_dry_run(struct dl *dl)
> >+{
> >+	dl_get_max_attr(dl);
> >+
> >+	return (dl->max_attr_valid && dl->max_attr >=3D
> DEVLINK_ATTR_DRY_RUN);
>=20
> This looks like it would be handy for other attrs too. Could you make
> this a generic helper accepting attr type as function argument?
>=20
>=20

Yea that makes sense.

>=20
> >+}
> >+
> > static int dl_argv_parse(struct dl *dl, uint64_t o_required,
> > 			 uint64_t o_optional)
> > {
> >@@ -2008,6 +2036,16 @@ static int dl_argv_parse(struct dl *dl, uint64_t
> o_required,
> > 			dl_arg_inc(dl);
> > 			opts->rate_parent_node =3D "";
> > 			o_found |=3D DL_OPT_PORT_FN_RATE_PARENT;
> >+		} else if (dl_argv_match(dl, "dry_run") &&
> >+			   (o_all & DL_OPT_DRY_RUN)) {
> >+
> >+			if (!dl_kernel_supports_dry_run(dl)) {
> >+				pr_err("Kernel does not support dry_run
> attribute\n");
> >+				return -EOPNOTSUPP;
> >+			}
> >+
> >+			dl_arg_inc(dl);
> >+			o_found |=3D DL_OPT_DRY_RUN;
> > 		} else {
> > 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
> > 			return -EINVAL;
> >@@ -2086,6 +2124,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, stru=
ct dl
> *dl)
> > 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_NODE_NAME,
> > 				  opts->rate_node_name);
> > 	}
> >+	if (opts->present & DL_OPT_DRY_RUN)
> >+		mnl_attr_put(nlh, DEVLINK_ATTR_DRY_RUN, 0, NULL);
> > 	if (opts->present & DL_OPT_PORT_TYPE)
> > 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_TYPE,
> > 				 opts->port_type);
> >@@ -2284,7 +2324,7 @@ static void cmd_dev_help(void)
> > 	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n"=
);
> > 	pr_err("                              [ action { driver_reinit | fw_ac=
tivate } ] [ limit
> no_reset ]\n");
> > 	pr_err("       devlink dev info [ DEV ]\n");
> >-	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [
> overwrite SECTION ]\n");
> >+	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [
> overwrite SECTION ] [ dry_run ]\n");
> > }
> >
> > static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
> >@@ -3844,7 +3884,8 @@ static int cmd_dev_flash(struct dl *dl)
> > 			       NLM_F_REQUEST | NLM_F_ACK);
> >
> > 	err =3D dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE |
> DL_OPT_FLASH_FILE_NAME,
> >-				DL_OPT_FLASH_COMPONENT |
> DL_OPT_FLASH_OVERWRITE);
> >+				DL_OPT_FLASH_COMPONENT |
> DL_OPT_FLASH_OVERWRITE |
> >+				DL_OPT_DRY_RUN);
> > 	if (err)
> > 		return err;
> >
> >--
> >2.36.1
> >
