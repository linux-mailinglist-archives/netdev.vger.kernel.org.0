Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8182E58AE35
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 18:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237641AbiHEQcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 12:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236318AbiHEQce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 12:32:34 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F2BDCB
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 09:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659717154; x=1691253154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dMBkOBNLC93v0ocIseAL8fEPQFJGOP8yVVH6QM3Zoaw=;
  b=deSKAzUM/YVAecYy3kcjluVLVpGvTVsXxwRmwkefnDHTCgGnFBohHYPm
   RcGe7/akDyHZf+lXzlF76OMRMeFMqEqKvtAMShx+RkVkCcaMsZVh01+3E
   xlaTqR1QzS9+tP7Vr4utXw5eUCr7S79wqkTV8W8j2KI1DRhKhy1c6aTCV
   AyvuMnAQCjzs92jIo2BX437hx3Su+CEH5H/LUmssAzayqDNbAoXr0qswU
   OCardLM+OBLhoK4r6s7AX8I8GKxx+kxBhyPIQfIByogMC+aem8lMvkCsH
   N7gWNbvHq3Uu8k7fSZD7dYIkEoJ6nZV5qkTGdhZgC9XrqZf97l0MPbzJ8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="351958864"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="351958864"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 09:32:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="579554488"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 05 Aug 2022 09:32:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 09:32:33 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 09:32:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 5 Aug 2022 09:32:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 5 Aug 2022 09:32:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caGjN1KHjssB0oAhQXYLMqJqAeSS31nEHtdanKDVMEa5sQ3UWzS5bfbupi78TUk3pAUoBVd/SlKi8UWWW2du4YGecMv1TEbmPSAdmzppFDKcy6DIICVmHImnIzg2QL4sqanM9TrExjuFtI05LSCaloXVmv6gPywkRTp+8Si6JBgcExbfYPDsoLGjbJLan7qwkJ0vng2eXKYcornap4WVn9HmM9m9w0yr/FdvCCVU+z7dICVGP3qNJiQCBe7PoiWtUpRssFUVGVn7Xn3Mj+knnG07KrgDopRxrXys2KwDmil9fAnsjj+m5/QyN8c92zpZDffR37FGP6ybZiuZae24ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMBkOBNLC93v0ocIseAL8fEPQFJGOP8yVVH6QM3Zoaw=;
 b=MBwu771j6M4XFVXU6jb2X3MqwpCPKJuCl7meV3qQEAwfUHzRnXwb3ZKkb6bNJeW6Q8Xyr8vygTsLP//UW6iN9RmrnP8t1LQmNfGRpEfsvQXE7+dQlLTXigZH7yS5IfGCO8FKCpyv8kJXy5GAKLvX+nvMZvzZg4sG8YS1loaJ7LKmdCy8oMt3gtgKHuKQ3pD4Rf38Z9Dg83Tb2syasFV22jrSERxCtthsyo+dMUBY71DdWE+inX76HjOSfl6RQ6MboFSUpEodTFNoQ1a3T8aFbPmq8yp81RVZK+F0cjD7Sn5hHqE9YX9sLM+frwAxbeK84edo01cC1nhKRHmhc77W+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY4PR11MB1928.namprd11.prod.outlook.com (2603:10b6:903:11e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 16:32:31 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 16:32:31 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Topic: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Thread-Index: AQHYnGds4JyoDr5oaE22k7ooTa/97q2IU/QAgAD0rTCAAKRdgIAA9+uwgAE35ICAA1xV4IAACoOAgAAM5bCAAAIMAIAAACQQgABOTYCAELdroA==
Date:   Fri, 5 Aug 2022 16:32:30 +0000
Message-ID: <CO1PR11MB508953EAEE7A719D2F9BF9F5D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
        <20220720183433.2070122-2-jacob.e.keller@intel.com>
        <YtjqJjIceW+fProb@nanopsycho>
        <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
        <YtpBR2ZnR2ieOg5E@nanopsycho>
        <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
        <YtwW4aMU96JSXIPw@nanopsycho>
        <SA2PR11MB5100E125B66263046B322DC1D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725123917.78863f79@kernel.org>
        <SA2PR11MB5100005E9FEB757A6364C2CFD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
        <20220725133246.251e51b9@kernel.org>
        <SA2PR11MB510047D98AFFDEE572B375E0D6959@SA2PR11MB5100.namprd11.prod.outlook.com>
 <20220725181331.2603bd26@kernel.org>
In-Reply-To: <20220725181331.2603bd26@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b737951-a43c-4857-1a7f-08da770017b6
x-ms-traffictypediagnostic: CY4PR11MB1928:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rBtAzWKCh6JFpz0wJvf5z4VaNWB052cbXFw6IKXTaGvQH6jgktfFQmC4wIbhdChf9m+skMtDUj3vJqsr95jWSJxN5km7LsnCYAtJgbiufV0eITvCENOCNT32Wc8hkIM/GN+PiE72tWc6TOHBd1IOBQ2OgCXxx0Itajuw3SNheWwicSWn51CnLCqpVItOY8uFZCHRiuW68B2YFazWRfk5K2N25ljRWoziuk9j3UvifIdKbEahWNXcflACdfNrcU3unkjhbO7gYf3VyyeHujmEeIoMgb55Q691vtfMeQ5DlZbLqlqKikmfyh/KpC6tKW29Z00ZJKx/hd10bWvUSchLAgLf+FaMuw5OL9/O3M3dTeZNtgFhysMMYA++jMygj1sdXEdM9CuW8dOHL5ydaCWd2DhJ/hHXS9tsCT62HZUtAbIBIaXK4eKR/wUQJq0VnxSQJsmKrnAiexWiSOjSSoJ4Eeth/6zDxuTIKfYrfrCLlf8pjs4HPlHPTNDu1G4zQUUSUrhsDaQY4oIvmbPzM5ov3hjDDi3I1sL+yKqy++sz+tqS4bu6ahMWDIPzMRhu+Wdyll+3dACO8KhTo/IlJM5+vltE0dsuGVai+vK/RwVzPlMUU1R1xHBjpP8ZCnbBlqGfv8qrF9/ahWnPF5YIJI1NMLnPFgaWSIlad1AXREai9Huq/UbyqZrRDf5eKM7sckyRJ9ZM1XHcAPQeOrb5MrnVBWXCjvwUC5YdFnbAjHUBKXPyIygLVjU6Ny0M7Azo3idz21x5YvB2FC6fzSSCtaZUeqyVieMKi1aJkovgTd8LDhc9+eTL4kXvXUQLUc+EdJ2D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(376002)(346002)(366004)(39860400002)(478600001)(4326008)(66476007)(66556008)(8676002)(64756008)(66446008)(6506007)(7696005)(53546011)(41300700001)(66946007)(316002)(86362001)(76116006)(71200400001)(6916009)(54906003)(38100700002)(122000001)(186003)(38070700005)(26005)(9686003)(83380400001)(82960400001)(55016003)(15650500001)(2906002)(4744005)(33656002)(8936002)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yD5HRDhWsuen5EXAy3H8RV6niS+pPIllqSWkyKvUI3uL8lQNFyqv7m/kXw9S?=
 =?us-ascii?Q?DahdL1FS2moRyKv2/vg0439vrW1oIR7kzBgEzEwrQT+5muJKfX6cG8yP+j7Q?=
 =?us-ascii?Q?Ro382NbIE7ePBxoWl34W8Yf6bRhk7X6LGDeIRGwltFNMEj7Z9Z7AC8op3M9o?=
 =?us-ascii?Q?VAOMzp+sOZ5NtRsSJpcy6l0BWNl9MGPZFFHr2xuMt4tTWv1Fco5i261KXNaN?=
 =?us-ascii?Q?Dt0EmYC/Ne3LA9XFp9HNUsAorGYNaKNf67q8drxMA9iBk92lbyhoP5FvNYdh?=
 =?us-ascii?Q?WjVHavPCzTnaHLxfY0CJBVsv/RqPadM7oWhwAJ5/e07fO/VaNN1/i0mG9JSV?=
 =?us-ascii?Q?wIuZzzC1CnHIEGPLVfu+dwkzOiANgYUqlLVksX716rZsYTlHpSbjd3cX+JPX?=
 =?us-ascii?Q?9XOhE8JdvWQ4/VPFYV4s+lmMJItPw4fQ/HpdwhNFvVqZZLQeKZCOl4d9Vguk?=
 =?us-ascii?Q?BbLgXqq9Gyjf3QViuw9f9RgV5dEgQpOZAbC3YF8JFKBxDx4zc9t8CjSkOwtu?=
 =?us-ascii?Q?mujmz3dic5LhMkjN5SUHY3qz/v/S4lKjEqaIhUaQ+Uj7JOzzPNJBfp+WAQJO?=
 =?us-ascii?Q?1qcI0qOGWrki/HgtNXkBVAcmhZ0hoC3nekdyRhw18g4Fz7df5hys1sPRGFvT?=
 =?us-ascii?Q?zKw0JsntSZ/opjyh1lHPBRqqBZw4ABfIs12y7uiTyYn+KTn7BeympcHokEXY?=
 =?us-ascii?Q?3LLiBDQJ4+Q32LiWa23U1yv43fUggAnk30uneilsgbCI29EoUevrKkM1HHxJ?=
 =?us-ascii?Q?GryksjOellOoaY6nNmes5K85fh7pYnIjn4+3xtmwCVWfn+ZaVmkqTasd4BoY?=
 =?us-ascii?Q?hd5BQb2woz8eXtLOLN514rjcvBWvGTywFSixciK557bGHvcr9S2t946WRLAu?=
 =?us-ascii?Q?423zQ0D6kEHZ+cKBGcefQkCphuaAQwSTF/Ms+9boj3737qziEv8Ai1ckbjn6?=
 =?us-ascii?Q?Kmz+nkx3L8g1GnRlf0idqS4xG4XfBw1y7FT2wSgmLVUYMPvT9sHPG1FiP162?=
 =?us-ascii?Q?3/fdkZlIMYYqS9zWRwEjT3ENjukMGhdIV4+/Q/SiEZ1E+3n3VkRL+yLzlpwN?=
 =?us-ascii?Q?NPvTA4GBQyie2nHVjfI9A9x/U7ryNcRfDwB/C29APQ1oq+kGToG5V8dX6HLo?=
 =?us-ascii?Q?+Madya7sQLwRR6rwh8+sdYigkezF+yYmB+W5V9cUfURHmT40RTVj10O6PAjW?=
 =?us-ascii?Q?9x+yOVQ/ljAR20VPpXJs7Tg+koLw1Ibqd5gv8QVnsaYyMCVFhQF2GcWv4Ka3?=
 =?us-ascii?Q?4zj/WC6I8QnbYiYkjlGspoLHSH7MsG3nny7izv7zoCXdEIaLOD7Srfql1QWN?=
 =?us-ascii?Q?zGtiR5uwW2C7bpjTV500E7spY+sIpvECJYt9VdCJeLLQ6+HbHe9f0PBNaOZA?=
 =?us-ascii?Q?MaBbxN3B2kR26SprJZZD8lvk84DIThhOwROCJW94OWdzfT/X5WJSX2nKWLie?=
 =?us-ascii?Q?MJUy63JRZdr35zuBy+tDUX8ZMpvJ01WQHca9IPPhYJdnFmuNMtJ8h3o3fmme?=
 =?us-ascii?Q?b/ADC9mKlknD+N8seDc/sPL6QHoe8/YPlgxzJBmSphD+ujEiGFP/wQ4fNs/O?=
 =?us-ascii?Q?8GvpsCq74/07qZBxkNduSA6ToDI0pAhj+p4aZG6R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b737951-a43c-4857-1a7f-08da770017b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2022 16:32:30.7549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nCCIbE/aXVV9k/XN2iTJaFJayBx1gnza9sg310Y6ECRL06yGPTVWwI5zK9KSUMCL7N9ReQDyd2qNvoLcoEYpfnFrL/tLfTluI8kLXr/GF3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1928
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, July 25, 2022 6:14 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash=
 update
>
> Hm, yes. Don't invest too much effort into rendering per-cmd policies
> right now, tho. I've started working on putting the parsing policies
> in YAML last Friday. This way we can auto-gen the policy for the kernel
> and user space can auto-gen the parser/nl TLV writer. Long story short
> we can kill two birds with one stone if you hold off until I have the
> format ironed out. For now maybe just fork the policies into two -
> with and without dry run attr. We'll improve the granularity later
> when doing the YAML conversion.

Any update on this?

FWIW I started looking at iproute2 code to dump policy and check whether a =
specific attribute is accepted by the kernel.

Thanks,
Jake=20
