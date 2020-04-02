Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C3819CC58
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 23:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388902AbgDBVZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 17:25:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731892AbgDBVZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 17:25:04 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 032LG6BU000798;
        Thu, 2 Apr 2020 14:24:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=JPjT8tgHMpyQkWqtoHN4CBy8U5z9wQP4R5WsABc5HEY=;
 b=V7HHyl5tIELixR4yLyaY6ee/x8QTH+Lw5T0JfrnsmpSgHt0mLufwuOOKZ+RuV9PdMAeu
 NVDFBSZDoHGnjshtJriienCmKH/EMQ+Nol7+njjwR8PX3evmbcTrbBuMwU2qPQubLGu4
 DlhyqPIGN6LQwCvhcdFu5ViVAtzk8kL4TjQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 305jfrt014-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 Apr 2020 14:24:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 2 Apr 2020 14:24:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkZPfZAEjeRogXWW/w3Mv8VP+RxrzT7qScsEPIAIbS0Xi3lUZo2q2ibVU+sOvFtENNyNBYm7GzDcptjdrUIWnLVexp4XEy0ggnndDWclqyDeNYfBa/kuxaalhV7kCgxAs1LhpbqmKYRZFOhXOMPnSM/7W6RDkavJMIqwTo2RoGa0JqMUtmyirAxvq6Jq9pYb11yO+tL0S0kb9fTUpOKV1qC434EqB5vARrdTXBUXzduOBIxlerqX5CzcGYKOcqTiKn/dO33yLtgn/W3Jzkg42uUNlpi+1XdUeVe9t3MDeegQ+Pu4VKWG/SfSViOx5A6pR0uBTeJUrdeFg+Q+AZej7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPjT8tgHMpyQkWqtoHN4CBy8U5z9wQP4R5WsABc5HEY=;
 b=W+VIcmnS8YS1ygllnSDrohW/P+EfXomYsRmswgH+JrSFZf3a9mQ7U3EChDT5JmNTn9tJ1XMzzLKh34E5undX3vnvcO8KA7pSRq31a6Y7INV3915UFHIKAK62wOekMtcVrdkWXSuLE+eRisAphd3LFeLcv5MlawWsCQmnlUu9wtQkj7lc6vqAkD2U/Jsofn0TBvFh457xT/WOG65zC11fGyfElzml2GaO20doqc/26u+kdaYWZqWffhoqCweM7ybUjhdlFT+tr7zh6JTRbwT4BNN/cZ3uDgITwEPhXZtnvxCSsebJ9UkBqaOQEVgdcOrmMwzoLr1j2Pz2OPldlsEOrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPjT8tgHMpyQkWqtoHN4CBy8U5z9wQP4R5WsABc5HEY=;
 b=BTE4Nu+IkPLHX2TshB28CEOtZAJFMX0DYkL1rf1+KVcpoDr1Thg6ehtCKRHjdnKN1onVV7pwuOthbRyNCp/kUPqFkvVvg5/6qJ+QBb1GDTf3EJWXTV8KOtMDzlINWmGfQIp/W+RYVMB+t+suiexlYuviIIFvjsE0jrPToHWaphQ=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2630.namprd15.prod.outlook.com (2603:10b6:a03:14c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Thu, 2 Apr
 2020 21:24:36 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 21:24:36 +0000
Date:   Thu, 2 Apr 2020 14:24:33 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
Message-ID: <20200402212433.GA12405@rdna-mbp.dhcp.thefacebook.com>
References: <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
 <20200326195340.dznktutm6yq763af@ast-mbp>
 <87o8sim4rw.fsf@toke.dk>
 <20200402202156.hq7wpz5vdoajpqp5@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200402202156.hq7wpz5vdoajpqp5@ast-mbp>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: CO1PR15CA0090.namprd15.prod.outlook.com
 (2603:10b6:101:20::34) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:5b0c) by CO1PR15CA0090.namprd15.prod.outlook.com (2603:10b6:101:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Thu, 2 Apr 2020 21:24:35 +0000
X-Originating-IP: [2620:10d:c090:400::5:5b0c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de8e1d43-c07a-45d4-a563-08d7d74c3e2a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2630:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2630AC1A280BF655BAE89EC0A8C60@BYAPR15MB2630.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0361212EA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(39860400002)(346002)(376002)(136003)(366004)(81166006)(16526019)(186003)(86362001)(66574012)(8936002)(54906003)(81156014)(66556008)(316002)(6486002)(478600001)(4326008)(52116002)(8676002)(66476007)(2906002)(6496006)(66946007)(33656002)(9686003)(5660300002)(1076003)(6916009);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QA09CfgAPesm2dMtTmntfjvjL5P98Am25V56Kt2JWXkk4tZwaaU85wTbr+RCAsA+6YOV9XwRbgr4x5jcT+ZYgQpt792vVZx0PyGK5gHxp1S7iPb/br7PIIaUTYvow2ka5vtwaC6pJVLg4AFX+saL+1wtbGn/8XjtrcWknsxJhg5CJWWkKRSk+O59TotPNIUIHc8ALoUfYZMCMxdE2jLD4jqDIsI/7/wKhgIj1b1yciNuWIlUo+Awbdp2+8xlUdNqv5h8FTjDVPbuZeygDelbG5Cz93m83GHzp/qTvORvascwNkVKE5auWaU6GBUOrYCkhSrjJEE6v33NOEkslmFppkGDU/ja/up9LoOZZkt5fI53oAKyjPMCvxLxtYowOVQz4epW3kZIy3Uyq1e3k/7iwXaIVw8Ft7lTLJqUZA/6nzqN2tryVtgXSem+6BS69jo8
X-MS-Exchange-AntiSpam-MessageData: janJ5X2MD3iqSOy7bF7FHxGy468dLuCOtJWWweoHq5YWpe+dSZsopIvIbD7dJeT2WEQCo4LoqMwCZLxKaNd7V4piUwfcPBhOFDPeRAGoMpzgWbWbjiBq7Uwl+4+6IoGPYnKP91a7uLnwYRggrdGjyuxUah6nZ4wFz4mfJgecfc390NaqqB82aDqDQa5a2YqS
X-MS-Exchange-CrossTenant-Network-Message-Id: de8e1d43-c07a-45d4-a563-08d7d74c3e2a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 21:24:35.9101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VekpOasK8+2gd8ZuUP+NO133EtKrmbt0dsQklBlsovyOlyTyIrVklLZWn0EdazNJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2630
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_11:2020-04-02,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004020157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> [Thu, 2020-04-02 13:22 -0700]:
> On Fri, Mar 27, 2020 at 12:11:15PM +0100, Toke Høiland-Jørgensen wrote:
> > 
> > Current code is in [0], for those following along. There are two bits of
> > kernel support missing before I can get it to where I want it for an
> > initial "release": Atomic replace of the dispatcher (this series), and
> > the ability to attach an freplace program to more than one "parent".
> > I'll try to get an RFC out for the latter during the merge window, but
> > I'll probably need some help in figuring out how to make it safe from
> > the verifier PoV.
> 
> I have some thoughts on the second part "ability to attach an freplace
> to more than one 'parent'".
> I think the solution should be more generic than just freplace.
> fentry/fexit need to have the same feature.
> Few folks already said that they want to attach fentry to multiple
> kernel functions. It's similar to what people do with kprobe progs now.
> (attach to multiple and differentiate attach point based on parent IP)
> Similarly "bpftool profile" needs it to avoid creating new pair of fentry/fexit
> progs for every target bpf prog it's collecting stats about.
> I didn't add this ability to fentry/fexit/freplace only to simplify
> initial implementation ;) I think the time had come.
> Currently fentry/fexit/freplace progs have single prog->aux->linked_prog pointer.
> It just needs to become a linked list.
> The api extension could be like this:
> bpf_raw_tp_open(prog_fd, attach_prog_fd, attach_btf_id);
> (currently it's just bpf_raw_tp_open(prog_fd))
> The same pair of (attach_prog_fd, attach_btf_id) is already passed into prog_load
> to hold the linked_prog and its corresponding btf_id.
> I'm proposing to extend raw_tp_open with this pair as well to
> attach existing fentry/fexit/freplace prog to another target.
> Internally the kernel verify that btf of current linked_prog
> exactly matches to btf of another requested linked_prog and
> if they match it will attach the same prog to two target programs (in case of freplace)
> or two kernel functions (in case of fentry/fexit).
> 
> Toke, Andrey,
> if above kinda makes sense from high level description
> I can prototype it quickly and then we can discuss details
> in the patches ?
> Or we can drill further into details and discuss corner cases.

That makes sense to me.

I've also been thinking of a way to "transition" ext prog from one
target program to another, but I had an impression that limiting number
of target progs to one for an ext prog is "by design" and hard to
change, and was looking at introducing a way to duplicate existing ext
prog by its fd but with different attach_prog_fd and attach_btf_id (smth
like BPF_PROG_DUP command) instead.

But since you're saying that there are actually many use-cases to be
able to attach freplace/fexit/fentry to multiple target programs, that
works as well. Happy to look at the prototype when it's available.

Thanks.


-- 
Andrey Ignatov
