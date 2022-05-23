Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BDE531BB7
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbiEWQ5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238975AbiEWQ5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:57:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908B1B1E9
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653325022; x=1684861022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ITTPOEQ30rIEYuWVpoV0ngcxUk4qTNuHzQbxeHKiE+E=;
  b=iWdps99wGjJd+6qj5G2Hl5KloMVTaCkVPrgJaggK4pkPZCj11xx74+bk
   ETYaL2p6y63+hduFIRpCFu3SQASxXNgN5TT01zkMzlOSTrTdPwqBWINMp
   B7iau/TISCGQ1dubT7E8P+oZfG3Fa0q5MoMXRnIchom8HTzl6or8c6k0T
   00L9c5yZfKKUMUE0HgpbOig94QdYsUR7OkqmfGiI2kE3opWvoP7quNJsH
   nkavCt5HXxGsQ+mPuMWFU3uJ0tEiHHXK+owh05v/B2StHxzFtfevSM7f8
   Rw1C2CJZuH0YxUYhg22hoJb6PhzI7RvkxuXO2N8JN6k82ZNlEZa8an5eE
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="255351348"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="255351348"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 09:56:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="558750264"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 23 May 2022 09:56:47 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 23 May 2022 09:56:47 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 23 May 2022 09:56:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 23 May 2022 09:56:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 23 May 2022 09:56:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmSoyePFj7t9tqoVlsYTCOgnCj6gwH/FaYNxRMIqBrp+hKk3ZGDVY4atZZ7ST1GsuFiMSPtUmd62Y3SFWif8V98cdsL3eD4HsNTDNO+GtBH0Y3vCcoUQx3mvo1x+zuAPc7tTA8R/eAuvycieBksCI2W4ufNiHArLVyb4F2xFcEpomt+2I12MznLyUPXjSieDvl6MC2JVp76PRN93iguQoYx44NrNCrS6xaA+F7+I17IwHOEvsXbrYxWWms29jv7L0rXUCcUozcIEx6CmMnUk8YED9aCoLiRqe/GGex9rgqGPxCM2k99RqBZMGY9EPScQp+R0+1Ud7dsA7H75E0ynHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITTPOEQ30rIEYuWVpoV0ngcxUk4qTNuHzQbxeHKiE+E=;
 b=fMvztErOgnBje6XaeheLuVOeB0/t6FYXf4L1iE1VP4ErIhmGKNNmjCToAlYDJR0k5+iWXCVOjDxuJq53mgjHmjR5tx+qhqHIaTqT33fcCyH6sWThlTp9Qxjzb7RYqJgzYue0b74z1dCO/TwYyJYDsJKGVmvjaQm9oBOKWnoMfGGO26d9r5wD2Z5zU+s80cQ2HKkaipMv9GfFdeDFxFAEAs36WATslaWrSYS98Uy9h0Nz1IEca+TOdo7X8eq2XuRdJqI0A2sXN4ggEOMfClf3RWg4JoQzwrlb3OqnLTlkK7Gl+QTYFm2J+VQDZIiyJcK6lgiuGF+wgsdAOET+8+0gCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5800.namprd11.prod.outlook.com (2603:10b6:303:186::21)
 by BN7PR11MB2691.namprd11.prod.outlook.com (2603:10b6:406:b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Mon, 23 May
 2022 16:56:44 +0000
Received: from MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::798f:5a98:e47f:3798]) by MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::798f:5a98:e47f:3798%8]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 16:56:44 +0000
From:   "Kolacinski, Karol" <karol.kolacinski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
Thread-Topic: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
Thread-Index: AQHYajQ/+5Nk/nCT4Euu3FZzl2q0S60lpXKAgAcRTA0=
Date:   Mon, 23 May 2022 16:56:44 +0000
Message-ID: <MW4PR11MB58005F4C9EFF1DF1541A421C86D49@MW4PR11MB5800.namprd11.prod.outlook.com>
References: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
        <20220517211935.1949447-4-anthony.l.nguyen@intel.com>
 <20220518215723.28383e8e@kernel.org>
In-Reply-To: <20220518215723.28383e8e@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: pl-PL
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 9caaf5ab-1751-c169-02eb-4fb205c0e295
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41fd578d-f3e1-4401-02f7-08da3cdd376b
x-ms-traffictypediagnostic: BN7PR11MB2691:EE_
x-microsoft-antispam-prvs: <BN7PR11MB269182648E14EDC6DEA445DE86D49@BN7PR11MB2691.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: janxzq1Wd5eHFC9FxsEuEWKVqYaM3XS4GKNy7lqlzl5rWSWRM/VjqVNyZJedZtFgxqUSx5scJei+UVkri9wdVTuogZnHDhpoaiZr4nbaNPMShp2e5M0ROVtthSu+gdRXnXNSZXJUB8T5RniAFpBxrURcgMJTWaD/PDI3ThuBt/dArHTDr4mmlHqAPvol79A49vQTvRPggn4SSoCWLS7S5sNqF2wBTmTMzVZpnUgMUePcoeRoYuO7VDBwboLBBWnZxcjMPUt+LG7SXrCjRKQOWIINnVdjuN5KKJlD84606W++vu8JLR/XKEKS1+sV0cSl6qHecsvS3i/UuCKd8buvbHrQBmGtSNFe6dJVMsXsoCWiitCe9jk6QEKYtlOSb2RNWF4tPqsd26CIxEA27JjG0JVK9k/DvnpGOI2uN9P1fw+TythckeaRtusznkavwcbmTd2hIlUEKZFP4uy0AiOv4hHMmPThzHcv7WocImhvymCZ3oJSX4N0foyxFwk31Lk1XE1pkGUvW4zc8IwUZJH2eh+V8qnLngwXdtZFkNcxt2eufPi+NrJa+lNIfLjObcvIWlYKWdF2XGv5iEb2r/nix8mM3eE+pErdVsiMvpCR4A8P91Usm7W3e0qtOMIOebeiBo/qVYKzjARZCw6kYpN5634TN7NwkmpXtBhm8lx9tp+bxZzI8bIw6HMzlL0lK93Y4rMqg8lQ9ne5lVxR/YbHPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5800.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(9686003)(71200400001)(55016003)(508600001)(52536014)(5660300002)(4744005)(2906002)(6506007)(7696005)(8936002)(33656002)(8676002)(4326008)(38070700005)(38100700002)(83380400001)(54906003)(6916009)(316002)(122000001)(82960400001)(186003)(76116006)(66946007)(66556008)(66476007)(86362001)(107886003)(66446008)(64756008)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?DJ4r9mNOVEsii8X4yaCsABsVY9tHFodbIo5yIPkVK6ZdX/44/Ye3xPj5EA?=
 =?iso-8859-2?Q?NOpL1bZki53r8xpc9n0lwy/v+/iLdfphU2JvADwwcrNCCNe5bV62EjzvaG?=
 =?iso-8859-2?Q?HiR77B4yvq8+kBRt0d6iDf+MUnxJFVUbhlszaS/1T6A74VuBvOQTlqmzRa?=
 =?iso-8859-2?Q?G+fjaCMR0o2o4tOUJ+01XTjS1Z0oTRC6bMBnpYGUvQwVl6nrOoPSpg/KVe?=
 =?iso-8859-2?Q?bfOgSMsbdW4iYmTrphuteFAiqHZVnTJIpcxoxu3KUFIZp4wG15X9Sbhwr4?=
 =?iso-8859-2?Q?LptFGHSifhwERFOf1Vj/30S25vbj1ua/jC58hGBWbAaQ1UBhJj18e62lat?=
 =?iso-8859-2?Q?88yXKFWYEAFTfwrwR6TM2aDiE0ndII2/KAaauAbQHD+BuUn/7V1DeSiW3a?=
 =?iso-8859-2?Q?1pi2H6Oz/yT5J9AN8HYH2CYdi8GhUhs0neAOfnOUGMs72lgd69nM+BJQlP?=
 =?iso-8859-2?Q?2C+xp8BIIVtBxXc7fXkEuUVD3F6j40i6HM71cxq19DBD0U9cAmWX1xGMb+?=
 =?iso-8859-2?Q?7Bo12QX7g9gbnckbNgNSi8CBj1Gy7M9C+Q2SfFNZdqGAUy+ae7S7O+5aLJ?=
 =?iso-8859-2?Q?t3uAry22RJ0B2PImBdFYfwt8GGqxN0R5IMnrH6vqLQ/a9AYl/RR4CeDFnW?=
 =?iso-8859-2?Q?jq+vm2yQAs7on0t4LFCvR/24b5Dv/e+O1QVSdlR+Ri3w2blhxaj8pBkhgM?=
 =?iso-8859-2?Q?+aF0y+SaTdqmyYJ4XQ+4oAcztJqjoJ0ODRavFe0xc6l49eu6DvRnzUX09c?=
 =?iso-8859-2?Q?g6TzkAMPDau8sbqx+ahYoFRQN22TJ8h9SVqwXDYH3Kj7FO1S62HeUuD+a/?=
 =?iso-8859-2?Q?C2LV8DyRUO/7KnYrTFugLJa5qpAwtBhntdE0aZonpPVJPu44AhNwdFZeBw?=
 =?iso-8859-2?Q?Qy7I96hHtoYANJwtLLKFwQmOJe1BpsoGFHqU47xL7p/PE5bJ+AJmBnZE1y?=
 =?iso-8859-2?Q?nRnbwjdacmqKNEdy94uITRtYGu2EWRD2qq7kZ8vnnqusGLK5ZGWD1TmJhw?=
 =?iso-8859-2?Q?xj8YPPlytTB1IKi8nCl3whMtUOil+/WywyHWqYHstF1j6Ks+u8BTZ2i6iK?=
 =?iso-8859-2?Q?itab/4Oe/yR4pZP23WLeRvk0f67KvVrmEyDDPSrvbqEsHr/P+9cuxP+oul?=
 =?iso-8859-2?Q?8iS5QF4sriTlQtZf0U5VpmIAo31rPxp7QhYnBCpK9NP3/nRLSztYLmDn+n?=
 =?iso-8859-2?Q?/UOItz3bKDqX4g5wWBFPJDvcUX43hFS7s5YEyK1xMfaoMnAFtYEnlVMRzz?=
 =?iso-8859-2?Q?SRKzVspvmLXMxXSeCG310HrMkxbJkl+x6l4gBp/jMlyTTgDgn8co2xHyC7?=
 =?iso-8859-2?Q?Msel5myxfvr9q9Fz02KWDKsKYDrJiVs1EMB2/BE/WaBROmwsJrwB4DTaUA?=
 =?iso-8859-2?Q?uYNlrxuZuaTI28Ft74hw5B7Wa6kukJdu8P7lGEZ+Fs/JYREB9/theHyaE7?=
 =?iso-8859-2?Q?WHZoM7Nn+YhuSCJWQBqn2Smgbn9KF7+BA9GyaX/Pu6rMurNnkZuOoechUq?=
 =?iso-8859-2?Q?3mcnq9XkYtrh9v6QoYkULfw4iK/zvD3EjaYJBfprXgMjmfvSFqDxgwccMd?=
 =?iso-8859-2?Q?bLqsUiRk9fAKQFnv7jLbmMBMFvLYSXpeDpGhbyMMUVlFlV4x9KJci/NYwN?=
 =?iso-8859-2?Q?w3PqESUjU8VEEgz9STOt0PGzMkVrXACdph6CuEIUZ0Ap/A/ocwDWLViHru?=
 =?iso-8859-2?Q?jToMzQV0A+CMWwdOHcC08Q36P2Uv0GrzFK+W/mJfTGArqy2fEW6G84GwkM?=
 =?iso-8859-2?Q?bkT1LhN52EtY8nZAYKLJp2OxLlVAtmKEGYZs8Uf3ih2JMinIQWVlzh+7a7?=
 =?iso-8859-2?Q?9wtaPQNEldp6t2HPxTYKJ7lavLQIRag=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5800.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41fd578d-f3e1-4401-02f7-08da3cdd376b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 16:56:44.1233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YJcMm2Hd14e3qfVv3Zij41hcW/NVXRooG8MTfV5Bm2WiVutnwNnmJx0++wFu1VDzkY8JrlrDF7UgkzKAczXmrZe0DVJJjiDMuz6/MPXE98U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2691
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 06:57 +0200 Jakub Kicinski wrote:=0A=
> > Create a second read-only TTY device.=0A=
> =0A=
> Can you say more about how the TTY devices are discovered, and why there=
=0A=
> are two of them? Would be great if that info was present under=0A=
> Documentation/=0A=
=0A=
Both TTY devices are used for the same GNSS module. First one is=0A=
read/write and the second one is read only. They are discovered by=0A=
checking ICE_E810T_P0_GNSS_PRSNT_N bit in ICE_PCA9575_P0_IN register.=0A=
This means that the GNSS module is physically present on the PCB.=0A=
The design with one RW and one RO TTY device was requested by=0A=
customers.=0A=
=0A=
Thanks!=0A=
Karol=
