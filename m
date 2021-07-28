Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1873D9923
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 00:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhG1W5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 18:57:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54164 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232163AbhG1W5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 18:57:45 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SMtNew006866;
        Wed, 28 Jul 2021 15:57:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=m6IM1GIy4g78JMiLdslj6GZ19cVceUSVuBNLkcQXMbc=;
 b=NAOd3/24kmc5LZ3bllPTOjC8dMTogweR9U4BjJ130VW9vRyXg9vjLWtiSLFbYszviubE
 SwFwNVQkK86aw2JiKclmUBbPd31lmo+pEb8hIMHHqlzEmUQX6p/zQIe+xhmGcKyAk64o
 EmCa13sUuA8FiyA4ai2UBPXmFZIW9FI7XVY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a39fvjuen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 15:57:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 15:57:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+ocHe6GYsnm99ddGhG1oZQmha38lexIla/3T4xMhCtnaYptqCYGR8+wr0A6QVnrocXYFoDgiTugw57uwhUQ7MzYn63tSCu256c0LFmOua5TnXTI9cy6SsmHp3gMXJzHA8OGScyezE/qtO29bYDWzJShG10A6/7QOr6bnBhDu91sru9uaOU8Tg4xSGcAbelpfeJWXnbS1klZiw1lUmWtdMTDVNJFI6Hat5FDQKrCqUmOEMpUappgeBZBrU9MRAcw62g+lc65ho+41OnjSt9uLobfDAE2oee2bK7tUtKP7yQJ+dKkbB2j8W98zgkc7Auojq7/gt5KmcnnZ49Zun/4mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6IM1GIy4g78JMiLdslj6GZ19cVceUSVuBNLkcQXMbc=;
 b=NjRElLthpgqMeWBGT9RM6+Ief4PgRhSRqt/3/HHMtxpLdD+11fcJgjzDml50JZFB4M2G6QlO9HSqgrpjVoDGmdyngY9eHEpMk2+0TZJusDCLHu7DGghdlqM15iqCjt7VlXiObMmk4lVE9kjkHS8fQ8nZasx087AuHz+BafTtoP0pTqdbb6gRobW9Bf/8wdd5mv7PuIymSmiUVxQt7b7cWMuFEykbZuTpHYX4chELExhFKWjqCLtbZlnxmFmdcxtlaAKuSBGzawTHG9+GGNU123e95leHsPvz+X6h56R341WdEuC688cJLu05nOtFCo2IqQ+B9XwzvDT+lB6nkYTzSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by DM6PR15MB3098.namprd15.prod.outlook.com (2603:10b6:5:13b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Wed, 28 Jul
 2021 22:57:27 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::b0e1:ea29:ca0a:be9f]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::b0e1:ea29:ca0a:be9f%7]) with mapi id 15.20.4352.033; Wed, 28 Jul 2021
 22:57:27 +0000
Subject: Re: [PATCH 05/14] bpf/tests: Add more ALU32 tests for
 BPF_LSH/RSH/ARSH
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-6-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <44c4b2ac-d6c8-509b-7076-e802de2cc8f8@fb.com>
Date:   Wed, 28 Jul 2021 15:57:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-6-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0004.namprd14.prod.outlook.com
 (2603:10b6:300:ae::14) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by MWHPR14CA0004.namprd14.prod.outlook.com (2603:10b6:300:ae::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 22:57:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb12f038-c505-4d6f-ae0b-08d9521b1264
X-MS-TrafficTypeDiagnostic: DM6PR15MB3098:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3098FB780396CA0E409E9918D3EA9@DM6PR15MB3098.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 45knmd5Klog0fhcwue/U8LzihLgJgUKogBEMWs+TFjG5DpbKjJ55uVTwyVgVmUXcyL46Qx4q5czX6TQpJ1Q1wGomL37YL8JCRiAY1LO+E9vw6KjmNvT24FXwMXuUZtF277A+sjxrV0ahyizkOJF+FQI1Z+cwr3H1QNnDqOwDEs/6Zt1xEWnZgNf7MxDyt/A4N7LiPQpduIPjWb4tgdYgAtJLAolSrgtn6MLq46gmOq/cnYh/j15I/FaaJ5kV30mmwBqG/DqWObCh3/lsYWWUFKEQLe+Yyu8bJ+m38MeKdQ8Ba/JZvZFhutlB4Bfd2TPRGI11XcmC2exNM7GRSRONdjWm53RfhxjsOUMp/OK3IbUSUSeQal42jjP6912oHFvWhKOvZWAD0eOZiFqk2KcGnFGm+pXIxsmzC7fNT7dWvi/A+gJMPSBOQijFXmXMuOMp4GcZFh1dOHEhWB/17g8DuZoQMOrxqfLjSKGwfINb9o05kjmEGtKOAhKRiEWFdO/+13lhz4wIWG+ueRhw481qYfu1ed5Jfxf/oRj/yrdBVB3+axQAMZHjVjVq/OargJ2rTRe/whPOdRaHIdboQ6p9z0tqFhAdPA8K55WVEcQ/+Y43hfGJC9SB6r+m1SCYIvoarkRQMzKa9F+GAuA9ushSFJ1JoYJUANnNUZBi1rM5NTCx9RWz6Qfe/oC41k8UE35FLI2ZDiqewH8FGdiR7rNPml351K6QQNYq8p/G81q3yF0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(66556008)(2616005)(52116002)(4326008)(31686004)(66476007)(53546011)(186003)(31696002)(478600001)(86362001)(36756003)(4744005)(8936002)(66946007)(5660300002)(38100700002)(6486002)(316002)(2906002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGF3djJxeWVHa3lVWTdNaGZyNlh6Q2NCTGdoUXJKMzBoY1hrcm9FRXRzNFVj?=
 =?utf-8?B?andjVlVaQUNFU25LUVNTVXZjS2UrMkZJWHZVZFRGS1B4dmxKb1hYR1V0YVpC?=
 =?utf-8?B?YTZiQS9rRGFpNkVycDh1SUpGeUdxSlJhVTNIZXFTL2J2VEpjb09ZN3JVYW80?=
 =?utf-8?B?dUx5NnUrU3RYcnJEMS9lOFRHczM1c2lEMnpYbGFzMzVQY1MrdEM3R1dobExk?=
 =?utf-8?B?VlYxejJUSHFNS2JzSnBTWitFQXo2bnZVQlozMUJDQlVNaGQ5VXhSWDFPdnBU?=
 =?utf-8?B?UGx4VmJaUHZZWWpEallCbWpQSHRyRWJoSnBlOVl5bXpaSm9HV0NlSWwzb29Z?=
 =?utf-8?B?MFBRY1huN2hQejhtYVdGOW1wbmw1UzY1bHYrRWh4cEJ1K3Ixem5GamQ0aU55?=
 =?utf-8?B?TE9WS0FqeWsvY1J4cm5PVmVrNC9COE54S2xaNXV1eWMrUEVHY2NaUElYemc0?=
 =?utf-8?B?V0t0WVFkZFVlbmo2eWNLa0tKOEQ0NXp5cGwyZmZpeFEvaGZUNkh0NjBKT3FX?=
 =?utf-8?B?QkZpVnlQdGxLZ1FOTzZocEhPbEkydkVaR0RIZG5EdVlXMjhPdmtnQnZKb3R3?=
 =?utf-8?B?eHlzNWRBUGp0NWlLQ1ovTUpEekVPbHI0T2lHZ09wZFNvUTY1SmE5d012TVlZ?=
 =?utf-8?B?NFo1enIwSGxXeWdVQW9ySlRqQjJrSEs4K3VUM2JpcTRhYVA2YnpUL3NMQld1?=
 =?utf-8?B?MjdXUlVoVUtBL0dpOXFkdmltV05YbURpcVFlSDJwRFpINjJObmE2alJ5RVo1?=
 =?utf-8?B?YXhNdDBaTThCbVp4UXV5TzhUNGRpUFlaZFpFVGRpTG9XMkRrRjhPWTYwYmtx?=
 =?utf-8?B?ZHhHR1ovM0RCQVBrSHA0Ym9zam9hL0FKZ0FGeXU0UDV0VkdGRUFFTHNtbkdJ?=
 =?utf-8?B?SngvMzBhNFIwVWVxWUlvTmRDbjVvL2NoM0JNSXppOXJ5andWUWZ0T1U5dWhG?=
 =?utf-8?B?YmNKdEluU1VOTHM2a2FrY1htWExONmJPdlg4eGJja05MLzJ2VjV5VFV0YVhm?=
 =?utf-8?B?VStEQkwrVTFici9BdjFNcE9QckwxVnBBY29VU1dUYkRDaDN5UFppVTZCQzVT?=
 =?utf-8?B?aFZSWWd0cW0rQXIyRThxRHVBd1Y3bUtKL0YybGVNejduU1Jwamd4VHk4aTIy?=
 =?utf-8?B?c0l6dHk5dVNYTjlkMjRBRlNUcCtvaGgxaGFqVmwwUTRHNUtwMmRhQlZUSnR2?=
 =?utf-8?B?ZkNKb0ZYN2I3cDJ0c1dxTXdYdkM2N1RDOXBMYkdjT1VZWW9hSE9oYUV2aTNV?=
 =?utf-8?B?eEFCTWJZS3d5RVFMU2Y3M1lTdStEL3U5bDVObWE2MGxRQWYrZm9peUNJclMw?=
 =?utf-8?B?N0kvRklCdzF3WktRcGRWMGNpS0tlNnNUSUVZTklPMzBrdDFLTU84NSt4cUFq?=
 =?utf-8?B?MGloakl3SGcrQ2xnb081UHZIZHRPam9YV1o0ejJFL2M5d0JSZGdpZkxNbDNx?=
 =?utf-8?B?blJhclI4VDROMWhhZnhlOUVRVHhDTkpDcG5QM0M1YThXL1JzK0RzTFoyWjJO?=
 =?utf-8?B?eWw1S3dLTG83eFh3dnVkRUJkU0RNb2ZZdDJmSU1PUVJmMnFpY2UrR2FjL0tj?=
 =?utf-8?B?TjVETWQrU0ErVE1wN01sV3dONVlQRWdvVnZrYUowc0xVR1F6cjdnQW9DRFlh?=
 =?utf-8?B?YmhGdklYUVlrMEZnL3ZBdFB2U0JiamNFcVBacVJEZnlZMkNhZ011NjZpS0Zx?=
 =?utf-8?B?OCticG5DeFM5M3NWa21QMkNwTmdlM0YwNitCbUxham94WkFGME9uMDhzc2FN?=
 =?utf-8?B?MFFjdWQ0aHR5dU04bHo1UUhycEhhK3NYcjJaaDIzdWNXNUY0MTNiODNnQ29q?=
 =?utf-8?B?NzFjNWtIcXpyRmowWThPZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb12f038-c505-4d6f-ae0b-08d9521b1264
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 22:57:27.7967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dzeIVcT044jbYaKU8j4J+GqyxIQ/PAYC4oU67liqhFIzjer2zaC2HDy0pzpg3MxC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3098
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: jlo2RGce0gzQPiDJG1ciV9GlUgmcFctL
X-Proofpoint-ORIG-GUID: jlo2RGce0gzQPiDJG1ciV9GlUgmcFctL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 mlxlogscore=701 spamscore=0
 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> This patch adds more tests of ALU32 shift operations BPF_LSH and BPF_RSH,
> including the special case of a zero immediate. Also add corresponding
> BPF_ARSH tests which were missing for ALU32.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>

Acked-by: Yonghong Song <yhs@fb.com>
