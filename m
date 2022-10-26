Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963DE60DFE4
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 13:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiJZLn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 07:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiJZLnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 07:43:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA6162920
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 04:40:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTgzcDvCgSvpwdZvJ1f3PUYPP5hQOTKYAJUb5LuJPsi01iJCJ7ajUeVQrLkItgzJ/L4srQM89fZX8gC1xTiKBPO6rmQ1P6MJwSpMOjmkzyfOzC5KPKuqL43bmu+rtRMHJTwVhW7FAb3gA0xr/XdXRo5nisLqb+HlgIJwcHh7fHdQk7WYrWr5fpLwKY8GdWtTia0QbYH37mtSW03z1Zf+DGrQ5Z5FRIBKqj6P5xN5nlgS5yT3fZKgzRHXe1ZyF+Mk7swHSo0UreLUpNEvnfmgRkPnLQCgMb9CDIOMtIQxHJebb2VNqBGVgn3D/5Gp1APtJ48jQ5/af5SjwRHPIvgNdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSf0Bto9KzAttShJVH5wDUt9l55I7L5THqhwDeOunJo=;
 b=O6TQgXiCPJw5OEYaTgmLyxsSNJduXNcwNtj55NOnDPFx+9/tiCySDUPmRJT9ze5OWtILelmvuk+ByRLFGrkhY+VPOnyvByjue3E/3kWe7BK5mB7FBsL7UEwlt7qV4sLJ9n8QCfFwtqR6BeBB5+NrSOmP90x3dQIY6iOlx+LqgCs/nHBMiCtbvz5lwR6it+AR88iV1swMlrENkiBkGyhGGLRDBAu7IbJMY8vWirRcAXRMUumu5nvbhkg8AtLjBKpgbWTpxR0ahMQYR0PK4h0k14iMNLbIhMsePLq29vmDjJjVCm26FM6+CmqIZCUlUULjTJRF/VuXQIeuJklw3wZ1VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSf0Bto9KzAttShJVH5wDUt9l55I7L5THqhwDeOunJo=;
 b=ZjVNk8QysgjRrfB67xELTuLrcN7iWZF6i3nNDErXeI+9oJ5MtqzlBnlYJ8TLKBTpYKbgZU9UgU+y1LqZBJwpqYGXICJRSD/pdzfxvawXN5a5WAwn3BalTc8gnx98xnEo38R6UBORXV/k4XqAaw3QU6PZBcXfIqXf9ZlVyGvNsiIOhfmwxUfy0R501PwtW8Ll00phfcPLBsR7/1BQ4lBxE1DVKJPpwjt09PUjiY9fFRy8rrbGj+/fRYGx7FyksEMIQwW9TXmq+1jFj+Nct/G8cIIsPYxV1x8FfQT6XuN3brhd25m8j7MJICrgjPV/qSGEtcoA9AeGp7SrBAECerRgsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by IA1PR12MB7639.namprd12.prod.outlook.com (2603:10b6:208:425::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 11:40:48 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::ede1:d11d:180e:4743]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::ede1:d11d:180e:4743%9]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 11:40:48 +0000
Message-ID: <c04ab396-bea0-fcb2-7b5a-deafa3daffa5@nvidia.com>
Date:   Wed, 26 Oct 2022 14:40:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [net-next PATCH v3 1/3] act_skbedit: skbedit queue mapping for
 receive queue
Content-Language: en-US
To:     Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.duyck@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, Maor Dickman <maord@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
 <166633911976.52141.3907831602027668289.stgit@anambiarhost.jf.intel.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <166633911976.52141.3907831602027668289.stgit@anambiarhost.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0473.eurprd06.prod.outlook.com
 (2603:10a6:20b:49a::25) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|IA1PR12MB7639:EE_
X-MS-Office365-Filtering-Correlation-Id: c4011908-2bef-4a74-f36e-08dab746ed09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ud3yzfzeIE+xazc3XyL3lwEIRmNj3wDzbPN66GW4sQMIhuBKE37q26vNyGDM5UDmh73k9Qbxbgb9eN+IeGUf8dwoOkTVjcsveJv+aeJBEfNBQG8DUa7wYj1LUVJZzv1f6Ud+MQakA2ZGA7F5OIbZc8HAwCt15t0MakJtvG9YGJ1Hp3+11LdmUoIfVnhJ/wB68WQlvk/YpMXKMGpe4K/KGDMqJwIC0JiRN31+TLw3r+Yvf4k3b+1ECveqx4L76wd9suM+b3W+mTQ73D4C9fMI8/BtO2VBFzedORaV+CvKV1zuKeMdaOF+pxE09HRcwg0KMTgKNejYzTiTAZ/iiWcnvU8Y8y8i2qdWgrq2kZUAH7lUwrm9s0U+QIoPPCv280vExGEIygA9POM8ex162IIu1zJVSv9aZlCdEQ9s2OD1WOcHrD5rBvovR/Wx3S6t6fi6X4AtGoc+UpG3jnuDq88FzHxtrWZCdieIADaBZrYwqHEuPG2lk7CtudAEwE8lYHS4dyDmuT+csQpO29hFsYuCuGPo4dEFLrKB+aX/OEM9snCDycVjt0J+AK+BwETEyd1zd/JazKPwrUGVL2HP661DwFCfc66A8AYdLf/qSVTSfvS5RhL3fL7nTW+GnsAd6iMbi9XjExNe7ffCmomI0XBRhoAjJN030Ey+/BBO8OfVQYZZ9js5DvCNXcw+2Jo+24ptQAOyBNvvk/98iXOfGYeBaqkNHsIEV5kKF/GrCmRMiC9ERy+VKTPL6V9zBS55yxdSpPwww5vSV6qp6Q/YNZaGsMbqEgGrDR+nPXhLHm9U2q8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199015)(8936002)(7416002)(41300700001)(8676002)(66946007)(4326008)(5660300002)(6486002)(54906003)(316002)(6666004)(38100700002)(6506007)(2616005)(26005)(6512007)(478600001)(66476007)(36756003)(66556008)(2906002)(31686004)(86362001)(31696002)(83380400001)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wk1wb2hWRGM1OXRUaXpSRHE0RllKOFliOXlRSzg2VEw5bW40RlFFd2UwUkl6?=
 =?utf-8?B?ZU9kWUFBRVZxSDNhTCtLb0tRV2lwVFpzakh6N1JvaGtUZnE3WUNWcmwxTUVO?=
 =?utf-8?B?aFJlQjZkaTc4L2MyQVZlY3FBSW1FdmhjeUhHME5DZHhoK1dPSGZVL2VXTVo0?=
 =?utf-8?B?NUIveEdqQlpaT0dSMnFpa1Jsbmd0Ykp5Z1U0NGRoRXVLSzc0bm0wOGlaRXFs?=
 =?utf-8?B?THZ4Q0ZlWTBDRDdaWjJPeVdBaWhwelpKK2luclBqV3p0ME5FQmNDbTlMK2di?=
 =?utf-8?B?Y0pleHc0WU5mZ1NsOE1ObThWV0YvRXlkRXhrRnNGekpjYzBlRDkvN2R1NUF4?=
 =?utf-8?B?Rno1WWI5OHh4OHhvYmYzMXNXcFUzTm5nL1AyNStrdEdReHQzMEl3TUp2NE5T?=
 =?utf-8?B?V3NVdWZ6OHhUckZzKzJSVGhnOGYyYWhpNFMzdkQ0UEdaM0psc0lKdXpQL2o1?=
 =?utf-8?B?ZWxvdUFUYzN5blZtN0JwQzY4QmlMeWRPL2JIb1h2L2hNa1k1d2IwVHpYM1ha?=
 =?utf-8?B?cXVERjFPN0VnZ0RmOUdaL04xeVh2M0htR0M4eU1ON3Y3U09jUGY1bWtPZUx1?=
 =?utf-8?B?SGdSS3k1VXJvczJRL3dDdGhKL0U5ZHE2M05KaDNBM0Rhdk5YR01yOXUyUzRW?=
 =?utf-8?B?NTdFbjgyQVk0NUhUNzZKZnVjYVdqR2QySDFMelU0elk5TENMWHo0N1VrWUxE?=
 =?utf-8?B?RDY1MnVBYmMxWkpkdW9wbEtleXhRT1NGbGFUd2NMMHRudWlHRG51Tm1wNUtu?=
 =?utf-8?B?UXgvTndiSklKVitRdUF1d0dXMHNmYU1seHZTM3N1NzNiaEtHeWFpNitYN0ZK?=
 =?utf-8?B?QjhHM2l1cmJ6czM5Wmt1RmRndmFuVHlOYjd2NnlNNUFVNDExQVNSM1dvZ0hq?=
 =?utf-8?B?bVhBckxjODllOVV4cHovUGZBRStPN3J3QUVQNnRkZmtEUjdGcVZPdC9hREQ1?=
 =?utf-8?B?dzdzRUxxRG0wSVcrMUowSnNpN3U3UUxFM0UyenNqamRxTGRVbzNnWU1GNVE3?=
 =?utf-8?B?VE14ZUJNcDdkRkE5QjhiUTJpUnkzc29GRmtwQkpEL0lPbVVhL2JDU2VMUWFp?=
 =?utf-8?B?UktKSXFRSVZoTmhzazN4WHNiSlZTcWJ5b3FXc2xYdHcyWEZXS0lxb0RaMnlp?=
 =?utf-8?B?cFdJV3gzRVlqdUFrY1k3dkZLamFKZkZzSjhsS0hYTWNwcVJoMEhVY3lSdmlw?=
 =?utf-8?B?M3RiTW9EemduRHZsenZ3Q25oNTlwZU8yWWZhNDRHbXJhd2hJNEdkRUxpTWhO?=
 =?utf-8?B?UEJqTFpwRElBKzVqMkF3bHlDN2VMVUdTcjFJcU5taGp0SnVYRDFVSFRXMTNN?=
 =?utf-8?B?aVdZWUhRUFBkNDZSUEl6S0ExV2N0OU9TRm9vaHpPSFh2cXhvVmxjZm9XanZo?=
 =?utf-8?B?dlkzYlRoNmx3L3IyckR3MmZOZFRlMzg2ZXdWVDdPZW5sSCtOV0R0b1NpREdL?=
 =?utf-8?B?M3hKemgzaUtJRFZNbGpsRnQ1cHRhUjZvTFFRazArODhveHcwQzBFUkdLTEw0?=
 =?utf-8?B?c2ZmaFoxK1UvZnJXZStvUlRtVXo5U0I1THErMzZnQzJIV1VpRG1VVVZlMzFG?=
 =?utf-8?B?WStmYnRuMmxUY0g3KzFHZU45L2taNjdTcnRoNEtBc01uODQ4RXFhazMxM1FE?=
 =?utf-8?B?YUhrWW5EUEk3azFSM3oyRjNoVTZrdzdMRHIvNzdvZm9sYjkwYThwcFVWcysw?=
 =?utf-8?B?S3RHQWFCQ2ZmRmhnSFNkVHM4aCtBZjMwbVlFRi92eEFLMkNzLzdmYmxVSHpr?=
 =?utf-8?B?Sm9paWdxR054Zk5NSXB5TVRjK1dPNytYdmVNQ0lLZlVPMEgrRU1rd1pqK0c0?=
 =?utf-8?B?RlJ4anIrTW1TckxHQmZjaS9FTjhObHlXNHkyK1p4eXdRMUoxYjhjNlQycVBW?=
 =?utf-8?B?ZXpuTjg3TXBEWmc3LzI2K3lFVWVVNFpqcHc1L3M5QnFDWVpiRk45Nm9xRFdN?=
 =?utf-8?B?by9WQzhRa1VyQWV0RjZHaTRrRHN3UFlFQy91MmRiQitDN0JtSncyVGFYNXFv?=
 =?utf-8?B?anJDMXlHLzQvOXpOQmtObVhvKzFKM1ZGRGY3S2ZYYVhVVFg3eXlvMEl3MXRt?=
 =?utf-8?B?UzA2WFZNLzlLTmtQL0g4YU1UZlpGWDNucC80OXRPdW1Nc21yVUlHQlhQcUtk?=
 =?utf-8?Q?dZerdC9cwoOYacjLsWhIzSQht?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4011908-2bef-4a74-f36e-08dab746ed09
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 11:40:48.1292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b0fLytlTkXjvtlHhy9W9h/7opf6XYInfygIK8GiAgwFSTwop8MOtQFeeCejKfI2V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7639
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>  
>  /* Update lastuse only if needed, to avoid dirtying a cache line.
>   * We use a temp variable to avoid fetching jiffies twice.
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index e343f9f8363e..7a60bc6d72c9 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -155,6 +155,7 @@ enum flow_action_id {
>  	FLOW_ACTION_MARK,
>  	FLOW_ACTION_PTYPE,
>  	FLOW_ACTION_PRIORITY,
> +	FLOW_ACTION_RX_QUEUE_MAPPING,
>  	FLOW_ACTION_WAKE,
>  	FLOW_ACTION_QUEUE,
>  	FLOW_ACTION_SAMPLE,
> @@ -247,6 +248,7 @@ struct flow_action_entry {
>  		u32			csum_flags;	/* FLOW_ACTION_CSUM */
>  		u32			mark;		/* FLOW_ACTION_MARK */
>  		u16                     ptype;          /* FLOW_ACTION_PTYPE */
> +		u16			rx_queue;	/* FLOW_ACTION_RX_QUEUE_MAPPING */
>  		u32			priority;	/* FLOW_ACTION_PRIORITY */
>  		struct {				/* FLOW_ACTION_QUEUE */
>  			u32		ctx;


Hi,

This patch broke mlx5_core TC offloads.
We have a generic code part going over the enum values and have a list
of action pointers to handle parsing each action without knowing the action.
The list of actions depends on being aligned with the values order of
the enum which I think usually new values should go to the end of the list.
I'm not sure if other code parts are broken from this change but at
least one part is.
New values were always inserted at the end.

Can you make a fixup patch to move FLOW_ACTION_RX_QUEUE_MAPPING to
the end of the enum list?
i.e. right before NUM_FLOW_ACTIONS.

Thanks,
Roi
