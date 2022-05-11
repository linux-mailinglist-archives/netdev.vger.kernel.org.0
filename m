Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C39A522899
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 02:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239463AbiEKAsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 20:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEKAsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 20:48:42 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93BE4AE15;
        Tue, 10 May 2022 17:48:40 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24B0abFA006936;
        Tue, 10 May 2022 17:48:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=TSh3RvWrCvFRcDS5IB7psHai4C2p/Jp0jsXVxTSzuQw=;
 b=CZzGAVWwkhX8DSnhXtNsyctX3IR8zhtCXGSaM44xy9HTbXBbV0BmGMKVE75/iaSiN0Rg
 SItqZwmO35Hz6+Xw15yKefZQw9uIphxSR75+prPFlr9vhGjqYaTzFhib/yll3dPDdoDK
 Zw84RovbAf1YEGD9NXitdBv33Fa3V/aw8W8= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fym646e0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 17:48:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejk0oTlcG6an5GN505JINiPGrpikAleZ8y6VpQc3tSOdAuY8QakRg1KFUdwLevWk/LZxDeleDMu36NOUpN+hppyYGrtvTkOgy3kHOXGtj0lfNpaTWID6g37WQKYdUYy6q21xBba0WUQfD8EUkfVRv+lkHr0DmaeoUVV8bDEB9sAwW/rlDaAoZ/CffRbCKPb8ChTcMaA5MvseI0NgDdahjyO0EhZwuzsadDXSsiAM34HVxnONnYuxAx9YxeAOJ/YvG5xcZvi9bm40TdKsD47MBXHuJeqnQsbKbToKQtzn4++JQEYcJqNqA30H2NCz2ggEInhP5pqHCnUhlC9DAXCPmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TSh3RvWrCvFRcDS5IB7psHai4C2p/Jp0jsXVxTSzuQw=;
 b=RqDV37HiaqF1Q9FdHkFWRxxMrFkUFXzFRAHW1CzzUneczjG4U3qtK1xP9uim9nt+2/6I94y0+O0/ic/eeg+Tf9MPH2lmCS59q8A/qbF0ZLRP3cSwMGK+0qDr6SxqSILXUujZQ44j/G2tnC0uWn2fXOUzMZVUKH/5UCL2NBJ9AzHQbHQkdycAK7QauR5lxLEHplJXfER1COuYUKPKPxLfSGkgMOwaLFbZskS6oe59BiT/LkHC9FsS8OBkYZMOwDbU13/Pa3v0q99ysXcp9wxF9FLwlR/tC1v+T0ZjQTeko8bHLa72l7ntrRnD9uahirDAvEkJycJhPUauY/UG5bvP/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CY4PR15MB1495.namprd15.prod.outlook.com (2603:10b6:903:f4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 00:48:20 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::fd7d:7e89:37f4:1714]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::fd7d:7e89:37f4:1714%5]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 00:48:20 +0000
Date:   Tue, 10 May 2022 17:48:18 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        ast@kernel.org, daniel@iogearbox.net, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next v3 1/8] bpf: expose is_mptcp flag to bpf_tcp_sock
Message-ID: <20220511004818.qnfpzgepmg7xufwd@kafai-mbp.dhcp.thefacebook.com>
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
 <20220502211235.142250-2-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502211235.142250-2-mathew.j.martineau@linux.intel.com>
X-ClientProxiedBy: BYAPR07CA0052.namprd07.prod.outlook.com
 (2603:10b6:a03:60::29) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 394697a1-e641-407e-2ef6-08da32e7f1f9
X-MS-TrafficTypeDiagnostic: CY4PR15MB1495:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB14956731B12657EEEDEE1D05D5C89@CY4PR15MB1495.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TFOcXvTKNpyMrGQhNIXF5dqX29lrgQ9Y/xBMg+WH2xblX0j4X2H1wMwNouot4cNybuL78KkU9g9icLajyex+nog/KVOvaoViW4zCBnxaS2lY3TArSf7Uny2yveujOvDwlTiy3yuosIpOH/9ed84WY+z1ZnWOGjT9tckx/r5SCg2u8powcu7lNYCvKhEFquffzqwIlAfRA5a35/lDPY3D+7TfMAd7PyobMhm9HSIpkIrkkftjsYUqkzRqCTT3NUc2zAts8C39Ucn1zwtKMR1NEc157g8spRTAdT3QNiArUznQbkgr3cVnAz2/CKBpxicsumcgl1nFhfN2el6ItmNqRPNIgnO+eVByE9d2n0gDBQrwwJqSAGCAC+hUMIuAVPGknzz1bCT6WQanjzfKG3g7Jj/mWIFU48ZV9EenbRCoYHekUawAa0tk+fGmZMisvI0Y0GeEetKc/bsNpclAhb55FNz5qIVe5zAUNsE6GUGsu/3djmtmDp3j+hTR1c9etO6LvwVZ8+wgWnIu+KOCDm+NDEX3O/odNp9hycIjkwwFPGlsrZp7HXeP4+ScHmk3aTd+BnyaeqoTJ9R/HBW62bP3HXScJ+kJmMymhER4bS+/YIkOy4S5EsnC+jYvfho/QRVbvIxOGIzOu5f9kMMGHMt6Dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(508600001)(9686003)(6486002)(6506007)(186003)(86362001)(1076003)(52116002)(2906002)(5660300002)(316002)(83380400001)(8676002)(66476007)(4326008)(54906003)(66946007)(66556008)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lkksCNlpnUKxMMJJtJ6LwQDKS4Cw/Yg+FoBTp90safWwUoiWtr2fKb6SWyoj?=
 =?us-ascii?Q?riJ74U5EsfEnbGKqZpetlNXgpL5VPrF3LiaPt95Ol8lh6vXoLHZJNv1Au9cJ?=
 =?us-ascii?Q?2sOorL4sXFytoJ8INfrRFFKEVv2BbaUcWG8t6NsC6VUlAISJmEpnpKXNNZBn?=
 =?us-ascii?Q?88PeE/BbvKdVK0gEvWaA37GFC4SaBLqvz9kzcgB+KXxHviB04KWyrm3WLeMi?=
 =?us-ascii?Q?vKTMo837o5dQd0xFhSBaZLpyLDsHuJfuYebUXM/Zz2GmRagX7LkjsBRvt+Jc?=
 =?us-ascii?Q?WwN/WzSFRroZIW1iU5r5LQn5YDioI/j8ZikDf6arscx1UplZBed+8E83Xkhc?=
 =?us-ascii?Q?D1Q2kvJmc7TmbW8WwNbL6qtuawKM9V3fN71TMgG+2fE8N2sAkM0tVwX9eEBH?=
 =?us-ascii?Q?dXSEnZ2xGxKEwfeBwddu0F1n/Dr1NgcIHAgULz1SlGarJFM8v0cVWTvDQ1pR?=
 =?us-ascii?Q?DJ+PYLOagXjVolsRcylBzpYi/fKBZeHNTBAIUVkxHlOakmtOEJ/y/DAK20kx?=
 =?us-ascii?Q?ZoPrPmJ2BY2eTWDjYpX0E32fr3iqtRB/leqph2nSdqx/n2krMq/FHqOhB7rL?=
 =?us-ascii?Q?eJ3KFObZSd7XdHoQAULUPPYb9K/FMmvicyknNSIacPFnT3GuB2bBsh3V6HmZ?=
 =?us-ascii?Q?zbz/BzntxeTpARSDKeexW6j5AxTGeEEL9bEuhgx3j6dnUXY3v/LRjWEuQmrY?=
 =?us-ascii?Q?KHgartx3zGi5ewH6YQ5T+vYzaciqQDGn2xStt5bX9CCTGLeLjKbrvAqviskr?=
 =?us-ascii?Q?RhRiR7OtXC7ilrZDLNVrK/YFKLyxPtYaJTifAEhTp0MQkKkE7xpMBDF0Cexo?=
 =?us-ascii?Q?kW8dcr+Gu6t5dcaknrR2IGvpWV29c895pR9TULb/15Eu69LcA6SJDvfK1cBi?=
 =?us-ascii?Q?VSNTqpxoMQWwll2EYQjf4YJYrxd7ogddDFEH/UknB2i0Opo/98J7J4/ltIAL?=
 =?us-ascii?Q?dusqBlOJwm1RmpsEsCK657X/sFdkoC2xjuRgfmJvSqNSZ/ILsam3NzOJlhCB?=
 =?us-ascii?Q?mE+LNP841J2Tb3cBI8rBMrO7xXfi7r8YjS6mPlHLgstecrEg+S6d3UtZZL66?=
 =?us-ascii?Q?6eS3j8/Ds9/UxchG8oz/ChSIpfcJuNHRS8oFxwMMFub8+G6zP9zyTM3nINkX?=
 =?us-ascii?Q?HUBX7EU+jtYOc4xMuGxhVajNII12wYVgMoQRhpdsICdbnMlEgGWTpIrUn7iO?=
 =?us-ascii?Q?6kXwwF4z+tkpEenDh82gI+UAQ+z7oGn7PlsYxOmOKg9slDupk92m+RcYigbf?=
 =?us-ascii?Q?ifMNV9AAbnYGvY/7i45D/pxy8XEh7NNuSTtfJ8CvXEYjVUk0gUB138CNKb5R?=
 =?us-ascii?Q?8xzfLLJwoc/nu34snjCxg8rxAp5zHLy5la8Kst3ZH4xcIDFEiMYV9+yGnRNd?=
 =?us-ascii?Q?bJU3lh9SXYgk2a+jcqv9H/55Dni80lDTHwmH5wP30WNMpUtVkefSdC03N6TQ?=
 =?us-ascii?Q?gWCVAMbIlAVQd3t1V3Jbs91tf6L6Bxqw/9yScyXu+zlNJc3lN+QlI4eqmdhT?=
 =?us-ascii?Q?H0zMPJZQqsKusN24SKv57Kc8UdaGmTifPd09PEGyBqlHTLe4QFwfSlOXn0mR?=
 =?us-ascii?Q?1i1FfAb9cIwLbSnULnOY1Z+YEFwraxajMbiu40Ib/wCwMQuFB1ggYBdLdUQG?=
 =?us-ascii?Q?5LxwrNN5MYENe4Y0umdj14Jzg/WBWwl0KYqIOWE4O6jjrB1dtQ8NNByI5WYT?=
 =?us-ascii?Q?BZrU/FRkliooKwQOtcvKOz+7fs9vImrOOg6mM8PumqVFgYI75z9HjGJjcdz3?=
 =?us-ascii?Q?enSojZ2niN4I7FTwqNFID0Mz9JLNFOo=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394697a1-e641-407e-2ef6-08da32e7f1f9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 00:48:20.6539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wnFm9PMWxN+S8pYQz6u6Mk4lVoF5gK1sTkapGW9SWyS3vF/7mmcXB3BEgPllj95g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1495
X-Proofpoint-GUID: eDuyUAZa6d4zCIhS5qJjRrrzJ6KtmdwK
X-Proofpoint-ORIG-GUID: eDuyUAZa6d4zCIhS5qJjRrrzJ6KtmdwK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_07,2022-05-10_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 02:12:27PM -0700, Mat Martineau wrote:
> From: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> 
> is_mptcp is a field from struct tcp_sock used to indicate that the
> current tcp_sock is part of the MPTCP protocol.
> 
> In this protocol, a first socket (mptcp_sock) is created with
> sk_protocol set to IPPROTO_MPTCP (=262) for control purpose but it
> isn't directly on the wire. This is the role of the subflow (kernel)
> sockets which are classical tcp_sock with sk_protocol set to
> IPPROTO_TCP. The only way to differentiate such sockets from plain TCP
> sockets is the is_mptcp field from tcp_sock.
> 
> Such an exposure in BPF is thus required to be able to differentiate
> plain TCP sockets from MPTCP subflow sockets in BPF_PROG_TYPE_SOCK_OPS
> programs.
> 
> The choice has been made to silently pass the case when CONFIG_MPTCP is
> unset by defaulting is_mptcp to 0 in order to make BPF independent of
> the MPTCP configuration. Another solution is to make the verifier fail
> in 'bpf_tcp_sock_is_valid_ctx_access' but this will add an additional
> '#ifdef CONFIG_MPTCP' in the BPF code and a same injected BPF program
> will not run if MPTCP is not set.
There is already bpf_skc_to_tcp_sock() and its returned tcp_sock pointer
can access all fields of the "struct tcp_sock" without extending
the bpf_tcp_sock.

iiuc, I believe the needs to extend bpf_tcp_sock here is to make the
same bpf sockops prog works for kernel with and without CONFIG_MPTCP
because tp->is_mptcp is not always available:

struct tcp_sock {
	/* ... */

#if IS_ENABLED(CONFIG_MPTCP)
	bool    is_mptcp;
#endif
};

Andrii, do you think bpf_core_field_exists() can be used in
the bpf prog to test if is_mptcp is available in the running kernel
such that the same bpf prog can be used in kernel with and without
CONFIG_MPTCP?
