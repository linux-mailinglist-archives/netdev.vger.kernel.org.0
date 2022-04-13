Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708655001E9
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 00:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiDMWfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 18:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiDMWfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 18:35:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE33496BD;
        Wed, 13 Apr 2022 15:32:39 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23DMLLXp012856;
        Wed, 13 Apr 2022 15:32:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EoZNb/2WoqHRC/yLJsbFG/QffLo9WPFaSF3q3KB3BOg=;
 b=F9q9ZTReGwtKjb0AOfJ3vcM9Xk7Zvv3UVy6LEiQfoPK2zCWSmvJ4vCkg6Cd8aT12ZMLo
 R+c7C6ltWucWXGzMt6DvYTZ9V4g02VqyGP1bCyXbbKQLKEHg4nYcZ3KiCu9U9Vv0UGNL
 XvHDOwBbPQQicnGXBaYq84Idh2pvcSEoHlo= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fdd419x8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 15:32:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZIH3Cgd4UAI3ef5+p9gQvabr/pRJw91t0RLuIyxSJMJGH4HWHCmUx2bVx4rsT1kr35+ggub/POCdxdoFfeHu7sCuPUKIQkqoRgiPj7y36+5/Be+hy4gkMluifCyEMHsk9MEkMa7Y4ImTMSNhawMDygAp4IJFVQHyqGx5YDH2G5tc6+FDQpSeQDHaF/2Aw2wPgAZStypqe63Zzh2pjdK1EL9iqakaVlL7BqCC5r6bfrUJ6SGyhiM2hsANrkDwajy/cwhECGzzjWHW5RmNZ4ioOj7z9AAiRYpOQY/g6gUseHJYXKbIO5xOe4UoPNujNoR/6nH4vHpsXjfp7RuRdDx2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EoZNb/2WoqHRC/yLJsbFG/QffLo9WPFaSF3q3KB3BOg=;
 b=JfdckTTlRbDBnw6/sKUvfFJKFBTAALW7OsiwJal55V5qDeSyMgiiKxPV4+AGXHOs+gg0kok57qvxLDKkl5vTNYDfSyBZjuXF2Dh/rPv+vwwxivJ4sxFL3+T43252IphgJC3+pb9aTPuNjd1muy6z6z8+ZK+htpLiQdRjKsMo/vtx6CDt0DwCeKaHDx3XHRmlK4+0qgqAoJQYLqmP73PS9Pdeg+NPsVeeZ4WT4l3okcddFVg6HdT+7yLOPR4h05erYZF16aqbs9y85LP82XC+Sggdi40maTWk9U2W+6nESmzYIpbI2+UXWr1tVrJ+ZNjG7rfhZ6+4WN4SJU38OwPdhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by PH0PR15MB5085.namprd15.prod.outlook.com (2603:10b6:510:a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Wed, 13 Apr
 2022 22:32:20 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5164.020; Wed, 13 Apr 2022
 22:32:20 +0000
Date:   Wed, 13 Apr 2022 15:32:16 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
Message-ID: <20220413223216.7lrdbizxg4g2bv5i@kafai-mbp.dhcp.thefacebook.com>
References: <20220413183256.1819164-1-sdf@google.com>
 <CAEf4Bzb_-KMy7GBN_NsJCKXHfDnGTtVEZb7i4dmcN-8=cLhO+A@mail.gmail.com>
 <Ylcm/dfeU3AEYqlV@google.com>
 <CAEf4BzYuTd9m4_J9nh5pZ9baoMMQK+m6Cum8UMCq-k6jFTJwEA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYuTd9m4_J9nh5pZ9baoMMQK+m6Cum8UMCq-k6jFTJwEA@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0281.namprd03.prod.outlook.com
 (2603:10b6:303:b5::16) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0c6b140-b132-48b8-db8e-08da1d9d7926
X-MS-TrafficTypeDiagnostic: PH0PR15MB5085:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB5085B3E0B6FB4DBA9B496160D5EC9@PH0PR15MB5085.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bAIFjcJkhck6+0G4MELazDls0HFFdkxpapQIXOJZIMcBayMYYvbnheIIv0isQoQk3MAeUcFkQhas936UofD0FK+CrN7qFadtAyAecrwkoHFIzhz3gUGe9V/0bNEaEvEqt8tYrxXUvcxDQDSUNF5JYeY+xlF0aZAtI7kTHBTUsDrnboNklpKXjYt8oZb+R4UrG+R1/XqmADCP2em2fIZgjxQmAI0tyWaETdqM/7jpvqkiRZC2H873yrmt8BfPIJA4ZnfnLykutT0v5jYgbrwf3jseDDZsKp6vtN/eY3m4bXTjuSoc7e/jvye9/q6DgQZ+LqF0V6y8xoVDF0SbPK6McfksEgbbkG+uisEDQaVfMNkmN2AGMMnNbiiZ8YQL6Y84bXwV4J9+CYzwWm8zmbGWJsdAW/ym/qIPGqKHTp2NciKKFzZW4zzbpnDwrdKpLiLUFZbrKyuPYNTBDIXyKoxHG0//eHwg8PbjGKGJK1cYC21fPrWHYI1FtzUvAJr23dzs0q8nXdj0dWQpPWeHqgoRFqeuCn4BEKXfqudeOkrWTpTWhlRbrI37cOIZAVebbg+4i+KhhrJBkPauGTlzFgoE4FPMliI1HUpV6TV5cSuN+HZRpID6wM+xIHRX2NB9Nny71uSJexp+7kZ7hSMvL4QBYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(186003)(6666004)(2906002)(6506007)(5660300002)(6512007)(9686003)(316002)(66556008)(6486002)(8676002)(66476007)(66946007)(8936002)(1076003)(53546011)(38100700002)(4326008)(110136005)(54906003)(52116002)(83380400001)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oZZhU6Uc22ontFfhILaSQ9bhifskFwcByDsIrDMkDrrt+6bS6cTeqIgioQIu?=
 =?us-ascii?Q?yFJbkzPZ70HNJDqQx4Xm83qrCSb7KiG4PaIlU0D1aRZPIZY0+XJbZZCgL29O?=
 =?us-ascii?Q?3n1rd98YiafTZq8yIHbHMSDRQd7jEM/XcmVyHwsrdszaDelnoWZZ1Q9PbIyn?=
 =?us-ascii?Q?qsVlumdWv8MYH2YcoiHtl9SIk9tAVUNeW6QUMqxBh7x/YNL9fY20SV/4daKI?=
 =?us-ascii?Q?D6lgUQ5fNIFvaHQnNpDtq3lOdndYP1pkaOxsccbm3qgXK+KWhPb7AkLME6eb?=
 =?us-ascii?Q?eoR0boS8+sq/LpSXv6JyYvdXmh+D9DpIk/d5hMMO1YDT5yF+CMkCPSSYFfVV?=
 =?us-ascii?Q?0nNDRO4P+RQEVcVOFSxKYMn2dSrfvyxV/HWoSSOZYFRpPDDF8qAt2f+nlBzs?=
 =?us-ascii?Q?eRqDPzdNRvztVBcTXe9E9MdWholZd8RkWIX8yFshd5zYf9Gtcgdar1K1RE9M?=
 =?us-ascii?Q?kueiHCBc+YuD6F6WVm4uJAb+qpzjUmwaji5D7X5juNqYHl48cjz5OmOEb9ZR?=
 =?us-ascii?Q?8e5m44KnkBwhuXP17iAgDJuDuq2CzkcUIN5Nw/TBpt/R9S1kyelTYJrJuzrv?=
 =?us-ascii?Q?jFSS+ZQxkDRjRSi7b7x0wtGLKJrkq9J6W5wq+glmH3zyuLPVGVzdOt8daWmr?=
 =?us-ascii?Q?YHeQxI5G3RsmHkZYwOhb4wMXhX+9PUKhDR2CqYM686C29xqTi5utagsoUlSv?=
 =?us-ascii?Q?6I8Hp+I/JA/2xET4PdrOieR4WoTqR+ARRaNxitYe5PakSk+1e4OEmYjoi/iy?=
 =?us-ascii?Q?VsSgW2BLuAcx2m8u9VhcL3oND9DMLwij/PqWOgN8Xv00Rsuxsv21A3Ji+W6s?=
 =?us-ascii?Q?ZVyebhiwfPVlMsTYmvNjH8h8VTSzxuloA/ttnd9MnpSJAI1vhOTV8cF3hOuT?=
 =?us-ascii?Q?RAVXEkOGGRXA9v0sC0q0tdz1xxJCzzf9wuD8EzYFVgOWS8JukYAz7hUixcvO?=
 =?us-ascii?Q?xluY6vshUOTec6oAlIoUmnZTwZS84eWcePXfzzym6uLYju3tokjF7kzZAGYz?=
 =?us-ascii?Q?PJ5UZeieaz/wrPaVPDINZShaglLHl4RkiOLnxH5ejylsmWw7f2zIhqYlwxUc?=
 =?us-ascii?Q?/wCtPxU55rRpBTPxLvleSFWSAaHL4N4muXCdntUfKwLCz0rQFXvw/kZxsarW?=
 =?us-ascii?Q?H5K4Ug0xC1lfXgwW14Cp4ibcSgNWa8MwUehlVnP2jJMQrRakcyMRhhu2k3/L?=
 =?us-ascii?Q?3lF10kAxvEIKd+JcCNmfDajP2qXNubdW6xordp8fBVS25GMsyAEqk6Wr34SH?=
 =?us-ascii?Q?/xUl23u0s35IPjsOdoDEkpbWGDA/S1KUet+fMaZktPfNdfFlLr02uSahSSP1?=
 =?us-ascii?Q?3O2ZNnpdU1TdzqMQDt+EyAw6HGWQ1Oev1tLnU+KV1ZXKVLrWvP4sILhcBuPZ?=
 =?us-ascii?Q?QWtVOdiCTVgMH/Zh5S4tflKnrpUqcmWokAGqAROZCB0WENR8fXJBzeiBIdcg?=
 =?us-ascii?Q?n7lZTa9+WhCDLcdwXy4RzouBxmvqWE6myKaHmIs8Of9q7bWAdtJkcMGQbubS?=
 =?us-ascii?Q?sHLMM4wg2zKACBKIlTgx9mYhP4RqV8kvwLTIGQYoemswcflSI57VjblPPaIi?=
 =?us-ascii?Q?M+0hn4J+UJXib9049Nbtmx5J4OkBVQY8hioAqmG7edtBcLKSVZei3QT73zMA?=
 =?us-ascii?Q?VA6Nhi1Kdri8oTtMYrZh+AXee46gbCxoiHJD/nmkXQmXSTCMED4kfCUFex2t?=
 =?us-ascii?Q?cPfuaDt5uVTARtCMGj2gooULx0Dyk3sRygiyBa36qudQq26WBmE7QJnEdBxs?=
 =?us-ascii?Q?pg1RjH8UGmYqdoWLh32TNQZlY0jrqjE=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c6b140-b132-48b8-db8e-08da1d9d7926
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 22:32:20.8194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c0/5v1lMkqoNaJArUiKZjr37eX2iV3VfInjXjXdc0HEjgkP8UQn6CVB96hPeAUob
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5085
X-Proofpoint-ORIG-GUID: 5sHCU9_Mjs6d5H9-_ekOz3R31C-UTj0Q
X-Proofpoint-GUID: 5sHCU9_Mjs6d5H9-_ekOz3R31C-UTj0Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_04,2022-04-13_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 12:52:53PM -0700, Andrii Nakryiko wrote:
> On Wed, Apr 13, 2022 at 12:39 PM <sdf@google.com> wrote:
> >
> > On 04/13, Andrii Nakryiko wrote:
> > > On Wed, Apr 13, 2022 at 11:33 AM Stanislav Fomichev <sdf@google.com>
> > > wrote:
> > > >
> > > > Commit 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of macros
> > > > into functions") switched a bunch of BPF_PROG_RUN macros to inline
> > > > routines. This changed the semantic a bit. Due to arguments expansion
> > > > of macros, it used to be:
> > > >
> > > >         rcu_read_lock();
> > > >         array = rcu_dereference(cgrp->bpf.effective[atype]);
> > > >         ...
> > > >
> > > > Now, with with inline routines, we have:
> > > >         array_rcu = rcu_dereference(cgrp->bpf.effective[atype]);
> > > >         /* array_rcu can be kfree'd here */
> > > >         rcu_read_lock();
> > > >         array = rcu_dereference(array_rcu);
> > > >
> >
> > > So subtle difference, wow...
> >
> > > But this open-coding of rcu_read_lock() seems very unfortunate as
> > > well. Would making BPF_PROG_RUN_ARRAY back to a macro which only does
> > > rcu lock/unlock and grabs effective array and then calls static inline
> > > function be a viable solution?
> >
> > > #define BPF_PROG_RUN_ARRAY_CG_FLAGS(array_rcu, ctx, run_prog, ret_flags) \
> > >    ({
> > >        int ret;
> >
> > >        rcu_read_lock();
> > >        ret =
> > > __BPF_PROG_RUN_ARRAY_CG_FLAGS(rcu_dereference(array_rcu), ....);
> > >        rcu_read_unlock();
> > >        ret;
> > >    })
> >
> >
> > > where __BPF_PROG_RUN_ARRAY_CG_FLAGS is what
> > > BPF_PROG_RUN_ARRAY_CG_FLAGS is today but with __rcu annotation dropped
> > > (and no internal rcu stuff)?
> >
> > Yeah, that should work. But why do you think it's better to hide them?
> > I find those automatic rcu locks deep in the call stack a bit obscure
> > (when reasoning about sleepable vs non-sleepable contexts/bpf).
> >
> > I, as the caller, know that the effective array is rcu-managed (it
> > has __rcu annotation) and it seems natural for me to grab rcu lock
> > while work with it; I might grab it for some other things like cgroup
> > anyway.
> 
> If you think that having this more explicitly is better, I'm fine with
> that as well. I thought a simpler invocation pattern would be good,
> given we call bpf_prog_run_array variants in quite a lot of places. So
> count me indifferent. I'm curious what others think.

Would it work if the bpf_prog_run_array_cg() directly takes the
'struct cgroup *cgrp' argument instead of the array ?
bpf_prog_run_array_cg() should know what protection is needed
to get member from the cgrp ptr.  The sk call path should be able
to provide a cgrp ptr.  For current cgrp, pass NULL as the cgrp
pointer and then current will be used in bpf_prog_run_array_cg().
A rcu_read_lock() is needed anyway to get the current's cgrp
and can be done together in bpf_prog_run_array_cg().

That there are only two remaining bpf_prog_run_array() usages
from lirc and bpf_trace which are not too bad to have them
directly do rcu_read_lock on their own struct ?
