Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA552C91F1
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388568AbgK3XDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:03:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55162 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbgK3XDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:03:48 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMtapF009400;
        Mon, 30 Nov 2020 15:02:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gxJUrmeycPlhy9dFvy7OVlLgj8Ti7fFg4eVf19hPzww=;
 b=JoSs8JTK8+SpUycaXNXXlh6CDTdPeNBGc+GIqWriq5dNpvp2e3XdMsdzBpneakW5XWdB
 lbKNgdKZ0/Po/p86+BLPqIFsCNHIn23JAuBdi7iN9YWaXfeX6abB9lO1dMyQq2nzwuK+
 d4/qsxZFHoI5O4J9i0ML26Attzgc96rYgJg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 354c7qf70n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Nov 2020 15:02:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 15:02:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFxzwZIIfbOgIi5j+chau2RUfFC6Fy+RfO/GSEtknMo8MdKD76qM3dilYwBFVgJnIzyqolwsxx+YKCrr7B9NpYYaXkJIBDM/0msoreYcP+mM/WSakDXj/O6GgvuKfbhR1pyVH14G5/BPVefotZWllPQ4S8cNwxVIA27VoQzRpGO0VK3OdTSRmvYYi7TOTjGkDOWffDfZBW/KXwgnstp4xAazIb/fiFLC9jyImJE2+PJisdPmFmdSqoQ5YC6i6cKuiV25wJm1k02WQeB3tn/FKlkEf2SREa9YgTy8CIhpuEMZE3Y24rg8WAeApsURDuAEsp4NaRrWPfzQH7GcaxMs5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxJUrmeycPlhy9dFvy7OVlLgj8Ti7fFg4eVf19hPzww=;
 b=lFfpHN9eDTNdGIOjYfoFUmiB7rgd89uE1qtoFp80lUe3KDRikuWUeHWQ8OWCzXnJ1xWRJnOEU68B93AEV6QyGfWmAiKaEIltghFXRZ1x6YCAifXcg6eU/6Q3Rch+VCqgZqfhGQAlna975mE3U1wJ/y9Z7GaE/LK8RzPyx76wpjjJjveNOZOFIYaAbuSFKJMq0H3dvy3xolnfAaW+SzOURLrguNUshamJ4+O3xnSXMHkV5DfJkY0Em7GLjMtKi+9ioQuCNJBC+dALPGToWFuRUWB2gNSAzhH8tQ0oVhIqrO+hd4ZMIFzgs+kQjbSNybqueQI6TWerWykvzHDnS8k8FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxJUrmeycPlhy9dFvy7OVlLgj8Ti7fFg4eVf19hPzww=;
 b=ho+8dxf/5tHqG8iDzBb8BjczH+my6xX/aL6eW61FOO/YU81CI2hvAr769I+pDIVIZPb5quNwCjpAqBTdgDzGk3PB9mKPdJaz/NsSFsdaqrYto2hjFRklVm6YIdFE3ekWnrAT0eQlXVF+xDJnbmIEehx7Jlj7Wel5cV5MFVDU598=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB4118.namprd15.prod.outlook.com (2603:10b6:a02:bf::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Mon, 30 Nov
 2020 23:02:45 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee%7]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 23:02:45 +0000
Date:   Mon, 30 Nov 2020 15:02:42 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     <sdf@google.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/3] bpf: allow bpf_{s,g}etsockopt from cgroup
 bind{4,6} hooks
Message-ID: <20201130230242.GA73546@rdna-mbp>
References: <20201118001742.85005-1-sdf@google.com>
 <20201118001742.85005-3-sdf@google.com>
 <CAADnVQLxt11Zx8553fegoSWCtt0SQ_6uYViMtuhGxA7sv1YSxA@mail.gmail.com>
 <20201130010559.GA1991@rdna-mbp>
 <20201130163813.GA553169@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201130163813.GA553169@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Originating-IP: [2620:10d:c090:400::5:c131]
X-ClientProxiedBy: CO2PR05CA0095.namprd05.prod.outlook.com
 (2603:10b6:104:1::21) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:c131) by CO2PR05CA0095.namprd05.prod.outlook.com (2603:10b6:104:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.9 via Frontend Transport; Mon, 30 Nov 2020 23:02:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c12398db-02d1-4d97-9356-08d895840cc8
X-MS-TrafficTypeDiagnostic: BYAPR15MB4118:
X-Microsoft-Antispam-PRVS: <BYAPR15MB4118272A79A5EF8C5701974AA8F50@BYAPR15MB4118.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNTX6otOrZ9bDrD0+bmokcojI60lbNCPjGs71jRC+/PsqK6V7tRE8YX2t8LczQbrsB8PD8PDVg5ZXEskimaa3jdPIYMQgU6mJPppnWWToXBLSC/xsmv3j5hlxh+R/To7bJNnSl2H4cEZu2cjfHi+O2OQtWkmXN1Ne+69gIW6fZbC58DBc8lIUVSUbCVflJnP2Z1bHZZmEC7h2pzNHf9wwk5FfxBbUJ8c9oGAeRfFjk3r+30L0TcfvdyDWzrv+2O6FZBXdfq6euLIHJxsrXwwa6nH/SQMUKkLSh+OHtlZAM75WBo+j6t85uV6lh00fcmwDGJNtzTANxr2w7gjcwBonbxjTjeiZlDIF6LTBW/vUOA7sdPk8UhZMJAL8QQIJ280AK3YeOS69rKrH2cjSmCRHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(376002)(366004)(39860400002)(346002)(136003)(396003)(4326008)(8936002)(16526019)(52116002)(186003)(53546011)(9686003)(83380400001)(316002)(6496006)(54906003)(33716001)(33656002)(2906002)(86362001)(4001150100001)(1076003)(6666004)(6916009)(6486002)(478600001)(8676002)(966005)(5660300002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dFllem1KWjRoZnN4enBSM2Q2ZERTdDBPR3RmeXVuczNUMTlOYXArZlYrR0VH?=
 =?utf-8?B?VXJvYjlHL01VY3FjcitVa1Q1WjVCOEt5WDl1WFZ2QTU2UzJVNW4xb2tYaUdG?=
 =?utf-8?B?WFF4Qzk0aGhMUmc0RDAxS2F2REltVGQ0VTkzTkw1S25oL1MrVVhqQVhmdnVj?=
 =?utf-8?B?T2NHSC9Rcjh2S3Vsay9UVUUwSWRKcGN2eTYwYlN3MTFvWG52eWJQajdwb1U1?=
 =?utf-8?B?K3RnOEFKTGJ3Q1BIeDZCa1BpZ1V5OXozREkzS2VBMWc1Wlo3ekEwUGtmNE1G?=
 =?utf-8?B?SEl6MHRtTHlDNUVka1YvTHlOSkFFaWNRUU9iSDlrajZZMVRnZ0JUcTNMZkpv?=
 =?utf-8?B?U0ZVYUc1Z3A3REthajBUOExreEJIZzQ1SW1TdkRDa2tkajNqSkc3NmVGeW5i?=
 =?utf-8?B?eWxhYTFPRDUxVjRJUGcwYWlkR0NQc1dxNGJkZ2NuRHNVNTdyRE9jZXNHRjV1?=
 =?utf-8?B?aGZKWERoVmVHUVpaWjMvb2hSV1RzZFRMRG43bXB4MlluRnpVamY4c3VqTEd2?=
 =?utf-8?B?L0RlcFVVRUZScHcxQnRsZzY4S0lWOGRTSG9mNk52Ymt4eXFaZmU5NHhiU1BE?=
 =?utf-8?B?a0tYclU3QnVaL1d5Mm1oNnVPK3RmZGNrUkMxbGhiOFV3S2tlZGFibDVYczU5?=
 =?utf-8?B?Q1gwZkVUWFFFQWxCczdhK1k4WlFSRFBSbDRaQTFUd2NPekZGQVVlSUx6MjRm?=
 =?utf-8?B?UE1keWhJTlBRRW9kRHJibDF6aURvUE5hTHQxUzUrUTFaTG1mZjhFcmFBa3Bx?=
 =?utf-8?B?Y21lUjV0SlNCV1BrTStEOGkzdHVmeTdLWTdXRVJlWUVDc1E5b2ovNS91czJN?=
 =?utf-8?B?VElLWktnVmRqMXVwUGwzakZqR0duMWp5dGFMZVJ3SUdlR3A2SHJPSXRFbWdJ?=
 =?utf-8?B?M0cvQXVNNW5aR2dQUjhiZnlZS1FXLzUwQitHRmpFUE5DQmZaRU1RcTk5ZkRu?=
 =?utf-8?B?VjQ0ZC9Rd1JhS1pwbkxmZGVQeVJJVDRqNENpRUtWbGxSbXRSVTlCLzJiTG9H?=
 =?utf-8?B?QnRJU2N3b1Z3ZmVUTWgzUGFXKzlaYitrR2xYOVFrbWhGcDlzM3dzZ00weUxm?=
 =?utf-8?B?V0tmZEdHOE1ZTEV0Rkh0VklBMThTS3ArZG5qbTBaUUNGSmdyblQ0YlRtdkxs?=
 =?utf-8?B?YmtIbUMxUnNVejlwSHB2NmFVS3o2QnY0MkltSzg1SzBQd1JJUTJzSEc2S1FV?=
 =?utf-8?B?cDR4aTNqc2FQM0pxQ3Jnb2crKzBxdEd0OFR3Y0JCNVlWZm5iSGx5b08ydG1T?=
 =?utf-8?B?OUlWV2RRcktWYVEyNVJUYkpKMG1LYnRrM3M2Y1pUZ2JMSjBweGNHOFBGL3BX?=
 =?utf-8?B?emZCYjliZlR3VHhGRnNReHkzT1JDYVdncnFNL0JDdXQxUUREY1czTXVjSFNI?=
 =?utf-8?B?c0x0UDFYMzBTN2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c12398db-02d1-4d97-9356-08d895840cc8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:02:45.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMNAjkX8jTKcY7Y0i1xK7D6K4LR3MnAHzM+teIWjSd1bgu6NHbeex4N/j+9Mfiw1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4118
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 spamscore=0 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011300142
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sdf@google.com <sdf@google.com> [Mon, 2020-11-30 08:38 -0800]:
> On 11/29, Andrey Ignatov wrote:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> [Tue, 2020-11-17 20:05
> > -0800]:
> > > On Tue, Nov 17, 2020 at 4:17 PM Stanislav Fomichev <sdf@google.com>
> > wrote:
> [..]
> > >
> > > I think it is ok, but I need to go through the locking paths more.
> > > Andrey,
> > > please take a look as well.
> 
> > Sorry for delay, I was offline for the last two weeks.
> No worries, I was OOO myself last week, thanks for the feedback!
> 
> >  From the correctness perspective it looks fine to me.
> 
> >  From the performance perspective I can think of one relevant scenario.
> > Quite common use-case in applications is to use bind(2) not before
> > listen(2) but before connect(2) for client sockets so that connection
> > can be set up from specific source IP and, optionally, port.
> 
> > Binding to both IP and port case is not interesting since it's already
> > slow due to get_port().
> 
> > But some applications do care about connection setup performance and at
> > the same time need to set source IP only (no port). In this case they
> > use IP_BIND_ADDRESS_NO_PORT socket option, what makes bind(2) fast
> > (we've discussed it with Stanislav earlier in [0]).
> 
> > I can imagine some pathological case when an application sets up tons of
> > connections with bind(2) before connect(2) for sockets with
> > IP_BIND_ADDRESS_NO_PORT enabled (that by itself requires setsockopt(2)
> > though, i.e. socket lock/unlock) and that another lock/unlock to run
> > bind hook may add some overhead. Though I do not know how critical that
> > overhead may be and whether it's worth to benchmark or not (maybe too
> > much paranoia).
> 
> > [0] https://lore.kernel.org/bpf/20200505182010.GB55644@rdna-mbp/
> Even in case of IP_BIND_ADDRESS_NO_PORT, inet[6]_bind() does
> lock_sock down the line, so it's not like we are switching
> a lockless path to the one with the lock, right?

Right, I understand that it's going from one lock/unlock to two (not
from zero to one), that's what I meant by "another". My point was about
this one more lock.

> And in this case, similar to listen, the socket is still uncontended and
> owned by the userspace. So that extra lock/unlock should be cheap
> enough to be ignored (spin_lock_bh on the warm cache line).
> 
> Am I missing something?

As I mentioned it may come up only in "pathological case" what is
probably fine to ignore, i.e. I'd rather agree with "cheap enough to be
ignored" and benchmark would likely confirm it, I just couldn't say that
for sure w/o numbers so brought this point.

Given that we both agree that it should be fine to ignore this +1 lock,
IMO it should be good to go unless someone else has objections.

-- 
Andrey Ignatov
