Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B1118A184
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 18:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgCRR2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 13:28:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726680AbgCRR2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 13:28:00 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02IHPWk4008620;
        Wed, 18 Mar 2020 10:27:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=AdxDbz0jniO3HydATSN39or9huDa4XTDK4JybEC0Mbo=;
 b=awuBrP9Mokndbi98IsqXtPynWndyhpAhD7ynHpXBXHWspPWObxbZ6lX8ktM9POp9QW4C
 AAMTBBmcOg9PX1JnjRCgiGF/L784kbqacXi3MfkOZt1e1vH6M0Btsw3qZqvlxtv1jyzX
 jfL4buUbJYeFdmNDrjcQTy9D8oa8oXVIxKc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu8x3ksbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Mar 2020 10:27:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 18 Mar 2020 10:27:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTmLj3dkALMjs2R2NQtIRpwU+EPHbiEYYJ4QjDphQktRe3i9jGDBhuqBggET8Vnv7uKTQDRf3936HTBYpMP1EH6glo+/Xv7gvsqgjQH+iGRtbUDhlDWAsHDdAXXvBRtORDjucXGfCGAIfv71v8rSbEeGQjw+4QK8xtVRE+doYE05aLYDvF/blvbGPixFADE2rsw+iWQ4Mpt8DVOUDuxr4B7uoACxVxI1sqBMm7EtqLRKOYX6u3BR8r/wA09nUjdE15jbXuqJgiqeXGX8lu9Hw1eQsj7q2W/Tol+EA+1aCs0RH1ZP33krpScgNxiXoktAy9PJCsQJl3rslgeWJDd5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdxDbz0jniO3HydATSN39or9huDa4XTDK4JybEC0Mbo=;
 b=ocxD3jQCXBWIDCMN2cFGdkSp5ULepSZqHuGTrD4s7mlrEROHfryv/7LjoMez8K1iwwD7poDNmfwdhivViS1O0q1TfL4NGIvuZWHn0TBgargIx+ofSF3/A2kpuWDWYIWtc2hTmsOpaCUULTfCl3aIQeuYFO4UiNAUWNYY+0mY1aqA2El2zGTU2ujzIvUNNwldK4dOzpoyK/xoqEU1oW3ysYseaqNumx6Iy22cXcxa/eJzg/M+MY12HyfugtjOk0bIeIPdB2qc6A26RpZAHuxXtHO88Bm66U+aWUqOUaB1aXEEQlxN14HNrrV5q6XfPJYADws6MdpMR14tB9V1bUANUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdxDbz0jniO3HydATSN39or9huDa4XTDK4JybEC0Mbo=;
 b=EJWp8GGIJhOugnVr+/ArAEgPzVFtpnzrYE5c70kiDyMB2x6gxsMdutOAPIaKLWaiCXScmFz+Tt3D9AWZ/7Pee8biBHKcJ64TM2tX7mCpBLFcLiNwDqzb4wa/18iegiaAGz7sWLvma0NmgzbqE777eKCw8qpuDp/8xOK8Nw/gfHU=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB4087.namprd15.prod.outlook.com (2603:10b6:a02:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18; Wed, 18 Mar
 2020 17:27:43 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 17:27:43 +0000
Date:   Wed, 18 Mar 2020 10:27:35 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 5/7] selftests: bpf: add test for sk_assign
Message-ID: <20200318172735.kxwuvccegquupkwh@kafai-mbp>
References: <20200312233648.1767-1-joe@wand.net.nz>
 <20200312233648.1767-6-joe@wand.net.nz>
 <20200317063044.l4csdcag7l74ehut@kafai-mbp>
 <CAOftzPjBo6r2nymjUn4qr=N4Zd7rF=03=n45HDvyXfSXfDnBtg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOftzPjBo6r2nymjUn4qr=N4Zd7rF=03=n45HDvyXfSXfDnBtg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR19CA0016.namprd19.prod.outlook.com
 (2603:10b6:300:d4::26) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:9ce5) by MWHPR19CA0016.namprd19.prod.outlook.com (2603:10b6:300:d4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Wed, 18 Mar 2020 17:27:42 +0000
X-Originating-IP: [2620:10d:c090:400::5:9ce5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edffae68-9e18-43fe-1e37-08d7cb61aa76
X-MS-TrafficTypeDiagnostic: BYAPR15MB4087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4087F23C08F80E677CE66E90D5F70@BYAPR15MB4087.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(366004)(346002)(136003)(376002)(199004)(86362001)(9686003)(2906002)(6666004)(5660300002)(6916009)(66556008)(66946007)(66476007)(8676002)(6496006)(316002)(53546011)(52116002)(478600001)(55016002)(1076003)(54906003)(4326008)(186003)(33716001)(3716004)(81156014)(16526019)(8936002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB4087;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3H9+ZHWWktUDMkpxfd/CXliFgfeOgRA01c1Pw9B5XFgHtS81pVfBnfaN+UiL3K9liad6Tbv90MG4SPPMN4f7nM+3LxhkmSEmV6EW78OhAXgd3s/Ueav12+s5PpiMCFXNo5l81AuWyILFZsb1Htqq5Ck4Gkgf6+o79sHJVZL9xN+b2bMHy9hEwJCaxjjmBxwcdRS/Y9Qhcc9owOMQzsMqzL+UzTI8F6jqdmR0kI6x8IKGWfkiV/+gOWiAaBiC4VJXaMNx9ukQ0LX2P69SU0h5jpGbE5NhM86uWLQJ+GIqwT23L4jo6dkc5cKT8MsfpiPtSXF/83vdZfSNSRMsLFBM4HRRN0bMPhHyWUyUdp/9rvOUW+8DaWcqzNBcvF9HpcYGh4YXO1oT13yUUVHnptJIhPef2ukUbck29Z2XC+yk3iuN4G56lYis2GSeBU3Sr4w3
X-MS-Exchange-AntiSpam-MessageData: hgnFsAPxmgJIeY1veeQwjqNnwPCBMv/gICKjZjkfGrcrgAAc4zbB8AZNMUsFH+mj23cip0VKR7sDRf/CgFDHAwI7X1jN1o9MipEdrqnmfbrk23KSAsbz4Gr3diV0ZMK3m6RS9X4a6t8tvn8xdaYGnISPflhJqE6ob3py9s25s4BrdqmZrvJVezqtWwosjhei
X-MS-Exchange-CrossTenant-Network-Message-Id: edffae68-9e18-43fe-1e37-08d7cb61aa76
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 17:27:43.0467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YRSH9jnCsyOUyf0c5y8qJM6V5w21nb7sVWez0EpclB7fSrN15P3Td/F5NINQVIQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4087
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_07:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003180078
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 01:56:12PM -0700, Joe Stringer wrote:
> On Tue, Mar 17, 2020 at 12:31 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Thu, Mar 12, 2020 at 04:36:46PM -0700, Joe Stringer wrote:
> > > From: Lorenz Bauer <lmb@cloudflare.com>
> > >
> > > Attach a tc direct-action classifier to lo in a fresh network
> > > namespace, and rewrite all connection attempts to localhost:4321
> > > to localhost:1234.
> > >
> > > Keep in mind that both client to server and server to client traffic
> > > passes the classifier.
> > >
> > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > > ---
> > >  tools/testing/selftests/bpf/.gitignore        |   1 +
> > >  tools/testing/selftests/bpf/Makefile          |   3 +-
> > >  .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++++++
> > >  tools/testing/selftests/bpf/test_sk_assign.c  | 176 ++++++++++++++++++
> > Can this test be put under the test_progs.c framework?
> 
> I'm not sure, how does the test_progs.c framework handle the logic in
> "tools/testing/selftests/bpf/test_sk_assign.sh"?
> 
> Specifically I'm looking for:
> * Unique netns to avoid messing with host networking stack configuration
> * Control over routes
> * Attaching loaded bpf programs to ingress qdisc of a device
> 
> These are each trivial one-liners in the supplied shell script
> (admittedly building on existing shell infrastructure in the tests dir
> and iproute2 package). Seems like maybe the netns parts aren't so bad
> looking at flow_dissector_reattach.c but anything involving netlink
> configuration would either require pulling in a netlink library
> dependency somewhere or shelling out to the existing binaries. At that
> point I wonder if we're trying to achieve integration of this test
> into some automated prog runner, is there a simpler way like a place I
> can just add a one-liner to run the test_sk_assign.sh script?
I think running a system(cmd) in test_progs is fine, as long as it cleans
up everything when it is done.  There is some pieces of netlink
in tools/lib/bpf/netlink.c that may be reuseable also.

Other than test_progs.c, I am not aware there is a script to run
all *.sh.  I usually only run test_progs.

Cc: Andrii who has fixed many selftest issues recently.
