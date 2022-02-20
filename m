Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E1E4BCD64
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 09:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243438AbiBTIt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 03:49:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbiBTIt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 03:49:26 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3A454BCA;
        Sun, 20 Feb 2022 00:49:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3cfnOFuHniugXnEQv4Q0EMngVvITryDhC0s7FBtwA2hoJ3s6fKESQ315j+1UL0hdUxUU2EANSG6Q3C7CZwYjVyL0I6hf96ihqN18uWTsGHb1WQ9byI+HqJwtqhgeryRcJXYZ+7cv5uCiCt6J1jXB42VOJ9730kmRmR+aUOpGBuyITynXUkCVqSAUIolG56gEbouvlgRJquevOyNGJMMupzJ3tmvlH2SBP8vjFAEgDrtwz6LS1U8POseJzmIHBDqifSd3K33Qg+e+QnzJUKnm8+76cO6MEHFe9sA7mt0Gur1tljlc82SfQzyVmhVLdNWuDgb1eWKx1WeHYR6JtjfWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lB37hVrY0fzvMWPshVC00E5k2xme6qe6qiKY7gorh8I=;
 b=KmvmtJl1At47l2DCZKT1D1sK5JDxp5vRYz/zmUu865A8x8QcwThzU7QUeStROaaXu6+unJnzHl1492OgPsTEAx8Lm3EUj/6cydVWEPSR/PjryTY0wWk0aU1UlACrJxTmryHF2uZdF2KVsUbg4OzDwKPE4qfAAsp6/9if3kOi7yH185EEh/UfXcuyXvjVfMagDScOPoGKEbyktq68q40Vis34h6siq7kKCvaWED0l2eE+0XvLRMOh3VCixnsfmJDFGJMDgds179HzxMMEzazouoyg3Txlz27siCLIgXUrDNc5yeHTnAxUx31Fi/XL/x4JgKIUWg4Dl7H8iPNfzARQAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB37hVrY0fzvMWPshVC00E5k2xme6qe6qiKY7gorh8I=;
 b=qU46EM3HU1MRSCAWwz/4dJt0SPbD8SvUPq38Kxa4eNaG2GlSQMI32zpqarYqf1hpaRSg8OPjdVv9liXg9vZilRDuQ+Hx/YjslkRHJQvmqsnT+MTV9ASbwXWDREGgAtAq/Vmg0i8QobXhd3WPf2U6+h808ZhFnsdMqKxo0Dt/wNRi3Vzm854MCU4HFfizH/MmM4Eark/LfXF6tiLu5SM4K2bG3UWZzLztuh1T5/yA8dcQZqUGTR29Cn8uBTNJ20fMG8drjEuywXdyVPOCQrmgzR6oEvvLSm5A3pIOBLxs9TTb3Gk1Sg9esqtvBrbQb9HK1rcvznQt/4lrgmzMbJycjg==
Received: from MWHPR20CA0045.namprd20.prod.outlook.com (2603:10b6:300:ed::31)
 by DM6PR12MB2987.namprd12.prod.outlook.com (2603:10b6:5:3b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 08:49:03 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ed:cafe::d6) by MWHPR20CA0045.outlook.office365.com
 (2603:10b6:300:ed::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.20 via Frontend
 Transport; Sun, 20 Feb 2022 08:49:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 08:49:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 08:49:02 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 20 Feb 2022 00:48:57 -0800
Date:   Sun, 20 Feb 2022 10:48:47 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, <coreteam@netfilter.org>
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup failure
 with no originating ifindex
In-Reply-To: <Yg7itx2dt4rIa24W@salvia>
Message-ID: <af7f1a21-5776-9b92-63d6-ce19b97489a2@nvidia.com>
References: <20220217093424.23601-1-paulb@nvidia.com> <Yg5Tz5ucVAI3zOTs@salvia> <20220217232708.yhigtv2ssrlfsexs@t14s.localdomain> <Yg7gWIrIlGDDiVer@salvia> <Yg7itx2dt4rIa24W@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91490b06-22ef-49bb-c6a1-08d9f44dd896
X-MS-TrafficTypeDiagnostic: DM6PR12MB2987:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB29871D96716F18FB71E34056C2399@DM6PR12MB2987.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MNxC0Kte+nNk2Ei+olLovNMkMLxU/b/tM39JK9oGv7b/TIcABd+sCDdTtDPdI58KZ1fNjXPw50CyumT8Xr798PBZO4EHQBPHpg8yb3KkBCWhVzZWTd2RCt9R/l15WMhGvSCz5IEHhfx7/iUj/FKvmRm6/P0jVll1IF3i/i4NqrwdszBjm0RRXdYdDXTYGYBe5fkqnDz/ffvrF0mn5gzl51dH1ICFKJp5fPpR+5uMKsRP4k8ARqTOd5d1o7DFL/wTgyfjRxrztmKSfXYYWbrObaqFavm10lKU7P++MEJeXGUUqDkyKAw8PjImKiZVl1T7IGU5n562o9audFX49gPCbGkyLtJFxYWDBbbeijPcT9uSCUwBd3kTNfr8xnGdPs3+mtFDXO3T54heIgRMCJGGV/i9IvRMAFo5s2qeK7v03MEyQ8ScWC002slvYpJEGG5PezSrS68AWqv+7M8s2E7pmz4L9loG8NIIwYM4lfTcnl72G9GgY8py+P1zYaicY0RGdWV6KYhHVyo6DXZlo8dAfj1KbWXKO+vUGckuArOT1EqyjDMXspSUhhWLk56nca19oy6k9laIRrrZgrauQDzKh6eOUisil0uzsASeuH/mna+g25i2q3uImcsS+wMcdoPqVaxvW4UYfmShhvQAbCS5asM3ffK5vWQIqR3+V8Wtd/cm1Qer8lliS8pG79VziEugSf1zSMrTlEGtiQ7Reyjnqw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(36756003)(31686004)(47076005)(40460700003)(186003)(26005)(81166007)(16526019)(2906002)(356005)(336012)(426003)(83380400001)(4326008)(5660300002)(6916009)(54906003)(316002)(6666004)(8936002)(7416002)(2616005)(82310400004)(70206006)(70586007)(86362001)(508600001)(31696002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 08:49:03.1961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91490b06-22ef-49bb-c6a1-08d9f44dd896
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2987
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Fri, 18 Feb 2022, Pablo Neira Ayuso wrote:

> On Fri, Feb 18, 2022 at 12:55:07AM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Feb 17, 2022 at 08:27:08PM -0300, Marcelo Ricardo Leitner wrote:
> > > On Thu, Feb 17, 2022 at 02:55:27PM +0100, Pablo Neira Ayuso wrote:
> > > > On Thu, Feb 17, 2022 at 11:34:24AM +0200, Paul Blakey wrote:
> > > > > After cited commit optimizted hw insertion, flow table entries are
> > > > > populated with ifindex information which was intended to only be used
> > > > > for HW offload. This tuple ifindex is hashed in the flow table key, so
> > > > > it must be filled for lookup to be successful. But tuple ifindex is only
> > > > > relevant for the netfilter flowtables (nft), so it's not filled in
> > > > > act_ct flow table lookup, resulting in lookup failure, and no SW
> > > > > offload and no offload teardown for TCP connection FIN/RST packets.
> > > > > 
> > > > > To fix this, allow flow tables that don't hash the ifindex.
> > > > > Netfilter flow tables will keep using ifindex for a more specific
> > > > > offload, while act_ct will not.
> > > > 
> > > > Using iif == zero should be enough to specify not set?
> > > 
> > > You mean, when searching, if search input iif == zero, to simply not
> > > check it? That seems dangerous somehow.
> > 
> > dev_new_index() does not allocate ifindex as zero.
> > 
> > Anyway, @Paul: could you add a tc_ifidx field instead in the union
> > right after __hash instead to fix 9795ded7f924?
> 
> I mean this incomplete patch below:
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index a3647fadf1cc..d4fa4f716f68 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -142,6 +142,7 @@ struct flow_offload_tuple {
>                         u8              h_source[ETH_ALEN];
>                         u8              h_dest[ETH_ALEN];
>                 } out;
> +               u32                     tc_ifidx;
>         };
>  };
> 
> You will need to update nf_flow_rule_match() to set key->meta.ingress_ifindex to
> use tc_ifidx if it is set to non-zero value.
> 

I  understand how it could fix the original issue, but I don't think this
is better, because it makes tuple less generic. What you suggested with 
using 0 to avoid needing the new flag is good enough for me, and is 
cleaner in my opinion.

I'll send the == 0 one as V2 for chance you agree, and if you want to 
change to this, I won't mind sending it as V3.
