Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2991470C74
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 22:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbhLJV0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 16:26:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39030 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237368AbhLJV0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 16:26:40 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAKJEIk020070;
        Fri, 10 Dec 2021 13:22:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=1Jju8APHUk/4nOMjBVaSY1DZnMReYXqKiruNQeWfCwE=;
 b=YlQWx3Xvbs3hP8m1rhDp4lk0d/AwNHUBwHKORPlTrKdsySUOHDWrReltZG64/bZ66rSa
 hhjwb/0Nv3TgWC38a+Tpd0kUcvMNnoAqM4VOhgwIV7xXLlJ91lHHfJQ5D1mTQfeYokpN
 BtyY/fsFWfKSow0AkQ0JYR/vWnZhcaEh66o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cvd18gruj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Dec 2021 13:22:46 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 13:22:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJkXcr0pJnq77vn5Eh6Oef4IXntLZ+TMB1GMIWzbFq8UG4IAXFu0KwUxb+pTWdgviHq7dDBNd6oH9BHbuTiA6rajRkqX1D5CzM87gpHXLQMRYkm3NoCXTBKuoaC/LCo5yAN05YegJD1s4BtxAZR3ouIvCxVvV3b9tCPHm1JTJ+H+A7tOXXe57y89pkjNnDS2+plXMWHXb5GAMzyMkMHGzQNt6oq3i2Dv/HXw4ZM4OYb6wHujdqEzwbmRoRRaRgPc84b0Y9l0dbqnJmMXjGKFGAnksMoZ1vZusXoSo9qz0i8/azDJNUBxGHsBVU3ztTbrxa4RqeGt/lQKAi6C3S87Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Jju8APHUk/4nOMjBVaSY1DZnMReYXqKiruNQeWfCwE=;
 b=FeWJ5NNVuzX9WY1iLEqhyng5MFFs46/s33qPJ+Szh+x1DPKFUv+dDH5oOZZTNix+AVI08ocWYPTj2IkJuJG//I7SBLBcCgopa05n5K8MueE3JMGuch+j+ObnwwUbMPwzCbuO6FoK6D186YULItX+Ide+3Iv076h1ZZ0IiIjW0fv0be/T97jA185OD6nUWtTLvLQQtYb3CtZCehTcyrBLSa+FtQCCBfLTB3eB4th+SXz+F14XnXmKh/9vAPadOXmdF5RErhnFI1vxv3YyQzgT2Zfm1y8FYutSrmwcy0Caj3ZkUiJu48Otc9v4KusBGuAmqeyc6KayzyzFf3YQFfE+sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3839.namprd15.prod.outlook.com (2603:10b6:806:83::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Fri, 10 Dec
 2021 21:22:44 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Fri, 10 Dec 2021
 21:22:44 +0000
Date:   Fri, 10 Dec 2021 13:22:39 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        <eric.dumazet@gmail.com>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <efault@gmx.de>, <netdev@vger.kernel.org>,
        <tglx@linutronix.de>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net v2] tcp: Don't acquire inet_listen_hashbucket::lock
 with disabled BH.
Message-ID: <20211210212239.xouzxoju44bz4yqf@kafai-mbp.dhcp.thefacebook.com>
References: <20211206120216.mgo6qibl5fmzdcrp@linutronix.de>
 <20211209200632.wpusjdlad5hyaal6@kafai-mbp.dhcp.thefacebook.com>
 <YbN+edCO3DGMDPmj@linutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YbN+edCO3DGMDPmj@linutronix.de>
X-ClientProxiedBy: MW4PR04CA0139.namprd04.prod.outlook.com
 (2603:10b6:303:84::24) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:acd1) by MW4PR04CA0139.namprd04.prod.outlook.com (2603:10b6:303:84::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend Transport; Fri, 10 Dec 2021 21:22:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 239428cc-1667-413c-9fb9-08d9bc233466
X-MS-TrafficTypeDiagnostic: SA0PR15MB3839:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB38396A01E1025FD8D684A352D5719@SA0PR15MB3839.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JxLN9WT6Nw5GMLhDEh2QyoToa7lkB6UckQ2I/HXqlPBEqCJg+WSLJ0D5+1GChPhcAPMe9cHtCwwicJoH5SodKTsdWBtBM9zGe8b4uhS/Tg1cyF4osTFM+jQSTM5ZVU+F+EV1S/AVM5SuaZ19EHgP0adj8sGS2epLn2tAhpfq6/bcvkFzCQZkya1vjIDyAdKcKDsq23/Tv5GQj57zP4ofRt/E2mSc56vXOOnqxdCAFY9pluKOZtZPWlJkwzcVF504/SYzW2P+Rh9b5+XlwgJRXhf7uXyl8AcIwhS2RSo77BNWpoDKOQAAblp8jJXozk2CwewHs87hWlbW+DNPKpoE6YSZNxVdlMOKD9SYsmYACm6rOFWD47twB2saaMEjJM5eZBWJijUkRl7jXq5dJN+L2axSkkVZD9lZjqnFMRdG3RINFFQBZyus5RCjHgAZeqgseebsuNvm5jB7oMQ7uCPuLNVCaAEw0oIO3pa9+kFIuYAhFPL6sZwrhsvoEk0b4H/WCZ46rX19QSGQnhp5DBNGVyabJ1kgw8WpL7ZD+rMMChGYPTPTK2chNNyjdBlklSdKDGaGE4fMw1d0Wgdp4H7MD/RfflPQkKLFQRCiIZuscbqRQuowRRmb+SR2AqbsyhREX89aHvXqVUtdqV3Ixqi3fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016003)(7416002)(66476007)(5660300002)(7696005)(52116002)(8676002)(86362001)(186003)(9686003)(53546011)(38100700002)(6506007)(4326008)(6666004)(6916009)(8936002)(2906002)(508600001)(316002)(1076003)(66946007)(54906003)(83380400001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzdGRXRwdGlQSnRpYnFON0lkakRLTFF2RWZJRXVINFBqbmM4TzZHNXR0b1FC?=
 =?utf-8?B?Q0Z5enYrb1RMTnN5VmVsTy8yK1psb1JsZmZHRWdSMTc1Q2dtZDYrR0d2TGNC?=
 =?utf-8?B?NVlvb2FmbXYwYjM2eENhOUt5Wm1ucmhqYUh0NWgvMVRXbE1hU0FzRGMxZWh2?=
 =?utf-8?B?M2JDS1JiWXptS2RGanF3VGE0OER2a1U1clJHaEZtT0tEV1gwS2NzdkpFbUxm?=
 =?utf-8?B?b0gyM2x6NkFMbGc3R1dXdGtORWYwZG5PazN4VjNYaDdlc3V3d2U1cHpCN2N5?=
 =?utf-8?B?V014UDYzNi9nckpFSXJuMHhKRlQ3dmxoeDJPTEt3M2s1SHJRNU1DRXpCMFZh?=
 =?utf-8?B?OVIzZ0JYczUwcERscTFkVFBuVlVsNTNVQ09QbTVHMlkvdzBVSXJyL1FRT3JK?=
 =?utf-8?B?UXN4N0hZQXFpQ0RWM2xWNU1jVEhpYVJma2JkWTVnTG9hSTRpc2krQVkva3Fx?=
 =?utf-8?B?K3IrcjB4a3J3ZGd2aWNBbUtRTWJaK252cEg4Q2FiQzYwdTBPbEJhYXE2SXlD?=
 =?utf-8?B?Ni8wYzNDdHFJV0JacDlLZE9WamFSUkphYUgyK1dFckpTQ2cvaEtKdzNvVmV1?=
 =?utf-8?B?N2FMaVpGemdCc21EaDdVdzc4TGl0Z2Z3a0Ivem1OTXJ3ZFFrUmhRMXdiby9J?=
 =?utf-8?B?ekZmRFNiNjRhNnl3Z2JydWxSMHVSWGVSNk1iTHN6dmZBWVdXQmdWanJyTDdV?=
 =?utf-8?B?eU1xSHhnM0lKV0FpMmI0a05UZHhxZTI0K0JVMFJSMWY4ZnNzZGM4TkpCQW1Q?=
 =?utf-8?B?bmtsYTJuUnhPTVZDamJhWWdPSlQ2ZFFxdlBjbnFmYWFjVS82MzlHYy9YTEo5?=
 =?utf-8?B?bEkzQmFnakpwWC83bmQxb2lZVmh6VGRUb3lRNVU2K1VvMGhZY0xIZnV0bWhN?=
 =?utf-8?B?V2dXS2lrMFlhM2ZYUTVVU1BKUWdOaU1HTjgzVkQycHlsVlZJQjV2NlF4Tk9F?=
 =?utf-8?B?TXFrK2R3cmlxZUc2WUo0N1ZBUjM2OXl4QVZTMjcyZDAxOW1mVWp4MVVpL3c0?=
 =?utf-8?B?VzJCallnMXoxOVBWMGlDMnVLMnpReTVZd0RCQWJQNFBTWE84RTNXVm4xTkVy?=
 =?utf-8?B?VjUramhRbWllck9xN1NBOW1PU1lSRmJiL0Q0RU8wVi9lMGdiajROMmlwVVlq?=
 =?utf-8?B?NFpXOEhnQkU1K3lJajVMTkJmcWhvR1BKT1FrV0Rja3J5WUFHQ1NacmRqSTRK?=
 =?utf-8?B?Y2d4eXlzQU93cXJZL09zSGF1YUNsdGQ3Wk85UC8yQnJ2SDRwT2lCS3NCMnA1?=
 =?utf-8?B?NUVmSVdyN3c0ekFINjFVLzhnMnJPaUxDU0QxcndNbFh6L3hFemlJQlVRN1Bk?=
 =?utf-8?B?MGRZcmQ3NzNDWGZROWUxZVduU0JxMnJwL0JzWjl5UUx1bURZam56NVVhdEUy?=
 =?utf-8?B?WlNPT2p2UUgvMkpVZlcwaGx4Ykc4K1R2a29ENEcxdkNNQ3JvMk5jZG1vVGpK?=
 =?utf-8?B?NTZrREF0QzNxK3dFOFI3QkxWZW83ZzNxSVhkUzZoeGI4Q2JmOHZ3bVZoaUhJ?=
 =?utf-8?B?TWUrSHNOaExsMmUveURRR0g2dzVMZGQ0M2tHelA5WVR3SDBhSUNCcUg0czhS?=
 =?utf-8?B?RjFSbDJRbDM0WDE0amREbFJyaHFMQVdxbHFGNmpKRjlIbVg3QnNTVEhzZWp1?=
 =?utf-8?B?QWdHaVRVMW90Q1VvbUVaUWN2RXpKdjF5OGRCK2V6OTZKMkg0SytIeWRyeHNx?=
 =?utf-8?B?TlVHMWhkTzY1S3NjRCtrZXdUemo2SVFxeDllOUxlbXBoWW43SzBReUd5aitP?=
 =?utf-8?B?U0VwckdtOHJaVjV6bEVpcGxBMGxzeU80ZkdVMG9kdUpkQ1FUMXJGaXg4NkpB?=
 =?utf-8?B?UmFSbVUzM2NxeVY2TEFTbTgySDI5bW5ENDVYNng4QXFlN0t2VWhCenhPU3dO?=
 =?utf-8?B?RitFREJnZTBrQjlBYkF6bCtGazhzdzloaUtyTm52Ri9wbXhmSmI3ZUF2M3I4?=
 =?utf-8?B?YjBQV1lKSHpJQlFCNC85UEhiWVNsM3ZmMzZ5d2R5MDk1T0ZHbXhuRkNVV2Rx?=
 =?utf-8?B?QUhNaUhKMncwRmxtQUt1SzBYZU9Tc0tDT2EvalVYQ1RvS21sYTVib21Ca0gv?=
 =?utf-8?B?QzJ0enFwZHAvN04vZy9FR2NTRmpRRmYvQXdqU25jTjhxaXlCUVJRaUxKSTdS?=
 =?utf-8?Q?0z220pLygie7sXQJjgRFjhLXa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 239428cc-1667-413c-9fb9-08d9bc233466
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 21:22:44.3880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6C24ijfefv2sLW4ilLO3nhFDhKaJ+mIwhN7If3g+LKTflQ8Le6bKK92y2rctirTE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3839
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: R_L1p0LpFPUr-swlfhS95Gj2EZy18JrY
X-Proofpoint-ORIG-GUID: R_L1p0LpFPUr-swlfhS95Gj2EZy18JrY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_08,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0
 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=477 bulkscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112100116
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 05:21:13PM +0100, Sebastian Andrzej Siewior wrote:
> On 2021-12-09 12:06:32 [-0800], Martin KaFai Lau wrote:
> > > local_bh_disable() + spin_lock(&ilb->lock):
> > >   inet_listen()
> > >     inet_csk_listen_start()
> > >       sk->sk_prot->hash() := inet_hash()
> > > 	local_bh_disable()
> > > 	__inet_hash()
> > > 	  spin_lock(&ilb->lock);
> > > 	    acquire(&ilb->lock);
> > > 
> > > Reverse order: spin_lock(&ilb->lock) + local_bh_disable():
> > >   tcp_seq_next()
> > >     listening_get_next()
> > >       spin_lock(&ilb->lock);
> > The net tree has already been using ilb2 instead of ilb.
> > It does not change the problem though but updating
> > the commit log will be useful to avoid future confusion.
> 
> You think so? But having ilb2 and ilb might suggest that these two are
> different locks while they are the same. I could repost it early next
> week if you this actually confuses more…
Yes, they are different locks.  ilb2->lock is also taken
in the inet_listen() path.  ilb->lock is not even taken
in the listening_get_next() side.
