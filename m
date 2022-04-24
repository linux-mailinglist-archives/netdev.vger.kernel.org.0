Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D3650CF05
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 05:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbiDXDv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 23:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236524AbiDXDvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 23:51:54 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92D6457BD
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 20:48:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djNqnQZj0XVWSx8+1J3gDg3pn7TmOadssHG2Ur60DbDdhZdtthos829x8DmiRG4T5kmoNBywTdhyU3o28eumn/BIgyojY3I+XJAUxFK+ouwNkI2YNSGt5/1zyuJDTh4dN11IZ8HZ+fyCOPowP+m5e4CiWGFyI3zZ5GC362rf17XXDZ1pVeqLBa3kttyf4dC3whfWxHhyFJmFBIciqlNJOMeSRgqKo4cVpv5SJjSizdDsAzH0/OeOEG3bigOdKt9MprCBxp9zwDAWXrnpFQWIzZyGW4/BiJQ+MYCrkqdaqQ4puft3F6Gc//1YcqBha+3lwVI3vSZ6FlHFksKW51D49A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GujJPAcOn1VB01oBPTUAZHhg5zrvLbChsvyxDFITroQ=;
 b=cLrAmT7zGo3T3lre71fOeLswn4Lc4tPxXTIIbaHdE0DBKbfWYwXzxB7e3+ij32Arj3jLm//IIy/xdwEd0arpct4UixQi8iwU7s6bSR6TDxSI3HbdZawGqpvo0gg7T7R0IHSolnwjoKywWJU8iHwBKu0j9E3RB6mg34hhvfsWVwmCiEYQ9KxJhVOmtdYTAA/uap65ptb9dzaaJITlUu20rxxYFwtZ08TJo1kEU20n7q9tSy7x02DoLtPJnZEk+KmxaeBGwJWN+AA6DHg8uNCotpRYwtLrb9LO6zaUFdNb4zKuPhZaQs0svbOoGx/XzAtXy0k3tXzW3kO4yzVwTd+RjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GujJPAcOn1VB01oBPTUAZHhg5zrvLbChsvyxDFITroQ=;
 b=iO5N63GdXeui9Xs8iY3/s7MApAs/jSSuSdSR8qQBWdAWrVL1/FqAS3EBYAP+C1Yx5jWX3iSzqDYiLfxklnkx3vIwDv2lIHRi/4ldX5i8mVUIjLxIZ32omSRZzL4IvLS7dV0m5L9oPZs8mtPUtXXuIMuAvTYahZyYoAYALBsxAAMN5JMgZP7Fi2KwQ89oCTry7vTmnOYKpE8oxnMksEyFk0/C14bCU1GCIfAgLJHtcXkgLc9cjmnyyrPow2d1Q+9/9ARAd3frHiGudSmf1yiXYbMk08UISdf6wjXOmi0wprKVqhHwDw9Etd88YaPN/fyGdJMQNLr/iMYGrge6V+zyQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by DM6PR12MB2825.namprd12.prod.outlook.com (2603:10b6:5:75::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Sun, 24 Apr
 2022 03:48:35 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%8]) with mapi id 15.20.5186.020; Sun, 24 Apr 2022
 03:48:35 +0000
Message-ID: <c2eb6a8a-531e-7a6e-267c-23577f2e95e8@nvidia.com>
Date:   Sat, 23 Apr 2022 20:48:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
Content-Language: en-US
To:     Jaehee Park <jhpark1013@gmail.com>, outreachy@lists.linux.dev,
        Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
References: <20220421164022.GA3485225@jaehee-ThinkPad-X1-Extreme>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220421164022.GA3485225@jaehee-ThinkPad-X1-Extreme>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0058.namprd17.prod.outlook.com
 (2603:10b6:a03:167::35) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f209c058-e950-4be5-4703-08da25a54f15
X-MS-TrafficTypeDiagnostic: DM6PR12MB2825:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2825483469C4FF8D4A24E666CBF99@DM6PR12MB2825.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FUKxFLMr3MojTOydkW4sVObxHkzGaq6ePFJZ1wG24ZxtFqTVKmE85dUOYUYZZbOWtBM4lJOlLRaqvQV/gbajxgszF55b3iCGkG+L0rHdIfkL/GORD0Q+aJzL71WkA8/ZjECou1B0pN9ZQoRlYNtC0hNplnm5Ih+q2I2ERvjeQhuMTQNCze1+uM1LBl8dCCZ082cSra8R3STaO0VyA5Yk4WjvtFbdt4/6McT3oWmPgPaHr4bYDjx76i2KCJsXwavd46KT7rR8Wmot0Dcy9LOSIwQSH9//ghe6rpqaXQx06jfCJo8Sp1n48es3FNZf2R0vndhZlnUeKNSx15B6JZ7CyjmRkzoA6QMhbGHTTJw0FCxgoCu1CN04sDqxolPkkoFAxDi+yZKd7c+kZh6ict+D3wqNApwes1U9WUb1Xk2scrCZtXwF6jTDV0ZLveEm5S2RM37KXOLsPIOuyHu2sw6j8buEFxEqdkufyiUTq51cyPF1nEnQH1gG6CzU5jsbABEaCR5/7i58Q0/wi3gaykhfGLIhYvbd0u7g4EKcejVLlTW4iYjT+O8YkGbozc5KlVBwm0ZjoKFhRjrUVOULUvhu3Z3BNdY7q4LUe2poW6E+lgF2K36EQfg0dK6Ted4+o0c+ah9IJDzh5pFG5iGMcLCQluAzIKJCYjCLvC9X6yjrry/ZyWGN8Kr4lgfFB2zUzXWN4gcaqlbx168CqpfSHSNCp0YzrYZVUEIX2RHiu9Ts+mo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(508600001)(53546011)(66556008)(8936002)(2906002)(66476007)(83380400001)(5660300002)(31696002)(38100700002)(316002)(110136005)(86362001)(6486002)(31686004)(8676002)(186003)(2616005)(36756003)(26005)(6666004)(6506007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bE1XQnZwcFp5ZVJMY0tMMEhuSDhJRXoxQXB0dVZFRzRRUGdGSTlyWURUMmpm?=
 =?utf-8?B?ZGkxdW9pcW9PZG1DTGh3YVhYaU5BdzZHUGlGT1YxaU82TVFVb1VKRHM4WnVY?=
 =?utf-8?B?SXNGcllxa2hUUWhwOVhmdGxuK09jV2t6azA2dVNZaElRSVY5Z2hSaE0vUHox?=
 =?utf-8?B?Q09yb0haZ2I5MTRuRVpsanhML1BUZHFoMzZHVnBtZzZqVDNzTVZqbGxneWth?=
 =?utf-8?B?R3ljNndxTWU2Y0l2R1IwZTZDN1pGWVVZcE1uVitGSEtsS2p1U0FTT3kvTGFM?=
 =?utf-8?B?a0RSbWRIYzRWdXFIRGFuK0s0STM2VENDYTVJUXhGbmRuUVVnK3N0U3VqK0VK?=
 =?utf-8?B?NmNOOXJVSG9Ga0V1cGx2bEZwaTZPRUdpVnpzTTR0Q0s0WTZCSER4Tzl4NDVs?=
 =?utf-8?B?c1YvWVZHK3hMZUNXaXlvT3lSV1Z1ZVZVY25vUXR4bFdyZ1orY3BQSXdXWVRP?=
 =?utf-8?B?YWlmU3M2c3JLU0lIK0NleHM0eVlhbUtKRC9qWVczVk15aTJ4YXo4dSs0T204?=
 =?utf-8?B?Vy95a29uUmprb1FTQkFqNDVIc3dzb2xET3JrNU5KdTVpdS8vVUxIZWF6dlR4?=
 =?utf-8?B?REY3dnYzM2RDTGZJeFh2dS9qYVc3bzE3MVUzSnBNSXNCZWN2OTJEWU1YR3B4?=
 =?utf-8?B?NFlldUkySTFMaFFEZW80TEcvS3plbjJ5MG4wd0FOT3J3SlA5T0M3R3lKRmdx?=
 =?utf-8?B?amdRcHZPS2E0WmhjT1BmVFNSZXRzaEM1K3NacGpuQzJtYnJLTlJGZkVrZ2lE?=
 =?utf-8?B?ZU5tTDFFZW95d2YxWlhrUWhRNUE0NC9TUTl1bWF5RFhRbW9QSGsrdE44d3lW?=
 =?utf-8?B?dTk3eEdBc0JMT3AxRENDVk9JTEh3cTlvZE9Vclo0ejBWdWR1TzlzY1BralRk?=
 =?utf-8?B?U3dzZTkyYUhTTHlFZnZJT2hMd243MnhGQlE4dy9SdXVtd2dyeWN1UCtMdkQ5?=
 =?utf-8?B?S3dmcnVzTFRGYmFRQklCeEFHMjRlYUQ0OC8yeHhPUndlV0FicEQ1R20xN0JY?=
 =?utf-8?B?dFZXWWw5enhyLzVLVGhET2pQNVVFMTZVd0hrU3RpbEJia0ZaSEwrWTdpalNy?=
 =?utf-8?B?Mk1EZUdmU25MRUo4bGZBTlQ3Rmhhb2pXWmVzSWRHRXl1cFZrQkJWQlN2anpy?=
 =?utf-8?B?MGxxcEJJaXFiS2JIYTlZQ1R2cnU2WDNiaExxWm5sRy9SRi8yTVdkbzNIamNw?=
 =?utf-8?B?c1JDZ1o4VmxFUGRqSlpkRjdPTU02ak1KZk4yKy9wVkVpUEVITWx2VmFSWjh5?=
 =?utf-8?B?WUcxY3NFV3JZVjh1RTVJRHplRnExZlhKSWdHNkt4QzdWRVprR1dlY1VZS0dU?=
 =?utf-8?B?Q2FuRjd3ZmxRa3NaZ05FdEZ2UG0xVVYwNGF4SXBIalJGbUFRUmsyd0lkcGJR?=
 =?utf-8?B?b1JpLzZ2MHpqTk16amd6M0srYnNvcjdKL2VrS2pKS09Xc2NiOS9zZG05SGpB?=
 =?utf-8?B?TmlXUENsT0h3VThtblpxdnYzVVpIVUFXSDdqcUlkRG9TZ25UQXF0bnBUWXcy?=
 =?utf-8?B?TWUwKy9ZeVNpZlhVSWJkYWJERjkvdjNacUpGM3QzRXNMdC9Da21DQ3BwVjhj?=
 =?utf-8?B?a1VrNHRmZ1lkTWtycDlnRW9jd0RFOTFXQWNKaVFtaU4zUGM0Zi9ZaFhwQmdm?=
 =?utf-8?B?bFJkMVFaaWZnZWIrd2llVGt2eGtjcklDb3lUazl4OWFxZDZQTkRsZDR4dU40?=
 =?utf-8?B?ZUZuSFM4b2RzelNicHpjc3pMcE5POVpEdFZJTTNyV2plVWRyOHRybnE3QWtD?=
 =?utf-8?B?UHJvUHR2N21vMExLQjlVNDdNSnJJbkN5UEVnME9tYU5nYklLdVYvQ1l4Y0s2?=
 =?utf-8?B?cElGVHh2YmlyUnhZNmZsZGhQeVl0SDcrRXpaQSthaTZBeFFsOXc4T2JYb21O?=
 =?utf-8?B?VEIwaEEwRld5SmxUeTkwbk1xNmpKNWdQYUhwbUpFYlNVZzhiSzh1dnh1Mzk1?=
 =?utf-8?B?bEZQMjZLczBXQ0UzaWFFMDRPSTdQWW1BZi9Xd285ZGZnWDdRQ0srM0NUcHd0?=
 =?utf-8?B?UFp4U21idkZvS0szbHhmV05pOE9qVmV5K2F3ajRJWHF6N3hrL1pZUFhSVmNQ?=
 =?utf-8?B?MGlJVDRJR0V0UHBrelpRVzVwUnhydzBzMnh0OSs4VXFNaDZoTzJ4cjNITHk4?=
 =?utf-8?B?V2FNYXBacUFmcmFBZmtORGorR01IZ0luWVAxTXVFd0ZhWXB4eCtyejEyalBq?=
 =?utf-8?B?VDJsdVk2ZlVMeStjRExDMUhocWVzOXZkcUY1a0I0R2pNcGhpWUIweFJCY2lZ?=
 =?utf-8?B?cnQ2SEtLekh3dUdMWklhblhtSzVqZDcwdSs2R1EySjBoQWE4Wnp0OFY1WUw0?=
 =?utf-8?B?UFgrbWFMSFRPbnNOM3pvK29Gb1pxbm1aL09WeUp1L0duaXJnZ3JxUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f209c058-e950-4be5-4703-08da25a54f15
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 03:48:35.5940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YHZ6hUIO+FHK65fgyHpwkDRwX5uP9jBHfuoz4jeYbUwEv9kZL4rAN1jowaeLpnF95nycai3xgfQkIcK7DiomcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2825
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/21/22 09:40, Jaehee Park wrote:
> Add a boilerplate test loop to run all tests in
> vrf_strict_mode_test.sh. Add a -t flag that allows a selected test to
> run.
>
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> ---

Thanks Jaehee.

CC, David Ahern

David, this might be an overkill for this test. But nonetheless a step 
towards bringing some uniformity in the tests.

next step is to ideally move this to a library to remove repeating this 
boilerplate loop in every test.


.../selftests/net/vrf_strict_mode_test.sh | 31 ++++++++++++++++++-

>   1 file changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> index 865d53c1781c..ca4379265706 100755
> --- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
> +++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> @@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
>   
>   PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
>   
> +TESTS="init testns mix"
> +
>   log_test()
>   {
>   	local rc=$1
> @@ -353,6 +355,23 @@ vrf_strict_mode_tests()
>   	vrf_strict_mode_tests_mix
>   }
>   
> +usage()
> +{
> +	cat <<EOF
> +usage: ${0##*/} OPTS
> +
> +	-t <test> Test(s) to run (default: all)
> +		  (options: $TESTS)
> +EOF
> +}
> +while getopts ":t:h" opt; do
> +	case $opt in
> +		t) TESTS=$OPTARG;;
> +		h) usage; exit 0;;
> +		*) usage; exit 1;;
> +	esac
> +done
> +
>   vrf_strict_mode_check_support()
>   {
>   	local nsname=$1
> @@ -391,7 +410,17 @@ fi
>   cleanup &> /dev/null
>   
>   setup
> -vrf_strict_mode_tests
> +for t in $TESTS
> +do
> +	case $t in
> +	vrf_strict_mode_tests_init|init) vrf_strict_mode_tests_init;;
> +	vrf_strict_mode_tests_testns|testns) vrf_strict_mode_tests_testns;;
> +	vrf_strict_mode_tests_mix|mix) vrf_strict_mode_tests_mix;;
> +
> +	help) echo "Test names: $TESTS"; exit 0;;
> +
> +	esac
> +done
>   cleanup
>   
>   print_log_test_results
