Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FFC1C9CCF
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgEGUz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:55:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18170 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726367AbgEGUz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:55:57 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 047KtUkg008291;
        Thu, 7 May 2020 13:55:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=HvEWUMGdWMgjm9M550bzz+3nCQ/p76cit4yETho2uDk=;
 b=mP64enoxxZeLgggjSJ/HolTLpbPckoGQEJeQFdxrZaSDAS4Z2vy/7lN1vdlBS0sLEoAp
 aiFzWLizp/UFgTtlvDrc6j+grWgc9sE8sCvREm7uwtHYQFpEjawwESzOla1xnrjVzbrr
 0ZVrAqThno4cdvgZBxp/92dIjJwbiSVpV0U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30v07yque3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 May 2020 13:55:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 7 May 2020 13:55:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xiemyjjydf+1CzrKyCZeC/Wd/XaeMGvrHuf3pjdUTsoanZ9x6B7LLFDiYAvSqIgsohsTofmljK7Lu6PylKGpvy/ZMRXEGSAPDULrsghbLwlObU5C0UtpV5sUCQaGWogl3BJoQBF9o/HZKTHOwMW8l0Q5eDPJadPno7mlsuNDMppVEy4FVlyyb4F07FQdsNPkIROnkQwgR2IUk7XZlzZEX3wgmQgOzhuHKDFaBtP/ax9y9/a6dFQWwTet500k+f7qs9RQdhY43GxolGy0pRENv37mFDmzXVZM15qVZWrGbj5BH7e2cNZjMR3qOIsW0m7Nh773DKrUVfSWxZPHOzwpUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvEWUMGdWMgjm9M550bzz+3nCQ/p76cit4yETho2uDk=;
 b=d2VRR0/+OFnEUcyp4S6nrK6xBneEz/IRVdt6xb/YmNd+1pt6wNm46IbUF5a+hnv9NEk9Vz3LaOK1hoY5MlmTVWmUkYljQojMfu9FJ2mWlgTCbyIaRHyn/YeMQqFghdvQdt1g+54Iec9EQrf0JCNWuZ/8eugJmwqC2G7SjimK4PfZrAt8QrQUgPjrwtbndL8OhPUsN1ElP6oKjnLLwf4CexkJFYKR0IjvsiM6CyNxGRrQX++2WwKwOthmCLxZHGCzuoAFXsVFPwRL/6emOmfNwpcX3gKZDyJY81kyNRtRbXuNhL3IUwFyJe1oXF8sbFH3RE6bYKEscXPKYnbWvEcWEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvEWUMGdWMgjm9M550bzz+3nCQ/p76cit4yETho2uDk=;
 b=VpKwLUfI9im2/lktQgAeR4YUYScHqCgfqn8EyLr7J2VAgduyX2xecjvZw+X0zgz9wHCWrU2IH70uCGj4CTq9Ux9uWRI/F+Jk2MPpBwCo+Qqg+EkSd3PxNV7bj/hMqiwTCE4wdTizzMnAjEKYNMq1m2Q9ModGQHtIjKodWUWCcaE=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3850.namprd15.prod.outlook.com (2603:10b6:303:42::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Thu, 7 May
 2020 20:55:27 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.034; Thu, 7 May 2020
 20:55:27 +0000
Date:   Thu, 7 May 2020 13:55:24 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <dccp@vger.kernel.org>, kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: Introduce SK_LOOKUP program type
 with a dedicated attach point
Message-ID: <20200507205524.pv2pnujxdrbktdc4@kafai-mbp>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
 <20200506125514.1020829-3-jakub@cloudflare.com>
 <CACAyw9-ro_Dit=3M46=JSrkuc8y+UcsvJgVQuG98KdtmM9mCCA@mail.gmail.com>
 <87eerxuq3k.fsf@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eerxuq3k.fsf@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::19) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:fbdb) by BYAPR05CA0006.namprd05.prod.outlook.com (2603:10b6:a03:c0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.12 via Frontend Transport; Thu, 7 May 2020 20:55:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:fbdb]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e5498b6-cff3-4c52-9853-08d7f2c8f81c
X-MS-TrafficTypeDiagnostic: MW3PR15MB3850:
X-Microsoft-Antispam-PRVS: <MW3PR15MB3850834C91D9BE21BD827F8ED5A50@MW3PR15MB3850.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GG+20vtDmbEcJPEht+hVVXM8UsIcI5xwll4a2E1JguE4Oz0WpfyIGEWSbxQOxHGEYHj+Dzj1RF5U271hXpuvfkhcL+wjQlgipgLgSG/RIozXH6za01VZ8HY8S7TvvuJyFHWsrs4CEkS4YIaDTwVFzYfctcWTPIFKJ5W/+DetB2jr8XAGUrcdB/KyesoDSqKuEmNpVS4FJf7CgB4OHUOprhyPk6IOBaB0SeyGAMn1Q016sDk3/P7i4cuYyOk1p4HXeeV+RVUb7CXNyhs8T8BQKuVcPkvkIjoKiAiawnRvVf7PChCs/YsYi5S9g4vYzXth35cGrgTtCsZZJTnnPS7Me2AumKZ4PopZ5VQNjDFgPK7826mtvyoXp8uhD4YyylFdrg6pA2Yvnz+MdBr3NGQ4WdqPk2/ecjJOPc2IbiaPWQ32QtZ35fujHkTlG4m8Zfu0P9g7cRLvkhV+3aEjm53HqRmuPkj9FsQosHMfCt8+StME5d3JuxTWxcwdR/y+DkUdwdPt1nQPoghacrkwWdivvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(39860400002)(396003)(366004)(33430700001)(6916009)(66476007)(4326008)(8936002)(8676002)(86362001)(52116002)(66556008)(9686003)(33716001)(55016002)(83300400001)(6496006)(54906003)(83320400001)(83280400001)(83310400001)(83290400001)(66946007)(478600001)(1076003)(53546011)(7416002)(316002)(33440700001)(5660300002)(16526019)(186003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: TlZknqtfSRD83+lQ/qFUNYH+qHS4kwZ8ufzUUxNH6KEro/a4uOsS5hw+03hTY2iIjNNoaoZ57K2e4JklgiXZIH5YvTQdFDi7Ajysp6dKc2ydlrt6II6SXoHjwa0dDrCeyASeiMEsnmtLgZRyJqk6MZZms0jbU8N8csum9C3DJ1zwtuI/QIU0u5CYBSu6sTnOs8bq2OReULs+jgXqpEFvL3cgEsoR94x6FC172d/bkFcs/a7UA9f0Vc5OcCF80wu2o/nyM+mGdXIbVG6SOjyT97wxQ+9pJK3WvRKpuEAh63NfMWyJMdEN8+M1UaExb9SB3dzqjSx5bR5+92k/R071CT0mfwnrZdQdEid2Wsn0APBlrUpbZhdVFybniUkL+hbhbVjlM0Pc9gQ13Hk20B9wZxN08lC3FXYtjmGjXNi2fuEIvea2Indk9dnPQNrNMDOFS9XWgEORSCx+xnapFgrEAChF4ThxIhgAlfXZ2/OMhmojnoFUSUqdPXLSjJtrdSdj3LOoqXgSd9Px4V5O1xXKqdbBqXon7WfMkg1nImfo54y/sX3fDwlzPYF1NCULX6jmpqI1KC+0YMqr5ZqW8KnotjRn4s/9bnJjJq5PyfIFalHrwrriabu3WKSBYIYcF9eSPbIcje1n1M4nLxtSDPJOizAnhn6S84XA8G5aJPKLWVjTEZJwZAYhR2gjLGjHznRrBnCjg3VCu+iPHUMY3nXxaSdYggrnGJlsd7QjBxfx7kJz0a1VEByPquEt1nb+FwfTumRHQyhetj+begEBB4KAyDhJN7PQz5hQSNQKOdoTil2xcnop6Ph1nxy92d/+qYLbHdD4s7AbOWevPyTeWdaSWg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5498b6-cff3-4c52-9853-08d7f2c8f81c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 20:55:26.9225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ByNbTZaXAjR4k9KZDjLuyyOX8FJKnUt8g5NdUjIf0FTk+SnSPRE5UT0ctebh+Cjh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3850
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_14:2020-05-07,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxlogscore=978
 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0 adultscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 03:53:35PM +0200, Jakub Sitnicki wrote:
> On Wed, May 06, 2020 at 03:16 PM CEST, Lorenz Bauer wrote:
> > On Wed, 6 May 2020 at 13:55, Jakub Sitnicki <jakub@cloudflare.com> wrote:
> 
> [...]
> 
> >> @@ -4012,4 +4051,18 @@ struct bpf_pidns_info {
> >>         __u32 pid;
> >>         __u32 tgid;
> >>  };
> >> +
> >> +/* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
> >> +struct bpf_sk_lookup {
> >> +       __u32 family;           /* AF_INET, AF_INET6 */
> >> +       __u32 protocol;         /* IPPROTO_TCP, IPPROTO_UDP */
> >> +       /* IP addresses allows 1, 2, and 4 bytes access */
> >> +       __u32 src_ip4;
> >> +       __u32 src_ip6[4];
> >> +       __u32 src_port;         /* network byte order */
> >> +       __u32 dst_ip4;
> >> +       __u32 dst_ip6[4];
> >> +       __u32 dst_port;         /* host byte order */
> >
> > Jakub and I have discussed this off-list, but we couldn't come to an
> > agreement and decided to invite
> > your opinion.
> >
> > I think that dst_port should be in network byte order, since it's one
> > less exception to the
> > rule to think about when writing BPF programs.
> >
> > Jakub's argument is that this follows __sk_buff->local_port precedent,
> > which is also in host
> > byte order.
> 
> Yes, would be great to hear if there is a preference here.
> 
> Small correction, proposed sk_lookup program doesn't have access to
> __sk_buff, so perhaps that case matters less.
> 
> bpf_sk_lookup->dst_port, the packet destination port, is in host byte
> order so that it can be compared against bpf_sock->src_port, socket
> local port, without conversion.
> 
> But I also see how it can be a surprise for a BPF user that one field has
> a different byte order.
I would also prefer port and addr were all in the same byte order.
However, it is not the cases for the other prog_type ctx.
People has stomped on it from time to time.  May be something
can be done at the libbpf to hide this difference.

I think uapi consistency with other existing ctx is more important here.
(i.e. keep the "local" port in host order).  Otherwise, the user will
be slapped left and right when writting bpf_prog in different prog_type.

Armed with the knowledge on skc_num, the "local" port is
in host byte order in the current existing prog ctx.  It is
unfortunate that the "dst"_port in this patch is the "local" port.
The "local" port in "struct bpf_sock" is actually the "src"_port. :/
Would "local"/"remote" be clearer than "src"/dst" in this patch?
