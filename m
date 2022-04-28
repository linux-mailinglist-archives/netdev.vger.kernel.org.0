Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DE7513ED4
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351683AbiD1XGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiD1XGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:06:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C038C4038
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:03:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeW2BpgrfR+pxl2XrAX7d+6Wq57hOsVRt1qAHfWAzlGNyle7EIsm+Ay6qVQCsB4J0Z+utOX82Y8Xc8O5iHUJ5ZMdHPhIasX5NfDmP5/37KklfeaRS5hL6OnMH4D/vgXsOy7/sBHZEQFjn2cogcTtc7lBFa5uOCaZMQvF4MCNX+/uTyyg50d4t3BRnU7h/nQ5vbMgFfqvXHOirICigJ84j+xA3PI6RSn0x/Y4spec6RempO2LxNnvTK5cv3dPocrfrNRqJTQQSH5mcZdlrt1YmyAT6vTvKUvJ+EZ5Oe8K1WDJhGM5hivmRzEBQSvVH+JlYs7IK7XCwWQJbPc9sZgaUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1Rt1a91twDjAIxCBJqs13/lM7BFCZ6wi2672AYjGOs=;
 b=Ul7Vj2XhlG9vtBrw/id+r++dmUkFCf6u/LhzbmXnyDaKdXGFBamGZlxPjhQ8PXJTyzM7z99xj/fXefZ4YAklLwDalHqOCGA/A17UFqExCvUlgus5GK+dx1CbxXCv4joxyO0zZrhpMumkJ35jb/Ndw7/efYSUWAapsFMRHGzHC1rXVnjeIdkLJX4VuNoxCxjWk9rECIDyZTki6b3ZgeXSZ/L0UZqzpUsJGpd4B555IMOxvS+MKffcKeNOuIOhpnjhpIyfeNYXa+A8cxr9C8NaXKsNBtBxKKwmqur7H71VCSqK54hbDRyWEs1WpPHIpYqxxBWJHfuS+5cY0hgGMIlWfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1Rt1a91twDjAIxCBJqs13/lM7BFCZ6wi2672AYjGOs=;
 b=jkLAP1w5kLtAvpDYcKNyV/T776CnYlyWwnowEF4HgY144NXrxCGTXDJv0Vldun2Dm/pMVqVmMmErW25WHdjb5Eb/GzokN/YCAODBdDHQpoIKvRHxT+N8wtLokF6fOy1pC8FWRQnM0DPoHw4259jwQKX/YLqdSMuNg3w/oyMI1cfUZpecOTbhZnlNxo4f2cqI4EOVW3QPqGHftgLx47svdU1OrtRc+PXMTaJDnJu6nUOETe0krcHaMw9cdUHFMLvZrNQ4zcdb9lS9EAXcm3KoHvezvomHmnYM0dH23GDZDLBIGLwPqnd3i8T7Utvf1aVDRX2SwTY/gSt5cB2Aaz+9qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by BN8PR12MB3298.namprd12.prod.outlook.com (2603:10b6:408:69::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 23:02:59 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%8]) with mapi id 15.20.5206.014; Thu, 28 Apr 2022
 23:02:59 +0000
Message-ID: <cf8ae870-8208-b4eb-fbaa-c81be95df05d@nvidia.com>
Date:   Thu, 28 Apr 2022 16:02:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v3] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
Content-Language: en-US
To:     Jaehee Park <jhpark1013@gmail.com>, outreachy@lists.linux.dev,
        Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
References: <20220428164831.GA577338@jaehee-ThinkPad-X1-Extreme>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220428164831.GA577338@jaehee-ThinkPad-X1-Extreme>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::25) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bbe8309-e9b2-4f8a-fd55-08da296b3d06
X-MS-TrafficTypeDiagnostic: BN8PR12MB3298:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB32985FBF77AA8C53A5BBA80FCBFD9@BN8PR12MB3298.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eCdQvr/hddRddecT2AH0TmW5lpn7cNfKqJ2bvHZmpDxQxOde+t+lMTBzqkZvtEjyvLXFYU7MBitcdzsUb3s6S7w84NzUKtCQ7QHQBEvq6FzjoGFByj8acrkBzwLfePFvrZb/wEOH2GQ6tFvZaAImTok4l+KTyGBVD7YRdiO3wrOgiscYY7HvtaAkd1ZF4YrwdPrTY6ge6lPwnFb8u9/uSx2q235ShBKdqYwKCByzamYWlpQ65UHuygawpn1XJUTMI3mtHXTi4WHhen1jG3CJhHTPWPlOFEzjv1Dq+yCJIYf5YhbrEEwiIMv+ER2kgUm/PAJycFcrOOz3z9t7HrQ5tX4Ig30Y9rHsQIFA7DPEHDs3ny7jjIfkNhBettv3hjF1za3sPCrzS1U5yIE9PMAluxkHUWSO8jewe9PkHXp4X3WUQIA1fZzNOH78Pdg22qDREmUKkk7twdGCadWQXrYE2esGuruD4EWKqlucHZ1Faww+q5n3iZZVWm2vzmo1j7uu/afY/CL2blCq6J/OoDTSw0mm86CwNCn3FH94SgKx2q6S1Au+Luv0YvTW1qO4zxrp0vfM/gWpRajcXnWIdk86DLlEex6PRa8en3pZQI0xClclfIPfGWBOGUKo2bdhQKZ46+hSRlHPJp3CIx2Tm7shrb96CZijMsMlo8NZr97aUX50k5hkxdDc8cBZZOg51FTsH8ibNTvGzqBnvwN5rlzKkOSZ0HPf8u3sZBZO/3HLLlM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(316002)(110136005)(8936002)(53546011)(6512007)(26005)(5660300002)(6506007)(31696002)(6666004)(508600001)(86362001)(8676002)(66476007)(66946007)(66556008)(38100700002)(36756003)(186003)(2616005)(83380400001)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXNjbGZPSDk5V2RrdUo3Z3Y5azR4UzZZMURKWUVFbnZxa2tvTzl2bDFQN3BV?=
 =?utf-8?B?OWltVVdLQXJmckpOQ3B5VXRSTm1HaUttWi9ZRHZsa0tVbTYvcmFJakZubytG?=
 =?utf-8?B?cmhzTm52VXNzbGhRc0Jja3pBN0RLZUozcEZGblkxZDZ5TnlYUVZTVGEyTnpS?=
 =?utf-8?B?ZlFCWGt5ZUx5bVFMMjF5V0N1SVZ5Q1ZINVVtTW54UC9UKzNxTmwzbHU0TUc3?=
 =?utf-8?B?Mzd5bTVkaFBBRzlpTHc4WExxNFROcDlQODlGNForRUhjSUx1SkRMcUN0dlJV?=
 =?utf-8?B?Y3BXdi9hZ1hCSVBMeWZIUHNVYTlYbXJmOGhCRGxGNFVJVGd6TUY2MTV0bWkr?=
 =?utf-8?B?V3RBTFZ4Vm5vVExLTnlzSGMxMktKditOcUlldDdFRzh3eXprNGwyWEt5eGRY?=
 =?utf-8?B?SmNnNmpQRXQ1aTJKd01yeHBuOEZkeE5lcUtWV2NlWXZVTGRsdEFXMnZ0RG5m?=
 =?utf-8?B?dDN3aXg1eklMS3RNOVJTbXd3QzhCNm5uODl1aHZZU05NbENLY29Wamc1cXRF?=
 =?utf-8?B?RllqYWd5S0EreU5vQUZTenBOT0FFVDlIRGNOQllJN01ENDlFSnVaT3pjWk1O?=
 =?utf-8?B?VjFLTVlrOS9zOTU4aGgvNkZ1Z2dJemloZ3VRc2pOa0czVGR0RzBSYjVvU1Bq?=
 =?utf-8?B?M1o4QjNWK2kvTndXQ0VBb1BDSWRXMGpORHg3WHRFNWtVaXpIVFVMSzl4Y3lt?=
 =?utf-8?B?OFZvS295NDVJTTJrZXZzVXBOUjcvVEFzN2doWUNDTC9tTW95TnlVKzFtZmg5?=
 =?utf-8?B?TEJMVzlLZTRWT3dzTnFWdGdMdmFrUVVNZlJZUUhzeFR4R3g4VWwyUElFa212?=
 =?utf-8?B?RWhkM3BaNW1Pb3NySWRGSG1XQjkvTEpENkl5Wnh0Z0t2SXVNdjJaZXlDRlMr?=
 =?utf-8?B?UEdaVHJlY0FFNjVHMFRwdlRFdkNSVG9sbC9sNGhQNGJxcmlEZkFkK01qWHhz?=
 =?utf-8?B?VGMvT095STVQbW8zSXA2bzU2ckRwb2dUVXQ1QS9pcHozUmZYYzhkdkxRenQ5?=
 =?utf-8?B?MnAwMmV2N2Q4VEo4WWswVG5sZ1RueEpURzA0MTBoRzQrenk5OVU2WFVwQnpq?=
 =?utf-8?B?NTNDYzJuckFoVUZPTjR3YkE0VC9Oek5mMklPdml0eGk4RGhVTThXVU9qQ1Jp?=
 =?utf-8?B?YWZBNG1uNE5aQTJ2dlZQZGJoSnlTRytsVndMdjIvUzhqY0JVMUZTdFFBb1Nv?=
 =?utf-8?B?S1N6UGQ0bDk1TkNXSG92N3FYQ0JFM2JrM1NCUVNBbUJWZWlFSzNLM1dzQ01i?=
 =?utf-8?B?MjhlTkZqMWtkaFhZZUo4TzQrNXNNZUdmQ0lHM3NyMDJqMnRJaDhaS3Y3a3pK?=
 =?utf-8?B?cFd3bUJMOFVZMHBLUlBGVk9pT0lROURxL2VjVXhpVlpmR05JTCsrcllZeU44?=
 =?utf-8?B?OWptdDBPRHNsbkttL05IaDVtWTlsNDFwZjZHZUVwYzVvMnY5eC9kWERZS3Qy?=
 =?utf-8?B?MkRHb2l0L3RMcjJULzZ6NXk4RTQvOTE4NFB2U1BBMlN1RGJSZmo3QU52Tk1M?=
 =?utf-8?B?SVdCL1hoREkxQkNKTy9iZ2pzK3lrRTJBRnp4clRacVRaRGVSWW01eFVTTElF?=
 =?utf-8?B?RFJxYU9hNEZQaHpUZzBrQU0yOXYvdmtvMFpzRHhmUFBacnFWakZQVFRKYzVD?=
 =?utf-8?B?RHFQeFFlMWtWeFdGUUdNaVhmUjIzUnQrZk1SaVZnNVpjOHY5bVpzUlU1QmFi?=
 =?utf-8?B?ZEdyUDhvcFJycm5xS3hDSVZxZGFPMGNVN2pnZ3l1TnhhZGVpWEVoQTNtMEYv?=
 =?utf-8?B?dTJBRk1VbGl3aVR6SE1OaUlqR0ttOGVWVU9uOFdoNUVMWVpvWkl2emVVS2U2?=
 =?utf-8?B?YkxTcm1HN29PdG50TFE0WS9DVWk1eFFFbjRWU0dseWNQcGNBVlFIVEtaV1RI?=
 =?utf-8?B?aXdZRmJKcmoxY3hkV3hZL0lTa2FFQmN1bFhDOS92ejMvcWlMVVU2bE9ObmpN?=
 =?utf-8?B?aWhXY0NNbExwcjNmc1F2cHEwNzBNMmRqc0h2d0h1ZUx0dXJPdnUwbWM2YlZo?=
 =?utf-8?B?SUlEaExBU3luOFNGQmRYTDY5TlJoS1ovbm1tZ1AyUnRqVHBpWXJOUFdpdzBV?=
 =?utf-8?B?MFNieHdZZk13SmhseVI1eHZsRGlLVTkyZ0I4bEtKampvMHh2bkxyWmxMcTZw?=
 =?utf-8?B?SVZxTUhLVVd6bDBxOGM1SGtmTG1EMi81bHUvSGpSdEhGVk42UkFwdWpaV3A2?=
 =?utf-8?B?dUtWb1ZpQUtkQi9qaTRicjNFeXZFa05rOFBOY0ZmOWJmQVpIRWx3dkczQ2J3?=
 =?utf-8?B?RGUvYmpnajdUWFFER2diSWZzeVBwcGFheERIK1gvYXFlVkE0VWEyNFAwOGtP?=
 =?utf-8?B?LzRRUFFTOXNJSCtjcDRtYzdIVnhCd2t0K3FFN0RSLzE1T3BJWEUwUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bbe8309-e9b2-4f8a-fd55-08da296b3d06
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 23:02:59.4546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0z5VnGQdY5K1tK1WitnRtaMjZkTBtpC1ONilQl7TzTu5JZfT4WKWAoGKNmJTsqx+f+4GEvap+BZT2oUdLVBVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3298
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/28/22 09:48, Jaehee Park wrote:
> Add a boilerplate test loop to run all tests in
> vrf_strict_mode_test.sh. Add a -t flag that allows a selected test to
> run.
>
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> ---
> version 3:
> - Added commented delineators to section the code for improved
> readability.
> - Moved the log_section() call into the functions handling the tests.
> - Removed unnecessary spaces.
>
>
>   .../selftests/net/vrf_strict_mode_test.sh     | 47 +++++++++++++++++--
>   1 file changed, 43 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh b/tools/testing/selftests/net/vrf_strict_mode_test.sh
> index 865d53c1781c..423da8e08510 100755
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
> @@ -262,6 +264,8 @@ cleanup()
>   
>   vrf_strict_mode_tests_init()
>   {
> +	log_section "VRF strict_mode test on init network namespace"
> +
>   	vrf_strict_mode_check_support init
>   
>   	strict_mode_check_default init
> @@ -292,6 +296,8 @@ vrf_strict_mode_tests_init()
>   
>   vrf_strict_mode_tests_testns()
>   {
> +	log_section "VRF strict_mode test on testns network namespace"
> +
>   	vrf_strict_mode_check_support testns
>   
>   	strict_mode_check_default testns
> @@ -318,6 +324,8 @@ vrf_strict_mode_tests_testns()
>   
>   vrf_strict_mode_tests_mix()
>   {
> +	log_section "VRF strict_mode test mixing init and testns network namespaces"
> +
>   	read_strict_mode_compare_and_check init 1
>   
>   	read_strict_mode_compare_and_check testns 0
> @@ -343,16 +351,37 @@ vrf_strict_mode_tests_mix()
>   
>   vrf_strict_mode_tests()

this func is no longer used correct ?, you can remove the function (that 
was one of the comment from david too IIRC)


>   {
> -	log_section "VRF strict_mode test on init network namespace"
>   	vrf_strict_mode_tests_init
>   
> -	log_section "VRF strict_mode test on testns network namespace"
>   	vrf_strict_mode_tests_testns
>   
> -	log_section "VRF strict_mode test mixing init and testns network namespaces"
>   	vrf_strict_mode_tests_mix
>   }
>   
> +################################################################################
> +# usage
> +
> +usage()
> +{
> +	cat <<EOF
> +usage: ${0##*/} OPTS
> +
> +	-t <test>	Test(s) to run (default: all)
> +			(options: $TESTS)
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
> +
>   vrf_strict_mode_check_support()
>   {
>   	local nsname=$1
> @@ -391,7 +420,17 @@ fi
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
