Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6244A182C85
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 10:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgCLJd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 05:33:59 -0400
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:33792
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbgCLJd7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 05:33:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPgdkMNBHsLPAqteu089fD/zIl3kiIV0af8+3K70RxAPwG5M9B4SDZKoz67KhfUYr4x/dncxx7rV6/Lofhqsow8KQ0cdsNueFb0TKk0sysyV/mzqVMwYLzymeI/Fs8tftvUKtkLPCXMBMkT9TNcNXUOv7wvx9AxRv+Jy2TQ++BNF22Sevzlxqe1oo51TPDZworQT/eGj62+KDCfBHbWmrXGiVJ6+OpODNdBNdtyVVyIiDUolSuY5XTjh5ihvwJUUtIHIb2XLj5OtfcarYZmz8rF+l11lnr1LAThJSYwpfOsnF86ly0ZC597Ft4ZBWkoY2nqnrm9NPnpHSvIZO1UCRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zg5bSOlxOvFySmJxRmWusg/oGkcBB8iAc9YMFvlKyg=;
 b=iEqn9hPsQ2l1Sjg5XyAWs7M8X5RXoeTanKxJ8UoYnJi+ND/ZlCJihcgZPtSPdRhnrs4K72F0YbZHqU89JRNzz2v/23Oj9Y0f10fmkZcjex3qE4dEk4QNSfQCoPbl78/MMfDPffYgaWcMTolhPfZHmzamRXu4FwNTcqBxbYqp7Ono2DVK83rE5E7zh1dGO9lwrcuiY9xvmopPUZ3Wmq3ENYT+ABsx8EtJhiwPduUugGqqhrzeu735np+tGguGtlq+FtVUuVCRjvlfYHLtFK+OLrCyIRYsZ9Nl/erREya+Scv73xfb3caLT19sj9/VOu61l5Yt43zXkOinc+81vQukmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zg5bSOlxOvFySmJxRmWusg/oGkcBB8iAc9YMFvlKyg=;
 b=BE+ajHmB4so72mPEKsUuXxdcGxcVHohaX1fytvskDofpF+iwq8xb0SV2HONWixBUcZeIphpl2lYGElpUiGRrnU/4Pfk+kiaS3AhbqWZSj/pWXuz5B1cLM9xJW+2zOSbh5KL2yvCmJDTN4wChCFemMu47sEsoQqEyJWtUbNvTXmE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB5016.eurprd05.prod.outlook.com (20.177.36.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 09:33:55 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::4d29:be06:e98f:c2b2%7]) with mapi id 15.20.2814.007; Thu, 12 Mar 2020
 09:33:55 +0000
Subject: Re: [PATCH net-next ct-offload v3 05/15] net/sched: act_ct: Support
 restoring conntrack info on skbs
To:     David Miller <davem@davemloft.net>
Cc:     saeedm@mellanox.com, ozsh@mellanox.com,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, roid@mellanox.com
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
 <1583937238-21511-6-git-send-email-paulb@mellanox.com>
 <20200311.234000.1671360774348542429.davem@davemloft.net>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <2ee89898-d9c2-7673-270a-aef6cbba92ca@mellanox.com>
Date:   Thu, 12 Mar 2020 11:33:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <20200311.234000.1671360774348542429.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR01CA0097.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::38) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR01CA0097.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.20 via Frontend Transport; Thu, 12 Mar 2020 09:33:54 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 59ec4283-e65f-4d9d-3e2e-08d7c6687bf7
X-MS-TrafficTypeDiagnostic: AM6PR05MB5016:|AM6PR05MB5016:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB50165B3A390481372398FFBCCFFD0@AM6PR05MB5016.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(199004)(26005)(53546011)(107886003)(2616005)(81166006)(6486002)(31686004)(4326008)(6916009)(16526019)(52116002)(4744005)(316002)(186003)(16576012)(36756003)(956004)(86362001)(8676002)(66556008)(31696002)(66946007)(81156014)(8936002)(478600001)(2906002)(66476007)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5016;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3/wTcVOYUwTIfHy17EmMssM4e3ussJtB5vGAzeiqbTPv+52bCHmkCtUYaU60K6hGgFv1+W+LB73f8XQPMpuukE28tmwV29LIHwc5DEYr7B6Fu5bO6WnCBgO2wHWAI24yucoojvtWX0kW1zh8GmOSAWmWI3KhhRJYzwV+5oGIT36YTBdu45RUAJy1hvpG2b4VRcbQiOhOYizs2k8p/TFmtOiQ7FoBOLqmYALKSFNrAscJMs8665Mqm5slt5rp4czo13qhrG6sn76OYoayqujrnKbIcZbaxVj3dZYbdJ/phdl2Wf80xOr6MLIF96Ru+KpF/a+12luz681UVReuz4ttlRw6ifyfZUBzMHge3Jmlp2Eo5UPHptF8PEVVePtgn0YjgyXSGR6t0H2djHrggI7c75dI97e4sUiXKVWADRWEjzNzCLSS66TDlmTRJ0zqnIf
X-MS-Exchange-AntiSpam-MessageData: Q4CbCdEBuEalgGvf1DEqLcURbsI2of7RkbyZEG6cM7IKjua99Wf4VGi2gDygo4YBQw5APGKq2VCKPMzVKQP0/QYo6tpVC3GDhZQAOODD774594q5eHAT0nwwqdzqAnM92rw7UOQiZUg4A6nlZ73H2A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ec4283-e65f-4d9d-3e2e-08d7c6687bf7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 09:33:55.6610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3dzWB8fVgc/o1EenhT6g7zyj6y9yzdznSB2XLTezApteGTEjRBpyR0S+jYj2wHobgfWBv7lhjbB6WkRFdfU9kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5016
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/12/2020 8:40 AM, David Miller wrote:
> From: Paul Blakey <paulb@mellanox.com>
> Date: Wed, 11 Mar 2020 16:33:48 +0200
>
>> +void tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie)
>> +{
>> +	enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
>> +	struct nf_conn *ct = (struct nf_conn *)(cookie & NFCT_PTRMASK);
> Reverse christmas tree here please, thank you.
sure thanks.

