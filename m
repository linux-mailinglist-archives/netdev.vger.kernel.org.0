Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7104658A7
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 22:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353459AbhLAVz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 16:55:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353470AbhLAVzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 16:55:40 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B1Lclvf012202;
        Wed, 1 Dec 2021 13:52:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jNlZaUQv5wEK9qoyLgp6W4H99uFEKHFZ8FsYaXzqO4c=;
 b=VdgLsAULZL+vjVw7NKRCnUiiPG3mL+UnXIvUBfUBbYjDBJZqqGjXnkillb0JI9fg6Y33
 pER7gYDVpbrCCpHAw9KFWxuA4CTYdY4YkpjcKaLcxqoCZmAL34agEUkSnMfxFJbnWRk7
 jOB8aG6iPyq63FHBkZnkfzVlq6XwLf7vnFs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cpbt4jt1r-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Dec 2021 13:52:04 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 1 Dec 2021 13:52:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUL148rCC9uNaalHVxDZjbXFIjuLqYXcsn+Zu7NaTyFYW5d6aPwagsTTlrZXvwU9TB0Y3Swy18zyzX50315CzKIPZFF3Hh8m0LDpwVZ9vAs1FYLmXlwA5bTX/m+gS87waQib9lJnLk0ZQM8UVUye4hI5Tfvdgpy3dc4wJmxYwEdgrc0dBjK2qHRh+Xln6VfP9uoGFKDhT1CEkwvz4gLn2uC+gnYzrRlUhbeW1be6RykKltL3xx0d7gIB70PT3bq1xnSEjehCXAkGqaZ2u4JJoXww7zuXMrF4xoBjA8FvmnEp/v7cTvRocjDExt5txrks4JcrH4NbKeC5aNwSipDbJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNlZaUQv5wEK9qoyLgp6W4H99uFEKHFZ8FsYaXzqO4c=;
 b=kg6oicH9SDzqz92lZlW9rZnKmXJaqfGt3SuOCQdIrpY1xggt2CdOAOVd6ONXkk2qiQO5CJSWb9z0e7n+KColmP04z/h/3WJjxQqyxtB5+AZRN6oSiWj7dByAj9C7r4edrC3F2RHkaNq1PRKXcxcvLH6XzYfxudZ3DPJSPp6rdnP/6G4JH6bJt669hg86ChROiEFxDeWaSsBsdNmL1/eYYBqEaQ8ZYHaeZ2gRytKkDS6uxhCa8nq5KcwQizSiek3jV7lX88zFdbuFQZsXDWaBK+DIk7KSvNXdamN5ndDBFCLOamNxnny3gbldpFR3wj89DoR3Z7S7vhgQFo+rJfZU5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB2191.namprd15.prod.outlook.com (2603:10b6:805:10::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Wed, 1 Dec
 2021 21:52:00 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 21:52:00 +0000
Date:   Wed, 1 Dec 2021 13:51:57 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     David Ahern <dsahern@gmail.com>, <io-uring@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC 00/12] io_uring zerocopy send
Message-ID: <20211201215157.kgqd5attj3dytfgs@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
 <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
 <c4424a7a-2ef1-6524-9b10-1e7d1f1e1fe4@gmail.com>
 <889c0306-afed-62cd-d95b-a20b8e798979@gmail.com>
 <0b92f046-5ac3-7138-2775-59fadee6e17a@gmail.com>
 <974b266e-d224-97da-708f-c4a7e7050190@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <974b266e-d224-97da-708f-c4a7e7050190@gmail.com>
X-ClientProxiedBy: MWHPR2001CA0018.namprd20.prod.outlook.com
 (2603:10b6:301:15::28) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:785f) by MWHPR2001CA0018.namprd20.prod.outlook.com (2603:10b6:301:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Wed, 1 Dec 2021 21:51:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15c79332-fce6-44bf-cb54-08d9b514cdba
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2191:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2191AB20E47D28362783F4F3D5689@SN6PR1501MB2191.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9o9WH8MqZk4tR3xFBK2uMDT2uhu+8EnVjEBAXkl8T6wxo5J3p/tK5Rho1gvmOujC/xxaOKEas2/yo2+bq0aTs7GB5FgWuojS4hUAQz7BnyfjMKkkZ1047lWklLPUOfSz6ceHWktgZlMmnqMCsnFvkLkM7IzIhoICDJ8d70d757YHQy06qv52vRnpzdSd1A9N6GQQifqbQQ2YcfLp1ZNbzNy5nGlkGe4Fas0CKLUkWV4PIKfqPugZ3Ra9WedCf8xY8kBvWnbjCddc+slDnkMQPHAY4nKot1oFsD5n+5/lX7aAsbMm2+1VcunNkOCUV1mIVhRvQ+0YxMzaOrRXncRyRiBTIU73sutCLdc18OKT8/PHi1mN+Z6KsFwFynEmqt1JXq6LrjqWHVc7/gppVgix5BZUfczvKq4+aHQ8/3IsGUOsQEj5frDuuuJ8RbOvGkWhCO9WElitk42JLEdq6SsN388XAFR91I08VWitSJ6RAQUsJAPiTlQ7yp1pPPXVdMFEnPWmc1usUpv0unF2QXVp2S3/u50lGMTTit9VM6q7g1EmQ5bfGkbY+8Qr0oXDycvttn68fj1YFU7MkXUYMIzZ/hz+JvqE5MK0oxH/GabLz9OburDt8gPTC5M5aP6AmA/POwb1TAeluZuTSgjuxXjiXDBBczXNW44roZN1Qz/UinqZ92Lp6xJoQ/gOxI2peQEqZR2hOrioot/S17zPOSi4k9t8mK9EeXw7kY8FibpxeM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(316002)(186003)(7416002)(54906003)(4326008)(55016003)(966005)(8936002)(53546011)(8676002)(66476007)(38100700002)(66556008)(508600001)(52116002)(7696005)(5660300002)(6916009)(1076003)(66946007)(6506007)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yo9dmLg5NE0L6OhGSZ38+CmV01XOLzEaCCf0d37LFH+S2qYVFT/5X2UmI0pt?=
 =?us-ascii?Q?Jub3ZI4gawbYLSDMLfcCJdAx5ykiRGiKcN3OKi32N2X1poc42Xp25rCH5HYO?=
 =?us-ascii?Q?8l1cUS/fTrdm1Sf7sno4Wpyy/QQznqYnevhsAYzlD9CG9X5LIQCNUrCb5yjs?=
 =?us-ascii?Q?s3wgZiIC7hKS1O43D5p7wCB7FeIg4aNqWTWt33nCr+ZDsBZyFXhItYPpAhL7?=
 =?us-ascii?Q?bswEjsYAHl/Rv2I+sFgULRIzuCW3f+aZ4NCd7k2Ymp/nQVL0sKJRFunYoHJ5?=
 =?us-ascii?Q?7qhf0VhPx/AyhvhKrBD4SGTKsPplYHBK/s/Cd1HsJsjpwsh1PzVxrDdjZw+7?=
 =?us-ascii?Q?HH5CmQEFK1hwMtHvEATMqPGmq7Sai1SdCtdFU5Uets75TZCM4Zba+IF+35VT?=
 =?us-ascii?Q?qTE1Ug1toU6zfHSVRDZJW4XxWJw3Piy3ZGs6itm5r+IAEUOgAmjhxkGnCyt3?=
 =?us-ascii?Q?FgFuHyx+S3wexWqG3rJh4McebIkU3f6C2+hlhRJn1oOnzHzmuWMMa3sDv9pW?=
 =?us-ascii?Q?tjLYY4yPm+xscT1yM8tOKFJGQ3Nh/eEDVmiTqdyQbY/y8m7MzQ2ejIpRLYj7?=
 =?us-ascii?Q?xTsy2LC/HKFWAwzEzL116UWgFoisIro4LMqP7P099XPN2u65H+yLCAN0EfMy?=
 =?us-ascii?Q?0wNI6IEa8p9Gzc/4NIYX/9j+BPd4EnDOTnJRNt5JN++tJNkMYUooNEP3KcNu?=
 =?us-ascii?Q?fcgKNNmCM7YTgVMgdYq5vr0ItE3bIrycs/oFAVu/m+leUXjQqGGdjcL5LcMQ?=
 =?us-ascii?Q?PGRMKKLvIISTVBWm4K2sPqQlpVB42fuV3qVtKVZ67c4rRgeDn95nEf9eUVsi?=
 =?us-ascii?Q?cWJtt4vu+bRLNOQleNByZiX+jbqLG/jJxvzjjtEc6GhyEe/IR8AHKZ9lUPIA?=
 =?us-ascii?Q?kHq49xYO+68dcn5szyHztvTesgBtwK49CTn6Wm1O8ewtIkR3PSlQXMy5iihH?=
 =?us-ascii?Q?c1ISwSwU7/Qv9rCYTfzgw+K2BS/1p1PGuXTlVt44okNyGPZMgMN2I9VUeOUc?=
 =?us-ascii?Q?rLcZhiYWjq875BEx16xSjkI57diuS0+Yp9vNg6YTJnvkj6E8bAP74cAqD8LS?=
 =?us-ascii?Q?tUkBHpQlhSCdeYmTg4gQILwTeU3esWhR5nXebYaEOESx7voHHPFsCjrUyWxm?=
 =?us-ascii?Q?IXAwPusrXSsi9WSzepucSsI5hauJmMwSXZ+aBZ5T5/3Y1Iv50HeG7zUxMrcJ?=
 =?us-ascii?Q?LTD9vftabBW+RcM6MQX9owj+BgR74zmhRH7AV64yZWJrx4aIgFt3YpuOrJfA?=
 =?us-ascii?Q?MCtTU/KU6iwgnZp4pJlp3G/dwdXE7FSQzTQiFBKUvyCH7RAeIzo64RK1XPMx?=
 =?us-ascii?Q?Vs5ipN3nMtg2nLpQCd/yl6Mc7hSCOLZf/FalIk+GMeTW+Q60NkW03Mur5qQN?=
 =?us-ascii?Q?oNaUTmj0VkP/9Ozc1oOKMJBTQxFiQOQyAh6EiBSSpajkdY6sIZZjWGL1+lo0?=
 =?us-ascii?Q?PHYAPsfYPBn/N46njm3fc25W9Zhqafjbk8wW9jd3kVpamaK1yOBGBtOtp2Kr?=
 =?us-ascii?Q?GVk5rtY6dy4Z7ujXLPyviV+sPMT6T6vL2P0ZaLnkBldJb8jIw1OdUd9tVLU5?=
 =?us-ascii?Q?wa01ArnRoLVy4duiwDzZnvx6igapJqp/MEF9bZ/U?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c79332-fce6-44bf-cb54-08d9b514cdba
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 21:52:00.8027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sVC1wiQ9yLZK+I8d4Up/WeDQp1B4R8jvaTPUSpfQTme2m3jBF1YdcF3ttOqmpzHr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2191
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: fYCd2844CT5bQ7bsFWAJ8tV3eJWDwGM8
X-Proofpoint-ORIG-GUID: fYCd2844CT5bQ7bsFWAJ8tV3eJWDwGM8
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-12-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 clxscore=1011 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=494 adultscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 08:15:28PM +0000, Pavel Begunkov wrote:
> On 12/1/21 19:20, David Ahern wrote:
> > On 12/1/21 12:11 PM, Pavel Begunkov wrote:
> > > btw, why a dummy device would ever go through loopback? It doesn't
> > > seem to make sense, though may be missing something.
> > 
> > You are sending to a local ip address, so the fib_lookup returns
> > RTN_LOCAL. The code makes dev_out the loopback:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/route.c#n2773
> 
> I see, thanks. I still don't use the skb_orphan_frags_rx() hack
> and it doesn't go through the loopback (for my dummy tests), just
> dummy_xmit() and no mention of loopback in perf data, see the
> flamegraph. Don't know what is the catch.
> 
> I'm illiterate of the routing paths. Can it be related to
> the "ip route add"? How do you get an ipv4 address for the device?
I also bumped into the udp-connect() => ECONNREFUSED (111) error from send-zc.
because I assumed no server is needed by using dummy.  Then realized
the cover letter mentioned msg_zerocopy is used as the server.
Mentioning just in case someone hits it also.

To tx out dummy, I did:
#> ip a add 10.0.0.1/24 dev dummy0

#> ip -4 r
10.0.0.0/24 dev dummy0 proto kernel scope link src 10.0.0.1

#> ./send-zc -4 -D 10.0.0.(2) -t 10 udp
ip -s link show dev dummy0
2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 65535 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
   link/ether 82:0f:e0:dc:f7:e6 brd ff:ff:ff:ff:ff:ff
   RX:    bytes packets errors dropped  missed   mcast
              0       0      0       0       0       0
   TX:    bytes packets errors dropped carrier collsns
   140800890299 2150397      0       0       0       0
