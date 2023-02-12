Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5A7693704
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 12:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjBLLdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 06:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBLLdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 06:33:36 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA94E211E
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 03:33:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NjTHTPgCNAjET6YJD8GmvgArmw/lxFu1034U989taP3SJXdzL02xd2UhS2uUfhMlMUE/oz3ThHQgL9sgWzqUur61LAjNNk4t1mJJVBqb6etawtGH+yPe1I68wNwxmrztfHam4k3w9RK19MP1UaBRlNdSHWqhj+ZjqBk89woNXzYmwssDZn7+LQVJmvQYGVx5nXvJGJ/0W3A3CwI9CVyCxYj/ed/cg47B3nJZS1JWRr2YpecrD9HhUxUM8gByMCexYWFXnQDr+WkyN3Newf6zwR4h3wGTBa6rB4KQ1owkI2R0SIKwvJneIZNIbfNnT968iRkYt5mRX7weBCiYTBOShw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZhInKnAqqnW5FLrbWOMwL9kGpU3e3hUByA5jBI6WuA=;
 b=hk+eZLkgjfVVWH/jktZoghHAiU6zI/7/z2umbqWKgD2yeMuLTK/TdBqdXZJ5ZO3oJIfcqTtOEAfr0pXfWyh1t6VZtzPqhGhXB8b+dnI6VN36j/vG/rCtgcqFG2czdOwKNIxs9COOGCB4HpAF/WxhvygYapsq8eSy0jENmdqV3s+pWHzSlRVsfagiUMpYgygmzbWOb4/oXQXhhMSB6skcof7pM+uJdG61YULySnAHg0ocDy5E/Hz+frw/QAXfkgfCjOICWC55ww1lYbTgLgoAdLtpQn2V5xRLA0YACLvP6LhoUGwvevs37kfhYLioJc37WZpBg3R3NeBWrIXYMW7WuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZhInKnAqqnW5FLrbWOMwL9kGpU3e3hUByA5jBI6WuA=;
 b=CZNu8SNGPByrLkgsPpHQP9k79/HZePWqCMvUqmpVfOI0mz1Rqc6bmex/tpGJR6jA9wwNMXw9x7D2UOASxbX3wKpaOgfc0FMchh1AmBowCRUjQlD5lSH1GghsZXytvc5Ex7nGlUU9FM8a6nYCHn22up3MAncRKLTqnRNpAETVAb94lU3oLNgfhuNLSqkZVf+0ZYn/i7a8hmquem1zcsPLBHeJ1HBkmRcd2JLL87gaJ3brgWbBjP5mBybZ8P4PxMrkIzSuZIFOrq6DxKoVfqtsa9/rhRw+NdaHoQI1lLxGqYgronAjBQghq4Xg1e5dETDspKR5viyxLsk14o0dPxsZ7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DS7PR12MB6333.namprd12.prod.outlook.com (2603:10b6:8:96::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Sun, 12 Feb 2023 11:33:32 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::85c0:24e1:600e:1cda]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::85c0:24e1:600e:1cda%3]) with mapi id 15.20.6086.022; Sun, 12 Feb 2023
 11:33:32 +0000
Message-ID: <f49cc7a1-f873-b6a3-9654-16a7a662dad7@nvidia.com>
Date:   Sun, 12 Feb 2023 13:33:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v3 2/9] net/sched: act_pedit, setup offload
 action for action stats query
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
 <20230206135442.15671-3-ozsh@nvidia.com> <20230209221906.6a69c79f@kernel.org>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20230209221906.6a69c79f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0074.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::12) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1307:EE_|DS7PR12MB6333:EE_
X-MS-Office365-Filtering-Correlation-Id: c3165fd5-8199-484b-9073-08db0cecf82d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kA2cJNeVozQLTdh9qym4EUMXwekcEtITGLWDsGmeGKSbTWdWvGNslgk94uLu8M76eN89awts7A0Qq616lSH780lwqjUB7QBUt3BVfvR47ucx7BDg/w4mglt8Hl55rIrekrki/KiAkai1xRuoPiIk2YLuOcoPCAcP/n2HB2zvg0ajj47JaCwlTO+ag9G/0kGfY8rvr+4C8VDPwxnTevS1aumal0HesvbcSjWgJ3YcX3aKbrCf0ztq00cnbAQfqg/4qCfhzoFwv/8dspC7TRRxrl1otOkGibrfXsnt04IywfPPp+2XgPlNIJ/6zkwif9IKflkWGeuKSgG3zIMjelkIMGUEvur6gW9UR3M14aXXnUmoobHLP6cjs5YxY+GGwwR4xYhzTfKyoPy7ttuxc/B5vrJduuRd+zAEW71UL09Gqlurmjmd0hCwyjlJax7S2c7ONkN0qwODrx695fyKSOIQ3I37K7aS/I4m3er4PpMQ9PB01GY5CaLANqLkbLyk1cO4HQsCgnXJldN81I228jvPZZWrKgBF2nVdaNUBameKzkkPJYe7xmcvM24cGOj6dhZG8MX47rJWU+5LhEXF3DYSntVnZo4D+j54SG4SD9mORl2Gccx9/7dZ8fNg0O7dV6veKS52oAvKCNEwL4v7ZLRHz2Si9psNizp9YF6/OOosuqnFFsks7l3SLbOOvvcFjvRH37OMKd05HCxocEnArICNC2xwHvcodXSSgsNcx+w1myU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199018)(66556008)(66946007)(316002)(54906003)(66476007)(8676002)(6916009)(8936002)(5660300002)(4326008)(41300700001)(6666004)(478600001)(6512007)(186003)(53546011)(26005)(6506007)(2616005)(6486002)(31696002)(36756003)(86362001)(2906002)(4744005)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YW9LR2hMTjlCRklHNkNtR0RDTnVzSytVeUw5YlBYWnIxZkJVaXZjcE13UVdO?=
 =?utf-8?B?bXNZN3EvUVpVNWV0aDBwNExZNmRDblo4emFtZDVtN284YUhhOUlTNHlrRkYv?=
 =?utf-8?B?K0VzcHJVYno2NGpDQWFHenJzdmFmaVJGSG9aU2ViaTZmbG9PTnJKT1MxRE1N?=
 =?utf-8?B?OCtPekxXR3hWRDU4Unl5eVdYaDllVHdpR1dGNDJwS3kzaEN6bTdTVjFLVWox?=
 =?utf-8?B?TGlpNi94TnBBWWhCeG1TaFVyZzZ5Rm1aR3hXQllOZlVwL1hkZklDY1IyWjVy?=
 =?utf-8?B?VmpQaFVYRDBOd08zYTByS1FYQndQaXdJYTZ5S0hrcndpNEZYV2s4MjZmNkEz?=
 =?utf-8?B?Qy9ZSHdBM0MwcWFLbGRIeTY0aU5jemdpRk1SK3ZDbTRDdUl1alVWNWE4VXRU?=
 =?utf-8?B?UStRTTZic3ZtR0lXZGd6L0E1b1VCeEJBeTcrdnJ0T2ZZSFJ2UEhQUmtoZm16?=
 =?utf-8?B?N2drNGlTWENMNW00Vk9rNFk1TGlxcDNvOFNNanVSQnJzL1RXK2pEWUtNdzVP?=
 =?utf-8?B?aFAwWkFwYXQ0MUNqTXNNV2lURk0rNnkvTUNzUHdMMlNqd0hnTHRSaUZkblBG?=
 =?utf-8?B?TkdiYUU1dVdXK2RBVXZMRTZmOHRUK0h6YkJwQU9sK0UwN1FpWlpuZkJhVUNT?=
 =?utf-8?B?NGJhT0NHSWQvN1JqWUVwS1J0dHR5YkdGTlZrakJ5b0JLTVlERUJjdkFXbWFX?=
 =?utf-8?B?ZlhWczduZHJHKzFTU3g4R0JFMWs4dlg5MWx1WGNORmxIc2NTNGpQbVA3QWZ3?=
 =?utf-8?B?L0oycUwzR0NQWCtLTHZuZjVod3pxcGpzOUtUL3lrVkRFWnBDMC9Wa0d2eFlM?=
 =?utf-8?B?eVgxMVptWWdLN2QydUpXSG5odlEvMTJrejNQZTNOWnJORFRSbjVHOE5TUDNx?=
 =?utf-8?B?Sk5VM1ZiNEF1dmUwQ0NRdm1weWxybW5TM3hkVkd5T21LU2pTcXRIR1pzaGJG?=
 =?utf-8?B?RGFCNlpleWpIbmZOMGMweno2U3FIbjRMMm1TdC82Q2N0UGc1WUsvWWkrb2dM?=
 =?utf-8?B?aGNidDBHQnpjREhLK3hsSzNFcHJvREpiS3hNZ29NVmZOamQrZk5ZNlFWWmJC?=
 =?utf-8?B?T3RXTmVqUlhMTUt3QjFmaS9yaVdPSCs2eGFDeDg1R0dqR0liRzJNS1ZhWjdE?=
 =?utf-8?B?MkhsOGNnaVkveW4wR0dPWGIxUzhkdWRqRnZyRW1pMUlHZWVWRVd2WGwrVXI1?=
 =?utf-8?B?Qm9tVWlRNStFVjJiVExCVkRzNHlrd3FNa0RaSXdXaVhKYm9mY3hHYjE0dmNP?=
 =?utf-8?B?N1NhM2NGQUtibnNDOW02ZENYYWZYSjNYSDduKzZHT2NPZ3RwT2tqQjVnamRw?=
 =?utf-8?B?TmVjeTllaEUrOFJUOWRkQlBRMGxzdVBkZ1lNbnQ4ZVc0ODk2bjN3dDd2dDd0?=
 =?utf-8?B?QTZ1VE5GZ0JtVEZWamRDSk5xYXdNR2RyZ2pNaVlMQWlPbzhzOGY4K2ZqWUpw?=
 =?utf-8?B?UVdheFg1T3g1QmhrbHpHTjUyZ1NycXFiNmsxS21YRjM0RDhacmpxbnN3SWVm?=
 =?utf-8?B?amM5RitQZEdLcm1YdEE2S0FkQ0Q3V21jNnJUZGszKzlHVFFzV05lTnlqcG5u?=
 =?utf-8?B?bkM3OUxOaVRVSHZRWGZ4dXk2ZHZKaHhVR0VsQURhTHhOVlQzaWU1SVVnSkxJ?=
 =?utf-8?B?aklEOEJ2ZWZKNHUvbzhaMmFhVUZqc3MvSUJ0dXJVSFQ4Y0hRQjczTVZ4ZTlD?=
 =?utf-8?B?MGVkYTdpM21HeE9oVTYrazJ5eUt5dU8vcE9LeUFmSmRZdXpBRGhqckJtK3FE?=
 =?utf-8?B?ajNGa2pMakp6NTJUbGhOUEppNkl4N21CbXZpbkF4clByYllLcXhhRkhtZE9y?=
 =?utf-8?B?YWJVdytSMTI2MThhYnFPQlJLSTl3OE1iTnFaWlBKL2lwWnZVdThSQjl6WTNC?=
 =?utf-8?B?YkVwVG1tbFZLeTJOMy8wVk9LamtJNm94SFJQOFZ2NnpWRUFmbXFiaEVZeU9a?=
 =?utf-8?B?eXB0Z3BXZ204ak1ZTzRxWGt5bXVqNXZLNmhzeGh4V2hNRHhhVDNGWCtzYmRp?=
 =?utf-8?B?L1lUQzVMemVZNWluSEtVVk9kMzFuQWRLeG9Pa3dyMDkwQUczbTJ1ZDFIM3Nh?=
 =?utf-8?B?ajE4RDVNMGxsV1hTdms1RElUNkU2Wll4emJERWdodVU2VEJ5REVmYlpOY3RR?=
 =?utf-8?Q?Mbn+//QtFEi7XtPecd+jTcjdF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3165fd5-8199-484b-9073-08db0cecf82d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 11:33:32.1420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFOggMHYlhByIOEnp87MC0O25sWJEGzTUtyjVl/5y1Ee8WXnrUDszvxUT+1Q7tTG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6333
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/02/2023 8:19, Jakub Kicinski wrote:
> On Mon, 6 Feb 2023 15:54:35 +0200 Oz Shlomo wrote:
>> +		for (k = 1; k < tcf_pedit_nkeys(act); k++) {
>> +			last_cmd = cmd;
>> +			cmd = tcf_pedit_cmd(act, k);
>> +
>> +			if (cmd != last_cmd) {
>> +				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
>> +				return -EOPNOTSUPP;
>> +			}
> Is there a reason you're comparing to previous and not just always
> to the first one - since they all must be the same?

That can be done.

I will send a new version.

