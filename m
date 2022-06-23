Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004C9558B58
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiFWWnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiFWWnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:43:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB831EAE0;
        Thu, 23 Jun 2022 15:43:28 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25NK2qU9000408;
        Thu, 23 Jun 2022 15:43:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=NR2YIOm76rdVdXvSs2C5IIFeAuetVWuUwMVGM3LtVxA=;
 b=mFK3B+87SdW7gkVDROPj3lWANrwP6Ce2XbZ7oQzfqBVzU5liChR0du9llgr5hNxO5ta+
 ay4aCs4RXAsGZWf2QY2tYF7cFq3nrRmXUiauiGG87O9T99U3pIP9JKuv/KeVRfQqkunH
 jsqAfGSa+SAJ/94x7bF1miOdiZL+mNkq/64= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gvqwxkxj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 15:43:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLWwKhtN8dJBzB21lbyaybI5j+XyxITAYHMgM98jHh8I+ynxxBZmvA8c+4Az6FkgDfRfdVQfvUKs36lPX8zTlAlVmBQckuY8n3FSTOE9fveFTihRduz0U2tfHreac/7GDoTEL4Tx3qbEShbDVvqASHm89f72OG+1i5elnWtbMxANQRE7MHTFbHRZOS9rH1IB0XpUZ8d35Bi0LiITMuNPWWoWQEs6XCZ9fzxcWqkgRGFaFFFOmj+XWS1dMt4gMJTLsWIkHGN8dHedOFMn41a+G3NTjpMXyMSjADvbmy7qX8sjzoqggbX5GnefsWmtwvv1u/rdSZrB36F31V9fe9a2nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NR2YIOm76rdVdXvSs2C5IIFeAuetVWuUwMVGM3LtVxA=;
 b=ZM7ibE4S10MnsMKaVepAieutikAOs6uEe4Fg7Sc/58E85PJxAiYUSr6+G1a2IGRMcIYLz0MuXP91eJp63I8dzS70IaqoZ+ZPA11U33bfz+zoWozdYtDGJ3tGTFhHp2B0OeU3h0PulcyJOS+Z2Kj6vaXnQsnZd4O2qjOO3WWp0lCKug50iimptSf5GD2zf7gHJ/2FjS6X+sCR8oFvyxKflxYaGYEP4HZFFF5V6gXe/b+2rcwFubX7OL6dSN6KHz3llC8+0TIDyj0Slkh/ecMEcFE3mKKxx7YNLMKpvFMBz8pfm1t5WQmCxonAE6agRlxt1S96AYXPJv1hR4b3odPciQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by CO1PR15MB4827.namprd15.prod.outlook.com (2603:10b6:303:fe::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Thu, 23 Jun
 2022 22:43:12 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 22:43:12 +0000
Date:   Thu, 23 Jun 2022 15:43:10 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v10 06/11] bpf: expose bpf_{g,s}etsockopt to lsm
 cgroup
Message-ID: <20220623224310.nlictje6xrepmbo4@kafai-mbp>
References: <20220622160346.967594-1-sdf@google.com>
 <20220622160346.967594-7-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622160346.967594-7-sdf@google.com>
X-ClientProxiedBy: BYAPR01CA0036.prod.exchangelabs.com (2603:10b6:a02:80::49)
 To MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f25067c-5a8c-4a0e-df4d-08da5569c0e0
X-MS-TrafficTypeDiagnostic: CO1PR15MB4827:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d1homrS+T4NSKyUGZiOO1FLq1G9Y1fGya5iKZDaChya+fFqxU7RUHN7SSyI56ohhR9IglOJcqO+OgZiC46o08C5LxoV2I9fBRGMUHHXWcB37KuHwTxrgOouAF6c3L2wBqns0EoFCYflV01NeKVaAYUl2w0pCNKkT8rnyJ2kqIlTaaH6p30skEbdahNLS7qkO4wunvCxy/2KnHi/pD+qQGAMOfMw2e3S4geC9aPaPRNsJqA/nvizJjHR3qdn3rrauG1hSEJi1YCpY4B+VvRMzCj51woZjDarSTjVBNIUtDWjhU0Ufma9j+mZRjYmwB+pOjHdV5mva4GmWkCh+txnztT3Ea6duGyKFRwZnOmvFfT1IdWLYyiQIwksqFQ1Gu7Y1qQwUJwCrcZ829xTyOsizBSUk5sThutnA2Vv6npwNVQ/ufD2SdmZuD2dNicpAzKBhQgAg0HwbJrx2wGShDmGZi54Vt9SFL5ryT1WKD3d7vCdcT3ZTgidS/u65l7g7RMEz9mTeonkNMTOLu4ZEJcjWx8RK4O+OYti8nIa3JO7vVaOTF1m+yyeCDGG6mSUJjoisRn2VNfh8DKYLf4/jmmkfY8gqVMQUIGpdP3QYximUuDvBGruxb1n+Rgg6TThF3Vof/GGV2fypv5hThRGZkFi/dC7r5OqC6S2EMBi8eRFI7sxZVqmIvY55XO/r1TNqBQV5B+6XZa4pNb2xtWLDJPOe2eJ3q4V3+8fSUi7HhjnDz97PGw4Oe4ChblunNtIZgU0I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(346002)(396003)(136003)(366004)(376002)(9686003)(4326008)(41300700001)(1076003)(33716001)(66946007)(6916009)(6512007)(5660300002)(6486002)(66476007)(66556008)(8676002)(478600001)(8936002)(186003)(316002)(83380400001)(38100700002)(52116002)(6506007)(2906002)(86362001)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o/fh1ZEsgzeFne4+K6KgOGs90wwC33dynl2JejZPDyghcPKXXEwW3j/SK+yx?=
 =?us-ascii?Q?AffchLS2MSZY2mxQjOGd2UalTaX2+G7wZQ+8hFyVKoxXY0UEfZHbag/a2w6v?=
 =?us-ascii?Q?kXTpIOjh2+k/7CNMzjpP3Y0ASpVHbbIUPwrvKz7Rywjv+qn8zPOuZshp5G6Y?=
 =?us-ascii?Q?FsLwQDoZowK276o+BBFwYqRkM77Opb9qqdzi50kiqnmcVybvJNLS+OtUQl6W?=
 =?us-ascii?Q?n6HYeqdJzcJ2qCQkXXiRBWaXdqs3NwH2I4HOA1WrMSEOcQA0GvSUvqUASsUG?=
 =?us-ascii?Q?DznaXZ6jGNXGm/AJIPIEEFgj4Hokl1nm2iHSeaGPdHRqfQVOBuKvDE3QzYc/?=
 =?us-ascii?Q?ANgHSfsXPnZDWdna8Zu8jsleqfKeA9T9wYNgY0bnfSUON/kbqm6hJCHssuP2?=
 =?us-ascii?Q?xpNxcRxUPOB+vHV+YQNRoCGXh9Su1vvo/DsRbN6kJC5uZZgaOPT0afLwhg2U?=
 =?us-ascii?Q?naCuzg5PhWCoG2HXzexF7e6ejBLgi2wgN3hqX4PIGWgA1lQwLyeYv1LeD/1r?=
 =?us-ascii?Q?gCuFXaRzSXezYQtFq9nwpFFuk+s1psaHfL4QmSawMqMYf2tIRsT66sAibSgX?=
 =?us-ascii?Q?R+7s8uB/pEf6ScmwHxtScxN7RZM497LKczEEdPL91COeFZ7qiUS5zpjPDobi?=
 =?us-ascii?Q?/rPndbE1bwev9gozG98q/g+5fQFKiwlWyhAGRSvdpXAMfGlG3fBK5WqXSKjr?=
 =?us-ascii?Q?EFMPByWayZR2JtNVyca6mk4LKjGIvY2dczNGTp0DboFVkeeSKYL9w1BTWQFE?=
 =?us-ascii?Q?avT2c4IuxUw7SV9LFH99CBrMXKXZ+YJV/pY/IJo/RQ1mrHtSB287OpN+lehZ?=
 =?us-ascii?Q?UI6/xl8K2jqeVCFYQ+vr8j4QX4V6rtOQmAlSBspoQMnfN3WHLTRRRG0Ce1Cg?=
 =?us-ascii?Q?MfQ7yA6V82e4GFRbY1KVguUz8k/2V1P1nFz2JQkVlbz8+zgwi9kO9ltIcrqN?=
 =?us-ascii?Q?9ZZ6c71usKWis8HVDjX/JkVw0dd95LxsD8XH7te++/wZfonQGLayIByW7Ulv?=
 =?us-ascii?Q?UM1q+4PvvAltqB4hJZk4GFm1YC5mfqR9H/NjTf4VkeI7ifHA0MY9rIzwDNe2?=
 =?us-ascii?Q?9qVFbvkVeiWK8tEFAzgTSltq9mBmdpBmqCDdD60bcGLCGQaEwahbLij4cjrh?=
 =?us-ascii?Q?D88yEUQFfh9f3LSqgvHHXRJArDDzQbaO9pw0rQ9UUbLV2z4z/aZwAJk4ZNfH?=
 =?us-ascii?Q?+Uf/0iXdb4tEwQpvefyvwJ+gEKdRLg73b1gV/5Q/28PItkRm9rUXg4Le+4eI?=
 =?us-ascii?Q?tTWQhQL2C9mEbvaaRwQrwtydSOkty9jGqrBZbpqunzsVdBG+yorlm82Ne+zC?=
 =?us-ascii?Q?hDB8QcAIpNnjdbQma/ic3XSJbM4p4CzGzk8tY2RYRwAOLKCKYN/D6gGRC+L9?=
 =?us-ascii?Q?U56KiFqagNxMv7PqG3C0YmHeJi/SO4kTQeNYNAz7F2cVebA8pZXDqMFItvKK?=
 =?us-ascii?Q?7tbiMv7YIogZILyPkiLR0pdFXywxA3erInDcMmJKfJCmoSAOHtVkdixx/5pZ?=
 =?us-ascii?Q?8Km7HDMdDDIuNhKvpxOk2QeyVdnIcdCO9bRRp+rDnArWfN6Ebrd7+Wc0xjBh?=
 =?us-ascii?Q?xCMSXN2rbY4JAn5OZI4Kr6UcseIvQZfWmweJFfshR/8I6xYhQuCj9IlXCNLH?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f25067c-5a8c-4a0e-df4d-08da5569c0e0
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 22:43:12.3173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgjCpq64qwbimeg/G6JTxtt1bjN7VSo7qmrsQbkP090fO6xruAqeC+yfybPxhkXf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4827
X-Proofpoint-ORIG-GUID: 7efoaTmS6XtglBf0AUB_1dvAf83FFC4L
X-Proofpoint-GUID: 7efoaTmS6XtglBf0AUB_1dvAf83FFC4L
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

On Wed, Jun 22, 2022 at 09:03:41AM -0700, Stanislav Fomichev wrote:
> I don't see how to make it nice without introducing btf id lists
> for the hooks where these helpers are allowed. Some LSM hooks
> work on the locked sockets, some are triggering early and
> don't grab any locks, so have two lists for now:
> 
> 1. LSM hooks which trigger under socket lock - minority of the hooks,
>    but ideal case for us, we can expose existing BTF-based helpers
> 2. LSM hooks which trigger without socket lock, but they trigger
>    early in the socket creation path where it should be safe to
>    do setsockopt without any locks
> 3. The rest are prohibited. I'm thinking that this use-case might
>    be a good gateway to sleeping lsm cgroup hooks in the future.
>    We can either expose lock/unlock operations (and add tracking
>    to the verifier) or have another set of bpf_setsockopt
>    wrapper that grab the locks and might sleep.
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
