Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C9F1C0E77
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 09:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgEAHJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 03:09:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25920 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbgEAHJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 03:09:15 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04178tES001711;
        Fri, 1 May 2020 00:09:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=SESw9s1qdE6CejpZBB/cBXjDFV5jIHOv/JcqbQznXZU=;
 b=d2/zMsXTwdraktVMlp3YDXZj+LQjXGgRXidwxPFJmyP+IqNlUL/Txd/A+NQiaV5fU6nR
 u4Qd9+qHXzKK4GFBjpW8YvmEfbHwtGm27k1KOSd37QBPFy84bNECvMU3/QTQlQSS+gMH
 Pf/XJE8AK6KlRvUM9q9gfrJnhCp3+/Klu3I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30r7crt2bd-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 01 May 2020 00:08:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 1 May 2020 00:08:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huJ7ebOeqsW65N3M7z5UcVpn/vCvxi7ihYIjhYJVB50pziEotV0Zd736MaNyRMYxGzBRft17sjZv2uhM9PApvKlvDlWS4g/IscdYl+XLsWc8jkM0NOAdvPjqXEvZPQx8Lon2Y1Qg6PMmZjeDI/44z9cNq7M2V1gc3phcnwW3N4BlIp0UaQLwVCHy4lrAjvOGC14zXVZOWE+VTtIi31QrlAaBkl3JipR33srNt1ThFTh89/zLnmaoI6PbGnkVnncXEAU7qatq9Sod7NRBELzIl4PeC0t2pMJ/cNJtne3Sg+o6KWbjvi4vti59v06bbaNgB6KZ1Tt3pyIsv5QMZ7b2Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SESw9s1qdE6CejpZBB/cBXjDFV5jIHOv/JcqbQznXZU=;
 b=Kp+pmQnC3yOJEixrzf28JUIN60GmAbRvou2XX6pp+75dkgg7fQgo/9iTetYsn7JFlu7moe8FiW1bXRIw24YZiSraEiT89Me0x+cIqA/PEHiFUeJ6ePEBcuwd5zMAo8RcbFPOHoZqvMry8NdO+O9a2+ZhEryiff8Hhe91VijbqJzHn+rGxxC3Pyq6UaJnTwjWTuVd020vHYcQkYRrs/tZ5lhKRPycqkeoSkUg7j/hMwfikI4UJtWUmuAAkcgJ4woFzXyrY06RROYeNPtyE6SKL8Lr72Xl8G8EBZBITrhe6XMJyPl/0c4dyD/LlOx9j+7+ohYxbkmCka2nV65VP/zdnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SESw9s1qdE6CejpZBB/cBXjDFV5jIHOv/JcqbQznXZU=;
 b=QTS5xgjBUSHJHOhtFrLJmXCiBsfr39dJetvmzsxPwF3lk1h5HivBCJaKlynLgvlcQnsAqq1sPECvMYde9WPtjh/dk2udoae0l3XXs343KsS0FDfzgJ0DJIS/6NmYlKc/wQhvK1SnQJxnyaWwLL5piWKVQrg8SE3igVZPeklI6+c=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3995.namprd15.prod.outlook.com (2603:10b6:303:40::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Fri, 1 May
 2020 07:08:48 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.020; Fri, 1 May 2020
 07:08:48 +0000
Date:   Fri, 1 May 2020 00:08:46 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        syzbot <syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] bpf: fix use-after-free of
 bpf_link when priming half-fails
Message-ID: <20200501070846.7tmhev6uhdjn4wyz@kafai-mbp>
References: <20200430194609.1216836-1-andriin@fb.com>
 <20200501062521.2xruidyrtuxycipw@kafai-mbp>
 <CAEf4Bza166F5M4Qie5t+tkM+vYgYxqgeStpOWovc_WU_MiSURQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza166F5M4Qie5t+tkM+vYgYxqgeStpOWovc_WU_MiSURQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR1401CA0005.namprd14.prod.outlook.com
 (2603:10b6:301:4b::15) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:da9a) by MWHPR1401CA0005.namprd14.prod.outlook.com (2603:10b6:301:4b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Fri, 1 May 2020 07:08:47 +0000
X-Originating-IP: [2620:10d:c090:400::5:da9a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a6026db-f236-434b-bfdb-08d7ed9e7e91
X-MS-TrafficTypeDiagnostic: MW3PR15MB3995:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB399513036EAFB28E865B6686D5AB0@MW3PR15MB3995.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +UXnIxdLXDNTwvjVqXXU4s5Wf5RwlxCplIBKihftl/i4ZKe1UJP1XkSbz8mPhooDnkCTdr7v6/3IUq137xVhPr2Q1YMYYy+u3lPxU088AmgNTXiGhYM83xe89sndRZgHYGy3GzsszMbhuW2M3hSEdoftNBqf7k5WkWWHP5fhpMynLeT+nC7Z1Q2GoFsdvES24OBlZmbPmOJKxjB/cRNH6wgSW8bM9iogVYwhOhaA2iluK7xiTiwvR4zp/B2Kqx7D2DO25WK0SlZLc6Ei8k3zcJDGUu0uLBaaO4cQBWjBrrXA4oxma9E1vBWFNXh7+M3mqlBmVZb5V8SuAoltJM8ggjY2NzRSP5edRAwefIELeBKZYaK25Sd/x/slWE3TXdt9biTxXhbrMRZC3rxJrTKVDq8Z3yh6mD/6mP3yPq6PWx/0eq8UPnxYfYGKc/fUMAi3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(366004)(346002)(376002)(136003)(4326008)(8936002)(8676002)(2906002)(66946007)(55016002)(66556008)(66476007)(9686003)(86362001)(33716001)(6496006)(478600001)(1076003)(54906003)(5660300002)(52116002)(16526019)(316002)(186003)(53546011)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rXcZAsHyEVBjzIs7Ykyo79DcYkHlpqKuc7/eBkn2miRUlda0JGWsc8e+rXG2BO+28CVx7QFztHpdVFrrwx/K7Gl2HoSbOwYRPCx26ZFE1pcwb6UYLmt2C0lCEnChuZJnQwtBd0DkG0Fk6n7QWe6HQSYKlgPr3of2oW4ozU0sklP5nbwYFRlj/YysHVKMcVZswbapIYqgVP9yYJy7PlzzFdktITIStOWLNh8YaBz4lQ6wMFnrQK16Clx7E7TF9dj3Ex8inPEnu03Iqk6G4/a1360TIsW4gUU4l+vl7U27lS1qB9/XsG/yEAGAIfYUiI43NagDCeHVrG2DrRC0faAgF1ZtQZDIguuoy6MA1c4ms5lyviZu0ceNXBuFg1GB+bEM1CEAt8enz0MHLmpaszgjBWfichN0gL0m5IRowiR8tTPy+w3/878N5jwB5bxptmIbEZsGujIKjnE9OA1JMrQp7P6X6BKbRINhJv/GCOjUudqc+khIM9kWGEKZgMG1AftiIqrwhMPuP0YtfSRN6l3KGXQFMqOquLX/bSlbpPJV+Pbn38WLgHzvErsR/NncnwXsXTUQMgdtXJ9alBnvR+2HJNDWLEpeyIsQ+g1lmjT5dy/0FMteVjDASa8Ir0XLMPBgMOMMNBvQTEAiApLYeClcAdRNwFfM0Ljh6fXO8g3T4IWPH88to1IRDxcL/6x47UadK8qQj7yoJrU/3UQV5BobgvJBvKans0mfoSrmjF2xMlpPClNywbuhyO8DHm62m0d5SDNEBGyQ3DxgkTQRZX7OOgg1z9Q1OIhBMPyUJ72QtnX7pmNFs1fRdsetXBfFasJ2LTuam1cuwrwK4AEv5vAvMA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a6026db-f236-434b-bfdb-08d7ed9e7e91
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 07:08:48.2899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pm86zOxZOQFknr2v++diI4AfCfDmNjO2fkctf9tBDPSfQyz3jVdUK9Cl7AKCjido
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3995
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_02:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=903 phishscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=2
 mlxscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005010053
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:32:59PM -0700, Andrii Nakryiko wrote:
> On Thu, Apr 30, 2020 at 11:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Apr 30, 2020 at 12:46:08PM -0700, Andrii Nakryiko wrote:
> > > If bpf_link_prime() succeeds to allocate new anon file, but then fails to
> > > allocate ID for it, link priming is considered to be failed and user is
> > > supposed ot be able to directly kfree() bpf_link, because it was never exposed
> > > to user-space.
> > >
> > > But at that point file already keeps a pointer to bpf_link and will eventually
> > > call bpf_link_release(), so if bpf_link was kfree()'d by caller, that would
> > > lead to use-after-free.
> > >
> > > Fix this by creating file with NULL private_data until ID allocation succeeds.
> > > Only then set private_data to bpf_link. Teach bpf_link_release() to recognize
> > > such situation and do nothing.
> > >
> > > Fixes: a3b80e107894 ("bpf: Allocate ID for bpf_link")
> > > Reported-by: syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  kernel/bpf/syscall.c | 16 +++++++++++++---
> > >  1 file changed, 13 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index c75b2dd2459c..ce00df64a4d4 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -2267,7 +2267,12 @@ static int bpf_link_release(struct inode *inode, struct file *filp)
> > >  {
> > >       struct bpf_link *link = filp->private_data;
> > >
> > > -     bpf_link_put(link);
> > > +     /* if bpf_link_prime() allocated file, but failed to allocate ID,
> > > +      * file->private_data will be null and by now link itself is kfree()'d
> > > +      * directly, so just do nothing in such case.
> > > +      */
> > > +     if (link)
> > > +             bpf_link_put(link);
> > >       return 0;
> > >  }
> > >
> > > @@ -2348,7 +2353,7 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer)
> > >       if (fd < 0)
> > >               return fd;
> > >
> > > -     file = anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC);
> > > +     file = anon_inode_getfile("bpf_link", &bpf_link_fops, NULL, O_CLOEXEC);
> > >       if (IS_ERR(file)) {
> > >               put_unused_fd(fd);
> > >               return PTR_ERR(file);
> > > @@ -2357,10 +2362,15 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer)
> > >       id = bpf_link_alloc_id(link);
> > >       if (id < 0) {
> > >               put_unused_fd(fd);
> > > -             fput(file);
> > > +             fput(file); /* won't put link, so user can kfree() it */
> > >               return id;
> > >       }
> > >
> > > +     /* Link priming succeeded, point file's private data to link now.
> > > +      * After this caller has to call bpf_link_cleanup() to free link.
> > > +      */
> > > +     file->private_data = link;
> > Instead of switching private_data back and forth, how about calling getfile() at end
> > (i.e. after alloc_id())?
> >
> 
> Because once ID is allocated, user-space might have bumped bpf_link
> refcnt already, so we can't just kfree() it after that.
link->id is not	set, so	refcnt should not be bumped.

Calling	bpf_link_free_id(id) at the getfile() error path should be enough?

> 
> > > +
> > >       primer->link = link;
> > >       primer->file = file;
> > >       primer->fd = fd;
> > > --
> > > 2.24.1
> > >
