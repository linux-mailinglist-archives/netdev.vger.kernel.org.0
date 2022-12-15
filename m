Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F06B64D98C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 11:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiLOK26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 05:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiLOK2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 05:28:52 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6EB2BB11
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671100128; x=1702636128;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=sWkpM99nm664GfEt8/enMbUkrbr5zG1r7dslC1rlyhg=;
  b=Tzi8sDDNKwLThGcZoQmTondDCsRjjU8rPCHAm8ruYvAMvf6R9ztG2keV
   9bnu05omKclog2u0IrdgSiRhxUffgGjAqOMzl9jEmxHGcX27RYV+5hZMF
   TSaqTx+dzwQxlXk24kfjYfI1viC/QPwlUpbkium0eeL+ESvMp7yHUqCCb
   AvlWaHZ1/aE6G2Wff7lZe7DUbkzXQNcB9nD2i5FdljZsNk1fO4IROIRYc
   NDSurko18gQmbiRajSF+24NTBiuow8kx+6JluPfmKpl1M1hOfYJqaZupj
   1mmQ1xksWd5RoBpKXyOTu4100Ajye/+oVQqrMVFVRFPcV5gU3plKr6DiV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="298988362"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="298988362"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 02:28:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="649324523"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="649324523"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 15 Dec 2022 02:28:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 02:28:18 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 02:28:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 02:28:18 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 02:28:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ig4f1jlzNAcNMxoapF7igBMpOXkfzu30xzIfk8x5pilY/BilMGMill/h6sjNIBvCNorQtKAT9/WAjB7miUMHPpVoaknzdk5ujaQdMLNJ63hNVlxoJP09ieUEL/+WfA2PAklgVVyD1GRl2naRlZ1i/z69mJCLkJbG7gsm+9hFLl4sk/fwzvX3wUquSJuf45QQ5MCy1kuvDh6Ea+ddDTBCJEPEH9F8AX7h19ni5sBRc6kIBuwQz365WJF6B6kjkGcym5mQnwCYzMsM/7WiBmWK2pj4hkSkOBKA+1W7NjGXpGY9MVFqCliprMXlx/2W3bCZ7Wq4+Xq/3SIVG0AFl5xX3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWkpM99nm664GfEt8/enMbUkrbr5zG1r7dslC1rlyhg=;
 b=KwwiDYqRKcSSA53CbiJEdn4BcVM98FTdpVqQmwvXOgC1oB2YJg3x5X2v3XFO6v+YYb2C36MT1sXncYxzJj1tdtPG/cCHP6uldf7foJ+Uvy6GX2prfzYmRxTnHChnuPchef+a0iDziaVd+DJBLuuDD89IKxN6m/wWyikmlFcKhoutDeFG24CUqfG6THZdA0gp4+H+6s+9yP3OkNfnyY5pEfjmSGXsXch9SYC9k+jQB//GTcL9wdllyXXIJmxh3GzDUpNlbbWrPEyrcSpn0slXLurDzUd6Mu27I2/V+uxSEZaYHV3aTlR0zQ13GVIpjbTdCqQcD05IQ7kO8pKHyjLwPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by MN0PR11MB6111.namprd11.prod.outlook.com (2603:10b6:208:3cd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 10:28:16 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::cfab:5e4e:581:39cf]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::cfab:5e4e:581:39cf%9]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 10:28:16 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Missing patch in iproute2 6.1 release
Thread-Topic: Missing patch in iproute2 6.1 release
Thread-Index: AdkQb9xUC5vmlm8hSd6HD7llrKjh9g==
Date:   Thu, 15 Dec 2022 10:28:16 +0000
Message-ID: <MW4PR11MB5776DC6756FF5CB106F3ED26FDE19@MW4PR11MB5776.namprd11.prod.outlook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|MN0PR11MB6111:EE_
x-ms-office365-filtering-correlation-id: ad879875-1347-422b-75b5-08dade871437
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ukFXiQDAUJBrK2Ulr9JdJtRitAJLKpz9N2UD3A2H4LVZhba07DoUU5U0JZ0IK9Jfhq8j0GbnFRHjZJCXB4c10K1mmbEBRoEJxMjbefvVY3Xt3WIgFXFzvWq48zBPI/3FUcxFPRqn48KikfsSmoWrRHEplsD5zwwk0wYXqng5leQsluU+07RqOtF05psyXvlaX5ka7nbcSwCYuWiC8yGMWMWlSPzUGGi1EZduX1dLJEPykV6m0kJT8wPfWdEebTjegd4n/9AU5WAzXSrCkDzIlGb4loj+4SOyOT5b24eBoheJBnQEXLdhNNdmjGMqJSq+uW/oSG0IDLwArzoQztpKZyZKxg5VUOPw9e3Qjgzy4W4bjRbqxoIszaXZwG4WcdLU/26pPvde+8trkCO331XZoug4XhG7cZRQZ3huPNbWbXaPqDxnxa4QBbj6tDM2cnWeileyMF0GFKjMmgUjC4vxYGuFTuFHanV2yHpURMHmK6CJR5JtjlfWd3/eI/Q769GsFUKXhBh/1lQLdyH29yvc3nqJcxk9AsFVNL3g20fi3HkfHQZIcpvyrAQMVuH0hrppY4lOpWOg9E+IWb3g3gu512JxGky7yv4VjHHrAYb/+CWO1iOfpvuHWfT3EKpIgdIkSssJgivmgWPjh05ljr/FpGLox5o4GPhsQInBITKy36vr8HLxjd1lM+WWFhCTdA/G+ZIVxGO4DPPDXX3qAq4xFEYicUjhg3YC7hfbrlISiHqLELT4TyPfsDHNrvKifgM9WVOdaBL+hcvFwOd6t4zfnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199015)(2906002)(122000001)(38100700002)(82960400001)(86362001)(55016003)(33656002)(38070700005)(966005)(71200400001)(9686003)(7696005)(26005)(6506007)(478600001)(186003)(52536014)(41300700001)(4326008)(5660300002)(8936002)(4744005)(8676002)(83380400001)(316002)(6916009)(66556008)(64756008)(66946007)(66446008)(76116006)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MsEqLtQ0HpL0ddfBkk0xYwbnWCHAbX5VSxuaoaUdYE0QrJQ4CWMp42Hy4deA?=
 =?us-ascii?Q?69rfxZF+gWre0qKHJkE0Cq7SOy6/Q149vkSkhOI4wTx8465YjOHRWdJ999hE?=
 =?us-ascii?Q?Qc0huZJXJFjcca7bfes77vvsEB8rQ6grU44HSCZXlOVbkuVZfNS7N7IWgKib?=
 =?us-ascii?Q?CrT3+ZdXy6Y1VDRHDm4GO2KBQSqag8KA7vmJko5ii2IFPyC6UuJwjTCMwqRM?=
 =?us-ascii?Q?oIcY+8MF0eyl6knQ6q49OzevavyYU6FKqiWH028D3F+buODm+n2Ri+VSIILZ?=
 =?us-ascii?Q?9ZqZWVp2WXGvJx3gCa5ATc9zRcOlsl7z052f/yB8IH9NJB4quQasqj+eybEo?=
 =?us-ascii?Q?ZYtd+vPOjKU3axyf4hR/lP9uQ1W53OTjlmnq1o9pkNXAjGtTo3XJW2W8vIUV?=
 =?us-ascii?Q?EJaCl0oF7JX04/877yNlihokkbU3uOPYTdtQLmjjsrXRq0AHsWwcRwvx4oSV?=
 =?us-ascii?Q?bvjdD7fDYzXMgRgqAweiauwQ/fnr7uU/zZoXyO1lXDqmavC2WvbgXMpeWi7K?=
 =?us-ascii?Q?IXAXOaFMQS1qtVbr/PuHbdW9FoHy8NzkAMCEGfIHkdaAx/GeUDjLVTRpyMdj?=
 =?us-ascii?Q?w1DH7HCh/Z9BMFq0P46TILlYz91oiP34HVFpL6ULAAw941C/uRjH0nQwh+mH?=
 =?us-ascii?Q?WiolNapSciS2GpfNkIaFdXYKL4gk2M43bDmpdvIaBEIMK9rcn6v2m8QezAdt?=
 =?us-ascii?Q?dapiXoc+2bg/xDUu8eVYdCvM2jYvX0PSxpFGVkkmlHJBAqFMwccK+ya0PdiK?=
 =?us-ascii?Q?TVOnIo1pvandC7/A039AduuGfROERJawlBPtzBOnwt7LRSTK22UkiVWx3W+a?=
 =?us-ascii?Q?Lkgx2Cupv/zmNmnJ7jIVYimNw3Er+CTLl9kfDWkZEdNx1FmVhjs6VHYYrh9L?=
 =?us-ascii?Q?TuRsq32B2hWI6HnUkAGtQjRX6daMXTrGgKleeVg3KnxCCPZ4ZO+N2NUahaMr?=
 =?us-ascii?Q?G1LBZt3chPcqxbAAcjBHz6xccca+UwulXgbnkY2F2CQcvdqZ3hH6N57Fg8IF?=
 =?us-ascii?Q?Oc2/OLZUXuRbkvrbm8J0eJH3bwWjgS8HGTupJ+8KY33/KJ/KtSjSC8g9luDp?=
 =?us-ascii?Q?IZ6hP5YSlwjfXWmdPbj1GvcmLAIrJ97JiPpt21nKzbdQBYrhfNzXypQ1xoJP?=
 =?us-ascii?Q?ryLjlZbr6cU64kvZ42MjmKSd8Ak5xvS0HYfcVLuozRWTQFiir9NSZZ+vXKHO?=
 =?us-ascii?Q?j2GIJU/wDwM6nZbBP8Nh3bW+ALwQ9P8miRYT+FE2taFzf+q7ER45Rqc4SnpB?=
 =?us-ascii?Q?0+6EJwCrD4sc0fKcNHuPEfHvsAN6Nl16h4A8dtTOqU43zzC7etEJpY09rrW4?=
 =?us-ascii?Q?L4rjvVy+TyE9WVJ/YSiHL6B7weTex5600af+rxVIr4GARCQ1R8P42kBiOnwW?=
 =?us-ascii?Q?kZKB/vYeW9tYxq/1jBY/OfTuMt82Qiy3gSKWSLO+4u5vZSd90WGC9NRNqNQc?=
 =?us-ascii?Q?jYolWL18DUhkc9krytdSp1cIRvuJP6/lMtHEjSwq97wPj3Ld+VkL9wvXT9LW?=
 =?us-ascii?Q?eYTXkQURZsE99/337YvNSL52wPO/l8YK1nlDsaeK89I6fxKBJW6b//mG0d2d?=
 =?us-ascii?Q?hQjZU4UPbw/ClKVnXYQcFRkuAvrWBjEkT2ctH7Sh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad879875-1347-422b-75b5-08dade871437
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 10:28:16.6851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pO+8JqnnYIm7kkXRWRojxSO3Y+dbi4to93eM7SNnRqaZ4Mk/JWaf3HPeOgAGVppebEMIz6VyC8+OtRplOJuCwJJKVCbWhC0lmkCcuPCmuE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6111
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

I've seen iproute2 6.1 being released recently[1] and I'm wondering why my =
patch[2] was included.
Is there anything wrong with the patch?

Regards,
Wojtek

[1] https://lore.kernel.org/netdev/20221214082705.5d2c2e7f@hermes.local/
[2] https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commi=
t/?id=3D9313ba541f793dd1600ea4bb7c4f739accac3e84
