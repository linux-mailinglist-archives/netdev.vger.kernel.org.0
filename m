Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E34C41798C
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 19:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347569AbhIXRRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 13:17:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30904 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344388AbhIXRRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 13:17:01 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18OG92J1029970;
        Fri, 24 Sep 2021 17:14:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=QucjMnleHJCAsHLUxN6xOayFlX/GXcNCDQTpY4yIg6c=;
 b=sbKvP1PWYAMUTvXWFljaav7SN5pt8I41tPUPMV4z0sM/wHpEs5+RcAg2RI85qgdbj9JV
 GTBkhuWQ2IxZHqgJ3kYZS+9YTuUJijOXfd2nMnzxPn//tVTAI3sv4gKAfneJjvFJi4Je
 rSFyGtQIC5YK/mqmuENYzVSGDTSoJDBvvHxwRkWFYGA7l3PY1bW3Yz7MEJHDLdDsRvl0
 owuVybJ/FUhFqJXb1SKx9LQmjWVlRUV27qlCME9+8atM3erm9/oj/9AwNZJIy2NMIeh+
 oMG0l/lXMRIGD99nJTKxVK/W/yn2TtpqTvSSxlE5OEOaBoOQbMEgmrg+Nyu+RonHyi10 Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b93ey4fpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 17:14:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18OH6AIm049202;
        Fri, 24 Sep 2021 17:14:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3b93fc9xhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 17:14:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBg8hKHDs07unpIrQDh4uuQJndV3bzK4Fuo2yGtDpiKBY/OjoHiQJ9prPUxq1PrAtTEZOa9QpenLvc/Ns4PjsItmhHbvIJVkyMWffdopAgU95pKO9i+pkGg+ftANuFyEWBNDA0NVfyeiVMwquDwn0iKQ0rYu4Zi1IKIRZNbIheV+xsJp0T+mWCxK7+sASFcQPHDl6Aakk3rd0M3TRKmEBhxMYcAlj52Dfm8dX72hHLN9+GN3elg4G4DQ+4N6mniF4CzYPdTaOC7NoQaV+BeJhLfdrX0EE/sPM42yjVydA0DiNC2cANvaMo1Gx/upbLLSka3kG4pqIrovkTVdHe5uxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QucjMnleHJCAsHLUxN6xOayFlX/GXcNCDQTpY4yIg6c=;
 b=NGNfPZvNcw/i1tArZ3NeQBC5jGoTSflrcOH1AWz4xCUBQOsJ3556k005bCLGlVmg2RR57pf+KNNvr6dheT3M8kU8S2sc4EFFSroaF7xbw5RpylqzttDsJZVOxnJFK+To3XyNHOXO9zgGaoDhDEOC0wcKcLwBwIaGgkVNTiD4L1jdYJC3AmKWxnbXXyXa+usvERodXx2GTUSkQCDwko2aNQlpEXPlmS9CFjKBj9ON4v7XYqZnWTwzYUaqKigHN1tBveZsYuUNt7ZQS5jt8dzf08CvtVRlV9zn1DRTZ30mGk6RXQ1hitH5XLDit0EodOicdUYS72hHoQErUvJtrcWqgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QucjMnleHJCAsHLUxN6xOayFlX/GXcNCDQTpY4yIg6c=;
 b=U5deZ/fg6Yio9zxJ6dKrxr4BMC4Y64mhhY/JmIwfLBcMVvBS0b2YzNJ2Ut8pvudnqSNmXDDCmYngWxHTpykDSbCQ8JkJbD2qB8uKDJO7SHYPQhEiO1TZIi49TADcbvfjLmBLZiX+iyuSyH6w1pnMvDJXl2iow8hy323gCajfxuc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by CY4PR1001MB2088.namprd10.prod.outlook.com
 (2603:10b6:910:40::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 24 Sep
 2021 17:14:31 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::44ed:abde:17a1:d442]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::44ed:abde:17a1:d442%7]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 17:14:31 +0000
Date:   Fri, 24 Sep 2021 20:14:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     syzbot <syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Subject: Re: [syzbot] general protection fault in sctp_rcv
Message-ID: <20210924171412.GF2083@kadam>
References: <0000000000009a53cd05cc788a95@google.com>
 <CADvbK_c-V6orWGm2ae1pxoUU-5J-1J-a057hYemA6oTESGhFMg@mail.gmail.com>
 <20210923093442.GC2048@kadam>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923093442.GC2048@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0049.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::12)
 To CY4PR1001MB2358.namprd10.prod.outlook.com (2603:10b6:910:4a::32)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0049.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 24 Sep 2021 17:14:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1070ff94-2481-4d43-d5d3-08d97f7ec5ae
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2088:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1001MB2088D8BD9B01B54086AD7F4A8EA49@CY4PR1001MB2088.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9vzgM0PfIUx+f42vKWRPH9QdRzcqP+zM3VWTL9jjMN+f0fzFf8tYvfahQGrrpzxa5x4uP3B+3BDp0NukRYqPBrxlphipAgabdO+l1oacNi8F+vBiZevcs0zdiyyRNW3DJnMO/u528nnTf1QHP8FqOQv1XiuDzdsYqCfNTtJOlccypxghGyxr95p05OH3iW+luJuZW0wu91mJngrpxF+mRi7cpZWSOURpsv6l7OZUFSMskO+BxMMw+PkLbq1gXbbR6xt2DwkoeJK8VIcc84xuUrFDE9001LQXl4jECai/Kc0izFuyZeDEbHCY8/HoKX9/nuDBn3pRLQgAMh/WnbgFKa+5Lb3M+EtF7jRSwx4C/ovMA+Vc9nC7oHJXvolbAkDNsvAxIMrzDH1HDIbG29S2/WDDawAlazFKcR3k2/+WwttfrVpG7DraIvADfyAX89rbZXaRCP4j3ZtQXP3t7evI3hxAFOuV0Cky432E2L8D2kojR9qi9HajaAFDjzX6sOcUi1k13uHj++4CDt1CHKgCDq6Az7X40SnAnfhGGFr5qCWo0L8EoGjh67/bBeeusXZYix1cRZ1s297AGb1A42GKm8eUE3osWYjJ53uG/EK5NzVB37gS/Mnj80+EPKexHlJuWBUbx5oJxuDgtjMRPwL4fQ5t5CWEcdXIts9CagHLZEZxrN253n9eKdO2k3N1LkEREMoJ8fEzqoIpbUCK1gbjagtUYyVfEPrx/LMpVTBh1iyE8vI+r4u/HbSrgE2kQjOgOSYCPgsatq65z5+5KIEr6nLiFXcl75kZ/Vaa5AbQNNVB4o2IY+rcFAqMXeY+7qrwffo/sv+jHTRvy+UqOQ8Xpey34lyHF6A4vWJ9NgP1hOo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(508600001)(8676002)(55016002)(7416002)(83380400001)(9576002)(52116002)(4326008)(956004)(6916009)(33716001)(26005)(186003)(54906003)(5660300002)(2906002)(33656002)(6496006)(6666004)(9686003)(38100700002)(38350700002)(66556008)(53546011)(66476007)(44832011)(66946007)(86362001)(966005)(316002)(8936002)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5lXF+TLoNpetRMm/yGJAXCSCW/87PkR2zyR4TftnnB9jjyuohxmIToDr8BUU?=
 =?us-ascii?Q?en6OGkObyTg0d/ZXN6JnTIsAQPVd4ZCY9U53xbNKx+mmnzVT5Hfb/Nyqyw3t?=
 =?us-ascii?Q?bBhecSn35r157d+ANyJvEghl0rKbaIGMi+1cK9CumNAswLo0XN5V7visZUSS?=
 =?us-ascii?Q?6sAahnSgbYGfiGA5Ryi5ozQDknxvmCMJY85jBW03qbHawY9Ydz+kneQkImQA?=
 =?us-ascii?Q?DKrEvD7UY8ol64GhHtZvjnWWC4Dh44W4xx7us2RS2K6No8D2SWF7LXN59WfB?=
 =?us-ascii?Q?60Eo9j6lY109XBdeiuzZhboTrFhSo4OAUmZCaAQdZ8HTKxh3gay5ShVHmxtQ?=
 =?us-ascii?Q?kczGj67ajcPl1Sq3Bhqej6vDVqscecpQeiJKfjRI7oZ59ZQeqwWoqdKW8pLs?=
 =?us-ascii?Q?FD2rPkO/fFHoobeUsKeO8Bv982FR+S7Z4ZMzy9J0qNRqAOih/HAThS0Ez2ML?=
 =?us-ascii?Q?Mn/79UD1GxPQ7bKZ87ylgdmSLPyJkXdv+WYh/i/wm/Cere5AoCQPYu5fqBsA?=
 =?us-ascii?Q?sh0NHiD90L0x8bIkPl4Sa0llksn4XOoHGF0DQNJX6ZWKSsfm/Q6UMa4zWAeD?=
 =?us-ascii?Q?nshLK8DzUfYo6BhrnS2LFWy+TvKsMFKvvOItIMpjEMuPv6e0o5VAoyJMdB8R?=
 =?us-ascii?Q?KwdgYOrUXDJuIGlIAe8MevZkwSXgskhBMrQvmvcXSIrZWBzDD2Lr/ejqTPqP?=
 =?us-ascii?Q?7ykS2YA6RCWxy93Pk5RY5YQYnuzDOSoXNXaUGM/TE4Rm2Jj4lmhkTW7/8wqE?=
 =?us-ascii?Q?/UBkf0XTaxn1e7LZa0uleF0qTUNchheIQlGAWqn9VPVGP19jgLOwM2ip45fo?=
 =?us-ascii?Q?YtGekpZcdj+bZGnfL9JiInL1x6efNGGFbzcREQ6Svs8w72i4ukSAqbEjSpzz?=
 =?us-ascii?Q?sBc6d8VwvO49LFlp5tbOGmJWE205QXGCNnFl6V2nn/vUH1X5AH5mBup71AO9?=
 =?us-ascii?Q?7nGCxigknPSe8DHCWliwVymp5RfYGG+irztKuGq+5avLhRECjR2iWrkLHNkp?=
 =?us-ascii?Q?qi7iJAr4u8tef7Xo/M3S3kMuy4NU6S2wmyAST08DZvZGppudzQiKkw9g3xQ4?=
 =?us-ascii?Q?E19IHVwVcN20Wzf1S9dDnMWgGMAYoVrg+O3lllFmi4YjSjBGqpi+bn7WaCWx?=
 =?us-ascii?Q?i9kOQTmCV4nAfkTqk4wM+B9hAbBbEAmDJ1EafE3rxipWeTtur7k0X/fGFwGv?=
 =?us-ascii?Q?Io7iV0YEtYOye66KyHRPWT1m73Xpr21g0PFhJs38AzjHxS+eQRynGyssIlfZ?=
 =?us-ascii?Q?MYBlq87ldxva1JMs3//+tFnQscFskmwvX+x3txdARCO05Hq5Oy7Ncy4eF79P?=
 =?us-ascii?Q?VUSlUPQelc/Fq2bBHLbQDLfL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1070ff94-2481-4d43-d5d3-08d97f7ec5ae
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 17:14:31.1130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: awLZUH2VOcXPhNsRwU/xGU8AHo/5omIDS7oSSNHv870mUhwp95xN64bYjXLqpDV3akhNRBhJBBJvlcRqgxZjys2aQEeXwrkOfoTAmIuHg+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2088
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10117 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109240108
X-Proofpoint-GUID: Ve5Nq-bL8MXwyA5CfMmFz0C2TfGhg2ci
X-Proofpoint-ORIG-GUID: Ve5Nq-bL8MXwyA5CfMmFz0C2TfGhg2ci
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 12:34:42PM +0300, Dan Carpenter wrote:
> On Wed, Sep 22, 2021 at 05:18:29PM +0800, Xin Long wrote:
> > On Tue, Sep 21, 2021 at 12:09 PM syzbot
> > <syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    98dc68f8b0c2 selftests: nci: replace unsigned int with int
> > > git tree:       net
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=11fd443d300000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=c31c0936547df9ea
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=581aff2ae6b860625116
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com
> > >
> > > general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> > > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > > CPU: 0 PID: 11205 Comm: kworker/0:12 Not tainted 5.14.0-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > Workqueue: ipv6_addrconf addrconf_dad_work
> > > RIP: 0010:sctp_rcv_ootb net/sctp/input.c:705 [inline]
> > by anyway, checking if skb_header_pointer() return NULL is always needed:
> > @@ -702,7 +702,7 @@ static int sctp_rcv_ootb(struct sk_buff *skb)
> >                 ch = skb_header_pointer(skb, offset, sizeof(*ch), &_ch);
> > 
> >                 /* Break out if chunk length is less then minimal. */
> > -               if (ntohs(ch->length) < sizeof(_ch))
> > +               if (!ch || ntohs(ch->length) < sizeof(_ch))
> >                         break;
> > 
> 
> The skb_header_pointer() function is annotated as __must_check but that
> only means you have to use the return value.  These things would be
> better as a Coccinelle or Smatch check.
> 
> I will create a Smatch warning for this.

These are the Smatch warnings for this:

net/sctp/input.c:705 sctp_rcv_ootb() error: skb_header_pointer() returns NULL
net/ipv6/netfilter/ip6t_rt.c:111 rt_mt6() error: skb_header_pointer() returns NULL
net/ipv4/icmp.c:1076 icmp_build_probe() error: skb_header_pointer() returns NULL
net/ipv4/icmp.c:1089 icmp_build_probe() error: skb_header_pointer() returns NULL

regards,
dan carpenter

