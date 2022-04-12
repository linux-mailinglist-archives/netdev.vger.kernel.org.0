Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A8F4FE764
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351878AbiDLRnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358684AbiDLRnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:43:09 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1695A4F9D9;
        Tue, 12 Apr 2022 10:40:50 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23CFGOGR030849;
        Tue, 12 Apr 2022 10:40:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=OnXGNUJMoReOV1f8IDO+KNCpLgn5Jzz0/U1pntjbUOE=;
 b=qkb66uuRsptKMuEY+yYs2FwhptAqYWBRWE85bZ1TUjm97p6NSOhBmG74wUASmaTl373R
 jGVa8MgSwDiUFocU698r8AJdGjuxdzal02QUG1eD7gwzX6Wg/GEo0t1QeE3lR+COm2EI
 YURFflNkCWFU4I2JdqUqwSzTSOyDkFYZos4= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fcwaww91h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 10:40:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDXvIB4yqbQR+B+NC5VbBume4mb+R4WxYQa3NmgF65PSTB7ztq+qmkbKx2DIjgQfoNOSlGtIRo2cJdtt0QVy1l3MFpg2wmNCxkjBBv7g9tRbq9s+x/ZlzZw4YeObdIgWwghoCGtSmyELvwzy4PtgtdL4wu7oSKdepz7ki4V0nlWdj7TAAHpWUk4L3R7jwzyBcl4uLqmKDJwmPA6IAEDMSrjbM/8xS9WFK+p502C8FknVYV3udW7eWaLEhf7ObFmq5zDFYEUu6DT2113I0gdkSz/5IvRUEDgB2qcH4QjYGc5GEhv/xlDcqHHPkZEFUDufSfGQHJbQ1Ddv41JKg8rngw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnXGNUJMoReOV1f8IDO+KNCpLgn5Jzz0/U1pntjbUOE=;
 b=YJgTwfi1mxkz+V+cpdmfEpv2NcrL/wJ7Q1YRwhwZZiA3O1KpfzYQszKUvwOmfgYoGv3y59oF445qlHWNECl5fYhU/mNlpDjNjQ4+Jdvm644LpyfhdMRpQsvZerV7BHPHoVrQrxtZZ57rURK5k6fMGSs8s2oMAD06x5HMW2nacrasOG46O0+kjMLf8EfHO2rWjd+zAcXbtVxuDmC85LUNT5966tLqNh2vsyWz/SfO0Qg8IYcGXKceRNWLwDK8PE4HRbX7aVk2ecrdcyHzlGQlDjK92VF0jxi5bWohStBw0QPp9WmtB+INJVWH9zi9+B4EMpSumD8dL1ep8Kd4LB4YWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MW3PR15MB3996.namprd15.prod.outlook.com (2603:10b6:303:41::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Tue, 12 Apr
 2022 17:40:32 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 17:40:31 +0000
Date:   Tue, 12 Apr 2022 10:40:29 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220412174029.upzzk63klygpc55q@kafai-mbp.dhcp.thefacebook.com>
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
 <87fsmmp1pi.fsf@cloudflare.com>
 <20220412011938.usu6wzwc2ayydiq2@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBtMU2V3RpQBBCmaZyh1A-oB1ggc9sgF9KXWgPPp++iNhQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBtMU2V3RpQBBCmaZyh1A-oB1ggc9sgF9KXWgPPp++iNhQ@mail.gmail.com>
X-ClientProxiedBy: BYAPR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::26) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c20c402-1266-4d13-0d5f-08da1cab8a77
X-MS-TrafficTypeDiagnostic: MW3PR15MB3996:EE_
X-Microsoft-Antispam-PRVS: <MW3PR15MB3996C61445A865B25DEB51B5D5ED9@MW3PR15MB3996.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3a9+JJONYeDB1hTDrxm03kA5JdFn4d06za/JDEsCTAAtRfRKbVqvgWaN2/tffkXEpZ2w3SGnSFtAk1N3SPFWoxlWBDVEnsDCt5N+E1CnDHFKgqFfYq09OLUfHYD6/tuWx+WEKkHsWyawrewGa/0d6b9v6wkONmpz4wVTnCGD4udsolvIMu7ygnaxn531jSA3EIJpjYODatLv4R0XnhEKNwmxbnYDGM2S1S4JZq/whw2J0SUtxCdo1qBT7taHf2D+mct9luGXSaGc7BFlZtMtDvkp9V15vuDcYsfR6wEhfhJJZWYQEj2e6aQ9WRD888ByZUe26k0pPLWU4hdIUt/2JTJ0EK5iRjAjPXXHJU2ncc9AC/JR7T+v0Egs9g9Cmp3rU+Q3F+BbibbGiA5LkakZb7+NwvpcS+Y7TQnS8+oPldL6ZYOwYNQ0Sb9ke35FHciWzJTJQLHzBODCPN1ZMkOdlwZUelquxXgDI4G2KYeH0BiRZ9pYK08TeYeSoKQrpHmY/xz4xreoNeHD2GwqWzZqGGUF7WgNFC1sY5EdIbVCtxpdb3/Vlpflr2sZwrKiBdqlWmXkBntcM3WAAm4BXZIFINApOwQPREQYvKQwGyXbUbOIRlJSW1QQ+nnjQ0j9NTJte33+GGM2nP+j/I4vhYghCcNOTyU4VQuij+hAzR2h9mDhYg/guuHZSHgtS1XDHqFRhRk+udphTJH92a/UvOXpHlyHgc0j1gbHXcHnPhejB3A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(6916009)(86362001)(66556008)(1076003)(2906002)(83380400001)(186003)(8936002)(6486002)(5660300002)(966005)(9686003)(52116002)(6506007)(53546011)(6512007)(66476007)(66946007)(508600001)(8676002)(38100700002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F4TViqXuhsjxBGL604bqr7Qda5ceiYD2Y8/L7VidftiK0E9scuhB8M9+6tHv?=
 =?us-ascii?Q?p2Mr9UtCRcxaE6bamHhzhFq25Z1kHOQhtVO8ZPXTDRPZ9Z6fSQ+M8b+Ojy+0?=
 =?us-ascii?Q?SVXNGgyk9cDjEiSC7Has3u5w6q32mFjomFK3Nbf4MJoAP9UmJxJaJYeDta2D?=
 =?us-ascii?Q?QoAYn8AmtPM/u0PmQmtYdcBt99jR5OxV8AJIjXLemP67Ac5mInoywaAfWSW9?=
 =?us-ascii?Q?El9UKE8fwPXqpurOqRdir0e0Ljyd0ql0VkwrWVtlKjgw385vle+iaKjI8xqQ?=
 =?us-ascii?Q?71m7oAkwzE8D8Tf+LwswECYO8fAh5RLFeVNozgNVzDx5DhMbdcH2+h8vMmTb?=
 =?us-ascii?Q?JwWODhheE6VqAJfA5DFZyOXXB6nEjbStVeJi0RhB58tNmLSKgND462QiIa2a?=
 =?us-ascii?Q?dSZFiV6azTRZ+FYrTCN2AjdAe1rSlnUuwdDl0oTMDHZKs8YjOLCnS7tTEZpc?=
 =?us-ascii?Q?M0dMy8UL7NSD1yvmAn5RoC6FCIy1NKto8M54G8q0WpT8Zl/XNYm/IV5L7lRE?=
 =?us-ascii?Q?DfIGeiImydP64DdhNdxekTedqQQjg9qkjTHX6vrpGwemJ2680j2UDnAcZLWq?=
 =?us-ascii?Q?3Lg6k4oLqQlEaUql65oqDnTUC2pPC0I7YbzoZXcxRGvjCM3AqakzXp6Z5zGw?=
 =?us-ascii?Q?LcVf29W5yhxTQljteacQ/fE+1pw0vf4PvUtcW7OmId+TM56GptEriYRVkqRm?=
 =?us-ascii?Q?B/gnkWl0t1y9rTrvJm/cukgUXAy/pbSFjFg8XiqO2tYVb8Il7fVwR8QXKksX?=
 =?us-ascii?Q?H1JD33A3sMGOqWXrYFPU+o5Qm6AFLFad+CT/MNk7mSySxJjtLgPGIXxuMxkl?=
 =?us-ascii?Q?ZAPSRax7dgMFIOvNcsQeFLF2H8IacyktFJPSN5hv4R1XpZ+IWwpEIT5e5w+y?=
 =?us-ascii?Q?7Hlgj91DGuYdFBgHoGXjV6QTE8b9Qv9iwXRRB3Dn3LJdVLMhRn4VUSeTZzyC?=
 =?us-ascii?Q?WoWFkiXxMiqWYjEVp3Yzjhjr4NrMotd4g7jNPr2pYBDGVS8CQeHaVsRXrY2T?=
 =?us-ascii?Q?WZHDR8XEGpBMEp6HM/OoIxrF+lbgRrVTl/xF5bMpv0izgAG90beE+aCfputt?=
 =?us-ascii?Q?Gu5PoBNXw7DZbLBZII9eOvp9qAkM/V8aOq7ePk7vWKPSEdn+qEmEcAS9Rv5L?=
 =?us-ascii?Q?ef7Dp5VKBZseJiGgpr8BZCiCgg1wMLa/f1c5LJrEFiZmDvb70LSwo5epmRvS?=
 =?us-ascii?Q?r5h9CpN8Q9IBfbs38GIlAbyWoTCkvmT5dPdI6wxgRfJx3aPN18rhQoSSmc7H?=
 =?us-ascii?Q?7bF5SsFSdDXDk6vxG7XPHbw8ACEbfJSHS61kNNoN30Z3TKVFJXKhav9VEFNv?=
 =?us-ascii?Q?04BBk4cQ9hbrd/RYoIzWZzkrzjDB/wIkfP1HtHympWFzCcC6ZPZbHayvebqS?=
 =?us-ascii?Q?ZRWBsUTr+OWUO0S+EWevPCgdja4V5TXhVwYDEaD8um1PFPkjW001KNVpzSMt?=
 =?us-ascii?Q?2LlEu6GD6IlZR4VsWyytYzs8fCfaa0zA7gEqu6fLuhyh2Fta3zDVaP1HP5cC?=
 =?us-ascii?Q?9ypmIoqXNCGJ2KK+EqnOthVnSVCYQ9hvAxl5bpsdPsSAUm1XTagSvwH/9c7A?=
 =?us-ascii?Q?+me7W+6XHd4NCbR2iZcv2Jf3U3+5Lzzaw1KYgoijVmGud/gzsvJ1pNDX8r8p?=
 =?us-ascii?Q?kHTxDvDDnfkIRtVoWHEkWYBDLzT8dHSsAXaG9TnVq9cC2xvpdnkurRGK2iGZ?=
 =?us-ascii?Q?MzFVrIgPJ8QkxvuO97JM+KqEuOlY/mfCD5LU/ebwNC+FK1zDdphcBTRlUf7+?=
 =?us-ascii?Q?2VubqYhGp4WNH/wPw2u9lCsl/Sx6K/w=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c20c402-1266-4d13-0d5f-08da1cab8a77
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 17:40:31.7045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DbiuoaIGI+7UO3WqDZ0lfRtPeeB8gCgqh0CM9QNCNLyodHomVLJVJxjIAYacJeKh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3996
X-Proofpoint-GUID: HUT7A_B1kQEnZXSlbzz-oo8ua7C8yGai
X-Proofpoint-ORIG-GUID: HUT7A_B1kQEnZXSlbzz-oo8ua7C8yGai
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 09:42:41AM -0700, Stanislav Fomichev wrote:
> On Mon, Apr 11, 2022 at 6:19 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Sat, Apr 09, 2022 at 07:04:05PM +0200, Jakub Sitnicki wrote:
> > > >> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > > >> index 6c661b4df9fa..d42516e86b3a 100644
> > > >> --- a/include/linux/bpf-cgroup-defs.h
> > > >> +++ b/include/linux/bpf-cgroup-defs.h
> > > >> @@ -10,7 +10,9 @@
> > > >>
> > > >>  struct bpf_prog_array;
> > > >>
> > > >> -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > > >> +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> > > >> + */
> > > >> +#define CGROUP_LSM_NUM 10
> > > > hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> > > > have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> > > > a static 211 (and potentially growing in the future) is not good either.
> > > > I currently do not have a better idea also. :/
> > > >
> > > > Have you thought about other dynamic schemes or they would be too slow ?
> > >
> > > As long as we're talking ideas - how about a 2-level lookup?
> > >
> > > L1: 0..255 -> { 0..31, -1 }, where -1 is inactive cgroup_bp_attach_type
> > > L2: 0..31 -> struct bpf_prog_array * for cgroup->bpf.effective[],
> > >              struct hlist_head [^1]  for cgroup->bpf.progs[],
> > >              u32                     for cgroup->bpf.flags[],
> > >
> > > This way we could have 32 distinct _active_ attachment types for each
> > > cgroup instance, to be shared among regular cgroup attach types and BPF
> > > LSM attach types.
> > >
> > > It is 9 extra slots in comparison to today, so if anyone has cgroups
> > > that make use of all available attach types at the same time, we don't
> > > break their setup.
> > >
> > > The L1 lookup table would still a few slots for new cgroup [^2] or LSM
> > > hooks:
> > >
> > >   256 - 23 (cgroup attach types) - 211 (LSM hooks) = 22
> > >
> > > Memory bloat:
> > >
> > >  +256 B - L1 lookup table
> > Does L1 need to be per cgroup ?
> >
> > or different cgroups usually have a very different active(/effective) set ?
> 
> I'm assuming the suggestion is to have it per cgroup. Otherwise, if it's
> global, it's close to whatever I'm proposing in the original patch. As I
> mentioned in the commit message, in theory, all cgroup_bpf can be managed
> the way I propose to manage 10 lsm slots if we get to the point where
> 10 slots is not enough.
Ah, indeed. The global one will be similar to the original patch.  I was
thinking only use the spaces saved from list_head->hlist_head to get a
larger progs[] instead of spending it on L1 lookup table.

Also, I think u8 should be enough for the flags[].

> I've played with this mode a bit and it looks a bit complicated :-( Since it's
> per cgroup, we have to be careful to preserve this mapping during
> cgroup_bpf_inherit.
> I'll see what I can do, but I'll most likely revert to my initial
> version for now (I'll also include list_head->hlist_head conversion
> patch, very nice idea).
sgtm.

> 
> 
> 
> > >  + 72 B - extra effective[] slots
> > >  + 72 B - extra progs[] slots
> > >  + 36 B - extra flags[] slots
> > >  -184 B - savings from switching to hlist_head
> > >  ------
> > >  +252 B per cgroup instance
> > >
> > > Total cgroup_bpf{} size change - 720 B -> 968 B.
> > >
> > > WDYT?
> > >
> > > [^1] It looks like we can easily switch from cgroup->bpf.progs[] from
> > >      list_head to hlist_head and save some bytes!
> > >
> > >      We only access the list tail in __cgroup_bpf_attach(). We can
> > >      either iterate over the list and eat the cost there or push the new
> > >      prog onto the front.
> > >
> > >      I think we treat cgroup->bpf.progs[] everywhere like an unordered
> > >      set. Except for __cgroup_bpf_query, where the user might notice the
> > >      order change in the BPF_PROG_QUERY dump.
> > >
> > > [^2] Unrelated, but we would like to propose a
> > >      CGROUP_INET[46]_POST_CONNECT hook in the near future to make it
> > >      easier to bind UDP sockets to 4-tuple without creating conflicts:
> > >
> > >      https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-connectx/ebpf_connect4
> > >
> > > [...]
