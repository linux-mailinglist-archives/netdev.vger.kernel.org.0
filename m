Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972C54FCBD6
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243900AbiDLBWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiDLBWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 21:22:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CDF1707C;
        Mon, 11 Apr 2022 18:19:59 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23BMJgvB007850;
        Mon, 11 Apr 2022 18:19:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=OZPW8YB7GAt+9YF+1R6+I2yv1RP0wMOCLdFImTfr3gk=;
 b=nfVUakZcP3HgRXSRIltR3CCBLLIGODrQf9XpubHBXq6RkIL8tH2CfQuXgHBqNLUXoEyl
 SNMDqEUpKQaSSIPw39qzPeYpMvIpaIC+yJMC0a0aOP+qHMH14oStPfGb/hD/hzhzYzTz
 2wR8s3tqVQh02rkafNb4l25zj/wSnJe6+gM= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fcm464n2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 18:19:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jc6Wr2l8OkWx1ByQr/TiAJ9FVrTrJBI8NmPkNWIOnPfhe9qgFjUEU2bR3XAUZPwUxEuqyhVvqGiE4nDxU0gSG6OFL1Z1o8kzDoezemc36nqPitLwg6+/ZbB2lKLJ0rmHLLtG1vlYHXi3j900mJwFaOCLS/1hRNOW5NijYmB8KsukJNCsIxrRk1Fieg1nyr8RSfkNStplCq8NmQGKo9Elxj46TLJTL0wQgGYoEyPc0EixFXvma/I8171pfHDWvkONeNspbxeHZHdNqy+YY5lM852lMIVKJuBLL59Qohi0m/WsNd/jPD89iFnkDwzH8DXx8U4EIfHBcTifjyHevlV0iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZPW8YB7GAt+9YF+1R6+I2yv1RP0wMOCLdFImTfr3gk=;
 b=cJvaTVBMXh3mAQ6uh+ZT59hukqVxSQsU+/pS6ENdEj6ZZqQ5GF0IQokjN9r/KJ4MX0C8Fq3BfbwGKIhsnkZT+KTjLZ6ffWhPUmWhFkm0O8W/hXTHwBxHbDGGsEIqMwk0HB07vPKJNrginBf01Z2yp1DWot6vefReRtbcRI0WBoW25NlxYMN05fBwC8+2GGSTN8nh88xhs7CIoFOiAMM6uBArPS+o4JffCafnVZkGxgQrix2276srVa4EEJgNAXFeOxss1lx3Nlr0R+SqkrbPetn4EMlw7w5bAEKlAI4CQZBSptGk0GJj+gjXacaSPbbMzpQUIyr4qzaZ+v4y3gZTxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM5PR15MB1257.namprd15.prod.outlook.com (2603:10b6:3:b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 01:19:41 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 01:19:41 +0000
Date:   Mon, 11 Apr 2022 18:19:38 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220412011938.usu6wzwc2ayydiq2@kafai-mbp.dhcp.thefacebook.com>
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
 <87fsmmp1pi.fsf@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsmmp1pi.fsf@cloudflare.com>
X-ClientProxiedBy: SJ0PR03CA0194.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c29ac6e-ccf3-4a8c-5862-08da1c22852c
X-MS-TrafficTypeDiagnostic: DM5PR15MB1257:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB1257F091E41AEA4003D0FC80D5ED9@DM5PR15MB1257.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0fooBEuaG4QQzyXjmP8nZCNVak4kc+Mm7/x6Hl0v1fjdA33XMOElTmOE0E0R6FsSxeEHEp2a08Q7F2H9mAyI5YEHQnRw8T3KBogncVRpShfXqyRfuKBs9SBgFcWFvTIIHv14N51apDJWqTUlefiAZ9t5AYTbUpxcWUS8HB7QdK/Q/SXqNxseWvtD9whdYTRMBp47tuiguSzxEPUwPUFJoeXZx1Ih3gT3tpZDbe6+Ui1IgRS7INhZb+bybt/sttAhpSEHx3zf1lk66CwdXguBWcKhMNajSLy4SCfwBlIQJ+kxdfd4VuamrXEZSzD62pmbS28CIHHeNU2KkdELZI72d9iEL0TemV/8Px6s8J1vkIym4Ufp5wtYe1JQ76AYzNHbBaYED6MX4Lf0y0o7gUVjmg+z9twrJZCsuUDSUb1yPrFQ5UBTAKjB6rlQRb3udqdDgO+o5YbaDLu2ZL849FnTQHb2P0L5K1vj/bucDtryMOhGe6AUKFa/4tLJrBH/PZRy345y73mJyTmbeYUyMLLTmuhGyCjtcdYlYioSvufmzs/W+RH7eKVBzsBBec5i16HiBNM2S6FE2VCxF/R93xNFMTprTzPb60S/8CzNj+Aru6q1T8HzdSwmWdTSccPEoPgXIon/B1LYdOVZG1Ya7RqHozM+4yt/nFW6DsiWKG44ccwbAy1qCYFEi9YB5vhlSfk4IhGhudkgD6eh6g+nklkrS5j4zRiwl3HucCp96JxbrgA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(6512007)(6486002)(6506007)(316002)(110136005)(1076003)(52116002)(6666004)(186003)(38100700002)(83380400001)(4326008)(9686003)(8676002)(66946007)(66556008)(66476007)(2906002)(966005)(8936002)(508600001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FeHUVuw3WbFIOcHlJb7pgFQEtUFRiO+/n3d6ogC6Ly+pjFIc6JAuyEDwVVzL?=
 =?us-ascii?Q?qbVYYQL/omAijSYoJcy18C9A2ubGsxf+PpXXtGiIZk9O1hXDYQFyRgXuQkBL?=
 =?us-ascii?Q?Hl9V+TAg7XUOg326n9jGwaA0fmhoEKNm3MJO5luYt6ZdcNMK9FW861vng4Su?=
 =?us-ascii?Q?NMoAHKiHI8H+Gce+4+4XpDoEEYgzdVGZiKM9ApHB1j1TOXB25gjKbS/y8P44?=
 =?us-ascii?Q?NOYgL0yaQdRUCIBBug/pN7C5ZWrKoxM8PlhHxT3xNFknQf0Xow7yQkCNuhwY?=
 =?us-ascii?Q?eP3sPckYMYEw8I3WuxYP+XpQ9uxwJSB8VxkjcUAw5URsxkGb4shI3Q3Bzch6?=
 =?us-ascii?Q?b7yVMlUWwJZorUfnKrVtgEPXGSRMKKGejbTbhbUeIcdlhrVrHICAeWsvI57f?=
 =?us-ascii?Q?ntY2xyVER4nAwrJ69ur56yk4nYI2/QOXRMsQ8gyy2uFBKYz9XFkgiyYAkfz5?=
 =?us-ascii?Q?sZ6uAGSmwU1JeAhrw+EjCmJeZIJRmjwF4UZ37WY19mAf0qLQleRe8MgZ2HyA?=
 =?us-ascii?Q?9iTXmE8cOWzYbhD4vlS/ap1H+t4M0S+vG3uCTbVdIR7U6iPfNTHDoI+oa1Ci?=
 =?us-ascii?Q?OHDTpQS6Ja5Xg3aXqL2ibLxsIkhOeThAyb3u6JFdWRdnCl2GolKpZHQxISst?=
 =?us-ascii?Q?5y7hdKTZs34N17vTYjC255l26VTjaCAOmgkhmWCXlchjP15wncIDhaOgsz18?=
 =?us-ascii?Q?fkrIyYjn+MNCxKQQoAkSAwT7tuG/orGAd92dFtcFQnJwG8BoRkZ7cMDIJ91S?=
 =?us-ascii?Q?64jBEG/0oeHm0pBM99uEdSmi9J8HZernOUnAJASRZ5JA2e8qvdAwDzMymPgr?=
 =?us-ascii?Q?PqxzuFyeHsDBqDzbo8B4/W2KFWO/bhB+6LQ1JAMLPl0ULt7LLHactHD2F2RR?=
 =?us-ascii?Q?/fwRlyMFJl3glc9UQAGGo6Z8dB+lMT7kqSEVdEeWuyViRXEPamYKMiX5DKTg?=
 =?us-ascii?Q?9voHyIYuPU9En50jHSeuEKZ69JdfkM885pscI2IYYdlxGRFTGA3RL6M7lDa9?=
 =?us-ascii?Q?tovrGnauzQfd/fas3MVOUZVPmxkt0bXSZueQrxOYdn67p6saLiQfTLQNP06S?=
 =?us-ascii?Q?3pRngLoVAQdF4O0pTVYvJxgfivfmmoYdD6cU99Gq7UMNkEV5BlO8RJR8BRP3?=
 =?us-ascii?Q?7Zcg+Img7BuSREqn9KY0TZhARcBStMldshiceo7Lsm5sUl86uK4WrypiSTWi?=
 =?us-ascii?Q?4LMMD7k2TZqd1LKvj1XLosTK+bdB3fbguMoTwFA35YmnDAl/7lf83PpclwST?=
 =?us-ascii?Q?NwrRV5LimMtLHPDj3WJ+cjEgmtnWgvFOvULM9jZjZxthaiNq8hdE/M1seROg?=
 =?us-ascii?Q?lq6v37gUdgmb+VnpCWqHEg5AeS7w4BMuikRt279NvHZqpkScvS34B40pM6Cy?=
 =?us-ascii?Q?M9KC5jWCHdma7yERtuCS+y4bxbTXyp5SywDJ050D2TOfAze7aEDPecoBL9Vr?=
 =?us-ascii?Q?kcFGoa7tgySKI/oiCFdxE9G/xJTRcBrZRBuTmtAGrnf4KdbNCuGMnh8IIjis?=
 =?us-ascii?Q?nggPfJMnRYleQTixe/eh1pU5i+WxPDEAy5foY5jFmxuP3m0AIvl6In4Qdua5?=
 =?us-ascii?Q?SEgRd+nHcbvRX8JNfC79XZ9NNlvoLupDkEKnual7Ph3Wm4hsIZ+Ic7sU8pCl?=
 =?us-ascii?Q?nGlM7i7zhbBudQ3jbDmsibodFgyodubj0juD2QFZNS+ocEh/wLjkECBjG4Er?=
 =?us-ascii?Q?k0rCRoJM5a5XY5/E9IO6nNLwGNBiPP2iqP4iImOm9PPbPvuPmnSnN88V7WER?=
 =?us-ascii?Q?qjGJM54uDQ6IhkouAzsd9nu9rXCo2uo=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c29ac6e-ccf3-4a8c-5862-08da1c22852c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 01:19:41.6962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NY056lI4ja/5ZPddunPYL5Ox48HOd5U0UsnL9ACvQdfka1E0Mu9i62HAASJkatqF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1257
X-Proofpoint-ORIG-GUID: EAmcVI4A0dVDSDzTaUVd95yP6a1IvrsH
X-Proofpoint-GUID: EAmcVI4A0dVDSDzTaUVd95yP6a1IvrsH
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_09,2022-04-11_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 07:04:05PM +0200, Jakub Sitnicki wrote:
> >> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> >> index 6c661b4df9fa..d42516e86b3a 100644
> >> --- a/include/linux/bpf-cgroup-defs.h
> >> +++ b/include/linux/bpf-cgroup-defs.h
> >> @@ -10,7 +10,9 @@
> >>  
> >>  struct bpf_prog_array;
> >>  
> >> -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> >> +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> >> + */
> >> +#define CGROUP_LSM_NUM 10
> > hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> > have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> > a static 211 (and potentially growing in the future) is not good either.
> > I currently do not have a better idea also. :/
> >
> > Have you thought about other dynamic schemes or they would be too slow ?
> 
> As long as we're talking ideas - how about a 2-level lookup?
> 
> L1: 0..255 -> { 0..31, -1 }, where -1 is inactive cgroup_bp_attach_type
> L2: 0..31 -> struct bpf_prog_array * for cgroup->bpf.effective[],
>              struct hlist_head [^1]  for cgroup->bpf.progs[],
>              u32                     for cgroup->bpf.flags[],
> 
> This way we could have 32 distinct _active_ attachment types for each
> cgroup instance, to be shared among regular cgroup attach types and BPF
> LSM attach types.
> 
> It is 9 extra slots in comparison to today, so if anyone has cgroups
> that make use of all available attach types at the same time, we don't
> break their setup.
> 
> The L1 lookup table would still a few slots for new cgroup [^2] or LSM
> hooks:
> 
>   256 - 23 (cgroup attach types) - 211 (LSM hooks) = 22
> 
> Memory bloat:
> 
>  +256 B - L1 lookup table
Does L1 need to be per cgroup ?

or different cgroups usually have a very different active(/effective) set ?

>  + 72 B - extra effective[] slots
>  + 72 B - extra progs[] slots
>  + 36 B - extra flags[] slots
>  -184 B - savings from switching to hlist_head
>  ------
>  +252 B per cgroup instance
> 
> Total cgroup_bpf{} size change - 720 B -> 968 B.
> 
> WDYT?
> 
> [^1] It looks like we can easily switch from cgroup->bpf.progs[] from
>      list_head to hlist_head and save some bytes!
> 
>      We only access the list tail in __cgroup_bpf_attach(). We can
>      either iterate over the list and eat the cost there or push the new
>      prog onto the front.
> 
>      I think we treat cgroup->bpf.progs[] everywhere like an unordered
>      set. Except for __cgroup_bpf_query, where the user might notice the
>      order change in the BPF_PROG_QUERY dump.
> 
> [^2] Unrelated, but we would like to propose a
>      CGROUP_INET[46]_POST_CONNECT hook in the near future to make it
>      easier to bind UDP sockets to 4-tuple without creating conflicts:
> 
>      https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-connectx/ebpf_connect4
>  
> [...]
