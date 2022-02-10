Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE6D4B1480
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245304AbiBJRqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:46:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239868AbiBJRqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:46:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79676F6F;
        Thu, 10 Feb 2022 09:46:13 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AHIRqd026356;
        Thu, 10 Feb 2022 17:45:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=kJDe/eukKc7/qF8Q0LhljcHQ4C6HIQQDunj/A4iRSDg=;
 b=erQeWxigqWwMRl21QoP6fCr1zrlCKhnzeJ8lqxhXUi1E4Z9VTvyYBIIIqBTUOck+f3Gg
 Dw1pUtb0fLVNJ8dZmwsQLmsf6OwCJ8RkB73SSWo9VP96WMFnxh2X4ESk8oeikclbTHpB
 xCjdqBHkM91LWtI3JMzlV9ksdnaTfyyw41vTV9QE2OfY3n6BBaZV3tAlGhNrXYgZc7C+
 0PJ3F0C/+9ZURGT5jY0fNGjfWuMn99R9FOyXa1YQ2Te0ZiNBW5R8ygoWixT71vfYpVDb
 pIgob52jJGhUyMp7Gg0CFMCX7vde6+EX32OGdiIPkUyodJbSrFjpHw2zh9Vjlv1+3c6e dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e54ykggja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 17:45:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21AHfuYG011963;
        Thu, 10 Feb 2022 17:45:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3e1ec5ga3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 17:45:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qft/Qc6mUR9WAauRic/qUtf0slKaMULfcYXuQC83QQASx6TCVt0BNxe1h4MBfqoNe2nHXqE4pootP9r0taK5z24Sio9+ZPiIw0+QGVOHTsrUalrL+3aHWtEPWLInqq0L8ngdvtDvjKR5jt7tQSTBeETWdGQ5771pojl9/vuTNrCQR+5bayX9XSYkT2xHO+aMpQKK8SpJVasj6xpxLM9V/olRCMptGwwN2EW8JbjzBij+W1zb682DgNwe7qF8KktYOjuJClUzVTdRUrtX6jmuCm7PN21gxf7geqyd+LAjONI9Gzofmqb04n2bRGMexRUsfZKTtSBzX8VxwaVmdyRokA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjnDuU/3l0aWCj7IvQU1pTL3T1QXW/AYvvtDfHGdH1U=;
 b=XyWjn0oplzQyelIMEBG7lB1wQFQDLmX3XHRSjLAo0zhNlc3vTAqLrEQ5mTKXgFROhmm2iRgY8EdIoPt0u6NQuykMV4xCb91pjgD8O42bQSi6piYu5xEarksfsjY3ESWCMTTtJFuM1pzrxTj5Yrk6ZA+56ubBvo5sG8mepu8WkohEtfVrmbt6aC6lIUaDl+eQ8FBlVoKsn9NZ2cPPDtiCnXYRSN00iQW+fvlOdC2OpYTAbmN8uAeC7faHPMWGT+tS/9AbstdLhEuDYJIRrVO9CBJ6qNrJMywBQxMLlKYzAudT1a2hfKQKMVvkT460Cbmi/3qIYVHGkQ9AruGLyd5irQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjnDuU/3l0aWCj7IvQU1pTL3T1QXW/AYvvtDfHGdH1U=;
 b=G8zBXoaq788GWmrTAQl8AUotYJCuZ03YyZjrsUoFehPgszW068+MEl7Jy2qSbXGOvwIuwrxO+hK3C1fD6Hvygdi25Vx81Wci14T1koq0rHD0vsQp4qsUOBqVMMqElInYv2GT6rbqCX+HdW5NYCl3m+WhkPRDKTlMKYTiPrhAQtM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB4345.namprd10.prod.outlook.com
 (2603:10b6:5:21a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 17:45:24 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4951.018; Thu, 10 Feb 2022
 17:45:24 +0000
Date:   Thu, 10 Feb 2022 20:45:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, Willy Tarreau <w@1wt.eu>,
        syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        fgheet255t@gmail.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        mudongliangabcd@gmail.com, Netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in xdp_umem_create (2)
Message-ID: <20220210174507.GK1951@kadam>
References: <000000000000a3571605d27817b5@google.com>
 <0000000000001f60ef05d7a3c6ad@google.com>
 <20220210081125.GA4616@1wt.eu>
 <359ee592-747f-8610-4180-5e1d2aba1b77@iogearbox.net>
 <CAJ+HfNjeapa=2Ue19L3EWF8z5vxFB0k2QO_LuBu4Meqs0=AE4Q@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNjeapa=2Ue19L3EWF8z5vxFB0k2QO_LuBu4Meqs0=AE4Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MRXP264CA0042.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::30) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90c22474-4321-45f9-2b75-08d9ecbd1d42
X-MS-TrafficTypeDiagnostic: DM6PR10MB4345:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4345606BE5A94F2919C2AE898E2F9@DM6PR10MB4345.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1X1JXwzDvLONRS95ekzjFO9v54wVNL3M5fsPFvZrioaUDDJJrcUD2gc4yCF1pbZmVLo4mJDxUJHN3jsgm6GXab4wPU4D3yeSCg3x1LMp429rG1Sbe5yAxLB7Wf/SZ5zYsoorfTDEKhJCTkmjMS95Z6u8JUe3G1SGZr3LfjvYoFuyD+/mSihO6oaIe7AQlogR7R5S5svks75R7wI0K8u1szCIGgZY9HKLSpyMJ1pjH9L+hKLIAEApuorHcpWvFMIc4E38c8yWWxrFDJ3Ese4yIqLMstwqAiINqGujwS7bapGlnKGL7I87TYHIUOK5R/3f8Z7N6DKPYzDww3v11fWdFbHyKHuEkARtS0xxmRHDB8sgdK8ErDHOGABWYSYRhOLiguUtowX3iWFjpWaU5dXfIYXBVR54+k7Zo1bJMoYnRc+BqwSHstNMM/JnuypY9/s3kbsR/dDNbjLu1iOcsY6I+2hQo4D+fUYzW75pfyxxoiX+7VcHxav1bJWCEtqWfalRAdiWxssbrSI6eV3ka4ZhoBSgyRaFuODfHhJiHeMaeELgX3AZ2uB5PB71u3Rl/Iao6WhbReFFKNRd6XO/bk97OnsMv8NGFwetVXjwGiQCP/E7tpfhkKLuLpiGCxgbhXr/WK5rWgB6Cux8jQrMqQHuIUb393aFhq0EqACAatjC4ro/i4VsI05a3CyeviMxsTILnps537cVwoFcSBd4hJxIkxpo1eqKgAdoDABpJW+wO/JQcjuzu1GGmD7qKOuP7uWn4BMlO/8tMqfHPHbpSO/v5aICRTalro40BP0tFtHn9NzFHOfOveNaC4rsXRXwkXm6Er6gadpNThdC9IejfAQldxw+N85er5O0wZC+uogNtPY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(33656002)(508600001)(6666004)(5660300002)(54906003)(53546011)(52116002)(33716001)(6506007)(8676002)(6486002)(6916009)(9686003)(66556008)(316002)(66476007)(8936002)(6512007)(86362001)(2906002)(7416002)(26005)(83380400001)(44832011)(66574015)(38100700002)(1076003)(186003)(4326008)(966005)(38350700002)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?aABBveOZa+fz1tdkg4mb/aMOKXNKIH6kl4uVgQ/zXpwZTmpJOKDHQjA6mz?=
 =?iso-8859-1?Q?5gvg8OBZi4LKjEXmITh0jp4aqOW5aIycWA9+vw9Ro108WvdMtlfWTVoXtf?=
 =?iso-8859-1?Q?oGz41WnPtGFYcLdiyV9aqjM4agKfg6M9S51y273njE9a7cdlhKDJwh39aa?=
 =?iso-8859-1?Q?Lpw/Nj56XTRgv6BFK8HG9GVbwvr7hVkViZf2npOUyD3m3G98V7YPMvwOAe?=
 =?iso-8859-1?Q?jJhLKb95hlZ38qQSWNylBJnkCphCIF/7CrvNJ5tE4XvFwNCLqZN9KZOS1M?=
 =?iso-8859-1?Q?riLd3IjSWuvfAGnfK9kury3kfHw5N6k/9c6C9dM/RRuozXzcd4rN/28emZ?=
 =?iso-8859-1?Q?zNbJ2xLs1034vdA06goZw9fyJJS/y4WNw5bcFbvq1l/V6gcbK031pN6X/k?=
 =?iso-8859-1?Q?F/OKayz2IK3jL5p56xmpaw2fQTZ/xAfmuGU9EJluIRlK6uMY9sqo52UQ+E?=
 =?iso-8859-1?Q?ZKyhKGISLbtIknRnTdu51nKH95txRz8fwpp6cgfjOG4DIKkfwq+GVaG3Ie?=
 =?iso-8859-1?Q?PgGo56YRWfAS6k/tGcI9y3mxphlS4GP2apEFm7/W0dTbKeOQbm2Jf9n+uh?=
 =?iso-8859-1?Q?eiVzPzNT9n69Igmwa36ta7ZlW/Z0V/0q10XTGSFh3CmiArfmmxlsq207wA?=
 =?iso-8859-1?Q?yesa6HPuVN233A2NORZ4E7VNIBsEwEzsaxX1o3vDo4P8ojbYHr67HT6BMe?=
 =?iso-8859-1?Q?lwz8+AUSz6qn86WCKEzG3EyDFV87x6q2EstQyICps00fTgIYrF4GdoMop6?=
 =?iso-8859-1?Q?3rrqF08I3nj+kr3aZfJRWfqNJmnLh8sNa/pljEc1sO09XgGyqEQ73VkAVQ?=
 =?iso-8859-1?Q?7DcRklmpWAebI7K0JDGW/5T12gbXRg7s2uPBE/FaSVlRqMUaHGRkxCgyq0?=
 =?iso-8859-1?Q?LMA+Y8N1Ci7b1ZxUrNE4a3YYLyvmQu0U4uAD9zk7aN2IMlCpMgNNiaICIh?=
 =?iso-8859-1?Q?NkAshOe2CGbNnI2TlfZxeleLWuKu4n0L3DFUwyNmwJZAU8wosLTdIs5wmA?=
 =?iso-8859-1?Q?QUnTjV3yVQ1RSCNwhU8RErRaHvNcF3bXwLERb7c9xXomY7u0GPyKJtVE6e?=
 =?iso-8859-1?Q?1if6dHyKJR2TBrmwm8C+FoetRYDZvN8qJYCxKAwK8Slbx1msxppS8yRjTg?=
 =?iso-8859-1?Q?bGn2M/1sLes1ySCexex+YjOU9Hk9DlyZhidPfwbFx7rS/9MxTAlY4PEhp0?=
 =?iso-8859-1?Q?KJSuzPUk+BDnTZAyQlyxG3idfWgQK24rLV3977as/E8H+WlkV0q6eV0LC7?=
 =?iso-8859-1?Q?ZaZSttEJCjRt5pEcjFxK+M7CIEcyyVWcxWonbJNA5imHO7gfrepMb1kHh2?=
 =?iso-8859-1?Q?MVZPJssyafp6ySSIOYLi4R5/oulf0QcagwXx7ESDPtFQMNKmPuxiX8IEHY?=
 =?iso-8859-1?Q?eki0/AP78/COKrQRH5JLhnPw0W6aMzxDSRaMz23aTmzTM0FdUEN3end5jy?=
 =?iso-8859-1?Q?oQ3eMXgFWhtSAfkEZ2wm9gQkryTqXX0JZdgpXTOHJQxmp8nuqejtcDZlbh?=
 =?iso-8859-1?Q?4SBrCvFEX/QlgjY4ZTOMEPB471do99OY6F0rMClI3YhupJnwIn2YEimXUT?=
 =?iso-8859-1?Q?l9G1NsdeDa64hZmm/ql2YvwjlReI4QvK7sVMizRzQKFMoFoE5qTSqfV3NI?=
 =?iso-8859-1?Q?Oj/ssJ/E5NJU4Wcq0K6WM/b06sGxGNypbwTG0+bnfufyhg1857+sCwS1nO?=
 =?iso-8859-1?Q?k2ZdOczQie2o4zEHQJ3x4vpP3Z7hqDLtc4vKGI3/OiyYPTLIwe2kP68sz1?=
 =?iso-8859-1?Q?3Bag=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c22474-4321-45f9-2b75-08d9ecbd1d42
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 17:45:23.8641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aei22d2kzUiVOLGO5tvi9N0Qspd0azDI58iGC29Xa3BWXbAX5xPseqhoVm44AE3fPO0Iqw88PyxRmgovb4HAYEZ34ZvuW6fhAQdFg7uXiok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4345
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100094
X-Proofpoint-GUID: r0yCrTMX2l6y0yU_BuecSURjkGH69VhJ
X-Proofpoint-ORIG-GUID: r0yCrTMX2l6y0yU_BuecSURjkGH69VhJ
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,GB_FAKE_RF_SHORT,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 05:18:52PM +0100, Björn Töpel wrote:
> On Thu, 10 Feb 2022 at 09:35, Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 2/10/22 9:11 AM, Willy Tarreau wrote:
> > > On Wed, Feb 09, 2022 at 10:08:07PM -0800, syzbot wrote:
> > >> syzbot has bisected this issue to:
> > >>
> > >> commit 7661809d493b426e979f39ab512e3adf41fbcc69
> > >> Author: Linus Torvalds <torvalds@linux-foundation.org>
> > >> Date:   Wed Jul 14 16:45:49 2021 +0000
> > >>
> > >>      mm: don't allow oversized kvmalloc() calls
> > >>
> > >> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13bc74c2700000
> > >> start commit:   f4bc5bbb5fef Merge tag 'nfsd-5.17-2' of git://git.kernel.o..
> > >> git tree:       upstream
> > >> final oops:     https://syzkaller.appspot.com/x/report.txt?x=107c74c2700000
> > >> console output: https://syzkaller.appspot.com/x/log.txt?x=17bc74c2700000
> > >> kernel config:  https://syzkaller.appspot.com/x/.config?x=5707221760c00a20
> > >> dashboard link: https://syzkaller.appspot.com/bug?extid=11421fbbff99b989670e
> > >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e514a4700000
> > >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fcdf8a700000
> > >>
> > >> Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
> > >> Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> > >>
> > >> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > >
> > > Interesting, so in fact syzkaller has shown that the aforementioned
> > > patch does its job well and has spotted a call path by which a single
> > > userland setsockopt() can request more than 2 GB allocation in the
> > > kernel. Most likely that's in fact what needs to be addressed.
> > >
> > > FWIW the call trace at the URL above is:
> > >
> > > Call Trace:
> > >   kvmalloc include/linux/mm.h:806 [inline]
> > >   kvmalloc_array include/linux/mm.h:824 [inline]
> > >   kvcalloc include/linux/mm.h:829 [inline]
> > >   xdp_umem_pin_pages net/xdp/xdp_umem.c:102 [inline]
> > >   xdp_umem_reg net/xdp/xdp_umem.c:219 [inline]
> > >   xdp_umem_create+0x6a5/0xf00 net/xdp/xdp_umem.c:252
> > >   xsk_setsockopt+0x604/0x790 net/xdp/xsk.c:1068
> > >   __sys_setsockopt+0x1fd/0x4e0 net/socket.c:2176
> > >   __do_sys_setsockopt net/socket.c:2187 [inline]
> > >   __se_sys_setsockopt net/socket.c:2184 [inline]
> > >   __x64_sys_setsockopt+0xb5/0x150 net/socket.c:2184
> > >   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> > >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > > and the meaningful part of the repro is:
> > >
> > >    syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> > >    syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
> > >    syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> > >    intptr_t res = 0;
> > >    res = syscall(__NR_socket, 0x2cul, 3ul, 0);
> > >    if (res != -1)
> > >      r[0] = res;
> > >    *(uint64_t*)0x20000080 = 0;
> > >    *(uint64_t*)0x20000088 = 0xfff02000000;
> > >    *(uint32_t*)0x20000090 = 0x800;
> > >    *(uint32_t*)0x20000094 = 0;
> > >    *(uint32_t*)0x20000098 = 0;
> > >    syscall(__NR_setsockopt, r[0], 0x11b, 4, 0x20000080ul, 0x20ul);
> >
> > Bjorn had a comment back then when the issue was first raised here:
> >
> >    https://lore.kernel.org/bpf/3f854ca9-f5d6-4065-c7b1-5e5b25ea742f@iogearbox.net/
> >
> > There was earlier discussion from Andrew to potentially retire the warning:
> >
> >    https://lore.kernel.org/bpf/20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org/
> >
> > Bjorn / Magnus / Andrew, anyone planning to follow-up on this issue?
> >
> 
> Honestly, I would need some guidance on how to progress. I could just
> change from U32_MAX to INT_MAX

It would have to be lower than that.  The limit is on "npgs" but we are
allocating npgs * sizeof(struct page *) so it would have to:

	if (npgs > INT_MAX / sizeof(void *))
		return -EINVAL;

Is it normally going to huge?  You could call vmalloc() instead of
kvmalloc().

When Linus added the WARN_ON() for huge kvmalloc sizes, it was as a
reaction to a security bug where the size which was more than UINT_MAX
but not everything was prepared to handle ulong sizes.  He wanted
people who allocated large amounts of RAM to do it in a deliberate way
instead of by accident.

regards,
dan carpenter
