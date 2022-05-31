Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3950B5399A0
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 00:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348374AbiEaWn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 18:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346421AbiEaWn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 18:43:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2821D4EDE6;
        Tue, 31 May 2022 15:43:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YC1ctcfAS1vJGzueopuWBzympkrLFxGgbsDcAhF8GSIBhZCLUFnkoGCy5szVGGFQI4DzuTgn3S9kH8ug23e+//R730B0UeYlSLI05ha0H0jQuIoeqbsCqj9grl6wjwHUV+xH3vE01V/SKo7Y4gVq7FPmWgtUJFbgTYKUN7vL6eYQuJZza38LR5IfNN5kR2aBQyt5bbzooKK2AlxDK3jD1UfC/DZqLCUpp47A8Ne9tGPtn6bhAZh/SDqZ7vLUetn+UyfkpctjNxwY02BlprhD1Q7Q+RBo6Y1WkKzJtcYvVV+BfKaapmXaNxWsvazVtgvw1XyxruUv7H1gFWveCkTUXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1X9AUzS97e9fNJsgLJUD4L8MV0lHNAZEOonsu/z52Vc=;
 b=gALgOccl17JkCk+iiZDUyVgOkcgE2KfVER1QzDPmm5Mt/zt/5AsL8rvooKa2xQsroi4ThdTEZjW5OsxRPLDMvwNEt6NNFLjSn9ALcOs5zGOXlY8Zhe5nbaZhOR/Uv7J+yLIveqXDNDoJzdzKYBScH3fknVysEyCQXYUhTbhN5O8wyFo2KeSfJxRr4HHyx1rmUqCpwVf6zn1cuxyD451yHBS3pddbuul2v+IWUQ+Ss6HWHiI5h9rQIyEM+gPGLKBNgmPVLADVuJFOA4AKHawAUk4PbjmFMJDJ/SdQWRbuRgtVNhUPcW3rxo9246eULGrc2Ekg48j7UZAx2z+DfBMpcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1X9AUzS97e9fNJsgLJUD4L8MV0lHNAZEOonsu/z52Vc=;
 b=oUGTqQHjHa6eiJ6mye15pS85jTahx+0KrOADUkKXwxux0WHFbQ45UCNIZKm0Oh/us3QsMzFB2LUotiwz+FZJY7+tpGSCJhrzcHw3y1B27qameYKw2amyIPfVqIuELy0wsR9WQgsQk+NPsh759slkaKwrY6XHDuvS/QoyTx7ReULgcVJ1oD0lTGxNjA9GiIF+QGgmQq4qUyFEO6DR6nXMxnDE9P2wjYcBZzIggNOzqmlmq0NNRdJ6zKuFlBGHAydMqibtevv6p7/8mt2b5KFbkWxPrfzqoeUsF0g5MhuiCJiNbiVu7OrR9ienyY0N/OK+7q37lvd+/abDKaCbPrGF4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by BL0PR12MB4740.namprd12.prod.outlook.com (2603:10b6:208:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 31 May
 2022 22:43:53 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::ede1:a4f9:5bf5:c3a0]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::ede1:a4f9:5bf5:c3a0%4]) with mapi id 15.20.5314.012; Tue, 31 May 2022
 22:43:53 +0000
Message-ID: <928114e2-05c4-3cfe-7a9e-05ae89f18807@nvidia.com>
Date:   Tue, 31 May 2022 15:43:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] selftests: net: fib_rule_tests: add support to
 run individual tests
Content-Language: en-US
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220530181242.8487-1-eng.alaamohamedsoliman.am@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220530181242.8487-1-eng.alaamohamedsoliman.am@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0043.prod.exchangelabs.com (2603:10b6:a03:94::20)
 To SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6fdab5a-b02e-4457-a3ca-08da435709cb
X-MS-TrafficTypeDiagnostic: BL0PR12MB4740:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB47408EE4AC22BCE27E2E16D7CBDC9@BL0PR12MB4740.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aGBpIt4jcgSlxy+cV5tTXmdE8Ama66lg6GOBsm52X2em9BhqFtberHgGBdQfCndAPOAvtBX18n/TxaZXUpaGJWG7fAZUXzyJM09aNb84n/6aF11Uff3xju0vnCQnzkrQGHCI/LeAVDf7Pcv9bK2RKlMxQDZdq+KBX8MTZ6ON7dgNuJAnGcGPBZ5feE52X3bkR8gy6oO4cxj0oTa9N8yZbgxAQjL5Iu+bbLgEBmZmXgc6EhQCUdKL4pa7MTun82dfcBR5AsR+EN0NuLKO1zbKXp3Gf5XBtkHUhMUKdfoGeaKafdhzJlKIO4h28cNW4A+sDB58Vj/E+FuiqSg2vEEWgL5msmtEfe/Jr7O/jB2+k6Agjmqwlhz71wQuEIIVCaskYaCUkRYjIQv/lUPjwu2CBRoTlBU7bDJKO/xKqb2bfEg0JQ5X26Ed0OaJJfYHspnIgl5VIXA7E9Zdqx2QNUbSeVxOpB2xCArRWOryJHk4GpCnuBWpYwt2KZRyLE3WCJBwXrs2Pr3+p+70DlyUEkVYGROhqp/kxinZ/ghb5YgmX4mlHjdKOAwuWvCHX29HeuhIxqLlSzTJvFas1EZJETSWNnIOuNTPkAPFRtFcOdz0uvEBMQ4TNXj7nD6ghRhkAPZV2IpZxVGJGnBuWkxNEg9Ms5x8su+PP1Hz2+hAX99knCNmVWoRFOu959OtgwctvEvkZKiEgtAf5KEBl/9dljs7FVmG4cZRBUgluxgGyXCgmNvuWJIi35cvt0Jd2MZAASlr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38100700002)(31686004)(36756003)(66946007)(4326008)(66556008)(66476007)(8676002)(316002)(6506007)(53546011)(508600001)(6512007)(2906002)(26005)(86362001)(8936002)(31696002)(2616005)(5660300002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnNqNGdFdlZkcDQyV25IVzJaK3p6eGRTNTlUQnd2Mm5BeDB0U2hQOEVVdVlr?=
 =?utf-8?B?K1g2N3R0cWVERTlSVjlNdm9CM0R1cmtFWk8rSkN3U0YyaEgvbndiWmlFNGFD?=
 =?utf-8?B?Nmh0ZUlNYmk0a2gvbVRjaTJiMFhmb2hHZU9wUmpiRW5ldVFUbjJXSkE5RmNN?=
 =?utf-8?B?aitUdlJ1bjVLMWR0d2RlTEpJT04zUkFOVEZVNTQxN0ZkRjcrbjNZNGJVNnhs?=
 =?utf-8?B?VG5JallYcWM5NXpzYStpTGVJbEpUVnovUVRSczYwTmNieWVFMTIyTUVIdVFH?=
 =?utf-8?B?ZlJKV2RraTYyRGlpRWtDRkNIOHNIQ1lkV01vQVJ6VHlBWXlRblVidjVSc2xq?=
 =?utf-8?B?cFlmdlMyajcybWVIQ01FQ01tOTg2Q28rUmZ4V29TY01hYTA5ME5vVVY0a1ps?=
 =?utf-8?B?NUtDdHkrUjhmYWFTRUdGTWxXZ2FWd1RqK1UrMmpueTdRNktUOFdwU21LZTZL?=
 =?utf-8?B?aFYxR1ZnZzNyUjJvZGJ5U0JuaU9ZY2VmcTFVSmtJZWRzRE1JTDI5STBTamh0?=
 =?utf-8?B?Q3kwL0FhY3BYV1BvbXI0RHJXc3E5ZmpuMzRxcGpjVk1kcS9RTldvSE9PZ0hP?=
 =?utf-8?B?V0FQblRaQ3FSSjEvcWRjM1BEdlcvSFp6U1NaNlpxZmhtVVNWcUh4dGxWcUFX?=
 =?utf-8?B?a0RIWWZCM2JVcFA1emFpOGkyL2NOWnNua0JEVGs0alM3TzE4VHZuczlJZERw?=
 =?utf-8?B?OCtScUhMR2t5alBUZG1XZ01jV3RCbkNSRWJwbU45dmNoWitzbGl0SmkwTlVU?=
 =?utf-8?B?a3lIVmpIbjF5UTJ0VG8zTzF1bGNha3NNM3ZsUmorSGExZDlwTVhhQ3NDRjh5?=
 =?utf-8?B?VzZ6MmREb1ErYWdKWTVwWFlneHVHZnVoL2lZMjZyZDE4eUFRRERveFZ0WHds?=
 =?utf-8?B?MStvTzRUZHlBZ0pramNFWWJqd2FBaktxNjk3ZWIzUForRGlPOHdHSVlrZkFq?=
 =?utf-8?B?bjk1S3N5czNYSlcxamZ5U3hzMmhrSktPeTNVUTRxUllMT01ZV1lScFhxbTBI?=
 =?utf-8?B?ZE5TanZ4RE1yU3BmM0Zuem01RW05cVZXS2Q5aG51TDJSaWV4T0xMNlNTTGZ6?=
 =?utf-8?B?Z0NSczBOSGllK0FJSmFBczUweThrT2ZDdXI5K2NSRWUrSlNlRWRWbldOK2I2?=
 =?utf-8?B?RnJ6UityYmIzOVp2TnBZNUFxamEwYTlsYkxvZ1UydDN0MllkdnpCZ293WlhJ?=
 =?utf-8?B?VDdSamZCRkpmSCtyVFV3Tld4QmhYY2N5My9iMEV0UzNFQXkvTzdhRHpvRnRQ?=
 =?utf-8?B?Sm1FTEt4RWpXRE1Jc05SbmFjTUhPckVZRkpVRW1OOFpJT1JDVXJ5ekE3NjNm?=
 =?utf-8?B?b2p2TU1HSS9paTcvUWtpNW9wcWE3TEdhK2JUUW4xV1NNQzBSTUtLbytHYU5i?=
 =?utf-8?B?TFUxdVV3YUNoSlNLK2hrMzBYYkJnYmZRNmM5dUsrbDYzbjI1UlowQUN0SWZG?=
 =?utf-8?B?ejdzZlNCeGlKVUJKSGJkUCtmcTZLSDk5bi9aaEprNVdhRGZjYTA2cXE5Vnln?=
 =?utf-8?B?V0NUMys3L1VON2hzQm11NWUvanFROEFFQ1oybktsQ0VvQnVVeEdFUXRReXJm?=
 =?utf-8?B?d3ZvQkxaTlJjUUhIWkRKajdCYmZVeHBSNk5tMUpwNCt3Rm83ZStJSTE0cTZo?=
 =?utf-8?B?U000TVlxaWxmK1FKRC9uSW9Yc2FQVE5NaVpqR212QXZHWldTazVJeXBNRFdB?=
 =?utf-8?B?eWRuR3o4VVZNc0pIOVJIOUNBTTlNL1BqeWNVSFdnR0Z0TkQyUWszQnAwNDU4?=
 =?utf-8?B?WE81ZkJ3Y3FHZndqcmJpSUI3aE5mNGovc2prV0N1RmhSTDVGUWxlT1lrRTFD?=
 =?utf-8?B?NkNubGpIWFk0NlJGdFdRa250aG1pUlExcUdGdldUS1ozUEp3NHFLQUZnSXRq?=
 =?utf-8?B?Qm5SKzhCRnEvQlZuNTR4K1NrYkJnVWwxTnZId3drREJrbFViSW42YjVwaXVR?=
 =?utf-8?B?Z0F2cWpTRjVXYVRVOFhQRWNOcWpoNnZKaEcwM3NIdjlkZjJvaEt5Z09QVUtE?=
 =?utf-8?B?K1FIbVlEV0JjMjVnNkhvQUtzMUZRN0VOQ1NQaU9BZXE0ODhkb0tQQWhuL0VM?=
 =?utf-8?B?V0xyUm84QTN0ajg0ZzRZa2kwYjg1UnhxaVo0RjhMbmhEWGExcDVveGZkR29Z?=
 =?utf-8?B?bm9xaUJFSnBwRmdsSEVDNkFHQVdPVVJOczUwM0x6U3lFaU5HS2ErY1I3cGdl?=
 =?utf-8?B?UGZ5K2lYTkJRbjBQaE1UbS9qNG1rWW1heUdtcDR6RExZMmhFV1BHSW1kWnlh?=
 =?utf-8?B?TjVOMlZRQm1oY01MeFdWRVlnb2xFT1Ntb0UwZnN1a3J1bmx6RXNUODB5azVq?=
 =?utf-8?B?ckhHbytMOVhpZWRrWmZVaDlUQ3FNaWNoQmo0eVhPb1RQVWxCbWRRQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fdab5a-b02e-4457-a3ca-08da435709cb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 22:43:53.3321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MTgXqvs8N6WWkUMtTzG8/34Lwrg8fwDsn+VQYduv0bA+IGfAEfMqa7wU9+EJ0kgczl/CC4wPwv41A7441FFw3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4740
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/30/22 11:12, Alaa Mohamed wrote:
> add -t option to run individual tests in the test with -t option
>
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> ---

Alaa, I suggest you send a v2 with a fixes tag for this. This actually 
completes commit "816cda9ae531" which went in incomplete.

For examples of fixes tag, look for "Fixes" in git log. change the patch 
title to convey the fix.

rest looks good.



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
