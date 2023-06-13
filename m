Return-Path: <netdev+bounces-10450-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBAA272E8DB
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 202F3281100
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3578D2DBC1;
	Tue, 13 Jun 2023 16:55:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCB723C6A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:55:12 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BA6184;
	Tue, 13 Jun 2023 09:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686675311; x=1718211311;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Muh6MRYYelg716UEKo+HU1q130FYMOZ+NHqTPp9+zos=;
  b=PF2T0ZBumO+uuJAdXcC3d23S83gL9k+feCNaj9XDmFz01+/qXl1TJ2WE
   qnN22ttU9lK46MfxRse0I13EANbPG3b+wb48m2Qb1nbUKC6dy/4ANaj1N
   XiAekOl6KrWwfdJjEtbVJAMoC9sbLaNbOM1Qse1TH1xSZDj2V4uHgAEC/
   67GGiNPiVvfwDZcf44ZuAqVma7ZM5Jgb0O/94qcp74PImuqiyHwgxhPTP
   YP8PnFbsx7D1F3woewIzxlQm1n7fhTarFnmUc7eQIMLFePGQuGOMOYtJT
   S+NmishDrD17Za3OJRoxm6ubKM8gvhi2hUS8qZxmeAwhT8DXwYVAq8H+I
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="358395817"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="358395817"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 09:55:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="705885904"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="705885904"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 13 Jun 2023 09:55:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 09:55:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 09:55:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 09:55:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knwjWQ5NXNHwwb9hosXZ7PUPmASin/YHzcZGLhrRpfRx5V/1hIZnTK07i8q9jxxGQN3C6JqT/i9Pz+vdcCINJz9U1vcK1IA1yV/XuaojZ5wd43/ZJ7C41uSlW9CammuqQp+Cn3JL6ZI6k0bS/PXHurppT5sEXFFvOHGFTXSidnnjjCSuolHZ5/E6iZ24nOr28+q00tYEBFjYRtS3kOXelscmtKB5g7NuIJbXw2ESU6U78XHuoezNMdIKJPktpew0X8vIvYpOw638KEfMdbO+hw3pkbPne+nv9+6KrDyhDFki8jS96z0cc+81SJ/E2wWW7UxHBN/bAQ6OBkJ7zKoDaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I5jB55cw0tpM7ZM4sy5YOUL7jpqc5gZH05hvw5+axTQ=;
 b=A4HL5tpNXuzAMnIgl7nAvYuO/FtwNZqGJAZJpEkfS413y68uedyg0fFqDXTwnqjcuvahGvtLhkQuXRPEoFUi39L/a9w6EqqEPbTSZo2AsxZfEG9AO9JXpmsc+yvb7w/xTCagvk0WCyLWCFA/YgSr4SBrC4rznFHYXr/3mkO1ugZGsqlp3VvuNPXxjBfIvMFwtBJ95JJdEIVaBXTo8m2SkWueX1b1n0aYwfhZ/leSno33tEeUqYQ9EB2mKR5ITZq4Nqeor8zUQBKP0+xIRaRrE+qNYHnr/lFvLADc1/vhgvglOIbNm3Uv8e0D0EtVSk6Zut1UhtRgzddpF9YtxwC45g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3224.namprd11.prod.outlook.com (2603:10b6:a03:77::24)
 by CY5PR11MB6416.namprd11.prod.outlook.com (2603:10b6:930:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 13 Jun
 2023 16:55:06 +0000
Received: from BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::d806:693a:1703:3350]) by BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::d806:693a:1703:3350%6]) with mapi id 15.20.6455.043; Tue, 13 Jun 2023
 16:55:06 +0000
Message-ID: <5f1617c5-0821-e1fe-4ac4-22702935d722@intel.com>
Date: Tue, 13 Jun 2023 09:55:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] e1000e: Remove not useful `else' after a break or return
To: Baozhu Ni <nibaozhu@yeah.net>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "moderated list:INTEL ETHERNET DRIVERS"
	<intel-wired-lan@lists.osuosl.org>, "open list:NETWORKING DRIVERS"
	<netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Outreachy
	<outreachy@lists.linux.dev>
References: <20230609025437.GA5307@john-VirtualBox>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230609025437.GA5307@john-VirtualBox>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BYAPR11MB3224.namprd11.prod.outlook.com
 (2603:10b6:a03:77::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3224:EE_|CY5PR11MB6416:EE_
X-MS-Office365-Filtering-Correlation-Id: ca4a3f7d-cc61-43ae-ca84-08db6c2ef02f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J2eHuJLPiGzFVq5jOjDy8vb54xuVqgiUuOfdRWVuKn32vM3wtuKCIyiJF06899y9ucedGXtcizYjlaSxF36fQjQIY3U/tBCE2BA1/tLk3ViMjN8IpFEJyaOTbNwG7XNiFzHXOLOxIObPtdqdk4lxuVeJsZV7vpIV386nEa7OrCJZFQMQ/y/PvnyUh0xMJ3HXICWQD7Ijw4mDDwqTVpaKk/Ab2Xc7uTDQO//1x20EMcd+9wf3+LY2b2X6sYRDShSiiwwk3APcyZj75wZpOPunwVHBTDjBL8Y+0pVjIpMvWl3RVX0xdZvjbcqkkvVJflHUtUv1rmiS7RRKPa4CzrLTIvPPzqICil3Qmq0M9NPOZjwFtxTkuy1Sl88cuVeewNOBbSkadOt6z9EhWriAJy7eUaPglcMPun4kudU6TApmUohrg+k6OzoDJrOEShqYARThbYSqfwO6lF/v43j2HfHwfsMjcaVRQOe2oSs9RsAYz4DXOcSUT2yMC8MQyN8OH5C0Mrd7nLD1KF9ZFVTe+oM8u5Ok9pjgWoS/kaBKp+QEgY0afDU4ixbkUU9ju3x35qH+cNn/L4zxvzHLlgezvMBRhqNmXVShJFqKWybcnchdHyY6Sv+UzXKmyqePdygAw2T/56fWYnj5BubEk62BQBnN/Bqus7agWXJDs//+JZ1WpH7LRsZOGRCDRrKMfIyTI7d1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3224.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199021)(8676002)(921005)(66476007)(316002)(38100700002)(66556008)(8936002)(86362001)(36756003)(41300700001)(5660300002)(4744005)(31696002)(2906002)(2616005)(6666004)(26005)(6506007)(31686004)(66946007)(6512007)(6486002)(83380400001)(186003)(53546011)(110136005)(478600001)(82960400001)(81973001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2lBSzhYam0zMXFLcUVCNHo3SnJnZVpLUUd3YkptVUQzYjdHNHAzblQ5ZVc3?=
 =?utf-8?B?aC9SeVUwM0tEeFgrb0d5ZFM5NE1EckVveCtSZ0g3Q0N2NUhCSFVLRGpOQVBi?=
 =?utf-8?B?UGU0V3dNY2s3dE9NMEMvUTJnVjJjRXdaVW95SzJpRUdQbFpvQ1V4a2dGZGxQ?=
 =?utf-8?B?K0htNGFyNk9hQU4xeTB4NlRlMUpMQ2JtNVNCMWNiQ240WW81dG9HSWcwQTAx?=
 =?utf-8?B?SDY0L01iOXZuYTBoQ0hzN3B2NkQ3TGt1Q25TN1FSdUhnYW5KVThGUHNBdFFW?=
 =?utf-8?B?MUJkdzg3SUc0RE9SazJTT05FTUpmLzNacFZrZlZmekp4WXh2UmxhMGd6MnJB?=
 =?utf-8?B?ZklHQ0VHUElxOW9IbEhGcUE5ZGpWaTQ1ZkxHVHEzT1d3T3pyWGhXbWd5clB0?=
 =?utf-8?B?ZFMwRVlUMURYYVZQVXE5dllQS3hvR1dZWHpwVTRDOUhBejdDbSt2RlMybWtr?=
 =?utf-8?B?aUx0UGNzcmFHQm1UN1poNmVJdlIvTWxxNUZkUXBVM0cvK29LZEszUlpiSmd3?=
 =?utf-8?B?Qno1cEp2Tml2QUFPb1poU3l1NFhZODlIdldMOHZnK0ZtbGgxMXRzRkRhMzJa?=
 =?utf-8?B?V2dqbDRlMFdNTUN5SlFwdUZLRGtUeGVqd3VQNUFlMXZYSzlOM0V1c0hCdFFl?=
 =?utf-8?B?dWRwQ1NJMFA0ajY0YnRua1ZYMmtjdEtGTndFa1dmUVIvdEVENFdTcGJIY2pZ?=
 =?utf-8?B?TmdRMXkraGhtWVE3Umx1RjIvOFIycDFKNGhkTUo0UVlWMXFqT3g5YUN2MGlO?=
 =?utf-8?B?dmJwMG1zZCtMNGRvSmZHeEZwSVM3NTJIY0FQRkpxTjFXbmlXVGV4S0hJRzBP?=
 =?utf-8?B?Wm81TGZ0ZkFKTXVnbFNpOXFlbGJza0krSVkxYmpMamFDU2I1VDZsL3p3V3NK?=
 =?utf-8?B?RlU5S295aU9iY3F4UzJMVldaQ0ErK0taelVXVFo1bFh4ZENJUXBrWkd0bjNs?=
 =?utf-8?B?eHRFdHhyZkFHK3ZROHp1U1lPbHlwM2xpaEQ4NUVwNlNzdk1HclNaZHJaWmdK?=
 =?utf-8?B?OXdkaDFSOGhUVTkxYm5DTC8yd2dJdWlGTGN2eTNQR09wRUhyK0QzbnByNm9X?=
 =?utf-8?B?Q0ltODhkR0hVdXNSeHBOdkNkY0xJRnpBd3EzRmtBelV6QjI2cE9IZWU0OW41?=
 =?utf-8?B?amlrNXNLVjlZcnpaUjZzd0lkSTZRcC9GMkJwZ2lNa1ZUdFF6SzEyUWhrQUMz?=
 =?utf-8?B?Ym1KaVNOTDlaN3RVVHFMZ1h1bDVHYWFQdnhodmNKQ09JenNyZGFrUmlCRmx5?=
 =?utf-8?B?ZkFyUjd6L0RBQ3JYRjFUalk3disxZUJsZDgrVE96RkJhNG4vdm80V1FPMzl0?=
 =?utf-8?B?TVQxSnBReVl0enZUMi9hdmYzVXdLdmxtSDc1M1VRMldQR1FzMjN0cEVCUGtB?=
 =?utf-8?B?ejkyM1hMRVg5NE1qZmVCaVI3SkNsdmI0UnRtQitKSzhPb3k3YmxKcGhBZGlR?=
 =?utf-8?B?YXJuZ3ljZWlVWmNaTTd0anN0eC9tY1cxVjFXWEhVai9IaFY3NXhBMkpRQmFQ?=
 =?utf-8?B?TitxVEJ2VHoremh4QjJ2QSt2ZUJ3RUhBckNmOXZDdUp5cTM1eU83ZnlBdThB?=
 =?utf-8?B?bUwzaVdPL0tFdmxnMFcweHo2aEsrRk5JbGJiY3RER3FwanVxTS9ucmZ5enJy?=
 =?utf-8?B?Z3lwMzBLeE9jTUNZK1BEYmtkM3lDYTdEZG43am9ETS9ubGRuSDVCTVY0d3JJ?=
 =?utf-8?B?bnRSRnJ4NUxYY3NXYTVkWDN1aDI1UGNWYlpOdUlxSFo2aTlBQklkbitUdm9K?=
 =?utf-8?B?bnhSekFOd2FQR2IrVkxINWh1aWIwZUlMUWZ6NmZIUU9ncERYZlhJL2c3NjdW?=
 =?utf-8?B?b3JzQllmVXoyV2h3ZDdSS0tBZXpnNHZzQ1hBQitwNmIzR0gzM0RoSHhaMDF1?=
 =?utf-8?B?d1Z5WkliZDRMb0JGVVdrVDlFS3kxK2tqb1NodDNxT3VFaHh0VHR6YTBkOTgr?=
 =?utf-8?B?Nm5JV0FnemlucFBHMldYMnlyaVl0S205MEk2NERJK2JpODMzZ3dydGNxZHk3?=
 =?utf-8?B?L0R2aFNZbENlbXZId2lpSGk4NFJJdUo2Q1VPb1Rqa0kwTGhyVTViSVFlVmVq?=
 =?utf-8?B?a2NVQlRBREsyWU13ajhGMDJxODY0SWtNRldjZVNKOUVjamxib0RCVnM4UlFs?=
 =?utf-8?B?VGJ5WlhQRHJtUzZsMTNQeXNVeHl6MGRXaHhsZzBpUUE3RTBTclp4OFBaejJp?=
 =?utf-8?B?RWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4a3f7d-cc61-43ae-ca84-08db6c2ef02f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3224.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 16:55:05.9240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 01mO9n9dVm466QoGr0u8DuCmcBu4y/X25+a2PdnLat6gM34TX1wXlCj9idnZACB3RhQVCd6ZCrFCLlftZZNrbcktLnWrV48NMVbakw2HgE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6416
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/8/2023 7:54 PM, Baozhu Ni wrote:
> `else' is not generally useful after a break or return

networking doesn't take checkpatch only fixes. While this doesn't 
explicitly reference checkpatch, the message and changes address solely 
checkpatch issues. Sorry.

> Signed-off-by: Baozhu Ni <nibaozhu@yeah.net>


