Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5A7501CA1
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 22:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbiDNU0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 16:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiDNU0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 16:26:33 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D7FDE097;
        Thu, 14 Apr 2022 13:24:07 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23EDh0d5021089;
        Thu, 14 Apr 2022 13:23:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=OD4z5laTdftrzJ0bCLqJAWiLeEXHseiewweNDnR1D9w=;
 b=T93VrmoPWwHgPhA2IDBk/kVNatHx1iaPTAyul5nENy7UmgANWu6TH4S75mA3zjSJjpBY
 a1VpAp7ZaW6wl5CwbMVCYKWB06s8nJjL6QjFpzAuLeqLGRwsTbPYbi5526ycehgC6vJO
 Dl4Lbq1rK9QzDF89s/LEjl3FbjbuWYhu7VQ= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fe2myrkdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 13:23:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RF11bbiFW3GoGMkqJ7g7/8N5uVG9B6XvJ07iZx00KRzf2884/lyW6ROZqFKhbnKBYpjHCkPtIQx4V98Akvh51Uq5871Mq121H5SyhZrcrddqQgxQOjV2xX6aAj0bGwzc1xdBATMdlAsBH5As0zGB1AklsM3lEgeZkwW+RpKToiIdZ69ucGSFh99AlIOG8qfgqW8j5jny/WxqSms+C1hEl1zJLMPhYNxDmZ8qtKLMNR5I5slOY2Na2WnvA1YLrfw0TFUoo1+P3RGS2d4EBJtNmCp4qbZ6nPP11NY5dwQSZcaiY9x1ob0GH1DyT0SJ3KrPFHaC3BHgVzGYkyevQQcVmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OD4z5laTdftrzJ0bCLqJAWiLeEXHseiewweNDnR1D9w=;
 b=gzD8B4NRy//YAFPT9qlmINOUyLu8txIEY1qOyklsB7J5SEebfKxh3O8Y8TqnoxFax8+5sk5zWrxUrCeXxv3BAPKt/lUzns57GhTja6+XBTHUjmVJQ80QTAK4cTsVcezJ7ZynwFPnI5SlXgQieNOhp8qgyURs/PuSkQLyKlgeStQf/TCrc1QDUSVpcDOFRwxijeZoh6ydtwysVAoj+mqJ5i0y1z7o6TM5IXMXWa2tKOE08T7DWhAZY2mTC+bmTaFls09yLzc4k7MEatCHtEjxpYJEKVsanOcrX4sPUEZM7BNz18kWGy5foQeBaAlkW3rTiaTuv1qSlapoGjsryMImSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB4055.namprd15.prod.outlook.com (2603:10b6:5:2be::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 20:23:48 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 20:23:48 +0000
Date:   Thu, 14 Apr 2022 13:23:45 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v2] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
Message-ID: <20220414202345.kireigrz7jftmes4@kafai-mbp.dhcp.thefacebook.com>
References: <20220414161233.170780-1-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414161233.170780-1-sdf@google.com>
X-ClientProxiedBy: MW4PR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:303:8d::32) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aadcd2ff-e85d-467b-a721-08da1e54ae7d
X-MS-TrafficTypeDiagnostic: DM6PR15MB4055:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB4055439E5729C0854325D984D5EF9@DM6PR15MB4055.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cD+IdYYijsIR3a0eQ6/qGLid8ThhsYs7gC0tqOSua1pmgQbktMecq5iQqGYYkQI49ISpyFv/0wCelfG0MwwD9+WkBAm1EVQrQTS+l4sVp3iLUsx6bOZHqwB3Z94jFMbZrk01uwnJCw0T0pK8zeC8Zgs/CI7HnNEDJDPylEDxm3f5ZxKbi4dcAAUwc0J1Q4YP8ZhSAWu5oem2N5Ih5H0fP0Rf7yM9b9/HgdchCHz+64EHazEi3uI1y2S6ab/yQIHRZMytkRPR0fOJ6D/8w0xW6euVTVISZX5UFrmmC3YpRRejLRGeTwl+gJBtV0bhQfeLuEEHWb4kRb5P0eGcj88uLkZqsWChPqZLuHi5OijaFMIf6Pz1I1k1jFXWWjl+BlgMErCXpqudICkt7nJdvT8HZpwIWvL1zegYcEgYIH9XtSmktqu5VvsdaFZCBfROXQzX7txv8aG4g+2zBiZpjkcAZiKeNsvNit3OUpUPa5mBSjBzZ2j5iHR8FyuBKvU9fAtdlbUVffv2rxHOY1WOWXZFgalDxp3u+7MFLS3xhZSFHU6TL3mayyVzjvxfu5ORKwbg7wFByH+ptZYT0bJi7A5ivNCVE4y1VEcmWfVW0mYNzCGAlhHEEvg1DuV6c88oSJHh+xrpmvH1qXTc7vUMavz+YazkL9mj2lvp22ywXoViMva3FHy9BCRwJItzPRmEq6+NsrH9pHNa1oPgO1Z6N49uHfzQwIkL4pWgJkD3uLEHR/8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(38100700002)(5660300002)(83380400001)(6666004)(66476007)(8676002)(9686003)(6506007)(4326008)(66946007)(1076003)(66556008)(186003)(8936002)(6916009)(6512007)(52116002)(508600001)(316002)(6486002)(966005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K/TwD6PCjuTwpx+m0meqfXW30OLiu3BzF4Oe1UVKGa4YKD5xQs/3501CvA5/?=
 =?us-ascii?Q?yJqpeEnGdpiTaVo9wMm2ZRawaEIykJzolN2BEc3D9s4YEWWjxn5gWBNfPlUK?=
 =?us-ascii?Q?Dtyit+On8OMrd9BDB/8aFnRzCG6UqtXZqxYs8SEBqWUmfxg+WDlU41LGubiZ?=
 =?us-ascii?Q?8W7UoU6yd6qhHjlehfUrX2wmKWxFWUlOdHmtoHcKd8Lw7afqx90RdswB2fhT?=
 =?us-ascii?Q?fpltMoJxBbuCSV98FGTFAV2vNy5IFCS+XfMHEjPDgzZ7ggJvRor0GoYbThKu?=
 =?us-ascii?Q?huhgClCOjTzYsBxCK+6tEM77eJYVojF5DaSyJRdVcMXs9wO3lDOZ9jU2OYYR?=
 =?us-ascii?Q?VcYvZ8LRZGwQtcSBhd37eJQ9GchRo2Nrad2OXSwFsGiiuQN+/m3iS0StM7FG?=
 =?us-ascii?Q?eXTwcAhtf2iqeFsoNOEera1h4+73Xpv5+VfgyHSchuSA5wYq0o0zo4aKsRXJ?=
 =?us-ascii?Q?78gFARkiEcVZLcIS3fmD89q6FamwlCIRg+912T3RX2HcYrRvCULwaXt4JdyB?=
 =?us-ascii?Q?jLKMP+QNSFJVn9vej5cr2XYQm17lHSz7BSvqhPdHymUdroBeoAGNk7vvR4DR?=
 =?us-ascii?Q?VvhbFCPMUcHjE8py2LKZU3KBBDmFCDTkpAOfnVAIxkriPXXqlv3bdwmsRqp/?=
 =?us-ascii?Q?iUg0TBdsNpgWDCH5FtNWKupjHOzWFGVCMwKHQhTLKzRzGhG5AoPvLuh4eCga?=
 =?us-ascii?Q?SujQoKXNt5gHEk8uENxL5oT6wiIJZWjAMoIYQ7M5ERZKEp5UrzNB8XY6h84B?=
 =?us-ascii?Q?GScUzJvde16pYWEQbUvkvzUcEly99XAp5UiP2b8KsMkZSC9iH0wy5BaeqeB8?=
 =?us-ascii?Q?txFGCngn+iFUB+69FKALLjpTpGqLS5VlzNbjVU/QiIHHrwhrZ4Pxnta6GSBb?=
 =?us-ascii?Q?hA2lLn0mGb/1PNaWR4sTVqCyr1EQb/FFvHGemRfjBoyv/Jk4XNFhgHHlLm9I?=
 =?us-ascii?Q?zliC0zzX+JnMmyNdzbFOU7wXuADA/QZQTGj4FKavRLGriwD/EECGKhw94UDc?=
 =?us-ascii?Q?DLWBXVRjMdag77MGuUqGsojQ9zvCPaWq8xKZRV6bjxhU03W6QRTGWT95RnBE?=
 =?us-ascii?Q?C1PlBJsiliVnzBMpOq8zk3F4/wRBEXCc6IMeX5FILu3KgxUvqJfb/8/27YI8?=
 =?us-ascii?Q?24B79wzQAZ68fOIRkXxZ0t2av1tLZL15GWUOAc8nUhOG4NLDCAyvwnn5GlrF?=
 =?us-ascii?Q?T6ess4y+ArbqH3Zhfc62Wmjpy4fL41m5oCtHdCeUq5QRuOjwIewgBxebfIRM?=
 =?us-ascii?Q?Lfa8HRummiGnTF1jeWc0VIqwYmiKQxTzfLMSVMcMGqCJ5Lq8QPMvBr++2+/l?=
 =?us-ascii?Q?WnmSv6AO1kA9KuiqKLNUwl03j6Tvl3Yym3OGCPGDrEjTJ5Y4Gg2qYPCAhhFX?=
 =?us-ascii?Q?df4K3oYxqHFcHudrIvb/Rhh6YxqdGuU3aLDGAARCQ1thCmKL7wYxFS7zUohi?=
 =?us-ascii?Q?/2GCorueeKlqS5sAFmwGXBm2kPH5qKYUXaywhjYcEEUNCUcyzfl60JzEjLVB?=
 =?us-ascii?Q?b9uWI10C5lGbx+oMeGRbgBLChnNlfX1AiOxdPm0tNLYYkFT5SDEF8qE6Ndtq?=
 =?us-ascii?Q?fD6uY9XKBc+LOacKyDnz173nwjGS109yBw9982nQHPUlloIon7m3tG+zUYbb?=
 =?us-ascii?Q?Y1BVb1bUhXVkiw90pJks5xsxDwaaF4OhY6sTykMTodKBLrbu2aypSuETU0N2?=
 =?us-ascii?Q?Wlbf2B0Olg1nHwQJtAYaaI1ZcMz82P+/bh1S47OIXJAskGnxzjVU+tezw8BI?=
 =?us-ascii?Q?DFjtosOmQyQut8dSRSXLe4HohuasIYA=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aadcd2ff-e85d-467b-a721-08da1e54ae7d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 20:23:48.2714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R2hqWyK0wj4AKGCMe8yQCdKt5Z+XxUfD1uT+5WMbXv5pxgj5Is54bUeWsXYlIhPw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4055
X-Proofpoint-GUID: hppVvRcMGHSYLGswE6EFN5s0qwGTcasC
X-Proofpoint-ORIG-GUID: hppVvRcMGHSYLGswE6EFN5s0qwGTcasC
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_05,2022-04-14_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SCC_BODY_URI_ONLY,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 09:12:33AM -0700, Stanislav Fomichev wrote:
> Commit 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of macros
> into functions") switched a bunch of BPF_PROG_RUN macros to inline
> routines. This changed the semantic a bit. Due to arguments expansion
> of macros, it used to be:
> 
> 	rcu_read_lock();
> 	array = rcu_dereference(cgrp->bpf.effective[atype]);
> 	...
> 
> Now, with with inline routines, we have:
> 	array_rcu = rcu_dereference(cgrp->bpf.effective[atype]);
> 	/* array_rcu can be kfree'd here */
> 	rcu_read_lock();
> 	array = rcu_dereference(array_rcu);
> 
> I'm assuming in practice rcu subsystem isn't fast enough to trigger
> this but let's use rcu API properly.
> 
> Also, rename to lower caps to not confuse with macros. Additionally,
> drop and expand BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY.
> 
> See [1] for more context.
> 
>   [1] https://lore.kernel.org/bpf/CAKH8qBs60fOinFdxiiQikK_q0EcVxGvNTQoWvHLEUGbgcj1UYg@mail.gmail.com/T/#u
> 
> v2
> - keep rcu locks inside by passing cgroup_bpf
Acked-by: Martin KaFai Lau <kafai@fb.com>
