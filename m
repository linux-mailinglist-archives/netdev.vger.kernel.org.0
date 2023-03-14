Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D52A6BA158
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 22:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjCNVU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 17:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCNVU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 17:20:27 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AEE303C1
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 14:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678828824; x=1710364824;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RwY6o5qLGALabHr+Jc3ygHK8jfqs2IyA5veF15MOJmE=;
  b=hcIgCdBNkVsvagHBjtIpDzT6CCpFQyKt1DcEzhMVs4lGznXNlM+ZJQY0
   wE3V1ur6vRoxeZwcGw4xx40enhUNMjXpnC/ZZnAwmaj3m3+G0b5piWSlE
   xbh/Eq/QfsT3W4MwyJoOc6mZfeLm6ypYf/HEElKy5Onx4JI3ehu4pzOAh
   WB2+l3k0l3gkPYgEV1VlKrO/hvQneT6dPX2UgOpZs0K2qJYuc4h2x4s5v
   u5XE5VZDFAtzK+UJmQZcj1dhfNvQdveYPgJxnbirb+/u4nYSJETq2kMkS
   10Et9hzPfu1CTgd1F00AFHHawra7SBTxjm5m12ZuQ5mkQgd02imlBOPZr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="321391146"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="321391146"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 14:20:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="822534286"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="822534286"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 14 Mar 2023 14:20:23 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 14:20:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 14:20:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 14:20:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 14:20:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6limAAl/FhZKv0lzFvfeF/znZDIaG4xIgoHewSVKJ2SsSzKTZAT5Vdn7n4rrXWHGAo0juDxBYCCf6T120f7/7XTlYa+GOZ0rNiY0fmT1niZnpEmVzTrUlxpMSH79vWrimtoCdwkUYSMRyFpCDlOLoBmkVHcp9XC9s76c17yYiFh2O7dxeUtu10s8ajIQAkvuWaCBtTpkiCOwKf2eYlJY2SZpTp4JPXjix2m9f9Vkvq9+WOWmz8LgPyqjBiH7QontF/ohhH/6KkaOwk1zTH2K+a1MttVVEbn9yv3BUNj1LFW7Ncz5y3HOXh2eZ438VOXMHQocOGBuZFilrw1ysCNgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwY6o5qLGALabHr+Jc3ygHK8jfqs2IyA5veF15MOJmE=;
 b=LTLHD4EflMghLRreRejjggy5UXVv/nHQRH9siAQBBv27iRMDbpv7uUco2YfJD6zjwYmxHEkL6zycTH3w11IHD4oBT+vzDVbiQH15YQFTBO/4r/kGQcx60Iy2ELWyaL/vRN/7azWw2Ba0G6nnCKO/NY44QCxuNohzFsofXxb/ayCFxTsSFK8gMQFsogGfFAQ0lohkYtQSjACqABGm4981+qmJH8x99II9/Q8yOX+xSb+ijNuw/X6YyvMktQQcVAFMAqbHMQWzlzs2V0fbXy98zvqj5wfySKikt4r1XJBzWfqaxpG6XiLrhGmpSkTRv95d1X/OrJliiq+WclHr+oRdaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA0PR11MB7791.namprd11.prod.outlook.com (2603:10b6:208:401::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 21:20:15 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::a54:899:975c:5b65]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::a54:899:975c:5b65%9]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 21:20:15 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "Szlosek, Marek" <marek.szlosek@intel.com>
Subject: RE: [PATCH net-next 03/14] ice: track malicious VFs in new
 ice_mbx_vf_info structure
Thread-Topic: [PATCH net-next 03/14] ice: track malicious VFs in new
 ice_mbx_vf_info structure
Thread-Index: AQHZVdjd9Je43GfCBEGL8v+/Aze94q76SlqAgAB/IyA=
Date:   Tue, 14 Mar 2023 21:20:15 +0000
Message-ID: <CO1PR11MB5089918F2843887060B21FD0D6BE9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
 <20230313182123.483057-4-anthony.l.nguyen@intel.com>
 <20230314134357.GH36557@unreal>
In-Reply-To: <20230314134357.GH36557@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|IA0PR11MB7791:EE_
x-ms-office365-filtering-correlation-id: a8e5a31c-db7f-4a38-b84c-08db24d1e76a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DaRN9dDEzHSmjQw/bMJbrHf2uPSNV72RvbFk6fA+kLIbsR27zXFg8As4jIZQubGQ0ouspdXhiMYSkfqeTOdkGzFweqNCE/d0GG0HhUvTiduvBEMCm3O1bDhgVgB0MBZHBGPeo30t4H42zr/bMHPcIU/mGn7vSAj3ngC3WvSGdPJdZWPQg0RuPrWbmF5NrMvA9MQ8y34CXxba0bgFP33AdPe/Po8KDGYMtG4SCCrD1YNp7lWQu9pgmAKjwfO4P5TaBFkvhhRsL71Qk9DbUKmdIkzOnWmWNSKixp8r8BwKMdPk7SCcJvXXa1VWo5HIW4aBD6tTGcnot8wHn6KBEMbNwx4ttQPQQpwun4fsIogWNe7IQbXWDpgiR96gNWJ7NpA0qZNmL1xYHr+bF4PDmw3cF250jILLOKgIwY9AKZn1/Z/tp9KietC1PakqQvF33tWxkx7KuJf7BQLQsmrwCoH6ao1H4hIcoQABPjzCWCGdHVKqHEmgupNS1RFndeC4uewBVL2xaiz4cC3YRf5GJ9fFJAVGos+NJpB6YmEHnI9jfbqUuFOAbGO3wbqLPKcUVZgzjiQSHneGpmXotcGZwK1/KO+PSKKRXxSnrs2HXR+SZvdN47v6J0ikQ5BHrz/QhevJHpdLPi4pRCpMEBH3Lk5FL79LHN56CI7DBamRsVSx4Fi3JXeo08xufsz6ZeyANlS+QPbo0PRqCXf1sanWJnXr/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199018)(9686003)(186003)(6506007)(26005)(53546011)(52536014)(8936002)(83380400001)(38070700005)(82960400001)(38100700002)(5660300002)(64756008)(66446008)(55016003)(33656002)(7696005)(66946007)(71200400001)(41300700001)(66476007)(86362001)(122000001)(66556008)(6636002)(316002)(8676002)(4326008)(2906002)(110136005)(76116006)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EqW3dnYq1V9+UWsIS1gDG7izaho/ovu66yAiWEBoKr7o4UDr5eS9gDotalFB?=
 =?us-ascii?Q?ez+jw9U7Cg7ZepWZ/7uZfOQQMRGhzaIKDzUK/wbdOI8ODxkBwm34l/2hE73R?=
 =?us-ascii?Q?umcQiBbmKEKCk4z/UpTHU+W1jKGDLnzWNNpX2UXamvvpRpd7IlBIdUcVGm0A?=
 =?us-ascii?Q?XMWC1SP5FgUmD8Yis8ab7sNHhu62v21nYPtU7fPwK3ubz7ouwONtfJn13EmH?=
 =?us-ascii?Q?z3hxEmnB4abnEwplNDilgIHdEoy+UpKqWq4CFQCDtr4k+Gxkb/tb8s6pw9zG?=
 =?us-ascii?Q?u+vzPCfmnCCaoXKV0mL9i6nPA0+LFE8sha3KDxfYdgoK+DULHr2axsUt/3hV?=
 =?us-ascii?Q?utiHyQv5MNGll7hFKJ7h9BCank25XTSOOBqCbJBSIgMaElPuisKO0x7y//U8?=
 =?us-ascii?Q?28cEz/K3il7aBB2pW8DDF/1MeNEo8v7P2+dKiyBek+6AiMUDUWyRG6lgN3Ph?=
 =?us-ascii?Q?BTJKoEHTd/HVzq0LKDl4fEVWV5jbJY5GDXnoaBvhgcfJYGTU63P4Il2cQ0RN?=
 =?us-ascii?Q?U/CZSswJckreQVuyaJCmqpweorlHxo+4dLmI//Q2Dk60D0Sr55WH7ITvWZA8?=
 =?us-ascii?Q?b3Mpm+W1SXnKoMYfXXvR+qK6HipIyAgMJ0uGKyVHkUvCcrycvN0+owViYCbo?=
 =?us-ascii?Q?PMVQ6daGvrho0j9SH0PXnywBbNLGLI0DOuKMzckYxQ2J4OoOcvfBXjm5TsVi?=
 =?us-ascii?Q?NYUb/PLSzqK0i2wptwa5zflrq6/F15g/zjEw1SJxZcelb4bsB0GuyP2naB47?=
 =?us-ascii?Q?+1ByI+Ca8VJQ7tpSGHk8Ux/eNEyyYFBnTRTVdMHZ8kiY6mRB9CnkP9KhKroY?=
 =?us-ascii?Q?yrjfwI/+6VEf/3czDH43c5fXvFoq2UR8biqjEmdEKpld0fIsmKn65Rgo2BAG?=
 =?us-ascii?Q?RLiDgzZH0cSYgx6qev/20vWYDffUPjkR6Ndiy7/XQ8TwnThfyGwBsATZnWNO?=
 =?us-ascii?Q?tQuD8junMX7URHic/21YKozON/BAuw52JUEfTgqAc8ltmjEIJLfnpyD9H/H3?=
 =?us-ascii?Q?UBX7G544PniqzuWcL5PcJqQOCAEHvscsQTpqJOLrVTr+fQXFT1jNhjX+YP76?=
 =?us-ascii?Q?vIDJxHTLX+aSzoCmAL0TvK6C+l9nM4zkxKY8Kze9yn2RIjqAc3RJ91/+hypC?=
 =?us-ascii?Q?xZvqyJpy6D6dgPyMJpzVqrArKUkSm3/AEKPmmf+1lXrqPOH3QkTt/gpzibIj?=
 =?us-ascii?Q?OumZoY8/Pltgo75M6SlD+dJeKrgS0lcml19ybJS1tHh93FulyFyrb+gqUy+F?=
 =?us-ascii?Q?KnRUvPorYNSMCOpr/F52aG1WqBPodspcz2ME/DjrCbEHQQKgDk5K9e6s6sgF?=
 =?us-ascii?Q?ayCaPAsfOLQdQCUGMdJFb6EAWcLeLiZ9axRMGaQTFXQI8b+4VcpEgiwCbagk?=
 =?us-ascii?Q?e9ZT63uenHxMmVkA3Mdx86Wwr3q71qMYZPi6W2rOs6ckVW9omC8pv9jpmRG3?=
 =?us-ascii?Q?6sTqYlxwVbD33NlvfTHnXsRLtKdea+NkBg2zl/Kbq0eCKJwiBzsYaU/O2R/w?=
 =?us-ascii?Q?2nMjXdc3k/W4mQyjLBoNmX8k5OsLUVw8ohtLx9km4oDn1uJM5d5w+PX1KyNn?=
 =?us-ascii?Q?2yKPj2Sybe8tZwC3RN75+dSGs1HlXQJbpVmdsnh5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e5a31c-db7f-4a38-b84c-08db24d1e76a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 21:20:15.2196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7qE6gJZoMpvqMF6RV7U68K95KDU35zr9EdyveqqkYGG92DJB8eIVi42w9ZXYlLBiXplBGTrDbN8q0YPZv5pjrJlYlSeUu4qNKKtL3ZEXK8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7791
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, March 14, 2023 6:44 AM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> edumazet@google.com; netdev@vger.kernel.org; Keller, Jacob E
> <jacob.e.keller@intel.com>; Michal Swiatkowski
> <michal.swiatkowski@linux.intel.com>; Szlosek, Marek
> <marek.szlosek@intel.com>
> Subject: Re: [PATCH net-next 03/14] ice: track malicious VFs in new
> ice_mbx_vf_info structure
>=20
> On Mon, Mar 13, 2023 at 11:21:12AM -0700, Tony Nguyen wrote:
> > From: Jacob Keller <jacob.e.keller@intel.com>
> >
> > Currently the PF tracks malicious VFs in a malvfs bitmap which is used =
by
> > the ice_mbx_clear_malvf and ice_mbx_report_malvf functions. This bitmap=
 is
> > used to ensure that we only report a VF as malicious once rather than
> > continuously spamming the event log.
>=20
> I would say that idea that VF is allowed to spam PF is very questionable.
> Even with overflow logic.
>=20
> Thanks

Unfortunately, there's no protection in the hardware mailbox to stop a VF f=
rom doing such spamming. The normal VF driver obviously doesn't do this, bu=
t we can't control what a VM does to its driver. This was an oversight in d=
esign that was not caught before the hardware became fixed.

Thanks,
Jake
