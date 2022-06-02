Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4366353B235
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 05:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiFBDox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 23:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiFBDov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 23:44:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B471B16A51B;
        Wed,  1 Jun 2022 20:44:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZ6Zr1Qst6UQR2xt29Pqt5mYLzrs2Nghf5zCpY8MOpf4ZbPwkwYv7faOWJWJ/6gqxcUzrSu0r7u7zMUTHYHzw4Ke0G2m+UbJHmKjS3xBBSrNeYMx8oQ/yiderRqnd73vWMsXUASivTUw72SB1P3qreEpzfJKns/g8ixsixdZjo3gAdbSUBLyvj02AP1Ruqw0JcvMkj4WTseYJapT4nYVn9Obp/znatTCK6i1xumfk++cxuBT/i2diz54ENrKQZaVsaw2p88VYnQQ/5spPIUSHwY3pQPEdFVFMBtitHCAQFKc2SYAj07c3Lk1jL4/Gd+qAQq8n8/2XD6GWHL6RzWe1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LO0FtnNN082qHyxxWS/HSdQINrPpYR901eNde+tl5U=;
 b=icQX/j+7NoDKxnensQx65wA7gmBEvuGXoxN/dXJX48iN5QHahqONPSFqS+M/O0xBWBN7LwPtUg/kwQ3cZBMBZHkNNIbJeyOQf96p0SwEga2Jav9PJyyv9CwlYvNoQ6VkYEqaj6rqDdAmcg/oDhzeViOU+rmIRUe/W97qWGSdIuCEQ6mrFCmQDdWAL6HRMzDw8th8A1kGTSBZAK2vbsa6+T3nCtRxi7q8byhdOFo9C4S22LctPZst8RB8Wz6IpWHaI21Ooljn3vXu3UWKGZHLOWbxANX4QMEHk6sMOBaHfG0gsptIUo4zN29eEACwn+xgDrZYrX++dfaX7xzHKp4Ltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LO0FtnNN082qHyxxWS/HSdQINrPpYR901eNde+tl5U=;
 b=K3qXSvGZTnWYwH1MoNeqWIulxmKIP1xt36tfWVKaCX7LAvEELhC0p4UXuzHfe2V5uNiepOEFRMNU1qONvrF5EC6OTjyTBLtZ7VGoccu38sDRjluNDpZqraZDo4z1iowxfcQ8Cx9G7WgnBzyMUGKmeYsceyzugB+JBKYhFm2OCnJg7082HTg5uP1oNmZkr/bPQXu8K/merWergQ18zKUKp6Ys7Cm5SliayDq1ZZ3DummwELrL7+XaJx4RFpxPzqhGDTQvHkHgGhLE2q1AqUIVCD5MFIvVOPK9sjCeak8X4lXoHQLt17jBKCW6LKJac7a1+HFshti0mX+r1Bz10LiACw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by MN2PR12MB2944.namprd12.prod.outlook.com (2603:10b6:208:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 2 Jun
 2022 03:43:47 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::ede1:a4f9:5bf5:c3a0]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::ede1:a4f9:5bf5:c3a0%4]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 03:43:47 +0000
Message-ID: <534a43c8-5491-b57c-292a-dd56d6c8af86@nvidia.com>
Date:   Wed, 1 Jun 2022 20:43:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2] selftests: net: fib_rule_tests: fix support
 for running individual tests
Content-Language: en-US
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220601174316.4278-1-eng.alaamohamedsoliman.am@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220601174316.4278-1-eng.alaamohamedsoliman.am@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0178.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::33) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce4ba6a2-ead2-4e42-8758-08da444a1971
X-MS-TrafficTypeDiagnostic: MN2PR12MB2944:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB294452A5540105479FFC30A6CBDE9@MN2PR12MB2944.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wha1wi8JQrw+XaeZo9Cu6QjvbI0F8bypiG32hdU4JvLCTJI/COHTRhfJsG2jeiq4kxEp9EnI4A20a+crQje70YBY2EH2gx5Srqw7TXz4SwXWcFS7E8ZgcztIIcALcPPO2cVEJ69DfqD/VrEnjyKmRcO++C7h+Kw7VjjBRfxEMXTY91PINg7sfI5mj0BEgzxB3JMW3HigXG00adGIL0kSYW2vNwZgbPQBpEg7g4Wwkp5DLGkEsFLIak4zZu0yAykOaQRDugZ+FeMS35rH+pVLtWqW7vJNLHmj55FE6ls3XSCAVvVnMv4lu23uqo5UC1IY+OXw7FiDbl/S1aPLC4PTPB1PNZ9oCV+NosHBX6ZcIOcLWsml4uZTY628yEF7bxtMnLJm3aLYWvB/nnVCZyAk2aJz2QJSdhiGxYiHAnwcFTs9s+u9hYqtOLLU7kEIBsVqCWYhrZiX9T3xwkfijm3ilqAUo64Cv0Vx9lAZ1ycuCDUIcB0vret//Pu67GiW0W3lZ0V4nJaj5LaPgGnABQUoWDfy083AZJQJWv9kqWVFyj+vzx5lFCXRHJvpa4FCHDUZaTzRP56W13htW+8HuRwLgeEIqcR9ZsLoc8gyCQZWx67SgruIPbvJF1VJFArJ/y9nKdJVK4v75fWXvOw32cgVBTVjrSaJ6t9MZcMcZbGaWGdfgCiS01YEwC7QF2jTG5/ZvSJyhZs0hJnHzCYmILxI+fOAPF1pH4z57BQ2rOuC3gNUyQT7BvZOIWkxn/0ayiKI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(186003)(38100700002)(316002)(8676002)(4326008)(66946007)(66476007)(83380400001)(36756003)(31686004)(6506007)(66556008)(31696002)(86362001)(53546011)(6486002)(8936002)(5660300002)(26005)(6512007)(6666004)(2906002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEtkdVlVa3ZkcHVaMlNVYU9NNjRlYXJxem82N0ZCNnhuR0o2SnR6bCtNaU5a?=
 =?utf-8?B?aXpHS1lEK1pxSzNsYXhSR1Vob1c5TjQ1eGQrb2lvVHNOZytlRXlob1JJZ0VB?=
 =?utf-8?B?NTlvZTZDNkJjR2htTE4xdmJWeGRWNjBiQks5MGhXSGpFRGxtWlVESW9KZTQx?=
 =?utf-8?B?K1dWVDg5ZnRUa1pqRHNyOVhQNVJwQ09UUDhlT1hkS2ZlQWkwOTVSTTF0bXZp?=
 =?utf-8?B?QXVHemJPNzFyYVpxS2RKQk5EdmlNT2FYblNwb212OVNWbVRLMDV2bS9uSmNT?=
 =?utf-8?B?dFN2RTZhQ3pQcERRTEdKM1dUcC84NGE0S2ZIZFV6cFJiSlZsN3BoZUFpMzdq?=
 =?utf-8?B?ckFGbjgzcXErZnAwejErVW1rVmk1OGhwazc3MVNRUThRbFlBcGpIWEV3R0VF?=
 =?utf-8?B?bVBIdG84U2M1WmlieEVoUFh4Y0JhTUdMUmFJdlRSMVFRSzBsejZmenRiK25l?=
 =?utf-8?B?ZXdYbWpBWGMycXdXVjQrTHptQXFBR3VCUWtlYWNiN2JiSHZOVE5Hc3FRT2tD?=
 =?utf-8?B?aXhnVDlGamR1REFqU21kMFJ4bHg5dnB5T3pKaERhN0g2NzdYTUszby9UMTBR?=
 =?utf-8?B?WGV3THp6NzQ4TFRVbUFCdi9IVnQrMUI4L2NvTzhIM1hUcndSbDVxaEtSUUlF?=
 =?utf-8?B?TE00c2Rad0VDcDV0dURwb3pyNTlORWd0ckkyNUtMT0xuNHd0YTRjM2JMMmN2?=
 =?utf-8?B?VXRVVERGVmR6a2gzUFlDK2ZvdlFMdnoxSW1KMDlvS0dScEdGTDRiNEZiRW1y?=
 =?utf-8?B?cFhQdUtvNW9OOVFpNndzRzNnY21xY3V1bnp4NVhnMTVRZEZxanZWa0pzY1dj?=
 =?utf-8?B?ZWFLUnQ1Q2RUTlhlajdheUlSVnBCODRycTlCaHdqTnNadk5PSURPdmpQdmd4?=
 =?utf-8?B?bW9lSzRFZGdyUlZZQmtWWXppQjVkVTY1MDJRUmEzTXEvajZTTGdKVGtndXdp?=
 =?utf-8?B?a2FENENNV1RwRm15b1BiRm9ma0o2aWZ3SjR4MWVIT2NucG1xT09RV1dLTE9s?=
 =?utf-8?B?VmtMelR2TVNmS2ZOaDVyRU1YSGphQ3E0dlpjVElMTTBUSUE2by81c2RMbUlF?=
 =?utf-8?B?RlZQUFJkTlRzc09GY2ZGQURMLzh0UmtjTjNObUxENUN6ZFFoUEFOandWTmdr?=
 =?utf-8?B?SDc5YVB4MXA2OHo2aHRkMitUVHdLRjdQZis1YXhQd2FvZEI3alBYRU8yS3hZ?=
 =?utf-8?B?RE9KUmIzUWlBN3FRRGtzbXBla2g2U3EvR1N3ZmQ3SXpFT2lhbmJ2QkpHN0tD?=
 =?utf-8?B?SjNDTGdoaHVyZU8zQUZnNUV2R2s1cEZCbGdYWkZJdGljdlluOERVbGhReXdW?=
 =?utf-8?B?b1ZFV3NuckxWcFV5WCtGZ2g4eC9RTFpDYjdIYUY5Ukt5cFlYWmFVckR0WkVZ?=
 =?utf-8?B?MERER3dVTmNyR2ZseG5UVmZ2enAzT0swd0M1UnUyNjgwSmVZd0hySXpLU3hM?=
 =?utf-8?B?L0hVM2pmUDRNZytaUDlnZmVXK2c3SkpKUDlBc1R4VVRtUFMwT04wR0lpM2JN?=
 =?utf-8?B?L2NQUjE2MUFNK0s2T09PakVKajVzTWFxc3VuV2RxSzhzOVZacS9HczRJM1pR?=
 =?utf-8?B?aWxDYllYb2YzdWI1TWU2bU03QlVUaWlCZ09PVmRjWjB2MHYwMy9pd0VlSysx?=
 =?utf-8?B?Q2xIWTkwbDQzenpGbG9EbkxqeVNyaHlZdE9lVGVwcUZvMUFhaUMwVW10S2t6?=
 =?utf-8?B?Smt1UmVqbHBFMDkyQlo4UndUdHppUW5BVjV6bkg5bnJDUWcyWkFTeFV6YzVK?=
 =?utf-8?B?UUMvM1BkbXdJaG11Qk01TlQyRTFOcUVLcHFnV2hkMDZhVzVOYnFvaDhyYXdX?=
 =?utf-8?B?UEdESU44dGVXcUVSWWVVRHZJam9IMnlqZnEvU3FCZ1hhRmxWTjlDVkpzSDlQ?=
 =?utf-8?B?VGE3bkZranZGN0F6ODZlaG9GWWZjOFBaRHlxbUE3cUtJb3NXUkVEMk8wSnpJ?=
 =?utf-8?B?UW5JNEtrMVBBMmVoKzJoVmZJMFROUmkyblFlTGlJZ2FhSXdRcDFqMDg4dncx?=
 =?utf-8?B?NmdvSnJ2c2U0NFN4Rm5uOFpqZ0hxQ0VTNlVvSTRyaWdBNkphRDJwMWwzc2Jx?=
 =?utf-8?B?MWMvOHZGZmZibFg0c2xFNFA0bEtiMTZqNnVsdVZYdnVHdzFUWW5xb081MVh1?=
 =?utf-8?B?TFRiL0thbnBYN0NoNXRkZkRWeUZZb0ExVWxmNWpReVduUVEzZW1JanY2b3dO?=
 =?utf-8?B?aUVTOXFmaU5oTkJCT3NjL1JKZkFaUHI2RVVEZFFNRDlyOUtGMjFWT2ZsbTdM?=
 =?utf-8?B?SW5JRllveFdHMFhoZlorbFNOdUFTNGJLV3lOeGlhSVFPME9aSUVXcEtLN1o3?=
 =?utf-8?B?UThqcHgxMWN6d1YyM3hVMXUxeC9oMmFwSndWamdwUjVvWHcrOHFLZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4ba6a2-ead2-4e42-8758-08da444a1971
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 03:43:47.3672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YIp7akzSbX8e3T/a9TFqDwdyjh2Rf4YkIRhq6Fd2SPfKWcfEuwcgeFBXdhp/UvovkN2EoHN3c4poiHROqGvj9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2944
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/1/22 10:43, Alaa Mohamed wrote:
> parsing and usage of -t got missed in the previous patch.
> this patch fixes it
>
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> ---

Alaa, need a v3 with Fixes tag

Fixes: 816cda9ae531 ("selftests: net: fib_rule_tests: add support to 
select a test to run")

do a git log and grep for "Fixes:" to see an example


> changes in v2:
> 	edit commit subject and message.
> ---
>   tools/testing/selftests/net/fib_rule_tests.sh | 23 +++++++++++++++++++
>   1 file changed, 23 insertions(+)
>
> diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
> index bbe3b379927a..c245476fa29d 100755
> --- a/tools/testing/selftests/net/fib_rule_tests.sh
> +++ b/tools/testing/selftests/net/fib_rule_tests.sh
> @@ -303,6 +303,29 @@ run_fibrule_tests()
>   	log_section "IPv6 fib rule"
>   	fib_rule6_test
>   }
> +################################################################################
> +# usage
> +
> +usage()
> +{
> +	cat <<EOF
> +usage: ${0##*/} OPTS
> +
> +        -t <test>   Test(s) to run (default: all)
> +                    (options: $TESTS)
> +EOF
> +}
> +
> +################################################################################
> +# main
> +
> +while getopts ":t:h" opt; do
> +	case $opt in
> +		t) TESTS=$OPTARG;;
> +		h) usage; exit 0;;
> +		*) usage; exit 1;;
> +	esac
> +done
>   
>   if [ "$(id -u)" -ne 0 ];then
>   	echo "SKIP: Need root privileges"
