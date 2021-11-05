Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E71A44633B
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 13:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhKEMUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 08:20:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56788 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231723AbhKEMUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 08:20:23 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A59xU8S020726;
        Fri, 5 Nov 2021 12:17:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=NUwmKEYEWzP0KIcRTwbdNAxXdbhVJw51E1zx6DmUaSo=;
 b=GVrWzxAoOvn4zrvNr8mHhVZrcfugjKnxoVzX8qbEOEmx+m5eEXe4wez/8hXxIwG1fGRE
 VVsSUutcW+nMFLs7KCrFX1cE2O6R3P4KmAY2jZvU+vW0S9LsX0e2Wd9l4tO/vwr2Qoe/
 4taagMfGtvFVd7OtNb0aSWKeUJp5a3/WeQ9Mxy8U/q+opJmETcuRoZSsOTM9h6sA5paK
 v+j4y/OWzn/3d1FLlv1Mja68bkosAQVlvKEsVsR5P/pPLv9lv6swdZbeGT+YqYg9fqJV
 MBBjuQMJ9KBFt/Axznld9CNAM1WEgnUOGALKMNEHpH5Fxwk3Z1zdjUfV3VN2pVavqWfh JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7q238t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 12:17:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5CB9BT129065;
        Fri, 5 Nov 2021 12:17:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 3c4t5cwg7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 12:17:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0eN3uPtWfsQodx22svktpq2H4NyY9hEAJrjtfhz87x0Bicb29YtzEU8N1eZlbWwGJDSg6VluhYUXvcmjamwfuYjLFShHzwzGSIdNltTrOlDeAMZFXJ00Fbhxuah0qS3o7bDZ//F4VFgpDTZJFatb6S3C6K+Dp9QtL1IHQNH0PJn14n4GqYhjU1I0nQoy+1HBqHnW4Yj2YyPkWs6+f2gDNr4aqvn1lIr/9oNCDy/nZrtU7bOlwPiyDXoaIImcoso9FUsbcmjTt2Ffqtsr0CCPYpk+o9QLAMXXUrH8YPWQE+Qo6ikyWzyZsA/e/BUKR9Flj1i3vrNajUMV44Q2BWQFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUwmKEYEWzP0KIcRTwbdNAxXdbhVJw51E1zx6DmUaSo=;
 b=N3OQ+xtXVs/T22Bgvi8/YrShTX0XIb5yTWD/uBQNlTn6aG2GkMWBnu4FbHFJufB9BnnvEpybuWRB8bKnI006uVrG7WTMeT+N4UIOXZVpS5pjrqtxvEjA5AMkVzhItDv4TxHNQqalp3IWsHgQFS0X2pNTAe5WT1VACiktxUXS6RzKVrOAVtVdKbU4qAYo69DwSnpD1gmvANgvCLUFpejg2LowFy1nGdltxwt4QVfhOQKisQIDt7R43NStLwYLhwxGkoRuJIvKf0i+CA05LsGcprHjDVsVeXG2vHXfOj6Aa1smcOVDbM5BKXBKBDsqPy/MvNvpLr8bX0HYB/33LX03oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUwmKEYEWzP0KIcRTwbdNAxXdbhVJw51E1zx6DmUaSo=;
 b=lEsKPB/jmX9fEWJsgdEwju6V6YORCs3KljeCsRU0/ySFhLM7HJyyA59pJKB4A4rue8iRasJyXnFQfTQZ759sAmhRu9zLikneyZ5O/LfNuVr16B98zclqlemKcksLNtZvAgrD6C4DfqT6xdxF2Cm4DuksSj7HV8qQ0BkM4t1WBWI=
Authentication-Results: connect.ust.hk; dkim=none (message not signed)
 header.d=none;connect.ust.hk; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1662.namprd10.prod.outlook.com
 (2603:10b6:301:a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 5 Nov
 2021 12:17:31 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4669.011; Fri, 5 Nov 2021
 12:17:31 +0000
Date:   Fri, 5 Nov 2021 15:17:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     YE Chengfeng <cyeaa@connect.ust.hk>
Cc:     "krzysztof.kozlowski@canonical.com" 
        <krzysztof.kozlowski@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wengjianfeng@yulong.com" <wengjianfeng@yulong.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfc: pn533: suspected double free when
 pn533_fill_fragment_skbs() return value <= 0
Message-ID: <20211105121715.GB2026@kadam>
References: <TYCP286MB1188FA6BE2735C22AA9C473E8A8E9@TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCP286MB1188FA6BE2735C22AA9C473E8A8E9@TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0009.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::21)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JN2P275CA0009.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 12:17:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbd4c891-37b0-46a0-2a1e-08d9a0563d4c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1662:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1662013C7D131DB5E9674E5B8E8E9@MWHPR10MB1662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPV61EKtOF3TjkVTHPq++1YfiBVAN95frvyy4PD6gmc3Vtf0BJMfd+Uu5Wyoy6pkLaQP4LxSZYNsIxN1Cx7f/sWF5f75+UjoV0p5wIGQy5nOP0eUxo/cVVccdoo7ETz98GLobQNMkGm00HFKNTLLn4PmGEsk5y3NYvSPC6v/HXWx/lDRyMan5f5tEHOfqt8VZBd1qa/BwprhzSBC7jsfatm3NexrWnUneUAR/5+kUbyJ+/NNf0Wdl/Jpd7OBtMcCa/L2Xzzz1AMCtXINCkTFdmCYmP9LTYZ/vHYf+/n1F7+ew7LbHS7PeWUEEmohj0vzKLW9OIIk8oHx3chudk0WJRqVFhPmpXiLSWuQCqPfvmX6VpWt9oyawzS3l7xFNWWZd0bYaGsxQ7jYf32JYq0s6GtoU5bvG4DRcXr5Wl4b8gYiFeIcihMxI1VztdYykoUX7WfGB/2xC5yztj5T070b7LqUiBl6hYtmwF26EDmYSVxLc3k1qU23vdcOx2Qo0DkY45HDOlTyvxhJ4N1mkAzLue5NdJTvXA9Rdxn4tCrH+t0bxm7s2yS/XGH/T+JAs9WdDXeLxRP9tkc3ke3DdxefExBK9hqpQL6blcI8yYtCH9dFS0NCKbvzLKhEBW2a77rsM6qyDIxAxiZvmKrjzAAafqxxJd/iJpLvRTSZ2h6iAM9ej8yoJ8Sq4BUPGQGIQNJnlbGP//R+sC49siuZRABQMfqMYe3UdpI/+fOeskjeCFRN6achSAICOKx680Y4R+pvce+ZCcczid7WWCtz7VVCrb35U1JHyHiEmskVzbqfGIY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(54906003)(1076003)(296002)(33716001)(966005)(8936002)(33656002)(956004)(9686003)(44832011)(83380400001)(55016002)(186003)(508600001)(4326008)(6666004)(38100700002)(5660300002)(316002)(66946007)(26005)(2906002)(38350700002)(6916009)(8676002)(52116002)(6496006)(66556008)(66476007)(9576002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0CcYNfWwLzJpxWN4x4Z3B6GnsGqTBSAGjtXlhiX5NLR1IhbiXeqthwwAD7vj?=
 =?us-ascii?Q?i5+Pz4i9VeKJzRRF63ChN3StqGBnPHR5szwyWMh+c3Y7j4k8436hrtdnjqQ9?=
 =?us-ascii?Q?JmZ9z0azxXwBvQJjkMJN/w9Vp0Nuv/YeH9eOHSJcuxQvDAmfXSXD18fMp8Xq?=
 =?us-ascii?Q?6bu2bG9aoJlJsHPSy4c46CA56Igo13CrmdZgMk5WuV7tVCZNFWameDFB+pIS?=
 =?us-ascii?Q?Dj0oK6j09jc3J1QixgSPLWA1QUE7gv7KvV1edzI+Bc1xTKztf/KuFJGR3x9f?=
 =?us-ascii?Q?5D6fec99eSbYBE7Ii4ljQAJjziTFLlBBHukFs5N18NsmNduvskSWNKvUNZkD?=
 =?us-ascii?Q?uX/TrgyQSI91VeFol6vlzHb4uRYHrIAeGXmnDMehgMq3Grl07IzK6HhTo6IT?=
 =?us-ascii?Q?GNk0D/76o73AeWXsV1QbpvCuoIjS4d0gh50SXPFA9FmVu9XRuBWJckvYiaSm?=
 =?us-ascii?Q?ZNSJCy+hbB+dyjesq8Vc0hY2GJtvsCNamQ/FHy+y3G/Q+2OuRSN/uc639n1w?=
 =?us-ascii?Q?lD61jiM6VetrGeKpItx6Gd+vNF7DcmZybGFPnLkREHkfz+QXvxOygKdTj5Fh?=
 =?us-ascii?Q?V4OmI5ifJry0r0bYBs43voTvovdX1+G81qMItKw5SxGdnFGAgzVyo3zm6tYG?=
 =?us-ascii?Q?ZVO7vBrYmJghz7OLV6hm+lkLl/+a7FwIvN1AvLTkAj0HtJiXg6DKZZ9tXJSB?=
 =?us-ascii?Q?hrfB76yGKLaUvwQfBO9muqzMxXe0qPQpNmmUcSfeuhAKkHky4cmzasDR1+85?=
 =?us-ascii?Q?q9zU+Dj1ye5qwfzaB4bbpRreqhUCxbBlKZAmESQj9hlt26LzlbWyVjizbtUQ?=
 =?us-ascii?Q?lMKGryvDR+nummMuuCS0AUdNShsjTfrh8KXo0hN6g3woPVg27Elw7r/xTmdu?=
 =?us-ascii?Q?ipecFt9frnZbkbouOzUj33n0qQKRsFeiMZmqn5AeFLkI9v2KJlAodLm4JIbM?=
 =?us-ascii?Q?4PoA8cyvz68lqSFkFvUy5MEYAigrNI4XgjYyBL+RJLlhcgT+CXjmGxXzJqek?=
 =?us-ascii?Q?IA4YhLQBwAUWKFIPazwtqOSY0ZaYl7SPMO/65zGLmTtm4DHLdudSQM14NyQh?=
 =?us-ascii?Q?YkzeiSpa9nbNmfNwI4YHsSTiJ6TNPMF8TzsGPZf7eeQ01v5yzWNi7D9a1USY?=
 =?us-ascii?Q?EJDr1IV97Y1aZPf66auv0mZKaM/PGfswWD74TS+DtrFcilk23jMHj7OwDyN7?=
 =?us-ascii?Q?kApDy9AJaiwJws33K5PhRbNBjVIG2XIzpT/fISDj2hi8HycPzM642Bi1VIZ5?=
 =?us-ascii?Q?ywSqN6DJKdE+x2qxQgdsUNh+36PJKUcQz6ztQJWbgHo2DI7P6vaPFmMEc7mE?=
 =?us-ascii?Q?reWp2zc8FwdswysmjqaNQvQSyGL10b+2LoVrBRQp45GLius8YxrE4RK6ekIp?=
 =?us-ascii?Q?sX5F6pFDvnpRUen+mWKv/dJqtGU/iBzRAEk2kEHKyg6wA/c/YIIfYPAl9PI6?=
 =?us-ascii?Q?5bdTeDQbhcGs2MxSZXeA9D+Rxu72OjTPsWgdWfGQoTO4DZEVeGCd5iATxYKI?=
 =?us-ascii?Q?3RZaYp0V20W9rxhevcT2jFYwcAl6vwDNR0zoZjPwiR5qa5JpCZXm9N83yqBf?=
 =?us-ascii?Q?zPmlB2mcxpsqVaHE1gbqNpMvi7D6YLYdV7XFqME/ZLip64jNlpy6SRqlbpM3?=
 =?us-ascii?Q?rqDbfQoacNL1BRo9zDjTwaPEqpHvaWHQj6eZE1MSLUEREa18r01l2y+QsEo1?=
 =?us-ascii?Q?zf+fZw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbd4c891-37b0-46a0-2a1e-08d9a0563d4c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 12:17:31.1103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jO/nkXtifxebC9vt/RNxR/KLz9rxfP8Ir3iZbq4rKPRzFnIssM0ZvcGNyN8tcQBx5FUl3nrAWxBF68nDYnmncugWQt9zAHZ00a2Bh4ypl6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1662
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050072
X-Proofpoint-GUID: EKkHVI0Xl5KDHIBq0AEXXbH9X9Dam1Jk
X-Proofpoint-ORIG-GUID: EKkHVI0Xl5KDHIBq0AEXXbH9X9Dam1Jk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 09:22:12AM +0000, YE Chengfeng wrote:
> Hi,
> 
> We notice that skb is already freed by dev_kfree_skb in
> pn533_fill_fragment_skbs, but follow error handler branch #line 2288
> and #line 2356, skb is freed again, seems like a double free issue.
> Would you like to have a look at them?
> 
> https://github.com/torvalds/linux/blob/master/drivers/nfc/pn533/pn533.c#L2288 
> 

The code is buggy, yes, but it's a bit tricky to fix.

pn533_fill_fragment_skbs() never returns error codes, it returns zero
on error.  Specifically it clears out the &dev->fragment_skb list and
then returns the length of the list "skb_queue_len(&dev->fragment_skb)"
which is now zero.

Returning success on transmit failure is fine because the network stack
thinks it was lost somewhere in the network and resends it.  But
probably it should return -ENOMEM?  But changing the return would make
the other caller into a double free now.

So probably the correct fix is to
1) Make pn533_fill_fragment_skbs() return -ENOMEM on error
2) Don't call dev_kfree_skb(skb); on error in pn533_fill_fragment_skbs().
   Only call it on the success path.
3) Change the callers to check for negatives instead of <= 0

> We will provide patch for them after confirmation.

Sounds great.  You can fix it however you want.  My ideas are a
suggestion only.

regards,
dan carpenter

