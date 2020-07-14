Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238EE21E63C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 05:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgGNDSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 23:18:01 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:6032
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726432AbgGNDSA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 23:18:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKpFBxMMUHv2DC1GMAlnntRBkIzAPzLjBdVCSrWbHdYtZhuwVMOJiwe0KuPjrFtyvpNPxULHRG1DphpmrWbqeCEC+pXrr17K9CnfBGfUNgNHXE4HZpzrNH/CAww2gvOXeW8RIxJkdfa5HluMfzsFvdENYc3QN1IWuP1fW8PYWKWfOLMRcEbEw50u1C/F5nbReqmxCcW9y38tagp0VEneHLV/6qxsL4ge5BGvYsnnt33XMichPA66ujfSHn6esot6UcWj3RxGw8por+y74nk0uDRmIKM9I19L6VXyyKaSh7zNf5dExTOw/8+jGO4kRH0hoX5uhXd2uDayTn1wwUG/5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dQEo21vCT76jexfP5GmaDsYIli4U5JaSQRBh3KLzhE=;
 b=XOjCoZxDfgKZ0VwciW2WmRqNPcF0w8kvVZQbR2By6ZlJlgssXxpnyc5oG+ABASygq85kRDp/4wvjM7WBuaAC9Bc0Q2P1jZCZ1MzynWzCwTprU6FEu4nU1gbAfpxjrLbhAi1K6ZFkkakqS3xyVIDvzMd86F9Jt5DalANdSFMMPRfh4XHp0FU1DIE1GZpxRMNgICL2UqQj0k4C0UrPlvlNFWH3n/qTsZWq3UgGuwd3WKUr8qCAW8y8agKRRi3EI6lEEAC3n9vdp/fORSspaSdXTyYbZhcCdDiq12C8yerWhnZ8ZWUBdO3cr/xhw+olS7uMK5VHKxmRJyHOtVBG1ZpSCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dQEo21vCT76jexfP5GmaDsYIli4U5JaSQRBh3KLzhE=;
 b=TPlPsGDh3mhG3B/XsR1ZeJxUQxcDqdqlnTPSO8WDRYQvczQQWGr9HVGVThwyHIkrQHoyw7FHV9EBoxul50st/i4kmGP21AtB7rT1MiIhSov7265PtPGHR2XZDhtcs40mZMU41P4rOj+ZrtFV9jlVHmZBk5OmzCed6nnsQhxs05o=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com (2603:10a6:4:80::18)
 by DB7PR05MB5051.eurprd05.prod.outlook.com (2603:10a6:10:23::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Tue, 14 Jul
 2020 03:17:55 +0000
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08]) by DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 03:17:54 +0000
Subject: Re: [PATCH net-next v3 2/4] net/sched: Introduce action hash
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Pirko <jiri@mellanox.com>
References: <20200711212848.20914-1-lariel@mellanox.com>
 <20200711212848.20914-3-lariel@mellanox.com>
 <CAM_iQpXy-_qVUangkd-V8V_shLRMjRNUpJkrWTZ=xv3sYzzaKQ@mail.gmail.com>
From:   Ariel Levkovich <lariel@mellanox.com>
Message-ID: <b4099188-cd5d-cbca-001b-3b0e4b2bb98a@mellanox.com>
Date:   Mon, 13 Jul 2020 23:17:50 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <CAM_iQpXy-_qVUangkd-V8V_shLRMjRNUpJkrWTZ=xv3sYzzaKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0024.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::37) To DB6PR0501MB2648.eurprd05.prod.outlook.com
 (2603:10a6:4:80::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Ariels-iMac.local (2604:2000:1342:c20:f5a1:f82f:881f:87db) by AM0PR02CA0024.eurprd02.prod.outlook.com (2603:10a6:208:3e::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Tue, 14 Jul 2020 03:17:53 +0000
X-Originating-IP: [2604:2000:1342:c20:f5a1:f82f:881f:87db]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 10e9281b-308b-41cd-e580-08d827a47fed
X-MS-TrafficTypeDiagnostic: DB7PR05MB5051:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB5051D3B3B7FFF228723942B8BA610@DB7PR05MB5051.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pRHVJ6jKE2j2V89wLVbme90Fv1u2K7qMaxbDHy1Llw/8eiKlmkZWDVZGEXcDOF0v2aCrVXr6zV4DdlNTE0NuGoYGVVDJgDIWvg4K5JGC7Vq2n6eUR/ho0O7rvR6f0ICCrsKGNKA/z/4xXnVFAjWfjqhByhJadCHO19K/TYHIObp1P5/Uh2TOHDdTc6Nmpwop6qWGSttvfb8WMH/VHELW9dzvO7GxzY1pbSpnDWB70JHIs1nHnDYx9+bd6atAI8Pyd8bNpuAaIa8wNjPScFDGF4Z3DbSrnwiF2avYDAQnCDHBrVLrimXluvU74GmtHW/5WNHUAoZn/jqcIKSARJWyJTDPlaASK9ywVz4wQGdvC/U2gPzBfdFMazqzEj2EE7Lw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0501MB2648.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(52116002)(31696002)(6916009)(4326008)(2906002)(5660300002)(107886003)(8676002)(16526019)(86362001)(6486002)(186003)(53546011)(36756003)(66476007)(6506007)(66946007)(66556008)(8936002)(6512007)(54906003)(31686004)(2616005)(316002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wrZuqhVDqO0bby2YJGS9oSmIUlpwU+Wh9Yard5ADiGBEDvotWlXx/3UG43uQbetvqhHhQ2+cX21OsET+UDyrZ6XFJkfBnZFzk6FghOiVQBy3mY9kqGQ/EpC1azmd+9Q+a9ceHZvJDftLzhUexQGI5FZpBAKd1cUmdU+1pYBxrO/aGdGmBGaRCvCwe7gScIPKtmFlm4oVG82xGJxE8HT8Ie5ujuAdn9RSdIK/PJmxXS/L3amzAJ25kXBdtain7G4V7CHVbbThTplMwcefXRsAdjbHg2RoU4n07MeTAH2//hRNyslz1G620MgH2gvHDRVSS6YVOQvszPBVPljIQnqz9E/TMf76s6hwshmo5MB4ZH6HzwrzsqmGG5zE+YlhBF//KjAui4Du8rA7/XSyVcetuNtKrEk37zedIgXjMMDn33698ODBnPKRPrOd7qAsKXxziMnermP3+QqFO3otVRaHGjehARn2Bvzdj5VWWsx/0P4Jhb9g/PtW+RC7Qk2STriYc63MHleoS4F7mEX2h55c7+yxU4mZPotuxXu81EPC+4WySWGEmQ2RZybCz7m8Sifg
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e9281b-308b-41cd-e580-08d827a47fed
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0501MB2648.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 03:17:54.9201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hz0hA1rpAurWpXOdCo7Ul6nfFzgb1IR5NbFIJEf87X/PlkNql1K0yDn/Dxs0pNmMkm/HlH3Mvw13e5ImX3Cn0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5051
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/20 6:04 PM, Cong Wang wrote:
> On Sat, Jul 11, 2020 at 2:28 PM Ariel Levkovich <lariel@mellanox.com> wrote:
>> Allow user to set a packet's hash value using a bpf program.
>>
>> The user provided BPF program is required to compute and return
>> a hash value for the packet which is then stored in skb->hash.
> Can be done by act_bpf, right?

Right. We already agreed on that.

Nevertheless, as I mentioned, act_bpf is not offloadable.

Device driver has no clue what the program does.

>
>> Using this action to set the skb->hash is an alternative to setting
>> it with act_skbedit and can be useful for future HW offload support
>> when the HW hash function is different then the kernel's hash
>> function.
>> By using a bpg program that emulates the HW hash function user
>> can ensure hash consistency between the SW and the HW.
> It sounds weird that the sole reason to add a new action is
> because of HW offloading. What prevents us extending the
> existing actions to support HW offloading?
>
> Thanks.
Something like adding a parameter to act_bpf that provides information 
on the program

and what it does?


Ariel


