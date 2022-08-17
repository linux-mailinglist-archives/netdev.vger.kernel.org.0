Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01A8597973
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 00:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242469AbiHQWFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 18:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242463AbiHQWFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 18:05:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36ED7A50EC;
        Wed, 17 Aug 2022 15:05:31 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27HHrq1p016900;
        Wed, 17 Aug 2022 15:05:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=GDYD6hIESMf0TTAGiXTCRM4RaATbzfvfzP8YK/5/sPM=;
 b=P2yqA8DXe1jb/btubXNk2n2Ge15Mdnhmt7ybtV4fNkokvuuTnmmSz2Jcu1a1TNAOarVt
 oB1eLhtFe7Wu5XH9Fwbs9fWiVMtHmxIa3l9tCBk0OKG1RC8lfbyHUQg4FTvUlUWbfYlP
 F7PKYJh3MpvU2g+fNRKT3tRuKSbj7XlvSa8= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by m0001303.ppops.net (PPS) with ESMTPS id 3j0nvjpjpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 15:05:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AteAxR1yuVZucNnZoeHyi1z6KigFszgphu7nssLnNd0b+st9bbZqipuWLBvgh+L4966eQoRVoW8LV3/zKHLNyTP9734JK9xScD+sukmGj74kkppqHT6fzJ7lkIv5uE4bIuuXaqIB0y42FMU4xpyrOH99xiNv2j7LcOt/h88QbL8b2StvsrTgOWle+uMDxV9Gyc/SZ/NZCbzqU7OwLucW3VBjkD3IK/VLvRNjj57AzI+wbhQmZh1XxJfKx6JK4mRvOWKma4NTQVlqwzBKExSej3caBCrRWZhmKpFRTsIaZDQa36IOpKHjErB69qDBTSdzY3etrCN6jQlIaQnckI1pVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDYD6hIESMf0TTAGiXTCRM4RaATbzfvfzP8YK/5/sPM=;
 b=PAtVISodFqLpwPR9dW2IRnNPRPUAHMUkcQQZonv+SR6J708c17uxtIGWr1eCgQShjaJJ/v3ZUz+8ZvPGABTW1FmokSnb5ud3pJWhaqOCAqWUVSOYQTkHQTT/LrpWyho2qeI/paLV9k2O+Mm8RED9w7vdueIpHFJmBpVpdvvQejn9VPyxcjYDtuvVxYh/5NfrTQETJgpxnCvp7WWK9bnGX2U3y+OIBFaACIdzBLAPUk4uSXs35YvRuTHaVxqmCDCGHkArpkgaWcvQ6N6cfE6GUaHHjV7I6h84eLSn10voblNLYELwarE2lQCJKvhVxcI/mg06/55pfNJQKgNdl0DOLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by SJ0PR15MB5246.namprd15.prod.outlook.com (2603:10b6:a03:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 17 Aug
 2022 22:05:03 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 22:05:03 +0000
Date:   Wed, 17 Aug 2022 15:05:01 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, Martin KaFai Lau <martin.lau@linux.dev>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 3/4] bpf: Add support for writing to
 nf_conn:mark
Message-ID: <20220817220501.kiftkkaqepooforu@kafai-mbp>
References: <cover.1660761470.git.dxu@dxuuu.xyz>
 <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
 <CAADnVQ+G0Hju-OeN6e=JLPQzODxGXCsP7OuVbex1y-EYr6Z5Yw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+G0Hju-OeN6e=JLPQzODxGXCsP7OuVbex1y-EYr6Z5Yw@mail.gmail.com>
X-ClientProxiedBy: BYAPR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::43) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa6aabaf-fbcf-4267-55f2-08da809c894f
X-MS-TrafficTypeDiagnostic: SJ0PR15MB5246:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDWicvL3bBcOdF9ijTiQaA9ieqOdQ05UamgYt8R5KiIuTc//Br75AeZnZ1U6mXwNDL9kAha19XyZ8fOQ4tajYg/6uUs+Jwl4VJIPtEqeU+6ccgRvydi7Kqaeby+ra2k7Ncp3YFfEPW2fDCE3b10+REL0ZbJeoBIV4aA5fmofKiaSqN4UNGOk2rBFDpRKlFqU8tQ3GDBq9iPSC8GrtMZkdbIm4SNWWXafudYnv7c5SdCgWWmuaJX3Hcc24JsK21bgWlortXEcpWt/RGnsWIkMaxK0W2C4vktxcd57LX6ZlghXpBcgy+UVKWBu/z1zRFjPYJZbPTywC6SDYhuGaNqt6sSPdewqWF9IHcZ7HAeFTO8ubxbhUPPEGFcgGcYFkgxSE75m+QMXXAeFRru3jlwzaHlytdLCG1W3Oj2kwO0vMrveixoImpF/hRt5GuqS1NjBvTcidpyuH9mUhoi2AkC8GuDK2OBNzNgLSNdw1xOa8BGW7lAk4e2TZ+UlHWBAy+xXYhhv49Z488w5oP6BHAgoT7M/RvYAgGmJVpVmJpgMmu5BKwOc1kTW6rLJbsFcjtpYMHxvaWK/dI0MS7EDTGje4HFByZoqyT2asklyQO1BNOm7lZuni77B4+OYO75rVLZbZY/KeptrDc5JtIRybl2Ou698lELY+CF98xJ9Q8HDBRCh3l54CCAtyIne2+P+0LqEZCmEJgu4qI3njPleAMeDUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(366004)(39860400002)(136003)(346002)(396003)(54906003)(6916009)(2906002)(66556008)(66476007)(4326008)(8676002)(66946007)(5660300002)(8936002)(9686003)(6512007)(7416002)(186003)(6506007)(53546011)(52116002)(1076003)(41300700001)(3716004)(86362001)(83380400001)(316002)(6486002)(478600001)(33716001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hS9txzFm+Dx04gU1OCtCjIcGtP4SHf5xIC+BlzflUqu6f5vw9gsiMBWDRqju?=
 =?us-ascii?Q?8HPIDeBVbnG2JQ1soshUAIKtSXptuyPZ0wbPRBfKdXFYEVefrVKKC8NKQvBs?=
 =?us-ascii?Q?ZYrPfoL+tyn526YEc906biAaR9DB9lbD2WQ+ilnUOTVammsybUz8uL/mVmH+?=
 =?us-ascii?Q?Mi84t/Nrs4hu5obD3piceQjQfowid74+IB5oXGrMjnsHOB/Cy5EiGSD69kGP?=
 =?us-ascii?Q?FtJF4SQPaXF4Fr+HanviQiL1cCxJOUUi5VwQjjEjv25m4RMpFk/moI9VsTqW?=
 =?us-ascii?Q?X5HLUncu4v05ZNvqA5uYM54W3TMz2SZ24aRnad8skPxwMxRs+9ZrWZCxjHgo?=
 =?us-ascii?Q?Rai6gtPBicccYgzOdGrFEw+5FktMvPh59/gCspH8HOZHDY8y4R3OEeZb/Sie?=
 =?us-ascii?Q?bAlL1U58htnnd6j6TaOW8DDzBJczM85/URU/n4s6TwC8Hd+3bEfxy+59dAlU?=
 =?us-ascii?Q?yjJb4QtsHcnPteIikg4bLFPFTKOW+QCfj0MdUfatAHTH/K2rC3teBGSPs13h?=
 =?us-ascii?Q?U9aEUtUiI19wpI0A3GaPcgWd+WN+7lSndJAT9x/anzNFHDR7sk+1jBNuVrqd?=
 =?us-ascii?Q?kYQrHLaoBqzj7yGYxrjctUeXfOS3r55xaq+24Kb2REIrwJIItr9NorvtiL8H?=
 =?us-ascii?Q?b89vZQROVnbFitVFSCDMYdVm87pIpkZi6SI6reexlHlC5uEbkEVv8sp3V9Yl?=
 =?us-ascii?Q?XEXDmh5LxBT5/gBRQS/2/qy7kg02mmqefuCftn5lIOcApyDuiG8E5YfvAsRc?=
 =?us-ascii?Q?L5o7YAixICAK7zhSgsEtPIeLCHQ49aVXyXfnstl748QgseBhD+xTsa28W8f6?=
 =?us-ascii?Q?PiAZVGz1A7cc/CcRKaoZpcyw8R+auaa5+KYbcEQqT8KF0wYazyASvic9e5/U?=
 =?us-ascii?Q?33aCHsOtV9j3lnPl0om8+jllaHBc6gXvjnkFhZz1zvD4ix046B6kr3Y6FKw+?=
 =?us-ascii?Q?AnPpiCG23X9276lS6krqANpNItRpQ4sNeBs0nH8kw1bDditOZ1VhLt+hfAYP?=
 =?us-ascii?Q?me16Tb0zACYs2G9otyJPGLwB4prkezpxpS4peWzNHOFF7bNAv0OBL1RJUAaQ?=
 =?us-ascii?Q?v91GVtEAQ2CJa2iswvN7Xgz/ZcmZJStLNP+fiX+61ct1NEYKp9wmOOg7m14k?=
 =?us-ascii?Q?OfVeo0cQiKOHD/8HH+3D3muhVflusOy6tD61GvtuVruGxmDNRMobUqmwaWn3?=
 =?us-ascii?Q?w16jqltXZbkVWGxAoCIobyn3TFFEnu39Mq2MBNSVaufJHC8rNaKE4EE+g+am?=
 =?us-ascii?Q?noR7wmq6l9+zzDv5SSYpnrRcvwkad6sRCb5niPRGTooAKWk3eYkWO32sK9PE?=
 =?us-ascii?Q?eMGkMJbjuACWHzAgDeb3+euTU8KQ6kpX6CsUcr3s8m6K7kCIYHIh1AdFoXfk?=
 =?us-ascii?Q?xvNufxN7sAG4GJ1gmcUb5VIgsueecMGbv1HknxGAI0OyOPIuKwkwlsNRhn42?=
 =?us-ascii?Q?PxTk3ZrKHP6L8LOtk6geVRSbbXttrQv70r6+iff0t6nTapCe9ZUVacENMMJy?=
 =?us-ascii?Q?oJCyRcuc65Mb+zq3bvPW7SjdZ2QQkHgYw4QuAJHLWLwDrs2iTksK68aOgA/o?=
 =?us-ascii?Q?kERaA5t1jj526dGHXUN8kcBv/bO8vudKYXdlhyFgepnLn/QUj80IOo35dJQt?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa6aabaf-fbcf-4267-55f2-08da809c894f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 22:05:03.4527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjtyhyWPDolqkTUU7KLeGySuapeG+i/Fx3CJPvNOdWOlSZ+tYFmsEjQJiYmEFSl8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5246
X-Proofpoint-GUID: fgDZipQJ5COrgVhGF6VnQZXhO3uq3tSE
X-Proofpoint-ORIG-GUID: fgDZipQJ5COrgVhGF6VnQZXhO3uq3tSE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-17_15,2022-08-16_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 02:30:01PM -0700, Alexei Starovoitov wrote:
> On Wed, Aug 17, 2022 at 11:43 AM Daniel Xu <dxu@dxuuu.xyz> wrote:
> >
> > +/* Check writes into `struct nf_conn` */
> > +int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
> > +                                  const struct btf *btf,
> > +                                  const struct btf_type *t, int off,
> > +                                  int size, enum bpf_access_type atype,
> > +                                  u32 *next_btf_id,
> > +                                  enum bpf_type_flag *flag)
> > +{
> > +       const struct btf_type *nct = READ_ONCE(nf_conn_type);
> > +       s32 type_id;
> > +       size_t end;
> > +
> > +       if (!nct) {
> > +               type_id = btf_find_by_name_kind(btf, "nf_conn", BTF_KIND_STRUCT);
> > +               if (type_id < 0)
> > +                       return -EINVAL;
> > +
> > +               nct = btf_type_by_id(btf, type_id);
> > +               WRITE_ONCE(nf_conn_type, nct);
> > +       }
> > +
> > +       if (t != nct) {
> > +               bpf_log(log, "only read is supported\n");
> > +               return -EACCES;
> > +       }
> > +
> > +       switch (off) {
> > +#if defined(CONFIG_NF_CONNTRACK_MARK)
> > +       case offsetof(struct nf_conn, mark):
> > +               end = offsetofend(struct nf_conn, mark);
> > +               break;
> > +#endif
> > +       default:
> > +               bpf_log(log, "no write support to nf_conn at off %d\n", off);
> > +               return -EACCES;
> > +       }
> > +
> > +       if (off + size > end) {
> > +               bpf_log(log,
> > +                       "write access at off %d with size %d beyond the member of nf_conn ended at %zu\n",
> > +                       off, size, end);
> > +               return -EACCES;
> > +       }
> > +
> > +       return NOT_INIT;
> 
> Took me a long time to realize that this is a copy-paste
> from net/ipv4/bpf_tcp_ca.c.
> It's not wrong, but misleading.
> When atype == BPF_READ the return value from
> btf_struct_access should only be error<0, SCALAR_VALUE, PTR_TO_BTF_ID.
> For atype == BPF_WRITE we should probably standardize on
> error<0, or 0.
> 
> The NOT_INIT happens to be zero, but explicit 0
> is cleaner to avoid confusion that this is somehow enum bpf_reg_type.
> 
> Martin,
> since you've added this code in bpf_tcp_ca, wdyt?
Yep, sgtm.  This will be less confusing.
