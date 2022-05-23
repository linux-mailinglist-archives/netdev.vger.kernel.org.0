Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A765311EB
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238100AbiEWPpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 11:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiEWPpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 11:45:53 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D067583A2;
        Mon, 23 May 2022 08:45:52 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24N3sGC3021060;
        Mon, 23 May 2022 08:45:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AHLZqqGzPIH+OlVYAxUgu65XV/eEWGXNNKIhUan9wMU=;
 b=ZBBFa8rbeo0FbkWrNzQSC/+S32AsG8Vo2TpFIs+X0NhTWF/CtrHT35F9hOMEtkfalZFD
 7GFk9R0ouucHQ6XvVW/Bqseyoztei2b8hVkE8fUNORfDuB8zNG0b+hpG3kWWkwhAgazB
 crHgam7G0iNHt5zl2/etFYeZa1QC3wQlZYw= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g6yd39bew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 08:45:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6dC/dYcH+nLSpUS+6ClH36WQtLeNYo+v7mZ4+ZaRrP0zCq/L+JJyff6R70v8uYXYoZAEWa9JOaWwKLLFs1t3yFKvRA0TEGi2TTFLlUiGU3BUHYWZbyrgynXi3/iGNfvmNEN/jHq9JpOzsF50GSTl+12PoJ+UiPrXNBf/rpAJYF/fSE3/lEnDSWLZJidl2q9VGQORhwFwl/IWnzvKCDLeGs2CKzCaMV8fbMFId74x9tYJsuO49PENZLcb2J6954nM8pl0Lk0iRhuLHxjtiUEgZLdVu5Zak0HCNKTTzRG/9jfRC5wE7K52E9yt9lKv8eQd3IjkAEwlo1LyI8gP0sjIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHLZqqGzPIH+OlVYAxUgu65XV/eEWGXNNKIhUan9wMU=;
 b=GsSppuTUMu5UWge2+AeqUA5YPigRTD7Zv0B8PmWqjtgP9sjIJZuxpcqPS5Akatk43cOxI3Puk8znUJ1oY1NtB3ucn4P5y5iRTiq0SJtXgvtcuCEHSIHaybyWJZtrz2kq3j4KkCO2RVd5Vgz3NfyiuIAusa4fCb7zno+BXUprXoX5VkOvwgrPPuff1cGugmyWQFyCqfZn84AhpQmmxnuMhJj4fZC1pcFTsCkjoH0keGbr9HvPHgsbFWAFbf8gerca35UxqT2uXiQB0DncYm5yU7mS7sEouPma3m5YEFGN2DqjoSRQsgRTwjd9738yrpWM8Air05ckCJZVJ5e2D26HsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CY4PR15MB1718.namprd15.prod.outlook.com (2603:10b6:910:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Mon, 23 May
 2022 15:45:28 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 15:45:28 +0000
Message-ID: <6b766a00-58a7-8bde-59a6-5e634ed5ff62@fb.com>
Date:   Mon, 23 May 2022 08:45:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v2] libbpf: Fix determine_ptr_size() guessing
Content-Language: en-US
To:     Douglas RAILLARD <douglas.raillard@arm.com>, bpf@vger.kernel.org
Cc:     beata.michalska@arm.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20220523102955.43844-1-douglas.raillard@arm.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220523102955.43844-1-douglas.raillard@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0181.namprd04.prod.outlook.com
 (2603:10b6:303:86::6) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f3e3e85-b7bd-4dc4-b871-08da3cd342a6
X-MS-TrafficTypeDiagnostic: CY4PR15MB1718:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB1718937C626391F3769189C4D3D49@CY4PR15MB1718.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ziqvFT3CTicEw52lMU7MO9RdmK1s6xLnWWqFwde4nHtxhLEjhC09cZMd2fcC37DHFHbJemgludGU7nw0H/88n+KS7TtfWrq3ZBovK93wjmJFwELiwGIhlbBv+6Ffy3myq7DbbZq0I6aQkornAt3RxwZDppB0qK5mUsDjyws1fVTWbPrf1+URt0DAOSYr7XYcffZordjVPJTW3E/vASiUgACAC0gCw+qz3i4nYp5+HambjCzksM4BUsK3XmZtqAPznTVTs5dRCnNQl4kvoorteuE60swcfChS0Os5mIEBADb9BpG/NKATYMOf1uc0A6c2JhTD6DGybiOonNhKHTZefD773tXy1lUA0iQNWNpe/3/stCLgXBwFxuRZVaNF/xjowLh9WTEY6K5cG6C8jxSB2GmyZXiurl4yW10mguERRzOQdZVE9LYYZN43rYtSnt2sVrVUxGdcvEdgSJRMCuMgAjA0UI9PYyCeWONIR7WV7uXTDHVieXH5wO6SBpJfa90oLqcyFr57iKXLFdU6NKbI2ewg9PF0acPEPOMKug4KV1JruRF4G5B7AkKzz1Gno8Ung/8yxMJLR5NKX0mO32xxAHFSGhhDaaHd5lZYqy1y/K58dBjyccFiFfDiUZZBO+lmTSQehlqelKlp/QKMsDso4fzcytItupj8+hCmGfwp65QuRB6vA+/9CIp5HDxet3SBE2uYwl499mhVG/xgKgO+I5y+gBUrM9UsKgcVXr5cqcnoSJtlh3xaReShbN+A17hA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6486002)(508600001)(31686004)(4744005)(36756003)(5660300002)(7416002)(2906002)(6506007)(8936002)(53546011)(6666004)(52116002)(54906003)(4326008)(8676002)(38100700002)(316002)(186003)(66946007)(66556008)(66476007)(31696002)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGlmbGl2K3BJTHlkTGpnRjQrc3h2TEQvUUc4ZDNZVmdTMnRZYWxobHUrUERj?=
 =?utf-8?B?VTVaakhyYy9wVG5sUGRPdG1GSDZqMDM2VGR4SzJ4dlJNdituamdybmk3WDB4?=
 =?utf-8?B?alloUy9HTFlEc1dBTGk1Si9NQVRwckE5NUVPVkFuMFBqQlRDK2NuaCtURGFp?=
 =?utf-8?B?SCtGWS9kTUhKblNlTmxYZW1sUk50ekFBL1IxQnNxdS9OTVl0SDRQd0hmczFp?=
 =?utf-8?B?VmZwZ3Z0dFhpS1Q2OUptZ3JsYXY3VFlPNGFqL09tTTlpOWlLQkliM2t0RFRS?=
 =?utf-8?B?L1hCWGx3ZzdTR2U4cS9nTVloMXg2c290dTN3dk9HL3YxMnl0NUFkeWI4MUtO?=
 =?utf-8?B?U1drT0tEVW9lSW5mL1hmZml3ZVpDZVdKUlRUSllKcXpuM2pqSkR0Q3JJQ2Rw?=
 =?utf-8?B?QUlYUkJTVnB1b2lKei93WHhkMVRZWWFQZ2xiVElMV2JVdWZZZTZvVnhyaXhG?=
 =?utf-8?B?ZmpmNDRWbWRwd09GbXVwTCsrTGV3WXcrd0VFTktDWnFOZ3V6NHU2akZLd1RB?=
 =?utf-8?B?KzhHd3VRaHdBRTBZMHBJL1R0VVNTYUpRZFcySEhONVdLOTUzMmJLMmJYdXE5?=
 =?utf-8?B?TG5nTjJiNHI2aXk3enVPdXhGZVhHT0FtMytvdXp3OWZrS1pwNW43M3puVkth?=
 =?utf-8?B?ejZkdENUT1JXYkp5TjV0NmRyQUdDd1J2bEs4WnIraFlZb3pwMGY4dmFMemIw?=
 =?utf-8?B?MXc0YW9NamsrNFIyVGkxRnFpTWFXdjk4QXZvWXJjcEtGRVF0MlpnOC9CZmV1?=
 =?utf-8?B?SWtUZU0wTXlGSUEwUmxUb3dJd3oxYmdrT0ZlL3VlWkhid1VuS0hBRm9FWFBy?=
 =?utf-8?B?VEgwRWRBMnZ1Vy9oK0hmTUJ5YkJ0bDIxOURIS1BNNGJ6aWg3TGdHaVdISVRX?=
 =?utf-8?B?NHpCTVpEeDFWSktTSDhSVk9BTUdBZ2ZwSlRxalh4OU55bVFXbWREeEFGOWpi?=
 =?utf-8?B?aVorelBaOTVRVW5DZllRbjM0eHc4OWlWTnNvaUw5VkYvWnVpb04wOGM4cys4?=
 =?utf-8?B?eWk3Tk9jMkxUSEVVdGQ5TDFBWUVPQlBSUzdiSERHeHpTRCtMMGpQRDVGQWlW?=
 =?utf-8?B?TUpQL0h4RjczeGVhYXBNMmM5TVlWc2ptMzVIM2ZrK2p1MjNoRC9LUlRNY3B4?=
 =?utf-8?B?dWhYSUxtcS9vRGJSSU4yVHJZM0hmNVJRTENJWFpaMXNJSXBXSXkwNWFQRW8y?=
 =?utf-8?B?a014SW05Z2xVcGtXKzgrNHVWa3AzSmVrZGFLbHVGMFRDUG1QZ3ZjbFZ6Qmlq?=
 =?utf-8?B?ekQ2RENuTjhwR3NMM29GbjlXb0xtNUN4TzlsYm1HTlNxaFEvTFl3U3hsSkNQ?=
 =?utf-8?B?MURSZkZMaVk2N0hDTWV6Vlh1Z3Q4SVpsMmZHN1R4TzZkd3F2OEpaM3dFaEpJ?=
 =?utf-8?B?aG5lcXhtN0ozTHEyRk4yeTF4cGZZU1Y5L2NnZjJpZExWRzVnRGNRUS9TQWVJ?=
 =?utf-8?B?TVp2UWFna0cvUW5QK2h1enpMK2FJcUwrWjRFTVdsQzg3MG9JTEFUVWE0UFZq?=
 =?utf-8?B?Yjh6cFE1TkRseFdsZDVRYkVtR3paenkzaWdJVnY4OU10aEZLNXFuelBmTkFJ?=
 =?utf-8?B?dmthbUpyaHJyc014VWVTd293d3VwMUZKRzRXUmU3WDQ1TkVmclBheHJBMjBU?=
 =?utf-8?B?d1dwUW0yMkkvaFhDeVllUjFzZ3ZEZStSd3hEcGhzRHJTNDFvMnJ6TTNtN2N4?=
 =?utf-8?B?NGwrRHdIQjdRaVNHTGZKMnkyNzJuQWp0cndzVHEyVU5abFg4YWV4S0hQdk1F?=
 =?utf-8?B?SjZ0UlB5Rk5ncmR4K3NPbDJTZE54Q0FyOHpSUEY3ck1MbmZFa1cwMklSdGZL?=
 =?utf-8?B?NDFSRHl5Vm5TM0JhcEdyc1MvMEVWRzBYdG5nU2xZRDUrWjdLdk1md0UxVk4z?=
 =?utf-8?B?a0h3L25rdXF5MS9SR1lVYzFDWEZhemdlOGRFSzh6Y3BtRUQwVmFJNmY2ZHJ5?=
 =?utf-8?B?VmZrQ3lsUzBLUFhCRnoxZU5aUHhYOXMwWUFpR2hMOG0yS3hzRjNPeW5wYXBB?=
 =?utf-8?B?Y0tOMDUrV3JadExRL05PYTZRUThtL3Nyek1CWksvMXpCQ1hSMlA3RUhGbGVM?=
 =?utf-8?B?YTJuNEtkUWNZU2xnQXRkRHdzTG0wb0R4SGNFQXVOWUhqcTEwS2NTemk2STlF?=
 =?utf-8?B?Q1JBVDRYUHQ5ejNjektlVmJqcE5ReGtXWk9TNU1tbHBkQkU1TnM3U3dUd1Va?=
 =?utf-8?B?R1prWjNORHU2ZUR0MG5jUU13WFlsVVpwOXdjbHRYSVJ0QTRYKzkzQTcySlZi?=
 =?utf-8?B?eFJYaVI3UjVadDZ3WW5Odlgyd1YwU1FUTWpydjQ4aVVFelRIbVFqWjQ2dlp5?=
 =?utf-8?B?MG8rNGxiaFF4cDFLTjR2UGo2WXJwUC9PZElNRDhwR1lOYVU5TjdmVUx4dUR5?=
 =?utf-8?Q?EJlTbRlEvktjvVyY=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3e3e85-b7bd-4dc4-b871-08da3cd342a6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 15:45:28.3615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NO8sm+Hj2cWCmWzwSVFSlA4iEpoR9cmIgz+VKGJNVDZz0Pmvi5msSiboGtnj7ujz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1718
X-Proofpoint-GUID: OBN7fbs7AUGz7HT8ve5IsINVOgCyaGP3
X-Proofpoint-ORIG-GUID: OBN7fbs7AUGz7HT8ve5IsINVOgCyaGP3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_06,2022-05-23_01,2022-02-23_01
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/23/22 3:29 AM, Douglas RAILLARD wrote:
> From: Douglas Raillard <douglas.raillard@arm.com>
> 
> One strategy employed by libbpf to guess the pointer size is by finding
> the size of "unsigned long" type. This is achieved by looking for a type
> of with the expected name and checking its size.
> 
> Unfortunately, the C syntax is friendlier to humans than to computers
> as there is some variety in how such a type can be named. Specifically,
> gcc and clang do not use the same name in debug info.
> 
> Lookup all the names for such a type so that libbpf can hope to find the
> information it wants.
> 
> Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>

Acked-by: Yonghong Song <yhs@fb.com>
