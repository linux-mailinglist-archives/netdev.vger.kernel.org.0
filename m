Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B480E4D0FB0
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245726AbiCHGBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbiCHGBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:01:41 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0303122B;
        Mon,  7 Mar 2022 22:00:45 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22816U76011297;
        Mon, 7 Mar 2022 22:00:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=t+zGCAXzai7nHk9z8vgbIKoM9RwMY47PVdYqMQmRlWg=;
 b=ZppLSwkSv2AfX8/Xya5FR53PGl4GAq1yKXeX/ivGuRzGbZBfFNB2ObrnttirR5eyIoR+
 RCVviLVgSeR7Fu6jE+pIuEcgpIKwq8VmUPS8rjPTxUPjmatbtw8iVLK8XLB+VDY9k/ff
 Uc5GGJvmlo7DSMzLEf3edOEZOp4V6YoxJKk= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3em827qsxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 22:00:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWpZf7MxsFy/vZVbuljfMlTlTVqNsWI7j3RuZGwJE7jt1aGbm6L/G6K8HA4Yye4rpDEj7ia26PqtqJYreGhnokA/Y1YmIwMkdB6DxxP5yt7zmlro0CByDcHIVMpuZqSxveatzz5UzLSTu61ANZFaEA4tC63RWzOJnqq0SUseattFGtCrelHGhrznrkN59uW3h18QJjzda+ze/piF3Z03660tcTTggpQDSMKARuymQdUK/aKRdO2qxTRIP8FjEW3ko92NXpOHW2xX86bH87g1GzWaZMAx793e/viUgRw5TMP6D2YAu+VWAWj6rKWNnC0AUOoYscyEkiFQJLi2LoSN2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6238bieiqFaf+kIVzrPxQ4Sn112mtuMGjeUXTo6Ejs=;
 b=X0cRtUW2XcWuLnEDk+8EQiJ0agIB5iRBn1+Xly+3hmVC+bg4MBBjaT6Z67HuM8K33c9EiXxFH8E/LTsths2/qrOp52qULBx70dlP76NNUQ3AWb+B0EiVjTR6UskUHpX1QU5o9VcAK9UER0VHsddB3WRvVFpk4RM1MvspLF5mVJD0wOckAFRuV946Dqp/hZo5rPJk59CWy+JOHOv9LypXyQKcd2TZtlYPH3wej1T3j1ojMQ+4BLnlp8HVLXeY2/BHERprAzzyd4Bhn2LBCZuF0iKBkXK4DhmcfbstXaAUZJSWFCqxS0uk3jPVYAxO42JLnEXptR2VgPNby09zd94Qcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MN2PR15MB3248.namprd15.prod.outlook.com (2603:10b6:208:38::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Tue, 8 Mar
 2022 06:00:03 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 06:00:03 +0000
Date:   Mon, 7 Mar 2022 21:59:59 -0800
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
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 5/5] selftests/bpf: Add selftest for
 XDP_REDIRECT in BPF_PROG_RUN
Message-ID: <20220308055959.ltrzq3kkq7joslv2@kafai-mbp.dhcp.thefacebook.com>
References: <20220306223404.60170-1-toke@redhat.com>
 <20220306223404.60170-6-toke@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220306223404.60170-6-toke@redhat.com>
X-ClientProxiedBy: MWHPR15CA0046.namprd15.prod.outlook.com
 (2603:10b6:300:ad::32) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9d90524-f5c3-40d4-dbe2-08da00c8e330
X-MS-TrafficTypeDiagnostic: MN2PR15MB3248:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB3248BE2A9C073FC836278ACCD5099@MN2PR15MB3248.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wAlRS/OxBsxXd7Yp8g3i8lHlDIQYDOujiIJJXg0Ahqs1HpyNZEjV/D/FTSsEZRMhrUKmfln0ChDxr0JAdV3DcyLmMtw3wHZd1BPstp3lII8NKVJZerDvUrjvTqOdX5ofqOgFwjbMvzaILGXfjed12lUcyZbR570lNw+2eVTR9efMPpuFTg2zEmyvjStoD67ZgRp6KnUa5OVlnBk7a40izw8ST7h5uzUB57/EjOdQIf3684DDVOpNbOhLskfkSwBBdY+CdriJCMa1EIZpKpGarIA4g8+XQEgNwBM/TFoA0XvTHHTenusJL/mMU1kgM7loAQc1Nb0KGyl7VYFvusUuMJPaDsK2AVfGkqke1lDSf3HYQgaHAAjV0zDSj/NIb6QfXbJP5ymiX3j8iUAdjivtF92stcmvKRteRuh+eA0s6T+XqLUmakbgx0VpZ4j4+/ki9ivpg6EqpaHd2q61alo9+R4LOZAkSNCYYJLH8Nv+5phEEcsQOW1u77hMRoKibwHpNgP/WO93G4omUGZ5eTf6wot9/7I2fAbh1apInLX+UXBGLpbtgKA7NQdXz51eKX0GMefykDhz2HNIekEbl4dS+w5QlbXbOpHTVfYPxO8uCeh8UTliE54FpJGHoKYV4KPdp9hdjhm9LInky0zpidNotQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(2906002)(6512007)(86362001)(6506007)(9686003)(6486002)(7416002)(66574015)(5660300002)(38100700002)(52116002)(8936002)(66476007)(8676002)(54906003)(66946007)(66556008)(4326008)(508600001)(83380400001)(316002)(6916009)(186003)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?7LQe1ioWJ/kUs9RCK2bIMcmd6uAifWDl0ST+pXDx40nB5Q6VhGr0dGCtX/?=
 =?iso-8859-1?Q?85uVS8qtk6Z0g5ofWC2kfsXBpcq/FKuSoJ3Pa9yaI/KOV4tfEVsXgoVb77?=
 =?iso-8859-1?Q?3BYbJMe6PB1GHxPgDkYJSKWbFwLb4BDu2cygRztdpDUYd85QFqj+gW1zhv?=
 =?iso-8859-1?Q?atS2AUA8Zbg7Mm2rpJCwnq6DVcFKnrWYiPg6A/Vk/+INkZ9Otb60Qa92KD?=
 =?iso-8859-1?Q?/QbO9yQYroCbfHaFISsqCJCT4hf4yGiH/vzetdhpzCueS/8flCnQDhlQ2Z?=
 =?iso-8859-1?Q?D0nAs3exprv7SikzCrfOwsifa97EV2nYlcPFaHtDyvqJput24axYRgVNyC?=
 =?iso-8859-1?Q?FaHZSTCT3azo9H8QuZpozcSNwvxrveX2eUvT+KoVcQOCCtn01PRyMVYp5/?=
 =?iso-8859-1?Q?7VhVcKrpIPb4qc8C8tYHE0TXSPus97RMZWhpy80sD3LLqNHYdP2RqhEseg?=
 =?iso-8859-1?Q?7oIByDpSu2SoIv34IHGcNNTHoUaLCyJJmEcjzl/4b21VBmgRH4HOQj/wbH?=
 =?iso-8859-1?Q?MY+T1nOBzm9Tm8iNZ7EXop7jWbSoqt7IYCoxT/Q8ZDuIIMrQKA6ph1grSM?=
 =?iso-8859-1?Q?QjmzQpOA005aymFP/d41bSwu3Q52VbYkPHi7d92cL9Lp/glCwbLruRhzlr?=
 =?iso-8859-1?Q?Z1czPN54KLspPWGKLMZvs4gFuquaO3XAwsoBYNoPBopzXOQQhKDMzvHfXo?=
 =?iso-8859-1?Q?HQbZ+jgSPAbYGkcsGiy8qrnFEoEplyuu1+/Re+ZjyqvuPAo+VfalEgXKZM?=
 =?iso-8859-1?Q?tVIaTAjhBfMu6IhlBW2Y9YGUbwFwH+LKGbriRL2sihEcrBLMlTdG85IJqT?=
 =?iso-8859-1?Q?gZH+VGeG960UPZ5wbUXApZuavKq5Xgf8o9iS3UKTfe+WAHPlwa6IEyh7kv?=
 =?iso-8859-1?Q?sPYzyjG9uSg+V9pkvhery65D6GIfnCMTPEb0ZpATIAhLFbH9e9tMe29IrR?=
 =?iso-8859-1?Q?HNHGJtx7S7+5z5rkjJ9/am0ZvlytKmtMZKUiZboAk89bWIZ2PatfPaQo2/?=
 =?iso-8859-1?Q?lBymUT1HXpsq1eTmXXQ76jUY6a+z3+NVChSC948ii0K45aoWBAwtZuElNN?=
 =?iso-8859-1?Q?bT7vZ/93O6F8MhvJD+npJO1n+9m/Skn5G4I9U3Dor+4Bx61Kl3ih/j5mMz?=
 =?iso-8859-1?Q?EMZkBy8PvYPqEDZjuuMBlkERDmU+lD9WkO+F6Rfs/QmNt5BVui/XuWYVCT?=
 =?iso-8859-1?Q?YOK/v0LJ1k7f/JAJhxSBEc3/cJdxilSnGvxCiyqX2/XhUAuZpvWdkQN5Ki?=
 =?iso-8859-1?Q?QLRaqRrs3M2dJl/fK0XHiAoNal7RBT7gjujLNxiuO8d4k3i74TagM3HVja?=
 =?iso-8859-1?Q?3P6Ed6TDQ6x6mQWUJwGxxLWFVT89gNyTOfIFjYUV2H1Qm/y9EFzwuTDt5E?=
 =?iso-8859-1?Q?WdC/40G3fXd/0ljzPM9h/sc+JNu6qyGd01tzSz0GhjIyL2F1vsNOqKBy52?=
 =?iso-8859-1?Q?F6sCzK80o2RUL9jqp5rqZqCYa92P2LtneBQ+x6gJiWIqF3W3t6eEmvg4wq?=
 =?iso-8859-1?Q?7L7sldRnTzQoDv12hLT4QfVR/iebF7t/qQiCziFjlGI0Tjbw4swHCnB9T6?=
 =?iso-8859-1?Q?ZK1waMSgWgzqrhMmaEPKpeDgKV3rS9Q7o6aRa2IvicjSYtLmTZU1gMG+PC?=
 =?iso-8859-1?Q?mSn7ggtbsHs0EMONGGi8lfrQ8eTTjU+v1P?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d90524-f5c3-40d4-dbe2-08da00c8e330
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 06:00:03.3623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oC/bZCY6vRBldiw+k2Rtbr1tuFTh8JkwnmlzN/lOOoiqchaANqIZsOfyTjeTSEGL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3248
X-Proofpoint-GUID: eR3REOKOWkpoXsXAKE2kewukApAJRcRx
X-Proofpoint-ORIG-GUID: eR3REOKOWkpoXsXAKE2kewukApAJRcRx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_02,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 11:34:04PM +0100, Toke Høiland-Jørgensen wrote:

> +#define NUM_PKTS 1000000
It took my qemu 30s to run.
Would it have the same test coverage by lowering it to something
like 10000  ?

> +void test_xdp_do_redirect(void)
> +{
> +	int err, xdp_prog_fd, tc_prog_fd, ifindex_src, ifindex_dst;
> +	char data[sizeof(pkt_udp) + sizeof(__u32)];
> +	struct test_xdp_do_redirect *skel = NULL;
> +	struct nstoken *nstoken = NULL;
> +	struct bpf_link *link;
> +
> +	struct xdp_md ctx_in = { .data = sizeof(__u32),
> +				 .data_end = sizeof(data) };
> +	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
> +			    .data_in = &data,
> +			    .data_size_in = sizeof(data),
> +			    .ctx_in = &ctx_in,
> +			    .ctx_size_in = sizeof(ctx_in),
> +			    .flags = BPF_F_TEST_XDP_LIVE_FRAMES,
> +			    .repeat = NUM_PKTS,
> +			    .batch_size = 64,
> +		);
> +	DECLARE_LIBBPF_OPTS(bpf_tc_hook, tc_hook,
> +			    .attach_point = BPF_TC_INGRESS);
> +
> +	memcpy(&data[sizeof(__u32)], &pkt_udp, sizeof(pkt_udp));
> +	*((__u32 *)data) = 0x42; /* metadata test value */
> +
> +	skel = test_xdp_do_redirect__open();
> +	if (!ASSERT_OK_PTR(skel, "skel"))
> +		return;
> +
> +	/* The XDP program we run with bpf_prog_run() will cycle through all
> +	 * three xmit (PASS/TX/REDIRECT) return codes starting from above, and
> +	 * ending up with PASS, so we should end up with two packets on the dst
> +	 * iface and NUM_PKTS-2 in the TC hook. We match the packets on the UDP
> +	 * payload.
> +	 */
> +	SYS("ip netns add testns");
> +	nstoken = open_netns("testns");
> +	if (!ASSERT_OK_PTR(nstoken, "setns"))
> +		goto out;
> +
> +	SYS("ip link add veth_src type veth peer name veth_dst");
> +	SYS("ip link set dev veth_src address 00:11:22:33:44:55");
> +	SYS("ip link set dev veth_dst address 66:77:88:99:aa:bb");
> +	SYS("ip link set dev veth_src up");
> +	SYS("ip link set dev veth_dst up");
> +	SYS("ip addr add dev veth_src fc00::1/64");
> +	SYS("ip addr add dev veth_dst fc00::2/64");
> +	SYS("ip neigh add fc00::2 dev veth_src lladdr 66:77:88:99:aa:bb");
> +
> +	/* We enable forwarding in the test namespace because that will cause
> +	 * the packets that go through the kernel stack (with XDP_PASS) to be
> +	 * forwarded back out the same interface (because of the packet dst
> +	 * combined with the interface addresses). When this happens, the
> +	 * regular forwarding path will end up going through the same
> +	 * veth_xdp_xmit() call as the XDP_REDIRECT code, which can cause a
> +	 * deadlock if it happens on the same CPU. There's a local_bh_disable()
> +	 * in the test_run code to prevent this, but an earlier version of the
> +	 * code didn't have this, so we keep the test behaviour to make sure the
> +	 * bug doesn't resurface.
> +	 */
> +	SYS("sysctl -qw net.ipv6.conf.all.forwarding=1");
> +
> +	ifindex_src = if_nametoindex("veth_src");
> +	ifindex_dst = if_nametoindex("veth_dst");
> +	if (!ASSERT_NEQ(ifindex_src, 0, "ifindex_src") ||
> +	    !ASSERT_NEQ(ifindex_dst, 0, "ifindex_dst"))
> +		goto out;
> +
> +	memcpy(skel->rodata->expect_dst, &pkt_udp.eth.h_dest, ETH_ALEN);
> +	skel->rodata->ifindex_out = ifindex_src; /* redirect back to the same iface */
> +	skel->rodata->ifindex_in = ifindex_src;
> +	ctx_in.ingress_ifindex = ifindex_src;
> +	tc_hook.ifindex = ifindex_src;
> +
> +	if (!ASSERT_OK(test_xdp_do_redirect__load(skel), "load"))
> +		goto out;
> +
> +	link = bpf_program__attach_xdp(skel->progs.xdp_count_pkts, ifindex_dst);
> +	if (!ASSERT_OK_PTR(link, "prog_attach"))
> +		goto out;
> +	skel->links.xdp_count_pkts = link;
> +
> +	tc_prog_fd = bpf_program__fd(skel->progs.tc_count_pkts);
> +	if (attach_tc_prog(&tc_hook, tc_prog_fd))
> +		goto out;
> +
> +	xdp_prog_fd = bpf_program__fd(skel->progs.xdp_redirect);
> +	err = bpf_prog_test_run_opts(xdp_prog_fd, &opts);
> +	if (!ASSERT_OK(err, "prog_run"))
> +		goto out_tc;
> +
> +	/* wait for the packets to be flushed */
> +	kern_sync_rcu();
> +
> +	/* There will be one packet sent through XDP_REDIRECT and one through
> +	 * XDP_TX; these will show up on the XDP counting program, while the
> +	 * rest will be counted at the TC ingress hook (and the counting program
> +	 * resets the packet payload so they don't get counted twice even though
> +	 * they are re-xmited out the veth device
> +	 */
> +	ASSERT_EQ(skel->bss->pkts_seen_xdp, 2, "pkt_count_xdp");
> +	ASSERT_EQ(skel->bss->pkts_seen_tc, NUM_PKTS - 2, "pkt_count_tc");
> +
> +out_tc:
> +	bpf_tc_hook_destroy(&tc_hook);
> +out:
> +	if (nstoken)
> +		close_netns(nstoken);
> +	system("ip netns del testns");
> +	test_xdp_do_redirect__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> new file mode 100644
> index 000000000000..d785f48304ea
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> @@ -0,0 +1,92 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define ETH_ALEN 6
> +#define HDR_SZ (sizeof(struct ethhdr) + sizeof(struct ipv6hdr) + sizeof(struct udphdr))
> +const volatile int ifindex_out;
> +const volatile int ifindex_in;
> +const volatile __u8 expect_dst[ETH_ALEN];
> +volatile int pkts_seen_xdp = 0;
> +volatile int pkts_seen_tc = 0;
> +volatile int retcode = XDP_REDIRECT;
> +
> +SEC("xdp")
> +int xdp_redirect(struct xdp_md *xdp)
> +{
> +	__u32 *metadata = (void *)(long)xdp->data_meta;
> +	void *data_end = (void *)(long)xdp->data_end;
> +	void *data = (void *)(long)xdp->data;
> +
> +	__u8 *payload = data + HDR_SZ;
> +	int ret = retcode;
> +
> +	if (payload + 1 > data_end)
> +		return XDP_ABORTED;
> +
> +	if (xdp->ingress_ifindex != ifindex_in)
> +		return XDP_ABORTED;
> +
> +	if (metadata + 1 > data)
> +		return XDP_ABORTED;
> +
> +	if (*metadata != 0x42)
> +		return XDP_ABORTED;
> +
> +	*payload = 0x42;
nit. How about also adding a pkts_seen_zero counter here, like
	if (*payload == 0) {
		*payload = 0x42;
		pkts_seen_zero++;
	}

and add ASSERT_EQ(skel->bss->pkts_seen_zero, 2, "pkt_count_zero")
to the prog_tests.  It can better show the recycled page's data
is not re-initialized.

> +
> +	if (bpf_xdp_adjust_meta(xdp, 4))
> +		return XDP_ABORTED;
> +
> +	if (retcode > XDP_PASS)
> +		retcode--;
> +
> +	if (ret == XDP_REDIRECT)
> +		return bpf_redirect(ifindex_out, 0);
> +
> +	return ret;
> +}
> +
> +static bool check_pkt(void *data, void *data_end)
> +{
> +	struct ipv6hdr *iph = data + sizeof(struct ethhdr);
> +	__u8 *payload = data + HDR_SZ;
> +
> +	if (payload + 1 > data_end)
> +		return false;
> +
> +	if (iph->nexthdr != IPPROTO_UDP || *payload != 0x42)
> +		return false;
> +
> +	/* reset the payload so the same packet doesn't get counted twice when
> +	 * it cycles back through the kernel path and out the dst veth
> +	 */
> +	*payload = 0;
> +	return true;
> +}
> +
> +SEC("xdp")
> +int xdp_count_pkts(struct xdp_md *xdp)
> +{
> +	void *data = (void *)(long)xdp->data;
> +	void *data_end = (void *)(long)xdp->data_end;
> +
> +	if (check_pkt(data, data_end))
> +		pkts_seen_xdp++;
> +
> +	return XDP_DROP;
nit.  A comment here will be useful to explain XDP_DROP from
the xdp@veth@ingress will put the page back to the recycle
pool, which will be similar to xmit-ing out of a real NIC.

> +}
> +
> +SEC("tc")
> +int tc_count_pkts(struct __sk_buff *skb)
> +{
> +	void *data = (void *)(long)skb->data;
> +	void *data_end = (void *)(long)skb->data_end;
> +
> +	if (check_pkt(data, data_end))
> +		pkts_seen_tc++;
> +
> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> -- 
> 2.35.1
> 
