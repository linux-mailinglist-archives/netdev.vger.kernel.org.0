Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956C9434493
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 07:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhJTFTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 01:19:07 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:50828 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229756AbhJTFTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 01:19:06 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K5EmKp024881;
        Tue, 19 Oct 2021 22:16:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=pICHADg2kpfK+72cb3vjK2upNrD/fiz4CvSMBd0wers=;
 b=Nxzcz2+LpuQROIFnS+Ph4cFe9aOHGsPXyFb3nru+waTsm+ROkifKEezy5D9waoSxMXmP
 VMR1NENSvNkeur2Okr0y33Ei/LQUxIX/7r03XTC54pK+9Bw94Q/CKcilGqYFyM3hjWrK
 zkcOJDf0bMsOepXBAkY69oKjrU4uxgE1iqIu62N9XyNR5QpERZ/xqd+Fgho+FXiFs330
 mvHRoKOvFxLAweJz4Ohb7xRLUTyfcPMDdCe8vERZZUvnUqsNwZDuaheuZB6MzwOAvbuJ
 sTw9BoFA1fLez7QroAFlEeyPTm1/DiJ4e+qmSdgssX3kI6YHaqpUT6MwMZIiwnIdHEzs VQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bsmtb14nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 22:16:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2JBUtYnE0ml8orh4F1cXWkxt1yZyFEqNgXCm44H1PuwQIXIOaYerwk+KTPkUdg8q2/1IXrBADcjhFXCREe3Jfr6Xpa1f1K0EpWjM8oYrsnGHFI77ZXNOT6W9gxtEmyanBI9ntvefP8VN+gyhJaQQsoPlRb1EAAl5qlf+h1q8n2T6YjDyDTc5Sf8jVpRLYTyMtfOwYZ7UR+f0k23aXZ9BhuY4tluulMvzpjVrUIvU3JTmqX4WC5ZUmjdvlY1DUEtGQGbUU0sYNkbRgVETgMLHDnu2FO/QhxYAGJIzOkwpja975QCWFniVXQiYvBerVXtiTsKgEyE4CSbHaZU0xU8zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pICHADg2kpfK+72cb3vjK2upNrD/fiz4CvSMBd0wers=;
 b=UV/6lI7PqnxVDscs+BqwJw52ydCEZ3GsN6/UOVnMx8qybIZyF8CG/sPmuG/3r9C45rDcQmuFRxZ5OV+E7JtxdRF+Z9vGdZdFFnWv3bPqCNUoqZlYXsgO5bH8faKocVKfkA+k1erZ6P1qPhoSiBnpwzHQBpkiO7dIhohp4oXYv8SdMC7x2ArB2r73XtCUVMJA5DF1zs848bdZlEAkx5vxFna2iLGJajqajQemHll1DEk7WyRiNIy1epIsKBTKKbv7kDHItHcZYCIlRorkaNjWTBEBE+KDdgKOurwAJfPXk1dnZRP7jsROFCfBobxYMfmTTEQgptnQfoTWGHKYNFACRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by PH0PR11MB5062.namprd11.prod.outlook.com (2603:10b6:510:3e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 20 Oct
 2021 05:16:17 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c%6]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 05:16:17 +0000
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590> <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590> <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
 <YW78AohHqgqM9Cuw@blackbook>
From:   Quanyang Wang <quanyang.wang@windriver.com>
Message-ID: <4644b5eb-8acf-45ef-e33e-84eee6394a57@windriver.com>
Date:   Wed, 20 Oct 2021 13:16:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YW78AohHqgqM9Cuw@blackbook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HKAPR03CA0033.apcprd03.prod.outlook.com
 (2603:1096:203:c9::20) To PH7PR11MB5819.namprd11.prod.outlook.com
 (2603:10b6:510:13b::9)
MIME-Version: 1.0
Received: from [128.224.162.199] (60.247.85.82) by HKAPR03CA0033.apcprd03.prod.outlook.com (2603:1096:203:c9::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Wed, 20 Oct 2021 05:16:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed7f08c2-66b6-4203-8d75-08d99388beb9
X-MS-TrafficTypeDiagnostic: PH0PR11MB5062:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5062B3896B18918454CAC7ECF0BE9@PH0PR11MB5062.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j8wHavtDr4ly9Uevajwrex9QiPu6wt5h6ncS/zpaJqVITc1tCxFoiRbrLPLzq4AkX9W08JMVMp5Bqj6gnMn1DioCIKmPd0zws5XcRolTcQtt4F8IP2WmaApwGp4APUXPpUOQLzfnN4X9DcvIK2Ob9r1E0SdPv1A2AZNU3EliuTNBslCD9CDY1faw53rXxAT33MEXEf+jqbUWSor28WBWwh1blSW6vl02aLJjQAawcQjGMJXp7hnucTgx/rSwhDkaZIjcheQXreqghsFMZ/4/NGqPVGP4lwqIfkuqURRIyOIHIEQ0nRXTGDZfuVXceUbbzma4TGikRYsRfgyiJTdArJ+GFdKeHHG75lgwUW6ehG2c3UVaPx/jbToTPSk/+3gviNJPHUz5q9YtPmVtjnROmHL61WvmtDsPtvxuuk0dq4TA7/0t9JB++xqGPcV79rQp2LbCmapPSmnxrqY9Daqr9yRzP4Jmb/NDN4C3E4LQ4LES+8O/Si+CX5hh9c8EUkjckgCWwpo68VL6hcLlmOjwbM5fhz2enjAMf/GBXPjBojRBA1mmaN4R4loBEstRkPdd17IIuEfmnzVKGPq5a/XM5icfWkOz639XJWO1nVSZNoArJtljc2tLb/397DVVHzzN9hMWgLcrdOW9JgM8Gx3FAMvFs0kJ2kj9Q8+zOmPAY8Swy+Y8MfuOrFC8m0kB0dBQS4jTQ/39fwiD7Cr8zON/n57R0sP6M+fEUTSxSODdVRyKITzfdwVhhkkRL548PzzYZa348lcJqEF3nQSSVxkgFhx9vgRq8oXqJPvkXXg7n+s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(8936002)(5660300002)(6486002)(16576012)(508600001)(66556008)(26005)(8676002)(316002)(86362001)(36756003)(44832011)(54906003)(31696002)(66476007)(38100700002)(2906002)(7416002)(52116002)(31686004)(6666004)(6706004)(6916009)(186003)(66946007)(956004)(2616005)(38350700002)(4326008)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTBwc3d2d0grbDZFYjczdndydjRtdDVLMytxczZrQ2JQY2EzbXFCMzRndTB5?=
 =?utf-8?B?ejFPOTJxSm1HZ1gxcjVHdURWRlc3ei80Qk1CeDNlbXFHaklWdDV2aHlIU0VS?=
 =?utf-8?B?TmVuSnJkZE5reldLVFErMDBhWXJtZC95NUxkUTdQaFJqdWxUYVZLNldaNytQ?=
 =?utf-8?B?NWhvMGdPSE1DaFQ0ZDM1SFBaTFpRR3Vja0d0ZVRBa2ZDNStpNjFsSXQxazAv?=
 =?utf-8?B?aGZZMEZ3QlNFWUFTbUMzdUtLbTVxdEMxejRoRFY2b2FDUWVHWVRYZGl5TzZQ?=
 =?utf-8?B?dDkxQnYxVUovclA2TTMyWDlsOUQ1SlRHdkJnNEozbVB6bkJkNkZkRlNCZ2Nt?=
 =?utf-8?B?TzdYaEpocCs4Z211K1Z4Q0hqVU9jZWUwK2ZraWFhcXVPNE55ekM3VmxZQzBk?=
 =?utf-8?B?RTgvaVA1dEtjblRnNTdZeGFGVDd4TnB2RjAwU2tCOE55a0htUHc5TUNvWlZR?=
 =?utf-8?B?YXROMW5RNFRBM0MxU1dFdXN1M0NndFBVSDB6WkkzWklBcmZOalFPV1FVN0Z3?=
 =?utf-8?B?M1lxS3p4WUxMZXo0OTgwWHZZZUYxWGh0SGZBNmlLMU1PK25iZHJOVDV1M2dh?=
 =?utf-8?B?a2l0UnNXcDJvc0JsUUJvTS9EQ2tHNXltZnRGYkJBQ2xhSDNSb2F6b2JJVUxw?=
 =?utf-8?B?a01HYWd5dHlUVXVjSk5IbHkyMTVvMFB2Y1ZVUGpaZGxYTkRFVENSbm9WMnAy?=
 =?utf-8?B?VFpkVFVnU2JBVmJSeDJZV2N4Y05mMER1aHl2ZFBwWDV2alhXdHRtVjA0aFR0?=
 =?utf-8?B?K2ZtbXBMS2wvRGttbkZFd1U3dU9xSDFvRUNrRzQwUTQ5cnRKZzlycGlldWpF?=
 =?utf-8?B?NS96MUR3aFhsTTByQlpzMktZcmZtRXMvem55UWFJalljRTZHdGdXUkZHWEdJ?=
 =?utf-8?B?UHlLamFISjgrMkNMNklXZ3BhL21LMGRLY3VCdEs5N1I2YXIyOE4wZTlHdEor?=
 =?utf-8?B?cnZnMFRKbWplSWpJODd3QWJabWhRQnd1VVlWNjJ2M2F2enJrc2JXdkZJbGow?=
 =?utf-8?B?U2FEbE4vQzk5aEdId2R1VEwrYVRqZmxUaFYwSjNVQ3JJeVhQdGFzQ2ltS0tl?=
 =?utf-8?B?ZWNqRzlLUVJTT21TUHdLL3BMUmxCT1VKaUlxMHd1bWJFWEtZSmFLWW1qcHFl?=
 =?utf-8?B?YkZHNk5xRGs0cnEvQkEyVlhLNXNyYXp1VCtrL2Q5ZWRRalBTaWM1ZzRHMnQy?=
 =?utf-8?B?eHFRNkR6NTJmZkhsRytaRGNNdkdnTHkzMThhN0VmdEtxZDZsSk9zR2tQdFh2?=
 =?utf-8?B?L0tabE83a29WWEdLYU50NlI0cWNyWWcyaXpJQ094UllsUXhpV3JwQTdEMEFt?=
 =?utf-8?B?REFoUE1HOXdwc2Nrb0tXUHh4QlNGYmNJNTRmcVB2T085NWFzT3JORWZLamFr?=
 =?utf-8?B?RWZKdm5zVmdvTklsclpBOVpkR0pMWWc4RzFqc3R0cnA5U21XK3dISFNySURS?=
 =?utf-8?B?ZFNTcUs5L0g3VXhCN0l6blVTQXpIclNUVkp0T05ka09BeW5HL1hWQWxjL01Z?=
 =?utf-8?B?RjhHdjlvRnBpN0NWWWdWdk5HQjREWWMybWtWM3BBaGtwZnpaR0JMYlo3dXc5?=
 =?utf-8?B?RTRLbnphUGU4TXV0Y1g3VThxdytGZTJpYnRRb3NPbThZS2NPcThrS2o1Wmxt?=
 =?utf-8?B?eXV6RE1Ia0dvOEZ6c0ttVWR3aGtadnVmWXRsWlJZT1VjUzh0dWhVUnRHMWRX?=
 =?utf-8?B?SS94a200UVViYndhVDhDTnhhOG05S0MrL2Q4VFlIMDVKTTRwSnF1OXE4OTU3?=
 =?utf-8?Q?ANLy2cr47QMB8uG/f3VNStRt2q/vVcml6gag/SB?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed7f08c2-66b6-4203-8d75-08d99388beb9
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 05:16:17.5865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: quanyang.wang@windriver.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5062
X-Proofpoint-ORIG-GUID: 3n8kghCID_sEZgJzgZDBtRIYXfLOryNn
X-Proofpoint-GUID: 3n8kghCID_sEZgJzgZDBtRIYXfLOryNn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_01,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=720
 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On 10/20/21 1:10 AM, Michal Koutný wrote:
> Hi.
> 
> On Tue, Oct 19, 2021 at 06:41:14PM +0800, Quanyang Wang <quanyang.wang@windriver.com> wrote:
>> So I add 2 "Fixes tags" here to indicate that 2 commits introduce two
>> different issues.
> 
> AFAIU, both the changes are needed to cause the leak, a single patch
> alone won't cause the issue. Is that correct? (Perhaps not as I realize,
> see below.)
Yes, I back to the earlier commit 4bfc0bb2c60e and no memory leak is 
observed.
> 
> But on second thought, the problem is the missing percpu_ref_exit() in
> the (root) cgroup release path and percpu counter would allocate the
> percpu_count_ptr anyway, so 4bfc0bb2c60e is only making the leak more
> visible. Is this correct?
No, the earlier commit 4bfc0bb2c60e introduces a imbalance and the later
commit 2b0d3d3e4fcf introduces a visible leak.

Thanks,
Quanyang
> 
> I agree the commit 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of
> percpu_ref in fast path") alone did nothing wrong.
> 
> [On a related (but independent) note, there seems to be an optimization
> opportunity in not dealing with cgroup_bpf at all on the non-default
> hierarchies.]
> 
> Regards,
> Michal
> 
