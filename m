Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7606D3D6B14
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 02:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhGZXxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 19:53:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39536 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233843AbhGZXxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 19:53:42 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R0EI4m023574;
        Mon, 26 Jul 2021 17:33:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=cH/WZrqLgza0lusOI4mu0AMG60vAutnBOAwL6wgsa2Y=;
 b=RqtKlUYbrdP2lu3S74ToMGeAosr35fOtK9DzW+5u4oYG403SfhF9jwkqbNETK0/FxspU
 rPMr9yDJoYN52zjrr8e/1rT9icAu5haOuRA/KoEdBGUZZU+D6FwgbDbIRiEBMynGLyj3
 SKlXz09POz2BrzxQ7NabWg7SA4UioPx5stI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a23569hjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Jul 2021 17:33:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Jul 2021 17:33:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBXclVsDS5gOC4e45aOqdBPcHok5Kk0BSpD3cW8O+mEngzJP8bfLoeFMijMvULLitUg4xJBpkXJ3cphxCRCnYDE83QUqJmWkVqp5uRN0LGXoX+Kku/3zKpMYtvqr2gdVgtwZ0UvpGyz99j+EEBLLvb538NfFKxXY1LKTsgTH2qccrwUxjAZm2sOAuTKqJh43ORlCGVP3rVcKwfxpzIoyuW2+3pqJZTW1u5sdasrR+/5Xca2pEJqto8GS62hTTJpyQkVB7f0i4Uuel9Z757xYQhNxhRIYhwxyCx8fzm4/ftsScoKAwhq9862bD8nSyxxTeqpBhU/O72/2EPQUp4MHBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cH/WZrqLgza0lusOI4mu0AMG60vAutnBOAwL6wgsa2Y=;
 b=eonHTjPeL/3m7lchx50B2rCRqhdsxDGLzBIJVU/sJtd8GjxGqLp1DsU7QNPAlOr3GkFw3vkqYnWIhIm4HlmB3/tWQOrvUvvjGQ7bRXajA4iSbsQluEGpKWIeqVl2OVo5qpPG9MBuBIISftz5H4oDMMSyc8xMaZGMk9JsvMCCp70wbYA30uSzZ/YK31tVGLH9VpQEOT3Smx2fEcTGX6+85lcVoqwIDh8bAQ3R/MK+xDD33j588TuaUuwAfnfH4s8SWQd29xsRoB+TF6c63N7CwWeZrD01Wws+jHQxci0kCpJgl1lEfHDP9/sW4yVZkZhWITH3H6uFtXbEkhFyIc3T2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN7PR15MB4207.namprd15.prod.outlook.com (2603:10b6:806:109::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 00:33:54 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%9]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 00:33:54 +0000
Date:   Mon, 26 Jul 2021 17:33:51 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v3] bpf: increase supported cgroup storage value
 size
Message-ID: <20210727003351.e5znun6pstjamzz2@kafai-mbp.dhcp.thefacebook.com>
References: <20210726230032.1806348-1-sdf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210726230032.1806348-1-sdf@google.com>
X-ClientProxiedBy: SJ0PR03CA0266.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::31) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:ac8c) by SJ0PR03CA0266.namprd03.prod.outlook.com (2603:10b6:a03:3a0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 00:33:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8f09354-9508-4653-346e-08d950963685
X-MS-TrafficTypeDiagnostic: SN7PR15MB4207:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN7PR15MB4207C3FB554BC1F11CD9C1ABD5E99@SN7PR15MB4207.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CbWfUrTSbyAj69KWmjzRyNDfU0CeiYjYJthv5A2310LfucrhMhEQ16A7zKnesV+aEtnDvNIyhSn0cZ+MI7gz2aBL9r3SBQa0nMrwxgUhb/o2T5V0k0jsj7zVoNAjVgdio9rPiczaDqLtjTfcopXp89mwObDveSvD61Znb44BwmaEDWKz2CCEqVhik2fHNhGQbKfRU3Tf6H8eZvdrG3kH48NeQfjjvxw+HKhXcwC6LawNJwi2wVAJ9SuTp/C9OlfrdiEBRu6HcxH/2mO8DtEQtczqEs4BBPEBh58IvpzNhstkEvQvWV7Wn+GVOS94Nir/nKvIV6Dd3ebCLfbA2haEtP906LBy6mbx6fg+WiWb1SLtpkIHEvw6th8tQnSwKhiSdSAQmN/PBB/v6u+AEfVLAeT9CUtvN6AAnMOXpVfGuXaCUdUI+qwX3kJM9I7Cl5PBr+f45ePGop7REfRBFXBjUrwy202STKlIlHYKzH0OkML/vbHtQXViIDU1Lz0/KeN1fARy9z5AfdBq5BGMRnM40r6vuzMvhchB+/PfXRhgXHY/z19HvlnPBwgXzW8CCLjQQP2ptqTqUWuVOKo1WZ4TLDNJVdTSDOyc/8WmLFaUjmb/CPOou6IxQsNz8kDj5VhEdQvzoqzM8EXKA86RlwS2Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(7696005)(8936002)(86362001)(52116002)(478600001)(9686003)(4744005)(8676002)(83380400001)(1076003)(38100700002)(5660300002)(55016002)(6506007)(6916009)(4326008)(186003)(2906002)(66946007)(66556008)(66476007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?spC6idCoF8k5HuY2vBPGDpiI/ff4Zec3PRW1u1zQnY1kbfi8DKGT/b4sdVOR?=
 =?us-ascii?Q?qsR65odZtFqOksDkljDf9FgZNSOxBRsaUMtgjL/PBu0TmQgxqHAY6HbgDSiZ?=
 =?us-ascii?Q?Z+h7YzSt3PO5/vUZSrg3i0X1KqtTm50Jyv6uBQkl745W9zpbw19YLn72/we1?=
 =?us-ascii?Q?dYMec0pOWvAUaq8ni5zpXxxSKqTFo7t+Ti369Q6kRupFR2IjzH+eEXaKLNaw?=
 =?us-ascii?Q?mWvD/zy+ByG/lWdTl2nBcqYHzB8GgEqf6ms0qjV24qsExaHmz2/5QB5jjHAx?=
 =?us-ascii?Q?4Mkc6zuON+RjEW4EUbiKIP+DnAGs1oF67KIAsAXFM8AyvWmGjwI4C4GiPqPW?=
 =?us-ascii?Q?qpFgdaz/nYXnvR5hnZibzceoQmuT7h5U3bOEkNxNGQvlErEGxoGZsUQsAGWb?=
 =?us-ascii?Q?JtAtZ05SW/la8TzOZZpgzAdqoEksOfadtwIzRcKzYg+MYGE224BqRKzvZxYV?=
 =?us-ascii?Q?ev8UonhAoSsKQTZjnQgt8r69pKnvUTj2VnuXB583SUNglCYZ4avbvBTEWsQY?=
 =?us-ascii?Q?Syehs0YOU+ynPu18Ubx+OJjvVZz7885O//sBRLG32+Hen+dWeYefsuw4Uxdr?=
 =?us-ascii?Q?4cfFi9VGp5SD0MND9XJjhhuZ314pRz+GQVPPs3VCnNdwxFniaCNvSV8/DXfb?=
 =?us-ascii?Q?YpZE8HNkhmfwMZR67tOrwJNkzslpsHFQE4DrLCteplB//jFADl8uLtHJnI4i?=
 =?us-ascii?Q?uStFHJ1A5Nw1J+7tjp0A52jvxNF59CBpApFdCfc41ZM0kX0FwO0CDDhbrGaJ?=
 =?us-ascii?Q?p2z8/IZisgydZnBNOBKiJe6EmTCfUJWPrhIqda01xF43z0aKASfn5YjUADXL?=
 =?us-ascii?Q?bAhiPQWoi2neolCfSXDScZubxDouCtsXQHwdiiXiTiMY6W7pBR7kfP30ViFP?=
 =?us-ascii?Q?z73QguCsMhkXC5yIfGcHIo/nYb5f9mC42VLOoTJGTUp+ILpiUC2RH2hnZb7F?=
 =?us-ascii?Q?Qh4gROBujXIz/ykG88UIaEq2dpKKt1XiXIGkCZFSkBCSay2FnuCGarOdNX+P?=
 =?us-ascii?Q?1l87Qc3FH852+EeKXpX5jMAzSeZqS2UCSwT49UMUBi0+N547HS9D2djhT4Ko?=
 =?us-ascii?Q?bd5OAbScfrwXLfI/X18dUyiPM5YkgoMtccjl5h1GAo3C5Sg0j9uGds3ligKx?=
 =?us-ascii?Q?6A33sQb6s8+ckWLj/WuACJhsztFrORoxRY2/RUmugGmF9p6sf3DAmomm90tA?=
 =?us-ascii?Q?h6UJbghfcLXlatA+OQ+z5mV3H6JIwne7Vd4/aSd591SSkeWb5z+bKL79HKwz?=
 =?us-ascii?Q?Did8jxp7G5Iu/seWB0asT8SYUNPTLWMm8YN0Rz8ZwjByAv7H51wJRXo6daxA?=
 =?us-ascii?Q?4qY1DnggN8f6rQfUWiNRnnAMKskV/u2fHeKER1Tx4yWgLQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f09354-9508-4653-346e-08d950963685
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 00:33:54.1204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KuvhOJk2NEjgfT9laDNdCORVkHv3UCNg2SBp5xKSs3z8hH3WL+QZcTvSd0yx3fqQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4207
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: iJ9b6cc4OGaR4BmePrFIt4FhYgxMQUjj
X-Proofpoint-GUID: iJ9b6cc4OGaR4BmePrFIt4FhYgxMQUjj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-26_14:2021-07-26,2021-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=708 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 04:00:32PM -0700, Stanislav Fomichev wrote:
> Current max cgroup storage value size is 4k (PAGE_SIZE). The other local
> storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's align
> max cgroup value size with the other storages.
> 
> For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
> allocator is not happy about larger values.
> 
> netcnt test is extended to exercise those maximum values
> (non-percpu max size is close to, but not real max).
> 
> v3:
> * refine SIZEOF_BPF_LOCAL_STORAGE_ELEM comment (Yonghong Song)
> * anonymous struct in percpu_net_cnt & net_cnt (Yonghong Song)
> * reorder free (Yonghong Song)
> 
> v2:
> * cap max_value_size instead of BUILD_BUG_ON (Martin KaFai Lau)
Acked-by: Martin KaFai Lau <kafai@fb.com>
