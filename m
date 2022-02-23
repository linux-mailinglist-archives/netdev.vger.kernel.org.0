Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABF84C1915
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243034AbiBWQyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiBWQyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:54:01 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F3B4DF77;
        Wed, 23 Feb 2022 08:53:33 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21NFULwV024848;
        Wed, 23 Feb 2022 08:53:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=E126nmqnKDW7v1LmcPayIklPAQNYB72IAtsfjbRmE/8=;
 b=R3GupPuF1zb9V8pHJcg4fYGnV7UFvFv/IFMe85RphHLuoonxlD5Zu4+iyoQX4ZYb7Qwq
 iFdsKzgFFoj7q9RbjWtZDNfflH0Fav9lO5tvtfKd0mKx0t3Ui9vs2di+3BzkPBEf5kON
 ZtvZD8S4PiCSm/Q65SkT3NAm6v9Z9wsG0OI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3edbfjvr26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Feb 2022 08:53:19 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 08:53:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUMIcelOV4dQFPwgSmjuZoEqGTGZADjqgPzPGtlY2t/1p7zwe2pcrnbAn8+y7qbCJfZUzN6IX8BUCNUnbiNqNLDn/9MGf6PHWfqfqnWfxr81qmZk/UcJp/1YGtwyrPi9VFkK5NXFMVYCeNPlkkuVHaz6+v5VhoNgEkN4nG/sLxySPBp6wIduIg8saF8wfLNhtLndvlzEm8/Hngm9J5h+c7yh9NFF1em7BXDDLC1Dh7qg8P02Ii7wiHJfpUiyhJm5/Whyoq11IuUskAnPgmpmaoOM/MqOXQcDjm1G9Tf2/e44XcGk6q/syImk2rXZPkL1DOIybLE5UToRvV/d4fTWng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E126nmqnKDW7v1LmcPayIklPAQNYB72IAtsfjbRmE/8=;
 b=fJAdPctVdlWPUbrwu4uGBYAQJDPXgkLWdKyy2c+STuJHMGNRobz72xtrC7z+CoH/oK02SWIffo5ewH8cEBfgCn04PPW3jZmVvzx+EDpSMswoSWDtgl69G6Ws8kj6dTI4kwqQAeUdC9IizgD60uSwHBDrkoEupXBxN4i2KkME+Fo7Twpj9GJ6UrUpCtiYL8EXFoK3Pi0Cu9gFyPLBjM8TEcqrolgrlUomOg6Ch44MBmvYmjKIBWaEeS6btO84L2owsIxIwMxWVoxbs9MrDHN742uT5EyGKTylhoe4UXGHPpGQzvSLmkTQuxYqBae4WocOKQh5t2gJI6w9iyJs1ka9xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2950.namprd15.prod.outlook.com (2603:10b6:a03:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Wed, 23 Feb
 2022 16:53:15 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 16:53:15 +0000
Message-ID: <75ee7810-8735-7eaf-bcee-559c77bbe9f7@fb.com>
Date:   Wed, 23 Feb 2022 08:53:12 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] bpf: Refuse to mount bpffs on the same mount point
 multiple times
Content-Language: en-US
To:     Yafang Shao <laoar.shao@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <20220223131833.51991-1-laoar.shao@gmail.com>
 <7ca9637a-8df0-5400-f50e-cfa8703de55c@fb.com>
 <CALOAHbC4DDUmje999Fizse_O_ibhJckR0kzO+qwC6eLUJhkX6g@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CALOAHbC4DDUmje999Fizse_O_ibhJckR0kzO+qwC6eLUJhkX6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:303:16d::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b431da2a-25d0-4c6d-fbf6-08d9f6ecfc5d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2950:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2950D5B1272AF56BBE9E82B6D33C9@BYAPR15MB2950.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CK/5QVnM4ETZpemZsOf3b7vSdpoeSnxB8OujhATbc7UbhY6hy5me0/myPvW1v480FjP969nhpNbsL19EfSV2OFIcMnTbIBaxd9P2W4QWtRyhm3D8eTS2LU1ku/LHaix8c9K4ipG+pLscmHVtNb5E1laaRoA0TBTYpkCAA4dGOgz7ics8xJKsD8tjxl9oORbKWZ7QfbMe2QG5M2zQ3QkE/lo7+n9gVqRfqTrHs4Zu1qRP9i7pc+xK1/bxKRIovVvHhgbaRksn5VPxIriZUt6LhWwzMuAjNj3ZWtGUWmeCkmqr8T8r47ESJTIAs8xZ7jmwr3Nj7B3enhg1do4cpwOTqqO/8vGqM/Rxikl2wAW5JnyrdUZ9kmZEe+Jt9hjcQ57/+68d4kSFi4vVe2xinOD2wsnSzUvdyIdYy+DgLkraThQpB4F/atlVkPTeu2Uua0J17I7OQYdbKKUTfhmzjuET/j61SYIdTO4/Lrn8D8pbIcj64H+g8Jrd6XG01BSA6nAMTDGB3DOBeqk9hoZObtc0ypYcB5IF+oI7Cks7X2GHN0zeZWsYjoWYbgVS++1/5bcPB7KZMWTCHbpEIu/Jh5CfaLB0V05BwcF48kspkh1Ful4q5TXfQx/lwtQiHSYY+PewEGIebYt8yD0gqvxHZ9zKoKDoH0WST0yFULr4z3OFIZF3KNLeezrfPWvUN1JEs0XrJgHYtWMiMa1I4knKjvGxdQUiYcdLwvLJZJj4x4zQgqjzePQ5HOaLU76Ln4YypHqDwlzUsjgY4y5tcJXL1xnCDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(6512007)(6506007)(316002)(31686004)(2906002)(31696002)(86362001)(54906003)(6486002)(6916009)(508600001)(6666004)(5660300002)(53546011)(52116002)(8936002)(38100700002)(4326008)(36756003)(66556008)(66476007)(186003)(2616005)(66946007)(8676002)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHJ2VmsvRjBvTDJJOHAwMDlGa1JyVmJ2RmlMSTA3aUhzeVZ2Z3QrSWxqZ3Bt?=
 =?utf-8?B?WjBPNzZSL1JXUFJuWlVPYUNrQ29xdS9YTVF2azZHSlZZZXY2YXU3NGRnZlNQ?=
 =?utf-8?B?VVZTbDFYR1FFVkdFY0FMUDUraGxvK2tZSGh2aFhqZEpuckVzRXFUOXphUEt5?=
 =?utf-8?B?OXFBb0JWRm5Uem5zb2l3SkV3WjBKTUVjdEcxcVN6R0w0NHhPYVUyNnYwMklM?=
 =?utf-8?B?dWRyVlpPM1hDOHVaZk9ERVN4VVhtdCtPRUlJQzgrN3ZxN253KytORFE4UDB4?=
 =?utf-8?B?ZUNJYnV5ZEtEZ05xVjlza1kzcHUxODBGZnJGLzRRRFJQcnkrVzJ4MEV1MnJB?=
 =?utf-8?B?ald5VWpsQ2hwbmxmajdIajluallKdVpuNXZkbW54blBwNXpwV2pqTUtGZSt3?=
 =?utf-8?B?LzluTHRrNnB0LzQyb3R4QWJvMzAydFF2MUttQXNJWnFFREFXeE5ldVpQTDdG?=
 =?utf-8?B?OXVhVjdoV0NKcHRndEliTWJYSW16andUVCszTVR6WUFkWlVMK2VjMHpKdXI0?=
 =?utf-8?B?WDl0N0hPVlJIdk8waU8zeDVGTHpLT0h1dEI4R2tRTzNhOG9HNXlyZ2hyRnAx?=
 =?utf-8?B?b3p4U0RFZTUxdVNXTXQ5V0I5MGZiOHVuVHlRaGx5aTNldEZuQXpESVc3K0R3?=
 =?utf-8?B?UUZkUjVndUQ3RGxoM1ZZOGtCU0NTR0pzd05ucmpydGxDUkFzMnRHTXZQM2VX?=
 =?utf-8?B?R3h4ckxEQ3p0Q0t4UUhKenNrUkVaNWRzaTFxTUdUUThOdkQwZUdYRFpiNm9R?=
 =?utf-8?B?UFZCTWNWT09yNzltcCt4M0pURCthWnpuOHJ0ZkZ5R3RYNTB0SHM1c2tITVB0?=
 =?utf-8?B?NjdtV2oySXMzSjMrS2lOUEN3Rkd1clFjUmZJNmx3dUhwblhPZi9IUjBJT0ta?=
 =?utf-8?B?M216aWhrWUJFcDM3Zk9tcFQrbHhadnhMdFRTeHpiMGVYaHM4azBZZ1pCTi8z?=
 =?utf-8?B?K3g4K0ZIemJ5Q3RtRHdQQVM0Q29peEgrd1I5T21QcEE5R1hrMHZhSXROVUcz?=
 =?utf-8?B?MVcyRTRRaUNFMy9aY3FoS0RvSTdOYnVVVGVraGRaWGljcFV3TGs4emNJVFNu?=
 =?utf-8?B?OVA2bUlLa2tvRS91cDBRQjk1R3pkbXExbEF6WmVLMFF5cDlYNHVCS3pBNnFi?=
 =?utf-8?B?ZTNvS3FtOVRoV2ZGTjZFQVRMa1VFaDYrRkdBWG53WjViREN5ZFFraXRZUFgy?=
 =?utf-8?B?L0lCbFRZZnRiQzhNazR0bHhXOFN4QVdGREJtZll4OVRZa2U1RVJTTlkzMnJt?=
 =?utf-8?B?RGVNNUEvL3JvYUxaajY5V01aeG8vNXlEelJlOG9QZTlWUG4rVDdjV29SYU9p?=
 =?utf-8?B?Y20wRjdnQktwVUI1QS85c21WREFPaGtJT2ZQajdVbjY1VVlsL1JpbXUvUUxI?=
 =?utf-8?B?RUtWcEVsUnp6NHpsTVhwRXY4Rk0rSkIvMGg1TE1SeGRLVWdGbnNyTFI0M01l?=
 =?utf-8?B?eFFIK3p0UVFHTHVlRGVnL3hhMzc5UHg4UFQxeDlrQVNSOElUTU5kYmNxNGpv?=
 =?utf-8?B?Q21Wb0tDaWVGQ290Q0dncVc5dndqYUF2NnJIYTBuRHY3Rk5yWDkyVmFJaWk5?=
 =?utf-8?B?cmROaWVvcU5ZckpqT0VUWFJhTzd5Tmx2NzhFczJ3cVFNelVNV3pPdjJKalQ4?=
 =?utf-8?B?d1RRelFmRDJrRnpMRlIrNmhuUTVwNWFRMHk4N2cxZ3Y1eTF2aEtEVTA1aHlQ?=
 =?utf-8?B?L2dWR0hPLzZRNGxmaWRDZEt6SklUUlFnMnNwdThkVmw0Y1pPbGo2WmJiRm1k?=
 =?utf-8?B?R09ERHVZeTRONFRCUVJNV1lWdkd5UmVYMU9USmZYdlQ4aTFtVzdOTy9BNjlk?=
 =?utf-8?B?RzVTWlBXbWFLS2txVmlyYmlOY09VU2NtS29XaHZNZE9zTm1vaU40R3AyeFhu?=
 =?utf-8?B?N2tCSnNTRy9lMnl4VVJuRGpwRHo4bSttWmQzcGhmK2E5Ums0QWVXdXhBRmRy?=
 =?utf-8?B?eVBsQjYxMXlBYnAyNUxtbWxrTGlvTys1OFVwRXFGdW1hTmZwZWg0a2tXaU9E?=
 =?utf-8?B?NUpBb0Y0REwyMWRhamw2cnZWUXZobms3Z0NkUmpQNjY2dTRZbXBtU3Z2WWgr?=
 =?utf-8?B?K0NJZUJrOW9qWXdUREYrRGN5QVNvS0lOYzJ1NEN1N1NVaUpyeEpsOVVqRDBj?=
 =?utf-8?B?QnlFRU1QbTNnVkV3cmpYb25wcGNyajBmWXFJQnd1SFM3b3VwbFpvUXFMNSt4?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b431da2a-25d0-4c6d-fbf6-08d9f6ecfc5d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 16:53:15.8087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0PpHQTMCtEX/hZmCjVpk3fBWrkUvboLZwV79B2l7ZbX7yuvf9r9U7NW+AKOhVHVm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2950
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: uqQEjA1ovg9J9m8CXOZMyuY95U4jbEJ1
X-Proofpoint-GUID: uqQEjA1ovg9J9m8CXOZMyuY95U4jbEJ1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_08,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 adultscore=0
 impostorscore=0 phishscore=0 clxscore=1015 malwarescore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230095
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/23/22 8:17 AM, Yafang Shao wrote:
> On Wed, Feb 23, 2022 at 11:36 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 2/23/22 5:18 AM, Yafang Shao wrote:
>>> We monitored an unexpected behavoir that bpffs is mounted on a same mount
>>> point lots of times on some of our production envrionments. For example,
>>> $ mount -t bpf
>>> bpffs /sys/fs/bpf bpf rw,relatime 0 0
>>> bpffs /sys/fs/bpf bpf rw,relatime 0 0
>>> bpffs /sys/fs/bpf bpf rw,relatime 0 0
>>> bpffs /sys/fs/bpf bpf rw,relatime 0 0
>>> ...
>>>
>>> That was casued by a buggy user script which didn't check the mount
>>> point correctly before mounting bpffs. But it also drives us to think more
>>> about if it is okay to allow mounting bpffs on the same mount point
>>> multiple times. After investigation we get the conclusion that it is bad
>>> to allow that behavior, because it can cause unexpected issues, for
>>> example it can break bpftool, which depends on the mount point to get
>>> the pinned files.
>>>
>>> Below is the test case wrt bpftool.
>>> First, let's mount bpffs on /var/run/ltcp/bpf multiple times.
>>> $ mount -t bpf
>>> bpffs on /run/ltcp/bpf type bpf (rw,relatime)
>>> bpffs on /run/ltcp/bpf type bpf (rw,relatime)
>>> bpffs on /run/ltcp/bpf type bpf (rw,relatime)
>>>
>>> After pinning some bpf progs on this mount point, let's check the pinned
>>> files with bpftool,
>>> $ bpftool prog list -f
>>> 87: sock_ops  name bpf_sockmap  tag a04f5eef06a7f555  gpl
>>>           loaded_at 2022-02-23T16:27:38+0800  uid 0
>>>           xlated 16B  jited 15B  memlock 4096B
>>>           pinned /run/ltcp/bpf/bpf_sockmap
>>>           pinned /run/ltcp/bpf/bpf_sockmap
>>>           pinned /run/ltcp/bpf/bpf_sockmap
>>>           btf_id 243
>>> 89: sk_msg  name bpf_redir_proxy  tag 57cd311f2e27366b  gpl
>>>           loaded_at 2022-02-23T16:27:38+0800  uid 0
>>>           xlated 16B  jited 18B  memlock 4096B
>>>           pinned /run/ltcp/bpf/bpf_redir_proxy
>>>           pinned /run/ltcp/bpf/bpf_redir_proxy
>>>           pinned /run/ltcp/bpf/bpf_redir_proxy
>>>           btf_id 244
>>>
>>> The same pinned file will be showed multiple times.
>>> Finnally after mounting bpffs on the same mount point again, we can't
>>> get the pinnned files via bpftool,
>>> $ bpftool prog list -f
>>> 87: sock_ops  name bpf_sockmap  tag a04f5eef06a7f555  gpl
>>>           loaded_at 2022-02-23T16:27:38+0800  uid 0
>>>           xlated 16B  jited 15B  memlock 4096B
>>>           btf_id 243
>>> 89: sk_msg  name bpf_redir_proxy  tag 57cd311f2e27366b  gpl
>>>           loaded_at 2022-02-23T16:27:38+0800  uid 0
>>>           xlated 16B  jited 18B  memlock 4096B
>>>           btf_id 244
>>>
>>> We should better refuse to mount bpffs on the same mount point. Before
>>> making this change, I also checked why it is allowed in the first place.
>>> The related commits are commit e27f4a942a0e
>>> ("bpf: Use mount_nodev not mount_ns to mount the bpf filesystem") and
>>> commit b2197755b263 ("bpf: add support for persistent maps/progs").
>>> Unfortunately they didn't explain why it is allowed. But there should be
>>> no use case which requires to mount bpffs on a same mount point multiple
>>> times, so let's just refuse it.
>>>
>>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>>> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>>> ---
>>>    kernel/bpf/inode.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
>>> index 4f841e16779e..58374db9376f 100644
>>> --- a/kernel/bpf/inode.c
>>> +++ b/kernel/bpf/inode.c
>>> @@ -763,7 +763,7 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
>>>
>>>    static int bpf_get_tree(struct fs_context *fc)
>>>    {
>>> -     return get_tree_nodev(fc, bpf_fill_super);
>>> +     return get_tree_single(fc, bpf_fill_super);
>>
>> This is not right. get_tree_nodev is intentional to allow bpffs could be
>> mounted in different places with different contents. get_tree_single
>> permits a single shared bpffs tree which is not what we want.
>>
> 
> Thanks for the explanation.
> 
>> In your particular case, you probably should improve your tools.
>> in my opinion, with get_tree_nodev, it is user space's responsibility
>> to coordinate with different bpffs mounts.
>>
> 
> Of course it is the user's responsibility to make the mount point
> always correct.
> But it is easy to make mistakes by allowing mounting the same bpffs on
> the same mount point multiple times.
> Per my understanding, as that behavior can't give us any help while it
> can easily introduce bugs, we'd better disable this behavior.

This behavior may not be desirable. But the patch itself won't work
and user space can handle this.
And this is a general problem for all get_tree_nodev() file systems.

Let us say hugetlbfs:

$ sudo mount -t hugetlbfs none tmp10
$ sudo mount -t hugetlbfs none tmp10
$ sudo mount -t hugetlbfs none tmp10
$ sudo mount -t hugetlbfs none tmp10
$ mount | grep hugetlbfs
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime,pagesize=2M)
none on /home/yhs/tmp10 type hugetlbfs (rw,relatime,pagesize=2M)
none on /home/yhs/tmp10 type hugetlbfs (rw,relatime,pagesize=2M)
none on /home/yhs/tmp10 type hugetlbfs (rw,relatime,pagesize=2M)
none on /home/yhs/tmp10 type hugetlbfs (rw,relatime,pagesize=2M)

So this is not a bpffs specific problem.
If you want to fix this problem. Please fix get_tree_nodev() or
introduce other get_tree_*() variant if fs maintainer agrees.

> 
> Maybe there's another get_tree_XXX that can be suitable for this case,
> but I am not sure yet.
> 
> 
>>>    }
>>>
>>>    static void bpf_free_fc(struct fs_context *fc)
> 
> 
> 
