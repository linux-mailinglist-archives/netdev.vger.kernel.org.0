Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0B0342295
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 17:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhCSQ4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 12:56:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20450 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhCSQz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 12:55:59 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JGo2PI029564;
        Fri, 19 Mar 2021 09:55:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lTJFfQv04GZ+GbtqC+zm6qvAfu4aGArMK1b+Ojj9rxg=;
 b=aorhDMuQhLaW4hfotjVTv1k8u4bNMFdSupD5uTVOIz6OYJOhWo9n3xnkHjsiIXvof5O4
 imm/1bKeB6YHMCHLjFECMbaGj2KX+H7+ABByhshcQhqQpQFl73lOlFEZ6TqgBvypoPAN
 1EYTVw88/iqIM/zJS8/OqSxEOc3oK1/XTwg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1wbr6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Mar 2021 09:55:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 09:55:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/nPrMbxwsXyH6IO71c74ghJilgqIOmNLeJpFDacw7HOluqId9Sk5rAoPUdw87w0nfrjoLIpcL4McAtq4CAxLmi5k9JogA1tVDyJZMzNATt38WuK/GIC6t1sVfcuD6D6F+DOUTCM027javvduH/zE09ONQOmmJxOKp0irpLc67ACKzJgNJIVzBdJxCQPqHD5ytFyzd1yped6YbdvYynwr/P5qUpmzpEx1HQNKYctUeQK96gAzowAEDkNGf26WlL2ucDaLbjib94hnzzKvUqle6e7w1SgXGlzwICUEnmov7N6DANs4HBl6CYPKZdKpVD2FWrfQKTCDj4sAdSvW8mAWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K81WiJrgVg35eStkSO+xtDpHYPZN5DWrgOYPZ4jAUoQ=;
 b=S5N17OiUKIW7H0cyRX8hlCXEdXhQDrEXPU58EMyTi6iSus27imzLb3Gg/buQyzgFKvSLBCmq8UP/Be3uv3qqLA/eGM5kTGC5EYpXUa0pAoq/6H4WW94hC45KulVtZJ5OtybTf/0cKSxuHRm0Hd/OWMyY//lbe35dhNH7d5lbRSYqHwGr2Ku4opi7Gc41gCrc7NJ0XARtJHL8vAjFJDVqJBejzHULFjhYEKtD4wGFSBz6szQ26nYEVEkEhVO+Vuqma3Yz8KvHEXRhrz1rClAfCnDpiNxilO36tnz7be1KGJNQZEW0OVX+42W3rHDXNxdt220q8XT7FeGrypJFNyF+zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: mildred.fr; dkim=none (message not signed)
 header.d=none;mildred.fr; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4422.namprd15.prod.outlook.com (2603:10b6:a03:373::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 16:55:48 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.024; Fri, 19 Mar 2021
 16:55:48 +0000
Date:   Fri, 19 Mar 2021 09:55:46 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Shanti Lombard =?utf-8?Q?n=C3=A9e_Bouchez-Mongard=C3=A9?= 
        <shanti@mildred.fr>
CC:     bpf <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alexei.starovoitov@gmail.com>
Subject: Re: Design for sk_lookup helper function in context of sk_lookup hook
Message-ID: <20210319165546.6dbiki7es7uhdayw@kafai-mbp.dhcp.thefacebook.com>
References: <0eba7cd7-aa87-26a0-9431-686365d515f2@mildred.fr>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <0eba7cd7-aa87-26a0-9431-686365d515f2@mildred.fr>
X-Originating-IP: [2620:10d:c090:400::5:d22b]
X-ClientProxiedBy: BYAPR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::31) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d22b) by BYAPR02CA0018.namprd02.prod.outlook.com (2603:10b6:a02:ee::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 16:55:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ebbf2bc-1420-4152-9bb9-08d8eaf7d835
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4422:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB44228C7AE2516454158EE29BD5689@SJ0PR15MB4422.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8Z3LgVRcpds0wrC+7X20vWEmkzVd3meLzcc4ZsCbrza+5elyrT6BoGYNkaCkNMl53rbe6YGT625uS52pT8K8p/117dJpj2gOeMbS7ChB2wGh5ui12ctviFovKSR8wctl5k4LQe3bQMjr1ecOzEkq7slhxMOAnedJrtT48OZa/7RgOmyjlnkbveUf+tcxDL5OC3Eckr2vpc/UyQHz2O9CnEaE5/1eYPMihQfoS1NA/cbEtDFCpphE1cghTFX1fc4NVeaBPpekY5V+2LHTAglz4TmP8SrryFIq4MxzFz2WjSSEKWIdZt2CAkBPG43Xy4ymnioJ3ShGIKQ8O/LEtiXizYiuPklR2cB8LY25CYaqopRzWM/+sl3sqTlCvZ5LeWUMeBvoyJbUp1oHymtxzhuCnBPNrWBvgxfXeWAeMBs901WulD6XpwegCcgcnjuQbUhiAdJseyOzDJf0MYQZwqar/QzxEH44ObNQjPvgFPSu+fTQ7GAlh51PQ77AwrCYhWiZIab1ggqmnjBO0YlQVBZC3xbbs4waNUwVHf2s26Jtmw8YpIliyREy1uZhhcZ8kT9TxoNagdowK3utUJ4Pp8xM669FP0KX27OFpRphm4QNyPajCfBgix97gEh7CBb+bAzX3Fmq7qeCWdQ0D/1qZI9RtgnuL5LDze0n3Gr5DZ4Ypnh7H2Z1E/vpVu5e+ZT+XUYET/DHucrdy+NQAJN8Lv5DksQSOmS9pnu9X9HWEWiBSg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(376002)(346002)(38100700001)(4326008)(66574015)(2906002)(86362001)(966005)(478600001)(66946007)(8936002)(8676002)(83380400001)(6506007)(186003)(66476007)(55016002)(1076003)(66556008)(316002)(5660300002)(6916009)(9686003)(52116002)(7696005)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?/rrY5i2Hm6Cl0yMCe8tHPVUnDxvnbm17D3l0ZZuVb+uD2VMqOMv+lN4oq8?=
 =?iso-8859-1?Q?hmnTURJpYK+a3PBeV01ykfGF2pYcjLyfxIC/ECYe7dczaAXuTcUGC/Yh2r?=
 =?iso-8859-1?Q?AFtV2DoJrXPD2mKJV26K5RCDReQjZnv2AUytWG/jTvFBSNPbS5KvZfYb3Y?=
 =?iso-8859-1?Q?FiyE4O3TYXvu3nKEXYMipURMJkDi0WAct2KtE88WO6uvZoGWGtedYxFGjB?=
 =?iso-8859-1?Q?BEiVe2LTZF/O56D4Cagmd9x0wx2dpqWGvLXE5AoANc4XBAKmcNQyxgIt7m?=
 =?iso-8859-1?Q?PqJtjUaB7OfXQbhQY29RbRH3vBeHSR0xqYPoynW4FMVaFYlCoZEU83mfKT?=
 =?iso-8859-1?Q?QohnbRNq85UtNyaum9+v2BDpEyAmnHNIrFn8CF1TJX7kr6/v/aDZBDGKs9?=
 =?iso-8859-1?Q?z5sLkKntcOEmpLfK5/s0W5iVe3XGjCX1INvItqd5QKruD2bb1eQq7Oto4a?=
 =?iso-8859-1?Q?OEPa5Wu4iVtR/0OCTROJJUAlPuy+T96V65UiXv5L5amSgCd5zbnllXYOZ1?=
 =?iso-8859-1?Q?4FXjzrX3ZzZVNd8l3Xcs4jG8IUrl3rRK60CpXK8mUl18p95PRQkMGbFl5N?=
 =?iso-8859-1?Q?Shbe58GiwiL4jm2cijogd9sAlWlPq4hFqPoP1+F2usp0wrmd3DIKUQVJ4m?=
 =?iso-8859-1?Q?zQMQ2mwbPA/h2oZ30pVSYESOzPMwtu0krNKoFgyFLXNg6YV9k0jJdFbUW1?=
 =?iso-8859-1?Q?rdFk866zUfyWOQ0JGaQynLyV5miAj5Dn0Dapfl7Wf5srd9s3UxewNEh5fL?=
 =?iso-8859-1?Q?nrs6aYlWazCf91q04Xz98mnH2m/JHtdYXLNPY2pzQJ3gzqqlCGqHuUueCd?=
 =?iso-8859-1?Q?WArPH92blHfan0eW0KT7Ulw5Ehx5AfWupPEtTEWmEcyNHkIsEwSU4EPGZ+?=
 =?iso-8859-1?Q?Fsp7x78YUGVjDknayeE/v5yEsBHS8RwfMUG+7yb5ag64gNvjP11lPLMl2X?=
 =?iso-8859-1?Q?t4ubmEtZKNccNmeb7LGRxT8Q8JSITXPkoV0gaw16xCk2rX4dBUOnl2WLuK?=
 =?iso-8859-1?Q?RXmlqn0gLxQcMjyWSua9CsouTklW1jLwI1jjdliS1A6nM5utO80Q6ALI/7?=
 =?iso-8859-1?Q?UEFHiYlKK15erzbUf1ZiFlP3IoLo60Y9xAUKTQHn0IbK4RApEkdtrD28X3?=
 =?iso-8859-1?Q?2UgOjKSP08nTfXZ/3WYfpvEoFQbEI4Do77OJRXaA29h8ecnRTkVeoNLgCD?=
 =?iso-8859-1?Q?7o0wlGbj9Bmgur5dRwNMXAYN1KezynzF9R4uXF/vpGhJb3EmbstcSO9Csr?=
 =?iso-8859-1?Q?razuau1YnC6YP7pvOwTVjIqYGaS3JI8Rnad0bqiE2ZglyubKdP2nixU7g4?=
 =?iso-8859-1?Q?wao+8FAON8+hjVlyLvXn7jwON6ad+C6HEFr4XJyHpEmSZyuHqmlZqHiWTi?=
 =?iso-8859-1?Q?6V04NIgEZK6ue4irFiWltFPT2BsEFclA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ebbf2bc-1420-4152-9bb9-08d8eaf7d835
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 16:55:48.3135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/gZRYuhezaaqQJAPphIBGd4Mj7td8jNNmjQlVludjn5sWn/JZ/59Ed9ISyD7dyB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4422
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_09:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 10:04:18AM +0100, Shanti Lombard née Bouchez-Mongardé wrote:
> Hello everyone,
> 
> Background discussion: https://lore.kernel.org/bpf/CAADnVQJnX-+9u--px_VnhrMTPB=O9Y0LH9T7RJbqzfLchbUFvg@mail.gmail.com/
> 
> In a previous e-mail I was explaining that sk_lookup BPF programs had no way
> to lookup existing sockets in kernel space. The sockets have to be provided
> by userspace, and the userspace has to find a way to get them and update
> them, which in some circumstances can be difficult. I'm working on a patch
> to make socket lookup available to BPF programs in the context of the
> sk_lookup hook.
> 
> There is also two helper function bpf_sk_lokup_tcp and bpf_sk_lookup_udp
> which exists but are not available in the context of sk_lookup hooks. Making
> them available in this context is not very difficult (just configure it in
> net/core/filter.c) but those helpers will call back BPF code as part of the
> socket lookup potentially causing an infinite loop. We need to find a way to
> perform socket lookup but disable the BPF hook while doing so.
> 
> Around all this, I have a few design questions :
> 
> Q1: How do we prevent socket lookup from triggering BPF sk_lookup causing a
> loop?
The bpf_sk_lookup_(tcp|udp) will be called from the BPF_PROG_TYPE_SK_LOOKUP program?

> 
> - Solution A: We add a flag to the existing inet_lookup exported function
> (and similarly for inet6, udp4 and udp6). The INET_LOOKUP_SKIP_BPF_SK_LOOKUP
> flag, when set, would prevent BPF sk_lookup from happening. It also requires
> modifying every location making use of those functions.
> 
> - Solution B: We export a new symbol in inet_hashtables, a wrapper around
> static function inet_lhash2_lookup for inet4 and similar functions for inet6
> and udp4/6. Looking up specific IP/port and if not found looking up for
> INADDR_ANY could be done in the helper function in net/core/filters.c or in
> the BPF program.
> 
> Q2: Should we reuse the bpf_sk_lokup_tcp and bpf_sk_lookup_udp helper
> functions or create new ones?
If the args passing to the bpf_sk_lookup_(tcp|udp) is the same,
it makes sense to reuse the same BPF_FUNC_sk_lookup_*.
The actual helper implementation could be different though.
Look at bpf_xdp_sk_lookup_tcp_proto and bpf_sk_lookup_tcp_proto.

> 
> For solution A above, the helper functions can be reused almose identically,
> just adding a flag or boolean argument to tell if we are in a sk_lookup
> program or not. In solution B is preferred, them perhaps it would make sense
> to expose the new raw lookup function created, and the BPF program would be
> responsible for falling back to INADDR_ANY if the specific socket is not
> found. It adds more power to the BPF program in this case but requires to
> create a new helper function.
> 
> I was going with Solution A abd identical function names, but as I am
> touching the code it seems that maybe solution B with a new helper function
> could be better. I'm open to ideas.
> 
> Thank you.
> 
> PS: please include me in replies if you are responding only to the netdev
> mailing list as I'm not part of it. I'm subscribed to bpf.
> 
