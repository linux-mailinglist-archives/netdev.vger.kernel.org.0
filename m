Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A7F2E7E7D
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 07:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgLaGvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 01:51:48 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37826 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726037AbgLaGvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 01:51:48 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BV6XrpA003262;
        Wed, 30 Dec 2020 22:50:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=wzcYJYCjSqJ5c/NvdCwz1lrGB66U2mJZrRdOCUf1Q1g=;
 b=T9l18oToOPsdmO1I/4Z6RuuevEhkrCtZUYkEv5gptV0E1EQjYIH8pWKlWTR5qc+e1niY
 WziM2UaQ8hu4cOkZVq+06K7w+559AXQRvnQgie89Utpl6PrzQNHU+85G4ZHZ0fA7ow1P
 YYBG45XDT5d9gfFVYNPXaKQrWIP36OpLxT0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 35p1qts2vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Dec 2020 22:50:53 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Dec 2020 22:50:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezsma3ZTBYYJKcEQno5JatZtqnTnAw2F2tYVai0FmKNH734tbzyHAeCKeYhCv9xTvF7bcfc/WoYqvpVrbzEi9Sa4uZCBt2QdMk8/SdXj71r1BluLbR27SVv7PKdsLsMHQe6hlWGQSXTLvTrvMxfMAjdXssZRs3jLhYNrL9wM2+Z2G6CnnwPsNE84zB8PIZNDQNlbuCQZThChAs2ae+ylNCZpSxdtFqgkPqaAH8XBLODMdJMfB1pLq07Tsu6qpytb+hk7uJ17nLmphUMzD/TBOOQ1WW+BT8gntE7EaV+/J7/s18AYOGpnUvBaG9plImOc47h641rUQa/fab/h15yyXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzcYJYCjSqJ5c/NvdCwz1lrGB66U2mJZrRdOCUf1Q1g=;
 b=F+gGyUZ28DV6FKP9JdtwzlYXGGcef99Kflalj04lGsRTukZz+CgWvDzrQ9+RdBTB8JhiOju/cMb+p5WyjDZ+BtBNZQu+q8BEkzDGnJ0BGKp79pKE05DVGHYeGM6L5y8IRXQ5tLdFA+j+ALyaI6Krqi+tWu/nCQNYf+3evTuVDlDWQRhdMR8DQKFFBDlqNzo0xzUg4wtQsVCfGphIQ15YEtYMSU8t2bJnHpMoDGXOFKq5in9ExifvIFpGopIpc8QisRHYm5rPAsBSfv8QUcpQ9V2k6ZWXfy9SCBL+oLJCoZ/7sqzN1UlnjdZaAWZeTRXpV6s4MqG05jKI3wlcK+xX1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzcYJYCjSqJ5c/NvdCwz1lrGB66U2mJZrRdOCUf1Q1g=;
 b=LjPbdWJD88/VNQ8ZzsGNRk8rsO0eIklj1wpUIqcb+L0TXxwR7WZEblzNy3SuipyDoa68VZ39JpFVFPVd8P2Wo7bxn2COTCj8xGAxwxBVTIEorIlyznRwYncrntNZvH1jWBE8QiFtr7gd9MEZ1hlTXELqMupQnEkiGoZx6r1WaQc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2488.namprd15.prod.outlook.com (2603:10b6:a02:90::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27; Thu, 31 Dec
 2020 06:50:50 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.021; Thu, 31 Dec 2020
 06:50:50 +0000
Date:   Wed, 30 Dec 2020 22:50:44 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in
 cgroup/{s,g}etsockopt
Message-ID: <20201231065038.k637ewwyqclq2nxh@kafai-mbp.dhcp.thefacebook.com>
References: <20201217172324.2121488-1-sdf@google.com>
 <20201217172324.2121488-2-sdf@google.com>
 <20201222191107.bbg6yafayxp4jx5i@kafai-mbp.dhcp.thefacebook.com>
 <X+K07Rh+2qECwxJp@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+K07Rh+2qECwxJp@google.com>
X-Originating-IP: [2620:10d:c090:400::5:d5ef]
X-ClientProxiedBy: CO2PR04CA0179.namprd04.prod.outlook.com
 (2603:10b6:104:4::33) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d5ef) by CO2PR04CA0179.namprd04.prod.outlook.com (2603:10b6:104:4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20 via Frontend Transport; Thu, 31 Dec 2020 06:50:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c54ab3a-77b6-42be-887c-08d8ad586924
X-MS-TrafficTypeDiagnostic: BYAPR15MB2488:
X-Microsoft-Antispam-PRVS: <BYAPR15MB24887AE4559B0384F39D3A57D5D60@BYAPR15MB2488.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVrFc/mc2lLRFKFi88HT6dgMe8Dm46Xpq6Vj8E/cSt+pyGx+byTbG/woAfnQXXnewRfUq3Wkmjy4lzKsv43O0FBeY9Xr3NHWAcGBYbxGq4uOLRVsjYUFL5bokeA1zhF/vl9V7BnJowanQ6y1pis6K6xazllpv6tZ6q/WSPQFXXrutMfjVrD+N0xs2RB/HjpTnI3rp2aqbWkfnmY549STYJgLkgk4z37n2+YvK8cCd2E0/G6RZAoNbunQO4x0pLQtuEW7zti5nU4Mf1/M5Yb1pcmL7wekjj4yFJJA4lKSVwVSKGsWSZN7l6WyaIkDPdpJogtdz9BnY7VMM4Md1NZ5YrKEUErnE8IvaNREqS9+65dY64QqN2IRBvhEbVfh9q+wd2iP7fXTnmkL00V1I4d+Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(346002)(39860400002)(86362001)(66476007)(2906002)(4326008)(8676002)(66946007)(55016002)(8936002)(6916009)(5660300002)(1076003)(316002)(6506007)(6666004)(7696005)(478600001)(9686003)(83380400001)(66556008)(52116002)(16526019)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3qJ23X4q7MHds6/h25qeeYsM+by6mJxbMf7vSfmSb/ELaeif8RLt88LWmK1J?=
 =?us-ascii?Q?IqsZCFZjJ3dzEdLquy4m4ZTv70C6dGyBgCZ29pzV6QNNZr5NT788/ecfDRC8?=
 =?us-ascii?Q?etwhpBGLTgYNe7eyS2E8jw4xbgSMXN/khTVoE//6zBqM/WzOcMJU/hQnDlay?=
 =?us-ascii?Q?T2ZtNKMgoyZVktaaYnERyNJAu26P4CccYIjjwRRTRgkVofQYbLEirGuHk2jF?=
 =?us-ascii?Q?8qgnqleVp2KYusOAjvoLeEzDrCL3hTfLxXW741O+mDiH3BOAMWjZ4w5J+I2D?=
 =?us-ascii?Q?tElw+CDDYqjigcGBsRPnymev680EUIMQI6dIPONnURlgGtlgFcgntELoOMaN?=
 =?us-ascii?Q?pS0CXr5nRfDcP1VQMKunp/IuT0cYxTUhH7XM7Bx1xBph7v3ZNL1VCqpM4+0/?=
 =?us-ascii?Q?K3M93O10bZ1IzJFeDMQMMN2LunFvMRXv1fDMj7dDpvAifnKIpesSRtoxu5m8?=
 =?us-ascii?Q?8Tc/3PKUzvam7DndbtgsPS7IuazHHZhHFzf0echTW+m4tUtv48xLgJx8WEkV?=
 =?us-ascii?Q?+UOIH9mG8wTpEt6QB5DmvVHFE2G2xkOGttf0DBaLZTvG0HzlQLjcv/IwmTY8?=
 =?us-ascii?Q?d9ZeRGd9EmCzEx2EP3IA35bBlWTATc59+JjqGHmWZ+TITL3n0Uh30h6i94hp?=
 =?us-ascii?Q?9FcSaFmPfIWcpU41xBda62IOvKbzRo3kL/MRq0JkResTDQVGrMuVALDO3PEB?=
 =?us-ascii?Q?UdxLA+wS19v57hco9p7fG4KJdGbja50xbOm027toPZsm/oM6L/C7yvKEXJqR?=
 =?us-ascii?Q?ykyy5NLSKgRq/2kkQKOeZUTpbD9bIAb2y1mhe3XrkjYFq86VjJ2Wnw1zCIYN?=
 =?us-ascii?Q?9WcmOeDlyommwRyd64kMnU67Ez5W2CYoDAgzY5bOU8tRiKysjYuwfXXrQSA8?=
 =?us-ascii?Q?ikDgwCSe435Hh+9yDYZK5GNTGhlkDw4YyM+z162Sw38b956jkI4Nc4Cc7X+l?=
 =?us-ascii?Q?jLQBtTzVBVm7qOJ1VeKVGtig6lfDB8X+Q9/CcYqqbktbvCtg3qcvAlgREXSM?=
 =?us-ascii?Q?AwpNbIAmK3gpT9mwUkwEBg6CaQ=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2020 06:50:50.4485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c54ab3a-77b6-42be-887c-08d8ad586924
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XXP4JgcmB7K/Gjo42LzofxNQAYimVaoGd8BL3q/XhHhFmkSF8DIMQeNN8Bmqej6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2488
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-31_02:2020-12-30,2020-12-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310036
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 07:09:33PM -0800, sdf@google.com wrote:
> On 12/22, Martin KaFai Lau wrote:
> > On Thu, Dec 17, 2020 at 09:23:23AM -0800, Stanislav Fomichev wrote:
> > > When we attach a bpf program to cgroup/getsockopt any other getsockopt()
> > > syscall starts incurring kzalloc/kfree cost. While, in general, it's
> > > not an issue, sometimes it is, like in the case of TCP_ZEROCOPY_RECEIVE.
> > > TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> > > fastpath for incoming TCP, we don't want to have extra allocations in
> > > there.
> > >
> > > Let add a small buffer on the stack and use it for small (majority)
> > > {s,g}etsockopt values. I've started with 128 bytes to cover
> > > the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> > > currently, with some planned extension to 64 + some headroom
> > > for the future).
> > >
> > > It seems natural to do the same for setsockopt, but it's a bit more
> > > involved when the BPF program modifies the data (where we have to
> > > kmalloc). The assumption is that for the majority of setsockopt
> > > calls (which are doing pure BPF options or apply policy) this
> > > will bring some benefit as well.
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/linux/filter.h |  3 +++
> > >  kernel/bpf/cgroup.c    | 41 +++++++++++++++++++++++++++++++++++++++--
> > >  2 files changed, 42 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > > index 29c27656165b..362eb0d7af5d 100644
> > > --- a/include/linux/filter.h
> > > +++ b/include/linux/filter.h
> > > @@ -1281,6 +1281,8 @@ struct bpf_sysctl_kern {
> > >  	u64 tmp_reg;
> > >  };
> > >
> > > +#define BPF_SOCKOPT_KERN_BUF_SIZE	128
> > Since these 128 bytes (which then needs to be zero-ed) is modeled after
> > the TCP_ZEROCOPY_RECEIVE use case, it will be useful to explain
> > a use case on how the bpf prog will interact with
> > getsockopt(TCP_ZEROCOPY_RECEIVE).
> The only thing I would expect BPF program can do is to return EPERM
> to cause application to fallback to non-zerocopy path (and, mostly,
> bypass). I don't think BPF can meaningfully mangle the data in struct
> tcp_zerocopy_receive.
> 
> Does it address your concern? Or do you want me to add a comment or
> something?
I was asking because, while 128 byte may work best for TCP_ZEROCOPY_RECEIVCE,
it is many unnecessary byte-zeroings for most options though.
Hence, I am interested to see if there is a practical bpf
use case for TCP_ZEROCOPY_RECEIVE.
