Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5545466949
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 18:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353731AbhLBRoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 12:44:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236969AbhLBRoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 12:44:06 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2E5cmk001121;
        Thu, 2 Dec 2021 09:40:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rZji21vlj8WfJJqsyzR1k1brFm2xXDd8Xueesz0kxYE=;
 b=F1eVX/YGa1h6NmH/lePbrTSRURXqo4k54L3ZIbTNQhqnZpTvmD1W/pUFr0Jjgq55w3Ki
 FweDbqx/6SakaCBAyYOAZEamikBoX3+lhlTC++UaGq+0lhpPszaJC0GjZMnx3EUFjGVL
 hKR1gLIRURnrI4Fum5LxzJpBACC+OHWJDQw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cpjn5x22n-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 Dec 2021 09:40:36 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 09:40:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDUGZHmZMN0yoIhtlzQCN3ESI0lqV+e8djv7OuwhowDtij8wmqCEURSPXKQhBNfgC6MjN3YQRPuK02xx+fTTY0E74H2ZYWO3qxRZyhFVnSNI3Byp5eth3SNzQF1eugyVwPzDLJJoKIzSkiTJbx2HN8kmvKR90dce1kSRsmRRxzryggG63oU+K557CS/0BBwvLe8/jKR35gnQ89Q/eq8f4qJk0heApIWfrWTCWhKHgp1734Jq+uBQoTPKjNpg+K4HFpFKVcxvuJKQ5+gnxDmzb5KjnQ4V4rM0GMNwgI0f26po+MNkbAHarHNvGSvP44vnQxlQKaYHYuB0xX0lTuqtRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZji21vlj8WfJJqsyzR1k1brFm2xXDd8Xueesz0kxYE=;
 b=HBeGLLm/89mz31veFPlI94ipRHRRGttcw4+XKZPXKUYjPg/39KastbZHzsnSe7qadnpCSSLfGrkuNX4yylYn1kWDmupA/iimJW2fmawh0FzG4/FGEFNbRzrHSBucxq3as/Po0OVqDGnTySir0eY11dR71Job3L0v2FSITbQduDZWNKVtekYA8CPj18+qVQdqwnJtDxS7a+FdfGI015Mo+imXrqWD6yFEuW6XkbDmYudrtyUyy61E+jimjnsM0lU8ZCLUNr75lnkF5Jc2DvPWHw7bb9wsjlZmHnSFNTo7aQNDDlSwddWDyRv4KSpgcJRORX60YfYSFZyY5e3zNHL3TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4402.namprd15.prod.outlook.com (2603:10b6:806:191::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 17:40:33 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4734.024; Thu, 2 Dec 2021
 17:40:33 +0000
Date:   Thu, 2 Dec 2021 09:40:29 -0800
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
Message-ID: <20211202174029.qtwtw7e2je7v3chl@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
 <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
 <c4424a7a-2ef1-6524-9b10-1e7d1f1e1fe4@gmail.com>
 <889c0306-afed-62cd-d95b-a20b8e798979@gmail.com>
 <0b92f046-5ac3-7138-2775-59fadee6e17a@gmail.com>
 <974b266e-d224-97da-708f-c4a7e7050190@gmail.com>
 <20211201215157.kgqd5attj3dytfgs@kafai-mbp.dhcp.thefacebook.com>
 <ffd25188-aa92-2d69-a749-3058d1d33bc1@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ffd25188-aa92-2d69-a749-3058d1d33bc1@gmail.com>
X-ClientProxiedBy: MW4PR04CA0066.namprd04.prod.outlook.com
 (2603:10b6:303:6b::11) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:32bf) by MW4PR04CA0066.namprd04.prod.outlook.com (2603:10b6:303:6b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 2 Dec 2021 17:40:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24336053-aaed-4fe8-f766-08d9b5bad766
X-MS-TrafficTypeDiagnostic: SA1PR15MB4402:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4402CB2374853C31A1949C01D5699@SA1PR15MB4402.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yLxa3rtjcdVgBf1pAUVM+eiZbLtdZo+HF+YN2h7CBE47reYa+pnVhEaLUE0cU/yL8TH8CTPEvTeRZtTpXNvKEyIVcbHBLAa6T0Q+1SXHL07EutjH5E539k64o9L2Y3iMSK9hyDUy7lxzZUmqAtp5Wzm4xhNTcZovc+7jKnZhYsG/SIyQFT65elZIiEc3tgydw81tmaE3MkJjbM29rzod08tVkKAIvFr+p6S6E8JP8Npo5fvHBXRJRtTzWXP0TEJLiJd74JfP7LZxPnLgw/mzqLLBF6KyMzdPfmodvV9EokR41Cy1VrZutnVX4rIoWSF9uSS65dDZ39EGPq2uFvUn6MEi/FVhfhBzBzpKZDiTexXkTfplQ/f90piifsl/qot1Od5O1rQw4WWiTGGtVlSzmtLSd/GpJqDWpQCRhhJRJAWAHkdGRab837ua/jhLfRDzAARaIHZjaXaRRwbdIOgiSRG+SZCjLusYJhA07WHKhuqLvrDPTK7HwgX2cbh7TnNqu76IbIrKUd+TlslKLSSQtexcjahDQVwNuqWlFHSLNlzdd8aoddKtd4FYrqoq8Ov0ZWG8a0H7zLGa0FNEvsyoRHEnPkuA+tl/Ozj6Smgn076XyuMWhQUHoSMfrMj4Xh3BJcvSBNb9GnnCGMUOfdKr8trDi02N6LFzl5eMAEsj9Hf3hXOk3l1KvLHl8hYth+oWeY6hQ2wQytmjMRT/T2Yn32ZSPbzay4L6lxvAm9MLQSg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6666004)(8936002)(66476007)(66556008)(186003)(38100700002)(66946007)(2906002)(9686003)(52116002)(508600001)(6916009)(53546011)(86362001)(4326008)(7416002)(7696005)(316002)(966005)(1076003)(55016003)(5660300002)(54906003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ugejHPLx5AfvInxe8NRl9O86W4Uamzkp4UxMqJAZf3VaD5xZZCRBl2XVAw0X?=
 =?us-ascii?Q?zjmj/sR7YbTubdfLrKbWSF4rFDobwBoZ2nFYZEKg/d0G0QzJRskmYPsBrODM?=
 =?us-ascii?Q?pYfIMLquxRWqB8jk0YvZEJlIfLjuEkoL/R6l6P2R/KcG4zRQc1xBkh1WMDEc?=
 =?us-ascii?Q?RczSWFYQ6T/ohh9kEL+z6zeLR96rE6bh+XVcM8yfeHRSYFfU3vv/Ypv6SRHo?=
 =?us-ascii?Q?2003oR7MSgdwWXJ8i8gZIfkhFtscXeqynoFihhQbegND4Kn3FEUmbFXtFrJt?=
 =?us-ascii?Q?iWzqpybC3cR/f4Mz5T3y3uW7dgIThb0x9bWpbYUzVydUJk81pINGpBymttC0?=
 =?us-ascii?Q?Lq0hCBkZv0yw17MWCsIyU+dlI9X0QO4MZV0KvdYp2gostnPCJNn9GDaMoD4W?=
 =?us-ascii?Q?XSvfLFsXrpCj2OJhGW2SK5vWCxeKLO2flaenPAXe+Db9mWhPEPL4xAx1zu72?=
 =?us-ascii?Q?d0yg0JKEYHKFOV9UYHAOVLr9xa10V0AjAfxFUfQ9c5z/0OMEqrkOHqYRgmsL?=
 =?us-ascii?Q?fWa5DsUcub1OZ3wicJwi+tbxcvCYJUbcJGpZkNM/Siso03TP4Tpoe6Eu8aq7?=
 =?us-ascii?Q?3S8UgX2FsnRBj4EpocnEG007qpfQSXpiYhbuaZsM2l7dD/RC9tj/06Iua+Jx?=
 =?us-ascii?Q?OVC6lWXQBWWE9hakguwiY1/dmIf9kLNws+hvJyTZFk/QzPHx7OQr1HKbKnPQ?=
 =?us-ascii?Q?TCa9EL99FnAUj3SoU3xl0gozgdi9ARKSXqE0K/n1DvEkICyi8xYRuCs7qt3J?=
 =?us-ascii?Q?S4awTtP7vx6YYM1BhDNKr3/kbQsCJX3LHR6E47oZ3b4RocAhybj12prQkVHr?=
 =?us-ascii?Q?EafGwnWwYuZiPwtu6xprFy48kw6YzFzCToogylLR8lwZ6VSiRGesKerr7yXv?=
 =?us-ascii?Q?quM4kSK7h3eXCjU3J1gRei1V5EmWjIc6d6F2kDlo4nbVKHBEOAqGhVQw8NTW?=
 =?us-ascii?Q?4L1E2jcT70/J+hJRBF5WTEM4zdXpf23mt5Ed8TdrNVZVKwcREImEGKXZhaRg?=
 =?us-ascii?Q?ouGYv6tgiNuZU5uhyrVBs0vfM/rbF25qm9sC5+fsO+/vSSsV75LH+VeAWk3H?=
 =?us-ascii?Q?rlGiDh4dK6E8Fa9pZTY5FmqmKxEKtkgR1wdPFB1tmzltAiNCIioWvfN83AFw?=
 =?us-ascii?Q?g+8tZUkEwPRx9T+jLHQIOdznRtLHGEKvLbjZQV5PL3MnjgJzNvbXdxALnfdQ?=
 =?us-ascii?Q?oS3H46QfR4+hmtV5+BtG9K8yKiarcJ2n1w75MXwLONWJjFX7imkE3tv0D6O/?=
 =?us-ascii?Q?0mr5lumsdMh8qoAwvMCZ0hcYpYxxOGI902U2yV//IeBWwvrGG7QOzWjrguKO?=
 =?us-ascii?Q?U5Z32hihayup93dY/LD2yoAJJeVxx02LYDzlXWCOlAF6vOgEDg6ck0ZVnm3j?=
 =?us-ascii?Q?Ixl9Mu4ayuPTPyNQyGXDPVjTHIGDgIMdrdUdGqIubdjlxiIoZKIoJUJpmp8l?=
 =?us-ascii?Q?1QMgjzhpcLjnM9kdEv+G9RZwBkHqzPp2aLWtoucvSe8JAzhTH0wmWUYqTsD3?=
 =?us-ascii?Q?DgX4tLVQBAmrwWygQw7NajsQL61cxIi5wji2MAbXg+j27QS/YUAVGEGV7bSB?=
 =?us-ascii?Q?/wdWZ3E63SVxZolYlUuMlTtriKtx9dUZmSUB7ci6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 24336053-aaed-4fe8-f766-08d9b5bad766
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 17:40:33.3433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffPraYHeFUzeCz3XtWiefuVAY6DfHj0cLuG2lF27+H9n/yzkogJdd4fVYLA23X1g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4402
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: MnnIWN_pujlljCEux_wuSvg342LXyX9b
X-Proofpoint-ORIG-GUID: MnnIWN_pujlljCEux_wuSvg342LXyX9b
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_12,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=547 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 03:48:14PM +0000, Pavel Begunkov wrote:
> On 12/1/21 21:51, Martin KaFai Lau wrote:
> > On Wed, Dec 01, 2021 at 08:15:28PM +0000, Pavel Begunkov wrote:
> > > On 12/1/21 19:20, David Ahern wrote:
> > > > On 12/1/21 12:11 PM, Pavel Begunkov wrote:
> > > > > btw, why a dummy device would ever go through loopback? It doesn't
> > > > > seem to make sense, though may be missing something.
> > > > 
> > > > You are sending to a local ip address, so the fib_lookup returns
> > > > RTN_LOCAL. The code makes dev_out the loopback:
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/route.c#n2773
> > > 
> > > I see, thanks. I still don't use the skb_orphan_frags_rx() hack
> > > and it doesn't go through the loopback (for my dummy tests), just
> > > dummy_xmit() and no mention of loopback in perf data, see the
> > > flamegraph. Don't know what is the catch.
> > > 
> > > I'm illiterate of the routing paths. Can it be related to
> > > the "ip route add"? How do you get an ipv4 address for the device?
> > I also bumped into the udp-connect() => ECONNREFUSED (111) error from send-zc.
> > because I assumed no server is needed by using dummy.  Then realized
> > the cover letter mentioned msg_zerocopy is used as the server.
> > Mentioning just in case someone hits it also.
> > 
> > To tx out dummy, I did:
> > #> ip a add 10.0.0.1/24 dev dummy0
> 
> Works well for me, IOW getting the same behaviour as with my
> ip route add <ip> dev dummy0
> 
> I'm curious what is the difference bw them?
No difference.  It should be the same.  The skb should still go out
of dummy (instead of lo) and then get drop/kfree.  I think
the confusion is probably from the name "<dummy_ip_addr>" which
points to the intention that the dummy0 has this ip addr
instead of dummy having a route to this ip address.
The need for running msg_zerocopy as the server also
adds to this confusion.  There should be no need for
server in dummy test.  No skb can reach the server anyway.

> 
> 
> > #> ip -4 r
> > 10.0.0.0/24 dev dummy0 proto kernel scope link src 10.0.0.1
> > 
> > #> ./send-zc -4 -D 10.0.0.(2) -t 10 udp
> > ip -s link show dev dummy0
> > 2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 65535 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
> >     link/ether 82:0f:e0:dc:f7:e6 brd ff:ff:ff:ff:ff:ff
> >     RX:    bytes packets errors dropped  missed   mcast
> >                0       0      0       0       0       0
> >     TX:    bytes packets errors dropped carrier collsns
> >     140800890299 2150397      0       0       0       0
> > 
> 
> -- 
> Pavel Begunkov
