Return-Path: <netdev+bounces-11671-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3999733E0F
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AB6328194D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 04:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DD71874;
	Sat, 17 Jun 2023 04:49:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE3C138F
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 04:49:12 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0F0DD;
	Fri, 16 Jun 2023 21:49:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mteHOEHy3NgjIDsZxXWVy6r8r4m0cDmNFJhug1u2m+GfWmVK1+mrSmzkhm2vN2n4xMUobxHieyOQTkEfN+JvVGo8Eo+SRIep2BoxL/8HSiw1pZZcHgK5oUY+LR0XWFRRDhR+u9wyWECa2KhVoPcN4YhXMEDh/7nCzkl5yf2cEfkSfIlV5lpIoyVcDz3QDU8VLm3KvjquiTDbplSxUw726RiUWd4zf0VbdqMu/rBvNzOr7DuQO8uSTmsQL4g6TlKP3Nhwq6MX0bp84WCCmB3x1bHEV+1pdz23PCAzWDOJG495QUgQ8Npro+5UF4UoPc+JMViwrQ9w60bFZhoD3pnndw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITWIKiLvntUMu1jIMHPmIeB+zZ6bCtN7ER3klqY6+SM=;
 b=Y1IUSDsMteyiR2feTKPR30ZmVZlgHAC+0jwI9bEdqQR9EYpJusrKEERqEoNqddUiu+z8ad4BvWcyeGaPAPDieAjHjwXYBSDxIlmCSiQJC3TUedktNxemr25LhJaTZJLe4k6wYyQ7RevfY91JofAxYoJhGcoxcQmxd9QvRKVsc/1szDJTKNUdlAEpu5AE7HCcc7F43kxmKHpVjptH9QiAYYbiNp/3eMDEpUAb9B/mgMQf8x6vBeN3oXGM4eCm+WjJAe+yhWjASlvvg98XD407YiBa4IoC3dAvZwFs+ewRcqhZHFir/S3YAKjXvUetTsQf2m9KDYad3OQ76Mpn5tydKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITWIKiLvntUMu1jIMHPmIeB+zZ6bCtN7ER3klqY6+SM=;
 b=4221fi1xdFL0wKutNo14d685iwWBllcal5dtRmwMX3EELwmtR+O7SOVXoZNWIo9HHGCddZjghecSkyr5lUuljIQ9JI+rGJaNKFMi1Ty4Pck+EBmf8LfXYYyIF5Az4eBCpVEFCwAKqJKA9IQrTZQXUo4W1s9ribaQgBLsnMKvqCk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by BL1PR12MB5730.namprd12.prod.outlook.com (2603:10b6:208:385::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Sat, 17 Jun
 2023 04:49:08 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Sat, 17 Jun 2023
 04:49:08 +0000
Message-ID: <1b5bb4df-df6f-65af-df05-08f1a4b3dacf@amd.com>
Date: Fri, 16 Jun 2023 21:49:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 vfio 0/7] pds_vfio driver
Content-Language: en-US
To: Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
 netdev@vger.kernel.org, alex.williamson@redhat.com, jgg@nvidia.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 kevin.tian@intel.com
Cc: shannon.nelson@amd.com
References: <20230602220318.15323-1-brett.creeley@amd.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230602220318.15323-1-brett.creeley@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::18) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|BL1PR12MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: a8baf4e4-5cad-406c-e2f4-08db6eee2fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IC5uiLhM812v7qX55PCjyPFd01JWqhwq4EqN4nc+SPv3QGDY4l/dIONHB6htXX+NaufEjGPnGzmta1Qsj4ui2xNDdLvHmjJLYt+ZBPOG/Q6R6ZX1X+XjBO8PUmgV5PPTX5bpsOE1/jeIPd3nJzZkcFpi2qTLS/PHyrbBoKe7UUrap3kB9MvVA/bAKNCSWy+4e0KFLbNcJ6F10dEFyS7DnNQxOU+E1eTKrr6mAEGzpE/vSFOux+02DB0S0i11xg0naz8+VCXlXONEAgyPZrrNw+/F5sY4LjxxAY73hdcvReqS8VYfM6G8naHbL48sMI8gX1y4O9EcqLz8xaT3Iky3mNQOKChf3VPAWTw4Lir7hpFIPqwItL0cqUs+y5QEAyD3gJxC5OslyqAT8stWKV4NGQ/rzHV5/M8yUj3DCAOQvz3m1eeEpLQNMN4SvW+X+KY46MAIan/R5YwzeSz2WpalsQYjnPdNyRUuJQmKkWOhxZcu7TcNktnDXVcozd6HKJDk/C6xaRsLBmvToaCRmeZHD3we9Do9qLemgYDX685V8qvkYipvSr6qwRkhAnrZSPFUdIGkWZfdDfTES4BgxjRuRHqzTL2WqzM0HL/Kt7K6guxKZto0qHFZx26tj/Mm1S/Jfz4+DBNvHW0w3QBervRblg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199021)(6486002)(31696002)(8676002)(316002)(6666004)(41300700001)(83380400001)(26005)(5660300002)(6512007)(38100700002)(53546011)(6506007)(8936002)(36756003)(66946007)(66556008)(4326008)(478600001)(186003)(31686004)(2906002)(66476007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N29aaVNTSFc0d0Y3SFNiZS96NU1tV2locUtPbDJOeG13TzRKRHVVTHJLZTI2?=
 =?utf-8?B?c21udFU0V2ZHeGlOODhuMUg2RVdacnRJZkh2cDNPdHk0bFFMQ3RIVTJDY0Fp?=
 =?utf-8?B?NmNtK1BQelR1b096WFByNis4MHJycHhNYTVxUGRLNHFnMmU4dThxOXlpTHJO?=
 =?utf-8?B?dkFkTzZwckdjL011L2Y2SmY1NjM5Qm9NYUlkSE5rT3BTVEhWU2h0VXBFL3lC?=
 =?utf-8?B?WHJ2M2licGhBNDRncnhNNTRFS0MxV2JaOGoxaktXTXUvY0NnNlNQeTlFODNi?=
 =?utf-8?B?T1BOUFZBU2tISEp0djVXWG1BSnB4NndEQTlzSHVPbzBaNWp5bWdHUGtIV3VL?=
 =?utf-8?B?R2tiYWIvRElaZXNZckhhTFNyQ3cvNjh0b0dhMExFdlRvYlpEQ1c1KzVOTjRk?=
 =?utf-8?B?SFA2emxsOVJVMUdLcjlLT3VIUkV0VDJrZmFvcW9NTzVtZENFaXVaVlRvc1ND?=
 =?utf-8?B?Z3hzcXhiTi9HcXU3ajdpci9vdnhuNjVjK09yQ3BwVEhLWVFpZHRORjFFNm5i?=
 =?utf-8?B?cmdUQWRmdnA3clZIengxVlRpR0wzRm1BUUc0UUVEbTAvenREalMvMFNkTzhS?=
 =?utf-8?B?RmJDV3RiRW9vMzVlUnRjY3VjMUNtdHR3V0ZKUmpqcXFEeXcwWExVVjE3T3V2?=
 =?utf-8?B?T096K2FrVzN0TkttYTNmYm1JbmFGWlhTSlA4T0RySG02K0JCSXRIV0h2S3do?=
 =?utf-8?B?TnpLL1c4MTBSWlNYYVgyNEs1T3h1ZlhiUzZvT0dGeGozZ0MzRDlzOUpUZFZB?=
 =?utf-8?B?QmJndC8rS3FOVzhmeUIrYksrZnp3YTlhclJLZFV5Ly90ejlKZlJjNFZRTWwx?=
 =?utf-8?B?UkxJYk9mUG1Ba3FOSmo4T2ZCeXRwMXZRWjZPZEhvN0c2OXFEc0ZJVUQxM043?=
 =?utf-8?B?ai90NVc1bDljdDBvV1EvUDJRUnp0dHhTamZ3NC9PY2dqRTBhYXVPYllieUZy?=
 =?utf-8?B?TEVmSXJ1cVdHUEdiMDNuZURpTGlWTTV3Yk0ycFNkbFFJTjVNdHNxNW50dWZN?=
 =?utf-8?B?eVFMTytqeHhCbnk2T0xkOWhPL3JGR2UvUXlxbTVDSHdqZWZ2N3RVS0Q1KzZV?=
 =?utf-8?B?SHpSb29DV1R1OWhMVlUvZUFsQWhhSTV5dC8vM2NYZEt3RTVQTEtLdWg5K01k?=
 =?utf-8?B?TUk5MDFQRElJaE9pMVpTMk1STmNsczRGMEhXVEJkNHpZQmd2R2JlNzFkbHlW?=
 =?utf-8?B?cnpsK3FRUzc0UFo1MEJFaHQ5ZWV5UzVscGlRY0tYZTQrNXA1VmZyaHhLZFBG?=
 =?utf-8?B?RTgycUc4Z2t5WlhlT2I2WURNeUJ1SWRoT0cxSnJ5blM1MDJZdGJQaXNoMm5D?=
 =?utf-8?B?cWVBRUJQWTJJSDRXa0tLVm8wc0JEOXRrRE15UFFxSmZZN0txL0UrUkwxVUFQ?=
 =?utf-8?B?TUNoWk14dGU3Q0dmdnFJc1NPVm5jOW1kZVZycGlacG5KeVRkUVczbllDODVW?=
 =?utf-8?B?YytpV0JhN2VuZFFlL3RpNEV3MGt1b0hVV3UzamhubGc4Y0g2TU1lZHRVeFRx?=
 =?utf-8?B?clNYVkpWUFRrYnQ5VU4zeDZsbk9DUlB0YS9YcVpWTzg2WGIwV1BsNVVqSTdT?=
 =?utf-8?B?dzdJY3gyc1JPSlM5VzY4Qlk5WW1BV3FoYzZQNExEWnNwQXpTaVNGUzdQdFBB?=
 =?utf-8?B?M29OelNGQVRpeXNZY1IyWWIxcWtyYk9rMjBBbTNOS3JxWm5abm9nSU9jeDBi?=
 =?utf-8?B?MExuSDAyWFltV21BMUtXcHBucWZEZ3gxa290TllnL1IwOWhJYi9FMGZZZ29E?=
 =?utf-8?B?SitMcTljbkgzb001TEtrRGVEOVovYnpML1hUSlBjSVZDMDc0NkEwZDZubzZX?=
 =?utf-8?B?anlTd3hra002VWN3eEZVTERLTWVhRndwbUFnR0tiVm9lZnRTanpZM1pXODZl?=
 =?utf-8?B?OUsxaUNYMkU2ME0zdjJtL3JKVHl0YXRJdzhFVUUyZ3Y4aTBRNXhwVFFDT29S?=
 =?utf-8?B?b2pEUlVFQTBFYjBNZlZOTFROc1BQTzIvbThDNVhQeG9FclB4V0hHcXJsZXJl?=
 =?utf-8?B?dC9wa2wxTUY5ckRtVDFGOVpZYTE5NmQwazIyK1c0eXhHc2tBK1Vrb1had2ov?=
 =?utf-8?B?Y3BhRU1PdklMU0c1aVFCeUUwOTZiYUFQWDRsUWhBTEE0cUVIZ2k5M0FBVHMx?=
 =?utf-8?Q?ryaMNAlUMoJeDXGmiPC4jCXqj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8baf4e4-5cad-406c-e2f4-08db6eee2fb0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2023 04:49:08.5701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yxU5PC7oH+BOIAEiLd78m1BdJUSwnfC7I2vSilgWgQCxrq0//6KJ/7/QDagc4l18Ck8f2yVWgx8o/CWQTnoxxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5730
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/2/2023 3:03 PM, Brett Creeley wrote:
> This is a patchset for a new vendor specific VFIO driver
> (pds_vfio) for use with the AMD/Pensando Distributed Services Card
> (DSC). This driver makes use of the pds_core driver.
> 
> This driver will use the pds_core device's adminq as the VFIO
> control path to the DSC. In order to make adminq calls, the VFIO
> instance makes use of functions exported by the pds_core driver.
> 
> In order to receive events from pds_core, the pds_vfio driver
> registers to a private notifier. This is needed for various events
> that come from the device.
> 
> An ASCII diagram of a VFIO instance looks something like this and can
> be used with the VFIO subsystem to provide the VF device VFIO and live
> migration support.
> 
>                                 .------.  .-----------------------.
>                                 | QEMU |--|  VM  .-------------.  |
>                                 '......'  |      |   Eth VF    |  |
>                                    |      |      .-------------.  |
>                                    |      |      |  SR-IOV VF  |  |
>                                    |      |      '-------------'  |
>                                    |      '------------||---------'
>                                 .--------------.       ||
>                                 |/dev/<vfio_fd>|       ||
>                                 '--------------'       ||
> Host Userspace                         |              ||
> ===================================================   ||
> Host Kernel                            |              ||
>                                    .--------.          ||
>                                    |vfio-pci|          ||
>                                    '--------'          ||
>         .------------------.           ||              ||
>         |   | exported API |<----+     ||              ||
>         |   '--------------|     |     ||              ||
>         |                  |    .-------------.        ||
>         |     pds_core     |--->|   pds_vfio  |        ||
>         '------------------' |  '-------------'        ||
>                 ||           |         ||              ||
>               09:00.0     notifier    09:00.1          ||
> == PCI ===============================================||=====
>                 ||                     ||              ||
>            .----------.          .----------.          ||
>      ,-----|    PF    |----------|    VF    |-------------------,
>      |     '----------'          '----------'  |       VF       |
>      |                     DSC                 |  data/control  |
>      |                                         |      path      |
>      -----------------------------------------------------------
> 
> 
> The pds_vfio driver is targeted to reside in drivers/vfio/pci/pds.
> It makes use of and introduces new files in the common include/linux/pds
> include directory.
> 
> Changes:
>  > v10:

Just as a quick note, I don't plan to push v11 next week as I am on 
vacation. I appreciate all the reviews and hope to have updates when I 
get back on the week of 6/26.

Thanks,

Brett

[...]

