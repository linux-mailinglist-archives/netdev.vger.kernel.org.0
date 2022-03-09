Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEC84D28CA
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiCIGOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiCIGOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:14:15 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EA015E6C9;
        Tue,  8 Mar 2022 22:13:17 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 228MGBbQ004129;
        Tue, 8 Mar 2022 22:12:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=Z2uP0/DUrtQVnPLSd6maa6PwZ+Ev7ngg1wqjlYv8hqI=;
 b=hBPZ45KvMoHRNiJbHN6XYtrZEV25rvnNzZ8GLDyDVQYSEp9uRdNeGORwNA2oTW06RWLy
 pX1hb8yX7fFCAq0ABtU1DEJkJbI4B7HBf8ObczbIO/M97R3llOdDMkugQnJdyKTMa4q3
 XU9o0OgE4J8MXHLatAlthYwHX58odjU8ZOk= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3epfssj5vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 22:12:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CObi0bHBGK937v/ttRq0EwY28/nhK8s/mR2Djs+qm+mFpeNe6/JftW76c7NITHkqnMdycodFWWIQooqZN40n9vba0OgOFL4HzxLZmekJ8DANI7fs0+5h/3yMqBVNAqp64hruEMdMT/t8X1ExD5u7P9KaDb9cbE2S0Ww7yjFi7eGDciZy25Hq5d5utBgCjbnM34Htv39wSdr7Z4eXDzZNQPiWT4kBGUXe4YXBXpZ3xnjYmAKscPkBJ9Qwu+sjkROVKenKtAzP4TfDMMuOW2GVrRFz4TwYMS0uYz/SajlR2uJDfQIHlQ6Jh2q6jeOVPNrjRm2DbGLMVJsXisUvMnl3Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3f2y8kad+waotwGCxPk6/YakBZyZI83+Nr6Bri8JGF8=;
 b=bpNHjV4psvIdzZGXCAm8m+ey4jbETYZa9djGubS/IlJ1Oo+1VKr2IE2/DgvsodS4qMSVFwlVrblK3d+43NPfgq+QSzGYAWps7IfctYjwMNwcq/0NUo9vHJHZqcd827AXmw5VErbFKvtoF76LEImE2MRMWw3HKJNvXwrUQQHD7cOZeBqyN3bYJUlvFTJ8/P2tLUEiDwqUKRIFCcVBH/KU1BuFj+EKqbAc6TkY4HrN7HA9d2W/ex9rtHTuvFj5xqaOlENHCXU4FsXZgJ2DwX9qwJwQOjqd8IW4v9FG628ato1WJ6lFSBfJwRZSU2178COSbSzhv7k7vGVB4RAMm27PyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN7PR15MB4173.namprd15.prod.outlook.com (2603:10b6:806:10f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 06:12:57 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 06:12:57 +0000
Date:   Tue, 8 Mar 2022 22:12:54 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 0/5] Add support for transmitting packets
 using XDP in bpf_prog_run()
Message-ID: <20220309061254.lbz7no6hxjphr34w@kafai-mbp.dhcp.thefacebook.com>
References: <20220308145801.46256-1-toke@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220308145801.46256-1-toke@redhat.com>
X-ClientProxiedBy: CO1PR15CA0106.namprd15.prod.outlook.com
 (2603:10b6:101:21::26) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7aa2fc45-418f-4310-700f-08da0193db11
X-MS-TrafficTypeDiagnostic: SN7PR15MB4173:EE_
X-Microsoft-Antispam-PRVS: <SN7PR15MB4173363ECB86B2CCF020820CD50A9@SN7PR15MB4173.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: APnwC2C583pPZJDVhumg+JYr1+cQE3p7D7PG+dVEnrrexfsW0KeKnT5a3rjjzSrfo2Gw6I6S1L2NY0nDkEvIHP2y7FcYb8ow5tQItXYF9c15Ji4wJhHwzbHLfX4j6cviCCRSpX/U/jQpXfzysxwWM0yde+g5HU2dip447HOHcE50kuGN6VcWKk9Jw2xdtRZOj5cBD2qD0B+9YLvaSF3OQVk/t0Ye09yFCX72pp7yIvHlG+0zBFzPjwsundLEUK+9rzL0ADfOhau8xeq+H5hxKdqObcVZI0tQ9rEQ6Sqj9HdpiFAkF1wgGoRDBqDaWy6f332O871Vyv4xxz+IW+hIJ7iqkjmgOSuf/BCd1M4iB+ALsjM9tDdkTroso9r0FMIkEFe37nbVVMGJE8q3L6BIObvzAHFaLALy6/xFXKRQs0cL7/kaLOCJkmb8YwaEQ5dqvB7LoKRlIEWT3P1dbdWuxddKzOAfQUNIhDKNg6WnKzb55hSaYCoBHyGwPLt68zgpipLq/AKFL2FVdtcYEZIJWmrkI1Zwt3eQ6WHYUfqB0ZCj9CbmWfxiAXrIkMwFdjWlyiNEWs3u1qtm0ML71sKYnoaOF74xmKUxs+voVPbl0WlxDea+iKYlOhiL1HPK50pDa20DTRvaIuQ4b9lfi5qmYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(6512007)(9686003)(86362001)(186003)(38100700002)(316002)(54906003)(1076003)(6916009)(66574015)(7416002)(6486002)(66556008)(66476007)(8676002)(66946007)(4326008)(508600001)(52116002)(5660300002)(8936002)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?f7wd5uYyK+RASBmz1Yfar9fpn9TKumUxiEy0UPOy/rLM4UIj8MBj7qb8J0?=
 =?iso-8859-1?Q?wfSsGmuCehYN+7XUxDzOT98BZqyDnBivvjtMHPUjW37sQ5zSabOXQgUJAm?=
 =?iso-8859-1?Q?r2lDzGOMtpqrdYT84eU3K8yuwi1McuHk3QcnwcPa5H93v+Ez6a2bShSTgt?=
 =?iso-8859-1?Q?8GbsGp+NJEjIvEO+W59Ie7CiNFzGNjO5kjwhOrpeQutA4pHpJCf6olCuK5?=
 =?iso-8859-1?Q?eodlykb6tanzIHCiT//hdJcZ/6+2tvD3vIyv1zuv0dAhTJ2VOeXR8rtC8u?=
 =?iso-8859-1?Q?kbDM1o3ox73rVOe5KO61pdC5556RS0rTjSfz81tbN4042KGkx1aMjLQY7+?=
 =?iso-8859-1?Q?fUoQJlCmqEEKgDa0hop1j9sTezT8ta50tKZ/zPTKjfAYd8b9h/x70abKvo?=
 =?iso-8859-1?Q?HFtQuQSDwPnje8x7hPS8KHJdQfD2KbJXNKdxmpPKD9GJCeUDN2gP1PMkPC?=
 =?iso-8859-1?Q?qa18+xLzc+mMdWv1l9ORZ4zPI7qgl0yGCrvpe3nsmyZYarrTxHHU3AdnOs?=
 =?iso-8859-1?Q?RNS0+njEYUriARdZOR+rrgOlbqBwvNHGTwgmYmDMoqy7PrOUHbg0xBZDhe?=
 =?iso-8859-1?Q?mf4VBMkDkkJVeEgASgECMgGY5SUNUySmHuvj2nsVqBWt6RZeNLB2jK+saX?=
 =?iso-8859-1?Q?yzcM7AqldkqAh0JkCC/D99pX9Lv49T5QFT58NT02bByfiC8lohSkRIqbL1?=
 =?iso-8859-1?Q?bzbVrFdyGx7cC9QSszlgxdev6CMWK+1UXsnIg9L0Zyh8BKFs/kvIk0woRl?=
 =?iso-8859-1?Q?zv8BTl/NsKTum502qbqcl2hmAUcYBtrf9HiOVs41Z8UeYad5eBYX7Hb5F6?=
 =?iso-8859-1?Q?qkoPkcVoBkGwJGmR/eJlN/ZFP10iCLBliofgC+Lhi8QTNsFOR1LfprBkYI?=
 =?iso-8859-1?Q?SlTu31TS9R9osJuI8bVCy2J3Dv74h3QV/8hjGLjpbKdDFX9d2XRlWLLM5T?=
 =?iso-8859-1?Q?mij7T4b9pCdzSZ3h2bTzr12557NfojQPhLFPwuoorXHlL9oOfdei3/5Uk+?=
 =?iso-8859-1?Q?Xxf8ekwzhO3vd8RxF0wNMjsk2nWckFSvEly6JK4Yi8a9xW7uyNDh4qWhLJ?=
 =?iso-8859-1?Q?7jxoUgpjtRhp+HL04KF5iHXmaXFk5nzuBMwaHErqi/avzrvNNv2wk95gSt?=
 =?iso-8859-1?Q?/NsYx695PG6SILPDUEvFAr15mzxSNqYKFCYzWyyLA6JQMgTCfS+uCkpvEi?=
 =?iso-8859-1?Q?KArHiiu6S6yNCV6htNvUeYT18ZSNLWY6eL4gq5oGLHKpkX1tEzvooiQEN+?=
 =?iso-8859-1?Q?5IApGCSMVeTDvDMfjpws2rIm8MKo9mZ0tjavpU+0XYtOokBkC8tnBoioTu?=
 =?iso-8859-1?Q?ezhGmkWvJ/tZATEYgPPiKQ9FS6ZgQSey36EjHclxjiZA/z04Mzn/XYdiKH?=
 =?iso-8859-1?Q?smRDnR70sIy8s3Dyud7NmJVhee6EgsplXJmJiKCMLHnlXVrC3lJr0rHZtE?=
 =?iso-8859-1?Q?SxtgeokH04xv4YxnbETx/yKBTEDrWyITCAqHdPG5Ev8NbZmIw1nW7g4doC?=
 =?iso-8859-1?Q?Of08UPMN5ihDtmR2Ps3+UKbGssfrB99dO6nGxyt2OQfjXqW/lO29DcVI8k?=
 =?iso-8859-1?Q?nkO7jw0h+eWhkC0u2yAdHLTxfZPZoX6CBHP8aQVIfrdng4Y6AHi37R8lqk?=
 =?iso-8859-1?Q?zqur84OyXXv9Ha1ZQ9oRMnwJXM1PpgAi11wqnPbR/xiNEqD4aiWEDyCQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa2fc45-418f-4310-700f-08da0193db11
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 06:12:57.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qfFkPRFnFUrWZRV3MJF8T+7Q18OrLJaU96EZ0kl14mlYtW/ppA4hD5MWpfOZkK/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4173
X-Proofpoint-ORIG-GUID: 4q0hFapsKWYwb932P2GyiSkbERfr-NYv
X-Proofpoint-GUID: 4q0hFapsKWYwb932P2GyiSkbERfr-NYv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-09_02,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 03:57:56PM +0100, Toke Høiland-Jørgensen wrote:
> This series adds support for transmitting packets using XDP in
> bpf_prog_run(), by enabling a new mode "live packet" mode which will handle
> the XDP program return codes and redirect the packets to the stack or other
> devices.
> 
> The primary use case for this is testing the redirect map types and the
> ndo_xdp_xmit driver operation without an external traffic generator. But it
> turns out to also be useful for creating a programmable traffic generator
> in XDP, as well as injecting frames into the stack. A sample traffic
> generator, which was included in previous versions of the series, but now
> moved to xdp-tools, transmits up to 9 Mpps/core on my test machine.
> 
> To transmit the frames, the new mode instantiates a page_pool structure in
> bpf_prog_run() and initialises the pages to contain XDP frames with the
> data passed in by userspace. These frames can then be handled as though
> they came from the hardware XDP path, and the existing page_pool code takes
> care of returning and recycling them. The setup is optimised for high
> performance with a high number of repetitions to support stress testing and
> the traffic generator use case; see patch 1 for details.
> 
> v10:
> - Only propagate memory allocation errors from xdp_test_run_batch()
Other than a case in patch 1.  The set lgtm.

Acked-by: Martin KaFai Lau <kafai@fb.com>

> - Get rid of BPF_F_TEST_XDP_RESERVED; batch_size can be used to probe
> - Check that batch_size is unset in non-XDP test_run funcs
> - Lower the number of repetitions in the selftest to 10k
> - Count number of recycled pages in the selftest
> - Fix a few other nits from Martin, carry forward ACKs
