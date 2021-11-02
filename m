Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FBD44348E
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhKBRaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:30:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230214AbhKBRaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 13:30:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1A2FoTak015369;
        Tue, 2 Nov 2021 10:27:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BodZDst7CzQ/ZjCgEKzfgzWETvDpRacy08DAvB+oLS0=;
 b=MiuhOts4nEDVmqUnMjSvLetArMnV9jYoF9Z+ZjtufT6Fdls/F68gXRv6H9weHCtd0Ckw
 ywDLPr/x88cfnpllXgwIDrSTL0r9W9LQZ4vdTJAXkRCEauw+geZc/s0xtoWxXfV6fTA2
 Ue+zFvUXhd+hyP1RRHkBuA0orIwzJbMwO5Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3c2xy6vejj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Nov 2021 10:27:13 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 2 Nov 2021 10:27:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hF7QEeniuvAUS/HYn8QI8auJecy6NkroqfpWUgwzv1uTY6xJjBJtMJQ6UbTX62qmckJ8c9HcFN9dJ0OHlm7XjKY8tke8ZU/6eTwMvWFTWs0ppvffkT7h9z8mHTB3HnwEQbnfu7+AdQXTi2duM9nid4TbIqHjhZCjb2FC8DgNIyOlTwQj1YoH6njtHSYHqipZF4K7LYRn+9uf51mBH9Wj3FKa1OJzPhQ5sH/H7ZFMXI3b9+zdsvsEi5funCbjDXT0+ymF68A4kFkgILlO2o/XGjFS9wOqco0qYwycutSaGXKUylRUEdAudK+kK7mifAh/8WVGTDO82pFfyZstoX8V0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BodZDst7CzQ/ZjCgEKzfgzWETvDpRacy08DAvB+oLS0=;
 b=RwdFS/v5PggN6HwO3jLRqjvRzxfJeEmGT4ef/6myPI0OGVFI4A5G4V87n8v5aF8qH0k/MI8tu9reTFZRs6uOHIk2okiZL14+rDU2SVg/BkLhNBXtpb8ja/cSaB+zz0lCHDf4iwnKmYQ7sWRND+zHebVqYjJfH7V6TBXvAoI17PUo/47EvJg96GLQ2zf90SMVKAEypz4v7Bp3SkOZoL4LrVCL9/hQgtaimUfnyqpIF8qITOG33jr3AQ75NVeaAmCF+W/Ril6TmC+CfCAV36p/8IV4VQW3lmyHL0QY82+45P3LOr2RWpPxtf9DAz16ajU8au77vbI8vePClzBcFDaOCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2030.namprd15.prod.outlook.com (2603:10b6:805:3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 2 Nov
 2021 17:27:06 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 17:27:06 +0000
Message-ID: <9537f384-121b-744b-cdfd-0a3df0fc713e@fb.com>
Date:   Tue, 2 Nov 2021 10:27:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH bpf-next v3 1/2] bpf: clean-up bpf_verifier_vlog() for
 BPF_LOG_KERNEL log level
Content-Language: en-US
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211102101536.2958763-1-houtao1@huawei.com>
 <20211102101536.2958763-2-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211102101536.2958763-2-houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::198e] (2620:10d:c090:400::5:2e35) by MW4PR04CA0259.namprd04.prod.outlook.com (2603:10b6:303:88::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17 via Frontend Transport; Tue, 2 Nov 2021 17:27:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe280d74-d636-4169-3137-08d99e25fe0d
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2030:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB20308A65D1AC23F8210C6293D38B9@SN6PR1501MB2030.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGgfa35QPLzh5vnrHH94KqO+5y2zoKGGxK5BR4jxQynoZrep/h5fE+2RLu1fXO2BnB7lM1ogbPmJzgDPL6QhkrQ08SBQw7Z2THMXnV71bGypCaBIi3ZXYqhOsoGJIGMt0aETBvl4W8dTdQ0FIQVsvCyOAVi1UzV52hKa/SME1QJ4jFeKcdlid+Dx+erWkRgZmbZ8xuQt775uvfoqJOExhOejy/fBmaX1Fd9e87JiwR9lgzAduNChJQCgG3HmeRXYmsRTsmI2WNrfmQ+h2MVlvUY6bfJzcSFsfsV3ffhg0DIg1zRK69MHdflcr1sD10XP+M2EFxDlmJQM6AFEx628JczT/GJpuL3yD4nQ7ZBW5t44FpsZH93yJje40eH8xOkWknWL52Hc9VrUE6ysJTWktHHsCWW2Ad6BRoRTRa9lhSWQPRTrHLsLA13ordC3/+RcEemsm/LEZxnQ+MgEbu7RhmeHt/4QSvm6CSp9vhsqukwoFu4CaeKrS4gJsR1fxyuOpk5DgbOt1OXUydixjXoZmZee4NcGdPgwHAbb/ely9W6v/LXm6OmbKCR+LKMmh3Yb9DTZoHk9CathUKuCn1WmusFaSfMjWX00FxgC9GcgbLfJxPVuHAN5P9kibEQ6PDxmUeIQNvQ5d3xtNBFhiEN4dSc5UwpWUY+HA73sjR3rrGOLSKKDODC1zJm7qQjaSmOP6A+gU1WH4469r/+5DZE3nhNaaFOCDHNryy6nLwLxojw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(508600001)(186003)(66946007)(8676002)(110136005)(8936002)(54906003)(66476007)(66556008)(31686004)(38100700002)(2616005)(52116002)(86362001)(316002)(83380400001)(53546011)(5660300002)(36756003)(6486002)(4744005)(2906002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnZtQ0NrVXpjREltUEdXSS9jWGtRY3ZOaWEyT0c4S0p1dXFhdy8wekhVL0Vh?=
 =?utf-8?B?UmNpZUgwcGUzV1FHclJWdFBGNWYzQlZMa0xtK2lLOFlTOEhwbkQxNWZSeDJv?=
 =?utf-8?B?c1FYOXl1ZDVnMFloNUtja0JMdFQrTkU1T1RLdXFWcHNzS0FoajNQdlVuUklB?=
 =?utf-8?B?R0d4RG1lcmxWa3N2aXliY1ZJSURia0pCSTlpUm5OcFB1SlphZVpaT2IrU3dJ?=
 =?utf-8?B?VEU2UkhOamthUllWeWJIeDRpODNqTWtmMWhBazFxSkZBNFBVb3EzK3h2Tk96?=
 =?utf-8?B?TWVtaGtpaXlnYnUwbVQ2S2h1UGNXcDFoZGZ6cWhrMjgzODBvd251QzMrMHVP?=
 =?utf-8?B?THhIQmV1TVJ0RVRleElFQUE5OGtLbHcxaGxQQThjeE5sREJCa0s3akFVcTgw?=
 =?utf-8?B?Z21kWmtYVFd0dFBMQVhoMm5KRTkzZDNvQ2Y1amduWkNOMEt4SmthUHBDVW02?=
 =?utf-8?B?NlRya1A3aGtWYmJjYWJiUVN0cmI1RnU1VHRTWm1vQmlPdEhpTUhKdFVNSG4r?=
 =?utf-8?B?ZnVtc1BHWUlYOVNNYWJsVlFhQThrc2c1aW1VL1Zoc2RqNHdJM0hoek5RRUZT?=
 =?utf-8?B?NENYK01FN3psTU1wazhtUVNGWEIwVzVvSUpaeWhHbWlSWXZaazFWWHpJWE5s?=
 =?utf-8?B?V2VvcSt4T3B2aWpoYlNMSmFHZkNvOW1QT3VBMGFZRW1Qc2NxUmZldlhKZXZ1?=
 =?utf-8?B?RnZuZ2RieUgzc1c1NC9PV00rd2xSNlduS05RMkdXMDhzb1ErNkppRW80QWdi?=
 =?utf-8?B?bzYwYVhPREI5UTBUYkFLWUE1U2ltU0t3elBEZmIxd0EvUjhjd3VYVFFMSm1E?=
 =?utf-8?B?c2dhcWpsa3J0N1dobkdpSGY3WGtUVS9NNlVROXg2Y0JoV2VFWTU3d3VScWNn?=
 =?utf-8?B?bVVLSFNMWTQyRm02S3Z0RysyU1NtbGo3OGhsVXdMTHpFSEpYaENXT2V2THN6?=
 =?utf-8?B?em41WGxVMDBoUWc1Ni9JZi9qODljRmRiR2w2eDBIaVdGZkRrdXV3c1Z3NW5H?=
 =?utf-8?B?eC9yOGtlbW1vZFVyUkZFY2FMZGhkL0d4bDI1OVMvYzdOcW1wWTR6K0dxSU5X?=
 =?utf-8?B?MFpYbVhRVmErY0pBc0ovQmhPU2V5SjRkK01haVhuYXUxOVkzMUZTaWxnaEhM?=
 =?utf-8?B?VFNxRTVxdzhTQ1NXc0NUVldTVDR4WFQ2U1JsV2dnWDU5aHRZY2FKQlVyRFo0?=
 =?utf-8?B?a3hjR0lSbDFDb3VWc1NGTWdjaVRuR1U1OElGVHZrWXFpV0k3dFowMlkyV2hF?=
 =?utf-8?B?NVhGRHg0U1piTGc3QU90ek53dGVodGhoNjdzOElCKzRHeWN0QU1ycGZ0VDg0?=
 =?utf-8?B?bUV4YVRkdXhMUzBuQ2RHWTlNM043THJBazlMem5sRGJhRVN4b053UGgwc2J5?=
 =?utf-8?B?L2I2ZjEvYTJXR0JtZVhjUjlJcmxSbWtNN0wvdjE0ZUcyKzdIeWZ5VkZ2UWZO?=
 =?utf-8?B?MFYxNm1wVENyOVFWa2VKNFpHZ0N1d0EyZkZNd0luS3lZdlc2MUZ5ejN1T3h4?=
 =?utf-8?B?cHVIZ0I1akowSjN1NVpyS2JEY3hxL0Vva21yNHpsQzdaMlppNzJIQnpwZ1ZL?=
 =?utf-8?B?ZndoQVIvWGpNT1ZEa1pMMFdETTkrclo5RFNQQmM5MUlxUDZ6VkV0UmhFR0Rt?=
 =?utf-8?B?N2ZPR21uM2JXZk9xMGVXZ1Rpdmh6eFR6WXRVWEQ4M3BudStUN0tZblk2WUNs?=
 =?utf-8?B?U3pBU1NRalZFT2htdkpGR2UzaFBDS2dEMnFZSUF2N0lRQThieTdic08rNENr?=
 =?utf-8?B?SXp4cWhhVS9NaE5SYmtEZTFITWNkSXN4MnIyTlF2ZWoxM1VxWHUzSk4zYVln?=
 =?utf-8?B?RHZvclJ2VkRlQ29aY25WNlgrbjVBTlgrRVhpT1EzQnZzUzZSLzhJcng3TjRs?=
 =?utf-8?B?aXIzOERUVHBaenB3UDYveC9JdVNaQWR3d3EwT0RWRzRNeENUMUc2dXI1WDhH?=
 =?utf-8?B?WU1YTW1iVFVvTTJ2NDlIN0lWd01JTmJ0cUxIVk1nTlR0T3liV2wvRDY2dk1L?=
 =?utf-8?B?elJKSVM5VTRrZmp4L0NkMmcwMVlCalorR3loNC9vUnJjSXpNcjRBWkJiTnhR?=
 =?utf-8?B?b0tobHpGQzBoQ0NVYTU3Y3g2NEl4OWlheWoyL0sxbUFXOEpaNlpkSDdaYjlr?=
 =?utf-8?Q?zWIMAHhWip33NBzTQydrCU/wl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe280d74-d636-4169-3137-08d99e25fe0d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 17:27:06.4131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQksYNyw/hP/P1bxBvgMdZqHl+A2Q3uqwK4JHbukny1LP3hbb4fppyWlzYMKsZKd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2030
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: VVjQAhxUPg-iNcsewVMftONlLL--GAjt
X-Proofpoint-ORIG-GUID: VVjQAhxUPg-iNcsewVMftONlLL--GAjt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=978 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111020099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/21 3:15 AM, Hou Tao wrote:
> An extra newline will output for bpf_log() with BPF_LOG_KERNEL level
> as shown below:
> 
> [   52.095704] BPF:The function test_3 has 12 arguments. Too many.
> [   52.095704]
> [   52.096896] Error in parsing func ptr test_3 in struct bpf_dummy_ops
> 
> Now all bpf_log() are ended by newline, but not all btf_verifier_log()
> are ended by newline, so checking whether or not the log message
> has the trailing newline and adding a newline if not.
> 
> Also there is no need to calculate the left userspace buffer size
> for kernel log output and to truncate the output by '\0' which
> has already been done by vscnprintf(), so only do these for
> userspace log output.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Acked-by: Yonghong Song <yhs@fb.com>
