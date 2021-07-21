Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B69B3D0C1E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 12:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhGUJQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 05:16:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32660 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237489AbhGUI6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 04:58:35 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16L9aiW0019792;
        Wed, 21 Jul 2021 09:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=/Ji6QXQ8hnU2qWkwTh6980ktbY0GDGtlFgoM4HiZrpI=;
 b=0epPKMu/XN/yGEGP8H5oDSPej4jdkfWu0uV/9pq0HoCVtAaw4KfcnpOYtjKyWsjQWbgR
 KPH8Co8MtcswmT51PWzz+Qr8vgqup3KR8UMv1L8YBTGL01cXr6XD11QvKpV7epN5t2OB
 wuK4eDuxJEh80hlWjBpmqLUwjt8mmtkPq4bhQJP+wmUCLO4dhoeTz4UzowH7fzypT7Xc
 piIs/ayW3qk0om+ZvpL8BovxV7aOn4qzSjWKuPi9m+ztIYqjRAscmTRcj5ar0eK4MJwo
 uznbZhxTrk6hk54FwUCSynZZ4OX3C/Jh5XA7ykht9fWd9o3pkcmi0DturV1BLQjM+tB+ 7A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2020-01-29; bh=/Ji6QXQ8hnU2qWkwTh6980ktbY0GDGtlFgoM4HiZrpI=;
 b=T0DYgItvZE5gVQ04SM8Cf19RkNG/EHi/Z8mDdudHdzE67grNb+gkiqvMF0EU43ogId9K
 h/uRj3FLDQE1PHukXc4FSlCn8YkPRH8aHYsfZG2ufdR3OVdk6YGd3QjjOS0O5EyPsdWW
 1iHEO/d0P69HJTEVI6UxPC/j4YW34eQF7fjJqvV7JKOz/gaylqaxjpNCmqI3LeGowkTQ
 WwaVK4Qcm8pT160azSem2k76YtunbU7bh2PbN9WPO4p6/ssPcdjRPYoDGrD+TdcgTSVR
 +/n28FU1ZWQ3XhpOzysfNEG1DmnzG2W2ZP8RYqNP9jqerQb4Q5QtT6Lu9F+Xam5FS7P/ QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39wvr8aecn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 09:38:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16L9aPoL175266;
        Wed, 21 Jul 2021 09:38:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 39v8yx17am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 09:38:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvpK1bQ6VReiYTvfm0mKT73djcsEuWkvdzwHPpetMRk3NoYYJX8pyr8zPdsI4ZJWPWEDgp07j+sxvMOq4ga64Z+3X7++lyWQNNFBTqf/YE71JGdATlwLp9UTSwDIeU94S8P6shuMJ+y9+IFVxlhwp61wesUzzuhLkeKN5t/gMLo42Qmi29GyYtUSJL5bO0w6q96h8Z/hH5ynPn2P3BA6aUpwkWqdeTgqrWrBBkaSnzTicJHnv4vq3not9Gc19jresRddPybH8+ZsnecZwWCVCQjovDs0eyW4xB+r2eBLawVYkbWfZ5MXjFqXu6UzIiA5DEyQWrXkRhdVnFoWaFskQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Ji6QXQ8hnU2qWkwTh6980ktbY0GDGtlFgoM4HiZrpI=;
 b=Osu+JccOwbnOdigDMnmFrYCpANaXjQ6RQmbvNzJbmMiYKPLR8d4PG5jLz5QzFTeThdk4TmW89UbZ7LKAFOS2Ow6CW4HifEPOyr6aY1fbdtlc4zvSc9EJMpJOK6fzFSMS2SuFZX+NFR0sTBBmbBCqa8CIJ1MtJZWz0M8FaPEwI0m+WPDAJOTEszW62/XC4l76BL0CN4tiPbl4X/v/fUgNlyKqfW2B4ML7zAhIr8mBi3FxcIt4Bik4973iUnzliLM1ClU2k473+QJ+1yiVhzzzv6REvXS4FZEFt5KOJ6r8iw9iSvU1hnEJXEdqLKogXzUPcavkr2M1xMMV9ZwXy1v5rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Ji6QXQ8hnU2qWkwTh6980ktbY0GDGtlFgoM4HiZrpI=;
 b=ItHKzHo+bIFvaEtZ3XQRGvp2yoiWXwZJOKK+wAMCahonC7o1finb1COTnqpaKUqdMVZwvL9BsjJ7yo/fza+yrrZxk50xMX9qjqzZ0ozskrhAjti2rtr3hnzFQDMjILIadAI64EhyelUEI8dwgkwKmjKYwPlojBRFTHryKGTnQbI=
Authentication-Results: lists.01.org; dkim=none (message not signed)
 header.d=none;lists.01.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1888.namprd10.prod.outlook.com
 (2603:10b6:300:113::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Wed, 21 Jul
 2021 09:38:35 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 09:38:35 +0000
Date:   Wed, 21 Jul 2021 12:38:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, John Fastabend <john.fastabend@gmail.com>,
        jakub@cloudflare.com, daniel@iogearbox.net,
        xiyou.wangcong@gmail.com, alexei.starovoitov@gmail.com
Cc:     lkp@intel.com, kbuild-all@lists.01.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf 2/3] bpf, sockmap: on cleanup we additionally need to
 remove cached skb
Message-ID: <202107201829.npSZIVc5-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719214834.125484-3-john.fastabend@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0029.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::17)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNXP275CA0029.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 09:38:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c246e2f-8088-4ec9-bd16-08d94c2b4f1b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1888:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1888B98702421E3A8815178F8EE39@MWHPR10MB1888.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8JvhWYvwiY6riYdCL5roTke5/pK/cs0f43qRb6V03zIlKSvJIRXc0wt6b7gdmKuu22WD2UwqF3iVB5apC2CN71DSV2KRd4kCz7fnSxmkHV4At58KCAshUsb8HOW8LoWbACP8E9C5Wkmx+Rj6uI4yYxhf740QlfeK62i1ec2cPhMBXAq70KxKjGHLK7+bys4oAA3GJFD7qiBJZqN33BAFw1c6llCZCtXdmFRtd/fMKcw5SFn9EMT0dksyILcStx2wrwaOkkNpZcBnysVk29e+MBPPBAIViQcPErBo9GcO232jjCCcKGr9xx1OqT898qwDMAlCqAN1j+Tn1sPo7gj4TgpS1O4NFxi4qFl8KKkJkoNdgdljY143WOpizOwtkM0GaMJ4l8OVaQaIS4A6ErgZu/28KEx9gk66BOTia9MknXypREIemdu4BarFHRQU/j0f1XU46T0YIU8ikjKsl66eBin8rGYcP9IKrnQm0qY3DvNJgURO5DHTe5gZUll+HooiBHev1WKPLrumiBrfEWWyFc0GoATWmU4lGO4jRoaebM2qlBQcvCojlAguw9VLaKX4P888PtnpbGcTJbRP6W15dcMLj/Qf8xs/m3Cifp2oC2bxLmGm2wFhkJnHN9FeL6duEDjEeNnnUlyrk+rKyU+BxjwfxxzfzCV8tRWOk673wk5DEN2d36HzeACpjpx68i9Cs4QwhA9Cl87yKoK89cQVwXx53PfxmMImfZe8k4IUxGijV3wltQvPxaQc511Y8AH+abw+Aj/Eojq/0D8hAbIcTEJ+Xq6aINLgMX9INSh7SFrhQpjvKlHQqSkkOaEDVLrn0u5zV/SDoEJQQNvJu92F0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(376002)(366004)(396003)(8936002)(44832011)(52116002)(316002)(6666004)(38350700002)(66476007)(478600001)(26005)(186003)(6496006)(86362001)(8676002)(7416002)(38100700002)(6486002)(5660300002)(4001150100001)(83380400001)(36756003)(4326008)(956004)(66556008)(966005)(2906002)(66946007)(1076003)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?24HWf8KEgn2tj/ixDDYtsk2XrbR+914/5pQyXV68lV3nUYb0VSoKkHVo+/qt?=
 =?us-ascii?Q?M+UHsR3a16Q+07HOuZfBjggEfC2+hhR9gCaTfZ3j6N/pj/sVxpAfIOv/Jor3?=
 =?us-ascii?Q?mgUZ5EbndmVvHrMWnV/4I7s77bZNqkcQQ24GWmWd8JmcU4yD0hy/ZBhIh3f7?=
 =?us-ascii?Q?XF1l/ZiE7hR4l7hIksIDa3krnzZdaDD9asPxdxMoN5HmNJoYxk1eiCru0zRg?=
 =?us-ascii?Q?N/Js3ZmRwov8Sl0iLTnM+CtokIopziZGnR5WwmkNfT0P3B9ewLWeYkGUl2RT?=
 =?us-ascii?Q?JItWMUsevce+74hCphNnJ9/oQYU+P43EDmViV7UMUdY5tuUzy5hDU3w1fgWO?=
 =?us-ascii?Q?2N0lbEJMqTzLygi9/iYCyzcLYRReh9TOcaBDhX2qrOxzBhLeRfU2irNG0OHN?=
 =?us-ascii?Q?nKT9EDQKX2ipFnWGwY7q1obroXuMiMHQNfG+owc75P6dBwgmtST/tku1mBPQ?=
 =?us-ascii?Q?sfeRS4phPm6f8lETwSNfWwzD4/nSZ5AB6fL1R87YHes0DraUaNz2/RsuTpHV?=
 =?us-ascii?Q?Hah+rM7G4qxOrxg/HjxBplOeSL5TlR8QA0b3xxrqxM9YQdIyMrJs3qGNNB6i?=
 =?us-ascii?Q?UA5jPJyQNFwRHEfYfusjj17IvTVevP2ZsZSRZlfOJ33IbJgNWIgG0aCZry7u?=
 =?us-ascii?Q?jQfJ44pvuyHRFQRP//WlCu+s7oGa3NDl8TOmeRr0YlN8EaMAsOmqs8H3b0S8?=
 =?us-ascii?Q?EqhsZH4Ml8HeuMh3f3/EwCRrkDVQVSIvw9QQVl8T0WRcYN1SvMS5yJtoyPD4?=
 =?us-ascii?Q?nUHCv2DmtFDyPZ5S1TLeT5oEKslChS5scXzedm41FLtG1zmGQECxfFWTTQaP?=
 =?us-ascii?Q?384AUJ8rWJ7H+p+DnPxFtrALp2xd5+zolATi31ycVekBVN+mfv+HE6E0hq7U?=
 =?us-ascii?Q?dCqLGO0s1xkZHgibJWfiOjbJbdJOwIwa+3UPzbSq3ha5+aDUa2PTEzoUzjUS?=
 =?us-ascii?Q?UuAgg+DXdMyk78JNk2RZprl3ApIOm973wNHDbbMu0ixWVKZljI7sTod5YPc0?=
 =?us-ascii?Q?YzgMMNeioPHie/Z7MSPyOR6sRUyMfN67swJy+ONE/HUK+kGITZ1i02Rj7/Pm?=
 =?us-ascii?Q?9ums9HfLA85UYlHofR6A8X0wt5PGmlOwriQoPAqln2VzJHe/B2+SVlZEamVA?=
 =?us-ascii?Q?Fb5kFajmilDRGplBISCMuZBzlKyG02aRU9eqVGiczJH4cQYQscBPZG8T8hx/?=
 =?us-ascii?Q?Q4YMtboh47ZM3mqFRSUq8O0OMpdAlZ9xTu3Vqri2448am3CIsBcABEJo53EI?=
 =?us-ascii?Q?wDl+gS9l2E9ZSUOmZOdb2LpyAWbG/CHuefguT6unnbBB4G/P+vVGwZrZ5qwX?=
 =?us-ascii?Q?SZtPjCNAGZI4PAnf1lSFAufZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c246e2f-8088-4ec9-bd16-08d94c2b4f1b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 09:38:34.9475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nN0LUQUFM7ETSSHrTriQmsiscrEfCqGHh591y7EEQwoaqIXiuSykvw5woiAKncbN0iK9hW7XAAp1zPgJsv/pXYpfp/RET4HdsJhv9FnxO9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1888
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107210053
X-Proofpoint-GUID: Dj5J8d2_pmgCSRlBUxNgMYAgr0SYlf-I
X-Proofpoint-ORIG-GUID: Dj5J8d2_pmgCSRlBUxNgMYAgr0SYlf-I
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

url:    https://github.com/0day-ci/linux/commits/John-Fastabend/sockmap-fixes-picked-up-by-stress-tests/20210720-144138
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
config: i386-randconfig-m021-20210720 (attached as .config)
compiler: gcc-10 (Ubuntu 10.3.0-1ubuntu1~20.04) 10.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
net/core/skmsg.c:627 sk_psock_backlog() error: uninitialized symbol 'skb'.
net/core/skmsg.c:639 sk_psock_backlog() error: uninitialized symbol 'off'.
net/core/skmsg.c:640 sk_psock_backlog() error: uninitialized symbol 'len'.

vim +/skb +627 net/core/skmsg.c

604326b41a6fb9 Daniel Borkmann 2018-10-13  609  static void sk_psock_backlog(struct work_struct *work)
604326b41a6fb9 Daniel Borkmann 2018-10-13  610  {
604326b41a6fb9 Daniel Borkmann 2018-10-13  611  	struct sk_psock *psock = container_of(work, struct sk_psock, work);
604326b41a6fb9 Daniel Borkmann 2018-10-13  612  	struct sk_psock_work_state *state = &psock->work_state;
604326b41a6fb9 Daniel Borkmann 2018-10-13  613  	struct sk_buff *skb;
604326b41a6fb9 Daniel Borkmann 2018-10-13  614  	bool ingress;
604326b41a6fb9 Daniel Borkmann 2018-10-13  615  	u32 len, off;
604326b41a6fb9 Daniel Borkmann 2018-10-13  616  	int ret;
604326b41a6fb9 Daniel Borkmann 2018-10-13  617  
799aa7f98d53e0 Cong Wang       2021-03-30  618  	mutex_lock(&psock->work_mutex);
d1f6b1c794e27f John Fastabend  2021-07-19  619  	if (unlikely(state->skb)) {
d1f6b1c794e27f John Fastabend  2021-07-19  620  		spin_lock_bh(&psock->ingress_lock);
604326b41a6fb9 Daniel Borkmann 2018-10-13  621  		skb = state->skb;
604326b41a6fb9 Daniel Borkmann 2018-10-13  622  		len = state->len;
604326b41a6fb9 Daniel Borkmann 2018-10-13  623  		off = state->off;
604326b41a6fb9 Daniel Borkmann 2018-10-13  624  		state->skb = NULL;
d1f6b1c794e27f John Fastabend  2021-07-19  625  		spin_unlock_bh(&psock->ingress_lock);
604326b41a6fb9 Daniel Borkmann 2018-10-13  626  	}

skb uninitialized on else path.

d1f6b1c794e27f John Fastabend  2021-07-19 @627  	if (skb)
d1f6b1c794e27f John Fastabend  2021-07-19  628  		goto start;
604326b41a6fb9 Daniel Borkmann 2018-10-13  629  
604326b41a6fb9 Daniel Borkmann 2018-10-13  630  	while ((skb = skb_dequeue(&psock->ingress_skb))) {
604326b41a6fb9 Daniel Borkmann 2018-10-13  631  		len = skb->len;
604326b41a6fb9 Daniel Borkmann 2018-10-13  632  		off = 0;
604326b41a6fb9 Daniel Borkmann 2018-10-13  633  start:
e3526bb92a2084 Cong Wang       2021-02-23  634  		ingress = skb_bpf_ingress(skb);
e3526bb92a2084 Cong Wang       2021-02-23  635  		skb_bpf_redirect_clear(skb);
604326b41a6fb9 Daniel Borkmann 2018-10-13  636  		do {
604326b41a6fb9 Daniel Borkmann 2018-10-13  637  			ret = -EIO;
799aa7f98d53e0 Cong Wang       2021-03-30  638  			if (!sock_flag(psock->sk, SOCK_DEAD))
604326b41a6fb9 Daniel Borkmann 2018-10-13 @639  				ret = sk_psock_handle_skb(psock, skb, off,
604326b41a6fb9 Daniel Borkmann 2018-10-13 @640  							  len, ingress);
604326b41a6fb9 Daniel Borkmann 2018-10-13  641  			if (ret <= 0) {
604326b41a6fb9 Daniel Borkmann 2018-10-13  642  				if (ret == -EAGAIN) {
d1f6b1c794e27f John Fastabend  2021-07-19  643  					sk_psock_skb_state(psock, state, skb,
d1f6b1c794e27f John Fastabend  2021-07-19  644  							   len, off);
604326b41a6fb9 Daniel Borkmann 2018-10-13  645  					goto end;
604326b41a6fb9 Daniel Borkmann 2018-10-13  646  				}
604326b41a6fb9 Daniel Borkmann 2018-10-13  647  				/* Hard errors break pipe and stop xmit. */
604326b41a6fb9 Daniel Borkmann 2018-10-13  648  				sk_psock_report_error(psock, ret ? -ret : EPIPE);
604326b41a6fb9 Daniel Borkmann 2018-10-13  649  				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
781dd0431eb549 Cong Wang       2021-06-14  650  				sock_drop(psock->sk, skb);
604326b41a6fb9 Daniel Borkmann 2018-10-13  651  				goto end;
604326b41a6fb9 Daniel Borkmann 2018-10-13  652  			}
604326b41a6fb9 Daniel Borkmann 2018-10-13  653  			off += ret;
604326b41a6fb9 Daniel Borkmann 2018-10-13  654  			len -= ret;
604326b41a6fb9 Daniel Borkmann 2018-10-13  655  		} while (len);
604326b41a6fb9 Daniel Borkmann 2018-10-13  656  
604326b41a6fb9 Daniel Borkmann 2018-10-13  657  		if (!ingress)
604326b41a6fb9 Daniel Borkmann 2018-10-13  658  			kfree_skb(skb);
604326b41a6fb9 Daniel Borkmann 2018-10-13  659  	}
604326b41a6fb9 Daniel Borkmann 2018-10-13  660  end:
799aa7f98d53e0 Cong Wang       2021-03-30  661  	mutex_unlock(&psock->work_mutex);
604326b41a6fb9 Daniel Borkmann 2018-10-13  662  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

