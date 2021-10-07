Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22326425421
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241587AbhJGNdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:33:44 -0400
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:46918
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241508AbhJGNdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 09:33:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiANvbzYCLPkDOJ1xOH5BJwerYXPlwfkF1SL7dKs7bsXbXVIsD5igoiv7w03G1bPDqTiQm2Neukzp7UjSwxsTxDr5cRD9NH3eeGkslrt6+YGFPqfxqLpuYT0TMGfHI2dot7LwStlfQAXKI61O01hEAh6BFQE14UEemU8eOwpuJFi3bWxays0JdKPHaV6Yoaxqtg/LB4wMjzXCZfIMFOobcfOhzWN7MC8tCkGGoJoiJrARADsaXBksW6cJz6lB8EK13czGAEMF22qkKVb93AMaEV8KYxy2auWPcGWygQDvzPmnqd3ziMbdWoL6DLbCZSbN49hpPReEGmqFHjk9xQwNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNufgK5JFZxxiizzzEd/df1roOIMFNiaLowntoiSNf0=;
 b=gd4b7PD2+ITot0/azkehINdHcjGRU7UBmUgLyoDJlMshlTnRpyKrO2aUELDTk4v+E3j5Quh9Fp30vrzHoTXKwVRdo23AX4wkSU3a26ocIJqWk94VSy2ne7sFHp4MYHMXpqP5tRqDy4pwidmtqSl19BVDkmH/qGY+Nl5SGTFZL+Ysvv90FKRTD7vCbdrrnGZvnCjUXEUca54fp55XSnM0P6BWsnorlnA8cVkMV29MK0YXO9b2zyjQGR/K8kTZ8tzHBIioHxLszi4zt6uTdaGFkzsn+1YmvqiW+Wfu9z4lYLUpC0DoHR1CzEdL50pkzrP5JsGCxzvnJTOTrSg6o9t7nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNufgK5JFZxxiizzzEd/df1roOIMFNiaLowntoiSNf0=;
 b=PsYZb3P1DlmH9GUtlabPkAVbehaLnzxK/bYUqAIfzIsJL4kiQKpqWfnzSBCg7h5fRE4l32AaenBKkepQUHQGGF7571MegUFBWISdGOgUyrERRFDT9jqo55SGgmQaJpHtww98Y4nKek4a77D7NG1PlYSAdnNMsWZtcvFDcevelo8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10) by VI1PR04MB5071.eurprd04.prod.outlook.com
 (2603:10a6:803:56::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Thu, 7 Oct
 2021 13:31:46 +0000
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b]) by VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b%4]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 13:31:46 +0000
Message-ID: <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Date:   Thu, 07 Oct 2021 15:31:43 +0200
In-Reply-To: <20210930143527.GA14158@hoboy.vegasvil.org>
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
         <20210927145916.GA9549@hoboy.vegasvil.org>
         <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
         <20210927202304.GC11172@hoboy.vegasvil.org>
         <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
         <20210928133100.GB28632@hoboy.vegasvil.org>
         <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
         <20210930143527.GA14158@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P191CA0012.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::17) To VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SOPLPUATS06 (84.102.252.120) by AM8P191CA0012.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 7 Oct 2021 13:31:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e4b3574-85ad-4dba-6178-08d98996cee4
X-MS-TrafficTypeDiagnostic: VI1PR04MB5071:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB50712BCCFED7E3900849438ECDB19@VI1PR04MB5071.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wa0EVmB7ejrShqjTmAaS9CsdHOSg100xKnN3ldrQd/VGyKhKnr1WnJvDhJ2PMHZETBBRiBPD3gfZrr5Rk7ZDSIW9YICr/b5NyMI/utk+YEr4hazT4M5VfEcs1NNvB2Q9ixq+oreGhRZTYFjhRjYGcEWmc5o9KyumGSIoO/bs9P2915tp4/yhn8u/QIeyIKxro4rSx8ypXF1GBI3MVYhRlJC6U2XaX2Q1m01kFzxC/YLB3gpCF1RZj90BGbSAddu6a4LxwF4L9CVw744ZbNBiilHz4nl1uAddwZmSV2ivIaZMUtsg4+skEsnpUeoJLogXozlmxK5aq27x6BygNgPMyZcSGN5pIRbe57ugEkBuBajDqPXTJFXInVIs7VbjjhzSiTgkWrmhOWXBXntBkwKncG7GLxEwM3/aZw5kgJnescEMe4kPJpTbK6HFzqjrABvL4Tb38TME/tMZQJS2Lu18AqCFp/LJPCywrJx72NJFPggsDWxGUnEr5sAzKWPOltlM7C6ytZIbM54E8l89+IRBCH3ASTkn16ZTOWu/v+KVx9e4Gv7TcdrLVVLgrV+XK+i+RZ9SmFtwOfb1uzmJLteNTVCuuSoXBUS0poVMyvZZFqPci98tfeIUbK8i3enPmxpobCn3d3M2V8QKikUaRlK4QewCBy3jcYLBJKw50I25UuKJZOr7xkunByTUv2QMvrPCKZ40hopnQL+/5k3r8gnnKRpgXvNFaIxDkBRIRQVCpNNiLvtk8/tIyqzs10Ax3NvmklxAEurrE1RFxGtFK/b8kB1XlnDNf0jWs+VwBVtpRyM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(2616005)(66556008)(26005)(83380400001)(66476007)(8676002)(6496006)(186003)(2906002)(956004)(52116002)(6486002)(4326008)(508600001)(5660300002)(38100700002)(44832011)(316002)(6916009)(86362001)(38350700002)(966005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWluQStrczVBZ05FalhITTRsd0NsMml4YzBhcldQWlNZYnlRRTkrZm16Z1Vy?=
 =?utf-8?B?MXVMUXZSanRuOVF6Y2pZK3BGK1c2Vjk4Y1dLbUZ4amduTlhYTXg1aWx4Q0wr?=
 =?utf-8?B?cXZ6eWVIY3BZMEdhS3BlV1p2SFRqa2xPbTArNmZvbSsxUE9hclBzdlllSzFp?=
 =?utf-8?B?TGh3L2lQcWRXcHZramh3dHpMcEt0aVhmTnA2RkF1bHZnNVhBQ1hMZVNTNEZo?=
 =?utf-8?B?Z1p1TWhEMkJuQzFXb3FnZ29MczI4azdZV1FVQ1NYNXJwam45L2pGNkJZN3pX?=
 =?utf-8?B?TUFBL2JrZ3lkRFNIeU9qMWJ6SjNycFo1Y0RPYVgzQjBGaFI0K2JaZVVCdXpV?=
 =?utf-8?B?VjU4R3c0bkNXK3hQcGROVlZpTm40YSsxSGQzMzVZNU5uOStiVWdyeXFmb2FE?=
 =?utf-8?B?MXA2REhvcHcwWi80U2dBYjFCMTFFRTM3dUZWRElNcWczcDFuV2hLZFI5cGxs?=
 =?utf-8?B?dmFLWEh5WStSSzJFVXJMZWxJOUhMa0pxcVFybU1xYXNBUGVMY2ludVhuaE5x?=
 =?utf-8?B?Vm0vT1JHL3JrRGVXWUVxcUlZMWEzRHFLN2NXcHYrNG9HZExjMG44alNCWklR?=
 =?utf-8?B?bE9xU3oyRWlBdmhXanhtWHlaQTZaWTBGR0kwK1JPYWFPR3JYREpiS1BZNGp6?=
 =?utf-8?B?ZnYyNTQyNzJmbEEycDZIQlFqL1RIeDNWSzZER2NQbitOSXdRa0J3T3UyTVFK?=
 =?utf-8?B?Q2NxQlRHazRQR2tYa2FUcE9HTkd0ZUo5bVFrZG92SHFuQzU1U2xrd3pFWEdJ?=
 =?utf-8?B?dnl5Rk9GUFpBbTA5b3NxS0dEc2NhR0NKSU9qNXlvQlB2cFZyOTlmUGNZSnJC?=
 =?utf-8?B?R1J2VUJMRmpsVFlHSmo0Wlg2T3Z4aXpiTEN6emUydzBsOEhnSW5sZHl5MVZ5?=
 =?utf-8?B?Y3JpRXg4S2hvVWU5TEZkSHg2QXdSZTdaVWpiQVhLcWNTRkhtQ2N5eERnTEc3?=
 =?utf-8?B?TDB1TndmZUtJVkFyb1kyc0lkZXF2bXFrSXpOWEgvZUtUWUFxWFJPUzdPWEUv?=
 =?utf-8?B?Wnl2ckgwM3pLbi9FNGhBTzlRQXd4NHc0RHRtZ1Zua1ZuTmJMNjFUd3pxNTdl?=
 =?utf-8?B?d3pUeDNvdnlCcU03M3ltSldweW13K0lVaG9xV1RwMXU4UXFVS2JHZWR6Vjll?=
 =?utf-8?B?R1dYdTFLSXgvSGNZS3BOVVRpL2tETUdvakZzNlNBODJiays2QnBLRjZkQ3dK?=
 =?utf-8?B?UmdXeTMway9vc2pHNmNTUlJ0WkFEOWd5SzJobkhGQmVndEhQcnFOenIxdFhm?=
 =?utf-8?B?NnVaa2NKTndnVWR3dlFKbXNkQ2xGL1ZZWDFYWU80MnpIdDhPWUxac2RBakZn?=
 =?utf-8?B?THpMQTA3YnpuQ2tFTXhCbGxPd1RpVTI3THhJdEZwMTlXak4zSFV2Z1hteHZ0?=
 =?utf-8?B?UjF4TXN4a2xHK3dXWHUzc3lKVkdpNVBUbnZ2dVdoSHpXV3hPT0M5UkowRzg0?=
 =?utf-8?B?K3F3YSs0NEtKRW5GTThjV0hwVVdVMTJoN0ZZc1Z0TmpVdFFSZ1Z4V3FBWEpG?=
 =?utf-8?B?eitQQzRoU3pYSGNUUFlNczRBK2FyUjlwbUhBelEvN2JDTG1RSUl2TUtTME94?=
 =?utf-8?B?aXVGUitPMU5qeGkxWjFCQjJWRzlFOEpSR2pRSHo4UHREWW9mZjZiWVBYS09p?=
 =?utf-8?B?RS9Fd1ZQYmcrTldkSHc4ZExEWnBURnVvMUxRT1RxV2Y5Z2ZTQm0xZ2c1djBL?=
 =?utf-8?B?cDczMnFISG1tMldPQjhwZGF4QmxiRVJwT01IZ3hvOFYwK3dlTXpDbWRhZTly?=
 =?utf-8?Q?tLQkG84Xs4LKDQl1CJMjn219ZDAVcri0vG4auL6?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4b3574-85ad-4dba-6178-08d98996cee4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 13:31:46.1847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02oMcbNaYipdMD8ijCU/bRn419wG3d/cM7I1w9xjb+i1xIUWTJSvrKfuzf9ZqWPiSxxKfD9AXsTjtiEG/RQh/Za47kJbV61FA25DDpMo7+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-09-30 at 07:35 -0700, Richard Cochran wrote:
> > What we miss currently in the kernel for a better multi-domain usage
> > and would like to find a solution:
> > -allow PHC adjustment with virtual clocks. Otherwise scheduled traffic
> > cannot be used... (I've read your comments on this topic, we are
> > experimenting things on MCUs and we need to assess on measurements)
> 
> Yeah, so you cannot have it both ways, I'm afraid.  Either you adjust
> the HW clock or not.  If you don't, it becomes impractical to program
> the event registers for output signals.  (Time stamps on input signals
> are not an issue, though)

Yes, this is especially true for periodic events completely handled in
hardware like scheduled traffic.

However, not being able to support multiple domains + scheduled traffic
is a true limitation for TSN use cases.

I'm aware of your opinon on this topic:
https://lore.kernel.org/netdev/20210510231832.GA28585@hoboy.vegasvil.org/

However, a few points that _might_ change your mind:
* regular and random small adjustments don't cost that much since the
error you create for the children clocks is only the time for the PHC
to adjust. Since this time is quite small (~10 us ? ), a few ppm on
this short time is negligible.

For example:
Let's take a worst case, the PHC is adjusted every 10 ms, vclock every
1 sec with 1 ppm error.
vclock error is 1 us, now if you add the 100 PHC adjustments each of
them with an error of 1 ppm over 10 us. That gives 0.01 ns * 100 = 1
ns.
This is negligible vs the 1 us error.
Of course, in general, the vclock would be updated more frequently but
in this case even less impacted by PHC adjustments.

* large frequency adjustments are more problematic. I've checked that
some drivers allow up to 10^6 ppm... 
This could lead to non-negligible error. However, since it's already
accepted that using vclock is at the cost of loosing adjustments on the
PHC, it could be accepted that it's still adjustable but with some
restrictions. (1000 ppm max ?)

* offset adjustments do not introduce any error if performed in
software. On other systems we support, handling the offset in software
helped to improve stability as the hardware time becomes monotonic.
There is no added value in setting the offset in the PHC.

> I think the best option for user space wanting timers in multiple
> domains is to periodically do 
> 
>    gettime(monotonic); gettime(vclock); gettime(monotonic);
> 
> figure the conversion, and schedule using clock_monotonic.

Yes, having a good ratio/offset measurement should lead to decent
performance.

Thanks,
Sebastien

