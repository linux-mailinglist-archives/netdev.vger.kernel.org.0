Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E42D4160E8
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241590AbhIWOVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:21:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37012 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241308AbhIWOVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:21:48 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18NDsgB7017225;
        Thu, 23 Sep 2021 14:20:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=NzrOdwgsCJa7g0f6ayDbMxrby5Q4yzz38uLFAou4z6k=;
 b=PwPgrZRQZBMz7NObk8Ht0ly/QI/bMUzuhNuQIpx1YaNnLGxON/gceF3A8AXHA4Tp0Hyr
 HN4Lb9F9gxeEQs1N4vF/HoYyen5Q9xLA4RugC8VmS2U9nTmKNplRRVbsZRZMMZ/DbwEj
 4MhoSvg+kLL/yc30haZXIytLaLjRhacHs8gVw9rqBNIcWVrLvjwJWkhGj4pwTv8ZyNDb
 MvMIb3iNFL82nF0wX1KN769ZtRD2bwC+1TsRjM7nQ4QFmmR0lXLjeXd+6UFI8hP/AGs9
 EJwjYLXJEch+oHGNStkpAoee9nsoZC68G7K+44JjVvX8JyS8+Snn/zail36zATQo6O7I Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b8n2v2fss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 14:20:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18NEFPv8186425;
        Thu, 23 Sep 2021 14:20:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3020.oracle.com with ESMTP id 3b7q5ca0g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 14:20:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXddK8NbaR9pHrvS9gC+SiQSgWXJos+R7K/veLyxkD755vg39gf8KQ4GBGzb1EKpYqDcrHPXbpHCWnzlkhXyFYEgh9L9Jv90RNUcVY0V/N+jK20g4yTVLT08tYrRpQt7I65mR40xaT4tESJSo1g+licrBokJTsh4d7Nw+Ktg4bxurfKEvDcHzqV7hQK00CYtuNCg+3XdzGVZCdWuXL4NHby6RM0NUnBp+axlw3NmI1/dOzba9gNdFAsCXEuCbdilIoxu7GWntEPVqXTGsTvkF9WmvAk289BUDoYTAkBf1chWTp5SroieiipdzP61e6h/WKKCBggF7BZVMCEdFSeQlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NzrOdwgsCJa7g0f6ayDbMxrby5Q4yzz38uLFAou4z6k=;
 b=FWEO+NjBR2CKt9IB2AbX4lHaPpNI5kku8TYfjgHEG0n2WpwT7VOxCyw5NRjST7DQZdFFMcIBuXAZdBmCb8/efrh/ULxxP4EzEjLKIsbLwHgM6/QM7tgIlNbdY2NGl9eSwCZ+46Osw1ebaPLg0GBEEnMeaKGmkjIf3/qbr7t8ft6XVvZdfbUnynVfNQzLwLhlq9/NN/xqRH2TUV/aPFFoYw94txOh7Vzfmy8OToZ8PP5vT68w1KmTocXCGluqsIHLZGqFRXcBbUeR2BbT0Ph2u69AvLzbuWANBi5h13XnUkWYiIdP3WqcCp6RhGW4MxoCsLUYWJtGtfUBT1/8ynu/cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzrOdwgsCJa7g0f6ayDbMxrby5Q4yzz38uLFAou4z6k=;
 b=JMHv1j0E+oIQwpTHAvFeDILpcO6yHauKbsbza81NH1TnAS9nq9IvOIYw6qLXs3SI/TfAVfn0fx7LECRHiuSH31maV5btTllWzqInQa0+f+o6w9rtMi/3iVtmkYQG52LJ5O/7EtV7GFcxg76LQ3k3wViaGHSK++68uZFx136TJ9A=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2127.namprd10.prod.outlook.com
 (2603:10b6:301:33::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 14:20:02 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 14:20:02 +0000
Date:   Thu, 23 Sep 2021 17:19:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     syzbot <syzbot+263a248eec3e875baa7b@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING in mptcp_sendmsg_frag
Message-ID: <20210923141942.GD2048@kadam>
References: <00000000000015991c05cc43a736@google.com>
 <7de92627f85522bf5640defe16eee6c8825f5c55.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7de92627f85522bf5640defe16eee6c8825f5c55.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0035.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::19)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0035.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Thu, 23 Sep 2021 14:19:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91468d11-f701-4bcc-087f-08d97e9d3b7e
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2127:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2127AE7DE3BA0C2F5231C8128EA39@MWHPR1001MB2127.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VDvp/Y7XgLPpu/uEqREHTyhuzAE83RIyItRqerKmNBILD376K7UnTfLWPDBYxr4+xNANxELE9aJ3bs8KRpGEeUvbNzMHaM/zTk/syQu83YgIk88Fvlz4u/ns2Ma8QaeGQQ2gQVJ3jd7yJctLdoTw6nEy4WR1BURM1+eSo1FKLCg3X1wwSx/pi6ttEu1TzKf7HFahPR4QL9weVrez99mo72It4sOaRZZ0HIp8E20IF7eBOgtSlW50LKvtC0a0aeh32/ShjlpxfN9+iIynchvf2kOJB+U46WsDhekgrliG/pjHIhsbWO3UDx/anDXRZ20USnfdzJkav906hk8GpbuaqSbOr2v8EUZczk4DcNyCUrc+83CkIjYMAKXb/1iGbtTkaxKIrFqZZOk+Mp+gj5r9tsTg3gGPD5lIKZgpkFfodWZsiylsYuCqbvEE5jly50rhxx6iiD5e9L5CQkWsh/rDX7bsEgjKrd1XGtO2J7HPhdQnCXHObzBJcxdbKs7Hge6LpVn6tG99ORNBp5XRWWc2PP59+zmkkgsW/jrX5saiM+fxSfMLUS4CWIv/T5HMUvul8Xv0E1+wFIg9jB2fdmus/8zGhhSpEfDDdhp+KGSaLXRV8bytFonXWqtnmMDg2reofVIdtfPk9PaCRLbwRQrVRs+uhKBTsbVrVMCP3cIH4uUCkr2bP+LXfEtcp4VL8bjTrm+6a+/mwy+NlIHgGexdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(7416002)(508600001)(9686003)(8676002)(6916009)(2906002)(6496006)(26005)(956004)(8936002)(4744005)(5660300002)(86362001)(44832011)(66476007)(6666004)(1076003)(83380400001)(66946007)(33656002)(66556008)(52116002)(316002)(55016002)(9576002)(33716001)(186003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uItv1dhEjjl1VMJMQYwf/s/Dp+/FuF76epzdR/7+wuI4/1fq0inT3BBUwcYl?=
 =?us-ascii?Q?XhiwmpQF6h3A9pAkpyfU0ndaFVS84EdiFPKjSMWM7SmKh5Vrsyhpe44a3Y6a?=
 =?us-ascii?Q?P4kQe7g2uPZwPuQ0F3hTwhIWVKEq7wKdUm/ZUXpnZGidUgf0+lD7V9tRrh8I?=
 =?us-ascii?Q?kqeVg3Yy0jR83u6WWDpGHLEmTRQaTmdtGshR6alywOjNubvJyq0NNIV1kwy2?=
 =?us-ascii?Q?Jtw5hDx1SjszcE78GqHR3hQ0WmfmU9qiqIoxExtDH/QQmWGnr5ZrgOPcq0Jd?=
 =?us-ascii?Q?I7lY6L6Md5gdNByWbasNvQonKDMG36QexdT1CPjs3UK11oqYQ6xwRHcyyNsN?=
 =?us-ascii?Q?KWuBsiF7UBaSu8SwlmaRaAuRflPQPStJCwhyEuSPeA7prsUwLg4oB/O892/1?=
 =?us-ascii?Q?LZW+sV3bbyBcyo6N+XR+6n0Knji6PhapjOn6aT94A95jnhIGGn84e8QyabOG?=
 =?us-ascii?Q?yPf4MuOntuG1BkVwq1+7rVQxsTFwCNmkiuxRHMnRqgid3CuolNo0jHD7YdIT?=
 =?us-ascii?Q?bwPe7vwEdS9KDNP8GZc9T3dWuvQCo0HPKuS/NGqQJgeZ6Y26OGw4H5Ffpk2f?=
 =?us-ascii?Q?IjstGIDMks5U2+zIrL6s4HbVb6lPfdgSwxW/Rm+uofUgfQARtriGbus+/W8Y?=
 =?us-ascii?Q?KswcD+MJXGbLBUAHMVDeo6VuDMgGIvjHkF979chIjC8Rhl2GxOdHk7incEnd?=
 =?us-ascii?Q?K0k7q/XdWTnpchwC4nzxMD1o7G+6hDsV9ZiB43ArkzLUzWU6AgEpLBm3L6fv?=
 =?us-ascii?Q?ziJqZYkyA/KWkWMxHRUwcF/qAGX/BBoieI+9qsmbKR7pqHdzINCwfvbGaC0s?=
 =?us-ascii?Q?NpDi/o0eL7/zfwie587cABDBdfnGTnpy+SfXjO9Yub7ineh5c5kQ7wfTr1nr?=
 =?us-ascii?Q?9j2tQlHmnOy72FMBXuvPCcUtP8hupOsv9oCs70qZAd6W5YN/W/4KnCPvjuL0?=
 =?us-ascii?Q?820lWG1LRk6ifpkBVYmZU4iV4f5aE3nxejTdzmMMeWMPATPE9BK8fzAK5qKK?=
 =?us-ascii?Q?cg9SJws+7ML+QORbmFxkGxLtdPcH27Un25tIsP1t+SwDwNBtopvQMSiBT7AJ?=
 =?us-ascii?Q?wOn3JfDl8oQjOqt6wkSig+m8zLACZ+hT2dzQPEoSv4o7JjmEljcBKp8c3GhZ?=
 =?us-ascii?Q?Ao7jEaD/zAzLZNXdrkZoMf7dvmnoUnGYbgeTn1afK9tPjlyrHcs60llWQFpk?=
 =?us-ascii?Q?6bRPoK2qjbltGxXLWJE7R+8HoWY8h7mdpIofMKBkRI1/w6Z+cG28N0FE0JAU?=
 =?us-ascii?Q?D+LPQzQ3QZnDcCvcrQ9UbDY4a2MnlS60f5qjU+whta1bLrHZ1gfP9Ndtxp6z?=
 =?us-ascii?Q?zc4PW2y/ww0ekMFVvzG3w+Wb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91468d11-f701-4bcc-087f-08d97e9d3b7e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 14:20:02.5814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hHpbnB6XUIvTsktqMnoeYI+ddtVFVuhnPHWjt7YGebtdTMTyvyUW27lenzs8WgAr/XAG7PNTGCKVPdR41NQ18agPp8Ddgeq7r4mEM6pV518=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2127
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10115 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=945 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109230090
X-Proofpoint-GUID: 93VYmQvZhiRYEa1fHykcqNCRxSeXVWI1
X-Proofpoint-ORIG-GUID: 93VYmQvZhiRYEa1fHykcqNCRxSeXVWI1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 12:32:56PM +0200, Paolo Abeni wrote:
> 
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
> The debug code helped a bit. It looks like we have singed/unsigned
> comparisons issue

There should be a static checker warning for these.  I have created one
in response to your email.  It turns out there are a couple other
instances of this bug in the same file.

net/mptcp/protocol.c:479 mptcp_subflow_could_cleanup() warn: unsigned subtraction: '(null)' use '!='
net/mptcp/protocol.c:909 mptcp_frag_can_collapse_to() warn: unsigned subtraction: 'pfrag->size - pfrag->offset' use '!='
net/mptcp/protocol.c:1319 mptcp_sendmsg_frag() warn: unsigned subtraction: 'info->size_goal - skb->len' use '!='

regards,
dan carpenter

