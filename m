Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECBB9558B53
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiFWWlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiFWWlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:41:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE05517F0;
        Thu, 23 Jun 2022 15:41:10 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NK2rVx024195;
        Thu, 23 Jun 2022 15:40:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EqRcsT3mkPT2mOU7zAtTuhXFDWBNOzvhCkkwUbEcFxM=;
 b=LeFzKAjYHUdCV9sE4C+OGmBSJmKiJMYEkeMc5gWi3kxwTExxbG2KQ8wchmI0Li1wuC8n
 G0cYgzZ1XSh4JlolbOddKlosUGVc2nvBQQ4+tgHcFb+I57b0xj65Ta0YpXNnYqTfcHNO
 gdOe7+xUR34GzBGQ56ZHR1kw9CjhrRPLWKU= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gv51namsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 15:40:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXw2dyTdSodOtTuE4cFFWei0H8KAkqg7yDGA+Ko/0TrFvgGPwtyn76o+LNlXKExywnk1j+QMkShFTfkAxDAGQcM7YTH/1rrRMoDSVNWtp2HecJAD/w+G3RFktHb6mqXdxioCpM/XbopJc8c7rI9h0vC/WoMmLekXrEreqQdV1MKdLPtQXQxlXy5np5V4m7ekyge8nrD8vboZk1msD1XJPGrzB8J9WzeprD+dvZfgTqqjt7lLTjUdJdyJDhj3QGy/n6JAGZCCYudREDk6XGnpKJSnN4O/aHnTP83VPB7kdhSBQL5E3CkfNFV5n1IHw5tVsx4e+SyFCfdIokkDiy4LXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EqRcsT3mkPT2mOU7zAtTuhXFDWBNOzvhCkkwUbEcFxM=;
 b=J8GvtHPCESqeysGtjfGf5rUS+UjPCfvYsYwPyqErdy9jOnjaYpeIh2vK5HGOY6FsU1qgS7tSTeyIXjl5mbU2hcz0sDTNzdwBcAQGZr70tKfw5ETvuDLWC2Xyfr5TjXuGUpqbz+GDGjyJJYVzQJRKINMYtD5U8vYDnOppRqKOohQAOxamJewUQMMPokKhGsd8xV/7eaS9JTrxxJ99X8GgI5KzUnxwf6CUKatqLmgkBFdTmQe+0GiZ3f+20CWndNwpcdCKcxb4bnrUXjouQ7YFbp1yVLl1oJdVsIbD5onHIXAH0z9Jwnw/6xbND9ZTlLlBznpsIaeC7CLXgbNTuVLnFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM5PR15MB1707.namprd15.prod.outlook.com (2603:10b6:4:53::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Thu, 23 Jun
 2022 22:40:51 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 22:40:51 +0000
Date:   Thu, 23 Jun 2022 15:40:49 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v10 03/11] bpf: per-cgroup lsm flavor
Message-ID: <20220623224049.4xnxd3kjx4lzpjqu@kafai-mbp>
References: <20220622160346.967594-1-sdf@google.com>
 <20220622160346.967594-4-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622160346.967594-4-sdf@google.com>
X-ClientProxiedBy: BYAPR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:a03:74::42) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8fb9860-be1e-4ab8-a266-08da55696cdc
X-MS-TrafficTypeDiagnostic: DM5PR15MB1707:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qwvWED9GRV8dtoGQXqNdj9tEtlhb93cYQdPZnOmmUcmLawPeYqV5RZI4faUvo9jpt1IvK4jJxpXJ0sE6RP99PqYDNtvmjqY43aO/NuNfFdWu+S+HAKE3fOlhMNSuR39V0RAhpzQ7XH1zTDRGdd8LdMcdJ+EBdjLduJwqXdHEFbGWjFuxO1fMbeQtchXSevPRYVLygKgm7inmb1the+tBjMB5OKt9FJdAzEMQXU0XJ+H6nGG/Kufg50EXEhcwJ/0i/U5Kpjvc4MyPDFTqiw95s5fIfK9JEBNBqQJVpHlv/bXXlYkAbkSxPDHmFgVtDMmQ1zeyY9bd4SIaTHl0iENOWiZ+0HInoR2BVh3Hr6HHQCMImxIKB9s+WfcFFNrGPRaT63qcbMOFH9ekBJhHcLOx1BYsMKkP+Wg3XKOIIyLaI/Qva+mvAQ912MGD+Sssb74D7A5Gme0BP+6YJAGxh3FebUgx2cBAPk1Euw7aF0xRiaXEQmY+8DH706YhLD7EIsZElmJR3vpqAc0QGJj9swxe9Z3i1q/1SSAsgQIS5LG54sSYaJmzWT4rRKBEY76Asf1tntfi4nzvNO8TuO1YKauuWKARsZv+lN28MeQlFa8ECVi9+ZqqXqb1MAE9ebZNQuG6Lp9P1HC8cf9lB1gI8b1Sr5RcIbPwcJHCAnGV9v3NKpH6q0PdOPHD2JrfKB74VeTMBqw/deVqcCjRbDe35T/yWFKM0b+rnXc0qhZQhUMRlmKEL1QJszAolk4sMys9gjO0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(66476007)(41300700001)(6486002)(186003)(6506007)(86362001)(66946007)(1076003)(8936002)(9686003)(52116002)(6512007)(478600001)(8676002)(38100700002)(316002)(2906002)(4326008)(33716001)(66556008)(6916009)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5kVHqK9ctF+Ho/OdVZQjtTo+1t7qDtoE0rWYyl7gQiE7cpF2HmDNVx34UceE?=
 =?us-ascii?Q?moiz4Hv0PxgARRYoilO35FnSXOcFtMJWr8LfjpF7h0i6uLhKY+m4ikyCdNOH?=
 =?us-ascii?Q?BRDT/ZQP3T5NTqaViyysLpUoOvfz6HeDjZTxgf9cSpTTYPYPOAq0jtA8Dysr?=
 =?us-ascii?Q?9zTN8ZmkwDJnFA96CcJtTYZg/HDPhIC9FdiRFb9d93elHMz2UWmPvvND24U4?=
 =?us-ascii?Q?9cO8wXeWHzYYC43Vw/gdPJMA8aBwAkk6jU1NntEfnQkIpmm+TOoBnvBQHfcD?=
 =?us-ascii?Q?PU+X5T+32nJATrkMFdN3dJZfNDcfh9myU7S44Dx66qyH9VbFsZ9kM3rpP1RT?=
 =?us-ascii?Q?RAlbkkDGzaxwmKMArj+jaNG1vaMnH/k+yuYsHU6ZfO6WVy7gXFjc3amFR9Vn?=
 =?us-ascii?Q?wiiU74EjHtYX/sgWQbQxwUzNelttUQFM6pNP4693rZQY6sQhVw1W70zLqCWU?=
 =?us-ascii?Q?d6GcR8XcsjYQAXIiE7xbVADVZ0Lu+QSBzPeJITNs/LfWzBt4uLhdhjmst/vf?=
 =?us-ascii?Q?gAc5BVdbUHrgd3Qout4e28ycP+/b2fpdYD4JA+qwjVVvyiBBQqThXmNHvxOY?=
 =?us-ascii?Q?jdIsYpzvDBLy0Eurq5sBL76JyCk1m6CD8JIZ3UiQliWLELyQ4gR9l3kXnYP6?=
 =?us-ascii?Q?ulx7TeNA4AjndsK+mZTK7HFuyJsdPMSHYI8f5QhsEg1LHIIOe0Qt4ltWv/pl?=
 =?us-ascii?Q?gXZMyw+H+q+Iv6txZe8Zn9uTHLzbRTkm/vupivKfmbchejfJRwC8+GGIvDas?=
 =?us-ascii?Q?NysAsw24CT+k+icF19fDhtt8WLu2Bn4TQdeISEIMxnvXLFqdnrYkHcQ2NnT1?=
 =?us-ascii?Q?CBccr7oY6kO/rPEeYjZmD3ZKJVuR/cl5m1EQORkRcfGthXcq0J1ARbYsfPrS?=
 =?us-ascii?Q?99xfkgbrnqu3Ipn950f2T0TJCJD6Xem11mkh8bxKYl46Hej9tztQb/eT6x/y?=
 =?us-ascii?Q?xnpE8NvJrXdNXJwKGDTqzC+AFBlbJ6svQDy5vG/5XR/o7VicrOQKgAeKbzP0?=
 =?us-ascii?Q?50KxSO/MuWUC850GKxaK6iTZn2JC72pZ5CTt0xyfYkk4uJlYIQ/pXbtJzeU/?=
 =?us-ascii?Q?rMCyoGQO3yhUfNgbdrHi49yi6B7A7lnPxMXGYU8yBll8mDmN+Ufo4elHGrIw?=
 =?us-ascii?Q?vwkXJGoqRG/4n+G5kesM28758JYfzDqYiBy7Ai0ckWGWcSl+Rr8J584kEEBd?=
 =?us-ascii?Q?gaLpyAX6DMixC0McmNsLXKYJXOcZRc3JOPO0uWd1pt+M2wSFxX8/7wkp/LXc?=
 =?us-ascii?Q?207JcdyuwRb9xfi+HtRSXgdNc2qoRgiE66LX1cyI0NJrHAX2rw8lRP9MUXaO?=
 =?us-ascii?Q?AJHvXsm9121dwHDVH4aoGwkpG6vfweAkpapgp4gotWmDtJYqGb+fXIDHf6JB?=
 =?us-ascii?Q?Sdx4JAB2yEXyu7bSoJ6sOLHMHZIUJcVFw7Yi3/iHAc0MIBeLasA0gdb3IKhA?=
 =?us-ascii?Q?y6+J9rlZppGMz3CswS3bpNqXE0EcTlnRCxpnP1GeB2RpEPY/ugXor0ojbx1H?=
 =?us-ascii?Q?sfoL6AK5g7hKT5OpXvP5Z8ClPlJUiGPSg/d5/GdKpNeGidGMsU3vqnrht7dC?=
 =?us-ascii?Q?St12kBYlkBlKIjmNzxxWy5lftAvDRWSj+IJO29znpz/0WonWQUJnimeyb40f?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8fb9860-be1e-4ab8-a266-08da55696cdc
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 22:40:51.4234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxPmDFqPbwFXn6Jt7FDXpX9RIee8ynLnQYlGwnC9gpU7e6tufx5YI0KUt1oqKx72
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1707
X-Proofpoint-GUID: _ubjNJ_IbIc259d4useBvib4Gz7NkSx4
X-Proofpoint-ORIG-GUID: _ubjNJ_IbIc259d4useBvib4Gz7NkSx4
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

On Wed, Jun 22, 2022 at 09:03:38AM -0700, Stanislav Fomichev wrote:
> Allow attaching to lsm hooks in the cgroup context.
> 
> Attaching to per-cgroup LSM works exactly like attaching
> to other per-cgroup hooks. New BPF_LSM_CGROUP is added
> to trigger new mode; the actual lsm hook we attach to is
> signaled via existing attach_btf_id.
> 
> For the hooks that have 'struct socket' or 'struct sock' as its first
> argument, we use the cgroup associated with that socket. For the rest,
> we use 'current' cgroup (this is all on default hierarchy == v2 only).
> Note that for some hooks that work on 'struct sock' we still
> take the cgroup from 'current' because some of them work on the socket
> that hasn't been properly initialized yet.
> 
> Behind the scenes, we allocate a shim program that is attached
> to the trampoline and runs cgroup effective BPF programs array.
> This shim has some rudimentary ref counting and can be shared
> between several programs attaching to the same lsm hook from
> different cgroups.
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
