Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108F150A364
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 16:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384005AbiDUOzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 10:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244846AbiDUOzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 10:55:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121CDF2E
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 07:52:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bD+ni3kUgQZAsdgHG/Qz7CiDNPm5On3qOXWkOnrnmVEFkeq286OYLaS8TqaCY4VATb1CvnJmjnJ2VVibxgoXcWjxCpXQ8HRPNIiSaYqq02uUNkeUw7TCZ7C3zQS5K7W6znwhFbL9fagKWtGuvrv3dZvl9t6JnRdLFJFUwIOWvhKPiGk4SumUx4lXm4B2OXgUntkuDBZ628+YbmNeNhFPdX/WeRLfibFxtgShasjuFMd3MHR+M87YTcncKbGOrZfc+Ttku2MV6eJz5srqwlaahXLCviB6sW1/Swu7wuJ3gUub6e4+XZrkmKU0Irm2H6pAUZAbfozYUWxptnlSTDnjIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9C3DI21iXKrTIHYYRnIffg/Gu++5aoD31cJL/CGLXE=;
 b=dXCXfGE4NqHUlPKR3QJyc9zCBD9e8h/XezzUjHfn5M63ZYuhySPBhJEppAwQxFLfdpyDQixjere5T2izutmya9SaJUBBjP7rVtRB26LLDzLs7pK1idzgcj/QjSbZfRxNIi4tLpmELZ7sONnTtR1NpRi/eiRQtZoylkSRuVvgsQFYicVjVRT3NSCPek6u1P/u896Z1Hh3KsB9nPkVz/inQH7wZ7TQ9ElfDkhmW46cddIiezLvYnQjQB5NxIaWCBt7xvuXaRcAXB37pa+VFBwplLo64lO2MQ4udPpcFRmDvkeg4u46LVdXjZwrfLdvfLEYMoAK0vhVigGhjycXJ1UOSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9C3DI21iXKrTIHYYRnIffg/Gu++5aoD31cJL/CGLXE=;
 b=icTreDM2F+m540lZK75G6XQ2SdHRMgp5O6MT/USbGUDwhHu892klx5G4OEubPJdWawxdGxsmCU37EdrlQs5fnwvnFgYCLCTLbUPnSyhjt898z01d2lwFt9W46y8yIw6grJyDIj5S1OjfJg2JEjpoMcY8jcT3QqDaRgQCb0pEOuC7i7aTRaOwgIvaMwsLvUnaOx7LEyOXiLW5PbupuK67CtMBgy9Jrm1PAopwVHVz+IC038KrO2dnnoimIRNUwH/RkyuM3ssmh9DunYg6eF8PWAy/QLlZXvV35NYjq9Is01aTpdHqKh7lgpi489gmlJRyxEqVeTdbMW38K9VG2H3OIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by BYAPR12MB3318.namprd12.prod.outlook.com (2603:10b6:a03:df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 21 Apr
 2022 14:52:49 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%8]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 14:52:49 +0000
Message-ID: <41a48002-817b-4366-d316-9d94e8d81a79@nvidia.com>
Date:   Thu, 21 Apr 2022 07:52:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
Content-Language: en-US
To:     Jaehee Park <jhpark1013@gmail.com>, outreachy@lists.linux.dev,
        Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org
References: <20220420045512.GA1289782@jaehee-ThinkPad-X1-Extreme>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220420045512.GA1289782@jaehee-ThinkPad-X1-Extreme>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0da22ae-b13a-4884-f13c-08da23a69a73
X-MS-TrafficTypeDiagnostic: BYAPR12MB3318:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB331892DEE055E712DBA46D82CBF49@BYAPR12MB3318.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qvcxaQ2KHFkqKuqJTZIrZzHg+ivtIUBksnvzXhvtrx7h0QHmagsU3EX7Y+vkakzVCQRx0AZpe29MTBK+P5wOg18TXkdosreysZNot+gNvMIOLopalCF8jN65Ygmo8v4nqBKB0Bv1vQG+CyJU8OKUADYxJCtOCIJn2YVtTrZxjrZC910XQngpzY48RrR5VHbPw/JGStjmjZfsmk1WxzD2rtgVz/zLDFdjRGv8ug4w3oZmaknRyROCoJukshVCDLWUa0xYFZtg5PKWR4T4WIpcJI39Xepeglu3TsLxdcKs6U64A/A3pT684ew4b6RyWaWxClnEw707qSR9RfRPLXhX6Hdlr571izUqx7d/whE5YOhfJWuVcASyo/fZwRt+a9xyN5kM8dQUT3bNw9opTzdSivZorsLfeKYxp0QF0zVnE0pyZrizp9q4M90QPUTLjw1DtuoTrxF3qd4KW48hG2oWYD5IqQFSChyPmKvsVHpJxTGsHRKS3wRDNpriQP6pqvrHMZ1attpva+z8b9jPOmIYqYRsji+t2WCAVXnVsCRWrQpOshDXzaF4BN/2+XaTxGcv+D5EBkRs4PMLNSt57hAzs7MynG+otzbGsnooGic4qP/p3o5BScT3I0xxRNQBEbsmuw9vZc4oHCefB0R1J74buuPwRxN45coiYY60DWGAZUAlDTfhK6yGqI6GmHr6Z3V3WTBNhWmx2pJHAYaggb0hfjC4vNl3bbGLNwsLqgC210I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(316002)(508600001)(38100700002)(110136005)(36756003)(2906002)(6506007)(66946007)(66556008)(186003)(8676002)(83380400001)(66476007)(8936002)(86362001)(6666004)(26005)(31696002)(5660300002)(2616005)(53546011)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OW1SOEp2QzI1aWFJMjZaT0NzdStuL1hqQnVuSytrR21vNHFtSEJ5QXQ4MUNy?=
 =?utf-8?B?TUJZeVA1YVZKam4vaElmT2pKbytRVklQenhQM1RwRGxJQWNiQnVEckhGaDVB?=
 =?utf-8?B?azg5ZENzekJXRzQvWHhiUW5PSys0cFVuSzQySXpqdDZFRzhYK3FjYk5DRGl5?=
 =?utf-8?B?TTIvQ09kYU8zVXhRbFFTTk5oN2c3ZGRKVjNTbHJuOHhXdUtWZEVmazBxV3or?=
 =?utf-8?B?WndQS2E4eEpQZExVQTVRM3FieUVCYzhrb09GUFh4VEtjSjRkTkZxTDFoMko5?=
 =?utf-8?B?WFZUVXJhOS90SlEzeVZjWjd5UWxWR2Y3cDZFV2I2V0NpbXVQaHBvdmEwRExN?=
 =?utf-8?B?ZlhxV3JkbjhHTXpYTng5VlRTZXRxTUdVOFJLMkNDbUZrajlIQTFBWGtTNHho?=
 =?utf-8?B?bXRvQlF5R25VUndMZkZmTy81R2piTG83WVJTMXc2NC9SOTVTR3JLb1ZTV3N6?=
 =?utf-8?B?MmZTeEdtR0dkMFp2UlY4SFA5ZWtmMXlEVU1QVE1xR0pyU1ZpS1crY2V0N1FP?=
 =?utf-8?B?Nit2c0xSYkNDNW1seXZVWmpjZXNuVTd0enZoRFRuTEtKazF1WkJORjdBN3J6?=
 =?utf-8?B?ZzFENzBaRzhnRmg0UElrT2IzTWlyZzQ1OFVUc25oMExCcC9QRXhXandiNlE4?=
 =?utf-8?B?OHRJWVRWL3hXbWRxYWcvQnVDeGRWUmR0N2hoZVIva29uRmx4dnhqMFE1YUtX?=
 =?utf-8?B?aWk2WHp2UjgydUVmbUZxWEFLc1lxMEhYMWdVWW5ZNzUrQmFyV1A3c0E3OWtn?=
 =?utf-8?B?ZnI2ZklmZXBwQmhLMFJwRUJjSmNnTVJYMFpnU1lxWjdPeEZsQnlkRmlrRVNJ?=
 =?utf-8?B?V2Q5MWJHeWVwb2tHTHFyNWM5UlFmK0ZBczA3TFY0cUQ0VllxZjlqdmZvbHlV?=
 =?utf-8?B?VlpiMDVCdWxCZm4rcnAwdjN2Z3RBemluNVQ3RDh2eTltU0ZtanNlb3dCVUVJ?=
 =?utf-8?B?RHkwTzZxWTNyc3dLRGUxb2lLbmdYbFF1K0ZkWlp4Qkc3eUNCUWlkMksvYXp6?=
 =?utf-8?B?ZVhZbTE5LzdTV0NqRzB2K3VUbSs3UG5DSnprU1ErOVFZMTJEbzFob1R3TEYx?=
 =?utf-8?B?QlNxVTFJQnJiSUdUdEFpNU81M21lT3dyUml1Nnp3ZG92ZWZFaVZDb3BmNVRR?=
 =?utf-8?B?VnZyRWhpOXovRnJRREFCWDUwajBiVUNKQmh4b3BvWU9RcVNINmgyNDlpSGho?=
 =?utf-8?B?TmxoZ3NBMlB2Si9uN2tyTzE1Z2pqY255VXA3T2dhbGVVNXY2dDl4OGJSNjJE?=
 =?utf-8?B?bThJZG5sbHExSURpeXN6aitsZXZOY3ZLTEROWXRVUDV0TzNsL2RWaW1JWlRo?=
 =?utf-8?B?UU9CL3NGTitweHdSM1VEbWlJRVBIRU1sTncxclZCVXhmQjl2Y2NmSEl2NFQ1?=
 =?utf-8?B?L0M5aVJqU2w5Z0t5TWZxUEo2UFRBVWpzV3IvNTZRYTZKL3pVN2dxUERxc0hC?=
 =?utf-8?B?NFVZQ1NVdDJxNE1LU0hTQTFwRW9Sd1hUQ2tVTWtEb0JjdGNUTVFaTHFmSUVp?=
 =?utf-8?B?QTNtZ2sxK2xCajJxSWQvdnlqTXdyNEFmYWtKOXRoWGViNko0R25WcTFCSUYw?=
 =?utf-8?B?TXdLQ1l4a2h3eFMwQjNVUmRndkg3d1RXejAzMFlmcmRrb1BTK3BISE5ZR2Q2?=
 =?utf-8?B?QmV3OFl6TlJ1Y3duMHZ5Z3RNRmpXSmUzM0k3SXJhRWg3bEJ2bk1NYU1CTGZk?=
 =?utf-8?B?eWpaMUdZc1EzKzRCWFk3emp5TmdrVjVRTUQwdjU0Z1NETWt0M3ZmSng4NHNP?=
 =?utf-8?B?Sk0yRTBzcCtNT05JckIyYlhsRWNUbk1IK3lrR3hleVZuSmpjeXI3aUJNZGho?=
 =?utf-8?B?L0hpMVRTdEg2b3lkSVFHa1JiL0RWVnVyQW52M1JwMlM5dnVuUkZ4NFFadUR3?=
 =?utf-8?B?c0VBOUo2Y294UXlBclhEdURWRFBGTUk2OHhDQWNmeWtDV2NhUkdzZ2EvMlhO?=
 =?utf-8?B?cm1tVEFjc09hOTBXV0owempIa0FFcU1zSW1BNVFiMW9DblBuQnFSTEpJcXFz?=
 =?utf-8?B?ZkJBNEh0Y3BzeVB0M04xUklmODhTak40d1FFdmV6WWlLMEwzeEV0OFlkTm5S?=
 =?utf-8?B?QWJUSDZoRmJlV21yYTNSRTVOcHBFQThDcGRucWxLZW44Z3dtOEFnUFpQZHNw?=
 =?utf-8?B?N1poSzhCaGF1WmFqTVpEZTVDRXN0V2NFd0FydkVRYkltU0xYR0pNaHdNVDMw?=
 =?utf-8?B?anozMXVZTXlSVm9hK1NZT1g0cmRDVVgzQXVia0JNaExzVDRqQkpidjFnb0Yy?=
 =?utf-8?B?SmtVVm9tK3EwNW8vdFJrUWQxMVdVSC9aRWRGaXQ5U3pCQ24wb09ES1dpb08x?=
 =?utf-8?B?Wmd0VmpNSTZkUVN0WlVLMU5HWk5ScVhWNlBmTXg5SUN6c0liaWVrQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0da22ae-b13a-4884-f13c-08da23a69a73
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 14:52:49.0897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FiEO7e7y21YmRO2es6thER0l14vRsbIxakYRU3wd12sOn5W4vx6z9bGTYM1Q03swF9HJuQkAA5KOtuje8ESzXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3318
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/19/22 21:55, Jaehee Park wrote:
> Add a boilerplate test loop to run all tests in
> vrf_strict_mode_test.sh.
>
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> ---

Jaehee, this needs more work. The idea is to be able to run individual 
tests with -t option.

An example is drop_monitor_tests.sh, see the usage and getopts arg 
parsing at the beginning of the test

eg ./drop_monitor_tests.sh -t <testname>


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
