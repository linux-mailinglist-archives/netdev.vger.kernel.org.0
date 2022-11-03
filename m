Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92360617BDA
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiKCLqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiKCLqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:46:35 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8662C60F9
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 04:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667475994; x=1699011994;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wAYYfPHS1StynSbS6sPVNEMzGBTbyWRgkEbERDuhSyE=;
  b=jcHmSU6zqnfBB7ZsVZfCJ4gYhdY83Q1P5QdVbRXbu/O7N2pgGEzprMlA
   HmXKF5rg2XeJGKCdUS7/5YrHAlRjvzSA27XMrAd/Q9zETrvQJkRdsuZjB
   g6ZMDPwla4YuZ2rBxJ1rxG4eLbFFwO4NAQB2/2Tj/+Zc1sCg0lI3yr9pE
   esiQOEZw3ccxyc7sJSB5efrZyB3iDVqxNs5yyH3eD+2IEaKh1uRISmdvZ
   2FKA8TEu0gEi/+TMtDzMhZQcNpLki5GhW0Oyh7ygd67ckMFYcnKEWJRvg
   MhBU9u2voMCbcxm0e61A+GlYSJZW0NKgcuV1+WwkxHcwJCb/ZXmK/D9Iq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="310775364"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="310775364"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 04:46:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="629316927"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="629316927"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 03 Nov 2022 04:46:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 04:46:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 04:46:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 04:46:33 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 04:46:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8qD7aPWzzURATpRnhCyUFX5LhYQ6CsTlmJRvfd0o6biIz6r52loFJStu452Jsd2mx1X/BtlEuqEGoyXvSb4yOpERuGJyidHn2oDcBsW9ttFfGPR5NIWMn4XVppv4cm9giEH47T0apfE8cpplBxtoCBaqUn2b+o7hMR1VA1nRXzbQiEsatD2ctekJ5+W8Kow1+U7uYtL6jShhV0KKqd3Fqsc5lNEYboB9r10mgHa3/8vf2MlFmcYOLibPAHE+XGQlnyy7Ym7itb63m4H0XVjKcvZllXooWc37f+roGewTKaExZGLSTQYAA1qdxNlrJ9l6b9buOn83OdknqHrAFcHrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjeHYVRy7YJVrrbh6PGquTHG6k57xr82kmjZmcUkBJ0=;
 b=lshRbW3hGMuH7KlqYWvj74aeCjPkk1yzClwm2UovjET2DrsAFZrB1bGkwF5CZYk72/jnM88q8NHDBXc7gKBFgU+urVUE2zRj/MMfxFMALIBqdVXxCNu0YSOYu40YPICVnqjuQgZafdJOd5iICMrND6vChbhCg9qK3S0QhVfMIqnb0hgB5SfP+3r25QBFbybYaSe4yIhzWE65cbMg4AjhRyn6tjGnUgtDgHwdmylxOyp/ki5clUxQ6ZXYdI5HLAQB6gHIn7uf5ScCxvrw5hFyFibnvmUCc3rmGs37J/xJIbaWKVqsw8mAZU6uTCSG/CthgJxhgccuFP4XXLtpXqFQ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 IA1PR11MB6292.namprd11.prod.outlook.com (2603:10b6:208:3e4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 11:46:31 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::9f29:9c7a:f6fb:912a]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::9f29:9c7a:f6fb:912a%6]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 11:46:31 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next] iavf: check that state
 transitions happen under lock
Thread-Topic: [Intel-wired-lan] [PATCH net-next] iavf: check that state
 transitions happen under lock
Thread-Index: AQHY6tTJfMKifXJujkGGfUlXAB21064tHg7g
Date:   Thu, 3 Nov 2022 11:46:31 +0000
Message-ID: <DM8PR11MB5621D36AB45F5BA962527766AB389@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20221028134515.253022-1-sassmann@kpanic.de>
In-Reply-To: <20221028134515.253022-1-sassmann@kpanic.de>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5621:EE_|IA1PR11MB6292:EE_
x-ms-office365-filtering-correlation-id: cc22ee2c-b2b6-49af-fa53-08dabd910d16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C+/7qUFln80m472BTMKp+QRKTqD7eoViDQj7s71sZ5+4ccTDcpITzeQWmuzinwpJlT8cNDrw6OG7ynd1ChA3yp2Y4HjqZA/TjZ/1kuU8IfSIw1FKRkGAI8J+taFcxyka6ukLW5lY8QvuGczUFh6D1CzyonDYHZL0nAfKgjhbsrUIcLqnccVK86qwcUBvk22u7n463QN5cswi563ciCi3AuPr1I8uIKGb8C3Wpu7m22fjPIAVTjOw+N/mcCkN7h7ky/PdJRDefHdcyBIDhKQxmKeSP8e+d5JLyjhp+5VDR6uf1vDY8dVA3zesK2/n5/MtawjmOdNAstcT9wIwnHbgtYmcku+1KWCTyxuekGSzgNq2xOGvajcRAFSAhJgVCJdhT9Q9iSnpx+dtPiyhQdj4ifMgY6h94YsJKjETD0zAWAs0A0hoSDvBwKoTZ8lfM/SgkVR9DOMUKB7BK8xIDdSxCHIqg8aV5HS0+DwpQ+Hb7fiWMEASKbtOLDVE0J2o71sSvat/qbeGXo/vES32jG4KZhDfVhqQCUu/+SJhJAAGjMWr5TP6tPeINIpocXlUsTvhhPuedByGLPE/rMgIQ3O/4lAtTUd432m0mKiclDbIltuMav80ppLaf6jH/NA6woMVCTF28YN+tVWSGnawwtXVP2E2+HTb85gvX/FujrmK/4HQEIPAoe3IITqlNjBSKCnwxMfZdoA6ZeSJeCYxG60DFCwI3cTWNUd/oHOp7aKBSkbt7a/fIXfuE5n9b1+S1vxY1mEdYm4grmLZQcPHFjQkwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199015)(33656002)(82960400001)(86362001)(38100700002)(38070700005)(55016003)(2906002)(107886003)(53546011)(9686003)(186003)(83380400001)(122000001)(6506007)(7696005)(26005)(66476007)(66556008)(66446008)(64756008)(316002)(110136005)(54906003)(478600001)(76116006)(8936002)(4326008)(8676002)(66946007)(71200400001)(52536014)(41300700001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZZopKrYF+RmjebwsWmfMh64ix82QWiDKkW3UKcl6ElnLh4ZiSAmoFfjIrVlz?=
 =?us-ascii?Q?lJbEyQVYOznjYYEj+pNUzlQx5w/a8hZumF/JjoIv/jno/kNq/CNzfE4/zLvA?=
 =?us-ascii?Q?te9z+0OK3o7Pniewm6Ikk50VaWryR/N7rlqktXdot0MoWZZnAh8i5Updt4Sz?=
 =?us-ascii?Q?ymFodS6CshjnR0OsDe9gQHj7QxvHL/r5/qKOX42tdh8p4Idk5nSjy72Q/O7r?=
 =?us-ascii?Q?eZQN6J5cNyL+nxlqSP9gUKe0oAjzpD0rSdNRXuaUP/xfZ8TBxD0yHjiTNhj9?=
 =?us-ascii?Q?biENgLEZNwYEyxnYURKwWx0ETUiYkblwPIO6HqlkjTjoamrtVCtkrIISiNko?=
 =?us-ascii?Q?1TwLPc8qPUYHVhK3o75JfUOJdtmHRGs88HtQ7xIS+jP5MkVvN0rKNa3R8+qN?=
 =?us-ascii?Q?05MUQ7AAoutYh/sGMzkn3+wDPL4wCUuA5PL84CX+WfWWaXu2IfILLd50PI/A?=
 =?us-ascii?Q?ySSQsPUwqAsEvdQ+7LmWLple59ET+VPD8O8Jl85Maaq9UCSm8MXQ2vO9dYTG?=
 =?us-ascii?Q?ozXyBzzr2/HhvldoQi2QeRlF6nyC0HuFJb3rKBlidgBVkIyRqMHRaLZb7kpA?=
 =?us-ascii?Q?EaGVhtGdntBG2ivLTbOOYxxtYkwWn4lU2uE5USQFql9G4N1zR8+NEHrukk2Y?=
 =?us-ascii?Q?f5x5onz9JVCKKm5rvG/SOFM+vF7DNAAx2n9VogP+ciMO97UPRzlUept54HR9?=
 =?us-ascii?Q?kZZXY+eM/0LUbJBKIE5L3F1yCrTicv/VI0wZv1xr/OFA+2Uzoy+CSNjDg4XV?=
 =?us-ascii?Q?EpoL1jEp2n+1oS5j+dcu/8P1NndFXL6c/ThICJnhTKrdAEgZCRYoeDgRYeYW?=
 =?us-ascii?Q?SWakcg1vLKK1+bgBFr1WXQJM2+4tqc1jmZy1KWL/U42mO0MSdhV1s3/eVTEs?=
 =?us-ascii?Q?rc0WZGy/NxQozUDyiEGyXXpXMGKTWH1WCHpPzS1Q6NdmuMoTkwse80+LQ49c?=
 =?us-ascii?Q?DT/FtXkkjwoDqvPXRsPZjejan19N5Y8tqiZZQ7ga9xsu1n73bYqFZWty0Hrz?=
 =?us-ascii?Q?3G0DDdQzYCkT2dWCM7P8aE/gp3cCdW+XNq+PZ4YdhgXeTOZdS21w9HKvxus9?=
 =?us-ascii?Q?0Ly4c/dZL36zuGJNAWZK1xxdzbgxz3QRCJnbgyiNyndBbUZYwmrjTeXyuOMX?=
 =?us-ascii?Q?AOucFtmVzgUtgA63fZf9UMEdY/jODKF8uX+6mQ0DrRdpAkJ5tN8q/diWxVO6?=
 =?us-ascii?Q?iq7439tsaT+Ymuy0Y4zamyxa0Yzw4c2Cl6q0G0fc5ckW4QHvoLdmLCLQF7K/?=
 =?us-ascii?Q?S3PEIsfM8NykH60tg489iWD7oIFAO1v5d1nHSjrH03pwnAdFmkS4q4fTsada?=
 =?us-ascii?Q?Llu+yuHxV5PC0xxs/5FjFk2u5tdifxI1mlDqy2fl4g8wJSIgA7WfsBoEGf28?=
 =?us-ascii?Q?TGE6a1bX7FTts9U5tqcQH03LHf1fMH59e1f4RHRlj3qxLOoIEKayBO+XMLU5?=
 =?us-ascii?Q?xGI0JpXSol2InbTSsjgTmFhvwVVLW22z/RJXm4Ds0gQIdIEwNbyVb9iRTGqv?=
 =?us-ascii?Q?5u4TGN/RReouEPdauyDSXFGyXYaqKFxXPqP8xOX1mSM3WE7sgO6LA/pNros3?=
 =?us-ascii?Q?tSmzkRZWkbKo8wLuUikM5I2GWet8snEvc2I3kFDxD6KE/xVGejJjCicQNOqj?=
 =?us-ascii?Q?RQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc22ee2c-b2b6-49af-fa53-08dabd910d16
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 11:46:31.3707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K7FZBtycKIHupzcE1ZK5+Vyuot4K6EgfnUd44wd67wxhIrxgkramoySC5SAknRExwIXb6zK275HRSpsN/kNJ6xwyfjyCYdTlWuHFO6xm2oo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6292
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of S=
tefan
> Assmann
> Sent: Friday, October 28, 2022 3:45 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Piotrowski, Patryk <patryk.piotrowski@intel.c=
om>;
> sassmann@kpanic.de
> Subject: [Intel-wired-lan] [PATCH net-next] iavf: check that state transi=
tions
> happen under lock
>=20
> Add a check to make sure crit_lock is being held during every state trans=
ition and
> print a warning if that's not the case. For convenience a wrapper is adde=
d that
> helps pointing out where the locking is missing.
>=20
> Make an exception for iavf_probe() as that is too early in the init proce=
ss and
> generates a false positive report.
>=20
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/iavf/iavf.h      | 23 +++++++++++++++------
>  drivers/net/ethernet/intel/iavf/iavf_main.c |  2 +-
>  2 files changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h
> b/drivers/net/ethernet/intel/iavf/iavf.h
> index 3f6187c16424..28f41bbc9c86 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf.h

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
