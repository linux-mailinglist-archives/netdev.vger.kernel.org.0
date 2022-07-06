Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8A9567EE3
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 08:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiGFGrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 02:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiGFGrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 02:47:13 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5641836A;
        Tue,  5 Jul 2022 23:47:13 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265JKHvj004485;
        Tue, 5 Jul 2022 23:41:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aUtCoGikLfLdKVjc85qtV9VUWv6VaYu6Xw+T1Jl6Cmk=;
 b=khGxdDGreqD9fBbXiW5TTnm5sj0adw28oTT68JOT7h1gYqgiTX8MNXdUnrXQ3+zcF7Sj
 RFyzzXTfz9Te0hhZMNWY4NKEGKAeBqCAzNgMNGFzpD2Cr+bSiW/TbeO7u1kMXXQxgyDG
 vlkdshRjVQCEFBP53TxRFSZ5nEwNRSFXatw= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h4uc9k7u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 23:41:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUsnOsUwao84Dwy7JVh333gMkf/QB1I/nadbD0MDBv2yyy6fFNOvjRUrkNVLp44BisvG59LzHp5fn3z7WloUn2KddejBBcJastCzA5+j3msoW/pQ8qPC33+PHOhtAcKBiva4Enf6dKCADNUwvbveSDTYAqi4KOfBf9SXRidMb+oNkpxyiKI0zQ2iDwPIkFyLCzRK/NFWefvWWrsbJqPIdZhvg3ovK/5fBNms0oRiaKZkpGRFPGiNpdBfwC189KwjGCL7htz+ZUVnOMfUhsSXK7yUcmuu9sEr3A3KHM4cAw25yY2Vn/oj5Xd5Vuer9tQgOsD93eKy6ODhvd1Cph2dLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUtCoGikLfLdKVjc85qtV9VUWv6VaYu6Xw+T1Jl6Cmk=;
 b=Ma48Ni+z1X3VOhi4qK9uBTx8H0ceKOBB4yQEfmouXVECxtwFhL1PoKFhwBaggKqCt6fzEwEGz2gFYDXyjTvRaTt+qDqud4dkNhxbJODlz53d0r+W/q7LP960ty2/G8kEX+WOLXzbsptaVp1YSwxSQ6YytHqvpgqXTSBcSHmpxVLWCpcj8uAXB6eG2dIQyPgzjtBod/wO68qD2RUclL2HSY5nXmGTtN4J+VV4M8lVSB7U9poJ3RMmzNEzXHRS3jUS8tWPRa08avEzbkzybDFzRZdEGjWU3DAmtYbBa8hhhpnzvLIh3rcn29tbXci/qflmwWSIO59CDyrl9Cp/79XPOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN8PR15MB4244.namprd15.prod.outlook.com (2603:10b6:408:a5::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.22; Wed, 6 Jul
 2022 06:41:34 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 06:41:34 +0000
Message-ID: <712c8fac-6784-2acd-66ca-d1fd393aef23@fb.com>
Date:   Tue, 5 Jul 2022 23:41:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alan Maguire <alan.maguire@oracle.com>
Cc:     Yixun Lan <dlan@gentoo.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20220703130924.57240-1-dlan@gentoo.org>
 <YsKAZUJRo5cjtZ3n@infradead.org>
 <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAEf4BzbCswMd6KU7f9SEU6xHBBPu_rTL5f+KE0OkYj63e-h-bA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29e9c19f-36fd-4cd2-7810-08da5f1a9192
X-MS-TrafficTypeDiagnostic: BN8PR15MB4244:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SHryaYzO2qm2UD2SwCV6CcXEpkuhxfGJA3RyNZBUo+d6m38rumBkd3n3f3YrV/BO5GQZHVnHR73z3x+V/Lb3HruJypHVpX9FWqaagDCVbkpd5U2FZZ2KQgV6vhTQFZCaxAoHSyutDTkj/p6b5VZ3ImQIPPq8EkN0QvY9rs9ipJFv7SxZpz2UV75Sl/P++bvRFCoC4ba0WYeip+aeXkZDgTV1MigKUE7uKHg/V3YXDghZhv17TPTW1rvGUTkcCFhkzHmlNzw53CvJvQp9wz9LbFFf43axbwbOuUpaWUZD/zMfgJnMjyknvETVp+rPTpGnx4u7/OxXh1qFQG8z9nvJVJEkYnSgGjXSmeDnPM4uUKyyB+lYKab8ilRM8HnsDgLddkRtH3moPWcC71xEgH0DQQZnw7B+8xH7o4P64hWC058xDLCya48ytapI8isGwcwn4FN9Az1qopKj+B5IxwDPjrdRhsi4eAHUpWHKEAwu8ykprdR1IVCU+dJXMJSkKlqbbExs0LNpIdl+ckCxDe8Q6J6tdOA+cROEV0n01x1/ilHfuCAPDxszh5BmlRMgQsOdBZvTwba2ZraEJOFQZvf5qMYMY20uc9/NnYiEal94ZFlgPly4VstyTl/JLtxx8icR4JXMEG0d7Jf5BmErZysG/zE/ooOrcXxs1a7KdPr5gbuuVVpRwS0oAI+jBUUzvaEfGlSrCx5kSmefdyGOKUDiWDEUfeyFI0312fdflbJItXFIuLVC/brtA6lCd7N/wwn1DpTTZzVUDJyzKfWM4rInMYhC99GVpHGpjYAsePBW41ratUSOYaXqPPOBCXmj5XhFnMVgJEO/V6MWiVjoa9FNbJVptdKL1Vsd8mw8lGsMvNo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(8936002)(36756003)(2616005)(5660300002)(186003)(86362001)(83380400001)(110136005)(54906003)(316002)(6512007)(31686004)(31696002)(7416002)(2906002)(478600001)(6486002)(41300700001)(8676002)(53546011)(6666004)(66556008)(66946007)(66476007)(4326008)(38100700002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHlTUmQ3R0dCZTZnVkViOFp0TGxjTjNsNDZXY1FDRGFaTGNRUnZQME5MNGJL?=
 =?utf-8?B?c1AybXRzUkRPQ2lzcUI0VUMzZmVwUFZvMi9JaC9CWkc1citLRUxLQXcxbkE0?=
 =?utf-8?B?bkYvSXRKZ2NSVXdJS2hMK3B3ajFocWt3YmkzNGNJNVpaZ1FQaXRiUFZnemM4?=
 =?utf-8?B?cEpGMG8rbWpKSUdKSllQRmNSOTBrWndPY29IMjVIRFlPYW95YThhZ0xheGNi?=
 =?utf-8?B?K3B2eE5tV25VZXFRci9mSEVPYmtlRE5Md2FpTlh3NzhxV0JtL0lkaXdnQndP?=
 =?utf-8?B?dWRYU29iOU9PU1lkeWZsYnRPQmRtb3VUOVRaR0NTaHp6bFZGZURtbXh0K0or?=
 =?utf-8?B?dTJPVmtXc0lrWDdSV1V1Y1pJNEdzd3RXRTlrT3piUWtHOWlEeXltSFZhMnkv?=
 =?utf-8?B?NE1aS1ZmSnRkYmdBVGgxa0lHWHQ2djdnVHF6ZWdxaVVObGNIV0duOUhqTE5C?=
 =?utf-8?B?bjFRei9nU0FQNW9lamsrTHRteDllM0VTSkxqU0w0WnZ6Q2QxU0tXVkpOdlA5?=
 =?utf-8?B?QWR0V215RkZ2aFk1SGg2aFoxL2tlMTdSWkt0UGExempwTEJzRXRTU0hUalVo?=
 =?utf-8?B?YUpyTWlwM2IyVjU2N2hqZHN2ZHZhY2xqK0x1eEdmaGc4cHI4UnBvcGdlc21G?=
 =?utf-8?B?WUQxNGtHTkhGR1N1NENuV3hFT0sveUhITXJ0TlFmWlluckh4bjFldjlvOUdN?=
 =?utf-8?B?WmVRY2djakppdCtTaHVLZWFrbUxPM3AzemdkL3Q3bE01WlNQNDVEcktScU1N?=
 =?utf-8?B?YXhJNzY2eG9ZWmxRbUFLOUxMK2h4THBCRHRERm9ScHlkK29qSzd6WnJlVzhz?=
 =?utf-8?B?ZU9INE0za2xlR1hUb1Q0SGlXcVR6TDd1YkZ0ZEw1UTlvL2RLc05nYXpzVlJw?=
 =?utf-8?B?THlIdFFZRmdlWEcxZ2NYSHRGQXdoZ205c3U5MGZaaG16OFhoL2FibmYvc0ZV?=
 =?utf-8?B?cHd3K0MxM1J0c1pISUkzczNxTTJzK2tudmpiY3hsY2g1S1dxa0lWSEM1STV4?=
 =?utf-8?B?TEE0cXVoKzNMbVpWRXg3RnIwamk5am10TUJSdVFZY0QrZS9RWDdnQzBRamlH?=
 =?utf-8?B?aTdoQTM5STNpWVdRSTU1TEx6V1hGcnlxSFVTVXpXNkpYQ0ZVaWUvMlkxZWJk?=
 =?utf-8?B?VTcwYUxpUGtDcENvVXJoQ0xkT0xSQW9YdmhIZXEwYjlQNEFxZWhiT1RCenlC?=
 =?utf-8?B?ZUY2REFsV3AxQ0dRaStINDlqSFF1Q2prV1IzQ29IbHpKVTNtaWd5OGFoNUZu?=
 =?utf-8?B?OHBPY2RDMVMrNHk3Tk5jNzdKaVJyMlVnN2Qva0xLbmR3Z0hsdmcrSHlMemVs?=
 =?utf-8?B?MTc1am85a1plZUdERDB6Vzd5YUpERFBMR3ZyWVFrZDRkQnVPdWFoakRndCt0?=
 =?utf-8?B?K2tCRitOMVh4TW1XUmRaTkJIMm5XNmVGeWJHNEhBRXhVSW5jU3FWYUZBOGpn?=
 =?utf-8?B?Qzg2WGFoa3JKTUN0NStNdVNTS3pDYjNtMzEwSzJTNjVNWUxGaWVoejdqWm9i?=
 =?utf-8?B?K1VuUVc1aGdQWEtSbTU2ZE1vWC9mUW9QQUNRZ3FGQkIzWHloYWtUSTgxaXkv?=
 =?utf-8?B?TkkrQndDT25MMUpDQXBJQ2kxZVZCQWpxdEFYWjRHRlVIc1d0a0pOUDNicmpB?=
 =?utf-8?B?ZVhRaXhRdUJ4WC9CYjU5SU10R1VrbVFhZVJoVmVPcFRlQzc0MTI1cHR0bkhF?=
 =?utf-8?B?c1IyditkT0VZZjFXVXJsRzFIcmt2ME9mam5QeTk3cHhUVDlZVXUxYmNtbGZG?=
 =?utf-8?B?Q0RVUGpyWWlKWGxLbm5TbTROTDdLUHp5d1RqVHd1dE04UHlyeExhM2FaOEFU?=
 =?utf-8?B?ZnZCZGcvVkpROFhUcmordnNkcm1yWUZUVjhnd05yWjllK2lzaUhBQmhta2xU?=
 =?utf-8?B?UWF3Z2dWQitvem40eEZ6ckZ2QWI2aWt4b0kzZXg5YUhDc1VnaGFlbmpub2xy?=
 =?utf-8?B?cWh2aWFMb1V2RGQrendRNXk1VlhPMkQ5Qm1xc05iRUJFS1FtZkFyRHBUb1h6?=
 =?utf-8?B?S293cVp3MDRTSWp1TElYUDRXaFpwVGZqN3BNSUlmVVhVc1F3a3JXZjN0WHRF?=
 =?utf-8?B?T0xZQVQvaElhVWxsVGhnVjl6cm9mNXZMVUxKVUcvT0xQT1QyTkx5V3RhWmFn?=
 =?utf-8?B?RUVBbHFsU0xiTW9GYmNJaUthcXBGMitlRm5XUk8veWVvcW9nTWNVWElrTWlG?=
 =?utf-8?B?bFE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e9c19f-36fd-4cd2-7810-08da5f1a9192
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 06:41:34.3992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2i7fqnxXzpwVCZ0/r1n92yPRUXoyq8BX13y0WNOcwct800g8I/1ojT4qi4L2AZI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB4244
X-Proofpoint-ORIG-GUID: 7Su7rxRlvVqIWfHjE6VRf8hzXWg5lN5P
X-Proofpoint-GUID: 7Su7rxRlvVqIWfHjE6VRf8hzXWg5lN5P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_03,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/22 10:00 PM, Andrii Nakryiko wrote:
> On Sun, Jul 3, 2022 at 10:53 PM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> On Sun, Jul 03, 2022 at 09:09:24PM +0800, Yixun Lan wrote:
>>> Enable this option to fix a bcc error in RISC-V platform
>>>
>>> And, the error shows as follows:
>>
>> These should not be enabled on new platforms.  Use the proper helpers
>> to probe kernel vs user pointers instead.
> 
> riscv existed as of [0], so I'd argue it is a proper bug fix, as
> corresponding select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE should
> have been added back then.
> 
> But I also agree that BCC tools should be updated to use proper
> bpf_probe_read_{kernel,user}[_str()] helpers, please contribute such
> fixes to BCC tools and BCC itself as well. Cc'ed Alan as his ksnoop in
> libbpf-tools seems to be using bpf_probe_read() as well and needs to
> be fixed.

Yixun, the bcc change looks like below:

--- a/src/cc/frontends/clang/b_frontend_action.cc
+++ b/src/cc/frontends/clang/b_frontend_action.cc
@@ -132,7 +132,7 @@ static std::string 
check_bpf_probe_read_user(llvm::StringRef probe,

      /* For arch with overlapping address space, dont use 
bpf_probe_read for
       * user read. Just error out */
-#if defined(__s390x__)
+#if defined(__s390x__) || defined(__riscv_)
      overlap_addr = true;
      return "";
  #endif


Basically, prevent using bpf_probe_read() helper, so it will force user
to use bpf_probe_read_user() or bpf_probe_read_kernel(). and this should
make it work for old kernels.

> 
>    [0] 0ebeea8ca8a4 ("bpf: Restrict bpf_probe_read{, str}() only to
> archs where they work")
