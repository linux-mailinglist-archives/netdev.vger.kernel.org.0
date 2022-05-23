Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9341D531AC7
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbiEWRDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 13:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiEWRDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 13:03:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC873A5EB
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653325379; x=1684861379;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=71sFSK38GKef58ygZXFBCm+aMkILtVY08TrguqPmAOE=;
  b=bpO+fSRZ84vRUXQVUMP6BIii0OiOBpK9OAMU3ip1woXI/L2smFqUYzk5
   JvVjYoZIu2PuPpkH18yrZNz1bCtK4FV5sO+vfatw5oTNO9+zRcGJWfEOr
   m/Ob24lThdRa7+bDrMr+hqoZmzNNK7hzl4axXBfYa8AuW63IKyn34++qi
   OHlb8nPHk95RUtJa3n+kbw7LLI0wOznTxKikk8NWZvpmh5Q+3hzWx1QYJ
   1FGbfu8UXIhAFFCSxZL765lZoQ5vh7v8AlHclsR+IW2vVH35qNkOP4omQ
   LM6ccHV2DWxTTXOySnAe025t3xfYQL7Ih3JToqiogdOrJjDw/OuUxG449
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="253163353"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="253163353"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 10:02:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="703102203"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 23 May 2022 10:02:58 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 23 May 2022 10:02:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 23 May 2022 10:02:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 23 May 2022 10:02:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8rEECzr325FMNrZu8ld2aKRa5QZv5upzKIWm+AFm5u6FRaGaa6Q36lnijmu1HN2Je+gtsRqYtsQf1/xnhxv4k1V2FsjstlJHz/oXiIDZHNOb/8K2VeoKWP3Ql9AASTKpZzS8XE9WLtCvVZ4rvjWPhSXBMG56xvLWhFtQiZ4EHVV6ySgfUPzlQeJFHWzBQrTu4O6KB6YELJIUcdXybw64nvZ+bxXCBQ8/njGVDmpykbKGI/eXcTinRj++LZ5FiKRaxjax3GqDG1M1NwHLkWaNqJIUm6lH8g+BeqiOGJJx3HBBood4qixC5kWb77brYzHOW1uvUse9Ab4zVCNGbA6og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNtusDxL3Clu+r5eAX6kbOJZL4GOyOyqSAUKIKuHa3o=;
 b=hQwDzXME5ht6GMZnMLN0cQ79pmigMnEMTuCPmJAE28xHH+yRph1DYg3I203JShdaROcXLHZtWFBuMmlPghiKb+5VaJy4zP+E3iiyad5d7DMe9K9DNrnKz//oVppTnxKvW4fQg0Ms5Ctgm849ODLU0cPN2V+JhPCL9O3ThP3rf0Oks5LMexBK09WbTCtLLI265h3ucsga/sFqTsyDfCF+B2ZssXTbbwuqYU51AeGtCyjsnjXC9kb0bwlV7cho8GN1c5SQFXO1bObScw5tpo/ZEPgOy1vTWr5LA52tLUXo3WvqpayJdAu07jfC74P6N6pN8iJArlcs9JZSiFMh3PUOeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5800.namprd11.prod.outlook.com (2603:10b6:303:186::21)
 by DM6PR11MB3372.namprd11.prod.outlook.com (2603:10b6:5:8::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.17; Mon, 23 May 2022 17:02:55 +0000
Received: from MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::798f:5a98:e47f:3798]) by MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::798f:5a98:e47f:3798%8]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 17:02:55 +0000
From:   "Kolacinski, Karol" <karol.kolacinski@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 2/3] ice: add i2c write command
Thread-Topic: [PATCH net-next 2/3] ice: add i2c write command
Thread-Index: AQHYajQ/DgvP3b9Zbk+DazkU9ZOReq0mN5mAgAaBPVM=
Date:   Mon, 23 May 2022 17:02:55 +0000
Message-ID: <MW4PR11MB5800F540CCD489F150B5178186D49@MW4PR11MB5800.namprd11.prod.outlook.com>
References: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
         <20220517211935.1949447-3-anthony.l.nguyen@intel.com>
 <a4438af4d2a45b137172ed24f4ca362f8e4bf143.camel@redhat.com>
In-Reply-To: <a4438af4d2a45b137172ed24f4ca362f8e4bf143.camel@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: pl-PL
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: a2332d3e-44fc-9865-1b51-9f74c7726bd7
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdee8996-ead0-4a1a-24c7-08da3cde14c1
x-ms-traffictypediagnostic: DM6PR11MB3372:EE_
x-microsoft-antispam-prvs: <DM6PR11MB337208B43DE4B0E7AD9F6DF386D49@DM6PR11MB3372.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AV9mS6Ozf0gxa0KHO/5CokWX7GZ0aU5KOQjWN93I5xYNNY2pt9WpH1rM9absaCOu4jYz1kBrEV+jlEdVthgjUolBABJjdnHKNvxoO/lmbzpKnqLF/pWf6LSaUHpdDogC9RpYrguTs6Dfaxffr8Z7XELNRaQeBkvZPxe2c+Kt2gb+9F8T7aB/TTnOnaMUHnfmD/mnG/AyDoGk58Nz1UyPEOiqOjjdo/MH7LYm15RNIM1GZoyU+owplzISA59QrLDpXDIgOksoseqffz/xaFFWl1KcYS+UAkiqIiVfeRDNrS0uxMRUNuq/sjlJUHBrGUsKpG1qgDxn8XxKIHjjNBVx3rTV9uj86/VZ7eGMsMwN7u4+c3MvzUT/+9vISM9H2WkB701pAlKLnH9wmfeuXoAaKchTvGTj6o0G2DgAH+oZQIjVwfYCtMu1+APpKQeHOIN+3iIwNkbHgi3kT2nejU7aK+i1bZEr4AQ+3QDYuQo75zaa4ajpyGOQXxObOyo5yAMdLMlEL7gMWiD17yI90XFbV1LoU3DMT/PjCVyU+zCMPO4J18BlFPrffxHZwN/XxpAF3tnGAhAbckNf0rpq04taFUIRC/HkRGqeBWuWy2NCWDavROEAoO0iv10iFh0tT+WNpHtogzCc7ZNULNdPN0Jv03F6Z5hxKPyxJcXlefxaAYkJZpVCHf3zxYt+stomyk9tfi32hLTxOwTrcXCjJ3BGeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5800.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(52536014)(8936002)(9686003)(6506007)(86362001)(7696005)(508600001)(558084003)(71200400001)(2906002)(186003)(26005)(76116006)(38070700005)(66556008)(66476007)(66446008)(64756008)(33656002)(8676002)(66946007)(316002)(107886003)(38100700002)(4326008)(82960400001)(55016003)(122000001)(110136005)(54906003)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?aygkW3pr00vPY/0hOkCjLIP6rGh0AkHJXjCvl1Muney0ymOpHaSAm8rWHx?=
 =?iso-8859-2?Q?V0iDNZubj+bKfj9C0NqQZw2iHmJT6PyT5RIzwve/vquWrwFk46ikYBu4IM?=
 =?iso-8859-2?Q?xACGiv7K2EqQmLr6vKbCNx1uAywum1XrgkCWlo/J2x+ieMzkucAbGynBeJ?=
 =?iso-8859-2?Q?QXXxuQc0lO2BuDL8HR/b/wkEetQOLSDJ2xvUyN5zwWjvPQ/mUiid2WdIIf?=
 =?iso-8859-2?Q?Hay0ISziOqeJhnn4uCqYTVpYyr6QmQCXP3V7fsjspeXD1bmPSSqTDutxav?=
 =?iso-8859-2?Q?eBPW1k3/oFRwAUcGyXTr8QJvZ6tXHVUXJ4NHQMCMClXWowlcJcUz/igCOO?=
 =?iso-8859-2?Q?Zvwaj7X9oqvxcnrMQgClShbf+fOBlUeq5nWAqy7zthCTQszDxno086hDIT?=
 =?iso-8859-2?Q?50enYSf+poN3sP7fOG4AfyVYgLHkWwMomohxoj/GKzb8kJ3PrFRlktAw58?=
 =?iso-8859-2?Q?WzdTvCYREvUG33v6rMQYlHmohJiPmHZHyGxiOtJlQ7t0jVxTq3dXLzXmOo?=
 =?iso-8859-2?Q?8/pMAdYJ/6O3jeo1vvq8EdmtZ8YL9WxYjCJxK5ZyVtVzaIcgu+gsfvs/tG?=
 =?iso-8859-2?Q?iKNLPy90/BdwcPndVZky9gBQXkg2MoKUzCXqYcpqgQF6TgNbk16aifHZMD?=
 =?iso-8859-2?Q?i5JK7milN6qM+CzRQ32ZSVpR9DAgkRu4CX1Q+5sd8x0ubgKHaI6c8GCXY2?=
 =?iso-8859-2?Q?rc4VIaar3Is7ihu7kN1CJbRgXgPKg+oBL/1chc4T5IEFgkiiJXABztlFTU?=
 =?iso-8859-2?Q?wob6xS8/FyY4kGnPKHcsehSjzkbu6EKFbZWa1TVJdOdkdtXj6KODqaYdJ+?=
 =?iso-8859-2?Q?0Y1mrxEXW1DQKsvslpg92evS5ec68nJOj8ULhfk7ENa1lBI0Sgt0lJgsph?=
 =?iso-8859-2?Q?aJ5618wQNcQF/HPji4jo9Z/FbNpWH7yncgLZ0LME+WQYk52+a61kArmVag?=
 =?iso-8859-2?Q?SsC6ueKH5rKP+rc1+2U7+xU+sl84eGI7Eu9084bMwD3nouE5ghMtR8YdhU?=
 =?iso-8859-2?Q?yGRO/Vn6bLVOscYDFVbVoscb4IDBRGE4aouPGNSxFHuoD/Dgi6zlA/2Tmn?=
 =?iso-8859-2?Q?dMfGJCMBGUgdhOuBhlpFiNhRT3or+VhuQC5WlEBELObRBwzGOuUdxg61w+?=
 =?iso-8859-2?Q?+F8PpouwbMvbP8ujenqNLlUQsbOf3kGo7IsRVncvHoEQ4+5MxZihAZJS1r?=
 =?iso-8859-2?Q?nzqS/t+XIGc5WXPqBHiEMLT7JOZ/JXO3SEAaD3AcCfbesN9Dien+lIiK7x?=
 =?iso-8859-2?Q?2vYVAV7LSY/AKTvRV9VEwJvM0y23D0r5wlpV3RVnc8dBtK7njWYqA7YjVu?=
 =?iso-8859-2?Q?4OFvJ1OhcdmGKUCmD3a0dMJ0J11Lrxdduz1QBPoeLtqwuj07L1ykkF5VvN?=
 =?iso-8859-2?Q?SA+Wa9fa8+v+8XebsvuYVgxx4itNj4I6sIvEovVMhaMMEnsMZJgJDlovUg?=
 =?iso-8859-2?Q?SIBXx1rOCE79FqgRoUMq/EEfhiqeM1pSPq0r5YTWlSEeSSMAuTUpliczlP?=
 =?iso-8859-2?Q?/xHlCLvJYiX2qXggODcC6qonbWFzu8hw51qNneb32JMC68OQw90XllNV3n?=
 =?iso-8859-2?Q?rRMK2pFXWeWxrSPuppjSQnAv5paDlKMtqGlX+nTMF3zxTT3ilknQkLaVGO?=
 =?iso-8859-2?Q?PuK2WciQUkMKDgnyvOUAEPmIPmihS2h+WYMnYqFm728BK4TdzIBCe+NDmT?=
 =?iso-8859-2?Q?vJppk7zXSRgAoKKWQinoDs+MRdGWLrhvyLQHWp6/cy090sKt/X8/CAAeju?=
 =?iso-8859-2?Q?psK7ZoZkkMOajG5WEcnCedIvksW+wMU5FU179jiR+v9gwPjRxQwNz1N8K5?=
 =?iso-8859-2?Q?0uvXABeYAUnMUCwbL3gfM38a8fWrX70=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5800.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdee8996-ead0-4a1a-24c7-08da3cde14c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 17:02:55.4486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yIJgg42AMmLaNTcNEnmpUkFgcb7lXhLNxDsz72gVpn7KS9paEXshGn6PnhrI17uN7wKUIy1SQrHRw6dVtrpDSGOD6OAk2lU9omx2OCGEAVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3372
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, 19 May 2022 15:40 +0200 Paolo Abeni wrote:=0A=
> > +     for (i =3D 0; i < data_size; i++) {=0A=
> > +             cmd->i2c_data[i] =3D *data;=0A=
> > +             data++;=0A=
> > +     }=0A=
> Why not:=0A=
>         memcpy(cmd->i2c_data, data, data_size);=0A=
> =0A=
>         ?=0A=
> =0A=
> Thanks!=0A=
> =0A=
> Paolo=0A=
=0A=
Nice catch, thanks!=0A=
=0A=
Karol=
