Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EA45321D5
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 06:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbiEXEB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 00:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiEXEBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 00:01:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15EC1A064;
        Mon, 23 May 2022 21:01:21 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NKGcYC025850;
        Mon, 23 May 2022 21:01:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=j7zbl+iRVgFgcgYBKjMtslEyDL1LtQ6g8e1T3L/l/Ic=;
 b=epXpwVQLAIdPdre3KfoxHGkjXXuVTBh8PIomc1EfO/6d7VxZJpcf3h2Ef1BLTJBHRAYw
 G8O59NrC934GTsp/hdK10tx1keMuzGjNsKtvpXqBYgGk5F3CBMgtDXaRuKQxVoqp/lNK
 9RDKIoaynp9WNVgHG3NrrHX0pe6MB/Ba2+4= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g6yd3dddd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 21:01:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8QZeWDlRfeMDuA4TaM2A9CtWAHSWkXpaBB5lc7s0xCpXa+Sa55/RiQHNZn0+cJmbcIWCxXdyT1olBoCqj30emlhQY8hJqYW6ujDdA+J/ZdKGM6r9NFFJOPQKg5auE6ymkLS657O2UyGQLgd1UB5fUdFn8eAoq/4rUg9ZUd37a3IJL/U4ftN/WZtlzmpqKfLgDti9pmdqt5/0ovJbZtDqizsae1zBDtidAzU3qnoAd1mTFjMXOku6Rbd193FMTGsEZfn1NvTIVPtJi4D7njAj4zR0LBT3vKwrFw/rIF/Jb78IPxL6XOnK41vEs9EIlWqi57VFy2FnxTYiu3qvI7G2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7zbl+iRVgFgcgYBKjMtslEyDL1LtQ6g8e1T3L/l/Ic=;
 b=kc8djykxW8S1o+VtcX/MnLSyPQXx6R4VNcMeO8Cq8M6GpIyOthaKDemTiWDLUzS8g7uK1eokFbsgXrqVF9FRr9rMjNVh2p20uxn0hxaM9dm58zrofWhrFnGmcJD4fVHIhkTrft/ZEJ7ZDbqtf112fNR7/JN2MBFWDEfbkmMZ0NsQGoIbP97W8NJZAt+ri+zlupsoG5Hz3w4G+TUeaFBhZ20NmJK8VbzEg/DvihebgePjWnUhHO38p3fb4BKkCeARenHZJocC10kLlcDFKkH7C3Px/3JrhZ524A8ox82wNzqsfxcrDzDjy+V/RFWqkvUcMnruURq/zT8DpZWFyrmC0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB3740.namprd15.prod.outlook.com (2603:10b6:5:1f6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Tue, 24 May
 2022 04:01:03 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419%6]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 04:01:03 +0000
Date:   Mon, 23 May 2022 21:01:01 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next v7 07/11] libbpf: implement bpf_prog_query_opts
Message-ID: <20220524040101.ctd44fkuue77o2la@kafai-mbp>
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-8-sdf@google.com>
 <CAEf4BzaYx9EdabuxjLsN4HKTcq+EfwRzpAYdY-D+74YOTpr4Yg@mail.gmail.com>
 <CAKH8qBs7YE26=ecmn6xdjTC-5-NFMP_-=qkuKtRUDjzeqMTWcg@mail.gmail.com>
 <CAEf4BzZrykLnBc_uqfjDbh_a=6VZnMKz5+UQWiORXkiJqNFoBg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZrykLnBc_uqfjDbh_a=6VZnMKz5+UQWiORXkiJqNFoBg@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::14) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e32dd92b-9208-4b0a-d6b0-08da3d3a0580
X-MS-TrafficTypeDiagnostic: DM6PR15MB3740:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB37400423B1611081EC329C61D5D79@DM6PR15MB3740.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FZm2C9nlAul5n6AtxyyIpR/xSiL14ZfiQzlshJbAb4o7+dD3LlLL36LiMltVDdJ6wWTVXGANuqzlGDbnsq+UPNMASc1yyGtaggBeia+J9XyHG7WAKHQSWtAiVty8vmczsvdHdWcp97dZ0M7/SgN+7jC33PO0DU3GX0RrmdNtjnvh6XGUncMRQPZiYbxKHGJiofa4VTav4LXPAu63PRcknHj58ZUVkb3T1Oc+4p/kOs/BzzC7xHOJH2RqV93RGJWPjyNrx7uaNUlnYPf1XQ1q8Zz3LjcHupbqNRDFLGhjQD717YSnAIB3opUIrDo27KeuyIzMndQQDysJAw17jcI4vbQsm73xjrXze6die7DxsXFg6kK0TkTqXvdExF8Xh+3LKUdiHWql9f1Wr4zhZh60cXRjMuFMIXrjC09/SkyPoMfyu/ac4Rk18wkDSduEcjkbD5tsLRX3Xh70DR+BJhkVAqcTJ3FWCauZGLx24T3a1h4xDkRS6kt7pzDQwfecm7gZeDUcIuHTjzhR10OeioBU12fh6iWkKktBV1euPMgxkWkWuzMfO094RsEuo3a4irZUNHilKW4mdMuKKCgFGH3lrsimK0VSzRlRpX7eIe+geHU/hgAcJDSehmFSWjp9esEADEV3yr6V3Eeymz8qqXwHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(1076003)(4326008)(186003)(6506007)(83380400001)(2906002)(33716001)(38100700002)(316002)(52116002)(6916009)(6486002)(54906003)(8936002)(5660300002)(6512007)(86362001)(9686003)(53546011)(66946007)(508600001)(66556008)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?olkSuemyruE+7uqmspkQapKI8w0kEkC7BhSzW8pE5nAF4tpsgjdqw53dWPbL?=
 =?us-ascii?Q?JvQWX1qQkzleoz97Sg+5dzLLD/LN0uEj6G1cJXGgT3CxYgBjU3aMlzlqMex9?=
 =?us-ascii?Q?I+VFHiQeCk+s/Oq+5lqjcr4hk+dfRNMBE8U52mNqR43KBpQ1SnDqccj3+Fut?=
 =?us-ascii?Q?cTqsEhWV+KtezoUycHO0CP5S3HHD51fJN4kvzRokuuSbEG7rVpskRn7gj5h5?=
 =?us-ascii?Q?klKTfGaXyiWIKnochNP2g9HgMl1K8oJmQ+FneUGJZINCZf2g9KRobtVkWnU7?=
 =?us-ascii?Q?4LV/1wyDCEa/WrUEj3gjO9ZAnPtjLVMcPc2QEjW+nYBPI9rMc16eQQQScUbN?=
 =?us-ascii?Q?Q4oSlSYJGsJp1hSrV34Za4kc2L0IMTajgUWSDUDeHsEn6NkU2ddPIlzsRSGU?=
 =?us-ascii?Q?vy8/CDpKJhGQ/EAoY8Rf0q3sWB/UEOF47geoPa7ZcRu1W20iGvUsf3ruAuFX?=
 =?us-ascii?Q?fFHwsOKEyacEPPujRpwUt6Hu97CvAxmRi0qIVnqatrTSfOWYd7p4aOA2Td3l?=
 =?us-ascii?Q?GNSAuHQauzkrHWZPlBECBC7HIteGbQyamWyqMzF54bscBC8CQpAU/89WNW7B?=
 =?us-ascii?Q?9saVgrp47L0ZFAZ1Z7A3AouGaD15foICdWJHm7+XRGFFtAAN2SDaTD05pC7S?=
 =?us-ascii?Q?mu4oA4QoJ+qIlqIzR/dhx4PGY+9z+ONeCMMsHFYvTjPMvUo6cCabGeUpM1eR?=
 =?us-ascii?Q?xVcNxrG3JxWJIP/sfEJpazYoGd3CDLzJmtskzeyrF4Q+HAeCULiuBKPesKmA?=
 =?us-ascii?Q?9gyV0jjcphkhLb7U3i0DCHvKtB3nFhWTVUsZprPHiY89ZKGo9r433yqvIqDS?=
 =?us-ascii?Q?HNx/3aXfwV3TQFiMvtDmszMHbBKqekmPC+pCe9dW8L0oU3CHa+wFo6T4F7rm?=
 =?us-ascii?Q?QGQjsDTjiv+R+Y52P8I7pOr4uaQNaVs9X4WHw7kkYgwH/Lgf5WknyWAIruZH?=
 =?us-ascii?Q?EL6EDgEisWRi33OcPHWheruLOabHpCPMlm7rpWnSxGPdzGAWKgDla16hN0VW?=
 =?us-ascii?Q?K/S6UhCrb+fbv4kGeQ8DfqxCkCDMoOfAJmXUTi6g460G8ZeUyqkhNhFo00ZD?=
 =?us-ascii?Q?qtBrEQU2yB9coEhMVwhcRVQTT0izJWPYR+xvOnDmLnGYRtW79DqeF5nZwyTW?=
 =?us-ascii?Q?B4UJyQw5KaWNMo1ioCgI8E8uQ5h0C8u4OGAw4/8+UOq4xMXDFNVSPHjEBbgs?=
 =?us-ascii?Q?uJaHLXswTN7/wz1YC4Fo9BDu9PYI4N8CJaIZvvsCL4PPJ2nF/KR41rg+7hb7?=
 =?us-ascii?Q?p19UiWzqwSnNoGOqQ3+Pzx3MtF4ih9JTzkibSXsDtZt9KSyh23Wjf+fN1kRX?=
 =?us-ascii?Q?r2NTWxVTMqcVLOdxeQR0yNoCGnB4oN/HBfkFpng3C4ZLTj6M7uXy4RdD5FUX?=
 =?us-ascii?Q?Sq/WcgC929i971xK58DK2SwUY5StcsO85M3+uVI8id8Ppugt2ox+WdstD+KU?=
 =?us-ascii?Q?pr4tb79FoOypHZVne+6LawMvecsf6Ln/WHGhh9E96QOi7QFEgIeUBbO4xofw?=
 =?us-ascii?Q?eD4AqORX3Lq4eA3ltzPl3bjXaK6wricI5cUciPrzTGShD0Ml8Ao5CR8kYvvL?=
 =?us-ascii?Q?IoXJ9f692c2j9af6MlJ/xpOYvJIPEfBhVamrYBdIulsw3kP0Vq2QeaTT0MT7?=
 =?us-ascii?Q?sK8ZQxgSbUVIqZ4pIUl3/TbO//iCSzb4KPj4C5aDXybdCmxYz719VbCWKijb?=
 =?us-ascii?Q?1eIKG4L6ITw2MRSSNn1NlQS1qBBGayf0/i1tErbI6giBh1z4QweJwbuM/ywv?=
 =?us-ascii?Q?jAqxRI/exhHfc88zzwgsCEsIz6sd3RQ=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32dd92b-9208-4b0a-d6b0-08da3d3a0580
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 04:01:03.7010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qjo8bVH3ZBDKZ7lndrpzbTjb2RJ2EriQA7hJheokti09NHy73zS1mZbSNS79FACm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3740
X-Proofpoint-GUID: Z2pt1e2EXOX-U7T3mXVLqi35IenSJkUM
X-Proofpoint-ORIG-GUID: Z2pt1e2EXOX-U7T3mXVLqi35IenSJkUM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_01,2022-05-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 08:45:13PM -0700, Andrii Nakryiko wrote:
> On Mon, May 23, 2022 at 7:15 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Mon, May 23, 2022 at 4:22 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Wed, May 18, 2022 at 3:55 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > Implement bpf_prog_query_opts as a more expendable version of
> > > > bpf_prog_query. Expose new prog_attach_flags and attach_btf_func_id as
> > > > well:
> > > >
> > > > * prog_attach_flags is a per-program attach_type; relevant only for
> > > >   lsm cgroup program which might have different attach_flags
> > > >   per attach_btf_id
> > > > * attach_btf_func_id is a new field expose for prog_query which
> > > >   specifies real btf function id for lsm cgroup attachments
> > > >
> > >
> > > just thoughts aloud... Shouldn't bpf_prog_query() also return link_id
> > > if the attachment was done with LINK_CREATE? And then attach flags
> > > could actually be fetched through corresponding struct bpf_link_info.
> > > That is, bpf_prog_query() returns a list of link_ids, and whatever
> > > link-specific information can be fetched by querying individual links.
> > > Seems more logical (and useful overall) to extend struct bpf_link_info
> > > (you can get it more generically from bpftool, by querying fdinfo,
> > > etc).
> >
> > Note that I haven't removed non-link-based APIs because they are easy
> > to support. That might be an argument in favor of dropping them.
> > Regarding the implementation: I'm not sure there is an easy way, in
> > the kernel, to find all links associated with a given bpf_prog?
> 
> Nope, kernel doesn't keep track of this explicitly, in general. If you
> were building a tool for something like that you'd probably use
> bpf_link iterator program which we recently added. But in this case
> kernel knows links that are attached to cgroups (they are in
> prog_item->link if it's not NULL), so you shouldn't need any extra
> information.
It will be useful to be able to figure out the effective
bpf progs of a cgroup.  Something that the bpftool currently supports.
With links, the usespace can probably figure that out by
knowing how the kernel evaluate the effective array and
doing it similarly in the userspace ?

or it is something that fits better with cgroup iter in the future.
