Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED999678485
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbjAWSWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbjAWSWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:22:42 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24AE30E93
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674498140; x=1706034140;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/hDpR/4VL5NO/BGEDc1EOfvcMi9OrF368QnG7/oyR3U=;
  b=IZvosAr/DRXQ80hgC0R5vYnd6gi4c9JsAOFGQVOu2UZxRu0palRb51Hp
   AghqFYNjwCy2aqHiN+sRdUUtPP/zucpmxyzkEimF+3HIDEiKAOmSkZuxK
   6en0VKb4/2lei4/40QyIHXnY17qD4+o2BnvZHYvwt+y+jbqcH4vI2cTLL
   0yGaBSshGMjIhHyN/UFmz/kJWBAT3dWfmdprjFNE7My0+/+ILlrGP7plh
   wr/yuGvhTmyuj7jpvH91D6YGn64r9crpVai+BiVH8L7Vn54txcbMtOs3L
   dZRJD1YU/ZA0ZOfGvctlIugnrFNuZgQAb7XGyKvDb4d5HwIPkAcE+qUba
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="309688569"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="309688569"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 10:22:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="639297224"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="639297224"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 23 Jan 2023 10:22:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 23 Jan 2023 10:22:19 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 23 Jan 2023 10:22:19 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 23 Jan 2023 10:22:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMVdad+yYBze3gITMOywzYJpLvBG8oNy+JfhOhx9rKO5Lue75gBoLo0DsgNGXhkQ4RM7eiN+NTHpgP/KnGq4oZe8ZJKWBtANMBR/YiST9eqgtMi3XzIMZ8S9SGkwxlMnAwGBLJy5J8vIarmmRJGyMhtKTir9khSp9JcVzI2BAhayKN9YRKDE3kK0aleCrv8uP8xBvk7swjpDq+X5a752UU3VbRgE8z8N+7/DqtjKbELStWkIbqpJG11/U6VK7AbZEybJJCVZAwWqVMNntm0Tlbs0JixRKoSOX+SgNJUptIUUZB07iHGFXCVbDeDXWsbIbP/J4//jAvvQxLcWz/0MfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+auyaQWrwGLDUKUnUz3pEn1omW3/L0q6LxUH5DQ04yg=;
 b=FZsqY0jWhENY8XgghaQmknHxae80QLZbKbqyarn5v/6eB15NpNNIGv+2wKrnJyysSvn/Gpr4D//xA8zFKwqTZbD1kRFSnIt9Xyows04vbXZ4Yg7yFVgJxqHH9Qu8eyE/UiTH1aZXD++bv2SPWdIGaf8VY3AtpSp8B/sKGiYLq8qkBL/jsUOVol2YjB9X+mLdtnyX6x10Y3UnNizLcAB4wVlA4jtasEXFxJPWoo2kiqHUE25dW5sPB4UTrmsY+k06qBDGfevZtv5rJAxyAwIwx/oSSOHHjpvaFElj/SMdAa7C4R5HOgwtdizl/pe/PyTb7m7QXuIbYNxj8vStj1IeNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA3PR11MB7556.namprd11.prod.outlook.com (2603:10b6:806:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.31; Mon, 23 Jan
 2023 18:22:10 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 18:22:10 +0000
Message-ID: <3c8934fc-c783-11b7-a2a3-3e29b544d5ff@intel.com>
Date:   Mon, 23 Jan 2023 10:22:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        <netdev@vger.kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Gerhard Engleder" <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "Kurt Kanzenbach" <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0203.namprd05.prod.outlook.com
 (2603:10b6:a03:330::28) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA3PR11MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fd04559-512d-4e62-22af-08dafd6ebe2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /8SbIyv+n9VgE8mtnA7dxInttjDKdSx7qFZPZ9i7GaY4YXy3ZbEzIvoaxqNb9OubCFeFXY4512k8qpnrBKLI46D+kJYhbyHu2ubpyDPgcpxP1lDRkQ9AJQUPR6yntJN9y8ChaIzJrjHD8VpHetAThAfO1GZT6n/AI9I3ETlXp8VbUQrrltw8wt8KCTO178Z/TFrGQn/B1b9jRHNQEPU5aT+0cBCQYsWv9kVQ8cOQkcwgjQ1evy8aSqkNgXedFUgi+O1PhNzFuRMLKRCeG/hZxev3qbYDDIhbzSz6OuYqGivkVR4b15S55Ley6dC/1RAVlVcN5yDY07fBmxFWI3FfUxY49wRg0JiIEGxQ0G1xMzgUVdD0Wyac9Jv/ch1MzgBr/EY4QgyXH1DYFo4GibislF/AaBcrDhfcgbjQST7A4VnjdbAqdiAM8clWGucddeTATrQW5PCwKhFtr3ywVkRc2gNq+DjgJnzet2d8sK6d2wWpkWg5YvODWm2HhQSw/xZpGHEHEeGrfFQsIt39fZWBzD3d2usI4XYyyR7HNSBpdsYhD1Nrqww8kI89feC2nXfwFbYGvnS9L+pLfQQqveqrid2YGn/yrduPzCo7G++iTkt30IV0xyQBTjMpf5IFMJfo5R4gxpe17tXwhRhbopP30Fyk4v7yEvXa6jU2uvsV/mEInZ87fRwfAkvuIbJUZiO/snrgIASbB6y/GvGrvgHpmWHciSAfy9iXYdyq6kEeFF2gS7e1Dz9zR27duJUxTnNCED4DgMJc6Y5Xnu5m1sDxvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199015)(38100700002)(82960400001)(36756003)(31696002)(86362001)(478600001)(316002)(110136005)(54906003)(966005)(66946007)(6486002)(8676002)(66556008)(4326008)(66476007)(2616005)(2906002)(31686004)(6506007)(53546011)(83380400001)(26005)(5660300002)(6512007)(41300700001)(107886003)(186003)(7416002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXM4ZjdsMTVSTWRZWGU0d09RUXAvMGRXWVFPLytES3F6c3R4clg1MkVFd3FO?=
 =?utf-8?B?bUZaeFFJakxBS0RUVzhCS3ZUV3RSUDBqTXJWTFVsSzZYMHQvRXNzOXJnSXR3?=
 =?utf-8?B?bFpnaEtmSS9zU2w4cmt0dDVDeDhPb2R6b1daWUdmTjhiWE5kbDFVS1drSXVq?=
 =?utf-8?B?TlRjaGxvZFpXcVlzR2VjYmhLbFY0bm5TblFUbXlMTldEUkp1WFR4ZHFqWEZu?=
 =?utf-8?B?U1hDL3BoZTlLVlZWaDAvWlhPMnhsNUdZMTgwL3Q3QlppZm5DbmJMZ0xyVFdX?=
 =?utf-8?B?eWo2RFQwd3U3aDB1NHp5Y1ovS0c0S1k2endUa3J2RDlnSWdyek1pd1lpcUhX?=
 =?utf-8?B?dUJtOEhqVGVPMnVWcW00bVhsTXI1WmxBKzZ4M3NsQmY3SWkxNVV6VzJJbVRH?=
 =?utf-8?B?YmRLT3g3eFhmTGtCbmNBR2loSjkwRTFlTGs4TllwcUY4WVpWTUVlTFk4Z095?=
 =?utf-8?B?bnFUWWEzVlNOV3ZCc1ppazg2aVJvOGVBNWhveVJJZkszNjJxUmZWcWNUOW50?=
 =?utf-8?B?OWsva0pXa1U0Q01DcElKUHZhMlZLZkJ4WEJsS0pKV1pxdnRvaDNubWt6WVZF?=
 =?utf-8?B?N2p5TnpkM1FBRzMrMGFQWU90QTJrNThDUzgrVEh4SmJNWGRCZzltZzRRaUsz?=
 =?utf-8?B?VDJkTzdERmhYTFRySURRZ2tTZHpXaWN6RUY5Wk00S0Z5V0ZPZ1hSTW96RFlv?=
 =?utf-8?B?ZXRacTg2WFMxdVlwNFI0OWViOW01NmV2UUxIVTJ2TVVQc1gxelBQQlhKaWpQ?=
 =?utf-8?B?T1JUekxXTTRjcHUrK2NrWVorWmR5dGU3cllnTGlGYWdUd2ZpOStJNDFWZXVx?=
 =?utf-8?B?ODkxV1RpYzR3dEtyeDFTVE9QdlNoM1owSUxsakFYeXNwZVZnRnFwL1ZGSjRY?=
 =?utf-8?B?eEdTellFc3ZSU2pMbXo5NE1wbVVTT3A5djJWSlNlL0pBRnhncmM3TUF5M2NT?=
 =?utf-8?B?QTFHMTZqcjI2NEFQWm1xdW00aXhER2tTWnlkRENjQ2E5UktQaWZlLzZRR240?=
 =?utf-8?B?WXZsZGpUSEhTb0NtSDdnbjBidXdDdWlRVHNSVG1PUm5RZlcyWXdVaXMzQStY?=
 =?utf-8?B?TFVIQkZxNUhTSWxyNFk2MmJ3Zks1MXBDeTNSeGZUKzVoNFRLQzV4NmlnTzZC?=
 =?utf-8?B?bERiRnNvSVZ6bnlYaE5vRUFMNDBUak1kUUdDYTBHcmRkcXJPWUo0d3hBcFp6?=
 =?utf-8?B?amJNbGU2aEgyTGZhU2p2R3ZNcnFCeldyVy9kRTNreERsWVhkemZkT0VVMk5R?=
 =?utf-8?B?aTMrMmFOalRQRmdFb2MvUDdMZVpXaDljVUpaT0RhbjU2WmRnWm5JVGpiUzlt?=
 =?utf-8?B?OUtYVmllT2pUMmx5NVlBenp2K0VubFd3WSsra254eWtpMGZOQnZBSlR2TG05?=
 =?utf-8?B?RFdoUTNic2hIL2hDTll1YldvTHhUcnUxOCtnWnp0bVd6NVZpRDVzQjhvNXc1?=
 =?utf-8?B?TDZONk0wbTMzSURpMEJnWkZhaXkwQ2VDSzN0ZkVtZGhmbllBUmRTYjArNmlr?=
 =?utf-8?B?RnZUUE5HaE1oUmhFVDYwemhvWTFRcFYxVmI5MmpUZDlsbkpCNEc0QXJYZW5k?=
 =?utf-8?B?SHZ5V0ZjWFdyL0doc3JpczlQcFV1OVlMTmhvc2hoeGxEa1BZcDd1bUgrblh2?=
 =?utf-8?B?aFJvdGJaTnVwK2JQQWQyMWV0U1hYM2FqZnZsOTFlRGpnUHR0YjJZWTlnRXhu?=
 =?utf-8?B?S3JTa1h5Mjc0Z2RSYW9kdGl5UTZ2TU1DRytVZ3dmNUMwZFp2RGhiMWduOTds?=
 =?utf-8?B?eEw2UDBReUFsRjREZkpOdFVPOVhBWnNGRTh6MVE3MnZydHZGODF2NDdQS1pG?=
 =?utf-8?B?enFWbmo4YkQ5TnZUSXZpbWNNcUVoSnNFaXN3anpTRlREMVAwN01XSUZ5bkRP?=
 =?utf-8?B?WitjaXNXMDhlcUNqQjk4SzhIaVp0aUE1RFJHWk5BbnZ1QkhQbThvSHZYcjNy?=
 =?utf-8?B?eTlSUnY4elNNdEg2aS91THA4K3AxMEVzbURxMDZhZjBkWHRyOGRMZHl2c2ZU?=
 =?utf-8?B?ay9OZ2srdjdaQWgxckZhWlFRZHUrOGlKeGMyV2prMmx1SnhmSG5aaFR6TDFx?=
 =?utf-8?B?c3c3aEV5RCsvS1gzTDh4NGgvN2MyTDVDVmwvckV1MjRQNGZFZzRBNWd0Um5M?=
 =?utf-8?B?dEpHanBWTGN4dnQwTXFaYXFnMWt2UGtGY3lCcEdaRlhpNys2K1VzeWZaYmNi?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd04559-512d-4e62-22af-08dafd6ebe2a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 18:22:10.6571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0b8NHsTZ6WUUAjT3cm+icZprrhyd6DgvRkVE2fSn7gpuo8usP9WIWtpj2LsL9EDId/mCHFlzBbtF2uAuOoIq1NEDTepgx8BXpV07QehV6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7556
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2023 6:15 AM, Vladimir Oltean wrote:
> I realize that this patch set will start a flame war, but there are
> things about the mqprio qdisc that I simply don't understand, so in an
> attempt to explain how I see things should be done, I've made some
> patches to the code. I hope the reviewers will be patient enough with me :)
> 
> I need to touch mqprio because I'm preparing a patch set for Frame
> Preemption (an IEEE 802.1Q feature). A disagreement started with
> Vinicius here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220816222920.1952936-3-vladimir.oltean@nxp.com/#24976672
> 
> regarding how TX packet prioritization should be handled. Vinicius said
> that for some Intel NICs, prioritization at the egress scheduler stage
> is fundamentally attached to TX queues rather than traffic classes.
> 
> In other words, in the "popular" mqprio configuration documented by him:
> 
> $ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
>       num_tc 3 \
>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>       queues 1@0 1@1 2@2 \
>       hw 0
> 
> there are 3 Linux traffic classes and 4 TX queues. The TX queues are
> organized in strict priority fashion, like this: TXQ 0 has highest prio
> (hardware dequeue precedence for TX scheduler), TXQ 3 has lowest prio.
> Packets classified by Linux to TC 2 are hashed between TXQ 2 and TXQ 3,
> but the hardware has higher precedence for TXQ2 over TXQ 3, and Linux
> doesn't know that.
> 
> I am surprised by this fact, and this isn't how ENETC works at all.
> For ENETC, we try to prioritize on TCs rather than TXQs, and TC 7 has
> higher priority than TC 7. For us, groups of TXQs that map to the same
> TC have the same egress scheduling priority. It is possible (and maybe
> useful) to have 2 TXQs per TC - one TXQ per CPU). Patch 07/11 tries to
> make that more clear.
> 
> Furthermore (and this is really the biggest point of contention), myself
> and Vinicius have the fundamental disagreement whether the 802.1Qbv
> (taprio) gate mask should be passed to the device driver per TXQ or per
> TC. This is what patch 11/11 is about.
> 
> Again, I'm not *certain* that my opinion on this topic is correct
> (and it sure is confusing to see such a different approach for Intel).
> But I would appreciate any feedback.
> 
> Vladimir Oltean (11):
>   net/sched: mqprio: refactor nlattr parsing to a separate function
>   net/sched: mqprio: refactor offloading and unoffloading to dedicated
>     functions
>   net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to
>     pkt_sched.h
>   net/sched: mqprio: allow offloading drivers to request queue count
>     validation
>   net/sched: mqprio: add extack messages for queue count validation
>   net: enetc: request mqprio to validate the queue counts
>   net: enetc: act upon the requested mqprio queue configuration
>   net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
>   net: enetc: act upon mqprio queue config in taprio offload
>   net/sched: taprio: validate that gate mask does not exceed number of
>     TCs
>   net/sched: taprio: only calculate gate mask per TXQ for igc
> 

I don't work on igc or the i225/i226 devices, so I can't speak for
those, but this series looks ok to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  drivers/net/ethernet/freescale/enetc/enetc.c  |  67 ++--
>  .../net/ethernet/freescale/enetc/enetc_qos.c  |  27 +-
>  drivers/net/ethernet/intel/igc/igc_main.c     |  17 +
>  include/net/pkt_cls.h                         |  10 -
>  include/net/pkt_sched.h                       |  16 +
>  net/sched/sch_mqprio.c                        | 298 +++++++++++-------
>  net/sched/sch_taprio.c                        |  57 ++--
>  7 files changed, 310 insertions(+), 182 deletions(-)
> 
