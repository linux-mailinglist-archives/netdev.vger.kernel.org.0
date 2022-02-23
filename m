Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197874C16F2
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241954AbiBWPhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiBWPhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:37:41 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1B24F448;
        Wed, 23 Feb 2022 07:37:12 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21NFarNX017407;
        Wed, 23 Feb 2022 07:36:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jR15mfXtDCZLtsbl0UjQ1cE0bwggOVQA3SOiJOUqk4c=;
 b=RoPU29oc/ny3Jt6vlzpI0zl3e9qWRX5mO/k2+D7CwevybR7cTM6E1TdxB7qPnzx8ZOAt
 q/sbTwHJdcOdiyZBAZRsPiwRQkCAEdY4MRpQA0YFKgoz1L2xTvGJflPBVWihwNFxPPXq
 dLWhypMUi4HZY4GA34eKKHBQzgMroR6eDls= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3edbfxm3nj-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Feb 2022 07:36:58 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 07:36:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGMY034ONhsdMUHTYSpejeMk7fKxDike57sKoU6OEiBrd/gcovAXiYwZeuOsz9iXqNdhKkL2UVu0uvR9QI/AwCwJA0m7LrAh726dMm7fh3cN3P9EqIp/odi/qCRr+KsYSY55j/zWYtcT0F9uNNnwQ9MzRI0hHGD7crYZDT3VRYLkLj41rcmOI251MAIAB/FY1gsWO6o+tfiZCKUXcsUxuJCs6Nvt0p70Zr1LhaUKI7YedviDs8kLtcrn4onhD482/8UryD4w7yr1qyHyklE3rePtKGHs1bzu/bsmo3+XJZ6YOd//8krPy7QReBZ1Jwf6DpIwgQa3u9MPWyjJfI5RKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jR15mfXtDCZLtsbl0UjQ1cE0bwggOVQA3SOiJOUqk4c=;
 b=Rok5eLZeWiy38RA95SHiGsmZeGKivaafo6lJUgglYnODaKRECirvAcMC6mHUF7u6jW/u2zzj6iCfPMEQ9TkWgPLMlZ1GOnMXDJI2ReiZMxdwGOGqQdETwnVTaGodzpaE6y5ohY/3oVcRHtjiLyakMBhTREohlsI3otFk2ccCN4hDp65pORGH0LTOstk2MG+YZh94dZCAbpRivZd1zDxdeDhzfvTM3KSUbLFqOlMxMC5Z/eaBHnOO8ORpw4cmemqN54JfkxZ9vislvFXcfTKpozBLMPD1OP78kg5GFb6oklL/xn+/FyEGiSU8UzGD5hWH8NLyO8HZm5Qm7rYwOFvggQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MWHPR15MB1278.namprd15.prod.outlook.com (2603:10b6:320:25::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 15:36:51 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 15:36:51 +0000
Message-ID: <7ca9637a-8df0-5400-f50e-cfa8703de55c@fb.com>
Date:   Wed, 23 Feb 2022 07:36:47 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] bpf: Refuse to mount bpffs on the same mount point
 multiple times
Content-Language: en-US
To:     Yafang Shao <laoar.shao@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <20220223131833.51991-1-laoar.shao@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220223131833.51991-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0155.namprd03.prod.outlook.com
 (2603:10b6:303:8d::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92a03739-739b-44ee-1b3c-08d9f6e24f8d
X-MS-TrafficTypeDiagnostic: MWHPR15MB1278:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB1278B81B2198143B6BFE4648D33C9@MWHPR15MB1278.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Utjdr21PnPQDj2kEWZbV3Br6qmQkBg3XhCebfhoB1VIO/TUqOANYmEKFohzoFJbduM4cLaNJhd8q+C0/ZKu8DS0i2ZuEWURHSjguaqJCM0tHcE14jhYpa4bp1TE3SRUcgSe4qVuvX96o7P2tOe0W8zkqzKlMlQs4xdyKw7Gcd/z9jzvq6nAzH57GeWZAbA3xgB4lw8DenNguTUDAClKucRvnLU5nyv5al22Zafc241z7KxecwMtsPvgt9Ufr7Ix06gpwMvB+I6NUJKYcA9Z50fQ0tRLrfKdINNy/GtNm2LVIObH8Z/lR+V/o/OQev3mnkcH2azy753zeUNKXTHN43+w5loiLwn53ltizcO+3WVDr/JcqAvGT1zIU0N/prhFtSBnsThNTKz+mexDnHeGh47zJitiGdfneWrNaK4hOK21k2zVDvtYYflYr61RfMNLlPUL8WaGzNxMCa6q75OTLDNQlVJUdi1aMsmxAKYZcnvXjAtP2uO/Y0w5kiXJxhQTTvBV/YOhs/rt+0WCo7xJDAF8n53IUL/M8tNIm6bYqP968Pt619fwK+74hBlmcEGwO6sxbNEfY7QcHaj6WCZ089L1MzAwbkOGBsb52+3pJJje7A8lnSOeUreVGtroUt/Ic1YD2Yv0ixdEUsQymblaZZt2wW7hv/nrk48Og8pxJ3MOiXzM36cASz8Jn+/5lxwUAybsYLQ3i3E9lb4FLNTDQZy5SKmTqg3Gxi1AS/W3VtbA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(66556008)(316002)(2616005)(66476007)(66946007)(36756003)(31686004)(38100700002)(31696002)(86362001)(6512007)(8936002)(6506007)(2906002)(83380400001)(508600001)(6486002)(4326008)(8676002)(6666004)(53546011)(5660300002)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVBPUHRrcjZCaXJBRTdWZ0RFb013VjFrTlhVaW5qUmIwK0w0KzFQbkJZdkdG?=
 =?utf-8?B?dnVOb3BlbUp1d2dvb2xVNkJ2b0E4VVF0ekUyWDlJZWQ3TTk3UFRCbnBVdjB5?=
 =?utf-8?B?QmJpVFdSbUIzeDlHNEc0TVM2cWRjY0FDWW52NTdwS3ZhSWdMSXY1cTJMSVIr?=
 =?utf-8?B?NnNGVlpKYVpNTnVaNzhGVnlIV25qVzluRHFPUnIrbjl4M3ljVCsySlc3NDVS?=
 =?utf-8?B?NDNIaHc2MmxlWW1OOFVUMGlNaHEwZVNNTncvRnFsSVc2amtyNHF0dHN0YzQ5?=
 =?utf-8?B?TkZVZlhUNzJCNWE1S3ZUK3pTanNNTTc3aXA0TWFhQVZaR1E0Q0k2QkJqR1Bk?=
 =?utf-8?B?Nm83Z202VXhqZGpZQW4vWkh0NjNnRmJSYUFzSHNkV0trZTJYL0VTTVYvOTJE?=
 =?utf-8?B?WXVZYjRaUGt2V0hwNXF2TzRsd1hhSCtzdEMvdGFXeWhEbnBLckJaQ0pTYTRr?=
 =?utf-8?B?czhmZVJicTBSYXhLdFNxbCtFeElvNmNLWkZuRm1MYjRrdXQ0QkJ5S0VnczVQ?=
 =?utf-8?B?WCtXL0hHYnk2bDhzWXBMeVg2SWRCTUVCSmgxaFhIZkZOb2xPZEhwcnVOUFdv?=
 =?utf-8?B?UlRSN0V1Q1E5Y3NQcmZwYnh1OEhNWEdUWnl0S2JHbWdFYWoveCthaFRRVkQz?=
 =?utf-8?B?QzdiVE1LdHJtN3FxWHZYcDhlcGgzdUQ5OW9IYnc2SStHQVpQc3NKc1FZaEVs?=
 =?utf-8?B?VHlkTmlaYkRnZFVya0NJcGx2UFpUNGltWUU1dHZzWmhpb1l6OFdiVEdQVXVw?=
 =?utf-8?B?ZnJJSVQxOEtmb1lxdm5XZ0dKSjJMQW95Z2hYRTRzMTArc0tOVUxoMU4yZW1a?=
 =?utf-8?B?dzdqa3Z0TEgyN29pN3dXWTRpRzlNQ0ZXVldBM1FDUFdTYmJhQ3czNTBzc0ZY?=
 =?utf-8?B?NkNLcS9OZFVVNXZPSUpqQ3BXVW14dnJ0YTluc1gvVGsvTmhKOEp6NjlseFBI?=
 =?utf-8?B?VEJEQysva3lVUG40OGVMRTN1NEhMdWVNVmRPSUthZlVBRlFHQmt3UTJPQ3lq?=
 =?utf-8?B?Z0VUVXVRWDhPSWdPRlVJQ3VwZU8vYVdLdDZqallkY29WeXNFMlBUTER2VjNs?=
 =?utf-8?B?YmtJYktXcjdYK0FUNDV4OHV0RHhCZ3V3N3k2T2YzSnYyYW9GY0lDK3Z3WlAr?=
 =?utf-8?B?VkZxSGxHQlQ4bitwdmpuYXQ2ZnFjSS9kdE9qamlhS0xjY1VOSkpia1RiQmM4?=
 =?utf-8?B?a3BCMHdSY0hXcHJ1UVFMZWJmdDBtcnhsM0NpdzNQd3JJbXA1K0JHam9uSVdp?=
 =?utf-8?B?TXNoTDNOaWl4eFV0cnVKUUE1eE5pWVdPOEVTUDIrbEpYV2hHci8ydlIyNXVM?=
 =?utf-8?B?R3JnbDZFQ1dQeHB2Q1AxaGdyUTRhNytYdkE2S3VJK0dCY3hLNzBUQ0dQc1FB?=
 =?utf-8?B?cDJOejNrd1VMSVlrMzRIdWxhUWFMQ21LY05EMXp1T1RBYlpoSlAvNjQ2aVE0?=
 =?utf-8?B?VFQvek9lRXd0VS9lRjNHUEduUUowWFZDNnhTTmRzRENYU2M5b3dVRG9iWDI4?=
 =?utf-8?B?QUNVR3NleUx6bDExUDJEcXFQQXpRR1JYZkt1WTFmcEFYZWdCVkRuRWt6THZD?=
 =?utf-8?B?cXdGUTFmczdsclAyc0R1MlBuaUt6Z1JsbzdyRG9iTnd0ZnppUWtyNkV1YnZX?=
 =?utf-8?B?YmVOdXA3ZXdKcFhCdjdsd1B0S296TVg2dzVSVU5aMmNqQm9ieWtVR0wzMHFk?=
 =?utf-8?B?WWxYLy9SdEVrSzcwVlBsV01PRElNWVhyNXhlbWNHaTJvaWxSM2t6Z1dyYUxT?=
 =?utf-8?B?YnE2Wk0xUXJPbklDcDJJSnZMSE1HTHNxdnpwdmorRGdGN3BHMHZTQkQ5QlhS?=
 =?utf-8?B?cWorTmhVWjBzb2dhTThQZDBNcmJGb2ljZkhtdVFwRXh1aXh4Y3pmMlJMbVND?=
 =?utf-8?B?bnlTMFAxVjlxMmJMc1RGbXowWkdpRTEyQ1hheFdZMFUwTFF1WThxNE5Jamkz?=
 =?utf-8?B?OWlmY3dsMmlpOXdWV0p6aHd2NlN3WGFOV0cyejZaMFRZd1AvdXBhOTg2T2xY?=
 =?utf-8?B?VG5BeXlGVDU4bVhpSUtGbmlTYTRUTG1VTDZLUVpCdmN6cUNISC9SQWRwVUJ5?=
 =?utf-8?B?TmNSbWNTbytSZFk3SlR6ZnlNbnpYckpiamlUeXc3K1hBUVJ0Wmt0YUdQUTZD?=
 =?utf-8?Q?6M49o2ey71vsJQU4Pn9EU/Qk5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a03739-739b-44ee-1b3c-08d9f6e24f8d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 15:36:50.9668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Q3qQvPzwvIJQ0ufat8Gwda0yQN9pnveiL7MhmLKScgnkMGS3G3Tm8cOATlybzc1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1278
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Xx8aufopTi8pPFaQNE0aG8yuRcc7NmVC
X-Proofpoint-GUID: Xx8aufopTi8pPFaQNE0aG8yuRcc7NmVC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_07,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1011 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230087
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



On 2/23/22 5:18 AM, Yafang Shao wrote:
> We monitored an unexpected behavoir that bpffs is mounted on a same mount
> point lots of times on some of our production envrionments. For example,
> $ mount -t bpf
> bpffs /sys/fs/bpf bpf rw,relatime 0 0
> bpffs /sys/fs/bpf bpf rw,relatime 0 0
> bpffs /sys/fs/bpf bpf rw,relatime 0 0
> bpffs /sys/fs/bpf bpf rw,relatime 0 0
> ...
> 
> That was casued by a buggy user script which didn't check the mount
> point correctly before mounting bpffs. But it also drives us to think more
> about if it is okay to allow mounting bpffs on the same mount point
> multiple times. After investigation we get the conclusion that it is bad
> to allow that behavior, because it can cause unexpected issues, for
> example it can break bpftool, which depends on the mount point to get
> the pinned files.
> 
> Below is the test case wrt bpftool.
> First, let's mount bpffs on /var/run/ltcp/bpf multiple times.
> $ mount -t bpf
> bpffs on /run/ltcp/bpf type bpf (rw,relatime)
> bpffs on /run/ltcp/bpf type bpf (rw,relatime)
> bpffs on /run/ltcp/bpf type bpf (rw,relatime)
> 
> After pinning some bpf progs on this mount point, let's check the pinned
> files with bpftool,
> $ bpftool prog list -f
> 87: sock_ops  name bpf_sockmap  tag a04f5eef06a7f555  gpl
>          loaded_at 2022-02-23T16:27:38+0800  uid 0
>          xlated 16B  jited 15B  memlock 4096B
>          pinned /run/ltcp/bpf/bpf_sockmap
>          pinned /run/ltcp/bpf/bpf_sockmap
>          pinned /run/ltcp/bpf/bpf_sockmap
>          btf_id 243
> 89: sk_msg  name bpf_redir_proxy  tag 57cd311f2e27366b  gpl
>          loaded_at 2022-02-23T16:27:38+0800  uid 0
>          xlated 16B  jited 18B  memlock 4096B
>          pinned /run/ltcp/bpf/bpf_redir_proxy
>          pinned /run/ltcp/bpf/bpf_redir_proxy
>          pinned /run/ltcp/bpf/bpf_redir_proxy
>          btf_id 244
> 
> The same pinned file will be showed multiple times.
> Finnally after mounting bpffs on the same mount point again, we can't
> get the pinnned files via bpftool,
> $ bpftool prog list -f
> 87: sock_ops  name bpf_sockmap  tag a04f5eef06a7f555  gpl
>          loaded_at 2022-02-23T16:27:38+0800  uid 0
>          xlated 16B  jited 15B  memlock 4096B
>          btf_id 243
> 89: sk_msg  name bpf_redir_proxy  tag 57cd311f2e27366b  gpl
>          loaded_at 2022-02-23T16:27:38+0800  uid 0
>          xlated 16B  jited 18B  memlock 4096B
>          btf_id 244
> 
> We should better refuse to mount bpffs on the same mount point. Before
> making this change, I also checked why it is allowed in the first place.
> The related commits are commit e27f4a942a0e
> ("bpf: Use mount_nodev not mount_ns to mount the bpf filesystem") and
> commit b2197755b263 ("bpf: add support for persistent maps/progs").
> Unfortunately they didn't explain why it is allowed. But there should be
> no use case which requires to mount bpffs on a same mount point multiple
> times, so let's just refuse it.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> ---
>   kernel/bpf/inode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index 4f841e16779e..58374db9376f 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -763,7 +763,7 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
>   
>   static int bpf_get_tree(struct fs_context *fc)
>   {
> -	return get_tree_nodev(fc, bpf_fill_super);
> +	return get_tree_single(fc, bpf_fill_super);

This is not right. get_tree_nodev is intentional to allow bpffs could be
mounted in different places with different contents. get_tree_single
permits a single shared bpffs tree which is not what we want.

In your particular case, you probably should improve your tools.
in my opinion, with get_tree_nodev, it is user space's responsibility
to coordinate with different bpffs mounts.

>   }
>   
>   static void bpf_free_fc(struct fs_context *fc)
