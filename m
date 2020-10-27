Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FE229BF21
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814992AbgJ0RBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 13:01:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3989 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1814978AbgJ0RBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 13:01:02 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 09RGwxFc028996;
        Tue, 27 Oct 2020 10:00:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=pe2jzqEzr8r2D/1h/D0pOCO0M3ybkSpcpSUC6M0jssI=;
 b=Tat9mVBKVyo6cGxWrno/Rns93Rd5AnDkHb3MLNnutchGCKPkPO2Oa7p+8ntdXtnwdG7l
 6G5Ty4hKjMwistbZn8BtR9vDD8y/uTEI94Eq1d3eLsJrj6ANb1ZYP9K7wj60z/B2NCvz
 o7HiEy6xx2eYdsOWTJK2JUM2NsPz5DaNB5o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34cfxn7y4b-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Oct 2020 10:00:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 27 Oct 2020 10:00:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XM8vcR/hskPouIuR7qJTtp9eHXf9u+8gvHvW8OwocZDtUUg7U8yoHVrWWc+5CXZ8Pyc+xQ8WE2LCNrmqTf4an9IxCFDQk8Q92wihOAuXcG6mFMcfMEXF3M/pBHUkAbXpZkpIc5KdUksvKdrNoMQKHOXpXcraKrLPVOJ4HX+7zNOyk28Y9rQZ6VSmWJ3tImDKXACuNxfMECLeloxNPoBaOUD+E5DSnQ+4TI2xiJaXVdyDvGr8B9csDXne82YmkMVr6zDbA4bOZGmFHbeaU1Tdn+6fWvr0nyE7/zRXfdoGcAcbOhAQbklPBgXg2wk1iPJHhnx44MRvRwQKOY6ZgSfgHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHwsRREaRjivNbbwMtu55sqfPOAOv1j85F4BYQ8wIsI=;
 b=L8bb+o455KnMrOHMgtHULlkL8d2MqHhOSzcJKCckseKZD7/VZrySH+yD6CXZrVc789MNwFDQCjcq/uew2mciPkm1WynNa7DLEOuNNReFdV0rfJ+6onjU+ugA5f0vcNMbPqNF/tWRKzjDuimOLPlNpdoDIaaLAF0M3Mac9c1lfjkdUL5qSgCS4j9rVvzrlGfncsO5YDbrmwf9Fw4JKdDil+i6pvp0vm1lyRhhc5hje+AovfJz0Y7jX0A1YFe8f0DlR8r/NlUz4oh6M52uqgCZ9jad8p4iq/21fp6q9FsqyBn8NoJn4pHuw1n+kvDNTcCNLTY0HZIMAh5Zi4aH9Ds9/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHwsRREaRjivNbbwMtu55sqfPOAOv1j85F4BYQ8wIsI=;
 b=GXIBmMzwJyd46XnUeESO3PVr3kCo398bH2cItDCycTiy7FfhsS/0c1GJHHdIpJXfFqDMfklxGPlGZ8vCT6En4CWkIpgYkHIBzENBwPnvu5NWFHIHv4Ex1TwqYBkK4ono57oRp0ITXfTERam+J8UVdaypOomcmi6cjRFeq7p4SQw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2936.namprd15.prod.outlook.com (2603:10b6:a03:f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Tue, 27 Oct
 2020 17:00:40 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::d834:4987:4916:70f2]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::d834:4987:4916:70f2%5]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 17:00:40 +0000
Date:   Tue, 27 Oct 2020 10:00:35 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        <daniel@iogearbox.net>, <ast@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf] samples/bpf: Set rlimit for memlock to infinity in
 all samples
Message-ID: <20201027170035.GA725724@carbon.dhcp.thefacebook.com>
References: <20201026233623.91728-1-toke@redhat.com>
 <20201027081440.756cd175@carbon>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201027081440.756cd175@carbon>
X-Originating-IP: [2620:10d:c090:400::4:a17b]
X-ClientProxiedBy: MW3PR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:303:2a::27) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::4:a17b) by MW3PR06CA0022.namprd06.prod.outlook.com (2603:10b6:303:2a::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24 via Frontend Transport; Tue, 27 Oct 2020 17:00:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13ac3269-16fa-47b5-51f5-08d87a99d589
X-MS-TrafficTypeDiagnostic: BYAPR15MB2936:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29368AB16E8D500E16D5A9B9BE160@BYAPR15MB2936.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMAMJHAwxhn/0zNa1ulQT8Wf1bRqomVtoRhV5OXBBusw9COXOwXzJ7oGtoh2UJMygdu7Thq9HFxuHul2d3/QjGmf45rSoVrTII+TOT3qDsiwHCgKfTEkLuwbqki2hi+rqP1xr3V6I4nzEGpH6UviAnq2T6mcLTiB3PSv2TqfOluMulB5gqrLIKZuXUqEdy45VViUKQdwaxhnsZeyPSVmBbl/kRbvj59bLbF+xGEWguOt+nJtgF5cCToeXT+e7TZRmxOORE6NfLpJCPYRMSP1gtaZxU2bxeRUCZhCCgDAHEZAZHhpq4qE+sCnT9dLwWP2zopMlBQK8WkV5vefrBOrvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(136003)(346002)(396003)(6666004)(6506007)(86362001)(9686003)(83380400001)(316002)(5660300002)(66574015)(52116002)(7696005)(33656002)(2906002)(1076003)(66946007)(4326008)(8676002)(478600001)(66556008)(66476007)(8936002)(55016002)(186003)(16526019)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: I6rVWBdwGWiKz2LEfYry/t4lRJLE7EoXZEYklaidC4V73qaAuinmg+VQ4J7tuVAeHXX5nHhFgiPk040sCeNWoANOF76Xrr4sXKHXzNSLRrb1BkmAgLaD7QzN7SLwPkKHc2M3M6speDjlJ82ieL/v2j5sArrSC1E+NbCTK8pupweVw1uYEcJNkx9+1U3SIYVpx10nZqyKQl3XivNaHTsFyz0QlMKjAP1hbcK+HHOBeOWhErVF3eUJeny9vN3L9HX4MVvQa9JXyoCUyNb6skLlDM2VOYTAYXSwn8mPTGXEEq8YnhEHWaJXEWgfoFuX7xn3NKcwJTXgOK0G3yEq4M9ITefEEK8+WXlIrAAigo08hudnCn+2hcRf9BjVB4Cbshjc30+B+fEu3IYBRf3Xsk+v8RcXrcsHPICXM3/Ja4zA1qJL4r2IcPWo5Oi+n8mdHImz4gEDJHak8QAON2yiFM6/m1PnSVX28aVj8RpsLZh3IKCC/5tp2H7nmBc2OapoiJ9wIh4JZhG54szAsYEnxaro/lko/HxhcxMhxlvLK1bAVv0zy81n9EIAcMH/88MjEN1RdvV90BqS8+jDBjwzgAOH94mR0gLe2Lj1VrOo19oZJD5K+6dTQYJiGEQpxsvOmwHcvkIo2iEE3RmKI4b/tdGjIARYS2InxcpJGshmCA3bQaP71Q3ZVBoJ5kEnnOvoFNaZ
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ac3269-16fa-47b5-51f5-08d87a99d589
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2020 17:00:40.6555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x//0Qn6MceMLWF3Z7hPDxmBeRM2dALjKgw4VpWcBVH0nAHg337oJuEv3EbQwEsrE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2936
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-27_10:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=1 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0
 clxscore=1011 phishscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 08:14:40AM +0100, Jesper Dangaard Brouer wrote:
> On Tue, 27 Oct 2020 00:36:23 +0100
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> 
> > The memlock rlimit is a notorious source of failure for BPF programs. Most
> > of the samples just set it to infinity, but a few used a lower limit. The
> > problem with unconditionally setting a lower limit is that this will also
> > override the limit if the system-wide setting is *higher* than the limit
> > being set, which can lead to failures on systems that lock a lot of memory,
> > but set 'ulimit -l' to unlimited before running a sample.
> > 
> > One fix for this is to only conditionally set the limit if the current
> > limit is lower, but it is simpler to just unify all the samples and have
> > them all set the limit to infinity.
> > 
> > Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> This change basically disable the memlock rlimit system. And this
> disable method is becoming standard in more and more BPF programs.
> IMHO using the system-wide memlock rlimit doesn't make sense for BPF.

Hi Jesper,

+1

> 
> I'm still ACKing the patch, as this seems the only way forward, to
> ignore and in-practice not use the memlock rlimit.
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> 
> I saw some patches on the list (from Facebook) with a new system for
> policy limiting memory usage per BPF program or was it mem-cgroup, but
> I don't think that was ever merged... I would really like to see
> something replace (and remove) this memlock rlimit dependency. Anyone
> knows what happened to that effort?

I'm working on it.

It required some heavy changes on the mm side: accounting of the percpu memory,
which required a framework for accounting of arbitrary non page-sized objects,
support of accounting from an interrupt context and some manipulations with
page flags in order to allow accounted vmallocs to be mapped to userspace.

It's mostly done with the last part expected to reach linux-next in few days.
Then I'll rebase and repost the bpf part.

Thanks!
