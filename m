Return-Path: <netdev+bounces-981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 118F06FBB52
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7C891C20A57
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 23:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8207E111B2;
	Mon,  8 May 2023 23:17:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669192598
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 23:17:34 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CC055AE
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683587852; x=1715123852;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qchu5jUHJbjk1IuC9gCkxsKOByJrAH51yHwTPJ6eOxo=;
  b=kEq3pCMhrbM++okUm2fm1qKWOvnsqB5MdhE80vORw4QIkT21BzdiaupL
   ho0mqYnYbrX94sK1XhzK9f/HwW42wa6dQNIfbiRYvlrjYv1tKGs6Kq8jV
   OssBV26oPvA/KzsXkupiilZOdiyrDf+h80ixW4AHl8Cdi7eH+UbhljqGh
   Vh7GlPUoVV9NKNVWOjdnuChgbouOtRe8vXOPv1EP9a7KNMz2CgY6v1c42
   kdx3EdK/e4UmsgWLo4I8wA21M/m6khMHIt/cSZ8Z6+VQMAt0/L4wyBZ8S
   YAGeSEgSEy69ZdaydIj60U+osUNOv6JwSVLRAdLoeTKZi0DpETI88Xi0i
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="348601591"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="348601591"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 16:17:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="676225000"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="676225000"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 08 May 2023 16:17:31 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 16:17:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 16:17:31 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 16:17:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNxEZCQTbDwfWtGgtfp4iSUt5dZMP+Rfk3ZwnRVaVXOQYATfpdJb0E4POCMLk/XyKv9MSJ8SCQ8rrfBRi/Y57LDReujb54s5lNJuA238J+3+ccFZkRgnKCKbk2Jj72RQnIeHIRg2IGCbrBunHgZBBohFRPAAZCfKWr4/5uHd7z5zIE5h3yhhBtsKlh8rPd6/P4s5KOg2XKLa01Vrkylvrn+Cd+Clkv2gIaHXSW7C8hgkb6S8CPY2HV3E0Byg7K4uVm8S9kkwH/dUn8RExUZETzsGuoAhc67o/Ow7O/P2ChR1ADdZ5PsBJV0hBLGbe/ucz5XRj571cqEPabkIuoE/Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xC7D1oS9sd5KeWvPwxPupt4rfsH8Kk/8UWNOzdY6PyA=;
 b=OTkAfqXl9BePvWHkM4X6AF/XEK02TNIIKSI7nEo4LhmwaBP9QCx60azmzpJL9he8/xlVUNF75y1kDxccS0vN1pomSGZ+3wjybppO4Qtt00zUgqToKRJA9sppeNhMbTqm4YTLaG3C+vjKYfs0VXLxVAbVk0zwelvT1m3Z+6xA6NpWKjErGrPxcdJNWlaCuwHH7Ui9GOjbTLYnbRn7jiDz6pM5gEkVfFPMvxESqE2G33hmI5OvHKLNQG9aneHteBhMwJyJnjywQyiLBpSa6xyVFcaR1HJ8fnV/4c3J6zKcJ1w9NeGN44oCsUVa9VP4+o+SnVBuaedk7D5XkxyrqaZZ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4107.namprd11.prod.outlook.com (2603:10b6:5:198::24)
 by SA1PR11MB8446.namprd11.prod.outlook.com (2603:10b6:806:3a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 23:17:29 +0000
Received: from DM6PR11MB4107.namprd11.prod.outlook.com
 ([fe80::29e3:b4cc:730a:eb25]) by DM6PR11MB4107.namprd11.prod.outlook.com
 ([fe80::29e3:b4cc:730a:eb25%6]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 23:17:29 +0000
From: "Chen, Tim C" <tim.c.chen@intel.com>
To: "Zhang, Cathy" <cathy.zhang@intel.com>, "edumazet@google.com"
	<edumazet@google.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH 1/2] net: Keep sk->sk_forward_alloc as a proper size
Thread-Topic: [PATCH 1/2] net: Keep sk->sk_forward_alloc as a proper size
Thread-Index: AQHZf9Ntgehazzv1OE2sbGvaPAj1ya9RBoYQ
Date: Mon, 8 May 2023 23:17:29 +0000
Message-ID: <DM6PR11MB4107DCA9F443CB5BE3A94119DC719@DM6PR11MB4107.namprd11.prod.outlook.com>
References: <20230506042958.15051-1-cathy.zhang@intel.com>
 <20230506042958.15051-2-cathy.zhang@intel.com>
In-Reply-To: <20230506042958.15051-2-cathy.zhang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4107:EE_|SA1PR11MB8446:EE_
x-ms-office365-filtering-correlation-id: 50011eac-e3db-417b-ae65-08db501a64c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VKcmLU7rzc5j/7yoCQ8vsg1h7WkLZUV+rHH0gYV7VQVIkqBf7ITEEC7rC3Yg2mZRZAjWhbXJrwVAxprfq/klE4Ds3EURsjCMYphCamUlTaR324ULs/+PjTfXB8WglwibmhpDNoX5nGqqUkzIY8kXRqXZGrro78s4tl89R4pe2X4HwHSJbjnds5vuQC1InmJexkccFG6923rc6BqZuHxID2RuZoDYpujskT3B/y0G7WT0OXE7HzfUoLTrP20x53hyYIEu26NXtpfae/uAtwfd4XCFiMcrnFd31c51P3mOlKVffkLFykR4iLW/z/gIeaHOJ2CLebntD1M3BN5OoyZh2+rxWHppRFQ8OI5f5rtrXnhDMO4RxvXuoK8EocopZER2asoq0ktz/pcWmQ08WQ9h3LvOlJ9bt2jMOwzvWFvKNDYl/OCrRHXi5UGbSIT1fuAv0xW6V/doeiHqVUWcseO0E9ezq1mynGdD+zONV5mZCvZPjAlCrJf0+0YH9g8FHQEGcJwiPe1ZLTUz+clfzzJDh3w/B5tJFpiYczkK2uKMLv2mNmRGxV5CL3/0gjCkLSbC2TyyO+GIRa1RpQ1tjtHnF3/32+gybqTf+Yk+nSPH6zIk8rj4STGjW+8BAvv3E/zB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(66556008)(66446008)(64756008)(4326008)(76116006)(66946007)(316002)(478600001)(7696005)(110136005)(54906003)(86362001)(66476007)(33656002)(83380400001)(6506007)(26005)(9686003)(71200400001)(52536014)(2906002)(5660300002)(41300700001)(8936002)(4744005)(8676002)(55016003)(82960400001)(38100700002)(122000001)(186003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5gl78ncdgl5Y3CwImoG2N3eQd4B1hWcjvWQ4Ngo24MwRkFfS4ToBf5qkpjkw?=
 =?us-ascii?Q?AyWHtnWiBPAUbh6w0FpK1IKG3MkeEKp0rn7YCxDG+uSwpXHt16wPEpSPfP+U?=
 =?us-ascii?Q?4oyZfluFh48Wk5OoyUZ4iOtBy0UFGdxx21idYN/p7pcJY6DA1LXB+SCM6zuE?=
 =?us-ascii?Q?EiIDIs7qSuoT8q1FKsK2CpkzaH4wc03rvaWFxD1AET7h55yybppCUJSJpmUO?=
 =?us-ascii?Q?qyvbS5h8VwYwJIBZXyCdwq8e+U/MLACVW5VSN3Jp/tN33opeBZaPlW8rZLK8?=
 =?us-ascii?Q?uPnW+1c44jVbdiLRMwGPTtDKTRVuK+9+PULfeQxy/cXoW7HfKQFa6fMaRrVq?=
 =?us-ascii?Q?4T0k0IuP/OWDk52PwMWA2P9wuYBJGPZxO5tZ4y7QK0VauYy/DC/uQhNySg3F?=
 =?us-ascii?Q?v6u9KCS87W0LO/HjPHzTKgaIW6MMu15Mz2piQxHCL3YXz8EffFYxmajVHIkr?=
 =?us-ascii?Q?uE06wwpb3xqdp9SdPuKfJbwmWHjPvmbUJ2VUFR+HPGUa6cwzrtzQCB778yiP?=
 =?us-ascii?Q?cTGGu71sBmiHSf3ENUgH4SNqrIP1kNYkSxxC8EyjighGfPKA4J137iA80D72?=
 =?us-ascii?Q?T857nOqYXlf3ZHepDhULJT8CQAgafiyFCkrkAtwO72l3kbCbzKZMwW4PWVIK?=
 =?us-ascii?Q?Tyfh8JLL/M0X4PwvHtseR8llvggF0g10qNiDznj9qMfR680sv8l0zFqXIze9?=
 =?us-ascii?Q?yLmVnmblq5DipotfOt42/61MExPLPXgJa0ZQzA4mlFxWV7Ao6kD7GDCZnJ8u?=
 =?us-ascii?Q?mQzIdG+4VidJzoFxQF8QGSmwkzqTq83KIyhBuAgEsIBmmlJFOHLi7Mf9tus2?=
 =?us-ascii?Q?Uu5ejRWxnV9QmPXWZIRv+qcAEf+dQw2AhYo2GJkIZdTHZ7Oht0VdfukIzBWZ?=
 =?us-ascii?Q?yXDI8gLSmuNDfJMTb4JdmJydS1Jlck0XYK4b79CQLllytqtWuOeeZkUIn6cl?=
 =?us-ascii?Q?A1hyPBhQV4Y8dN5Tz9Jhmw726w8hHFr4Xyr/45OxQXy3hQhvH4swJG/YfAic?=
 =?us-ascii?Q?FBsq1s6ys/Ml3Pl3tWsRJa7xl0LY35f5MnYkGjv3KCqBBs3xhFJY6SAeXVyH?=
 =?us-ascii?Q?N/PhqvBmhT7sweuwyW/UOMzCOY1D3Gk0hscbZqseNpj6WpV+kj469b5x9V5e?=
 =?us-ascii?Q?lltrIMN5BZrzmbBG0Ow3mo57TR+bDPGFDKylps7bqEoWNYq2We9JpvYSBkYI?=
 =?us-ascii?Q?Hz5mHjqTjmkth1scwSFrzbDFQBlO15VvZMuNH7FDMU+yPl3IOrh8Vxg1dcRE?=
 =?us-ascii?Q?i5HRVTLgkYvHaiPCRkw06aA4S3grRUv/bKB67vMxQ4ZY816GtCVtmuY1ECLY?=
 =?us-ascii?Q?x8t2Z2EiZvTea18WeoFHHGtJ1SzZdya9QEOmWEfpb6Z37eexulX/qV8WUAxz?=
 =?us-ascii?Q?0zKszofHbX2pww07CgZ3YdqfwycCnvGjDlYTFuDKCr0qXzqLHEIqGGjmgdEE?=
 =?us-ascii?Q?0//DO5xeLPd1d12JcSmv55aQORafZOX9Y70vese2kLYAksrU3RBHEtOiXx2Y?=
 =?us-ascii?Q?eQo7JXUF+qbwhiDR0CpzlWPfzzC3gk9N1ahH/TTMfP2Iql99HNEAH81ySNqa?=
 =?us-ascii?Q?VN4AeOZEFZTBh67w6Yfcumgfh1djfh7lUPSRzTaR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50011eac-e3db-417b-ae65-08db501a64c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 23:17:29.3272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iRLJOs1W9UK1sZrDTDS9c3BGrjswM6teA0iQo4AFP2FgXxuP0nLLYuG4w6Yc1Xt61tKyE1g5xn9cd5kyaAKN8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8446
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+
+	/* Reclaim memory to reduce memory pressure when multiple sockets

Improper comment style.
	/*=20
	  * comment
	  */


+	 * run in parallel. However, if we reclaim all pages and keep
+	 * sk->sk_forward_alloc as small as possible, it will cause
+	 * paths like tcp_rcv_established() going to the slow path with
+	 * much higher rate for forwarded memory expansion, which leads
+	 * to contention hot points and performance drop.
+	 *
+	 * In order to avoid the above issue, it's necessary to keep
+	 * sk->sk_forward_alloc with a proper size while doing reclaim.
+	 */
+	if (reclaimable > SK_RECLAIM_THRESHOLD) {
+		reclaimable -=3D SK_RECLAIM_THRESHOLD;
+		__sk_mem_reclaim(sk, reclaimable);
+	}
 }
=20
 /*
--
2.34.1


