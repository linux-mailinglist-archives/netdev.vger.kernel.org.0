Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3906E0031
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 22:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjDLUwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 16:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjDLUwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 16:52:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196326589;
        Wed, 12 Apr 2023 13:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681332757; x=1712868757;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BPTqUyLwlBt4/gBnTNnCmnyw+KOyNQUS/PNNnUFbJj8=;
  b=bRAIs0fa2WiGai5yJt4BCh+SO5e/TTaNTDoP4iPdjxsNfNEPXDTAZNjK
   ddTkVusnZ/6YPlnzCjlCkS1LpliVrBu3AVAN29BcrdM47iqvwRhYD6WaD
   aIVR0erYx/AYQrXkJA4Ba7FPskqWJ94JzqonOYi64SbQltx2Adges1u42
   fLVEVKGiTUfkmV0tR3fzCQgZKuwQFk4T0OdaHSk/xAjuKluEzEpUylbLk
   fYDNBkmsPE+Czz/FD6WY60t7l9QwrV7t9tX6oVeqj2VZAZsrS6RVMAXud
   HowlhbYcgK1z/j4FTMBcAqEjX8sxswT/JlkdNum2MNXEtvIzxHLZnDabL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="430307050"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="430307050"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 13:52:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="863459432"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="863459432"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 12 Apr 2023 13:52:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 13:52:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 13:52:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 13:52:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OluD5k9lgrDf6hqcS+FoG48SpFawFi2pifnlAu10ysrT/ev4kgbUM6G07AjTICbQqPJ4GbcCrNJT9y2xZrVZy59MQyETKgcndWHAh3+yN9gu6L9bIigJVGwzFEOlorK3jwei3qcoBOaDH/NQYjdjDiALXICbEwoMeM+ys/02BB3AU7pzmh93nZSDKgRDtKdrTJtioL55L1LJWTz+C+ZsHBJ4bh52kt3yIEqigp2KkWoNTwHzQbZyH9+4jk6PO8PfJEsUri/b3Ux0izTgyhCxkJAYr+mkHUeeEAqrUWkO6dba2S1Ib+Z+/UUL2XUhcKSU3AhDaWKUnYNiAWRt4rc5qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjt5d4BC17kqWAurylH2tBreICd1k5lgE0Pi/VYEG98=;
 b=d1gdc0IwMfVhAx0JBnXIBSxZhyeFkXsKS1WmAEja+OGosTi9XUKm+rIsyqccENqqRWC4OEMhILMRWxmTiK09/cbP6/uueyhtYQfPQOqn0u9AsOnIR5bCegZ5j9ei1cRxTpbunNl39N2pF55iIRaZGszxH8g7H506/5RYNeI25rvjcQi/Tn4phhDeS6PMbXycyp0L8sOjj8rhuQWGE4iJuB9OvZkbalqS7jDqok3XAV7aQ0Ib2/X9gt0usmf+VnC82ijcTtcp5WF0itzEmuJg7d8uEME/4BbYwl0tjxBVaZxS7jjFkHw16oO+svtCjhPq3o4veBmJdLr/ujiaGpwpNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB8203.namprd11.prod.outlook.com (2603:10b6:8:187::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 20:52:00 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 20:52:00 +0000
Message-ID: <3b324fba-d4cb-0290-f67f-6562fd7e86ad@intel.com>
Date:   Wed, 12 Apr 2023 13:52:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v3 1/4] net: stmmac: restructure Rx hardware
 timestamping function
Content-Language: en-US
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        "Alexander Duyck" <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
CC:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <xdp-hints@xdp-project.net>
References: <20230412094235.589089-1-yoong.siang.song@intel.com>
 <20230412094235.589089-2-yoong.siang.song@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412094235.589089-2-yoong.siang.song@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:a03:333::12) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB8203:EE_
X-MS-Office365-Filtering-Correlation-Id: e49ceaf6-6a2f-4777-a21f-08db3b97c30f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMYCoSvP7MFoxr1/KjeK9MVGN8r0ebNhoaqPIIaDZotMjx/OTj98GgJs1BSZLitKWa8oaiG1sFwIe/b7X6n5Z7+vXnRv1rQBQNNbWHr4DUdVVT9jrUBmMtMyellwXtPfhqx6l+DEKZnaNY9WfvGRV290nW+hkAu5g+7B5Z84XccVgyV1z96wUHgkVf7+hYvChlvzo1Irxlh9QFrk9hMVwzpZlFqje47zLZ5rzOTPf7QzGq6j9o79cDRjDk5vr0ehLiBwy7je2Bhbfve5mXq/p5lI60MnJUXCCGbpsEHIlePsiH7T9Be4mmwWCZgGjFEmCpMF49qcEqM/BFsERkICUW1Hjj9bS6/igyxquRpkVbijUPJxjfXRX5jjkvY7Tw0qJJJBC5tBNO8gG6vERuStKDZIXjggwCI2ZpJ148jEerto/VSgTeJ9vtCI8ysG90+z5b4NfuodedAZg8Jvkd6aS3mgq86KMAjz0N1qkWMKrD1gBPqXq8mlD6yg6bGD2tTwHrsZ0UIatgD0bBri0x7GggXhY5Lwao4939vMe2pbl4NKK1kxtIWmJEZlHR4vISSwdwUsxKvEtqtvkmplx3WiU8QgVyAekvhy1U48FJuWijeynA/AyIH5zQe41yD4PVtIJ/fFTL5Ue8mZq5vz19PwijUeTv5DeeayB1Z3TlbIfUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(366004)(346002)(396003)(451199021)(31686004)(478600001)(36756003)(31696002)(82960400001)(921005)(38100700002)(86362001)(2616005)(4744005)(2906002)(316002)(26005)(5660300002)(6512007)(6506007)(110136005)(53546011)(186003)(6636002)(66556008)(6486002)(66476007)(7416002)(41300700001)(8676002)(8936002)(4326008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b25OR0p2TDVIajdLWFRQVWpMWWNLUFBLSkNmVjQ2RWhicmVBbW52Z1VSZUp1?=
 =?utf-8?B?aC9QVElRRFdldTJiS2ptb0ZUVmVvNlNId3RzUHltZWJiOEYybkRVOW9OcTdV?=
 =?utf-8?B?VXY2dFVsNkl2TGYyczNMakJvQllxcThVSmhyb2Y0ZFp6Skt4UnV5cVRyWG1q?=
 =?utf-8?B?V0s2YXJxc081ZVFWaTNXeVFmM0EyTWJLNHFwa3lObXMzNXpuZktYak1FU29S?=
 =?utf-8?B?N1BaN0xXelpmN2RRaDN5VGQwVk81Y3hXc2IwSHFDQ2JtN0g3QnRoUGE0RXdv?=
 =?utf-8?B?TExQU0pscWNSV05hZE9lTTRtZFJsRkoxVjFZL2N3bCs2NGR1aWt6MVN1cjE4?=
 =?utf-8?B?L1JVVWszb2poMVdHZzdlcDJ3Y3FFc00rZnYvT3BMWENBVE9lRm9qL1BXZEJ3?=
 =?utf-8?B?alR4TEsxWVJxd1A5WGFXOW44bUk4MmxqL2N3aExvSkUyakFoVnorKzBRR3E5?=
 =?utf-8?B?MzAyOS9idTdEMEdVZVNIMWtlT2g4aHpMYmFuc0szQW5ZMUhtdjcyUG9zNCtv?=
 =?utf-8?B?cC9ieXhBVTJGaE8rUC92KysyMnV5MUgrWGNaVFk2UXhHSmtENitpVHZaMk9R?=
 =?utf-8?B?elZuMk0wcVN2N21xOXk1VmNzWnhLbk5WTXFkY3dmUURFR0pWOEphZkZzZVpo?=
 =?utf-8?B?ZzZEREdpYlpKZUZ4enNsVmd2ODkzZlpmeDVyd1RDSnJXRG93bmxzbm1MVkFX?=
 =?utf-8?B?d3BKZHB2NzJQdDl5dlRtUExrclVYSDJGeWEzZUEyZ0xveldoWTlpS0RwcXlE?=
 =?utf-8?B?RXltcG4rK1pwdmNGV05uTVRPbTFkcGZ4OUpRblVnZXJHSWZMeU95MzVJS0FY?=
 =?utf-8?B?MHpGQU1xcUpPRExZODlnUzJ6Y3FpUG0xSkthSktMTk1sbWZ5Q21NU25CT0N2?=
 =?utf-8?B?TDFqVXUyU0E5c1N0M1J0TE44STVkN2xsK2RZVThhRVJpZmQ4VmFEQXIyTEk4?=
 =?utf-8?B?aEVYdllzb0VrUXkxN3BxeDAwWnNpTFVLdFkwUGVQcUQxQkNQZ1AxLzhrUTFx?=
 =?utf-8?B?U21LMitMM1JTYW1TRWNiQXdqek1SNDJkNTIvNTFVWHBMNFNLN3FBRmI2dzlJ?=
 =?utf-8?B?bStlMTd1OStlRzE1TWR6cU1UL0tLdDZCYVVKeGFDWUc2UmpSRmRIV0NqYmlT?=
 =?utf-8?B?T21tbW81V3JtK2g0NmtzeCtlZWtIK2twQjJ3MU9zUWxRbHFsT3g4bWJxM29Z?=
 =?utf-8?B?K1RLUWIrR2c0REVGSCtvaTUxSzBkRWEySm55YzQzWld3c1Y0RnM2RnJUMmtM?=
 =?utf-8?B?MU9aL3Z4eittTjVVcDRQelAwci9Nc0hlQ21CeXYyM3BXK0NSS0RIWlJnOFFt?=
 =?utf-8?B?V0I0OTZQY3lLbGNoWjliWkJ2UnQvSHJpbHpMdkxiQTREUlpLKzg1UGJ3RlFk?=
 =?utf-8?B?VlhRZHJxUnhkaFRWV2gxbmM1MXlSTkg1NHoxekxSQW9GQ0tiQ3FnNVBnZVdu?=
 =?utf-8?B?a3JJcW5FRVp3UFhsTkdLcVlNQUFXZ3Y4Q29POTUzcXBwazZSMlpid2F6a3k1?=
 =?utf-8?B?ZzhENE92UWVwQUh6WVFpaTNPdXVFNlo3QnZVT04zM0V4ektxRk53THBtMW9Z?=
 =?utf-8?B?SFZselFOMzF5ZkFwbzZzL2dwVXBYZlRkTVFqMDRPR3dTOXh3bEtoK0p2ZVJK?=
 =?utf-8?B?M2NGSU1Wdlg4bFpvMkdjOC9zdXRaMnY3YVExRDdKeGhpbDg3Smx4T2E3ejVu?=
 =?utf-8?B?cGNwMVladkliMWVySWFCTU84NUVmbHlaS3BrSDhXVG1tN3NDVll6bDc5S2ZH?=
 =?utf-8?B?Z2VnTVFvcFBTaVRZbmc4UmNFTXcvWUFTcXhWZDY5eXRvakdlQVpONEQ2WVVp?=
 =?utf-8?B?TW1sTTdVRVQyZ2drcEJEdFk2U0ZHbUZzUnJsRmNhY0h5S0VSdjdLeTZLUVdK?=
 =?utf-8?B?OGR3Nnp6amFibFQ0dGQzS1hwVFB5VnV1YTU5K2U4eGs0WmhJTUU0SnNhSEhu?=
 =?utf-8?B?alRhS01FUlNvdGpkRVFZWEs5TXB1aVhSVUgwWmtyelYyNTZSTm9TSEpiOVJ4?=
 =?utf-8?B?emxWNW02UWFQQjF2aGRsVHNkRmRsOWd6L3lQd3FTeldOd0pobTZBUTdQY0Yz?=
 =?utf-8?B?d1lKeTRiYXNYS2J6OW5EZlRqRTdiSGZyMVZmK2plMXRZR1VzZGVFdGdzQVJD?=
 =?utf-8?B?VTA0R0RLMUc0bUE5ajhuTUc4aHlkTFJwNFRueWdxTk52RHN3Y004VGc3Wm9u?=
 =?utf-8?B?U1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e49ceaf6-6a2f-4777-a21f-08db3b97c30f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 20:52:00.4325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtbIs1cifPsOh20w3YB/p+8BQjARy0/NRjQqZM7QfF85HODF+G6mUgRA7JMrmbPS6V33ruD3YQ8RqDq1F+Wfty3L9xuYS4DLTN4psntfaV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8203
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 2:42 AM, Song Yoong Siang wrote:
> From: Ong Boon Leong <boon.leong.ong@intel.com>
> 
> Rearrange the function of getting Rx hardware timestamp for skb so
> that it can be reused for XDP later.
> 
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
