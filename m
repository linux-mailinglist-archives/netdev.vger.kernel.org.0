Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7DD50A362
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 16:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389511AbiDUO4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 10:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244846AbiDUO4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 10:56:06 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2060.outbound.protection.outlook.com [40.107.102.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4A42660
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 07:53:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wyl96KAPtkw1lE9ARaC1oy2cK7CTQyB7vyS86NxhWI4HsDZ5Jnq5wF5CmCCFqRjV1T+6uJpyk4Yx6pt37+oX4BeHmHLrXOT8lJEnqw5sTLV7Qj0f2j2n3fXxuxVjYSFOzF2tthRlRYAyMJLFGcRoZy6E+D5IpigUx9sbInOZCzZhqqUd3vW+MMCrM8MWXDFXrvj5UTp28WGJm/Uayx/Prny0NjvAMefVp+3ElTEuOPTgh77VFd7ypK//XBqI0n3ZxFc6WE9+I2EtMligcukEiBbW2vQR00CbxmEI2atL0ph53dRT6nz2my+pkpMldmcyzqwJ0FG+8cz33DV+P9oo6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7htWBNFQev1Ud+JTBALrqv3GprWbxT+xUy0wZgTlKQ=;
 b=Pi2bg2wfG4GS1jezBCgxZ5Fm/op0ROQsdAIKW9Ki8gmQK97deNao02ANDv5ORUcd8MhAqyr+pIAJvnQ9VryODrgYTlgGcUpQe7Yonpy0Y8Aotjb5cyu0xLGccOxf0ZiEGFtuwDglYBG1DnjQZCiyqURwPT+b5pDj3CffAhS1UqnYXdguucla86cBhtic6CylZBhL1L9+0p6SLeM9iS2833sX0I46304ykfJllgzYOgu3L/zAqcdGHcf8UFhuinA+u8FG6tG5Kv2nvePDOjDJUMZhCo/l5X5+nzrpnPccjf0NSrv8GWQb4N3dNJz1r7jvDAy7J6luBLpp+GIFEByaBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7htWBNFQev1Ud+JTBALrqv3GprWbxT+xUy0wZgTlKQ=;
 b=bulzQFlfLrf0a8aMSrP+1ojw04kzDHz+nItYdJqMfIf8aM6uajufv5Tpv8bNg3WisdImS5E5IphYEFSKGd0jZWYCcXpDNkUowm30bs1aYv6WBVNFSbWUnmDsMC+UgDP2XP45foqVV6X4FU9c0b0njccmtI9YVNlA/n9H6mncSdnOVao/uLho+xmnLV8YGFNx/sH7ERTpXF6A2z6PyPUNgn04TDwUqkxOF3Mo6zo3/IKXMdgUBvB5LnDQNIampcU42TzOZha/YwWN8X98UmOXN+3NgpWy2yKhUtpo+kleuhe2u+NIwPFtq8xKzwi2qgfAgmivJDi/oTD/aO5vfJ7JrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by DS7PR12MB5936.namprd12.prod.outlook.com (2603:10b6:8:7f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5164.20; Thu, 21 Apr 2022 14:53:15 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%8]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 14:53:15 +0000
Message-ID: <48a8fdde-edf7-4d6e-de61-9a2a9c88299c@nvidia.com>
Date:   Thu, 21 Apr 2022 07:53:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] [net-next] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
Content-Language: en-US
To:     Jaehee Park <jhpark1013@gmail.com>, outreachy@lists.linux.dev,
        Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org
References: <20220420044647.GA1288137@jaehee-ThinkPad-X1-Extreme>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220420044647.GA1288137@jaehee-ThinkPad-X1-Extreme>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::17) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: debd9d38-ebcf-4f4b-0ede-08da23a6aa60
X-MS-TrafficTypeDiagnostic: DS7PR12MB5936:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB593630CE65493FCA9A3B7980CBF49@DS7PR12MB5936.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9HyQdGHSR/T2MKg97qzVo/wAP3BfBrO8u2ZJQHbhLr20HyhXF+l4LbabounEAxoSTWTr6hHi6bc7xVWWd4A1K7rKbFGd32EqouqUjlHDsxsiZWcUnEketzSiZGb08riSd1GyGIk10hNwBEL/40eBA6mUhh2LF5QdkxXkOsfAWzQ3wLR9QLWrF47LPca+JRHny88381N/iI0S9Zd2nyPfZKsWkezuWkVjVmMQX/B/2fum97biB0qQYUlvq0qdjhXle1PVX6aNBfslmGrpRd1nNyLMTKRfG0ihMW3SUJCNx4q/gY2VCA7BUjeTNDhIPAW0GQGsHmGXILznJqwALFdWbG5hnr9RmxrxAgCuC11oiM/vMQglGyQYVM8Wae8Wyao+nCsIYsOjL3kQzCJsDDZR3tioNHRsF0jpgdJq4+Qbyzxs09y7+1EqE+2gtyyi/u6E8xvhiS8pvZCof09nPm04rVT93iZN9t2bE2AkZuSWzDNhMRCUqWDz6r0HzOgsDqO2ZkzTFE7+CRn/kLq60kN9sVkVWlW+MprCR8HpJPO42nG5VEBJncxXhg5Oce4t0Zsd7QMZS2BwMZ8wAx04PXw8viNs6B2n8mbepVnlgO4YXOl9m+TTmJKzKETIknh4DuMh1Ml4Y7VZHoBgKOD+pXaJY5afI1YcwXBElLsXVNpIiyYF1qYUrGJrwkaMrlJhPHyNZ6UPfTi1qujCgYE1+FnTj7/NSmdH2pvpTA14utDQxj4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(508600001)(2616005)(6512007)(186003)(26005)(6666004)(53546011)(31696002)(110136005)(36756003)(8936002)(86362001)(38100700002)(83380400001)(31686004)(6506007)(5660300002)(66476007)(66946007)(66556008)(8676002)(6486002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RStDcE9xVW82UFh6RVNMUVg0YVNlbmQwYUdYQS8zMjBaWUdKVWkrTnYrakZt?=
 =?utf-8?B?SjlmVGN0VXZvK25WL2hxS1B5UXRTVllpZzhiMkh4aGxrM2xMZVhZQldTOEdG?=
 =?utf-8?B?aVFqUmpPeW1JOFFuYjBaZVo2TVVHUGxSL281VTdMNlBqSEdwLzhxdldSWDlz?=
 =?utf-8?B?UVZjejJpTmZCOUdGZHpsb3NBYUN4MCsvbGI2Sk5hTTdsUU5ZQ3NWN21tcWhH?=
 =?utf-8?B?RTlpTERmOEIvR3oyRDM4MlQweVNFZ3J6dERScW0rVjczMGpTWXNkandSbDdU?=
 =?utf-8?B?ZXRHTUI4d1ZLL3VBcVVFQitDZzh6djBBd3RUbG54L2N5R1diNnZUc1BSeGlN?=
 =?utf-8?B?a3NkbDZaeVN0dUFEUnQzSVR1MDY1bE9GQmowYVZuRkRiMTRYN1RZTmlRT25N?=
 =?utf-8?B?TDJrbGJXcU1GN0dEQURPVXRGWFQ5ZHBBa1o3TEd1LzVRUmQyc0FFWXBQdU93?=
 =?utf-8?B?LzFlU2IyRi9XOWI5Q3NLL3FhUkZremVtaXQvRXR4NUowQTVEV0J1dVcrOERK?=
 =?utf-8?B?ejRORkxJOVFaSTZtRUZXZnFPRjl1WUNhUm1FYWkwVWhBVkFINVA2UXNFdWlv?=
 =?utf-8?B?bW1JcU1iU2lrSGcvc1Zza1Z4QmQ5YkR5SEttc20rdGV2L0ZDeFd2V2w2WURB?=
 =?utf-8?B?OUNCd3hndGpzbDF2d3B5K0grUkd6ZXVGalFPQU8wUlAybDBmUnJDY1FNdDhU?=
 =?utf-8?B?QUFSU25Ec204dG5WdGZtNVlORmQrSGloYnJFd1FVVWh5Z0NTU3h6YjhlNjlX?=
 =?utf-8?B?VllCUk5ITjlycFZRczhJeDBDZjhVMVpNNERlbkptbDA3UHF6cG84dXpiektj?=
 =?utf-8?B?ZXpURnlobHFTWjdyOTBraEkzK2hvMzRidHd1OTVITDdtYWt1WnVFTzN6azVj?=
 =?utf-8?B?SlZIc1JsbFIxdlEzLzJONzl6SFlvOTd0L1hRYWZtbk1aVHFNaXJwVUNkNGNJ?=
 =?utf-8?B?WkVmSktUZW1sMGpzTHd2MTVVSWtqSnF1aC9ldkxRc3JvOXBkL0pLN2dGOTlT?=
 =?utf-8?B?OGNrb3FkNkgvd29HSUpETFQrMjVzVnBkQ1BmY2xZQkdJT0lyNUR1djIzOHBX?=
 =?utf-8?B?WU85ak5sbERXQ3RSVElzZ1k0V3V3dHhIcURhWG13YkdONERobkRRbGN4ZVha?=
 =?utf-8?B?Y2o3RE10YUxjWE1aeFdDM3JicGw2bHBYRFpFeXdpc21CVEMxM3JFK3Vteldm?=
 =?utf-8?B?Y0h0bWUzbU5TZFpHNSs2WEN0aWpRcGJlKzQweUpaOGlHeHp3dmRzL2gyei9C?=
 =?utf-8?B?UllaOUFLeFh4MXJPUFJHaElLMjR4R25JRlVIQTVpVnUyODcvQTlPZU14bDVa?=
 =?utf-8?B?OXlnN3pSQnN3WDk4aE9ybk9Ha3JNN2pYc1NGQUFpTklnWXJEclEvcmpnTU95?=
 =?utf-8?B?U1VWRE9zalNab21SMWhVbThDa1grRUtaZVZsTTVWSTJ1SEpDOFVtRGRPNFY0?=
 =?utf-8?B?UHEyUDdtNWxpSnZLQi9jRW5vNWRuanYwanpwYWN5VVViUDZScm5NQ2k0aFNw?=
 =?utf-8?B?MC9JbUV5TWlpNlcvV0RxWTNLMW1vYk0rZVBZYlNHdjdSeGRpZ2gvMXp2SHJE?=
 =?utf-8?B?T3k4L2o1RWxoNEV4dDN3WVo3LzYwUW5yRVMwcTJsNlRLS0xzNk5oc2pvRG9l?=
 =?utf-8?B?THpxQXBVYnRKTUI5UlRPdmNwcTlmTUVSUkxFNis3OXd1cVFleCtWRUxBVWdC?=
 =?utf-8?B?dDE2SWszUXRrSFZpSE5RNFRQalF1dFpSUHlwRHVFckdGQ01VTkpEVGMwWTFM?=
 =?utf-8?B?eDRkeS96TGRHSkl6aGs5dS9TUWIyVFVUbUd3VDB1Z3ZySCtJRTRQT3RUdnFo?=
 =?utf-8?B?SHJHaXU3NDE4RTI3aFUzSW9HN01KTk9KZGFuTytHbmhtdGVrNzFHUlFVdDNH?=
 =?utf-8?B?TGpzZmhjZnMwNEMyQUpMeUVZelNUM2E2QkF4a3ZWcmp3OGVQUWlodFJxVk5D?=
 =?utf-8?B?dElXcldVRVRpWTJSeDdnU1orQ1ZuWUV5ZDlVeW8xV3FQYmJVSkNSS0h1Wk5m?=
 =?utf-8?B?TDdyTklQTmhPTjlOaDFlYmU1bWVhV24ybW9UeEV0RGVUQ2JlZXg5K25aTisz?=
 =?utf-8?B?QmRaU2RHM1hTVy9Kc25tSDloRW1hSzhQdUpiVHlYQ3hFZTZzZkFsWXFKYWhm?=
 =?utf-8?B?VDNBVDNiRkNPOGlsWjNsNVV5TTRabEpNOU1EMENaTitXUlhsa0dYWHVmaW9z?=
 =?utf-8?B?WHZIU0dYZ0dCU05VRElqcnAyVlZyWGRSN2pwbzhJOWk3OWMzR24vNEk1MnJB?=
 =?utf-8?B?WkJxTHdyYlNVY0JYd21lZGlrYVphWTlpVlgra0huTlpEaHhNaVdKWFFQM3Uw?=
 =?utf-8?B?UVA0Vm82dzZVa1R4VW80aEFWOE1CcFJnU3liVmdKcTd0T1U1em9tQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: debd9d38-ebcf-4f4b-0ede-08da23a6aa60
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 14:53:15.7717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbZKMeo+VWtQUauu1JAh6QXCHZnqu8QsREcgzMAFDXWbVaXq6xwMg9mJiAfCO3tMcm7CRGTKvYnLoHuJX5kzuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5936
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/19/22 21:46, Jaehee Park wrote:
> Add a boilerplate test loop to run all tests in
> vrf_strict_mode_test.sh.
>
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> ---

pls ignore this, duplicate patch


>   .../testing/selftests/net/vrf_strict_mode_test.sh  | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> index 865d53c1781c..116ca43381b5 100755
> --- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
> +++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> @@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
>   
>   PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
>   
> +TESTS="vrf_strict_mode_tests_init vrf_strict_mode_tests_testns vrf_strict_mode_tests_mix"
> +
>   log_test()
>   {
>   	local rc=$1
> @@ -391,7 +393,17 @@ fi
>   cleanup &> /dev/null
>   
>   setup
> -vrf_strict_mode_tests
> +for t in $TESTS
> +do
> +	case $t in
> +	vrf_strict_mode_tests_init|vrf_strict_mode_init) vrf_strict_mode_tests_init;;
> +	vrf_strict_mode_tests_testns|vrf_strict_mode_testns) vrf_strict_mode_tests_testns;;
> +	vrf_strict_mode_tests_mix|vrf_strict_mode_mix) vrf_strict_mode_tests_mix;;
> +
> +	help) echo "Test names: $TESTS"; exit 0;;
> +
> +	esac
> +done
>   cleanup
>   
>   print_log_test_results
