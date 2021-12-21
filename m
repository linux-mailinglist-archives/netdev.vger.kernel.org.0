Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7032F47C8E5
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 22:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbhLUVwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 16:52:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7892 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230251AbhLUVwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 16:52:40 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BLKlWWW001042;
        Tue, 21 Dec 2021 13:52:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=WgfdbLCcvVJZmXNe9ofJ06npNWyFPUTSWZOHHEAzjqY=;
 b=F7s/XlvDYivmZ73N2iAM+RumNUsvKNA6AkZTP4lpHTO5giCi2dDy+irpMfQq0OiYwrSx
 cVzFUohymWuwD0C99M1XeQ/T1p07aJX+Vlk3IhYZUd8ThHsXtQVAvtwjVNiIFFiXAbLt
 2oTfdJkYmASNemJaUKA3DbtiTuspBwCN5TY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d3p930es7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Dec 2021 13:52:34 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 13:52:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqGjwQgIrCp9qb2eWl2pYsIDPEQfrxBSf0Nsrum+9mHMf34J9maORo9NccrwDnGnLoIc6kfo+tS1rpn5jCE9wGNkUoMQyCaSwsptkCJXqKK3KNVLKzlFoaNcFGaOGnesHsw9y2nEAYJF8RAn67+L85IWiLez2k4ywir6ZRyh2zNZMJqxrNUEmZeQTI+KCe4yOl+Y6wB6Gt71JV1KkCUiZ5UaKIMPyZwQolrA9DTo+KYAXMfAqm7N9WXhc7qDRqwAIAtQIwr816K6l023f3AKSwtnOXk237OlvBF5vLyFeg48yRp1zmVK6Br+tTvbEMTC+xN1WE1qRc2aj40mJvNBQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WgfdbLCcvVJZmXNe9ofJ06npNWyFPUTSWZOHHEAzjqY=;
 b=fgQ8KyoxxQ2J5a2imwj9ayqbAT6tDPKq7vp+nB8OCL0YSVQEhpZKz3BeNYPQENLYTbgMR+KplADnjQ19GCuuMAY59+ZYVGEdISTIqnag0t2e8ttWgMH94QXys06LLc9TuoNrlNFjf3W9zJGyuRHdq/KJBYcY+zEvAmNV7ua3dN4BNsD3lyKEApZzd1tokVS6RdXymevYmJmzkSPPdL24fjXPtzAdSseGr717h4m3ARXdgex5O/23SCNurxZI1hhj7wzsUzwr3Fm+Mcrq3kEWbBu9HWSxaCYMfWV4l6glB3cksjvh0XGbrVK0rweqfJ4Bd8uFMHW+62ZEo2WhLISyLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB4125.namprd15.prod.outlook.com (2603:10b6:805:5f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 21:52:31 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 21:52:31 +0000
Date:   Tue, 21 Dec 2021 13:52:27 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
CC:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
Message-ID: <20211221215227.4kpw65oeusfskenx@kafai-mbp.dhcp.thefacebook.com>
References: <20211220204034.24443-1-quic_twear@quicinc.com>
 <41e6f9da-a375-3e72-aed3-f3b76b134d9b@fb.com>
 <20211221061652.n4f47xh67uxqq5p4@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB5238740A681CD4E64D1EE0F0AA7C9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <CANP3RGeNVSwSfb9T_6Xp8GyggbwnY7YQjv1Fw5L2wTtqiFJbpw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGeNVSwSfb9T_6Xp8GyggbwnY7YQjv1Fw5L2wTtqiFJbpw@mail.gmail.com>
X-ClientProxiedBy: MWHPR17CA0088.namprd17.prod.outlook.com
 (2603:10b6:300:c2::26) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea4ed74a-f9e3-41e5-5842-08d9c4cc2fe7
X-MS-TrafficTypeDiagnostic: SN6PR1501MB4125:EE_
X-Microsoft-Antispam-PRVS: <SN6PR1501MB4125E0164FF9E6C38FD40CC3D57C9@SN6PR1501MB4125.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a5Ijtnj90BmYSRpBRkBaej3k61cnH8/ZnlK8xP0PS31Ah1rDO8apSy/Smm/oKXIL1xDuTrbZdaGc3g0NPh6YpvMW4+/KXPL18f3q+LE5r71zn1CSitcu1G7zOGdXLI/DEKju6pCehcJP5gd7WdENxEWFVhRKGcVZ406cp5Z8E8njXSIQJ9L2UiM9TbDOk6O9c0WCjAVBlKR9UdEddT0g5n+OWh6ak9Fb+2GcGDNW7Lodu32K2wA3SzRgcC8hwm6PCd+uLgtnH4gYyRWpGO/J4XNS0WBEOJNSNYLPmVqa9pBq0R8qKy0XhV5VNF+ISyMEZB7veRM2EI7Uf7k4l6JnGwZez2mbUJ1xp0iYnWApQkVFb0+OVtkBcXBGhG1hVR/r+TlwX05l7RmhMj89zHSIPQvfAibAfQ3/Xmi9M9KX6eMHS7EDkXxyJfRK/3MHIpuA98iU/xJ2OmTAKnoLjrhNy/xJ3JqnghMKRnTamjdt59uYHixtWX8XbYE/KPHcypssbXnb4ouMN8L0mucyjZpPkZAJ13sxDXG9d64BoZMYswBfK+njWfHyiQ9a3vd+9VLjZfEy8W6xSGRh9OEm8m83GznZJuCnELK3uzXPEjlZy/hmMXiO8dKVSPQ4sSLrXVcmMQxgJtYIYHZFpmD7use7Sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(1076003)(66476007)(9686003)(52116002)(6512007)(66556008)(508600001)(86362001)(6506007)(186003)(6486002)(38100700002)(4326008)(53546011)(2906002)(54906003)(6666004)(5660300002)(316002)(8936002)(6916009)(8676002)(66574015)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVpDV3ZIMTFzb3lXLy9PSjY0Z3dYZnJDUG1YZENFZklzelF5V2VFUHlOMDNI?=
 =?utf-8?B?dXkzV0JHaEdWemY4dTF6blF1RGZwZzREbDVHU2lHQVhYMDVVSWJ6cndUWWhw?=
 =?utf-8?B?SzRmSndtMXMvRC92VzMwWlhJc1FKOG5Qa1FLNnErMFNBaHVlOVpnSGZFV0ly?=
 =?utf-8?B?cXV2eDZhVlFhME1WS2VkOTVTdTFlN2xUYzY0UmVWT2syclBHaTFxQytBWE01?=
 =?utf-8?B?Z1BZWHdLSVFkVVdQRmo4aWhZZlJjZFg1SUFmU3ZPeEZMclRCbWNqK2g4eTY0?=
 =?utf-8?B?WVYwSU0zSFB1Z1AzOGRMeDJ1SGFlQTM2YkJkUVRVSjJ0a2IxQzVSM2lja1lY?=
 =?utf-8?B?c1FxOWx1U2pSZ3VWV25NeW80QUpTenVhdGpSdDNLYU9rQnZtS0VWSkFjdEV4?=
 =?utf-8?B?bHdoYjNDdDFBYkdKeGIxWUlwRUtGdWpNMXFLTzBxaGsyMmRJQjRmZFBMZTkx?=
 =?utf-8?B?NVlBTm05YUlBZFBjcjJCOGVEajFzU0I2cTJobjJMY2pia2dqRFhPSXY3VzB5?=
 =?utf-8?B?TU1WRkRpTzZ2THVmdXpWdm1xV2JKNWlpeXNEUmtZR3Mza0ZYL3VxZTUzSkpJ?=
 =?utf-8?B?bFR5Y2l6aTQ5b2tzcHNjYzNIbmQvQVV6MkthRExyN09jNTFSR3M3MkVmQUxy?=
 =?utf-8?B?MFgrTloyZlBHbmptRXZYdkpoci95NGw3czFIQktra2NGN1FNc2ZtS0trTXBu?=
 =?utf-8?B?V0ZtNzZIR1JFZlBoNjhrZGw3ck5TbzV5RmloWlJPc0dVYkcvNlQybFdLcEpP?=
 =?utf-8?B?eFEvcW5uTk0zQkEzaWlMMWMwRFFpcDdjMWhJZkJtd296WU5tQ0xWcFBVUnJN?=
 =?utf-8?B?bzBPMmRraEw2eTZjV05SRWpXaUdVWWdWV1NPeGlDMC9DRGNCa0YveEw0VzdC?=
 =?utf-8?B?WmNLcnRibUJIQlR4UFJ2eFg2VzhhUlM4eDlsS1IzRnJpZUNpY2RlNSt6Yk1W?=
 =?utf-8?B?SThSVU5uWEtrU1drTHQvTGx3NEtBYXp3djhDMHhhaFFVMjBSaENScGJRRTJF?=
 =?utf-8?B?TzFBSFlJUXBEUE4xVUZJcENMYzFqcDUwZm5xc09VK0JFOE13algzRmRiamFF?=
 =?utf-8?B?Sm5PcXRGbkVYVG00dmJ6dUdKRngyZzVMUE5VY0tEdmU0dWk5ZkUxTmpCeGZW?=
 =?utf-8?B?MVhEK2lBZ29iK1NBS2VpUVBhWmN2SEdIb0pqZkpmVU00VytudzByMC9HbzI5?=
 =?utf-8?B?SGlGSWpiT1R3eWVZT2s3ZGI2VTM2VS8wdmVHYkRaMGlyZDZwSTRkY3Nwcnh3?=
 =?utf-8?B?Wlp3NWJsNCt3LzlCdmxXb2piNTJUUXlKeEY3MFFha0FlMThTQVRLOUVlYlNH?=
 =?utf-8?B?elRZVm1pQkdoUHZ1UlNEWWFnekNaekFlUDBtbURXdERMWm1LRjhpeHlnUkNz?=
 =?utf-8?B?YTJqTVo1eE9KZzErVm10dXNDS01rYUd6S281TCt3SVkxVGgvTmZRVnVoY2VI?=
 =?utf-8?B?K3FCUzdWOXlJSVd3ZEZ5UEVKbVliMmNHbHg1SkN3UzJMSzNBQ3QzUUt6bWg2?=
 =?utf-8?B?a1owYldaQ0dDSGQwcnVTTk1aY1RCaFhMV3FKSGFZd2M2eWxvYkJ2bThiMk1D?=
 =?utf-8?B?R2M4aUNDdEtEWVhBbmR5ZTcvaEFOZnVxWW9mMldxQ1RSUzdseFZRWHpjYWdN?=
 =?utf-8?B?ajRsSER3NFhacmFJRkdxL09wSHgyazNWdVRtR2U4NnVUclFTN3RwcHZqQXFu?=
 =?utf-8?B?czNRd0ppdzdpOVI4aDBLRnczbExUNnJJSzNRMFErTGtiSUNFZW54K3dmUFVG?=
 =?utf-8?B?eEFaVnRVb0oyNHIzVTcrM3hxRHpralRad240WHJZWDdMdmlib2gwREMxWnJo?=
 =?utf-8?B?cEx4cnFKK3pxWkZyQnc2blBMK3NVUHhlcWw4WHFMQkJ4YWVhNUZnS3VkQ3VY?=
 =?utf-8?B?SGE0bW44OHFvRUUyV2FKckEvdS9EQnZrZmRNQlQ5OFdsOWxoakpMT0kwZlhD?=
 =?utf-8?B?WXovbEpRUGhwSGlobDNQcGkyWkttdmxUbmRONzRGNzZBZXZiRzVoUnF3aDh2?=
 =?utf-8?B?cTE1cFk2OUo1Z1cxaWpQZUZKV3dST1V3VGJZYlhqd0VnaHN0bCtCT3A1U2Fn?=
 =?utf-8?B?MnpYSUlFT2dKSXo2S3MrV2E0dXN1WkV0Y1JpUXowZkNRUXQrdXZHK3VCbmRt?=
 =?utf-8?Q?HzKIvuzMlzlZ9/KxfRcQSARi+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4ed74a-f9e3-41e5-5842-08d9c4cc2fe7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 21:52:30.9880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9qKmi4GJ5CVIAgn5JUnprSXYkb2xF/G8f5/7gYm/adkInfTIWF/JcFe9Ks13Sr88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB4125
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 6HJNYNmJKXxn6zl9d3L0sO1xjKTs1HvR
X-Proofpoint-ORIG-GUID: 6HJNYNmJKXxn6zl9d3L0sO1xjKTs1HvR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_06,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 clxscore=1011 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112210107
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 11:46:40AM -0800, Maciej Żenczykowski wrote:
> On Tue, Dec 21, 2021 at 11:16 AM Tyler Wear (QUIC)
> <quic_twear@quicinc.com> wrote:
> > > On Mon, Dec 20, 2021 at 07:18:42PM -0800, Yonghong Song wrote:
> > > > On 12/20/21 12:40 PM, Tyler Wear wrote:
> > > > > New bpf helper function BPF_FUNC_skb_change_dsfield "int
> > > > > bpf_skb_change_dsfield(struct sk_buff *skb, u8 mask, u8 value)".
> > > > > BPF_PROG_TYPE_CGROUP_SKB typed bpf_prog which currently can be
> > > > > attached to the ingress and egress path. The helper is needed
> > > > > because this type of bpf_prog cannot modify the skb directly.
> > > > >
> > > > > Used by a bpf_prog to specify DS field values on egress or ingress.
> > > >
> > > > Maybe you can expand a little bit here for your use case?
> > > > I know DS field might help but a description of your actual use case
> > > > will make adding this helper more compelling.
> > > +1.  More details on the use case is needed.
> > > Also, having an individual helper for each particular header field is too specific.
> > >
> > > For egress, there is bpf_setsockopt() for IP_TOS and IPV6_TCLASS and it can be called in other cgroup hooks. e.g.
> > > BPF_PROG_TYPE_SOCK_OPS during tcp ESTABLISHED event.
> > > There is an example in tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c.
> > > Is it enough for egress?
> >
> > Using bpf_setsockopt() has 2 issues: 1) it changes the userspace visible state 2) won't work with udp sendmsg cmsg
> 
> Right, so to clarify since I've been working with Tyler on a project
> of which this patch is a small component.
> Note, I may be wrong here, I don't fully understand how all of this
> works... but:
> 
> ad 1) AFAIK if bpf calls bpf_setsockopt on the socket in question,
> then userspace's view of the socket settings via
> getsockopt(IP_TOS/IPV6_TCLASS) will also be affected - this may be
> undesirable (it's technically userspace visible change in behaviour
> and could, as unlikely as it is, lead to application misbehaviour).
> This can be worked around via also overriding getsockopt/setsockopt
> with bpf, but then you need to store the value to return to userspace
> somewhere... AFAICT it all ends up being pretty ugly and very complex.
CGROUP_(SET|GET)SOCKOPT is created for that.
The user's value can be stored in bpf_sk_storage.

> 
> I wouldn't be worried about needing to override each individual field,
> as the only other field that looks likely to be potentially beneficial
> to override would be the ipv6 flowlabel.
> 
> ad 2) I don't think the bpf_setsockopt(IP_TOS/IPV6_TCLASS) approach
> works for packets generated via udp sendmsg where cmsg is being used
> to set tos.
There is CGROUP_UDP[4|6]_SENDMSG.  Right now, it can only change the addr.
tos/tclass support could be added.

> 3) I also think the bpf_setsockopt(IP_TOS/IPV6_TCLASS) might be too
> late, since it would be in response to an already built packet, and
> would thus presumably only take effect on the next packet, and not for
> this one, no?
The bpf_setsockopt can be called in bind and connect.
Is it not early enough?

> Technically this could be done by attaching the programs to tc egress
> instead of the cgroup hook, but then it's per interface, which is
> potentially the wrong granularity...
Right, there is advantage to do it at higher layer,
and earlier also.

If the tos/tclass value can be changed early on, the correct
ip[6] header can be written at the beginning instead
of redoing it later and need to worry about the skb_clone_writable(),
rewriting it, do iph->check..etc.

> As for what is driving this?  Upcoming wifi standard to allow access
> points to inform client devices how to dscp mark individual flows.
Interesting.

How does the sending host get this dscp value from wifi
and then affect the dscp of a particular flow?  Is the dscp
going to be stored in a bpf map for the bpf prog to use?

Are you testing on TCP also?

> As for the patch itself, I wonder if the return value shouldn't be
> reversed, currently '1 if the DS field is set, 0 if it is not set.'
> But I think returning 0 on success and an error on failure is more in
> line with what other bpf helpers do?
> OTOH, it does match bpf_skb_ecn_set_ce() returning 0 on failure...
If adding a helper , how about making the bpf_skb_store_bytes()
available to BPF_PROG_TYPE_CGROUP_SKB?  Then it will be
more flexible to change other fields in the future in
the network and transport header.
