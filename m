Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0820E672A5B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjARVY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjARVYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:24:24 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9265D11C
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674077064; x=1705613064;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8utY8AZf0fgE9Kp1lw1GppUsU+rbUjBVvS7wyFR62r8=;
  b=mf5OqibPgcq4CzgKKX1UPodgK43BtjXNRaYcpA1i9NYqhmVKv3b6Gb59
   tTMRjWhgmLhZgF0nWMCGM8C29Xk48nmgoDt5URVT7OkDIknu8vGQ8wcxe
   4wi8oX0T5sX6pLPAj3i07jFosw+dBYUVvHFgW4r1zQuBuobA18DWRgTlS
   2opQgEHFqfFjOUGDyWNdF0oDIfL4XqUqBs2+Mmjfw3ivYjk/2cGwfsup7
   4UcCV14YrGI1nxqN+HYRm+c9f0EL3OT9+/l2z7LJwG3N3oMQLGpKN3RUV
   MDFx91Pv09cYTyNbcc7Q5H0CQrxIPmuUdbO/cFaQdy6T8D3rMgA8VNGax
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="308666496"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="308666496"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:24:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="723248623"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="723248623"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jan 2023 13:24:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:24:22 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:24:22 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:24:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpvYmRtI/Q4XmomcLjA+dVg00ooygP1Jd3uYgYYHlZbVXdpT0xVEgUq3f/q7Lay10Cvqjbs/T47a6GIt1H8FKXJOBRnzgVajzMAZ5jiJRKGhtpZksa4JLvKyBO3ku2SuomkT8VkKUNYltzYuvE+V44JCxzxsppFhFnBAawCbbS/2cofflIBDgA7SIukpC8Olh+AbRHzZxCr5tfkR090WrlkO2PcThj7bWz3Rt7nEpf8puxRrE/lRZDmm/XMy5JUtRndia2v1FP47yWx4uJ3JkzsGGbWY4x8kbm/nv4VGm8NL44ltB5y2jt0y6EfVca2nWPrcikXytiRPtqgcBTKjFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RNE/RtIDe5YFF+N2/ZT6hFK9t7FuVe+vLPViOmvpBY=;
 b=k8upQINsDpQLpcaryO/2GyBRXbMqo2ihF2JX/vs1gfh29BMFswb6yP1MZTfIrQg4IJGL/LtgmBnhm1teAgb6MSJhgrYeHDTe0AdlPA0rM6UhI24UxYx+6vyjOo0+MPVNVsySb/2PdAcrMuqqjelA/QTscUAt0fWswCxkkZPD2ZOJiCb1BX4xmv+cPNQZi5dM6eFhBtzdDcQHGq2boQ6tHFhau4brRgqnDAWmctbPibCCSiqyvw5EWNDSLqZEEapT6RRjgBj79ejtpQcga7reA5go0TiFDbQ6gt1GMNXUIHnwzM+z2AjJk9G47/ulK4Ecnq4DFV2V0NcW06HsQ/pe/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5366.namprd11.prod.outlook.com (2603:10b6:208:31c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 21:24:12 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:24:12 +0000
Message-ID: <90532340-ad5e-38a8-55e6-55faee63698b@intel.com>
Date:   Wed, 18 Jan 2023 13:24:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 11/12] devlink: remove
 devlink_dump_for_each_instance_get() helper
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>, <gal@nvidia.com>
References: <20230118152115.1113149-1-jiri@resnulli.us>
 <20230118152115.1113149-12-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-12-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::29) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB5366:EE_
X-MS-Office365-Filtering-Correlation-Id: 62150e52-984f-4ada-3909-08daf99a57bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfZ+J+q1Bm5y07sxv9VBtJ8rwY+g7+rgqkPuu3BUP9Sdzq+LXvXlcabvZPBHTDkz/XiJbm4o2V7dT0uTm8RVbxEj85ECtK01+emYFDFqLx7rhGC+MOhawq1d/7kPNMFuzS0BAAbtNmtrXE7WX7lIfl2xEUNe4LDkdb0CjTPaJvDPsJqyt0YdqTifuM3VMIbXDsKzTnt/iUVWEbJIXV+nYVTTvancRCRrWLhzyQG9OCrE2oM9ful997x+cQm1keNRco1NJ5zCzQ/OPDWqxCLW+0hz6ir8Rt7r7y42LksUZftoPMyiYFnViKuAGm1SnKRg7eoES8KY8jOXdrroMnnNr8HW2pZMGyLSBuaxot83MkarpkMowpAt3WuecPv7EzRyHSEJa58jhu5yKMZUm9ZBfy6UMFb3tclQhWSGJFghnfDBe6zhOZFQpz9Eqee5ZD4ObwAJCq6IEMP8nrdGbYFBajSQwqVe1HLZZ/7r/pg4bqohB9Nj26si5wILP6YDuv+v0hz27R/kjTwMQkrXBVJuhX6z3Q7w3Mn+rul5Phzp+K9G98CXGt8amBeUy5hXG863ffzHW7BrywYUjr7f09+ItUCQdL3sWiAteJdZDFjGPD3AwTlhlgHHwaYQv28Up0gNlzbJ6pSuEGKbZKwC1ww2hiib9VGy5qSDth6+nDWUjDDWKEqWcS8Iy1cm7/56VVyn/5c3DOpeyuPQdYvgJ+9MfS957AD2k2KtTyN8nYcUy9k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(31686004)(36756003)(7416002)(38100700002)(86362001)(8936002)(316002)(66476007)(66556008)(66946007)(8676002)(31696002)(5660300002)(2906002)(4744005)(4326008)(82960400001)(6486002)(478600001)(6666004)(53546011)(41300700001)(6512007)(2616005)(26005)(6506007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVZkQjhEZWZOQ2xrb1lOMk5wUGV0VTZvQ3U3Y2lqRWxSZmNzbFU1WEY4WlhZ?=
 =?utf-8?B?UldTZnU5WGpwcVFiUTJYR29CV1hxRzA5MUhHWDExMEpvR2xmR0YyNHJDSUla?=
 =?utf-8?B?N2RrcDE5a0p2b0pFM2RnTzV0ZmpWNENKTnhNWTVDdGVJQWFmQW1adEFzNXlB?=
 =?utf-8?B?VWVuQzE2dDBCN0hmSVJzSWFkQVFFQm5taU1ITndwc2NtOWNGa2FzSmNGemF6?=
 =?utf-8?B?ZndiQTM3aG5rQzZOckszM2s3cjB5WmtBK0oveStnSEhaOWRrNEtXWW1sTE5p?=
 =?utf-8?B?QmluWWI5cmxobFlLbHJBM3JVSktiRjlKZlQwMnkyUUgvZDdpcys2aW1iMkc4?=
 =?utf-8?B?RWdXQlYzQjBLUVh0U2lXS0pncXFGQVQzMUFjRThjdHo1Y1NFQU80dTFMRVVt?=
 =?utf-8?B?dGI4bEpVZXlIY1A3MVRIKytObTVnWHRaYlNiZ2VMQzcwaHhudlltekpTR3Ns?=
 =?utf-8?B?ak0xdVVkYXhVVWZCZW5GdEJpVVNBbFZmZjJORUNWK3RGLzQzb2pTRGp4dDB2?=
 =?utf-8?B?NDFuVXRjTzZsZW9NaDZ6bWVMR3J0dkg4ekJXbWgxSjJ1S0lacjZqYVNSdGFx?=
 =?utf-8?B?RTBRZzgzNHZ4RTVqNTVYRWRsZEhlcW5lYkxLNElpKzlRUGVzbVVraGV5RnI3?=
 =?utf-8?B?bnlOVE9LYkE3bmY3WE5iNWN2cTloWnBCTll5TnBGMVlNQ2VVb2dDd1JmblNJ?=
 =?utf-8?B?WmI3SjdkdmhYRE1YZTJaWFFHTkgwbjUyMHJtaTVWRko1NEU0VHFVOXNqY29R?=
 =?utf-8?B?cHNnQnl6ZEpIWmxDMTdENC9uT3lRRm5LbW1xZ3picEpCVEMxeU05Y0dtcVJ1?=
 =?utf-8?B?MDhLdm5mRytXbHAwYmZ5RDcySTBTcEFaM1YwcE1hMkxsV3NFK0JNYVNXTHJ4?=
 =?utf-8?B?V045TENQZ05IOERSek9UZyt6RzhBd1NJMEpRY2VHY2JqK3E4cWNja1hoUHpn?=
 =?utf-8?B?eGRncTA3Qmp2d1ZqcXo1cE14OGxFazlCTWE5eFlvcUZCZENnRGtleXNLeGd4?=
 =?utf-8?B?dGN6VktPUkxUK0h5dE5IUVdUclltbkNHc0ptalRqR2toVG9xZjZoQmlqaHl2?=
 =?utf-8?B?djBUdUFqc2I4UGY3QktyVERqQ0lBakVVWXVDRk1ROHY3WlhGTXpCNDRlV0h3?=
 =?utf-8?B?MzNSK3BtMzhiQ3V4Z2VCZGlrdVJmeFk2VlZZeUpXRVJVTXhORFRpNzZobm9v?=
 =?utf-8?B?OXZadmhxTGd4OHZPL1Jsbmhrdms2NTI2M29sc1owdUVuZDY5Q0VMTjFLQTJl?=
 =?utf-8?B?T3Rud2ZhNXJyMk5zT3hJcUdaWVNVV0srSVkrZnYwOTlRa0QwMjAxcVU0bzkx?=
 =?utf-8?B?Ni9jZU1xYjRpS2QxVDJCc1lEOUkzRHd3NnFJK2dWM1d5ZjlDYXhKS1FadC9Q?=
 =?utf-8?B?M3R3NUhFRHUrUEtFRng0S2c4ZUJOM1M2Z3FXM0hRdGJFMDhSOU1YTkZLNWh0?=
 =?utf-8?B?bGxQbTRtSFpEMExsL1lQZ09STmNMOGxqMVZHNnNtRFIrWWFtaUcwdmI3cWVk?=
 =?utf-8?B?Y0VaemRCZGo2aElXZUxyU2xqTm43WWRFckg1UXNvWDFaN3VqQXc4MkdONm9m?=
 =?utf-8?B?TkNORWJNb3N4cldyRGNWOVhZVG1SSmZka0lLbXpwamE0aGV2R2I0RTFNK2E5?=
 =?utf-8?B?ejlacTNucThheWhTaG5adTZTYnV1KzYyMlhSQ1I1M3hNb3JPaVZrd3BjdDly?=
 =?utf-8?B?REpXR3RBZUN3WjFqOHRGK1lPVVF5UE5YRkExZmVrUi9RSXd3T0RSMFJjeHRQ?=
 =?utf-8?B?UzJCT25zdmhSZ29pVlBnS3JGNXZzNnN4azVhOGdPZGtyN3NQTUNuaGhmNkdx?=
 =?utf-8?B?TDJpVzNtbXFsR21DcWFUOWI5TUN3d2U1eFZHNi90aEROSWI0Y1gvN1R6c2Uz?=
 =?utf-8?B?QjZBbUhndGFOZWdQcmZteWRBZ0lBU0w5eDYxR29HaVpmeGszMkVYdDIzR2pR?=
 =?utf-8?B?VDRBWjh4KzJZcEFLc29rQlptc3liQXJYWWwxZWpDc1c3VEZOdHh1RG1qK2Fk?=
 =?utf-8?B?Z3I4K01BSy9YOE03RUt0VVMxV1RRUnFtUUE3Nk1nKzJEU2trejhhMlRDM3BY?=
 =?utf-8?B?ZmRVbk1xcGpPMWZNclhuTU5NVElIb3M0MlJSeXdwTXZuODFFcWYvakdxZnNF?=
 =?utf-8?B?SEc4MVdienlJajRCL2JQaDBGUXc4eVNJKzlaZlYyK1NTSUtoVGp4K3BTVVNR?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62150e52-984f-4ada-3909-08daf99a57bf
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:24:12.0494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z7VB3rmZf6hg7qgcDwLhLSH+vNaDuGpIqy3DM3vUDPbkU/EJP+953cs+kMAzw+AlwhW7Z3okJXWqCalfsBG2OEb0M90FL/47Y1N4cO2Z7EA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5366
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> devlink_dump_for_each_instance_get() is currently called from
> a single place in netlink.c. As there is no need to use
> this helper anywhere else in the future, remove it and
> call devlinks_xa_find_get() directly from while loop
> in devlink_nl_instance_iter_dump(). Also remove redundant
> idx clear on loop end as it is already done
> in devlink_nl_instance_iter_dump().
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Nice cleanup considering that the function has a comment about how its
not a generic iterator.. Less chance of accidentally misusing it in the
future.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
