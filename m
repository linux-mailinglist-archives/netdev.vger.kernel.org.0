Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A533FF7EB
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345805AbhIBXg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:36:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9522 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235909AbhIBXg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:36:26 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 182NSxIM012136;
        Thu, 2 Sep 2021 16:35:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=AuFgsyiZcjU/34FUl1epJ/YiTUdZ4A+9bjOLGJSqG/w=;
 b=GjBuu/3ffUvsvyB0sJz1agzrgdiWvwHcKzmEdhDyQwGron+hOKlUnjjcBbX7nmm9g6fo
 SbS4TcyU27WwcB+0mWBPQpDffIMB0/OKWUJoe6GqdW9jMZDY6rvOYQ1lebjoLjO4YqY5
 JMZBnuY2vfZM8aelFwVYmaIlkhfv7mdmDJw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3atdyppjc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 Sep 2021 16:35:22 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 2 Sep 2021 16:35:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjskojGmhC9dexYf803lhnDuwQN0v79Zu23JF7pc6YKgOHWxDWI/L0iWopeCF8JaSKWxN0+EkBkOPzEDcIRG+kvRuxXzhD8lknpaz9ngOs4+z1UFutZts0b/ky/DKR/pzjQjfB4BhRXaAFv6QPZIkJVXi3Za4E5CN3ppneymFFYOj2cYXR+JuStSaaXjC+z6/biJ3S2TqYib+Y554vRix01DPybffvGll2Qg5JYjCSn7ZtJbqKQ8gEsec20yaW5zZbTawOLCPliKYeL6Eo5+tqRtc+Tq2UKQhLrwTlRuMO5FbuucguOm89UNBuQR5QYEr+rbZvJuA5U+eoxANcJNug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JXHk9zcvDYpmelfZKYCLSns8iNMbpwyU3NB+Z6XUXvU=;
 b=hoyPlUt3FGJoz6EjQyevZi4bSGZJaEVoNuX+xuyWHVxlGpkBChkNzGrFOHegfGby9KKhnwdR5Jzql/+m5ockBGqsg9EljrJp4UWNn59GKutpKjOz4qg73V3udBrR7dVNgCkUFpzncluzwaAADaIq94xoI+GJqFoQaGsgBDda9/YM59xvd2fQ9lgK7E+4eDvJRGet1wtE6QEaewB1h/SbS/GO+5hfCw1B9SmQce/QxRpOjPMoeEgmuVADWDmjc+n1QaOhK8Q+zyI/ulyZzPROjU+QaOaV31XB/fXQINszN6uSq/9dp1sGnmzthTtAv5SH0NjO9KcM5tptitJj5CC6/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4823.namprd15.prod.outlook.com (2603:10b6:806:1e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Thu, 2 Sep
 2021 23:35:15 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36%9]) with mapi id 15.20.4478.021; Thu, 2 Sep 2021
 23:35:15 +0000
Date:   Thu, 2 Sep 2021 16:35:10 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
Message-ID: <20210902233510.gnimg2krwwkzv4f2@kafai-mbp.dhcp.thefacebook.com>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
 <871r68vapw.fsf@toke.dk>
 <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
 <871r66ud8y.fsf@toke.dk>
 <613136d0cf411_2c56f2086@john-XPS-13-9370.notmuch>
 <87bl5asjdj.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bl5asjdj.fsf@toke.dk>
X-ClientProxiedBy: BL0PR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:208:2d::49) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c091:480::1:4739) by BL0PR03CA0036.namprd03.prod.outlook.com (2603:10b6:208:2d::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Thu, 2 Sep 2021 23:35:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 770231da-cb05-4279-ce38-08d96e6a50f0
X-MS-TrafficTypeDiagnostic: SA1PR15MB4823:
X-Microsoft-Antispam-PRVS: <SA1PR15MB482394AB10D434AC5E7508A5D5CE9@SA1PR15MB4823.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r397Pegyhiyd6uxoF4LQH6Y3iN4iRdpcEbGvqCp/wZgNRfDmyOSzZePcXYGXDQtlT8WttTTaCjMv3VtwQ8lH6myxC+ZS32AdRDRg1lCpitAwIhb0haxT5KBdBmN+l9MVqI4MO83ggDbDMrVFNYT3D9YVogCiYmIY2AWWZLAwSUNim5A9PuvqS889/BUstPN4C8vjJaWmj481oLlWl/Kzwn0Mmx8qZDipWGOfl1ZGoH4cEv7y5Dbpxs2H6narXlBVmeqfcnrbdp6DiVwrAIK6rZtnCO1JrC2LNv4PkIkiAXUedWThz8F7A3h0DkAlC2DKxpAHvUykuEQs95PKDKDmFIFhoz2Bh//mNgTGXtK3gobi/VyDtjgMeGJuSn+0Xo/KEeMc6tMshZHoPHQP0E/fyXKLb6MurKe6SIsbG+jFquaWAeEtfdrHBSJ6TOiSKGHZA840t+WrkfKAwt+qYQB1cemsaGmhLevp7AZeuROcueOZm5yjAK1oKLo8Ffnh0Q0jY4WasJV7UUkwQee7k5uY93OxT4ojgXTLiQt7uLsM1naX6Jukcvci15gMQ0arjteVd4dfaK9vDWC2Jl7CDitFhotvrGMJRF7ZpXWDwUoXzNMUduDE1DsJSyKhfeILaUI4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(54906003)(52116002)(7696005)(83380400001)(316002)(8936002)(5660300002)(66946007)(6916009)(1076003)(9686003)(478600001)(186003)(38100700002)(6666004)(4326008)(4744005)(2906002)(6506007)(66556008)(8676002)(55016002)(66476007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?4ZWIL2QE+2foDSJRCj1DMM95H4BN0ZBA6T1G9bN0VbEIVbYfub99xRYH1L?=
 =?iso-8859-1?Q?7brlu5yeApWeox6XsG87FTXtij/c8x8cevwwHe7cpRtblLZi6DLOcSXgCB?=
 =?iso-8859-1?Q?As/6nxjSQYcECdFEp3/eFz5pqsvuwpO5Y08kxJcvms284/icv3ylbOydbc?=
 =?iso-8859-1?Q?vTnYYdDs0sGDTkOvcHxG8tVmQqlg3L5q5BRVjQGrEieE3pfUPPtH9CIWQt?=
 =?iso-8859-1?Q?K6FYH31w0ke/FGu2H170GXUmjT5oc4QK3u4VzdMMTYDvMXPcQGvqUFXOYc?=
 =?iso-8859-1?Q?rCahHWyWOZAqffEaTWflOhzowaZaYdpoEdGB/ufCyiu1IDw501DPfyd0Zu?=
 =?iso-8859-1?Q?HAigZZOilS8c9MRP0lj6ta2VqTaYppl7bTptTCcXS/jakUvRCG8s5WSsqU?=
 =?iso-8859-1?Q?Mg7ybmy1TFWh/k4kkxy3crWiFuATrhFOJvSPqNpHRzT2Dqi64Gm6LCWdn9?=
 =?iso-8859-1?Q?fvlophgCo8CAj/eyZAfWu97ZH8CkBRaiFr6PkQPv4icwp68QlyX5cPtJMl?=
 =?iso-8859-1?Q?2gFT6qPUmzgDxUm1Nr/lDBtYmH0H6wpwsmIBKh2hMqnOs7KvJEOBdLunCo?=
 =?iso-8859-1?Q?Ab/LrDuhVJYXeyt1FEXrrkqONF+943i+46tEDBFiaicT47x8QTeIDIaKJP?=
 =?iso-8859-1?Q?+mX6SGCmR0V4jHoZuq7c0zYj1m0QzIkvGs1Ftq2+YchKVP2Jmse/Joo3ib?=
 =?iso-8859-1?Q?okGdzA01C65j+7+twUBvwrh2xF3ZbJBAtm3vQyfnM844AbWFyqf2I6D1dz?=
 =?iso-8859-1?Q?osTDuf5VY8vZWZQt1VosXg147ajZUdy7Ipgds5yMMRUMDaEQK6OCjmlN1M?=
 =?iso-8859-1?Q?ee9n/PNNH/cD0NE871k5Tk+JqR19GGbgWBjiQL2IKSCiIZglJusogc6PBD?=
 =?iso-8859-1?Q?7Ij8iKuY+SePEFGKJQKs2cnRtvDBnn9xnZfj2nPdeCYq3Pd96h/MLs6yKc?=
 =?iso-8859-1?Q?cQrbsuychHD+EZ+WNv60orNIkTSEDfgoR7CYjxmwz62NNJuJat9S3UjkTa?=
 =?iso-8859-1?Q?q+Hh9qhcP5PV2HTTh/tELomkCyC5EbInAzsCOBpFBJoQW71gF0ghiJ/h+6?=
 =?iso-8859-1?Q?aRTyghM+Hq414vjzhCUOVmEC1DjBEY56R7xXhcTqspikrAJ1kNmirfYbr6?=
 =?iso-8859-1?Q?lWhVE8z8RFRTWjiCAeVbYd1SJ/zaC+/3JG9x0lCUAdiVnCxFQs1lp2oPmi?=
 =?iso-8859-1?Q?//44lCDMNmHrQ+MerdZYQjgVi40Q8mInh3BzA77pAAU2q33oAQrftrX2nX?=
 =?iso-8859-1?Q?YD2YIrv4YmSsxOUAPCYtiLg2svD5ippFN0iC10hT+Qx2i3Yw/Mp3vDHq8P?=
 =?iso-8859-1?Q?/QA46XoJk05tLyhuJLAVJSZ6lr/I4EWhJz4KYRH6o+iFrtwt/MFH2/Vq/u?=
 =?iso-8859-1?Q?UkppRznMixMm0vOFfnY9Vs4JnOsSXjBQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 770231da-cb05-4279-ce38-08d96e6a50f0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 23:35:15.4228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LerkAhiYo7TsHPN72Ebc8Qxei0JrLfJJKZW1ty3qJ4CnrKIAKMhcr+788LCxeNu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4823
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Sn-NqlPUEMzcAWct43GooxGzjADw8E8S
X-Proofpoint-ORIG-GUID: Sn-NqlPUEMzcAWct43GooxGzjADw8E8S
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-02_04:2021-09-02,2021-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=636 phishscore=0
 clxscore=1015 malwarescore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109020135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 12:27:52AM +0200, Toke Høiland-Jørgensen wrote:
> >> The question is if it's useful to provide the full struct_ops for
> >> qdiscs? Having it would allow a BPF program to implement that interface
> >> towards userspace (things like statistics, classes etc), but the
> >> question is if anyone is going to bother with that given the wealth of
> >> BPF-specific introspection tools already available?
Instead of bpftool can only introspect bpf qdisc and the existing tc
can only introspect kernel qdisc,  it will be nice to have bpf
qdisc work as other qdisc and showing details together with others
in tc.  e.g. a bpf qdisc export its data/stats with its btf-id
to tc and have tc print it out in a generic way?
