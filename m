Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1796558B74
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiFWW65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiFWW6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:58:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAD45D110;
        Thu, 23 Jun 2022 15:58:55 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NK2q6e024184;
        Thu, 23 Jun 2022 15:58:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=oJfAslOuFG6+95INgN5aQMuw5PeuHSLSAHuoq+JUDRM=;
 b=SvUJ7DCgMRmyYBgUKngbbPzOGaRZzDRzlWvvtceH5s0gvGm5c3RwyphtOh8sGGaQK/Xv
 hGtSQudF0lTlOY/SJAawOBugFlIud2SxBA57G1f1Kaxhq+HISti15LgXWVWMQsvdjDaI
 3paB6dlNxL+ZBKRdkxmMGnlT6b1vpEmsE84= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gv51naqjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 15:58:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsaAKtBTiXUR9L9ffhnSZF51KHloCSOmgiR2LUPGGeVyWxMUfNZSKHkfN7kKIuv61tjSa/HCxZlRYWrAfCxBkTrUck1dNHTpTrPLjF4yZ7K6PlNsdVjIvqr8TSvV7tatl41CM174chWQIQOMRsIDsVixYtmHDo5XgNHlyDv0NX5wc+oshZNE6cRXufIICgcMf9uGNlvPDKxP1MdvJw6rq+Bzvgk5hQnrFS3aYQxPTh9DavQutdLNVyRZOHLohLl5Z1794CP7G3HnAFUdnsJhoiRdPUM7V1nM888PUsPN+Chzmfj4xutbMby1O5B3VvYdkjO/cIv90KMOf0MS8c2erQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJfAslOuFG6+95INgN5aQMuw5PeuHSLSAHuoq+JUDRM=;
 b=kJJCDltP0jH6dR2vNypemNxrInvSQnTuRVX88dhanG5Rsm43foIvedoxlcu89ofgBXLnVtPLVw37D5LwznmbDMaoanr3BTh1xt1o2caayG7+/C6oc/I9BWrEd7sO18fh2SyEftegCkUVIPJu448RE6Uc/8IiWanRpDvXZTs74Wd+7hwYAXQ1pJSr0JA1RhicFLGiKd153Grf2MmngDheIP2f38MnQiaLHJfXBF09P8VSf9TIYV7dF/FjcOCU0IeiMPKiGfa9VBSDsW5JOJE5eE7uN8jV6lLSGaqyl9qsCImN0sIM1mxCs+yDLmQc7XeBOBO8jrdMDPmys7GTnm9bog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by SN6PR1501MB2093.namprd15.prod.outlook.com (2603:10b6:805:3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 22:58:37 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 22:58:37 +0000
Date:   Thu, 23 Jun 2022 15:58:35 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: Re: [PATCH bpf-next v10 10/11] bpftool: implement cgroup tree for
 BPF_LSM_CGROUP
Message-ID: <20220623225835.sxgxwpxi2xatlhvp@kafai-mbp>
References: <20220622160346.967594-1-sdf@google.com>
 <20220622160346.967594-11-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622160346.967594-11-sdf@google.com>
X-ClientProxiedBy: SJ0PR05CA0201.namprd05.prod.outlook.com
 (2603:10b6:a03:330::26) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9cef77d-072b-45e0-dd6f-08da556be825
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2093:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NCWESDEMM7lnprHizRvSVv3TzuzXosxClgFJQt7j5qbDeNPryqHG4mi2EeeRTLgC/xGpEOjp0BcSQ8NHytLdEZcdTHgVUZxSq3VYQrEL2kQkJ4IF+bNUUs9UgMhkVitqB32TmbS28QPGo6X4fpWKJY5V8fpPlC/IrhKML9zSZpv53fz4doqAsYxGdkNlCnzzHqnPAR5T6Phq57DXWgMeQbaLhZ3Gvm4bo7miLHnTihnlJL0Edao8NW0QL2Uo8l8hkL8SuFdJCdBDGK276uc5+3E6yP5vJvpQIsPsGjaW1Jkb6/Te6I8QOns4JYetztZxrr07bsskSgZ4HwqsPqffDdyRNcbTspTtG6nTiDVFCDSwvPK225KYcfusiwAzSzpJMVRYm5G15qFq+TlOQsDcMEU3mMxY3D9ZodKz396h6ui4ioQpELy5suO2Nv1goeoQDzMbJB6xSAL3PH0A7YXoAb9pII38a4R2q0OUhILeZ1ThQDwKCtMLXLrGJlm+BOB3dSax9ajDD1LfUNLkVh1kBkjLOgZ1JoDPGr2XH8MaxAdM7xqNU9dQ4UlvjaELfcE8lrU7iW83+/61fTSrGXrZOgqpWveWvpiNMJOYBJA52qa9V4+7AEYVdJU/r3wTp2fqN5SBTK4Dlxr/LMP0fS7PQDuP5UzcnJbBNs2nk/LtpDF3eh5BTyM+qvibhFlRWPb0lUOjEMpl+xpUpkYxzCZu+FpZkKpf+O4AkFhoBtBopRn5LOvoWDpbSkp7zN8J+nco
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(6486002)(6506007)(52116002)(83380400001)(478600001)(6512007)(5660300002)(9686003)(8936002)(41300700001)(2906002)(4326008)(38100700002)(1076003)(86362001)(6916009)(33716001)(186003)(316002)(66946007)(66556008)(66476007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nZC83wBDFgtfrdggQnsdc5nbIp81me84e8NimIa9LaIA0cZ67v28aN3PjZFL?=
 =?us-ascii?Q?IQe8+fDxDb+JZnA6TVcvJYVu7nMjJY7zUPpVETQczeLAmQkzFjDLn8TVxw4j?=
 =?us-ascii?Q?HeQldkH3ue6Lth95bAD08XxNdXlXDpR+i8MU3cnrLPM6Abn04Kpau2UGhpty?=
 =?us-ascii?Q?TAdVynnYGA0BqOchQZjbsr/EyFcnBGHwaUI/mtpcGSdGEm0hGY+ZJ6fEiApy?=
 =?us-ascii?Q?0LeKGAaDjefmO2L9OXqcf7+cINBGvXUR2Ie+/RdyA6dLMMU2kG7/5NCKH/ZA?=
 =?us-ascii?Q?TENOxrDPqR0r/zb2hudl/p8Zb8zHgCrllwUsVA0CO4dqhjxok6N3clYS+X1u?=
 =?us-ascii?Q?O3HSboM/drt0MjwFDW8awWbxIwLm+uE3lXUQsJ/9FuwSvYBAxCh9sECseOjq?=
 =?us-ascii?Q?8xwwaEh/zOpKPGXzXun+Z+LhTxsEwwlDpie0Dkd9XEATcwJy6DvfXC8ZW3Wk?=
 =?us-ascii?Q?9uLPJ+re1ZsYy0StX+cy8PrSQ0BqaHcz2ooQAGucybRf5X2kZiTdvNrvYhDb?=
 =?us-ascii?Q?sKZ1dPNPz9US7ZfS5HadMa88aZ6kV3ZOM1k4p0P7pz2H3XJvPwIVARDsx0LY?=
 =?us-ascii?Q?37YwilHehGiJRMc/H+NulkMV1Hv41TIsRWwS7qfJlA/0vg74Y7EIWbH7NrrN?=
 =?us-ascii?Q?OaEF020c5VxlENXdcTSzrNXprMguZTpVyYQ2SK5tCMD9QYdMcTqHyWpCKHNb?=
 =?us-ascii?Q?TpdXDK7nKiMrU876V218GJl8HPzIxhw6RDN/qK8i9qSKIXIs3/V069zh59/U?=
 =?us-ascii?Q?dutDwHY7CwSUBP0rU/H4vzKfoUMkPlMXc85t6IFknkQ7JnInq6hhQ+LCQLWp?=
 =?us-ascii?Q?0yPEvj4fKmnWFwGYYqxSv2c4BTMh8NHzKWV+q33hLC+S+5Kd627HWAUUAOv5?=
 =?us-ascii?Q?kJbIvBxNDioKh6wLjZ2YAqWflsGlwHSIdVDk4imUeXqkAZlAGYrRZx6yWbhW?=
 =?us-ascii?Q?mwG2mM/B/hwfjY6brm/+fDEwOogv+aT0zQl3Ne/vxzHd0eRIvI831v4IG2OU?=
 =?us-ascii?Q?WhQvjN1kqgBn2uRi6MPF2QELZqHcELlDlBIFxWO2eq2RqaZqv+TWgTMSLSHu?=
 =?us-ascii?Q?gQ0alYHEK0kCGBbJjbspArrRXjCNQbTpaX46pyhDqKCzcORmExJd7KBho/+q?=
 =?us-ascii?Q?gaqEN4fzINvYQcfPheauTQxpfuBFvxW2CJKBIkWbrO2sgroBku8/JC34vIIA?=
 =?us-ascii?Q?JTyZaM8HNw/ZJfw8sdZAv7B8AGZx29YXNXtALRGjJmrCwnZz+TEDX4rOjWWV?=
 =?us-ascii?Q?zfYZM4jRzHnsEqc4FZft+BriooYEJPYc/F8ml8Y3jVNRQrJKNU1pNE6kWV7E?=
 =?us-ascii?Q?bSQrs2w+PaByFtnbDzzeNM7XQUYA8tDC8/gd4JaXoLvqFefcZdQK4uZ2pqO/?=
 =?us-ascii?Q?kQ18lImOuzZoH02JESpm0CUlZpTyNnn21OC8a9RCW3QwyXXFkphxRcknLUNN?=
 =?us-ascii?Q?Hs9Bd+z3KvY2QRCJwAYfpKsrmglrp+4D8eiCWL/ePV1gLgKwjJNLmHjhtjKP?=
 =?us-ascii?Q?uR7NDPabuwgRzhr8kef41wPQEr2uN+5SLwgRbtGB36EQs8PtMt1CZjAm7q8q?=
 =?us-ascii?Q?0kOcMWKVzBpoMSn5vh/HByQXWCzWiHCcsBTrXRNBIXkCiPyNbMQLZwfT+368?=
 =?us-ascii?Q?rA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9cef77d-072b-45e0-dd6f-08da556be825
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 22:58:37.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PxhwWf/TmlxTSrUzzC1p42SPGBWQlLnii4EX7KStyPG2LxQzruWUccLriKrqKzJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2093
X-Proofpoint-GUID: e5AgctOwQkplhpRs8INcRxquWOEtzN6i
X-Proofpoint-ORIG-GUID: e5AgctOwQkplhpRs8INcRxquWOEtzN6i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_11,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 09:03:45AM -0700, Stanislav Fomichev wrote:
> $ bpftool --nomount prog loadall $KDIR/tools/testing/selftests/bpf/lsm_cgroup.o /sys/fs/bpf/x
> $ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_alloc
> $ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_bind
> $ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_clone
> $ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_post_create
> $ bpftool cgroup tree
> CgroupPath
> ID       AttachType      AttachFlags     Name
> /sys/fs/cgroup
> 6        lsm_cgroup                      socket_post_create bpf_lsm_socket_post_create
> 8        lsm_cgroup                      socket_bind     bpf_lsm_socket_bind
> 10       lsm_cgroup                      socket_alloc    bpf_lsm_sk_alloc_security
> 11       lsm_cgroup                      socket_clone    bpf_lsm_inet_csk_clone
> 
> $ bpftool cgroup detach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_post_create
> $ bpftool cgroup tree
> CgroupPath
> ID       AttachType      AttachFlags     Name
> /sys/fs/cgroup
> 8        lsm_cgroup                      socket_bind     bpf_lsm_socket_bind
> 10       lsm_cgroup                      socket_alloc    bpf_lsm_sk_alloc_security
> 11       lsm_cgroup                      socket_clone    bpf_lsm_inet_csk_clone
Acked-by: Martin KaFai Lau <kafai@fb.com>
